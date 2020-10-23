--/*
--##########################################
--## AUTOR=Alberto Flores
--## FECHA_CREACION=20200616
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10390
--## PRODUCTO=NO
--##
--## Finalidad: Script que crea la tabla ACT_ART_AGENDA_REV_TITULO.
--## INSTRUCCIONES:
--## VERSIONES:
--## 		0.1 Versión inicial
--##########################################
--*/

ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
	V_NUM NUMBER(16); 
	
	V_USU VARCHAR2(30 CHAR) := 'HREOS-10390'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

	TYPE T_VAR IS TABLE OF VARCHAR2(100);
	TYPE T_ARRAY_VAR IS TABLE OF T_VAR;
	V_VAR T_ARRAY_VAR := T_ARRAY_VAR(
	-- 			TABLA 							TAG 
		T_VAR('ACT_ART_AGENDA_REV_TITULO', 	'ART')
	); 
	V_TMP_VAR T_VAR;
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	FOR I IN V_VAR.FIRST .. V_VAR.LAST LOOP
		V_TMP_VAR := V_VAR(I);
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] Verificando si la tabla '''||V_TMP_VAR(1)||''' existe...');
		V_SQL := 'SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TMP_VAR(1)||''' AND OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	
		IF V_NUM = 1 THEN
			DBMS_OUTPUT.PUT_LINE('	[INFO] ' || V_ESQUEMA || '.'||V_TMP_VAR(1)||'... Ya existe. Se borrará.');
			EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TMP_VAR(1)||' CASCADE CONSTRAINTS';
		END IF;
		
		-- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TMP_VAR(1)||''' AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM; 
		IF V_NUM = 1 THEN
			DBMS_OUTPUT.PUT_LINE('	[INFO] '|| V_ESQUEMA ||'.S_'||V_TMP_VAR(1)||'... Ya existe. Se borrará.');  
			EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TMP_VAR(1)||'';
		END IF; 
	
		-- Creamos la tabla
		DBMS_OUTPUT.PUT_LINE('	[INFO] Creando tabla '||V_ESQUEMA||'.'||V_TMP_VAR(1)||'...');
		V_SQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TMP_VAR(1)||' (
			'||V_TMP_VAR(2)||'_ID 				NUMBER(16,0) 			NOT NULL, 
			DD_STA_ID 							NUMBER(16,0) 			NOT NULL ENABLE, 
			'||V_TMP_VAR(2)||'_OBSERVACIONES 	CLOB,
			VERSION 							NUMBER(38,0) 			DEFAULT 0 NOT NULL ENABLE, 
			USUARIOCREAR 						VARCHAR2(50 CHAR) 		NOT NULL ENABLE, 
			FECHACREAR 							TIMESTAMP (6) 			NOT NULL ENABLE, 
			USUARIOMODIFICAR 					VARCHAR2(50 CHAR), 
			FECHAMODIFICAR 						TIMESTAMP (6), 
			USUARIOBORRAR 						VARCHAR2(50 CHAR), 
			FECHABORRAR 						TIMESTAMP (6), 
			BORRADO 							NUMBER(1,0) 			DEFAULT 0 NOT NULL ENABLE
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING
		';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('	[INFO] ' ||V_ESQUEMA||'.'||V_TMP_VAR(1)||'... Tabla creada.');
		
		-- Creamos índice
		V_SQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TMP_VAR(1)||'_PK ON '||V_ESQUEMA||'.'||V_TMP_VAR(1)||'('||V_TMP_VAR(2)||'_ID) TABLESPACE '||V_TABLESPACE_IDX;
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('	[INFO] ' ||V_ESQUEMA||'.'||V_TMP_VAR(1)||'_PK... Indice creado.');
		
		-- Creamos primary key
		V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_VAR(1)||' ADD (CONSTRAINT '||V_TMP_VAR(1)||'_PK PRIMARY KEY ('||V_TMP_VAR(2)||'_ID) USING INDEX)';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('	[INFO] ' ||V_ESQUEMA||'.'||V_TMP_VAR(1)||'_PK... PK creada.');
	
		-- Creamos secuencia
		V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TMP_VAR(1)||'';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('	[INFO] '||V_ESQUEMA||'.S_'||V_TMP_VAR(1)||'... Secuencia creada');
		
		-- Creamos FK's
		EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TMP_VAR(1)||''' AND CONSTRAINT_NAME = ''DD_STA_ID_FK''' INTO V_NUM;
		IF V_NUM = 0 THEN
			V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_VAR(1)||' ADD (CONSTRAINT DD_STA_ID_FK FOREIGN KEY (DD_STA_ID) REFERENCES '||V_ESQUEMA||'.DD_STA_SUBTIPOLOGIA_AGENDA(DD_STA_ID))';
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('	[INFO] Foreign key ''DD_STA_ID_FK'' creada');
		ELSE
			DBMS_OUTPUT.PUT_LINE('	[ERROR] Ya existe la foreign key ''DD_STA_ID_FK''.');
		END IF;
	
		-- Creamos comentarios
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TMP_VAR(1)||'.'||V_TMP_VAR(2)||'_ID 				IS ''ID de la tabla.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TMP_VAR(1)||'.DD_STA_ID 							IS ''FK del diccionario DD_STA_SUBTIPOLOGIA_AGENDA.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TMP_VAR(1)||'.'||V_TMP_VAR(2)||'_OBSERVACIONES 	IS ''Observaciones.''';
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] ' ||V_ESQUEMA||'.'||V_TMP_VAR(1)||'... Comentarios creados.');

	END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla creada correctamente.');


EXCEPTION
	WHEN OTHERS THEN
		err_num := SQLCODE;
		err_msg := SQLERRM;
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(err_msg);
		ROLLBACK;
		RAISE;          

END;
/
EXIT
