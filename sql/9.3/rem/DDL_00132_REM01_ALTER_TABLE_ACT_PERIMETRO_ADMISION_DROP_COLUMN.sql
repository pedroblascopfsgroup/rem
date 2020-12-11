--/*
--##########################################
--## AUTOR=Alberto Flores
--## FECHA_CREACION=20200717
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10633
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: Script para borrado de columnas de una tabla
--## VERSIONES:
--## 		0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 			-- Configuracion Esquemas
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_SQL VARCHAR2(4000 CHAR); 							-- Vble. para consulta que valida la existencia de una tabla.
	V_NUM_TABLAS NUMBER(16); 							-- Vble. para validar la existencia de una tabla.
	V_NUM_SEQ NUMBER(16); 								-- Vble. para validar la existencia de una secuencia.  
	ERR_NUM NUMBER(25); 								-- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); 						-- Vble. auxiliar para registrar errores en el script.
	V_USR VARCHAR2(30 CHAR) := 'HREOS-10633'; 			-- USUARIOCREAR/USUARIOMODIFICAR.
	V_TABLA VARCHAR2(2400 CHAR) := 'ACT_ACTIVO'; 		-- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	
	TYPE T_VAR IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_VAR IS TABLE OF T_VAR;
	V_VAR T_ARRAY_VAR := T_ARRAY_VAR(
		T_VAR('ACT_PERIMETRO_ADMISION')
	); 
	V_TMP T_VAR;
	
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] Borrado de campos en la tabla '''||V_TABLA||''':');
	
	FOR I IN V_VAR.FIRST .. V_VAR.LAST LOOP
		V_TMP := V_VAR(I);
		
		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_TMP(1)||''' AND OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		-- Si existe la columna se borra
		IF V_NUM_TABLAS > 0 THEN
			DBMS_OUTPUT.PUT_LINE('	[INFO] La columna '''||V_TMP(1)||''' existe. Se borrará.');
			
			-- Se borra la tabla
			EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' DROP COLUMN '||V_TMP(1)||'');
			
			DBMS_OUTPUT.PUT_LINE('	[INFO] Columna borrada.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('	[ERROR] La columna no existe. No se hace nada');
		END IF;
	END LOOP;
	
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
	
EXCEPTION
	WHEN OTHERS THEN
		ERR_NUM := SQLCODE;
		ERR_MSG := SQLERRM;
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(ERR_MSG);
		ROLLBACK;
		RAISE;   
END;
/
EXIT;
