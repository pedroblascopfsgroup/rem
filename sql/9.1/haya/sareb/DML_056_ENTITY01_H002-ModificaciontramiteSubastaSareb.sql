--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20150910
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.5-hy-rc02
--## INCIDENCIA_LINK=HR-989
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite subasta sareb
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_COD_PROCEDIMIENTO VARCHAR (20 CHAR) := 'H002';
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear


    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(

	    T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H002_SolicitarTasacion',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ 'comprobarExisteDocumentoINFTAVA() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Informe de tasación / valoración al procedimiento.</div>'' ',
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Solicitar tasación',
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
        /*DD_STA_ID(FK)................:*/ '801',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'SSUB',
        /*TAP_BUCLE_BPM................:*/ null        
        ),
        
        T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H002_InformarTipoPropuesta',
        /*TAP_VIEW.....................:*/ 'plugin/procedimientos-bpmHaya-plugin/tramiteSubasta/informarTipoPropuesta',
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Informar del tipo de propuesta',
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
        /*DD_STA_ID(FK)................:*/ '816',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'SSUB',
        /*TAP_BUCLE_BPM................:*/ null        
        ),
        
        T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ V_COD_PROCEDIMIENTO,
        /*TAP_CODIGO...................:*/ 'H002_ElevarAComite',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ null,
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Elevar propuesta a comité',
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
        /*DD_STA_ID(FK)................:*/ '817',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'DULI',
        /*TAP_BUCLE_BPM................:*/ null        
        )
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null,null,'H002_SolicitarTasacion','3*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H002_InformarTipoPropuesta','2*24*60*60*1000L','0','0','DD'),
		T_TIPO_PLAZAS(null,null,'H002_ElevarAComite','3*24*60*60*1000L','0','0','DD')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('H002_SolicitarTasacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; informar de la fecha en que solicita la tasaci&oacute;n a Sareb  y debe informar del numero de propuesta Sareb si la solicitud ha sido solicitado via workflow, as&iacute; como deber&aacute; adjuntar desde la pesta&ntilde;a de "Adjuntos" de la actuaci&oacute;n el informe de tasaci&oacute;n/valoraci&oacute;n.</p><p style="margin-bottom: 10px">Segun instrucciones de Sareb la tasaci&oacute;n ser&aacute; v&aacute;lida de todos los bienes si la fecha de tasaci&oacute;n es menor a 18 meses.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),	
		T_TIPO_TFI('H002_SolicitarTasacion','1','date','fecha','Fecha solicitud','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H002_SolicitarTasacion','2','number','numPropuestaSareb','Núm. Propuesta Sareb',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H002_SolicitarTasacion','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H002_InformarTipoPropuesta','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, el gestor de litigios debera indicar si  la propuesta de subasta es delegada o no es delegada.</p><p style="margin-bottom: 10px">En el caso que se indique que  la propuesta es No Delegada, deber&aacute; indicar el Numero de propuesta sareb y adjuntar la plantilla de workflow para que en la tarea siguiente "Cumplimentar parte economica de la propuesta de subasta", el gestor de Soporte Deuda cumplimente la carga de activos sobre la plantilla de la propuesta Sareb.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p></div>',null,null,null,null,'0','DD'),	
		T_TIPO_TFI('H002_InformarTipoPropuesta','1','combo','comboDelegada','Propuesta Subasta Delegada','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD'),
		T_TIPO_TFI('H002_InformarTipoPropuesta','2','number','numPropuestaSareb','Núm. Propuesta Sareb',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H002_InformarTipoPropuesta','3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H002_ElevarAComite','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; elevar la propuesta de subasta al comit&eacute; para su aprobaci&oacute;n informando de la fecha en que eleva la propuesta.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>',null,null,null,null,'0','DD'),	
		T_TIPO_TFI('H002_ElevarAComite','1','date','fecha','Fecha que se eleva la propuesta','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H002_ElevarAComite','2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD'),
		T_TIPO_TFI('H002_ActualizarTasacion','1','date','fecha','Fecha recepción','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD'),
		T_TIPO_TFI('H002_CumplimentarParteEconomica','1','combo','comboDelegada','Propuesta Subasta Delegada','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','valores[''H002_InformarTipoPropuesta''][''comboDelegada'']','DDSiNo','0','DD'),
		T_TIPO_TFI('H002_CumplimentarParteEconomica','2','number','numPropuestaSareb','Núm. Propuesta Sareb',null,null,'valores[''H002_InformarTipoPropuesta''][''numPropuestaSareb'']',null,'0','DD'),
		T_TIPO_TFI('H002_CumplimentarParteEconomica','3','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD')
		
		); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	
	
	
	/* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES TAREAS--------------- */
	/* ------------------- --------------------------------- */
	 V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_AUTOPRORROGA = 1 ' ||
			  ' ,TAP_MAX_AUTOP = 1 ' ||
			  ' WHERE TAP_CODIGO = ''H002_SolicitudSubasta''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_SolicitudSubasta actualizada.');
    
     V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SSUB'')' ||
	          ' ,DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''801'')' ||
			  ' WHERE TAP_CODIGO = ''H002_ActualizarTasacion''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ActualizarTasacion actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_AUTOPRORROGA = 1 ' ||
			  ' ,TAP_MAX_AUTOP = 1 ' ||
			  ' ,DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GULI'') ' ||
			  ' WHERE TAP_CODIGO = ''H002_ContactarConDeudorYPrepararInformeSubastaFisc''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ContactarConDeudorYPrepararInformeSubastaFisc actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_DESCRIPCION = ''Validar informe de subasta de letrado y preparar cuadro de pujas'' ' ||
			  ' ,TAP_SCRIPT_DECISION = ''(valores[''''H002_ValidarInformeDeSubastaYPrepararCuadroDePujas''''][''''comboSuspender''''] == DDSiNo.SI ? ''''SuspenderSubasta'''' : (valores[''''H002_ValidarInformeDeSubastaYPrepararCuadroDePujas''''][''''comboRequerida''''] == DDSiNo.SI ? ''''tipoDue'''' : ''''tipo'''') )'' ' ||
	          ' WHERE TAP_CODIGO = ''H002_ValidarInformeDeSubastaYPrepararCuadroDePujas''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ValidarInformeDeSubastaYPrepararCuadroDePujas actualizada.');
    
     V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SSDE'')' ||
	          ' ,DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''805'')' ||
	          ' ,TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H002_CumplimentarParteEconomica''''][''''comboDelegada''''] == DDSiNo.SI ? (comprobarExisteDocumentoINS() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Informe de subasta al procedimiento.</div>'''') : (comprobarExisteDocumentoPSSB() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Plantilla de Subasta Sareb</div>'''')'' ' ||
			  ' ,TAP_VIEW = ''plugin/procedimientos-bpmHaya-plugin/tramiteSubasta/cumplimentarParteEconomica'' ' ||
	          ' WHERE TAP_CODIGO = ''H002_CumplimentarParteEconomica''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_CumplimentarParteEconomica actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SSUB'')' ||
	          ' ,DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''801'')' ||
			  ' WHERE TAP_CODIGO = ''H002_SolicitarDueDiligence''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_SolicitarDueDiligence actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SSUB'')' ||
	          ' ,DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''801'')' ||
			  ' WHERE TAP_CODIGO = ''H002_RegistrarResultadoDueDiligence''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_RegistrarResultadoDueDiligence actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SSUB'')' ||
	          ' ,DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''816'')' ||
	          ' ,TAP_MAX_AUTOP = 1 ' ||
			  ' WHERE TAP_CODIGO = ''H002_PrepararPropuestaSubasta''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_PrepararPropuestaSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''DULI'')' ||
	          ' ,DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''817'')' ||
	          ' ,TAP_DESCRIPCION = ''Registrar resolución del comité'' ' ||
			  ' WHERE TAP_CODIGO = ''H002_ElevarPropuestaAComite''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ElevarPropuestaAComite actualizada.');
    
     V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SSUB'')' ||
	          ' ,DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''816'')' ||
			  ' WHERE TAP_CODIGO = ''H002_ElevarPropuestaASareb''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ElevarPropuestaASareb actualizada.');
    
     V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SSUB'')' ||
	          ' ,DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''816'')' ||
	          ' ,TAP_MAX_AUTOP = 1 ' ||
			  ' WHERE TAP_CODIGO = ''H002_RegistrarRespuestaSareb''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_RegistrarRespuestaSareb actualizada.');
    
    /* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES CAMPOS--------------- */
	/* ------------------- --------------------------------- */
	 V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, el letrado deber&aacute; acceder a la pesta&ntilde;a Subastas del asunto correspondiente y asociar  todos los bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta deber&aacute; indicar a trav&eacute;s de la ficha de cada bien las cargas anteriores y posteriores, si es vivienda habitual o no y la situaci&oacute;n posesoria.</p><p style="margin-bottom: 10px">En el campo Fecha solicitud deber&aacute; informar la fecha en la que haya realizado la solicitud de subasta.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute;n las siguientes tareas:</p><p style="margin-bottom: 10px; margin-left: 40px;">- Se Lanzar&aacute; el tr&aacute;mite de tributaci&oacute;n.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Contactar con el deudor y  preparar informe previo de subasta/fiscal a realizar por el gestor de deuda.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Solicitar tasaci&oacute;n a realizar por el gestor de subastas.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Se&ntilde;alamiento de subasta a realizar por el letrado.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_SolicitudSubasta'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_SolicitudSubasta actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea el gestor de subastas deber&aacute; indicar la fecha de recepci&oacute;n de la tasaci&oacute;n del bien solicitada en la tarea anterior e indicar en Recovery, desde la ficha del bien, en el apartado de Datos economicos, los campos fecha y valor de tasaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_ActualizarTasacion'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ActualizarTasacion actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 2' ||
			  ' WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_ActualizarTasacion'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ActualizarTasacion actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, el gestor de deuda deber&aacute; informar de la fecha en la que se ha puesto en contacto con el deudor y el resultado del acuerdo se lo comunicar&aacute; al supervisor.</p><p style="margin-bottom: 10px">Adem&aacute;s, debe cumplimentar correctamente el informe de gesti&oacute;n para la propuesta de subasta.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>''' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_ContactarConDeudorYPrepararInformeSubastaFisc'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ContactarConDeudorYPrepararInformeSubastaFisc actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; revisar el informe de subasta adjunto al asunto por parte del letrado,  preparar el cuadro de pujas y, determinar:</p><p style="margin-bottom: 10px; margin-left: 40px;">- Si alg&uacute;n bien requiere de una solicitud de Due Diligencie T&eacute;cnica.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Si todos los bienes incluidos por el Letrado en la Subasta han de ser efectivamente subastados o, por el contrario, excluya manualmente los que no deban ser subastados.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Si la subasta ha de suspenderse, indicando el motivo de suspensi&oacute;n de la subasta.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; informar la fecha en la que realiza la revisi&oacute;n del informe.</p><p style="margin-bottom: 10px">Debe comprobar el certificado de cargas y la nota simple y en el caso que tengan una antiguedad superior a 6 meses, deber&aacute; obtener la nota simple  e indicarlo en el campo "Necesario actualizar Nota Simple" y adjuntar la  nota simple actualizada desde la pesta&ntilde;a de "Adjuntos".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p></div>''' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_ValidarInformeDeSubastaYPrepararCuadroDePujas'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ValidarInformeDeSubastaYPrepararCuadroDePujas actualizada.');
    
     V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, el gestor de Soporte Deuda deber&aacute; cumplimentar los datos econ&oacute;micos de la subasta.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Si la propuesta de Subasta es Delegada, debe cumplimentar los datos economicos desde el informe de subasta. Este informe lo podr&aacute; descargar desde la pesta&ntilde;a de Adjuntos de la actuaci&oacute;n y rellenar el apartado de datos economicos y una vez cumplimentados volver a adjuntar el inform de subasta.</p><p style="margin-bottom: 10px; margin-left: 40px;">- Si la propuesta de Subasta es No Delegada, debe cumplimentar la carga de activos del Workflow. Para ello, deber&aacute; descargar la plantilla de workflow de la pesta&ntilde;a de Adjuntos de la actuaci&oacute;n, cumplimentar los datos relativos a la carga de activos y volver a adjuntar  la plantilla a Recovery.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p></div>''' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_CumplimentarParteEconomica'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_CumplimentarParteEconomica actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_ORDEN = 4 ' ||
			  ' WHERE TFI_NOMBRE = ''observaciones'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_CumplimentarParteEconomica'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_CumplimentarParteEconomica actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; registrar la respuesta del Comit&eacute; informando de la fecha de resoluci&oacute;n  y de l resultado del comit&eacute;.:</p><p style="margin-bottom: 10px; margin-left: 40px;">- En el caso que sea aceptada la propuesta por el comit&eacute;, se lanzar&aacute; la siguiente tarea al letrado de "Lectura y Aceptaci&oacute;n de Instrucciones".</p><p style="margin-bottom: 10px; margin-left: 40px;">- En el caso que se requiera de alguna modificaci&oacute;n, se volver&aacute; a la tarea de "Preparar Propuesta Subasta".</p><p style="margin-bottom: 10px; margin-left: 40px;">- En el caso que el Comit&eacute; dictamine la suspensi&oacute;n de la subasta, se lanzar&aacute; la tarea de "Suspender la Subasta".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>''' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_ElevarPropuestaAComite'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ElevarPropuestaAComite actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''Fecha de Resolución''' ||
			  ' WHERE TFI_NOMBRE = ''fechaElevacion'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_ElevarPropuestaAComite'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H002_ElevarPropuestaAComite actualizada.');
    
    /* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES PLAZOS--------------- */
	/* ------------------- --------------------------------- */
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
			  ' SET DD_PTP_PLAZO_SCRIPT = ''5*24*60*60*1000L'' ' ||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_ElevarPropuestaAComite'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H032_ConfirmarPresImpugnacion actualizada.');
	
	  
	/* ------------------- --------------------------------- */
	/* --------------  BORRADO TAREAS--------------- */
	/* ------------------- --------------------------------- */
	V_TAREA:='H002_EsperaPosibleCesionRemate';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Dd_Ptp_Plazos_Tareas_Plazas WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.Tfi_Tareas_Form_Items WHERE TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.tap_Tarea_procedimiento where tap_codigo = '''||V_TAREA||''')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_CODIGO=''BORRAR_'||V_TAREA||''',BORRADO=1,FECHABORRAR=SYSDATE,USUARIOBORRAR=''NACHO'' WHERE TAP_CODIGO='''||V_TAREA||'''';
	
	
	/* ------------------- -------------------------- */
	/* ------------------- -------------------------- */


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