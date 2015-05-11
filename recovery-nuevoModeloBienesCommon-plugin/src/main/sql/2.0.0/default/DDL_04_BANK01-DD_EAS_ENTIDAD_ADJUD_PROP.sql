--/*
--##########################################
--## Author: Roberto Lavalle
--## Finalidad: DDL de Diccionario Entidad Adjudicataria Propietaria
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--##########################################
--*/


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE

	v_seq_count number(3);
	v_table_count number(3);
	v_schema varchar(30) := 'BANK01';
	v_schema_master varchar(30) := 'BANKMASTER';
	v_constraint_count number(3);
	v_sql varchar2(4000);

BEGIN

	v_seq_count := 0;
	v_table_count := 0;

	DBMS_OUTPUT.PUT_LINE('[START]  tabla DD_EAS_ENTIDAD_ADJUD_PROP');

	EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''DD_EAS_ENTIDAD_ADJUD_PROP'' and owner = ''' || v_schema || '''' into v_table_count;

	if v_table_count > 0 then
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema || '.DD_EAS_ENTIDAD_ADJUD_PROP... Ya existe');
	else 
		EXECUTE IMMEDIATE 'CREATE TABLE '|| v_schema ||'.DD_EAS_ENTIDAD_ADJUD_PROP
			(
				"DD_EAS_ID" NUMBER(16,0) NOT NULL ENABLE,
    "DD_EAS_CODIGO" VARCHAR2(10 CHAR) NOT NULL ENABLE,
    "DD_EAS_DESCRIPCION" VARCHAR2(50 CHAR) NOT NULL ENABLE,
    "DD_EAS_DESCRIPCION_LARGA" VARCHAR2(200 CHAR) NOT NULL ENABLE,
    "VERSION" NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE,
    "USUARIOCREAR" VARCHAR2(10 CHAR) NOT NULL ENABLE,
    "FECHACREAR" TIMESTAMP (6) NOT NULL ENABLE,
    "USUARIOMODIFICAR" VARCHAR2(10 CHAR),
    "FECHAMODIFICAR" TIMESTAMP (6),
    "USUARIOBORRAR" VARCHAR2(10 CHAR),
    "FECHABORRAR" TIMESTAMP (6),
    "BORRADO" NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,
     CONSTRAINT "PK_DD_EAS_ENTIDAD_ADJUD_PROP" PRIMARY KEY ("DD_EAS_ID")
			)';

		DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| v_schema ||'.DD_EAS_ENTIDAD_ADJUD_PROP... Tabla creada OK');	
	
	end if;
	
	
		EXECUTE IMMEDIATE 'select count(1) from all_sequences where sequence_name = ''S_DD_EAS_ENTIDAD_ADJUD_PROP'' and sequence_owner = ''' || v_schema || '''' into v_seq_count;
	
		if v_seq_count > 0 then
			EXECUTE IMMEDIATE ' DROP SEQUENCE '|| v_schema ||'.S_DD_EAS_ENTIDAD_ADJUD_PROP ';
			DBMS_OUTPUT.PUT_LINE('DROP SEQUENCE '|| v_schema ||'.S_DD_EAS_ENTIDAD_ADJUD_PROP... Secuencia borrada...');
		end if;

		EXECUTE IMMEDIATE '
		CREATE SEQUENCE '|| v_schema ||'.S_DD_EAS_ENTIDAD_ADJUD_PROP
		  START WITH 1
		  MAXVALUE 9999999999999999
		  MINVALUE 1
		  NOCYCLE
		  CACHE 100
		  NOORDER';
		  
		  DBMS_OUTPUT.PUT_LINE('CREATE SEQUENCE '|| v_schema ||'.S_DD_EAS_ENTIDAD_ADJUD_PROP... Secuencia creada OK');

	DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
	RAISE;
END;
/
EXIT;