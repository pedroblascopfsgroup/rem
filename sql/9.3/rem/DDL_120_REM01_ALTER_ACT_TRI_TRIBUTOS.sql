--/*
--#########################################
--## AUTOR=KEVIN HONORATO
--## FECHA_CREACION=20201119
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-12216
--## PRODUCTO=NO
--##
--## Finalidad: - Creación columna auxiliar para la inserción de datos.
--##            - Vaciar el campo para su modificación.
--##            - Guardar los datos en la columna auxiliar.
--## 			- Modificar el campo.
--##            - Devolver datos al campo modificado.
--##            - Borrar columna auxiliar.
--##
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial HREOS-11024
--##        0.2 Add columnas BBVA_COD_INMUEBLE, BBVA_BIEN_HOST, BBVA_BIEN_PRAR HREOS-11875
--##        0.2 Modify columnas BBVA_ID_PROCESO_ORIGEN and BBVA_CDPEN HREOS-12216
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

V_MSQL VARCHAR2(32000 CHAR);
V_ESQUEMA VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_ESQUEMA_M VARCHAR2(20 CHAR) := '#ESQUEMA_MASTER#';       
V_TABLA VARCHAR2(40 CHAR) := 'ACT_TRI_TRIBUTOS';
V_COLUMN_NAME VARCHAR2(50):= 'NUM_EXPEDIENTE';
V_COLUMN_NAME_AUX VARCHAR2(50):= 'AUX_NUM_EXPEDIENTE'; 
V_COMMENT_COLUMN VARCHAR2(500 CHAR):= 'Numero de expediente'; 
V_COMMENT_COLUMN_AUX VARCHAR2(500 CHAR):= 'Columna auxiliar NUM_EXPEDIENTE'; 

BEGIN

-- Comprobar si existe la columna NUM_EXPEDIENTE.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME||''' AND DATA_TYPE != ''VARCHAR2'' AND TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN

		-- Creación columna auxiliar

		 	DBMS_OUTPUT.PUT_LINE('[INICIO] ADD COLUMN AUX_NUM_EXPEDIENTE');

		    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_COLUMN_NAME_AUX||' VARCHAR2(20 CHAR)';    

		    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COLUMN_NAME_AUX||' IS '''||V_COMMENT_COLUMN_AUX||'''';	
		    DBMS_OUTPUT.PUT_LINE('[INFO] COLUMNA '||V_COLUMN_NAME_AUX||' AÑADIDA');

		-- Guardar los datos en la columna auxiliar

			EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET '||V_COLUMN_NAME_AUX||' = '||V_COLUMN_NAME||'';
			DBMS_OUTPUT.PUT_LINE('  [INFO] GUARDADAS '||SQL%ROWCOUNT||' FILAS EN '||V_COLUMN_NAME_AUX||''); 

		-- Vaciar el campo para su modificación

			EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET '||V_COLUMN_NAME||' = NULL';
			DBMS_OUTPUT.PUT_LINE('[INFO] COLUMNA '||V_COLUMN_NAME_AUX||' VACIA');

		-- Modificar el campo

			EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' MODIFY ('||V_COLUMN_NAME||' VARCHAR2(20 CHAR))';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COLUMN_NAME||' IS '''||V_COMMENT_COLUMN||'''';
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COLUMN_NAME||'... MODIFICADA');

		-- Devolver datos al campo modificado

			EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET '||V_COLUMN_NAME||' = '||V_COLUMN_NAME_AUX||'';
			DBMS_OUTPUT.PUT_LINE('[INFO] GUARDADAS '||SQL%ROWCOUNT||' FILAS EN '||V_COLUMN_NAME||''); 

		-- Borrar columna auxiliar

			EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' DROP COLUMN '||V_COLUMN_NAME_AUX||')'; --##        0.2 Add columnas BBVA_COD_INMUEBLE, BBVA_BIEN_HOST, BBVA_BIEN_PRAR HREOS-11875
			DBMS_OUTPUT.PUT_LINE('[INFO] COLUMNA '||V_COLUMN_NAME_AUX||' BORRADA');
	END IF;

	COMMIT;

EXCEPTION
    WHEN OTHERS THEN
	DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
	DBMS_OUTPUT.put_line('-----------------------------------------------------------');
	DBMS_OUTPUT.put_line(SQLERRM);
	ROLLBACK;
	RAISE;
END;
/
EXIT;