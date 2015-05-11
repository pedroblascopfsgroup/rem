--/*
--##########################################
--## Author: AIA
--## Finalidad: DML UNDER_1
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


  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-501');  
  execute immediate 'update ' || V_ESQUEMA || '.dd_ptp_plazos_tareas_plazas SET dd_ptp_plazo_script =
  ''valoresBPMPadre[''''P401_SenyalamientoSubasta''''] == null ? 5*24*60*60*1000L : (damePlazo(valoresBPMPadre[''''P401_SenyalamientoSubasta''''][''''fechaSenyalamiento''''])+5*24*60*60*1000L)''
  WHERE dd_ptp_plazo_script = ''damePlazo(valoresBPMPadre[''''P401_SenyalamientoSubasta''''][''''fechaSenyalamiento''''])+5*24*60*60*1000L'' ';
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-573');  
  DBMS_OUTPUT.PUT_LINE('Borramos el campo combo de la tarea actual');    
  execute immediate 'delete from ' || V_ESQUEMA || '.tfi_tareas_form_items where tfi_nombre = ''comboEligeTramite'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P22_AutoDeclarandoConcurso'') ' ;
  
  DBMS_OUTPUT.PUT_LINE('ordenamos el campo observaciones');    
  execute immediate 'update ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS SET TFI_orden = 2 where tfi_nombre = ''observaciones'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P22_AutoDeclarandoConcurso'') ' ;
  
  DBMS_OUTPUT.PUT_LINE('borramos todo rastro de las opciones del combo anterior');      
  execute immediate 'delete from ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID IN (
  SELECT TAP_ID from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo in (''P22_BPMtramiteFaseComunAbreviado'', ''P22_BPMtramiteFaseComunOrdinario'')  ) ' ;
  
  execute immediate 'delete from ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID IN (SELECT TAP_ID from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo in (''P22_BPMtramiteFaseComunAbreviado'', ''P22_BPMtramiteFaseComunOrdinario'')) ' ;
  
  execute immediate 'delete from ' || V_ESQUEMA || '.tap_tarea_procedimiento where tap_codigo in (''P22_BPMtramiteFaseComunAbreviado'', ''P22_BPMtramiteFaseComunOrdinario'') ' ;
  
  DBMS_OUTPUT.PUT_LINE('insertamos la nueva tarea que determina la nueva ruta del flujo');        
  BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_573_1');  
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE  DD_TPO_ID = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P55'') and TAP_CODIGO=''P22_BPMtramiteFaseComun''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := ' Insert into '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
                (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_VALIDACION_JBPM, TAP_SCRIPT_DECISION, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, TAP_ALERT_NO_RETORNO, TAP_ALERT_VUELTA_ATRAS, DD_FAP_ID, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_TGE_ID, DD_STA_ID, TAP_EVITAR_REORG, DD_TSUP_ID, TAP_BUCLE_BPM)
                Values
                (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P55''), ''P22_BPMtramiteFaseComun'', NULL,
                NULL, NULL, NULL, (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P412'') , 0,
                ''Se inicia Trámite fase común'', 0, ''DD'', SYSDATE, NULL,
                NULL, NULL, NULL, 0, NULL,
                NULL, NULL, 1, ''EXTTareaProcedimiento'', 3,
                NULL, 39, NULL, NULL, NULL) ' ;
      EXECUTE IMMEDIATE V_SQL ;      
    END IF ;
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_573_2');  
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE  TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO =''P22_BPMtramiteFaseComun'') ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := ' Insert into '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS
      (DD_PTP_ID, DD_JUZ_ID, DD_PLA_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
      Values
      (S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, NULL, NULL, (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO =''P22_BPMtramiteFaseComun''),
      ''300*24*60*60*1000L'', 0, ''DD'', SYSDATE, NULL,
      NULL, NULL, NULL, 0) ';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] FASE_573_3');  
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = ( SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO =''P22_BPMtramiteFaseComun'' ) AND TFI_ORDEN =  0 ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;      
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := ' Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
      (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
      Values
      (S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO =''P22_BPMtramiteFaseComun''), 0, ''label'',
      ''titulo'', ''Se inicia Trámite fase común'', NULL, NULL, NULL,
      NULL, 0, ''DD'', SYSDATE, NULL,
      NULL, NULL, NULL, 0) ';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;
  END ;
    
  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-585'); 
  execute immediate 'update ' || V_ESQUEMA || '.dd_juz_juzgados_plaza set dij_id = null ' ;
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-586'); 
  execute immediate 'update ' || V_ESQUEMA || '.tap_tarea_procedimiento set tap_script_validacion = ''comprobarImporteEntidadAdjudicacionBienes() ? null : ''''Debe rellenar en cada bien el importe adjudicación y la entidad'''''' where tap_codigo in (''P401_CelebracionSubasta'',''P409_CelebracionSubasta'')  ' ;
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-587'); 
  execute immediate 'update ' || V_ESQUEMA || '.tfi_tareas_form_items set tfi_label = replace(tfi_label, ''</div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">'','''') where tfi_tipo = ''label'' and tfi_label like ''%</div><div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">%''  ' ;
  
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-589');   
  execute immediate 'update ' || V_ESQUEMA || '.tfi_tareas_form_items set tfi_error_validacion = null, tfi_validacion = null where tfi_nombre = ''fondo'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P413_notificacionDecretoAdjudicacionAEntidad'') ' ;
  
  execute immediate 'update ' || V_ESQUEMA || '.tap_tarea_procedimiento set tap_script_validacion_jbpm = ''(valores[''''P413_notificacionDecretoAdjudicacionAEntidad''''][''''comboEntidadAdjudicataria''''] == ''''FON'''' && valores[''''P413_notificacionDecretoAdjudicacionAEntidad''''][''''fondo''''] == null) ? ''''El campo fondo es obligatorio'''' : null'' where tap_codigo = ''P413_notificacionDecretoAdjudicacionAEntidad'' ' ;
  
  
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-592'); 
  execute immediate 'update ' || V_ESQUEMA || '.tap_tarea_procedimiento set dd_tpo_id_bpm = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P416'') where tap_codigo = ''P413_BPMTramiteDePosesion'' ' ;
  
  execute immediate 'update ' || V_ESQUEMA || '.tap_tarea_procedimiento set tap_descripcion = replace (tap_descripcion, ''Llamada al BPM de '',''Se inicia '') where tap_descripcion like ''Llamada al BPM de %'' ' ;    
  
  execute immediate 'update ' || V_ESQUEMA || '.tfi_tareas_form_items set tfi_validacion = null, tfi_error_validacion = null where tfi_nombre in (''fechaInscripcion'', ''fechaEnvioDecretoAdicion'') and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P413_RegistrarInscripcionDelTitulo'') ' ;  
  
  execute immediate 'update ' || V_ESQUEMA || '.tap_tarea_procedimiento SET tap_script_validacion = ''comprobarGestoriaAsignadaAlSaneamientoDeCargasDeBienes() ? null : ''''Debe asignar la Gestoría encargada del saneamiento de cargas del bien.'''''', tap_script_validacion_jbpm = ''valores[''''P413_RegistrarInscripcionDelTitulo''''][''''comboSituacionTitulo''''] == ''''INS'''' ? (valores[''''P413_RegistrarInscripcionDelTitulo''''][''''fechaInscripcion''''] == null || valores[''''P413_RegistrarInscripcionDelTitulo''''][''''fechaEnvioDecretoAdicion''''] == null ? ''''La fecha inscripción y fecha envío decreto adición son obligatorias'''' : (comprobarAdjuntoDocumentoTestimonioInscritoEnRegistro() ? null : ''''Debe adjuntar el Documento de Testimonio inscrito en el Registro.'''')) : null''  WHERE tap_codigo = ''P413_RegistrarInscripcionDelTitulo'' ' ;
  
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-593'); 
  execute immediate 'update ' || V_ESQUEMA || '.dd_tpo_tipo_procedimiento set flag_unico_bien = 1 where dd_tpo_codigo =''P413'' or dd_tpo_codigo =''P415'' or dd_tpo_codigo =''P416'' or dd_tpo_codigo =''P417'' or dd_tpo_codigo =''P419'' ' ;

  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-595'); 
  execute immediate 'update ' || V_ESQUEMA || '.tap_tarea_procedimiento set TAP_SCRIPT_DECISION = ''obtenerTipoCarga()'' 
  where TAP_CODIGO = ''P415_RevisarEstadoCargas'' ' ;
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-596'); 
  execute immediate 'update ' || V_ESQUEMA || '.tap_tarea_procedimiento set tap_script_validacion = ''comprobarBienAsociadoPrc() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>!Atenci&oacute;n! Para dar por completada esta tarea deber&aacute; vincular un bien al procedimiento.</p></div>'''''' where tap_codigo = ''P419_TrasladoDocuDeteccionOcupantes'' ' ;
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-597');   
  BEGIN    
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE  TAP_ID =  (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P417_RegistrarCambioCerradura'') and TFI_ORDEN = 2 ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := ' Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
      (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
      Values
      (s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P417_RegistrarCambioCerradura''), 2, ''textarea'',
      ''observaciones'', ''Observaciones'', null, null, NULL,
      NULL, 0, ''DD'', sysdate, NULL,
      NULL, NULL, NULL, 0) ';
    END IF ;
  END ;
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-599');  
  execute immediate 'update ' || V_ESQUEMA || '.tap_tarea_procedimiento  set DD_STA_ID = (select DD_STA_ID from '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE where DD_STA_CODIGO = ''105'' ) where TAP_CODIGO = ''P417_RegistrarRecepcionLlaves'' ' ;
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-600');  
  execute immediate 'update ' || V_ESQUEMA || '.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script=''3*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_PrepararCesionRemate'') ' ;
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-603');  
  DBMS_OUTPUT.PUT_LINE(' plazos ; hipotecario ');    
  execute immediate 'update ' || V_ESQUEMA || '.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''7*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P01_DemandaCertificacionCargas'') ' ;
  
  execute immediate 'update ' || V_ESQUEMA || '.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''damePlazo(valores[''''P01_DemandaCertificacionCargas''''][''''fechaSolicitud'''']) + 60*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P01_AutoDespachandoEjecucion'') ' ;
  
  execute immediate 'update ' || V_ESQUEMA || '.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''damePlazo(valores[''''P01_AutoDespachandoEjecucion''''][''''fecha'''']) + 60*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P01_AutoDespachandoEjecucion'') ' ;
  
  DBMS_OUTPUT.PUT_LINE(' monitorio ');    
  execute immediate 'update ' || V_ESQUEMA || '.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''7*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P02_InterposicionDemanda'') ' ;
  
  execute immediate 'update ' || V_ESQUEMA || '.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''damePlazo(valores[''''P02_InterposicionDemanda''''][''''fechaSolicitud'''']) + 60*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P02_ConfirmarAdmisionDemanda'') ' ;
  
  DBMS_OUTPUT.PUT_LINE(' ordinario ');    
  execute immediate 'update ' || V_ESQUEMA || '.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''7*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P03_InterposicionDemanda'' and dd_tpo_id=(select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P03'')) ' ;
  
  DBMS_OUTPUT.PUT_LINE(' ETJ ');    
  execute immediate 'update ' || V_ESQUEMA || '.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''7*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P16_InterposicionDemanda'') ' ;
  
  DBMS_OUTPUT.PUT_LINE(' Cargas ');    
  execute immediate 'update ' || V_ESQUEMA || '.dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = ''5*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P08_RegistrarInformacionCargas'') ' ;
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-608');    
  execute immediate 'update ' || V_ESQUEMA || '.tap_tarea_procedimiento tap set tap.DD_TPO_ID_BPM = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P402'') where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P412_BPMTramiteAnalisisContratos'') ' ;
  execute immediate 'update ' || V_ESQUEMA || '.tap_tarea_procedimiento tap set tap.DD_TPO_ID_BPM = (select dd_tpo_id from '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento where dd_tpo_codigo = ''P404'') where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P412_BPMTramiteAceptacionV4'') ' ;
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-610');    
  execute immediate 'update ' || V_ESQUEMA || '.dd_ptp_plazos_Tareas_plazas set dd_ptp_plazo_script = ''damePlazo(valores[''''P01_DemandaCertificacionCargas''''][''''fechaSolicitud'''']) + 60*24*60*60*1000L'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P01_AutoDespachandoEjecucion'') ' ;
  
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] FASE-SIN-ETIQUETAR');    
  execute immediate 'update ' || V_ESQUEMA || '.dd_ebc_estado_bien_cnt set dd_ebc_codigo = replace(dd_ebc_codigo,''A'','''') ' ;
  
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
