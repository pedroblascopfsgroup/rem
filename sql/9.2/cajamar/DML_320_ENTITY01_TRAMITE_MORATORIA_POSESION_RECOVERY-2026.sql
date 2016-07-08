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
		T_TIPO_TAP('CJ011','CJ011_CelebracionVista' ,null ,null ,null ,null ,null ,'0','Celebración vista' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,5,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ011','CJ011_LecturaInstruccionesMoratoria' ,'plugin/cajamar/tramiteMoratoria/lecturaInstrucciones' ,null ,null ,'valores[''CJ011_RegistrarAdmisionYEmplazamiento''][''comboVista''] == DDPositivoNegativo.POSITIVO ? ''HayVista'' : valores[''CJ011_RevisarInformeLetradoMoratoria''][''comboConformidad''] == DDPositivoNegativo.POSITIVO ? ''PresentarConformidad'' : ''NoHayVista''' ,null ,'0','Lectura de instrucciones moratoria' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,5,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ011','CJ011_PresentarConformidadMoratoria' ,null ,'comprobarExisteDocumentoECM() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el Escrito Conformidad a la Moratoria</div>''' ,null ,null ,null ,'0','Presentar conformidad a moratoria' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,5,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ011','CJ011_RegistrarAdmisionYEmplazamiento' ,'plugin/procedimientos-bpmHaya-plugin/tramiteMoratoria/registrarAdmisionYEmplazamiento' ,null ,'valores[''CJ011_RegistrarAdmisionYEmplazamiento''][''comboVista''] == DDSiNo.SI && valores[''CJ011_RegistrarAdmisionYEmplazamiento''][''fechaSenyalamiento''] == null ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">La fecha fin de se&ntilde;alamiento es obligatoria</div>'' : null' ,null ,null ,'0','Registrar admisión y emplazamiento' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,5,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ011','CJ011_RegistrarInformeMoratoria' ,null ,'comprobarExisteDocumentoILCRLM() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el Informe del Letrado sobre cumplimiento requisitos legales</div>''' ,null ,null ,null ,'0','Registar informe a moratoria' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,5,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ011','CJ011_RegistrarResolucion' ,'plugin/procedimientos-bpmHaya-plugin/tramiteMoratoria/registrarResolucion' ,'comprobarExisteDocumentoREM() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar la Resoluci&oacute;n</div>''' ,'(valores[''CJ011_RegistrarResolucion''][''comboFavDesf''] == ''02'' && valores[''CJ011_RegistrarResolucion''][''fechaFinMoratoria''] == null) ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">La fecha fin de moratoria es obligatoria</div>'' : null' ,'valores[''CJ011_RegistrarResolucion''][''comboFavDesf''] == DDFavorable.FAVORABLE ? ''Favorable'' : ''Desfavorable''' ,null ,'0','Registrar resolución' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,5,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ011','CJ011_RegistrarSolicitudMoratoria' ,null ,'comprobarBienAsociadoPrc() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>!Atenci&oacute;n! Para dar por completada esta tarea deber&aacute; vincular un bien al procedimiento.</p></div>''' ,null ,null ,null ,'0','Registrar solicitud de moratoria' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,5,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ011','CJ011_RevisarInformeLetradoMoratoria' ,null ,null ,null ,null ,null ,'0','Revisar informe letrado moratoria' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,5,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ011','CJ011_SolicitarInstrucciones' ,null ,null ,null ,null ,null ,'0','Solicitar instrucciones' ,'0','RECOVERY-2026','0' ,null ,'tareaExterna.cancelarTarea' ,5,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ011','CJ011_nodoEsperaController' ,null ,null ,null ,'estamosADosMeses() ? ''solicita'' : ''espera''' ,null ,'0','Nodo espera 1' ,'0','RECOVERY-2026','1' ,null ,'tareaExterna.cancelarTarea' ,1,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ011','CJ011_InstruccionesDecision' ,null ,null ,null ,null ,null ,'0','Tarea toma de decisión' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null),
		T_TIPO_TAP('CJ011','CJ011_AutorizarPropuesta' ,null ,null ,null ,'valores[''CJ011_AutorizarPropuesta''][''resultado''] == ''ACEPTADO'' ? ''aceptado'' : ''denegado''' ,null ,'0','Autorizar propuesta' ,'0','RECOVERY-2026','0' ,null ,null ,null,'0' ,'EXTTareaProcedimiento','0',null ,null,null ,null,null)
    );
	V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null ,null ,'CJ011_RevisarInformeLetradoMoratoria','1*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ011_CelebracionVista','damePlazo(valores[''CJ011_RegistrarAdmisionYEmplazamiento''][''fechaSenyalamiento''])' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ011_RegistrarAdmisionYEmplazamiento','damePlazo(valores[''CJ011_RegistrarSolicitudMoratoria''][''fechaSolicitud'']) + 5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ011_PresentarConformidadMoratoria','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ011_RegistrarInformeMoratoria','damePlazo(valores[''CJ011_RegistrarAdmisionYEmplazamiento''][''fechaNotificacion'']) + 1*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ011_LecturaInstruccionesMoratoria','1*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ011_RegistrarResolucion','(valores[''CJ011_CelebracionVista''] != null ? damePlazo(valores[''CJ011_CelebracionVista''][''fechaCelebracion'']) : 6*24*60*60*1000L )' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ011_SolicitarInstrucciones','damePlazo(valores[''CJ011_RegistrarResolucion''][''fechaFinMoratoria''])-60*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ011_RegistrarSolicitudMoratoria','5*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ011_AutorizarPropuesta','3*24*60*60*1000L' ,'0','0','RECOVERY-2026')
    ); 
	V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('CJ011_CelebracionVista','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá dejar indicada la fecha de celebración de la vista, en caso de que no se hubiere celebrado deberá dejar en blanco la fecha de celebración.</p><p>En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene esta pantalla se lanzará la tarea "Registrar resolución".</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_CelebracionVista','1','date' ,'fechaCelebracion','Fecha celebración' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_LecturaInstruccionesMoratoria','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta tarea deber&aacute; de leer las instrucciones dictadas por la entidad respecto a la moratoria.</p><p>Una vez acepte las instrucciones y en funci&oacute;n de los datos introducidos en tareas anteriores, la siguiente tarea ser&aacute; &ldquo;Celebraci&oacute;n de la vista&rdquo;, &ldquo;Registrar resoluci&oacute;n&rdquo; o &ldquo;Presentar escrito de conformidad&rdquo;</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_LecturaInstruccionesMoratoria','1','textarea' ,'instruccionesMoratoria','Instrucciones moratoria' ,null ,null ,'valores[''CJ011_RevisarInformeLetradoMoratoria''] == null ? '''' : (valores[''CJ011_RevisarInformeLetradoMoratoria''][''instruccionesMoratoria''])' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_LecturaInstruccionesMoratoria','2','combo' ,'presentarAlegaciones','Presentar conformidad' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'valores[''CJ011_RevisarInformeLetradoMoratoria''][''comboConformidad'']' ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_PresentarConformidadMoratoria','0','label' ,'titulo','<div style="margin-bottom: 30px;" align="justify"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Dado que la entidad ha decidido presentar el escrito de conformidad a la moratoria, a través de esta tarea deberá de informar la fecha de presentación de dicho escrito.</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez rellene esta pantalla la siguiente tarea será "Registrar resolución.</span></p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_PresentarConformidadMoratoria','1','date' ,'fechaPresentacion','Fecha presentación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_PresentarConformidadMoratoria','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarAdmisionYEmplazamiento','0','label' ,'titulo','<div style="margin-bottom: 30px;" align="justify"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para dar por terminada esta tarea deberá informar la fecha de notificación de la moratoria, si ha habido admisión o no de la solicitud de moratoria, en caso de haber, indicar si hay vista o no y por último la fecha de señalamiento de la misma.</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez rellene esta pantalla la siguiente tarea será  "Registrar informe moratoria".</span></p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarAdmisionYEmplazamiento','1','date' ,'fechaNotificacion','Fecha de notificación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarAdmisionYEmplazamiento','2','combo' ,'comboAdminEmplaza','Admisión y emplazamiento' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarAdmisionYEmplazamiento','3','combo' ,'comboVista','Vista' ,null ,null ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarAdmisionYEmplazamiento','4','date' ,'fechaSenyalamiento','Fecha señalamiento' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarAdmisionYEmplazamiento','5','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarInformeMoratoria','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta pantalla deber&aacute; dejar constancia si la moratoria solicitada por el deudor es acorde con lo establecido por la ley y por tanto es mejor presentar el escrito de conformidad a la moratoria, o si por el contrario se aprecia disconformidad a la ley y por tanto aconseja presentarse a la vista.</p><p>Una vez complete esta pantalla la siguiente tarea ser&aacute; &ldquo;Revisar informe letrado moratoria&rdquo; por la cual se mostrar&aacute; su informe al supervisor de la entidad para que dicte instrucciones.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarInformeMoratoria','1','textarea' ,'informeMoratoria','Informe moratoria' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarResolucion','0','label' ,'titulo','<div style="margin-bottom: 30px;" align="justify"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para dar por terminada esta tarea deberá informar el resultado que se haya dado, ya sea favorable para los intereses de la entidad o no, y solo en caso de haber sido desfavorable  la fecha de fin de la moratoria.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para el supuesto de que la resolución no fuere favorable para la entidad, deberá notificar dicha circunstancia al responsable interno de la misma a través del botón "Anotación" Una vez reciba la aceptación del supervisor deberá gestionar el recurso por medio de la pestaña "Recursos".</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez rellene esta pantalla en caso de resolución favorable para los intereses de la entidad se dará por terminada esta actuación continuando así con la actuación anterior, en caso contrario el sistema esperará hasta 2 meses antes del fin de la moratoria para lanzar la tarea “Solicitar instrucciones”.</span></font></p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarResolucion','1','date' ,'fechaResolucion','Fecha resolución' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarResolucion','2','combo' ,'comboFavDesf','Resultado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDFavorable','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarResolucion','3','date' ,'fechaFinMoratoria','Fecha fin de moratoria' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarResolucion','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarSolicitudMoratoria','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por completada esta tarea deber&aacute; de haber un bien vinculado al procedimiento, esto podr&aacute; comprobarlo a trav&eacute;s de la pesta&ntilde;a Bienes del procedimiento, en caso de no haberlo, a trav&eacute;s de esa misma pesta&ntilde;a dispone de la opci&oacute;n  de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p>En el campo &ldquo;Fecha solicitud&rdquo; deber&aacute; de informar la fecha en la que se haya producido la solicitud de la moratoria.</p><p>En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; &quot;Registrar admisi&oacute;n y emplazamiento&quot;.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarSolicitudMoratoria','1','date' ,'fechaSolicitud','Fecha de solicitud' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarSolicitudMoratoria','2','date' ,'fechaFinMoratoria','Fecha fin de moratoria' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RegistrarSolicitudMoratoria','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RevisarInformeLetradoMoratoria','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta tarea deber&aacute; revisar el informe realizado por el letrado sobre la moratoria presentada por el demandado. En el campo Instrucciones deber&aacute; introducir las instrucciones a realizar por el letrado respecto a la moratoria. </p><p>En el campo &ldquo;Presentar conformidad&rdquo; deber&aacute; indicar si el letrado debe presentar el escrito de conformidad a la moratoria o no.</p><p>Una vez rellene esta pantalla la siguiente tarea ser&aacute; &rdquo;Lectura instrucciones moratoria&rdquo;.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RevisarInformeLetradoMoratoria','1','textarea' ,'informeMoratoria','Informe moratoria' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'valores[''CJ011_RegistrarInformeMoratoria''] == null ? '''' : (valores[''CJ011_RegistrarInformeMoratoria''][''informeMoratoria''])' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RevisarInformeLetradoMoratoria','2','textarea' ,'instruccionesMoratoria','Instrucciones moratoria' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_RevisarInformeLetradoMoratoria','3','combo' ,'comboConformidad','Presentar conformidad' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_SolicitarInstrucciones','0','label' ,'titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que restan dos meses para que expire la fecha de moratoria dictaminada, a través de esta tarea se le informa de que debe obtener instrucciones por parte de la entidad a este respecto.</p><p>En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez termine esta tarea se lanzara una toma de decisión por la cual debe indicar la siguiente actuación a realiza.</p></div>' ,null ,null ,null ,null,'1','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_SolicitarInstrucciones','1','date' ,'fechaInstrucciones','Fecha instrucciones' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_SolicitarInstrucciones','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_AutorizarPropuesta','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta tarea, la entidad se deber&aacute; confirmar si autoriza propuesta del gestor de admisi&oacute;n por el gestor.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, y en caso de que la Entidad autorice la decisi&oacute;n, se lanzar&aacute; la tarea "Lectura de instrucciones moratoria". En caso contrario, la Entidad deber&aacute; indicar c&oacute;mo proceder.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_AutorizarPropuesta','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_AutorizarPropuesta','2','combo' ,'resultado','Resultado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDAceptadoDenegado','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ011_AutorizarPropuesta','3','textarea' ,'observaciones','Observaciones' ,null ,null,null ,null,'0','RECOVERY-2026')
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