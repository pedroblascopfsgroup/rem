--/*
--##########################################
--## Author: AIA
--## Finalidad: DDL UNDER_4
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-616 (Moratoria)');
execute immediate 'update '||V_ESQUEMA||'.tfi_Tareas_form_items tfi set tfi.TFI_VALIDACION= null, tfi.TFI_ERROR_VALIDACION=null where tfi_nombre=''fechaFinMoratoria'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_Tarea_procedimiento where tap_codigo = ''P418_RegistrarResolucion'') ' ;
execute immediate 'update '||V_ESQUEMA||'.tap_Tarea_procedimiento tap set tap.TAP_SCRIPT_VALIDACION_JBPM = ''(valores[''''P418_RegistrarResolucion''''][''''comboFavDesf''''] == ''''02'''' && valores[''''P418_RegistrarResolucion''''][''''fechaFinMoratoria''''] == null) ? ''''La fecha fin de moratoria es obligatoria'''' : null'' where tap_codigo = ''P418_RegistrarResolucion'' ' ;

DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-617 (Ocupantes)');
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas ptp set dd_ptp_plazo_script = ''valores[''''P419_ConfirmarVista''''] == null ? 20*24*60*60*1000L : (damePlazo(valores[''''P419_ConfirmarVista''''][''''fechaVista''''])+20*24*60*60*1000L)'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P419_RegistrarResolucion'') ' ;

DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-618 (Moratoria)');
execute immediate 'update '||V_ESQUEMA||'.tfi_Tareas_form_items set tfi_valor_inicial = ''valores[''''P418_RegistrarInformeMoratoria''''] == null ? '''''''' : (valores[''''P418_RegistrarInformeMoratoria''''][''''informeMoratoria''''])'' where tfi_nombre =''informeMoratoria'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P418_RevisarInformeLetradoMoratoria'') ' ;
execute immediate 'update '||V_ESQUEMA||'.tfi_Tareas_form_items set tfi_valor_inicial = ''valores[''''P418_RevisarInformeLetradoMoratoria''''] == null ? '''''''' : (valores[''''P418_RevisarInformeLetradoMoratoria''''][''''instruccionesMoratoria''''])'' where tfi_nombre =''instruccionesMoratoria'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P418_LecturaInstruccionesMoratoria'') ' ;

DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-619 (Posesion)');
execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas ptp set dd_ptp_plazo_script = ''((valores[''''P416_RegistrarLanzamientoEfectuado''''] != null) && (valores[''''P416_RegistrarLanzamientoEfectuado''''][''''fecha''''] != null)) ? damePlazo(valores[''''P416_RegistrarLanzamientoEfectuado''''][''''fecha'''']) + 24*24*60*60*1000L : (valores[''''P416_RegistrarPosesionYLanzamiento''''][''''fecha''''] == null ? 24*24*60*60*1000L : damePlazo(valores[''''P416_RegistrarPosesionYLanzamiento''''][''''fecha'''']) + 24*24*60*60*1000L) '' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P416_RegistrarDecisionLlaves'') ' ;


DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-620 (Subasta Bankia - nueva funcionalidad)');
  BEGIN
    V_SQL := ' SELECT COUNT(1) from '||V_ESQUEMA||'.DD_EAD_ENTIDAD_ADJUDICA WHERE  DD_EAD_ID =  4 ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := ' Insert into DD_EAD_ENTIDAD_ADJUDICA
      (DD_EAD_ID, DD_EAD_CODIGO, DD_EAD_DESCRIPCION, DD_EAD_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
      Values
      (4, ''TER'', ''TERCEROS'', ''TERCEROS'', 
      0, ''DD'', sysdate, NULL, NULL, 
      NULL, NULL, 0) ' ;
      EXECUTE IMMEDIATE V_SQL ;      
    END IF ;
  END ;    

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_alert_vuelta_atras = null where tap_codigo = ''P409_SolicitarMtoPago'' ' ;
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_alert_vuelta_atras = null where tap_codigo = ''P401_SolicitarMtoPago'' ' ;
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_decision = ''decidirRegistrarActaSubasta()'' where tap_codigo = ''P401_RegistrarActaSubasta'' ' ;
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_decision = ''decidirRegistrarActaSubasta()'' where tap_codigo = ''P409_RegistrarActaSubasta'' ' ;

DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-621 (Subasta)');

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_label  =''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; acceder a la pesta&ntilde;a Subastas del asunto correspondiente y asociar uno o m&aacute;s bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta deber&aacute; indicar a trav&eacute;s de la ficha de cada bien las cargas anteriores y posteriores, si es vivienda habitual o no, la situaci&oacute;n posesoria y el tipo de subasta.</p><p style="margin-bottom: 10px">En el campo Fecha solicitud deber&aacute; consignar la fecha en la que haya realizado la solicitud de subasta.En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.Una vez rellene esta pantalla se lanzar&aacute; la tarea &quot;Se&ntilde;alamiento de subasta&quot; a realizar por el letrado.</p></div>'' where tfi_tipo = ''label'' and tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = ''P401_SolicitudSubasta'') ' ;

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_label  =''<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea, deberá acceder a la pestaña Subastas del asunto correspondiente y asociar uno o más bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta deberá indicar a través de la ficha de cada bien las cargas anteriores y posteriores, si es vivienda habitual o no, la situación posesoria y el tipo de subasta.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha solicitud deberá consignar la fecha en la que haya realizado la solicitud de subasta.En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.Una vez rellene esta pantalla se lanzará la tarea "Señalamiento de subasta" a realizar por el letrado.</p></div>'' where tfi_tipo = ''label'' and tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = ''P409_SolicitudSubasta'') ' ;

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''comprobarMinimoBienLote() ? (comprobarBienInformado() ? null : ''''Los bienes con lote deben tener informado las cargas anteriores y posteriores, si es vivienda habitual o no, la situación posesoria y el tipo de subasta'''') : ''''Al menos un bien debe estar asignado a un lote'''''' where tap_codigo in (''P401_SolicitudSubasta'',''P409_SolicitudSubasta'') ' ;

execute immediate 'update '||V_ESQUEMA||'.tap_Tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoESRAS() ? null : ''''Es necesario adjuntar el documento Edicto de subasta y resolución acordando señalamiento'''''' where tap_codigo =''P409_SenyalamientoSubasta'' ' ;

execute immediate 'update '||V_ESQUEMA||'.tap_Tarea_procedimiento set tap_script_validacion = ''comprobarExisteDocumentoACS() ? null : ''''Es necesario adjuntar el documento Acta de subasta'''''' where tap_codigo =''P409_RegistrarActaSubasta'' ' ;

COMMIT;


EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;

END;

/

EXIT
    