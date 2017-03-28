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
	    T_TIPO_DATA('T002_AutorizacionBankia'		,'comboAmpliacion'	,'Autoriza ejecuci&oacute;n trabajo y ampliaci&oacute;n de presupuesto en su caso'),
		T_TIPO_DATA('T003_AutorizacionBankia'		,'comboAmpliacion'	,'Autoriza ejecuci&oacute;n trabajo y ampliaci&oacute;n de presupuesto en su caso'),
		T_TIPO_DATA('T004_AutorizacionBankia'		,'comboAmpliacion'	,'Autoriza ejecuci&oacute;n trabajo y ampliaci&oacute;n de presupuesto en su caso')
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
