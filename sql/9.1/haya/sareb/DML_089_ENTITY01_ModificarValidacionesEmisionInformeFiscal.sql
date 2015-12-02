--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20151029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.10-hy-rc01
--## INCIDENCIA_LINK=HR-1428
--## PRODUCTO=NO
--##
--## Finalidad: Modificación de las validaciones de la emisión del informe fiscal
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_VIEW = ''plugin/procedimientos-bpmHaya-plugin/tramiteTributacionSareb/emisionInformeFiscal'' WHERE TAP_CODIGO = ''H054_EmisionInformeFiscal''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] TAP_TAREA_PROCEDIMIENTO H054_EmisionInformeFiscal actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ERROR_VALIDACION = NULL' ||
			  ', TFI_VALIDACION = NULL' ||
			  ' WHERE TFI_NOMBRE = ''comboModelo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H054_EmisionInformeFiscal'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] TFI_TAREAS_FORM_ITEMS H054_EmisionInformeFiscal - comboModelo actualizado.');
    

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] Actualización validaciones emisión informe fiscal.');

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