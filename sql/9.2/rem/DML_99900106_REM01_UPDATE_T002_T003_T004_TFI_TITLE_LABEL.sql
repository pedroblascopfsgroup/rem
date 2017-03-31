--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20170321
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1779
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el Titulos tarea AUTH BANKIA de T. OD, CEE, y ACT. TECNICA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versi&oacute;n inicial
--##########################################
--*/


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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_TABLA VARCHAR2(50):='TFI_TAREAS_FORM_ITEMS';

       
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    			-- TAP_CODIGO						TFI_NOMBRE			TFI_LABEL
	    T_TIPO_DATA('T002_AutorizacionBankia'		,'comboAmpliacion'	,'Autoriza ejecucioacute;n trabajo y ampliacioacute;n de presupuesto en su caso'),
		T_TIPO_DATA('T003_AutorizacionBankia'		,'comboAmpliacion'	,'Autoriza ejecucioacute;n trabajo y ampliacioacute;n de presupuesto en su caso'),
		T_TIPO_DATA('T004_AutorizacionBankia'		,'comboAmpliacion'	,'Autoriza ejecucioacute;n trabajo y ampliacioacute;n de presupuesto en su caso'),
		T_TIPO_DATA('T002_AutorizacionBankia'		,'titulo'			,'<p style="margin-bottom: 10px">Se ha solicitado la ejecuci&oacute;n de un trabajo que requiere de su autorizaci&oacute;n, bien por que se ha superado el presupuesto asignado al activo bien porque su coste es superior a las atribuciones del gestor de HRE.</p><p style="margin-bottom: 10px">Puede comprobar el coste del trabajo en su pestaña de gesti&oacute;n econ&oacute;mica.</p><p style="margin-bottom: 10px">Puede comprobar el saldo del activo en su pestaña de gesti&oacute;n, subpestaña de presupuesto asignado al activo.</p><p style="margin-bottom: 10px">Si tras verificar la informaci&oacute;n disponible opta por rechazar la petici&oacute;n, el tr&aacute;mite concluir&aacute.</p><p style="margin-bottom: 10px">En caso de que conceda la ampliaci&oacute;n de presupuesto, deber&aacute; anotar su importe en la presente tarea y el tr&aacute;mite continuar&aacute;, encarg&aacute;ndose la ejecuci&oacute;n al proveedor correspondiente, de la misma manera que si autoriza el trabajo en virtud de sus atribuciones.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>'),
		T_TIPO_DATA('T003_AutorizacionBankia'		,'titulo'			,'<p style="margin-bottom: 10px">Se ha solicitado la ejecuci&oacute;n de un trabajo que requiere de su autorizaci&oacute;n, bien por que se ha superado el presupuesto asignado al activo bien porque su coste es superior a las atribuciones del gestor de HRE.</p><p style="margin-bottom: 10px">Puede comprobar el coste del trabajo en su pestaña de gesti&oacute;n econ&oacute;mica.</p><p style="margin-bottom: 10px">Puede comprobar el saldo del activo en su pestaña de gesti&oacute;n, subpestaña de presupuesto asignado al activo.</p><p style="margin-bottom: 10px">Si tras verificar la informaci&oacute;n disponible opta por rechazar la petici&oacute;n, el tr&aacute;mite concluir&aacute.</p><p style="margin-bottom: 10px">En caso de que conceda la ampliaci&oacute;n de presupuesto, deber&aacute; anotar su importe en la presente tarea y el tr&aacute;mite continuar&aacute;, encarg&aacute;ndose la ejecuci&oacute;n al proveedor correspondiente, de la misma manera que si autoriza el trabajo en virtud de sus atribuciones.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>'),
		T_TIPO_DATA('T004_AutorizacionBankia'		,'titulo'			,'<p style="margin-bottom: 10px">Se ha solicitado la ejecuci&oacute;n de un trabajo que requiere de su autorizaci&oacute;n, bien por que se ha superado el presupuesto asignado al activo bien porque su coste es superior a las atribuciones del gestor de HRE.</p><p style="margin-bottom: 10px">Puede comprobar el coste del trabajo en su pestaña de gesti&oacute;n econ&oacute;mica.</p><p style="margin-bottom: 10px">Puede comprobar el saldo del activo en su pestaña de gesti&oacute;n, subpestaña de presupuesto asignado al activo.</p><p style="margin-bottom: 10px">Si tras verificar la informaci&oacute;n disponible opta por rechazar la petici&oacute;n, el tr&aacute;mite concluir&aacute.</p><p style="margin-bottom: 10px">En caso de que conceda la ampliaci&oacute;n de presupuesto, deber&aacute; anotar su importe en la presente tarea y el tr&aacute;mite continuar&aacute;, encarg&aacute;ndose la ejecuci&oacute;n al proveedor correspondiente, de la misma manera que si autoriza el trabajo en virtud de sus atribuciones.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

  
BEGIN	
	 
    -- LOOP para insertar los valores en ACT_EJE_EJERCICIO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INICIO]: UPDATE '||V_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
					AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ) ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' DE LA TAREA '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
       	  V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' 		'||
	                    ' SET TFI_LABEL = '''||TRIM(V_TMP_TIPO_DATA(3))||''' 	'|| 
	                    ' ,USUARIOMODIFICAR= ''HREOS-1779'', FECHAMODIFICAR=SYSDATE '|| 
						' WHERE TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(2))||'''  '|| 
						' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ) ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

       END IF;
       --Si no existe, no hacemos nada
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');

  
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuci&oacute;n:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
