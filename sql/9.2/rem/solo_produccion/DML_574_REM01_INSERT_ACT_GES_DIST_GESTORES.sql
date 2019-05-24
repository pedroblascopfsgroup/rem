--/*
--##########################################
--## AUTOR=IKER ADOT
--## FECHA_CREACION=20190510
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6274
--## PRODUCTO=NO
--##
--## Finalidad: Reconfiguraciones varias en gestores formalización Carteras, CJM y LBK
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
    V_DD_PRV_CODIGO VARCHAR2(20 CHAR); -- Vble. aux para codigo de provincia
    V_USR VARCHAR2(30 CHAR) := 'HREOS-6274'; -- USUARIOCREAR/USUARIOMODIFICAR.    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(   
		t_tipo_data('8','Almería'), 
		t_tipo_data('8','Cádiz'),
		t_tipo_data('8','Córdoba'),
		t_tipo_data('8','Granada'),
		t_tipo_data('8','Huelva'),
		t_tipo_data('8','Jaén'),
		t_tipo_data('8','Málaga'),
		t_tipo_data('8','Sevilla'),
		t_tipo_data('8','Asturias'),
		t_tipo_data('8','Cantabria'), 
		t_tipo_data('8','Albacete'),
		t_tipo_data('8','CiudadReal'),
		t_tipo_data('8','Cuenca'),
		t_tipo_data('8','Guadalajara'),
		t_tipo_data('8','Avila'),
		t_tipo_data('8','Burgos'),
		t_tipo_data('8','León'),
		t_tipo_data('8','Palencia'),
		t_tipo_data('8','Salamanca'),
		t_tipo_data('8','Valladolid'),
		t_tipo_data('8','Zamora'),
		t_tipo_data('8','Huesca'),
		t_tipo_data('8','Teruel'),
		t_tipo_data('8','Zaragoza'),
		t_tipo_data('8','Barcelona'),
		t_tipo_data('8','Girona'),
		t_tipo_data('8','Lleida'),
		t_tipo_data('8','Tarragona'),
		t_tipo_data('8','Las Palmas'),  
		t_tipo_data('8','Santa C. Tenerife'),
		t_tipo_data('8','Murcia'),
		t_tipo_data('8','Álava'),
		t_tipo_data('8','Vizcaya'), 
		t_tipo_data('8','La Rioja'), 
		t_tipo_data('8','Baleares'),
		t_tipo_data('8','Navarra'),
		t_tipo_data('8','Ceuta'),
		t_tipo_data('8','Melilla'),
		t_tipo_data('8','Badajoz'),
		t_tipo_data('8','Cáceres'),
		t_tipo_data('8','A Coruña'),
		t_tipo_data('8','Lugo'),
		t_tipo_data('8','Ourense'),
		t_tipo_data('8','Pontevedra'),
		t_tipo_data('8','Madrid'),
		t_tipo_data('8','Guipúzcoa'),
		t_tipo_data('8','Segovia'),
		t_tipo_data('8','Soria')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_DESCRIPCION= '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS = 0 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: La provincia no existe: '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
        
        ELSE
			
			V_SQL := 'SELECT DD_PRV_CODIGO FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_DESCRIPCION= '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_PRV_CODIGO;
        
            --DELETE ACT_GES_DIST_GESTORES: TIPO_GESTOR GFORM, PROVINCIAS Y CARTERA            
            V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES ' ||
					  'WHERE TIPO_GESTOR = ''GIAFORM'' AND COD_CARTERA = '''||V_TMP_TIPO_DATA(1)||''' AND COD_PROVINCIA = '''||V_DD_PRV_CODIGO||'''';            
            EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: SE HAN BORRADO '|| SQL%ROWCOUNT);            
            
            --1 INSERT ACT_GES_DIST_GESTORES
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES (' || 
					  'ID, TIPO_GESTOR, COD_CARTERA, COD_PROVINCIA, USERNAME, NOMBRE_USUARIO, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
					  'SELECT '|| V_ESQUEMA ||'.S_ACT_GES_DIST_GESTORES.NEXTVAL, ''GIAFORM'', '''||V_TMP_TIPO_DATA(1)||''', '''||V_DD_PRV_CODIGO||''', ''pinos03''
					  ,(SELECT USU_NOMBRE FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = ''pinos03'') , '''||V_USR||''', SYSDATE, 0 FROM DUAL'; 
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: SE HAN INSERTADO '|| SQL%ROWCOUNT);
			
        END IF;        
      END LOOP;    
    
    --ROLLBACK;
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


   
