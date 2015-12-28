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
    PAR_TIT_TRAMITE VARCHAR2(50 CHAR)   := 'Trámite de ocupantes';   -- [PARAMETRO] Título del trámite
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
    V_COD_PROCEDIMIENTO VARCHAR(10 CHAR) := 'CJ048'; -- Código de procedimiento para reemplazar

	/*
    * ARRAY TABLA1: DD_TPO_TIPO_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
    	T_TIPO_TPO(V_COD_PROCEDIMIENTO, 'T. de ocupantes - CJ','T. de ocupantes','','cj_tramiteOcupantes',0,'DML',0,'AP', null, null,8,'MEJTipoProcedimiento',1,1)
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;
    
    /*
    * ARRAY TABLA2: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ048_ConfirmarVista','plugin/cajamar/tramiteOcupantes/confirmarVista','','(valores[''CJ048_ConfirmarVista''][''comboVista''] == DDSiNo.SI && valores[''CJ048_ConfirmarVista''][''fechaVista''] == null) ? ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe rellenar el campo "Fecha vista"</div>'' : null','valores[''CJ048_ConfirmarVista''][''comboVista''] == DDSiNo.SI ? ''hayVista'' : ''noHayVista''','',0,'Confirmar vista',0,'DML',0,'','','',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ048_PresentarEscritoAlegaciones','','','','','',0,'Presentar escrito de alegaciones',0,'DML',0,'','tareaExterna.cancelarTarea','',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ048_RegistrarCelebracionVista','','','','','',0,'Registrar celebración vista',0,'DML',0,'','','',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ048_RegistrarRecepcionDoc','','','','','',0,'Registrar recepción de la documentación',0,'DML',0,'','tareaExterna.cancelarTarea','',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ048_RegistrarResolucion','','comprobarExisteDocumentoREOC() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento de Resoluci&oacute;n (Ocupantes)</div>''','','','',0,'Registrar resolución',0,'DML',0,'','','',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ048_ResolucionFirme','','','','vieneDeTramitePosesion() ? (valores[''CJ048_RegistrarResolucion''][''comboResultado''] == DDPositivoNegativo.NEGATIVO ? ''desfavorable'' : ''favorable'') : ''desfavorableNTP''','',0,'Resolución firme',0,'DML',0,'','tareaExterna.cancelarTarea','',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ048_SolicitudRequerimientoDocOcupantes','','','','','',0,'Solicitud de requerimiento documentación de ocupantes',0,'DML',0,'','tareaExterna.cancelarTarea','',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ048_TrasladoDocuDeteccionOcupantes','','comprobarBienAsociadoPrc() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>!Atenci&oacute;n! Para dar por completada esta tarea deber&aacute; vincular un bien al procedimiento.</p></div>''','valores[''CJ048_TrasladoDocuDeteccionOcupantes''][''comboDocumentacion''] == DDSiNo.SI && (valores[''CJ048_TrasladoDocuDeteccionOcupantes''][''fechaDocumentos''] == null || valores[''CJ048_TrasladoDocuDeteccionOcupantes''][''fechaDocumentos''] == '''') ?  ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe informar el campo "Fecha Documentaci&oacute;n"</div>'' : null','valores[''CJ048_TrasladoDocuDeteccionOcupantes''][''comboDocumentacion''] == DDSiNo.SI ? ''conDocumentacion'' : ''sinDocumentacion''','',0,'Traslado de documentación detección de ocupantes',0,'DML',0,'','','',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ048_ResolucionDecision','','','','','',0,'Tarea toma de decisión',0,'DD',0,'','','',0,'EXTTareaProcedimiento',0,'','', null,'',''),
		T_TIPO_TAP(V_COD_PROCEDIMIENTO,'CJ048_ObtenerAprobacionAlquiler','','','','valores[''CJ048_ObtenerAprobacionAlquiler''][''comboAlegaciones''] == DDSiNo.SI ? ''siHayAleg'' : (valores[''CJ048_ObtenerAprobacionAlquiler''][''comboVista''] == DDSiNo.SI ? ''noHayAlegSiHayVista'' : ''noHayAlegNoHayVista'')','',0,'Obtener aprobación de alquiler',0,'DD',0,'','','',0,'EXTTareaProcedimiento',0,'','', null,'','')
	);
	V_TMP_TIPO_TAP T_TIPO_TAP;    
    
    /*
    * ARRAYS TABLA3: DD_PTP_PLAZOS_TAREAS_PLAZAS
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS('','','CJ048_ConfirmarVista','valores[''CJ048_PresentarEscritoAlegaciones''] != null ? damePlazo(valores[''CJ048_PresentarEscritoAlegaciones''][''fechaPresentacion'']) + 1*24*60*60*1000L : 1*24*60*60*1000L',0,0,'DML'),
		T_TIPO_PLAZAS('','','CJ048_PresentarEscritoAlegaciones','damePlazo(valores[''CJ048_TrasladoDocuDeteccionOcupantes''][''fechaFinAle''])',0,0,'DML'),
		T_TIPO_PLAZAS('','','CJ048_RegistrarCelebracionVista','(valores[''CJ048_ConfirmarVista''] != null && valores[''CJ048_ConfirmarVista''][''fechaVista''] != null && valores[''CJ048_ConfirmarVista''][''fechaVista''] != '''') ? damePlazo(valores[''CJ048_ConfirmarVista''][''fechaVista'']) + 1*24*60*60*1000L : ((valores[''CJ048_RegistrarRecepcionDoc''] != null && valores[''CJ048_RegistrarRecepcionDoc''][''fechaVista''] != null && valores[''CJ048_RegistrarRecepcionDoc''][''fechaVista''] != '''') ? damePlazo(valores[''CJ048_RegistrarRecepcionDoc''][''fechaVista'']) + 1*24*60*60*1000L : ( (valores[''CJ048_TrasladoDocuDeteccionOcupantes''] != null && valores[''CJ048_TrasladoDocuDeteccionOcupantes''][''fechaVista''] != null && valores[''CJ048_TrasladoDocuDeteccionOcupantes''][''fechaVista''] != '''') ? damePlazo(valores[''CJ048_TrasladoDocuDeteccionOcupantes''][''fechaVista'']) + 1*24*60*60*1000L : (1*24*60*60*1000L)) )',0,0,'DML'),
		T_TIPO_PLAZAS('','','CJ048_RegistrarRecepcionDoc','damePlazo(valores[''CJ048_SolicitudRequerimientoDocOcupantes''][''fechaSolicitud''])+20*24*60*60*1000L',0,0,'DML'),
		T_TIPO_PLAZAS('','','CJ048_RegistrarResolucion','valores[''CJ048_ConfirmarVista''] != null && valores[''CJ048_ConfirmarVista''][''fechaVista''] != null && valores[''CJ048_ConfirmarVista''][''fechaVista''] != ''''  ? (damePlazo(valores[''CJ048_ConfirmarVista''][''fechaVista'']) + 20*24*60*60*1000L) :  20*24*60*60*1000L',0,0,'DML'),
		T_TIPO_PLAZAS('','','CJ048_ResolucionFirme','damePlazo(valores[''CJ048_RegistrarResolucion''][''fechaResolucion'']) + 5*24*60*60*1000L',0,0,'DML'),
		T_TIPO_PLAZAS('','','CJ048_SolicitudRequerimientoDocOcupantes','3*24*60*60*1000L',0,0,'DML'),
		T_TIPO_PLAZAS('','','CJ048_TrasladoDocuDeteccionOcupantes','3*24*60*60*1000L',0,0,'DML'),
		T_TIPO_PLAZAS('','','CJ048_ObtenerAprobacionAlquiler','(valores[''CJ048_TrasladoDocuDeteccionOcupantes''][''fechaDocumentos''] != null ? damePlazo(valores[''CJ048_TrasladoDocuDeteccionOcupantes''][''fechaDocumentos'']) : damePlazo(valores[''CJ048_RegistrarRecepcionDoc''][''fecha''])) + 7*24*60*60*1000L',0,0,'DD')
	); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
        
    /*
    * ARRAYS TABLA4: TFI_TAREAS_FORM_ITEMS
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI ('CJ048_ConfirmarVista',0,'label','titulo','<div style="margin-bottom: 30px;" align="justify"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">A través de esta tarea debe confirmar si hay vista o no, en caso de haberla deberá de informar la fecha de celebración de la misma.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez rellene esta pantalla se lanzará la tarea, en caso de haber vista "Registrar vista" y en caso contrario "Registrar resolución".</span></font></p></div>','','','','',2,'DML'),
		T_TIPO_TFI ('CJ048_ConfirmarVista',1,'combo','comboVista','Vista','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DML'),
		T_TIPO_TFI ('CJ048_ConfirmarVista',2,'date','fechaVista','Fecha vista','','','(valores[''CJ048_RegistrarRecepcionDoc''] != null && valores[''CJ048_RegistrarRecepcionDoc''][''fechaVista''] != null) ? (valores[''CJ048_RegistrarRecepcionDoc''][''fechaVista'']) : (valores[''CJ048_TrasladoDocuDeteccionOcupantes''][''fechaVista''])','',0,'DML'),
		T_TIPO_TFI ('CJ048_ConfirmarVista',3,'textarea','observaciones','Observaciones','','','','',0,'DML'),
		T_TIPO_TFI ('CJ048_PresentarEscritoAlegaciones',0,'label','titulo','<div style="margin-bottom: 30px;" align="justify"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">A través de esta pantalla deberá de informar la fecha en que haya presentado las alegaciones en el juzgado. En el campo fecha vista deberá informar, si procede, la fecha en que ha quedado señalada la vista.</span></font></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px;"><span style="font-size: 10.6666669845581px; font-family: Arial;">Una vez rellene esta pantalla se lanzará la tarea "Confirmar vista".</span></p></div>','','','','',1,'DML'),
		T_TIPO_TFI ('CJ048_PresentarEscritoAlegaciones',1,'date','fechaPresentacion','Fecha presentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DML'),
		T_TIPO_TFI ('CJ048_PresentarEscritoAlegaciones',2,'date','fechaVista','Fecha vista','','','(valores[''CJ048_RegistrarRecepcionDoc''] != null && valores[''CJ048_RegistrarRecepcionDoc''][''fechaVista''] != null) ? (valores[''CJ048_RegistrarRecepcionDoc''][''fechaVista'']) : (valores[''CJ048_TrasladoDocuDeteccionOcupantes''][''fechaVista''])','',0,'DML'),
		T_TIPO_TFI ('CJ048_PresentarEscritoAlegaciones',3,'textarea','observaciones','Observaciones','','','','',0,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarCelebracionVista',0,'label','titulo','<div style="margin-bottom: 30px;" align="justify"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Después de celebrada la vista, en esta pantalla debemos de informar la fecha en la que se ha celebrado. </span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;"> En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez rellene esta pantalla se lanzará la tarea "Registrar resolución".</span></font></p></div>','','','','',1,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarCelebracionVista',1,'date','fechaResolucion','Fecha de la vista','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarCelebracionVista',2,'textarea','observaciones','Observaciones','','','','',0,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarRecepcionDoc',0,'label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deberá de informar la fecha en que haya recibido la documentación solicitada a los ocupantes.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Los campos Fecha vista y Fecha fin para alegaciones deberá de informarlos en caso de ya disponer de dicha información.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Obtener aprobación de alquiler".</p></div>','','','','',0,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarRecepcionDoc',1,'date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarRecepcionDoc',2,'combo','comboOcupado','Bien ocupado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarRecepcionDoc',3,'combo','comboDocumentacion','Documentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarRecepcionDoc',4,'combo','comboInquilino','Existe algún inquilino','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarRecepcionDoc',5,'date','fechaContrato','Fecha contrato arrendamiento','','','','DDSiNo',0,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarRecepcionDoc',6,'text','nombreArrendatario','Nombre arrendatario','','','','DDSiNo',0,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarRecepcionDoc',7,'date','fechaVista','Fecha vista','','','(valores[''CJ048_TrasladoDocuDeteccionOcupantes''][''fechaVista''] != null ? valores[''CJ048_TrasladoDocuDeteccionOcupantes''][''fechaVista''] : null)','',0,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarRecepcionDoc',8,'date','fechaFinAle','Fecha fin alegaciones','','','(valores[''CJ048_TrasladoDocuDeteccionOcupantes''][''fechaFinAle''] != null ? valores[''CJ048_TrasladoDocuDeteccionOcupantes''][''fechaFinAle''] : null)','',0,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarRecepcionDoc',9,'textarea','observaciones','Observaciones','','','','',0,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarResolucion',0,'label','titulo','<div style="margin-bottom: 30px;" align="justify"><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En ésta pantalla se deberá de informar la fecha de notificación de la Resolución que hubiere recaído como consecuencia del juicio celebrado. Se indicará si el resultado de dicha resolución ha sido favorable para los intereses de la entidad o no.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para el supuesto de que la resolución no fuere favorable para la entidad, deberá notificación dicha circunstancia al responsable interno de la misma a través del botón "Anotación". Una vez reciba la aceptación del supervisor deberá gestionar el recurso por medio de la pestaña "Recursos".</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Para el supuesto de anuncio del recurso por la parte contraria se deberá gestionar directamente a través de la pestaña "Recursos".</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></font></p><p style="margin-bottom: 10px;"><font face="Arial"><span style="font-size: 10.6666669845581px;">Una vez rellene ésta pantalla la siguiente tarea será "Resolución firme".</span></font></p></div>','','','','',1,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarResolucion',1,'date','fechaResolucion','Fecha resolucion','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarResolucion',2,'combo','comboResultado','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDPositivoNegativo',0,'DML'),
		T_TIPO_TFI ('CJ048_RegistrarResolucion',3,'textarea','observaciones','Observaciones','','','','',0,'DML'),
		T_TIPO_TFI ('CJ048_ResolucionFirme',0,'label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá informar la fecha en la que la Resolución adquiere firmeza.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla y en caso de haber obtenido una resolución desfavorable y no venir de un trámite de posesión se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad. En caso contrario se dará por terminada la actuación.</p></div>','','','','',0,'DML'),
		T_TIPO_TFI ('CJ048_ResolucionFirme',1,'date','fechaResolucion','Fecha resolucion','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DML'),
		T_TIPO_TFI ('CJ048_ResolucionFirme',2,'textarea','observaciones','Observaciones','','','','',0,'DML'),
		T_TIPO_TFI ('CJ048_SolicitudRequerimientoDocOcupantes',0,'label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta tarea deberá informar la fecha en que haya solicitado el requerimiento de documentación a los ocupantes.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea "Registrar recepción de la documentación".</p></div>','','','','',0,'DML'),
		T_TIPO_TFI ('CJ048_SolicitudRequerimientoDocOcupantes',1,'date','fechaSolicitud','Fecha solicitud','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DML'),
		T_TIPO_TFI ('CJ048_SolicitudRequerimientoDocOcupantes',2,'textarea','observaciones','Observaciones','','','','',0,'DML'),
		T_TIPO_TFI ('CJ048_TrasladoDocuDeteccionOcupantes',0,'label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por completada esta tarea deberá de haber un bien vinculado al procedimiento, esto podrá comprobarlo a través de la pestaña Bienes del procedimiento, en caso de no haberlo, a través de esa misma pestaña dispone de la opción de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá confirmar si el bien se encuentra ocupado o no, si dispone de la documentación de detección de ocupantes, en caso afirmativo, deberá indicar si existe o no inquilino y en tal caso la fecha del contrato de arrendamiento y el nombre del arrendatario. </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Los campos Fecha vista y Fecha fin para alegaciones deberá de informarlos en caso de ya disponer de dicha información.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla en caso de no disponer de la documentación de detección se lanzará la tarea "Solicitud de requerimiento documentación a ocupantes", en caso contrario se lanzará la tarea "Obtener aprobación alquiler".</p></div>','','','','',0,'DML'),
		T_TIPO_TFI ('CJ048_TrasladoDocuDeteccionOcupantes',1,'combo','comboOcupado','Bien ocupado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DML'),
		T_TIPO_TFI ('CJ048_TrasladoDocuDeteccionOcupantes',2,'combo','comboDocumentacion','Documentacion','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DML'),
		T_TIPO_TFI ('CJ048_TrasladoDocuDeteccionOcupantes',3,'date','fechaDocumentos','Fecha Documentación','','','','',0,'DML'),
		T_TIPO_TFI ('CJ048_TrasladoDocuDeteccionOcupantes',4,'combo','comboInquilino','Existe algún inquilino','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DML'),
		T_TIPO_TFI ('CJ048_TrasladoDocuDeteccionOcupantes',5,'date','fechaContrato','Fecha contrato arrendamiento','','','','',0,'DML'),
		T_TIPO_TFI ('CJ048_TrasladoDocuDeteccionOcupantes',6,'text','nombreArrendatario','Nombre arrendatario','','','dameNumAuto()','',0,'DML'),
		T_TIPO_TFI ('CJ048_TrasladoDocuDeteccionOcupantes',7,'date','fechaVista','Fecha vista','','','','',0,'DML'),
		T_TIPO_TFI ('CJ048_TrasladoDocuDeteccionOcupantes',8,'date','fechaFinAle','Fecha fin alegaciones','','','','',0,'DML'),
		T_TIPO_TFI ('CJ048_TrasladoDocuDeteccionOcupantes',9,'textarea','observaciones','Observaciones','','','','',0,'DML'),
		T_TIPO_TFI ('CJ048_ObtenerAprobacionAlquiler',0,'label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; obtener las conclusiones sobre la renta y el contrato de alquiler emitidos por el departamento de alquileres.</p><p style="margin-bottom: 10px">En el campo "Contrato v&aacute;lido" deber&aacute; indicar si las condiciones del contrato hacen que no sea sospechoso de ser un contrato falso. En caso de de ser v&aacute;lido y decida subrogarse al contrato de alquiler y no presentar alegaciones deber&aacute; ir a la pestaña del bien y marcar la opci&oacute;n de Alquilado a S&iacute;.</p><p style="margin-bottom: 10px">En caso de que el contrato no sea v&aacute;lido, deber&aacute; anotar si presenta alegaciones y/o hay vista y su fecha de celebraci&oacute;n.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; informar la fecha en que da por finalizada la revisi&oacute;n del informe.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y dependiendo de los datos introducidos se podr&aacute;n lanzar las siguientes tareas:<ul style="list-style-type:square;margin-left:35px;"><li>En caso de que la renta y el contrato sean v&aacute;lidos y por tanto no presente alegaciones ni haya vista, se lanzar&aacute; la tarea "Registrar resoluci&oacute;n".</li><li>En caso de que se haya indicado anteriormente que hay vista señalada, se lanzar&aacute; la tarea "Registrar celebraci&oacute;n de la vista".</li><li>En caso de que vaya a presentar alegaciones, se lanzar&aacute; la tarea "Presentar escrito de alegaciones".</li></ul></p></div>','','','','',0,'DD'),
		T_TIPO_TFI ('CJ048_ObtenerAprobacionAlquiler',1,'date','fechaFinRevision','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','',0,'DD'),
		T_TIPO_TFI ('CJ048_ObtenerAprobacionAlquiler',2,'combo','comboContrato','Contrato válido','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ048_ObtenerAprobacionAlquiler',3,'combo','comboAlegaciones','Alegaciones','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ048_ObtenerAprobacionAlquiler',4,'combo','comboVista','Vista','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo',0,'DD'),
		T_TIPO_TFI ('CJ048_ObtenerAprobacionAlquiler',5,'date','fechaVista','Fecha vista','','','','',0,'DD'),
		T_TIPO_TFI ('CJ048_ObtenerAprobacionAlquiler',6,'textarea','observaciones','Observaciones','','','','',0,'DD')
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
