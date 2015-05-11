--/*
--##########################################
--## Author: AIA
--## Finalidad: DDL UNDER_3
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

DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_605');  
  BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_605_1');  
    V_SQL := ' SELECT COUNT(1) from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE  DD_TPO_ID = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where
    dd_tpo_codigo = ''P401'') and TAP_CODIGO=''P401_BPMTramiteAdjudicacionV4''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := ' Insert into '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
        (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_VALIDACION_JBPM, TAP_SCRIPT_DECISION, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION,          
        USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, TAP_ALERT_NO_RETORNO, TAP_ALERT_VUELTA_ATRAS, DD_FAP_ID, TAP_AUTOPRORROGA,     
        DTYPE,     TAP_MAX_AUTOP, DD_TGE_ID, DD_STA_ID, TAP_EVITAR_REORG, DD_TSUP_ID, TAP_BUCLE_BPM)
         values (S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P401''), ''P401_BPMTramiteAdjudicacionV4'', NULL, 
         NULL, NULL, NULL, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P413''), 0, 
         ''Se inicia trámite de adjudicación por cada bien'', 0, ''DML'', sysdate, NULL, 
         NULL, NULL, NULL, 0, NULL, 
         ''tareaExterna.cancelarTarea'', NULL, 1, ''EXTTareaProcedimiento'', 3, 
         NULL, NULL, NULL, NULL, NULL); ' ;
      EXECUTE IMMEDIATE V_SQL ;      
    END IF ;
  END ;
    
  BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_605_2');  
    V_SQL := ' SELECT COUNT(1) from '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE  TAP_ID = (SELECT TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO  
             =''P401_BPMTramiteAdjudicacionV4'') ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := ' Insert into  '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS
       (DD_PTP_ID, DD_JUZ_ID, DD_PLA_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
      Values
       (S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, NULL, NULL, (SELECT TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P401_BPMTramiteAdjudicacionV4''), 
        ''300*24*60*60*1000L'', 0, ''DD'', sysdate, NULL, NULL, NULL, NULL, 0) ' ;
      EXECUTE IMMEDIATE V_SQL ;      
    END IF ;  
  END ;
    
  BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_605_3');  
    V_SQL := ' SELECT COUNT(1) from '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = ( SELECT TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO =
            ''P401_BPMTramiteAdjudicacionV4'')  AND TFI_ORDEN =  0 ' ;
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := ' Insert into  '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
        (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR,         
        FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
     Values
       (S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, (SELECT TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P401_BPMTramiteAdjudicacionV4''), 0, ''label'', 
        ''titulo'', ''<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se inicia el trámite de adjudicación.</p></div>'', NULL, NULL, NULL, 
        NULL, 0, ''DD'', sysdate, NULL, 
        NULL, NULL, NULL, 0) ' ;
      EXECUTE IMMEDIATE V_SQL ;      
    END IF ;    
  END ;  
    
DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_606');          
    
    execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script =''damePlazo(valores[''''P409_SenyalamientoSubasta''''][''''fechaSenyalamiento''''])+3*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P409_PrepararCesionRemate'') ';
    
    
DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_609');          
    execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_tipo = ''email'' where tfi_nombre in (''admEmail'',''admEmail2'',''admEmail3'') and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P412_RegistrarPublicacionBOE'') ';

    
DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_612');          
DBMS_OUTPUT.PUT_LINE('[INICIO] INCIDENCIA EXCEL 27');              
        
        execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_view = ''plugin/procedimientos/genericFormOverSize'' where tap_codigo = ''P413_ConfirmarTestimonio'' ' ;
DBMS_OUTPUT.PUT_LINE('[INICIO] INCIDENCIA EXCEL 115');                              
        execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_view = ''plugin/procedimientos/genericFormOverSize'' where tap_codigo = ''P408_realizarValoracionConcurso'' ' ;
        
DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_613');    
    execute immediate 'update '||V_ESQUEMA||'.tap_Tarea_procedimiento tap set tap.DD_TPO_ID_BPM = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P401'') where tap_codigo = ''P01_BPMTramiteSubasta'' ' ;

DBMS_OUTPUT.PUT_LINE('[INICIO] FASE 614');                      
  BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_614_1');  
    V_SQL := ' SELECT COUNT(1) from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE  DD_TPO_ID = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where
    dd_tpo_codigo = ''P408'') and TAP_CODIGO=''P408_revisarEjecucionesParalizadas''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := ' Insert into '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
      (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_VALIDACION_JBPM, TAP_SCRIPT_DECISION, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, TAP_ALERT_NO_RETORNO, TAP_ALERT_VUELTA_ATRAS, DD_FAP_ID, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_TGE_ID, DD_STA_ID, TAP_EVITAR_REORG, DD_TSUP_ID, TAP_BUCLE_BPM)
      Values
      (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P408''), ''P408_revisarEjecucionesParalizadas'', NULL, 
      NULL, NULL, NULL, NULL, 1, 
      ''Revisar ejecuciones paralizadas'', 0, ''DD'', sysdate, NULL, 
      NULL, NULL, NULL, 0, NULL, 
      NULL, 1, 1, ''EXTTareaProcedimiento'', 3, 
      NULL, 40, NULL, NULL, NULL) ' ;
      EXECUTE IMMEDIATE V_SQL ;      
    END IF ; 
  END ;
    
  BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_614_2');  
    V_SQL := ' SELECT COUNT(1) from '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE  TAP_ID = (SELECT TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO  
             =''P408_revisarEjecucionesParalizadas'') ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := ' Insert into  '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS
      (DD_PTP_ID, DD_JUZ_ID, DD_PLA_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
      Values
      (s_dd_ptp_plazos_tareas_plazas.nextval, NULL, NULL, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P408_revisarEjecucionesParalizadas''), 
      ''3*24*60*60*1000L'', 0, ''DD'', sysdate, NULL, 
      NULL, NULL, NULL, 0) ' ;
      EXECUTE IMMEDIATE V_SQL ;      
    END IF ; 
  END ;
      
  BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_614_3');  
    V_SQL := ' SELECT COUNT(1) from '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = ( SELECT TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO =
            ''P408_revisarEjecucionesParalizadas'')  AND TFI_ORDEN =  0 ' ;
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := ' Insert into  '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
      (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
      Values
      (s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P408_revisarEjecucionesParalizadas''), 0, ''label'', 
      ''titulo'', ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá acceder a la pestaña "Análisis de contratos" de la ficha del asunto correspondiente y revisar el estado del análisis de las operaciones que forman parte del concurso. Recuerde que dispone de las anotaciones para consultar al letrado cualquier detalle que considere oportuno.
      <p style="margin-bottom: 10px"></p>En el campo Fecha deberá de consignar la fecha en que haya realizado la revisión de las operaciones.<p style="margin-bottom: 10px"></p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.
      </p></div>'', NULL, NULL, NULL, 
      NULL, 0, ''DD'', sysdate, NULL, 
      NULL, NULL, NULL, 0); ' ;
      EXECUTE IMMEDIATE V_SQL ;      
    END IF ;     
  END ;

  BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_614_4');  
    V_SQL := ' SELECT COUNT(1) from '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = ( SELECT TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO =
            ''P408_revisarEjecucionesParalizadas'')  AND TFI_ORDEN =  1 ' ;
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := ' INSERT INTO  '||V_ESQUEMA||'.tfi_tareas_form_items
      (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
      )
      VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
      from '||V_ESQUEMA||'.tap_tarea_procedimiento
      WHERE tap_codigo = ''P408_revisarEjecucionesParalizadas''), 1, ''date'', ''fecha'', ''Fecha'', 0, ''DD'', SYSDATE, 0
      ) ' ;
      EXECUTE IMMEDIATE V_SQL ;      
    END IF ;  
  END ;

  BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_614_5');  
    V_SQL := ' SELECT COUNT(1) from '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = ( SELECT TAP_ID from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO =
            ''P408_revisarEjecucionesParalizadas'')  AND TFI_ORDEN =  2 ' ;
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := ' Insert into  '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
      (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
      Values
      (s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P408_revisarEjecucionesParalizadas''),2, ''textarea'', 
      ''observaciones'', ''Observaciones'', NULL, NULL, NULL, 
      NULL, 0, ''DD'', sysdate, NULL, 
      NULL, NULL, NULL, 0) ' ;
      EXECUTE IMMEDIATE V_SQL ;      
    END IF ;     
  END ;
  
DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_615');        
    
    execute immediate 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas ptp set ptp.DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''P412_RegistrarPublicacionBOE''''][''''fecha'''']) + 20*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P412_RegistrarInsinuacionCreditos'') ' ; 
    
  
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
    