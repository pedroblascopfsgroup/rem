CREATE SEQUENCE S_DD_TGE_TIPO_GESTOR
  START WITH 1
  MAXVALUE 999999999999999999999999999;

CREATE TABLE DD_TGE_TIPO_GESTOR
(
  DD_TGE_ID                 NUMBER(16),
  DD_TGE_CODIGO             VARCHAR2(20 CHAR)   NOT NULL,
  DD_TGE_DESCRIPCION        VARCHAR2(50 CHAR),
  DD_TGE_DESCRIPCION_LARGA  VARCHAR2(250 CHAR),
  VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
  USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
  FECHACREAR                TIMESTAMP(6)        NOT NULL,
  USUARIOMODIFICAR          VARCHAR2(10 CHAR),
  FECHAMODIFICAR            TIMESTAMP(6),
  USUARIOBORRAR             VARCHAR2(10 CHAR),
  FECHABORRAR               TIMESTAMP(6),
  BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL,
  CONSTRAINT PK_DD_TGE_TIPO_GESTOR PRIMARY KEY (DD_TGE_ID)
);

grant select, references on DD_TGE_TIPO_GESTOR to un001;

CREATE TABLE DD_TGE_TIPO_GESTOR_LG
(
  DD_TGE_ID                 NUMBER(16)          NOT NULL,
  DD_TGE_LANG               VARCHAR2(20 CHAR)   NOT NULL,
  DD_TGE_DESCRIPCION        VARCHAR2(50 CHAR),
  DD_TGE_DESCRIPCION_LARGA  VARCHAR2(250 CHAR),
  VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
  USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
  FECHACREAR                TIMESTAMP(6)        NOT NULL,
  USUARIOMODIFICAR          VARCHAR2(10 CHAR),
  FECHAMODIFICAR            TIMESTAMP(6),
  USUARIOBORRAR             VARCHAR2(10 CHAR),
  FECHABORRAR               TIMESTAMP(6),
  BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL,
  CONSTRAINT PK_DD_TGE_TIPO_GESTOR_LG PRIMARY KEY (DD_TGE_ID, DD_TGE_LANG),
  CONSTRAINT FK_DD_TGE_LG_FK_DD_TGE FOREIGN KEY (DD_TGE_ID) REFERENCES DD_TGE_TIPO_GESTOR (DD_TGE_ID)
);

grant select, references on DD_TGE_TIPO_GESTOR_LG to un001;

CREATE SEQUENCE S_DD_SUP_SUPERVISORES
  START WITH 1
  MAXVALUE 999999999999999999999999999;

CREATE TABLE DD_SUP_SUPERVISORES
(
  DD_SUP_ID                 NUMBER(16),
  DD_SUP_CODIGO             VARCHAR2(20 CHAR)   NOT NULL,
  DD_SUP_DESCRIPCION        VARCHAR2(50 CHAR),
  DD_SUP_DESCRIPCION_LARGA  VARCHAR2(250 CHAR),
  DD_TGE_SUP				NUMBER(16)			NOT NULL,
  DD_TGE_GES				NUMBER(16)			NOT NULL,
  VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
  USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
  FECHACREAR                TIMESTAMP(6)        NOT NULL,
  USUARIOMODIFICAR          VARCHAR2(10 CHAR),
  FECHAMODIFICAR            TIMESTAMP(6),
  USUARIOBORRAR             VARCHAR2(10 CHAR),
  FECHABORRAR               TIMESTAMP(6),
  BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL,
  CONSTRAINT PK_DD_SUP_SUPERVISORES PRIMARY KEY (DD_SUP_ID)
);

CREATE UNIQUE INDEX UK_DD_SUP_SUPERVISORES_COD ON DD_SUP_SUPERVISORES (DD_SUP_CODIGO);
CREATE UNIQUE INDEX UK_DD_SUP_SUPERVISORES_SUP ON DD_SUP_SUPERVISORES (DD_TGE_SUP, DD_TGE_GES);

grant select, references on DD_SUP_SUPERVISORES to un001;

insert into DD_TGE_TIPO_GESTOR(DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,VERSION,
USUARIOCREAR,FECHACREAR,BORRADO)
values(S_DD_TGE_TIPO_GESTOR.nextval, 'GDOC', 'Gestor Documental', 'Gestor Documental del Asunto', 0, 
'DIA',SYSDATE, 0);

insert into DD_TGE_TIPO_GESTOR(DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,VERSION,
USUARIOCREAR,FECHACREAR,BORRADO)
values(S_DD_TGE_TIPO_GESTOR.nextval, 'GEXT', 'Gestor Externo', 'Gestor Externo del Asunto', 0, 
'DIA',SYSDATE, 0);

insert into DD_TGE_TIPO_GESTOR(DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,VERSION,
USUARIOCREAR,FECHACREAR,BORRADO)
values(S_DD_TGE_TIPO_GESTOR.nextval, 'SUP', 'Supervisor', 'Supervisor del Asunto', 0, 
'DIA',SYSDATE, 0);

insert into DD_TGE_TIPO_GESTOR(DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,VERSION,
USUARIOCREAR,FECHACREAR,BORRADO)
values(S_DD_TGE_TIPO_GESTOR.nextval, 'PROC', 'Procurador', 'Procurador del Asunto', 0, 
'DIA',SYSDATE, 0);

ALTER TABLE dd_sta_subtipo_tarea_base ADD(DD_TGE_ID NUMBER(16));

ALTER TABLE dd_sta_subtipo_tarea_base ADD(DTYPE VARCHAR2(50 CHAR) DEFAULT 'EXTSubtipoTarea');

ALTER TABLE dd_sta_subtipo_tarea_base ADD (
  CONSTRAINT FK_STA_DD_TGE 
 FOREIGN KEY (DD_TGE_ID) 
 REFERENCES DD_TGE_TIPO_GESTOR (DD_TGE_ID));
 
Insert into DD_STA_SUBTIPO_TAREA_BASE
   (DD_STA_ID, DD_TAR_ID, DD_STA_CODIGO, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TGE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 select s_dd_sta_subtipo_tarea_base.nextval, 1, '542' , 'Tarea de Gestor Documental', 'Tarea de Gestor Documental',dd_tge_id, 0, 'DIA', sysdate, 0
 from DD_TGE_TIPO_GESTOR where dd_tge_codigo='GDOC';
 
Insert into DD_STA_SUBTIPO_TAREA_BASE
   (DD_STA_ID, DD_TAR_ID, DD_STA_CODIGO, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TGE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 select s_dd_sta_subtipo_tarea_base.nextval, 1, '543' , 'Tarea de Procurador', 'Tarea de Gestor Documental',dd_tge_id, 0, 'DIA', sysdate, 0
 from DD_TGE_TIPO_GESTOR where dd_tge_codigo='PROC'; 
 
 
update dd_sta_subtipo_tarea_base set dd_tge_id = (select dd_tge_id from DD_TGE_TIPO_GESTOR where dd_tge_codigo='GEXT')
where dd_sta_codigo='39';

update dd_sta_subtipo_tarea_base set dd_sta_gestor = null
where dd_sta_codigo='39';

update dd_sta_subtipo_tarea_base set dd_tge_id = (select dd_tge_id from DD_TGE_TIPO_GESTOR where dd_tge_codigo='SUP')
where dd_sta_codigo='40';

update dd_sta_subtipo_tarea_base set dd_sta_gestor = null
where dd_sta_codigo='40';

