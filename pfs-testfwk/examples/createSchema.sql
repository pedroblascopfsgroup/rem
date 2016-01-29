CREATE TABLE USU_USUARIOS  (
   USU_ID               INTEGER                      NOT NULL,
   ENTIDAD_ID           INTEGER,
   USU_USERNAME         VARCHAR                    NOT NULL,
   USU_PASSWORD         VARCHAR,
   USU_NOMBRE           VARCHAR,
   USU_APELLIDO1        VARCHAR,
   USU_APELLIDO2        VARCHAR,
   USU_TELEFONO         VARCHAR,
   USU_MAIL             VARCHAR,
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR                    NOT NULL,
   FECHACREAR           DATETIME                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR,
   FECHAMODIFICAR       DATETIME,
   USUARIOBORRAR        VARCHAR,
   FECHABORRAR          DATETIME,
   BORRADO              INTEGER                    DEFAULT 0 NOT NULL,
   CONSTRAINT PK_USU_USUARIOS PRIMARY KEY (USU_ID)
);

CREATE TABLE DES_DESPACHO_EXTERNO  (
   DES_ID               INTEGER                      NOT NULL,
   DES_DESPACHO         VARCHAR,
   DES_TIPO_VIA         VARCHAR,
   DES_DOMICILIO        VARCHAR,
   DES_DOMICILIO_PLAZA  VARCHAR,
   DES_CODIGO_POSTAL    INTEGER,
   DES_PERSONA_CONTACTO VARCHAR,
   DES_TELEFONO2        VARCHAR,
   DES_TELEFONO1        VARCHAR,
   VERSION              INTEGER                        DEFAULT 0 NOT NULL,
   USUARIOCREAR         VARCHAR                    NOT NULL,
   FECHACREAR           DATETIME                       NOT NULL,
   USUARIOMODIFICAR     VARCHAR,
   FECHAMODIFICAR       DATETIME,
   USUARIOBORRAR        VARCHAR,
   FECHABORRAR          DATETIME,
   BORRADO              INTEGER                   DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DES_DESPACHO_EXTERNO PRIMARY KEY (DES_ID)
);


CREATE TABLE USD_USUARIOS_DESPACHOS (
    USD_ID              INTEGER                    NOT NULL,
    USU_ID              INTEGER                   NOT NULL,
    DES_ID              INTEGER                    NOT NULL,
    USD_GESTOR_DEFECTO  INTEGER                     NOT NULL,
    USD_SUPERVISOR      INTEGER                     NOT NULL,
    VERSION             INTEGER              DEFAULT 0   NOT NULL,
    USUARIOCREAR        VARCHAR               NOT NULL,
    FECHACREAR          DATETIME                   NOT NULL,
    USUARIOMODIFICAR    VARCHAR,
    FECHAMODIFICAR      DATETIME,
    USUARIOBORRAR       VARCHAR,
    FECHABORRAR         DATETIME,
    BORRADO             INTEGER         DEFAULT 0   NOT NULL,
    CONSTRAINT PK_USD_USUARIOS_DESPACHOS PRIMARY KEY (USD_ID)
);