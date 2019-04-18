--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190410
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3971
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
    V_USU VARCHAR2(2400 CHAR) := 'REMVIP-3971';
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND2 VARCHAR2(400 CHAR) := 'IS NULL';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (		
    	 T_TIPO_DATA('GCOM', '7', '', '', '1', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '2', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '3', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '4', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '5', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '6', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '7', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '8', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '9', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '10', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '11', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '12', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '13', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '14', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '15', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '16', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '17', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '18', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '19', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '20', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '21', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '22', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '23', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '24', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '25', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '26', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '27', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '28', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '29', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '30', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '31', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '32', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '33', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '34', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '35', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '36', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '37', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '38', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '39', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '40', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '41', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '42', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '43', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '44', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '45', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '46', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '47', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '48', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '49', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '50', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '51', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GCOM', '7', '', '', '52', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         ------------------------------------------------------------------------------------------------
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '1', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '2', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '3', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '4', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '5', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '6', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '7', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '8', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '9', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '10', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '11', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '12', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '13', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '14', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '15', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '16', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '17', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '18', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '19', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '20', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '21', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '22', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '23', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '24', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '25', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '26', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '27', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '28', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '29', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '30', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '31', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '32', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '33', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '34', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '35', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '36', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '37', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '38', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '39', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '40', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '41', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '42', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '43', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '44', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '45', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '46', '', '', 'pgarciafraile', 'Pablo García Fraile', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '47', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '48', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '49', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '50', '', '', 'jguarch', 'Jose Maria Guarch Herrero', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '51', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138'),
         T_TIPO_DATA('GESTCOMALQ', '7', '', '', '52', '', '', 'rjimeno', 'Raúl Jimeno	Fuentes', '138')
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
        IF (V_TMP_TIPO_DATA(4) is not null)  THEN
			V_COND1 := '= '''||TRIM(V_TMP_TIPO_DATA(4))||''' ';
        END IF;
        IF (V_TMP_TIPO_DATA(6) is not null) THEN
			V_COND2 := '= '''||TRIM(V_TMP_TIPO_DATA(6))||''' ';
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
					' AND COD_SUBCARTERA = '''||TRIM(V_TMP_TIPO_DATA(10))||''' ';
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
					' AND COD_SUBCARTERA = '''||TRIM(V_TMP_TIPO_DATA(10))||''' ';
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
