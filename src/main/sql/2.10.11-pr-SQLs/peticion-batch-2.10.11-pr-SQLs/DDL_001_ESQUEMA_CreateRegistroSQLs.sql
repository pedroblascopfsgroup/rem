whenever sqlerror exit sql.sqlcode;

--/*
--##########################################
--## Author: #AUTOR#
--## Finalidad: Creación de tabla de registro de SQLs ejecutadas
--##########################################
--*/


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON; 

DECLARE
v_count number(3);
v_schema varchar(30) := '#ESQUEMA#';
v_constraint_count number(3);
v_sql varchar2(4000);

BEGIN

DBMS_OUTPUT.PUT_LINE('[START] Creación de la tabla RSR_REGISTRO_SQLS');

EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''RSR_REGISTRO_SQLS'' and owner = ''' || v_schema || '''' into v_count;

if v_count > 0 then
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema || '.RSR_REGISTRO_SQLS... Ya existe');
else 

EXECUTE IMMEDIATE 'CREATE TABLE '|| v_schema ||'.RSR_REGISTRO_SQLS
   (	
	RSR_ID NUMBER(16,0) NOT NULL PRIMARY KEY,
        RSR_NOMBRE_SCRIPT VARCHAR2(255 CHAR) NOT NULL,
	RSR_FECHACREACION VARCHAR2(20 CHAR) NOT NULL,
        RSR_ESQUEMA VARCHAR2(255 CHAR) NOT NULL,
	RSR_AUTOR VARCHAR2(100 CHAR),
	RSR_ARTEFACTO VARCHAR2(50 CHAR),
	RSR_VERSION_ARTEFACTO VARCHAR2(50 CHAR),
	RSR_INCIDENCIA_LINK VARCHAR2(255 CHAR),
	RSR_PRODUCTO VARCHAR2(2 CHAR),
        RSR_RESULTADO VARCHAR2(100 CHAR),
	RSR_INICIO TIMESTAMP,
        RSR_FIN TIMESTAMP,
	RSR_CONTENIDO_SQL BLOB,
        RSR_SALIDA_LOG VARCHAR2(4000 CHAR),
        RSR_ERROR_SQL VARCHAR2(255 CHAR))';

	DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| v_schema ||'.RSR_REGISTRO_SQLS... Tabla creada OK');

end if;

-- CREACION DE INDICES
SELECT COUNT(*) INTO v_count FROM ALL_INDEXES WHERE INDEX_NAME = 'IDX_RSR_REGISTRO_SQLS2' AND TABLE_OWNER=v_schema AND TABLE_NAME='RSR_REGISTRO_SQLS';    
IF v_count=0 THEN
    EXECUTE IMMEDIATE 'CREATE INDEX '|| v_schema ||'.IDX_RSR_REGISTRO_SQLS2 ON '|| v_schema ||'.RSR_REGISTRO_SQLS(RSR_NOMBRE_SCRIPT,RSR_FECHACREACION)';  
    DBMS_OUTPUT.PUT_LINE('CREATE INDEX '|| v_schema ||'.IDX_RSR_REGISTRO_SQLS2... Creado');
END IF;
  
SELECT COUNT(*) INTO v_count FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = 'S_RSR_REGISTRO_SQLS' AND SEQUENCE_OWNER=v_schema; 
   
IF v_count=0 THEN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE '|| v_schema ||'.S_RSR_REGISTRO_SQLS';  
    DBMS_OUTPUT.PUT_LINE('CREATE SEQUENCE '|| v_schema ||'.S_RSR_REGISTRO_SQLS... Creado');
END IF;

EXCEPTION
     WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(SQLERRM);
          
          ROLLBACK;
          RAISE;

END;
/

exit
