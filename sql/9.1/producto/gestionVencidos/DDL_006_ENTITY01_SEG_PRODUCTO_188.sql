--/*
--##########################################
--## AUTOR=ALBERTO_RAMIREZ
--## FECHA_CREACION=20150824
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-188
--## PRODUCTO=SI
--##
--## Finalidad: Crear tabla que relaciona tipo de regla y ámbito 'REA_REGLA_AMBITO'
--## INSTRUCCIONES: Relanzable.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################

whenever sqlerror exit sql.sqlcode;


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON; 

DECLARE
v_seq_count number(3);
v_table_count number(3);
v_schema   VARCHAR(25) := '#ESQUEMA#';
v_schema_MASTER VARCHAR(25) := '#ESQUEMA_MASTER#';
v_constraint_count number(3);
v_sql varchar2(4000);
v_nombre_tabla VARCHAR(25):= 'REA_REGLA_AMBITO';

BEGIN

DBMS_OUTPUT.PUT_LINE('[START]: Crear tabla '||v_nombre_tabla);

/**
 *CREATE TABLE REA_REGLA_AMBITO
 */

DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobaciones previas CREATE TABLE '||v_nombre_tabla);
v_sql := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||v_nombre_tabla||''' and owner = '''||v_schema||'''';
EXECUTE IMMEDIATE v_sql INTO v_table_count;

IF v_table_count > 0 THEN 
	DBMS_OUTPUT.PUT_LINE('[INFO]: Tabla '||v_schema||'.'||v_nombre_tabla||' ya existe.');  
ELSE
   --Crear tabla
   	v_sql := 'CREATE TABLE '||v_schema||'.'||v_nombre_tabla||'
	               ( REA_ID  NUMBER(16) NOT NULL
	               , DD_TRE_ID  NUMBER(16) NOT NULL
	               , DD_AEX_ID  NUMBER(16) NOT NULL
				   , CONSTRAINT PK_REA_REGLA_AMBITO PRIMARY KEY (REA_ID))';
	EXECUTE IMMEDIATE v_sql;
	DBMS_OUTPUT.PUT_LINE('[INFO]: Tabla '||v_schema||'.'||v_nombre_tabla||' creada correctamente.'); 
END IF; 

/**
 *CREATE SECUENCIA
 */

DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobaciones previas sequencia S_REA_REGLA_AMBITO.');
v_sql := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_REA_REGLA_AMBITO'' AND SEQUENCE_OWNER = '''||v_schema||'''';
EXECUTE IMMEDIATE v_sql INTO v_table_count;

IF v_table_count > 0 THEN 
	DBMS_OUTPUT.PUT_LINE('[INFO]: S_REA_REGLA_AMBITO ya existe.');  
ELSE
   -- Crear sequencia
   	v_sql := 'CREATE SEQUENCE ' || v_schema ||'.S_REA_REGLA_AMBITO';
	EXECUTE IMMEDIATE v_sql;
	DBMS_OUTPUT.PUT_LINE('[INFO]: Sequencia S_REA_REGLA_AMBITO creada correctamente.'); 
END IF;

/**
 *CREATE FK_REA_TRE
 */

DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobaciones previas FK_REA_TRE.');
v_sql := 'select count(*)
					from(
					SELECT consa.constraint_name,  consa.status, consa.owner
					                    FROM all_constraints consa
					                    WHERE consa.TABLE_NAME = '''||v_nombre_tabla||'''
					                    AND consa.constraint_type = ''R''
					                    AND consa.owner = '''||v_schema||'''  
					                    AND consa.constraint_name = ''FK_REA_TRE'')';
EXECUTE IMMEDIATE v_sql INTO v_table_count;

IF v_table_count > 0 THEN 
	DBMS_OUTPUT.PUT_LINE('[INFO]: FK_REA_TRE ya existe.');  
ELSE
   --Crear FK
   v_sql := 'ALTER TABLE '|| v_schema ||'.'||v_nombre_tabla||'  
						   ADD CONSTRAINT FK_REA_TRE 
								FOREIGN KEY (DD_TRE_ID)
								REFERENCES '|| v_schema_MASTER ||'.DD_TRE_TIPO_REGLAS_ELEVACION (DD_TRE_ID)';
	EXECUTE IMMEDIATE v_sql;
	DBMS_OUTPUT.PUT_LINE('[INFO]: FK_REA_TRE creada correctamente.'); 
END IF; 

/**
 *CREATE FK_REA_AEX
 */

DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobaciones previas FK_REA_AEX.');
v_sql := 'select count(*)
					from(
					SELECT consa.constraint_name,  consa.status, consa.owner
					                    FROM all_constraints consa
					                    WHERE consa.TABLE_NAME = '''||v_nombre_tabla||'''
					                    AND consa.constraint_type = ''R''
					                    AND consa.owner = '''||v_schema||'''  
					                    AND consa.constraint_name = ''FK_REA_AEX'')';
EXECUTE IMMEDIATE v_sql INTO v_table_count;

IF v_table_count > 0 THEN 
	DBMS_OUTPUT.PUT_LINE('[INFO]: FK_REA_AEX ya existe.');  
ELSE
   --Crear FK
   v_sql := 'ALTER TABLE '|| v_schema ||'.'||v_nombre_tabla||'  
						   ADD CONSTRAINT FK_REA_AEX 
								FOREIGN KEY (DD_AEX_ID)
								REFERENCES '|| v_schema_MASTER ||'.DD_AEX_AMBITOS_EXPEDIENTE (DD_AEX_ID)';
	EXECUTE IMMEDIATE v_sql;
	DBMS_OUTPUT.PUT_LINE('[INFO]: FK_REA_AEX creada correctamente.'); 
END IF; 

DBMS_OUTPUT.PUT_LINE('[FIN]: Script ejecutado correctamente');	

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Código de error obtenido:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
          


END;
/

EXIT