--/*
--##########################################
--## AUTOR=GONZALO ESTELLES
--## FECHA_CREACION=2015722
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-380
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite Saneamiento de cargas
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_COD_PROCEDIMIENTO VARCHAR (20 CHAR) := 'H008';
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
    	T_TIPO_TPO(V_COD_PROCEDIMIENTO,'T. de saneamiento de cargas Haya - HAYA','T. de saneamiento de cargas de Haya',null,'hcj_tramiteSaneamientoCargas','0','DD','0','AP',null,null,'8','MEJTipoProcedimiento','1','1')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(

    	--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H008_RevisarEstadoCargas',null,'comprobarBienAsociadoPrc() ? (comprobarTipoCargaBienIns() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Para cada una de las cargas, debe especificar el tipo y estado.</div>''): ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe tener un bien asociado al procedimiento</div>''',null,'obtenerTipoCargaBien() == ''noCargas'' ? ''noCargas'' : (obtenerTipoCargaBien() == ''registrales'' ? ''soloRegistrales'' : ''conEconomicas'')',null,'0','Revisar el estado de las cargas','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'1011',null,'GAREO',null),
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H008_SaneamientoDecision',null,null,null,null,null,'0','Tarea toma de decisión','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'820',null,'GAREO',null),
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H008_RegistrarPresentacionInscripcion',null,null,null,null,null,'0','Registrar presentación inscripción','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'1011',null,'GAREO',null),
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H008_RegInsCancelacionCargasReg',null,'comprobarEstadoCargasCancelacion() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El estado de todas las cargas registrales debe ser estado cancelada</div>''',null,null,null,'0','Registrar inscripción cancelación de cargas registrales','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'1011',null,'GAREO',null),
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H008_PropuestaCancelacionCargas',null,null,null,null,null,'1','Tramitar propuesta cancelación de cargas','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'1011',null,'GAREO',null),
		--DEL T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H008_BPMTramiteElevarPropSarebAdjudicados',null,null,null,null,'H010','0','Elevar propuesta Sareb Adjudicados','0','DD','0',null,'tareaExterna.cancelarTarea',null,'1','EXTTareaProcedimiento','3',null,'1011',null,'GAREO',null),
		--DEL T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H008_SarebDecision',null,null,null,null,null,'0','Tarea toma de decisión','0','DD','0',null,null,null,'0','EXTTareaProcedimiento','3',null,'825',null,'SULI',null),    
	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H008_ObtenerAprobPropuesta',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Obtener aprobación propuesta',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '0',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ '',
        /*TAP_BUCLE_BPM................:*/ null        
        )
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H008_RevisarPropuestaCancelacionCargas',null,null,null,null,null,'1','Revisar propuesta de cancelación de cargas','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'811',null,'SAREO',null),
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H008_LiquidarCargas',null,null,null,null,null,'0','Liquidar las cargas','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'1011',null,'GAREO',null),
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H008_RegInsCancelacionCargasEconomicas',null,' comprobarEstadoCargasPropuesta() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Todas las cargas econ&oacute;micas deben ser informadas en estado cancelada o rechazada</div>'' ',null,'(obtenerTipoCargaBien() == ''noCargas'') ?  ''soloEconomicas'' : ''conRegistrales'' ',null,'0','Registrar inscripción cancelación de cargas económicas','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'1011',null,'GAREO',null),
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H008_RegistrarPresentacionInscripcionEco',null,null,null,null,null,'0','Registrar presentación inscripción','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'1011',null,'GAREO',null),
		--EQ T_TIPO_TAP(V_COD_PROCEDIMIENTO,'H008_RegInsCancelacionCargasRegEco',null,null,null,null,null,'0','Registrar inscripción cancelación de cargas registrales','0','DD','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'1011',null,'GAREO',null),

    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		--EQ T_TIPO_PLAZAS(null,null,'H008_RevisarEstadoCargas','5*24*60*60*1000L','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H008_RegistrarPresentacionInscripcion','damePlazo(valores[''H008_RevisarEstadoCargas''][''fechaCargas''])+10*24*60*60*1000L','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H008_RegInsCancelacionCargasReg','damePlazo(valores[''H008_RegistrarPresentacionInscripcion''][''fechaPresentacion''])+30*24*60*60*1000L','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H008_PropuestaCancelacionCargas','damePlazo(valores[''H008_RevisarEstadoCargas''][''fechaCargas''])+10*24*60*60*1000L','0','0','DD'),
		--DEL T_TIPO_PLAZAS(null,null,'H008_BPMTramiteElevarPropSarebAdjudicados','300*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H008_ObtenerAprobPropuesta','5*24*60*60*1000L','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H008_RevisarPropuestaCancelacionCargas','damePlazo(valores[''H008_PropuestaCancelacionCargas''][''fechaPropuesta''])+5*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H008_LiquidarCargas','damePlazo(valores[''H008_PropuestaCancelacionCargas''][''fechaPropuesta''])+10*24*60*60*1000L','0','0','DD')
		--EQ T_TIPO_PLAZAS(null,null,'H008_RegInsCancelacionCargasEconomicas','damePlazo(valores[''H008_LiquidarCargas''][''fechaCancelacion''])+10*24*60*60*1000L','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H008_RegistrarPresentacionInscripcionEco','damePlazo(valores[''H008_RegInsCancelacionCargasEconomicas''][''fechaInsEco''])+10*24*60*60*1000L','0','0','DD'),
		--EQ T_TIPO_PLAZAS(null,null,'H008_RegInsCancelacionCargasRegEco','damePlazo(valores[''H008_RegistrarPresentacionInscripcionEco''][''fechaPresentacion''])+30*24*60*60*1000L','0','0','DD'),
    
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		--EQ T_TIPO_TFI('H008_RevisarEstadoCargas','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: ''Times New Roman''; font-size: medium; margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Antes de dar por terminada esta tarea deberá de revisar las cargas anteriores y posteriores registradas en el bien vinculado al procedimiento. En caso de no haber un bien ya vinculado al procedimiento, antes de dar por completada esta tarea el sistema le obligará a asociarlo a través de la pestaña bienes del procedimiento. Para cada carga deberá indicar si es de tipo Registral, si es de tipo Económico &nbsp;y en caso de no existir cargas indicarlo expresamente en el campo destinado a tal efecto. En cualquier caso deberá indicar en la ficha de cargas del bien la fecha en que haya realizado la revisión de las mismas.</span></font></p><p style="font-family: ''Times New Roman''; font-size: medium; margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo Fecha deberá indicar la fecha en que se le haya entregado el avalúo de cargas.</span></p><p style="font-family: ''Times New Roman''; font-size: medium; margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">&nbsp;</span></font><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla y dependiendo de cómo hayan quedado las cargas del bien adjudicado se podrán iniciar las siguientes tareas:</p><p></p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber alguna carga registral y no económica se lanzará la tarea "Registrar presentación de inscripción".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber alguna carga económica se lanzará la tarea "Tramitar propuesta de cancelación de cargas".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber quedado el bien en situación "Sin cargas" se lanzará una tarea de tipo decisión por la cual deberá de proponer a la entidad la próxima actuación a realizar.</li></ul></div>',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H008_RevisarEstadoCargas','1','date','fechaCargas','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--EQ T_TIPO_TFI('H008_RevisarEstadoCargas','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H008_RegistrarPresentacionInscripcion','0','label','titulo','<div style="margin-bottom: 30px;" align="justify"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para dar por terminada esta tarea deberá informar de registrar la fecha en que haya presentado la cancelación para la inscripción de todas las cargas marcadas en la ficha de los bienes subastados de tipo "Registra". Cargas registrales no económicas que hayan quedado marcadas en la tarea anterior.</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez complete esta pantalla la siguiente tarea será "Registrar inscripción cancelación de cargas registrales".</span></p></div>',null,null,null,null,'1','DD'),
		--EQ T_TIPO_TFI('H008_RegistrarPresentacionInscripcion','1','date','fechaPresentacion','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--EQ T_TIPO_TFI('H008_RegistrarPresentacionInscripcion','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H008_RegInsCancelacionCargasReg','0','label','titulo','<div style="margin-bottom: 30px;" align="justify"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Antes de dar por terminada esta tarea deberá acceder a la ficha del bien afecto adjudicados en al subasta y marcar en las cargas registrales que haya procedido a su cancelación dicha situación en el campo estado de la carga. Una vez hecho esto deberá de informar en esta tarea la fecha de inscripción de la cancelación de las cargas.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Recuerde que en caso de haber cancelado alguna carga deberá de enviar al archivo la escritura de cancelación inscrita de la misma.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez complete esta pantalla, en caso de provenga del "Trámite de adjudicación" o del "Trámite de cesión de remate", finalizará el trámite. En caso contrario, se lanzará una tarea por la cual deberá proponer a la entidad la siguiente actuación a realizar</span></font></p></div>',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H008_RegInsCancelacionCargasReg','1','date','fechaInscripcion','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--EQ T_TIPO_TFI('H008_RegInsCancelacionCargasReg','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H008_PropuestaCancelacionCargas','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Para dar por terminada esta tarea deberá adjuntar al procedimiento el documento con  la propuesta de cancelación de cargas según el formato establecido por la entidad. Desde la pestaña “Cargas” del bien asociado a este trámite,  puede generar la propuesta de cancelación de cargas en formato Word, de forma que en caso de ser necesario pueda modificar el documento antes de adjuntarlo al procedimiento.</p><p style="margin-bottom: 10px;">En el campo Fecha deberá informar la fecha en que de por concluida la propuesta de cancelación de cargas.</p><p style="margin-bottom: 10px;">En el campo "Requiere aprobación" deberá indicar si es necesario o no la aprobación por parte de la entidad a la propuesta de cancelación de cargas económicas.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez complete esta pantalla:</p><p style="margin-bottom: 10px;">-Si ha indocado que requere aprobación, se lanzará la tarea "Obtener aprobación propuesta".</p><p style="margin-bottom: 10px;">-Si ha indicado que no requiere aprobacación, se lanzará la tarea "Liquidar las cargas".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H008_PropuestaCancelacionCargas','1','date','fechaPropuesta','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H008_PropuestaCancelacionCargas','2','combo','cbAprobacion','Requiere aprobación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H008_PropuestaCancelacionCargas','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		--DEL T_TIPO_TFI('H008_BPMTramiteElevarPropSarebAdjudicados','0','label','titulo','Se inicia el trámite elevar propuesta Sareb Adjudicados.',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H008_ObtenerAprobPropuesta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">A través de esta pantalla deberá dar autorización expresa a la cancelación de las cargas económicas.</p><p style="margin-bottom: 10px;">En el campo Fecha informar de la fecha en la que se autoriza la cancelación de las cargas económicas. </p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez complete esta pantalla la siguiente tarea será "Revisar propuesta de cancelación de cargas".</p></div>',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H008_ObtenerAprobPropuesta','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H008_ObtenerAprobPropuesta','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H008_RevisarPropuestaCancelacionCargas','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Dado que se han adjuntado al procedimiento la propuesta de cancelación de cargas económicas, para dar por finalizada esta tarea deberá revisar dicha propuesta e informar de la fecha en que queda aprobada. En caso de necesitar comunicarse con el usuario responsable de la propuesta, recuerde que dispone de la opción de crear anotaciones a través de Recovery.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez complete esta pantalla la siguiente tarea será "Liquidar las cargas y formalizar títulos".</p></div>',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H008_RevisarPropuestaCancelacionCargas','1','date','fechaRevisar','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--EQ T_TIPO_TFI('H008_RevisarPropuestaCancelacionCargas','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H008_LiquidarCargas','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Antes de dar por finalizada esta tarea deberá de solicitar a Administración el importe total aprobado para cancelar el total de las cargas registradas del bien asociado e informar la fecha de solicitud en el campo Fecha solicitud importe. En el campo Fecha recepción importe deberá informar la fecha en que haya recibido de Administración el importe solicitado. Por último, en el campo “Fecha cancelación de las cargas” informe la fecha en que haya procedido a la liquidación del total de las cargas aprobadas.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez complete esta pantalla la siguiente tarea será "Registrar inscripción cancelación de cargas económicas".></p></div>',null,null,null,null,'1','DD'),
		T_TIPO_TFI('H008_LiquidarCargas','1','date','fechaLiquidacion','Fecha solicitud importe','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H008_LiquidarCargas','2','date','fechaRecepcion','Fecha recepción importe','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H008_LiquidarCargas','3','date','fechaCancelacion','Fecha cancelación de las cargas','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H008_LiquidarCargas','4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H008_RegInsCancelacionCargasEconomicas','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Antes de dar por terminada esta tarea deberá acceder a la ficha del bien asociado al procedimiento y marcar en las cargas económicas  el estado en que haya quedado cada una ya sea cancelada o rechazada. Una vez hecho esto deberá de informar la fecha de inscripción de la cancelación de las cargas, en caso de haberse producido ésta.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez complete esta pantalla en caso de que las cargas económicas también sean registrales se lanzará la tarea “Registrar presentación de inscripción”, en caso de no haberlas y si no proviene del "Trámite de adjudicación" o del "Trámite de cesión de remate", finalizará el trámite. En caso contrario, se lanzará una tarea por la cual deberá proponer a la entidad la siguiente actuación a realizar.</p></div>',null,null,null,null,'1','DD'),
		--EQ T_TIPO_TFI('H008_RegInsCancelacionCargasEconomicas','1','date','fechaInsEco','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--EQ T_TIPO_TFI('H008_RegInsCancelacionCargasEconomicas','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H008_RegistrarPresentacionInscripcionEco','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá informar de registrar la fecha en que haya presentado la cancelación para la inscripción de todas las cargas marcadas en la ficha de los bienes subastados de tipo "Registral" cargas. Cargas registrales no económicas que hayan quedado marcadas en la tarea anterior.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla la siguiente tarea será "Registrar cancelación de cargas registrales".</p></div>',null,null,null,null,'0','DD'),
		--EQ T_TIPO_TFI('H008_RegistrarPresentacionInscripcionEco','1','date','fechaPresentacion','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--EQ T_TIPO_TFI('H008_RegistrarPresentacionInscripcionEco','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H008_RegInsCancelacionCargasRegEco','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Antes de dar por terminada esta tarea deberá acceder a la ficha del bien afecto adjudicados en al subasta y marcar en las cargas registrales que haya procedido a su cancelación dicha situación en el campo estado de la carga. Una vez hecho esto deberá de informar en esta tarea la fecha de inscripción de la cancelación de las cargas.</p><p style="margin-bottom: 10px;">Recuerde que en caso de haber cancelado alguna carga deberá de enviar al archivo la escritura de cancelación inscrita de la misma.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez complete esta pantalla, en caso de provenga del "Trámite de adjudicación" o del "Trámite de cesión de remate", finalizará el trámite. En caso contrario, se lanzará una tarea por la cual deberá proponer a la entidad la siguiente actuación a realizar.</p></div>',null,null,null,null,'0','DD')
		--EQ T_TIPO_TFI('H008_RegInsCancelacionCargasRegEco','1','date','fechaInsReg','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		--EQ T_TIPO_TFI('H008_RegInsCancelacionCargasRegEco','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		
	); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	
	
	
	/* ------------------- -------------------------- */
	/* --------------  ACTUALIZACIONES --------------- */
	/* ------------------- -------------------------- */

	V_TAREA:='H008_RegInsCancelacionCargasReg';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
		' TAP_SCRIPT_VALIDACION=''comprobarExisteDocumentoSCBCCR() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Documento acreditativo de la cancelaci&oacute;n de cargas registrales.</div>'''''', ' ||
		' TAP_SCRIPT_DECISION=''vieneDeTCesionRemateTAdjudicacion() ? ''''Fin'''' : ''''Decidir'''''' ' ||
		' WHERE TAP_CODIGO='''||V_TAREA||'''';

	V_TAREA:='H008_RegistrarPresentacionInscripcion';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
		' TAP_ALERT_VUELTA_ATRAS=''tareaExterna.cancelarTarea''  ' ||
		' WHERE TAP_CODIGO='''||V_TAREA||'''';
		
	V_TAREA:='H008_PropuestaCancelacionCargas';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
		' TAP_SCRIPT_VALIDACION=''comprobarExisteDocumentoPCCSC() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar la Propuesta de cancelaci&oacute;n de cargas registrales.</div>'''''', ' ||
		' TAP_ALERT_VUELTA_ATRAS=''tareaExterna.cancelarTarea'' , ' ||
		' TAP_SCRIPT_DECISION=''valores[''''H008_PropuestaCancelacionCargas''''][''''cbAprobacion'''']==DDSiNo.SI ? ''''reqAprobacion'''' : ''''sinAprobacion'''''' ' ||
		' WHERE TAP_CODIGO='''||V_TAREA||'''';

		
	-- BORRADO DE TAREA (lógico)
	V_TAREA:='H008_BPMTramiteElevarPropSarebAdjudicados';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''GONZALO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
		
	-- BORRADO DE TAREA (lógico)
	V_TAREA:='H008_SarebDecision';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''DEL_'||V_TAREA||''',BORRADO=1,FECHABORRAR=sysdate,USUARIOBORRAR=''GONZALO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	
	V_TAREA:='H008_RevisarPropuestaCancelacionCargas';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
		' TAP_ALERT_VUELTA_ATRAS=''tareaExterna.cancelarTarea''  ' ||
		' WHERE TAP_CODIGO='''||V_TAREA||'''';
	
	V_TAREA:='H008_LiquidarCargas';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
		' TAP_DESCRIPCION=''Liquidar las cargas y formalizar títulos'', ' ||
		' TAP_SCRIPT_VALIDACION=''comprobarExisteDocumentoSCBCPC() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar la Carta de pago o documentaci&oacute;n acreditativa de cancelaci&oacute;n.</div>'''''', ' ||
		' TAP_ALERT_VUELTA_ATRAS=NULL , ' ||
		' TAP_SCRIPT_DECISION=NULL ' ||
		' WHERE TAP_CODIGO='''||V_TAREA||'''';

	V_TAREA:='H008_RegInsCancelacionCargasEconomicas';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
		' TAP_DESCRIPCION=''Reg. Inscripción cancelación de cargas económicas'', ' ||
		' TAP_SCRIPT_DECISION=''(obtenerTipoCargaBien() == ''''noCargas'''') ?  (vieneDeTCesionRemateTAdjudicacion() ? ''''fin'''' : ''''soloEconomicas'''')  : ''''conRegistrales'''''' ' ||
		' WHERE TAP_CODIGO='''||V_TAREA||'''';
		
	V_TAREA:='H008_RegistrarPresentacionInscripcionEco';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
		' TAP_ALERT_VUELTA_ATRAS=''tareaExterna.cancelarTarea''  ' ||
		' WHERE TAP_CODIGO='''||V_TAREA||'''';
		
	V_TAREA:='H008_RegInsCancelacionCargasRegEco';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TFI_NOMBRE=''titulo'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
		' TAP_SCRIPT_VALIDACION=''comprobarExisteDocumentoSCBCCR() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Documento acreditativo de la cancelaci&oacute;n de cargas registrales.</div>'''''', ' ||
		' TAP_SCRIPT_DECISION=''vieneDeTCesionRemateTAdjudicacion() ? ''''Fin'''' : ''''Decidir'''''', ' ||
		' TAP_ALERT_VUELTA_ATRAS=''tareaExterna.cancelarTarea''  ' ||
		' WHERE TAP_CODIGO='''||V_TAREA||'''';
		
		
	/* ------------------- -------------------------- */
	/* ------------------- -------------------------- */

	-- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' SET ' ||
        		' DD_TPO_CODIGO='''||REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') ||''''|| 
        		' ,DD_TPO_XML_JBPM='''||REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''')||''''||
				' WHERE DD_TPO_CODIGO='''||REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') ||'''';
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
            EXECUTE IMMEDIATE V_MSQL;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Procedimiento');

    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                    'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                    'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                    'SELECT ' ||
                    'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
                    'sysdate,''' || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
                    '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' || 
                    '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''')
										|| ''',' ||'(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO='''|| REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || ''')'
										|| ',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
          
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
            EXECUTE IMMEDIATE V_MSQL;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Tareas');


    -- LOOP Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    VAR_TABLENAME := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar PLAZOS');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
                    'SELECT ' ||
                    'S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
                    '(SELECT DD_JUZ_ID FROM ' || V_ESQUEMA || '.DD_JUZ_JUZGADOS_PLAZA WHERE DD_JUZ_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(1)) || '''), ' ||
                    '(SELECT DD_PLA_ID FROM ' || V_ESQUEMA || '.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(2)) || '''), ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(3)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''', sysdate FROM DUAL'; 

            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
            EXECUTE IMMEDIATE V_MSQL;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Plazos');

    -- LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
    VAR_TABLENAME := 'TFI_TAREAS_FORM_ITEMS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar Campos de tareas');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                    'SELECT ' ||
                    'S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || ''',sysdate,0 FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
            EXECUTE IMMEDIATE V_MSQL;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');

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