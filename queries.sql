--Results.txt from GA copy of HW

--Pages 35 - 40 in seven in seven pdf

--Existing tables
-- categories
-- users
-- Posts
-- comments

-- 1. Get posts containing a specific keyword (e.g. "about").
SELECT * FROM posts WHERE content LIKE '%about%';

-- 2. Get a listing of all posts grouped by year.
-- Number of post
-- SELECT EXTRACT(YEAR FROM created_at) FROM posts;
SELECT EXTRACT(YEAR FROM created_at), COUNT(posts.*)
  FROM posts
  GROUP BY EXTRACT(YEAR FROM created_at);


-- 3. Get the top 5 wordiest posts by character count.
SELECT title, LENGTH(content) FROM posts
ORDER BY LENGTH(content) DESC LIMIT 5;

-- 4. Find how many comments each user has across all of their posts.
-- That their posts have, not that they have made
-- All posts by a user
-- All comments on those posts
SELECT

-- 5. Get a specific user's posts sorted by date of most recent comment.
--users, posts, comments

--I don't think this works
SELECT users.login, posts.title, comments.created_at AS most_recent_comment
  FROM users, posts, comments
  WHERE users.id = posts.author_id
  GROUP BY users.login, posts.title, comments.created_at
  ORDER BY MAX(comments.created_at);



-- 6. Find how many comments each user has made per post category.


-- 7. Get the 5 most-commented-on posts that were created in the last 7 days.


-- 8. Get the 5 posts with the longest-running comment threads
--    (longest time between first and last comments).
SELECT MIN(created_at) FROM posts; -- I AM WICKED INCOMPLETE
SELECT DATEDIFF(day,2015-03-30, 2009-09-09) FROM posts;


-- 9. Get all posts by a specific user that have comments,
--    but which that user hasn't commented on.


-- 10. Find which category of post each user has made the most comments on.
