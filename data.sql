\c blog

INSERT INTO users (login)
  VALUES
    ('Kelly'),
    ('Chris'),
    ('Kim'),
    ('Jack'),
    ('Jill'),
    ('Went'),
    ('Hill'),
    ('Fetch');

INSERT INTO categories (name)
  VALUES
    ('Music'),
    ('Books'),
    ('Technology'),
    ('Dating'),
    ('Lifehacks'),
    ('Venture Capital');

-- Create blog posts

WITH temp (login, title, content, category) AS
(VALUES
  ('Jill', 'Harry Potter and the Philosophers Stone Review', 'It was good.', 'Books'),
  ('Kelly', 'Watch A Mariachi Band Perform Zelda Music At A Wedding', 'Impressive.', 'Music')
)
INSERT INTO posts
  (author_id, title, content, category_id)
SELECT
  users.id, temp.title, temp.content, categories.id
FROM
  users JOIN temp
    ON temp.login = users.login
    JOIN categories
      ON temp.category = categories.name;

-- Create comments

WITH temp (login, title, content) AS
(VALUES
  ('Hill', 'Harry Potter and the Philosophers Stone Review', 'I read it in latin.'),
  ('Fetch', 'Harry Potter and the Philosophers Stone Review', 'I hope Harry marries Hermonie.'),
  ('Chris', 'Watch A Mariachi Band Perform Zelda Music At A Wedding', 'Such good. Very music.')
)
INSERT INTO comments
  (author_id, post_id, content)
SELECT
  users.id, posts.id, temp.content
FROM
  users JOIN temp
    ON temp.login = users.login
    JOIN posts
      ON temp.title = posts.title;
