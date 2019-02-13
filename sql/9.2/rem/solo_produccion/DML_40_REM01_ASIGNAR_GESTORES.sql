--/*
--##########################################
--## AUTOR=JAVIER PONS
--## FECHA_CREACION=20190201
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-REMVIP-3251
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


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    			-- TGE		 CRA	EAC	  TCR	PRV	 LOC  POSTAL	USERNAME

		T_TIPO_DATA('GPUBL', '1', '', '', '1', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '2', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '3', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '4', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '5', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '6', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '7', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '8', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '9', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '10', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '11', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '12', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '13', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '14', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '15', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '16', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '17', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '18', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '19', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '20', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '21', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '22', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '23', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '24', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '25', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '26', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '27', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '28', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '29', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '30', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '31', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '32', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '33', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '34', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '35', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '36', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '37', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '38', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '39', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '40', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '41', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '42', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '43', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '44', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '45', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '46', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '47', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '48', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '49', '', '', 'mgrau'),
		T_TIPO_DATA('GPUBL', '1', '', '', '50', '', '', 'mgrau'),
        T_TIPO_DATA('GPUBL', '8', '', '', '28', '', '', 'rdura'),
        T_TIPO_DATA('GPUBL', '8', '', '', '45', '', '', 'rdura')           	
		
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	 
    -- LOOP para insertar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
        			' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||	
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION  IS NULL '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_POSTAL IS NULL ';	

        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

		DBMS_OUTPUT.PUT_LINE('[INFO]: Entra en LOOP -- ''||V_NUM_TABLAS||''');
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    ' SET COD_MUNICIPIO = NULL '||
					' , NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
					' , USUARIOMODIFICAR = ''REMVIP-3251'' , FECHAMODIFICAR = SYSDATE '||
					' , USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
					' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION  IS NULL '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_POSTAL IS NULL ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
        
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
