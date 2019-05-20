--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190410
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6072
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
    V_USU VARCHAR2(2400 CHAR) := 'HREOS-6072';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		
         T_TIPO_DATA('PTEC', '2', '', '', '1', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '2', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '3', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '4', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '5', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '6', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '7', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '8', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '9', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '10', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '11', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '12', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '13', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '14', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '15', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '16', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '17', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '18', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '19', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '20', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '21', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '22', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '23', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '24', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '25', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '26', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '27', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '28', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '29', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '30', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '31', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '32', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '33', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '34', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '35', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '36', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '37', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '38', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '39', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '40', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '41', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '42', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '43', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '44', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '45', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '46', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '47', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '48', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '49', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '50', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '51', '', '', 'A48027056', 'ELECNOR, S.A.', '4'),
         T_TIPO_DATA('PTEC', '2', '', '', '52', '', '', 'A48027056', 'ELECNOR, S.A.', '4')
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
	IF (V_TMP_TIPO_DATA(6) is not null)  THEN
			V_COND1 := '= '''||TRIM(V_TMP_TIPO_DATA(6))||''' ';
        END IF;
        			
  
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','''||TRIM(V_TMP_TIPO_DATA(5))||''' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
						', '''||TRIM(V_TMP_TIPO_DATA(9))||''' '||
						', 0, '''||V_USU||''',SYSDATE, 0, '''||TRIM(V_TMP_TIPO_DATA(10))||''' FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
        
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
