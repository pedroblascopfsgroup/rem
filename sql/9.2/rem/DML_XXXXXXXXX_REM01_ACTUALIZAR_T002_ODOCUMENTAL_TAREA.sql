--/*
--##########################################
--## AUTOR=BRUNO ANGLÉS ROLBES
--## FECHA_CREACION=20170516
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2045
--## PRODUCTO=NO
--##
--## Finalidad: Realiza modificaciones del trámite de obtencion documental CEE, existiendo ya el trámite
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#REMMASTER#'; -- Configuracion Esquema Master
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
    
    
    /* (INSERT) TABLAS: TAP_TAREA_PROCEDIMIENTO & DD_PTP_PLAZOS_TAREAS_PLAZAS */
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
/*
        T_TAP('T002_AutorizacionBankia',
                'Autorización capa control Bankia',
                '811',
                '3',
                'GCCBANKIA',
                '3*24*60*60*1000L',
                'NULL',
                '',
                '',
                'valores[''''T002_AutorizacionBankia''''][''''comboAmpliacion''''] == DDSiNo.SI ? ''''OK'''' : ''''KO'''' '
            )
*/
    );
    V_TMP_T_TAP T_TAP;

    
    /* (INSERT) TABLA: TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    --		   TAP_CODIGO						     TFI_ORDEN	TFI_TIPO	     TFI_NOMBRE				TFI_LABEL																																																																																		TFI_ERROR_VALIDACION											TFI_VALIDACION									TFI_BUSINESS_OPERATION
    --    T_TFI('T002_AutorizacionBankia'            ,'0'        ,'label'    ,'titulo'               ,'<p style="margin-bottom: 10px">Para cumplimentar esta tarea debe anotar la fecha en que ha recibido la respuesta del propietario aceptando o rechazando una ampliación del presupuesto asociado al activo.</p><p style="margin-bottom: 10px">En el caso de que la ampliación del presupuesto sea rechazada por el propietario, el trámite concluirá ya que no podrá llevarse a cabo la actuación por falta de saldo.</p><p style="margin-bottom: 10px">En caso de que se conceda la ampliación de presupuesto solicitada, deberá anotar su importe. En este caso, la siguiente tarea será la de "fijación de plazo de ejecución".</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'                                                                                               ,''                                                             ,''                                             ,''                 ),
    --    T_TFI('T002_AutorizacionBankia'            ,'1'        ,'date'     ,'fecha'                ,'Fecha'                                                                                                                                                                                                                                                                                                        ,'Debe indicar la fecha de autorizaci&oacute;n'                 ,'false'                                        ,''                 ),
    --    T_TFI('T002_AutorizacionBankia'            ,'2'        ,'combo'    ,'comboAmpliacion'      ,'Ampliación del presupuesto'                                                                                                                                                                                                                                                                                   ,'Debe indicar si autoriza el incremento de presupuesto'        ,'false'                                        ,'DDSiNo'           ),
    --    T_TFI('T002_AutorizacionBankia'            ,'3'        ,'textinf'  ,'numIncremento'        ,'Importe del incremento'                                                                                                                                                                                                                                                                                       ,''                                                             ,''                                             ,''                 ),
    --    T_TFI('T002_AutorizacionBankia'            ,'4'        ,'textarea' ,'observaciones'        ,'Observaciones'                                                                                                                                                                                                                                                                                                ,''                                                             ,''                                             ,''                 )

		);
    V_TMP_T_TFI T_TFI;
    
    /* (UPDATE) TABLA TAP_TAREA_PROCEDIMIENTO */
    TYPE T_TAP_UPDATE IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TAP_UPDATE IS TABLE OF T_TAP_UPDATE;
    V_TAP_UPDATE T_ARRAY_TAP_UPDATE := T_ARRAY_TAP_UPDATE (
    --                  TAP_CODIGO                    TAP_CAMPO                          TAP_VALOR
    -- ANÁLISIS PETICIÓN
        T_TAP_UPDATE(' ''T002_AnalisisPeticion'' ',   'TAP_SCRIPT_DECISION',             'valores[''''T002_AnalisisPeticion''''][''''comboTramitar''''] == DDSiNo.NO ? ''''Fin'''' : valores[''''T002_AnalisisPeticion''''][''''comboGasto''''] == DDSiNo.NO ? ''''OKSinPago'''' : (checkBankia() ? (checkSuperaPresupuestoActivo() ? ''''OKConPagoYSinSaldoBankia'''' : (checkSuperaDelegacion() ? ''''OKConPagoYSinSaldoBankia'''' : ''''OKConPagoYSaldo'''')) : (valores[''''T002_AnalisisPeticion''''][''''comboGasto''''] == DDSiNo.SI ? (valores[''''T002_AnalisisPeticion''''][''''comboSaldo''''] == DDSiNo.SI ? ''''OKConPagoYSaldo'''' : ''''OKConPagoYSinSaldo'''') : ''''OKSinPago''''))'),
        T_TAP_UPDATE(' ''T002_AnalisisPeticion'' ',   'TAP_SCRIPT_VALIDACION_JBPM',      'valores[''''T002_AnalisisPeticion''''][''''comboTramitar''''] == DDSiNo.NO ? null : (checkHayPresupuestoEjercicioActual() ? (valores[''''T002_AnalisisPeticion''''][''''comboGasto''''] == DDSiNo.NO ? null : ( comprobarExisteTarifaSuperiorCeroTrabajo() ?  (comprobarExisteProveedorTrabajo() ? null : ''''Debe asignar al menos un proveedo al trabajo.'''') : ''''Debe asignar al menos una tarifa con importe mayor a 0 al trabajo.'''')) : ''''El activo debe tener asignado un presupuesto para el ejercicio actual, aunque sea con saldo cero'''')')
    );
    V_TMP_T_TAP_UPDATE T_TAP_UPDATE;
    
    /* (UPDATE) DD_PTP_PLAZOS_TAREAS_PLAZAS */
    TYPE T_PTP_UPDATE IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_PTP_UPDATE IS TABLE OF T_PTP_UPDATE;
    V_PTP_UPDATE T_ARRAY_PTP_UPDATE := T_ARRAY_PTP_UPDATE (
    --                  TAP_CODIGO                    PLAZO
    -- ANÁLISIS PETICIÓN
        T_PTP_UPDATE(' ''T002_AnalisisPeticion'' ',   '3*24*60*60*1000L')
    );
    V_TMP_T_PTP_UPDATE T_PTP_UPDATE;
    
    /* (UPDATE) TFI_TAREAS_FORM_ITEMS */
    TYPE T_TFI_UPDATE IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI_UPDATE IS TABLE OF T_TFI_UPDATE;
    V_TFI_UPDATE T_ARRAY_TFI_UPDATE := T_ARRAY_TFI_UPDATE (
    --                  TAP_CODIGO                    TFI_NOMBRE          TFI_CAMPO         TFI_VALOR
    -- ANÁLISIS PETICIÓN
       T_TFI_UPDATE(' ''T002_AnalisisPeticion'' ',    ' ''titulo'' ',     'TFI_LABEL',      '<p style="margin-bottom: 10px">Se ha formulado una petición para la obtención de un documento, por lo que en la presente tarea deberá aceptarla o rechazarla.</p><p>Si deniega la petición, deberá hacer constar el motivo y finalizará el trámite.</p><p>En el caso de que acepte la petición, deberá indicar si la gestión se va a encomendar a un proveedor o por el contrario va a ser realizada por un gestor interno. En este último caso la siguiente tarea será la de solicitud del documento por el gestor interno.</p><p>Si el trabajo se va a encargar a un proveedor, deberá seleccionarlo en la pestaña "gestión económica" del trabajo, verificando asimismo que la tarifa que resulte aplciable tiene un importe y que este es correcto.</p><p>En el caso de que haya saldo suficiente en el activo para tramitarse el trabajo, la siguiente tarea será la de "solicitud documento por proveedor", a quien se le lanzará directamente.</p><p>Por el contrario, en el caso de que no haya saldo suficiente asociado al activo, la siguiente tarea será la de "solicitud de disposición extraordinaria al propietario". En el caso de Bankia, esta tarea se lanzará al usuario de Capa de Control.</p><p>En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>')
    );
    V_TMP_T_TFI_UPDATE T_TFI_UPDATE;
    
    
 -- ## FIN DATOS DEL TRÁMITE
 -- ########################################################################################
    
    


BEGIN

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] Empezando a insertar datos del BPM '||V_TPO_XML||'.');
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_XML_JBPM = '''||V_TPO_XML||'''';
    EXECUTE IMMEDIATE V_SQL INTO table_count;
    
    IF table_count = 0 THEN
   		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.DD_TPO_TIPO_PROCEDIMIENTO... NO existe el BPM '||V_TPO_XML||'.');
        DBMS_OUTPUT.PUT_LINE('[INFO] NO SE REALIZAN MODIFICACIONES.');
	ELSE
    IF V_TAP.FIRST IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE('');
      DBMS_OUTPUT.PUT_LINE('**** INSERTS EN TAP_TAREA_PROCEDIMIENTO ****');
      -- Insertamos en la tabla tap_tarea_procedimiento y dd_ptp_plazos_tareas_plazas
  		FOR I IN V_TAP.FIRST .. V_TAP.LAST
          LOOP
              DBMS_OUTPUT.PUT_LINE('');
              V_TMP_T_TAP := V_TAP(I);
  
              V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TAP(1)||'''';
              --EXECUTE IMMEDIATE V_SQL INTO table_count;
  
              IF table_count > 0 THEN
                  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.TAP_TAREA_PROCEDIMIENTO... YA existe la tarea '||V_TMP_T_TAP(1)||'.');
                  DBMS_OUTPUT.PUT_LINE('[INFO] NO SE REALIZAN MODIFICACIONES.');
              ELSE
                  V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL FROM DUAL';
                  --EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
                  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO (' ||
                            'TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, TAP_DESCRIPCION, '||
                            'VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_FAP_ID, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID, DD_TGE_ID, DD_TPO_ID_BPM, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_VALIDACION_JBPM, TAP_SCRIPT_DECISION) '||
                            'VALUES ('||V_ENTIDAD_ID||',(SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||V_TPO_COD||'''),'||
                            ''''||V_TMP_T_TAP(1)||''', NULL, 0,'''||V_TMP_T_TAP(2)||''', 0, ''REM_F2'', SYSDATE, 0, NULL, 0, ''EXTTareaProcedimiento'', '||
                            ''''||V_TMP_T_TAP(4)||''', (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = '''||V_TMP_T_TAP(3)||'''),'||
                            '(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||V_TMP_T_TAP(5)||'''),'||V_TMP_T_TAP(7)||','''||V_TMP_T_TAP(8)||''','''||V_TMP_T_TAP(9)||''','''||V_TMP_T_TAP(10)||''')';
                  DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_T_TAP(1)||''' de '''||V_TPO_XML||''''); 
                  DBMS_OUTPUT.PUT_LINE(V_MSQL);
                  --EXECUTE IMMEDIATE V_MSQL;
                  DBMS_OUTPUT.PUT_LINE('INSERTADO');
                  
                  V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL FROM DUAL';
                  --EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
                  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS (' ||
                          'DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_PTP_ABSOLUTO) '||
                          'VALUES ('||V_ENTIDAD_ID||',(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TAP(1)||'''),'||
                          ''''||V_TMP_T_TAP(6)||''',0, ''REM_F2'', SYSDATE, 0, 0)';
                  DBMS_OUTPUT.PUT_LINE('INSERTANDO: Plazo de '''||V_TMP_T_TAP(1)||'''.'); 
                  DBMS_OUTPUT.PUT_LINE(V_MSQL);
                  --EXECUTE IMMEDIATE V_MSQL;
                  DBMS_OUTPUT.PUT_LINE('INSERTADO');
              END IF;	          
          END LOOP;	      
        END IF; -- Fin insert en TAP
       
        IF V_TFI.FIRST IS NOT NULL THEN
          DBMS_OUTPUT.PUT_LINE('');
          DBMS_OUTPUT.PUT_LINE('**** INSERTS EN TFI_TAREAS_FORM_ITEMS ****');
          -- Insertamos en la tabla tfi_tareas_form_items
          FOR I IN V_TFI.FIRST .. V_TFI.LAST
          LOOP
              DBMS_OUTPUT.PUT_LINE('');
              V_TMP_T_TFI := V_TFI(I);
  
              V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP INNER JOIN '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS TFI ON TAP.TAP_ID = TFI.TAP_ID WHERE TAP.TAP_CODIGO = '''||V_TMP_T_TFI(1)||''' AND TFI.TFI_NOMBRE = '''||V_TMP_T_TFI(4)||'''';
              --EXECUTE IMMEDIATE V_SQL INTO table_count;
  
              IF table_count > 0 THEN
                  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.TFI_TAREAS_FORM_ITEMS... YA existe el campo '||V_TMP_T_TFI(4)||'.');
                  DBMS_OUTPUT.PUT_LINE('[INFO] NO SE REALIZAN MODIFICACIONES.');
              ELSE
                  V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL FROM DUAL';
                  --EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
                  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS (' ||
                          'TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) '||
                          'VALUES ('||V_ENTIDAD_ID||', (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||'''),'||
                          ''''||V_TMP_T_TFI(2)||''','''||V_TMP_T_TFI(3)||''','''||V_TMP_T_TFI(4)||''','''||V_TMP_T_TFI(5)||''', '''||V_TMP_T_TFI(6)||''', '''||V_TMP_T_TFI(7)||''', '||
                          ''''||V_TMP_T_TFI(8)||''',1, ''REM_F2'', SYSDATE, 0)';
                  DBMS_OUTPUT.PUT_LINE('INSERTANDO: Campo '''||V_TMP_T_TFI(4)||''' de '''||V_TMP_T_TFI(1)||''''); 
                  DBMS_OUTPUT.PUT_LINE(V_MSQL);
                  --EXECUTE IMMEDIATE V_MSQL;
                  DBMS_OUTPUT.PUT_LINE('INSERTADO');
              END IF;
          END LOOP;
        END IF; -- Fin insert en TFI
        
        -- Updates en TAP
        IF V_TAP_UPDATE.FIRST IS NOT NULL THEN
          DBMS_OUTPUT.PUT_LINE('');
          DBMS_OUTPUT.PUT_LINE('**** UPDATES EN TAP_TAREA_PROCEDIMIENTO ****');
          FOR I IN V_TAP_UPDATE.FIRST .. V_TAP_UPDATE.LAST
          LOOP
              DBMS_OUTPUT.PUT_LINE('');
              V_TMP_T_TAP_UPDATE := V_TAP_UPDATE(I);
              V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
                 SET '||V_TMP_T_TAP_UPDATE(2)||' = '''||V_TMP_T_TAP_UPDATE(3)||''' 
                 WHERE TAP_CODIGO = '||V_TMP_T_TAP_UPDATE(1)||'';
              DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO: Campo '''||V_TMP_T_TAP_UPDATE(2)||''' de '''||V_TMP_T_TAP_UPDATE(1)||'''');
              DBMS_OUTPUT.PUT_LINE(V_MSQL);
              EXECUTE IMMEDIATE V_MSQL;
              DBMS_OUTPUT.PUT_LINE('ACTUALIZADO');
          END LOOP;
        END IF; -- Fin updates en TAP
        
        -- Updates en DD_PTP
        IF V_PTP_UPDATE.FIRST IS NOT NULL THEN
          DBMS_OUTPUT.PUT_LINE('');
          DBMS_OUTPUT.PUT_LINE('**** UPDATES EN DD_PTP_PLAZOS_TAREAS_PLAZAS ****');
          FOR I IN V_PTP_UPDATE.FIRST .. V_PTP_UPDATE.LAST
          LOOP
              DBMS_OUTPUT.PUT_LINE('');
              V_TMP_T_PTP_UPDATE := V_PTP_UPDATE(I);
              V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS
                 SET DD_PTP_PLAZO_SCRIPT = '''||V_TMP_T_PTP_UPDATE(2)||''' 
                 WHERE TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '||V_TMP_T_PTP_UPDATE(1)||')';
              DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO: Campo DD_PTP_PLAZO_SCRIPT PARA '''||V_TMP_T_PTP_UPDATE(1)||'''');
              DBMS_OUTPUT.PUT_LINE(V_MSQL);
              EXECUTE IMMEDIATE V_MSQL;
              DBMS_OUTPUT.PUT_LINE('ACTUALIZADO');
          END LOOP;
        END IF; -- Fin updates en DD_PTP
        
         -- Updates en TFI
        IF V_TFI_UPDATE.FIRST IS NOT NULL THEN
          DBMS_OUTPUT.PUT_LINE('');
          DBMS_OUTPUT.PUT_LINE('**** UPDATES TFI_TAREAS_FORM_ITEMS ****');
          FOR I IN V_TFI_UPDATE.FIRST .. V_TFI_UPDATE.LAST
          LOOP
              DBMS_OUTPUT.PUT_LINE('');
              V_TMP_T_TFI_UPDATE := V_TFI_UPDATE(I);
              V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
                 SET '||V_TMP_T_TFI_UPDATE(3)||' = '''||V_TMP_T_TFI_UPDATE(4)||''' 
                 WHERE TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '||V_TMP_T_TFI_UPDATE(1)||') '||
                  'AND TFI_NOMBRE ='||V_TMP_T_TFI_UPDATE(2);
              DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO: Campo '||V_TMP_T_TFI_UPDATE(3)||' PARA '''||V_TMP_T_TFI_UPDATE(1)||'''');
              DBMS_OUTPUT.PUT_LINE(V_MSQL);
              EXECUTE IMMEDIATE V_MSQL;
              DBMS_OUTPUT.PUT_LINE('ACTUALIZADO');
          END LOOP;
        END IF; -- Fin updates en DD_TFI
              
        DBMS_OUTPUT.PUT_LINE('[FIN] Ha terminado la insercción deL BPM: '||V_TPO_XML||'.');
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