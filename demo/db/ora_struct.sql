
CREATE TABLE bdsarticle (
  bdsarticleid NUMBER(11) NOT NULL,
  bdsarticledesc VARCHAR2(50),
  bdsarticleprice NUMBER(8,2) NOT NULL
);

ALTER TABLE bdsarticle ADD (
  CONSTRAINT bdsarticle_pk PRIMARY KEY (bdsarticleid));

CREATE SEQUENCE bdsarticle_pk START WITH 1;

CREATE TABLE bdscstmr (
  bdscstmrid NUMBER(11) NOT NULL,
  bdscstmrname VARCHAR2(80) NOT NULL,
  bdscstmrfirstname VARCHAR2(80),
  bdscstmrdateofbirth DATE,
  bdscstmrpostcode VARCHAR2(5),
  bdscstmrcity VARCHAR2(50),
  bdscstmrstreet VARCHAR2(50),
  bdscstmrnotice CLOB,
  bdscstmrtypeid NUMBER(11),
  bdscstmrimage BLOB,
  bdscstmrimageext VARCHAR2(10)
);

ALTER TABLE bdscstmr ADD (
  CONSTRAINT bdscstmr_pk PRIMARY KEY (bdscstmrid));

CREATE SEQUENCE bdscstmr_pk START WITH 1;

CREATE TABLE bdscstmrorder (
  bdscstmrorderid NUMBER(11) NOT NULL,
  bdscstmrordercstmrid NUMBER(11) NOT NULL,
  bdscstmrorderdate DATE
);

ALTER TABLE bdscstmrorder ADD (
  CONSTRAINT bdscstmrorder_pk PRIMARY KEY (bdscstmrorderid));

CREATE SEQUENCE bdscstmrorder_pk START WITH 1;

CREATE TABLE bdscstmrorderpos (
  bdscstmrorderposid NUMBER(11) NOT NULL,
  bdscstmrorderposorderid NUMBER(11) NOT NULL,
  bdscstmrorderposquantity NUMBER(11) NOT NULL,
  bdscstmrorderposartid NUMBER(11) NOT NULL
);

ALTER TABLE bdscstmrorderpos ADD (
  CONSTRAINT bdscstmrorderpos_pk PRIMARY KEY (bdscstmrorderposid));

CREATE SEQUENCE bdscstmrorderpos_pk START WITH 1;

CREATE TABLE bdscstmrtype (
  bdscstmrtypeid NUMBER(11) PRIMARY KEY,
  bdscstmrtypedesc VARCHAR2(30)
);

INSERT INTO bdscstmrtype (bdscstmrtypeid, bdscstmrtypedesc) VALUES (1, 'Supplier');
INSERT INTO bdscstmrtype (bdscstmrtypeid, bdscstmrtypedesc) VALUES (2, 'Customer');
