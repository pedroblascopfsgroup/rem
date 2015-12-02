--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150822
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.1-hy-rc02
--## INCIDENCIA_LINK=CMREC-416
--## PRODUCTO=NO
--##
--## Finalidad: Adaptar BPM's Haya-Cajamar
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

	/*
    * CONFIGURACION: ESQUEMAS
    *---------------------------------------------------------------------
    */
    PAR_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';               -- [PARAMETRO] Configuracion Esquemas
    PAR_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';    -- [PARAMETRO] Configuracion Esquemas

    /*
    * CONFIGURACION: TABLAS
    *---------------------------------------------------------------------
    */    
    PAR_TABLENAME_TPROC VARCHAR2(50 CHAR) := 'DD_TPO_TIPO_PROCEDIMIENTO';   -- [PARAMETRO] TABLA para tipo de procedimiento. Por defecto DD_TPO_TIPO_PROCEDIMIENTO
    PAR_TABLENAME_TARPR VARCHAR2(50 CHAR) := 'TAP_TAREA_PROCEDIMIENTO';     -- [PARAMETRO] TABLA para tareas del procedimiento. Por defecto TAP_TAREA_PROCEDIMIENTO
    PAR_TABLENAME_TPLAZ VARCHAR2(50 CHAR) := 'DD_PTP_PLAZOS_TAREAS_PLAZAS'; -- [PARAMETRO] TABLA para plazos de tareas. Por defecto DD_PTP_PLAZOS_TAREAS_PLAZAS
    PAR_TABLENAME_TFITE VARCHAR2(50 CHAR) := 'TFI_TAREAS_FORM_ITEMS';       -- [PARAMETRO] TABLA para items del form de tareas. Por defecto TFI_TAREAS_FORM_ITEMS

    /*
    * CONFIGURACION: IDENTIDAD SCRIPT
    *---------------------------------------------------------------------
    */
    PAR_TIT_TRAMITE VARCHAR2(50 CHAR)   := 'Trámite de moratoria de posesión';   -- [PARAMETRO] Título del trámite
    PAR_AUTHOR VARCHAR2(20 CHAR)        := 'Alberto';                            -- [PARAMETRO] Nick del autor
    PAR_AUTHOR_EMAIL VARCHAR2(50 CHAR)  := 'alberto.campos@pfsgroup.es';   -- [PARAMETRO] Email del autor
    PAR_AUTHOR_TELF VARCHAR2(10 CHAR)   := '2052';                              -- [PARAMETRO] Teléfono del autor

    /*
    * VARIABLES DEL SCRIPT
    *---------------------------------------------------------------------
    */    
    V_MSQL VARCHAR2(32000 CHAR);                        -- Sentencia a ejecutar     
    V_SQL VARCHAR2(4000 CHAR);                          -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16);                            -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);                                 -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR);                        -- Vble. auxiliar para registrar errores en el script.

    VAR_SEQUENCENAME VARCHAR2(50 CHAR);                 -- Variable para secuencias
    VAR_CURR_ROWARRAY VARCHAR2(25 CHAR);                -- Variable con fila array actual - para excepciones
    VAR_CURR_TABLE VARCHAR2(50 CHAR);                   -- Variable con tabla actual - para excepciones

    V_CODIGO_TPO VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tipo procedimiento
    V_CODIGO_TAP VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tap tareas
    V_CODIGO_PLAZAS VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Plazos
    V_CODIGO1_TFI VARCHAR2(100 CHAR); -- Variable para nombre campo1 FK con codigo de TFI Items
    V_CODIGO2_TFI VARCHAR2(100 CHAR); -- Variable para nombre campo2 FK con codigo de TFI Items
    V_COD_PROCEDIMIENTO VARCHAR(10 CHAR) := 'CJ011'; -- Código de procedimiento para reemplazar

	/*
    * ARRAY TABLA1: DD_TPO_TIPO_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
    	T_TIPO_TPO(V_COD_PROCEDIMIENTO, 'T. de moratoria de Posesión - CJ','T. de moratoria de Posesión - CJ','','cj_tramiteMoratoriaLanzamiento',0,'dd',0,'AP', null, null,1,'MEJTipoProcedimiento',1,1)
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;
    
    /*
    * ARRAY TABLA2: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ011_CelebracionVista','','','','','',0,'Celebración vista',0,'DD',0,'','tareaExterna.cancelarTarea','05',1,'EXTTareaProcedimiento',3,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ011_LecturaInstruccionesMoratoria','plugin/cajamar/tramiteMoratoria/lecturaInstrucciones','','','valores[''CJ011_RegistrarAdmisionYEmplazamiento''][''comboVista''] == DDPositivoNegativo.POSITIVO ? ''HayVista'' : valores[''CJ011_RevisarInformeLetradoMoratoria''][''comboConformidad''] == DDPositivoNegativo.POSITIVO ? ''PresentarConformidad'' : ''NoHayVista''','',0,'Lectura de instrucciones moratoria',0,'DD',0,'','tareaExterna.cancelarTarea','05',1,'EXTTareaProcedimiento',3,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ011_PresentarConformidadMoratoria','','comprobarExisteDocumentoECM() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el Escrito Conformidad a la Moratoria</div>''','','','',0,'Presentar conformidad a moratoria',0,'DD',0,'','tareaExterna.cancelarTarea','05',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ011_RegistrarAdmisionYEmplazamiento','plugin/cajamar/tramiteMoratoria/registrarAdmisionYEmplazamiento','','valores[''CJ011_RegistrarAdmisionYEmplazamiento''][''comboVista''] == DDSiNo.SI && valores[''CJ011_RegistrarAdmisionYEmplazamiento''][''fechaSenyalamiento''] == null ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">La fecha fin de se&ntilde;alamiento es obligatoria</div>'' : null','','',0,'Registrar admisión y emplazamiento',0,'DD',0,'','tareaExterna.cancelarTarea','05',1,'EXTTareaProcedimiento',3,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ011_RegistrarInformeMoratoria','','comprobarExisteDocumentoILCRLM() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el Informe del Letrado sobre cumplimiento requisitos legales</div>''','','','',0,'Registar informe a moratoria',0,'DD',0,'','tareaExterna.cancelarTarea','05',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ011_RegistrarResolucion','plugin/cajamar/tramiteMoratoria/registrarResolucion','comprobarExisteDocumentoREM() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar la Resoluci&oacute;n</div>''','(valores[''CJ011_RegistrarResolucion''][''comboFavDesf''] == ''02'' && valores[''CJ011_RegistrarResolucion''][''fechaFinMoratoria''] == null) ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">La fecha fin de moratoria es obligatoria</div>'' : null','valores[''CJ011_RegistrarResolucion''][''comboFavDesf''] == DDFavorable.FAVORABLE ? ''Favorable'' : ''Desfavorable''','',0,'Registrar resolución',0,'DD',0,'','tareaExterna.cancelarTarea','05',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ011_RegistrarSolicitudMoratoria','','comprobarBienAsociadoPrc() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>!Atenci&oacute;n! Para dar por completada esta tarea deber&aacute; vincular un bien al procedimiento.</p></div>''','','','',0,'Registrar solicitud de moratoria',0,'DD',0,'','tareaExterna.cancelarTarea','05',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ011_RevisarInformeLetradoMoratoria','','','','','',0,'Revisar informe letrado moratoria',0,'DD',0,'','tareaExterna.cancelarTarea','05',1,'EXTTareaProcedimiento',3,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ011_SolicitarInstrucciones','','','','','',0,'Solicitar instrucciones',0,'DD',0,'','tareaExterna.cancelarTarea','05',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ011_InstruccionesDecision','','','','','',0,'Tarea toma de decisión',0,'DD',0,'','','',0,'EXTTareaProcedimiento',0,'','', null,'','')
	);
	V_TMP_TIPO_TAP T_TIPO_TAP;    
    
    /*
    * ARRAYS TABLA3: DD_PTP_PLAZOS_TAREAS_PLAZAS
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS('','','CJ011_CelebracionVista','damePlazo(valores[''CJ011_RegistrarAdmisionYEmplazamiento''][''fechaSenyalamiento''])',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ011_LecturaInstruccionesMoratoria','1*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ011_PresentarConformidadMoratoria','5*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ011_RegistrarAdmisionYEmplazamiento','damePlazo(valores[''CJ011_RegistrarSolicitudMoratoria''][''fechaSolicitud'']) + 5*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ011_RegistrarInformeMoratoria','damePlazo(valores[''CJ011_RegistrarAdmisionYEmplazamiento''][''fechaNotificacion'']) + 1*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ011_RegistrarResolucion','(valores[''CJ011_CelebracionVista''] != null ? damePlazo(valores[''CJ011_CelebracionVista''][''fechaCelebracion'']) : 6*24*60*60*1000L )',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ011_RegistrarSolicitudMoratoria','5*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ011_RevisarInformeLetradoMoratoria','1*24*60*60*1000L',0,0,'DD'),
		T_TIPO_PLAZAS('','','CJ011_SolicitarInstrucciones','damePlazo(valores[''CJ011_RegistrarResolucion''][''fechaFinMoratoria''])-60*24*60*60*1000L',0,0,'DD')
	); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
        
    /*
    * ARRAYS TABLA4: TFI_TAREAS_FORM_ITEMS
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI ('CJ011_CelebracionVista',0,'label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá dejar indicada la fecha de celebración de la vista, en caso de que no se hubiere celebrado deberá dejar en blanco la fecha de celebración.</p><p>En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene esta pantalla se lanzará la tarea "Registrar resolución".</p></div>','','','','',1,'DML'),
		T_TIPO_TFI ('CJ011_CelebracionVista',1,'date','fechaCelebracion','Fecha celebración','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DML'),
		T_TIPO_TFI ('CJ011_LecturaInstruccionesMoratoria',0,'label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta tarea deber&aacute; de leer las instrucciones dictadas por la entidad respecto a la moratoria.</p><p>Una vez acepte las instrucciones y en funci&oacute;n de los datos introducidos en tareas anteriores, la siguiente tarea ser&aacute; &ldquo;Celebraci&oacute;n de la vista&rdquo;, &ldquo;Registrar resoluci&oacute;n&rdquo; o &ldquo;Presentar escrito de conformidad&rdquo;</p></div>','','','','',0,'DML'),
		T_TIPO_TFI ('CJ011_LecturaInstruccionesMoratoria',1,'textarea','instruccionesMoratoria','Instrucciones moratoria','','','valores[''CJ011_RevisarInformeLetradoMoratoria''] == null ? '''' : (valores[''CJ011_RevisarInformeLetradoMoratoria''][''instruccionesMoratoria''])','',0,'DML'),
		T_TIPO_TFI ('CJ011_LecturaInstruccionesMoratoria',2,'combo','presentarAlegaciones','Presentar alegaciones','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','valores[''CJ011_RevisarInformeLetradoMoratoria''][''comboConformidad'']','DDSiNo',0,'DML'),
		T_TIPO_TFI ('CJ011_PresentarConformidadMoratoria',0,'label','titulo','<div style="margin-bottom: 30px;" align="justify"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Dado que la entidad ha decidido presentar el escrito de conformidad a la moratoria, a través de esta tarea deberá de informar la fecha de presentación de dicho escrito.</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez rellene esta pantalla la siguiente tarea será "Registrar resolución.</span></p></div>','','','','',1,'DML'),
		T_TIPO_TFI ('CJ011_PresentarConformidadMoratoria',1,'date','fechaPresentacion','Fecha presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DML'),
		T_TIPO_TFI ('CJ011_PresentarConformidadMoratoria',2,'textarea','observaciones','Observaciones','','','','',0,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarAdmisionYEmplazamiento',0,'label','titulo','<div style="margin-bottom: 30px;" align="justify"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para dar por terminada esta tarea deberá informar la fecha de notificación de la moratoria, si ha habido admisión o no de la solicitud de moratoria, en caso de haber, indicar si hay vista o no y por último la fecha de señalamiento de la misma.</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez rellene esta pantalla la siguiente tarea será  "Registrar informe moratoria".</span></p></div>','','','','',1,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarAdmisionYEmplazamiento',1,'date','fechaNotificacion','Fecha de notificación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarAdmisionYEmplazamiento',2,'combo','comboAdminEmplaza','Admisión y emplazamiento','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarAdmisionYEmplazamiento',3,'combo','comboVista','Vista','','','','DDSiNo',0,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarAdmisionYEmplazamiento',4,'date','fechaSenyalamiento','Fecha señalamiento','','','','',0,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarAdmisionYEmplazamiento',5,'textarea','observaciones','Observaciones','','','','',0,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarInformeMoratoria',0,'label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta pantalla deber&aacute; dejar constancia si la moratoria solicitada por el deudor es acorde con lo establecido por la ley y por tanto es mejor presentar el escrito de conformidad a la moratoria, o si por el contrario se aprecia disconformidad a la ley y por tanto aconseja presentarse a la vista.</p><p>Una vez complete esta pantalla la siguiente tarea ser&aacute; &ldquo;Revisar informe letrado moratoria&rdquo; por la cual se mostrar&aacute; su informe al supervisor de la entidad para que dicte instrucciones.</p></div>','','','','',0,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarInformeMoratoria',1,'textarea','informeMoratoria','Informe moratoria','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarResolucion',0,'label','titulo','<div style="margin-bottom: 30px;" align="justify"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para dar por terminada esta tarea deberá informar el resultado que se haya dado, ya sea favorable para los intereses de la entidad o no, y solo en caso de haber sido desfavorable  la fecha de fin de la moratoria.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para el supuesto de que la resolución no fuere favorable para la entidad, deberá notificar dicha circunstancia al responsable interno de la misma a través del botón "Anotación" Una vez reciba la aceptación del supervisor deberá gestionar el recurso por medio de la pestaña "Recursos".</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez rellene esta pantalla en caso de resolución favorable para los intereses de la entidad se dará por terminada esta actuación continuando así con la actuación anterior, en caso contrario el sistema esperará hasta 2 meses antes del fin de la moratoria para lanzar la tarea “Solicitar instrucciones”.</span></font></p></div>','','','','',1,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarResolucion',1,'date','fechaResolucion','Fecha resolución','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarResolucion',2,'combo','comboFavDesf','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDFavorable',0,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarResolucion',3,'date','fechaFinMoratoria','Fecha fin de moratoria','','','','',0,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarResolucion',4,'textarea','observaciones','Observaciones','','','','',0,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarSolicitudMoratoria',0,'label','titulo','<div align="justify" style="font-family: Arial; font-size: 8pt; margin-bottom: 30px;"><p style="text-align: justify; font-family: Arial; margin-bottom: 10px;">Antes de dar por completada esta tarea deberá de haber un bien vinculado al procedimiento, esto podrá comprobarlo a través de la pestaña Bienes del procedimiento, en caso de no haberlo, a través de esa misma pestaña dispone de la opción  de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p>En el campo “Fecha solicitud” deberá de informar la fecha en la que se haya producido la solicitud de la moratoria.</p><p>En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez rellene esta pantalla la siguiente tarea será "Registrar admisión y emplazamiento".</p></div>','','','','',1,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarSolicitudMoratoria',1,'date','fechaSolicitud','Fecha de solicitud','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarSolicitudMoratoria',2,'date','fechaFinMoratoria','Fecha fin de moratoria','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DML'),
		T_TIPO_TFI ('CJ011_RegistrarSolicitudMoratoria',3,'textarea','observaciones','Observaciones','','','','',0,'DML'),
		T_TIPO_TFI ('CJ011_RevisarInformeLetradoMoratoria',0,'label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta tarea deber&aacute; revisar el informe realizado por el letrado sobre la moratoria presentada por el demandado. En el campo Instrucciones deber&aacute; introducir las instrucciones a realizar por el letrado respecto a la moratoria. </p><p>En el campo &ldquo;Presentar conformidad&rdquo; deber&aacute; indicar si el letrado debe presentar el escrito de conformidad a la moratoria o no.</p><p>Una vez rellene esta pantalla la siguiente tarea ser&aacute; &rdquo;Lectura instrucciones moratoria&rdquo;.</p></div>','','','','',0,'DML'),
		T_TIPO_TFI ('CJ011_RevisarInformeLetradoMoratoria',1,'textarea','informeMoratoria','Informe moratoria','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','valores[''CJ011_RegistrarInformeMoratoria''] == null ? '''' : (valores[''CJ011_RegistrarInformeMoratoria''][''informeMoratoria''])','',0,'DML'),
		T_TIPO_TFI ('CJ011_RevisarInformeLetradoMoratoria',2,'textarea','instruccionesMoratoria','Instrucciones moratoria','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DML'),
		T_TIPO_TFI ('CJ011_RevisarInformeLetradoMoratoria',3,'combo','comboConformidad','Presentar conformidad','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DML'),
		T_TIPO_TFI ('CJ011_SolicitarInstrucciones',0,'label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que restan dos meses para que expire la fecha de moratoria dictaminada, a través de esta tarea se le informa de que debe obtener instrucciones por parte de la entidad a este respecto.</p><p>En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p>Una vez termine esta tarea se lanzara una toma de decisión por la cual debe indicar la siguiente actuación a realiza.</p></div>','','','','',1,'DML'),
		T_TIPO_TFI ('CJ011_SolicitarInstrucciones',1,'date','fechaInstrucciones','Fecha instrucciones','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DML'),
		T_TIPO_TFI ('CJ011_SolicitarInstrucciones',2,'textarea','observaciones','Observaciones','','','','',0,'DML')
    ); --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila
    V_TMP_TIPO_TFI T_TIPO_TFI;
BEGIN
	/*
    *---------------------------------------------------------------------------------------------------------
    *                                COMIENZO - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
    DBMS_OUTPUT.PUT_LINE('[INICIO-SCRIPT]------------------------------------------------------- ');
    DBMS_OUTPUT.PUT_LINE('    Generacion de datos BPM: '||PAR_TIT_TRAMITE);

    /*
    * LOOP ARRAY BLOCK-CODE: DD_TPO_TIPO_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TPROC;
    V_CODIGO_TPO := 'DD_TPO_CODIGO';
    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT('    [INSERT] '||PAR_ESQUEMA||'.' || PAR_TABLENAME_TPROC || '......');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        
        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '||V_CODIGO_TPO||' = '''||V_TMP_TIPO_TPO(1)||''' Descripcion = '''||V_TMP_TIPO_TPO(2)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO_TPO||' = '''||V_TMP_TIPO_TPO(1)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE '||V_CODIGO_TPO||' = '''|| V_TMP_TIPO_TPO(1) ||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| PAR_ESQUEMA ||'.' || PAR_TABLENAME_TPROC || ' (' ||
                        'DD_TPO_ID,DD_TPO_CODIGO,DD_TPO_DESCRIPCION,DD_TPO_DESCRIPCION_LARGA,' ||
                        'DD_TPO_HTML,DD_TPO_XML_JBPM,VERSION,USUARIOCREAR,' ||
                        'FECHACREAR,BORRADO,DD_TAC_ID,DD_TPO_SALDO_MIN,'||
                        'DD_TPO_SALDO_MAX,FLAG_PRORROGA,DTYPE,FLAG_DERIVABLE,FLAG_UNICO_BIEN) ' ||
                        'SELECT ' ||
                        'S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, ' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') || ''',
                             sysdate,' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') || ''',' ||
                             '(SELECT DD_TAC_ID FROM '|| PAR_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
                        '''' || TRIM(V_TMP_TIPO_TPO(10)) || ''',''' 
                             || TRIM(V_TMP_TIPO_TPO(11)) || ''',''' 
                             || TRIM(V_TMP_TIPO_TPO(12)) || ''',' ||
                        '''' || TRIM(V_TMP_TIPO_TPO(13)) || ''',''' 
                             || TRIM(V_TMP_TIPO_TPO(14)) || ''',''' 
                             || TRIM(V_TMP_TIPO_TPO(15)) 
                        || ''' FROM DUAL'; 

                VAR_CURR_ROWARRAY := I;
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');


    /*
    * LOOP ARRAY BLOCK-CODE: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TARPR;
    V_CODIGO_TAP := 'TAP_CODIGO';
    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT('    [INSERT] '||PAR_ESQUEMA||'.' || PAR_TABLENAME_TARPR || '........');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '||V_CODIGO_TAP||' = '''||V_TMP_TIPO_TAP(2)||''' Descripcion = '''||V_TMP_TIPO_TAP(9)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO_TAP||' = '''||V_TMP_TIPO_TAP(2)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE '||V_CODIGO_TAP||' = '''|| V_TMP_TIPO_TAP(2) ||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| PAR_ESQUEMA ||'.' || PAR_TABLENAME_TARPR || ' (' ||
                        'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                        'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                        'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                        'SELECT ' ||
                        'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                        '(SELECT DD_TPO_ID FROM ' || PAR_ESQUEMA || '.' || PAR_TABLENAME_TPROC || ' WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
                        '(SELECT DD_TPO_ID FROM ' || PAR_ESQUEMA || '.' || PAR_TABLENAME_TPROC || ' WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
                        'sysdate,''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
                        '(SELECT DD_TGE_ID FROM ' || PAR_ESQUEMA || '.DD_TGE_TIPO_GESTION WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' || 
                        '(SELECT DD_STA_ID FROM ' || PAR_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' 
                             ||'(select dd_tge_id from ' || PAR_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo='''|| REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || '''),''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') 
                        || ''' FROM DUAL';

                VAR_CURR_ROWARRAY := I;
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');



    /*
    * LOOP ARRAY BLOCK-CODE: DD_PTP_PLAZOS_TAREAS_PLAZAS
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TPLAZ;
    V_CODIGO_PLAZAS := 'TAP_CODIGO';
    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT('    [INSERT] '||PAR_ESQUEMA||'.' || PAR_TABLENAME_TPLAZ || '....');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '||V_CODIGO_PLAZAS||' = '''||V_TMP_TIPO_PLAZAS(3)||''' Descripcion = '''||V_TMP_TIPO_PLAZAS(4)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO_PLAZAS||' = '''||V_TMP_TIPO_PLAZAS(3)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''|| V_TMP_TIPO_PLAZAS(3) ||''') ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| PAR_ESQUEMA ||'.' || PAR_TABLENAME_TPLAZ || 
                        '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
                        'SELECT ' ||
                        'S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
                        '(SELECT DD_JUZ_ID FROM ' || PAR_ESQUEMA || '.DD_JUZ_JUZGADOS_PLAZA WHERE DD_JUZ_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(1)) || '''), ' ||
                        '(SELECT DD_PLA_ID FROM ' || PAR_ESQUEMA || '.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(2)) || '''), ' ||
                        '(SELECT TAP_ID FROM ' || PAR_ESQUEMA || '.' || PAR_TABLENAME_TARPR || ' WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(3)) || '''), ' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(5)),'''','''''') || ''','   ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(6)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || 
                        ''', sysdate FROM DUAL'; 

                VAR_CURR_ROWARRAY := I;
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');



    /*
    * LOOP ARRAY BLOCK-CODE: TFI_TAREAS_FORM_ITEMS
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TFITE;
    V_CODIGO1_TFI := 'TAP_CODIGO';
    V_CODIGO2_TFI := 'TFI_NOMBRE';
    VAR_CURR_ROWARRAY := 0;
    DBMS_OUTPUT.PUT('    [INSERT] '||PAR_ESQUEMA||'.' || PAR_TABLENAME_TFITE || '..........');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);

        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
        -----------------------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigos '||V_CODIGO1_TFI||' = '''||V_TMP_TIPO_TFI(1)||''', '||V_CODIGO2_TFI||' = '''||V_TMP_TIPO_TFI(4)||''' Descripcion = '''||V_TMP_TIPO_TFI(5)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||VAR_CURR_TABLE||', con codigo '||V_CODIGO1_TFI||' = '''||V_TMP_TIPO_TFI(1)||''', '||V_CODIGO2_TFI||' = '''||V_TMP_TIPO_TFI(4)||'''...'); 

        V_SQL := 'SELECT COUNT(1) FROM '||PAR_ESQUEMA||'.'||VAR_CURR_TABLE||' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE '||V_CODIGO1_TFI||' = '''||V_TMP_TIPO_TFI(1)||''') AND '||V_CODIGO2_TFI||' = '''||V_TMP_TIPO_TFI(4)||''' ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en '||VAR_CURR_TABLE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK - NO existe');

            V_MSQL := 'INSERT INTO '|| PAR_ESQUEMA ||'.' || PAR_TABLENAME_TFITE || 
                        '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                        'SELECT ' ||
                        'S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                        '(SELECT TAP_ID FROM ' || PAR_ESQUEMA || '.' || PAR_TABLENAME_TARPR || ' WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(2)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
                        '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(10)),'''','''''') || ''',''' 
                             || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || 
                        ''',sysdate,0 FROM DUAL';

                VAR_CURR_ROWARRAY := I;
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
                EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');
    
    /*
	 * ---------------------------------------------------------------------------------------------------------
	 * 								ACTUALIZACIONES
	 * ---------------------------------------------------------------------------------------------------------
	 */
	EXECUTE IMMEDIATE 'UPDATE TAP_TAREA_PROCEDIMIENTO SET DD_TPO_ID_BPM = (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO=''' || V_COD_PROCEDIMIENTO || ''') WHERE TAP_CODIGO = ''H025_BPMTramiteCostas''';
	
    /*
    * COMMIT ALL BLOCK-CODE
    *---------------------------------------------------------------------
    */
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
    /*
    *---------------------------------------------------------------------------------------------------------
    *                                FIN - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
	
EXCEPTION

    /*
    *---------------------------------------------------------------------------------------------------------
    *                                   TRATAMIENTO DE EXCEPCIONES
    *---------------------------------------------------------------------------------------------------------
    */
    WHEN OTHERS THEN
        /*
        * EXCEPTION: WHATEVER ERROR
        *---------------------------------------------------------------------
        */     
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT('[KO]');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          IF (ERR_NUM = -1427 OR ERR_NUM = -1) THEN
            DBMS_OUTPUT.put_line('[INFO] Ya existen los registros de este script insertados en la tabla '||VAR_CURR_TABLE
                              ||'. Encontrada fila num '||VAR_CURR_ROWARRAY||' de su array.');
            DBMS_OUTPUT.put_line('[INFO] Ejecute el script de limpieza del tramite '||PAR_TIT_TRAMITE||' y vuelva a ejecutar.');
          END IF;
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line('SQL que ha fallado:');
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('[ROLLBACK ALL].............................................');
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line('Contacto incidencia.....: '||PAR_AUTHOR);
          DBMS_OUTPUT.put_line('Email...................: '||PAR_AUTHOR_EMAIL);
          DBMS_OUTPUT.put_line('Telf....................: '||PAR_AUTHOR_TELF);
          DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');                    
          RAISE;
END;          
/ 
EXIT;
