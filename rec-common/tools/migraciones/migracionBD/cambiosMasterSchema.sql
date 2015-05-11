-- ********************************************************************************** --
-- * CAMBIOS A REALIZAR EN BD AL DESPLEGAR LAS DISTINTAS VERSIONES DE LA APLICACIÓN * --   
-- ********************************************************************************** --

-- ******************************** --
-- ** Para DEMO BANESTO			 ** --
-- ******************************** --

CREATE TABLE DD_TDE_TIPO_DESPACHO  (
   DD_TDE_ID               NUMBER(16)                      NOT NULL,
   DD_TDE_CODIGO           VARCHAR2(50 CHAR)                    NOT NULL,
   DD_TDE_DESCRIPCION      VARCHAR2(50 CHAR),
   DD_TDE_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
    CONSTRAINT PK_DD_TDE_TIPO_DESPACHO PRIMARY KEY (DD_TDE_ID),
    CONSTRAINT UK_DD_TDE_TIPO_DESPACHO UNIQUE  (DD_TDE_CODIGO)
);


CREATE TABLE DD_TDE_TIPO_DESPACHO_LG  (
   DD_TDE_ID            NUMBER(16)                      NOT NULL,
   DD_TDE_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_TDE_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_TDE_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TDE_TIPO_DESPACHO_LG PRIMARY KEY (DD_TDE_ID, DD_TDE_LANG)
);

grant references on DD_TDE_TIPO_DESPACHO to PFS01,PFS02,PFS03,PFS04;
grant select on DD_TDE_TIPO_DESPACHO to PFS01,PFS02,PFS03,PFS04;
grant insert on DD_TDE_TIPO_DESPACHO to PFS01,PFS02,PFS03,PFS04;
grant delete on DD_TDE_TIPO_DESPACHO to PFS01,PFS02,PFS03,PFS04;
grant update on DD_TDE_TIPO_DESPACHO to PFS01,PFS02,PFS03,PFS04;


-- ************************************************************* --

ALTER TABLE USU_USUARIOS

 ADD (USU_FECHA_VIGENCIA_PASS DATE DEFAULT SYSDATE NOT NULL);

-- ******************************** --
-- ** Para la versión 3.0.0.1.X ** --
-- ******************************** --

CREATE SEQUENCE S_DD_TRE_TIPO_REGLAS_ELEVACION NOCYCLE CACHE 100;

CREATE TABLE DD_TRE_TIPO_REGLAS_ELEVACION  (
   DD_TRE_ID            NUMBER(16)                      NOT NULL,
   DD_TRE_CODIGO        VARCHAR2(25 CHAR)                  NOT NULL,
   DD_TRE_DESCRIPCION   VARCHAR2(250 CHAR)                    NOT NULL,
   DD_TRE_DESCRIPCION_LARGA VARCHAR2(500 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TRE_TIPO_REGLAS_ELEVACI PRIMARY KEY (DD_TRE_ID),
   CONSTRAINT UK_DD_TRE_TIPO_REGLAS_ELEVACI UNIQUE (DD_TRE_CODIGO)
);


grant references on DD_TRE_TIPO_REGLAS_ELEVACION to PFS01, PFS02, PFS03, PFS04;
grant select on DD_TRE_TIPO_REGLAS_ELEVACION to PFS01, PFS02, PFS03, PFS04;
grant insert on DD_TRE_TIPO_REGLAS_ELEVACION to PFS01, PFS02, PFS03, PFS04;
grant delete on DD_TRE_TIPO_REGLAS_ELEVACION to PFS01, PFS02, PFS03, PFS04;
grant update on DD_TRE_TIPO_REGLAS_ELEVACION to PFS01, PFS02, PFS03, PFS04;


insert into DD_TRE_TIPO_REGLAS_ELEVACION(DD_TRE_ID, DD_TRE_CODIGO, DD_TRE_DESCRIPCION, DD_TRE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
values(S_DD_TRE_TIPO_REGLAS_ELEVACION.nextval, 'POLITICA', 'Proponer Política', 'Proponer Política', 0, 'DD', sysdate, 0);

insert into DD_TRE_TIPO_REGLAS_ELEVACION(DD_TRE_ID, DD_TRE_CODIGO, DD_TRE_DESCRIPCION, DD_TRE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
values(S_DD_TRE_TIPO_REGLAS_ELEVACION.nextval, 'GESTION_SINTESIS', 'Gestión de la Síntesis de Análisis', 'Gestión de la Síntesis de Análisis', 0, 'DD', sysdate, 0);

insert into DD_TRE_TIPO_REGLAS_ELEVACION(DD_TRE_ID, DD_TRE_CODIGO, DD_TRE_DESCRIPCION, DD_TRE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
values(S_DD_TRE_TIPO_REGLAS_ELEVACION.nextval, 'SOLVENCIA', 'Solvencia', 'Solvencia', 0, 'DD', sysdate, 0);

insert into DD_TRE_TIPO_REGLAS_ELEVACION(DD_TRE_ID, DD_TRE_CODIGO, DD_TRE_DESCRIPCION, DD_TRE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
values(S_DD_TRE_TIPO_REGLAS_ELEVACION.nextval, 'ANTECEDENTES', 'Antecedentes', 'Antecedentes', 0, 'DD', sysdate, 0);

insert into DD_TRE_TIPO_REGLAS_ELEVACION(DD_TRE_ID, DD_TRE_CODIGO, DD_TRE_DESCRIPCION, DD_TRE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
values(S_DD_TRE_TIPO_REGLAS_ELEVACION.nextval, 'GESTION_ANALISIS', 'Gestión y Análisis', 'Gestión y Análisis', 0, 'DD', sysdate, 0);

insert into DD_TRE_TIPO_REGLAS_ELEVACION(DD_TRE_ID, DD_TRE_CODIGO, DD_TRE_DESCRIPCION, DD_TRE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
values(S_DD_TRE_TIPO_REGLAS_ELEVACION.nextval, 'DOCUMENTOS', 'Documentos', 'Documentos', 0, 'DD', sysdate, 0);



CREATE SEQUENCE S_DD_AEX_AMBITOS_EXPEDIENTE NOCYCLE CACHE 100;

CREATE TABLE DD_AEX_AMBITOS_EXPEDIENTE  (
   DD_AEX_ID            NUMBER(16)                      NOT NULL,
   DD_AEX_CODIGO        VARCHAR2(25 CHAR)                  NOT NULL,
   DD_AEX_DESCRIPCION   VARCHAR2(250 CHAR)                    NOT NULL,
   DD_AEX_DESCRIPCION_LARGA VARCHAR2(500 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_AEX_AMBITOS_EXPEDIENTE PRIMARY KEY (DD_AEX_ID),
   CONSTRAINT UK_DD_AEX_AMBITOS_EXPEDIENTE UNIQUE (DD_AEX_CODIGO)
);



grant references on DD_AEX_AMBITOS_EXPEDIENTE to PFS01, PFS02, PFS03, PFS04;
grant select on DD_AEX_AMBITOS_EXPEDIENTE to PFS01, PFS02, PFS03, PFS04;
grant insert on DD_AEX_AMBITOS_EXPEDIENTE to PFS01, PFS02, PFS03, PFS04;
grant delete on DD_AEX_AMBITOS_EXPEDIENTE to PFS01, PFS02, PFS03, PFS04;
grant update on DD_AEX_AMBITOS_EXPEDIENTE to PFS01, PFS02, PFS03, PFS04;



insert into DD_AEX_AMBITOS_EXPEDIENTE(DD_AEX_ID, DD_AEX_CODIGO, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_DD_AEX_AMBITOS_EXPEDIENTE.nextval, 'CP', 'Solo el contrato de pase', 'Solo el contrato de pase', 0, 'DD', sysdate, 0);

insert into DD_AEX_AMBITOS_EXPEDIENTE(DD_AEX_ID, DD_AEX_CODIGO, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_DD_AEX_AMBITOS_EXPEDIENTE.nextval, 'CG', 'Contrato de pase y contratos del grupo de clientes', 'Contrato de pase y contratos del grupo de clientes (del cliente que es primer titular del contrato de pase)', 0, 'DD', sysdate, 0);

insert into DD_AEX_AMBITOS_EXPEDIENTE(DD_AEX_ID, DD_AEX_CODIGO, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_DD_AEX_AMBITOS_EXPEDIENTE.nextval, 'CPGRA', 'Contrato de pase, contratos del grupo de clientes y contratos de primera generación', 'Contrato de pase, contratos del grupo de clientes (del cliente que es primer titular del contrato de pase) y contratos de primera generación', 0, 'DD', sysdate, 0);

insert into DD_AEX_AMBITOS_EXPEDIENTE(DD_AEX_ID, DD_AEX_CODIGO, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_DD_AEX_AMBITOS_EXPEDIENTE.nextval, 'CSGRA', 'Contrato de pase, contratos del grupo de clientes y contratos de primera y segunda generación', 'Contrato de pase, contratos del grupo de clientes (del cliente que es primer titular del contrato de pase) y contratos de primera y segunda generación', 0, 'DD', sysdate, 0);


insert into DD_AEX_AMBITOS_EXPEDIENTE(DD_AEX_ID, DD_AEX_CODIGO, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_DD_AEX_AMBITOS_EXPEDIENTE.nextval, 'PP', 'Solo la persona de pase', 'Solo la persona de pase', 0, 'DD', sysdate, 0);

insert into DD_AEX_AMBITOS_EXPEDIENTE(DD_AEX_ID, DD_AEX_CODIGO, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_DD_AEX_AMBITOS_EXPEDIENTE.nextval, 'PG', 'Persona de pase y personas del grupo de clientes', 'Persona de pase y personas del grupo de clientes (de la persona de pase)', 0, 'DD', sysdate, 0);

insert into DD_AEX_AMBITOS_EXPEDIENTE(DD_AEX_ID, DD_AEX_CODIGO, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_DD_AEX_AMBITOS_EXPEDIENTE.nextval, 'PPGRA', 'Persona de pase, personas del grupo de clientes y personas de primera generación', 'Persona de pase, personas del grupo de clientes (de la persona de pase) y personas de primera generación', 0, 'DD', sysdate, 0);

insert into DD_AEX_AMBITOS_EXPEDIENTE(DD_AEX_ID, DD_AEX_CODIGO, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_DD_AEX_AMBITOS_EXPEDIENTE.nextval, 'PSGRA', 'Persona de pase, personas del grupo de clientes y personas de primera y segunda generación', 'Persona de pase, personas del grupo de clientes (de la persona de pase) y personas de primera y segunda generación', 0, 'DD', sysdate, 0);




-- Actualizado con la revisión 9846

CREATE SEQUENCE S_DD_CRC_CLASE_RIESGO_CIRBE;

CREATE SEQUENCE S_DD_TMC_TIPO_MONEDA_CIRBE;

CREATE SEQUENCE S_DD_TSC_TIPO_SITUAC_CIRBE;

CREATE SEQUENCE S_DD_TVC_TIPO_VENC_CIRBE;

CREATE SEQUENCE S_DD_COC_COD_OPERAC_CIRBE;

CREATE SEQUENCE S_DD_TGC_TIPO_GARANTIA_CIRBE;

CREATE SEQUENCE S_DD_FCN_FINALIDAD_CONTRATO;

CREATE SEQUENCE S_DD_FNO_FINALIDAD_OFICIAL;

CREATE SEQUENCE S_DD_GCN_GARANTIA_CONTRATO;

CREATE SEQUENCE S_DD_TTE_TIPO_TELEFONO;

CREATE SEQUENCE S_DD_REX_RATING_EXTERNO;

CREATE SEQUENCE S_DD_RAX_RATING_AUXILIAR;

CREATE SEQUENCE S_DD_GGE_GRUPO_GESTOR;

CREATE SEQUENCE S_DD_MX3_MOVIMIENTO_EXTRA_3;

CREATE SEQUENCE S_DD_MX4_MOVIMIENTO_EXTRA_4;

CREATE SEQUENCE S_DD_SEX_SEXOS;

CREATE SEQUENCE S_DD_POL_POLITICAS;

CREATE SEQUENCE S_DD_PX3_PERSONA_EXTRA_3;

CREATE SEQUENCE S_DD_PX4_PERSONA_EXTRA_4;

CREATE SEQUENCE S_DD_TAN_TIPO_ANALISIS;

CREATE SEQUENCE S_DD_VAL_VALORACION;

CREATE SEQUENCE S_DD_IMP_IMPACTO;



ALTER TABLE DD_TAY_TIPO_AYUDA_ACUERDO
 ADD (CONSTRAINT DD_TAY_CODIGO_UK UNIQUE (DD_TAY_CODIGO));

 ALTER TABLE DD_CRC_CLASE_RIESGO_CIRBE
 ADD (CONSTRAINT DD_CRC_CODIGO_UK UNIQUE (DD_CRC_CODIGO));
 
 ALTER TABLE DD_TMC_TIPO_MONEDA_CIRBE
 ADD (CONSTRAINT DD_TMC_CODIGO_UK UNIQUE (DD_TMC_CODIGO));
 
 ALTER TABLE DD_TSC_TIPO_SITUAC_CIRBE
 ADD (CONSTRAINT DD_TSC_CODIGO_UK  UNIQUE (DD_TSC_CODIGO)	);
 
 ALTER TABLE DD_TVC_TIPO_VENC_CIRBE
 ADD (CONSTRAINT DD_TVC_CODIGO_UK UNIQUE (DD_TVC_CODIGO));
 
  ALTER TABLE DD_COC_COD_OPERAC_CIRBE
 ADD (CONSTRAINT DD_COC_CODIGO_UK UNIQUE (DD_COC_CODIGO));
 
  ALTER TABLE DD_TGC_TIPO_GARANTIA_CIRBE
 ADD (CONSTRAINT DD_TGC_CODIGO_UK UNIQUE (DD_TGC_CODIGO)); 
 
   ALTER TABLE DD_CIC_CODIGO_ISO_CIRBE
 ADD (CONSTRAINT DD_CIC_CODIGO_UK UNIQUE (DD_CIC_CODIGO)); 
  
ALTER TABLE DD_TFI_TIPO_FICHERO
 ADD (CONSTRAINT DD_TFI_CODIGO_UK UNIQUE (DD_TFI_CODIGO)); 
 
ALTER TABLE DD_TGL_TIPO_GRUPO_CLIENTE
 ADD (CONSTRAINT DD_TGL_CODIGO_UK UNIQUE (DD_TGL_CODIGO));  
  
  

CREATE SEQUENCE S_DD_ESP_ESTADO_POLITICA;
CREATE SEQUENCE S_DD_EPI_EST_POL_ITINERARIO;
CREATE SEQUENCE S_DD_ESO_ESTADO_OBJETIVO;
CREATE SEQUENCE S_DD_ESC_ESTADO_CUMPLIMIENTO;
CREATE SEQUENCE S_DD_TOP_TIPO_OPERADOR;

/*==============================================================*/
/* Table: DD_EPI_EST_POL_ITINERARIO                             */
/*==============================================================*/
CREATE TABLE DD_EPI_EST_POL_ITINERARIO  (
   DD_EPI_ID                NUMBER(16)          NOT NULL,
   DD_EST_ID                NUMBER(16),
   DD_EPI_CODIGO            VARCHAR2(20 CHAR)   NOT NULL,
   DD_EPI_DESCRIPCION       VARCHAR2(50 CHAR),
   DD_EPI_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION                  INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_EPI_EST_POL_ITI PRIMARY KEY (DD_EPI_ID),
   CONSTRAINT DD_EPI_CODIGO_UK UNIQUE (DD_EPI_CODIGO)
);

ALTER TABLE DD_EPI_EST_POL_ITINERARIO
   ADD CONSTRAINT FK_DD_EPI_FK_EST_ITI FOREIGN KEY (DD_EST_ID)
      REFERENCES DD_EST_ESTADOS_ITINERARIOS (DD_EST_ID);

/*==============================================================*/
/* Table: DD_ESP_ESTADO_POLITICA                                */
/*==============================================================*/
CREATE TABLE DD_ESP_ESTADO_POLITICA  (
   DD_ESP_ID                NUMBER(16)          NOT NULL,
   DD_ESP_CODIGO            VARCHAR2(20 CHAR)   NOT NULL,
   DD_ESP_DESCRIPCION       VARCHAR2(50 CHAR),
   DD_ESP_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION                  INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_ESP_EST_POL PRIMARY KEY (DD_ESP_ID),
   CONSTRAINT DD_ESP_CODIGO_UK UNIQUE (DD_ESP_CODIGO)
);


/*==============================================================*/
/* Table: ESO_ESTADO_OBJETIVO                                   */
/*==============================================================*/
CREATE TABLE DD_ESO_ESTADO_OBJETIVO  (
   DD_ESO_ID                NUMBER(16)          NOT NULL,
   DD_ESO_CODIGO            VARCHAR2(20 CHAR)   NOT NULL,
   DD_ESO_DESCRIPCION       VARCHAR2(50 CHAR),
   DD_ESO_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION                  INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_ESO_EST_OBJ PRIMARY KEY (DD_ESO_ID),
   CONSTRAINT DD_ESO_CODIGO_UK UNIQUE (DD_ESO_CODIGO)
);


/*==============================================================*/
/* Table: DD_ESC_ESTADO_CUMPLIMIENTO                                */
/*==============================================================*/
CREATE TABLE DD_ESC_ESTADO_CUMPLIMIENTO  (
   DD_ESC_ID                NUMBER(16)          NOT NULL,
   DD_ESC_CODIGO            VARCHAR2(20 CHAR)   NOT NULL,
   DD_ESC_DESCRIPCION       VARCHAR2(50 CHAR),
   DD_ESC_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION                  INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_ESC_EST_CUMP PRIMARY KEY (DD_ESC_ID),
   CONSTRAINT DD_ESC_CODIGO_UK UNIQUE (DD_ESC_CODIGO)
);


/*==============================================================*/
/* Table: DD_TOP_TIPO_OPERADOR                                  */
/*==============================================================*/
CREATE TABLE DD_TOP_TIPO_OPERADOR  (
   DD_TOP_ID                NUMBER(16)          NOT NULL,
   DD_TOP_CODIGO            VARCHAR2(20 CHAR)   NOT NULL,
   DD_TOP_DESCRIPCION       VARCHAR2(50 CHAR),
   DD_TOP_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION                  INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TOP_TIP_OPER PRIMARY KEY (DD_TOP_ID),
   CONSTRAINT DD_TOP_CODIGO_UK UNIQUE (DD_TOP_CODIGO)
);

/*==============================================================*/
/* Table: DD_TAN_TIPO_ANALISIS                                  */
/*==============================================================*/
CREATE TABLE DD_TAN_TIPO_ANALISIS  (
   DD_TAN_ID                NUMBER(16)          NOT NULL,
   DD_TAN_CODIGO            VARCHAR2(20 CHAR)   NOT NULL,
   DD_TAN_DESCRIPCION       VARCHAR2(50 CHAR),
   DD_TAN_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION                  INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TAN_TIPO_ANALISIS PRIMARY KEY (DD_TAN_ID),
   CONSTRAINT DD_TAN_CODIGO_UK UNIQUE (DD_TAN_CODIGO)
);

/*==============================================================*/
/* Table: DD_VAL_VALORACION                                  */
/*==============================================================*/
CREATE TABLE DD_VAL_VALORACION  (
   DD_VAL_ID                NUMBER(16)          NOT NULL,
   DD_VAL_CODIGO            VARCHAR2(20 CHAR)   NOT NULL,
   DD_VAL_DESCRIPCION       VARCHAR2(50 CHAR),
   DD_VAL_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION                  INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_VAL_VALORACION PRIMARY KEY (DD_VAL_ID),
   CONSTRAINT DD_VAL_CODIGO_UK UNIQUE (DD_VAL_CODIGO)
);

/*==============================================================*/
/* Table: DD_IMP_IMPACTO                                  */
/*==============================================================*/
CREATE TABLE DD_IMP_IMPACTO  (
   DD_IMP_ID                NUMBER(16)          NOT NULL,
   DD_IMP_CODIGO            VARCHAR2(20 CHAR)   NOT NULL,
   DD_IMP_DESCRIPCION       VARCHAR2(50 CHAR),
   DD_IMP_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION                  INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_IMP_IMPACTO PRIMARY KEY (DD_IMP_ID),
   CONSTRAINT DD_IMP_CODIGO_UK UNIQUE (DD_IMP_CODIGO)
);

  
  
 

CREATE SEQUENCE S_DD_TIT_TIPO_ITINERARIOS START WITH 1 NOCYCLE CACHE 100;

CREATE TABLE DD_TIT_TIPO_ITINERARIOS
(
  DD_TIT_ID            NUMBER(16)                  NOT NULL,
  DD_TIT_CODIGO            VARCHAR2(50 CHAR)                  NOT NULL,
  DD_TIT_DESCRIPCION        VARCHAR2(50 CHAR),
  DD_TIT_DESCRIPCION_LARGA        VARCHAR2(250 CHAR),
  VERSION           INTEGER                     DEFAULT 0                     NOT NULL,
  USUARIOCREAR      VARCHAR2(10 CHAR)           NOT NULL,
  FECHACREAR        TIMESTAMP(6)                NOT NULL,
  USUARIOMODIFICAR  VARCHAR2(10 CHAR),
  FECHAMODIFICAR    TIMESTAMP(6),
  USUARIOBORRAR     VARCHAR2(10 CHAR),
  FECHABORRAR       TIMESTAMP(6),
  BORRADO           NUMBER(1)                   DEFAULT 0                     NOT NULL
);

CREATE UNIQUE INDEX PK_DD_TIT_TIPO_ITINERARIOS ON DD_TIT_TIPO_ITINERARIOS(DD_TIT_ID);

ALTER TABLE DD_TIT_TIPO_ITINERARIOS ADD (CONSTRAINT PK_DD_TIT_TIPO_ITINERARIOS PRIMARY KEY (DD_TIT_ID));

CREATE UNIQUE INDEX UK_DD_TIT_TIPO_ITINERARIOS ON DD_TIT_TIPO_ITINERARIOS(DD_TIT_CODIGO);

grant references on DD_TIT_TIPO_ITINERARIOS to PFS01, PFS02, PFS03, PFS04;
grant select on DD_TIT_TIPO_ITINERARIOS to PFS01, PFS02, PFS03, PFS04;
grant insert on DD_TIT_TIPO_ITINERARIOS to PFS01, PFS02, PFS03, PFS04;
grant delete on DD_TIT_TIPO_ITINERARIOS to PFS01, PFS02, PFS03, PFS04;
grant update on DD_TIT_TIPO_ITINERARIOS to PFS01, PFS02, PFS03, PFS04;

insert into DD_TIT_TIPO_ITINERARIOS(DD_TIT_ID, DD_TIT_CODIGO, DD_ITI_DESCRIPCION, DD_ITI_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_DD_TIT_TIPO_ITINERARIOS.nextval, 'REC', 'Recuperación', 'Itinerario de recuperación', 'DD', sysdate, 0);

insert into DD_TIT_TIPO_ITINERARIOS(DD_TIT_ID, DD_TIT_CODIGO, DD_ITI_DESCRIPCION, DD_ITI_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_DD_TIT_TIPO_ITINERARIOS.nextval, 'SEG', 'Seguimiento', 'Itinerario de seguimiento', 'DD', sysdate, 0);



-- NUEVA CARGA DE FICHEROS

-- TABLAS DE DICCIONARIOS


/*===============================================================*/
/* Table: DD_FCN_FINALIDAD_CONTRATO	                             */
/*===============================================================*/
CREATE TABLE DD_FCN_FINALIDAD_CONTRATO  (
   DD_FCN_ID            NUMBER(16)                      NOT NULL,
   DD_FCN_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_FCN_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_FCN_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_FCN_FINALIDAD_CONTRATO PRIMARY KEY (DD_FCN_ID),
   CONSTRAINT DD_FCN_CODIGO_UK UNIQUE (DD_FCN_CODIGO)
);

/*==============================================================*/
/* Table: DD_FCN_FINALIDAD_CONTRATO_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_FCN_FINALIDAD_CONTRATO_LG  (
   DD_FCN_ID            NUMBER(16)                      NOT NULL,
   DD_FCN_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_FCN_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_FCN_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_FCN_FIN_CONT_LG PRIMARY KEY (DD_FCN_ID, DD_FCN_LANG)
);


/*===============================================================*/
/* Table: DD_FNO_FINALIDAD_OFICIAL	                             */
/*===============================================================*/
CREATE TABLE DD_FNO_FINALIDAD_OFICIAL  (
   DD_FNO_ID            NUMBER(16)                      NOT NULL,
   DD_FNO_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_FNO_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_FNO_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_FNO_FINALIDAD_OFICIAL PRIMARY KEY (DD_FNO_ID),
   CONSTRAINT DD_FNO_CODIGO_UK UNIQUE (DD_FNO_CODIGO)
);

/*==============================================================*/
/* Table: DD_FNO_FINALIDAD_OFICIAL_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_FNO_FINALIDAD_OFICIAL_LG  (
   DD_FNO_ID            NUMBER(16)                      NOT NULL,
   DD_FNO_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_FNO_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_FNO_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_FNO_FIN_OFI_LG PRIMARY KEY (DD_FNO_ID, DD_FNO_LANG)
);


/*===============================================================*/
/* Table: DD_GCN_GARANTIA_CONTRATO	                             */
/*===============================================================*/
CREATE TABLE DD_GCN_GARANTIA_CONTRATO  (
   DD_GCN_ID            NUMBER(16)                      NOT NULL,
   DD_GCN_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_GCN_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_GCN_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_GCN_GARANTIA_CONTRATO PRIMARY KEY (DD_GCN_ID),
   CONSTRAINT DD_GCN_CODIGO_UK UNIQUE (DD_GCN_CODIGO)
);

/*==============================================================*/
/* Table: DD_GCN_GARANTIA_CONTRATO_LG 		                    */
/*==============================================================*/
CREATE TABLE DD_GCN_GARANTIA_CONTRATO_LG  (
   DD_GCN_ID            NUMBER(16)                      NOT NULL,
   DD_GCN_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_GCN_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_GCN_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_GCN_GARAN_CON_LG PRIMARY KEY (DD_GCN_ID, DD_GCN_LANG)
);


/*===============================================================*/
/* Table: DD_TTE_TIPO_TELEFONO		                             */
/*===============================================================*/
CREATE TABLE DD_TTE_TIPO_TELEFONO  (
   DD_TTE_ID            NUMBER(16)                      NOT NULL,
   DD_TTE_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_TTE_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_TTE_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TTE_TIPO_TELEFONO PRIMARY KEY (DD_TTE_ID),
   CONSTRAINT DD_TTE_CODIGO_UK UNIQUE (DD_TTE_CODIGO)
);

/*==============================================================*/
/* Table: DD_TTE_TIPO_TELEFONO_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_TTE_TIPO_TELEFONO_LG  (
   DD_TTE_ID            NUMBER(16)                      NOT NULL,
   DD_TTE_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_TTE_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_TTE_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TTE_TIPO_TELEFONO_LG PRIMARY KEY (DD_TTE_ID, DD_TTE_LANG)
);


/*===============================================================*/
/* Table: DD_REX_RATING_EXTERNO		                             */
/*===============================================================*/
CREATE TABLE DD_REX_RATING_EXTERNO (
   DD_REX_ID            NUMBER(16)                      NOT NULL,
   DD_REX_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_REX_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_REX_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_REX_RATING_EXTERNO PRIMARY KEY (DD_REX_ID),
   CONSTRAINT DD_REX_CODIGO_UK UNIQUE (DD_REX_CODIGO)
);

/*==============================================================*/
/* Table: DD_REX_RATING_EXTERNO_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_REX_RATING_EXTERNO_LG  (
   DD_REX_ID            NUMBER(16)                      NOT NULL,
   DD_REX_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_REX_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_REX_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_REX_RATING_EXTERNO_LG PRIMARY KEY (DD_REX_ID, DD_REX_LANG)
);


/*===============================================================*/
/* Table: DD_RAX_RATING_AUXILIAR		                             */
/*===============================================================*/
CREATE TABLE DD_RAX_RATING_AUXILIAR  (
   DD_RAX_ID            NUMBER(16)                      NOT NULL,
   DD_RAX_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_RAX_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_RAX_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_RAX_RATING_AUXILIAR PRIMARY KEY (DD_RAX_ID),
   CONSTRAINT DD_RAX_CODIGO_UK UNIQUE (DD_RAX_CODIGO)
);

/*==============================================================*/
/* Table: DD_RAX_RATING_AUXILIAR_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_RAX_RATING_AUXILIAR_LG  (
   DD_RAX_ID            NUMBER(16)                      NOT NULL,
   DD_RAX_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_RAX_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_RAX_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_RAX_RATING_AUXILIAR_LG PRIMARY KEY (DD_RAX_ID, DD_RAX_LANG)
);


/*===============================================================*/
/* Table: DD_GGE_GRUPO_GESTOR		                             */
/*===============================================================*/
CREATE TABLE DD_GGE_GRUPO_GESTOR  (
   DD_GGE_ID            NUMBER(16)                      NOT NULL,
   DD_GGE_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_GGE_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_GGE_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_GGE_GRUPO_GESTOR PRIMARY KEY (DD_GGE_ID),
   CONSTRAINT DD_GGE_CODIGO_UK UNIQUE (DD_GGE_CODIGO)
);

/*==============================================================*/
/* Table: DD_GGE_GRUPO_GESTOR_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_GGE_GRUPO_GESTOR_LG  (
   DD_GGE_ID            NUMBER(16)                      NOT NULL,
   DD_GGE_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_GGE_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_GGE_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_GGE_GRUPO_GESTOR_LG PRIMARY KEY (DD_GGE_ID, DD_GGE_LANG)
);



/*===============================================================*/
/* Table: DD_MX3_MOVIMIENTO_EXTRA_3		                             */
/*===============================================================*/
CREATE TABLE DD_MX3_MOVIMIENTO_EXTRA_3  (
   DD_MX3_ID            NUMBER(16)                      NOT NULL,
   DD_MX3_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_MX3_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_MX3_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_MX3_MOVIMIENTO_EXTRA_3 PRIMARY KEY (DD_MX3_ID),
   CONSTRAINT DD_MX3_CODIGO_UK UNIQUE (DD_MX3_CODIGO)
);

/*==============================================================*/
/* Table: DD_MX3_MOVIMIENTO_EXTRA_3_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_MX3_MOVIMIENTO_EXTRA_3_LG  (
   DD_MX3_ID            NUMBER(16)                      NOT NULL,
   DD_MX3_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_MX3_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_MX3_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_MX3_MOVIM_EXTRA_3_LG PRIMARY KEY (DD_MX3_ID, DD_MX3_LANG)
);


/*===============================================================*/
/* Table: DD_MX4_MOVIMIENTO_EXTRA_4		                             */
/*===============================================================*/
CREATE TABLE DD_MX4_MOVIMIENTO_EXTRA_4  (
   DD_MX4_ID            NUMBER(16)                      NOT NULL,
   DD_MX4_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_MX4_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_MX4_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_MX4_MOVIMENTO_EXTRA_4 PRIMARY KEY (DD_MX4_ID),
   CONSTRAINT DD_MX4_CODIGO_UK UNIQUE (DD_MX4_CODIGO)
);

/*==============================================================*/
/* Table: DD_MX4_MOVIMIENTO_EXTRA_4_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_MX4_MOVIMIENTO_EXTRA_4_LG  (
   DD_MX4_ID            NUMBER(16)                      NOT NULL,
   DD_MX4_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_MX4_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_MX4_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_MX4_MOVIM_EXTRA_4_LG PRIMARY KEY (DD_MX4_ID, DD_MX4_LANG)
);




/*===============================================================*/
/* Table: DD_SEX_SEXOS		                             */
/*===============================================================*/
CREATE TABLE DD_SEX_SEXOS  (
   DD_SEX_ID            NUMBER(16)                      NOT NULL,
   DD_SEX_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_SEX_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_SEX_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_SEX_SEXOS PRIMARY KEY (DD_SEX_ID),
   CONSTRAINT DD_SEX_CODIGO_UK UNIQUE (DD_SEX_CODIGO)
);

/*==============================================================*/
/* Table: DD_SEX_SEXOS_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_SEX_SEXOS_LG  (
   DD_SEX_ID            NUMBER(16)                      NOT NULL,
   DD_SEX_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_SEX_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_SEX_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_SEX_SEXOS_LG PRIMARY KEY (DD_SEX_ID, DD_SEX_LANG)
);


/*===============================================================*/
/* Table: DD_POL_POLITICAS		                             */
/*===============================================================*/
CREATE TABLE DD_POL_POLITICAS  (
   DD_POL_ID            NUMBER(16)                      NOT NULL,
   DD_POL_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_POL_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_POL_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_POL_POLITICAS PRIMARY KEY (DD_POL_ID),
   CONSTRAINT DD_POL_CODIGO_UK UNIQUE (DD_POL_CODIGO)
);

/*==============================================================*/
/* Table: DD_POL_POLITICAS_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_POL_POLITICAS_LG  (
   DD_POL_ID            NUMBER(16)                      NOT NULL,
   DD_POL_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_POL_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_POL_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_POL_POLITICAS_LG PRIMARY KEY (DD_POL_ID, DD_POL_LANG)
);


/*===============================================================*/
/* Table: DD_PX3_PERSONA_EXTRA_3		                             */
/*===============================================================*/
CREATE TABLE DD_PX3_PERSONA_EXTRA_3  (
   DD_PX3_ID            NUMBER(16)                      NOT NULL,
   DD_PX3_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_PX3_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_PX3_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_PX3_PERSONA_EXTRA_3 PRIMARY KEY (DD_PX3_ID),
   CONSTRAINT DD_PX3_CODIGO_UK UNIQUE (DD_PX3_CODIGO)
);

/*==============================================================*/
/* Table: DD_PX3_PERSONA_EXTRA_3_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_PX3_PERSONA_EXTRA_3_LG  (
   DD_PX3_ID            NUMBER(16)                      NOT NULL,
   DD_PX3_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_PX3_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_PX3_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_PX3_PER_EXTRA_3_LG PRIMARY KEY (DD_PX3_ID, DD_PX3_LANG)
);



/*===============================================================*/
/* Table: DD_PX4_PERSONA_EXTRA_4		                             */
/*===============================================================*/
CREATE TABLE DD_PX4_PERSONA_EXTRA_4  (
   DD_PX4_ID            NUMBER(16)                      NOT NULL,
   DD_PX4_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_PX4_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_PX4_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_PX4_PERSONA_EXTRA_4 PRIMARY KEY (DD_PX4_ID),
   CONSTRAINT DD_PX4_CODIGO_UK UNIQUE (DD_PX4_CODIGO)
);

/*==============================================================*/
/* Table: DD_PX4_PERSONA_EXTRA_4_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_PX4_PERSONA_EXTRA_4_LG  (
   DD_PX4_ID            NUMBER(16)                      NOT NULL,
   DD_PX4_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_PX4_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_PX4_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_PX4_PER_EXTRA_4_LG PRIMARY KEY (DD_PX4_ID, DD_PX4_LANG)
);

-- FIN TABLAS DE DICCIONARIOS


-- GRANTS 

grant references on DD_EPR_ESTADO_PROCEDIMIENTO to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_EPR_ESTADO_PROCEDIMIENTO to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_EPR_ESTADO_PROCEDIMIENTO to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_EPR_ESTADO_PROCEDIMIENTO to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_EPR_ESTADO_PROCEDIMIENTO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_FCN_FINALIDAD_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 
grant select on     DD_FCN_FINALIDAD_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 
grant insert on     DD_FCN_FINALIDAD_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 
grant delete on     DD_FCN_FINALIDAD_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 
grant update on     DD_FCN_FINALIDAD_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 

grant references on DD_FCN_FINALIDAD_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 
grant select on     DD_FCN_FINALIDAD_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 
grant insert on     DD_FCN_FINALIDAD_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 
grant delete on     DD_FCN_FINALIDAD_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 
grant update on     DD_FCN_FINALIDAD_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 

grant references on DD_FNO_FINALIDAD_OFICIAL  to pfs01, pfs02, pfs03, pfs04; 
grant select on     DD_FNO_FINALIDAD_OFICIAL  to pfs01, pfs02, pfs03, pfs04; 
grant insert on     DD_FNO_FINALIDAD_OFICIAL  to pfs01, pfs02, pfs03, pfs04; 
grant delete on     DD_FNO_FINALIDAD_OFICIAL  to pfs01, pfs02, pfs03, pfs04; 
grant update on     DD_FNO_FINALIDAD_OFICIAL  to pfs01, pfs02, pfs03, pfs04; 

grant references on DD_FNO_FINALIDAD_OFICIAL_LG  to pfs01, pfs02, pfs03, pfs04; 
grant select on     DD_FNO_FINALIDAD_OFICIAL_LG  to pfs01, pfs02, pfs03, pfs04; 
grant insert on     DD_FNO_FINALIDAD_OFICIAL_LG  to pfs01, pfs02, pfs03, pfs04; 
grant delete on     DD_FNO_FINALIDAD_OFICIAL_LG  to pfs01, pfs02, pfs03, pfs04; 
grant update on     DD_FNO_FINALIDAD_OFICIAL_LG  to pfs01, pfs02, pfs03, pfs04; 

grant references on DD_GCN_GARANTIA_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 
grant select on     DD_GCN_GARANTIA_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 
grant insert on     DD_GCN_GARANTIA_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 
grant delete on     DD_GCN_GARANTIA_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 
grant update on     DD_GCN_GARANTIA_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 

grant references on DD_GCN_GARANTIA_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 
grant select on     DD_GCN_GARANTIA_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 
grant insert on     DD_GCN_GARANTIA_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 
grant delete on     DD_GCN_GARANTIA_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 
grant update on     DD_GCN_GARANTIA_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 

grant references on DD_CT1_CATALOGO_1  to pfs01, pfs02, pfs03, pfs04; 
grant select on     DD_CT1_CATALOGO_1  to pfs01, pfs02, pfs03, pfs04; 
grant insert on     DD_CT1_CATALOGO_1  to pfs01, pfs02, pfs03, pfs04; 
grant delete on     DD_CT1_CATALOGO_1  to pfs01, pfs02, pfs03, pfs04; 
grant update on     DD_CT1_CATALOGO_1  to pfs01, pfs02, pfs03, pfs04; 

grant references on DD_CT1_CATALOGO_1_LG  to pfs01, pfs02, pfs03, pfs04; 
grant select on     DD_CT1_CATALOGO_1_LG  to pfs01, pfs02, pfs03, pfs04; 
grant insert on     DD_CT1_CATALOGO_1_LG  to pfs01, pfs02, pfs03, pfs04; 
grant delete on     DD_CT1_CATALOGO_1_LG  to pfs01, pfs02, pfs03, pfs04; 
grant update on     DD_CT1_CATALOGO_1_LG  to pfs01, pfs02, pfs03, pfs04; 

grant references on DD_CT2_CATALOGO_2  to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT2_CATALOGO_2  to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT2_CATALOGO_2  to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT2_CATALOGO_2  to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT2_CATALOGO_2  to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CT2_CATALOGO_2_LG  to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT2_CATALOGO_2_LG  to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT2_CATALOGO_2_LG  to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT2_CATALOGO_2_LG  to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT2_CATALOGO_2_LG  to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CT3_CATALOGO_3  to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT3_CATALOGO_3  to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT3_CATALOGO_3  to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT3_CATALOGO_3  to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT3_CATALOGO_3  to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CT3_CATALOGO_3_LG  to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT3_CATALOGO_3_LG  to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT3_CATALOGO_3_LG  to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT3_CATALOGO_3_LG  to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT3_CATALOGO_3_LG  to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CT4_CATALOGO_4  to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT4_CATALOGO_4  to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT4_CATALOGO_4  to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT4_CATALOGO_4  to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT4_CATALOGO_4  to pfs01, pfs02, pfs03, pfs04;


grant references on DD_CT4_CATALOGO_4_LG  to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT4_CATALOGO_4_LG  to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT4_CATALOGO_4_LG  to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT4_CATALOGO_4_LG  to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT4_CATALOGO_4_LG  to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CT5_CATALOGO_5 to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT5_CATALOGO_5 to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT5_CATALOGO_5 to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT5_CATALOGO_5 to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT5_CATALOGO_5 to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CT5_CATALOGO_5_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT5_CATALOGO_5_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT5_CATALOGO_5_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT5_CATALOGO_5_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT5_CATALOGO_5_LG to pfs01, pfs02, pfs03, pfs04;


grant references on DD_CT6_CATALOGO_6 to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT6_CATALOGO_6 to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT6_CATALOGO_6 to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT6_CATALOGO_6 to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT6_CATALOGO_6 to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CT6_CATALOGO_6_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT6_CATALOGO_6_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT6_CATALOGO_6_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT6_CATALOGO_6_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT6_CATALOGO_6_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TTE_TIPO_TELEFONO to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_TTE_TIPO_TELEFONO to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_TTE_TIPO_TELEFONO to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_TTE_TIPO_TELEFONO to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_TTE_TIPO_TELEFONO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TTE_TIPO_TELEFONO_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_TTE_TIPO_TELEFONO_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_TTE_TIPO_TELEFONO_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_TTE_TIPO_TELEFONO_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_TTE_TIPO_TELEFONO_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_REX_RATING_EXTERNO to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_REX_RATING_EXTERNO to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_REX_RATING_EXTERNO to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_REX_RATING_EXTERNO to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_REX_RATING_EXTERNO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_REX_RATING_EXTERNO_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_REX_RATING_EXTERNO_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_REX_RATING_EXTERNO_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_REX_RATING_EXTERNO_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_REX_RATING_EXTERNO_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_RAX_RATING_AUXILIAR to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_RAX_RATING_AUXILIAR to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_RAX_RATING_AUXILIAR to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_RAX_RATING_AUXILIAR to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_RAX_RATING_AUXILIAR to pfs01, pfs02, pfs03, pfs04;

grant references on DD_RAX_RATING_AUXILIAR_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_RAX_RATING_AUXILIAR_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_RAX_RATING_AUXILIAR_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_RAX_RATING_AUXILIAR_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_RAX_RATING_AUXILIAR_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_GGE_GRUPO_GESTOR to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_GGE_GRUPO_GESTOR to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_GGE_GRUPO_GESTOR to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_GGE_GRUPO_GESTOR to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_GGE_GRUPO_GESTOR to pfs01, pfs02, pfs03, pfs04;

grant references on DD_GGE_GRUPO_GESTOR_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_GGE_GRUPO_GESTOR_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_GGE_GRUPO_GESTOR_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_GGE_GRUPO_GESTOR_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_GGE_GRUPO_GESTOR_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_MX3_MOVIMIENTO_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_MX3_MOVIMIENTO_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_MX3_MOVIMIENTO_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_MX3_MOVIMIENTO_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_MX3_MOVIMIENTO_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;

grant references on DD_MX3_MOVIMIENTO_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_MX3_MOVIMIENTO_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_MX3_MOVIMIENTO_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_MX3_MOVIMIENTO_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_MX3_MOVIMIENTO_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_MX4_MOVIMIENTO_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_MX4_MOVIMIENTO_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_MX4_MOVIMIENTO_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_MX4_MOVIMIENTO_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_MX4_MOVIMIENTO_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;

grant references on DD_MX4_MOVIMIENTO_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_MX4_MOVIMIENTO_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_MX4_MOVIMIENTO_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_MX4_MOVIMIENTO_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_MX4_MOVIMIENTO_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_SEX_SEXOS to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_SEX_SEXOS to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_SEX_SEXOS to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_SEX_SEXOS to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_SEX_SEXOS to pfs01, pfs02, pfs03, pfs04;

grant references on DD_SEX_SEXOS_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_SEX_SEXOS_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_SEX_SEXOS_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_SEX_SEXOS_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_SEX_SEXOS_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_POL_POLITICAS to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_POL_POLITICAS to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_POL_POLITICAS to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_POL_POLITICAS to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_POL_POLITICAS to pfs01, pfs02, pfs03, pfs04;

grant references on DD_POL_POLITICAS_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_POL_POLITICAS_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_POL_POLITICAS_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_POL_POLITICAS_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_POL_POLITICAS_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_PX3_PERSONA_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_PX3_PERSONA_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_PX3_PERSONA_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_PX3_PERSONA_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_PX3_PERSONA_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;

grant references on DD_PX3_PERSONA_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_PX3_PERSONA_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_PX3_PERSONA_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_PX3_PERSONA_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_PX3_PERSONA_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_PX4_PERSONA_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_PX4_PERSONA_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_PX4_PERSONA_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_PX4_PERSONA_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_PX4_PERSONA_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;

grant references on DD_PX4_PERSONA_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_PX4_PERSONA_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_PX4_PERSONA_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_PX4_PERSONA_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_PX4_PERSONA_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;



-- FIN NUEVA CARGA DE FICHEROS

-- ******************************** --
-- ** Para la versión 3.0.0.1.X ** --
-- ******************************** --
-- Actualizado con la revisión 9513


--DD_TAY_TIPO_AYUDA_ACUERDO --Sin codigo UK
--DD_CRC_CLASE_RIESGO_CIRBE --Sin UK ni SEQ
--DD_TMC_TIPO_MONEDA_CIRBE --Sin UK ni SEQ
--DD_TSC_TIPO_SITUAC_CIRBE --Sin UK ni SEQ
--DD_TVC_TIPO_VENC_CIRBE	-- Sin UK ni SEQ
--DD_COC_COD_OPERAC_CIRBE	--Sin UK ni SEQ
--DD_TGC_TIPO_GARANTIA_CIRBE	-- Sin UK ni SEQ
--DD_CIC_CODIGO_ISO_CIRBE  -- Sin UK
--DD_TFI_TIPO_FICHERO -- Sin UK
--DD_TGL_TIPO_GRUPO_CLIENTE  -- Si Uk



INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES (S_FUN_FUNCIONES.nextVal,'MOSTRAR_VR_TAREAS','Mostrar VR en Listado de Tareas','DD', sysdate);

-- AGREGAR ENTIDAD DE INFORMACION: CONTRATO
INSERT INTO DD_EIN_ENTIDAD_INFORMACION (DD_EIN_ID,DD_EIN_CODIGO,DD_EIN_DESCRIPCION,DD_EIN_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (6,'6','Contrato','Contrato','DD',sysdate);
-- AGREGAR ENTIDAD DE INFORMACION: OBJETIVOA
INSERT INTO DD_EIN_ENTIDAD_INFORMACION (DD_EIN_ID,DD_EIN_CODIGO,DD_EIN_DESCRIPCION,DD_EIN_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (7,'7','Objetivo','Objetivo','DD',sysdate);

CREATE SEQUENCE S_DD_TAY_TIP_ACTU_ACUERDO;
CREATE SEQUENCE S_DD_CIC_CODIGO_ISO_CIRBE;
CREATE SEQUENCE S_DD_TFI_TIPO_FICHERO;
CREATE SEQUENCE S_DD_TGL_TIPO_GRUPO_CLIENTE;

/*==============================================================*/
/* Table: DD_TAY_TIPO_AYUDA_ACUERDO                             */
/*==============================================================*/
CREATE TABLE DD_TAY_TIPO_AYUDA_ACUERDO  (
   DD_TAY_ID            NUMBER(16)                      NOT NULL,
   DD_TAY_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_TAY_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_TAY_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TAY_TIPO_AYUDA_ACU PRIMARY KEY (DD_TAY_ID)
);


/*==============================================================*/
/* Table: DD_TAY_TIPO_AYUDA_ACUERDO_LG                       */
/*==============================================================*/
CREATE TABLE DD_TAY_TIPO_AYUDA_ACUERDO_LG  (
   DD_TAY_ID            NUMBER(16)                      NOT NULL,
   DD_TAY_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_TAY_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_TAY_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TAY_TIPO_AYUDA_ACU_LG PRIMARY KEY (DD_TAY_ID, DD_TAY_LANG)
);


/*  TABLAS DD DE CIRBE  */

/*==============================================================*/
/* Table: DD_CRC_CLASE_RIESGO_CIRBE                             */
/*==============================================================*/
CREATE TABLE DD_CRC_CLASE_RIESGO_CIRBE  (
   DD_CRC_ID            NUMBER(16)                      NOT NULL,
   DD_CRC_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_CRC_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_CRC_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CRC_TIPO_RIESGO_CIR PRIMARY KEY (DD_CRC_ID)
);

/*==============================================================*/
/* Table: DD_TMC_TIPO_MONEDA_CIRBE                             */
/*==============================================================*/
CREATE TABLE DD_TMC_TIPO_MONEDA_CIRBE  (
   DD_TMC_ID            NUMBER(16)                      NOT NULL,
   DD_TMC_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_TMC_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_TMC_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TMC_TIPO_MON_CIR PRIMARY KEY (DD_TMC_ID)
);

/*==============================================================*/
/* Table: DD_TSC_TIPO_SITUAC_CIRBE                             */
/*==============================================================*/
CREATE TABLE DD_TSC_TIPO_SITUAC_CIRBE  (
   DD_TSC_ID            NUMBER(16)                      NOT NULL,
   DD_TSC_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_TSC_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_TSC_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TSC_TIPO_SITUAC_CIR PRIMARY KEY (DD_TSC_ID)
);

/*==============================================================*/
/* Table: DD_TVC_TIPO_VENC_CIRBE                                */
/*==============================================================*/
CREATE TABLE DD_TVC_TIPO_VENC_CIRBE  (
   DD_TVC_ID            NUMBER(16)                      NOT NULL,
   DD_TVC_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_TVC_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_TVC_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TVC_TIPO_VENC_CIR PRIMARY KEY (DD_TVC_ID)
);

/*==============================================================*/
/* Table: DD_COC_COD_OPERAC_CIRBE                                */
/*==============================================================*/
CREATE TABLE DD_COC_COD_OPERAC_CIRBE  (
   DD_COC_ID            NUMBER(16)                      NOT NULL,
   DD_COC_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_COC_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_COC_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_COC_OPERAC_CIR PRIMARY KEY (DD_COC_ID)
);

/*==============================================================*/
/* Table: DD_TGC_TIPO_GARANTIA_CIRBE                            */
/*==============================================================*/
CREATE TABLE DD_TGC_TIPO_GARANTIA_CIRBE  (
   DD_TGC_ID            NUMBER(16)                      NOT NULL,
   DD_TGC_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_TGC_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_TGC_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TGC_TIPO_GARANTIA_CIR PRIMARY KEY (DD_TGC_ID)
);

/*==============================================================*/
/* Table: DD_CIC_CODIGO_ISO_CIRBE                            */
/*==============================================================*/
CREATE TABLE DD_CIC_CODIGO_ISO_CIRBE  (
   DD_CIC_ID            NUMBER(16)                      NOT NULL,
   DD_CIC_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_CIC_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_CIC_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CIC_CODIGO_ISO_CIRBE PRIMARY KEY (DD_CIC_ID)
);

/*  FIN TABLAS DD CIRBE  */


/*==============================================================*/
/* Table: DD_TFI_TIPO_FICHERO                            */
/*==============================================================*/
CREATE TABLE DD_TFI_TIPO_FICHERO  (
   DD_TFI_ID            NUMBER(16)                      NOT NULL,
   DD_TFI_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_TFI_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_TFI_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TFI_TIPO_FICHERO PRIMARY KEY (DD_TFI_ID)
);

/*==============================================================*/
/* Table:DD_TGL_TIPO_GRUPO_CLIENTE                              */
/*==============================================================*/
CREATE TABLE DD_TGL_TIPO_GRUPO_CLIENTE  (
   DD_TGL_ID            NUMBER(16)                      NOT NULL,
   DD_TGL_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_TGL_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_TGL_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TGL_TIPO_GRUPO_CLIENTE PRIMARY KEY (DD_TGL_ID)
);


ALTER TABLE DD_SCP_SUBTIPO_COBRO_PAGO
   ADD CONSTRAINT FK_SCP_DD_TCP_ID FOREIGN KEY (DD_TCP_ID)
      REFERENCES DD_TCP_TIPO_COBRO_PAGO (DD_TCP_ID);

--CreaciÃ³n de UNIQUE que faltaban
ALTER TABLE DD_CIM_CAUSAS_IMPAGO
 ADD CONSTRAINT UK_DD_CIM_CAUSAS_IMPAGO
 UNIQUE (DD_CIM_CODIGO);

ALTER TABLE DD_CPR_CAUSA_PRORROGA
 ADD CONSTRAINT UK_DD_CPR_CAUSA_PRORROGA
 UNIQUE (DD_CPR_CODIGO);

ALTER TABLE DD_CTL_CAUSA_EXCLUSION
 ADD CONSTRAINT UK_DD_CTL_CAUSA_EXCLUSION
 UNIQUE (DD_CTL_CODIGO);


grant references on DD_CRA_CRITERIO_ANALISIS to pfs01, pfs02, pfs03, pfs04;
grant select on DD_CRA_CRITERIO_ANALISIS to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_CRA_CRITERIO_ANALISIS to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_CRA_CRITERIO_ANALISIS to pfs01, pfs02, pfs03, pfs04;
grant update on DD_CRA_CRITERIO_ANALISIS to pfs01, pfs02, pfs03, pfs04;
 
grant references on DD_EAS_ESTADO_ASUNTOS to pfs01, pfs02, pfs03, pfs04;
grant select on DD_EAS_ESTADO_ASUNTOS to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_EAS_ESTADO_ASUNTOS to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_EAS_ESTADO_ASUNTOS to pfs01, pfs02, pfs03, pfs04;
grant update on DD_EAS_ESTADO_ASUNTOS to pfs01, pfs02, pfs03, pfs04;

grant references on DD_EPR_ESTADO_PROCEDIMIENTO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_EPR_ESTADO_PROCEDIMIENTO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_EPR_ESTADO_PROCEDIMIENTO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_EPR_ESTADO_PROCEDIMIENTO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_EPR_ESTADO_PROCEDIMIENTO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CIM_CAUSAS_IMPAGO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_CIM_CAUSAS_IMPAGO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_CIM_CAUSAS_IMPAGO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_CIM_CAUSAS_IMPAGO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_CIM_CAUSAS_IMPAGO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CPR_CAUSA_PRORROGA to pfs01, pfs02, pfs03, pfs04;
grant select on DD_CPR_CAUSA_PRORROGA to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_CPR_CAUSA_PRORROGA to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_CPR_CAUSA_PRORROGA to pfs01, pfs02, pfs03, pfs04;
grant update on DD_CPR_CAUSA_PRORROGA to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CTL_CAUSA_EXCLUSION to pfs01, pfs02, pfs03, pfs04;
grant select on DD_CTL_CAUSA_EXCLUSION to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_CTL_CAUSA_EXCLUSION to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_CTL_CAUSA_EXCLUSION to pfs01, pfs02, pfs03, pfs04;
grant update on DD_CTL_CAUSA_EXCLUSION to pfs01, pfs02, pfs03, pfs04;

grant references on DD_DTI_TIPO_INCIDENCIAS to pfs01, pfs02, pfs03, pfs04;
grant select on DD_DTI_TIPO_INCIDENCIAS to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_DTI_TIPO_INCIDENCIAS to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_DTI_TIPO_INCIDENCIAS to pfs01, pfs02, pfs03, pfs04;
grant update on DD_DTI_TIPO_INCIDENCIAS to pfs01, pfs02, pfs03, pfs04;

grant references on DD_ECL_ESTADO_CLIENTE to pfs01, pfs02, pfs03, pfs04;
grant select on DD_ECL_ESTADO_CLIENTE to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_ECL_ESTADO_CLIENTE to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_ECL_ESTADO_CLIENTE to pfs01, pfs02, pfs03, pfs04;
grant update on DD_ECL_ESTADO_CLIENTE to pfs01, pfs02, pfs03, pfs04;

grant references on DD_EEX_ESTADO_EXPEDIENTE to pfs01, pfs02, pfs03, pfs04;
grant select on DD_EEX_ESTADO_EXPEDIENTE to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_EEX_ESTADO_EXPEDIENTE to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_EEX_ESTADO_EXPEDIENTE to pfs01, pfs02, pfs03, pfs04;
grant update on DD_EEX_ESTADO_EXPEDIENTE to pfs01, pfs02, pfs03, pfs04;

grant references on DD_EFC_ESTADO_FINAN_CNT to pfs01, pfs02, pfs03, pfs04;
grant select on DD_EFC_ESTADO_FINAN_CNT to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_EFC_ESTADO_FINAN_CNT to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_EFC_ESTADO_FINAN_CNT to pfs01, pfs02, pfs03, pfs04;
grant update on DD_EFC_ESTADO_FINAN_CNT to pfs01, pfs02, pfs03, pfs04;

grant references on DD_EIN_ENTIDAD_INFORMACION to pfs01, pfs02, pfs03, pfs04;
grant select on DD_EIN_ENTIDAD_INFORMACION to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_EIN_ENTIDAD_INFORMACION to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_EIN_ENTIDAD_INFORMACION to pfs01, pfs02, pfs03, pfs04;
grant update on DD_EIN_ENTIDAD_INFORMACION to pfs01, pfs02, pfs03, pfs04;

grant references on DD_ESC_ESTADO_CNT to pfs01, pfs02, pfs03, pfs04;
grant select on DD_ESC_ESTADO_CNT to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_ESC_ESTADO_CNT to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_ESC_ESTADO_CNT to pfs01, pfs02, pfs03, pfs04;
grant update on DD_ESC_ESTADO_CNT to pfs01, pfs02, pfs03, pfs04;

grant references on DD_EST_ESTADOS_ITINERARIOS to pfs01, pfs02, pfs03, pfs04;
grant select on DD_EST_ESTADOS_ITINERARIOS to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_EST_ESTADOS_ITINERARIOS to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_EST_ESTADOS_ITINERARIOS to pfs01, pfs02, pfs03, pfs04;
grant update on DD_EST_ESTADOS_ITINERARIOS to pfs01, pfs02, pfs03, pfs04;

grant references on DD_FMG_FASES_MAPA_GLOBAL to pfs01, pfs02, pfs03, pfs04;
grant select on DD_FMG_FASES_MAPA_GLOBAL to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_FMG_FASES_MAPA_GLOBAL to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_FMG_FASES_MAPA_GLOBAL to pfs01, pfs02, pfs03, pfs04;
grant update on DD_FMG_FASES_MAPA_GLOBAL to pfs01, pfs02, pfs03, pfs04;

grant references on DD_LOC_LOCALIDAD to pfs01, pfs02, pfs03, pfs04;
grant select on DD_LOC_LOCALIDAD to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_LOC_LOCALIDAD to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_LOC_LOCALIDAD to pfs01, pfs02, pfs03, pfs04;
grant update on DD_LOC_LOCALIDAD to pfs01, pfs02, pfs03, pfs04;


grant references on DD_MON_MONEDAS to pfs01, pfs02, pfs03, pfs04;
grant select on DD_MON_MONEDAS to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_MON_MONEDAS to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_MON_MONEDAS to pfs01, pfs02, pfs03, pfs04;
grant update on DD_MON_MONEDAS to pfs01, pfs02, pfs03, pfs04;


grant references on DD_PRV_PROVINCIA to pfs01, pfs02, pfs03, pfs04;
grant select on DD_PRV_PROVINCIA to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_PRV_PROVINCIA to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_PRV_PROVINCIA to pfs01, pfs02, pfs03, pfs04;
grant update on DD_PRV_PROVINCIA to pfs01, pfs02, pfs03, pfs04;


grant references on DD_RPR_RAZON_PRORROGA to pfs01, pfs02, pfs03, pfs04;
grant select on DD_RPR_RAZON_PRORROGA to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_RPR_RAZON_PRORROGA to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_RPR_RAZON_PRORROGA to pfs01, pfs02, pfs03, pfs04;
grant update on DD_RPR_RAZON_PRORROGA to pfs01, pfs02, pfs03, pfs04;

grant references on DD_SMG_SUBFASES_MAPA_GLOBAL to pfs01, pfs02, pfs03, pfs04;
grant select on DD_SMG_SUBFASES_MAPA_GLOBAL to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_SMG_SUBFASES_MAPA_GLOBAL to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_SMG_SUBFASES_MAPA_GLOBAL to pfs01, pfs02, pfs03, pfs04;
grant update on DD_SMG_SUBFASES_MAPA_GLOBAL to pfs01, pfs02, pfs03, pfs04;

grant references on DD_STA_SUBTIPO_TAREA_BASE to pfs01, pfs02, pfs03, pfs04;
grant select on DD_STA_SUBTIPO_TAREA_BASE to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_STA_SUBTIPO_TAREA_BASE to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_STA_SUBTIPO_TAREA_BASE to pfs01, pfs02, pfs03, pfs04;
grant update on DD_STA_SUBTIPO_TAREA_BASE to pfs01, pfs02, pfs03, pfs04;


grant references on DD_STI_SITUACION to pfs01, pfs02, pfs03, pfs04;
grant select on DD_STI_SITUACION to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_STI_SITUACION to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_STI_SITUACION to pfs01, pfs02, pfs03, pfs04;
grant update on DD_STI_SITUACION to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TAA_TIPO_AYUDA_ACTUACION to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TAA_TIPO_AYUDA_ACTUACION to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TAA_TIPO_AYUDA_ACTUACION to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TAA_TIPO_AYUDA_ACTUACION to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TAA_TIPO_AYUDA_ACTUACION to pfs01, pfs02, pfs03, pfs04;


grant references on DD_TAC_TIPO_ACTUACION to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TAC_TIPO_ACTUACION to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TAC_TIPO_ACTUACION to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TAC_TIPO_ACTUACION to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TAC_TIPO_ACTUACION to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TAR_TIPO_TAREA_BASE to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TAR_TIPO_TAREA_BASE to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TAR_TIPO_TAREA_BASE to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TAR_TIPO_TAREA_BASE to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TAR_TIPO_TAREA_BASE to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TBI_TIPO_BIEN to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TBI_TIPO_BIEN to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TBI_TIPO_BIEN to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TBI_TIPO_BIEN to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TBI_TIPO_BIEN to pfs01, pfs02, pfs03, pfs04;


grant references on DD_TDI_TIPO_DOCUMENTO_ID to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TDI_TIPO_DOCUMENTO_ID to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TDI_TIPO_DOCUMENTO_ID to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TDI_TIPO_DOCUMENTO_ID to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TDI_TIPO_DOCUMENTO_ID to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TGA_TIPO_GARANTIA to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TGA_TIPO_GARANTIA to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TGA_TIPO_GARANTIA to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TGA_TIPO_GARANTIA to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TGA_TIPO_GARANTIA to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TIG_TIPO_INGRESO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TIG_TIPO_INGRESO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TIG_TIPO_INGRESO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TIG_TIPO_INGRESO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TIG_TIPO_INGRESO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TPE_TIPO_PERSONA to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TPE_TIPO_PERSONA to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TPE_TIPO_PERSONA to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TPE_TIPO_PERSONA to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TPE_TIPO_PERSONA to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TPR_TIPO_PRORROGA to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TPR_TIPO_PRORROGA to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TPR_TIPO_PRORROGA to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TPR_TIPO_PRORROGA to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TPR_TIPO_PRORROGA to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TRE_TIPO_RECLAMACION to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TRE_TIPO_RECLAMACION to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TRE_TIPO_RECLAMACION to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TRE_TIPO_RECLAMACION to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TRE_TIPO_RECLAMACION to pfs01, pfs02, pfs03, pfs04;


grant references on DD_TTI_TIPO_TITULO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TTI_TIPO_TITULO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TTI_TIPO_TITULO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TTI_TIPO_TITULO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TTI_TIPO_TITULO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TTG_TIPO_TIT_GEN to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TTG_TIPO_TIT_GEN to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TTG_TIPO_TIT_GEN to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TTG_TIPO_TIT_GEN to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TTG_TIPO_TIT_GEN to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TVI_TIPO_VIA to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TVI_TIPO_VIA to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TVI_TIPO_VIA to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TVI_TIPO_VIA to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TVI_TIPO_VIA to pfs01, pfs02, pfs03, pfs04;

grant references on DD_PRA_PROPUESTA_AAA to pfs01, pfs02, pfs03, pfs04;
grant select on DD_PRA_PROPUESTA_AAA to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_PRA_PROPUESTA_AAA to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_PRA_PROPUESTA_AAA to pfs01, pfs02, pfs03, pfs04;
grant update on DD_PRA_PROPUESTA_AAA to pfs01, pfs02, pfs03, pfs04;


grant references on FUN_FUNCIONES to pfs01, pfs02, pfs03, pfs04;
grant select on FUN_FUNCIONES to pfs01, pfs02, pfs03, pfs04;
grant insert on FUN_FUNCIONES to pfs01, pfs02, pfs03, pfs04;
grant delete on FUN_FUNCIONES to pfs01, pfs02, pfs03, pfs04;
grant update on FUN_FUNCIONES to pfs01, pfs02, pfs03, pfs04;


grant references on USU_USUARIOS to pfs01, pfs02, pfs03, pfs04;
grant select on USU_USUARIOS to pfs01, pfs02, pfs03, pfs04;
grant insert on USU_USUARIOS to pfs01, pfs02, pfs03, pfs04;
grant delete on USU_USUARIOS to pfs01, pfs02, pfs03, pfs04;
grant update on USU_USUARIOS to pfs01, pfs02, pfs03, pfs04;

grant references on DD_MET_MOT_EXC_TELECOBRO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_MET_MOT_EXC_TELECOBRO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_MET_MOT_EXC_TELECOBRO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_MET_MOT_EXC_TELECOBRO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_MET_MOT_EXC_TELECOBRO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_EEM_ESTADO_EMBARGO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_EEM_ESTADO_EMBARGO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_EEM_ESTADO_EMBARGO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_EEM_ESTADO_EMBARGO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_EEM_ESTADO_EMBARGO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_EAN_ESTADO_ANALISIS to pfs01, pfs02, pfs03, pfs04;
grant select on DD_EAN_ESTADO_ANALISIS to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_EAN_ESTADO_ANALISIS to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_EAN_ESTADO_ANALISIS to pfs01, pfs02, pfs03, pfs04;
grant update on DD_EAN_ESTADO_ANALISIS to pfs01, pfs02, pfs03, pfs04;

grant references on ENTIDADCONFIG to pfs01, pfs02, pfs03, pfs04;
grant select on ENTIDADCONFIG to pfs01, pfs02, pfs03, pfs04;

grant references on ENTIDAD to pfs01, pfs02, pfs03, pfs04;
grant select on ENTIDAD to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TRC_TERCEROS to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TRC_TERCEROS to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TRC_TERCEROS to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TRC_TERCEROS to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TRC_TERCEROS to pfs01, pfs02, pfs03, pfs04;

grant references on DD_POS_POSITIVO_NEGATIVO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_POS_POSITIVO_NEGATIVO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_POS_POSITIVO_NEGATIVO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_POS_POSITIVO_NEGATIVO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_POS_POSITIVO_NEGATIVO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_SIN_SINO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_SIN_SINO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_SIN_SINO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_SIN_SINO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_SIN_SINO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_SUS_SUSPENDIDA to pfs01, pfs02, pfs03, pfs04;
grant select on DD_SUS_SUSPENDIDA to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_SUS_SUSPENDIDA to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_SUS_SUSPENDIDA to pfs01, pfs02, pfs03, pfs04;
grant update on DD_SUS_SUSPENDIDA to pfs01, pfs02, pfs03, pfs04;

grant references on DD_FAV_FAVORABLE to pfs01, pfs02, pfs03, pfs04;
grant select on DD_FAV_FAVORABLE to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_FAV_FAVORABLE to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_FAV_FAVORABLE to pfs01, pfs02, pfs03, pfs04;
grant update on DD_FAV_FAVORABLE to pfs01, pfs02, pfs03, pfs04;

grant references on DD_IM1_IMPUGNACION1 to pfs01, pfs02, pfs03, pfs04;
grant select on DD_IM1_IMPUGNACION1 to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_IM1_IMPUGNACION1 to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_IM1_IMPUGNACION1 to pfs01, pfs02, pfs03, pfs04;
grant update on DD_IM1_IMPUGNACION1 to pfs01, pfs02, pfs03, pfs04;

grant references on DD_IM2_IMPUGNACION2 to pfs01, pfs02, pfs03, pfs04;
grant select on DD_IM2_IMPUGNACION2 to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_IM2_IMPUGNACION2 to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_IM2_IMPUGNACION2 to pfs01, pfs02, pfs03, pfs04;
grant update on DD_IM2_IMPUGNACION2 to pfs01, pfs02, pfs03, pfs04;


grant references on DD_PS1_POSTORES1 to pfs01, pfs02, pfs03, pfs04;
grant select on DD_PS1_POSTORES1 to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_PS1_POSTORES1 to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_PS1_POSTORES1 to pfs01, pfs02, pfs03, pfs04;
grant update on DD_PS1_POSTORES1 to pfs01, pfs02, pfs03, pfs04;

grant references on DD_PS2_POSTORES2 to pfs01, pfs02, pfs03, pfs04;
grant select on DD_PS2_POSTORES2 to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_PS2_POSTORES2 to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_PS2_POSTORES2 to pfs01, pfs02, pfs03, pfs04;
grant update on DD_PS2_POSTORES2 to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CDE_CAUSAS_DECISION to pfs01, pfs02, pfs03, pfs04;
grant select on DD_CDE_CAUSAS_DECISION to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_CDE_CAUSAS_DECISION to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_CDE_CAUSAS_DECISION to pfs01, pfs02, pfs03, pfs04;
grant update on DD_CDE_CAUSAS_DECISION to pfs01, pfs02, pfs03, pfs04;

grant references on DD_EDE_ESTADOS_DECISION to pfs01, pfs02, pfs03, pfs04;
grant select on DD_EDE_ESTADOS_DECISION to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_EDE_ESTADOS_DECISION to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_EDE_ESTADOS_DECISION to pfs01, pfs02, pfs03, pfs04;
grant update on DD_EDE_ESTADOS_DECISION to pfs01, pfs02, pfs03, pfs04;

grant references on DD_COM_COMPLETITUD to pfs01, pfs02, pfs03, pfs04;
grant select on DD_COM_COMPLETITUD to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_COM_COMPLETITUD to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_COM_COMPLETITUD to pfs01, pfs02, pfs03, pfs04;
grant update on DD_COM_COMPLETITUD to pfs01, pfs02, pfs03, pfs04;

grant references on DD_COR_CORRECTO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_COR_CORRECTO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_COR_CORRECTO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_COR_CORRECTO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_COR_CORRECTO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CCO_CORRECTO_COBROS to pfs01, pfs02, pfs03, pfs04;
grant select on DD_CCO_CORRECTO_COBROS to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_CCO_CORRECTO_COBROS to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_CCO_CORRECTO_COBROS to pfs01, pfs02, pfs03, pfs04;
grant update on DD_CCO_CORRECTO_COBROS to pfs01, pfs02, pfs03, pfs04;

grant references on DD_ACT_ACTOR to pfs01, pfs02, pfs03, pfs04;
grant select on DD_ACT_ACTOR to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_ACT_ACTOR to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_ACT_ACTOR to pfs01, pfs02, pfs03, pfs04;
grant update on DD_ACT_ACTOR to pfs01, pfs02, pfs03, pfs04;

grant references on DD_DTR_TIPO_RECURSO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_DTR_TIPO_RECURSO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_DTR_TIPO_RECURSO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_DTR_TIPO_RECURSO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_DTR_TIPO_RECURSO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CRE_CAUSA_RECURSO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_CRE_CAUSA_RECURSO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_CRE_CAUSA_RECURSO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_CRE_CAUSA_RECURSO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_CRE_CAUSA_RECURSO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_DRR_RESULTADO_RESOL to pfs01, pfs02, pfs03, pfs04;
grant select on DD_DRR_RESULTADO_RESOL to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_DRR_RESULTADO_RESOL to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_DRR_RESULTADO_RESOL to pfs01, pfs02, pfs03, pfs04;
grant update on DD_DRR_RESULTADO_RESOL to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TCA_TIPOS_CARGAS to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TCA_TIPOS_CARGAS to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TCA_TIPOS_CARGAS to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TCA_TIPOS_CARGAS to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TCA_TIPOS_CARGAS to pfs01, pfs02, pfs03, pfs04;

grant references on DD_DCA_DEMANDANTES_CARGAS to pfs01, pfs02, pfs03, pfs04;
grant select on DD_DCA_DEMANDANTES_CARGAS to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_DCA_DEMANDANTES_CARGAS to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_DCA_DEMANDANTES_CARGAS to pfs01, pfs02, pfs03, pfs04;
grant update on DD_DCA_DEMANDANTES_CARGAS to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TPA_TIPO_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TPA_TIPO_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TPA_TIPO_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TPA_TIPO_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TPA_TIPO_ACUERDO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_APE_PERIODICIDAD_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_APE_PERIODICIDAD_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_APE_PERIODICIDAD_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_APE_PERIODICIDAD_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_APE_PERIODICIDAD_ACUERDO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_SOL_SOLICITANTE to pfs01, pfs02, pfs03, pfs04;
grant select on DD_SOL_SOLICITANTE to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_SOL_SOLICITANTE to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_SOL_SOLICITANTE to pfs01, pfs02, pfs03, pfs04;
grant update on DD_SOL_SOLICITANTE to pfs01, pfs02, pfs03, pfs04;

grant references on DD_EAC_ESTADO_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_EAC_ESTADO_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_EAC_ESTADO_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_EAC_ESTADO_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_EAC_ESTADO_ACUERDO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_ATA_TIP_ACTUA_ACUE to pfs01, pfs02, pfs03, pfs04;
grant select on DD_ATA_TIP_ACTUA_ACUE to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_ATA_TIP_ACTUA_ACUE to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_ATA_TIP_ACTUA_ACUE to pfs01, pfs02, pfs03, pfs04;
grant update on DD_ATA_TIP_ACTUA_ACUE to pfs01, pfs02, pfs03, pfs04;

grant references on DD_RAA_RESULTADO_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_RAA_RESULTADO_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_RAA_RESULTADO_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_RAA_RESULTADO_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_RAA_RESULTADO_ACUERDO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_ACT_CONCLUSION_TITULO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_ACT_CONCLUSION_TITULO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_ACT_CONCLUSION_TITULO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_ACT_CONCLUSION_TITULO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_ACT_CONCLUSION_TITULO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_ACC_CAPACIDAD_PAGO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_ACC_CAPACIDAD_PAGO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_ACC_CAPACIDAD_PAGO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_ACC_CAPACIDAD_PAGO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_ACC_CAPACIDAD_PAGO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_ACS_CAMBIO_SOLVENCIA to pfs01, pfs02, pfs03, pfs04;
grant select on DD_ACS_CAMBIO_SOLVENCIA to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_ACS_CAMBIO_SOLVENCIA to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_ACS_CAMBIO_SOLVENCIA to pfs01, pfs02, pfs03, pfs04;
grant update on DD_ACS_CAMBIO_SOLVENCIA to pfs01, pfs02, pfs03, pfs04;

grant references on DD_VAA_VALORA_ACTU_AMIST to pfs01, pfs02, pfs03, pfs04;
grant select on DD_VAA_VALORA_ACTU_AMIST to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_VAA_VALORA_ACTU_AMIST to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_VAA_VALORA_ACTU_AMIST to pfs01, pfs02, pfs03, pfs04;
grant update on DD_VAA_VALORA_ACTU_AMIST to pfs01, pfs02, pfs03, pfs04;

grant references on DD_ATP_ACUERDO_TIPO_PAGO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_ATP_ACUERDO_TIPO_PAGO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_ATP_ACUERDO_TIPO_PAGO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_ATP_ACUERDO_TIPO_PAGO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_ATP_ACUERDO_TIPO_PAGO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_ECP_ESTADO_COBRO_PAGO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_ECP_ESTADO_COBRO_PAGO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_ECP_ESTADO_COBRO_PAGO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_ECP_ESTADO_COBRO_PAGO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_ECP_ESTADO_COBRO_PAGO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TCP_TIPO_COBRO_PAGO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TCP_TIPO_COBRO_PAGO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TCP_TIPO_COBRO_PAGO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TCP_TIPO_COBRO_PAGO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TCP_TIPO_COBRO_PAGO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_SCP_SUBTIPO_COBRO_PAGO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_SCP_SUBTIPO_COBRO_PAGO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_SCP_SUBTIPO_COBRO_PAGO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_SCP_SUBTIPO_COBRO_PAGO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_SCP_SUBTIPO_COBRO_PAGO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_MEX_MOTIVOS_EXP_MANUAL to pfs01, pfs02, pfs03, pfs04;
grant select on DD_MEX_MOTIVOS_EXP_MANUAL to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_MEX_MOTIVOS_EXP_MANUAL to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_MEX_MOTIVOS_EXP_MANUAL to pfs01, pfs02, pfs03, pfs04;
grant update on DD_MEX_MOTIVOS_EXP_MANUAL to pfs01, pfs02, pfs03, pfs04;


grant references on DD_TAY_TIPO_AYUDA_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TAY_TIPO_AYUDA_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TAY_TIPO_AYUDA_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TAY_TIPO_AYUDA_ACUERDO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TAY_TIPO_AYUDA_ACUERDO to pfs01, pfs02, pfs03, pfs04;


/* necesitamos permisos en deferedevents para los usuarios entidad porque se inyecta el entityTransactionManager en eventManager*/
grant all on deferedevent to pfs01, pfs02, pfs03, pfs04;

grant all on hibernate_sequence to pfs01, pfs02, pfs03, pfs04;

grant all on JBPM_ACTION to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_BYTEARRAY to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_BYTEBLOCK to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_COMMENT to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_DECISIONCONDITIONS to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_DELEGATION to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_EVENT to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_EXCEPTIONHANDLER to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_ID_GROUP to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_ID_MEMBERSHIP to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_ID_PERMISSIONS to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_ID_USER to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_JOB to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_LOG to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_MODULEDEFINITION to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_MODULEINSTANCE to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_NODE to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_POOLEDACTOR to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_PROCESSDEFINITION to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_PROCESSINSTANCE to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_RUNTIMEACTION to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_SWIMLANE to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_SWIMLANEINSTANCE to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_TASK to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_TASKACTORPOOL to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_TASKCONTROLLER to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_TASKINSTANCE to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_TOKEN to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_TOKENVARIABLEMAP to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_TRANSITION to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_VARIABLEACCESS to pfs01, pfs02, pfs03, pfs04;
grant all on JBPM_VARIABLEINSTANCE to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CRC_CLASE_RIESGO_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant select on DD_CRC_CLASE_RIESGO_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_CRC_CLASE_RIESGO_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_CRC_CLASE_RIESGO_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant update on DD_CRC_CLASE_RIESGO_CIRBE to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TMC_TIPO_MONEDA_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TMC_TIPO_MONEDA_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TMC_TIPO_MONEDA_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TMC_TIPO_MONEDA_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TMC_TIPO_MONEDA_CIRBE to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TSC_TIPO_SITUAC_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TSC_TIPO_SITUAC_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TSC_TIPO_SITUAC_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TSC_TIPO_SITUAC_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TSC_TIPO_SITUAC_CIRBE to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TVC_TIPO_VENC_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TVC_TIPO_VENC_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TVC_TIPO_VENC_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TVC_TIPO_VENC_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TVC_TIPO_VENC_CIRBE to pfs01, pfs02, pfs03, pfs04;

grant references on DD_COC_COD_OPERAC_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant select on DD_COC_COD_OPERAC_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_COC_COD_OPERAC_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_COC_COD_OPERAC_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant update on DD_COC_COD_OPERAC_CIRBE to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TGC_TIPO_GARANTIA_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TGC_TIPO_GARANTIA_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TGC_TIPO_GARANTIA_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TGC_TIPO_GARANTIA_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TGC_TIPO_GARANTIA_CIRBE to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CIC_CODIGO_ISO_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant select on DD_CIC_CODIGO_ISO_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_CIC_CODIGO_ISO_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_CIC_CODIGO_ISO_CIRBE to pfs01, pfs02, pfs03, pfs04;
grant update on DD_CIC_CODIGO_ISO_CIRBE to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TFI_TIPO_FICHERO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TFI_TIPO_FICHERO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TFI_TIPO_FICHERO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TFI_TIPO_FICHERO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TFI_TIPO_FICHERO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TGL_TIPO_GRUPO_CLIENTE to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TGL_TIPO_GRUPO_CLIENTE to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TGL_TIPO_GRUPO_CLIENTE to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TGL_TIPO_GRUPO_CLIENTE to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TGL_TIPO_GRUPO_CLIENTE to pfs01, pfs02, pfs03, pfs04;

grant references on DD_EPR_ESTADO_PROCEDIMIENTO to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_EPR_ESTADO_PROCEDIMIENTO to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_EPR_ESTADO_PROCEDIMIENTO to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_EPR_ESTADO_PROCEDIMIENTO to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_EPR_ESTADO_PROCEDIMIENTO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_FCN_FINALIDAD_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 
grant select on     DD_FCN_FINALIDAD_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 
grant insert on     DD_FCN_FINALIDAD_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 
grant delete on     DD_FCN_FINALIDAD_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 
grant update on     DD_FCN_FINALIDAD_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 

grant references on DD_FCN_FINALIDAD_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 
grant select on     DD_FCN_FINALIDAD_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 
grant insert on     DD_FCN_FINALIDAD_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 
grant delete on     DD_FCN_FINALIDAD_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 
grant update on     DD_FCN_FINALIDAD_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 

grant references on DD_FNO_FINALIDAD_OFICIAL  to pfs01, pfs02, pfs03, pfs04; 
grant select on     DD_FNO_FINALIDAD_OFICIAL  to pfs01, pfs02, pfs03, pfs04; 
grant insert on     DD_FNO_FINALIDAD_OFICIAL  to pfs01, pfs02, pfs03, pfs04; 
grant delete on     DD_FNO_FINALIDAD_OFICIAL  to pfs01, pfs02, pfs03, pfs04; 
grant update on     DD_FNO_FINALIDAD_OFICIAL  to pfs01, pfs02, pfs03, pfs04; 

grant references on DD_FNO_FINALIDAD_OFICIAL_LG  to pfs01, pfs02, pfs03, pfs04; 
grant select on     DD_FNO_FINALIDAD_OFICIAL_LG  to pfs01, pfs02, pfs03, pfs04; 
grant insert on     DD_FNO_FINALIDAD_OFICIAL_LG  to pfs01, pfs02, pfs03, pfs04; 
grant delete on     DD_FNO_FINALIDAD_OFICIAL_LG  to pfs01, pfs02, pfs03, pfs04; 
grant update on     DD_FNO_FINALIDAD_OFICIAL_LG  to pfs01, pfs02, pfs03, pfs04; 

grant references on DD_GCN_GARANTIA_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 
grant select on     DD_GCN_GARANTIA_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 
grant insert on     DD_GCN_GARANTIA_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 
grant delete on     DD_GCN_GARANTIA_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 
grant update on     DD_GCN_GARANTIA_CONTRATO  to pfs01, pfs02, pfs03, pfs04; 

grant references on DD_GCN_GARANTIA_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 
grant select on     DD_GCN_GARANTIA_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 
grant insert on     DD_GCN_GARANTIA_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 
grant delete on     DD_GCN_GARANTIA_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 
grant update on     DD_GCN_GARANTIA_CONTRATO_LG  to pfs01, pfs02, pfs03, pfs04; 

grant references on DD_CT1_CATALOGO_1  to pfs01, pfs02, pfs03, pfs04; 
grant select on     DD_CT1_CATALOGO_1  to pfs01, pfs02, pfs03, pfs04; 
grant insert on     DD_CT1_CATALOGO_1  to pfs01, pfs02, pfs03, pfs04; 
grant delete on     DD_CT1_CATALOGO_1  to pfs01, pfs02, pfs03, pfs04; 
grant update on     DD_CT1_CATALOGO_1  to pfs01, pfs02, pfs03, pfs04; 

grant references on DD_CT1_CATALOGO_1_LG  to pfs01, pfs02, pfs03, pfs04; 
grant select on     DD_CT1_CATALOGO_1_LG  to pfs01, pfs02, pfs03, pfs04; 
grant insert on     DD_CT1_CATALOGO_1_LG  to pfs01, pfs02, pfs03, pfs04; 
grant delete on     DD_CT1_CATALOGO_1_LG  to pfs01, pfs02, pfs03, pfs04; 
grant update on     DD_CT1_CATALOGO_1_LG  to pfs01, pfs02, pfs03, pfs04; 

grant references on DD_CT2_CATALOGO_2  to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT2_CATALOGO_2  to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT2_CATALOGO_2  to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT2_CATALOGO_2  to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT2_CATALOGO_2  to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CT2_CATALOGO_2_LG  to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT2_CATALOGO_2_LG  to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT2_CATALOGO_2_LG  to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT2_CATALOGO_2_LG  to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT2_CATALOGO_2_LG  to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CT3_CATALOGO_3  to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT3_CATALOGO_3  to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT3_CATALOGO_3  to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT3_CATALOGO_3  to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT3_CATALOGO_3  to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CT3_CATALOGO_3_LG  to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT3_CATALOGO_3_LG  to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT3_CATALOGO_3_LG  to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT3_CATALOGO_3_LG  to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT3_CATALOGO_3_LG  to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CT4_CATALOGO_4  to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT4_CATALOGO_4  to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT4_CATALOGO_4  to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT4_CATALOGO_4  to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT4_CATALOGO_4  to pfs01, pfs02, pfs03, pfs04;


grant references on DD_CT4_CATALOGO_4_LG  to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT4_CATALOGO_4_LG  to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT4_CATALOGO_4_LG  to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT4_CATALOGO_4_LG  to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT4_CATALOGO_4_LG  to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CT5_CATALOGO_5 to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT5_CATALOGO_5 to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT5_CATALOGO_5 to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT5_CATALOGO_5 to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT5_CATALOGO_5 to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CT5_CATALOGO_5_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT5_CATALOGO_5_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT5_CATALOGO_5_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT5_CATALOGO_5_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT5_CATALOGO_5_LG to pfs01, pfs02, pfs03, pfs04;


grant references on DD_CT6_CATALOGO_6 to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT6_CATALOGO_6 to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT6_CATALOGO_6 to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT6_CATALOGO_6 to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT6_CATALOGO_6 to pfs01, pfs02, pfs03, pfs04;

grant references on DD_CT6_CATALOGO_6_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_CT6_CATALOGO_6_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_CT6_CATALOGO_6_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_CT6_CATALOGO_6_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_CT6_CATALOGO_6_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TTE_TIPO_TELEFONO to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_TTE_TIPO_TELEFONO to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_TTE_TIPO_TELEFONO to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_TTE_TIPO_TELEFONO to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_TTE_TIPO_TELEFONO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TTE_TIPO_TELEFONO_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_TTE_TIPO_TELEFONO_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_TTE_TIPO_TELEFONO_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_TTE_TIPO_TELEFONO_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_TTE_TIPO_TELEFONO_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_REX_RATING_EXTERNO to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_REX_RATING_EXTERNO to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_REX_RATING_EXTERNO to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_REX_RATING_EXTERNO to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_REX_RATING_EXTERNO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_REX_RATING_EXTERNO_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_REX_RATING_EXTERNO_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_REX_RATING_EXTERNO_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_REX_RATING_EXTERNO_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_REX_RATING_EXTERNO_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_RAX_RATING_AUXILIAR to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_RAX_RATING_AUXILIAR to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_RAX_RATING_AUXILIAR to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_RAX_RATING_AUXILIAR to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_RAX_RATING_AUXILIAR to pfs01, pfs02, pfs03, pfs04;

grant references on DD_RAX_RATING_AUXILIAR_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_RAX_RATING_AUXILIAR_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_RAX_RATING_AUXILIAR_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_RAX_RATING_AUXILIAR_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_RAX_RATING_AUXILIAR_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_GGE_GRUPO_GESTOR to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_GGE_GRUPO_GESTOR to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_GGE_GRUPO_GESTOR to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_GGE_GRUPO_GESTOR to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_GGE_GRUPO_GESTOR to pfs01, pfs02, pfs03, pfs04;

grant references on DD_GGE_GRUPO_GESTOR_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_GGE_GRUPO_GESTOR_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_GGE_GRUPO_GESTOR_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_GGE_GRUPO_GESTOR_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_GGE_GRUPO_GESTOR_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_MX3_MOVIMIENTO_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_MX3_MOVIMIENTO_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_MX3_MOVIMIENTO_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_MX3_MOVIMIENTO_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_MX3_MOVIMIENTO_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;

grant references on DD_MX3_MOVIMIENTO_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_MX3_MOVIMIENTO_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_MX3_MOVIMIENTO_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_MX3_MOVIMIENTO_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_MX3_MOVIMIENTO_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_MX4_MOVIMIENTO_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_MX4_MOVIMIENTO_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_MX4_MOVIMIENTO_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_MX4_MOVIMIENTO_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_MX4_MOVIMIENTO_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;

grant references on DD_MX4_MOVIMIENTO_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_MX4_MOVIMIENTO_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_MX4_MOVIMIENTO_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_MX4_MOVIMIENTO_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_MX4_MOVIMIENTO_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_SEX_SEXOS to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_SEX_SEXOS to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_SEX_SEXOS to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_SEX_SEXOS to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_SEX_SEXOS to pfs01, pfs02, pfs03, pfs04;

grant references on DD_SEX_SEXOS_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_SEX_SEXOS_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_SEX_SEXOS_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_SEX_SEXOS_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_SEX_SEXOS_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_POL_POLITICAS to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_POL_POLITICAS to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_POL_POLITICAS to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_POL_POLITICAS to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_POL_POLITICAS to pfs01, pfs02, pfs03, pfs04;

grant references on DD_POL_POLITICAS_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_POL_POLITICAS_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_POL_POLITICAS_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_POL_POLITICAS_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_POL_POLITICAS_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_PX3_PERSONA_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_PX3_PERSONA_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_PX3_PERSONA_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_PX3_PERSONA_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_PX3_PERSONA_EXTRA_3 to pfs01, pfs02, pfs03, pfs04;

grant references on DD_PX3_PERSONA_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_PX3_PERSONA_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_PX3_PERSONA_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_PX3_PERSONA_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_PX3_PERSONA_EXTRA_3_LG to pfs01, pfs02, pfs03, pfs04;

grant references on DD_PX4_PERSONA_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_PX4_PERSONA_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_PX4_PERSONA_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_PX4_PERSONA_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_PX4_PERSONA_EXTRA_4 to pfs01, pfs02, pfs03, pfs04;

grant references on DD_PX4_PERSONA_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;
grant select on     DD_PX4_PERSONA_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;
grant insert on     DD_PX4_PERSONA_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;
grant delete on     DD_PX4_PERSONA_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;
grant update on     DD_PX4_PERSONA_EXTRA_4_LG to pfs01, pfs02, pfs03, pfs04;

-- Modulo de politica
grant references on DD_ESP_ESTADO_POLITICA to pfs01, pfs02, pfs03, pfs04;
grant select on DD_ESP_ESTADO_POLITICA to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_ESP_ESTADO_POLITICA to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_ESP_ESTADO_POLITICA to pfs01, pfs02, pfs03, pfs04;
grant update on DD_ESP_ESTADO_POLITICA to pfs01, pfs02, pfs03, pfs04;

grant references on DD_EPI_EST_POL_ITINERARIO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_EPI_EST_POL_ITINERARIO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_EPI_EST_POL_ITINERARIO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_EPI_EST_POL_ITINERARIO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_EPI_EST_POL_ITINERARIO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_ESO_ESTADO_OBJETIVO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_ESO_ESTADO_OBJETIVO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_ESO_ESTADO_OBJETIVO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_ESO_ESTADO_OBJETIVO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_ESO_ESTADO_OBJETIVO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_ESC_ESTADO_CUMPLIMIENTO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_ESC_ESTADO_CUMPLIMIENTO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_ESC_ESTADO_CUMPLIMIENTO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_ESC_ESTADO_CUMPLIMIENTO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_ESC_ESTADO_CUMPLIMIENTO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TOP_TIPO_OPERADOR to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TOP_TIPO_OPERADOR to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TOP_TIPO_OPERADOR to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TOP_TIPO_OPERADOR to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TOP_TIPO_OPERADOR to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TAN_TIPO_ANALISIS to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TAN_TIPO_ANALISIS to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TAN_TIPO_ANALISIS to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TAN_TIPO_ANALISIS to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TAN_TIPO_ANALISIS to pfs01, pfs02, pfs03, pfs04;

grant references on DD_VAL_VALORACION to pfs01, pfs02, pfs03, pfs04;
grant select on DD_VAL_VALORACION to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_VAL_VALORACION to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_VAL_VALORACION to pfs01, pfs02, pfs03, pfs04;
grant update on DD_VAL_VALORACION to pfs01, pfs02, pfs03, pfs04;

grant references on DD_IMP_IMPACTO to pfs01, pfs02, pfs03, pfs04;
grant select on DD_IMP_IMPACTO to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_IMP_IMPACTO to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_IMP_IMPACTO to pfs01, pfs02, pfs03, pfs04;
grant update on DD_IMP_IMPACTO to pfs01, pfs02, pfs03, pfs04;

grant references on DD_TIT_TIPO_ITINERARIOS to pfs01, pfs02, pfs03, pfs04;
grant select on DD_TIT_TIPO_ITINERARIOS to pfs01, pfs02, pfs03, pfs04;
grant insert on DD_TIT_TIPO_ITINERARIOS to pfs01, pfs02, pfs03, pfs04;
grant delete on DD_TIT_TIPO_ITINERARIOS to pfs01, pfs02, pfs03, pfs04;
grant update on DD_TIT_TIPO_ITINERARIOS to pfs01, pfs02, pfs03, pfs04;
 

commit;
 
 
 
 
 
 
 
 
 



-- ******************************** --
-- ** Para la versión 2.0.0.0.29 ** --
-- ******************************** --


-- Para añadir un tipo de prorroga a las causas y las razones de prorroga (interna o externa)
CREATE SEQUENCE S_DD_TPR_TIPO_PRORROGA;

CREATE TABLE DD_TPR_TIPO_PRORROGA  (
   DD_TPR_ID            NUMBER(16)                      NOT NULL,
   DD_TPR_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_TPR_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_TPR_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TPR_TIPO_PRORROGA PRIMARY KEY (DD_TPR_ID)
);

ALTER TABLE DD_TPR_TIPO_PRORROGA
 ADD CONSTRAINT UK_DD_TPR_TIPO_PRORROGA
 UNIQUE (DD_TPR_CODIGO);


INSERT INTO DD_TPR_TIPO_PRORROGA (DD_TPR_ID,DD_TPR_CODIGO,DD_TPR_DESCRIPCION,DD_TPR_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) 
VALUES (S_DD_TPR_TIPO_PRORROGA.nextVal,'INT','Primaria / Interna','Primaria / Interna','DD',SYSDATE);


INSERT INTO DD_TPR_TIPO_PRORROGA (DD_TPR_ID,DD_TPR_CODIGO,DD_TPR_DESCRIPCION,DD_TPR_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) 
VALUES (S_DD_TPR_TIPO_PRORROGA.nextVal,'EXT','Externa','Externa','DD',SYSDATE);



ALTER TABLE DD_CPR_CAUSA_PRORROGA
 ADD (DD_TPR_ID NUMBER);
 
ALTER TABLE DD_RPR_RAZON_PRORROGA
 ADD (DD_TPR_ID NUMBER);


update DD_CPR_CAUSA_PRORROGA
set dd_tpr_id = (SELECT dd_tpr_id FROM DD_TPR_TIPO_PRORROGA where dd_tpr_codigo = 'INT');

update DD_RPR_RAZON_PRORROGA
set dd_tpr_id = (SELECT dd_tpr_id FROM DD_TPR_TIPO_PRORROGA where dd_tpr_codigo = 'INT');


ALTER TABLE DD_CPR_CAUSA_PRORROGA
MODIFY(DD_TPR_ID  NOT NULL);

ALTER TABLE DD_RPR_RAZON_PRORROGA
MODIFY(DD_TPR_ID  NOT NULL);

ALTER TABLE DD_CPR_CAUSA_PRORROGA
   ADD CONSTRAINT FK_DD_CPR_C_FK_DD_TPR_T FOREIGN KEY (DD_TPR_ID)
      REFERENCES DD_TPR_TIPO_PRORROGA (DD_TPR_ID);


ALTER TABLE DD_RPR_RAZON_PRORROGA
   ADD CONSTRAINT FK_DD_RPR_R_FK_DD_TPR_T FOREIGN KEY (DD_TPR_ID)
      REFERENCES DD_TPR_TIPO_PRORROGA (DD_TPR_ID);


grant references on DD_TPR_TIPO_PRORROGA to PFS01, PFS02, PFS03, PFS04;
grant select on DD_TPR_TIPO_PRORROGA to PFS01, PFS02, PFS03, PFS04;
grant insert on DD_TPR_TIPO_PRORROGA to PFS01, PFS02, PFS03, PFS04;
grant delete on DD_TPR_TIPO_PRORROGA to PFS01, PFS02, PFS03, PFS04;
grant update on DD_TPR_TIPO_PRORROGA to PFS01, PFS02, PFS03, PFS04;



-- Añadimos los nuevos tipos de subtareas
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR) 
VALUES (53,1,'53','Umbral','Verificación Umbral',1,'DD',sysdate);

INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR) 
VALUES (54,1,'54','Solicitar Prorroga DC','Solicitar Prorroga DC',1,'DD',sysdate);

INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR) 
VALUES (55,3,'55','Notif Solic Prorroga DC Rechazada','Notificacion Solicitud Prorroga DC Rechazada',1,'DD',sysdate);

INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR) 
VALUES (57,1,'57','Propuesta de borrado de objetivo','Pedido al supervisor de borrado de objetivo',0,'DD',sysdate);
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR) 
VALUES (58,3,'58','Aceptar propuesta de borrado de objetivo','Aceptación del supervisor del borrado de objetivo',1,'DD',sysdate);
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR) 
VALUES (59,3,'59','Rechazar propuesta de borrado de objetivo','Rechazo del supervisor del borrado de objetivo',1,'DD',sysdate);
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR) 
VALUES (60,1,'60','Propuesta de alta de objetivo','Pedido al supervisor de alta de objetivo',0,'DD',sysdate);
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR) 
VALUES (61,3,'61','Aceptar propuesta de alta de objetivo','Aceptación de alta del objetivo',1,'DD',sysdate);
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR) 
VALUES (62,3,'62','Rechazar propuesta de alta de objetivo','Rechazo del supervisor del alta del objetivo',1,'DD',sysdate);
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR) 
VALUES (63,1,'63','Propuesta de cumplimiento de objetivo','Pedido al supervisor de cumplimiento de objetivo',0,'DD',sysdate);
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR) 
VALUES (64,3,'64','Aceptar propuesta de cumplimiento de objetivo','Aceptación del supervisor del cumplimiento de objetivo',1,'DD',sysdate);
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR) 
VALUES (65,1,'65','Justificar incumplimiento de objetivo','Justificar incumplimiento de objetivo',1,'DD',sysdate);
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (66,3,'66','Notificación objetivo aceptado','Notificación objetivo propuesto aceptado',1,'DD',sysdate);
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (67,3,'67','Notificación objetivo rechazado','Notificación objetivo propuesto rechazado',1,'DD',sysdate);

INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR) 
VALUES (501,1,'501','Solicitud Expediente Manual Seguimiento','Pedido al Supervisor de Expediente Manual de Seguimiento',0,'DD',sysdate);


-- Añadimos una columna nueva
ALTER TABLE DD_SMG_SUBFASES_MAPA_GLOBAL
 ADD (DD_SMG_ORDEN NUMBER);

-- Actualizamos los datos
update DD_SMG_SUBFASES_MAPA_GLOBAL set dd_smg_orden = 1 where dd_smg_codigo = 'NV'; 
update DD_SMG_SUBFASES_MAPA_GLOBAL set dd_smg_orden = 2 where dd_smg_codigo = 'CAR'; 
update DD_SMG_SUBFASES_MAPA_GLOBAL set dd_smg_orden = 3 where dd_smg_codigo = 'GV15'; 
update DD_SMG_SUBFASES_MAPA_GLOBAL set dd_smg_orden = 4 where dd_smg_codigo = 'GV15-30'; 
update DD_SMG_SUBFASES_MAPA_GLOBAL set dd_smg_orden = 5 where dd_smg_codigo = 'GV30-60'; 
update DD_SMG_SUBFASES_MAPA_GLOBAL set dd_smg_orden = 6 where dd_smg_codigo = 'GV60'; 
update DD_SMG_SUBFASES_MAPA_GLOBAL set dd_smg_orden = 7 where dd_smg_codigo = 'CE'; 
update DD_SMG_SUBFASES_MAPA_GLOBAL set dd_smg_orden = 8 where dd_smg_codigo = 'RE'; 
update DD_SMG_SUBFASES_MAPA_GLOBAL set dd_smg_orden = 9 where dd_smg_codigo = 'DC'; 
update DD_SMG_SUBFASES_MAPA_GLOBAL set dd_smg_orden = 10 where dd_smg_codigo = 'CA'; 
update DD_SMG_SUBFASES_MAPA_GLOBAL set dd_smg_orden = 11 where dd_smg_codigo = 'CJ'; 
update DD_SMG_SUBFASES_MAPA_GLOBAL set dd_smg_orden = 12 where dd_smg_codigo = 'CSC';

-- Forzamos un not null
ALTER TABLE DD_SMG_SUBFASES_MAPA_GLOBAL
MODIFY(DD_SMG_ORDEN NUMBER  NOT NULL);



-- Nuevas tablas de analisis
CREATE SEQUENCE S_DD_CRA_CRITERIO_ANALISIS;

CREATE TABLE DD_CRA_CRITERIO_ANALISIS  (
   DD_CRA_ID            NUMBER(16)                      NOT NULL,
   DD_CRA_CODIGO        VARCHAR2(8 CHAR)                     NOT NULL,
   DD_CRA_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_CRA_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                         DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CRA_CRITERIO_ANALISIS PRIMARY KEY (DD_CRA_ID)
);

CREATE TABLE DD_CRA_CRITERIO_ANALISIS_LG  (
   DD_CRA_ID            NUMBER(16)                      NOT NULL,
   DD_CRA_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_CRA_CODIGO        VARCHAR2(8 CHAR)                     NOT NULL,
   DD_CRA_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_CRA_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                         DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CRA_CRITERIO_ANALISIS_LG PRIMARY KEY (DD_CRA_ID,DD_CRA_LANG)
);


grant references on DD_CRA_CRITERIO_ANALISIS to PFS01, PFS02, PFS03, PFS04;
grant select on DD_CRA_CRITERIO_ANALISIS to PFS01, PFS02, PFS03, PFS04;
grant insert on DD_CRA_CRITERIO_ANALISIS to PFS01, PFS02, PFS03, PFS04;
grant delete on DD_CRA_CRITERIO_ANALISIS to PFS01, PFS02, PFS03, PFS04;
grant update on DD_CRA_CRITERIO_ANALISIS to PFS01, PFS02, PFS03, PFS04;



INSERT INTO DD_CRA_CRITERIO_ANALISIS (DD_CRA_ID, DD_CRA_CODIGO, DD_CRA_DESCRIPCION,DD_CRA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (1, 'jerarq', 'Por jerarquía', 'Por jerarquía', 'DD', SYSDATE);
INSERT INTO DD_CRA_CRITERIO_ANALISIS (DD_CRA_ID, DD_CRA_CODIGO, DD_CRA_DESCRIPCION,DD_CRA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (2, 'producto', 'Por tipo de producto', 'Por tipo de producto', 'DD', SYSDATE);
INSERT INTO DD_CRA_CRITERIO_ANALISIS (DD_CRA_ID, DD_CRA_CODIGO, DD_CRA_DESCRIPCION,DD_CRA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (3, 'segmento', 'Por tipo de segmento', 'Por tipo de segmento', 'DD', SYSDATE);
INSERT INTO DD_CRA_CRITERIO_ANALISIS (DD_CRA_ID, DD_CRA_CODIGO, DD_CRA_DESCRIPCION,DD_CRA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (4, 'fase', 'Por situación (fase y subfases)', 'Por situación (fase y subfases)', 'DD', SYSDATE);


INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES (28,'EDITAR_UMBRAL','Edita el umbral de deuda por persona para pasar a Expediente','DD', SYSDATE);
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES (29,'MENU-LIST-CNT','Puede buscar Contratos','DD', SYSDATE);
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES (30,'EDITAR_GYA_REV','Editar Revisión en Gestión y Análisis','DD', SYSDATE);

INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES (S_FUN_FUNCIONES.nextVal,'POLITICA_SUPER','Superusuario de políticas','DD', sysdate);
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES (S_FUN_FUNCIONES.nextVal,'VER-POLITICA','Usuario habilitado para ver políticas','DD', sysdate);
