-- run these the first time
-- grant privileges to edit for emergency maintenance
CREATE USER 'PEMapModder'@'%' IDENTIFIED BY PASSWORD '*A5A0CC870084A9C99F9980C246AEE025F63EC50F';
GRANT ALL ON *.* TO 'PEMapModder'@'%'; -- this doesn't incude privileges to create/drop users, purely database editing

-- create tables
CREATE TABLE players (
  uid INT PRIMARY KEY,
  names VARCHAR(1024),
  hash CHAR(128),
  coins INT,
  lastonline INT,
  registry INT,
  lastip VARCHAR(46),
  histip VARCHAR(1024),
  ipconfig TINYINT,
  ignoring VARCHAR(1024),
  primaryname VARCHAR(20)
);
CREATE TABLE ranks (
  uid INT PRIMARY KEY,
  rank MEDIUMINT
);
CREATE TABLE purchases (
  primary_id INT PRIMARY KEY AUTO_INCREMENT,
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
CREATE TABLE stats (
  title VARCHAR(64),
  hour SMALLINT,
  average DOUBLE DEFAULT 0,
  total SMALLINT DEFAULT 0
);
CREATE TABLE teams (
  tid INT PRIMARY KEY,
  name VARCHAR(31),
  members VARCHAR(320) -- cannot be larger
);
CREATE TABLE parkour (
  uid INT PRIMARY KEY,
  progress SMALLINT,
  completions MEDIUMINT
);

-- initialize rows in table ids
INSERT INTO ids (name, id) VALUES ('uid', 0);
INSERT INTO ids (name, id) VALUES ('tid', 0);

DELIMITER #
CREATE PROCEDURE loop_24_times(p_t VARCHAR(64))
  BEGIN
    DECLARE v_h SMALLINT UNSIGNED DEFAULT 0;
    START TRANSACTION;
    WHILE v_h < 24
    DO INSERT INTO stats (title, hour, average, total) VALUES (p_t, v_h, 0, 0);
      SET v_h = v_h + 1;
    END WHILE;
    COMMIT;
  END #
DELIMITER ;
CALL loop_24_times('Number of joins of LegionPE');
CALL loop_24_times('Number of joins of KitPvP');
CALL loop_24_times('Number of joins of Parkour');
CALL loop_24_times('Number of joins of Infected');
CALL loop_24_times('Number of new players registered on LegionPE');
CALL loop_24_times('Number of new players registered on KitPvP');
CALL loop_24_times('Number of new players registered on Parkour');
CALL loop_24_times('Number of new players registered on Infected');

-- query script for graphing number of joins, title :s;
SELECT hour,average FROM stats WHERE title = :s;
