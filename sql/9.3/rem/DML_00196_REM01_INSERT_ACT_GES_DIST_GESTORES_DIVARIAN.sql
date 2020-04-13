--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200413
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6956
--## PRODUCTO=NO
--##
--## Finalidad: Insertar GFORM Divarian
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
    V_COUNT NUMBER(16):= 0;
    V_ID NUMBER(16);
    V_DD_PRV_CODIGO VARCHAR2(20 CHAR); -- Vble. aux para codigo de provincia
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6956'; -- USUARIOCREAR/USUARIOMODIFICAR.    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		t_tipo_data('Álava', 'jmartinezsa'),
		t_tipo_data('Albacete', 'gplana'),
		t_tipo_data('Alicante', 'jcarbonellm'),
		t_tipo_data('Almería', 'ebenitezt'),
		t_tipo_data('Avila', 'gplana'),
		t_tipo_data('Badajoz', 'alopezr'),
		t_tipo_data('Baleares', 'jcarbonellm'),
		t_tipo_data('Barcelona', 'alopezr'),
		t_tipo_data('Barcelona', 'gplana'),
		t_tipo_data('Barcelona', 'ebenitezt'),
		t_tipo_data('Barcelona', 'jmartinezsa'),
		t_tipo_data('Barcelona', 'jcarbonellm'),
		t_tipo_data('Barcelona', 'ptranche'),
		t_tipo_data('Burgos', 'jmartinezsa'),
		t_tipo_data('CiudadReal', 'gplana'),
		t_tipo_data('Cáceres', 'alopezr'),
		t_tipo_data('Cádiz', 'alopezr'),
		t_tipo_data('Cantabria', 'jmartinezsa'),
		t_tipo_data('Castellón', 'jcarbonellm'),
		t_tipo_data('Ceuta', 'alopezr'),
		t_tipo_data('Córdoba', 'alopezr'),
		t_tipo_data('Cuenca', 'gplana'),
		t_tipo_data('Girona', 'alopezr'),
		t_tipo_data('Girona', 'gplana'),
		t_tipo_data('Girona', 'ebenitezt'),
		t_tipo_data('Girona', 'jmartinezsa'),
		t_tipo_data('Girona', 'jcarbonellm'),
		t_tipo_data('Girona', 'ptranche'),
		t_tipo_data('Granada', 'ebenitezt'),
		t_tipo_data('Guadalajara', 'gplana'),
		t_tipo_data('Guipúzcoa', 'jmartinezsa'),
		t_tipo_data('Huelva', 'alopezr'),
		t_tipo_data('Huesca', 'jmartinezsa'),
		t_tipo_data('Jaén', 'ebenitezt'),
		t_tipo_data('A Coruña', 'jmartinezsa'),
		t_tipo_data('La Rioja', 'jmartinezsa'),
		t_tipo_data('Las Palmas', 'ptranche'),
		t_tipo_data('León', 'jmartinezsa'),
		t_tipo_data('Lleida', 'alopezr'),
		t_tipo_data('Lleida', 'gplana'),
		t_tipo_data('Lleida', 'ebenitezt'),
		t_tipo_data('Lleida', 'jmartinezsa'),
		t_tipo_data('Lleida', 'jcarbonellm'),
		t_tipo_data('Lleida', 'ptranche'),
		t_tipo_data('Lugo', 'jmartinezsa'),
		t_tipo_data('Madrid', 'gplana'),
		t_tipo_data('Málaga', 'ebenitezt'),
		t_tipo_data('Melilla', 'ebenitezt'),
		t_tipo_data('Murcia', 'jcarbonellm'),
		t_tipo_data('Navarra', 'jmartinezsa'),
		t_tipo_data('Ourense', 'jmartinezsa'),
		t_tipo_data('Asturias', 'jmartinezsa'),
		t_tipo_data('Palencia', 'jmartinezsa'),
		t_tipo_data('Pontevedra', 'jmartinezsa'),
		t_tipo_data('Salamanca', 'gplana'),
		t_tipo_data('Segovia', 'gplana'),
		t_tipo_data('Sevilla', 'alopezr'),
		t_tipo_data('Soria', 'gplana'),
		t_tipo_data('Santa C. Tenerife', 'ptranche'),
		t_tipo_data('Tarragona', 'alopezr'),
		t_tipo_data('Tarragona', 'gplana'),
		t_tipo_data('Tarragona', 'ebenitezt'),
		t_tipo_data('Tarragona', 'jmartinezsa'),
		t_tipo_data('Tarragona', 'jcarbonellm'),
		t_tipo_data('Tarragona', 'ptranche'),
		t_tipo_data('Teruel', 'jmartinezsa'),
		t_tipo_data('Toledo', 'gplana'),
		t_tipo_data('Valencia', 'jcarbonellm'),
		t_tipo_data('Valladolid', 'jmartinezsa'),
		t_tipo_data('Vizcaya', 'jmartinezsa'),
		t_tipo_data('Zamora', 'jmartinezsa'),
		t_tipo_data('Zaragoza', 'jmartinezsa')
    );
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
	
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
	    --Comprobamos el dato a insertar
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_DESCRIPCION= '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO]: La provincia no existe: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
		
		ELSE
			V_SQL := 'SELECT DD_PRV_CODIGO FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_DESCRIPCION= '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_PRV_CODIGO;
		
			--DELETE ACT_GES_DIST_GESTORES: TIPO_GESTOR GFORM, PROVINCIAS Y CARTERA            
			V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES ' ||
			  'WHERE TIPO_GESTOR = ''GFORM'' AND COD_CARTERA = ''7'' AND COD_SUBCARTERA = ''151'' AND COD_PROVINCIA = '''||V_DD_PRV_CODIGO||''' AND USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';            
			EXECUTE IMMEDIATE V_MSQL;           
		
			--1 INSERT ACT_GES_DIST_GESTORES
			V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES (' || 
			  'ID, TIPO_GESTOR, COD_CARTERA, COD_PROVINCIA, USERNAME, NOMBRE_USUARIO, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) ' ||
			  'SELECT '|| V_ESQUEMA ||'.S_ACT_GES_DIST_GESTORES.NEXTVAL, ''GFORM'', ''7'', '''||V_DD_PRV_CODIGO||''', '''||TRIM(V_TMP_TIPO_DATA(2))||'''
			  ,(SELECT USU_NOMBRE FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''') , '''||V_USR||''', SYSDATE, 0, ''151'' FROM DUAL'; 
			EXECUTE IMMEDIATE V_MSQL;
			
			--DELETE ACT_GES_DIST_GESTORES: TIPO_GESTOR GFORM, PROVINCIAS Y CARTERA            
			V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES ' ||
			  'WHERE TIPO_GESTOR = ''GFORM'' AND COD_CARTERA = ''7'' AND COD_SUBCARTERA = ''152'' AND COD_PROVINCIA = '''||V_DD_PRV_CODIGO||''' AND USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';         
			EXECUTE IMMEDIATE V_MSQL;      
		
			--1 INSERT ACT_GES_DIST_GESTORES
			V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES (' || 
			  'ID, TIPO_GESTOR, COD_CARTERA, COD_PROVINCIA, USERNAME, NOMBRE_USUARIO, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) ' ||
			  'SELECT '|| V_ESQUEMA ||'.S_ACT_GES_DIST_GESTORES.NEXTVAL, ''GFORM'', ''7'', '''||V_DD_PRV_CODIGO||''', '''||TRIM(V_TMP_TIPO_DATA(2))||'''
			  ,(SELECT USU_NOMBRE FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''') , '''||V_USR||''', SYSDATE, 0, ''152'' FROM DUAL'; 
			EXECUTE IMMEDIATE V_MSQL;
			
			V_COUNT := V_COUNT + 2;
				
		END IF;        
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: SE HAN INSERTADO '|| V_COUNT ||' REGISTROS');
    
	COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');   

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
EXIT;