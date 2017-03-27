--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20170323
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1683
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_GES_DIST_GESTORES los datos añadidos en T_ARRAY_DATA
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    			-- TGE		 CRA	EAC	  TCR	PRV	 	LOC  		POSTAL	USERNAME
-- BANKIA - GESTOR COMERCIAL
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35002'  ,'35118'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35002'  ,'35260'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35007'  ,'35001'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35007'  ,'35002'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35007'  ,'35007'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35007'  ,'35009'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35007'  ,'35010'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35007'  ,'35011'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35007'  ,'35013'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35007'  ,'35015'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35007'  ,'35016'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35007'  ,'35018'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35007'  ,'35019'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35007'  ,'35330'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35009'  ,'35110'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35011'  ,'35240'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35011'  ,'35259'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35012'  ,'35120'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35012'  ,'35130'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35013'  ,'35421'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35013'  ,'35509'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35013'  ,'35550'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35014'  ,'35640'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35014'  ,'35660'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35014'  ,'35660'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35015'  ,'35627'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35015'  ,'35625'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35015'  ,'35600'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35016'  ,'35004'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35016'  ,'35016'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35016'  ,'35017'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35016'  ,'35017'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35016'  ,'35018'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35016'  ,'35018'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35018'  ,'35509'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35018'  ,'35550'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35019'  ,'35100'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35019'  ,'35290'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35019'  ,'35100'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35020'  ,'35470'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35022'  ,'35110'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35022'  ,'35110'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35022'  ,'35010'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35022'  ,'35100'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35022'  ,'35110'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35022'  ,'35110'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35022'  ,'35219'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35022'  ,'35219'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35022'  ,'35250'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35022'  ,'35280'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35022'  ,'35280'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35022'  ,'35110'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35022'  ,'35119'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35024'  ,'35507'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35026'  ,'35200'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35026'  ,'35212'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35028'  ,'35510'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35030'  ,'35620'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35030'  ,'35628'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35030'  ,'35627'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35031'  ,'35216'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35031'  ,'35217'  ,'etraviesol'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35034'  ,'35570'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '35'  ,'35034'  ,'35580'  ,'agonzalez'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46001'  ,'bmorant'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46002'  ,'mgarcia'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46006'  ,'bmorant'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46007'  ,'mgarcia'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46008'  ,'mgarcia'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46009'  ,'bmorant'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46010'  ,'bmorant'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46011'  ,'mgarcia'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46012'  ,'mgarcia'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46013'  ,'mgarcia'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46014'  ,'mgarcia'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46015'  ,'mgarcia'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46017'  ,'mgarcia'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46018'  ,'bmorant'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46019'  ,'bmorant'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46020'  ,'bmorant'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46021'  ,'mgarcia'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46022'  ,'mgarcia'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46023'  ,'bmorant'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46024'  ,'bmorant'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46025'  ,'bmorant'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46026'  ,'mgarcia'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46035'  ,'mgarcia'),
		T_TIPO_DATA('GCOM'  ,'03'  ,''  ,'02'  , '46'  ,'46250'  ,'46112'  ,'mgarcia'),
-- CAJAMAR - GESTOR COMERCIAL
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46001'  ,'lmontesino'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46002'  ,'dmartin'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46003'  ,'lmontesino'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46004'  ,'dmartin'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46005'  ,'dmartin'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46006'  ,'lmontesino'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46007'  ,'lmontesino'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46008'  ,'dmartin'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46009'  ,'dmartin'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46010'  ,'lmontesino'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46011'  ,'dmartin'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46012'  ,'lmontesino'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46013'  ,'lmontesino'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46014'  ,'lmontesino'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46015'  ,'dmartin'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46017'  ,'lmontesino'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46018'  ,'dmartin'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46019'  ,'dmartin'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46020'  ,'dmartin'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46021'  ,'dmartin'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46022'  ,'dmartin'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46023'  ,'dmartin'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46024'  ,'lmontesino'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46025'  ,'lmontesino'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46026'  ,'lmontesino'),
		T_TIPO_DATA('GCOM'  ,'01'  ,''  ,'02'  , '46'  ,'46250'  ,'46035'  ,'dmartin')
	
		
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
        			' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION = '''||TRIM(V_TMP_TIPO_DATA(4))||''' '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO = '''||TRIM(V_TMP_TIPO_DATA(6))||''' '||
					' AND COD_POSTAL = '''||TRIM(V_TMP_TIPO_DATA(7))||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    ' SET USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
					' , NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
					' , USUARIOMODIFICAR = ''HREOS-1683'' , FECHAMODIFICAR = SYSDATE '||
					' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION = '''||TRIM(V_TMP_TIPO_DATA(4))||''' '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO = '''||TRIM(V_TMP_TIPO_DATA(6))||''' '||
					' AND COD_POSTAL = '''||TRIM(V_TMP_TIPO_DATA(7))||''' ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA CODIGO POSTAL: '||TRIM(V_TMP_TIPO_DATA(7)));
          
       --Si no existe, lo insertamos   
       ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', '||V_TMP_TIPO_DATA(2)||','''||V_TMP_TIPO_DATA(3)||''','''||V_TMP_TIPO_DATA(4)||''','||V_TMP_TIPO_DATA(5)||' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
						', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
						', 0, ''HREOS-1683'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA CODIGO POSTAL: '||TRIM(V_TMP_TIPO_DATA(7)));
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

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
