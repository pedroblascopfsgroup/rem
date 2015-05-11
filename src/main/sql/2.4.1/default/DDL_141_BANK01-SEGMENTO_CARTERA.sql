--/*
--##########################################
--## Author: Francisco Gutiérrez
--## Finalidad: DDL de Diccionario Segmento Cartera
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--##########################################
--*/


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
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

DBMS_OUTPUT.PUT_LINE('[START]  tabla DD_SEC_SEGMENTO_CARTERA');

EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''DD_SEC_SEGMENTO_CARTERA'' and owner = ''' || v_schema || '''' into v_table_count;

if v_table_count > 0 then
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema || '.DD_SEC_SEGMENTO_CARTERA... Ya existe');
else 
	EXECUTE IMMEDIATE 'CREATE TABLE '|| v_schema ||'.DD_SEC_SEGMENTO_CARTERA
		(
			DD_SEC_ID                 NUMBER(16),
			DD_SEC_CODIGO             VARCHAR2(10 CHAR)        NOT NULL,
			DD_SEC_DESCRIPCION        VARCHAR2(50 CHAR),
			DD_SEC_DESCRIPCION_LARGA  VARCHAR2(100 CHAR),
			VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
			USUARIOCREAR              VARCHAR2(25 CHAR)        NOT NULL,
			FECHACREAR                DATE                DEFAULT SYSDATE               NOT NULL,
			BORRADO                   INTEGER             DEFAULT 0                     NOT NULL,
			USUARIOMODIFICAR          VARCHAR2(25 CHAR),
			FECHAMODIFICAR            DATE,
			USUARIOBORRAR             VARCHAR2(25 CHAR),
			FECHABORRAR               DATE
		)';

	DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| v_schema ||'.DD_SEC_SEGMENTO_CARTERA... Tabla creada OK');
	
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX '|| v_schema ||'.PK_DD_SEC_SEGMENTO_CARTERA ON '|| v_schema ||'.DD_SEC_SEGMENTO_CARTERA (DD_SEC_ID)';
	
	DBMS_OUTPUT.PUT_LINE('CREATE UNIQUE INDEX '|| v_schema ||'.PK_DD_SEC_SEGMENTO_CARTERA... Indice creado OK');

	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX '|| v_schema ||'.UK_DD_SEC_SEGMENTO_CARTERA ON '|| v_schema ||'.DD_SEC_SEGMENTO_CARTERA (DD_SEC_CODIGO)';
	
	DBMS_OUTPUT.PUT_LINE('CREATE UNIQUE INDEX '|| v_schema ||'.UK_DD_SEC_SEGMENTO_CARTERA... Indice creado OK');

	EXECUTE IMMEDIATE '
	ALTER TABLE '|| v_schema ||'.DD_SEC_SEGMENTO_CARTERA ADD (
	  CONSTRAINT PK_DD_SEC_SEGMENTO_CARTERA
	 PRIMARY KEY
	 (DD_SEC_ID)
	 ,
	  CONSTRAINT UK_DD_SEC_SEGMENTO_CARTERA
	 UNIQUE (DD_SEC_CODIGO)
		)';
	
	DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| v_schema ||'.DD_SEC_SEGMENTO_CARTERA... Tabla modificada OK');	
	
end if;
	
	
	EXECUTE IMMEDIATE 'select count(1) from all_sequences where sequence_name = ''S_DD_SEC_SEGMENTO_CARTERA'' and sequence_owner = ''' || v_schema || '''' into v_seq_count;
	
	if v_seq_count > 0 then
		EXECUTE IMMEDIATE ' DROP SEQUENCE '|| v_schema ||'.S_DD_SEC_SEGMENTO_CARTERA ';
		DBMS_OUTPUT.PUT_LINE('DROP SEQUENCE '|| v_schema ||'.S_DD_SEC_SEGMENTO_CARTERA... Secuencia borrada...');
	end if;

	EXECUTE IMMEDIATE '
	CREATE SEQUENCE '|| v_schema ||'.S_DD_SEC_SEGMENTO_CARTERA
	  START WITH 1
	  MAXVALUE 9999999999999999
	  MINVALUE 1
	  NOCYCLE
	  CACHE 100
	  NOORDER';
	  
	  DBMS_OUTPUT.PUT_LINE('CREATE SEQUENCE '|| v_schema ||'.S_DD_SEC_SEGMENTO_CARTERA... Secuencia creada OK');

DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
	RAISE;
END;
/
