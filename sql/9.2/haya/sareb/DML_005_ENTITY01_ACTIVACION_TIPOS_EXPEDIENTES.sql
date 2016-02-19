--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20160219
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-hy-rc01
--## INCIDENCIA_LINK=PRODUCTO-793
--## PRODUCTO=NO
--## Finalidad: Desactivar en Sareb los tipos de expedientes, Recuperación, Seguimiento y Recobro
--##			y Activar el tipo de expediente: Gestión de deuda
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
    
    V_NUM NUMBER; 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPX_TIPO_EXPEDIENTE SET BORRADO = 1 WHERE DD_TPX_CODIGO IN (''RECU'',''SEG'',''REC'')';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrados lógicos los tipos de expediente RECU, SEG, REC');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPX_TIPO_EXPEDIENTE SET BORRADO = 0 WHERE DD_TPX_CODIGO = ''GESDEU''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Activado lógico el tipo de expediente GESDECU');
	
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
