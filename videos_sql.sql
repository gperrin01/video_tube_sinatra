CREATE TABLE videos(
  id serial8 primary key, 
  title varchar(225),
  description text,
  url varchar(225),
  url_embed varchar(225),
  genre varchar(30)
);