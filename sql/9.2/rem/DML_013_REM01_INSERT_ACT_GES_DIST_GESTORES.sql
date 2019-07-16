--/*
--##########################################
--## AUTOR=Alfonso Rodriguez
--## FECHA_CREACION=20190716
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.16.0
--## INCIDENCIA_LINK=HREOS-6976
--## PRODUCTO=NO
--##
--## Finalidad:	Añade en la tabla ACT_GES_DIST_GESTORES los datos del array T_ARRAY_DATA
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
    V_USU VARCHAR2(2400 CHAR) := 'HREOS-6976';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	-- TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, COD_SUBCARTERA	
        -- GIANTS 
         T_TIPO_DATA('GCOM', '12', null, null, null, null, null, 'bgarcia', 'Blanca Garcia Planet', null),
         T_TIPO_DATA('HAYAGBOINM', '12', null, null, null, null, null, 'prodriguezg', 'Patricia Rodriguez Guzman', null),
         T_TIPO_DATA('GPUBL', '12', null, null, null, null, null, 'lmartinc', 'Leticia Martin Contreras', null),
         T_TIPO_DATA('SCOM', '12', null, null, null, null, null, 'rdelolmo', 'Raul Del Olmo Iglesias', null),
         T_TIPO_DATA('GBACKOFFICE', '12', null, null, null, null, null, 'ejust', 'ERNESTO JUST PLA', null),
         T_TIPO_DATA('SPUBL', '12', null, null, null, null, null, 'saragon', 'Sara Aragon Gutierrez', null),

         -- GALEON
         T_TIPO_DATA('GCOM', '15', null, null, null, null, null, 'ndelgado', 'Natalia Delgado Auñon', null),
         T_TIPO_DATA('HAYAGBOINM', '15', null, null, null, null, null, 'prodriguezg', 'Patricia Rodriguez Guzman', null),
         T_TIPO_DATA('GPUBL', '15', null, null, null, null, null, 'aruedag', 'Anselmo Rueda', null),
         T_TIPO_DATA('SCOM', '15', null, null, null, null, null, 'rdelolmo', 'Raul Del Olmo Iglesias', null),
         T_TIPO_DATA('GBACKOFFICE', '15', null, null, null, null, null, 'ejust', 'ERNESTO JUST PLA', null),
         T_TIPO_DATA('SPUBL', '15', null, null, null, null, null, 'saragon', 'Sara Aragon Gutierrez', null),

         -- EGEO SUBCARTERA ZEUS
         T_TIPO_DATA('GCOM', '13', null, null, null, null, null, 'ndelgado', 'Natalia Delgado Auñon', '41'),
         T_TIPO_DATA('HAYAGBOINM', '13', null, null, null, null, null, 'prodriguezg', 'Patricia Rodriguez Guzman', '41'),
         T_TIPO_DATA('GPUBL', '13', null, null, null, null, null, 'aruedag', 'Anselmo Rueda', '41'),
         T_TIPO_DATA('SCOM', '13', null, null, null, null, null, 'rdelolmo', 'Raul Del Olmo Iglesias', '41'),
         T_TIPO_DATA('GBACKOFFICE', '13', null, null, null, null, null, 'ejust', 'ERNESTO JUST PLA', '41'),
         T_TIPO_DATA('SPUBL', '13', null, null,null, null, null, 'saragon', 'Sara Aragon Gutierrez', '41')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	
    -- LOOP para insertar o modificar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);


      V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
       WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
      	AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' 
      	AND (COD_ESTADO_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(3))||''' OR COD_ESTADO_ACTIVO IS NULL)
		AND (COD_TIPO_COMERZIALZACION = '''||TRIM(V_TMP_TIPO_DATA(4))||''' OR COD_TIPO_COMERZIALZACION IS NULL) 
		AND (COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' OR COD_PROVINCIA IS NULL) 
		AND (COD_MUNICIPIO = '''||TRIM(V_TMP_TIPO_DATA(6))||''' OR COD_MUNICIPIO IS NULL) 
		AND (COD_POSTAL = '''||TRIM(V_TMP_TIPO_DATA(7))||''' OR COD_POSTAL IS NULL)
      	AND USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''' AND BORRADO = 0 
      	AND (COD_SUBCARTERA = '''||TRIM(V_TMP_TIPO_DATA(10))||''' OR COD_SUBCARTERA IS NULL )';

        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 0 THEN  
  
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) ' ||
                      	'SELECT '|| V_ID || ','''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','''||TRIM(V_TMP_TIPO_DATA(5))||''' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
						', '''||TRIM(V_TMP_TIPO_DATA(9))||''' '||
						', 0, '''||V_USU||''',SYSDATE, 0, '''||TRIM(V_TMP_TIPO_DATA(10))||''' FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA USUARIO: '''|| TRIM(V_TMP_TIPO_DATA(8)) ||'''');

      	ELSE
      		DBMS_OUTPUT.PUT_LINE('[INFO]: DATOS YA REGISTRADOS');        
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
