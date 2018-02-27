--/*
--###########################################
--## AUTOR=Jessica Sampere
--## FECHA_CREACION=20180214
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.12
--## INCIDENCIA_LINK=REMNIVUNO-230
--## PRODUCTO=NO
--## 
--## Finalidad: Cambio contraseñas y correos usuarios REM
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  V_ID NUMBER(16);

  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		--	  USER_NAME	   	NOMBRE_USU		APELL1			APELL2			EMAIL      			PASS		PEF_COD		USU GRUPO	DESPACHO_EXTERNO	
	T_TIPO_DATA( 'jnombela', 'DBDJTMSCPU', 'jnombela@haya.es'),
	T_TIPO_DATA( 'mgonzalezm', 'RGECNXYLVR', 'mgonzalezm@haya.es'),
	T_TIPO_DATA( 'agonzalezc', 'SYMWSARJKV', 'agonzalezc@haya.es'),
	T_TIPO_DATA( 'desteban', 'PPSENUKFDT', 'desteban@haya.es'),
	T_TIPO_DATA( 'jcrespillo', 'MMNCOMCAXB', 'jcrespillo@haya.es')

  ); 
  V_TMP_TIPO_DATA T_TIPO_DATA;
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');


 
   -- LOOP para insertar los valores en USU_USUARIOS, ZON_PEF_USU Y USD_USUARIOS_DESPACHOS -----------------------------------------------------------------
   FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
     LOOP
    
       V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
       -------------------------------------------------
       --Comprobamos el dato a insertar en usu_usuario--
       -------------------------------------------------
       
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USU_USUARIOS DE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       
       V_SQL := 'SELECT distinct(USU_ID) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
       EXECUTE IMMEDIATE V_SQL INTO V_ID;
       DBMS_OUTPUT.PUT_LINE('[INFO]: USUARIO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ID  '''|| V_ID ||''' ');

        
		V_MSQL := 'update '|| V_ESQUEMA_M ||'.USU_USUARIOS SET
				USU_PASSWORD = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
				USU_MAIL = '''||TRIM(V_TMP_TIPO_DATA(3))||'''
				WHERE USU_ID = '||V_ID||' ';
          EXECUTE IMMEDIATE V_MSQL;
        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' INSERTADO CORRECTAMENTE EN USU_USUARIOS');
      
		
    END LOOP;
    
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO ACTUALIZADO CORRECTAMENTE ');
 

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