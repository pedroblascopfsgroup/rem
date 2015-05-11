-- ********************************************************************************** --
-- * CAMBIOS A REALIZAR EN BD AL DESPLEGAR LAS DISTINTAS VERSIONES DE LA APLICACIÓN * --   
-- ********************************************************************************** --
-- ******************************** --
-- ** Para DEMO BANESTO			 ** --
-- ******************************** --

ALTER TABLE DES_DESPACHO_EXTERNO ADD(
     ZON_ID                NUMBER(16),
  DD_TDE_ID            NUMBER(16)
);

ALTER TABLE DES_DESPACHO_EXTERNO
   ADD CONSTRAINT FK_DES_ZON_ID FOREIGN KEY (ZON_ID)
      REFERENCES ZON_ZONIFICACION (ZON_ID);
      
ALTER TABLE DES_DESPACHO_EXTERNO
   ADD CONSTRAINT FK_DES_TDE_ID FOREIGN KEY (DD_TDE_ID)
      REFERENCES ${master.schema}.DD_TDE_TIPO_DESPACHO (DD_TDE_ID);
      
ALTER TABLE ASU_ASUNTOS ADD(
    USD_ID            NUMBER(16)
);

ALTER TABLE ASU_ASUNTOS
   ADD CONSTRAINT FK_ASU_USD_ID FOREIGN KEY (USD_ID)
      REFERENCES USD_USUARIOS_DESPACHOS (USD_ID);



CREATE TABLE HCA_HISTORICO_CAMBIOS_ASUNTO(
    HCA_ID                                NUMBER(16),
    HCA_SUP_ORIGEN                NUMBER(16),
    HCA_SUP_DESTINO                NUMBER(16),
    ASU_ID                                NUMBER(16),
    HCA_TEMPORAL                    NUMBER(1,0),
    
    VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_HCA_HIS_CAMBIOS_ASU PRIMARY KEY (HCA_ID)
);

CREATE SEQUENCE S_HCA_HISTORICO_CAMBIOS_ASUNTO START WITH ${initialId} NOCYCLE CACHE 100;

ALTER TABLE HCA_HISTORICO_CAMBIOS_ASUNTO
   ADD CONSTRAINT FK_HCA_SUP_ORIGEN FOREIGN KEY (HCA_SUP_ORIGEN)
      REFERENCES USD_USUARIOS_DESPACHOS (USD_ID);
      
ALTER TABLE HCA_HISTORICO_CAMBIOS_ASUNTO
   ADD CONSTRAINT FK_HCA_SUP_DESTINO FOREIGN KEY (HCA_SUP_DESTINO)
      REFERENCES USD_USUARIOS_DESPACHOS (USD_ID);

ALTER TABLE HCA_HISTORICO_CAMBIOS_ASUNTO
   ADD CONSTRAINT FK_HCA_ASU_ID FOREIGN KEY (ASU_ID)
      REFERENCES ASU_ASUNTOS (ASU_ID);

-- ******************************** --

-- ******************************** --
-- ** Para la versión 3.0.0.1.X  ** --
-- ******************************** --

-- Dependencia entre tipos procedimiento/tipos actuacion
-- Rangos de saldo segun el tipo de procedimiento
ALTER TABLE DD_TPO_TIPO_PROCEDIMIENTO ADD (
    DD_TAC_ID NUMBER(16),
    DD_TPO_SALDO_MIN NUMBER(14,2),
    DD_TPO_SALDO_MAX NUMBER(14,2)
);


--Cambios para el motor de reglas

ALTER TABLE PFS01.ARQ_ARQUETIPOS ADD (RD_ID  NUMBER(16));

--------------------------------------------------------
--IMPORTANTE!! Ejecutar el script entityRuleengineScript-Oracle9iDialect.sql
--------------------------------------------------------


ALTER TABLE PEX_PERSONAS_EXPEDIENTE
 ADD (DD_AEX_ID  NUMBER(16));

ALTER TABLE PEX_PERSONAS_EXPEDIENTE ADD (
  CONSTRAINT FK_PEX_PERS_FK_DD_AEX_ID 
 FOREIGN KEY (DD_AEX_ID) 
 REFERENCES pfsmaster.DD_AEX_AMBITOS_EXPEDIENTE (DD_AEX_ID));

--Updateamos las personas de pase
update PEX_PERSONAS_EXPEDIENTE 
set dd_aex_id = (select dd_aex_id from pfsmaster.DD_AEX_AMBITOS_EXPEDIENTE where dd_aex_codigo = 'PP') 
where pex_pase = 1;

--Updateamos el resto
update PEX_PERSONAS_EXPEDIENTE 
set dd_aex_id = (select dd_aex_id from pfsmaster.DD_AEX_AMBITOS_EXPEDIENTE where dd_aex_codigo = 'PPGRA')
where pex_pase = 0;

 
ALTER TABLE PEX_PERSONAS_EXPEDIENTE
 MODIFY (DD_AEX_ID  NOT NULL);


ALTER TABLE CEX_CONTRATOS_EXPEDIENTE
 ADD (DD_AEX_ID  NUMBER(16));

ALTER TABLE CEX_CONTRATOS_EXPEDIENTE ADD (
  CONSTRAINT FK_CEX_CONT_FK_DD_AEX_ID 
 FOREIGN KEY (DD_AEX_ID) 
 REFERENCES pfsmaster.DD_AEX_AMBITOS_EXPEDIENTE (DD_AEX_ID));

--Updateamos las personas de pase
update CEX_CONTRATOS_EXPEDIENTE
set dd_aex_id = (select dd_aex_id from pfsmaster.DD_AEX_AMBITOS_EXPEDIENTE where dd_aex_codigo = 'CP') 
where cex_pase = 1;

--Updateamos el resto
update CEX_CONTRATOS_EXPEDIENTE
set dd_aex_id = (select dd_aex_id from pfsmaster.DD_AEX_AMBITOS_EXPEDIENTE where dd_aex_codigo = 'CPGRA')
where cex_pase = 0;
 
ALTER TABLE CEX_CONTRATOS_EXPEDIENTE
 MODIFY (DD_AEX_ID  NOT NULL);




--Cambios de la versión 9870

ALTER TABLE ITI_ITINERARIOS
ADD (
    DD_AEX_ID   NUMBER(16),
    CONSTRAINT FK_ITI_ITIN_FK_DD_AEX_AMB_EXP FOREIGN KEY (DD_AEX_ID) REFERENCES PFSMASTER.DD_AEX_AMBITOS_EXPEDIENTE (DD_AEX_ID)
);

update iti_itinerarios
set DD_AEX_ID = (select dd_aex_id from PFSMASTER.DD_AEX_AMBITOS_EXPEDIENTE where dd_aex_codigo = 'PPGRA');


CREATE SEQUENCE S_REE_REGLAS_ELEVACION_ESTADO NOCYCLE CACHE 100;

CREATE TABLE REE_REGLAS_ELEVACION_ESTADO  (
   REE_ID            NUMBER(16)                      NOT NULL,
   DD_TRE_ID            NUMBER(16)                      NOT NULL,
   DD_AEX_ID            NUMBER(16),
   EST_ID            NUMBER(16)                      NOT NULL,
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_REL_REGLAS_ELEVACION_ESTADO PRIMARY KEY (REE_ID ),
   CONSTRAINT FK_REE_REGL_FK_DD_TRE_TIPO_REG FOREIGN KEY (DD_TRE_ID) REFERENCES PFSMASTER.DD_TRE_TIPO_REGLAS_ELEVACION (DD_TRE_ID),
   CONSTRAINT FK_REE_REGL_FK_DD_AEX_AMB_EXP FOREIGN KEY (DD_AEX_ID) REFERENCES PFSMASTER.DD_AEX_AMBITOS_EXPEDIENTE (DD_AEX_ID),
   CONSTRAINT FK_REE_REGL_FK_EST_ESTADOS FOREIGN KEY (EST_ID) REFERENCES EST_ESTADOS (EST_ID),
   CONSTRAINT UK_REE_REGLAS_ELEVACION_ESTADO UNIQUE (EST_ID, DD_TRE_ID)
);

insert into REE_REGLAS_ELEVACION_ESTADO(REE_ID, DD_TRE_ID, DD_AEX_ID, EST_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)  
select S_REE_REGLAS_ELEVACION_ESTADO.nextval, tre.dd_tre_id, (select dd_aex_id from PFSMASTER.DD_AEX_AMBITOS_EXPEDIENTE where dd_aex_codigo = 'PPGRA'), est.EST_ID, 0, 'DD', sysdate, 0 
from est_estados est, PFSMASTER.DD_TRE_TIPO_REGLAS_ELEVACION tre;

update REE_REGLAS_ELEVACION_ESTADO
set DD_AEX_ID = null
where DD_TRE_ID IN (select dd_tre_id from PFSMASTER.DD_TRE_TIPO_REGLAS_ELEVACION where dd_tre_codigo IN ('GESTION_ANALISIS', 'DOCUMENTOS'));



ALTER TABLE PER_PERSONAS ADD (
 	PER_RIESGO_DIR_DANYADO  NUMBER(14, 2),
	PER_RIESGO_DIR_VENCIDO  NUMBER(14, 2),
 	PER_RIESGO_DIR_GRUPO  	NUMBER(14, 2),
 	PER_RIESGO_DIR_D_GRUPO  NUMBER(14, 2),
 	PER_ULTIMA_OPERACION	DATE 	
);
 



-- Actualizado con la revisión 9846

      
CREATE SEQUENCE S_PEX_PERSONAS_EXPEDIENTE START WITH ${initialId} NOCYCLE CACHE 100;

CREATE SEQUENCE S_TMP_CIR_CIRBE START WITH ${initialId} NOCYCLE CACHE 100;

CREATE SEQUENCE S_APP_ANALISIS_PER_POL START WITH ${initialId} NOCYCLE CACHE 100;

CREATE SEQUENCE S_APA_ANALISIS_PAR_PER START WITH ${initialId} NOCYCLE CACHE 100;

CREATE SEQUENCE S_APO_ANALISIS_PER_CNT START WITH ${initialId} NOCYCLE CACHE 100;

CREATE SEQUENCE S_DD_PAR_PARCELAS START WITH ${initialId} NOCYCLE CACHE 100;

--Añadimos al arquetipo un nivel
ALTER TABLE ARQ_ARQUETIPOS
 ADD (ARQ_NIVEL  NUMBER(4) DEFAULT 0);

UPDATE ARQ_ARQUETIPOS SET arq_nivel = 0;

ALTER TABLE ARQ_ARQUETIPOS
 MODIFY (ARQ_NIVEL NOT NULL);
 
/*==============================================================*/ 
/* Table: PEX_PERSONAS_EXPEDIENTE                              */
/*==============================================================*/
CREATE TABLE PEX_PERSONAS_EXPEDIENTE  (
   PEX_ID               NUMBER(16)                    NOT NULL,
   PER_ID               NUMBER(16)                    NOT NULL,
   EXP_ID               NUMBER(16)                    NOT NULL,
   PEX_PASE             NUMBER(1,0),
   VERSION              INTEGER                       DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)             NOT NULL,
   FECHACREAR           TIMESTAMP                     NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                   DEFAULT 0 NOT NULL,
   CONSTRAINT PK_PEX_PERSONAS_EXPEDIENTE PRIMARY KEY (PEX_ID)
);
 
ALTER TABLE EXP_EXPEDIENTES
 ADD (EXP_MANUAL_SEG  NUMBER(1,0) DEFAULT 0);
 
UPDATE EXP_EXPEDIENTES SET EXP_MANUAL_SEG = 0;

ALTER TABLE EXP_EXPEDIENTES
 MODIFY (EXP_MANUAL_SEG NOT NULL);
 
 
 
--Asociamos itinerarios con tipo
ALTER TABLE ITI_ITINERARIOS
 ADD (DD_TIT_ID  NUMBER(16));
 
UPDATE ITI_ITINERARIOS SET DD_TIT_ID = (select dd_tit_id from pfsmaster.dd_tit_tipo_itinerarios where dd_tit_codigo = 'REC');

ALTER TABLE ITI_ITINERARIOS
 MODIFY (DD_TIT_ID NOT NULL);

ALTER TABLE ITI_ITINERARIOS
   ADD CONSTRAINT FK_ITI_ITIN_FK_DD_TIT_TIPO_IT FOREIGN KEY (DD_TIT_ID)
      REFERENCES pfsmaster.DD_TIT_TIPO_ITINERARIOS (DD_TIT_ID);      



ALTER TABLE PEF_PERFILES
 ADD (PEF_CODIGO VARCHAR2(100 CHAR));
 
UPDATE PEF_PERFILES SET PEF_CODIGO = PEF_ID;

ALTER TABLE PEF_PERFILES
 MODIFY (PEF_CODIGO NOT NULL);
	  
 
--Añadimos el arquetipo a la persona (calculado y real)
ALTER TABLE PER_PERSONAS
 ADD (ARQ_ID  NUMBER(16));

ALTER TABLE PER_PERSONAS
 ADD (ARQ_ID_CALCULADO  NUMBER(16));
 
 
 
 
 
ALTER TABLE GRC_GRUPO_CARGA ADD CONSTRAINT GRC_CODIGO_UK UNIQUE (GRC_CODIGO);

ALTER TABLE TAL_TIPO_ALERTA ADD(TAL_PLAZO_VISIBILIDAD	NUMBER);

ALTER TABLE TAL_TIPO_ALERTA ADD CONSTRAINT TAL_CODIGO_UK UNIQUE (TAL_CODIGO);
 
ALTER TABLE GAL_GRUPO_ALERTA ADD CONSTRAINT GAL_CODIGO_UK UNIQUE (GAL_CODIGO); 
 
 
ALTER TABLE NGR_NIVEL_GRAVEDAD ADD(NGR_PESO					NUMBER(16)					   NOT NULL);

ALTER TABLE NGR_NIVEL_GRAVEDAD ADD CONSTRAINT NGR_CODIGO_UK UNIQUE (NGR_CODIGO);
 

ALTER TABLE PEX_PERSONAS_EXPEDIENTE
   ADD CONSTRAINT FK_PEX_PER_FK_PER_PERSONA FOREIGN KEY (PER_ID)
      REFERENCES PER_PERSONAS (PER_ID);

ALTER TABLE PEX_PERSONAS_EXPEDIENTE
   ADD CONSTRAINT FK_PEX_EXP_FK_EXP_EXPE FOREIGN KEY (EXP_ID)
      REFERENCES EXP_EXPEDIENTES (EXP_ID);

-- NUEVA CARGA DE FICHEROS
CREATE SEQUENCE S_DD_CT1_CATALOGO_1;

CREATE SEQUENCE S_DD_CT2_CATALOGO_2;

CREATE SEQUENCE S_DD_CT3_CATALOGO_3;

CREATE SEQUENCE S_DD_CT4_CATALOGO_4;

CREATE SEQUENCE S_DD_CT5_CATALOGO_5;

CREATE SEQUENCE S_DD_CT6_CATALOGO_6;



/*===============================================================*/
/* Table: DD_CT1_CATALOGO_1					                             */
/*===============================================================*/
CREATE TABLE DD_CT1_CATALOGO_1  (
   DD_CT1_ID            NUMBER(16)                      NOT NULL,
   DD_CT1_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_CT1_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_CT1_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CT1_CATALOGO_1 PRIMARY KEY (DD_CT1_ID),
   CONSTRAINT DD_CT1_CODIGO_UK UNIQUE (DD_CT1_CODIGO)
);

/*==============================================================*/
/* Table: DD_CT1_CATALOGO_1_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_CT1_CATALOGO_1_LG  (
   DD_CT1_ID            NUMBER(16)                      NOT NULL,
   DD_CT1_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_CT1_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_CT1_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CT1_CATALOGO_1_LG PRIMARY KEY (DD_CT1_ID, DD_CT1_LANG)
);

/*===============================================================*/
/* Table: DD_CT2_CATALOGO_2					                             */
/*===============================================================*/
CREATE TABLE DD_CT2_CATALOGO_2  (
   DD_CT2_ID            NUMBER(16)                      NOT NULL,
   DD_CT2_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_CT2_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_CT2_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CT2_CATALOGO_2 PRIMARY KEY (DD_CT2_ID),
   CONSTRAINT DD_CT2_CODIGO_UK UNIQUE (DD_CT2_CODIGO)
);

/*==============================================================*/
/* Table: DD_CT2_CATALOGO_2_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_CT2_CATALOGO_2_LG  (
   DD_CT2_ID            NUMBER(16)                      NOT NULL,
   DD_CT2_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_CT2_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_CT2_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CT1_CATALOGO_2_LG PRIMARY KEY (DD_CT2_ID, DD_CT2_LANG)
);

/*===============================================================*/
/* Table: DD_CT3_CATALOGO_3					                             */
/*===============================================================*/
CREATE TABLE DD_CT3_CATALOGO_3  (
   DD_CT3_ID            NUMBER(16)                      NOT NULL,
   DD_CT3_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_CT3_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_CT3_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CT3_CATALOGO_3 PRIMARY KEY (DD_CT3_ID),
   CONSTRAINT DD_CT3_CODIGO_UK UNIQUE (DD_CT3_CODIGO)
);

/*==============================================================*/
/* Table: DD_CT3_CATALOGO_3_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_CT3_CATALOGO_3_LG  (
   DD_CT3_ID            NUMBER(16)                      NOT NULL,
   DD_CT3_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_CT3_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_CT3_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CT3_CATALOGO_3_LG PRIMARY KEY (DD_CT3_ID, DD_CT3_LANG)
);

/*===============================================================*/
/* Table: DD_CT4_CATALOGO_4					                             */
/*===============================================================*/
CREATE TABLE DD_CT4_CATALOGO_4  (
   DD_CT4_ID            NUMBER(16)                      NOT NULL,
   DD_CT4_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_CT4_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_CT4_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CT4_CATALOGO_4 PRIMARY KEY (DD_CT4_ID),
   CONSTRAINT DD_CT4_CODIGO_UK UNIQUE (DD_CT4_CODIGO)
);

/*==============================================================*/
/* Table: DD_CT4_CATALOGO_4_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_CT4_CATALOGO_4_LG  (
   DD_CT4_ID            NUMBER(16)                      NOT NULL,
   DD_CT4_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_CT4_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_CT4_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CT4_CATALOGO_4_LG PRIMARY KEY (DD_CT4_ID, DD_CT4_LANG)
);


/*===============================================================*/
/* Table: DD_CT5_CATALOGO_5					                             */
/*===============================================================*/
CREATE TABLE DD_CT5_CATALOGO_5  (
   DD_CT5_ID            NUMBER(16)                      NOT NULL,
   DD_CT5_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_CT5_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_CT5_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CT5_CATALOGO_5 PRIMARY KEY (DD_CT5_ID),
   CONSTRAINT DD_CT5_CODIGO_UK UNIQUE (DD_CT5_CODIGO)
);

/*==============================================================*/
/* Table: DD_CT5_CATALOGO_5_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_CT5_CATALOGO_5_LG  (
   DD_CT5_ID            NUMBER(16)                      NOT NULL,
   DD_CT5_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_CT5_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_CT5_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CT5_CATALOGO_5_LG PRIMARY KEY (DD_CT5_ID, DD_CT5_LANG)
);


/*===============================================================*/
/* Table: DD_CT6_CATALOGO_6					                             */
/*===============================================================*/
CREATE TABLE DD_CT6_CATALOGO_6  (
   DD_CT6_ID            NUMBER(16)                      NOT NULL,
   DD_CT6_CODIGO        VARCHAR2(20 CHAR)                    NOT NULL,
   DD_CT6_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_CT6_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CT6_CATALOGO_6 PRIMARY KEY (DD_CT6_ID),
   CONSTRAINT DD_CT6_CODIGO_UK UNIQUE (DD_CT6_CODIGO)
);

/*==============================================================*/
/* Table: DD_CT6_CATALOGO_6_LG 		                      */
/*==============================================================*/
CREATE TABLE DD_CT6_CATALOGO_6_LG  (
   DD_CT6_ID            NUMBER(16)                      NOT NULL,
   DD_CT6_LANG          VARCHAR2(8 CHAR)                     NOT NULL,
   DD_CT6_DESCRIPCION   VARCHAR2(50 CHAR),
   DD_CT6_DESCRIPCION_LARGA VARCHAR2(250 CHAR),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CT6_CATALOGO_6_LG PRIMARY KEY (DD_CT6_ID, DD_CT6_LANG)
);


 
--Agregar columnas a MOV_MOVIMIENTOS
ALTER TABLE MOV_MOVIMIENTOS ADD(
	MOV_RIESGO	          NUMBER(14, 2),
	MOV_DEUDA_IRREGULAR		NUMBER(14, 2),
	MOV_DISPUESTO					NUMBER(14, 2),
	MOV_SALDO_PASIVO			NUMBER(14, 2),
	MOV_RIESGO_GARANT	NUMBER(14, 2),
	MOV_SALDO_EXCE		NUMBER(14, 2),
	MOV_LIMITE_DESC		NUMBER(14, 4),
	MOV_EXTRA_1	NUMBER(14, 2),
	MOV_EXTRA_2 NUMBER(14, 2),
	MOV_LTV_INI	 NUMBER(4),
	MOV_LTV_FIN	 NUMBER(4),
	DD_MX3_ID	NUMBER(16),
	DD_MX4_ID	NUMBER(16),
	MOV_EXTRA_5	DATE,
	MOV_EXTRA_6	DATE
);

ALTER TABLE MOV_MOVIMIENTOS
   ADD CONSTRAINT FK_MOV_DD_MX3_ID FOREIGN KEY (DD_MX3_ID)
      REFERENCES pfsmaster.DD_MX3_MOVIMIENTO_EXTRA_3 (DD_MX3_ID);

ALTER TABLE MOV_MOVIMIENTOS
   ADD CONSTRAINT FK_MOV_DD_MX4_ID FOREIGN KEY (DD_MX4_ID)
      REFERENCES pfsmaster.DD_MX4_MOVIMIENTO_EXTRA_4 (DD_MX4_ID);


-- Agregar columnas a PER_PERSONAS
ALTER TABLE PER_PERSONAS ADD(
	PER_CONTACTO VARCHAR2(90 CHAR),
  PER_RIESGO  NUMBER(14, 2),
  PER_RIESGO_IND NUMBER(14, 2),
  PER_NRO_SOCIOS NUMBER(5),
  PER_NRO_EMPLEADOS				NUMBER(6),
  PER_TELEFONO_5 VARCHAR2(20 CHAR),
  PER_TELEFONO_6 VARCHAR2(20 CHAR),
  PER_VR_OTRAS_ENT NUMBER(14,2),
  PER_VR_DANIADO_OTRAS_ENT	NUMBER(14,2),
  PER_EXTRA_1 NUMBER(14, 2),
  PER_EXTRA_2 NUMBER(14, 2),
  PER_NACIONALIDAD		NUMBER(16),
  PER_PAIS_NACIMIENTO NUMBER(16),
  PER_SEXO NUMBER(4),
  DD_TIPO_TELEFONO_1 NUMBER(16),
  DD_TIPO_TELEFONO_2 NUMBER(16),
  DD_TIPO_TELEFONO_3 NUMBER(16),
  DD_TIPO_TELEFONO_4 NUMBER(16),
  DD_TIPO_TELEFONO_5 NUMBER(16),
  DD_TIPO_TELEFONO_6 NUMBER(16),
  PEF_ID 	NUMBER(16),
  USU_ID	NUMBER(16),
  ZON_ID	NUMBER(16),
  DD_POL_ID NUMBER(16),
  OFI_ID NUMBER(16),
  DD_GGE_ID NUMBER (16),
  DD_REX_ID	NUMBER (16),
  DD_RAX_ID NUMBER (16),
  DD_PX3_ID NUMBER(16),
	DD_PX4_ID NUMBER(16),
  PER_FECHA_CONSTITUCION DATE,
  PER_EXTRA_5 DATE,
	PER_EXTRA_6 DATE
);   

-- FK PER_NACIONALIDAD
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_PER_NACIONALIDAD FOREIGN KEY (PER_NACIONALIDAD)
      REFERENCES pfsmaster.DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID);
      
-- FK PER_PAIS_NACIMIENTO
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_PER_PAIS_NACIMIENTO FOREIGN KEY (PER_PAIS_NACIMIENTO)
      REFERENCES pfsmaster.DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID);
      
-- FK PEF_ID
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_PER_PEF_ID FOREIGN KEY (PEF_ID)
      REFERENCES PEF_PERFILES (PEF_ID);
      
-- FK USU_ID
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_PER_USU_ID FOREIGN KEY (USU_ID)
      REFERENCES pfsmaster.USU_USUARIOS (USU_ID);
-- FK ZON_ID
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_PER_ZON_ID FOREIGN KEY (ZON_ID)
      REFERENCES ZON_ZONIFICACION (ZON_ID);

-- FK DD_TIPO_TELEFONO_1 
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_DD_TIPO_TELEFONO_1 FOREIGN KEY (DD_TIPO_TELEFONO_1)
      REFERENCES pfsmaster.DD_TTE_TIPO_TELEFONO (DD_TTE_ID);
      
-- FK DD_TIPO_TELEFONO_2 
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_DD_TIPO_TELEFONO_2 FOREIGN KEY (DD_TIPO_TELEFONO_2)
      REFERENCES pfsmaster.DD_TTE_TIPO_TELEFONO (DD_TTE_ID);
      
-- FK DD_TIPO_TELEFONO_3 
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_DD_TIPO_TELEFONO_3 FOREIGN KEY (DD_TIPO_TELEFONO_3)
      REFERENCES pfsmaster.DD_TTE_TIPO_TELEFONO (DD_TTE_ID);
      
-- FK DD_TIPO_TELEFONO_4 
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_DD_TIPO_TELEFONO_4 FOREIGN KEY (DD_TIPO_TELEFONO_4)
      REFERENCES pfsmaster.DD_TTE_TIPO_TELEFONO (DD_TTE_ID);
      
-- FK DD_TIPO_TELEFONO_5 
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_DD_TIPO_TELEFONO_5 FOREIGN KEY (DD_TIPO_TELEFONO_5)
      REFERENCES pfsmaster.DD_TTE_TIPO_TELEFONO (DD_TTE_ID);

-- FK DD_TIPO_TELEFONO_6 
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_DD_TIPO_TELEFONO_6 FOREIGN KEY (DD_TIPO_TELEFONO_6)
      REFERENCES pfsmaster.DD_TTE_TIPO_TELEFONO (DD_TTE_ID);

-- FK DD_POL_ID 
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_DD_POL_ID FOREIGN KEY (DD_POL_ID)
      REFERENCES pfsmaster.DD_POL_POLITICAS (DD_POL_ID);

-- FK OFI_ID 
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_PER_OFI_ID FOREIGN KEY (OFI_ID)
      REFERENCES OFI_OFICINAS (OFI_ID);

-- FK DD_GGE_ID 
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_PER_DD_GGE_ID FOREIGN KEY (DD_GGE_ID)
      REFERENCES pfsmaster.DD_GGE_GRUPO_GESTOR (DD_GGE_ID);
      
-- FK DD_REX_ID	
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_PER_DD_REX_ID FOREIGN KEY (DD_REX_ID)
      REFERENCES pfsmaster.DD_REX_RATING_EXTERNO (DD_REX_ID);
      
-- FK DD_RAX_ID 
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_PER_DD_RAX_ID FOREIGN KEY (DD_RAX_ID)
      REFERENCES pfsmaster.DD_RAX_RATING_AUXILIAR (DD_RAX_ID);
      
-- FK DD_PX3_ID 
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_PER_DD_PX3_ID FOREIGN KEY (DD_PX3_ID)
      REFERENCES pfsmaster.DD_PX3_PERSONA_EXTRA_3 (DD_PX3_ID);
      
-- FK DD_PX4_ID 
ALTER TABLE PER_PERSONAS
   ADD CONSTRAINT FK_PER_DD_PX4_ID FOREIGN KEY (DD_PX4_ID)
      REFERENCES pfsmaster.DD_PX4_PERSONA_EXTRA_4 (DD_PX4_ID);
                                                            
-- Agregar columnas a TMP_PER_PERSONAS                               
ALTER TABLE TMP_PER_PERSONAS ADD(                                    
  TMP_PER_CONTACTO VARCHAR2(90  CHAR),                                       
  TMP_PER_RIESGO  NUMBER(14, 2),                                       
  TMP_PER_RIESGO_IND  NUMBER(14, 2),                                       
  TMP_PER_NRO_SOCIOS NUMBER(5),
  TMP_PER_NRO_EMPLEADOS NUMBER(6),
  TMP_PER_TELEFONO_5 VARCHAR2(20 CHAR),																				
  TMP_PER_TELEFONO_6 VARCHAR2(20 CHAR),                                       
  TMP_PER_VR_OTRAS_ENT NUMBER(14,2),                                   
  TMP_PER_VR_DANIADO_OTRAS_ENT	NUMBER(14,2),                          
  TMP_PER_EXTRA_1 NUMBER(14, 2),                                       
  TMP_PER_EXTRA_2 NUMBER(14, 2),                                       
  TMP_PER_NACIONALIDAD		VARCHAR2(3 CHAR),																							
  TMP_PER_PAIS_NACIMIENTO VARCHAR2(3 CHAR),
  TMP_PER_SEXO VARCHAR2(1 CHAR),                                  
  TMP_DD_TIPO_TELEFONO_1 VARCHAR2(5 CHAR),                                   
  TMP_DD_TIPO_TELEFONO_2 VARCHAR2(5 CHAR),                                   
  TMP_DD_TIPO_TELEFONO_3 VARCHAR2(5 CHAR),                                   
  TMP_DD_TIPO_TELEFONO_4 VARCHAR2(5 CHAR),                                   
  TMP_DD_TIPO_TELEFONO_5 VARCHAR2(5 CHAR),                                   
  TMP_DD_TIPO_TELEFONO_6 VARCHAR2(5 CHAR),                                   
  TMP_PEF_ID 	NUMBER(16),                                              
  TMP_USU_USERNAME	VARCHAR2(50 CHAR),                                              
  TMP_ZON_NUM_CENTRO	VARCHAR2(20 CHAR),                                              
  TMP_DD_POL_CODIGO VARCHAR2(10 CHAR),                                         
  TMP_OFI_CODIGO NUMBER(16),
  TMP_DD_GGE_CODIGO NUMBER (16),                                           
  TMP_DD_REX_CODIGO	VARCHAR2(10 CHAR),                                           
  TMP_DD_RAX_CODIGO VARCHAR2(10 CHAR),                                           
  TMP_DD_PER_EXTRA_3_CODIGO VARCHAR2(10 CHAR),                                    
  TMP_DD_PER_EXTRA_4_CODIGO VARCHAR2(10 CHAR),                                    
  TMP_PER_FECHA_CONSTITUCION DATE,                                       
  TMP_PER_EXTRA_5 DATE,                                         
	TMP_PER_EXTRA_6 DATE           
);

-- Agregar columnas a CNT_CONTRATOS
ALTER TABLE CNT_CONTRATOS ADD(
		CNT_LIMITE_INI		NUMBER(14, 2),
		CNT_LIMITE_FIN		NUMBER(14, 2),
		DD_FCN_ID			NUMBER(16), -- Finalidad contrato --FK
		DD_FNO_ID			NUMBER(16), -- Finalidad oficial --FK
		DD_GC1_ID	NUMBER(16),	--Garantia 1 --FK
		DD_GC2_ID	NUMBER(16), --Garantia 2 --FK
		DD_CT1_ID	NUMBER(16), --Catalogo1 --FK
		DD_CT2_ID	NUMBER(16),--FK
		DD_CT3_ID	NUMBER(16),--FK
		DD_CT4_ID	NUMBER(16),--FK
		DD_CT5_ID	NUMBER(16),--FK
		DD_CT6_ID	NUMBER(16),--FK
		CNT_FECHA_CONSTITUCION	DATE,
		CNT_FECHA_VENC	DATE
);       

-- FK DD_FCN_ID
ALTER TABLE CNT_CONTRATOS                                      
   ADD CONSTRAINT FK_CNT_DD_FCN_ID FOREIGN KEY (DD_FCN_ID)    
      REFERENCES pfsmaster.DD_FCN_FINALIDAD_CONTRATO (DD_FCN_ID);

-- FK DD_FNO_ID
ALTER TABLE CNT_CONTRATOS                                      
   ADD CONSTRAINT FK_CNT_DD_FNO_ID FOREIGN KEY (DD_FNO_ID)    
      REFERENCES pfsmaster.DD_FNO_FINALIDAD_OFICIAL (DD_FNO_ID); 

-- FK DD_GC1_ID
ALTER TABLE CNT_CONTRATOS                                      
   ADD CONSTRAINT FK_CNT_DD_GCN_ID FOREIGN KEY (DD_GC1_ID)    
      REFERENCES pfsmaster.DD_GCN_GARANTIA_CONTRATO (DD_GCN_ID); 

-- FK DD_GC2_ID
ALTER TABLE CNT_CONTRATOS                                      
   ADD CONSTRAINT FK_CNT_DD_GC2_ID FOREIGN KEY (DD_GC2_ID)    
      REFERENCES pfsmaster.DD_GCN_GARANTIA_CONTRATO (DD_GCN_ID); 

-- FK DD_CT1_ID
ALTER TABLE CNT_CONTRATOS                                      
   ADD CONSTRAINT FK_CNT_DD_CT1_ID FOREIGN KEY (DD_CT1_ID)    
      REFERENCES pfsmaster.DD_CT1_CATALOGO_1 (DD_CT1_ID); 

-- FK DD_CT2_ID
ALTER TABLE CNT_CONTRATOS                                      
   ADD CONSTRAINT FK_CNT_DD_CT2_ID FOREIGN KEY (DD_CT2_ID)    
      REFERENCES pfsmaster.DD_CT2_CATALOGO_2 (DD_CT2_ID); 

-- FK DD_CT3_ID
ALTER TABLE CNT_CONTRATOS                                      
   ADD CONSTRAINT FK_CNT_DD_CT3_ID FOREIGN KEY (DD_CT3_ID)    
      REFERENCES pfsmaster.DD_CT3_CATALOGO_3 (DD_CT3_ID); 

-- FK DD_CT4_ID
ALTER TABLE CNT_CONTRATOS                                      
   ADD CONSTRAINT FK_CNT_DD_CT4_ID FOREIGN KEY (DD_CT4_ID)    
      REFERENCES pfsmaster.DD_CT4_CATALOGO_4 (DD_CT4_ID); 

-- FK DD_CT5_ID
ALTER TABLE CNT_CONTRATOS                                      
   ADD CONSTRAINT FK_CNT_DD_CT5_ID FOREIGN KEY (DD_CT5_ID)    
      REFERENCES pfsmaster.DD_CT5_CATALOGO_5 (DD_CT5_ID); 

-- FK DD_CT6_ID
ALTER TABLE CNT_CONTRATOS                                      
   ADD CONSTRAINT FK_CNT_DD_CT6_ID FOREIGN KEY (DD_CT6_ID)    
      REFERENCES pfsmaster.DD_CT6_CATALOGO_6 (DD_CT6_ID); 


-- Agregar columnas a TMP_CNT_CONTRATOS
ALTER TABLE TMP_CNT_CONTRATOS ADD(
		TMP_CNT_LIMITE_INI		NUMBER(14, 2),
		TMP_CNT_LIMITE_FIN		NUMBER(14, 2),
		TMP_CNT_FINALIDAD_OFI		VARCHAR2(3 char),
		TMP_CNT_FINALIDAD_CON		VARCHAR2(3 char),
		TMP_CNT_GARANTIA_1	NUMBER(4),
		TMP_CNT_GARANTIA_2	NUMBER(4),
		TMP_CNT_CATALOGO_1	VARCHAR(10 CHAR),
		TMP_CNT_CATALOGO_2	VARCHAR(10 CHAR),
		TMP_CNT_CATALOGO_3	VARCHAR(10 CHAR),
		TMP_CNT_CATALOGO_4	VARCHAR(10 CHAR),
		TMP_CNT_CATALOGO_5	VARCHAR(10 CHAR),
		TMP_CNT_CATALOGO_6	VARCHAR(10 CHAR),
		TMP_CNT_NOMBRE_CATALOGO	VARCHAR(255 CHAR),
		TMP_CNT_FECHA_CONSTITUCION	DATE,
		TMP_CNT_FECHA_VENC	DATE,
		TMP_CNT_RIESGO NUMBER(14, 2),
		TMP_CNT_RIESGO_IND NUMBER(14, 2),
		TMP_CNT_DEUDA_IRREGULAR NUMBER(14, 2),
		TMP_CNT_DISPUESTO	NUMBER(14, 2),
		TMP_CNT_SALDO_PASIVO	NUMBER(14, 2),
		TMP_CNT_RIESGO_GARANT	NUMBER(14, 2),
		TMP_CNT_SALDO_EXCE NUMBER(14, 2),
		TMP_CNT_LIMITE_DESC	NUMBER(14, 4),
		TMP_CNT_EXTRA_1	NUMBER(14, 2),
		TMP_CNT_EXTRA_2 NUMBER(14, 2),
		TMP_CNT_LTV_INI	 NUMBER(16),
		TMP_CNT_LTV_FIN	 NUMBER(16),
		TMP_CNT_EXTRA_3_CODIGO	NUMBER(16),
		TMP_CNT_EXTRA_4_CODIGO	NUMBER(16),
		TMP_CNT_EXTRA_5	DATE,
		TMP_CNT_EXTRA_6	DATE
);



-- Modulo de politicas
CREATE SEQUENCE S_MOT_MOTIVO START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_TEN_TENDENCIA START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_TPL_TIPO_POLITICA START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_TOB_TIPO_OBJETIVO START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_OBJ_OBJETIVO START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_POL_POLITICA START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_EIP_EST_ITI_POLITICA START WITH ${initialId} NOCYCLE CACHE 100;

/*==============================================================*/
/* Table: MOT_MOTIVO                                            */
/*==============================================================*/
CREATE TABLE MOT_MOTIVO (
   MOT_ID                   NUMBER(16)          NOT NULL,
   MOT_CODIGO               VARCHAR2(20 CHAR)   NOT NULL,
   MOT_DESCRIPCION          VARCHAR2(50 CHAR),
   MOT_DESCRIPCION_LARGA    VARCHAR2(250 CHAR),
   VERSION                  INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_MOT_MOTIVO PRIMARY KEY (MOT_ID),
   CONSTRAINT MOT_CODIGO_UK UNIQUE (MOT_CODIGO)
);

/*==============================================================*/
/* Table: TEN_TENDENCIA                                         */
/*==============================================================*/
CREATE TABLE TEN_TENDENCIA  (
   TEN_ID                   NUMBER(16)          NOT NULL,
   TEN_CODIGO               VARCHAR2(20 CHAR)   NOT NULL,
   TEN_DESCRIPCION          VARCHAR2(50 CHAR),
   TEN_DESCRIPCION_LARGA    VARCHAR2(250 CHAR),
   VERSION                  INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_TEN_TENDENCIA PRIMARY KEY (TEN_ID),
   CONSTRAINT TEN_CODIGO_UK UNIQUE (TEN_CODIGO)
);

/*==============================================================*/
/* Table: TPL_TIPO_POLITICA                                     */
/*==============================================================*/
CREATE TABLE TPL_TIPO_POLITICA  (
   TPL_ID                   NUMBER(16)          NOT NULL,
   TPL_CODIGO               VARCHAR2(20 CHAR)   NOT NULL,
   TEN_ID                   NUMBER(16)          NOT NULL,
   TPL_DESCRIPCION          VARCHAR2(50 CHAR),
   TPL_DESCRIPCION_LARGA    VARCHAR2(250 CHAR),
   TPL_PRIORIDAD            NUMBER(16)			DEFAULT 0 NOT NULL,
   RD_ID  				    NUMBER(16),
   DD_POL_ID				NUMBER(16)			NOT NULL,
   VERSION                  INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_TPL_TIPO_POLITICA PRIMARY KEY (TPL_ID),
   CONSTRAINT TPL_CODIGO_UK UNIQUE (TPL_CODIGO)
);

ALTER TABLE TPL_TIPO_POLITICA
   ADD CONSTRAINT FK_TPL_FK_TEN FOREIGN KEY (TEN_ID)
      REFERENCES TEN_TENDENCIA (TEN_ID);

/*==============================================================*/
/* Table: TOB_TIPO_OBJETIVO                                         */
/*==============================================================*/
CREATE TABLE TOB_TIPO_OBJETIVO  (
   TOB_ID                   NUMBER(16)          NOT NULL,
   TOB_CODIGO               VARCHAR2(20 CHAR)   NOT NULL,
   TOB_DESCRIPCION          VARCHAR2(50 CHAR),
   TOB_DESCRIPCION_LARGA    VARCHAR2(250 CHAR),
   TOB_AUTOMATICO           INTEGER             DEFAULT 0 NOT NULL,
   VERSION                  INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_TOB_TIPO_OBJETIVO PRIMARY KEY (TOB_ID),
   CONSTRAINT TOB_CODIGO_UK UNIQUE (TOB_CODIGO)
);


/*==============================================================*/
/* Table: POL_POLITICA                                          */
/*==============================================================*/
CREATE TABLE POL_POLITICA  (
   POL_ID                   NUMBER(16)          NOT NULL,
   TPL_ID                   NUMBER(16)          NOT NULL,
   MOT_ID                   NUMBER(16)          NOT NULL,
   DD_ESP_ID                NUMBER(16)          NOT NULL,
   DD_EPI_ID                NUMBER(16)          NOT NULL,
   PER_ID                   NUMBER(16)          NOT NULL,
   POL_FECHA_CREACION       DATE                NOT NULL,
   POL_FECHA_VIGENCIA       DATE,
   POL_PROCESS_BPM          NUMBER(16),
   USU_ID                   NUMBER(16)          NOT NULL,
   VERSION                  INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_POL_POLITICA PRIMARY KEY (POL_ID)
);

ALTER TABLE POL_POLITICA
   ADD CONSTRAINT FK_POL_POLITICA_TPL_TIPO FOREIGN KEY (TPL_ID)
      REFERENCES TPL_TIPO_POLITICA (TPL_ID);

ALTER TABLE POL_POLITICA
   ADD CONSTRAINT FK_POL_POLITICA_MOT_MOTIVO FOREIGN KEY (MOT_ID)
      REFERENCES MOT_MOTIVO (MOT_ID);

ALTER TABLE POL_POLITICA
   ADD CONSTRAINT FK_POL_ESP_ESTADO FOREIGN KEY (DD_ESP_ID)
      REFERENCES pfsmaster.DD_ESP_ESTADO_POLITICA (DD_ESP_ID);

ALTER TABLE POL_POLITICA
   ADD CONSTRAINT FK_POL_EPI_EST_ITINERARIO FOREIGN KEY (DD_EPI_ID)
      REFERENCES pfsmaster.DD_EPI_EST_POL_ITINERARIO (DD_EPI_ID);

ALTER TABLE POL_POLITICA
   ADD CONSTRAINT FK_POL_POLITICA_PER_PERSONAS FOREIGN KEY (PER_ID)
      REFERENCES PER_PERSONAS (PER_ID);

ALTER TABLE POL_POLITICA
   ADD CONSTRAINT FK_POL_POLITICA_USU_USUARIOS FOREIGN KEY (USU_ID)
      REFERENCES pfsmaster.USU_USUARIOS (USU_ID);

/*==============================================================*/
/* Table: EIP_EST_ITI_POLITICA                        */
/*==============================================================*/
CREATE TABLE EIP_EST_ITI_POLITICA  (
   EIP_ID                   NUMBER(16)          NOT NULL,
   POL_ID                   NUMBER(16)          NOT NULL,
   EIP_TIPO_POL             VARCHAR2(250 CHAR)  NOT NULL,
   DD_EPI_ID                NUMBER(16)          NOT NULL,
   EIP_GES_PERFIL           VARCHAR2(250 CHAR)  NOT NULL,
   EIP_SUP_PERFIL           VARCHAR2(250 CHAR)  NOT NULL,
   EIP_USU_NOMBRE           VARCHAR2(250 CHAR)  NOT NULL,
   EIP_FECHA                DATE                NOT NULL,
   VERSION                  INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_EIP_EST_ITI_POL PRIMARY KEY (EIP_ID)
);


ALTER TABLE EIP_EST_ITI_POLITICA
   ADD CONSTRAINT FK_EIP_ESP_ESTADO FOREIGN KEY (DD_EPI_ID)
      REFERENCES pfsmaster.DD_EPI_EST_POL_ITINERARIO (DD_EPI_ID);

ALTER TABLE EIP_EST_ITI_POLITICA
   ADD CONSTRAINT FK_EIP_POL_POLITICA FOREIGN KEY (POL_ID)
      REFERENCES POL_POLITICA (POL_ID);

/*==============================================================*/
/* Table: OBJ_OBJETIVO                                          */
/*==============================================================*/
CREATE TABLE OBJ_OBJETIVO  (
   OBJ_ID                   NUMBER(16)          NOT NULL,
   EIP_ID                   NUMBER(16)          NOT NULL,
   OBJ_PADRE_ID             NUMBER(16),
   TOB_ID                   NUMBER(16),
   DD_ESO_ID                NUMBER(16)          NOT NULL,
   DD_ESC_ID                NUMBER(16)          NOT NULL,
   DD_TOP_ID                NUMBER(16),
   DD_EPI_ID                NUMBER(16)          NOT NULL,
   CNT_ID                   NUMBER(16),
   OBJ_OBSERVACION          VARCHAR2(250 CHAR),
   OBJ_RESUMEN              VARCHAR2(250 CHAR),
   OBJ_PROP_CUMPLE          VARCHAR2(250 CHAR),
   OBJ_RTA_PROP_CUMPLE      VARCHAR2(250 CHAR),
   OBJ_JUSTIFICACION        VARCHAR2(250 CHAR),
   OBJ_FECHA_LIMITE         DATE                NOT NULL,
   OBJ_FECHA_VIGENCIA       DATE,
   OBJ_VALOR                NUMBER(14,2),
   OBJ_PROCESS_BPM          NUMBER(16),
   VERSION                  INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_OBJ_OBJETIVO PRIMARY KEY (OBJ_ID)
);

ALTER TABLE OBJ_OBJETIVO
   ADD CONSTRAINT FK_OBJ_EIP_ESTADO_POL FOREIGN KEY (EIP_ID)
      REFERENCES EIP_EST_ITI_POLITICA (EIP_ID);

ALTER TABLE OBJ_OBJETIVO
   ADD CONSTRAINT FK_OBJ_OBJETIVO_OBJ_PADRE FOREIGN KEY (OBJ_PADRE_ID)
      REFERENCES OBJ_OBJETIVO (OBJ_ID);

ALTER TABLE OBJ_OBJETIVO
   ADD CONSTRAINT FK_OBJ_OBJETIVO_TOB_TIPO FOREIGN KEY (TOB_ID)
      REFERENCES TOB_TIPO_OBJETIVO (TOB_ID);

ALTER TABLE OBJ_OBJETIVO
   ADD CONSTRAINT FK_OBJ_OBJETIVO_DD_ESO FOREIGN KEY (DD_ESO_ID)
      REFERENCES pfsmaster.DD_ESO_ESTADO_OBJETIVO (DD_ESO_ID);

ALTER TABLE OBJ_OBJETIVO
   ADD CONSTRAINT FK_OBJ_OBJETIVO_DD_ESC FOREIGN KEY (DD_ESC_ID)
      REFERENCES pfsmaster.DD_ESC_ESTADO_CUMPLIMIENTO (DD_ESC_ID);

ALTER TABLE OBJ_OBJETIVO
   ADD CONSTRAINT FK_OBJ_OBJETIVO_DD_TOP FOREIGN KEY (DD_TOP_ID)
      REFERENCES pfsmaster.DD_TOP_TIPO_OPERADOR (DD_TOP_ID);

ALTER TABLE OBJ_OBJETIVO
   ADD CONSTRAINT FK_OBJ_OBJETIVO_CNT_CONTRATOS FOREIGN KEY (CNT_ID)
      REFERENCES CNT_CONTRATOS (CNT_ID);

ALTER TABLE OBJ_OBJETIVO
   ADD CONSTRAINT FK_OBJ_ESTADO FOREIGN KEY (DD_EPI_ID)
      REFERENCES pfsmaster.DD_EPI_EST_POL_ITINERARIO (DD_EPI_ID);

/*==============================================================*/
/* Table: APP_ANALISIS_PERSONA_POLITICA                         */
/*==============================================================*/
CREATE TABLE APP_ANALISIS_PERSONA_POLITICA  (
	APP_ID			 	 		 NUMBER(16)         	NOT NULL,
	POL_ID       	 	 		 NUMBER(16)         	NOT NULL,
	APP_COMENTARIO_GESTOR   	 VARCHAR2(20 CHAR)       NOT NULL,
    APP_COMENTARIO_SUPERVISOR 	 VARCHAR2(20 CHAR)       NOT NULL,
    APP_OBS_GEST_REALIZADAS      VARCHAR2(250 CHAR),
    VERSION                      INTEGER            DEFAULT 0 NOT NULL,
    USUARIOCREAR             	 VARCHAR2(10 CHAR)       NOT NULL,
    FECHACREAR               	 TIMESTAMP          NOT NULL,
    USUARIOMODIFICAR         	 VARCHAR2(10 CHAR),
    FECHAMODIFICAR           	 TIMESTAMP,
    USUARIOBORRAR            	 VARCHAR2(10 CHAR),
    FECHABORRAR              	 TIMESTAMP,
    BORRADO                  	 NUMBER(1,0)        DEFAULT 0 NOT NULL,
	CONSTRAINT PK_APP PRIMARY KEY (APP_ID)
);

ALTER TABLE APP_ANALISIS_PERSONA_POLITICA
   ADD CONSTRAINT FK_APP_POL FOREIGN KEY (POL_ID)
      REFERENCES POL_POLITICA (POL_ID);

/*==============================================================*/
/* Table: DD_PAR_PARCELAS                                       */
/*==============================================================*/
CREATE TABLE DD_PAR_PARCELAS  (
   DD_PAR_ID			 	 	NUMBER(16)         	NOT NULL,
   DD_PAR_CODIGO                VARCHAR2(20 CHAR)   NOT NULL,
   DD_PAR_DESCRIPCION           VARCHAR2(50 CHAR),
   DD_PAR_DESCRIPCION_LARGA     VARCHAR2(250 CHAR),
   DD_TAN_ID					NUMBER(16)			NOT NULL,
   VERSION                  	INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             	VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               	TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         	VARCHAR2(10 CHAR),
   FECHAMODIFICAR           	TIMESTAMP,
   USUARIOBORRAR            	VARCHAR2(10 CHAR),
   FECHABORRAR              	TIMESTAMP,
   BORRADO                  	NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_PAR_PARCELAS PRIMARY KEY (DD_PAR_ID),
   CONSTRAINT DD_PAR_CODIGO_UK UNIQUE (DD_PAR_CODIGO)
);

ALTER TABLE DD_PAR_PARCELAS
	ADD CONSTRAINT FK_APP_TAN FOREIGN KEY (DD_TAN_ID)
      REFERENCES pfsmaster.DD_TAN_TIPO_ANALISIS (DD_TAN_ID);

/*==============================================================*/
/* Table: PPS_PARCELA_PERSONA_SGTO                                       */
/*==============================================================*/
CREATE TABLE PPS_PARCELA_PERSONA_SGTO(
	PPS_ID						NUMBER(16)         	NOT NULL,		
	DD_PAR_ID					NUMBER(16)			NOT NULL,
	DD_SCL_ID					NUMBER(16)			NOT NULL,
    DD_TPE_ID					NUMBER(16)			NOT NULL,
	VERSION                  	INTEGER             DEFAULT 0 NOT NULL,
    USUARIOCREAR             	VARCHAR2(10 CHAR)   NOT NULL,
    FECHACREAR               	TIMESTAMP           NOT NULL,
    USUARIOMODIFICAR         	VARCHAR2(10 CHAR),
    FECHAMODIFICAR           	TIMESTAMP,
    USUARIOBORRAR            	VARCHAR2(10 CHAR),
    FECHABORRAR              	TIMESTAMP,
    BORRADO                  	NUMBER(1,0)         DEFAULT 0 NOT NULL,
    CONSTRAINT PPS_PARCELA_PERSONA_SGTO PRIMARY KEY (PPS_ID)
);

ALTER TABLE PPS_PARCELA_PERSONA_SGTO
	ADD CONSTRAINT FK_PPS_PAR FOREIGN KEY (DD_PAR_ID)
      REFERENCES DD_PAR_PARCELAS (DD_PAR_ID);

ALTER TABLE PPS_PARCELA_PERSONA_SGTO
	ADD CONSTRAINT FK_PPS_SCL FOREIGN KEY (DD_SCL_ID)
      REFERENCES DD_SCL_SEGTO_CLI (DD_SCL_ID);

ALTER TABLE PPS_PARCELA_PERSONA_SGTO
	ADD CONSTRAINT FK_PPS_TPE FOREIGN KEY (DD_TPE_ID)
      REFERENCES pfsmaster.DD_TPE_TIPO_PERSONA (DD_TPE_ID);

/*==============================================================*/
/* Table: APA_ANALISIS_PARCELA_PERSONA                          */                 
/*==============================================================*/
CREATE TABLE APA_ANALISIS_PARCELA_PERSONA  (
   APA_ID			 NUMBER(16)          NOT NULL,
   APA_COMENTARIO    VARCHAR2(250 CHAR)  NOT NULL,
   APP_ID            NUMBER(16)          NOT NULL,
   DD_PAR_ID	     NUMBER(16)          NOT NULL,
   DD_VAL_ID		 NUMBER(16)			 NOT NULL,
   DD_IMP_ID		 NUMBER(16)			 NOT NULL,
   VERSION           INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR      VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR        TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR  VARCHAR2(10 CHAR),
   FECHAMODIFICAR    TIMESTAMP,
   USUARIOBORRAR     VARCHAR2(10 CHAR),
   FECHABORRAR       TIMESTAMP,
   BORRADO           NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_APA_ANA_PARC_PERSONA PRIMARY KEY (APA_ID)
);

ALTER TABLE APA_ANALISIS_PARCELA_PERSONA
	ADD CONSTRAINT FK_APA_APP FOREIGN KEY (APP_ID)
      REFERENCES APP_ANALISIS_PERSONA_POLITICA (APP_ID);

ALTER TABLE APA_ANALISIS_PARCELA_PERSONA
	ADD CONSTRAINT FK_APA_DD_PAR FOREIGN KEY (DD_PAR_ID)
      REFERENCES DD_PAR_PARCELAS (DD_PAR_ID);

ALTER TABLE APA_ANALISIS_PARCELA_PERSONA
	ADD CONSTRAINT FK_APA_DD_VAL FOREIGN KEY (DD_VAL_ID)
      REFERENCES pfsmaster.DD_VAL_VALORACION(DD_VAL_ID);

ALTER TABLE APA_ANALISIS_PARCELA_PERSONA
	ADD CONSTRAINT FK_APA_DD_IMP FOREIGN KEY (DD_IMP_ID)
      REFERENCES pfsmaster.DD_IMP_IMPACTO(DD_IMP_ID);


/*==============================================================*/
/* Table: APA_ANALISIS_PERSONA_OPERAC                          */                 
/*==============================================================*/
CREATE TABLE APO_ANALISIS_PERSONA_OPERAC  (
   APO_ID			 NUMBER(16)          NOT NULL,
   APO_COMENTARIO    VARCHAR2(250 CHAR)  NOT NULL,
   CNT_ID	         NUMBER(16)          NOT NULL,
   APP_ID			 NUMBER(16)			 NOT NULL,
   DD_VAL_ID		 NUMBER(16)			 NOT NULL,
   DD_IMP_ID		 NUMBER(16)			 NOT NULL,
   VERSION           INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR      VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR        TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR  VARCHAR2(10 CHAR),
   FECHAMODIFICAR    TIMESTAMP,
   USUARIOBORRAR     VARCHAR2(10 CHAR),
   FECHABORRAR       TIMESTAMP,
   BORRADO           NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_APO_ANA_PER_OP PRIMARY KEY (APO_ID)
);

ALTER TABLE APO_ANALISIS_PERSONA_OPERAC
	ADD CONSTRAINT FK_APO_CNT FOREIGN KEY (CNT_ID)
      REFERENCES CNT_CONTRATOS (CNT_ID);

ALTER TABLE APO_ANALISIS_PERSONA_OPERAC
	ADD CONSTRAINT FK_APO_APP FOREIGN KEY (APP_ID)
      REFERENCES APP_ANALISIS_PERSONA_POLITICA (APP_ID);

ALTER TABLE APO_ANALISIS_PERSONA_OPERAC
	ADD CONSTRAINT FK_APO_DD_VAL FOREIGN KEY (DD_VAL_ID)
      REFERENCES pfsmaster.DD_VAL_VALORACION(DD_VAL_ID);

ALTER TABLE APO_ANALISIS_PERSONA_OPERAC
	ADD CONSTRAINT FK_APO_DD_IMP FOREIGN KEY (DD_IMP_ID)
      REFERENCES pfsmaster.DD_IMP_IMPACTO(DD_IMP_ID);



ALTER TABLE HAC_HISTORICO_ACCESOS
 ADD (CNT_ID  NUMBER(16));
 
ALTER TABLE HAC_HISTORICO_ACCESOS ADD (
  CONSTRAINT FK_HAC_HIST_FK_HAC_CNT_CONTR 
 FOREIGN KEY (CNT_ID) 
 REFERENCES CNT_CONTRATOS (CNT_ID));


INSERT INTO TOB_TIPO_OBJETIVO(TOB_ID,TOB_CODIGO, TOB_DESCRIPCION,TOB_AUTOMATICO, TOB_CONTRATO, USUARIOCREAR,FECHACREAR)
VALUES      (1, 'TOB01', 'Credito personal Manual',0, 0, 'dummy', SYSDATE);
INSERT INTO TOB_TIPO_OBJETIVO(TOB_ID,TOB_CODIGO, TOB_DESCRIPCION,TOB_AUTOMATICO, TOB_CONTRATO, USUARIOCREAR,FECHACREAR)
VALUES      (2, 'TOB02', 'Credito personal Auto',1, 0, 'dummy', SYSDATE);
INSERT INTO TOB_TIPO_OBJETIVO(TOB_ID,TOB_CODIGO, TOB_DESCRIPCION,TOB_AUTOMATICO, TOB_CONTRATO, USUARIOCREAR,FECHACREAR)
VALUES      (3, 'TOB03', 'Prestamo Manual',0, 0, 'dummy', SYSDATE);
INSERT INTO TOB_TIPO_OBJETIVO(TOB_ID,TOB_CODIGO, TOB_DESCRIPCION,TOB_AUTOMATICO, TOB_CONTRATO, USUARIOCREAR,FECHACREAR)
VALUES      (4, 'TOB04', 'Prestamo Auto',1, 1, 'dummy', SYSDATE);


CREATE SEQUENCE S_CIR_CIRBE START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_ALE_ALERTAS START WITH ${initialId} NOCYCLE CACHE 100; 
CREATE SEQUENCE S_TMP_ALE_ALERTAS START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_FRC_FICHEROS_CARGADOS START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_GRC_GRUPO_CARGA START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_GAL_GRUPO_ALERTA START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_TAL_TIPO_ALERTA START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_NGR_NIVEL_GRAVEDAD START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_ START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_FME_FICHERO_METRICAS START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_MTR_METRICAS START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_MTT_METRICAS_TIPO START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_MTG_METRICAS_TIPO_GRAVEDAD START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_PPA_PUNTUACION_PARCIAL START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_PTO_PUNTUACION_TOTAL START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_GCL_GRUPOS_CLIENTES START WITH ${initialId} NOCYCLE CACHE 100;
CREATE SEQUENCE S_PER_GCL START WITH ${initialId} NOCYCLE CACHE 100;
 
 

ALTER TABLE DD_SCL_SEGTO_CLI
 ADD (DD_SCL_CODIGO  VARCHAR2(25 CHAR));
 
UPDATE DD_SCL_SEGTO_CLI
set DD_SCL_CODIGO = DD_SCL_ID;
 
ALTER TABLE DD_SCL_SEGTO_CLI
MODIFY(DD_SCL_CODIGO  NOT NULL);
 
 
ALTER TABLE AAR_ACTUACIONES_REALIZADAS
   DROP CONSTRAINT FK_AAR_ACTUACIONES_DD_TAA;

ALTER TABLE AAR_ACTUACIONES_REALIZADAS
RENAME COLUMN DD_TAA_ID TO DD_TAY_ID;

 
ALTER TABLE AAR_ACTUACIONES_REALIZADAS
   ADD CONSTRAINT FK_AAR_ACTUACIONES_DD_TAY FOREIGN KEY (DD_TAY_ID)
      REFERENCES pfsmaster.DD_TAY_TIPO_AYUDA_ACUERDO (DD_TAY_ID);
 
 
CREATE TABLE TMP_CIR_CIRBE (
	TMP_CIR_ID					 NUMBER(16) NOT NULL,
	TMP_CIR_FECHA_FIN_MES		 DATE NOT NULL,
	TMP_CIR_COD_NRBE_EN     	 VARCHAR2(4 CHAR) NOT NULL,
	TMP_CIR_CLASE_RSGO_CIRBE     VARCHAR2(1 CHAR) NOT NULL,
	TMP_CIR_COD_PD_CIRBE         VARCHAR2(1 CHAR) NOT NULL,
	TMP_CIR_COD_DIVISA_CIRBE     VARCHAR2(1 CHAR) NOT NULL,
	TMP_CIR_COD_VTO_CIRBE        VARCHAR2(1 CHAR) NOT NULL,
	TMP_CIR_COD_GTIA_CIRBE       VARCHAR2(1 CHAR) NOT NULL,
	TMP_CIR_COD_SITIRREG_CIRBE   VARCHAR2(1 CHAR) NOT NULL,
	TMP_CIR_FECHA_ACTLZN		 DATE NOT NULL,
	TMP_CIR_ID_INTERNO_PE		 VARCHAR2(20 CHAR) NOT NULL,
	TMP_CIR_IMP_DSPTO_CIRBE_RC   NUMBER(14,2) NOT NULL,
	TMP_CIR_IMP_DISP_CIRBE_RC    NUMBER(14,2) NOT NULL,
	TMP_CIR_COD_ISO_PAIS_AG      VARCHAR2(2 CHAR) NOT NULL,
	TMP_CIR_NUM_PA               VARCHAR2(3 CHAR) NOT NULL,
	TMP_CIR_FECHA_CARGA          DATE                NOT NULL,
    TMP_CIR_FICHERO_CARGA        VARCHAR2(50 CHAR)        NOT NULL,
    VERSION                      INTEGER             DEFAULT 0 NOT NULL,
    USUARIOCREAR                 VARCHAR2(10 CHAR)        NOT NULL,
    FECHACREAR                   TIMESTAMP           NOT NULL,
    USUARIOMODIFICAR             VARCHAR2(10 CHAR),
    FECHAMODIFICAR               TIMESTAMP,
    USUARIOBORRAR                VARCHAR2(10 CHAR),
    FECHABORRAR                  TIMESTAMP,
    BORRADO                      NUMBER(1,0)         DEFAULT 0 NOT NULL,
    CONSTRAINT PK_TMP_CIR_ID PRIMARY KEY (TMP_CIR_ID)
);

CREATE TABLE CIR_CIRBE(
	CIR_ID				 NUMBER(16)		NOT NULL,
	DD_CRC_ID            NUMBER(16)     NOT NULL,
	DD_TMC_ID            NUMBER(16)     NOT NULL,
	DD_TSC_ID            NUMBER(16)     NOT NULL,
	DD_TVC_ID            NUMBER(16)     NOT NULL,
	DD_COC_ID            NUMBER(16)     NOT NULL,
	DD_TGC_ID            NUMBER(16)     NOT NULL,
	DD_CIC_ID			 NUMBER(16)		NOT NULL,	
	CIRBE_ANTERIOR		 NUMBER(16),
	CIR_DISPONIBLE		 NUMBER(14,2)   NOT NULL,
	CIR_DISPUESTO		 NUMBER(14,2)   NOT NULL,
	CIR_CANT_PART_SOLID  NUMBER(16)     NOT NULL,
	PER_ID				 NUMBER(16)     NOT NULL,
	CIR_FECHA_ACTUALIZAC TIMESTAMP		NOT NULL,
	CIR_FECHA_EXTRACCION DATE			NOT NULL,
	CIR_FICHERO_CARGA    VARCHAR2(50 CHAR)   NOT NULL,
	VERSION              INTEGER        DEFAULT 0 NOT NULL,
  	USUARIOCREAR         VARCHAR2(10 CHAR)   NOT NULL,
  	FECHACREAR           TIMESTAMP      NOT NULL,
  	USUARIOMODIFICAR     VARCHAR2(10 CHAR),
  	FECHAMODIFICAR       TIMESTAMP,
  	USUARIOBORRAR        VARCHAR2(10 CHAR),
  	FECHABORRAR          TIMESTAMP,
  	BORRADO              NUMBER(1,0)    DEFAULT 0 NOT NULL,
  	CONSTRAINT PK_CIR_ID PRIMARY KEY (CIR_ID)
);

CREATE TABLE TMP_ALE_ALERTAS (
    TMP_ALE_ID                   NUMBER(16)          NOT NULL,
    TMP_ALE_FECHA_EXTRACCION     DATE                NOT NULL,
    TMP_ALE_COD_ENTIDAD          NUMBER(4,0)         NOT NULL,
    TMP_ALE_COD_CLIENTE_ENTIDAD  NUMBER(16)          NOT NULL,
    TMP_ALE_COD_GRUPO_CARGA      VARCHAR2(20 CHAR)        NOT NULL,
    TMP_ALE_COD_ALERTA           VARCHAR2(20 CHAR)        NOT NULL,
    TMP_ALE_COD_GRAVEDAD         VARCHAR2(20 CHAR)        NOT NULL,
    TMP_ALE_FECHA_CARGA          DATE                NOT NULL,
    TMP_ALE_FICHERO_CARGA        VARCHAR2(50 CHAR)        NOT NULL,
    TMP_COD_CONTRATO             VARCHAR2(10 CHAR),
    TMP_COD_CENTRO_CNT           VARCHAR2(4 CHAR),
    TMP_COD_CENTRO_ALE           VARCHAR2(4 CHAR)    NOT NULL
    VERSION                      INTEGER             DEFAULT 0 NOT NULL,
    USUARIOCREAR                 VARCHAR2(10 CHAR)        NOT NULL,
    FECHACREAR                   TIMESTAMP           NOT NULL,
    USUARIOMODIFICAR             VARCHAR2(10 CHAR),
    FECHAMODIFICAR               TIMESTAMP,
    USUARIOBORRAR                VARCHAR2(10 CHAR),
    FECHABORRAR                  TIMESTAMP,
    BORRADO                      NUMBER(1,0)         DEFAULT 0 NOT NULL,
    CONSTRAINT PK_TMP_ALE_ID PRIMARY KEY (TMP_ALE_ID)
);

CREATE TABLE FRC_FICHEROS_CARGADOS (
    FRC_ID                  NUMBER(16)          NOT NULL,
    DD_TFI_ID               NUMBER(16)          NOT NULL,
    FRC_ULTIMO              NUMBER(1,0)         DEFAULT 0 NOT NULL,
    FRC_FECHA_EXTRACCION    DATE                NOT NULL,   
    VERSION                 INTEGER             DEFAULT 0 NOT NULL,
    USUARIOCREAR            VARCHAR2(10 CHAR)        NOT NULL,
    FECHACREAR              TIMESTAMP           NOT NULL,
    USUARIOMODIFICAR        VARCHAR2(10 CHAR),
    FECHAMODIFICAR          TIMESTAMP,
    USUARIOBORRAR           VARCHAR2(10 CHAR),
    FECHABORRAR             TIMESTAMP,
    BORRADO                 NUMBER(1,0)         DEFAULT 0 NOT NULL,
    CONSTRAINT PK_FRC_ID PRIMARY KEY (FRC_ID)
);

CREATE TABLE ALE_ALERTAS (
    ALE_ID                  NUMBER(16)          NOT NULL,
    PER_ID                  NUMBER(16)          NOT NULL,
    TAL_ID                  NUMBER(16)          NOT NULL,
    NGR_ID                  NUMBER(16)          NOT NULL,
    ALE_FECHA_EXTRACCION    DATE                NOT NULL,    
    ALE_FECHA_CARGA         DATE                NOT NULL,   
    ALE_FICHERO_CARGA       VARCHAR2(50 CHAR)        NOT NULL,
    CNT_ID                  NUMBER(16),
    OFI_ID_CNT              NUMBER(16),
    OFI_ID_ALE              NUMBER(16)          NOT NULL,
    ALE_ACTIVO              INTEGER             DEFAULT 0 NOT NULL,
    VERSION                 INTEGER             DEFAULT 0 NOT NULL,
    USUARIOCREAR            VARCHAR2(10 CHAR)        NOT NULL,
    FECHACREAR              TIMESTAMP           NOT NULL,
    USUARIOMODIFICAR        VARCHAR2(10 CHAR),
    FECHAMODIFICAR          TIMESTAMP,
    USUARIOBORRAR           VARCHAR2(10 CHAR),
    FECHABORRAR             TIMESTAMP,
    BORRADO                 NUMBER(1,0)         DEFAULT 0 NOT NULL,
    CONSTRAINT PK_ALE_ID PRIMARY KEY (ALE_ID)
);

ALTER TABLE ALE_ALERTAS
ADD CONSTRAINT FK_ALE_ALERTAS_OFI_CNT FOREIGN KEY (OFI_ID_CNT)
      REFERENCES OFI_OFICINAS (OFI_ID);

ALTER TABLE ALE_ALERTAS
ADD CONSTRAINT FK_ALE_ALERTAS_OFI_ALE FOREIGN KEY (OFI_ID_ALE)
      REFERENCES OFI_OFICINAS (OFI_ID);

ALTER TABLE ALE_ALERTAS
ADD CONSTRAINT FK_ALE_CNT FOREIGN KEY (CNT_ID)
      REFERENCES CNT_CONTRATOS (CNT_ID);
 
/*==============================================================*/
/* Table: GRC_GRUPO_CARGA                                    */
/*==============================================================*/
CREATE TABLE GRC_GRUPO_CARGA  (
   GRC_ID                   NUMBER(16)                      NOT NULL,
   GRC_CODIGO               VARCHAR2(20 CHAR)                    NOT NULL,
   GRC_DESCRIPCION          VARCHAR2(50 CHAR),
   GRC_DESCRIPCION_LARGA    VARCHAR2(250 CHAR),
   VERSION                  INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR               TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_GRC_GRUPO_CARGA PRIMARY KEY (GRC_ID)
);

/*==============================================================*/
/* Table: TAL_TIPO_ALERTA                            */
/*==============================================================*/
CREATE TABLE TAL_TIPO_ALERTA  (
   TAL_ID                   NUMBER(16)                      NOT NULL,
   TAL_CODIGO               VARCHAR2(20 CHAR)                    NOT NULL,
   GAL_ID                   NUMBER(16)                      NOT NULL,
   GRC_ID                   NUMBER(16)                      NOT NULL,
   TAL_DESCRIPCION          VARCHAR2(50 CHAR),
   TAL_DESCRIPCION_LARGA    VARCHAR2(250 CHAR),
   VERSION                  INTEGER                         DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR               TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_TAL_TIPO_ALERTA PRIMARY KEY (TAL_ID)
);

/*==============================================================*/
/* Table: GAL_GRUPO_ALERTA                            */
/*==============================================================*/
CREATE TABLE GAL_GRUPO_ALERTA  (
   GAL_ID                   NUMBER(16)                      NOT NULL,
   GAL_CODIGO               VARCHAR2(20 CHAR)                    NOT NULL,
   GAL_DESCRIPCION          VARCHAR2(50 CHAR),
   GAL_DESCRIPCION_LARGA    VARCHAR2(250 CHAR),
   VERSION                  INTEGER                         DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR               TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_GAL_GRUPO_ALERTA PRIMARY KEY (GAL_ID)
);


/*==============================================================*/
/* Table: NGR_NIVEL_GRAVEDAD                            */
/*==============================================================*/
CREATE TABLE NGR_NIVEL_GRAVEDAD  (
   NGR_ID                   NUMBER(16)                      NOT NULL,
   NGR_ORDEN                INTEGER                         NOT NULL,
   NGR_CODIGO               VARCHAR2(20 CHAR)                    NOT NULL,
   NGR_DESCRIPCION          VARCHAR2(50 CHAR),
   NGR_DESCRIPCION_LARGA    VARCHAR2(250 CHAR),
   VERSION                  INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)                    NOT NULL,
   FECHACREAR               TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_NGR_NIVEL_GRAVEDAD PRIMARY KEY (NGR_ID)
);

/*==============================================================*/
/* Table: FME_FICHERO_METRICAS                                          */
/*==============================================================*/
CREATE TABLE FME_FICHERO_METRICAS  (
   FME_ID                   NUMBER(16)         NOT NULL,
   DD_TPE_ID                NUMBER(16),
   DD_SCE_ID                NUMBER(16),
   FME_FICHERO              BLOB,
   FME_FECHA_CARGA          DATE               NOT NULL,   
   VERSION                  INTEGER            DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)       NOT NULL,
   FECHACREAR               TIMESTAMP          NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)        DEFAULT 0 NOT NULL,
   CONSTRAINT PK_FME_FICHERO_METRICAS PRIMARY KEY (FME_ID)
);

ALTER TABLE FME_FICHERO_METRICAS
   ADD CONSTRAINT FK_FME_FIC_FK_DD_TPE_DD_TPE_T FOREIGN KEY (DD_TPE_ID)
      REFERENCES pfsmaster.DD_TPE_TIPO_PERSONA (DD_TPE_ID);

ALTER TABLE FME_FICHERO_METRICAS
   ADD CONSTRAINT FK_FME_FIC_FK_SCE_DD_SCE_S FOREIGN KEY (DD_SCE_ID)
      REFERENCES DD_SCE_SEGTO_CLI_ENTIDAD (DD_SCE_ID);
/**
 * Hay datos duplicados para evitar acceder a la tablas de archivos. 
 * Ademas es posible que se borre la metrica perdiendo la referencia al archivo,
 * por lo cual los datos extras permiten id el archivo.
 */
/*==============================================================*/
/* Table: MTR_METRICAS                                          */
/*==============================================================*/
CREATE TABLE MTR_METRICAS  (
   MTR_ID                   NUMBER(16)         NOT NULL,
   DD_TPE_ID                NUMBER(16),
   DD_SCE_ID                NUMBER(16),
   FME_ID                   NUMBER(16)         NOT NULL,
   MTR_FECHA_ACTIVACION     DATE,   
   MTR_FICHERO_CARGA        VARCHAR2(50 CHAR)       NOT NULL,
   MTR_ACTIVO               INTEGER            DEFAULT 0 NOT NULL,
   VERSION                  INTEGER            DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)       NOT NULL,
   FECHACREAR               TIMESTAMP          NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)        DEFAULT 0 NOT NULL,
   CONSTRAINT PK_MTR_METRICAS PRIMARY KEY (MTR_ID)
);

ALTER TABLE MTR_METRICAS
   ADD CONSTRAINT FK_MTR_MET_FK_DD_TPE_DD_TPE_T FOREIGN KEY (DD_TPE_ID)
      REFERENCES pfsmaster.DD_TPE_TIPO_PERSONA (DD_TPE_ID);

ALTER TABLE MTR_METRICAS
   ADD CONSTRAINT FK_MTR_MET_FK_SCE_DD_SCE_S FOREIGN KEY (DD_SCE_ID)
      REFERENCES DD_SCE_SEGTO_CLI_ENTIDAD (DD_SCE_ID);

ALTER TABLE MTR_METRICAS
   ADD CONSTRAINT FK_MTR_MET_FK_FME_FIC_MET FOREIGN KEY (FME_ID)
      REFERENCES FME_FICHERO_METRICAS (FME_ID);

/*==============================================================*/
/* Table: MTT_METRICAS_TIPO                                          */
/*==============================================================*/
CREATE TABLE MTT_METRICAS_TIPO  (
   MTT_ID                   NUMBER(16)         NOT NULL,
   MTR_ID                   NUMBER(16)         NOT NULL,
   TAL_ID                   NUMBER(16)         NOT NULL,
   MTT_PREOCUPACION         INTEGER,
   VERSION                  INTEGER            DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)       NOT NULL,
   FECHACREAR               TIMESTAMP          NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)        DEFAULT 0 NOT NULL,
   CONSTRAINT PK_MTT_METRICAS PRIMARY KEY (MTT_ID)
);

ALTER TABLE MTT_METRICAS_TIPO
   ADD CONSTRAINT FK_MTT_MTR FOREIGN KEY (MTR_ID)
      REFERENCES MTR_METRICAS(MTR_ID);

ALTER TABLE MTT_METRICAS_TIPO
   ADD CONSTRAINT FK_MTT_TAL FOREIGN KEY (TAL_ID)
      REFERENCES TAL_TIPO_ALERTA(TAL_ID);

/*==============================================================*/
/* Table: MTG_METRICAS_TIPO_GRAVEDAD                            */
/*==============================================================*/
CREATE TABLE MTG_METRICAS_TIPO_GRAVEDAD  (
   MTG_ID                   NUMBER(16)         NOT NULL,
   MTT_ID                   NUMBER(16)         NOT NULL,
   NGR_ID                   NUMBER(16)         NOT NULL,
   MTG_PESO                 INTEGER,
   VERSION                  INTEGER            DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)       NOT NULL,
   FECHACREAR               TIMESTAMP          NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)        DEFAULT 0 NOT NULL,
   CONSTRAINT PK_MTG_METRICAS PRIMARY KEY (MTG_ID)
);

ALTER TABLE MTG_METRICAS_TIPO_GRAVEDAD
   ADD CONSTRAINT FK_MTG_MTT FOREIGN KEY (MTT_ID)
      REFERENCES MTT_METRICAS_TIPO(MTT_ID);

ALTER TABLE MTG_METRICAS_TIPO_GRAVEDAD
   ADD CONSTRAINT FK_MTG_NGR FOREIGN KEY (NGR_ID)
      REFERENCES NGR_NIVEL_GRAVEDAD(NGR_ID);

/*==============================================================*/
/* Table: PTO_PUNTUACION_TOTAL                                   */
/*==============================================================*/
CREATE TABLE PTO_PUNTUACION_TOTAL  (
   PTO_ID                   NUMBER(16)         NOT NULL,
   PER_ID                   NUMBER(16)         NOT NULL,
   PTO_VRC                  INTEGER            DEFAULT 0,
   PTO_PUNTUACION           INTEGER            DEFAULT 0,
   PTO_RATING               INTEGER            DEFAULT 0,
   PTO_RANGO_INTERVALO      INTEGER            DEFAULT 0,
   PTO_INTERVALO            VARCHAR2(100 CHAR),
   PTO_FECHA_PROCESADO      DATE               NOT NULL,
   PTO_ACTIVO               INTEGER            DEFAULT 0 NOT NULL,
   VERSION                  INTEGER            DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)       NOT NULL,
   FECHACREAR               TIMESTAMP          NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)        DEFAULT 0 NOT NULL,
   CONSTRAINT PK_PTO_PUNTUACION_TOTAL PRIMARY KEY (PTO_ID)
);

ALTER TABLE PTO_PUNTUACION_TOTAL
   ADD CONSTRAINT FK_PTO_FK_PER FOREIGN KEY (PER_ID)
      REFERENCES PER_PERSONAS (PER_ID);

/*==============================================================*/
/* Table: PPA_PUNTUACION_PARCIAL                                 */
/*==============================================================*/
CREATE TABLE PPA_PUNTUACION_PARCIAL  (
   PPA_ID                   NUMBER(16)         NOT NULL,
   PER_ID                   NUMBER(16)         NOT NULL,
   PTO_ID                   NUMBER(16)         NOT NULL,
   TAL_ID                   NUMBER(16)         NOT NULL,
   PPA_PREOCUPACION         INTEGER            DEFAULT 0,
   PPA_PESO_NVL_GRAVEDAD    INTEGER            DEFAULT 0,
   PPA_PUNTUACION           INTEGER            DEFAULT 0,
   PPA_FECHA_EXTRACCION     DATE               NOT NULL,    
   PPA_FECHA_METRICA        DATE               NOT NULL,
   PPA_FECHA_PROCESADO      DATE               NOT NULL,
   VERSION                  INTEGER            DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)       NOT NULL,
   FECHACREAR               TIMESTAMP          NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)        DEFAULT 0 NOT NULL,
   CONSTRAINT PK_PPA_PUNTUACION_PARCIAL PRIMARY KEY (PPA_ID)
);

ALTER TABLE PPA_PUNTUACION_PARCIAL
   ADD CONSTRAINT FK_PPA_FK_PER FOREIGN KEY (PER_ID)
      REFERENCES PER_PERSONAS (PER_ID);

/*==============================================================*/
/* Table: GCL_GRUPOS_CLIENTES                                   */
/*==============================================================*/
CREATE TABLE GCL_GRUPOS_CLIENTES  (
   GCL_ID                   NUMBER(16)         NOT NULL,
   DD_TGL_ID                NUMBER(16)         NOT NULL,
   GCL_CODIGO               VARCHAR2(20 CHAR)       NOT NULL,
   GCL_NOMBRE         		VARCHAR2(60 CHAR)       NOT NULL,
   GCL_FECHA_EXTRACCION		DATE			   NOT NULL,
   GCL_FICHERO_CARGA        VARCHAR2(40 CHAR)	   NOT NULL,
   VERSION                  INTEGER            DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)       NOT NULL,
   FECHACREAR               TIMESTAMP          NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)        DEFAULT 0 NOT NULL,
   CONSTRAINT PK_GCL_GRUPOS_CLIENTES PRIMARY KEY (GCL_ID)
);

/*==============================================================*/
/* Table: PER_GCL                                               */
/*==============================================================*/
CREATE TABLE PER_GCL (
	PER_GCL_ID				 NUMBER(16)         NOT NULL,
	GCL_ID                   NUMBER(16)         NOT NULL,
	PER_ID					 NUMBER(16)         NOT NULL,
	PER_GCL_FECHA_EXTRACCION DATE			    NOT NULL,
	PER_GCL_FICHERO_CARGA	 VARCHAR2(40 CHAR)		NOT NULL,
    VERSION                  INTEGER            DEFAULT 0 NOT NULL,
    USUARIOCREAR             VARCHAR2(10 CHAR)       NOT NULL,
    FECHACREAR               TIMESTAMP          NOT NULL,
    USUARIOMODIFICAR         VARCHAR2(10 CHAR),
    FECHAMODIFICAR           TIMESTAMP,
    USUARIOBORRAR            VARCHAR2(10 CHAR),
    FECHABORRAR              TIMESTAMP,
    BORRADO                  NUMBER(1,0)        DEFAULT 0 NOT NULL,
	CONSTRAINT PK_PER_GCL PRIMARY KEY (PER_GCL_ID)
);

/*==============================================================*/
/* Table: TMP_GCL_GRUPOS_CLIENTES                               */
/*==============================================================*/
CREATE TABLE TMP_GCL_GRUPOS_CLIENTES (
	TMP_GCL_ID				 NUMBER(16)         NOT NULL,
	TMP_GCL_CODIGO           VARCHAR2(20 CHAR)       NOT NULL,
    TMP_GCL_NOMBRE     		 VARCHAR2(60 CHAR)       NOT NULL,
	TMP_GCL_COD_ENTIDAD		 VARCHAR2(4 CHAR)		NOT NULL,
	TMP_GCL_TIPO_GRUPO		 VARCHAR2(20 CHAR)		NOT NULL,
	TMP_GCL_FECHA_EXTRACCION DATE			    NOT NULL,
	TMP_GCL_FICHERO_CARGA    VARCHAR2(40 CHAR)		NOT NULL,
    VERSION                  INTEGER            DEFAULT 0 NOT NULL,
    USUARIOCREAR             VARCHAR2(10 CHAR)       NOT NULL,
    FECHACREAR               TIMESTAMP          NOT NULL,
    USUARIOMODIFICAR         VARCHAR2(10 CHAR),
    FECHAMODIFICAR           TIMESTAMP,
    USUARIOBORRAR            VARCHAR2(10 CHAR),
    FECHABORRAR              TIMESTAMP,
    BORRADO                  NUMBER(1,0)        DEFAULT 0 NOT NULL,
	CONSTRAINT PK_TMP_GCL_GRUPOS_CLIENTES PRIMARY KEY (TMP_GCL_ID)
);

/*==============================================================*/
/* Table: TMP_PER_GCL                                           */
/*==============================================================*/
CREATE TABLE TMP_PER_GCL  (
	TMP_PER_GCL_ID			 	 NUMBER(16)         NOT NULL,
	TMP_PER_GCL_COD_ENTIDAD	 	 VARCHAR2(4 CHAR)		NOT NULL,
	TMP_PER_GCL_CODIGO_GRUPO   	 VARCHAR2(20 CHAR)       NOT NULL,
    TMP_PER_GCL_COD_CLI		 	 VARCHAR2(20 CHAR)       NOT NULL,
	TMP_PER_GCL_TIPO_GRUPO	 	 VARCHAR2(20 CHAR)		NOT NULL,
	TMP_PER_GCL_COMP_VIN		 VARCHAR2(1 CHAR),	
	TMP_PER_GCL_FECHA_EXTRACCION DATE			    NOT NULL,
 	TMP_PER_GCL_FICHERO_CARGA    VARCHAR2(40 CHAR)		NOT NULL,
    VERSION                      INTEGER            DEFAULT 0 NOT NULL,
    USUARIOCREAR             	 VARCHAR2(10 CHAR)       NOT NULL,
    FECHACREAR               	 TIMESTAMP          NOT NULL,
    USUARIOMODIFICAR         	 VARCHAR2(10 CHAR),
    FECHAMODIFICAR           	 TIMESTAMP,
    USUARIOBORRAR            	 VARCHAR2(10 CHAR),
    FECHABORRAR              	 TIMESTAMP,
    BORRADO                  	 NUMBER(1,0)        DEFAULT 0 NOT NULL,
	CONSTRAINT PK_TMP_PER_GCL PRIMARY KEY (TMP_PER_GCL_ID)
);


ALTER TABLE GCL_GRUPOS_CLIENTES
	ADD CONSTRAINT FK_GCL_TGL_ID FOREIGN KEY (DD_TGL_ID)
      REFERENCES pfsmaster.DD_TGL_TIPO_GRUPO_CLIENTE (DD_TGL_ID);

ALTER TABLE PER_GCL
	ADD CONSTRAINT FK_PER_GCL_GCL FOREIGN KEY (GCL_ID)
      REFERENCES GCL_GRUPOS_CLIENTES (GCL_ID);

ALTER TABLE PER_GCL
	ADD CONSTRAINT FK_PER_GCL_PER FOREIGN KEY (PER_ID)
      REFERENCES PER_PERSONAS (PER_ID);

ALTER TABLE PPA_PUNTUACION_PARCIAL
   ADD CONSTRAINT FK_PPA_FK_PTO FOREIGN KEY (PTO_ID)
      REFERENCES PTO_PUNTUACION_TOTAL (PTO_ID);

ALTER TABLE PPA_PUNTUACION_PARCIAL
   ADD CONSTRAINT FK_PPA_TAL FOREIGN KEY (TAL_ID)
      REFERENCES TAL_TIPO_ALERTA(TAL_ID);


/* FKs Alertas y cia*/
ALTER TABLE TAL_TIPO_ALERTA
   ADD CONSTRAINT FK_TAL_FK_DD_GRC FOREIGN KEY (GRC_ID)
      REFERENCES GRC_GRUPO_CARGA (GRC_ID);

ALTER TABLE TAL_TIPO_ALERTA
   ADD CONSTRAINT FK_TAL_FK_GAL FOREIGN KEY (GAL_ID)
      REFERENCES GAL_GRUPO_ALERTA (GAL_ID);

ALTER TABLE ALE_ALERTAS
   ADD CONSTRAINT FK_ALE_PER FOREIGN KEY (PER_ID)
      REFERENCES PER_PERSONAS(PER_ID);

ALTER TABLE ALE_ALERTAS
   ADD CONSTRAINT FK_ALE_TAL FOREIGN KEY (TAL_ID)
      REFERENCES TAL_TIPO_ALERTA(TAL_ID);

ALTER TABLE ALE_ALERTAS
   ADD CONSTRAINT FK_ALE_NGR FOREIGN KEY (NGR_ID)
      REFERENCES NGR_NIVEL_GRAVEDAD(NGR_ID);


/* Fk de FRC_FICHEROS_CARGADOS*/
ALTER TABLE FRC_FICHEROS_CARGADOS
   ADD CONSTRAINT FK_FRC_TFI FOREIGN KEY (DD_TFI_ID)
      REFERENCES pfsmaster.DD_TFI_TIPO_FICHERO(DD_TFI_ID);


/* FKs CIRBE*/

ALTER TABLE CIR_CIRBE
   ADD CONSTRAINT FK_CIR_CRC FOREIGN KEY (DD_CRC_ID)
      REFERENCES pfsmaster.DD_CRC_CLASE_RIESGO_CIRBE(DD_CRC_ID);

ALTER TABLE CIR_CIRBE
   ADD CONSTRAINT FK_CIR_TMC FOREIGN KEY (DD_TMC_ID)
      REFERENCES pfsmaster.DD_TMC_TIPO_MONEDA_CIRBE(DD_TMC_ID);

ALTER TABLE CIR_CIRBE
   ADD CONSTRAINT FK_CIR_TSC FOREIGN KEY (DD_TSC_ID)
      REFERENCES pfsmaster.DD_TSC_TIPO_SITUAC_CIRBE(DD_TSC_ID);

ALTER TABLE CIR_CIRBE
   ADD CONSTRAINT FK_CIR_TVC FOREIGN KEY (DD_TVC_ID)
      REFERENCES pfsmaster.DD_TVC_TIPO_VENC_CIRBE(DD_TVC_ID);

ALTER TABLE CIR_CIRBE
   ADD CONSTRAINT FK_CIR_COC FOREIGN KEY (DD_COC_ID)
      REFERENCES pfsmaster.DD_COC_COD_OPERAC_CIRBE(DD_COC_ID);

ALTER TABLE CIR_CIRBE
   ADD CONSTRAINT FK_CIR_TGC FOREIGN KEY (DD_TGC_ID)
      REFERENCES pfsmaster.DD_TGC_TIPO_GARANTIA_CIRBE(DD_TGC_ID);

ALTER TABLE CIR_CIRBE
   ADD CONSTRAINT FK_CIR_CIR FOREIGN KEY (CIRBE_ANTERIOR)
      REFERENCES CIR_CIRBE(CIR_ID);

ALTER TABLE CIR_CIRBE
   ADD CONSTRAINT FK_CIR_PER FOREIGN KEY (PER_ID)
      REFERENCES PER_PERSONAS(PER_ID);

ALTER TABLE CIR_CIRBE
   ADD CONSTRAINT FK_CIR_CIC FOREIGN KEY (DD_CIC_ID)
      REFERENCES pfsmaster.DD_CIC_CODIGO_ISO_CIRBE(DD_CIC_ID);

/* ! FKs CIRBE*/      
      
ALTER TABLE NGR_NIVEL_GRAVEDAD ADD CONSTRAINT NGR_NIVEL_GRAVEDAD_UK_1 UNIQUE (NGR_ORDEN) ENABLE;
      
CREATE INDEX CIR_CIRBE_INDEX_1 ON CIR_CIRBE(CIR_FECHA_EXTRACCION) NOPARALLEL;
      
ALTER TABLE PTO_PUNTUACION_TOTAL
MODIFY(PTO_VRC NUMBER); 
 

ALTER TABLE PPA_PUNTUACION_PARCIAL ADD(ALE_ID					NUMBER(16)	       NOT NULL);

ALTER TABLE PPA_PUNTUACION_PARCIAL
   ADD CONSTRAINT FK_PPA_FK_ALERTA FOREIGN KEY (ALE_ID)
      REFERENCES ALE_ALERTAS (ALE_ID); 
 
	  
      
commit;      
      	  
	  
	  
	  
	  
	  
	        
      
      
      
      
 
-- ******************************** --
-- ** Para la versión 2.0.0.0.41 ** --
-- ******************************** --


INSERT INTO PLA_PLAZOS_DEFAULT(PLA_ID, DD_STA_ID, PLA_PLAZO, PLA_CODIGO, PLA_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (12, (select dd_sta_id from pfsmaster.DD_STA_SUBTIPO_TAREA_BASE where dd_sta_codigo = '41'), 365*24*60*60*1000, '13', 'Plazo prorroga en Externa', 'DD', SYSDATE);

INSERT INTO PLA_PLAZOS_DEFAULT(PLA_ID, DD_STA_ID, PLA_PLAZO, PLA_CODIGO, PLA_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (13, (select dd_sta_id from pfsmaster.DD_STA_SUBTIPO_TAREA_BASE where dd_sta_codigo = '55'), 365*24*60*60*1000, '14', 'Plazo prorroga default', 'DD', SYSDATE);



-- ******************************** --
-- ** Para la versión 2.0.0.0.29 ** --
-- ******************************** --

--Si no existe como es el caso de PFS01 (en producción)
ALTER TABLE PRC_PER
 ADD (VERSION  INTEGER);
 
update prc_per set version = 0;

ALTER TABLE PRC_PER
MODIFY(VERSION NOT NULL); 
------------------------------------

INSERT INTO PLA_PLAZOS_DEFAULT(PLA_ID, DD_STA_ID, PLA_PLAZO, PLA_CODIGO, PLA_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (11, (select dd_sta_id from pfsmaster.DD_STA_SUBTIPO_TAREA_BASE where dd_sta_codigo = '53'), 1*24*60*60*1000, '11', 'Plazo comprobación umbral', 'DD', SYSDATE);


INSERT INTO PLA_PLAZOS_DEFAULT(PLA_ID, DD_STA_ID, PLA_PLAZO, PLA_CODIGO, PLA_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (12, (select dd_sta_id from pfsmaster.DD_STA_SUBTIPO_TAREA_BASE where dd_sta_codigo = '55'), 365*24*60*60*1000, '12', 'Plazo prorroga en DC', 'DD', SYSDATE);



CREATE SEQUENCE S_ADP_ADJUNTOS_PERSONAS START WITH 1 NOCYCLE CACHE 100;

CREATE SEQUENCE S_ADC_ADJUNTOS_CONTRATOS START WITH 1 NOCYCLE CACHE 100;

CREATE SEQUENCE S_HTC_HIST_TRASP_COMITE START WITH 1 NOCYCLE CACHE 100;


ALTER TABLE OBA_OBSERVACION_ACEPTACION
MODIFY(OBA_DETALLE NULL);


ALTER TABLE AAA_ACTITUD_APTITUD_ACTUACION
 ADD (AAA_REVISION  VARCHAR2(1024 CHAR));


ALTER TABLE CLI_CLIENTES
 ADD (CLI_FECHA_GV	DATE);


CREATE TABLE ADP_ADJUNTOS_PERSONAS (
   ADP_ID               NUMBER(16)                    NOT NULL,
   PER_ID               NUMBER(16)                    NOT NULL,
   ADP_NOMBRE           VARCHAR2(255 CHAR)                 NOT NULL,
   ADP_CONTENT_TYPE     VARCHAR2(50 CHAR)                  NOT NULL,
   ADP_LENGTH           NUMBER(16)                    NOT NULL,
   ADP_DESCRIPCION      VARCHAR2(1024 CHAR),
   ADJ_ID               NUMBER(16)                    NOT NULL,
   VERSION              INTEGER                       DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                  NOT NULL,
   FECHACREAR           TIMESTAMP                     NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                   DEFAULT 0 NOT NULL,
   CONSTRAINT PK_ADP_ADJUNTOS_PERSONAS PRIMARY KEY (ADP_ID)
);

ALTER TABLE ADP_ADJUNTOS_PERSONAS
   ADD CONSTRAINT FK_FK_PER_ADJ FOREIGN KEY (PER_ID)
      REFERENCES PER_PERSONAS (PER_ID);

ALTER TABLE ADP_ADJUNTOS_PERSONAS
   ADD CONSTRAINT FK_FK_ADP_ADJ FOREIGN KEY (ADJ_ID)
      REFERENCES ADJ_ADJUNTOS (ADJ_ID);


CREATE TABLE ADC_ADJUNTOS_CONTRATOS (
   ADC_ID               NUMBER(16)                    NOT NULL,
   CNT_ID               NUMBER(16)                    NOT NULL,
   ADC_NOMBRE           VARCHAR2(255 CHAR)                 NOT NULL,
   ADC_CONTENT_TYPE     VARCHAR2(50 CHAR)                  NOT NULL,
   ADC_LENGTH           NUMBER(16)                    NOT NULL,
   ADC_DESCRIPCION      VARCHAR2(1024 CHAR),
   ADJ_ID               NUMBER(16)                    NOT NULL,
   VERSION              INTEGER                       DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10 CHAR)                  NOT NULL,
   FECHACREAR           TIMESTAMP                     NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10 CHAR),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10 CHAR),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                   DEFAULT 0 NOT NULL,
   CONSTRAINT PK_ADC_ADJUNTOS_CONTRATOS PRIMARY KEY (ADC_ID)
);


ALTER TABLE ADC_ADJUNTOS_CONTRATOS
   ADD CONSTRAINT FK_FK_CNT_ADJ FOREIGN KEY (CNT_ID)
      REFERENCES CNT_CONTRATOS (CNT_ID);

ALTER TABLE ADC_ADJUNTOS_CONTRATOS
   ADD CONSTRAINT FK_FK_ADC_ADJ FOREIGN KEY (ADJ_ID)
      REFERENCES ADJ_ADJUNTOS (ADJ_ID);


CREATE TABLE HTC_HIST_TRASP_COMITE(
	HTC_ID				 NUMBER(16)		NOT NULL,
	EXP_ID				 NUMBER(16)		NOT NULL,
	COM_ID_ORIGEN		 NUMBER(16)		NOT NULL,
	COM_ID_DESTINO	     NUMBER(16)		NOT NULL,
	HTC_FECHA			 TIMESTAMP		NOT NULL,
	VERSION              INTEGER        DEFAULT 0 NOT NULL,
  	USUARIOCREAR         VARCHAR2(10 CHAR)   NOT NULL,
  	FECHACREAR           TIMESTAMP      NOT NULL,
  	USUARIOMODIFICAR     VARCHAR2(10 CHAR),
  	FECHAMODIFICAR       TIMESTAMP,
  	USUARIOBORRAR        VARCHAR2(10 CHAR),
  	FECHABORRAR          TIMESTAMP,
  	BORRADO              NUMBER(1,0)    DEFAULT 0 NOT NULL,
  	CONSTRAINT PK_HTC_ID PRIMARY KEY (HTC_ID)
);

ALTER TABLE HTC_HIST_TRASP_COMITE
   ADD CONSTRAINT FK_HTC_EXP FOREIGN KEY (EXP_ID)
      REFERENCES EXP_EXPEDIENTES (EXP_ID);

ALTER TABLE HTC_HIST_TRASP_COMITE
   ADD CONSTRAINT FK_HTC_COM_OR FOREIGN KEY (COM_ID_ORIGEN)
      REFERENCES COM_COMITES (COM_ID);

ALTER TABLE HTC_HIST_TRASP_COMITE
   ADD CONSTRAINT FK_HTC_COM_DEST FOREIGN KEY (COM_ID_DESTINO)
      REFERENCES COM_COMITES (COM_ID);

ALTER TABLE PEF_PERFILES
ADD PEF_CODIGO VARCHAR2(100 CHAR);

UPDATE PEF_PERFILES
SET PEF_CODIGO = PEF_ID;

ALTER TABLE PEF_PERFILES
MODIFY(PEF_CODIGO NOT NULL); 

ALTER TABLE TAR_TAREAS_NOTIFICACIONES
ADD OBJ_ID NUMBER(16);

ALTER TABLE TAR_TAREAS_NOTIFICACIONES
   ADD CONSTRAINT FK_TAR_TARE_FK_TAR_OBJETIVO FOREIGN KEY (OBJ_ID)
      REFERENCES OBJ_OBJETIVO (OBJ_ID);

/*==============================================================*/
/* Table: COM_ITI                                  				*/
/*==============================================================*/
CREATE TABLE COM_ITI (
	COM_ID						NUMBER(16)         	NOT NULL,
	ITI_ID	  		 	 	NUMBER(16)         	NOT NULL,
	CONSTRAINT PK_COM_ITI PRIMARY KEY (COM_ID, ITI_ID)
);

ALTER TABLE COM_ITI
   ADD CONSTRAINT FK_COM_ITI_COM FOREIGN KEY (COM_ID)
      REFERENCES COM_COMITES (COM_ID);

ALTER TABLE COM_ITI
   ADD CONSTRAINT FK_COM_ITI_ITI FOREIGN KEY (ITI_ID)
      REFERENCES ITI_ITINERARIOS (ITI_ID);

--Comité mixto
INSERT INTO COM_ITI (COM_ID, ITI_ID) VALUES ((SELECT COM_ID FROM COM_COMITES WHERE COM_NOMBRE = 'Comite Ficticio'),
                                     (SELECT ITI_ID FROM ITI_ITINERARIOS WHERE ITI_NOMBRE = 'Seguimiento'));
INSERT INTO COM_ITI (COM_ID, ITI_ID) VALUES ((SELECT COM_ID FROM COM_COMITES WHERE COM_NOMBRE = 'Comite Ficticio'),
                                     (SELECT ITI_ID FROM ITI_ITINERARIOS WHERE ITI_NOMBRE = 'Muy Urgente - 36d'));
INSERT INTO COM_ITI (COM_ID, ITI_ID) VALUES ((SELECT COM_ID FROM COM_COMITES WHERE COM_NOMBRE = 'Comite Ficticio'),
                                     (SELECT ITI_ID FROM ITI_ITINERARIOS WHERE ITI_NOMBRE = 'Directo a DC'));
--Comité solo de seguimiento
INSERT INTO COM_ITI (COM_ID, ITI_ID) VALUES ((SELECT COM_ID FROM COM_COMITES WHERE COM_NOMBRE = 'Comite Resp. Analistas'),
                                     (SELECT ITI_ID FROM ITI_ITINERARIOS WHERE ITI_NOMBRE = 'Seguimiento'));


/*==============================================================*/
/* Table: CDO_CAMPO_DESTINO_OBJETIVO                            */
/*==============================================================*/
CREATE TABLE CDO_CAMPO_DESTINO_OBJETIVO  (
   CDO_ID			 	 	NUMBER(16)         	NOT NULL,
   CDO_CODIGO                VARCHAR2(20 CHAR)   NOT NULL,
   CDO_DESCRIPCION           VARCHAR2(50 CHAR),
   CDO_DESCRIPCION_LARGA     VARCHAR2(250 CHAR),
   VERSION                  INTEGER             DEFAULT 0 NOT NULL,
   USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
   FECHACREAR               TIMESTAMP           NOT NULL,
   USUARIOMODIFICAR         VARCHAR2(10 CHAR),
   FECHAMODIFICAR           TIMESTAMP,
   USUARIOBORRAR            VARCHAR2(10 CHAR),
   FECHABORRAR              TIMESTAMP,
   BORRADO                  NUMBER(1,0)         DEFAULT 0 NOT NULL,
   CONSTRAINT PK_CDO_CAMPO_DEST_OBJ PRIMARY KEY (CDO_ID),
   CONSTRAINT DD_CDO_CODIGO_UK UNIQUE (CDO_CODIGO)
);

CREATE TABLE CTO_TOB_CAMPOS_TIPOS_OBJ(
	CDO_ID		NUMBER(16)         	NOT NULL,
	TOB_ID		NUMBER(16)         	NOT NULL,
	CONSTRAINT PK_CTO_TOB_CPOS_TIPOS_OBJ PRIMARY KEY (CDO_ID, TOB_ID)
);


ALTER TABLE CTO_TOB_CAMPOS_TIPOS_OBJ
   ADD CONSTRAINT FK_CTO_TOB FOREIGN KEY (TOB_ID)
      REFERENCES TOB_TIPO_OBJETIVO (TOB_ID); 

ALTER TABLE CTO_TOB_CAMPOS_TIPOS_OBJ
   ADD CONSTRAINT FK_CTO_CDO FOREIGN KEY (CDO_ID)
      REFERENCES CDO_CAMPO_DESTINO_OBJETIVO (CDO_ID);

INSERT INTO CDO_CAMPO_DESTINO_OBJETIVO (CDO_ID, CDO_CODIGO, CDO_DESCRIPCION, CDO_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 VALUES (1, 'RD', 'Riesgo Directo', 'Riesgo Directo', 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0);
INSERT INTO CDO_CAMPO_DESTINO_OBJETIVO(CDO_ID, CDO_CODIGO, CDO_DESCRIPCION, CDO_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 VALUES (2, 'RIP', 'Riesgo Indirecto Persona', 'Riesgo Indirecto Persona', 0,'DD', SYSDATE, NULL, NULL, NULL, NULL, 0);
INSERT INTO CDO_CAMPO_DESTINO_OBJETIVO (CDO_ID, CDO_CODIGO, CDO_DESCRIPCION, CDO_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 VALUES (3, 'RIrrP', 'Riesgo Irregular Persona', 'Riesgo Irregular Persona', 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0);
INSERT INTO CDO_CAMPO_DESTINO_OBJETIVO (CDO_ID, CDO_CODIGO, CDO_DESCRIPCION, CDO_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 VALUES (4, 'RGP', 'Riesgo Garantizado Persona', 'Riesgo Garantizado Persona', 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0);
INSERT INTO CDO_CAMPO_DESTINO_OBJETIVO (CDO_ID, CDO_CODIGO, CDO_DESCRIPCION, CDO_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 VALUES (5, 'RNGP', 'Riesgo No Garantizado Persona', 'Riesgo No Garantizado Persona', 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0);
INSERT INTO CDO_CAMPO_DESTINO_OBJETIVO (CDO_ID, CDO_CODIGO, CDO_DESCRIPCION, CDO_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 VALUES (6, 'RNG/RD', 'Porcentaje RNG/RD', 'Porcentaje RNG/RD', 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0);
INSERT INTO CDO_CAMPO_DESTINO_OBJETIVO (CDO_ID, CDO_CODIGO, CDO_DESCRIPCION, CDO_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 VALUES (7, 'RIrr/RD', 'Procentaje RIrr/RD', 'Porcentaje RIrr/RD', 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0);
INSERT INTO CDO_CAMPO_DESTINO_OBJETIVO (CDO_ID, CDO_CODIGO, CDO_DESCRIPCION, CDO_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 VALUES (8, 'RC', 'Riesgo Contrato', 'Riesgo Contrato', 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0);
INSERT INTO CDO_CAMPO_DESTINO_OBJETIVO (CDO_ID, CDO_CODIGO, CDO_DESCRIPCION, CDO_DESCRIPCION_LARGA, VERSION, 
	USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 VALUES (9, 'RIrrC', 'Riesgo Irregular Contrato', 'Riesgo Irregular Contrato', 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0);
INSERT INTO CDO_CAMPO_DESTINO_OBJETIVO (CDO_ID, CDO_CODIGO, CDO_DESCRIPCION, CDO_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 VALUES (10, 'RGC', 'Riesgo Garantizado Contrato', 'Riesgo Garantizado Contrato', 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0);
INSERT INTO CDO_CAMPO_DESTINO_OBJETIVO (CDO_ID, CDO_CODIGO, CDO_DESCRIPCION, CDO_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 VALUES (11, 'RNGC', 'Riesgo No Garantizado Contrato', 'Riesgo No Garantizado Contrato', 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0);
INSERT INTO CDO_CAMPO_DESTINO_OBJETIVO (CDO_ID, CDO_CODIGO, CDO_DESCRIPCION, CDO_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 VALUES (12, 'LAC', 'Límite Actual Contrato', 'Límite Actual Contrato', 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0);
INSERT INTO CDO_CAMPO_DESTINO_OBJETIVO (CDO_ID, CDO_CODIGO, CDO_DESCRIPCION, CDO_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
 VALUES (13, 'DC', 'Dispuesto Contrato', 'Dispuesto Contrato', 0, 'DD', SYSDATE, NULL, NULL, NULL, NULL, 0);

