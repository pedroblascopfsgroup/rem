--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20161005
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-906
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
    V_TPO_COD VARCHAR2(20 CHAR):= 			'T001';
    
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

	T_TAP('T001_DesignarMediador',
            'Designación de mediador',
            '811',
            '3',
            'GCOM',
            '3*24*60*60*1000L',
            'NULL',
            '',
            'comprobarObligatoriosDesignarMediador()',
            ''
       	)
	);
    V_TMP_T_TAP T_TAP;   
    
    
     /* TABLA: TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    --		   TAP_CODIGO							TFI_ORDEN		TFI_TIPO		TFI_NOMBRE				TFI_LABEL																																																																																		TFI_ERROR_VALIDACION											TFI_VALIDACION									TFI_BUSINESS_OPERATION
    	T_TFI('T001_DesignarMediador'				,'0'			,'tfi_label'    ,'titulo'				,'<p style="margin-bottom: 10px">Para dar completada esta tarea, el activo debe tener asignado un mediador, anotando a continuación en la presente pantalla la fecha de asignación.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'																																																																			,''																,''												,''					),
    	T_TFI('T001_DesignarMediador'				,'1'			,'date'			,'fechaAsignacion'		,'Fecha asignaci&oacute;n'																																																																						  								,'Debe indicar fecha de asignaci&oacute;n'						,'false'                                 		,''					),
    	T_TFI('T001_DesignarMediador'				,'2'			,'textarea'	    ,'observaciones'		,'Observaciones'																																																																																,''																,''												,''					),
    	T_TFI('T001_DesignarMediador'				,'3'			,'elcactivo'    ,'PUBLICACION'			,'ACTIVO > Informe comercial'																																																																													,''																,''												,''					)
    	);
    V_TMP_T_TFI T_TFI;
    
    
    /* ################################################################################
     ## MODIFICACIONES: Se cambia el trámite de admisión
     ## Actualizamos TAP_TAREA: T001_CheckingInformacion, se le inserta una decisión
     ## Insertamos nueva tarea 'Designar mediador'
     ## Insertamos campos TFI de la nueva tarea ó
     ## Actualizamos TFI segun codigo y orden, si no existe -> se crea
     ##
     */  
BEGIN    
	
	--Actualizamos la tarea anterior (T001_CheckingInformacion), para validar una decisión
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET' ||
			  ' TAP_SCRIPT_DECISION = ''comprobarActivoComercializable() ? ''''Comercializable'''' : ''''NoComercializable'''''' '||
			  ' ,USUARIOMODIFICAR =''HREOS-906_REM_F2'', FECHAMODIFICAR = SYSDATE  '||
			  ' WHERE TAP_CODIGO = ''T001_CheckingInformacion'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

	FOR I IN V_TAP.FIRST .. V_TAP.LAST
      LOOP
        V_TMP_T_TAP := V_TAP(I);
          
        -- Insertamos en la tabla tap_tarea_procedimiento y dd_ptp_plazos_tareas_plazas LA NUEVA TAREA
	    DBMS_OUTPUT.PUT_LINE('[INICIO] Empezando a insertar datos del BPM');
	    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TAP(1)||'''';
	    EXECUTE IMMEDIATE V_SQL INTO table_count;
          
		IF table_count = 1 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.TAP_TAREA_PROCEDIMIENTO... Ya existe la tarea '||V_TMP_T_TAP(1)||'.');
		ELSE
		   
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO (' ||
                      'TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, TAP_DESCRIPCION, '||
                      'VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_FAP_ID, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID, DD_TGE_ID, DD_TPO_ID_BPM, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_VALIDACION_JBPM, TAP_SCRIPT_DECISION) '||
                      'VALUES ('||V_ENTIDAD_ID||',(SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||V_TPO_COD||'''),'||
                      ''''||V_TMP_T_TAP(1)||''', NULL, 0,'''||V_TMP_T_TAP(2)||''', 0, ''HREOS-906_REM_F2'', SYSDATE, 0, NULL, 0, ''EXTTareaProcedimiento'', '||
                      ''''||V_TMP_T_TAP(4)||''', (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = '''||V_TMP_T_TAP(3)||'''),'||
                      '(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||V_TMP_T_TAP(5)||'''),'||V_TMP_T_TAP(7)||','''||V_TMP_T_TAP(8)||''','''||V_TMP_T_TAP(9)||''','''||V_TMP_T_TAP(10)||''')';
          DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_T_TAP(1)||''' '); 
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('INSERTADO');
          
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS (' ||
          				'DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_PTP_ABSOLUTO) '||
          				'VALUES ('||V_ENTIDAD_ID||',(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TAP(1)||'''),'||
          				''''||V_TMP_T_TAP(6)||''',0, ''HREOS-906_REM_F2'', SYSDATE, 0, 0)';
          DBMS_OUTPUT.PUT_LINE('INSERTANDO: Plazo de '''||V_TMP_T_TAP(1)||'''.'); 
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('INSERTADO');
          
		END IF;
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
          			  'VALUES ('||V_ENTIDAD_ID||', (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T001_DesignarMediador''),'||
          			  ''''||V_TMP_T_TFI(2)||''','''||V_TMP_T_TFI(3)||''','''||V_TMP_T_TFI(4)||''','''||V_TMP_T_TFI(5)||''', '''||V_TMP_T_TFI(6)||''', '''||V_TMP_T_TFI(7)||''', '||
          			  ''''||V_TMP_T_TFI(8)||''',1, ''HREOS-906_REM_F2'', SYSDATE, 0)';
		          
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
							,USUARIOMODIFICAR =''HREOS-906_REM_F2'', FECHAMODIFICAR = SYSDATE  
				       WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||''') 
				         	AND TFI_ORDEN = '''||V_TMP_T_TFI(2)||'''
				       ';
				
					EXECUTE IMMEDIATE V_MSQL;
				
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