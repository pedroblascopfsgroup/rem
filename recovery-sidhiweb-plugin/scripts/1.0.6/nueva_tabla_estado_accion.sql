-- Este script sólo es necesario ejecutarlo en caso de que la tabla no exista. 
-- Ejecutar con el usuario entidad.

WHENEVER SQLERROR EXIT SQL.SQLCODE
CREATE TABLE SIDHI_DAT_EAC_ESTADO_ACCION
(
  DD_EAC_ID                 NUMBER(16)          NOT NULL,
  DD_EAC_CODIGO             VARCHAR2(20 CHAR)   NOT NULL,
  DD_EAC_DESCRIPCION        VARCHAR2(50 CHAR),
  DD_EAC_DESCRIPCION_LARGA  VARCHAR2(250 CHAR),
  VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
  USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
  FECHACREAR                TIMESTAMP(6)        NOT NULL,
  USUARIOMODIFICAR          VARCHAR2(10 CHAR),
  FECHAMODIFICAR            TIMESTAMP(6),
  USUARIOBORRAR             VARCHAR2(10 CHAR),
  FECHABORRAR               TIMESTAMP(6),
  BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
)
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


CREATE UNIQUE INDEX PK_SIDHI_DAT_EAC_ESTADO_ACCION ON SIDHI_DAT_EAC_ESTADO_ACCION
(DD_EAC_ID)
LOGGING
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


CREATE UNIQUE INDEX UK_SIDHI_DAT_EAC_ESTADO_ACCION ON SIDHI_DAT_EAC_ESTADO_ACCION
(DD_EAC_CODIGO)
LOGGING
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


ALTER TABLE SIDHI_DAT_EAC_ESTADO_ACCION ADD (
  CONSTRAINT PK_SIDHI_DAT_EAC_ESTADO_ACCION
 PRIMARY KEY
 (DD_EAC_ID)
    USING INDEX 
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
  CONSTRAINT UK_SIDHI_DAT_EAC_ESTADO_ACCION
 UNIQUE (DD_EAC_CODIGO)
    USING INDEX 
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
               

-- CREAR COLUMNA ESTADO ACCIÓN EN LA TABLA DE ACCIONES
ALTER TABLE SIDHI_DAT_ACJ_ACCIONES ADD(DD_EAC_ID NUMBER(16));



Insert into SIDHI_DAT_EAC_ESTADO_ACCION
   (DD_EAC_ID, DD_EAC_CODIGO, DD_EAC_DESCRIPCION, DD_EAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (1, 'PROC', 'Procesada', 'Procesada', 0, 'DIA', TO_TIMESTAMP('25/09/2012 10:43:26.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);
Insert into SIDHI_DAT_EAC_ESTADO_ACCION
   (DD_EAC_ID, DD_EAC_CODIGO, DD_EAC_DESCRIPCION, DD_EAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (2, 'NPROC', 'No Procesada', 'No Procesada', 0, 'DIA', TO_TIMESTAMP('25/09/2012 10:43:26.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);
Insert into SIDHI_DAT_EAC_ESTADO_ACCION
   (DD_EAC_ID, DD_EAC_CODIGO, DD_EAC_DESCRIPCION, DD_EAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (3, 'ACT', 'Actualizada', 'Actualizada', 0, 'DIA', TO_TIMESTAMP('25/09/2012 10:43:26.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);
COMMIT;

