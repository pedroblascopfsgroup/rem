--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200317
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6688
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
    V_USU VARCHAR2(2400 CHAR) := 'RREMVIP-6688';
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND2 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND3 VARCHAR2(400 CHAR) := 'IS NULL';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (		
	--LBK
        T_TIPO_DATA('GACT', '2', '', '', '4', '', '', 'aruiz', 'Antonio Ruiz Avila', ''),
	T_TIPO_DATA('GACT', '2', '', '', '11', '', '', 'aruiz', 'Antonio Ruiz Avila', ''),
	T_TIPO_DATA('GACT', '2', '', '', '14', '', '', 'aruiz', 'Antonio Ruiz Avila', ''),
	T_TIPO_DATA('GACT', '2', '', '', '18', '', '', 'aruiz', 'Antonio Ruiz Avila', ''),
	T_TIPO_DATA('GACT', '2', '', '', '21', '', '', 'aruiz', 'Antonio Ruiz Avila', ''),
	T_TIPO_DATA('GACT', '2', '', '', '23', '', '', 'aruiz', 'Antonio Ruiz Avila', ''),
	T_TIPO_DATA('GACT', '2', '', '', '29', '', '', 'aruiz', 'Antonio Ruiz Avila', ''),
	T_TIPO_DATA('GACT', '2', '', '', '41', '', '', 'aruiz', 'Antonio Ruiz Avila', ''),
	T_TIPO_DATA('GACT', '2', '', '', '22', '', '', 'agonzaleza', 'Ana Gonzalez Alonso', ''),
	T_TIPO_DATA('GACT', '2', '', '', '44', '', '', 'agonzaleza', 'Ana Gonzalez Alonso', ''),
	T_TIPO_DATA('GACT', '2', '', '', '50', '', '', 'agonzaleza', 'Ana Gonzalez Alonso', ''),
	T_TIPO_DATA('GACT', '2', '', '', '7', '', '', 'jberenguerx', 'Jose Berenguer Aleixandre', ''),
	T_TIPO_DATA('GACT', '2', '', '', '35', '35003', '', 'nhorcajo', 'Natalia Horcajo Gavira', ''),
	T_TIPO_DATA('GACT', '2', '', '', '35', '35004', '', 'nhorcajo', 'Natalia Horcajo Gavira', ''),
	T_TIPO_DATA('GACT', '2', '', '', '35', '35007', '', 'nhorcajo', 'Natalia Horcajo Gavira', ''),
	T_TIPO_DATA('GACT', '2', '', '', '35', '35010', '', 'nhorcajo', 'Natalia Horcajo Gavira', ''),
	T_TIPO_DATA('GACT', '2', '', '', '35', '35014', '', 'nhorcajo', 'Natalia Horcajo Gavira', ''),
	T_TIPO_DATA('GACT', '2', '', '', '35', '35015', '', 'nhorcajo', 'Natalia Horcajo Gavira', ''),
	T_TIPO_DATA('GACT', '2', '', '', '35', '35017', '', 'nhorcajo', 'Natalia Horcajo Gavira', ''),
	T_TIPO_DATA('GACT', '2', '', '', '35', '35018', '', 'nhorcajo', 'Natalia Horcajo Gavira', ''),
	T_TIPO_DATA('GACT', '2', '', '', '35', '35024', '', 'nhorcajo', 'Natalia Horcajo Gavira', ''),
	T_TIPO_DATA('GACT', '2', '', '', '35', '35028', '', 'nhorcajo', 'Natalia Horcajo Gavira', ''),
	T_TIPO_DATA('GACT', '2', '', '', '35', '35029', '', 'nhorcajo', 'Natalia Horcajo Gavira', ''),
	T_TIPO_DATA('GACT', '2', '', '', '35', '35030', '', 'nhorcajo', 'Natalia Horcajo Gavira', ''),
	T_TIPO_DATA('GACT', '2', '', '', '35', '35034', '', 'nhorcajo', 'Natalia Horcajo Gavira', ''),
	T_TIPO_DATA('GACT', '2', '', '', '35', '', '', 'ckuhnel', 'Carmen Kuhnel Alemán', ''),
	T_TIPO_DATA('GACT', '2', '', '', '38', '', '', 'nhorcajo', 'Natalia Horcajo Gavira', ''),
	T_TIPO_DATA('GACT', '2', '', '', '39', '', '', 'agonzaleza', 'Ana Gonzalez Alonso', ''),
	T_TIPO_DATA('GACT', '2', '', '', '2', '', '', 'ckuhnel', 'Carmen Kuhnel Alemán', ''),
	T_TIPO_DATA('GACT', '2', '', '', '13', '', '', 'aruiz', 'Antonio Ruiz Avila', ''),
	T_TIPO_DATA('GACT', '2', '', '', '16', '', '', 'nhorcajo', 'NATALIA HORCAJO GAVIRA', ''),
	T_TIPO_DATA('GACT', '2', '', '', '19', '', '', 'agonzaleza', 'Ana Gonzalez Alonso', ''),
	T_TIPO_DATA('GACT', '2', '', '', '45', '', '', 'agonzaleza', 'Ana Gonzalez Alonso', ''),
	T_TIPO_DATA('GACT', '2', '', '', '5', '', '', 'amonge', 'Alfredo Leonardo Monge Jurado', ''),
	T_TIPO_DATA('GACT', '2', '', '', '9', '', '', 'amonge', 'Alfredo Leonardo Monge Jurado', ''),
	T_TIPO_DATA('GACT', '2', '', '', '24', '', '', 'amonge', 'Alfredo Leonardo Monge Jurado', ''),
	T_TIPO_DATA('GACT', '2', '', '', '34', '', '', 'amonge', 'Alfredo Leonardo Monge Jurado', ''),
	T_TIPO_DATA('GACT', '2', '', '', '37', '', '', 'amonge', 'Alfredo Leonardo Monge Jurado', ''),
	T_TIPO_DATA('GACT', '2', '', '', '40', '', '', 'amonge', 'Alfredo Leonardo Monge Jurado', ''),
	T_TIPO_DATA('GACT', '2', '', '', '42', '', '', 'amonge', 'Alfredo Leonardo Monge Jurado', ''),
	T_TIPO_DATA('GACT', '2', '', '', '47', '', '', 'amonge', 'Alfredo Leonardo Monge Jurado', ''),
	T_TIPO_DATA('GACT', '2', '', '', '49', '', '', 'amonge', 'Alfredo Leonardo Monge Jurado', ''),
	T_TIPO_DATA('GACT', '2', '', '', '8', '', '', 'jberenguerx', 'Jose Berenguer Aleixandre', ''),
	T_TIPO_DATA('GACT', '2', '', '', '17', '', '', 'jberenguerx', 'Jose Berenguer Aleixandre', ''),
	T_TIPO_DATA('GACT', '2', '', '', '25', '', '', 'jberenguerx', 'Jose Berenguer Aleixandre', ''),
	T_TIPO_DATA('GACT', '2', '', '', '43', '', '', 'jberenguerx', 'Jose Berenguer Aleixandre', ''),
	T_TIPO_DATA('GACT', '2', '', '', '3', '', '', 'jberenguerx', 'Jose Berenguer Aleixandre', ''),
	T_TIPO_DATA('GACT', '2', '', '', '12', '', '', 'jberenguerx', 'Jose Berenguer Aleixandre', ''),
	T_TIPO_DATA('GACT', '2', '', '', '46', '', '', 'jberenguerx', 'Jose Berenguer Aleixandre', ''),
	T_TIPO_DATA('GACT', '2', '', '', '6', '', '', 'aruiz', 'Antonio Ruiz Avila', ''),
	T_TIPO_DATA('GACT', '2', '', '', '10', '', '', 'aruiz', 'Antonio Ruiz Avila', ''),
	T_TIPO_DATA('GACT', '2', '', '', '15', '', '', 'agonzaleza', 'Ana Gonzalez Alonso', ''),
	T_TIPO_DATA('GACT', '2', '', '', '27', '', '', 'agonzaleza', 'Ana Gonzalez Alonso', ''),
	T_TIPO_DATA('GACT', '2', '', '', '32', '', '', 'agonzaleza', 'Ana Gonzalez Alonso', ''),
	T_TIPO_DATA('GACT', '2', '', '', '36', '', '', 'agonzaleza', 'Ana Gonzalez Alonso', ''),
	T_TIPO_DATA('GACT', '2', '', '', '28', '28079', '', 'amonge', 'Alfredo Leonardo Monge Jurado', ''),
	T_TIPO_DATA('GACT', '2', '', '', '28', '', '', 'agonzaleza', 'Ana Gonzalez Alonso', ''),
	T_TIPO_DATA('GACT', '2', '', '', '30', '', '', 'ckuhnel', 'Carmen Kuhnel Alemán', ''),
	T_TIPO_DATA('GACT', '2', '', '', '31', '', '', 'agonzaleza', 'Ana Gonzalez Alonso', ''),
	T_TIPO_DATA('GACT', '2', '', '', '1', '', '', 'agonzaleza', 'Ana Gonzalez Alonso', ''),
	T_TIPO_DATA('GACT', '2', '', '', '20', '', '', 'agonzaleza', 'Ana Gonzalez Alonso', ''),
	T_TIPO_DATA('GACT', '2', '', '', '48', '', '', 'agonzaleza', 'Ana Gonzalez Alonso', ''),
	T_TIPO_DATA('GACT', '2', '', '', '33', '', '', 'agonzaleza', 'Ana Gonzalez Alonso', ''),
	T_TIPO_DATA('GACT', '2', '', '', '26', '', '', 'amonge', 'Alfredo Leonardo Monge Jurado', ''),
	T_TIPO_DATA('GACT', '2', '', '', '51', '', '', 'nhorcajo', 'Natalia Horcajo Gavira', ''),
	T_TIPO_DATA('GACT', '2', '', '', '52', '', '', 'nhorcajo', 'Natalia Horcajo Gavira', '')
  
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    -- LOOP para insertar o modificar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        V_COND1 := 'IS NULL';
	V_COND2 := 'IS NULL';
        V_COND3 := 'IS NULL';

        IF (V_TMP_TIPO_DATA(4) is not null)  THEN
			V_COND1 := '= '''||TRIM(V_TMP_TIPO_DATA(4))||''' ';
        END IF;
        IF (V_TMP_TIPO_DATA(6) is not null) THEN
			V_COND2 := '= '''||TRIM(V_TMP_TIPO_DATA(6))||''' ';
        END IF;
        IF (V_TMP_TIPO_DATA(10) is not null) THEN
			V_COND3 := '= '''||TRIM(V_TMP_TIPO_DATA(10))||''' ';
        END IF;
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
        			' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||	
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION  '||V_COND1||' '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO '||V_COND2||' '||
					' AND COD_POSTAL IS NULL '||
					' AND COD_SUBCARTERA '||V_COND3||' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    ' SET USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
					' , NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
					' , USUARIOMODIFICAR = '''||V_USU||''' , FECHAMODIFICAR = SYSDATE '||
					' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO  IS NULL '||
					' AND COD_TIPO_COMERZIALZACION '||V_COND1||' '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO '||V_COND2||' '||
					' AND COD_POSTAL IS NULL '||
					' AND COD_SUBCARTERA '||V_COND3||' ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
          
          
       --Si no existe, lo insertamos   
       ELSE
  
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', '||V_TMP_TIPO_DATA(2)||','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','||TRIM(V_TMP_TIPO_DATA(5))||' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
						', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
						', 0, '''||V_USU||''',SYSDATE,0, '''||TRIM(V_TMP_TIPO_DATA(10))||''' FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
        
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
