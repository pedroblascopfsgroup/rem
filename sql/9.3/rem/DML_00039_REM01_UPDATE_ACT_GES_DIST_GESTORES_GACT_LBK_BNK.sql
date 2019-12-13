--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191212
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5874
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
    V_USU VARCHAR2(2400 CHAR) := 'RREMVIP-5874';
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND2 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND3 VARCHAR2(400 CHAR) := 'IS NULL';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (		
	--LBK
    	 T_TIPO_DATA('GACT', '8', '', '', '1', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '2', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '3', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '4', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '5', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '6', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '7', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '8', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '9', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '10', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '11', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '12', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '13', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '14', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '15', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '16', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '17', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '18', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '19', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '20', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '21', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '22', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '23', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '24', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '25', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '26', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '27', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '28', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '29', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '30', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '31', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '32', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '33', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '34', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '35', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '36', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '37', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '38', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '39', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '40', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '41', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '42', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '43', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '44', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '45', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '46', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '47', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '48', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '49', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '50', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '51', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '8', '', '', '52', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
	--BNK
	 T_TIPO_DATA('GACT', '3', '', '', '1', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '2', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '3', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '4', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '5', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '6', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '7', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '8', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '9', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '10', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '11', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '12', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '13', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '14', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '15', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '16', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '17', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '18', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '19', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '20', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '21', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '22', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '23', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '24', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '25', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '26', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '27', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '28', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '29', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '30', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '31', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '32', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '33', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '34', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '35', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '36', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '37', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '38', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '39', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '40', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '41', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '42', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '43', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '44', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '45', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '46', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '47', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '48', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '49', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '50', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '51', '', '', 'grupgact', 'Grupo Gestion de activos', ''),
         T_TIPO_DATA('GACT', '3', '', '', '52', '', '', 'grupgact', 'Grupo Gestion de activos', '')
         
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
					--' AND COD_MUNICIPIO '||V_COND2||' '||
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
					--' AND COD_MUNICIPIO '||V_COND2||' '||
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
