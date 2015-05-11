drop table LIN_ASUNTOS_NUEVOS;

CREATE TABLE LIN_ASUNTOS_NUEVOS
(
  N_CASO        NUMBER(16)                      NOT NULL,
  CREADO        VARCHAR2(1 BYTE)                DEFAULT 'N'                   NOT NULL,
  FECHA_ALTA    DATE                            DEFAULT SYSDATE               NOT NULL,
  N_REFERENCIA  VARCHAR2(50 CHAR)               NOT NULL,
  DESPACHO      NUMBER(16)                      NOT NULL,
  LETRADO       VARCHAR2(10 CHAR),
  GRUPO         VARCHAR2(10 CHAR),
  TIPO_PROC     NUMBER(16)                      NOT NULL,
  PROCURADOR    VARCHAR2(10 CHAR)              NOT NULL,
  PLAZA         NUMBER(16)                      NOT NULL,
  JUZGADO       NUMBER(16),
  PRINCIPAL     NUMBER(14,2)                    NOT NULL,
  ID            NUMBER                          NOT NULL,
  VERSION       INTEGER                         DEFAULT 0                     NOT NULL
);


CREATE UNIQUE INDEX LIN_ASUNTOS_NUEVOS_PK ON LIN_ASUNTOS_NUEVOS(ID);


ALTER TABLE LIN_ASUNTOS_NUEVOS ADD (CONSTRAINT LIN_ASUNTOS_NUEVOS_PK PRIMARY KEY (ID) USING INDEX);


DROP TABLE LIN_LOTES_NUEVOS;

CREATE TABLE LIN_LOTES_NUEVOS
(
  N_CASO          NUMBER(16)                    NOT NULL,
  CREADO          VARCHAR2(1 BYTE)              DEFAULT 'N'                   NOT NULL,
  FECHA_ALTA      DATE                          DEFAULT SYSDATE               NOT NULL,
  N_REFERENCIA    VARCHAR2(50 CHAR)             NOT NULL,
  DESPACHO        NUMBER(16)                    NOT NULL,
  LETRADO         VARCHAR2(10 CHAR),
  GRUPO           VARCHAR2(10 CHAR),
  TIPO_PROC       NUMBER(16)                    NOT NULL,
  CON_PROCURADOR  VARCHAR2(1 BYTE)              DEFAULT 'N'                   NOT NULL,
  CON_CONTRATO    VARCHAR2(1 BYTE)              DEFAULT 'N'                   NOT NULL,
  LOTE            VARCHAR2(50 CHAR)             NOT NULL,
  ID              NUMBER                        NOT NULL,
  VERSION         INTEGER                       DEFAULT 0                     NOT NULL
);


CREATE UNIQUE INDEX LIN_LOTES_NUEVOS_PK ON LIN_LOTES_NUEVOS (ID);


ALTER TABLE LIN_LOTES_NUEVOS ADD (CONSTRAINT LIN_LOTES_NUEVOS_PK PRIMARY KEY (ID) USING INDEX);

create sequence S_LIN_ASUNTOS_NUEVOS;

create sequence S_LIN_LOTES_NUEVOS;

