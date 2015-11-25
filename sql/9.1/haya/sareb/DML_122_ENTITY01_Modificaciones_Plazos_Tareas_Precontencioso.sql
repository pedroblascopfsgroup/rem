--/*
--##########################################
--## AUTOR=Alberto Soler
--## FECHA_CREACION=20151123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-345 Todas las incidencias y mejoras del precontencioso PRODUCTO
--## PRODUCTO=NO
--## Finalidad: Resolución incidencias
--## INSTRUCCIONES
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK PRODUCTO-377');
	V_TAREA:='PCO_GenerarLiq';
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar tarea PCO_GenerarLiq');
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET ' ||
	  ' DD_PTP_PLAZO_SCRIPT=''2*24*60*60*1000L'' ' ||
	  ' WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] Actualizar tarea PCO_GenerarLiq');

	V_TAREA:='PCO_AcuseReciboBurofax';
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar tarea PCO_AcuseReciboBurofax');
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET ' ||
	  ' DD_PTP_PLAZO_SCRIPT=''10*24*60*60*1000L'' ' ||
	  ' WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] Actualizar tarea PCO_AcuseReciboBurofax');

	V_TAREA:='PCO_RegistrarAceptacion';
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar tarea PCO_RegistrarAceptacion');
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET ' ||
	  ' DD_PTP_PLAZO_SCRIPT=''5*24*60*60*1000L'' ' ||
	  ' WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] Actualizar tarea PCO_RegistrarAceptacion');

	V_TAREA:='PCO_RegistrarAceptacionPost';
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar tarea PCO_RegistrarAceptacionPost');
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET ' ||
	  ' DD_PTP_PLAZO_SCRIPT=''5*24*60*60*1000L'' ' ||
	  ' WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] Actualizar tarea PCO_RegistrarAceptacionPost');

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK PRODUCTO-377');


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