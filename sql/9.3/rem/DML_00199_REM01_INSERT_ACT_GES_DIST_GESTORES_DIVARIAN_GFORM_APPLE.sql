--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200428
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7075
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7075'; -- USUARIOCREAR/USUARIOMODIFICAR.    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		t_tipo_data('Álava', 'jdella'),
		t_tipo_data('Albacete', 'jdella'),
		t_tipo_data('Alicante', 'jdella'),
		t_tipo_data('Almería', 'jdella'),
		t_tipo_data('Avila', 'jdella'),
		t_tipo_data('Badajoz', 'jdella'),
		t_tipo_data('Baleares', 'jdella'),
		t_tipo_data('Barcelona', 'jdella'),
		t_tipo_data('Burgos', 'jdella'),
		t_tipo_data('CiudadReal', 'jdella'),
		t_tipo_data('Cáceres', 'jdella'),
		t_tipo_data('Cádiz', 'jdella'),
		t_tipo_data('Cantabria', 'jdella'),
		t_tipo_data('Castellón', 'jdella'),
		t_tipo_data('Ceuta', 'jdella'),
		t_tipo_data('Córdoba', 'jdella'),
		t_tipo_data('Cuenca', 'jdella'),
		t_tipo_data('Girona', 'jdella'),
		t_tipo_data('Granada', 'jdella'),
		t_tipo_data('Guadalajara', 'jdella'),
		t_tipo_data('Guipúzcoa', 'jdella'),
		t_tipo_data('Huelva', 'jdella'),
		t_tipo_data('Huesca', 'jdella'),
		t_tipo_data('Jaén', 'jdella'),
		t_tipo_data('A Coruña', 'jdella'),
		t_tipo_data('La Rioja', 'jdella'),
		t_tipo_data('Las Palmas', 'jdella'),
		t_tipo_data('León', 'jdella'),
		t_tipo_data('Lleida', 'jdella'),
		t_tipo_data('Lugo', 'jdella'),
		t_tipo_data('Madrid', 'jdella'),
		t_tipo_data('Málaga', 'jdella'),
		t_tipo_data('Melilla', 'jdella'),
		t_tipo_data('Murcia', 'jdella'),
		t_tipo_data('Navarra', 'jdella'),
		t_tipo_data('Ourense', 'jdella'),
		t_tipo_data('Asturias', 'jdella'),
		t_tipo_data('Palencia', 'jdella'),
		t_tipo_data('Pontevedra', 'jdella'),
		t_tipo_data('Salamanca', 'jdella'),
		t_tipo_data('Segovia', 'jdella'),
		t_tipo_data('Sevilla', 'jdella'),
		t_tipo_data('Soria', 'jdella'),
		t_tipo_data('Santa C. Tenerife', 'jdella'),
		t_tipo_data('Tarragona', 'jdella'),
		t_tipo_data('Teruel', 'jdella'),
		t_tipo_data('Toledo', 'jdella'),
		t_tipo_data('Valencia', 'jdella'),
		t_tipo_data('Valladolid', 'jdella'),
		t_tipo_data('Vizcaya', 'jdella'),
		t_tipo_data('Zamora', 'jdella'),
		t_tipo_data('Zaragoza', 'jdella'),
		t_tipo_data('Álava', 'osanz'),
		t_tipo_data('Albacete', 'osanz'),
		t_tipo_data('Alicante', 'osanz'),
		t_tipo_data('Almería', 'osanz'),
		t_tipo_data('Avila', 'osanz'),
		t_tipo_data('Badajoz', 'osanz'),
		t_tipo_data('Baleares', 'osanz'),
		t_tipo_data('Barcelona', 'osanz'),
		t_tipo_data('Burgos', 'osanz'),
		t_tipo_data('CiudadReal', 'osanz'),
		t_tipo_data('Cáceres', 'osanz'),
		t_tipo_data('Cádiz', 'osanz'),
		t_tipo_data('Cantabria', 'osanz'),
		t_tipo_data('Castellón', 'osanz'),
		t_tipo_data('Ceuta', 'osanz'),
		t_tipo_data('Córdoba', 'osanz'),
		t_tipo_data('Cuenca', 'osanz'),
		t_tipo_data('Girona', 'osanz'),
		t_tipo_data('Granada', 'osanz'),
		t_tipo_data('Guadalajara', 'osanz'),
		t_tipo_data('Guipúzcoa', 'osanz'),
		t_tipo_data('Huelva', 'osanz'),
		t_tipo_data('Huesca', 'osanz'),
		t_tipo_data('Jaén', 'osanz'),
		t_tipo_data('A Coruña', 'osanz'),
		t_tipo_data('La Rioja', 'osanz'),
		t_tipo_data('Las Palmas', 'osanz'),
		t_tipo_data('León', 'osanz'),
		t_tipo_data('Lleida', 'osanz'),
		t_tipo_data('Lugo', 'osanz'),
		t_tipo_data('Madrid', 'osanz'),
		t_tipo_data('Málaga', 'osanz'),
		t_tipo_data('Melilla', 'osanz'),
		t_tipo_data('Murcia', 'osanz'),
		t_tipo_data('Navarra', 'osanz'),
		t_tipo_data('Ourense', 'osanz'),
		t_tipo_data('Asturias', 'osanz'),
		t_tipo_data('Palencia', 'osanz'),
		t_tipo_data('Pontevedra', 'osanz'),
		t_tipo_data('Salamanca', 'osanz'),
		t_tipo_data('Segovia', 'osanz'),
		t_tipo_data('Sevilla', 'osanz'),
		t_tipo_data('Soria', 'osanz'),
		t_tipo_data('Santa C. Tenerife', 'osanz'),
		t_tipo_data('Tarragona', 'osanz'),
		t_tipo_data('Teruel', 'osanz'),
		t_tipo_data('Toledo', 'osanz'),
		t_tipo_data('Valencia', 'osanz'),
		t_tipo_data('Valladolid', 'osanz'),
		t_tipo_data('Vizcaya', 'osanz'),
		t_tipo_data('Zamora', 'osanz'),
		t_tipo_data('Zaragoza', 'osanz')
    );
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	


	V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES WHERE COD_CARTERA = ''7'' AND COD_SUBCARTERA = ''138'' AND TIPO_GESTOR = ''GFORM''';

          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO CORRECTO');

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
		
			--1 INSERT ACT_GES_DIST_GESTORES
			V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES (' || 
			  'ID, TIPO_GESTOR, COD_CARTERA, COD_PROVINCIA, USERNAME, NOMBRE_USUARIO, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) ' ||
			  'SELECT '|| V_ESQUEMA ||'.S_ACT_GES_DIST_GESTORES.NEXTVAL, ''GFORM'', ''7'', '''||V_DD_PRV_CODIGO||''', '''||TRIM(V_TMP_TIPO_DATA(2))||'''
			  ,(SELECT USU_NOMBRE FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''') , '''||V_USR||''', SYSDATE, 0, ''138'' FROM DUAL'; 
			EXECUTE IMMEDIATE V_MSQL;
			
			V_COUNT := V_COUNT + 1;
				
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
