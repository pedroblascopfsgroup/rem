ALTER TABLE LIN001.DD_TPN_TIPO_INMUEBLE
 DROP PRIMARY KEY CASCADE;
DROP TABLE LIN001.DD_TPN_TIPO_INMUEBLE CASCADE CONSTRAINTS;

CREATE TABLE LIN001.DD_TPN_TIPO_INMUEBLE
(
  DD_TPN_ID                 NUMBER(16)          NOT NULL,
  DD_TPN_CODIGO             VARCHAR2(50 CHAR)   NOT NULL,
  DD_TPN_DESCRIPCION        VARCHAR2(50 CHAR),
  DD_TPN_DESCRIPCION_LARGA  VARCHAR2(250 CHAR),
  VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
  USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
  FECHACREAR                TIMESTAMP(6)        NOT NULL,
  USUARIOMODIFICAR          VARCHAR2(10 CHAR),
  FECHAMODIFICAR            TIMESTAMP(6),
  USUARIOBORRAR             VARCHAR2(10 CHAR),
  FECHABORRAR               TIMESTAMP(6),
  BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
)
TABLESPACE LIN001
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX LIN001.PK_DD_TPN_TIPO_INMUEBLE ON LIN001.DD_TPN_TIPO_INMUEBLE
(DD_TPN_ID)
LOGGING
TABLESPACE LIN001
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX LIN001.UK_DD_TPN_TIPO_INMUEBLE ON LIN001.DD_TPN_TIPO_INMUEBLE
(DD_TPN_CODIGO)
LOGGING
TABLESPACE LIN001
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE LIN001.DD_TPN_TIPO_INMUEBLE ADD (
  CONSTRAINT PK_DD_TPN_TIPO_INMUEBLE
 PRIMARY KEY
 (DD_TPN_ID)
    USING INDEX 
    TABLESPACE LIN001
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ),
  CONSTRAINT UK_DD_TPN_TIPO_INMUEBLE
 UNIQUE (DD_TPN_CODIGO)
    USING INDEX 
    TABLESPACE LIN001
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

DROP SEQUENCE LIN001.S_DD_TPN_TIPO_INMUEBLE;

CREATE SEQUENCE LIN001.S_DD_TPN_TIPO_INMUEBLE
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 100
  NOORDER;       
  
  
  
Insert into DD_TPN_TIPO_INMUEBLE
   (DD_TPN_ID, DD_TPN_CODIGO, DD_TPN_DESCRIPCION, DD_TPN_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, 
    FECHABORRAR, BORRADO)
 Values
   (S_DD_TPN_TIPO_INMUEBLE.NEXTVAL, 'RUS', 'R�STICO', 'R�STICO', 0, 
    'CPEREZ', SYSDATE, NULL, NULL, NULL, 
    NULL, 0);
Insert into DD_TPN_TIPO_INMUEBLE
   (DD_TPN_ID, DD_TPN_CODIGO, DD_TPN_DESCRIPCION, DD_TPN_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, 
    FECHABORRAR, BORRADO)
 Values
   (S_DD_TPN_TIPO_INMUEBLE.NEXTVAL, 'URB', 'URBANO', 'URBANO', 0, 
    'CPEREZ', SYSDATE, NULL, NULL, NULL, 
    NULL, 0);
COMMIT;