DEFINE NOMBRE_TABLA = CIA_CONF_IMPULSO_AUTOMATICO
DEFINE NOMBRE_INDICE = CIA_CONF_IMPULSO_AUTOMATICO_PK

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
    CIA_ID NUMBER(16) NOT NULL,
    DD_TJ_ID NUMBER(16) NOT NULL,
    TAP_ID NUMBER(16) NOT NULL,
    CIA_CON_PROCURADOR NUMBER(1) DEFAULT 0 NOT NULL,
    DES_ID NUMBER(16) NOT NULL,
    CIA_OPER_ULTIMA_RESOL VARCHAR2(5),
    CIA_NUM_DIAS_ULTIMA_RESOL NUMBER(5),
    CIA_OPER_ULTIMO_IMPULSO VARCHAR2(5),
    CIA_NUM_DIAS_ULTIMO_IMPULSO NUMBER(5),
    VERSION                  INTEGER              DEFAULT 0                     NOT NULL,
    USUARIOCREAR             VARCHAR2(10 BYTE)    NOT NULL,
    FECHACREAR               TIMESTAMP(6)         NOT NULL,
    USUARIOMODIFICAR         VARCHAR2(10 BYTE),
    FECHAMODIFICAR           TIMESTAMP(6),
    USUARIOBORRAR            VARCHAR2(10 BYTE),
    FECHABORRAR              TIMESTAMP(6),
    BORRADO                  NUMBER(1)            DEFAULT 0                     NOT NULL
);

CREATE UNIQUE INDEX &NOMBRE_INDICE ON &NOMBRE_TABLA (CIA_ID);

--ALTER TABLE &NOMBRE_TABLA ADD (
--  CONSTRAINT &NOMBRE_INDICE
-- PRIMARY KEY
-- (CIA_ID)
--    USING INDEX 
-- );

ALTER TABLE &NOMBRE_TABLA ADD (
  CONSTRAINT FK_DD_TJ_ID 
 FOREIGN KEY (DD_TJ_ID) 
 REFERENCES DD_TJ_TIPO_JUICIO (DD_TJ_ID));
 
ALTER TABLE &NOMBRE_TABLA ADD (
  CONSTRAINT FK_TAP_ID 
 FOREIGN KEY (TAP_ID) 
 REFERENCES TAP_TAREA_PROCEDIMIENTO (TAP_ID));
 
ALTER TABLE &NOMBRE_TABLA ADD (
  CONSTRAINT FK_DES_ID 
 FOREIGN KEY (DES_ID) 
 REFERENCES DES_DESPACHO_EXTERNO (DES_ID));
 