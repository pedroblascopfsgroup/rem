--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20160202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc37
--## INCIDENCIA_LINK=CMREC-1842
--## PRODUCTO=NO
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
	
	DBMS_OUTPUT.PUT_LINE('******** TER_TAREA_EXTERNA_RECUPERACION ********'); 
	
	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TER_TAREA_EXTERNA_RECUPERACION WHERE TEX_ID IN (SELECT TEX_ID FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA WHERE TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_VisarLiq''))';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro eliminado en '||V_ESQUEMA||'.TER_TAREA_EXTERNA_RECUPERACION');

  	DBMS_OUTPUT.PUT_LINE('******** TEV_TAREA_EXTERNA_VALOR ********'); 
	
	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR WHERE TEX_ID IN (SELECT TEX_ID FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA WHERE TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_VisarLiq''))';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro eliminado en '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR');
  
	DBMS_OUTPUT.PUT_LINE('******** TEX_TAREA_EXTERNA ********'); 
	
	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES WHERE TAR_TAREA = ''Visar factura'')';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro eliminado en '||V_ESQUEMA||'.TEX_TAREA_EXTERNA');
  
	DBMS_OUTPUT.PUT_LINE('******** TAR_TAREAS_NOTIFICACIONES ********'); 
	
	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES WHERE TAR_TAREA = ''Visar factura''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro eliminado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
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
