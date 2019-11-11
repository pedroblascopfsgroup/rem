--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5665
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
    V_USU VARCHAR2(2400 CHAR) := 'REMVIP-5665';
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND2 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND3 VARCHAR2(400 CHAR) := 'IS NULL';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (		
    		-- TGE | CRA | EAC | TCR | PRV | LOC | POSTAL | USERNAME | NOMBRE_APELLIDO | SCRA
		       -- 1  2	  3   4   5	6   7	    8			9		10
		T_TIPO_DATA('PTEC', '3', '', '', '1', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '2', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '3', '', '', '---------.5', 'ASSISTACASA 2005 S.L.', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '4', '', '', 'bri.brick', 'BRICK O´CLOCK', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '5', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '6', '', '', 'bri.brick', 'BRICK O´CLOCK', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '7', '', '', '---------.5', 'ASSISTACASA 2005 S.L.', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '8', '', '', 'ablecme03', 'INV-ABLE', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '9', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '10', '', '', 'bri.brick', 'BRICK O´CLOCK', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '11', '', '', 'bri.brick', 'BRICK O´CLOCK', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '12', '', '', '---------.5', 'ASSISTACASA 2005 S.L.', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '13', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '14', '', '', 'bri.brick', 'BRICK O´CLOCK', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '15', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '16', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '17', '', '', '---------.5', 'ASSISTACASA 2005 S.L.', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '18', '', '', 'bri.brick', 'BRICK O´CLOCK', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '19', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '20', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '21', '', '', 'bri.brick', 'BRICK O´CLOCK', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '22', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '23', '', '', 'bri.brick', 'BRICK O´CLOCK', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '24', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '25', '', '', 'bri.brick', 'BRICK O´CLOCK', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '26', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '27', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '28', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '29', '', '', 'bri.brick', 'BRICK O´CLOCK', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '31', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '32', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '33', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '34', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '35', '', '', 'gen.2659701', 'BZ 99 LAS PALMAS SL', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '36', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '37', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '38', '', '', 'gen.2659701', 'BZ 99 LAS PALMAS SL', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '39', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '30', '', '', '---------.5', 'ASSISTACASA 2005 S.L.', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '40', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '41', '', '', 'bri.brick', 'BRICK O´CLOCK', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '42', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '43', '', '', 'bri.brick', 'BRICK O´CLOCK', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '44', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '45', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '46', '', '', '---------.5', 'ASSISTACASA 2005 S.L.', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '47', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '48', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '49', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '50', '', '', '---------.6', 'CASER ASISTENCIA_ACIERTA', ''),
		T_TIPO_DATA('PTEC', '3', '', '', '51', '', '', 'bri.brick', 'BRICK O´CLOCK', '')

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
         IF (V_TMP_TIPO_DATA(10) is not null)  THEN
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
					' AND COD_SUBCARTERA  '||V_COND3||' ';
          DBMS_OUTPUT.PUT_LINE(V_SQL);          
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
             DBMS_OUTPUT.PUT_LINE(V_MSQL);         
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
          
          
       --Si no existe, lo insertamos   
       ELSE
  
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
           DBMS_OUTPUT.PUT_LINE(V_MSQL);  
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', '||V_TMP_TIPO_DATA(2)||','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','||TRIM(V_TMP_TIPO_DATA(5))||' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
						', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
						', 0, '''||V_USU||''',SYSDATE,0, '''||TRIM(V_TMP_TIPO_DATA(10))||''' FROM DUAL';
                         DBMS_OUTPUT.PUT_LINE(V_MSQL);  
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
