--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20160113
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=0
--## PRODUCTO=SI
--##
--## Finalidad: Realiza las inserciones del trámite de Obtención Documento.
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
    V_TPO_COD VARCHAR2(20 CHAR):= 			'T002';
    V_TPO_DES VARCHAR2(100 CHAR):=			'Trámite de obtención documental';
    V_TPO_XML VARCHAR2(50 CHAR):=			'activo_tramiteDocumental';
    
    
    /* TABLAS: TAP_TAREA_PROCEDIMIENTO & DD_PTP_PLAZOS_TAREAS_PLAZAS */
    TYPE T_TAP IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TAP;
    V_TAP T_ARRAY_TAP := T_ARRAY_TAP(
    -- TAP_CODIGO
    -- TAP_DESCRIPCION
    -- DD_STA_CODIGO
    -- TAP_MAX_AUTOP
    -- DD_TGE_CODIGO
    -- DD_PTP_PLAZO_SCRIPT
    -- DD_TPO_ID_BPM
    -- TAP_SCRIPT_VALIDACION
    -- TAP_SCRIPT_VALIDACION_JBPM
    -- TAP_SCRIPT_DECISION
    	T_TAP('T002_AnalisisPeticion',
                'Análisis de la petición',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                'valores[''''T002_AnalisisPeticion''''][''''comboTramitar''''] == DDSiNo.NO ? (valores[''''T002_AnalisisPeticion''''][''''motivoDenegacion''''] == '''''''' ? ''''Si deniega la tramitaci&oacute; debe indicar un motivo'''' : null) : (valores[''''T002_AnalisisPeticion''''][''''numTarifa''''] == '''''''' ? ''''Si acepta la tramitaci&oacute; debe indicar la tarifa aplicable'''' : null)',
                'valores[''''T002_AnalisisPeticion''''][''''comboTramitar''''] == DDSiNo.NO ? ''''Fin'''' : (valores[''''T002_AnalisisPeticion''''][''''comboGasto''''] == DDSiNo.SI ? (valores[''''T002_AnalisisPeticion''''][''''comboSaldo''''] == DDSiNo.SI ? ''''OKConPagoYSaldo'''' : ''''OKConPagoYSinSaldo'''') : ''''OKSinPago'''') '),

    	T_TAP('T002_SolicitudLPOGestorInterno',
            	'Solicitud LPO por Gestor Interno',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '',
                ''),

    	T_TAP('T002_ObtencionLPOGestorInterno',
        		'Obtención LPO por Gestor Interno',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                'comprobarExisteAdjuntoActivoTarea() == false ? ''''Debe subirse el documento al trabajo'''' : null',
                '(valores[''''T002_ObtencionLPOGestorInterno''''][''''comboObtencion''''] == DDSiNo.NO && valores[''''T002_ObtencionLPOGestorInterno''''][''''motivoNoObtencion''''] == '''''''' ) ? ''''Si declina la obtenci&oacute;n del documento, debe indicar un motivo de no obtenci&oacute;n'''' : null',
                ''),

    	T_TAP('T002_SolicitudDocumentoGestoria',
        		'Solicitud Documento por gestoría',
               	'811',
               	'3',
                'GEST',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '',
                ''),

    	T_TAP('T002_ObtencionDocumentoGestoria',
        		'Obtención LPO por gestoría',
                '811',
                '3',
                'GEST',
                '3*24*60*60*1000L',
                'NULL',
                'comprobarExisteAdjuntoActivoTarea() == false ? ''''Debe subirse el documento al trabajo'''' : null',
                '(valores[''''T002_ObtencionDocumentoGestoria''''][''''comboObtencion''''] == DDSiNo.NO && valores[''''T002_ObtencionDocumentoGestoria''''][''''motivoNoObtencion''''] == '''''''' ) ? ''''Si declina la obtenci&oacute;n del documento, debe indicar un motivo de no obtenci&oacute;n'''' : null',
                ''),

    	T_TAP('T002_ValidacionActuacion',
        		'Validación de actuación',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '(valores[''''T002_ValidacionActuacion''''][''''comboObtencion''''] == DDSiNo.NO && valores[''''T002_ValidacionActuacion''''][''''motivoIncorreccion''''] == '''''''' ) ? ''''Si el documento no corresponde con la petici&oacute;n, debe indicar un motivo de incorrecci&oacute;n'''' : null',
                'valores[''''T002_ValidacionActuacion''''][''''comboCorreccion''''] == DDSiNo.NO ? (valores[''''T002_ValidacionActuacion''''][''''comboPagar''''] == DDSiNo.SI ? ''''CorrectoConCoste'''' : ''''CorrectoSinCoste'''') : ''''Incorrecto'''' ' ),

		T_TAP('T002_CierreEconomico',
        		'Cierre económico',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '',
                ''),

		T_TAP('T002_SolicitudExtraordinaria',
        		'Solicitud de disposición extraordinaria al propietario',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '',
                ''),

		T_TAP('T002_AutorizacionPropietario',
        		'Autorización del propietario',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '(valores[''''T002_AutorizacionPropietario''''][''''comboAmpliacion''''] == DDSiNo.SI && valores[''''T002_AutorizacionPropietario''''][''''numIncremento''''] == '''''''' ) ? ''''Si el propietario autoriza ampliaci&oacute;n de presupuesto, debe indicar el importe de incremento'''' : null',
                'valores[''''T002_AutorizacionPropietario''''][''''comboAmpliacion''''] == DDSiNo.SI ? ''''OK'''' : ''''Fin'''' ')
        );
    V_TMP_T_TAP T_TAP;

    
    /* TABLA: TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    --		   TAP_CODIGO						TFI_ORDEN	TFI_TIPO	TFI_NOMBRE				TFI_LABEL																																																																																		TFI_ERROR_VALIDACION											TFI_VALIDACION									TFI_BUSINESS_OPERATION
    	T_TFI('T002_AnalisisPeticion'			,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Se ha formulado una petición para la obtención de un documento, por lo que en la presente tarea deberá aceptar o rechazar la solicitud.</p><p>Si deniega la petición, deberá hacer constar el motivo y finalizará el trámite.</p><p>En el caso de que acepte la petición, deberá indicar si la gestión se va a encomendar a una gestoría o por el contrario va a ser realizada por un gestor interno. En este último caso la siguiente tarea será la de solicitud del documento por el gestor interno.</p><p>Si el trabajo se va a encargar a una gestoría, deberá indicar la tarifa que resulta de aplicación en la pestaña "gestión económica" del trabajo y, tras ello, comprobar si el importe resultante supera el límite presupuestario asignado al activo.</p><p>En el caso de que haya saldo suficiente, la siguiente tarea será la de solicitud del documento por la gestoría.</p><p>Por el contrario, en el caso de que no haya saldo suficiente asociado al activo, la siguiente tarea será la de "solicitud de disposición extraordinaria al propietario".</p><p>En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'                                                                                                                                                                          ,''                                                             ,''                                             ,''         ),
    	T_TFI('T002_AnalisisPeticion'			,'1'		,'combo'	,'comboTramitar'		,'Tramitar petición'																																																																															,''                                                            	,''												,'DDSiNo'	),
    	T_TFI('T002_AnalisisPeticion'			,'2'		,'textfield','motivoDenegacion'		,'Motivo de denegación'																																																																															,''																,''												,''			),
    	T_TFI('T002_AnalisisPeticion'			,'3'		,'combo'	,'comboGasto'			,'Se encargará a gestoría'																																																																														,''                                                             ,''												,'DDSiNo'	),
		T_TFI('T002_AnalisisPeticion'			,'4'		,'textinf'	,'saldoDisponible'		,'Saldo disponible'																																																																																,''																,''												,''			),
    	T_TFI('T002_AnalisisPeticion'			,'5'		,'combo'	,'comboSaldo'			,'Saldo positivo'																																																																																,''	                                                            ,''												,'DDSiNo'	),
    	T_TFI('T002_AnalisisPeticion'			,'6'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''			),
    	T_TFI('T002_SolicitudLPOGestorInterno'	,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para dar por completada esta tarea deberá consignar la fecha en que ha solicitado el documento correspondiente a la administración u organismo responsable.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'                                                                                                                                              ,''                                                             ,''                                             ,''         ),
		T_TFI('T002_SolicitudLPOGestorInterno'	,'1'		,'date'		,'fechaSolicitud'		,'Fecha solicitud documento'																																																																													,'Debe indicar la fecha de solicitud del documento'				,'false'										,''			),
		T_TFI('T002_SolicitudLPOGestorInterno'	,'2'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''			),
		T_TFI('T002_ObtencionLPOGestorInterno'	,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá subir una copia del documento a la pestaña "documentos" del trabajo, haciendo constar a continuación en esta tarea la fecha en que se emitió o se obtuvo aquél así como su referencia, en su caso.</p><p style="margin-bottom: 10px">En el supuesto de que no haya sido posible obtener el documento, deberá hacerlo constar así en el campo "imposibilidad de obtener el documento", anotando el motivo de tal imposibilidad.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p><p style="margin-bottom: 10px">Con la obtención del documento finaliza el trámite.</p>'                                                                                       ,''                                                             ,''                                             ,''         ),
		T_TFI('T002_ObtencionLPOGestorInterno'	,'3'		,'date'		,'fechaEmision'			,'Fecha emisión documento'																																																																														,''																,'false'										,''			),
		T_TFI('T002_ObtencionLPOGestorInterno'	,'4'		,'textfield','refDocumento'			,'Referencia del documento'																																																																														,''																,''												,''			),
		T_TFI('T002_ObtencionLPOGestorInterno'	,'1'		,'combo'	,'comboObtencion'		,'Obtención'																																																																																	,''	                                                            ,'false'										,'DDSiNo'	),
		T_TFI('T002_ObtencionLPOGestorInterno'	,'2'		,'textfield','motivoNoObtencion'	,'Motivo de no obtención'																																																																														,''	                                                            ,''												,''			),
		T_TFI('T002_ObtencionLPOGestorInterno'	,'5'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''			),
		T_TFI('T002_SolicitudDocumentoGestoria'	,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para dar por completada esta tarea deberá consignar la fecha en que ha solicitado a la administración u organismo responsable la expedición del documento.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p><p style="margin-bottom: 10px">La siguiente tarea que se lanzará en el trámite será la de obtención del documento.</p>'                                                                                                                                               ,''                                                             ,''                                             ,''         ),
		T_TFI('T002_SolicitudDocumentoGestoria' ,'1'		,'date'		,'fechaSolicitud'		,'Fecha solicitud documento'																																																																													,'Debe indicar la fecha de solicitud del documento'				,'false'										,''			),
		T_TFI('T002_SolicitudDocumentoGestoria'	,'2'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''			),
		T_TFI('T002_ObtencionDocumentoGestoria'	,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá subir una copia del documento obtenido a la pestaña "documentos" del trabajo, haciendo constar a continuación en esta tarea la fecha en que se emitió o se obtuvo aquél así como su referencia, en su caso.</p><p style="margin-bottom: 10px">En el supuesto de que no sea posible obtener el documento, deberá hacerlo constar así en el campo "imposibilidad de obtener el documento", anotando el motivo de tal imposibilidad.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'                                                                                     ,''                                                             ,''                                             ,''         ),
		T_TFI('T002_ObtencionDocumentoGestoria'	,'3'		,'date'		,'fechaEmision'			,'Fecha emisión documento'																																																																														,''																,'false'										,''			),
		T_TFI('T002_ObtencionDocumentoGestoria'	,'4'		,'textfield','refDocumento'			,'Referencia del documento'																																																																														,''					    										,''												,''			),
		T_TFI('T002_ObtencionDocumentoGestoria'	,'1'		,'combo'	,'comboObtencion'		,'Obtención'																																																																																	,''	                                                            ,'false'										,'DDSiNo'	),
		T_TFI('T002_ObtencionDocumentoGestoria'	,'2'		,'textfield','motivoNoObtencion'	,'Motivo de no obtención'																																																																														,''																,''												,''			),
		T_TFI('T002_ObtencionDocumentoGestoria'	,'5'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''			),
		T_TFI('T002_ValidacionActuacion'		,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Antes de dar por terminada esta tarea, deberá acceder a la pestaña "documentos" del trabajo y comprobar que el documento que se ha subido a la aplicación es el que se había solicitado, haciendo constar en el campo "corrección del documento" si se corresponde con la petición realizada. En caso negativo, deberá hacer consta el motivo de la incorrección.</p><p style="margin-bottom: 10px">Tras hacer constar la fecha en que ha finalizado la tarea y la valoración que concede al proveedor, puede utilizar el campo "observaciones" para consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p><p style="margin-bottom: 10px">En el caso de que el documento sea correcto, la siguiente tarea será la de "emisión pre-factura". En el supuesto de que el documento subido sea incorrecto, se lanzará de nuevo al proveedor la tarea de solicitud del documento.</p>'                                                                                                                                 ,''                                                             ,''                                             ,''         ),
		T_TFI('T002_ValidacionActuacion'		,'1'		,'date'		,'fechaValidacion'		,'Fecha validación'																																																																																,'Debe indicar la fecha de validaci&oacute;n del documento'		,'false'										,''			),
		T_TFI('T002_ValidacionActuacion'		,'2'		,'combo'	,'comboCorreccion'		,'Corrección del documento'																																																																														,''					                                            ,''												,'DDSiNo'	),
		T_TFI('T002_ValidacionActuacion'		,'3'		,'textfield','motivoIncorreccion'	,'Motivo de la incorrección'																																																																													,''																,''												,''			),
		T_TFI('T002_ValidacionActuacion'		,'4'		,'combo'	,'comboValoracion'		,'Valoración del proveedor'																																																																														,''																,''												,'DDTipoCalidad'),
		T_TFI('T002_ValidacionActuacion'		,'5'		,'combo'	,'comboPagar'			,'Procede pagar'																																																																																,'Debe indicar si procede pagar'								,'false'										,'DDSiNo'	),	
		T_TFI('T002_ValidacionActuacion'		,'6'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''			),
		T_TFI('T002_CierreEconomico'			,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para dar por cumplimentada esta tarea deberá realizar el cierre económico del trabajo.</p><p>Para ello, si no lo ha hecho previamente, deberá seleccionar la tarifa que resulta de aplicación en la pestaña "gestión económica" del trabajo, cumplimentando a continuación, en su caso, los importes correspondientes a cada uno de sus bloques.</p><p>Debe tener en cuenta que, una vez cumplimentada esta tarea, ya no podrá modificar los importes que se hayan hecho constar en la pestaña de "gestión económica", que serán los que se tomarán para el proceso de facturación.</p><p>En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p><p>Esta tarea pone fin al trámite de obtención de documento.</p>'																													,''																,''												,''			),
		T_TFI('T002_CierreEconomico'			,'1'		,'date'		,'fechaCierre'			,'Fecha cierre económico'																																																																														,''																,''												,''			),
		T_TFI('T002_CierreEconomico'			,'2'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''			),
		T_TFI('T002_SolicitudExtraordinaria'	,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para dar por terminada esta tarea debe hacer constar la fecha en que ha solicitado al propietario del activo una provisión extraordinaria de fondos por no disponer el activo de fondos suficientes para hacer frente al coste del trabajo.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'															,''																,''												,''			),
		T_TFI('T002_SolicitudExtraordinaria'	,'1'		,'date'		,'fecha'				,'Fecha'																																																																																		,'Debe indicar la fecha de solicitud extraordinaria'			,'false'										,''			),
		T_TFI('T002_SolicitudExtraordinaria'	,'2'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''			),
		T_TFI('T002_AutorizacionPropietario'	,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para cumplimentar esta tarea debe anotar la fecha en que ha recibido la respuesta del propietario aceptando o rechazando una ampliación del presupuesto asociado al activo.</p><p style="margin-bottom: 10px">En el caso de que la ampliación del presupuesto sea rechazada por el propietario, el trámite concluirá ya que no podrá llevarse a cabo la actuación por falta de saldo.</p><p style="margin-bottom: 10px">En caso de que se conceda la ampliación de presupuesto solicitada, deberá anotar su importe. La siguiente tarea será la de solicitud del documento.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'																																,''																,''												,''			),
		T_TFI('T002_AutorizacionPropietario'	,'1'		,'date'		,'fecha'				,'Fecha'																																																																																		,'Debe indicar la fecha de autorizaci&oacute;n'					,'false'										,''			),
		T_TFI('T002_AutorizacionPropietario'	,'2'		,'combo'	,'comboAmpliacion'		,'Ampliación del presupuesto'																																																																													,''	                                                            ,''												,'DDSiNo'	),
    	T_TFI('T002_AutorizacionPropietario'	,'3'		,'number'	,'numIncremento'		,'Importe del incremento'																																																																														,''																,''												,''			),
		T_TFI('T002_AutorizacionPropietario'	,'4'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''			)		
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
		V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TAC_TIPO_ACTUACION.NEXTVAL FROM DUAL';
	    	EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION (' ||
					'DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) '||
					'VALUES ('||V_ENTIDAD_ID||','''||V_TIPO_ACT_COD||''','''||V_TIPO_ACT_DES||''','''||V_TIPO_ACT_DES||''',	1, ''REM_F1'', SYSDATE, 0)';
			EXECUTE IMMEDIATE V_MSQL;
			
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