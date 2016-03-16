--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20160311
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2052
--## PRODUCTO=SI
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_EXISTE NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** DD_IMV_IMPOSICION_VENTA ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_IMV_IMPOSICION_VENTA... Comprobaciones previas TAP_TAREA_PROCEDIMIENTO'); 

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.DD_IMV_IMPOSICION_VENTA WHERE BORRADO != 0';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_IMV_IMPOSICION_VENTA SET BORRADO = 0, USUARIOMODIFICAR=''HR-2052'', FECHAMODIFICAR=sysdate WHERE BORRADO != 0';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA_M||'.DD_IMV_IMPOSICION_VENTA');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] No hay registros que cumplan la condicion en  '||V_ESQUEMA_M||'.DD_IMV_IMPOSICION_VENTA.');
	END IF;
	
    COMMIT;
	
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
