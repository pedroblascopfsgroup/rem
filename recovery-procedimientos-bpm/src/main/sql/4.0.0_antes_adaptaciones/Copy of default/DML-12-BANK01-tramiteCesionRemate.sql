

	SET SERVEROUTPUT ON; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     

    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas

    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.

    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	BEGIN
	
	--Coger datos de subasta
update BANK01.TFI_TAREAS_FORM_ITEMS set TFI_VALOR_INICIAL='valores[''P401_PrepararCesionRemate''] == null ? '' : (valores[''P401_PrepararCesionRemate''][''instrucciones''])' where TFI_LABEL='Instrucciones' and tap_id=(SELECT tap_id FROM BANK01.tap_tarea_procedimiento WHERE tap_codigo = 'P410_AperturaPlazo');


update BANK01.dd_ptp_plazos_tareas_plazas set DD_PTP_PLAZO_SCRIPT='damePlazo(valoresBPMPadre[''P401_SenyalamientoSubasta''][''fechaSenyalamiento''])+5*24*60*60*1000L' where tap_id=(SELECT tap_id FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas WHERE tap_codigo='P410_AperturaPlazo');


update BANK01.dd_ptp_plazos_tareas_plazas set DD_PTP_PLAZO_SCRIPT='300*24*60*60*1000L' where tap_id=(SELECT tap_id FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas WHERE tap_codigo='P410_BPMTramiteAdjudicacion');

  
  
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