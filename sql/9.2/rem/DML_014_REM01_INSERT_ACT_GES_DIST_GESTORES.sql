--/*
--##########################################
--## AUTOR=Miguel Lopez
--## FECHA_CREACION=20190715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.15.0
--## INCIDENCIA_LINK=HREOS-7029
--## PRODUCTO=NO
--##
--## Finalidad:	Añade en la tabla ACT_GES_DIST_GESTORES los datos del array T_ARRAY_DATA (GESTORES)
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
    V_SQL2 VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USU VARCHAR2(2400 CHAR) := 'HREOS-7029';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		
-- TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, COD_SUBCARTERA
         T_TIPO_DATA('HAYASBOINM', '6', null, '2', null, null, null, 'ejust', 'Ernesto Just', null),
         T_TIPO_DATA('HAYASBOINM', '10', null, '2', null, null, null, 'ejust', 'Ernesto Just', null),
         T_TIPO_DATA('HAYASBOINM', '11', null, '2', null, null, null, 'ejust', 'Ernesto Just', '28'),
         T_TIPO_DATA('HAYASBOINM', '11', null, '2', null, null, null, 'ejust', 'Ernesto Just', '30'),
         T_TIPO_DATA('HAYASBOINM', '12', null, '2', null, null, null, 'ejust', 'Ernesto Just', null),
         T_TIPO_DATA('HAYASBOINM', '13', null, '2', null, null, null, 'ejust', 'Ernesto Just', '41'),
         T_TIPO_DATA('HAYASBOINM', '15', null, '2', null, null, null, 'ejust', 'Ernesto Just', null)

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    -- LOOP para insertar o modificar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;

          V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||'''AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''' AND (COD_SUBCARTERA IS NULL OR  COD_SUBCARTERA = '''||TRIM(V_TMP_TIPO_DATA(10))||''')';
          EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    	  IF V_NUM_TABLAS = 0 THEN
          	
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
