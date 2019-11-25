--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20191120
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5757
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
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar el id del registro
	V_USUARIO_CREAR VARCHAR2(20 CHAR) := 'REMVIP-5757'; -- Vble. auxiliar para almacenar el usuario crear
    V_USUARIO_MODIFICAR VARCHAR2(20 CHAR) := 'REMVIP-5757'; -- Vble. auxiliar para almacenar el usuario modificar	
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
	
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		  --T_TIPO_DATA('DD_CODIGO_SUBTIPO_REC','DD_CODIGO_TIPO_REM','DD_CODIGO_SUBTIPO_REM')
		  T_TIPO_DATA('0924','01','27'),
          T_TIPO_DATA('0929','03','28'),
          T_TIPO_DATA('0930','03','29'),
          T_TIPO_DATA('0932','08','30'),
          T_TIPO_DATA('0933','08','31'),
          T_TIPO_DATA('0934','08','32'),
          T_TIPO_DATA('0935','09','33'),
          T_TIPO_DATA('0936','08','34'),
          T_TIPO_DATA('0937','07','35'),
          T_TIPO_DATA('0941','07','36'),
          T_TIPO_DATA('0943','08','37')
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
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.APR_AUX_MAPEO_DD_SAC WHERE DD_CODIGO_SUBTIPO_REC = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND DD_CODIGO_SUBTIPO_REM = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND DD_CODIGO_TIPO_REM = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		--Si existe lo modificamos
		IF V_NUM_TABLAS > 0 THEN				
			DBMS_OUTPUT.PUT_LINE('[INFO]: EL REGISTRO YA EXISTE. NO SE HACE NADA.');
		  
		--Si no existe, lo insertamos   
		ELSE
       
	      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(3)) ||'''');     
	      V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_APR_AUX_MAPEO_DD_SAC.NEXTVAL FROM DUAL';
	      EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
	      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.APR_AUX_MAPEO_DD_SAC (
			   			DD_MSA_ID, 
						DD_CODIGO_SUBTIPO_REC, 
						DD_CODIGO_SUBTIPO_REM, 
						DD_CODIGO_TIPO_REM, 
						VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					   SELECT '|| V_ID ||',
					   '''||V_TMP_TIPO_DATA(1)||''' ,
					   '''||V_TMP_TIPO_DATA(3)||''' ,
					   '''||TRIM(V_TMP_TIPO_DATA(2))||''' ,					   
					   0,'''|| V_USUARIO_CREAR ||''',SYSDATE,0 FROM DUAL';
	      EXECUTE IMMEDIATE V_MSQL;
	      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
	      
		 END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO APR_AUX_MAPEO_DD_SAC ACTUALIZADO CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT



   