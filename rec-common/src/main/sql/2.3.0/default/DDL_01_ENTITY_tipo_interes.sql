-- crear tabla de diccionario de datos para tipo de interés

CREATE SEQUENCE S_DD_TIN_TIPO_INTERES;

CREATE TABLE DD_TIN_TIPO_INTERES (
   DD_TIN_ID                NUMBER(16)                      NOT NULL,        
   DD_TIN_CODIGO                VARCHAR2(20 CHAR)                      NOT NULL,
   DD_TIN_DESCRIPCION           VARCHAR2(50 CHAR)                       NOT NULL,
   DD_TIN_DESCRIPCION_LARGA     VARCHAR2(250 CHAR) ,
   VERSION                      INTEGER               DEFAULT 0 NOT NULL,
   USUARIOCREAR                 VARCHAR2(10 CHAR)               NOT NULL,
   FECHACREAR                   TIMESTAMP(6)                    NOT NULL,
   USUARIOMODIFICAR             VARCHAR2(10 CHAR),
   FECHAMODIFICAR               TIMESTAMP(6),
   USUARIOBORRAR                VARCHAR2(10 CHAR),
   FECHABORRAR                  TIMESTAMP(6),
   BORRADO                      NUMBER(1)             DEFAULT 0 NOT NULL,
   CONSTRAINT PK_DD_TIN_TIPO_INTERES PRIMARY KEY (DD_TIN_ID),
   CONSTRAINT UK_DD_TIN_TIPO_INTERES UNIQUE (DD_TIN_CODIGO)
);
