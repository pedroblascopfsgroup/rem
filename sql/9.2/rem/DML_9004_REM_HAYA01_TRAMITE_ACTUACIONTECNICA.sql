--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20160119
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=0
--## PRODUCTO=SI
--##
--## Finalidad: Realiza las inserciones del trámite de Actuación Técnica.
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
    V_TPO_COD VARCHAR2(20 CHAR):= 			'T004';
    V_TPO_DES VARCHAR2(100 CHAR):=			'Trámite de actuación técnica';
    V_TPO_XML VARCHAR2(50 CHAR):=			'activo_tramiteActuacionTecnica';
    
    
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

    	T_TAP('T004_AnalisisPeticion',
                'Análisis de la petición',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                'valores[''''T004_AnalisisPeticion''''][''''comboTramitar''''] == DDSiNo.NO ? (valores[''''T004_AnalisisPeticion''''][''''motivoDenegacion''''] == '''''''' ? ''''Si deniega la petici&oacute;n debe indicar un motivo'''' : null) : ((valores[''''T004_AnalisisPeticion''''][''''comboCubierto''''] == DDSiNo.SI && valores[''''T004_AnalisisPeticion''''][''''comboAseguradoras''''] == '''''''' ) ? ''''Si el trabajo est&aacute; cubierto, debe indicar la compa&ntilde;&iacute;a de seguros'''' : null)',
                'valores[''''T004_AnalisisPeticion''''][''''comboTramitar''''] == DDSiNo.NO ? ''''KO'''' : (valores[''''T004_AnalisisPeticion''''][''''comboTarifa''''] == DDSiNo.SI ? ''''OKTarificada'''' : ''''OKNoTarificada'''')'
            ),    	

    	T_TAP('T004_SolicitudPresupuestos',
                'Solicitud presupuestos',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '',
                ''
            ),

    	T_TAP('T004_EleccionPresupuesto',
                'Elección presupuesto',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                'comprobarExistePresupuestoTrabajo() == false? ''''Debe asignar al menos un presupuesto al trabajo'''' : null',
                'valores[''''T004_EleccionPresupuesto''''][''''comboPresupuesto''''] == DDSiNo.NO ? (valores[''''T004_EleccionPresupuesto''''][''''motivoInvalidez''''] == ''''''''  ? ''''Si no hay presupuesto v&aacute;lido, debe indicar un motivo de invalidez'''' : null) : (valores[''''T004_EleccionPresupuesto''''][''''fechaEmision''''] == ''''''''  ? ''''Si hay presupuesto v&aacute;lido, debe indicar la fecha de selecci&oacute;n'''' : null)',
                'valores[''''T004_EleccionPresupuesto''''][''''comboPresupuesto''''] == DDSiNo.NO ? ''''PresupuestoInvalido'''' : ''''PresupuestoValido'''' '
            ),

		T_TAP('T004_EleccionProveedorYTarifa',
                'Eleccion proveedor y tarifa',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '(comprobarExisteProveedorTrabajo() == false && comprobarExisteTarifaTrabajo() == false) ? ''''Debe asignar al menos un proveedor y al menos una tarifa al trabajo.'''' : (comprobarExisteProveedorTrabajo() == false ? ''''Debe asignar al menos un proveedor al trabajo.'''' : (comprobarExisteTarifaTrabajo() == false ? ''''Debe asignar al menos una tarifa al trabajo.'''' : null ) )',
                ''
            ),

    	T_TAP('T004_DisponibilidadSaldo',
                'Disponibilidad de saldo',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '',
                'valores[''''T004_DisponibilidadSaldo''''][''''comboSaldo''''] == DDSiNo.NO ? ''''SuperaLimite'''' : ''''ConSaldo'''' ' 
            ),

		T_TAP('T004_SolicitudExtraordinaria',
                'Solicitud disposición extraordinaria al propietario',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '',
                ''
            ),

		T_TAP('T004_AutorizacionPropietario',
                'Autorización del propietario',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '(valores[''''T004_AutorizacionPropietario''''][''''comboAmpliacion''''] == DDSiNo.SI && valores[''''T004_AutorizacionPropietario''''][''''numIncremento''''] == '''''''' ) ? ''''En caso de que se conceda la ampliaci&oacute;n de presupuesto solicitada, deber&aacute; anotar su importe'''' : null',
                'valores[''''T004_AutorizacionPropietario''''][''''comboAmpliacion''''] == DDSiNo.SI ? ''''OK'''' : ''''KO'''' '
            ),

		T_TAP('T004_FijacionPlazo',
                'Fijación plazo de ejecución del trabajo',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '',
                'valores[''''T004_AnalisisPeticion''''][''''comboTarifa''''] == DDSiNo.SI ? ''''Tarificada'''' : ''''NoTarificada''''  '
            ),

		T_TAP('T004_ResultadoTarificada',
                'Resultado actuación técnica tarificada',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '',
                ''
            ),

		T_TAP('T004_ResultadoNoTarificada',
                'Resultado actuación técnica no tarificada',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '(valores[''''T004_ResultadoNoTarificada''''][''''comboModificacion''''] == DDSiNo.NO && valores[''''T004_ResultadoNoTarificada''''][''''fechaFinalizacion''''] == '''''''' ) ? ''''Si ya ha finalizado el trabajo, deber&aacute; indicar la fecha de finalizaci&oacute;n'''' : null',
                'valores[''''T004_ResultadoNoTarificada''''][''''comboModificacion''''] == DDSiNo.SI ? ''''ModificacionPresupuesto'''' : ''''Ejecutado'''' '
            ),

		T_TAP('T004_SolicitudPresupuestoComplementario',
                'Solicitud presupuesto complementario',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '',
                ''
            ),

		T_TAP('T004_ValidacionTrabajo',
                'Validación trabajo',
                '811',
                '3',
                'GACT',
                '3*24*60*60*1000L',
                'NULL',
                '',
                'valores[''''T004_ValidacionTrabajo''''][''''comboEjecutado''''] == DDSiNo.NO ? (valores[''''T004_ValidacionTrabajo''''][''''motivoIncorreccion''''] == '''''''' ? ''''Si el trabajo no se ha ejecutado de forma correcta, debe indicar el motivo'''' : null) : (valores[''''T004_ValidacionTrabajo''''][''''comboValoracion''''] == '''''''' ? ''''Debe indicar la valoraci&oacute;n del proveedor'''' : null)',
                'valores[''''T004_ValidacionTrabajo''''][''''comboEjecutado''''] == DDSiNo.SI ? ''''OK'''' : ''''KO'''' '
            ),

		T_TAP('T004_CierreEconomico',
                'Cierre económico',
                '811',
                '3',
                'GACT',
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
    --		   TAP_CODIGO								TFI_ORDEN	TFI_TIPO		TFI_NOMBRE				TFI_LABEL																																																																									TFI_ERROR_VALIDACION											TFI_VALIDACION									TFI_BUSINESS_OPERATION
    	T_TFI('T004_AnalisisPeticion'					,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Se ha formulado una petición de una actuación técnica, por lo que en la presente tarea deberá indicar si la acepta y se ejecuta el trabajo, o no.</p><p>Si deniega la petición deberá hacer constar el motivo, finalizándose el trámite.</p><p>Si acepta la petición, deberá indicar si el activo dispone de un seguro que cubra el trabajo y, en caso afirmativo, seleccionar la compañía de seguros a fin de que se le remita una notificación informándole del trabajo a realizar.</p><p>Si acepta la petición y el trabajo no está sujeto a una tarifa, la siguiente tarea será la de solicitud de presupuestos a proveedores.</p><p>Si acepta la petición y el trabajo está sujeto a una tarifa, la siguiente tarea será la de elección de tarifa y, en su caso, proveedor.</p><p>En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'																																		 	,''																,''												,''					),
    	T_TFI('T004_AnalisisPeticion'					,'1'		,'combo'	,'comboTramitar'		,'Tramitar petición'																																																																							,''	                                                            ,''                                 			,'DDSiNo'			),
    	T_TFI('T004_AnalisisPeticion'					,'2'		,'combo'	,'comboCubierto'		,'Cubierto por seguro'																																																																						  	,''	                                                            ,''                                 			,'DDSiNo'			),
    	T_TFI('T004_AnalisisPeticion'					,'3'		,'comboesp'	,'comboAseguradoras'	,'Compañía de seguros'																																																																						    ,''	                                                            ,''                                      		,'DDSeguros'		),
	    T_TFI('T004_AnalisisPeticion'					,'4'		,'comboini'	,'comboTarifa'			,'Sujeto a tarifa'																																																																							  	,''	                                                            ,''                                      		,'DDSiNo'			),
    	T_TFI('T004_AnalisisPeticion'					,'5'		,'textfield','motivoDenegacion'		,'Motivo de denegación'																																																																						   	,''																,''												,''					),
    	T_TFI('T004_AnalisisPeticion'					,'6'		,'textarea'	,'observaciones'		,'Observaciones'																																																																								,''																,''												,''					),
    	T_TFI('T004_SolicitudPresupuestos'				,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Puesto que la actuación no está tarificada, es necesario solicitar presupuestos a proveedores.</p><p style="margin-bottom: 10px">En la presente tarea deberá indicar la fecha en que efectúa dicha solicitud.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto que considere relevante y que debe quedar reflejado en este punto del trámite.</p>'																																															  	,''																,''												,''					),
		T_TFI('T004_SolicitudPresupuestos'				,'1'		,'date'		,'fechaEmision'			,'Fecha solicitud presupuestos a proveedores'																																																																    ,'Debe indicar fecha de emisi&oacute;n'						    ,'false'										,''					),
		T_TFI('T004_SolicitudPresupuestos'				,'2'		,'textarea'	,'observaciones'		,'Observaciones'																																																																							    ,''																,''												,''					),
		T_TFI('T004_EleccionPresupuesto'				,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Una vez recibidos los presupuestos de los proveedores, debe proceder a la elección de uno de ellos.</p><p>Para ello, con carácter previo a la cumplimentación de la presente tarea, deberá anotar la información relativa a los presupuestos recibidos en la pestaña "gestión económica" del trabajo, autorizando uno de ellos.</p><p>Si no puede aceptar ningún presupuesto porque ninguno de los que le han sido remitidos es válido, deberá hacer constar el motivo. En este caso, la siguiente tarea del trámite será de nuevo la de "solicitud presupuestos".</p><p>En el caso de que sí que haya algún presupuesto que pueda ser seleccionado, deberá hacer constar la fecha en que efectúa la elección. En este caso la siguiente tarea que se lanzará será la de "disponibilidad de saldo".</p><p>En el campo "observaciones" puede consignar cualquier aspecto que considere levante  y que debe quedar reflejado en este punto del trámite.</p>'																							  	,''																,''												,''					),
	    T_TFI('T004_EleccionPresupuesto'				,'1'		,'combo'	,'comboPresupuesto'		,'Presupuesto válido'																																																																						  	,''	                                                            ,''                                      		,'DDSiNo'			),
    	T_TFI('T004_EleccionPresupuesto'				,'2'		,'textfield','motivoInvalidez'		,'Motivo invalidez'																																																																							 	,''																,''												,''					),
		T_TFI('T004_EleccionPresupuesto'				,'3'		,'date'		,'fechaEmision'			,'Fecha selección presupuestos a proveedores'																																																																  	,''																,''												,''					),
	    T_TFI('T004_EleccionPresupuesto'				,'4'		,'textarea'	,'observaciones'		,'Observaciones'																																																																							  	,''																,''												,''					),
		T_TFI('T004_EleccionProveedorYTarifa'			,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Una vez aceptada la ejecución del trabajo y estando el mismo sujeto a tarifa, en la presente tarea deberá anotar la fecha en que ha elegido el proveedor y seleccionado la tarifa que aplica.</p><p style="margin-bottom: 10px">Ambas acciones deberá realizarlas en la pestaña "gestión económica" del trabajo.</p><p style="margin-bottom: 10px">Una vez seleccionado el proveedor y la o las tarifas que aplican, la siguiente tarea será la de fijación del plazo de ejecución del trabajo.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'																							  	,''																,''												,''					),
		T_TFI('T004_EleccionProveedorYTarifa'			,'3'		,'date'		,'fechaEmision'			,'Fecha de elección de proveedor y tarifa'																																																																	    ,'Debe indicar la fecha de emisi&oacute;n'				        ,'false'										,''					),
	    T_TFI('T004_EleccionProveedorYTarifa'			,'4'		,'textarea'	,'observaciones'		,'Observaciones'																																																																							  	,''																,''												,''					),
	    T_TFI('T004_DisponibilidadSaldo'				,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">En la presente tarea deberá indicar si el importe del presupuesto seleccionado o el resultante de la aplicación de la tarifa correspondiente al trabajo, superan el saldo disponible del presupuesto anual asignado al activo.</p><p style="margin-bottom: 10px">En el caso de que haya saldo suficiente, la siguiente tarea será la de asignación del trabajo al proveedor.</p><p style="margin-bottom: 10px">Por el contrario, en el caso de que no haya saldo suficiente, la siguiente tarea será la de "solicitud de disposición extraordinaria al propietario".</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'													 	,''																,''												,''					),
    	T_TFI('T004_DisponibilidadSaldo'				,'1'		,'combo'	,'comboSaldo'			,'Saldo suficiente'																																																																								,''	                                                            ,''                                       		,'DDSiNo'			),
		T_TFI('T004_DisponibilidadSaldo'				,'2'		,'textarea'	,'observaciones'		,'Observaciones'																																																																							 	,''																,''												,''					),
		T_TFI('T004_SolicitudExtraordinaria'			,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para dar por terminada esta tarea debe hacer constar la fecha en que ha solicitado al propietario del activo una provisión extraordinaria de fondos por no disponer el activo de saldo suficiente para hacer frente al coste del trabajo.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'						,''																,''												,''					),
		T_TFI('T004_SolicitudExtraordinaria'			,'1'		,'date'		,'fecha'				,'Fecha'																																																																									 	,'Debe indicar la fecha de solicitud extraordinaria'			,'false'										,''					),
		T_TFI('T004_SolicitudExtraordinaria'			,'2'		,'textarea'	,'observaciones'		,'Observaciones'																																																																							  	,''																,''												,''					),
		T_TFI('T004_AutorizacionPropietario'			,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para cumplimentar esta tarea debe anotar la fecha en que ha recibido la respuesta del propietario aceptando o rechazando una ampliación del presupuesto asociado al activo.</p><p style="margin-bottom: 10px">En el caso de que la ampliación del presupuesto sea rechazada por el propietario, el trámite concluirá ya que no podrá llevarse a cabo la actuación por falta de saldo.</p><p style="margin-bottom: 10px">En caso de que se conceda la ampliación de presupuesto solicitada, deberá anotar su importe. En este caso, la siguiente tarea será la de "fijación de plazo de ejecución".</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'																							 	,''																,''												,''					),
		T_TFI('T004_AutorizacionPropietario'			,'1'		,'date'		,'fecha'				,'Fecha'																																																																									 	,'Debe indicar la fecha de autorizaci&oacute;n'					,'false'										,''					),
		T_TFI('T004_AutorizacionPropietario'			,'2'		,'combo'	,'comboAmpliacion'		,'Ampliación del presupuesto'																																																																				 	,''			                                                    ,''												,'DDSiNo'			),
    	T_TFI('T004_AutorizacionPropietario'			,'3'		,'number'	,'numIncremento'		,'Importe del incremento'																																																																					  	,''																,''												,''					),
		T_TFI('T004_AutorizacionPropietario'			,'4'		,'textarea'	,'observaciones'		,'Observaciones'																																																																							  	,''																,''												,''					),		
		T_TFI('T004_FijacionPlazo'						,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para dar por cumplimentada esta tarea deberá fijar el plazo del que dispone el proveedor para ejecutar el trabajo.</p><p style="margin-bottom: 10px">Por defecto, el proveedor dispondrá de un plazo de (por determinar) días para ejecutar el trabajo salvo que se haya indicado que debe ejecutarlo en una fecha concreta. No obstante, si lo desea, puede modificar dicho plazo anotando uno diferente en el campo correspondiente de la presente tarea.</p><p style="margin-bottom: 10px">Una vez cumplimentada la presente tarea, se le remitirá una notificación al proveedor informándole de los términos del trabajo que debe ejecutar.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'													  	,''																,''												,''					),
		T_TFI('T004_FijacionPlazo'						,'1'		,'date'		,'fechaTope'			,'Plazo tope ejecución trabajo'																																																																					,''										    					,''												,''					),
		T_TFI('T004_FijacionPlazo'						,'2'		,'datemaxtod'		,'fechaConcreta'		,'Plazo concreto ejecución trabajo'																																																																				,''																,''												,''					),
		T_TFI('T004_FijacionPlazo'						,'3'		,'time'		,'horaConcreta'			,'Hora concreta ejecución trabajo'																																																																				,''																,''												,''					),
		T_TFI('T004_FijacionPlazo'						,'4'		,'textarea'	,'observaciones'		,'Observaciones'																																																																							 	,''																,''												,''					),
		T_TFI('T004_ResultadoTarificada'				,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Como proveedor responsable de la ejecución del presente trabajo, en esta tarea deberá indicar la fecha en que lo ha finalizado.</p><p style="margin-bottom: 10px">Previamente, deberá subir a la pestaña fotos del trabajo correspondiente las imágenes que acrediten su correcta ejecución.</p><p style="margin-bottom: 10px">Por otra parte, si al ejecutar el trabajo ha realizado otros que no estaban inicialmente previstos, deberá añadir los mismos en la lista de tarifas que se contiene en la pestaña gestion económica del trabajo.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'																  	,''																,''												,''					),
		T_TFI('T004_ResultadoTarificada'				,'1'		,'date'		,'fechaFinalizacion'	,'Fecha finalización'																																																																						 	,'Debe indicar una fecha de finalizaci&oacute;n'				,'false'										,''					),
		--T_TFI('T004_ResultadoTarificada'				,'2'		,'combo'	,'comboOtrosTrabajos'	,'Otros trabajos'																																																																							   	,''							                                    ,''												,'DDSiNo'			),
		T_TFI('T004_ResultadoTarificada'				,'2'		,'textarea'	,'observaciones'		,'Observaciones'																																																																							 	,''																,''												,''					),
		T_TFI('T004_ResultadoNoTarificada'				,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Como proveedor responsable de la ejecución del presente trabajo, en esta tarea deberá realizar una de las siguientes actuaciones:</p><p style="margin-bottom: 10px">  1) Si ya ha finalizado el trabajo, deberá indicar la fecha de dicha finalización. Previamente deberá subir a la pestaña fotos del trabajo las imágenes que acrediten su correcta ejecución.</p><p style="margin-bottom: 10px">  2) Si no ha ejecutado el trabajo porque hay que modificar el presupuesto, deberá indicarlo así en el campo correspondiente de la presente tarea, subiendo en su caso a la pestaña fotos del trabajo las imágenes que acrediten el incremento de presupuesto que se solicita.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'																	,''																,''												,''					),
		T_TFI('T004_ResultadoNoTarificada'				,'1'		,'combo'	,'comboModificacion'	,'Solicita una modificación del presupuesto'																																																																  	,''	                                                            ,''												,'DDSiNo'			),
		T_TFI('T004_ResultadoNoTarificada'				,'2'		,'date'		,'fechaFinalizacion'	,'Fecha finalización'																																																																						    ,''																,''												,''					),
		T_TFI('T004_ResultadoNoTarificada'				,'3'		,'textarea'	,'observaciones'		,'Observaciones'																																																																							    ,''																,''												,''					),
		T_TFI('T004_SolicitudPresupuestoComplementario'	,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">El proveedor ha solicitado una modificación del presupuesto presentado inicialmente por lo que, con carácter previo a la cumplimentación de la presente tarea, deberá anotar la información relativa al nuevo presupuesto en la pestaña "gestión económica" del trabajo y proceder a su autorización.</p><p style="margin-bottom: 10px">Una vez cumplimentada la presente tarea, la siguiente que se lanzará será la de "disponibilidad de saldo".</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'																  	,''																,''												,''					),
		T_TFI('T004_SolicitudPresupuestoComplementario'	,'1'		,'date'		,'fechaFinalizacion'	,'Fecha de autorización'																																																																					    ,'Debe indicar la fecha de finalizaci&oacute;n'					,'false'										,''					),
		T_TFI('T004_SolicitudPresupuestoComplementario'	,'2'		,'textarea'	,'observaciones'		,'Observaciones'																																																																							 	,''																,''												,''					),
		T_TFI('T004_ValidacionTrabajo'					,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Antes de anotar la fecha en que valida la actuación, deberá comprobar que el trabajo ha sido ejecutado correctamente, visualizando en su caso las fotografías subidas por el proveedor para acreditar tal extremo.</p><p>En el campo "el trabajo se ha ejecutado de forma correcta" deberá hacer constar si el trabajo ejecutado se ha realizado adecuadamente y se corresponde con la petición realizada. En caso negativo, deberá detallar la incorrección.</p><p>Si el trabajo ha sido finalizado, deberá valorar al proveedor.</p><p>Puede utilizar el campo "observaciones" para consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p><p>En el caso de que el trabajo se haya ejecutado de forma correcta, la siguiente tarea será la de "emisión pre-factura".</p><p>En el caso de que no se acepte el trabajo realizado, la siguiente tarea será nuevamente la de "fijación de plazo de ejecución".</p>'																	  	,''																,''												,''					),
		T_TFI('T004_ValidacionTrabajo'					,'1'		,'combo'	,'comboEjecutado'		,'Trabajo ejecutado correctamente'																																																																			  	,''		                                                        ,''												,'DDSiNo'			),
    	T_TFI('T004_ValidacionTrabajo'					,'2'		,'textfield','motivoIncorreccion'	,'Motivo de la incorrección'																																																																				  	,''																,''												,''					),
		T_TFI('T004_ValidacionTrabajo'					,'4'		,'date'		,'fechaValidacion'		,'Fecha de validación'																																																																							,'Debe indicar la fecha de validación'							,'false'										,''					),
    	T_TFI('T004_ValidacionTrabajo'					,'5'		,'combo'	,'comboValoracion'		,'Valoración del proveedor'																																																																					  	,''																,''												,'DDTipoCalidad'	),
    	T_TFI('T004_ValidacionTrabajo'					,'6'		,'textarea'	,'observaciones'		,'Observaciones'																																																																							    ,''																,''												,''					),		
		T_TFI('T004_CierreEconomico'					,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para dar por cumplimentada esta tarea deberá realizar el cierre económico del trabajo.</p><p>Para ello deberá cumplimentar los importes correspondientes a cada uno de los bloques de la pestaña "gestión económica" del trabajo.</p><p>Debe tener en cuenta que, una vez cumplimentada esta tarea, ya no podrá modificar los importes que se hayan hecho constar en la pestaña de "gestión económica", que serán los que se tomarán para el proceso de facturación.</p><p>En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p><p>Esta tarea pone fin al trámite de actuación técnica.</p>'																					,''																,''												,''					),
    	T_TFI('T004_CierreEconomico'					,'1'		,'date'		,'fechaCierre'			,'Fecha de cierre económico'																																																																							   	,'Debe indicar la fecha de emisi&oacute;n'					    ,'false'										,''					),
		T_TFI('T004_CierreEconomico'					,'2'		,'textarea'	,'observaciones'		,'Observaciones'																																																																							  	,''																,''												,''					)	
		
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