set verify off;

define MASTER_SCHEMA = &Introduce_el_master_schema;


ALTER TABLE &MASTER_SCHEMA..DD_TGE_TIPO_GESTOR
 ADD (DD_TGE_EDITABLE_WEB  NUMBER(1)               DEFAULT 1);
 
 
