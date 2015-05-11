ALTER TABLE BANK01.DD_TPC_TIPO_CARGA
 DROP PRIMARY KEY CASCADE;
DROP TABLE BANK01.DD_TPC_TIPO_CARGA CASCADE CONSTRAINTS;

CREATE TABLE BANK01.DD_TPC_TIPO_CARGA
(
  DD_TPC_ID                 NUMBER(16)          NOT NULL,
  DD_TPC_CODIGO             VARCHAR2(10 CHAR)   NOT NULL,
  DD_TPC_DESCRIPCION        VARCHAR2(50 CHAR)   NOT NULL,
  DD_TPC_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  NOT NULL,
  VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
  USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
  FECHACREAR                TIMESTAMP(6)        NOT NULL,
  USUARIOMODIFICAR          VARCHAR2(10 CHAR),
  FECHAMODIFICAR            TIMESTAMP(6),
  USUARIOBORRAR             VARCHAR2(10 CHAR),
  FECHABORRAR               TIMESTAMP(6),
  BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
)
TABLESPACE BANK01
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


CREATE UNIQUE INDEX BANK01.PK_DD_TPC_TIPO_CARGA ON BANK01.DD_TPC_TIPO_CARGA
(DD_TPC_ID)
LOGGING
TABLESPACE BANK01
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


ALTER TABLE BANK01.DD_TPC_TIPO_CARGA ADD (
  CONSTRAINT PK_DD_TPC_TIPO_CARGA
 PRIMARY KEY
 (DD_TPC_ID)
    USING INDEX 
    TABLESPACE BANK01
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
               
               
INSERT INTO BANK01.DD_TPC_TIPO_CARGA
(
  DD_TPC_ID,
  DD_TPC_CODIGO,
  DD_TPC_DESCRIPCION,
  DD_TPC_DESCRIPCION_LARGA,
  USUARIOCREAR,
  FECHACREAR,
  BORRADO  
)  VALUES (1,'ANT','ANTERIORES HIPOTECA','ANTERIORES HIPOTECA','DGG',sysdate,0);


INSERT INTO BANK01.DD_TPC_TIPO_CARGA
(
  DD_TPC_ID,
  DD_TPC_CODIGO,
  DD_TPC_DESCRIPCION,
  DD_TPC_DESCRIPCION_LARGA,
  USUARIOCREAR,
  FECHACREAR,
  BORRADO  
)  VALUES (2,'POS','POSTERIORES HIPOTECA','POSTERIORES HIPOTECA','DGG',sysdate,0);


ALTER TABLE BANK01.DD_SIC_SITUACION_CARGA
 DROP PRIMARY KEY CASCADE;
DROP TABLE BANK01.DD_SIC_SITUACION_CARGA CASCADE CONSTRAINTS;

CREATE TABLE BANK01.DD_SIC_SITUACION_CARGA
(
  DD_SIC_ID                 NUMBER(16)          NOT NULL,
  DD_SIC_CODIGO             VARCHAR2(10 CHAR)   NOT NULL,
  DD_SIC_DESCRIPCION        VARCHAR2(50 CHAR)   NOT NULL,
  DD_SIC_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  NOT NULL,
  VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
  USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
  FECHACREAR                TIMESTAMP(6)        NOT NULL,
  USUARIOMODIFICAR          VARCHAR2(10 CHAR),
  FECHAMODIFICAR            TIMESTAMP(6),
  USUARIOBORRAR             VARCHAR2(10 CHAR),
  FECHABORRAR               TIMESTAMP(6),
  BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
)
TABLESPACE BANK01
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


CREATE UNIQUE INDEX BANK01.PK_DD_SIC_SITUACION_CARGA ON BANK01.DD_SIC_SITUACION_CARGA
(DD_SIC_ID)
LOGGING
TABLESPACE BANK01
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


ALTER TABLE BANK01.DD_SIC_SITUACION_CARGA ADD (
  CONSTRAINT PK_DD_SIC_SITUACION_CARGA
 PRIMARY KEY
 (DD_SIC_ID)
    USING INDEX 
    TABLESPACE BANK01
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
               
               
INSERT INTO BANK01.DD_SIC_SITUACION_CARGA
(
  DD_SIC_ID,
  DD_SIC_CODIGO,
  DD_SIC_DESCRIPCION,
  DD_SIC_DESCRIPCION_LARGA,
  USUARIOCREAR,
  FECHACREAR,
  BORRADO  
)  VALUES (1,'CAN','CANCELADA','CANCELADA','DGG',sysdate,0);


INSERT INTO BANK01.DD_SIC_SITUACION_CARGA
(
  DD_SIC_ID,
  DD_SIC_CODIGO,
  DD_SIC_DESCRIPCION,
  DD_SIC_DESCRIPCION_LARGA,
  USUARIOCREAR,
  FECHACREAR,
  BORRADO  
)  VALUES (2,'REC','RECHAZADA','RECHAZADA','DGG',sysdate,0);


DROP SEQUENCE S_BIE_CAR_CARGAS;
CREATE SEQUENCE S_BIE_CAR_CARGAS;


ALTER TABLE BANK01.BIE_CAR_CARGAS
 DROP PRIMARY KEY CASCADE;
DROP TABLE BANK01.BIE_CAR_CARGAS CASCADE CONSTRAINTS;


CREATE TABLE BANK01.BIE_CAR_CARGAS
(
  BIE_ID                       NUMBER(16)       NOT NULL, 
  BIE_CAR_ID                   NUMBER(16)       NOT NULL,
  DD_TPC_ID                    NUMBER(16)       NOT NULL,
  BIE_CAR_LETRA                VARCHAR2(50 CHAR), 
  BIE_CAR_TITULAR              VARCHAR2(50 CHAR),
  BIE_CAR_IMPORTE_REGISTRAL    NUMBER(16),
  BIE_CAR_IMPORTE_ECONOMICO    NUMBER(16),
  BIE_CAR_REGISTRAL            NUMBER(1),
  DD_SIC_ID                    NUMBER(16)       NOT NULL,
  BIE_CAR_FECHA_PRESENTACION   DATE,
  BIE_CAR_FECHA_INSCRIPCION    DATE,
  BIE_CAR_FECHA_CANCELACION    DATE,
  BIE_CAR_ECONOMICA            NUMBER(1),
  VERSION                      INTEGER          DEFAULT 0                     NOT NULL,
  USUARIOCREAR                 VARCHAR2(10 CHAR) NOT NULL,
  FECHACREAR                   TIMESTAMP(6)     NOT NULL,
  USUARIOMODIFICAR             VARCHAR2(10 CHAR),
  FECHAMODIFICAR               TIMESTAMP(6),
  USUARIOBORRAR                VARCHAR2(10 CHAR),
  FECHABORRAR                  TIMESTAMP(6),
  BORRADO                      NUMBER(1)        DEFAULT 0                     NOT NULL

)
TABLESPACE BANK01
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


CREATE UNIQUE INDEX BANK01.PK_BIE_CAR_CARGAS ON BANK01.BIE_CAR_CARGAS
(BIE_CAR_ID)
LOGGING
TABLESPACE BANK01
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


ALTER TABLE BANK01.BIE_CAR_CARGAS ADD (
  CONSTRAINT PK_BIE_CAR_CARGAS
 PRIMARY KEY
 (BIE_CAR_ID)
    USING INDEX 
    TABLESPACE BANK01
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
 
 ALTER TABLE BANK01.BIE_CAR_CARGAS ADD (
 CONSTRAINT FK_BIE_CAR 
 FOREIGN KEY (BIE_ID) 
 REFERENCES BANK01.BIE_BIEN (BIE_ID),
  CONSTRAINT FK_BIE_DD_TPC 
 FOREIGN KEY (DD_TPC_ID) 
 REFERENCES BANK01.DD_TPC_TIPO_CARGA (DD_TPC_ID),
  CONSTRAINT FK_BIE_DD_SIC 
 FOREIGN KEY (DD_SIC_ID) 
 REFERENCES BANK01.DD_SIC_SITUACION_CARGA (DD_SIC_ID));
 
 
 
 ALTER TABLE BIE_ADICIONAL ADD (
 
    BIE_ADI_FFIN_REV_CARGA DATE,
    BIE_ADI_SIN_CARGA   NUMBER(1),
    BIE_ADI_OBS_CARGA VARCHAR2(250 CHAR)
 

 );

