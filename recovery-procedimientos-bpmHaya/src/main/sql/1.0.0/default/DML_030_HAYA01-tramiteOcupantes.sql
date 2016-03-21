/*
--######################################################################
--## Author: Roberto
--## BPM: Trámite de Ocupantes (H048)
--## Finalidad: Insertar datos en tablas de configuración del BPM
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
    PAR_TABLENAME_TPROC VARCHAR2(50 CHAR) := 'DD_TPO_TIPO_PROCEDIMIENTO';   -- [PARAMETRO] TABLA para tipo de procedimiento. Por defecto DD_TPO_TIPO_PROCEDIMIENTO
    V_CODIGO_TPO VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tipo procedimiento

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
		T_TIPO_TPO('H048','T. de ocupantes','T. de ocupantes','','haya_tramiteOcupantes','0','DML','0','AP','','','8','MEJTipoProcedimiento','1','1')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP('H048','H048_ConfirmarVista','','','','valores[''H048_ConfirmarVista''][''comboVista''] == DDSiNo.SI ? ''hayVista'' : ''noHayVista''','','0','Confirmar vista','0','DML','0','','','','0','EXTTareaProcedimiento','3','','39','','GAREO',''),
		
		T_TIPO_TAP('H048','H048_PresentarEscritoAlegaciones','','','','','','0','Presentar escrito de alegaciones','0','DML','0','','tareaExterna.cancelarTarea','','0','EXTTareaProcedimiento','3','','39','','GAREO',''),
		
		T_TIPO_TAP('H048','H048_RegistrarCelebracionVista','','','','','','0','Registrar celebración vista','0','DML','0','','','','0','EXTTareaProcedimiento','3','','39','','GAREO',''),
		
		T_TIPO_TAP('H048','H048_RegistrarInformeSituacion','','comprobarExisteDocumentoISP() ? null : ''Es necesario adjuntar el documento informe de situaci&oacute;n de la posesi&oacute;n''','','','','0','Registrar informe de situación','0','DML','0','','','','0','EXTTareaProcedimiento','3','','39','','GAREO',''),
		
		T_TIPO_TAP('H048','H048_RegistrarRecepcionDoc','','','','','','0','Registrar recepción de la documentación','0','DML','0','','tareaExterna.cancelarTarea','','0','EXTTareaProcedimiento','3','','39','','GAREO',''),
		
		T_TIPO_TAP('H048','H048_RegistrarResolucion','','comprobarExisteDocumentoREOC() ? null : ''Es necesario adjuntar el documento de Resoluci&oacute;n (Ocupantes)''','','','','0','Registrar resolución','0','DML','0','','','','0','EXTTareaProcedimiento','3','','39','','GAREO',''),
		
		T_TIPO_TAP('H048','H048_ResolucionFirme','','','','valores[''H048_RegistrarResolucion''][''comboResultado''] == DDPositivoNegativo.NEGATIVO ? ( vieneDeTramitePosesion() ? ''desfavorableTP'' : ''desfavorable'') : ''favorable''','','0','Resolución firme','0','DML','0','','tareaExterna.cancelarTarea','','0','EXTTareaProcedimiento','3','','39','','GAREO',''),
		
		T_TIPO_TAP('H048','H048_RevisarInformeLetrado','','','','valores[''H048_RevisarInformeLetrado''][''comboResultado''] == ''MOD'' ? ''requiereModificacion'' : (valores[''H048_RevisarInformeLetrado''][''comboResultado''] == ''HA'' ? ''siHayAleg'' : (valores[''H048_RevisarInformeLetrado''][''comboResultado''] == ''NHASHV'' ? ''noHayAlegSiHayVista'' : ''noHayAlegNoHayVista''))','','1','Revisar informe de letrado','0','DML','0','','tareaExterna.cancelarTarea','','0','EXTTareaProcedimiento','3','','811','','SAREO',''),
		
		T_TIPO_TAP('H048','H048_SolicitudRequerimientoDocOcupantes','','','','','','0','Solicitud de requerimiento documentación de ocupantes','0','DML','0','','tareaExterna.cancelarTarea','','0','EXTTareaProcedimiento','3','','39','','GAREO',''),
		
		T_TIPO_TAP('H048','H048_TrasladoDocuDeteccionOcupantes','','comprobarBienAsociadoPrc() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>!Atenci&oacute;n! Para dar por completada esta tarea deber&aacute; vincular un bien al procedimiento.</p></div>''','','valores[''H048_TrasladoDocuDeteccionOcupantes''][''comboDocumentacion''] == DDSiNo.SI ? ''conDocumentacion'' : ''sinDocumentacion''','','0','Traslado de documentación detección de ocupantes','0','DML','0','','','','0','EXTTareaProcedimiento','3','','39','','GAREO','')
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS('','','H048_ConfirmarVista','1*24*60*60*1000L','0','0','DML'),
		T_TIPO_PLAZAS('','','H048_RevisarInformeLetrado','5*24*60*60*1000L','0','0','DML'),
		T_TIPO_PLAZAS('','','H048_SolicitudRequerimientoDocOcupantes','3*24*60*60*1000L','0','0','DML'),
		T_TIPO_PLAZAS('','','H048_RegistrarInformeSituacion','valores[''H048_RegistrarRecepcionDoc''] == null ? (5*24*60*60*1000L): (valores[''H048_RegistrarRecepcionDoc''][''FechaRecepcion''] == null ? (5*24*60*60*1000L) : (damePlazo(valores[''H048_RegistrarRecepcionDoc ''][''fechaRecepcion''])+20*24*60*60*1000L))','0','0','DML'),
		T_TIPO_PLAZAS('','','H048_TrasladoDocuDeteccionOcupantes','3','0','0','DML'),
		T_TIPO_PLAZAS('','','H048_RegistrarRecepcionDoc','damePlazo(valores[''H048_SolicitudRequerimientoDocOcupantes''][''fechaSolicitud''])+20*24*60*60*1000L','0','0','DML'),
		T_TIPO_PLAZAS('','','H048_ResolucionFirme','damePlazo(valores[''H048_RegistrarCelebracionVista''][''fechaResolucion''])+5*24*60*60*1000L','0','0','DML'),
		T_TIPO_PLAZAS('','','H048_PresentarEscritoAlegaciones','5*24*60*60*1000L','0','0','DML'),
		T_TIPO_PLAZAS('','','H048_RegistrarCelebracionVista','1*24*60*60*1000L','0','0','DML'),
		T_TIPO_PLAZAS('','','H048_RegistrarResolucion','valores[''H048_ConfirmarVista''] == null ? 20*24*60*60*1000L : (damePlazo(valores[''H048_ConfirmarVista''][''fechaVista''])+20*24*60*60*1000L)','0','0','DML')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('H048_ConfirmarVista','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta tarea debe confirmar si hay vista o no, en caso de haberla deberá de consignar la fecha de celebración de la misma.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea, en caso de haber vista "Registrar vista" y en caso contrario "Registrar resolución".</p></div>','','','','','0','DML'),
		T_TIPO_TFI('H048_ConfirmarVista','1','combo','comboVista','Vista','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo','0','DML'),
		T_TIPO_TFI('H048_ConfirmarVista','2','date','fechaVista','Fecha vista','','','valores[''H048_RegistrarRecepcionDoc''][''fechaVista''] == null ? (valores[''H048_TrasladoDocuDeteccionOcupantes''][''fechaVista'']) : valores[''H048_RegistrarRecepcionDoc''][''fechaVista'']','','0','DML'),
		T_TIPO_TFI('H048_ConfirmarVista','3','textarea','observaciones','Observaciones','','','','','0','DML'),
		
		T_TIPO_TFI('H048_PresentarEscritoAlegaciones','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá de consignar la fecha en que haya presentado las alegaciones en el juzgado. En el campo fecha vista deberá consignar, si procede, la fecha en que ha quedado señalada la vista.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea "Confirmar vista".</p></div>','','','','','0','DML'),
		T_TIPO_TFI('H048_PresentarEscritoAlegaciones','1','date','fechaPresentacion','Fecha presentación','','','','','0','DML'),
		T_TIPO_TFI('H048_PresentarEscritoAlegaciones','2','date','fechaVista','Fecha vista','','','valores[''H048_RegistrarRecepcionDoc''][''fechaVista''] == null ? (valores[''H048_TrasladoDocuDeteccionOcupantes''][''fechaVista'']) : valores[''H048_RegistrarRecepcionDoc''][''fechaVista'']','','0','DML'),
		T_TIPO_TFI('H048_PresentarEscritoAlegaciones','3','textarea','observaciones','Observaciones','','','','','0','DML'),
		
		T_TIPO_TFI('H048_RegistrarCelebracionVista','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Después de celebrada la vista, en esta pantalla debemos de consignar la fecha en la que se ha celebrado. </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; "> En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea "Registrar resolución"</p></div>','','','','','0','DML'),
		T_TIPO_TFI('H048_RegistrarCelebracionVista','1','date','fechaResolucion','Fecha resolucion','','','','','0','DML'),
		T_TIPO_TFI('H048_RegistrarCelebracionVista','2','textarea','observaciones','Observaciones','','','','','0','DML'),
		
		T_TIPO_TFI('H048_RegistrarInformeSituacion','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deberá adjuntar al procedimiento el informe de situación de los ocupantes según el formato establecido por la entidad. Una vez adjuntado el informe deberá consignar el resultado de dicho informe, ya sea positivo o no para los intereses de la entidad y la fecha en que haya dado por finalizada la preparación del informe.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea "Revisar informe de letrado".</p></div>','','','','','0','DML'),
		T_TIPO_TFI('H048_RegistrarInformeSituacion','1','date','fecha','Fecha','','','','','0','DML'),
		T_TIPO_TFI('H048_RegistrarInformeSituacion','2','combo','comboResultado','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDPositivoNegativo','0','DML'),
		T_TIPO_TFI('H048_RegistrarInformeSituacion','3','textarea','observaciones','Observaciones','','','','','0','DML'),
		
		T_TIPO_TFI('H048_RegistrarRecepcionDoc','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deberá de consignar la fecha en que haya recibido la documentación solicitada a los ocupantes.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Los campos Fecha vista y Fecha fin para alegaciones deberá de consignarlos en caso de ya disponer de dicha información.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea "Registrar informe de situación".</p></div>','','','','','0','DML'),
		T_TIPO_TFI('H048_RegistrarRecepcionDoc','1','date','fecha','Fecha','','','','','0','DML'),
		T_TIPO_TFI('H048_RegistrarRecepcionDoc','2','date','fechaVista','Fecha vista','','','','','0','DML'),
		T_TIPO_TFI('H048_RegistrarRecepcionDoc','3','date','fechaFinAle','Fecha fin alegaciones','','','','','0','DML'),
		T_TIPO_TFI('H048_RegistrarRecepcionDoc','4','textarea','observaciones','Observaciones','','','','','0','DML'),
		
		T_TIPO_TFI('H048_RegistrarResolucion','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En ésta pantalla se deberá de consignar la fecha de notificación de la Resolución que hubiere recaído como consecuencia del juicio celebrado. Se indicará si el resultado de dicha resolución ha sido favorable para los intereses de la entidad o no.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para el supuesto de que la resolución no fuere favorable para la entidad, deberá comunicar dicha circunstancia al responsable interno de la misma a través del botón "Comunicación". Una vez reciba la aceptación del supervisor deberá gestionar el recurso por medio de la pestaña "Recursos".</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para el supuesto de anuncio del recurso por la parte contraria se deberá gestionar directamente a través de la pestaña "Recursos".</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla la siguiente tarea será "Resolución firme"</p></div>','','','','','0','DML'),
		T_TIPO_TFI('H048_RegistrarResolucion','1','date','fechaResolucion','Fecha resolucion','','','','','0','DML'),
		T_TIPO_TFI('H048_RegistrarResolucion','2','combo','comboResultado','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDPositivoNegativo','0','DML'),
		T_TIPO_TFI('H048_RegistrarResolucion','3','textarea','observaciones','Observaciones','','','','','0','DML'),
		
		T_TIPO_TFI('H048_ResolucionFirme','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá consignar la fecha en la que la Resolución adquiere firmeza.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla y en caso de haber obtenido una resolución desfavorable y no venir de un trámite de posesión se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad. En caso contrario se dará por terminada la actuación.</p></div>','','','','','0','DML'),
		T_TIPO_TFI('H048_ResolucionFirme','1','date','fechaResolucion','Fecha resolucion','','','','','0','DML'),
		T_TIPO_TFI('H048_ResolucionFirme','2','textarea','observaciones','Observaciones','','','','','0','DML'),
		
		T_TIPO_TFI('H048_RevisarInformeLetrado','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta tarea se le informa de que dispone en la pestaña adjuntos del procedimiento, del informe de situaci&oacute;n de la posesi&oacute;n propuesta por el letrado respecto al bien afecto. En el campo Resultado deber&aacute; indicar su aprobaci&oacute;n o no de dicho informe.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deber&aacute; consignar la fecha en que da por finalizada la revisi&oacute;n del informe propuesto por el letrado. </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene &eacute;sta pantalla y dependiendo de los datos introducidos se podr&aacute;n lanzar las siguientes tareas:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber indicado que el informe requiere de modificaciones se lanzar&aacute; la tarea "Registrar informe de situaci&oacute;n" al letrado.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de no requerir modificaci&oacute;n el informe propuesto por el letrado y de que se haya indicado anteriormente que se deben presentar alegaciones, se lanzar&aacute; la tarea "Presentar escrito de alegaciones" al letrado.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de no requerir modificaci&oacute;n el informe propuesto por el letrado y de que se haya indicado anteriormente que hay vista señalada, se lanzar&aacute; la tarea "Registrar celebraci&oacute;n de la vista".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de no requerir modificaci&oacute;n el informe propuesto por el letrado, de que no haya que presentar alegaciones y que no se haya fijado fecha para la vista, se lanzar&aacute; la tarea "Confirmar vista" al letrado.</li></ul></div>','','','','','0','DML'),
		T_TIPO_TFI('H048_RevisarInformeLetrado','1','date','fecha','Fecha','','','','','0','DML'),
		T_TIPO_TFI('H048_RevisarInformeLetrado','2','combo','comboResultado','Resultado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDResultadoInforme','0','DML'),
		T_TIPO_TFI('H048_RevisarInformeLetrado','3','textarea','observaciones','Observaciones','','','','','0','DML'),
		
		T_TIPO_TFI('H048_SolicitudRequerimientoDocOcupantes','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta tarea deberá consignar la fecha en que haya solicitado el requerimiento de documentación a los ocupantes.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea "Registrar recepción de la documentación".</p></div>','','','','','0','DML'),
		T_TIPO_TFI('H048_SolicitudRequerimientoDocOcupantes','1','date','fechaSolicitud','Fecha solicitud','','','','','0','DML'),
		T_TIPO_TFI('H048_SolicitudRequerimientoDocOcupantes','2','textarea','observaciones','Observaciones','','','','','0','DML'),
		
		T_TIPO_TFI('H048_TrasladoDocuDeteccionOcupantes','0','label','titulo','<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por completada esta tarea deberá de haber un bien vinculado al procedimiento, esto podrá comprobarlo a través de la pestaña Bienes del procedimiento, en caso de no haberlo, a través de esa misma pestaña dispone de la opción de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá confirmar si el bien se encuentra ocupado o no, si dispone de la documentación de detección de ocupantes, en caso afirmativo, deberá indicar si existe o no inquilino y en tal caso la fecha del contrato de arrendamiento y el nombre del arrendatario. </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Los campos Fecha vista y Fecha fin para alegaciones deberá de consignarlos en caso de ya disponer de dicha información.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla en caso de no disponer de la documentación de detección se lanzará la tarea "Solicitud de requerimiento documentación a ocupantes", en caso contrario se lanzará la tarea "Realizar alegaciones".</p></div>','','','','','0','DML'),
		T_TIPO_TFI('H048_TrasladoDocuDeteccionOcupantes','1','combo','comboOcupado','Bien ocupado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo','0','DML'),
		T_TIPO_TFI('H048_TrasladoDocuDeteccionOcupantes','2','combo','comboDocumentacion','Documentacion','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo','0','DML'),
		T_TIPO_TFI('H048_TrasladoDocuDeteccionOcupantes','3','combo','comboInquilino','Existe algún inquilino','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','','DDSiNo','0','DML'),
		T_TIPO_TFI('H048_TrasladoDocuDeteccionOcupantes','4','date','fechaContrato','Fecha contrato arrendamiento','','','','','0','DML'),
		T_TIPO_TFI('H048_TrasladoDocuDeteccionOcupantes','5','text','nombreArrendatario','Nombre arrendatario','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','dameNumAuto()','','0','DML'),
		T_TIPO_TFI('H048_TrasladoDocuDeteccionOcupantes','6','date','fechaVista','Fecha vista','','','','','0','DML'),
		T_TIPO_TFI('H048_TrasladoDocuDeteccionOcupantes','7','date','fechaFinAle','Fecha fin alegaciones','','','','','0','DML'),
		T_TIPO_TFI('H048_TrasladoDocuDeteccionOcupantes','8','textarea','observaciones','Observaciones','','','','','0','DML')
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	

    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'DD_TPO_ID,DD_TPO_CODIGO,DD_TPO_DESCRIPCION,DD_TPO_DESCRIPCION_LARGA,' ||
                    'DD_TPO_HTML,DD_TPO_XML_JBPM,VERSION,USUARIOCREAR,' ||
                    'FECHACREAR,BORRADO,DD_TAC_ID,DD_TPO_SALDO_MIN,'||
                    'DD_TPO_SALDO_MAX,FLAG_PRORROGA,DTYPE,FLAG_DERIVABLE,FLAG_UNICO_BIEN) ' ||
                    'SELECT ' ||
                    'S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') 
                    || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') 
                    || ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') 
                    || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') 
                    || ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') 
                    || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') 
                    || ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') 
                    || ''',sysdate,' 
                    || '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') 
                    || ''',' || '(SELECT DD_TAC_ID FROM '|| V_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(10)) 
                    || ''',''' || TRIM(V_TMP_TIPO_TPO(11)) 
                    || ''',''' || TRIM(V_TMP_TIPO_TPO(12)) 
                    || ''',' || '''' || TRIM(V_TMP_TIPO_TPO(13)) 
                    || ''',''' || TRIM(V_TMP_TIPO_TPO(14)) 
                    || ''',''' || TRIM(V_TMP_TIPO_TPO(15)) 
                    || ''' FROM DUAL'; 

            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
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
                    	'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' 
                    	|| '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' 
                    	|| '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') 
                    	|| ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') 
                    	|| ''',' || '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' 
                    	|| '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') 
                    	|| ''',' || 'sysdate,''' || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') 
                    	|| ''',' || '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') 
                    	|| ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') 
                    	|| ''',' || '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' 
                    	|| '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' 
                    	|| ''''|| REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') 
                    	|| ''',' ||'(select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo='''|| REPLACE(TRIM(V_TMP_TIPO_TAP(22)),'''','''''') || ''')'
                    	|| ',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') 
                    	|| ''' FROM DUAL';
                    
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
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

            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
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
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
            EXECUTE IMMEDIATE V_MSQL;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');

    /*
     * Desactivamos trámites antiguos si existen
     */
    V_CODIGO_TPO := 'DD_TPO_CODIGO';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||PAR_TABLENAME_TPROC||' WHERE '||V_CODIGO_TPO||' = ''P419'' AND BORRADO=0 ';
        
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
	    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||PAR_TABLENAME_TPROC||' SET BORRADO=1 WHERE '||V_CODIGO_TPO||' = ''P419'' AND BORRADO=0 ';
        DBMS_OUTPUT.PUT_LINE('Trámite antiguo desactivado.');
        EXECUTE IMMEDIATE V_SQL; 
	END IF;    
    
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