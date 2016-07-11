--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20160118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=0
--## PRODUCTO=SI
--##
--## Finalidad: Realiza las inserciones del trámite de Obtención Documento CEE.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
    /* ##############################################################################
    ## INSTRUCCIONES - DATOS DEL TRÁMITE
    ## Modificar sólo los siguientes datos.
    ## 
     */
    
    V_TIPO_ACT_COD VARCHAR2(20 CHAR):=		'GES';
    V_TIPO_ACT_DES VARCHAR2(50 CHAR):=		'Gestión';	
    V_TPO_COD VARCHAR2(20 CHAR):= 			'T003';
    V_TPO_DES VARCHAR2(100 CHAR):=			'Trámite de obtención documental CEE';
    V_TPO_XML VARCHAR2(50 CHAR):=			'activo_tramiteDocumentalCEE';
    
    
    /* TABLAS: TAP_TAREA_PROCEDIMIENTO & DD_PTP_PLAZOS_TAREAS_PLAZAS */
    TYPE T_TAP IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TAP;
    V_TAP T_ARRAY_TAP := T_ARRAY_TAP(
    --	TAP_CODIGO
    --	TAP_DESCRIPCION
    --	DD_STA_CODIGO
    --	TAP_MAX_AUTOP
    -- 	DD_TGE_CODIGO
    --	DD_PTP_PLAZO_SCRIPT
    --	DD_TPO_ID_BPM
    --	TAP_SCRIPT_VALIDACION
    --	TAP_SCRIPT_VALIDACION_JBPM
    --	TAP_SCRIPT_DECISION
    	T_TAP('T003_AnalisisPeticion',
    			'Análisis de la petición',
    			'811',
    			'3',
    			'GACT',
    			'3*24*60*60*1000L',
    			'NULL',
    			'',
    			'valores[''''T003_AnalisisPeticion''''][''''comboTramitar''''] == DDSiNo.NO ? (valores[''''T003_AnalisisPeticion''''][''''motivoDenegacion''''] == '''''''' ? ''''Si deniega la tramitaci&oacute; debe indicar un motivo'''' : null) : null',
    			'valores[''''T003_AnalisisPeticion''''][''''comboTramitar''''] == DDSiNo.NO ? ''''KO'''' : (valores[''''T003_AnalisisPeticion''''][''''comboSaldo''''] == DDSiNo.SI ? ''''OKConSaldo'''' : ''''OKSinSaldo'''')'),

    	T_TAP('T003_EmisionCertificado',
    			'Emisión certificado',
    			'811',
    			'3',
    			'TECN',
    			'3*24*60*60*1000L',
    			'NULL',
    			'comprobarExisteAdjuntoActivo(''''11'''') ? null : ''''Debe adjuntarse previamente copia del certificado de CEE.''''',
    			'',
    			'valores[''''T003_EmisionCertificado''''][''''comboProcede''''] == DDSiNo.SI ? ''''ConEtiqueta'''' : ''''SinEtiqueta'''' '),

    	T_TAP('T003_SolicitudEtiqueta',
    			'Solicitud etiqueta',
    			'811',
    			'3',
    			'TECN',
    			'3*24*60*60*1000L',
    			'NULL',
    			'',
    			'',
    			''),

    	T_TAP('T003_ObtencionEtiqueta',
    			'Obtención etiqueta',
    			'811',
    			'3',
    			'TECN',
    			'3*24*60*60*1000L',
    			'NULL',
    			'comprobarExisteAdjuntoActivo(''''11'''') ? null : ''''Debe adjuntarse previamente copia del certificado de CEE, a la ficha del activo''''',
    			'',
    			''),

		T_TAP('T003_CierreEconomico',
				'Cierre económico',
				'811',
				'3',
				'GACT',
				'3*24*60*60*1000L',
				'NULL',
				'',
				'',
				''),

		T_TAP('T003_SolicitudExtraordinaria',
				'Solicitud de disposición extraordinaria al propietario',
				'811',
				'3',
				'GACT',
				'3*24*60*60*1000L',
				'NULL',
				'',
				'',
				''),

		T_TAP('T003_AutorizacionPropietario',
				'Autorización del propietario',
				'811',
				'3',
				'GACT',
				'3*24*60*60*1000L',
				'NULL',
				'',
				'(valores[''''T003_AutorizacionPropietario''''][''''comboAmpliacion''''] == DDSiNo.SI && valores[''''T003_AutorizacionPropietario''''][''''numIncremento''''] == '''''''' ) ? ''''En caso de que se conceda la ampliaci&oacute;n de presupuesto solicitada, deber&aacute; anotar su importe'''' : null',
				'valores[''''T003_AutorizacionPropietario''''][''''comboAmpliacion''''] == DDSiNo.SI ? ''''OK'''' : ''''KO'''' ')
    );
    V_TMP_T_TAP T_TAP;

    
    /* TABLA: TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    --		   TAP_CODIGO						TFI_ORDEN	TFI_TIPO	TFI_NOMBRE				TFI_LABEL																																																																																		TFI_ERROR_VALIDACION											TFI_VALIDACION									TFI_BUSINESS_OPERATION
    	T_TFI('T003_AnalisisPeticion'			,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Se ha formulado una solicitud para la emisión de un Certificado de Eficiencia Energética (CEE), por lo que en la presente tarea deberá anotar si acepta o no la petición y se solicita la emisión del CEE al técnico correspondiente.</p><p>Si deniega la petición, deberá hacer constar el motivo y finalizará el trámite.</p><p>Si acepta la petición, deberá indicar la tarifa que resulta de aplicación en la pestaña "gestión económica" del trabajo y, tras ello, comprobar si el importe resultante supera el límite presupuestario asignado al activo.</p><p>En el caso de que haya saldo suficiente, la siguiente tarea será la de "emisión certificado" y se lanzará al técnico encargado de emitir el CEE.</p><p>Por el contrario, en el caso de que no haya saldo suficiente asociado al activo, la siguiente tarea será la de "solicitud de disposición extraordinaria al propietario".</p><p>En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'																																											,''																,''												,''					),
    	T_TFI('T003_AnalisisPeticion'			,'1'		,'combo'	,'comboTramitar'		,'Tramitar petición'																																																																															,''																,''												,'DDSiNo'			),
       	T_TFI('T003_AnalisisPeticion'			,'2'		,'textfield','motivoDenegacion'		,'Motivo de denegación'																																																																															,''																,''												,''					),
    	T_TFI('T003_AnalisisPeticion'			,'3'		,'textinf'	,'saldoDisponible'		,'Saldo disponible'																																																																																,''																,''												,''			),   
    	T_TFI('T003_AnalisisPeticion'			,'4'		,'combo'	,'comboSaldo'			,'Saldo positivo'																																																																																,''																,''												,'DDSiNo'			),
    	T_TFI('T003_AnalisisPeticion'			,'5'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''					),
    	T_TFI('T003_EmisionCertificado'			,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá adjuntar previamente copia del certificado de CEE a la pestaña "documentos" del trabajo, haciendo constar en el campo correspondiente de esta tarea la fecha en que se ha emitido el documento así como la calificación resultante.</p><p style="margin-bottom: 10px">Si una vez emitido el certificado no fuese preceptiva su inscripción ni la obtención de la etiqueta correspondiente, deberá indicarse así.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'																		,''																,''												,''					),
		T_TFI('T003_EmisionCertificado'			,'1'		,'date'		,'fechaEmision'			,'Fecha emisión certificado CEE'																																																																												,'Debe indicar la fecha de emisi&oacute;n del documento'		,'false'										,''					),
		T_TFI('T003_EmisionCertificado'			,'2'		,'combo'	,'comboCalificacion'	,'Calificación energética'																																																																														,''																,''												,'DDTipoCalificacionEnergetica'	),
		T_TFI('T003_EmisionCertificado'			,'3'		,'combo'	,'comboProcede'			,'Procede la inscripción y obtención de etiqueta'																																																																								,''																,''												,'DDSiNo'			),
		T_TFI('T003_EmisionCertificado'			,'4'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''					),
		T_TFI('T003_SolicitudEtiqueta'			,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">En esta tarea deberá hacer constar la fecha en que ha presentado a inscripción el certificado y ha solicitado la emisión de la etiqueta correspondiente.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe ser tenido en cuenta en este punto del trámite.</p>'																																,''																,''												,''					),
		T_TFI('T003_SolicitudEtiqueta'			,'1'		,'date'		,'fechaPresentacion'	,'Fecha presentación a inscripción'																																																																												,'Debe indicar la fecha de presentaci&oacute;n'					,'false'										,''					),
		T_TFI('T003_SolicitudEtiqueta'			,'2'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''					),
		T_TFI('T003_ObtencionEtiqueta'			,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Previamente a la cumplimentación de la presente tarea, deberá subir a la pestaña "documentos" del trabajo la etiqueta de eficiencia energética así como el documento justificativo del registro.</p><p style="margin-bottom: 10px">Una vez subidos los documentos, deberá hacer constar la fecha en que se han obtenido así como su referencia.</p><p style="margin-bottom: 10px">Si ha satisfecho algún suplido en concepto de tasa administrativa, deberá hacer constar su importe en la pestaña "gestión económica" del trabajo.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe ser tenido en cuenta en este punto del trámite.</p>'                                                                                                                               ,''                                                             ,''                                             ,''                 ),
		T_TFI('T003_ObtencionEtiqueta'			,'1'		,'date'		,'fechaInscripcion'		,'Fecha inscripción y expedición etiqueta'																																																																										,'Debe indicar la fecha de inscripci&oacute;n'					,'false'										,''					),
		T_TFI('T003_ObtencionEtiqueta'			,'2'		,'textfield','refEtiqueta'			,'Referencia de la etiqueta de eficiencia energética'																																																																							,''																,''												,''					),
		T_TFI('T003_ObtencionEtiqueta'			,'3'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''					),
		T_TFI('T003_CierreEconomico'			,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para dar por cumplimentada esta tarea deberá realizar el cierre económico del trabajo.</p><p>Para ello, si no lo ha hecho previamente, deberá seleccionar la tarifa que resulta de aplicación en la pestaña "gestión económica" del trabajo, cumplimentando a continuación, en su caso, los importes correspondientes a cada uno de sus bloques.</p><p>Debe tener en cuenta que, una vez cumplimentada esta tarea, ya no podrá modificar los importes que se hayan hecho constar en la pestaña de "gestión económica", que serán los que se tomarán para el proceso de facturación.</p><p>En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p><p>Esta tarea pone fin al trámite de emisión de CEE.</p>'																														,''																,''												,''					),
		T_TFI('T003_CierreEconomico'			,'1'		,'date'		,'fechaCierre'			,'Fecha cierre económico'																																																																														,'Debe indicar la fecha de cierre econ&oacute;mico'				,'false'										,''			        ),
		T_TFI('T003_CierreEconomico'			,'2'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''					),
		T_TFI('T003_SolicitudExtraordinaria'	,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para dar por terminada esta tarea debe hacer constar la fecha en que ha solicitado al propietario del activo una provisión extraordinaria de fondos por no disponer el activo de saldo suficiente para hacer frente al coste del trabajo.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'															,''																,''												,''					),
		T_TFI('T003_SolicitudExtraordinaria'	,'1'		,'date'		,'fecha'				,'Fecha'																																																																																		,'Debe indicar la fecha de solicitud extraordinaria'			,'false'										,''					),
		T_TFI('T003_SolicitudExtraordinaria'	,'2'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''					),
		T_TFI('T003_AutorizacionPropietario'	,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para cumplimentar esta tarea debe anotar la fecha en que ha recibido la respuesta del propietario aceptando o rechazando una ampliación del presupuesto asociado al activo.</p><p style="margin-bottom: 10px">En el caso de que la ampliación del presupuesto sea rechazada por el propietario, el trámite concluirá ya que no podrá llevarse a cabo la actuación por falta de saldo.</p><p style="margin-bottom: 10px">En caso de que se conceda la ampliación de presupuesto solicitada, deberá anotar su importe. La siguiente tarea será la de "emisión certificado".</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'																																,''																,''												,''					),
		T_TFI('T003_AutorizacionPropietario'	,'1'		,'date'		,'fecha'				,'Fecha'																																																																																		,'Debe indicar la fecha de autorizaci&oacute;n'					,'false'										,''					),
		T_TFI('T003_AutorizacionPropietario'	,'2'		,'combo'	,'comboAmpliacion'		,'Ampliación del presupuesto'																																																																													,''																,''												,'DDSiNo'			),
    	T_TFI('T003_AutorizacionPropietario'	,'3'		,'number'	,'numIncremento'		,'Importe del incremento'																																																																														,''																,''												,''					),
		T_TFI('T003_AutorizacionPropietario'	,'4'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''					)		
		);
    V_TMP_T_TFI T_TFI;
    
    
    
 -- ## FIN DATOS DEL TRÁMITE
 -- ########################################################################################
    
    


BEGIN

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] Empezando a insertar datos del BPM '||V_TPO_XML||'.');
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_XML_JBPM = '''||V_TPO_XML||'''';
    EXECUTE IMMEDIATE V_SQL INTO table_count;
    
    IF table_count = 1 THEN
   		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.DD_TPO_TIPO_PROCEDIMIENTO... Ya existe el BPM '||V_TPO_XML||'.');
	ELSE
		-- Insertamos en la tabla dd_tac_tipo_actuacion
--		V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TAC_TIPO_ACTUACION.NEXTVAL FROM DUAL';
--	    	EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
--		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION (' ||
--					'DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) '||
--					'VALUES ('||V_ENTIDAD_ID||','''||V_TIPO_ACT_COD||''','''||V_TIPO_ACT_DES||''','''||V_TIPO_ACT_DES||''',	1, ''REM_F1'', SYSDATE, 0)';
--			EXECUTE IMMEDIATE V_MSQL;
			
		-- Insertamos en la tabla dd_tpo_tipo_procedimiento
		V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO (' ||
					'DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID, FLAG_PRORROGA, DTYPE, FLAG_DERIVABLE, FLAG_UNICO_BIEN) '||
					'VALUES ('||V_ENTIDAD_ID||','''||V_TPO_COD||''','''||V_TPO_DES||''','''||V_TPO_DES||''','''||V_TPO_XML||''', 1, ''REM_F1'', SYSDATE, 0,'||
					'(SELECT DD_TAC_ID FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = '''||V_TIPO_ACT_COD||'''), 1, ''MEJTipoProcedimiento'', 1, 0)';
			EXECUTE IMMEDIATE V_MSQL;
		
		-- Insertamos en la tabla tap_tarea_procedimiento y dd_ptp_plazos_tareas_plazas
		FOR I IN V_TAP.FIRST .. V_TAP.LAST
	      LOOP
	          V_TMP_T_TAP := V_TAP(I);
	          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL FROM DUAL';
	          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
	          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO (' ||
	                      'TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, TAP_DESCRIPCION, '||
	                      'VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_FAP_ID, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID, DD_TGE_ID, DD_TPO_ID_BPM, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_VALIDACION_JBPM, TAP_SCRIPT_DECISION) '||
	                      'VALUES ('||V_ENTIDAD_ID||',(SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||V_TPO_COD||'''),'||
	                      ''''||V_TMP_T_TAP(1)||''', NULL, 0,'''||V_TMP_T_TAP(2)||''', 0, ''REM_F1'', SYSDATE, 0, NULL, 0, ''EXTTareaProcedimiento'', '||
	                      ''''||V_TMP_T_TAP(4)||''', (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = '''||V_TMP_T_TAP(3)||'''),'||
	                      '(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||V_TMP_T_TAP(5)||'''),'||V_TMP_T_TAP(7)||','''||V_TMP_T_TAP(8)||''','''||V_TMP_T_TAP(9)||''','''||V_TMP_T_TAP(10)||''')';
	          DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_T_TAP(1)||''' de '''||V_TPO_XML||''''); 
	          DBMS_OUTPUT.PUT_LINE(V_MSQL);
	          EXECUTE IMMEDIATE V_MSQL;
	          DBMS_OUTPUT.PUT_LINE('INSERTADO');
	          
	          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL FROM DUAL';
	          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
	          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS (' ||
	          				'DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_PTP_ABSOLUTO) '||
	          				'VALUES ('||V_ENTIDAD_ID||',(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TAP(1)||'''),'||
	          				''''||V_TMP_T_TAP(6)||''',0, ''REM_F1'', SYSDATE, 0, 0)';
	          DBMS_OUTPUT.PUT_LINE('INSERTANDO: Plazo de '''||V_TMP_T_TAP(1)||'''.'); 
	          DBMS_OUTPUT.PUT_LINE(V_MSQL);
	          EXECUTE IMMEDIATE V_MSQL;
	          DBMS_OUTPUT.PUT_LINE('INSERTADO');
	          
	      END LOOP;
	      
		-- Insertamos en la tabla tfi_tareas_form_items
		FOR I IN V_TFI.FIRST .. V_TFI.LAST
	      LOOP
	          V_TMP_T_TFI := V_TFI(I);
	          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL FROM DUAL';
	          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
	          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS (' ||
	          			  'TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) '||
	          			  'VALUES ('||V_ENTIDAD_ID||', (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||'''),'||
	          			  ''''||V_TMP_T_TFI(2)||''','''||V_TMP_T_TFI(3)||''','''||V_TMP_T_TFI(4)||''','''||V_TMP_T_TFI(5)||''', '''||V_TMP_T_TFI(6)||''', '''||V_TMP_T_TFI(7)||''', '||
	          			  ''''||V_TMP_T_TFI(8)||''',1, ''REM_F1'', SYSDATE, 0)';
	          DBMS_OUTPUT.PUT_LINE('INSERTANDO: Campo '''||V_TMP_T_TFI(4)||''' de '''||V_TMP_T_TFI(1)||''''); 
	          DBMS_OUTPUT.PUT_LINE(V_MSQL);
	          EXECUTE IMMEDIATE V_MSQL;
	          DBMS_OUTPUT.PUT_LINE('INSERTADO');          
	      END LOOP;
	    
	      
    	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO... ha terminado la insercción deL BPM: '||V_TPO_XML||'.');
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