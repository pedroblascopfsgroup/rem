CREATE SEQUENCE S_DIJ_DIRECCION_JUZGADO
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20;


CREATE TABLE DIJ_DIRECCION_JUZGADO
(
  DIJ_ID                NUMBER(16)              NOT NULL,
  DD_LOC_ID             NUMBER(16),
  DD_PRV_ID             NUMBER(16),
  DD_TVI_ID             NUMBER(16),
  DIJ_COD_DIRECCION     NUMBER(16)              NOT NULL,
  DIJ_FECHA_EXTRACCION  DATE                    NOT NULL,
  DIJ_DOMICILIO         VARCHAR2(100 CHAR)      NOT NULL,
  DIJ_DOM_N             VARCHAR2(10 CHAR),
  DIJ_DOM_PORTAL        VARCHAR2(10 CHAR),
  DIJ_DOM_PISO          VARCHAR2(10 CHAR),
  DIJ_DOM_ESC           VARCHAR2(10 CHAR),
  DIJ_DOM_PUERTA        VARCHAR2(10 CHAR),
  DIJ_CODIGO_POSTAL     INTEGER,
  DIJ_PROVINCIA         VARCHAR2(100 CHAR),
  DIJ_POBLACION         VARCHAR2(100 CHAR),
  DIJ_MUNICIPIO         VARCHAR2(100 CHAR),
  DIJ_INE_PROV          NUMBER(10),
  DIJ_INE_POB           NUMBER(10),
  DIJ_INE_MUN           NUMBER(10),
  DIJ_INE_VIA           NUMBER(10),
  DIJ_NORMALIZADA       NUMBER(1)               DEFAULT 0,
  VERSION               INTEGER                 DEFAULT 0                     NOT NULL,
  USUARIOCREAR          VARCHAR2(10 CHAR)       NOT NULL,
  FECHACREAR            TIMESTAMP(6)            NOT NULL,
  USUARIOMODIFICAR      VARCHAR2(10 CHAR),
  FECHAMODIFICAR        TIMESTAMP(6),
  USUARIOBORRAR         VARCHAR2(10 CHAR),
  FECHABORRAR           TIMESTAMP(6),
  BORRADO               NUMBER(1)               DEFAULT 0                     NOT NULL,
  DIJ_COD_POST_INTL     VARCHAR2(20 BYTE),
  DTYPE                 VARCHAR2(50 BYTE)       DEFAULT 'DireccionJuzgado', 
  CONSTRAINT PK_DIJ_DIRECCION_JUZGADO PRIMARY KEY (DIJ_ID), 
  CONSTRAINT UK_DIJ_DIRECCION_JUZGADO_COD UNIQUE (DIJ_COD_DIRECCION),
  CONSTRAINT FK_DIR_DIRJUZ_FK_PER_DD_DD_LOC FOREIGN KEY (DD_LOC_ID) REFERENCES LINMASTER.DD_LOC_LOCALIDAD (DD_LOC_ID),
  CONSTRAINT FK_DIR_DIRJUZ_FK_PER_DD_DD_PRV FOREIGN KEY (DD_PRV_ID) REFERENCES LINMASTER.DD_PRV_PROVINCIA (DD_PRV_ID),
  CONSTRAINT FK_DIR_DIRJUZ_FK_TIPO_VIA_V FOREIGN KEY (DD_TVI_ID) REFERENCES LINMASTER.DD_TVI_TIPO_VIA (DD_TVI_ID)
);

ALTER TABLE DD_JUZ_JUZGADOS_PLAZA ADD (DIJ_ID  NUMBER(16) );

ALTER TABLE DD_JUZ_JUZGADOS_PLAZA ADD (DTYPE  VARCHAR2(50 BYTE)  DEFAULT('EXTTipoJuzgado') );
