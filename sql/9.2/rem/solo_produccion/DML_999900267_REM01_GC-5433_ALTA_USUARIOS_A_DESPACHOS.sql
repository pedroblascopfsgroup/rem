--/*
--/*
--###########################################
--## AUTOR=Jessica Sampere
--## FECHA_CREACION=20180320
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.12
--## INCIDENCIA_LINK=GC-5373
--## PRODUCTO=NO
--## 
--## Finalidad: Creacion de Usuarios REM
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
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		--	  USER_NAME	   	NOMBRE_USU		APELL1			APELL2			EMAIL      			PASS		PEF_COD		USU GRUPO	DESPACHO_EXTERNO	
T_TIPO_DATA( '07488153C' ,'Pilar' ,'Lopez'  ,'Acedo'  ,'pilar@rojomata.com'  , ''  ,'HAYAPROV'  ,''  ,'REMPROV'),
T_TIPO_DATA( 'pcalonge' ,'Pedro ' ,'Calonge '  ,'Martin'  ,'pcalonge@haya.es'  , ''  ,'HAYACONSU'  ,''  ,'REMCERT'),
T_TIPO_DATA( 'gmurcia' ,'Guillermo' ,'Murcia'  ,'Verdu'  ,'gmurcia@externos.haya.es'  , ''  ,'HAYAGESACT'  ,' '  ,'REMACT'),
T_TIPO_DATA( 'asorianol' ,'Ana' ,'Soriano'  ,'Lorente'  ,'asorianol@externos.haya.es'  , ''  ,'HAYAGESTPUBL'  ,'usugrupub'  ,'REMGPUBL'),
T_TIPO_DATA( 'ecasis' ,'Eva María' ,'Casis'  ,'García'  ,'ecasis@haya.es'  , ''  ,'HAYAGESTPUBL'  ,'usugrupub'  ,'REMGPUBL'),
T_TIPO_DATA( '50321160N' ,'FATIMA ' ,'VILLADONIGA '  ,'DIEZ'  ,'FVILLADONIGA@aciertaasistencia.es'  , ''  ,'HAYAPROV'  ,' '  ,'REMPROV'),
T_TIPO_DATA( 'lsoriano' ,'Lucia ' ,'Soriano '  ,'Heras'  ,'lsoriano@haya.es'  , ''  ,'HAYASUPFORM'  ,''  ,'REMSUPFORM'),
T_TIPO_DATA( '50608259W' ,'LAURA ' ,'HIDALGO '  ,'JIMÉNEZ'  ,'LHIDALGO@ALMARCONSULTING.COM'  , ''  ,'HAYAPROV'  ,''  ,'REMPROV'),
T_TIPO_DATA( '15433595C' ,'ALMUDENA ' ,'ROMERO '  ,'LOBATO'  ,'AROMERO@ALMARCONSULTING.COM'  , ''  ,'HAYAPROV'  ,''  ,'REMPROV'),
T_TIPO_DATA( 'arueda' ,'Andres ' ,'Rueda '  ,'de la Puerta '  ,'arueda@haya.es'  , ''  ,'HAYAGESACT'  ,''  ,'REMACT'),
T_TIPO_DATA( 'ctorres' ,'Carlos ' ,'Torres '  ,'Perez'  ,'ctorres@externos.haya.es'  , ''  ,'HAYASADM'  ,''  ,'HAYASADM'),
T_TIPO_DATA( 'sortiz' ,'Susana ' ,'Ortiz '  ,'Martinez'  ,'sortiz@externos.haya.es'  , ''  ,'HAYASADM'  ,''  ,'HAYASADM'),
T_TIPO_DATA( 'esantorcuato' ,'Estefania ' ,'Santorcuato '  ,'Rocafull'  ,'esantorcuato@externos.haya.es'  , ''  ,'HAYASADM'  ,''  ,'HAYASADM'),
T_TIPO_DATA( 'esantorcuato' ,'Estefania ' ,'Santorcuato '  ,'Rocafull'  ,'esantorcuato@externos.haya.es'  , ''  ,'HAYAGESTADM'  ,'usugruadm'  ,'REMGIAADMT'),
T_TIPO_DATA( 'etorres' ,'Estela ' ,'Torres '  ,'Martinez'  ,'etorres@externos.haya.es'  , ''  ,'HAYASADM'  ,''  ,'HAYASADM'),
T_TIPO_DATA( 'etorres' ,'Estela ' ,'Torres '  ,'Martinez'  ,'etorres@externos.haya.es'  , ''  ,'HAYAGESTADM'  ,'usugruadm'  ,'REMGIAADMT'),
T_TIPO_DATA( 'mblat' ,'Maria Cruz ' ,'Blat '  ,'Romero'  ,'mblat@externos.haya.es'  , ''  ,'HAYASADM'  ,''  ,'HAYASADM'),
T_TIPO_DATA( 'mblat' ,'Maria Cruz ' ,'Blat '  ,'Romero'  ,'mblat@externos.haya.es'  , ''  ,'HAYAGESACT'  ,' '  ,'REMACT'),
T_TIPO_DATA( 'vcastillo' ,'Vanesa ' ,'Castillo '  ,'Tortajada'  ,'vcastillo@externos.haya.es'  , ''  ,'HAYASADM'  ,''  ,'HAYASADM'),
T_TIPO_DATA( 'vcastillo' ,'Vanesa ' ,'Castillo '  ,'Tortajada'  ,'vcastillo@externos.haya.es'  , ''  ,'HAYAGESACT'  ,''  ,'REMACT'),
T_TIPO_DATA( '02670559Y' ,'Luz del Carmen' ,'Jiménez'  ,'Bido'  ,'ljimenez@apreblanc.com'  , ''  ,'HAYAPROV'  ,''  ,'REMPROV'),
T_TIPO_DATA( '50331119N' ,'Alberto' ,'Sanz'  ,'Gómez'  ,'asanz@apreblanc.com   '  , ''  ,'HAYAPROV'  ,''  ,'REMPROV'),
T_TIPO_DATA( '47411520X' ,'Noelia' ,'Hurtado'  ,'Aparicio'  ,'nhurtado@apreblanc.com   '  , ''  ,'HAYAPROV'  ,''  ,'REMPROV')
  ); 
  V_TMP_TIPO_DATA T_TIPO_DATA;
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');


 
   -- LOOP para insertar los valores en USU_USUARIOS, ZON_PEF_USU Y USD_USUARIOS_DESPACHOS -----------------------------------------------------------------
   FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
     LOOP
    
       V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
	   ------------------------------------------------------------
       --Comprobamos el dato a insertar en usd_usuarios_despachos--
       ------------------------------------------------------------
       IF V_TMP_TIPO_DATA(9) IS NULL THEN
       		DBMS_OUTPUT.PUT_LINE('[INFO]: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' NO INSERTA EN USUARIOS_DESPACHOS');
       ELSE
       
	       --DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USD_USUARIOS_DESPACHOS ');
	       
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS 
				WHERE DES_ID = 
					(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO 
					WHERE DES_DESPACHO = '''||TRIM(V_TMP_TIPO_DATA(9))||''') 
					AND USU_ID = 
						(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS 
						WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||''')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
				
			-- Si existe no se modifica
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos de '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' en la tabla '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS...no se modifica nada.');
				
			ELSE
			
			--DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN USD_USUARIOS_DESPACHOS');
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS' ||
						' (USD_ID, DES_ID, USU_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR, BORRADO)' || 
						' SELECT '||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL,' ||
						' (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = '''||TRIM(V_TMP_TIPO_DATA(9))||'''),' ||							
						' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''),' ||
						' 1,1,''CARGA_USUARIOS'',SYSDATE,0 FROM DUAL';
			  	
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[OK]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' INSERTADO CORRECTAMENTE EN USD_USUARIOS_DESPACHOS');
				
			END IF;	
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
