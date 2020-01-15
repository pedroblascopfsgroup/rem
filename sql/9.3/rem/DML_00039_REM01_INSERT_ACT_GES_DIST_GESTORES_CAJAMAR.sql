--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200108
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5940
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
	V_NUM_REGISTROS NUMBER(16):= 0; -- Vble. para contabilizar los registros afectados.
    V_USU VARCHAR2(2400 CHAR) := 'REMVIP-5940';
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND2 VARCHAR2(400 CHAR) := 'IS NULL';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (		
    	-- TGE (1) | CRA(2) | EAC(3) | TCR(4) | PRV(5) | LOC(6) | POSTAL(7) | USERNAME(8)   	
		T_TIPO_DATA('GACT', '1', '', '', '1', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '2', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '3', '', '', 'rguirado'),
		T_TIPO_DATA('GACT', '1', '', '', '4', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '5', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '6', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '7', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '8', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '9', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '10', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '11', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '12', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '13', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '14', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '15', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '16', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '17', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '18', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '19', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '20', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '21', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '22', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '23', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '24', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '25', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '26', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '27', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '28', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '29', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '30', '', '', 'rguirado'),
		T_TIPO_DATA('GACT', '1', '', '', '32', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '34', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '35', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '36', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '37', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '38', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '39', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '40', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '41', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '42', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '43', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '44', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '45', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '46', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '47', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '48', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '49', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '50', '', '', 'jparrar'),
		T_TIPO_DATA('GACT', '1', '', '', '51', '', '', 'mperez'),
		T_TIPO_DATA('GACT', '1', '', '', '52', '', '', 'mperez')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

   --borramos registros creados por el REMVIP-5940 anteriormente

 	V_SQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE USUARIOCREAR = ''REMVIP-5940'' ';

        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.put_line('[INFO] Se han borrado '||SQL%ROWCOUNT||' registro en la tabla ');

	
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
					' AND COD_POSTAL IS NULL ';
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
					' AND COD_POSTAL IS NULL ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA  '''|| TRIM(V_TMP_TIPO_DATA(8)) ||''' COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
          
          
       --Si no existe, lo insertamos   
       ELSE
  
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', '||V_TMP_TIPO_DATA(2)||','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','||TRIM(V_TMP_TIPO_DATA(5))||' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
						', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
						', 0, '''||V_USU||''',SYSDATE, 0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA '''|| TRIM(V_TMP_TIPO_DATA(8)) ||''' COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
        
       END IF;
	   V_NUM_REGISTROS :=  V_NUM_REGISTROS + sql%rowcount;
      END LOOP;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS AFECTADOS: ' || V_NUM_REGISTROS);
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
