--/*
--##########################################
--## AUTOR=ANAHECT DE VICENTE
--## FECHA_CREACION=20151102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en APR_AUX_MAPEO_DD_SAC los datos añadidos en T_ARRAY_DATA
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('CO00',		'NULL',		'03',		'02'),
		T_TIPO_DATA('CO01',		'13',		'03',		'02'),
		T_TIPO_DATA('CO02',		'14',		'03',		'02'),
		T_TIPO_DATA('CO03',		'15',		'03',		'02'),
		T_TIPO_DATA('ED00',		'NULL',		'05',		'05'),
		T_TIPO_DATA('ED01',		'23',		'06',		'01'),
		T_TIPO_DATA('ED02',		'22',		'05',		'02'),
		T_TIPO_DATA('ED03',		'NULL',		'04',		'03'),
		T_TIPO_DATA('ED04',		'19',		'05',		'02'),
		T_TIPO_DATA('ED05',		'NULL',		'03',		'04'),
		T_TIPO_DATA('ED06',		'20',		'05',		'02'),
		T_TIPO_DATA('ED07',		'21',		'05',		'02'),
		T_TIPO_DATA('IN00',		'NULL',		'04',		'03'),
		T_TIPO_DATA('IN01',		'18',		'04',		'03'),
		T_TIPO_DATA('IN02',		'17',		'04',		'03'),
		T_TIPO_DATA('IN03',		'18',		'04',		'03'),
		T_TIPO_DATA('IN04',		'18',		'04',		'03'),
		T_TIPO_DATA('OT00',		'NULL',		'07',		'05'),
		T_TIPO_DATA('OT01',		'19',		'05',		'02'),
		T_TIPO_DATA('OT02',		'24',		'07',		'02'),
		T_TIPO_DATA('OT03',		'25',		'07',		'02'),
		T_TIPO_DATA('OT04',		'16',		'03',		'02'),
		T_TIPO_DATA('OT05',		'26',		'07',		'05'),
		T_TIPO_DATA('SI',		'NULL',		'NULL',		'NULL'),
		T_TIPO_DATA('SU00',		'NULL',		'01',		'NULL'),
		T_TIPO_DATA('SU01',		'01',		'01',		'05'),
		T_TIPO_DATA('SU02',		'02',		'01',		'05'),
		T_TIPO_DATA('SU03',		'03',		'01',		'05'),
		T_TIPO_DATA('SU04',		'04',		'01',		'NULL'),
		T_TIPO_DATA('VI00',		'NULL',		'02',		'01'),
		T_TIPO_DATA('VI01',		'12',		'02',		'01'),
		T_TIPO_DATA('VI02',		'10',		'02',		'01'),
		T_TIPO_DATA('VI03',		'05',		'02',		'01'),
		T_TIPO_DATA('VI04',		'06',		'02',		'01'),
		T_TIPO_DATA('VI05',		'08',		'02',		'01'),
		T_TIPO_DATA('00',		'26',		'07',		'NULL')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en APR_AUX_MAPEO_DD_SAC -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN APR_AUX_MAPEO_DD_SAC] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
	    V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
	    --Comprobamos el dato a insertar
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.APR_AUX_MAPEO_DD_SAC WHERE DD_CODIGO_SUBTIPO_REC = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND DD_CODIGO_SUBTIPO_REM = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND DD_CODIGO_TIPO_REM = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND DD_CODIGO_TUD_REM = '''||TRIM(V_TMP_TIPO_DATA(4))||'''';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		--Si existe lo modificamos
		IF V_NUM_TABLAS > 0 THEN				
			DBMS_OUTPUT.PUT_LINE('[INFO]: EL REGISTRO YA EXISTE. NO SE HACE NADA.');
		  
		--Si no existe, lo insertamos   
		ELSE
       
	      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(3)) ||'''');     
	      V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_APR_AUX_MAPEO_DD_SAC.NEXTVAL FROM DUAL';
	      EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
	       V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.APR_AUX_MAPEO_DD_SAC (' ||
                      'DD_MSA_ID, DD_CODIGO_SUBTIPO_REC, DD_CODIGO_SUBTIPO_REM, DD_CODIGO_TIPO_REM, DD_CODIGO_TUD_REM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''' ,'''||V_TMP_TIPO_DATA(2)||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', '''||TRIM(V_TMP_TIPO_DATA(4))||''', 0, ''DML'',SYSDATE,0 FROM DUAL';
	      EXECUTE IMMEDIATE V_MSQL;
	      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
	      
		 END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO APR_AUX_MAPEO_DD_SAC ACTUALIZADO CORRECTAMENTE ');
   

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



   