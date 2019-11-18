CREATE TABLE bdsarticle (
  bdsarticleid integer PRIMARY KEY AUTOINCREMENT,
  bdsarticledesc varchar(50) NOT NULL,
  bdsarticleprice numeric(8,2) NOT NULL
);

CREATE TABLE bdscstmr (
  bdscstmrid integer PRIMARY KEY AUTOINCREMENT,
  bdscstmrname varchar(80),
  bdscstmrfirstname varchar(80),
  bdscstmrdateofbirth date,
  bdscstmrpostcode varchar(5),
  bdscstmrcity varchar(50),
  bdscstmrstreet varchar(50),
  bdscstmrnotice clob,
  bdscstmrtypeid integer,
  bdscstmrimage blob,
  bdscstmrimageext varchar(10)
);

CREATE TABLE bdscstmrorder (
  bdscstmrorderid integer PRIMARY KEY AUTOINCREMENT,
  bdscstmrordercstmrid integer NOT NULL,
  bdscstmrorderdate date NOT NULL
);

CREATE TABLE bdscstmrorderpos (
  bdscstmrorderposid integer PRIMARY KEY AUTOINCREMENT,
  bdscstmrorderposorderid integer NOT NULL,
  bdscstmrorderposquantity integer NOT NULL,
  bdscstmrorderposartid integer NOT NULL
);

CREATE TABLE bdscstmrtype (
  bdscstmrtypeid integer PRIMARY KEY NOT NULL,
  bdscstmrtypedesc varchar(30) NOT NULL
);

INSERT INTO bdscstmrtype (bdscstmrtypeid, bdscstmrtypedesc) VALUES (1, 'Supplier');
INSERT INTO bdscstmrtype (bdscstmrtypeid, bdscstmrtypedesc) VALUES (2, 'Customer');
