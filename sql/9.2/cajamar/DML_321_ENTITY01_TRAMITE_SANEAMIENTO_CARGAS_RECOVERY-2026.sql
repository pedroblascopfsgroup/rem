/*
--##########################################
--## AUTOR=SERGIO NIETO
--## FECHA_CREACION=20160706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-2026
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Procedimiento Cambiario
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear


    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    
    --FALTA CAMBIAR LA RUTA DE LAS JSP
  	TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP('CJ008','CJ008_RevisarPropuestaCancelacionCargas' ,null ,null ,null ,null ,null ,'1','Revisar propuesta de cancelación de cargas' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ008','CJ008_RevisarEstadoCargas' ,null ,'comprobarBienAsociadoPrc() ? (comprobarTipoCargaBienIns() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Para cada una de las cargas, debe especificar el tipo y estado.</div>''): ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe tener un bien asociado al procedimiento</div>''' ,null ,'obtenerTipoCargaBien() == ''noCargas'' ? ''noCargas'' : (obtenerTipoCargaBien() == ''registrales'' ? ''soloRegistrales'' : ''conEconomicas'')' ,null ,'0','Revisar el estado de las cargas' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ008','CJ008_RegistrarPresentacionInscripcionEco' ,null ,null ,null ,null ,null ,'0','Registrar presentación inscripción' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ008','CJ008_RegistrarPresentacionInscripcion' ,null ,null ,null ,null ,null ,'0','Registrar presentación inscripción' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ008','CJ008_RegInsCancelacionCargasRegEco' ,null ,'!comprobarEstadoCargasCancelacion() ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Todas las cargas registrales deben ser informadas en estado cancelada o rechazada</div>'' : comprobarExisteDocumentoSCBCCR() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Documento acreditativo de la cancelaci&oacute;n de cargas registrales.</div>''' ,null ,'vieneDeTCesionRemateTAdjudicacion() ? ''Fin'' : ''Decidir''' ,null ,'0','Registrar inscripción cancelación de cargas registrales' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ008','CJ008_RegInsCancelacionCargasReg' ,null ,'!comprobarEstadoCargasCancelacion() ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Todas las cargas registrales deben ser informadas en estado cancelada o rechazada</div>'' : comprobarExisteDocumentoSCBCCR() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Documento acreditativo de la cancelaci&oacute;n de cargas registrales.</div>''' ,null ,'vieneDeTCesionRemateTAdjudicacion() ? ''Fin'' : ''Decidir''' ,null,'0','Registrar inscripción cancelación de cargas registrales' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ008','CJ008_RegInsCancelacionCargasEconomicas' ,null ,' comprobarEstadoCargasPropuesta() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Todas las cargas econ&oacute;micas deben ser informadas en estado cancelada o rechazada</div>'' ' ,null ,'(obtenerTipoCargaBien() == ''noCargas'') ?  (vieneDeTCesionRemateTAdjudicacion() ? ''fin'' : ''soloEconomicas'')  : ''conRegistrales''' ,null ,'0','Reg. Inscripción cancelación de cargas económicas' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ008','CJ008_PropuestaCancelacionCargas' ,null ,'comprobarExisteDocumento(''PCCSC'') ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento "Propuesta de cancelaci&oacute;n de cargas"</div>''' ,null ,'valores[''CJ008_PropuestaCancelacionCargas''][''cbAprobacion'']==DDSiNo.SI ? ''reqAprobacion'' : ''sinAprobacion''' ,null ,'1','Tramitar propuesta cancelación de cargas' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ008','CJ008_LiquidarCargas' ,null ,'comprobarExisteDocumentoSCBCPC() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar la Carta de pago o documentaci&oacute;n acreditativa de cancelaci&oacute;n.</div>''' ,null ,null ,null ,'0','Liquidar las cargas y formalizar títulos' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ008','DEL_CJ008_BPMTramiteElevarPropSarebAdjudicados' ,null ,null ,null ,null ,'CJ010' ,'0','Elevar propuesta Sareb Adjudicados' ,'0','RECOVERY-2026','1' ,null ,'tareaExterna.cancelarTarea' ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ008','CJ008_SaneamientoDecision' ,null ,null ,null ,null ,null ,'0','Tarea toma de decisión' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ008','DEL_CJ008_SarebDecision' ,null ,null ,null ,null ,null ,'0','Tarea toma de decisión' ,'0','RECOVERY-2026','1' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ008','CJ008_ObtenerAprobPropuesta' ,null ,null ,null ,'valores[''CJ008_ObtenerAprobPropuesta''][''resultado''] == ''ACEPTADO'' ? ''aceptado'' : ''denegado''' ,null ,'0','Autorizar propuesta' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null)
    );
	V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null ,null ,'CJ008_RegistrarPresentacionInscripcion','damePlazo(valores[''CJ008_RevisarEstadoCargas''][''fechaCargas''])+10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ008_RegInsCancelacionCargasReg','damePlazo(valores[''CJ008_RegistrarPresentacionInscripcion''][''fechaPresentacion''])+30*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ008_PropuestaCancelacionCargas','damePlazo(valores[''CJ008_RevisarEstadoCargas''][''fechaCargas''])+10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ008_RevisarPropuestaCancelacionCargas','damePlazo(valores[''CJ008_PropuestaCancelacionCargas''][''fechaPropuesta''])+5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ008_RevisarEstadoCargas','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ008_RegInsCancelacionCargasEconomicas','damePlazo(valores[''CJ008_LiquidarCargas''][''fechaCancelacion''])+10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ008_RegistrarPresentacionInscripcionEco','damePlazo(valores[''CJ008_RegInsCancelacionCargasEconomicas''][''fechaInsEco''])+10*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ008_RegInsCancelacionCargasRegEco','damePlazo(valores[''CJ008_RegistrarPresentacionInscripcionEco''][''fechaPresentacion''])+30*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ008_ObtenerAprobPropuesta','3*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ008_LiquidarCargas','damePlazo(valores[''CJ008_PropuestaCancelacionCargas''][''fechaPropuesta''])+10*24*60*60*1000L' ,'0','0','RECOVERY-2026')
    ); 
	V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('CJ008_RevisarPropuestaCancelacionCargas','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Dado que se han adjuntado al procedimiento la propuesta de cancelaci&oacute;n de cargas econ&oacute;micas, para dar por finalizada esta tarea deber&aacute; revisar dicha propuesta e informar de la fecha en que queda aprobada. En caso de necesitar comunicarse con el usuario responsable de la propuesta, recuerde que dispone de la opci&oacute;n de crear anotaciones a trav&eacute;s de Recovery.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez complete esta pantalla la siguiente tarea ser&aacute; "Autorizar propuesta" que se lanzar&aacute; a la Entidad para su visto bueno.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RevisarPropuestaCancelacionCargas','1','date' ,'fechaRevisar','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RevisarPropuestaCancelacionCargas','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RevisarEstadoCargas','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Times New Roman; font-size: medium; margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Antes de dar por terminada esta tarea deberá de revisar las cargas anteriores y posteriores registradas en el bien vinculado al procedimiento. En caso de no haber un bien ya vinculado al procedimiento, antes de dar por completada esta tarea el sistema le obligará a asociarlo a través de la pestaña bienes del procedimiento. Para cada carga deberá indicar si es de tipo Registral, si es de tipo Económico &nbsp;y en caso de no existir cargas indicarlo expresamente en el campo destinado a tal efecto. En cualquier caso deberá indicar en la ficha de cargas del bien la fecha en que haya realizado la revisión de las mismas.</span></font></p><p style="font-family: Times New Roman; font-size: medium; margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo Fecha deberá indicar la fecha en que se le haya entregado el avalúo de cargas.</span></p><p style="font-family: Times New Roman; font-size: medium; margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">&nbsp;</span></font><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla y dependiendo de cómo hayan quedado las cargas del bien adjudicado se podrán iniciar las siguientes tareas:</p><p></p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber alguna carga registral y no económica se lanzará la tarea "Registrar presentación de inscripción".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber alguna carga económica se lanzará la tarea "Tramitar propuesta de cancelación de cargas".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber quedado el bien en situación "Sin cargas" se lanzará una tarea de tipo decisión por la cual deberá de proponer a la entidad la próxima actuación a realizar.</li></ul></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RevisarEstadoCargas','1','date' ,'fechaCargas','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RevisarEstadoCargas','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RegistrarPresentacionInscripcionEco','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá informar de registrar la fecha en que haya presentado la cancelación para la inscripción de todas las cargas marcadas en la ficha de los bienes subastados de tipo "Registral" cargas. Cargas registrales no económicas que hayan quedado marcadas en la tarea anterior.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla la siguiente tarea será "Registrar cancelación de cargas registrales".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RegistrarPresentacionInscripcionEco','1','date' ,'fechaPresentacion','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RegistrarPresentacionInscripcionEco','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RegistrarPresentacionInscripcion','0','label' ,'titulo','<div style="margin-bottom: 30px;" align="justify"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para dar por terminada esta tarea deberá informar de registrar la fecha en que haya presentado la cancelación para la inscripción de todas las cargas marcadas en la ficha de los bienes subastados de tipo "Registra". Cargas registrales no económicas que hayan quedado marcadas en la tarea anterior.</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez complete esta pantalla la siguiente tarea será "Registrar inscripción cancelación de cargas registrales".</span></p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RegistrarPresentacionInscripcion','1','date' ,'fechaPresentacion','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RegistrarPresentacionInscripcion','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RegInsCancelacionCargasRegEco','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Antes de dar por terminada esta tarea deberá acceder a la ficha del bien afecto adjudicados en al subasta y marcar en las cargas registrales que haya procedido a su cancelación dicha situación en el campo estado de la carga. Una vez hecho esto deberá de informar en esta tarea la fecha de inscripción de la cancelación de las cargas.</p><p style="margin-bottom: 10px;">Recuerde que en caso de haber cancelado alguna carga deberá de enviar al archivo la escritura de cancelación inscrita de la misma.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez complete esta pantalla, en caso de provenga del "Trámite de adjudicación" o del "Trámite de cesión de remate", finalizará el trámite. En caso contrario, se lanzará una tarea por la cual deberá proponer a la entidad la siguiente actuación a realizar.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RegInsCancelacionCargasRegEco','1','date' ,'fechaInsReg','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RegInsCancelacionCargasRegEco','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RegInsCancelacionCargasReg','0','label' ,'titulo','<div style="margin-bottom: 30px;" align="justify"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Antes de dar por terminada esta tarea deberá acceder a la ficha del bien afecto adjudicados en al subasta y marcar en las cargas registrales que haya procedido a su cancelación dicha situación en el campo estado de la carga. Una vez hecho esto deberá de informar en esta tarea la fecha de inscripción de la cancelación de las cargas.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Recuerde que en caso de haber cancelado alguna carga deberá de enviar al archivo la escritura de cancelación inscrita de la misma.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez complete esta pantalla, en caso de provenga del "Trámite de adjudicación" o del "Trámite de cesión de remate", finalizará el trámite. En caso contrario, se lanzará una tarea por la cual deberá proponer a la entidad la siguiente actuación a realizar</span></font></p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RegInsCancelacionCargasReg','1','date' ,'fechaInscripcion','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RegInsCancelacionCargasReg','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RegInsCancelacionCargasEconomicas','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Antes de dar por terminada esta tarea deberá acceder a la ficha del bien asociado al procedimiento y marcar en las cargas económicas  el estado en que haya quedado cada una ya sea cancelada o rechazada. Una vez hecho esto deberá de informar la fecha de inscripción de la cancelación de las cargas, en caso de haberse producido ésta.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez complete esta pantalla en caso de que las cargas económicas también sean registrales se lanzará la tarea “Registrar presentación de inscripción”, en caso de no haberlas y si no proviene del "Trámite de adjudicación" o del "Trámite de cesión de remate", finalizará el trámite. En caso contrario, se lanzará una tarea por la cual deberá proponer a la entidad la siguiente actuación a realizar.</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RegInsCancelacionCargasEconomicas','1','date' ,'fechaInsEco','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_RegInsCancelacionCargasEconomicas','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_PropuestaCancelacionCargas','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Para dar por terminada esta tarea deberá adjuntar al procedimiento el documento con  la propuesta de cancelación de cargas según el formato establecido por la entidad. Desde la pestaña “Cargas” del bien asociado a este trámite,  puede generar la propuesta de cancelación de cargas en formato Word, de forma que en caso de ser necesario pueda modificar el documento antes de adjuntarlo al procedimiento.</p><p style="margin-bottom: 10px;">En el campo Fecha deberá informar la fecha en que de por concluida la propuesta de cancelación de cargas.</p><p style="margin-bottom: 10px;">En el campo "Requiere aprobación" deberá indicar si es necesario o no la aprobación por parte de la entidad a la propuesta de cancelación de cargas económicas.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez complete esta pantalla:</p><p style="margin-bottom: 10px;">-Si ha indocado que requere aprobación, se lanzará la tarea "Obtener aprobación propuesta".</p><p style="margin-bottom: 10px;">-Si ha indicado que no requiere aprobacación, se lanzará la tarea "Liquidar las cargas".</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_PropuestaCancelacionCargas','1','date' ,'fechaPropuesta','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_PropuestaCancelacionCargas','2','combo' ,'cbAprobacion','Requiere aprobación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_PropuestaCancelacionCargas','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_LiquidarCargas','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">Antes de dar por finalizada esta tarea deberá de solicitar a Administración el importe total aprobado para cancelar el total de las cargas registradas del bien asociado e informar la fecha de solicitud en el campo Fecha solicitud importe. En el campo Fecha recepción importe deberá informar la fecha en que haya recibido de Administración el importe solicitado. Por último, en el campo “Fecha cancelación de las cargas” informe la fecha en que haya procedido a la liquidación del total de las cargas aprobadas.</p><p style="margin-bottom: 10px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez complete esta pantalla la siguiente tarea será "Registrar inscripción cancelación de cargas económicas".></p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_LiquidarCargas','1','date' ,'fechaLiquidacion','Fecha solicitud importe' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_LiquidarCargas','2','date' ,'fechaRecepcion','Fecha recepción importe' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_LiquidarCargas','3','date' ,'fechaCancelacion','Fecha cancelación de las cargas' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_LiquidarCargas','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_ObtenerAprobPropuesta','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial;"><p style="margin-bottom: 10px;">En esta tarea, la Entidad deber&aacute; aceptar o denegar la propuesta de cancelaci&oacute;n de cargas realizada por el letrado.</p><p style="margin-bottom: 10px;">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px;">Una vez rellene esa pantalla, y si la Entidad acepta la propuesta se lanzar&aacute; la tarea "Revisar propuesta de cancelaci&oacute;n y cargas". En caso contrario, la Entidad deber&aacute; indicar c&oacute;mo proceder.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_ObtenerAprobPropuesta','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_ObtenerAprobPropuesta','2','combo' ,'resultado','Resultado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDAceptadoDenegado','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ008_ObtenerAprobPropuesta','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026')
    );
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	
	
    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
        IF V_NUM_TABLAS > 0 THEN				
        	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET TAP_VIEW=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
        	' TAP_SCRIPT_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',' ||
        	' TAP_SCRIPT_VALIDACION_JBPM=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',' ||
        	' TAP_SCRIPT_DECISION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' ||
          ' TAP_DESCRIPCION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',' ||
          ' DD_TPO_ID_BPM=(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || TRIM(V_TMP_TIPO_TAP(7)) || '''),' ||
          ' TAP_ALERT_VUELTA_ATRAS=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
          ' DD_FAP_ID=(SELECT DD_FAP_ID FROM ' || V_ESQUEMA || '.DD_FAP_FASE_PROCESAL WHERE DD_FAP_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(15)) || '''),' || 
          ' TAP_AUTOPRORROGA=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',' ||
          ' TAP_MAX_AUTOP=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
        	' DD_STA_ID=(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
          ' DD_TSUP_ID=(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' ||
          ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
          ' FECHAMODIFICAR=sysdate ' ||
        	' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
			--DBMS_OUTPUT.PUT_LINE(V_SQL);
		    EXECUTE IMMEDIATE V_SQL;	
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||VAR_TABLENAME||'... Actualizada la tarea '''|| TRIM(V_TMP_TIPO_TAP(2)) ||''', ' || TRIM(V_TMP_TIPO_TAP(3)));
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                    'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                    'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                    'SELECT ' || V_ESQUEMA || '.' ||
                    'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
                    'sysdate,''' || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(19)),'''','''''') || ''',' || 
                    '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' ||
		    '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' ||
		    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
          END IF;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Tareas');


    -- LOOP Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    VAR_TABLENAME := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar PLAZOS');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(3))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
        IF V_NUM_TABLAS > 0 THEN				
	  V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET DD_PTP_PLAZO_SCRIPT=''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',' ||
            ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''',' ||
            ' FECHAMODIFICAR=sysdate ' ||
        	  ' WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(3))||''')';
          EXECUTE IMMEDIATE V_SQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Se actualiza el plazo '''|| TRIM(V_TMP_TIPO_PLAZAS(3)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
                    'SELECT ' ||
                    ''||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
                    '(SELECT DD_JUZ_ID FROM ' || V_ESQUEMA || '.DD_JUZ_JUZGADOS_PLAZA WHERE DD_JUZ_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(1)) || '''), ' ||
                    '(SELECT DD_PLA_ID FROM ' || V_ESQUEMA || '.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(2)) || '''), ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(3)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''', sysdate FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Plazos');

    -- LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
    VAR_TABLENAME := 'TFI_TAREAS_FORM_ITEMS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar Campos de tareas');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TFI(1))||''') and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
        
        	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET TFI_TIPO=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
        	' TFI_NOMBRE=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',' ||
        	' TFI_LABEL=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
        	' TFI_ERROR_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',' ||
        	' TFI_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
        	' TFI_VALOR_INICIAL=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',' ||
        	' TFI_BUSINESS_OPERATION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
          ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || ''',' ||
          ' FECHAMODIFICAR=sysdate ' ||
        	' WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TFI(1))||''') and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
			--DBMS_OUTPUT.PUT_LINE(V_SQL);
		    EXECUTE IMMEDIATE V_SQL;	
	        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS... Actualizado el item '''|| TRIM(V_TMP_TIPO_TFI(1)) ||''' and TFI_NOMBRE = '||TRIM(V_TMP_TIPO_TFI(4))||' ');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                    'SELECT ' ||
                    ''||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || ''',sysdate,0 FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');

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