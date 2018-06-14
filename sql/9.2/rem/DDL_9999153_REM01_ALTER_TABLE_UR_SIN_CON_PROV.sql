--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180614
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-1040
--## PRODUCTO=NO
--## Finalidad: 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_COUNT	NUMBER(6);
    V_TABLA VARCHAR2(30 CHAR);
    V_CAMPO VARCHAR2(30 CHAR);
    ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

	--Tabla y campo a modificar
	V_TABLA := 'APR_AUX_I_UR_FACT_SIN_PROV';
	V_CAMPO := 'RETORNO_RECHAZO_CONTAX';
	
	DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas');

	-- Verificar si la tabla ya existe y está vacía
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
	IF V_COUNT = 1 THEN
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_TABLA||''' and COLUMN_NAME = '''||V_CAMPO||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		IF V_COUNT = 1 THEN
			V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA;
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||'
				MODIFY ('||V_CAMPO||' VARCHAR2 (3 CHAR))';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... alterada en el campo '||V_CAMPO);
		END IF;
	END IF;

	--Tabla y campo a modificar
	V_TABLA := 'APR_AUX_I_UR_FACT_SIN_PROV';
	V_CAMPO := 'RETORNO_UVEM';
	
	DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas');

	-- Verificar si la tabla ya existe y está vacía
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
	IF V_COUNT = 1 THEN
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_TABLA||''' and COLUMN_NAME = '''||V_CAMPO||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		IF V_COUNT = 1 THEN
			V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA;
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||'
				MODIFY ('||V_CAMPO||' VARCHAR2 (3 CHAR))';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... alterada en el campo '||V_CAMPO);
		END IF;
	END IF;

	--Tabla y campo a modificar
	V_TABLA := 'APR_AUX_I_UR_FACT_PROV';
	V_CAMPO := 'COD_TIPO_ERROR';
	
	DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas');

	-- Verificar si la tabla ya existe y está vacía
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
	IF V_COUNT = 1 THEN
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_TABLA||''' and COLUMN_NAME = '''||V_CAMPO||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		IF V_COUNT = 1 THEN
			V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA;
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||'
				MODIFY ('||V_CAMPO||' VARCHAR2 (2 CHAR))';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... alterada en el campo '||V_CAMPO);
		END IF;
	END IF;

EXCEPTION
	WHEN OTHERS THEN
		err_num := SQLCODE;
		err_msg := SQLERRM;
		DBMS_OUTPUT.PUT_LINE('KO no modificada');
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(err_msg);
		ROLLBACK;
		RAISE;          
END;
/
EXIT