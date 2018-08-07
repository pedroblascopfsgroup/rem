--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20180806
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4311
--## PRODUCTO=SI
--##
--## Finalidad: Realiza las inserciones del trámite de Sanción de oferta tipo tramite comercial alquiler
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
    V_TPO_COD VARCHAR2(20 CHAR):= 			'T015';
    V_TPO_DES VARCHAR2(100 CHAR):=			'Trámite comercial de alquiler';
    V_TPO_XML VARCHAR2(50 CHAR):=			'activo_tramiteComercialAlquiler';
    
    
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
    -- 	Gestor comercial: GESTCOMALQ
	-- 	Gestoría de preparación documental: 
	
 	   	T_TAP('T015_DefinicionOferta',
                'Definición oferta',
                'TGCA',
                '3',
                'GESTCOMALQ',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',                
				'valores[''''T015_DefinicionOferta''''][''''tipoTratamiento''''] == ''''01'''' ? ''''verificaScoring'''' : valores[''''T015_DefinicionOferta''''][''''tipoTratamiento''''] ==''''02'''' ? ''''verificaSeguroRenta'''' : ''''elevarSancion'''''
			),    	

    	T_TAP('T015_VerificarScoring',
                'Verificar scoring',
                'TGCA',
                '3',
                'GESTCOMALQ',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '',
                'valores[''''T015_VerificarScoring''''][''''resultadoScoring''''] == ''''01'''' ? ''''Aprobado'''' : ''''Rechazado'''''
            ),

    	T_TAP('T015_VerificarSeguroRentas',
                'Verificar seguro de rentas',
                'TGCA',
                '3',
                'GESTCOMALQ',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				'valores[''''T015_VerificarSeguroRentas''''][''''resultadoRentas''''] == ''''01'''' ? ''''Aprobado'''' : ''''Rechazado'''''            
			),
			
    	T_TAP('T015_ElevarASancion',
                'Elevar a sanción',
                'TGCA',
                '3',
                'GESTCOMALQ',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				'valores[''''T015_ElevarASancion''''][''''resolucionOferta''''] == ''''01'''' ? ''''Elevar'''' : ''''Anular'''''            
			),
			
    	T_TAP('T015_ResolucionExpediente',
                'Resolución expediente',
                'TGCA',
                '3',
                'GESTCOMALQ',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				'valores[''''T015_ResolucionExpediente''''][''''resolucionExpediente''''] == ''''01'''' ? ''''Aprobada'''' : valores[''''T015_ResolucionExpediente''''][''''resolucionExpediente''''] == ''''02'''' ? ''''Anulada'''' : ''''Contraofertar'''''            
			),

    	T_TAP('T015_AceptacionCliente',
                'Aceptación cliente',
                'TGCA',
                '3',
                'GESTCOMALQ',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				'valores[''''T015_AceptacionCliente''''][''''aceptacionContraoferta''''] == ''''01'''' ? valores[''''T015_DefinicionOferta''''][''''tipoTratamiento''''] == ''''01'''' ? ''''SiScoring'''' : valores[''''T015_DefinicionOferta''''][''''tipoTratamiento''''] ==''''02'''' ? ''''SiSeguroRentas'''' : ''''SiNnguna'''' : ''''No'''''            
			),
			

    	T_TAP('T015_ResolucionPBC',
                'Resolución PBC',
                'TGCA',
                '3',
                'GESTCOMALQ',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				'valores[''''T015_ResolucionPBC''''][''''resultadoPBC''''] == ''''01'''' ? ''''Aprobado'''' : ''''Denegado'''''            
			),				
			
    	T_TAP('T015_Posicionamiento',
                'Posicionamiento',
                'TGCA',
                '3',
                'GESTCOMALQ',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				''            
			),	
			
    	T_TAP('T015_Firma',
                'Firma',
                'TGCA',
                '3',
                'GESTCOMALQ',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'',
				' '            
			),	
			
    	T_TAP('T015_CierreContrato',
                'Cierre contrato',
                'TGCA',
                '3',
                'GESTCOMALQ',
                '3*24*60*60*1000L',
                'NULL',
                '',
				'valores[''''T015_CierreContrato''''][''''docOK''''] != ''''false'''' ? null : ''''Debe marcar la casilla "Documentaci&#243;n OK" para poder avanzar la tarea.''''',
				''          
			)
			
	);
    V_TMP_T_TAP T_TAP;

    
    /* TABLA: TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    --		   TAP_CODIGO							TFI_ORDEN		TFI_TIPO		TFI_NOMBRE				TFI_LABEL										TFI_ERROR_VALIDACION													TFI_VALIDACION													TFI_BUSINESS_OPERATION			
		T_TFI('T015_DefinicionOferta'					,'0'		,'label'		,'titulo'				,'<p style="margin-bottom: 10px"></p>'			,''																			,''															,''					),
		T_TFI('T015_DefinicionOferta'					,'1'		,'combo'		,'tipoTratamiento'		,'Tipo de tratamiento'							,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'				,'valor != null && valor != '''''''' ? true : false'		,'DDTipoTratamiento'),
		T_TFI('T015_DefinicionOferta'					,'2'		,'date'			,'fechaTratamiento'		,'Fecha de tratamiento'							,''																			,''															,''					),
		T_TFI('T015_DefinicionOferta'					,'3'		,'combo'		,'tipoInquilino'		,'Tipo inquilino'								,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'				,'valor != null && valor != '''''''' ? true : false'		,'DDTipoInquilino'	),
		T_TFI('T015_DefinicionOferta'					,'4'		,'number'		,'nMesesFianza'			,'Nº meses fianza'								,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'				,'valor != null && valor != '''''''' ? true : false'		,''					),
		T_TFI('T015_DefinicionOferta'					,'5'		,'number'		,'importeFianza'		,'Importe fianza'								,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'				,'valor != null && valor != '''''''' ? true : false'		,''					),
		T_TFI('T015_DefinicionOferta'					,'6'		,'checkbox'		,'deposito'				,'Depósito'										,''																			,''															,''					),
		T_TFI('T015_DefinicionOferta'					,'7'		,'textfield'	,'nMeses'				,'Nº meses'										,''																			,''															,''					),
		T_TFI('T015_DefinicionOferta'					,'8'		,'number'		,'importeDeposito'		,'Importe'										,''																			,''															,''					),
		T_TFI('T015_DefinicionOferta'					,'9'		,'checkbox'		,'fiadorSolidario'		,'Fiador solidario'								,''																			,''															,''					),
		T_TFI('T015_DefinicionOferta'					,'10'		,'textfield'	,'nombreFS'				,'Nombre'										,''																			,''															,''					),
		T_TFI('T015_DefinicionOferta'					,'11'		,'textfield'	,'documento'			,'Documento'									,''																			,''															,''					),
		T_TFI('T015_DefinicionOferta'					,'12'		,'combo'		,'tipoImpuesto'			,'Tipo impuesto'								,''																			,''															,'DDTiposImpuesto'	),
		T_TFI('T015_DefinicionOferta'					,'13'		,'number'		,'porcentajeImpuesto'	,'% impuesto'									,''																			,''															,''					),
		T_TFI('T015_DefinicionOferta'					,'14'		,'textarea'		,'observaciones'		,'Observaciones'								,''																			,''															,''					),
		
		T_TFI('T015_VerificarScoring'					,'0'		,'label'		,'titulo'				,'<p style="margin-bottom: 10px"></p>'			,''																			,''															,''					),
		T_TFI('T015_VerificarScoring'					,'1'		,'combo'		,'resultadoScoring'		,'Resultado scoring'							,''																			,''															,'DDResultadoCampo'	),
		T_TFI('T015_VerificarScoring'					,'2'		,'date'			,'fechaSancScoring'		,'Fecha sanción scoring'						,''																			,''															,''					),
		T_TFI('T015_VerificarScoring'					,'3'		,'combo'		,'motivoRechazo'		,'Motivo rechazo'								,''																			,''															,'DDMotivoRechazoAlquiler'	),
		T_TFI('T015_VerificarScoring'					,'4'		,'number'		,'nExpediente'			,'Nº Expediente'								,''																			,''															,''					),
		T_TFI('T015_VerificarScoring'					,'5'		,'number'		,'nMesesFianza'			,'Nº meses fianza'								,''																			,''															,''					),
		T_TFI('T015_VerificarScoring'					,'6'		,'number'		,'importeFianza'		,'Importe fianza'								,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'				,'valor != null && valor != '''''''' ? true : false'		,''					),
		T_TFI('T015_VerificarScoring'					,'7'		,'checkbox'		,'deposito'				,'Depósito'										,''																			,''															,''					),
		T_TFI('T015_VerificarScoring'					,'8'		,'textfield'	,'nMeses'				,'Nº meses'										,''																			,''															,''					),
		T_TFI('T015_VerificarScoring'					,'9'		,'number'		,'importeDeposito'		,'Importe'										,''																			,''															,''					),
		T_TFI('T015_VerificarScoring'					,'10'		,'checkbox'		,'fiadorSolidario'		,'Fiador solidario'								,''																			,''															,''					),
		T_TFI('T015_VerificarScoring'					,'11'		,'textfield'	,'nombreFS'				,'Nombre'										,''																			,''															,''					),
		T_TFI('T015_VerificarScoring'					,'12'		,'textfield'	,'documento'			,'Documento'									,''																			,''															,''					),
		T_TFI('T015_VerificarScoring'					,'13'		,'combo'		,'tipoImpuesto'			,'Tipo impuesto'								,''																			,''															,'DDTiposImpuesto'	),
		T_TFI('T015_VerificarScoring'					,'14'		,'number'		,'porcentajeImpuesto'	,'% impuesto'									,''																			,''															,''					),
		T_TFI('T015_VerificarScoring'					,'15'		,'textarea'		,'observaciones'		,'Observaciones'								,''																			,''															,''					),
		
		T_TFI('T015_VerificarSeguroRentas'				,'0'		,'label'		,'titulo'				,'<p style="margin-bottom: 10px"></p>'			,''																			,''															,''					),
		T_TFI('T015_VerificarSeguroRentas'				,'1'		,'combo'		,'resultadoRentas'		,'Resultado seguro de rentas'					,''																			,''															,'DDResultadoCampo'	),
		T_TFI('T015_VerificarSeguroRentas'				,'2'		,'date'			,'fechaSancRentas'		,'Fecha sanción seguro de rentas'				,''																			,''															,''					),
		T_TFI('T015_VerificarSeguroRentas'				,'3'		,'combo'		,'motivoRechazo'		,'Motivo rechazo'								,''																			,''															,'DDMotivoRechazoAlquiler'	),
		T_TFI('T015_VerificarSeguroRentas'				,'4'		,'number'		,'nMesesFianza'			,'Nº meses fianza'								,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'				,'valor != null && valor != '''''''' ? true : false'		,''					),
		T_TFI('T015_VerificarSeguroRentas'				,'5'		,'number'		,'importeFianza'		,'Importe fianza'								,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'				,'valor != null && valor != '''''''' ? true : false'		,''					),
		T_TFI('T015_VerificarSeguroRentas'				,'6'		,'checkbox'		,'deposito'				,'Depósito'										,''																			,''															,''					),
		T_TFI('T015_VerificarSeguroRentas'				,'7'		,'textfield'	,'nMeses'				,'Nº meses'										,''																			,''															,''					),
		T_TFI('T015_VerificarSeguroRentas'				,'8'		,'number'		,'importeDeposito'		,'Importe'										,''																			,''															,''					),
		T_TFI('T015_VerificarSeguroRentas'				,'9'		,'checkbox'		,'fiadorSolidario'		,'Fiador solidario'								,''																			,''															,''					),
		T_TFI('T015_VerificarSeguroRentas'				,'10'		,'textfield'	,'nombreFS'				,'Nombre'										,''																			,''															,''					),
		T_TFI('T015_VerificarSeguroRentas'				,'11'		,'textfield'	,'documento'			,'Documento'									,''																			,''															,''					),
		T_TFI('T015_VerificarSeguroRentas'				,'12'		,'combo'		,'tipoImpuesto'			,'Tipo impuesto'								,''																			,''															,'DDTiposImpuesto'	),
		T_TFI('T015_VerificarSeguroRentas'				,'13'		,'number'		,'porcentajeImpuesto'	,'% impuesto'									,''																			,''															,''					),
		T_TFI('T015_VerificarSeguroRentas'				,'14'		,'comboesp'		,'aseguradora'			,'Aseguradora'									,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'				,'valor != null && valor != '''''''' ? true : false'		,'DDSegurosVigentes'),
		T_TFI('T015_VerificarSeguroRentas'				,'15'		,'textfield'	,'envioEmail'			,'Envío email póliza seguro'					,''																			,''															,''					),
		T_TFI('T015_VerificarSeguroRentas'				,'16'		,'textarea'		,'observaciones'		,'Observaciones'								,''																			,''															,''					),
		
		T_TFI('T015_ElevarASancion'						,'0'		,'label'		,'titulo'				,'<p style="margin-bottom: 10px"></p>'			,''																			,''															,''					),
		T_TFI('T015_ElevarASancion'						,'1'		,'combo'		,'resolucionOferta'		,'Resolución de la oferta'						,''																			,''															,'DDResolucionOferta'	),
		T_TFI('T015_ElevarASancion'						,'2'		,'date'			,'fechaSancion'			,'Fecha sanción'								,''																			,''															,''					),
		T_TFI('T015_ElevarASancion'						,'3'		,'textfield'	,'motivoAnulacion'		,'Motivo de anulación'							,''																			,''															,''					),
		T_TFI('T015_ElevarASancion'						,'4'		,'combo'		,'comite'				,'Comité'										,''																			,''															,''					),
		T_TFI('T015_ElevarASancion'						,'6'		,'textfield'	,'refCircuitoCliente'	,'Ref. circuito cliente'						,''																			,''															,''					),
		T_TFI('T015_ElevarASancion'						,'5'		,'date'			,'fechaElevacion'		,'Fecha elevación'								,''																			,''															,''					),
		
		T_TFI('T015_ResolucionExpediente'				,'0'		,'label'		,'titulo'				,'<p style="margin-bottom: 10px"></p>'			,''																			,''															,''					),
		T_TFI('T015_ResolucionExpediente'				,'1'		,'combo'		,'resolucionExpediente'	,'Resolución expediente'						,''																			,''															,'DDResolucionComite'	),
		T_TFI('T015_ResolucionExpediente'				,'2'		,'date'			,'fechaResolucion'		,'Fecha resolución'								,''																			,''															,''					),
		T_TFI('T015_ResolucionExpediente'				,'3'		,'textfield'	,'motivo'				,'Motivo'										,''																			,''															,''					),
		T_TFI('T015_ResolucionExpediente'				,'4'		,'number'		,'importeContraoferta'	,'Importe contraoferta'							,''																			,''															,''					),
	   	
		T_TFI('T015_AceptacionCliente'					,'0'		,'label'		,'titulo'					,'<p style="margin-bottom: 10px"></p>'		,''																			,''															,''					),
		T_TFI('T015_AceptacionCliente'					,'1'		,'combo'		,'aceptacionContraoferta'	,'Aceptación contraoferta'					,''																			,''															,'DDSiNo'			),
		T_TFI('T015_AceptacionCliente'					,'2'		,'date'			,'fechaAceptaDenega'	,'Fecha Aceptación/Denegación'					,''																			,''															,''					),
		T_TFI('T015_AceptacionCliente'					,'3'		,'textfield'	,'motivoAC'				,'Motivo'										,''																			,''															,''					),
		
		T_TFI('T015_ResolucionPBC'						,'0'		,'label'		,'titulo'				,'<p style="margin-bottom: 10px"></p>'			,''																			,''															,''					),
		T_TFI('T015_ResolucionPBC'						,'1'		,'combo'		,'resultadoPBC'			,'Resultado PBC'								,''																			,''															,'DDResultadoCampo'	),
		T_TFI('T015_ResolucionPBC'						,'2'		,'date'			,'fechaPBC'				,'Fecha'										,''																			,''															,''					),
		
		T_TFI('T015_Posicionamiento'					,'0'		,'label'		,'titulo'				,'<p style="margin-bottom: 10px"></p>'			,''																			,''															,''					),
		T_TFI('T015_Posicionamiento'					,'1'		,'date'			,'fechaFirmaContrato'	,'Fecha prevista firma de contrato'				,''																			,''															,''					),
		T_TFI('T015_Posicionamiento'					,'2'		,'textfield'	,'lugarFirma'			,'Lugar de firma'								,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'				,'valor != null && valor != '''''''' ? true : false'		,''					),
		
		T_TFI('T015_Firma'								,'0'		,'label'		,'titulo'				,'<p style="margin-bottom: 10px"></p>'			,''																			,''															,''					),
		T_TFI('T015_Firma'								,'1'		,'date'			,'fechaFirma'			,'Fecha firma'									,''																			,''															,''					),
		
		T_TFI('T015_CierreContrato'						,'0'		,'label'		,'titulo'				,'<p style="margin-bottom: 10px"></p>'			,''																			,''															,''					),
		T_TFI('T015_CierreContrato'						,'1'		,'checkbox'		,'docOK'				,'Documentación OK'								,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'				,'valor != null && valor != '''''''' ? true : false'		,''					),
		T_TFI('T015_CierreContrato'						,'2'		,'date'			,'fechaValidacion'		,'Fecha validación'								,''																			,''															,''					),
		T_TFI('T015_CierreContrato'						,'3'		,'textfield'	,'ncontratoPrinex'		,'Nº contrato Prinex'							,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'				,'valor != null && valor != '''''''' ? true : false'		,''					)
    	
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
--					'VALUES ('||V_ENTIDAD_ID||','''||V_TIPO_ACT_COD||''','''||V_TIPO_ACT_DES||''','''||V_TIPO_ACT_DES||''',	1, ''HREOS-4311'', SYSDATE, 0)';
--			EXECUTE IMMEDIATE V_MSQL;
			
		-- Insertamos en la tabla dd_tpo_tipo_procedimiento
		V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO (' ||
					'DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID, FLAG_PRORROGA, DTYPE, FLAG_DERIVABLE, FLAG_UNICO_BIEN) '||
					'VALUES ('||V_ENTIDAD_ID||','''||V_TPO_COD||''','''||V_TPO_DES||''','''||V_TPO_DES||''','''||V_TPO_XML||''', 1, ''HREOS-4311'', SYSDATE, 0,'||
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
	                      ''''||V_TMP_T_TAP(1)||''', NULL, 0,'''||V_TMP_T_TAP(2)||''', 0, ''HREOS-4311'', SYSDATE, 0, NULL, 0, ''EXTTareaProcedimiento'', '||
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
	          				''''||V_TMP_T_TAP(6)||''',0, ''HREOS-4311'', SYSDATE, 0, 0)';
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
	          			  ''''||V_TMP_T_TFI(8)||''',1, ''HREOS-4311'', SYSDATE, 0)';
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