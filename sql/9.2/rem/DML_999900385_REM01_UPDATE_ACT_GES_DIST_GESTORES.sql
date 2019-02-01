--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20190201
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3256
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica en ACT_GES_DIST_GESTORES los datos añadidos en T_ARRAY_DATA
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


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		     -- TIPO_GESTOR-COD_CRA-EAC-TCR-COD_PROVINCIA-MUN-CP-USERNAME


		T_TIPO_DATA('GIAADMT', '3', '', '', '4', '', '', 'maretra03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '11', '', '', 'maretra03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '14', '', '', 'maretra03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '18', '', '', 'maretra03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '21', '', '', 'maretra03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '23', '', '', 'maretra03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '29', '', '', 'maretra03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '41', '', '', 'maretra03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '22', '', '', 'montalvo03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '44', '', '', 'montalvo03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '50', '', '', 'montalvo03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '33', '', '', 'montalvo03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '7', '', '', 'maretra03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '35', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '38', '', '', 'montalvo03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '39', '', '', 'montalvo03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '2', '', '', 'montalvo03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '13', '', '', 'montalvo03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '16', '', '', 'montalvo03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '19', '', '', 'montalvo03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '45', '', '', 'montalvo03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '5', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '9', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '24', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '34', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '37', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '40', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '42', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '47', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '49', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '8', '', '', 'grupobc03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '17', '', '', 'grupobc03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '25', '', '', 'grupobc03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '43', '', '', 'grupobc03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '51', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '3', '', '', 'garsa03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '12', '', '', 'garsa03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '46', '', '', 'garsa03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '6', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '10', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '15', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '27', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '32', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '36', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '28', '', '', 'montalvo03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '30', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '31', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '1', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '48', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '20', '', '', 'qipert03'),

		T_TIPO_DATA('GIAADMT', '3', '', '', '26', '', '', 'montalvo03'),


		T_TIPO_DATA('GGADM', '3', '', '', '4', '', '', 'maretra01'),

		T_TIPO_DATA('GGADM', '3', '', '', '11', '', '', 'maretra01'),

		T_TIPO_DATA('GGADM', '3', '', '', '14', '', '', 'maretra01'),

		T_TIPO_DATA('GGADM', '3', '', '', '18', '', '', 'maretra01'),

		T_TIPO_DATA('GGADM', '3', '', '', '21', '', '', 'maretra01'),

		T_TIPO_DATA('GGADM', '3', '', '', '23', '', '', 'maretra01'),

		T_TIPO_DATA('GGADM', '3', '', '', '29', '', '', 'maretra01'),

		T_TIPO_DATA('GGADM', '3', '', '', '41', '', '', 'maretra01'),

		T_TIPO_DATA('GGADM', '3', '', '', '22', '', '', 'montalvo01'),

		T_TIPO_DATA('GGADM', '3', '', '', '44', '', '', 'montalvo01'),

		T_TIPO_DATA('GGADM', '3', '', '', '50', '', '', 'montalvo01'),

		T_TIPO_DATA('GGADM', '3', '', '', '33', '', '', 'montalvo01'),

		T_TIPO_DATA('GGADM', '3', '', '', '7', '', '', 'maretra01'),

		T_TIPO_DATA('GGADM', '3', '', '', '35', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '38', '', '', 'montalvo01'),

		T_TIPO_DATA('GGADM', '3', '', '', '39', '', '', 'montalvo01'),

		T_TIPO_DATA('GGADM', '3', '', '', '2', '', '', 'montalvo01'),

		T_TIPO_DATA('GGADM', '3', '', '', '13', '', '', 'montalvo01'),

		T_TIPO_DATA('GGADM', '3', '', '', '16', '', '', 'montalvo01'),

		T_TIPO_DATA('GGADM', '3', '', '', '19', '', '', 'montalvo01'),

		T_TIPO_DATA('GGADM', '3', '', '', '45', '', '', 'montalvo01'),

		T_TIPO_DATA('GGADM', '3', '', '', '5', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '9', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '24', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '34', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '37', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '40', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '42', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '47', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '49', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '8', '', '', 'grupobc01'),

		T_TIPO_DATA('GGADM', '3', '', '', '17', '', '', 'grupobc01'),

		T_TIPO_DATA('GGADM', '3', '', '', '25', '', '', 'grupobc01'),

		T_TIPO_DATA('GGADM', '3', '', '', '43', '', '', 'grupobc01'),

		T_TIPO_DATA('GGADM', '3', '', '', '51', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '3', '', '', 'garsa01'),

		T_TIPO_DATA('GGADM', '3', '', '', '12', '', '', 'garsa01'),

		T_TIPO_DATA('GGADM', '3', '', '', '46', '', '', 'garsa01'),

		T_TIPO_DATA('GGADM', '3', '', '', '6', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '10', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '15', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '27', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '32', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '36', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '28', '', '', 'montalvo01'),

		T_TIPO_DATA('GGADM', '3', '', '', '30', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '31', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '1', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '48', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '20', '', '', 'qipert01'),

		T_TIPO_DATA('GGADM', '3', '', '', '26', '', '', 'montalvo01')


	
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA ||' WHERE COD_CARTERA = 3 AND TIPO_GESTOR IN (''GGADM'')'; 
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: TABLA TRUNCADA');

	 
    -- LOOP para insertar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
        			' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||	
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION  IS NULL '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO  IS NULL '||
					' AND COD_POSTAL IS NULL ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe, lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    ' SET NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
					' , USUARIOMODIFICAR = ''HREOS-5316'' , FECHAMODIFICAR = SYSDATE '||
					' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION  IS NULL '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO  IS NULL '||
					' AND COD_POSTAL IS NULL ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
          
       --Si no existe, lo insertamos   
       ELSE
  
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', '||V_TMP_TIPO_DATA(2)||','''||V_TMP_TIPO_DATA(3)||''','''||V_TMP_TIPO_DATA(4)||''','||V_TMP_TIPO_DATA(5)||' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
						', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
						', 0, ''HREOS-5316'',SYSDATE,0 FROM DUAL';
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
