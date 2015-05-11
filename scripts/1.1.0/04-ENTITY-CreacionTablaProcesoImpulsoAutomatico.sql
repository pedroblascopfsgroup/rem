DEFINE NOMBRE_TABLA = PIA_PROCESO_IMPULSO_AUTO
DEFINE NOMBRE_INDICE = PIA_PROCESO_IMPULSO_AUTO_PK

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
	PIA_ID NUMBER(16) NOT NULL,
    CIA_ID NUMBER(16) NOT NULL,
    FECHAPROCESO TIMESTAMP(6)         NOT NULL,
    PIA_ESTADO VARCHAR2(3) NOT NULL, -- VALORES: 'INI', 'FIN', 'ERR' 
    PIA_FICHERO_RESULTADOS VARCHAR2(255),
    PIA_FICHERO_ERRORES VARCHAR2(255),
    VERSION                  INTEGER              DEFAULT 0                     NOT NULL,
    USUARIOCREAR             VARCHAR2(10 BYTE)    NOT NULL,
    FECHACREAR               TIMESTAMP(6)         NOT NULL,
    USUARIOMODIFICAR         VARCHAR2(10 BYTE),
    FECHAMODIFICAR           TIMESTAMP(6),
    USUARIOBORRAR            VARCHAR2(10 BYTE),
    FECHABORRAR              TIMESTAMP(6),
    BORRADO                  NUMBER(1)            DEFAULT 0                     NOT NULL
);

CREATE UNIQUE INDEX &NOMBRE_INDICE ON &NOMBRE_TABLA (PIA_ID);

ALTER TABLE &NOMBRE_TABLA ADD (
  CONSTRAINT &NOMBRE_INDICE 
 PRIMARY KEY (IAG_ID));


ALTER TABLE &NOMBRE_TABLA ADD (
  CONSTRAINT FK_CIA_ID 
 FOREIGN KEY (CIA_ID) 
 REFERENCES CIA_CONF_IMPULSO_AUTOMATICO (CIA_ID));
