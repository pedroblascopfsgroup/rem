/*
--######################################################################
--## Author: Nacho
--## BPM: H023 Trámite Demandada Incidental - modificación del BPM
--## Finalidad: Modificación del BPM
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	

	V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_VIEW = ''plugin/procedimientos-bpmHaya/tramiteDemandaIncidental/confirmarOposicion'' '
 				|| ' WHERE TAP_CODIGO = ''H023_confirmarOposicion''';	
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    COMMIT;
    
     V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_VIEW = ''plugin/procedimientos-bpmHaya/tramiteDemandaIncidental/admisionOposicionSenyalamientoVista'' '
 				|| ' WHERE TAP_CODIGO = ''H023_admisionOposicionYSenalamientoVista''';	
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    COMMIT;
    
    V_MSQL := 'UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS '
				|| ' SET DD_PTP_PLAZO_SCRIPT = ''valoresBPMPadre[''''H009_RegistrarInformeAdmonConcursal''''] != null ? damePlazo(valoresBPMPadre[''''H009_RegistrarInformeAdmonConcursal''''][''''fecha'''']) + 10*24*60*60*1000L : (valoresBPMPadre[''''H035_registrarOposicion''''] != null ? damePlazo(valoresBPMPadre[''''H035_registrarOposicion''''][''''fecha'''']) + 10*24*60*60*1000L : (valoresBPMPadre[''''H027_RegistrarResHomologacionJudicial''''] != null ? damePlazo(valoresBPMPadre[''''H027_RegistrarResHomologacionJudicial''''][''''fecha'''']) + 10*24*60*60*1000L : 10*24*60*60*1000L))'' '
 				|| ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H023_interposicionDemanda'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
     V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = null, '
				|| ' TFI_VALIDACION = null '
 				|| ' WHERE TFI_NOMBRE = ''procedimiento'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H023_confirmarAdmisionDemanda'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = null, '
				|| ' TFI_VALIDACION = null '
 				|| ' WHERE TFI_NOMBRE = ''comboVista'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H023_confirmarOposicion'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = null, '
				|| ' TFI_VALIDACION = null '
 				|| ' WHERE TFI_NOMBRE = ''comboVista'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H023_admisionOposicionYSenalamientoVista'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
 
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