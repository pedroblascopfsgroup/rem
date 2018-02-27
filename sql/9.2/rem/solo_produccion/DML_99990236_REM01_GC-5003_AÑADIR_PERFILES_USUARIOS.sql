--/*
--###########################################
--## AUTOR=Jessica Sampere
--## FECHA_CREACION=20180212
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.12
--## INCIDENCIA_LINK=REMNIVDOS-3315
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
		T_TIPO_DATA( '00403142K' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '01922998Z' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '02616729L' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '02618123X' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '02641048G' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '02790931L' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '02891847B' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '02912517G' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '04843135W' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '05293091D' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '05333677T' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '05359290Z' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '05426070W' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '05960870Y' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '07476736B' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '08931423V' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '11814281D' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '11834651R' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '12449131J' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '46870710E' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '47043581W' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '47294808T' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '47456865E' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '48149397R' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '4843135W' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '50299138R' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '50360263S' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '50731233H' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '51374894R' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '51621412M' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '51637306Y' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '51643931F' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '52366328C' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '53018453A' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '53103618E' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '70590549F' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '02257034K' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '02663468E' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '02715571F' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '05217085H' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '05356929E' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '07225685M' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '09796301A' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '2235351G' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '2715571F' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '31861013X' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '33521528V' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '49002451P' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '50225955G' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '50690732C' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '50729087B' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '50887128L' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '51409365H' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '51936756L' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '51943412M' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '52979268X' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '836024C' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( 'montserran' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( 'X4436667J' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '02521353R' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '06959680H' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '07957175A' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '0892090J' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '20253621M' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '20267711L' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '25120404B' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '2698508X' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '46933372D' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '47460855X' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '50432579L' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '50690262X' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '50727168R' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '50731298Z' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '50751583J' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '50834347T' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '50892090J' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '51391272A' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '51484093L' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '51927281C' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '53048030W' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '70061363M' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '74717518V' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '7525763W' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '8978199B' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( 'malcalde' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '00696205H' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '00828446D' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '04176190B' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '05466387T' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '20158921L' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '24258785H' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '36163375S' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '44858702P' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '47532475P' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '52659872S' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( '52701241F' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT'),
		T_TIPO_DATA( 'Y3134580Q' ,'' ,''  ,''  ,''  , ''  ,'HAYAGESTADMT'  ,''  ,'REMGIAADMT')




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