create database project2;
use project2;
CREATE TABLE Movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    release_year YEAR,
    genre VARCHAR(50)
);
describe movies;
CREATE TABLE Actors (
    actor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE
);
describe Actors;
CREATE TABLE Castings (
    casting_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT,
    actor_id INT,
    role VARCHAR(100),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (actor_id) REFERENCES Actors(actor_id)
);
describe Castings;
INSERT INTO Movies (title, release_year, genre) VALUES
('Inception', 2010, 'Sci-Fi'),
('Titanic', 1997, 'Romance'),
('The Godfather', 1972, 'Crime'),
('Avatar', 2009, 'Sci-Fi'),
('The Dark Knight', 2008, 'Action'),
('Pulp Fiction', 1994, 'Crime'),
('The Matrix', 1999, 'Sci-Fi'),
('The Lord of the Rings: The Fellowship of the Ring', 2001, 'Fantasy'),
('Forrest Gump', 1994, 'Drama'),
('Interstellar', 2014, 'Sci-Fi');

INSERT INTO Actors (first_name, last_name, birth_date) VALUES
('Leonardo', 'DiCaprio', '1974-11-11'),
('Marlon', 'Brando', '1924-04-03'),
('Kate', 'Winslet', '1975-10-05'),
('Christian', 'Bale', '1974-01-30'),
('Sam', 'Worthington', '1976-08-02'),
('John', 'Travolta', '1954-02-18'),
('Keanu', 'Reeves', '1964-09-02'),
('Elijah', 'Wood', '1981-01-28'),
('Tom', 'Hanks', '1956-07-09'),
('Matthew', 'McConaughey', '1969-11-04');

INSERT INTO Castings (movie_id, actor_id, role) VALUES
(1, 1, 'Dom Cobb'),             -- Inception, Leonardo DiCaprio
(2, 1, 'Jack Dawson'),           -- Titanic, Leonardo DiCaprio
(2, 3, 'Rose DeWitt Bukater'),   -- Titanic, Kate Winslet
(3, 2, 'Don Vito Corleone'),     -- The Godfather, Marlon Brando
(4, 5, 'Jake Sully'),            -- Avatar, Sam Worthington
(5, 4, 'Bruce Wayne'),           -- The Dark Knight, Christian Bale
(6, 6, 'Vincent Vega'),          -- Pulp Fiction, John Travolta
(7, 7, 'Neo'),                   -- The Matrix, Keanu Reeves
(8, 8, 'Frodo Baggins'),         -- The Lord of the Rings, Elijah Wood
(9, 9, 'Forrest Gump'),          -- Forrest Gump, Tom Hanks
(10, 10, 'Cooper');              -- Interstellar, Matthew McConaughey

alter table Actors change first_name name VARCHAR(50);

-- List all movies along with their release years.
select title,release_year from Movies ;

-- Retrieve the names of all actors who acted in 'Inception'
select name from actors where actor_id in (select actor_id from castings where movie_id=(select movie_id from movies where title='Inception'));
-- Find all movies released in 1994.
select * from movies where release_year=1994;
-- Get all actors who were born before January 1, 1975.
select * from Actors where birth_date<'1975-01-01';
-- List all movies with the genre 'Sci-Fi'.
select * from movies where genre like 'Sci-Fi';
-- Find the roles that Leonardo DiCaprio has played in all movies.
select role from castings where actor_id in (select actor_id from actors where name='Leonardo' and last_name='DiCaprio');
-- Find actors who appear in multiple movies.
select * from actors where actor_id in (select actor_id from castings GROUP BY actor_id HAVING COUNT(movie_id) > 1);

-- Count the total number of movies.
select count(title) as tot_num from movies;

-- List all actors who acted in 'The Dark Knight'.
select * from actors where actor_id in (select actor_id from castings where movie_id= 5);

-- Retrieve the names of actors in movies that were released after 2010.
select name,last_name from actors where actor_id in (select actor_id from castings where movie_id=(select movie_id from movies where release_year>2010));

-- Find the actor who played 'Neo' in 'The Matrix'.
select name,last_name from actors where actor_id in (select actor_id from castings where actor_id=7 );

--  Count how many movies each actor has appeared in.
-- select count(title) from movies where movie_id in (select movie_id from castings where (select actor_id from movies group by actor_id) );
SELECT name, last_name, (SELECT COUNT(*) FROM Castings WHERE Castings.actor_id = Actors.actor_id) AS movie_count FROM Actors;

-- List all movies (with genres) that Tom Hanks has acted in.
select title,genre from movies where movie_id in (select movie_id from castings where actor_id in ( select actor_id from actors where name='Tom' and last_name='Hanks'));

-- Retrieve all movies that feature actors born after January 1, 1980.
select title from movies where movie_id in (select movie_id from castings where actor_id in (select actor_id from actors where birth_date>'1980-01-01'));

-- List the roles played by actors in 'Pulp Fiction'.
select role from castings where movie_id in (select movie_id from movies where title='Pulp Fiction' );