--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160912
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-763
--## PRODUCTO=SI
--##
--## Finalidad: Realiza las modificaciones necesarias para el trámite de información.
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
    V_TPO_COD VARCHAR2(20 CHAR):= 			'T009';
    V_TPO_DES VARCHAR2(100 CHAR):=			'Trámite de propuesta de precios';
    V_TPO_XML VARCHAR2(50 CHAR):=			'activo_tramitePropuestaPrecios';
    
    
    /* TABLAS: TAP_TAREA_PROCEDIMIENTO & DD_PTP_PLAZOS_TAREAS_PLAZAS */
    TYPE T_TAP IS TABLE OF VARCHAR2(1000);
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

    	T_TAP('T009_AnalisisPeticion',
    			'Análisis de la petición',
    			'811',
    			'3',
    			'GPREC',
    			'3*24*60*60*1000L',
    			'NULL',
    			'',
    			'valores[''''T009_AnalisisPeticion''''][''''comboTramitar''''] == DDSiNo.NO ? (valores[''''T009_AnalisisPeticion''''][''''motivoDenegacion''''] == '''''''' ? ''''Si deniega la tramitaci&oacute; debe indicar un motivo'''' : null) : null',
    			'valores[''''T009_AnalisisPeticion''''][''''comboTramitar''''] == DDSiNo.SI ? ''''OK'''' : ''''KO'''' '
    	),    	

    	T_TAP('T009_GenerarPropuestaPrecios',
    			'Generar propuesta de precios',
    			'811',
    			'3',
    			'GPREC',
    			'3*24*60*60*1000L',
    			'NULL',
    			'',
    			'',
    			''
    	),

		T_TAP('T009_EnvioPropuestaPropietario',
				'Env&iacute;o de la propuesta al propietario',
				'811',
				'3',
				'GPREC',
				'3*24*60*60*1000L',
				'NULL',
    			'',
    			'',
				''
		),
		
		T_TAP('T009_SancionCargaPropuesta',
				'Sanci&oacute;n y carga de la propuesta de precios',
				'811',
				'3',
				'GPREC',
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
    --		   TAP_CODIGO						TFI_ORDEN	TFI_TIPO	TFI_NOMBRE				TFI_LABEL																																																																																		TFI_ERROR_VALIDACION											TFI_VALIDACION									TFI_BUSINESS_OPERATION
   -- 	T_TFI('T005_ComprobacionGestor'			,'0'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''					),
    	T_TFI('T009_AnalisisPeticion'			,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Se ha formulado una solicitud para la generaci&oacute;n de una propuesta de precios.</p>'																																									,''																,''												,''					),
    	T_TFI('T009_AnalisisPeticion'			,'1'		,'combo'	,'comboTramitar'		,'Tramitar petición'																																																																															,''																,''												,'DDSiNo'			),
        T_TFI('T009_AnalisisPeticion'           ,'2'        ,'textfield','motivoDenegacion'     ,'Motivo de denegación'                                                                                                                                                                                                                                                                                                                         ,''                                                             ,''                                             ,''                 ),
    	T_TFI('T009_AnalisisPeticion'			,'3'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''					),
    	T_TFI('T009_GenerarPropuestaPrecios'			,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&aacute; generar una propuesta de precios</p>'											,''																,''												,''					),
		T_TFI('T009_GenerarPropuestaPrecios'			,'1'		,'datemaxtod'		,'fechaGeneracion'			,'Fecha generaci&oacute;n propuesta'																																																																														,'Debe indicar la fecha de generaci&oacute;n de la propuesta'	,'false'										,''					),
		T_TFI('T009_GenerarPropuestaPrecios'			,'2'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''					),
		T_TFI('T009_EnvioPropuestaPropietario'			,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para dar por cumplimentada esta tarea deber&aacute; enviar la propuesta al propietario</p>'																														,''																,''												,''					),
        T_TFI('T009_EnvioPropuestaPropietario'            ,'1'        ,'datemaxtod'     ,'fechaEnvio'          ,'Fecha env&iacute;o al propietario'                                                                                                                                                                                                                                                                                                                       ,'Debe indicar la fecha de env&iacute;o de la propuesta'             ,'false'                                        ,''                 ),
		T_TFI('T009_EnvioPropuestaPropietario'			,'2'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''					),
		T_TFI('T009_SancionCargaPropuesta'	,'0'		,'label'	,'titulo'				,'<p style="margin-bottom: 10px">Para dar por terminada esta tarea debe cargar la propuesta que ha sido modificada y remitida por el propietario, con la lista validada de precios.</p>'															,''																,''												,''					),
        T_TFI('T009_SancionCargaPropuesta'  ,'1'        ,'datemaxtod'     ,'fechaSancion'               ,'Fecha sanci&oacute;n propuesta'                                                                                                                                                                                                                                                                                                                                        ,'Debe indicar la fecha de sanci&oacute;n de la propuesta'            ,'false'                                        ,''                 ),
        T_TFI('T009_SancionCargaPropuesta'	,'2'		,'datemaxtod'		,'fechaCarga'				,'Fecha carga propuesta'																																																																																		,'Debe indicar la fecha de carga de la propuesta'			,'false'										,''					),
		T_TFI('T009_SancionCargaPropuesta'	,'3'		,'textarea'	,'observaciones'		,'Observaciones'																																																																																,''																,''												,''					)
		);
    V_TMP_T_TFI T_TFI;
    
    
    
 -- ## FIN DATOS DEL TRÁMITE
 -- ########################################################################################
    
    
    /* ################################################################################
     ## MODIFICACIONES: Se cambia la decisión BPM del trámite de propuesta de precios.
     ## Actualizamos TAP_TAREA
     ## Actualizamos TFI segun codigo y orden, si no existe -> se crea
     ##
     */  
BEGIN    
    
    -- Actulizar las tareas del tramite, nuevas validaciones.
   FOR I IN V_TAP.FIRST .. V_TAP.LAST
      LOOP
          V_TMP_T_TAP := V_TAP(I);

          V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO ' ||
          				' SET TAP_SCRIPT_VALIDACION_JBPM='''||V_TMP_T_TAP(9)||''' '||
          				' ,TAP_SCRIPT_DECISION='''||V_TMP_T_TAP(10)||''' '||
          				' ,USUARIOMODIFICAR =''HREOS-763_REM_F2'', FECHAMODIFICAR = SYSDATE  '||
          				' WHERE TAP_CODIGO ='''||V_TMP_T_TAP(1)||''' ';
          DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO: '''||V_TMP_T_TAP(1)||''' de '''||V_TPO_XML||''''); 
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('ACTUALIZADO');
          
      END LOOP;
    
    
    -- Insertamos en la tabla tfi_tareas_form_items
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizacion TFI.......');
		FOR I IN V_TFI.FIRST .. V_TFI.LAST
	      LOOP
	      		 V_TMP_T_TFI := V_TFI(I);
	           V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '||
			            ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||''') '||
			            ' AND TFI_ORDEN = '''||V_TMP_T_TFI(2)||''' ';
			   EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	          
	          
	           IF V_NUM_TABLAS = 0 THEN
  
					DBMS_OUTPUT.PUT_LINE('[WARN] ' ||V_ESQUEMA|| '.TFI_TAREAS_FORM_ITEMS - NO EXISTE EL REGISTRO CON TAP_CODIGO =  '||V_TMP_T_TFI(1)||' Y CON TFI_ORDEN = '||V_TMP_T_TFI(2)||'.');
					DBMS_OUTPUT.PUT_LINE('[WARN] ' ||V_ESQUEMA|| '.TFI_TAREAS_FORM_ITEMS - LO INSERTAMOS.');
				
					V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL FROM DUAL';
	          		EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
					
				 	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS (' ||
          			  'TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) '||
          			  'VALUES ('||V_ENTIDAD_ID||', (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T010_AnalisisPeticionCargaList''),'||
          			  ''''||V_TMP_T_TFI(2)||''','''||V_TMP_T_TFI(3)||''','''||V_TMP_T_TFI(4)||''','''||V_TMP_T_TFI(5)||''', '''||V_TMP_T_TFI(6)||''', '''||V_TMP_T_TFI(7)||''', '||
          			  ''''||V_TMP_T_TFI(8)||''',1, ''HREOS-763_REM_F2'', SYSDATE, 0)';
		          
          			DBMS_OUTPUT.PUT_LINE('INSERTANDO: Campo '''||V_TMP_T_TFI(4)||''' de '''||V_TMP_T_TFI(1)||''''); 
			        DBMS_OUTPUT.PUT_LINE(V_MSQL);
			        EXECUTE IMMEDIATE V_MSQL;
			        DBMS_OUTPUT.PUT_LINE('INSERTADO');   
					
			  ELSE
					DBMS_OUTPUT.PUT_LINE('[WARN] ' ||V_ESQUEMA|| '.TFI_TAREAS_FORM_ITEMS - Actualizando tfi.');
				
				    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
				       SET TFI_TIPO='''||V_TMP_T_TFI(3)||''' 
							,TFI_NOMBRE='''||V_TMP_T_TFI(4)||''' 
							,TFI_LABEL='''||V_TMP_T_TFI(5)||''' 
							,TFI_ERROR_VALIDACION='''||V_TMP_T_TFI(6)||''' 
							,TFI_VALIDACION='''||V_TMP_T_TFI(7)||''' 
							,TFI_BUSINESS_OPERATION ='''||V_TMP_T_TFI(8)||'''    
							,USUARIOMODIFICAR =''HREOS-763_REM_F2'', FECHAMODIFICAR = SYSDATE  
				       WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||''') 
				         	AND TFI_ORDEN = '''||V_TMP_T_TFI(2)||'''
				       ';
				
					EXECUTE IMMEDIATE V_MSQL;
				
				
				COMMIT;
				DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADO CORRECTAMENTE ');
				
			  END IF;
	          
	      END LOOP;
	          
    
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