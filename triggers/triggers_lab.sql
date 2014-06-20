DROP DATABASE IF EXISTS trigger_lab;
CREATE DATABASE trigger_lab;
\c trigger_lab

CREATE TABLE users (id SERIAL PRIMARY KEY, name TEXT);
CREATE TABLE address (id_user int, address TEXT);

INSERT INTO users VALUES
    (1, 'Michael P');
INSERT INTO address VALUES
    (1, 'Work in Tokyo, Japan'),
    (1, 'Live in San Francisco, California');

CREATE FUNCTION delete_address() RETURNS TRIGGER AS $_$
BEGIN
    DELETE FROM address WHERE address.id_user = OLD.id;
    RETURN OLD;
END $_$ LANGUAGE 'plpgsql';

CREATE TRIGGER delete_user_address BEFORE DELETE ON users FOR EACH ROW EXECUTE PROCEDURE delete_address();

