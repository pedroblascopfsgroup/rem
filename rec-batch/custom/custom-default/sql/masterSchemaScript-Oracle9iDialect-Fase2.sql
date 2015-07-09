/*==============================================================*/
/* DBMS name:      ORACLE Version 10g                           */
/* Created on:     08/09/2008 12:30:19                          */
/*==============================================================*/


CREATE SEQUENCE S_DD_CIM_CAUSAS_IMPAGO;

CREATE SEQUENCE S_DD_CIM_CAUSAS_IMPAGO_LG;

CREATE SEQUENCE S_DD_CPR_CAUSA_PRORROGA;

CREATE SEQUENCE S_DD_CPR_CAUSA_PRORROGA_LG;

CREATE SEQUENCE S_DD_CTL_CAUSA_EXCLUSION;

CREATE SEQUENCE S_DD_CTL_CAUSA_EXCLUSION_LG;

CREATE SEQUENCE S_DD_DTI_TIPO_INCIDENCIAS;

CREATE SEQUENCE S_DD_DTI_TIPO_INCIDENCIAS_LG;

CREATE SEQUENCE S_DD_EFC_ESTADO_FINAN_CNT;

CREATE SEQUENCE S_DD_EIN_ENT_INFO;

CREATE SEQUENCE S_DD_EIN_ENT_INFO_LG;

CREATE SEQUENCE S_DD_ESC_ESTADO_CNT;

CREATE SEQUENCE S_DD_EST_EST_ITI;

CREATE SEQUENCE S_DD_EST_EST_ITI_LG;

CREATE SEQUENCE S_DD_FMG_FASES_MG;

CREATE SEQUENCE S_DD_FMG_FASES_MG_LG;

CREATE SEQUENCE S_DD_LOC_LOCALIDAD;

CREATE SEQUENCE S_DD_LOC_LOCALIDAD_LG;

CREATE SEQUENCE S_DD_MON_MONEDAS;

CREATE SEQUENCE S_DD_MON_MONEDAS_LG;

CREATE SEQUENCE S_DD_PRV_PROVINCIA;

CREATE SEQUENCE S_DD_PRV_PROVINCIA_LG;

CREATE SEQUENCE S_DD_RPR_RAZON_PRORROGA;

CREATE SEQUENCE S_DD_RPR_RAZON_PRORROGA_LG;

CREATE SEQUENCE S_DD_SMG_SUBFASES_MG;

CREATE SEQUENCE S_DD_SMG_SUBFASES_MG_LG;

CREATE SEQUENCE S_DD_STA_SUBTIPO_TAREA_BASE;

CREATE SEQUENCE S_DD_STA_SUBTIPO_TAREA_BASE_LG;

CREATE SEQUENCE S_DD_STI_SITUACION;

CREATE SEQUENCE S_DD_STI_SITUACION_LG;

CREATE SEQUENCE S_DD_TAA_TIP_AYUDA_ACT;

CREATE SEQUENCE S_DD_TAA_TIP_AYUDA_ACT_LG;

CREATE SEQUENCE S_DD_TAC_TIPO_ACTUACION;

CREATE SEQUENCE S_DD_TAC_TIPO_ACTUACION_LG;

CREATE SEQUENCE S_DD_TAR_TIPO_TAREA_BASE;

CREATE SEQUENCE S_DD_TAR_TIPO_TAREA_BASE_LG;

CREATE SEQUENCE S_DD_TBI_TIPO_BIEN;

CREATE SEQUENCE S_DD_TBI_TIPO_BIEN_LG;

CREATE SEQUENCE S_DD_TDI_TIPO_DOCUMENTO_ID;

CREATE SEQUENCE S_DD_TDI_TIPO_DOCUMENTO_ID_LG;

CREATE SEQUENCE S_DD_TGA_TIPO_GARANTIA;

CREATE SEQUENCE S_DD_TGA_TIPO_GARANTIA_LG;

CREATE SEQUENCE S_DD_TIG_TIPO_INGRESO;

CREATE SEQUENCE S_DD_TIG_TIPO_INGRESO_LG;

CREATE SEQUENCE S_DD_TPE_TIPO_PERSONA;

CREATE SEQUENCE S_DD_TPE_TIPO_PERSONA_LG;

CREATE SEQUENCE S_DD_TPO_TIPO_PROCEDIMIENTO;

CREATE SEQUENCE S_DD_TPO_TIPO_PROCEDIMIENTO_LG;

CREATE SEQUENCE S_DD_TRE_TIPO_RECLAMACION;

CREATE SEQUENCE S_DD_TRE_TIPO_RECLAMACION_LG;

CREATE SEQUENCE S_DD_TTG_TIPO_TIT_GEN;

CREATE SEQUENCE S_DD_TTI_TIPO_TITULO;

CREATE SEQUENCE S_DD_TTI_TIPO_TITULO_LG;

CREATE SEQUENCE S_DD_TVI_TIPO_VIA;

CREATE SEQUENCE S_DD_TVI_TIPO_VIA_LG;

CREATE SEQUENCE S_DEFEREDEVENT;

CREATE SEQUENCE S_ENTIDAD;

CREATE SEQUENCE S_ENTIDADCONFIG;

CREATE SEQUENCE S_FUN_FUNCIONES;

CREATE SEQUENCE S_USU_USUARIOS;

/*==============================================================*/
/* Table: DD_CIM_CAUSAS_IMPAGO                                  */
/*==============================================================*/
CREATE TABLE DD_CIM_CAUSAS_IMPAGO  (
   DD_CIM_ID            NUMBER(20)                      NOT NULL,
   DD_CIM_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_CIM_DESCRIPCION   VARCHAR2(50),
   DD_CIM_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CIM_CAUSAS_IMPAGO PRIMARY KEY (DD_CIM_ID)
);

/*==============================================================*/
/* Table: DD_CIM_CAUSAS_IMPAGO_LG                               */
/*==============================================================*/
CREATE TABLE DD_CIM_CAUSAS_IMPAGO_LG  (
   DD_CIM_ID            NUMBER(20)                      NOT NULL,
   DD_CIM_LANG          VARCHAR2(8)                     NOT NULL,
   DD_CIM_DESCRIPCION   VARCHAR2(50),
   DD_CIM_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CIM_CAUSAS_IMPAGO_LG PRIMARY KEY (DD_CIM_LANG, DD_CIM_ID),
   CONSTRAINT AK_KDD_CIM_ID_DD_CIM_C UNIQUE (DD_CIM_ID)
);

/*==============================================================*/
/* Table: DD_CPR_CAUSA_PRORROGA                                 */
/*==============================================================*/
CREATE TABLE DD_CPR_CAUSA_PRORROGA  (
   DD_CPR_ID            NUMBER(20)                      NOT NULL,
   DD_CPR_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_CPR_DESCRIPCION   VARCHAR2(50),
   DD_CPR_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CPR_CAUSA_PRORROGA PRIMARY KEY (DD_CPR_ID)
);

/*==============================================================*/
/* Table: DD_CPR_CAUSA_PRORROGA_LG                              */
/*==============================================================*/
CREATE TABLE DD_CPR_CAUSA_PRORROGA_LG  (
   DD_CPR_ID            NUMBER(20)                      NOT NULL,
   DD_CPR_LANG          VARCHAR2(8)                     NOT NULL,
   DD_CPR_DESCRIPCION   VARCHAR2(50),
   DD_CPR_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CPR_CAUSA_PRORROGA_LG PRIMARY KEY (DD_CPR_ID, DD_CPR_LANG)
);

/*==============================================================*/
/* Table: DD_CTL_CAUSA_EXCLUSION                                */
/*==============================================================*/
CREATE TABLE DD_CTL_CAUSA_EXCLUSION  (
   DD_CTL_ID            NUMBER(20)                      NOT NULL,
   DD_CTL_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_CTL_DESCRIPCION   VARCHAR2(50),
   DD_CTL_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CTL_CAUSA_EXCLUSION PRIMARY KEY (DD_CTL_ID)
);

/*==============================================================*/
/* Table: DD_CTL_CAUSA_EXCLUSION_LG                             */
/*==============================================================*/
CREATE TABLE DD_CTL_CAUSA_EXCLUSION_LG  (
   DD_CTL_ID            NUMBER(20)                      NOT NULL,
   DD_CTL_LANG          VARCHAR2(8)                     NOT NULL,
   DD_CTL_DESCRIPCION   VARCHAR2(50),
   DD_CTL_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_CTL_CAUSA_EXCLUSION_LG PRIMARY KEY (DD_CTL_ID, DD_CTL_LANG)
);

/*==============================================================*/
/* Table: DD_DTI_TIPO_INCIDENCIAS                               */
/*==============================================================*/
CREATE TABLE DD_DTI_TIPO_INCIDENCIAS  (
   DTI_ID               NUMBER(20)                      NOT NULL,
   DTI_CODIGO           VARCHAR2(50)                    NOT NULL,
   DTI_DESCRIPCION      VARCHAR2(20),
   DTI_DESCRIPCION_LARGA VARCHAR2(250),
   DTI_PATRON           VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   USUARIOMODIF         VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_DTI_TIPO_INCIDENCIAS PRIMARY KEY (DTI_ID)
);

/*==============================================================*/
/* Table: DD_DTI_TIPO_INCIDENCIAS_LG                            */
/*==============================================================*/
CREATE TABLE DD_DTI_TIPO_INCIDENCIAS_LG  (
   DTI_ID               NUMBER(20)                      NOT NULL,
   DTI_LANG             VARCHAR2(8)                     NOT NULL,
   DTI_DESCRIPCION      VARCHAR2(20),
   DTI_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   USUARIOMODIF         VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_DTI_TIPO_INCIDENCIAS_LG PRIMARY KEY (DTI_ID, DTI_LANG)
);

/*==============================================================*/
/* Table: DD_EFC_ESTADO_FINAN_CNT                               */
/*==============================================================*/
CREATE TABLE DD_EFC_ESTADO_FINAN_CNT  (
   DD_EFC_ID            NUMBER(20)                      NOT NULL,
   DD_EFC_CODIGO        VARCHAR2(2)                     NOT NULL,
   DD_EFC_DESCRIPCION   VARCHAR2(50),
   DD_EFC_DESCRIPCION_LARGA VARCHAR2(250),
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_EFC_ESTADO_FINAN_CNT PRIMARY KEY (DD_EFC_ID)
);

/*==============================================================*/
/* Table: DD_EFC_ESTADO_FINAN_CNT_LNG                           */
/*==============================================================*/
CREATE TABLE DD_EFC_ESTADO_FINAN_CNT_LNG  (
   DD_EFC_ID            NUMBER(20,0)                    NOT NULL,
   DD_EFC_LANG          VARCHAR2(8)                     NOT NULL,
   DD_EFC_DESCRIPCION   VARCHAR2(50),
   DD_EFC_DESCRIPCION_LARGA VARCHAR2(250),
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_EFC_ESTADO_FINAN_CNT_LNG PRIMARY KEY (DD_EFC_ID, DD_EFC_LANG)
);

/*==============================================================*/
/* Table: DD_EIN_ENTIDAD_INFORMACION                            */
/*==============================================================*/
CREATE TABLE DD_EIN_ENTIDAD_INFORMACION  (
   DD_EIN_ID            NUMBER(20)                      NOT NULL,
   DD_EIN_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_EIN_DESCRIPCION   VARCHAR2(50),
   DD_EIN_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_EIN_ENTIDAD_INFORMACION PRIMARY KEY (DD_EIN_ID)
);

/*==============================================================*/
/* Table: DD_EIN_ENTIDAD_INFORMACION_LG                         */
/*==============================================================*/
CREATE TABLE DD_EIN_ENTIDAD_INFORMACION_LG  (
   DD_EIN_ID            NUMBER(20)                      NOT NULL,
   DD_EIN_LANG          VARCHAR2(8)                     NOT NULL,
   DD_EIN_DESCRIPCION   VARCHAR2(50),
   DD_EIN_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_EIN_ENTIDAD_INFORMACION_ PRIMARY KEY (DD_EIN_ID, DD_EIN_LANG)
);

/*==============================================================*/
/* Table: DD_ESC_ESTADO_CNT                                     */
/*==============================================================*/
CREATE TABLE DD_ESC_ESTADO_CNT  (
   DD_ESC_ID            NUMBER(20)                      NOT NULL,
   DD_ESC_CODIGO        VARCHAR2(8)                     NOT NULL,
   DD_ESC_DESCRIPCION   VARCHAR2(50),
   DD_ESC_DESCRIPCION_LARGA VARCHAR2(250),
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_ESC_ESTADO_CNT PRIMARY KEY (DD_ESC_ID)
);

/*==============================================================*/
/* Table: DD_ESC_ESTADO_CNT_LNG                                 */
/*==============================================================*/
CREATE TABLE DD_ESC_ESTADO_CNT_LNG  (
   DD_ESC_ID            NUMBER(20,0)                    NOT NULL,
   DD_ESC_LANG          VARCHAR2(8)                     NOT NULL,
   DD_ESC_DESCRIPCION   VARCHAR2(50),
   DD__ESC_DESCRIPCION_LARGA VARCHAR2(250),
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   COLUMN_12            CHAR(10),
   CONSTRAINT PK_DD_ESC_ESTADO_CNT_LNG PRIMARY KEY (DD_ESC_ID, DD_ESC_LANG)
);

/*==============================================================*/
/* Table: DD_EST_ESTADOS_ITINERARIOS                            */
/*==============================================================*/
CREATE TABLE DD_EST_ESTADOS_ITINERARIOS  (
   DD_EST_ID            NUMBER(20)                      NOT NULL,
   DD_EIN_ID            NUMBER(20,0)                    NOT NULL,
   DD_EST_ORDEN         INTEGER                         NOT NULL,
   DD_EST_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_EST_DESCRIPCION   VARCHAR2(50),
   DD_EST_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_EST_ESTADOS_ITINERARIOS PRIMARY KEY (DD_EST_ID)
);

/*==============================================================*/
/* Table: DD_EST_ESTADOS_ITINERARIOS_LG                         */
/*==============================================================*/
CREATE TABLE DD_EST_ESTADOS_ITINERARIOS_LG  (
   DD_EST_ID            NUMBER(20)                      NOT NULL,
   DD_EST_LANG          VARCHAR2(8)                     NOT NULL,
   DD_EST_DESCRIPCION   VARCHAR2(50),
   DD_EST_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_EST_ESTADOS_ITINERARIOS_ PRIMARY KEY (DD_EST_ID, DD_EST_LANG)
);

/*==============================================================*/
/* Table: DD_FMG_FASES_MAPA_GLOBAL                              */
/*==============================================================*/
CREATE TABLE DD_FMG_FASES_MAPA_GLOBAL  (
   DD_FMG_ID            NUMBER(20,0)                    NOT NULL,
   DD_FMG_CODIGO        VARCHAR2(8)                     NOT NULL,
   DD_FMG_DESCRIPCION   VARCHAR2(50),
   DD_FMG_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_FMG_FASES_MAPA_GLOBAL PRIMARY KEY (DD_FMG_ID)
);

/*==============================================================*/
/* Table: DD_FMG_FASES_MAPA_GLOBAL_LG                           */
/*==============================================================*/
CREATE TABLE DD_FMG_FASES_MAPA_GLOBAL_LG  (
   DD_FMG_ID            NUMBER(20)                      NOT NULL,
   DD_FMG_LANG          VARCHAR2(8)                     NOT NULL,
   DD_FMG_DESCRIPCION   VARCHAR2(50),
   DD_FMG_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_FMG_FASES_MAPA_GLOBAL_LG PRIMARY KEY (DD_FMG_ID, DD_FMG_LANG)
);

/*==============================================================*/
/* Table: DD_LOC_LOCALIDAD                                      */
/*==============================================================*/
CREATE TABLE DD_LOC_LOCALIDAD  (
   DD_LOC_ID            NUMBER(20)                      NOT NULL,
   DD_PRV_ID            NUMBER(20,0)                    NOT NULL,
   DD_LOC_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_LOC_DESCRIPCION   VARCHAR2(50),
   DD_LOC_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_LOC_LOCALIDAD PRIMARY KEY (DD_LOC_ID)
);

/*==============================================================*/
/* Table: DD_LOC_LOCALIDAD_LG                                   */
/*==============================================================*/
CREATE TABLE DD_LOC_LOCALIDAD_LG  (
   DD_LOC_ID            NUMBER(20)                      NOT NULL,
   DD_LOC_LANG          VARCHAR2(8)                     NOT NULL,
   DD_LOC_DESCRIPCION   VARCHAR2(50),
   DD_LOC_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_LOC_LOCALIDAD_LG PRIMARY KEY (DD_LOC_ID, DD_LOC_LANG)
);

/*==============================================================*/
/* Table: DD_MON_MONEDAS                                        */
/*==============================================================*/
CREATE TABLE DD_MON_MONEDAS  (
   DD_MON_ID            NUMBER(20)                      NOT NULL,
   DD_MON_CODIGO        VARCHAR2(8)                     NOT NULL,
   DD_MON_DESCRIPCION   VARCHAR2(50),
   DD_MON_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_MON_MONEDAS PRIMARY KEY (DD_MON_ID)
);

/*==============================================================*/
/* Table: DD_MON_MONEDAS_LG                                     */
/*==============================================================*/
CREATE TABLE DD_MON_MONEDAS_LG  (
   DD_MON_ID            NUMBER(20)                      NOT NULL,
   DD_MON_LANG          VARCHAR2(8)                     NOT NULL,
   DD_MON_DESCRIPCION   VARCHAR2(50),
   DD_MON_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_MON_MONEDAS_LG PRIMARY KEY (DD_MON_ID, DD_MON_LANG)
);

/*==============================================================*/
/* Table: DD_PRV_PROVINCIA                                      */
/*==============================================================*/
CREATE TABLE DD_PRV_PROVINCIA  (
   DD_PRV_ID            NUMBER(20)                      NOT NULL,
   DD_PRV_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_PRV_DESCRIPCION   VARCHAR2(50),
   DD_PRV_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_PRV_PROVINCIA PRIMARY KEY (DD_PRV_ID)
);

/*==============================================================*/
/* Table: DD_PRV_PROVINCIA_LG                                   */
/*==============================================================*/
CREATE TABLE DD_PRV_PROVINCIA_LG  (
   DD_PRV_ID            NUMBER(20)                      NOT NULL,
   DD_PRV_LANG          VARCHAR2(8)                     NOT NULL,
   DD_PRV_DESCRIPCION   VARCHAR2(50),
   DD_PRV_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_PRV_PROVINCIA_LG PRIMARY KEY (DD_PRV_ID, DD_PRV_LANG)
);

/*==============================================================*/
/* Table: DD_RPR_RAZON_PRORROGA                                 */
/*==============================================================*/
CREATE TABLE DD_RPR_RAZON_PRORROGA  (
   DD_RPR_ID            NUMBER(20)                      NOT NULL,
   DD_RPR_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_RPR_DESCRIPCION   VARCHAR2(50),
   DD_RPR_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_RPR_RAZON_PRORROGA PRIMARY KEY (DD_RPR_ID)
);

/*==============================================================*/
/* Table: DD_RPR_RAZON_PRORROGA_LG                              */
/*==============================================================*/
CREATE TABLE DD_RPR_RAZON_PRORROGA_LG  (
   DD_RPR_ID            NUMBER(20)                      NOT NULL,
   DD_RPR_LANG          VARCHAR2(8)                     NOT NULL,
   DD_RPR_DESCRIPCION   VARCHAR2(50),
   DD_RPR_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_RPR_RAZON_PRORROGA_LG PRIMARY KEY (DD_RPR_ID, DD_RPR_LANG)
);

/*==============================================================*/
/* Table: DD_SMG_SUBFASES_MAPA_GLOBAL                           */
/*==============================================================*/
CREATE TABLE DD_SMG_SUBFASES_MAPA_GLOBAL  (
   DD_SMG_ID            NUMBER(20,0)                    NOT NULL,
   DD_FMG_ID            NUMBER(20,0)                    NOT NULL,
   DD_SMG_CODIGO        VARCHAR2(8)                     NOT NULL,
   DD_SMG_DESCRIPCION   VARCHAR2(50),
   DD_SMG_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_SMG_SUBFASES_MAPA_GLOBAL PRIMARY KEY (DD_SMG_ID)
);

/*==============================================================*/
/* Table: DD_SMG_SUBFASES_MAPA_GLOBAL_LG                        */
/*==============================================================*/
CREATE TABLE DD_SMG_SUBFASES_MAPA_GLOBAL_LG  (
   DD_SMG_ID            NUMBER(20)                      NOT NULL,
   DD_SMG_LANG          VARCHAR2(8)                     NOT NULL,
   DD_SMG_DESCRIPCION   VARCHAR2(50),
   DD_SMG_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_SMG_LG PRIMARY KEY (DD_SMG_ID, DD_SMG_LANG)
);

/*==============================================================*/
/* Table: DD_STA_SUBTIPO_TAREA_BASE                             */
/*==============================================================*/
CREATE TABLE DD_STA_SUBTIPO_TAREA_BASE  (
   DD_STA_ID            NUMBER(20)                      NOT NULL,
   DD_TAR_ID            NUMBER(20,0),
   DD_STA_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_STA_DESCRIPCION   VARCHAR2(50),
   DD_STA_DESCRIPCION_LARGA VARCHAR2(250),
   DD_STA_GESTOR        NUMBER(1,0),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_STA_SUBTIPO_TAREA_BASE PRIMARY KEY (DD_STA_ID)
);

/*==============================================================*/
/* Table: DD_STA_SUBTIPO_TAREA_BASE_LG                          */
/*==============================================================*/
CREATE TABLE DD_STA_SUBTIPO_TAREA_BASE_LG  (
   DD_STA_ID            NUMBER(20)                      NOT NULL,
   DD_STA_LANG          VARCHAR2(8)                     NOT NULL,
   DD_STA_DESCRIPCION   VARCHAR2(50),
   DD_STA_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_STA_SUBTIPO_TAREA_BASE_L PRIMARY KEY (DD_STA_ID, DD_STA_LANG)
);

/*==============================================================*/
/* Table: DD_STI_SITUACION                                      */
/*==============================================================*/
CREATE TABLE DD_STI_SITUACION  (
   DD_STI_ID            NUMBER(20)                      NOT NULL,
   DD_STI_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_STI_DESCRIPCION   VARCHAR2(50),
   DD_STI_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_STI_SITUACION PRIMARY KEY (DD_STI_ID)
);

/*==============================================================*/
/* Table: DD_STI_SITUACION_LG                                   */
/*==============================================================*/
CREATE TABLE DD_STI_SITUACION_LG  (
   DD_STI_ID            NUMBER(20)                      NOT NULL,
   DD_STI_LANG          VARCHAR2(8)                     NOT NULL,
   DD__DD_STI_ID        NUMBER(20,0),
   DD_STI_DESCRIPCION   VARCHAR2(50),
   DD_STI_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_STI_SITUACION_LG PRIMARY KEY (DD_STI_ID, DD_STI_LANG)
);

/*==============================================================*/
/* Table: DD_TAA_TIPO_AYUDA_ACTUACION                           */
/*==============================================================*/
CREATE TABLE DD_TAA_TIPO_AYUDA_ACTUACION  (
   DD_TAA_ID            NUMBER(20)                      NOT NULL,
   DD_TAA_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_TAA_DESCRIPCION   VARCHAR2(50),
   DD_TAA_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TAA_TIPO_AYUDA_ACTUACIO2 PRIMARY KEY (DD_TAA_ID)
);

/*==============================================================*/
/* Table: DD_TAA_TIPO_AYUDA_ACTUACION_LG                        */
/*==============================================================*/
CREATE TABLE DD_TAA_TIPO_AYUDA_ACTUACION_LG  (
   DD_TAA_ID            NUMBER(20)                      NOT NULL,
   DD_TAA_LANG          VARCHAR2(8)                     NOT NULL,
   DD__DD_TAA_ID        NUMBER(20,0),
   DD_TAA_DESCRIPCION   VARCHAR2(50),
   DD_TAA_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TAA_TIPO_AYUDA_ACTUACION PRIMARY KEY (DD_TAA_ID, DD_TAA_LANG)
);

/*==============================================================*/
/* Table: DD_TAC_TIPO_ACTUACION                                 */
/*==============================================================*/
CREATE TABLE DD_TAC_TIPO_ACTUACION  (
   DD_TAC_ID            NUMBER(20)                      NOT NULL,
   DD_TAC_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_TAC_DESCRIPCION   VARCHAR2(50),
   DD_TAC_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TAC_TIPO_ACTUACION PRIMARY KEY (DD_TAC_ID)
);

/*==============================================================*/
/* Table: DD_TAC_TIPO_ACTUACION_LG                              */
/*==============================================================*/
CREATE TABLE DD_TAC_TIPO_ACTUACION_LG  (
   DD_TAC_ID            NUMBER(20)                      NOT NULL,
   DD_TAC_LANG          VARCHAR2(8)                     NOT NULL,
   DD_TAC_DESCRIPCION   VARCHAR2(50),
   DD_TAC_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TAC_TIPO_ACTUACION_LG PRIMARY KEY (DD_TAC_ID, DD_TAC_LANG)
);

/*==============================================================*/
/* Table: DD_TAR_TIPO_TAREA_BASE                                */
/*==============================================================*/
CREATE TABLE DD_TAR_TIPO_TAREA_BASE  (
   DD_TAR_ID            NUMBER(20)                      NOT NULL,
   DD_TAR_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_TAR_DESCRIPCION   VARCHAR2(50),
   DD_TAR_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TAR_TIPO_TAREA_BASE PRIMARY KEY (DD_TAR_ID)
);

/*==============================================================*/
/* Table: DD_TAR_TIPO_TAREA_BASE_LG                             */
/*==============================================================*/
CREATE TABLE DD_TAR_TIPO_TAREA_BASE_LG  (
   DD_TAR_ID            NUMBER(20)                      NOT NULL,
   DD_TAR_LANG          VARCHAR2(8)                     NOT NULL,
   DD_TAR_DESCRIPCION   VARCHAR2(50),
   DD_TAR_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TAR_TIPO_TAREA_BASE_LG PRIMARY KEY (DD_TAR_ID, DD_TAR_LANG)
);

/*==============================================================*/
/* Table: DD_TBI_TIPO_BIEN                                      */
/*==============================================================*/
CREATE TABLE DD_TBI_TIPO_BIEN  (
   DD_TBI_ID            NUMBER(20)                      NOT NULL,
   DD_TBI_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_TBI_DESCRIPCION   VARCHAR2(50),
   DD_TBI_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TBI_TIPO_BIEN PRIMARY KEY (DD_TBI_ID)
);

/*==============================================================*/
/* Table: DD_TBI_TIPO_BIEN_LG                                   */
/*==============================================================*/
CREATE TABLE DD_TBI_TIPO_BIEN_LG  (
   DD_TBI_ID            NUMBER(20)                      NOT NULL,
   DD_TBI_LANG          VARCHAR2(8)                     NOT NULL,
   DD_TBI_DESCRIPCION   VARCHAR2(50),
   DD_TBI_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TBI_TIPO_BIEN_LG PRIMARY KEY (DD_TBI_ID, DD_TBI_LANG)
);

/*==============================================================*/
/* Table: DD_TDI_TIPO_DOCUMENTO_ID                              */
/*==============================================================*/
CREATE TABLE DD_TDI_TIPO_DOCUMENTO_ID  (
   DD_TDI_ID            NUMBER(20)                      NOT NULL,
   DD_TDI_CODIGO        VARCHAR2(8)                     NOT NULL,
   DD_TDI_DESCRIPCION   VARCHAR2(50),
   DD_TDI_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TDI_TIPO_DOCUMENTO_ID PRIMARY KEY (DD_TDI_ID)
);

/*==============================================================*/
/* Table: DD_TDI_TIPO_DOCUMENTO_ID_LG                           */
/*==============================================================*/
CREATE TABLE DD_TDI_TIPO_DOCUMENTO_ID_LG  (
   DD_TDI_ID            NUMBER(20)                      NOT NULL,
   DD_TDI_LANG          VARCHAR2(8)                     NOT NULL,
   DD_TDI_DESCRIPCION   VARCHAR2(50),
   DD_TDI_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TDI_TIPO_DOCUMENTO_ID_LG PRIMARY KEY (DD_TDI_ID, DD_TDI_LANG)
);

/*==============================================================*/
/* Table: DD_TGA_TIPO_GARANTIA                                  */
/*==============================================================*/
CREATE TABLE DD_TGA_TIPO_GARANTIA  (
   DD_TGA_ID            NUMBER(20)                      NOT NULL,
   DD_TGA_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_TGA_DESCRIPCION   VARCHAR2(50),
   DD_TGA_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TGA_TIPO_GARANTIA PRIMARY KEY (DD_TGA_ID)
);

/*==============================================================*/
/* Table: DD_TGA_TIPO_GARANTIA_LG                               */
/*==============================================================*/
CREATE TABLE DD_TGA_TIPO_GARANTIA_LG  (
   DD_TGA_ID            NUMBER(20)                      NOT NULL,
   DD_TGA_LANG          VARCHAR2(8)                     NOT NULL,
   DD_TGA_DESCRIPCION   VARCHAR2(50),
   DD_TGA_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TGA_TIPO_GARANTIA_LG PRIMARY KEY (DD_TGA_ID, DD_TGA_LANG)
);

/*==============================================================*/
/* Table: DD_TIG_TIPO_INGRESO                                   */
/*==============================================================*/
CREATE TABLE DD_TIG_TIPO_INGRESO  (
   DD_TIG_ID            NUMBER(20)                      NOT NULL,
   DD_TIG_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_TIG_DESCRIPCION   VARCHAR2(50),
   DD_TIG_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TIG_TIPO_INGRESO PRIMARY KEY (DD_TIG_ID)
);

/*==============================================================*/
/* Table: DD_TIG_TIPO_INGRESO_LG                                */
/*==============================================================*/
CREATE TABLE DD_TIG_TIPO_INGRESO_LG  (
   DD_TIG_ID            NUMBER(20)                      NOT NULL,
   DD_TIG_LANG          VARCHAR2(8)                     NOT NULL,
   DD_TIG_DESCRIPCION   VARCHAR2(50),
   DD_TIG_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TIG_TIPO_INGRESO_LG PRIMARY KEY (DD_TIG_ID, DD_TIG_LANG)
);

/*==============================================================*/
/* Table: DD_TPE_TIPO_PERSONA                                   */
/*==============================================================*/
CREATE TABLE DD_TPE_TIPO_PERSONA  (
   DD_TPE_ID            NUMBER(20)                      NOT NULL,
   DD_TPE_CODIGO        VARCHAR2(8)                     NOT NULL,
   DD_TPE_DESCRIPCION   VARCHAR2(50),
   DD_TPE_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TPE_TIPO_PERSONA PRIMARY KEY (DD_TPE_ID)
);

/*==============================================================*/
/* Table: DD_TPE_TIPO_PERSONA_LG                                */
/*==============================================================*/
CREATE TABLE DD_TPE_TIPO_PERSONA_LG  (
   DD_TPE_ID            NUMBER(20)                      NOT NULL,
   DD_TPE_LANG          VARCHAR2(8)                     NOT NULL,
   DD_TPE_DESCRIPCION   VARCHAR2(50),
   DD_TPE_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TPE_TIPO_PERSONA_LG PRIMARY KEY (DD_TPE_ID, DD_TPE_LANG)
);

/*==============================================================*/
/* Table: DD_TPO_TIPO_PROCEDIMIENTO                             */
/*==============================================================*/
CREATE TABLE DD_TPO_TIPO_PROCEDIMIENTO  (
   DD_TPO_ID            NUMBER(20)                      NOT NULL,
   DD_TPO_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_TPO_DESCRIPCION   VARCHAR2(50),
   DD_TPO_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TPO_TIPO_PROCEDIMIENTO PRIMARY KEY (DD_TPO_ID)
);

/*==============================================================*/
/* Table: DD_TPO_TIPO_PROCEDIMIENTO_LG                          */
/*==============================================================*/
CREATE TABLE DD_TPO_TIPO_PROCEDIMIENTO_LG  (
   DD_TPO_ID            NUMBER(20)                      NOT NULL,
   DD_TPO_LANG          VARCHAR2(8)                     NOT NULL,
   DD_TPO_DESCRIPCION   VARCHAR2(50),
   DD_TPO_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TPO_TIPO_PROCEDIMIENTO_L PRIMARY KEY (DD_TPO_ID, DD_TPO_LANG)
);

/*==============================================================*/
/* Table: DD_TRE_TIPO_RECLAMACION                               */
/*==============================================================*/
CREATE TABLE DD_TRE_TIPO_RECLAMACION  (
   DD_TRE_ID            NUMBER(20)                      NOT NULL,
   DD_TRE_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_TRE_DESCRIPCION   VARCHAR2(50),
   DD_TRE_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TRE_TIPO_RECLAMACION PRIMARY KEY (DD_TRE_ID)
);

/*==============================================================*/
/* Table: DD_TRE_TIPO_RECLAMACION_LG                            */
/*==============================================================*/
CREATE TABLE DD_TRE_TIPO_RECLAMACION_LG  (
   DD_TRE_ID            NUMBER(20)                      NOT NULL,
   DD_TRE_LANG          VARCHAR2(8)                     NOT NULL,
   DD_TRE_DESCRIPCION   VARCHAR2(50),
   DD_TRE_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TRE_TIPO_RECLAMACION_LG PRIMARY KEY (DD_TRE_ID, DD_TRE_LANG)
);

/*==============================================================*/
/* Table: DD_TTI_TIPO_TITULO                                    */
/*==============================================================*/
CREATE TABLE DD_TTI_TIPO_TITULO  (
   DD_TTI_ID            NUMBER(20)                      NOT NULL,
   DD_TTI_CODIGO        VARCHAR2(20)                    NOT NULL,
   DD_TTI_DESCRIPCION   VARCHAR2(50),
   DD_TTI_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TTI_TIPO_TITULO PRIMARY KEY (DD_TTI_ID)
);

/*==============================================================*/
/* Table: DD_TTI_TIPO_TITULO_LG                                 */
/*==============================================================*/
CREATE TABLE DD_TTI_TIPO_TITULO_LG  (
   DD_TTI_ID            NUMBER(20)                      NOT NULL,
   DD_TTI_LANG          VARCHAR2(8)                     NOT NULL,
   DD__DD_TTI_ID        NUMBER(20,0),
   DD_TTI_DESCRIPCION   VARCHAR2(50),
   DD_TTI_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TTI_TIPO_TITULO_LG PRIMARY KEY (DD_TTI_ID, DD_TTI_LANG)
);

/*==============================================================*/
/* Table: DD_TVI_TIPO_VIA                                       */
/*==============================================================*/
CREATE TABLE DD_TVI_TIPO_VIA  (
   DD_TVI_ID            NUMBER(20)                      NOT NULL,
   DD_TVI_CODIGO        VARCHAR2(100)                   NOT NULL,
   DD_TVI_DESCRIPCION   VARCHAR2(50),
   DD_TVI_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TVI_TIPO_VIA PRIMARY KEY (DD_TVI_ID)
);

/*==============================================================*/
/* Table: DD_TVI_TIPO_VIA_LG                                    */
/*==============================================================*/
CREATE TABLE DD_TVI_TIPO_VIA_LG  (
   DD_TVI_ID            NUMBER(20)                      NOT NULL,
   DD_TVI_LANG          VARCHAR2(8)                     NOT NULL,
   DD_TVI_DESCRIPCION   VARCHAR2(50),
   DD_TVI_DESCRIPCION_LARGA VARCHAR2(250),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TVI_TIPO_VIA_LG PRIMARY KEY (DD_TVI_ID, DD_TVI_LANG)
);

/*==============================================================*/
/* Table: DEFEREDEVENT                                          */
/*==============================================================*/
CREATE TABLE DEFEREDEVENT  (
   ID                   NUMBER(20)                      NOT NULL,
   QUEUE                VARCHAR2(50)                    NOT NULL,
   STATE                VARCHAR2(3)                     NOT NULL,
   ARRIVED              NUMBER(20)                      NOT NULL,
   WILLPROCESS          TIMESTAMP                       DEFAULT ${sql.function.now} NOT NULL,
   PROCESSED            TIMESTAMP                       NOT NULL,
   DATA                 BLOB                            NOT NULL,
   CONSTRAINT PK_DEFEREDEVENT PRIMARY KEY (ID)
);

/*==============================================================*/
/* Table: ENTIDAD                                               */
/*==============================================================*/
CREATE TABLE ENTIDAD  (
   ID                   NUMBER(20)                      NOT NULL,
   DESCRIPCION          VARCHAR2(255),
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_ENTIDAD PRIMARY KEY (ID)
);

/*==============================================================*/
/* Table: ENTIDADCONFIG                                         */
/*==============================================================*/
CREATE TABLE ENTIDADCONFIG  (
   ID                   NUMBER(20)                      NOT NULL,
   ENTIDAD_ID           NUMBER(20,0),
   DATAKEY              VARCHAR2(32),
   DATAVALUE            VARCHAR2(255),
   CONSTRAINT PK_ENTIDADCONFIG PRIMARY KEY (ID),
   CONSTRAINT IX_ENTIDADCONFIG_KEY UNIQUE (ENTIDAD_ID, DATAKEY)
);

/*==============================================================*/
/* Table: FUN_FUNCIONES                                         */
/*==============================================================*/
CREATE TABLE FUN_FUNCIONES  (
   FUN_ID               NUMBER(20)                      NOT NULL,
   FUN_DESCRIPCION_LARGA VARCHAR2(250),
   FUN_DESCRIPCION      VARCHAR2(50),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_FUN_FUNCIONES PRIMARY KEY (FUN_ID)
);

/*==============================================================*/
/* Table: ROLE                                                  */
/*==============================================================*/
CREATE TABLE ROLE  (
   ROLE                 VARCHAR2(50)                    NOT NULL,
   CONSTRAINT PK_ROLE PRIMARY KEY (ROLE)
);

/*==============================================================*/
/* Table: USUARIO                                               */
/*==============================================================*/
CREATE TABLE USUARIO  (
   ENTIDAD_ID           INTEGER,
   USERNAME             VARCHAR2(50)                    NOT NULL,
   PASSWORD             VARCHAR2(50)                    NOT NULL,
   NOMBRE               VARCHAR2(50)                    NOT NULL,
   APELLIDO1            VARCHAR2(50)                    NOT NULL,
   APELLIDO2            VARCHAR2(50),
   EMAIL                VARCHAR2(50),
   ENABLED              CHAR(1)                         NOT NULL,
   ALTA                 DATE                            NOT NULL,
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   CONSTRAINT PK_USUARIO PRIMARY KEY (USERNAME)
);

/*==============================================================*/
/* Table: USUARIO_ROLE                                          */
/*==============================================================*/
CREATE TABLE USUARIO_ROLE  (
   USERNAME             VARCHAR2(50)                    NOT NULL,
   ROLE                 VARCHAR2(50)                    NOT NULL,
   CONSTRAINT IX_AUTHORITIES_USERNAME UNIQUE (USERNAME, ROLE)
);

/*==============================================================*/
/* Table: USU_USUARIOS                                          */
/*==============================================================*/
CREATE TABLE USU_USUARIOS  (
   USU_ID               NUMBER(20)                      NOT NULL,
   ENTIDAD_ID           NUMBER(20,0),
   USU_USERNAME         VARCHAR2(50)                    NOT NULL,
   USU_PASSWORD         VARCHAR2(50),
   USU_NOMBRE           VARCHAR2(50),
   USU_APELLIDO1        VARCHAR2(50),
   USU_APELLIDO2        VARCHAR2(50),
   USU_TELEFONO         VARCHAR2(10),
   USU_MAIL             VARCHAR2(50),
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR2(10)                    NOT NULL,
   FECHACREAR           TIMESTAMP                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR2(10),
   FECHAMODIFICAR       TIMESTAMP,
   USUARIOBORRAR        VARCHAR2(10),
   FECHABORRAR          TIMESTAMP,
   BORRADO              NUMBER(1,0)                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_USU_USUARIOS PRIMARY KEY (USU_ID),
   CONSTRAINT AK_UK_USU_USUARIOS_USU_USUA UNIQUE (USU_USERNAME)
);

ALTER TABLE DD_CIM_CAUSAS_IMPAGO_LG
   ADD CONSTRAINT FK_DD_CIM_C_FK_CIM_LG_DD_CIM_C FOREIGN KEY (DD_CIM_ID)
      REFERENCES DD_CIM_CAUSAS_IMPAGO (DD_CIM_ID);

ALTER TABLE DD_CPR_CAUSA_PRORROGA_LG
   ADD CONSTRAINT FK_DD_CPR_C_FK_CPR_LG_DD_CPR_C FOREIGN KEY (DD_CPR_ID)
      REFERENCES DD_CPR_CAUSA_PRORROGA (DD_CPR_ID);

ALTER TABLE DD_CTL_CAUSA_EXCLUSION_LG
   ADD CONSTRAINT FK_DD_CTL_C_FK_CTL_LG_DD_CTL_C FOREIGN KEY (DD_CTL_ID)
      REFERENCES DD_CTL_CAUSA_EXCLUSION (DD_CTL_ID);

ALTER TABLE DD_DTI_TIPO_INCIDENCIAS_LG
   ADD CONSTRAINT FK_DD_DTI_T_FK_DTI_LG_DD_DTI_T FOREIGN KEY (DTI_ID)
      REFERENCES DD_DTI_TIPO_INCIDENCIAS (DTI_ID);

ALTER TABLE DD_EFC_ESTADO_FINAN_CNT_LNG
   ADD CONSTRAINT FK_DD_EFC_E_FK_EFC_LA_DD_EFC_E FOREIGN KEY (DD_EFC_ID)
      REFERENCES DD_EFC_ESTADO_FINAN_CNT (DD_EFC_ID);

ALTER TABLE DD_EIN_ENTIDAD_INFORMACION_LG
   ADD CONSTRAINT FK_DD_EIN_E_FK_EIN_LG_DD_EIN_E FOREIGN KEY (DD_EIN_ID)
      REFERENCES DD_EIN_ENTIDAD_INFORMACION (DD_EIN_ID);

ALTER TABLE DD_ESC_ESTADO_CNT_LNG
   ADD CONSTRAINT FK_DD_ESC_E_FK_ESC_LA_DD_ESC_E FOREIGN KEY (DD_ESC_ID)
      REFERENCES DD_ESC_ESTADO_CNT (DD_ESC_ID);

ALTER TABLE DD_EST_ESTADOS_ITINERARIOS
   ADD CONSTRAINT FK_DD_EST_E_REFERENCE_DD_EIN_E FOREIGN KEY (DD_EIN_ID)
      REFERENCES DD_EIN_ENTIDAD_INFORMACION (DD_EIN_ID);

ALTER TABLE DD_EST_ESTADOS_ITINERARIOS_LG
   ADD CONSTRAINT FK_DD_EST_E_FK_EST_LG_DD_EST_E FOREIGN KEY (DD_EST_ID)
      REFERENCES DD_EST_ESTADOS_ITINERARIOS (DD_EST_ID);

ALTER TABLE DD_FMG_FASES_MAPA_GLOBAL_LG
   ADD CONSTRAINT FK_DD_FMG_F_REFERENCE_DD_FMG_F FOREIGN KEY (DD_FMG_ID)
      REFERENCES DD_FMG_FASES_MAPA_GLOBAL (DD_FMG_ID);

ALTER TABLE DD_LOC_LOCALIDAD
   ADD CONSTRAINT FK_DD_LOC_L_FK_PRV_LO_DD_PRV_P FOREIGN KEY (DD_PRV_ID)
      REFERENCES DD_PRV_PROVINCIA (DD_PRV_ID);

ALTER TABLE DD_LOC_LOCALIDAD_LG
   ADD CONSTRAINT FK_DD_LOC_L_FK_LOC_LG_DD_LOC_L FOREIGN KEY (DD_LOC_ID)
      REFERENCES DD_LOC_LOCALIDAD (DD_LOC_ID);

ALTER TABLE DD_MON_MONEDAS_LG
   ADD CONSTRAINT FK_DD_MON_M_FK_MON_LG_DD_MON_M FOREIGN KEY (DD_MON_ID)
      REFERENCES DD_MON_MONEDAS (DD_MON_ID);

ALTER TABLE DD_PRV_PROVINCIA_LG
   ADD CONSTRAINT FK_DD_PRV_P_FK_PRV_LG_DD_PRV_P FOREIGN KEY (DD_PRV_ID)
      REFERENCES DD_PRV_PROVINCIA (DD_PRV_ID);

ALTER TABLE DD_RPR_RAZON_PRORROGA_LG
   ADD CONSTRAINT FK_DD_RPR_R_FK_RPR_LG_DD_RPR_R FOREIGN KEY (DD_RPR_ID)
      REFERENCES DD_RPR_RAZON_PRORROGA (DD_RPR_ID);

ALTER TABLE DD_SMG_SUBFASES_MAPA_GLOBAL
   ADD CONSTRAINT FK_DD_SMG_S_FK_SMG_FM_DD_FMG_F FOREIGN KEY (DD_FMG_ID)
      REFERENCES DD_FMG_FASES_MAPA_GLOBAL (DD_FMG_ID);

ALTER TABLE DD_SMG_SUBFASES_MAPA_GLOBAL_LG
   ADD CONSTRAINT FK_DD_SMG_S_REFERENCE_DD_SMG_S FOREIGN KEY (DD_SMG_ID)
      REFERENCES DD_SMG_SUBFASES_MAPA_GLOBAL (DD_SMG_ID);

ALTER TABLE DD_STA_SUBTIPO_TAREA_BASE
   ADD CONSTRAINT FK_DD_STA_S_FK_DD_TAR_DD_TAR_T FOREIGN KEY (DD_TAR_ID)
      REFERENCES DD_TAR_TIPO_TAREA_BASE (DD_TAR_ID);

ALTER TABLE DD_STA_SUBTIPO_TAREA_BASE_LG
   ADD CONSTRAINT FK_DD_STA_S_FK_STA_LG_DD_STA_S FOREIGN KEY (DD_STA_ID)
      REFERENCES DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID);

ALTER TABLE DD_STI_SITUACION_LG
   ADD CONSTRAINT FK_DD_STI_S_FK_STI_LG_DD_STI_S FOREIGN KEY (DD_STI_ID)
      REFERENCES DD_STI_SITUACION (DD_STI_ID);

ALTER TABLE DD_TAA_TIPO_AYUDA_ACTUACION_LG
   ADD CONSTRAINT FK_DD_TAA_T_FK_TAA_LG_DD_TAA_T FOREIGN KEY (DD_TAA_ID)
      REFERENCES DD_TAA_TIPO_AYUDA_ACTUACION (DD_TAA_ID);

ALTER TABLE DD_TAC_TIPO_ACTUACION_LG
   ADD CONSTRAINT FK_DD_TAC_T_FK_TAC_LG_DD_TAC_T FOREIGN KEY (DD_TAC_ID)
      REFERENCES DD_TAC_TIPO_ACTUACION (DD_TAC_ID);

ALTER TABLE DD_TAR_TIPO_TAREA_BASE_LG
   ADD CONSTRAINT FK_DD_TAR_T_FK_TAR_LG_DD_TAR_T FOREIGN KEY (DD_TAR_ID)
      REFERENCES DD_TAR_TIPO_TAREA_BASE (DD_TAR_ID);

ALTER TABLE DD_TBI_TIPO_BIEN_LG
   ADD CONSTRAINT FK_DD_TBI_T_FK_TBI_LG_DD_TBI_T FOREIGN KEY (DD_TBI_ID)
      REFERENCES DD_TBI_TIPO_BIEN (DD_TBI_ID);

ALTER TABLE DD_TDI_TIPO_DOCUMENTO_ID_LG
   ADD CONSTRAINT FK_DD_TDI_T_FK_TDI_LG_DD_TDI_T FOREIGN KEY (DD_TDI_ID)
      REFERENCES DD_TDI_TIPO_DOCUMENTO_ID (DD_TDI_ID);

ALTER TABLE DD_TGA_TIPO_GARANTIA_LG
   ADD CONSTRAINT FK_DD_TGA_T_FK_TGA_LG_DD_TGA_T FOREIGN KEY (DD_TGA_ID)
      REFERENCES DD_TGA_TIPO_GARANTIA (DD_TGA_ID);

ALTER TABLE DD_TIG_TIPO_INGRESO_LG
   ADD CONSTRAINT FK_DD_TIN_T_FK_TIN_LG_DD_TIN_2 FOREIGN KEY (DD_TIG_ID)
      REFERENCES DD_TIG_TIPO_INGRESO (DD_TIG_ID);

ALTER TABLE DD_TPE_TIPO_PERSONA_LG
   ADD CONSTRAINT FK_DD_TPE_T_FK_TPE_LG_DD_TPE_T FOREIGN KEY (DD_TPE_ID)
      REFERENCES DD_TPE_TIPO_PERSONA (DD_TPE_ID);

ALTER TABLE DD_TPO_TIPO_PROCEDIMIENTO_LG
   ADD CONSTRAINT FK_DD_TPO_T_FK_DD_TPO_DD_TPO_T FOREIGN KEY (DD_TPO_ID)
      REFERENCES DD_TPO_TIPO_PROCEDIMIENTO (DD_TPO_ID);

ALTER TABLE DD_TRE_TIPO_RECLAMACION_LG
   ADD CONSTRAINT FK_DD_TRE_T_FK_DD_TRE_DD_TRE_T FOREIGN KEY (DD_TRE_ID)
      REFERENCES DD_TRE_TIPO_RECLAMACION (DD_TRE_ID);

ALTER TABLE DD_TTI_TIPO_TITULO_LG
   ADD CONSTRAINT FK_DD_TTI_T_FK_TTI_LG_DD_TTI_T FOREIGN KEY (DD_TTI_ID)
      REFERENCES DD_TTI_TIPO_TITULO (DD_TTI_ID);

ALTER TABLE DD_TVI_TIPO_VIA_LG
   ADD CONSTRAINT FK_DD_TVI_T_FK_TVI_LG_DD_TVI_T FOREIGN KEY (DD_TVI_ID)
      REFERENCES DD_TVI_TIPO_VIA (DD_TVI_ID);

ALTER TABLE ENTIDADCONFIG
   ADD CONSTRAINT "FK_ENTIDADCONFIG_ENTIDAD" FOREIGN KEY (ENTIDAD_ID)
      REFERENCES ENTIDAD (ID);

ALTER TABLE USUARIO_ROLE
   ADD CONSTRAINT "FK_AUTHORIES_ROLE" FOREIGN KEY (ROLE)
      REFERENCES ROLE (ROLE);

ALTER TABLE USUARIO_ROLE
   ADD CONSTRAINT "FK_AUTHORIES_USUARIO" FOREIGN KEY (USERNAME)
      REFERENCES USUARIO (USERNAME);

ALTER TABLE USU_USUARIOS
   ADD CONSTRAINT FK_USU_USUA_FK_USU_EN_ENTIDAD FOREIGN KEY (ENTIDAD_ID)
      REFERENCES ENTIDAD (ID);




grant references on DD_CIM_CAUSAS_IMPAGO to ${sql.conn.username1};
grant select on DD_CIM_CAUSAS_IMPAGO to ${sql.conn.username1};
grant insert on DD_CIM_CAUSAS_IMPAGO to ${sql.conn.username1};
grant delete on DD_CIM_CAUSAS_IMPAGO to ${sql.conn.username1};
grant update on DD_CIM_CAUSAS_IMPAGO to ${sql.conn.username1};

grant references on DD_CPR_CAUSA_PRORROGA to ${sql.conn.username1};
grant select on DD_CPR_CAUSA_PRORROGA to ${sql.conn.username1};
grant insert on DD_CPR_CAUSA_PRORROGA to ${sql.conn.username1};
grant delete on DD_CPR_CAUSA_PRORROGA to ${sql.conn.username1};
grant update on DD_CPR_CAUSA_PRORROGA to ${sql.conn.username1};

grant references on DD_CTL_CAUSA_EXCLUSION to ${sql.conn.username1};
grant select on DD_CTL_CAUSA_EXCLUSION to ${sql.conn.username1};
grant insert on DD_CTL_CAUSA_EXCLUSION to ${sql.conn.username1};
grant delete on DD_CTL_CAUSA_EXCLUSION to ${sql.conn.username1};
grant update on DD_CTL_CAUSA_EXCLUSION to ${sql.conn.username1};

grant references on DD_DTI_TIPO_INCIDENCIAS to ${sql.conn.username1};
grant select on DD_DTI_TIPO_INCIDENCIAS to ${sql.conn.username1};
grant insert on DD_DTI_TIPO_INCIDENCIAS to ${sql.conn.username1};
grant delete on DD_DTI_TIPO_INCIDENCIAS to ${sql.conn.username1};
grant update on DD_DTI_TIPO_INCIDENCIAS to ${sql.conn.username1};


grant references on DD_EFC_ESTADO_FINAN_CNT to ${sql.conn.username1};
grant select on DD_EFC_ESTADO_FINAN_CNT to ${sql.conn.username1};
grant insert on DD_EFC_ESTADO_FINAN_CNT to ${sql.conn.username1};
grant delete on DD_EFC_ESTADO_FINAN_CNT to ${sql.conn.username1};
grant update on DD_EFC_ESTADO_FINAN_CNT to ${sql.conn.username1};


grant references on DD_EIN_ENTIDAD_INFORMACION to ${sql.conn.username1};
grant select on DD_EIN_ENTIDAD_INFORMACION to ${sql.conn.username1};
grant insert on DD_EIN_ENTIDAD_INFORMACION to ${sql.conn.username1};
grant delete on DD_EIN_ENTIDAD_INFORMACION to ${sql.conn.username1};
grant update on DD_EIN_ENTIDAD_INFORMACION to ${sql.conn.username1};

grant references on DD_ESC_ESTADO_CNT to ${sql.conn.username1};
grant select on DD_ESC_ESTADO_CNT to ${sql.conn.username1};
grant insert on DD_ESC_ESTADO_CNT to ${sql.conn.username1};
grant delete on DD_ESC_ESTADO_CNT to ${sql.conn.username1};
grant update on DD_ESC_ESTADO_CNT to ${sql.conn.username1};
    
grant references on DD_EST_ESTADOS_ITINERARIOS to ${sql.conn.username1};
grant select on DD_EST_ESTADOS_ITINERARIOS to ${sql.conn.username1};
grant insert on DD_EST_ESTADOS_ITINERARIOS to ${sql.conn.username1};
grant delete on DD_EST_ESTADOS_ITINERARIOS to ${sql.conn.username1};
grant update on DD_EST_ESTADOS_ITINERARIOS to ${sql.conn.username1};

grant references on DD_FMG_FASES_MAPA_GLOBAL to ${sql.conn.username1};
grant select on DD_FMG_FASES_MAPA_GLOBAL to ${sql.conn.username1};
grant insert on DD_FMG_FASES_MAPA_GLOBAL to ${sql.conn.username1};
grant delete on DD_FMG_FASES_MAPA_GLOBAL to ${sql.conn.username1};
grant update on DD_FMG_FASES_MAPA_GLOBAL to ${sql.conn.username1};

grant references on DD_LOC_LOCALIDAD to ${sql.conn.username1};
grant select on DD_LOC_LOCALIDAD to ${sql.conn.username1};
grant insert on DD_LOC_LOCALIDAD to ${sql.conn.username1};
grant delete on DD_LOC_LOCALIDAD to ${sql.conn.username1};
grant update on DD_LOC_LOCALIDAD to ${sql.conn.username1};


grant references on DD_MON_MONEDAS to ${sql.conn.username1};
grant select on DD_MON_MONEDAS to ${sql.conn.username1};
grant insert on DD_MON_MONEDAS to ${sql.conn.username1};
grant delete on DD_MON_MONEDAS to ${sql.conn.username1};
grant update on DD_MON_MONEDAS to ${sql.conn.username1};


grant references on DD_PRV_PROVINCIA to ${sql.conn.username1};
grant select on DD_PRV_PROVINCIA to ${sql.conn.username1};
grant insert on DD_PRV_PROVINCIA to ${sql.conn.username1};
grant delete on DD_PRV_PROVINCIA to ${sql.conn.username1};
grant update on DD_PRV_PROVINCIA to ${sql.conn.username1};


grant references on DD_RPR_RAZON_PRORROGA to ${sql.conn.username1};
grant select on DD_RPR_RAZON_PRORROGA to ${sql.conn.username1};
grant insert on DD_RPR_RAZON_PRORROGA to ${sql.conn.username1};
grant delete on DD_RPR_RAZON_PRORROGA to ${sql.conn.username1};
grant update on DD_RPR_RAZON_PRORROGA to ${sql.conn.username1};

grant references on DD_SMG_SUBFASES_MAPA_GLOBAL to ${sql.conn.username1};
grant select on DD_SMG_SUBFASES_MAPA_GLOBAL to ${sql.conn.username1};
grant insert on DD_SMG_SUBFASES_MAPA_GLOBAL to ${sql.conn.username1};
grant delete on DD_SMG_SUBFASES_MAPA_GLOBAL to ${sql.conn.username1};
grant update on DD_SMG_SUBFASES_MAPA_GLOBAL to ${sql.conn.username1};

grant references on DD_STA_SUBTIPO_TAREA_BASE to ${sql.conn.username1};
grant select on DD_STA_SUBTIPO_TAREA_BASE to ${sql.conn.username1};
grant insert on DD_STA_SUBTIPO_TAREA_BASE to ${sql.conn.username1};
grant delete on DD_STA_SUBTIPO_TAREA_BASE to ${sql.conn.username1};
grant update on DD_STA_SUBTIPO_TAREA_BASE to ${sql.conn.username1};


grant references on DD_STI_SITUACION to ${sql.conn.username1};
grant select on DD_STI_SITUACION to ${sql.conn.username1};
grant insert on DD_STI_SITUACION to ${sql.conn.username1};
grant delete on DD_STI_SITUACION to ${sql.conn.username1};
grant update on DD_STI_SITUACION to ${sql.conn.username1};

grant references on DD_TAA_TIPO_AYUDA_ACTUACION to ${sql.conn.username1};
grant select on DD_TAA_TIPO_AYUDA_ACTUACION to ${sql.conn.username1};
grant insert on DD_TAA_TIPO_AYUDA_ACTUACION to ${sql.conn.username1};
grant delete on DD_TAA_TIPO_AYUDA_ACTUACION to ${sql.conn.username1};
grant update on DD_TAA_TIPO_AYUDA_ACTUACION to ${sql.conn.username1};


grant references on DD_TAC_TIPO_ACTUACION to ${sql.conn.username1};
grant select on DD_TAC_TIPO_ACTUACION to ${sql.conn.username1};
grant insert on DD_TAC_TIPO_ACTUACION to ${sql.conn.username1};
grant delete on DD_TAC_TIPO_ACTUACION to ${sql.conn.username1};
grant update on DD_TAC_TIPO_ACTUACION to ${sql.conn.username1};

grant references on DD_TAR_TIPO_TAREA_BASE to ${sql.conn.username1};
grant select on DD_TAR_TIPO_TAREA_BASE to ${sql.conn.username1};
grant insert on DD_TAR_TIPO_TAREA_BASE to ${sql.conn.username1};
grant delete on DD_TAR_TIPO_TAREA_BASE to ${sql.conn.username1};
grant update on DD_TAR_TIPO_TAREA_BASE to ${sql.conn.username1};

grant references on DD_TBI_TIPO_BIEN to ${sql.conn.username1};
grant select on DD_TBI_TIPO_BIEN to ${sql.conn.username1};
grant insert on DD_TBI_TIPO_BIEN to ${sql.conn.username1};
grant delete on DD_TBI_TIPO_BIEN to ${sql.conn.username1};
grant update on DD_TBI_TIPO_BIEN to ${sql.conn.username1};


grant references on DD_TDI_TIPO_DOCUMENTO_ID to ${sql.conn.username1};
grant select on DD_TDI_TIPO_DOCUMENTO_ID to ${sql.conn.username1};
grant insert on DD_TDI_TIPO_DOCUMENTO_ID to ${sql.conn.username1};
grant delete on DD_TDI_TIPO_DOCUMENTO_ID to ${sql.conn.username1};
grant update on DD_TDI_TIPO_DOCUMENTO_ID to ${sql.conn.username1};

grant references on DD_TGA_TIPO_GARANTIA to ${sql.conn.username1};
grant select on DD_TGA_TIPO_GARANTIA to ${sql.conn.username1};
grant insert on DD_TGA_TIPO_GARANTIA to ${sql.conn.username1};
grant delete on DD_TGA_TIPO_GARANTIA to ${sql.conn.username1};
grant update on DD_TGA_TIPO_GARANTIA to ${sql.conn.username1};

grant references on DD_TIG_TIPO_INGRESO to ${sql.conn.username1};
grant select on DD_TIG_TIPO_INGRESO to ${sql.conn.username1};
grant insert on DD_TIG_TIPO_INGRESO to ${sql.conn.username1};
grant delete on DD_TIG_TIPO_INGRESO to ${sql.conn.username1};
grant update on DD_TIG_TIPO_INGRESO to ${sql.conn.username1};

grant references on DD_TPE_TIPO_PERSONA to ${sql.conn.username1};
grant select on DD_TPE_TIPO_PERSONA to ${sql.conn.username1};
grant insert on DD_TPE_TIPO_PERSONA to ${sql.conn.username1};
grant delete on DD_TPE_TIPO_PERSONA to ${sql.conn.username1};
grant update on DD_TPE_TIPO_PERSONA to ${sql.conn.username1};

grant references on DD_TPO_TIPO_PROCEDIMIENTO to ${sql.conn.username1};
grant select on DD_TPO_TIPO_PROCEDIMIENTO to ${sql.conn.username1};
grant insert on DD_TPO_TIPO_PROCEDIMIENTO to ${sql.conn.username1};
grant delete on DD_TPO_TIPO_PROCEDIMIENTO to ${sql.conn.username1};
grant update on DD_TPO_TIPO_PROCEDIMIENTO to ${sql.conn.username1};


grant references on DD_TRE_TIPO_RECLAMACION to ${sql.conn.username1};
grant select on DD_TRE_TIPO_RECLAMACION to ${sql.conn.username1};
grant insert on DD_TRE_TIPO_RECLAMACION to ${sql.conn.username1};
grant delete on DD_TRE_TIPO_RECLAMACION to ${sql.conn.username1};
grant update on DD_TRE_TIPO_RECLAMACION to ${sql.conn.username1};


grant references on DD_TTI_TIPO_TITULO to ${sql.conn.username1};
grant select on DD_TTI_TIPO_TITULO to ${sql.conn.username1};
grant insert on DD_TTI_TIPO_TITULO to ${sql.conn.username1};
grant delete on DD_TTI_TIPO_TITULO to ${sql.conn.username1};
grant update on DD_TTI_TIPO_TITULO to ${sql.conn.username1};

grant references on DD_TVI_TIPO_VIA to ${sql.conn.username1};
grant select on DD_TVI_TIPO_VIA to ${sql.conn.username1};
grant insert on DD_TVI_TIPO_VIA to ${sql.conn.username1};
grant delete on DD_TVI_TIPO_VIA to ${sql.conn.username1};
grant update on DD_TVI_TIPO_VIA to ${sql.conn.username1};


grant references on FUN_FUNCIONES to ${sql.conn.username1};
grant select on FUN_FUNCIONES to ${sql.conn.username1};
grant insert on FUN_FUNCIONES to ${sql.conn.username1};
grant delete on FUN_FUNCIONES to ${sql.conn.username1};
grant update on FUN_FUNCIONES to ${sql.conn.username1};


grant references on USU_USUARIOS to ${sql.conn.username1};
grant select on USU_USUARIOS to ${sql.conn.username1};
grant insert on USU_USUARIOS to ${sql.conn.username1};
grant delete on USU_USUARIOS to ${sql.conn.username1};
grant update on USU_USUARIOS to ${sql.conn.username1};

grant references on ENTIDADCONFIG to ${sql.conn.username1};
grant select on ENTIDADCONFIG to ${sql.conn.username1};

grant references on ENTIDAD to ${sql.conn.username1};
grant select on ENTIDAD to ${sql.conn.username1};



grant references on DD_CIM_CAUSAS_IMPAGO to ${sql.conn.username2};
grant select on DD_CIM_CAUSAS_IMPAGO to ${sql.conn.username2};
grant insert on DD_CIM_CAUSAS_IMPAGO to ${sql.conn.username2};
grant delete on DD_CIM_CAUSAS_IMPAGO to ${sql.conn.username2};
grant update on DD_CIM_CAUSAS_IMPAGO to ${sql.conn.username2};

grant references on DD_CPR_CAUSA_PRORROGA to ${sql.conn.username2};
grant select on DD_CPR_CAUSA_PRORROGA to ${sql.conn.username2};
grant insert on DD_CPR_CAUSA_PRORROGA to ${sql.conn.username2};
grant delete on DD_CPR_CAUSA_PRORROGA to ${sql.conn.username2};
grant update on DD_CPR_CAUSA_PRORROGA to ${sql.conn.username2};

grant references on DD_CTL_CAUSA_EXCLUSION to ${sql.conn.username2};
grant select on DD_CTL_CAUSA_EXCLUSION to ${sql.conn.username2};
grant insert on DD_CTL_CAUSA_EXCLUSION to ${sql.conn.username2};
grant delete on DD_CTL_CAUSA_EXCLUSION to ${sql.conn.username2};
grant update on DD_CTL_CAUSA_EXCLUSION to ${sql.conn.username2};

grant references on DD_DTI_TIPO_INCIDENCIAS to ${sql.conn.username2};
grant select on DD_DTI_TIPO_INCIDENCIAS to ${sql.conn.username2};
grant insert on DD_DTI_TIPO_INCIDENCIAS to ${sql.conn.username2};
grant delete on DD_DTI_TIPO_INCIDENCIAS to ${sql.conn.username2};
grant update on DD_DTI_TIPO_INCIDENCIAS to ${sql.conn.username2};


grant references on DD_EFC_ESTADO_FINAN_CNT to ${sql.conn.username2};
grant select on DD_EFC_ESTADO_FINAN_CNT to ${sql.conn.username2};
grant insert on DD_EFC_ESTADO_FINAN_CNT to ${sql.conn.username2};
grant delete on DD_EFC_ESTADO_FINAN_CNT to ${sql.conn.username2};
grant update on DD_EFC_ESTADO_FINAN_CNT to ${sql.conn.username2};


grant references on DD_EIN_ENTIDAD_INFORMACION to ${sql.conn.username2};
grant select on DD_EIN_ENTIDAD_INFORMACION to ${sql.conn.username2};
grant insert on DD_EIN_ENTIDAD_INFORMACION to ${sql.conn.username2};
grant delete on DD_EIN_ENTIDAD_INFORMACION to ${sql.conn.username2};
grant update on DD_EIN_ENTIDAD_INFORMACION to ${sql.conn.username2};

grant references on DD_ESC_ESTADO_CNT to ${sql.conn.username2};
grant select on DD_ESC_ESTADO_CNT to ${sql.conn.username2};
grant insert on DD_ESC_ESTADO_CNT to ${sql.conn.username2};
grant delete on DD_ESC_ESTADO_CNT to ${sql.conn.username2};
grant update on DD_ESC_ESTADO_CNT to ${sql.conn.username2};
    
grant references on DD_EST_ESTADOS_ITINERARIOS to ${sql.conn.username2};
grant select on DD_EST_ESTADOS_ITINERARIOS to ${sql.conn.username2};
grant insert on DD_EST_ESTADOS_ITINERARIOS to ${sql.conn.username2};
grant delete on DD_EST_ESTADOS_ITINERARIOS to ${sql.conn.username2};
grant update on DD_EST_ESTADOS_ITINERARIOS to ${sql.conn.username2};

grant references on DD_FMG_FASES_MAPA_GLOBAL to ${sql.conn.username2};
grant select on DD_FMG_FASES_MAPA_GLOBAL to ${sql.conn.username2};
grant insert on DD_FMG_FASES_MAPA_GLOBAL to ${sql.conn.username2};
grant delete on DD_FMG_FASES_MAPA_GLOBAL to ${sql.conn.username2};
grant update on DD_FMG_FASES_MAPA_GLOBAL to ${sql.conn.username2};

grant references on DD_LOC_LOCALIDAD to ${sql.conn.username2};
grant select on DD_LOC_LOCALIDAD to ${sql.conn.username2};
grant insert on DD_LOC_LOCALIDAD to ${sql.conn.username2};
grant delete on DD_LOC_LOCALIDAD to ${sql.conn.username2};
grant update on DD_LOC_LOCALIDAD to ${sql.conn.username2};


grant references on DD_MON_MONEDAS to ${sql.conn.username2};
grant select on DD_MON_MONEDAS to ${sql.conn.username2};
grant insert on DD_MON_MONEDAS to ${sql.conn.username2};
grant delete on DD_MON_MONEDAS to ${sql.conn.username2};
grant update on DD_MON_MONEDAS to ${sql.conn.username2};


grant references on DD_PRV_PROVINCIA to ${sql.conn.username2};
grant select on DD_PRV_PROVINCIA to ${sql.conn.username2};
grant insert on DD_PRV_PROVINCIA to ${sql.conn.username2};
grant delete on DD_PRV_PROVINCIA to ${sql.conn.username2};
grant update on DD_PRV_PROVINCIA to ${sql.conn.username2};


grant references on DD_RPR_RAZON_PRORROGA to ${sql.conn.username2};
grant select on DD_RPR_RAZON_PRORROGA to ${sql.conn.username2};
grant insert on DD_RPR_RAZON_PRORROGA to ${sql.conn.username2};
grant delete on DD_RPR_RAZON_PRORROGA to ${sql.conn.username2};
grant update on DD_RPR_RAZON_PRORROGA to ${sql.conn.username2};

grant references on DD_SMG_SUBFASES_MAPA_GLOBAL to ${sql.conn.username2};
grant select on DD_SMG_SUBFASES_MAPA_GLOBAL to ${sql.conn.username2};
grant insert on DD_SMG_SUBFASES_MAPA_GLOBAL to ${sql.conn.username2};
grant delete on DD_SMG_SUBFASES_MAPA_GLOBAL to ${sql.conn.username2};
grant update on DD_SMG_SUBFASES_MAPA_GLOBAL to ${sql.conn.username2};

grant references on DD_STA_SUBTIPO_TAREA_BASE to ${sql.conn.username2};
grant select on DD_STA_SUBTIPO_TAREA_BASE to ${sql.conn.username2};
grant insert on DD_STA_SUBTIPO_TAREA_BASE to ${sql.conn.username2};
grant delete on DD_STA_SUBTIPO_TAREA_BASE to ${sql.conn.username2};
grant update on DD_STA_SUBTIPO_TAREA_BASE to ${sql.conn.username2};


grant references on DD_STI_SITUACION to ${sql.conn.username2};
grant select on DD_STI_SITUACION to ${sql.conn.username2};
grant insert on DD_STI_SITUACION to ${sql.conn.username2};
grant delete on DD_STI_SITUACION to ${sql.conn.username2};
grant update on DD_STI_SITUACION to ${sql.conn.username2};

grant references on DD_TAA_TIPO_AYUDA_ACTUACION to ${sql.conn.username2};
grant select on DD_TAA_TIPO_AYUDA_ACTUACION to ${sql.conn.username2};
grant insert on DD_TAA_TIPO_AYUDA_ACTUACION to ${sql.conn.username2};
grant delete on DD_TAA_TIPO_AYUDA_ACTUACION to ${sql.conn.username2};
grant update on DD_TAA_TIPO_AYUDA_ACTUACION to ${sql.conn.username2};


grant references on DD_TAC_TIPO_ACTUACION to ${sql.conn.username2};
grant select on DD_TAC_TIPO_ACTUACION to ${sql.conn.username2};
grant insert on DD_TAC_TIPO_ACTUACION to ${sql.conn.username2};
grant delete on DD_TAC_TIPO_ACTUACION to ${sql.conn.username2};
grant update on DD_TAC_TIPO_ACTUACION to ${sql.conn.username2};

grant references on DD_TAR_TIPO_TAREA_BASE to ${sql.conn.username2};
grant select on DD_TAR_TIPO_TAREA_BASE to ${sql.conn.username2};
grant insert on DD_TAR_TIPO_TAREA_BASE to ${sql.conn.username2};
grant delete on DD_TAR_TIPO_TAREA_BASE to ${sql.conn.username2};
grant update on DD_TAR_TIPO_TAREA_BASE to ${sql.conn.username2};

grant references on DD_TBI_TIPO_BIEN to ${sql.conn.username2};
grant select on DD_TBI_TIPO_BIEN to ${sql.conn.username2};
grant insert on DD_TBI_TIPO_BIEN to ${sql.conn.username2};
grant delete on DD_TBI_TIPO_BIEN to ${sql.conn.username2};
grant update on DD_TBI_TIPO_BIEN to ${sql.conn.username2};

grant references on DD_TDI_TIPO_DOCUMENTO_ID to ${sql.conn.username2};
grant select on DD_TDI_TIPO_DOCUMENTO_ID to ${sql.conn.username2};
grant insert on DD_TDI_TIPO_DOCUMENTO_ID to ${sql.conn.username2};
grant delete on DD_TDI_TIPO_DOCUMENTO_ID to ${sql.conn.username2};
grant update on DD_TDI_TIPO_DOCUMENTO_ID to ${sql.conn.username2};

grant references on DD_TGA_TIPO_GARANTIA to ${sql.conn.username2};
grant select on DD_TGA_TIPO_GARANTIA to ${sql.conn.username2};
grant insert on DD_TGA_TIPO_GARANTIA to ${sql.conn.username2};
grant delete on DD_TGA_TIPO_GARANTIA to ${sql.conn.username2};
grant update on DD_TGA_TIPO_GARANTIA to ${sql.conn.username2};

grant references on DD_TIG_TIPO_INGRESO to ${sql.conn.username2};
grant select on DD_TIG_TIPO_INGRESO to ${sql.conn.username2};
grant insert on DD_TIG_TIPO_INGRESO to ${sql.conn.username2};
grant delete on DD_TIG_TIPO_INGRESO to ${sql.conn.username2};
grant update on DD_TIG_TIPO_INGRESO to ${sql.conn.username2};

grant references on DD_TPE_TIPO_PERSONA to ${sql.conn.username2};
grant select on DD_TPE_TIPO_PERSONA to ${sql.conn.username2};
grant insert on DD_TPE_TIPO_PERSONA to ${sql.conn.username2};
grant delete on DD_TPE_TIPO_PERSONA to ${sql.conn.username2};
grant update on DD_TPE_TIPO_PERSONA to ${sql.conn.username2};

grant references on DD_TPO_TIPO_PROCEDIMIENTO to ${sql.conn.username2};
grant select on DD_TPO_TIPO_PROCEDIMIENTO to ${sql.conn.username2};
grant insert on DD_TPO_TIPO_PROCEDIMIENTO to ${sql.conn.username2};
grant delete on DD_TPO_TIPO_PROCEDIMIENTO to ${sql.conn.username2};
grant update on DD_TPO_TIPO_PROCEDIMIENTO to ${sql.conn.username2};


grant references on DD_TRE_TIPO_RECLAMACION to ${sql.conn.username2};
grant select on DD_TRE_TIPO_RECLAMACION to ${sql.conn.username2};
grant insert on DD_TRE_TIPO_RECLAMACION to ${sql.conn.username2};
grant delete on DD_TRE_TIPO_RECLAMACION to ${sql.conn.username2};
grant update on DD_TRE_TIPO_RECLAMACION to ${sql.conn.username2};


grant references on DD_TTI_TIPO_TITULO to ${sql.conn.username2};
grant select on DD_TTI_TIPO_TITULO to ${sql.conn.username2};
grant insert on DD_TTI_TIPO_TITULO to ${sql.conn.username2};
grant delete on DD_TTI_TIPO_TITULO to ${sql.conn.username2};
grant update on DD_TTI_TIPO_TITULO to ${sql.conn.username2};

grant references on DD_TVI_TIPO_VIA to ${sql.conn.username2};
grant select on DD_TVI_TIPO_VIA to ${sql.conn.username2};
grant insert on DD_TVI_TIPO_VIA to ${sql.conn.username2};
grant delete on DD_TVI_TIPO_VIA to ${sql.conn.username2};
grant update on DD_TVI_TIPO_VIA to ${sql.conn.username2};


grant references on FUN_FUNCIONES to ${sql.conn.username2};
grant select on FUN_FUNCIONES to ${sql.conn.username2};
grant insert on FUN_FUNCIONES to ${sql.conn.username2};
grant delete on FUN_FUNCIONES to ${sql.conn.username2};
grant update on FUN_FUNCIONES to ${sql.conn.username2};


grant references on USU_USUARIOS to ${sql.conn.username2};
grant select on USU_USUARIOS to ${sql.conn.username2};
grant insert on USU_USUARIOS to ${sql.conn.username2};
grant delete on USU_USUARIOS to ${sql.conn.username2};
grant update on USU_USUARIOS to ${sql.conn.username2};

