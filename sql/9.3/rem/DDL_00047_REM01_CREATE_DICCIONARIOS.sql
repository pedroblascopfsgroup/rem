--/*
--##########################################
--## AUTOR=Alberto Flores
--## FECHA_CREACION=20200617
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10390
--## PRODUCTO=NO
--##
--## Finalidad: Script que crea distintos diccionarios.
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
		T_VAR('DD_SNA_SI_NO_NA', 				'SNA'), 
		T_VAR('DD_SII_SIT_INI_INSCRIPCION', 	'SII'),
		T_VAR('DD_SPI_SIT_POSESORIA_INI', 		'SPI'),
		T_VAR('DD_SIC_SIT_INI_CARGAS', 			'SIC'),
		T_VAR('DD_TTI_TIPO_TITULARIDAD', 		'TTI'),
		T_VAR('DD_AUT_AUTORIZ_TRANSMISION', 	'AUT'),
		T_VAR('DD_ANC_ANOTACION_CONCURSO', 		'ANC'),
		T_VAR('DD_ESG_ESTADO_GESTION', 			'ESG'),
		T_VAR('DD_CFO_CERTIFICADO_FIN_OBRA', 	'CFO'),
		T_VAR('DD_AFO_ACTA_FIN_OBRA', 			'AFO'),
		T_VAR('DD_LPO_LIC_PRIMERA_OCUPACION', 	'LPO'),
		T_VAR('DD_BOL_BOLETINES', 				'BOL'),
		T_VAR('DD_SDC_SEGURO_DECENAL', 			'SDC'),
		T_VAR('DD_CEH_CEDULA_HABITABILIDAD', 	'CEH'),
		T_VAR('DD_TIA_TIPO_ARRENDAMIENTO', 		'TIA'),
		T_VAR('DD_TEA_TIPO_EXP_ADM', 			'TEA'),
		T_VAR('DD_TIR_TIPO_INCI_REGISTRAL', 	'TIR'),
		T_VAR('DD_TOL_TIPO_OCUPACION_LEGAL', 	'TOL'),
		T_VAR('DD_STA_SUBTIPOLOGIA_AGENDA', 	'STA')
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
			DD_'||V_TMP_VAR(2)||'_ID 					NUMBER(16,0) 			NOT NULL, 
			DD_'||V_TMP_VAR(2)||'_CODIGO 				VARCHAR2(20 CHAR) 		NOT NULL ENABLE, 
			DD_'||V_TMP_VAR(2)||'_DESCRIPCION 			VARCHAR2(100 CHAR),
			DD_'||V_TMP_VAR(2)||'_DESCRIPCION_LARGA 	VARCHAR2(250 CHAR),
			VERSION 									NUMBER(38,0) 			DEFAULT 0 NOT NULL ENABLE, 
			USUARIOCREAR 								VARCHAR2(50 CHAR) 		NOT NULL ENABLE, 
			FECHACREAR 									TIMESTAMP (6) 			NOT NULL ENABLE, 
			USUARIOMODIFICAR 							VARCHAR2(50 CHAR), 
			FECHAMODIFICAR 								TIMESTAMP (6), 
			USUARIOBORRAR 								VARCHAR2(50 CHAR), 
			FECHABORRAR 								TIMESTAMP (6), 
			BORRADO 									NUMBER(1,0) 			DEFAULT 0 NOT NULL ENABLE
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
		V_SQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TMP_VAR(1)||'_PK ON '||V_ESQUEMA||'.'||V_TMP_VAR(1)||'(DD_'||V_TMP_VAR(2)||'_ID) TABLESPACE '||V_TABLESPACE_IDX;
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('	[INFO] ' ||V_ESQUEMA||'.'||V_TMP_VAR(1)||'_PK... Indice creado.');
		
		-- Creamos primary key
		V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_VAR(1)||' ADD (CONSTRAINT '||V_TMP_VAR(1)||'_PK PRIMARY KEY (DD_'||V_TMP_VAR(2)||'_ID) USING INDEX)';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('	[INFO] ' ||V_ESQUEMA||'.'||V_TMP_VAR(1)||'_PK... PK creada.');
	
		-- Creamos secuencia
		V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TMP_VAR(1)||'';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('	[INFO] '||V_ESQUEMA||'.S_'||V_TMP_VAR(1)||'... Secuencia creada');
	END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]: Tablas creadas correctamente.');


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
