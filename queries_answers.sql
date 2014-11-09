--Results.txt from GA copy of HW

--Pages 35 - 40 in seven in seven pdf

--Existing tables
-- categories
-- users
-- Posts
-- comments

-- 1. Get posts containing a specific keyword (e.g. "about").
 --ILIKE = case-insensitive
SELECT * FROM posts WHERE content ILIKE '%about%';

-- 2. Get a listing of all posts grouped by year.
--AS creates variable
SELECT EXTRACT(YEAR FROM posts.created_at) AS year, posts.title
  FROM posts
  ORDER BY year;


-- 3. Get the top 5 wordiest posts by character count.
-- AS so it can be used in the ORDER BY
SELECT posts.title, CHAR_LENGTH(posts.content) AS characters
  FROM posts
  ORDER BY characters DESC
  LIMIT 5;

-- 4. Find how many comments each user has across all of their posts.
-- That their posts have, not that they have made
-- All posts by a user
-- All comments on those posts
SELECT users.login, COUNT(*) AS total_comments
  FROM users
    INNER JOIN posts ON posts.author_id = users.id
    INNER JOIN comments ON comments.post_id = posts.id
  GROUP BY users.login;

-- 5. Get a specific user's posts sorted by date of most recent comment.
-- Three tables mentioned, means have to do two JOINs
SELECT posts.title, MAX(comments.created_at) AS most_recent_comment_date
  FROM posts
    INNER JOIN users ON users.id = posts.author_id
    INNER JOIN comments ON comments.post_id = posts.id
  WHERE users.login = 'Jill'
  GROUP BY posts.title
  ORDER BY most_recent_comment_date DESC;

SELECT * FROM (
  SELECT DISTINCT ON (posts.title) posts.title,
    comments.created_at AS most_recent_comment
  FROM posts, comments, users
  WHERE comments.post_id = posts.id
    AND posts.author_id = users.id
    AND users.login = 'Jill')
AS tmp
  ORDER BY tmp.most_recent_comment DESC;

-- 6. Find how many comments each user has made per post category.
SELECT users.login, categories.name, COUNT(categories.name) AS comments_count
  FROM users
    INNER JOIN comments on comments.author_id = users.id
    INNER JOIN posts ON comments.post_id = posts.id
    INNER JOIN categories ON posts.category_id = categories.id
  GROUP BY users.login, categories.name
  ORDER BY users.login;

-- 7. Get the 5 most-commented-on posts that were created in the last 7 days.
SELECT posts.title, COUNT(*) AS comments_count
  FROM posts
    INNER JOIN comments ON comments.post_id = posts.id
    WHERE posts.created_at < current_date - 7
    GROUP BY posts.title, posts.created_at
    ORDER BY posts.created_at LIMIT 5;

-- 8. Get the 5 posts with the longest-running comment threads
--    (longest time between first and last comments)

SELECT posts.title, (MAX(comments.created_at) - MIN(comments.created_at)) AS runtime
  FROM posts
    INNER JOIN comments ON comments.post_id = posts.id
    GROUP By posts.title
    ORDER BY runtime DESC
    LIMIT 5;

-- 9. Get all posts by a specific user that have comments,
--    but which that user hasn't commented on.
WITH comments_on_user_posts AS (
  SELECT users.id AS user_id,
      posts.id AS post_id,
      posts.title AS post_title,
      comments.author_id AS comment_author_id
    FROM users
      INNER JOIN posts ON posts.author_id = users.id
      INNER JOIN comments ON comments.post_id = posts.id
    WHERE users.login = 'George'
)
SELECT DISTINCT post_title
  FROM comments_on_user_posts
  WHERE post_id NOT IN (
    SELECT DISTINCT post_id
      FROM comments_on_user_posts
      WHERE user_id = comment_author_id
  );
--

--Blair's solution
SELECT u.login, p.title, COUNT(c.*) AS comment_count
FROM users u
INNER JOIN posts p
ON p.author_id = u.id
INNER JOIN comments c
ON c.post_id = p.id AND c.author_id != u.id
GROUP BY u.login, p.title
ORDER BY u.login, p.title;
--

--Devin's solution
SELECT DISTINCT posts.title
FROM posts, comments
WHERE comments.post_id = posts.id
AND comments.author_id != posts.author_id
AND posts.author_id = 13;
--

--Clara's solution
SELECT posts.id, posts.title, posts.content
FROM users, posts, comments
WHERE posts.id = comments.post_id
AND users.id = posts.author_id
AND users.login = 'George'
EXCEPT
SELECT posts.id, posts.title, posts.content
FROM users, posts, comments
WHERE users.id = comments.author_id
AND users.id = posts.auth
or_id
    AND posts.id = comments.post_id;
--


-- 10. Find which category of post each user has made the most comments on.
-- Note! SELECT DISTINCT ON is Postgres-specific and not part of standard SQL
WITH comments_by_category AS (
  SELECT users.login, categories.name, COUNT(categories.name) AS comments_count
    FROM users
      INNER JOIN comments ON comments.author_id = users.id
      INNER JOIN posts ON comments.post_id = posts.id
      INNER JOIN categories ON posts.category_id = categories.id
    GROUP BY users.login, categories.name
)
SELECT DISTINCT ON (login) *
  FROM comments_by_category
  ORDER BY login, comments_count DESC;
--

--Devin's solution
SELECT users.login, MAX(categories.name) AS most_commented_category
FROM users, comments, posts, categories
WHERE users.id = comments.author_id
AND comments.post_id = posts.id
AND posts.category_id = categories.id
GROUP BY users.login;
--

--Sample Interview Question
--Clara Solution:
WITH most_recent_entries AS (
SELECT DISTINCT ON (model) model, price, dateupdated
FROM tvs
ORDER BY model, dateupdated DESC
)
SELECT model, price
FROM most_recent_entries;
--
