--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20161004
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=0
--## PRODUCTO=SI
--##
--## Finalidad: Realiza las inserciones del trámite de Sanción de oferta.
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
    V_TPO_COD VARCHAR2(20 CHAR):= 			'T013';
    V_TPO_DES VARCHAR2(100 CHAR):=			'Trámite de sanción de oferta';
    V_TPO_XML VARCHAR2(50 CHAR):=			'activo_tramiteSancionOferta';
    
    
    /* TABLAS: TAP_TAREA_PROCEDIMIENTO & DD_PTP_PLAZOS_TAREAS_PLAZAS */
    TYPE T_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TAP;
    V_TAP T_ARRAY_TAP := T_ARRAY_TAP(
    --  TAP_CODIGO
    --  TAP_DESCRIPCION
    --  DD_STA_CODIGO
    --  TAP_MAX_AUTOP
    --  DD_TGE_CODIGO
    --  DD_PTP_PLAZO_SCRIPT
    --  DD_TPO_ID_BPM
    --  TAP_SCRIPT_VALIDACION
    --  TAP_SCRIPT_VALIDACION_JBPM
    --  TAP_SCRIPT_DECISION
    -- 	Gestor comercial: GCOM
	-- 	Gestoría de preparación documental: GESTORIA_PREDOC
	
 	   	T_TAP('T013_DefinicionOferta',
                'Definición oferta',
                '811',
                '3',
                'GCOM',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',                
				'checkFormalizacion() == true ? (checkDeDerechoTanteo() == false ? (checkAtribuciones() == true ? ''''ConFormalizacionSinTanteoConAtribucion'''' : ''''ConFormalizacionSinTanteoSinAtribucion'''') : ''''ConFormalizacionDeTanteo'''') : ''''SinFormalizacion'''''
			),    	

    	T_TAP('T013_FirmaPropietario',
                'Firma propietario',
                '811',
                '3',
                'GCOM',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '',
                ''
            ),

    	T_TAP('T013_CierreEconomico',
                'Cierre económico',
                '811',
                '3',
                'GESTORIA_PREDOC',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				''            
			),
			
    	T_TAP('T013_ResolucionComite',
                'Resolución comité',
                '811',
                '3',
                'GCOM',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				'valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.01 ? ''''Aprueba'''': (valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.02 ? ''''Rechaza'''' : (checkSareb() ? ''''ContraofertaSareb'''' : ''''Contraoferta''''))'            
			),
			
    	T_TAP('T013_RespuestaOfertante',
                'Respuesta ofertante',
                '811',
                '3',
                'GCOM',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				'valores[''''T013_RespuestaOfertante''''][''''comboRespuesta''''] == DDSiNo.SI ?  ''''Acepta'''' : ''''Rechaza'''' '            
			),

    	T_TAP('T013_DobleFirma',
                'Doble firma',
                '811',
                '3',
                'GCOM',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				''            
			),
			

    	T_TAP('T013_InformeJuridico',
                'Informe jurídico',
                '811',
                '3',
                'GESTORIA_PREDOC',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				'checkReserva() == false ? (checkDerechoTanteo() == true ? ''''SinReservaConTanteo'''' : ''''SinReservaSinTanteo'''') : ''''ConReserva'''''            
			),				
			
    	T_TAP('T013_InstruccionesReserva',
                'Instrucciones reserva',
                '811',
                '3',
                'GCOM',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				''            
			),	
			
    	T_TAP('T013_ObtencionContratoReserva',
                'Instrucciones reserva',
                '811',
                '3',
                'GESTORIA_PREDOC',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				'checkDerechoTanteo() == true ? ''''ConTanteo'''' : ''''SinTanteo'''' '            
			),	
			
    	T_TAP('T013_ResolucionTanteo',
                'Resolución tanteo',
                '811',
                '3',
                'GESTORIA_PREDOC',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				'valores[''''T013_ResolucionTanteo''''][''''comboEjerce''''] == DDSiNo.SI ? ''''Ejerce'''' : ''''NoEjerce'''''          
			),		
			
    	T_TAP('T013_ResultadoPBC',
                'Resultado PBC',
                '811',
                '3',
                'GESTORIA_PREDOC',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				'valores[''''T013_ResultadoPBC''''][''''comboResultado''''] == DDSiNo.SI ? ''''Aprobado''''  : ''''NoAprobado'''' '            
			),
			
    	T_TAP('T013_PosicionamientoYFirma',
                'Posicionamiento y firma',
                '811',
                '3',
                'GESTORIA_PREDOC',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				'valores[''''T013_PosicionamientoYFirma''''][''''comboFirma''''] == DDSiNo.SI ? ''''ConFirma'''' : ''''SinFirma'''''
			),
			
    	T_TAP('T013_DevolucionLlaves',
                'Devolución de llaves HRE',
                '811',
                '3',
                'GESTORIA_PREDOC',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				''            
			),
			
    	T_TAP('T013_DocumentosPostVenta',
                'Documentos post-venta',
                '811',
                '3',
                'GESTORIA_PREDOC',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				''            
			)
	);
    V_TMP_T_TAP T_TAP;

    
    /* TABLA: TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    --		   TAP_CODIGO								TFI_ORDEN	TFI_TIPO		TFI_NOMBRE				TFI_LABEL															TFI_ERROR_VALIDACION							TFI_VALIDACION									TFI_BUSINESS_OPERATION
    	T_TFI('T013_DefinicionOferta'					,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px"></p>'								 	,''												,''												,''					),
    	T_TFI('T013_DefinicionOferta'					,'1'		,'textinf'	,'comite'				,'Comité sancionador'													,''												,''												,''					),
    	T_TFI('T013_DefinicionOferta'					,'2'		,'date'		,'fechaEnvio'			,'Fecha de envío'														,''												,''												,''					),
    	T_TFI('T013_DefinicionOferta'					,'3'		,'text'		,'numExpediente'		,'Nº Expediente origen'													,''												,''												,''					),
    	T_TFI('T013_DefinicionOferta'					,'4'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
    	T_TFI('T013_FirmaPropietario'					,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px"></p>'									,''												,''												,''					),
		T_TFI('T013_FirmaPropietario'					,'1'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
    	T_TFI('T013_ResolucionComite'					,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px"></p>'									,''												,''												,''					),
	    T_TFI('T013_ResolucionComite'					,'1'		,'date'		,'fechaRespuesta'		,'Fecha de respuesta'													,''	                                            ,''                                      		,''					),
    	T_TFI('T013_ResolucionComite'					,'2'		,'combo'	,'comboResolucion'		,'Resolución'															,''												,''												,'DDResolucionComite'),
		T_TFI('T013_ResolucionComite'					,'3'		,'number'	,'numImporte'			,'Importe contraoferta'													,''												,''												,''					),
	    T_TFI('T013_ResolucionComite'					,'4'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
		T_TFI('T013_DobleFirma'							,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px"></p>'									,''												,''												,''					),
	    T_TFI('T013_DobleFirma'							,'1'		,'combo'	,'comboTecleo'			,'Tecleo correcto'														,''												,''												,'DDSiNo'			),
	    T_TFI('T013_DobleFirma'							,'2'		,'number'	,'numImporte'			,'Importe correcto'														,''												,''												,''					),
	    T_TFI('T013_DobleFirma'							,'3'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
	    T_TFI('T013_RespuestaOfertante'					,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px"></p>'									,''												,''												,''					),
	    T_TFI('T013_RespuestaOfertante'					,'1'		,'combo'	,'comboRespuesta'		,'¿Acepta contraoferta?'												,''												,''												,'DDSiNo'			),
	    T_TFI('T013_RespuestaOfertante'					,'2'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
	    T_TFI('T013_InformeJuridico'					,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px"></p>'									,''												,''												,''					),
	    T_TFI('T013_InformeJuridico'					,'1'		,'date'		,'fechaEmision'			,'Fecha de emisión'														,''												,''												,''					),
	    T_TFI('T013_InformeJuridico'					,'2'		,'combo'	,'comboResultado'		,'¿Resultado favorable?'												,''												,''												,'DDSiNo'					),
	    T_TFI('T013_InformeJuridico'					,'3'		,'combo'	,'tipoIncidencia'		,'Tipo de incidencia'													,''												,''												,'DDTipoIncidencia'	),
	    T_TFI('T013_InformeJuridico'					,'4'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
	    T_TFI('T013_InstruccionesReserva'				,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px"></p>'									,''												,''												,''					),
	    T_TFI('T013_InstruccionesReserva'				,'1'		,'date'		,'fechaEnvio'			,'Fecha de envío'														,''												,''												,''					),
	    T_TFI('T013_InstruccionesReserva'				,'2'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
	    T_TFI('T013_ObtencionContratoReserva'			,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px"></p>'									,''												,''												,''					),
	    T_TFI('T013_ObtencionContratoReserva'			,'1'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
	    T_TFI('T013_ResolucionTanteo'					,'0'		,'label'	,'titulo'				,'Título'																,''												,''												,''					),
	    T_TFI('T013_ResolucionTanteo'					,'1'		,'combo'	,'comboEjerce'			,'Ejerce'																,''												,''												,''					),
		T_TFI('T013_ResolucionTanteo'					,'2'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
		T_TFI('T013_ResultadoPBC'						,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px"></p>'									,''												,''												,''					),
		T_TFI('T013_ResultadoPBC'						,'1'		,'combo'	,'comboResultado'		,'¿PBC Aprobado?'														,''												,''												,'DDSiNo'			),
		T_TFI('T013_ResultadoPBC'						,'2'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
		T_TFI('T013_PosicionamientoYFirma'				,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px"></p>'									,''												,''												,''					),
		T_TFI('T013_PosicionamientoYFirma'				,'1'		,'combo'	,'comboFirma'			,'¿Firmado?'															,''												,''												,'DDSiNo'			),
		T_TFI('T013_PosicionamientoYFirma'				,'2'		,'date'		,'fechaFirma'			,'Fecha firma'															,''												,''												,''					),
		T_TFI('T013_PosicionamientoYFirma'				,'3'		,'number'	,'numProtocolo'			,'Núm Protocolo'														,''												,''												,''					),
		T_TFI('T013_PosicionamientoYFirma'				,'4'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
		T_TFI('T013_DevolucionLlaves'					,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px"></p>'									,''												,''												,''					),
		T_TFI('T013_DevolucionLlaves'					,'1'		,'date'		,'fechaEnvio'			,'Fecha envío'															,''												,''												,''					),
		T_TFI('T013_DevolucionLlaves'					,'2'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
		T_TFI('T013_DocumentosPostVenta'				,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px"></p>'									,''												,''												,''					),
		T_TFI('T013_DocumentosPostVenta'				,'1'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
		T_TFI('T013_CierreEconomico'					,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px"></p>'									,''												,''												,''					),
		T_TFI('T013_CierreEconomico'					,'1'		,'number'	,'numHonorarios'		,'Honorarios ratificados'												,''												,''												,''					),
		T_TFI('T013_CierreEconomico'					,'2'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					)	
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