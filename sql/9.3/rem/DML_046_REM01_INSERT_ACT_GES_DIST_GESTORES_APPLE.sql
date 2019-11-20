--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190820
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5092
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
    V_USU VARCHAR2(2400 CHAR) := 'RREMVIP-5092';
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND2 VARCHAR2(400 CHAR) := 'IS NULL';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (		
    	 T_TIPO_DATA('SFORM', '7', '', '', '1', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '2', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '3', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '4', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '5', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '6', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '7', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '8', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '9', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '10', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '11', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '12', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '13', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '14', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '15', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '16', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '17', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '18', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '19', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '20', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '21', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '22', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '23', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '24', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '25', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '26', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '27', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '28', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '29', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '30', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '31', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '32', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '33', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '34', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '35', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '36', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '37', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '38', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '39', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '40', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '41', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '42', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '43', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '44', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '45', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '46', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '47', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '48', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '49', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '50', '', '', 'pdiez', 'Paloma Diez Blasco', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '51', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138'),
         T_TIPO_DATA('SFORM', '7', '', '', '52', '', '', 'mfuentesm', 'Mario Fuentes Martinez', '138')
         
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
