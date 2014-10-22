CREATE TABLE players (
  uid INT PRIMARY KEY,
  names VARCHAR(1024),
  hash BINARY(64),
  lastonline INT,
  registry INT,
  lastip VARCHAR(32),
  histip VARCHAR(1024),
  ipconfig TINYINT,
  ignoring VARCHAR(1024),
  chatinfo SMALLINT
);
CREATE TABLE kitpvp (
  uid INT PRIMARY KEY,
  kills INT,
  deaths INT,
  kit SMALLINT
);
