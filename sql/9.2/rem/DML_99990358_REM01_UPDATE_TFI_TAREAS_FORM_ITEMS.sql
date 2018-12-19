--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20180906
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4445
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el trámite T015 comercial de alquiler
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
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := 'HREOS-4445'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    
BEGIN

    DBMS_OUTPUT.PUT_LINE('COMENZANDO EL PROCESO DE ACTUALIZACIÓN TABLA ''TFI_TAREAS_FORM_ITEMS''');
    
    
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	SET TFI_TIPO = ''combo'',TFI_BUSINESS_OPERATION = ''DDMotivoAnulacionExpediente'', USUARIOMODIFICAR = '''||V_USU_MODIFICAR||''', FECHAMODIFICAR = SYSDATE
		   WHERE TAP_ID IN (SELECT TAP.TAP_ID FROM TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T015_ElevarASancion'') 
			AND TFI_NOMBRE = ''motivoAnulacion''';
			
	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	SET TFI_TIPO = ''combo'',	TFI_BUSINESS_OPERATION = ''DDMotivoAnulacionExpediente'', USUARIOMODIFICAR = '''||V_USU_MODIFICAR||''', FECHAMODIFICAR = SYSDATE            
            WHERE TAP_ID = (SELECT TAP.TAP_ID FROM TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T015_ResolucionExpediente'') 
			AND TFI_NOMBRE = ''motivo''';
			
	EXECUTE IMMEDIATE V_MSQL;
            
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	SET TFI_TIPO = ''combo'',	TFI_BUSINESS_OPERATION = ''DDMotivoAnulacionExpediente'', USUARIOMODIFICAR = '''||V_USU_MODIFICAR||''', FECHAMODIFICAR = SYSDATE
            WHERE TAP_ID = (SELECT TAP.TAP_ID FROM TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T015_AceptacionCliente'') 
			AND TFI_NOMBRE = ''motivoAC''';
			
	EXECUTE IMMEDIATE V_MSQL;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ''TFI_TAREAS_FORM_ITEMS'' ACTUALIZADA CORRECTAMENTE ');


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