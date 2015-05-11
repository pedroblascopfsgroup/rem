DEFINE NOMBRE_TABLA = CEI_CONF_ENVIO_IMPRESION
DEFINE NOMBRE_INDICE = CEI_CONF_ENVIO_IMPRESION_PK

declare
   c int;
   nombre_tabla varchar2(255);
begin
   nombre_tabla := '&NOMBRE_TABLA';
   select count(*) into c from user_tables where table_name = upper(nombre_tabla);
   if c = 1 then
      execute immediate 'drop table ' || nombre_tabla;
   end if;
   select count(*) into c from user_sequences where sequence_name = upper('S_' || nombre_tabla);
   if c = 1 then
      execute immediate 'drop sequence S_' || nombre_tabla;
   end if;
end;

CREATE SEQUENCE S_&NOMBRE_TABLA
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 100
  NOORDER;
  
CREATE TABLE &NOMBRE_TABLA (
    CEI_ID NUMBER(16) NOT NULL,
    CEI_PACK_IMPRESION VARCHAR2(25),
    DD_TFA_ID NUMBER(16) NOT NULL,
    CEI_NUM_ORDEN NUMBER(3) NOT NULL,
    CEI_REPETIR_DEMANDADO NUMBER(1) DEFAULT 0 NOT NULL,
    CEI_NUM_COPIAS_ADIC NUMBER(3) NOT NULL,
    CEI_INCLUIR_PLAZA NUMBER(1) DEFAULT 1 NOT NULL,
    VERSION                  INTEGER              DEFAULT 0                     NOT NULL,
    USUARIOCREAR             VARCHAR2(10 BYTE)    NOT NULL,
    FECHACREAR               TIMESTAMP(6)         NOT NULL,
    USUARIOMODIFICAR         VARCHAR2(10 BYTE),
    FECHAMODIFICAR           TIMESTAMP(6),
    USUARIOBORRAR            VARCHAR2(10 BYTE),
    FECHABORRAR              TIMESTAMP(6),
    BORRADO                  NUMBER(1)            DEFAULT 0                     NOT NULL
);

CREATE UNIQUE INDEX &NOMBRE_INDICE ON &NOMBRE_TABLA (CEI_ID);

ALTER TABLE &NOMBRE_TABLA ADD (
  CONSTRAINT FK_DD_TFA_ID 
 FOREIGN KEY (DD_TFA_ID) 
 REFERENCES DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID));
 
CREATE UNIQUE INDEX CEI_CONF_ENVIO_IMPRESION_AUX ON CEI_CONF_ENVIO_IMPRESION (CEI_PACK_IMPRESION, CEI_NUM_ORDEN, CEI_REPETIR_DEMANDADO);
