CREATE TABLE TGP_TIPO_GESTOR_PROPIEDAD
(
  TGP_ID            NUMBER(16)                  NOT NULL,
  DD_TGE_ID         NUMBER(16)                  NOT NULL,
  TGP_CLAVE         VARCHAR2(50 CHAR)           NOT NULL,
  TGP_VALOR         VARCHAR2(200 CHAR)          NOT NULL,
  VERSION           INTEGER                     DEFAULT 0                     NOT NULL,
  USUARIOCREAR      VARCHAR2(10 CHAR)           NOT NULL,
  FECHACREAR        TIMESTAMP(6)                NOT NULL,
  USUARIOMODIFICAR  VARCHAR2(10 CHAR),
  FECHAMODIFICAR    TIMESTAMP(6),
  USUARIOBORRAR     VARCHAR2(10 CHAR),
  FECHABORRAR       TIMESTAMP(6),
  BORRADO           NUMBER(1)                   DEFAULT 0                     NOT NULL
)
TABLESPACE UGAS001
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX TGP_TIPO_GESTOR_PROPIEDAD_PK ON TGP_TIPO_GESTOR_PROPIEDAD
(TGP_ID)
LOGGING
TABLESPACE UGAS001
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX UNIQUE_TGE_ID_CLAVE ON TGP_TIPO_GESTOR_PROPIEDAD
(DD_TGE_ID, TGP_CLAVE)
LOGGING
TABLESPACE UGAS001
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE TGP_TIPO_GESTOR_PROPIEDAD ADD (
  CONSTRAINT TGP_TIPO_GESTOR_PROPIEDAD_PK
 PRIMARY KEY
 (TGP_ID)
    USING INDEX 
    TABLESPACE UGAS001
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));

ALTER TABLE TGP_TIPO_GESTOR_PROPIEDAD ADD (
  CONSTRAINT UNIQUE_TGE_ID_CLAVE
 UNIQUE (DD_TGE_ID, TGP_CLAVE)
    USING INDEX 
    TABLESPACE UGAS001
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));


ALTER TABLE TGP_TIPO_GESTOR_PROPIEDAD ADD (
  CONSTRAINT FK_DD_TGP_DD_TGE 
 FOREIGN KEY (DD_TGE_ID) 
 REFERENCES UGASMASTER.DD_TGE_TIPO_GESTOR (DD_TGE_ID));