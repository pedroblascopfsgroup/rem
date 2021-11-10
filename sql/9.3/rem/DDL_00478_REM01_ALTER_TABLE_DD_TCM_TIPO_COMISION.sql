--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20210903
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15076
--## PRODUCTO=NO
--## Finalidad: Alter table GPV_GASTOS_PROVEEDOR
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(2400 CHAR) := 'GPV_GASTOS_PROVEEDOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Modificando el tamaño de la columna GPV_NUM_CONTR_ALQUILER de la tabla GPV_GASTOS_PROVEEDOR');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' MODIFY GPV_NUM_CONTR_ALQUILER VARCHAR2(15 CHAR)';
		EXECUTE IMMEDIATE V_MSQL;
		
	END IF;

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN]');
	
EXCEPTION


	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;
END;
/


EXIT;