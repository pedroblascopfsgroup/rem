CREATE SEQUENCE BANK01.S_BIE_TEA;

CREATE TABLE BANK01.BIE_TEA
(
  BIE_TEA_ID        NUMBER(16)                  NOT NULL,
  TEA_ID            NUMBER(16)                  NOT NULL,
  BIE_ID            NUMBER(16)                  NOT NULL,
  VERSION           INTEGER                     DEFAULT 0                     NOT NULL,
  USUARIOCREAR      VARCHAR2(10 CHAR)           NOT NULL,
  FECHACREAR        TIMESTAMP(6)                NOT NULL,
  USUARIOMODIFICAR  VARCHAR2(10 CHAR),
  FECHAMODIFICAR    TIMESTAMP(6),
  USUARIOBORRAR     VARCHAR2(10 CHAR),
  FECHABORRAR       TIMESTAMP(6),
  BORRADO           NUMBER(1)                   DEFAULT 0                     NOT NULL
);
 
CREATE UNIQUE INDEX BIE_TEA_PK ON BIE_TEA
(BIE_TEA_ID);
 
ALTER TABLE BANK01.BIE_TEA ADD (
  CONSTRAINT BIE_TEA_PK
 PRIMARY KEY
 (BIE_TEA_ID));
 
ALTER TABLE BANK01.BIE_TEA ADD (
  CONSTRAINT BIE_TEA_TEA_FK
 FOREIGN KEY (TEA_ID)
 REFERENCES BANK01.TEA_TERMINOS_ACUERDO (TEA_ID),
  CONSTRAINT BIE_TEA_BIE_FK
 FOREIGN KEY (BIE_ID)
 REFERENCES BANK01.BIE_BIEN (BIE_ID));
