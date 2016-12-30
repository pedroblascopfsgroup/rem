--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20161228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=0
--## PRODUCTO=SI
--##
--## Finalidad: Realiza las modificaciones necesarias para el trámite de sanción de ofertas.
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
    
    
    	/* NUEVAS TAREAS */
	
	V_TIPO_ACT_COD VARCHAR2(20 CHAR):=		'GES';
    V_TIPO_ACT_DES VARCHAR2(50 CHAR):=		'Gestión';	
    V_TPO_COD VARCHAR2(20 CHAR):= 			'T013';
    V_TPO_DES VARCHAR2(100 CHAR):=			'Trámite comercial venta';
    V_TPO_XML VARCHAR2(50 CHAR):=			'activo_tramiteSancionOferta';
    
    
    /* TABLAS: TAP_TAREA_PROCEDIMIENTO & DD_PTP_PLAZOS_TAREAS_PLAZAS */
    TYPE T_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TAP;
    V_TAP T_ARRAY_TAP := T_ARRAY_TAP(
    
    T_TAP('T013_ResolucionExpediente',
          'Resolución expediente',
          '811',
          '3',
          'GCOM',
          '3*24*60*60*1000L',
   	      'NULL',
          '',
		  '',                
		  ''
		)
	);
    V_TMP_T_TAP T_TAP;

     /* NUEVOS CAMPOS Y ACTUALIZACIÓN DE ORDEN */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    --		   TAP_CODIGO								TFI_ORDEN	TFI_TIPO		TFI_NOMBRE				TFI_LABEL															TFI_ERROR_VALIDACION							TFI_VALIDACION									TFI_BUSINESS_OPERATION
    	T_TFI('T013_DefinicionOferta'					,'2'		,'combo'	,'comboConflicto'		,'Conflicto de intereses'								 				,''												,''												,'DDSiNo'			),
    	T_TFI('T013_DefinicionOferta'					,'3'		,'combo'	,'comboRiesgo'			,'Riesgo reputacional'													,''												,''												,'DDSiNo'			),
    	T_TFI('T013_DefinicionOferta'					,'4'		,'date'		,'fechaEnvio'			,'Fecha de envío'														,''												,''												,''					),
    	T_TFI('T013_DefinicionOferta'					,'5'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
    	T_TFI('T013_FirmaPropietario'					,'1'		,'combo'	,'comboFirma'			,'¿Se ha firmado la escritura?'											,''												,''												,'DDSiNo'			),
    	T_TFI('T013_FirmaPropietario'					,'2'		,'date'		,'fechaFirma'			,'Fecha efectiva de firma'												,''												,''												,''					),
    	T_TFI('T013_FirmaPropietario'					,'3'		,'textfield','notario'				,'Notario'																,''												,''												,''					),
		T_TFI('T013_FirmaPropietario'					,'4'		,'number' 	,'numProtocolo'			,'Nº protocolo'															,''												,''												,''					),
		T_TFI('T013_FirmaPropietario'					,'5'		,'number' 	,'precioEscrituracion'	,'Precio escrituración'													,''												,''												,''					),
		T_TFI('T013_FirmaPropietario'					,'6'		,'textfield','motivoAnulacion'		,'Motivo anulación'														,''												,''												,''					),
    	T_TFI('T013_FirmaPropietario'					,'7'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
	   	T_TFI('T013_RespuestaOfertante'					,'2'		,'date'		,'fechaRespuesta'		,'Fecha respuesta'														,''												,''												,''					),
    	T_TFI('T013_RespuestaOfertante'					,'3'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
    	T_TFI('T013_InstruccionesReserva'				,'1'		,'combo'	,'comboVPO'				,'Activo VPO'															,''												,''												,'DDSiNo'			),
	    T_TFI('T013_InstruccionesReserva'				,'2'		,'textfield','Tipo de arras'		,'Tipo de arras'														,''												,''												,''					),
    	T_TFI('T013_InstruccionesReserva'				,'3'		,'date'		,'fechaEnvio'			,'Fecha de envío'														,''												,''												,''					),
	    T_TFI('T013_InstruccionesReserva'				,'4'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
	    T_TFI('T013_ResolucionTanteo'					,'2'		,'textfield','administracion'		,'Administración que ejercita el tanteo'								,''												,''												,''					),
	    T_TFI('T013_ResolucionTanteo'					,'3'		,'textfield','nif'					,'NIF administración'													,''												,''												,''					),
	    T_TFI('T013_ResolucionTanteo'					,'4'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
	    T_TFI('T013_ObtencionContratoReserva'			,'1'		,'textinf'	,'cartera'				,'Cartera del activo'													,''												,''												,''					),
	    T_TFI('T013_ObtencionContratoReserva'			,'2'		,'textinf'	,'oficinaReserva'		,'Oficina en la que se ha firmado la reserva'							,''												,''												,''					),
	    T_TFI('T013_ObtencionContratoReserva'			,'3'		,'date'		,'fechaFirma'			,'Fecha de firma'														,''												,''												,''					),
	    T_TFI('T013_ObtencionContratoReserva'			,'4'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
		T_TFI('T013_PosicionamientoYFirma'				,'4'		,'date'		,'fechaIngreso'			,'Fecha ingreso cheque'													,''												,''												,''					),
		T_TFI('T013_PosicionamientoYFirma'				,'5'		,'combo'	,'comboCondiciones'		,'Condiciones postventa'												,''												,''												,'DDSiNo'			),
		T_TFI('T013_PosicionamientoYFirma'				,'6'		,'textfield','condiciones'			,'Texto condiciones postventa'											,''												,''												,''					),
		T_TFI('T013_PosicionamientoYFirma'				,'7'		,'textfield','motivoNoFirma'		,'Motivo de no firma'													,''												,''												,''					),
		T_TFI('T013_PosicionamientoYFirma'				,'8'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					),
		T_TFI('T013_ResolucionExpediente'				,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px"></p>'									,''												,''												,''					),
		T_TFI('T013_ResolucionExpediente'				,'1'		,'textinf'	,'tipoArras'			,'Tipo de arras'														,''												,''												,''					),
		T_TFI('T013_ResolucionExpediente'				,'2'		,'textfield','motivoAnulacion'		,'Motivo anulación'														,''												,''												,''					),
		T_TFI('T013_ResolucionExpediente'				,'3'		,'combo'	,'comboProcede'			,'Procede Devolución'													,''												,''												,'DDSiNo'			),
		T_TFI('T013_ResolucionExpediente'				,'4'		,'textarea'	,'observaciones'		,'Observaciones'														,''												,''												,''					)
		);
    V_TMP_T_TFI T_TFI;
    
    /* CAMPOS MARCADO A BORRADO */
    TYPE T_TFI_DEL IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI_DEL IS TABLE OF T_TFI_DEL;
    V_TFI_DEL T_ARRAY_TFI_DEL := T_ARRAY_TFI_DEL(
    --		   TAP_CODIGO								TFI_ORDEN	TFI_TIPO		TFI_NOMBRE				TFI_LABEL															TFI_ERROR_VALIDACION							TFI_VALIDACION									TFI_BUSINESS_OPERATION
    	T_TFI_DEL('T013_DefinicionOferta'					,'3'		,'text'		,'numExpediente'		,'Nº Expediente origen'													,''												,''												,''					),
	    T_TFI_DEL('T013_InformeJuridico'					,'3'		,'combo'	,'tipoIncidencia'		,'Tipo de incidencia'													,''												,''												,'DDTipoIncidencia'	)
    	);
    V_TMP_T_TFI_DEL T_TFI_DEL;
    
BEGIN
	
	
	/* MODIFICACIÓN NOMBRE TRÁMITE */
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO' ||
    		  ' SET DD_TPO_DESCRIPCION = '''||V_TPO_DES||''' '||
    		  ' ,DD_TPO_DESCRIPCION_LARGA = '''||V_TPO_DES||''' '||
    		  ', USUARIOMODIFICAR = ''HREOS-1308'' '||
	          ', FECHAMODIFICAR = SYSDATE '||
    		  ' WHERE DD_TPO_CODIGO = '''||V_TPO_COD||''' ';
    		  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;


    /* INSERTAMOS NUEVAS TAREAS */
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


    /* ACTUALIZACIÓN DE CAMPOS */
    FOR I IN V_TFI.FIRST .. V_TFI.LAST
	      LOOP
	      	  V_TMP_T_TFI := V_TFI(I);
	          
			  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||''') AND TFI_NOMBRE = '''||V_TMP_T_TFI(4)||''' ';
			  EXECUTE IMMEDIATE V_SQL INTO table_count;
			   
			  IF table_count = 1 THEN
			  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizamos el orden.');
			  	  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          			' SET TFI_ORDEN = '''||V_TMP_T_TFI(2)||''' '||
	          			', USUARIOMODIFICAR = ''HREOS-1308'' '||
	          			', FECHAMODIFICAR = SYSDATE '||
	          			' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||''') '||
			  			' AND TFI_NOMBRE = '''||V_TMP_T_TFI(4)||''' ';
		          DBMS_OUTPUT.PUT_LINE('Actualizado orden: Campo '''||V_TMP_T_TFI(4)||''' de '''||V_TMP_T_TFI(1)||''''); 
		          DBMS_OUTPUT.PUT_LINE(V_MSQL);
		          EXECUTE IMMEDIATE V_MSQL;
		          DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO'); 
			  ELSE
			  
		          
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
		      END IF;
	      END LOOP;

	/* BORRADO DE CAMPOS */
	FOR I IN V_TFI_DEL.FIRST .. V_TFI_DEL.LAST
	      LOOP
	          V_TMP_T_TFI_DEL := V_TFI_DEL(I);
	          V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          			' SET BORRADO = ''1'' '||
	          			', USUARIOBORRAR = ''HREOS-1308'' '||
	          			', FECHABORRAR = SYSDATE '||
	          			' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI_DEL(1)||''') '||
			  			' AND TFI_NOMBRE = '''||V_TMP_T_TFI_DEL(4)||''' ';
	          DBMS_OUTPUT.PUT_LINE('BORRANDO: Campo '''||V_TMP_T_TFI_DEL(4)||''' de '''||V_TMP_T_TFI_DEL(1)||''''); 
	          DBMS_OUTPUT.PUT_LINE(V_MSQL);
	          EXECUTE IMMEDIATE V_MSQL;
	          DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO');          
	      END LOOP;
	
	
	
	/* ACTUALIZACIÓN DE DECISIONES */
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
    		  ' SET TAP_SCRIPT_DECISION = ''checkFormalizacion() == true ? (checkDeDerechoTanteo() == false ? (checkAtribuciones() == true ? (checkReserva() == false ? (checkDerechoTanteo() == true ? ''''ConFormalizacionSinTanteoConAtribucionSinReservaConTanteo'''' : ''''ConFormalizacionSinTanteoConAtribucionSinReservaSinTanteo'''') : ''''ConFormalizacionSinTanteoConAtribucionConReserva'''') : ''''ConFormalizacionSinTanteoSinAtribucion'''') : ''''ConFormalizacionConTanteo'''') : ''''SinFormalizacion'''' '' '||
    		  ' WHERE TAP_CODIGO = ''T013_DefinicionOferta'' ';
    		  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
    		  ' SET TAP_SCRIPT_DECISION = ''valores[''''T013_FirmaPropietario''''][''''comboFirma''''] == DDSiNo.SI ? ''''Si'''' : ''''No'''''' '||
    		  ' WHERE TAP_CODIGO = ''T013_FirmaPropietario'' ';
    		  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    /*
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
    		  ' SET TAP_SCRIPT_DECISION = '' '' '||
    		  ' WHERE TAP_CODIGO = ''T013_CierreEconomico'' ';
    		  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    */
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||						  
    		  ' SET TAP_SCRIPT_DECISION = ''valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_APRUEBA ? (checkReserva() ? ''''ApruebaConReserva'''' : checkDerechoTanteo() ? ''''ApruebaSinReservaConTanteo'''' : ''''ApruebaSinReservaSinTanteo'''') : (valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_RECHAZA ? ''''Rechaza'''' : ''''Contraoferta'''') '' '||
    		  ' WHERE TAP_CODIGO = ''T013_ResolucionComite'' ';
    		  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||	
    		  ' SET TAP_SCRIPT_DECISION = ''valores[''''T013_RespuestaOfertante''''][''''comboRespuesta''''] == DDSiNo.SI ?  (checkReserva() ? ''''AceptaConReserva'''' : checkDerechoTanteo() ? ''''AceptaSinReservaConTanteo'''' : ''''AceptaSinReservaSinTanteo'''') : ''''Rechaza'''' '' '||
    		  ' WHERE TAP_CODIGO = ''T013_RespuestaOfertante'' ';
    		  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
   	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||	
    		  ' SET TAP_SCRIPT_DECISION = ''checkDerechoTanteo() ? ''''Si'''' : ''''No'''' '' '||
    		  ' WHERE TAP_CODIGO = ''T013_InstruccionesReserva'' ';
    		  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    /*
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
    		  ' SET TAP_SCRIPT_DECISION = '' '' '||
    		  ' WHERE TAP_CODIGO = ''T013_InformeJuridico'' ';
    		  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    */

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
    		  ' SET TAP_SCRIPT_DECISION = ''valores[''''T013_ResultadoPBC''''][''''comboResultado''''] == DDSiNo.SI ? ''''Aprobado''''  : (checkReserva() ? ''''NoAprobadoConReserva'''' : ''''NoAprobadoSinReserva'''') '' '||
    		  ' WHERE TAP_CODIGO = ''T013_ResultadoPBC'' ';
    		  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
   
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
    		  ' SET TAP_SCRIPT_DECISION = ''valores[''''T013_ResolucionTanteo''''][''''comboEjerce''''] == DDSiNo.SI ? (checkReserva() ? ''''EjerceConReserva'''' : ''''EjerceSinReserva'''') : ''''NoEjerce'''' '' '||
    		  ' WHERE TAP_CODIGO = ''T013_ResolucionTanteo'' ';
    		  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    /*
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
    		  ' SET TAP_SCRIPT_DECISION = '' '' '||
    		  ' WHERE TAP_CODIGO = ''T013_ObtencionContratoReserva'' ';
    		  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    */
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
    		  ' SET TAP_SCRIPT_DECISION = ''valores[''''T013_PosicionamientoYFirma''''][''''comboFirma''''] == DDSiNo.SI ? ''''ConFirma'''' : ''''SinFirma'''' '' '||
    		  ' WHERE TAP_CODIGO = ''T013_PosicionamientoYFirma'' ';
    		  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    /*
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
    		  ' SET TAP_SCRIPT_DECISION = '' '' '||
    		  ' WHERE TAP_CODIGO = ''T013_ResolucionExpediente'' ';
    		  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    */
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
    		  ' SET TAP_SCRIPT_DECISION = '' checkReserva() ? ''''ConReserva'''' : ''''SinReserva'''' '' '||
    		  ' WHERE TAP_CODIGO = ''T013_DevolucionLlaves'' ';
    		  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    /*
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
    		  ' SET TAP_SCRIPT_DECISION = '' '' '||
    		  ' WHERE TAP_CODIGO = ''T013_DocumentosPostVenta'' ';
    		  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    */
    
    
    /* ACTUALIZACIÓN DE PRECONDICIONES DE LA TAREA */

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''checkPoliticaCorporativa() ?  null : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' '' '||	  
			  ' WHERE TAP_CODIGO = ''T013_DefinicionOferta'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''checkPoliticaCorporativa() ?  null : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' '' '||	  
			  ' WHERE TAP_CODIGO = ''T013_FirmaPropietario'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''checkPoliticaCorporativa() ?  null : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' '' '||	  
			  ' WHERE TAP_CODIGO = ''T013_CierreEconomico'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''checkPoliticaCorporativa() ?  null : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' '' '||	  
			  ' WHERE TAP_CODIGO = ''T013_ResolucionComite'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''checkPoliticaCorporativa() ?  null : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' '' '||	  
			  ' WHERE TAP_CODIGO = ''T013_RespuestaOfertante'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''checkPoliticaCorporativa() ?  null : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' '' '||	  
			  ' WHERE TAP_CODIGO = ''T013_DobleFirma'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''checkPoliticaCorporativa() ?  null : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' '' '||	  
			  ' WHERE TAP_CODIGO = ''T013_InformeJuridico'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''checkPoliticaCorporativa() ?  null : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' '' '||	  
			  ' WHERE TAP_CODIGO = ''T013_InstruccionesReserva'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''checkPoliticaCorporativa() ?  null : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' '' '||	  
			  ' WHERE TAP_CODIGO = ''T013_ObtencionContratoReserva'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''checkPoliticaCorporativa() ?  null : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' '' '||	  
			  ' WHERE TAP_CODIGO = ''T013_ResolucionTanteo'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''checkPoliticaCorporativa() ?  null : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' '' '||	  
			  ' WHERE TAP_CODIGO = ''T013_ResultadoPBC'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''checkPoliticaCorporativa() ?  null : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' '' '||	  
			  ' WHERE TAP_CODIGO = ''T013_PosicionamientoYFirma'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''checkPoliticaCorporativa() ?  null : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' '' '||	  
			  ' WHERE TAP_CODIGO = ''T013_DevolucionLlaves'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''checkPoliticaCorporativa() ?  null : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' '' '||	  
			  ' WHERE TAP_CODIGO = ''T013_DocumentosPostVenta'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = '''' '||	  
			  ' WHERE TAP_CODIGO = ''T013_ResolucionExpediente'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    /* MODIFICACIÓN VALIDACIONES POSTTAREA */
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T013_PosicionamientoYFirma''''][''''comboFirma''''] == DDSiNo.SI ? (checkPosicionamiento() ? existeAdjuntoUGValidacion("15,E;19,E;17,E;18,E") : ''''El expediente debe tener algún posicionamiento'''') : null  '' '||
			  ' WHERE TAP_CODIGO = ''T013_PosicionamientoYFirma'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''checkEjerce() ? (existeAdjuntoUGValidacion("07,E")) : ''''No se puede avanzar la tarea si no tenemos resolución de tanteo''''  '' '||
			  ' WHERE TAP_CODIGO = ''T013_ResultadoPBC'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T013_FirmaPropietario''''][''''comboFirma''''] == DDSiNo.NO ? (valores[''''T013_FirmaPropietario''''][''''motivoAnulacion''''] ==  '''''''' ? ''''Si no se firma el motivo de anulación es obligatorio rellenarlo'''' : null ) : null  '' '||
			  ' WHERE TAP_CODIGO = ''T013_FirmaPropietario'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    
    /* DICCIONARIOS EN CAMPOS */
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_BUSINESS_OPERATION = ''DDSiNo'' '||
			  ' ,TFI_TIPO = ''combo'' '||
			  ' ,TFI_VALIDACION = ''false'' '||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_CierreEconomico'') '||
			  ' AND TFI_NOMBRE = ''numHonorarios'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    
    
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