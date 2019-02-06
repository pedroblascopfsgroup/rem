--/*
--##########################################
--## AUTOR=Sonia Garcia
--## FECHA_CREACION=20190206
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v2.5.0-rem
--## INCIDENCIA_LINK=HREOS-5388
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el grupo de usuarios
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
  ENTIDAD NUMBER(1):= '1';
  V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-5388';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

--			    USER_NAME	  USU_GRUPO	
		
	 	T_TIPO_DATA( 'maretra01' , '1'),
		T_TIPO_DATA( 'qipert01', '1'),
		T_TIPO_DATA( 'grupobc01', '1'),
		T_TIPO_DATA( 'mediterraneo01', '1'),
		T_TIPO_DATA( 'gestinova01', '1'),
		T_TIPO_DATA( 'emais01' , '1'),
		T_TIPO_DATA( 'f&g01' ,'1'),
		T_TIPO_DATA( 'maretra02' , '1'),
		T_TIPO_DATA( 'qipert02', '1'),
		T_TIPO_DATA( 'grupobc02', '1'),
		T_TIPO_DATA( 'mediterraneo02', '1'),
		T_TIPO_DATA( 'gestinova02', '1'),
		T_TIPO_DATA( 'emais02' , '1'),
		T_TIPO_DATA( 'f&g02' ,'1'),
		T_TIPO_DATA( 'maretra03' , '1'),
		T_TIPO_DATA( 'qipert03', '1'),
		T_TIPO_DATA( 'grupobc03', '1'),
		T_TIPO_DATA( 'mediterraneo03', '1'),
		T_TIPO_DATA( 'gestinova03', '1'),
		T_TIPO_DATA( 'emais03' , '1'),
		T_TIPO_DATA( 'f&g03', '1'),
	 	T_TIPO_DATA( 'cenahi01' , '1'),
		T_TIPO_DATA( 'cenahi02', '1'),
		T_TIPO_DATA( 'cenahi03', '1'),
		T_TIPO_DATA( 'diagonal01', '1'),
		T_TIPO_DATA( 'diagonal02', '1'),
		T_TIPO_DATA( 'diagonal03' , '1'),
		T_TIPO_DATA( 'garsa01' ,'1'),
		T_TIPO_DATA( 'garsa02' , '1'),
		T_TIPO_DATA( 'garsa03', '1'),
		T_TIPO_DATA( 'gl01', '1'),
		T_TIPO_DATA( 'gl02', '1'),
		T_TIPO_DATA( 'gl03', '1'),
		T_TIPO_DATA( 'montalvo01' , '1'),
		T_TIPO_DATA( 'montalvo02' ,'1'),
		T_TIPO_DATA( 'montalvo03' , '1'),
		T_TIPO_DATA( 'ogf01', '1'),
		T_TIPO_DATA( 'ogf02', '1'),
		T_TIPO_DATA( 'ogf03', '1'),
		T_TIPO_DATA( 'pinos01', '1'),
		T_TIPO_DATA( 'pinos02' , '1'),
		T_TIPO_DATA( 'pinos03', '1'),
		T_TIPO_DATA( 'tecnotra01', '1'),
		T_TIPO_DATA( 'tecnotra02', '1'),
		T_TIPO_DATA( 'tecnotra03', '1'),
		T_TIPO_DATA( 'tinsacer01', '1'),
		T_TIPO_DATA( 'tinsacer02' , '1'),
		T_TIPO_DATA( 'tinsacer03', '1'),
		T_TIPO_DATA( 'uniges01', '1'),
		T_TIPO_DATA( 'uniges02' , '1'),
		T_TIPO_DATA( 'uniges03', '1')



  ); 
  V_TMP_TIPO_DATA T_TIPO_DATA;
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');


 
   -- LOOP para insertar los valores en USU_USUARIOS
   FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
     LOOP
    
       V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
       -------------------------------------------------
       --Comprobamos el dato a insertar en usu_usuario--
       -------------------------------------------------
       
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USU_USUARIOS DE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       
       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND USU_GRUPO = 0';
       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       
       --Si existe no se modifica
       IF V_NUM_TABLAS > 0 THEN				         
			
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USU_USUARIOS... se modifican sus campos');
		
		V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET USU_GRUPO = '''||TRIM(V_TMP_TIPO_DATA(2))||''', USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
					WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
		EXECUTE IMMEDIATE V_MSQL;	
       ELSE
     
        DBMS_OUTPUT.PUT_LINE('[INFO]: USUARIO '''||TRIM(V_TMP_TIPO_DATA(1))||''' NO EXISTE, O YA TIENE EL USU_GRUPO A '''||TRIM(V_TMP_TIPO_DATA(2))||'''');   
      
       END IF;
     
		
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
