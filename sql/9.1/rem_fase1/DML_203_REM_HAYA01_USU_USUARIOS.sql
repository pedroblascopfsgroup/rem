----/*
----##########################################
----## AUTOR=DANIEL GUTIERREZ
----## FECHA_CREACION=20160407
----## ARTEFACTO=online
----## VERSION_ARTEFACTO=9.1
----## INCIDENCIA_LINK=0
----## PRODUCTO=NO
----##
----## Finalidad: Script que añade en USU_USUARIOS los datos añadidos en T_ARRAY_DATA
----## INSTRUCCIONES:
----## VERSIONES:
----##        0.1 Versión inicial
----##########################################
----*/


--WHENEVER SQLERROR EXIT SQL.SQLCODE;
--SET SERVEROUTPUT ON; 
--SET DEFINE OFF;


--DECLARE
    --V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    --V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    --V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    --V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    --V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    --ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    --ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    --V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    --V_ENTIDAD_ID NUMBER(16);
    --V_ID NUMBER(16);

    
    --TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    --TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    --V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--T_TIPO_DATA('1','TINSA' ,'Pintor32', 'TINSA CERTIFY', 'pruebashrem@gmail.com', '1')
    --); 
    --V_TMP_TIPO_DATA T_TIPO_DATA;
    
--BEGIN	
	
	--DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	
	 
    ---- LOOP para insertar los valores en USU_USUARIOS -----------------------------------------------------------------
    --DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USU_USUARIOS] ');
    --FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      --LOOP
      
        --V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        ----Comprobamos el dato a insertar
        --V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        --EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        ----Si existe lo modificamos
        --IF V_NUM_TABLAS > 0 THEN				         
  			--DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USU_USUARIOS...no se modifica nada.');
  			
        --ELSE
       
          --DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');   
          --V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_USU_USUARIOS.NEXTVAL FROM DUAL';
          --EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          --V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.USU_USUARIOS (' ||
                      --'USU_ID, ENTIDAD_ID, USU_USERNAME, USU_PASSWORD, USU_NOMBRE, USU_MAIL, USU_GRUPO, USU_FECHA_VIGENCIA_PASS, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      --'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', '''||TRIM(V_TMP_TIPO_DATA(4))||''', '''||TRIM(V_TMP_TIPO_DATA(5))||''','''||TRIM(V_TMP_TIPO_DATA(6))||''',SYSDATE+730,''DML'',SYSDATE,0 FROM DUAL';
          --EXECUTE IMMEDIATE V_MSQL;
          --DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       --END IF;
      --END LOOP;
    --COMMIT;
    --DBMS_OUTPUT.PUT_LINE('[FIN]: USU_USUARIOS ACTUALIZADO CORRECTAMENTE ');
   

--EXCEPTION
     --WHEN OTHERS THEN
          --err_num := SQLCODE;
          --err_msg := SQLERRM;

          --DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          --DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          --DBMS_OUTPUT.put_line(err_msg);

          --ROLLBACK;
          --RAISE;          

--END;

--/

EXIT



   
