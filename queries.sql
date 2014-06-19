-- 1. Get posts containing a specific keyword (e.g. "about").

SELECT posts.title
  FROM posts
  WHERE posts.content ILIKE '%about%';


-- 2. Get a listing of all posts grouped by year.

SELECT extract(year from posts.created_at) AS year, posts.title
  FROM posts
  ORDER BY year;


-- 3. Get the top 5 wordiest posts by character count.

SELECT posts.title, char_length(posts.content) AS characters
  FROM posts
  ORDER BY characters DESC
  LIMIT 5;


-- 4. Find how many comments each user has across all of their posts.

SELECT users.login, COUNT(*) AS total_comments
  FROM users
    INNER JOIN posts ON posts.author_id = users.id
    INNER JOIN comments ON comments.post_id = posts.id
  GROUP BY users.login;


-- 5. Get a specific user's posts sorted by date of most recent comment.

SELECT posts.title, MAX(comments.created_at) AS most_recent_comment_date
  FROM posts
    INNER JOIN users ON users.id = posts.author_id
    INNER JOIN comments ON comments.post_id = posts.id
  WHERE users.login = 'Jill'
  GROUP BY posts.title
  ORDER BY most_recent_comment_date DESC;


-- 6. Find how many comments each user has made per post category.

SELECT users.login, categories.name, COUNT(categories.name) AS comments_count
  FROM users
    INNER JOIN comments ON comments.author_id = users.id
    INNER JOIN posts ON comments.post_id = posts.id
    INNER JOIN categories ON posts.category_id = categories.id
  GROUP BY users.login, categories.name
  ORDER BY users.login;


-- 7. Get the 5 most-commented-on posts that were created in the last 7 days.

SELECT posts.title, COUNT(*) AS comments_count
  FROM posts
    INNER JOIN comments ON comments.post_id = posts.id
  WHERE posts.created_at > current_date - 7
  GROUP BY posts.title, posts.created_at
  ORDER BY posts.created_at;


-- 8. Get the 5 posts with the longest-running comment threads
--    (longest time between first and last comments).

SELECT posts.title, (MAX(comments.created_at) - MIN(comments.created_at)) AS runtime
  FROM posts
    INNER JOIN comments ON comments.post_id = posts.id
  GROUP BY posts.title
  ORDER BY runtime DESC;


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
