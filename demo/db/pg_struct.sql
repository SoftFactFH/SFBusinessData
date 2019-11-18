CREATE TABLE bdsarticle (
  bdsarticleid serial PRIMARY KEY NOT NULL,
  bdsarticledesc varchar(50) NOT NULL,
  bdsarticleprice numeric(8,2) NOT NULL
);

CREATE TABLE bdscstmr (
  bdscstmrid serial PRIMARY KEY NOT NULL,
  bdscstmrname varchar(80),
  bdscstmrfirstname varchar(80),
  bdscstmrdateofbirth date,
  bdscstmrpostcode varchar(5),
  bdscstmrcity varchar(50),
  bdscstmrstreet varchar(50),
  bdscstmrnotice text,
  bdscstmrtypeid integer,
  bdscstmrimage bytea,
  bdscstmrimageext varchar(10)
);

CREATE TABLE bdscstmrorder (
  bdscstmrorderid serial PRIMARY KEY NOT NULL,
  bdscstmrordercstmrid integer NOT NULL,
  bdscstmrorderdate date NOT NULL
);

CREATE TABLE bdscstmrorderpos (
  bdscstmrorderposid serial PRIMARY KEY NOT NULL,
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
