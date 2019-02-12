--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20190130
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3137
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

		T_TIPO_DATA('GCOM', '3', '', '', '1', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '2', '', '', 'rnavarro'),
		T_TIPO_DATA('GCOM', '3', '', '', '3', '', '', 'enavarro'),
		T_TIPO_DATA('GCOM', '3', '', '', '4', '', '', 'pnevot'),
		T_TIPO_DATA('GCOM', '3', '', '', '5', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '6', '', '', 'rnavarro'),
		T_TIPO_DATA('GCOM', '3', '', '', '7', '', '', 'shernandez'),
		T_TIPO_DATA('GCOM', '3', '', '', '8', '', '', 'jcasolive'),
		T_TIPO_DATA('GCOM', '3', '', '', '9', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '10', '', '', 'rnavarro'),
		T_TIPO_DATA('GCOM', '3', '', '', '11', '', '', 'pnevot'),
		T_TIPO_DATA('GCOM', '3', '', '', '12', '', '', 'enavarro'),
		T_TIPO_DATA('GCOM', '3', '', '', '13', '', '', 'rnavarro'),
		T_TIPO_DATA('GCOM', '3', '', '', '14', '', '', 'rnavarro'),
		T_TIPO_DATA('GCOM', '3', '', '', '15', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '16', '', '', 'rnavarro'),
		T_TIPO_DATA('GCOM', '3', '', '', '17', '', '', 'jcasolive'),
		T_TIPO_DATA('GCOM', '3', '', '', '18', '', '', 'pnevot'),
		T_TIPO_DATA('GCOM', '3', '', '', '19', '', '', 'rnavarro'),
		T_TIPO_DATA('GCOM', '3', '', '', '20', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '21', '', '', 'pnevot'),
		T_TIPO_DATA('GCOM', '3', '', '', '22', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '23', '', '', 'rnavarro'),
		T_TIPO_DATA('GCOM', '3', '', '', '24', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '25', '', '', 'jcasolive'),
		T_TIPO_DATA('GCOM', '3', '', '', '26', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '27', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '28', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '29', '', '', 'pnevot'),
		T_TIPO_DATA('GCOM', '3', '', '', '30', '', '', 'rnavarro'),
		T_TIPO_DATA('GCOM', '3', '', '', '31', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '32', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '33', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '34', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '35', '', '', 'pnevot'),
		T_TIPO_DATA('GCOM', '3', '', '', '36', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '37', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '38', '', '', 'pnevot'),
		T_TIPO_DATA('GCOM', '3', '', '', '39', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '40', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '41', '', '', 'rnavarro'),
		T_TIPO_DATA('GCOM', '3', '', '', '42', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '43', '', '', 'jcasolive'),
		T_TIPO_DATA('GCOM', '3', '', '', '44', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '45', '', '', 'rnavarro'),
		T_TIPO_DATA('GCOM', '3', '', '', '46', '', '', 'enavarro'),
		T_TIPO_DATA('GCOM', '3', '', '', '47', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '48', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '49', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '50', '', '', 'dmercado'),
		T_TIPO_DATA('GCOM', '3', '', '', '51', '', '', 'pnevot')

		
		
		
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
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
					' AND COD_TIPO_COMERZIALZACION  = 1 '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO  IS NULL '||
					' AND COD_POSTAL IS NULL ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    ' SET NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
					' , USUARIOMODIFICAR = ''REMVIP-3137'' , FECHAMODIFICAR = SYSDATE '||
					' , USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
					' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION  = 1 '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO  IS NULL '||
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
