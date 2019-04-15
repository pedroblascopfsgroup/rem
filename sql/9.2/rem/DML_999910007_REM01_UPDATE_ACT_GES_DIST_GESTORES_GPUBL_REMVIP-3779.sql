--/*
--##########################################
--## AUTOR=VICTOR OLIVARES
--## FECHA_CREACION=20190408
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3779
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
    V_USUARIO VARCHAR2(2400 CHAR) := 'REMVIP-3779'; -- Vble. auxiliar para almacenar usuario.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    			-- TIPO_GESTOR	CRA	  PRV LOC POSTAL	USERNAME     NOMBRE_USUARIO

		T_TIPO_DATA('GPUBL', 	'3',  '11', '', '', 	'aruedag', 'Anselmo Rueda García'),
		T_TIPO_DATA('GPUBL', 	'3',  '12', '', '', 	'aruedag', 'Anselmo Rueda García'),
		T_TIPO_DATA('GPUBL', 	'3',  '14', '', '', 	'aruedag', 'Anselmo Rueda García'),
		T_TIPO_DATA('GPUBL', 	'3',  '18', '', '', 	'aruedag', 'Anselmo Rueda García'),
		T_TIPO_DATA('GPUBL', 	'3',  '21', '', '', 	'aruedag', 'Anselmo Rueda García'),
		T_TIPO_DATA('GPUBL', 	'3',  '23', '', '', 	'aruedag', 'Anselmo Rueda García'),
		T_TIPO_DATA('GPUBL', 	'3',  '29', '', '', 	'aruedag', 'Anselmo Rueda García'),
		T_TIPO_DATA('GPUBL', 	'3',  '3', 	'', '', 	'aruedag', 'Anselmo Rueda García'),
		T_TIPO_DATA('GPUBL', 	'3',  '30', '', '', 	'aruedag', 'Anselmo Rueda García'),
		T_TIPO_DATA('GPUBL', 	'3',  '4', 	'', '', 	'aruedag', 'Anselmo Rueda García'),
		T_TIPO_DATA('GPUBL', 	'3',  '41', '', '', 	'aruedag', 'Anselmo Rueda García'),
		T_TIPO_DATA('GPUBL', 	'3',  '46', '', '', 	'aruedag', 'Anselmo Rueda García'),
		T_TIPO_DATA('GPUBL', 	'3',  '7', 	'', '', 	'aruedag', 'Anselmo Rueda García'),
		T_TIPO_DATA('GPUBL', 	'3',  '15', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '1', 	'', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '33', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '5', 	'', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '6', 	'', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '8', 	'', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '9', 	'', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '10', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '39', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '13', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '16', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '17', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '19', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '20', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '22', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '26', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '35', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '24', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '25', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '27', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '28', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '31', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '32', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '34', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '36', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '37', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '40', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '42', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '38', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '43', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '44', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '45', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '47', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '48', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '49', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '50', '', '', 	'lmartinc', 'Leticia Martín Contreras'),
		T_TIPO_DATA('GPUBL', 	'3',  '2', 	'', '', 	'lmartinc', 'Leticia Martín Contreras')
		--CEUTA		T_TIPO_DATA('GPUBL', 	'3',  '51', 	'', '', 	'lmartinc', 'Leticia Martín Contreras')
		--MELILLA	T_TIPO_DATA('GPUBL', 	'3',  '52', 	'', '', 	'lmartinc', 'Leticia Martín Contreras')
		
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- LOOP para insertar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
        			' WHERE TIPO_GESTOR = '''||V_TMP_TIPO_DATA(1)||''' '||	
					' AND COD_CARTERA = '''||V_TMP_TIPO_DATA(2)||''' '||
					' AND COD_PROVINCIA = '''||V_TMP_TIPO_DATA(3)||''' '||
					' AND COD_MUNICIPIO = 0'||
					' AND COD_POSTAL IS NULL '||
					' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    ' SET NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(6))||''') '||
                    ' , USERNAME = '''||V_TMP_TIPO_DATA(6)||''' '||
					' , USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE '||
					' WHERE TIPO_GESTOR = '''||V_TMP_TIPO_DATA(1)||''' '||	
					' AND COD_CARTERA = '''||V_TMP_TIPO_DATA(2)||''' '||
					' AND COD_PROVINCIA = '''||V_TMP_TIPO_DATA(3)||''' '||
					' AND COD_MUNICIPIO = 0'||
					' AND COD_POSTAL IS NULL '||
					' AND BORRADO = 0';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(3)) ||'''');
          
       --Si no existe, lo insertamos   
       ELSE
  
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
 			  ID
			, TIPO_GESTOR
			, COD_CARTERA
			, COD_PROVINCIA
			, USERNAME
			, NOMBRE_USUARIO
			, USUARIOCREAR
			, FECHACREAR
			, VERSION
			, BORRADO
			, COD_MUNICIPIO
 			) VALUES (
 			  S_'||V_TEXT_TABLA||'.NEXTVAL
 			, '''||TRIM(V_TMP_TIPO_DATA(1))||'''
 			, '''||TRIM(V_TMP_TIPO_DATA(2))||'''
 			, '''||TRIM(V_TMP_TIPO_DATA(3))||'''
 			, '''||TRIM(V_TMP_TIPO_DATA(6))||'''
 			, (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(6))||''')
 			, '''||V_USUARIO||'''
 			, SYSDATE
 			, 1
 			, 0
 			, 0
 			)
		  ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
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
