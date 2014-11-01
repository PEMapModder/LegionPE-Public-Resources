-- run these the first time
CREATE TABLE players (
  uid INT PRIMARY KEY,
  names VARCHAR(1024),
  hash BINARY(64),
  coins INT,
  lastonline INT,
  registry INT,
  lastip VARCHAR(32),
  histip VARCHAR(1024),
  ipconfig TINYINT,
  ignoring VARCHAR(1024),
  chatinfo SMALLINT,
  primaryname VARCHAR(20),
);
CREATE TABLE ranks (
  uid INT PRIMARY KEY,
  rank SMALLINT
);
CREATE TABLE purchases (
  owner INT,
  expiry INT,
  product INT
);
CREATE TABLE kitpvp (
  uid INT PRIMARY KEY,
  kills INT,
  deaths INT,
  kit SMALLINT
);
CREATE TABLE kitpvp_friends (
  smalluid INT,
  largeuid INT,
  type SMALLINT
);
CREATE TABLE ids (
  name VARCHAR(8) PRIMARY KEY,
  id INT DEFAULT 0
);
INSERT INTO ids (name, id) VALUES ('uid', 0);
CREATE TABLE stats (
  title VARCHAR(64),
  hour SMALLINT,
  average DOUBLE DEFAULT 0,
  total SMALLINT DEFAULT 0
);
-- for 0 to 23 for :d,
INSERT INTO stats (title, hour) VALUES ('Number of joins of LegionPE', :d);
INSERT INTO stats (title, hour) VALUES ('Number of joins of KitPvP', :d);
INSERT INTO stats (title, hour) VALUES ('Number of joins of Parkour', :d);
INSERT INTO stats (title, hour) VALUES ('Number of joins of Infected', :d);

-- query script for graphing number of joins, title :s;
SELECT hour,average FROM stats WHERE title = :s;
