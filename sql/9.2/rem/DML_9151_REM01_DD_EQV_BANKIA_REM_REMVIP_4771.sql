--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190710
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4771
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica en DD_EQV_BANKIA_REM los datos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
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
	
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	T_TIPO_DATA('DD_SCR_CODIGO', '316', 'TDA 27, FONDO DE TITULIZACION DE ACTIVOS' , 'TDA 27, FONDO DE TITULIZACION DE ACTIVOS' , 'DD_SCR_SUBCARTERA', '09', 'TITULIZADAS', 'TITULIZADAS')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_EQV_BANKIA_REM -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_EQV_BANKIA_REM ] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EQV_BANKIA_REM  WHERE DD_NOMBRE_BANKIA = '''||TRIM(V_TMP_TIPO_DATA(1))||'''' || 
		                 'AND DD_CODIGO_BANKIA = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_EQV_BANKIA_REM  '||
                    'SET DD_CODIGO_REM            = '''||TRIM(V_TMP_TIPO_DATA(6))||''''|| 
		      ', DD_DESCRIPCION_REM       = '''||TRIM(V_TMP_TIPO_DATA(7))||''''||
		      ', DD_DESCRIPCION_LARGA_REM = '''||TRIM(V_TMP_TIPO_DATA(8))||''''||
		      ', USUARIOMODIFICAR         = ''REMVIP-4771'' , FECHAMODIFICAR = SYSDATE '||
		   'WHERE DD_NOMBRE_BANKIA = '''||TRIM(V_TMP_TIPO_DATA(1))||'''' || 
		     'AND DD_CODIGO_BANKIA = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
	
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_EQV_BANKIA_REM (' ||
		      'DD_NOMBRE_BANKIA, DD_CODIGO_BANKIA, DD_DESCRIPCION_BANKIA, DD_DESCRIPCION_LARGA_BANKIA, DD_NOMBRE_REM, DD_CODIGO_REM, DD_DESCRIPCION_REM, DD_DESCRIPCION_LARGA_REM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '''||TRIM(V_TMP_TIPO_DATA(1))||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', '''||TRIM(V_TMP_TIPO_DATA(4))||''','''||TRIM(V_TMP_TIPO_DATA(5))||''','''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''','''||TRIM(V_TMP_TIPO_DATA(8))||''', 0, ''REMVIP-4771'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_EQV_BANKIA_REM ACTUALIZADO CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT



   
