--/*
--###########################################
--## AUTOR=Dean Ibañez
--## FECHA_CREACION=20171222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=GC-4615
--## PRODUCTO=NO
--## 
--## Finalidad:
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
		T_TIPO_DATA( 'csanchezd' ,'Carmen ' ,'Sanchez '  ,'Duran'  ,'csanchezd@externos.haya.es'  , 'QWSCPRDQYS'  ,'HAYAGESTADM'  ,'usugruadm'  ,'REMADM'),
		T_TIPO_DATA( '09422052X' ,'Alejandra' ,'Cobo'  ,'Fueyo '  ,'alejandracobo@asigno.es'  , 'CGSOHLYATY'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '52613878K' ,'Amparo' ,'Pelaez'  ,'Perez '  ,'amparopelaez@asigno.es'  , 'XJWHBYHRDJ'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '71636817M' ,'Ana Belen' ,'Garcia'  ,'Alonso '  ,'anabelengarcia@asigno.es'  , 'LQAAVGFJKT'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '44718004R' ,'Ana' ,'Delgado'  ,'Gonzalez '  ,'anadelgado@lener.es'  , 'SRJUTCTCNN'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '7694037F' ,'Ana' ,'Garcia'  ,'Blanco '  ,'anagblanco@asigno.es'  , 'JXJSKFSTCI'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '39452196C' ,'Antia' ,'Gonzalez'  ,'Fernandez '  ,'antiagonzalez@asigno.es'  , 'MVSRNROLUE'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '43782920M' ,'Beatriz' ,'Hernandez'  ,'Valiente '  ,'beatrizhernandez@asigno.es'  , 'VPVDBWOXEF'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '71662924F' ,'Carlos' ,'Gonzalez'  ,'Barquin '  ,'carlosgonzalez@asigno.es'  , 'TPKMBVRCSB'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '09405641K' ,'Carmen Maria' ,'Sierra'  ,'Sanchez '  ,'carmensierra@asigno.es'  , 'ERJBGHKOWK'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '11443554L' ,'Carmen' ,'Vilar'  ,'Menendez '  ,'carmenvilar@asigno.es'  , 'IXLKKZWUAX'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '71165857Q' ,'Cesar' ,'Llorente'  ,'Beade '  ,'cesarllorente@lener.es'  , 'HXKCOAKBWW'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '77806960F' ,'David' ,'Rubio'  ,'Risquet '  ,'davidrubio@lener.es'  , 'TQLLDYGNQA'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '71664559D' ,'Emma' ,'Alvarez'  ,'Suarez '  ,'emmaalvarez@asigno.es'  , 'NZBPZLVRPF'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '12392304L' ,'Eva' ,'Alcalde'  ,'Ruiz '  ,'evaalcalde@asigno.es'  , 'XZQHQZQAUY'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '04191646B' ,'Gema' ,'Moreno'  ,'Ropero '  ,'gemamoreno@asigno.es'  , 'HMIMBDZSPT'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '10905685M' ,'Gemma Cristina' ,'Rodriguez'  ,'Barril '  ,'gemarodriguez@asigno.es'  , 'GSIPTUUHLM'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '71657479J' ,'Irene' ,'Arce'  ,'Rubio '  ,'irenearce@asigno.es'  , 'YUCEWAOHYB'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '71767993N' ,'Jair' ,'Gonzalez'  ,'Fernandez '  ,'jairgonzalez@asigno.es'  , 'WUGHUDTXXR'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '32889264T' ,'Jenifer' ,'Losada'  ,'Carrio '  ,'jeniferlosada@asigno.es'  , 'GOUCHUPKOL'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '07082048F' ,'Jorge' ,'Gay'  ,'Carpizo '  ,'jorgegay@asigno.es'  , 'RDHZWHRPVA'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '30672897M' ,'Juan Ignacio' ,'Echarren'  ,'Chasco '  ,'juanignacioecharren@lener.es'  , 'OXLEIXZAME'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '71662385C' ,'Katia' ,'Alonso'  ,'Carral '  ,'katiaalonso@asigno.es'  , 'EHTEMPRCRY'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '09009254Q' ,'Laura' ,'Roldan'  ,'Viñas '  ,'lauraroldan@asigno.es'  , 'CBLARSUIWZ'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '09405477H' ,'Lucia' ,'Perez'  ,'Granda '  ,'luciaperez@asigno.es'  , 'TSQXUVZONJ'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '53516828Z' ,'Mar' ,'Armada'  ,'Lopez '  ,'mararmada@asigno.es'  , 'KZDGTQUKNW'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '52619172W' ,'Maria del Val' ,'Carrero'  ,'Alvarez '  ,'valcarrero@asigno.es'  , 'JBYUVBWFTZ'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '71885921L' ,'Maria Henar' ,'Diaz'  ,'Cañibano '  ,'henardiaz@asigno.es'  , 'GZMJEGAZLM'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '76942225A' ,'Maria Teresa' ,'Gonzalez'  ,'Menendez '  ,'teresagonzalez@asigno.es'  , 'GXOWPFOTOV'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '53558001V' ,'Marta Elena' ,'Murias'  ,'Lopez '  ,'martamurias@asigno.es'  , 'RCQOWVFADS'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '51429450R' ,'Marta' ,'Lorente'  ,'Lara '  ,'martalorente@lener.es'  , 'TZLHGNTJZO'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '09408576N' ,'Natalia' ,'Navajas'  ,'Rebollar '  ,'natalianavajas@asigno.es'  , 'AROJZSBPJR'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '10901173R' ,'Patricia' ,'Margaride'  ,'Rodriguez '  ,'patriciamargaride@asigno.es'  , 'NGZZWSSMWP'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '71772524N' ,'Patricia' ,'Tuñon'  ,'Gonzalez '  ,'patriciatunon@asigno.es'  , 'UHPMLYEOJY'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '72040630F' ,'Ruth' ,'Rodriguez'  ,'Lopez '  ,'ruthrodriguez@asigno.es'  , 'NUMUYHIKIN'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '09377263W' ,'Salome' ,'Martinez'  ,'Lorenzo '  ,'salomemartinez@asigno.es'  , 'CREBDSOYXU'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '71660082V' ,'Silvia' ,'Fernandez'  ,'Tejero '  ,'silviaftejero@asigno.es'  , 'KYEXRNQTYU'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '71649760E' ,'Vanesa' ,'Redondo'  ,'Lopez '  ,'vanesaredondo@asigno.es'  , 'ARCARUFUUC'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '71881241S' ,'Veronica' ,'Ferreyra'  ,'Ochoa '  ,'veronicaferreyra@asigno.es'  , 'NHTRZGCSMM'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '36129639V' ,'Veronica' ,'Rodriguez'  ,'Comesaña '  ,'veronicarodriguez@asigno.es'  , 'BYLVJBTCPH'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( '10891911P' ,'Virginia' ,'Valdes'  ,'Alvarez-Buylla '  ,'virginiavaldes@asigno.es'  , 'LASXVXJMUP'  ,'HAYACONSU'  ,''  ,''),
		T_TIPO_DATA( 'rgranado' ,'Rafael ' ,'Granado '  ,'Bacete'  ,'rgranado@externos.haya.es'  , 'CKMQJXRUBP'  ,'HAYAGESTFORM'  ,''  ,'REMGFORM'),
		T_TIPO_DATA( 'aalvareza' ,'Angel ' ,'Alvarez '  ,'Aporta'  ,'aalvareza@externos.haya.es'  , 'RIEUHCASIN'  ,'HAYAGESTFORM'  ,''  ,'REMGFORM')

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
       
       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       
       --Si existe no se modifica
       IF V_NUM_TABLAS > 0 THEN				         
			
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USU_USUARIOS...no se modifica nada.');
			
       ELSE
     
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN USU_USUARIOS');   
        
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_USU_USUARIOS.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.USU_USUARIOS (' ||
                      'USU_ID,
                       ENTIDAD_ID,
                       USU_USERNAME,
                       USU_PASSWORD,
                       USU_NOMBRE,
                       USU_APELLIDO1,
                       USU_APELLIDO2,
                       USU_MAIL,
                       USU_GRUPO,
                       USU_FECHA_VIGENCIA_PASS,
                       USUARIOCREAR,
                       FECHACREAR,
                       BORRADO) ' ||
                      'SELECT '|| V_ID || ',
                      '|| ENTIDAD ||',
                      '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(6)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(4)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(5)) ||''',
                      ''0'',
                      SYSDATE+730,
                      ''CARGA_USUARIOS'',
                      SYSDATE,
                      0 
                      FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' INSERTADO CORRECTAMENTE EN USU_USUARIOS');
      
       END IF;
       
       -------------------------------------------------
       --Comprobamos el dato a insertar en zon_pef_usu--
       -------------------------------------------------
        
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ZON_PEF_USU '); 
        
       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_PEF_USU WHERE PEF_ID = 
						(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(7))||''') 
							AND USU_ID = 
								(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||''')';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
		-- Si existe no se modifica
		IF V_NUM_TABLAS > 0 THEN	  
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ZON_PEF_USU...no se modifica nada.');
			
		ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN ZON_PEF_USU');
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU' ||
					' (ZPU_ID, ZON_ID, PEF_ID, USU_ID, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT '||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL,' ||
					' (SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''REM''),' ||
					' (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(7))||'''),' ||
					' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''),' ||
					' ''CARGA_USUARIOS'',
					SYSDATE,
					0 
					FROM DUAL';
		   	
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' INSERTADO CORRECTAMENTE EN ZON_PEF_USU');
			
		END IF;
		
	   ------------------------------------------------------------
       --Comprobamos el dato a insertar en usd_usuarios_despachos--
       ------------------------------------------------------------
       IF V_TMP_TIPO_DATA(9) IS NULL THEN
       		DBMS_OUTPUT.PUT_LINE('[INFO]: NO INSERTA EN USUARIOS_DESPACHOS');
       ELSE
       
	       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USD_USUARIOS_DESPACHOS ');
	       
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
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS...no se modifica nada.');
				
			ELSE
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN USD_USUARIOS_DESPACHOS');
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS' ||
						' (USD_ID, DES_ID, USU_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR, BORRADO)' || 
						' SELECT '||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL,' ||
						' (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = '''||TRIM(V_TMP_TIPO_DATA(9))||'''),' ||							
						' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''),' ||
						' 1,1,''CARGA_USUARIOS'',SYSDATE,0 FROM DUAL';
			  	
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' INSERTADO CORRECTAMENTE EN USD_USUARIOS_DESPACHOS');
				
			END IF;	
		END IF;
		
	   ---------------------------------------------------------
       --Comprobamos el dato a insertar en gru_grupos_usuarios--
       ---------------------------------------------------------
       
		IF V_TMP_TIPO_DATA(8) IS NULL THEN
			DBMS_OUTPUT.PUT_LINE('[INFO]: NO INSERTA EN GRUPOS ');
		ELSE
			-- Comprobamos que exista el usuario de grupo
			V_SQL := '
			SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS
			where USU_ID_GRUPO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''')'
			;
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			IF V_NUM_TABLAS > 0 THEN
		
		       	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN GRU_GRUPOS_USUARIOS ');	
			   
				V_SQL := '
				SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS
				WHERE USU_ID_USUARIO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
				AND USU_ID_GRUPO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''')
				'
				;
				
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
				
				-- Si existe no se modifica
				IF V_NUM_TABLAS > 0 THEN	  
					DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.GRU_GRUPOS_USUARIOS...no se modifica nada.');
					
				ELSE
				
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN GRU_GRUPOS_USUARIOS');
				
				V_MSQL := '
				INSERT INTO '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS
					(GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO, USUARIOCREAR, FECHACREAR, BORRADO) 
					SELECT '||V_ESQUEMA_M||'.S_GRU_GRUPOS_USUARIOS.NEXTVAL,
					(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||'''),
					(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''),
					''HREOS-PRO'',
					SYSDATE,
					0 
					FROM DUAL
				'
				;
					
				EXECUTE IMMEDIATE V_MSQL;
				
				DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' INSERTADO CORRECTAMENTE EN GRU_GRUPOS_USUARIOS.. en GRUPO: '|| TRIM(V_TMP_TIPO_DATA(8)));
					
				END IF;
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL USUARIO DE GRUPO: '|| TRIM(V_TMP_TIPO_DATA(8)));
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