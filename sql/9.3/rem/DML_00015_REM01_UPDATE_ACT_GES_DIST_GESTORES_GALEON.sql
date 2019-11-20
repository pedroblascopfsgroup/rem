--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190927
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5325
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
    			-- TGE		 CRA	SCRA	PRV	USERNAME   TIPO_COMERCIALIZACION
    			-- TGE		 CRA	EAC	  TCR	PRV	 LOC  POSTAL	USERNAME
			-- 1			2	3		4	5		6	7		8
	--GPM
		--pgarciafraile

		T_TIPO_DATA('GCOM', '15', '', '', 'enavarro', '1'),
		T_TIPO_DATA('GCOM', '15', '', '', 'ndelgado', '2'),
		T_TIPO_DATA('HAYAGBOINM', '15', '', '', 'prodriguezg', ''),
		T_TIPO_DATA('GADM', '15', '', '', 'usugruadm', ''),
		T_TIPO_DATA('GACT', '15', '', '', 'rguirado', ''),
		T_TIPO_DATA('GPUBL', '15', '', '', 'aruedag', ''),
		T_TIPO_DATA('GIAADMT', '15', '', '', 'ogf02', ''),
		T_TIPO_DATA('GGADM', '15', '', '', 'garsa01', ''),
		T_TIPO_DATA('GIAFORM', '15', '', '', 'ogf03', ''),
		T_TIPO_DATA('SCOM', '15', '', '', 'pfernandezg', ''),
		T_TIPO_DATA('HAYASBOINM', '15', '', '', 'ejust', ''),
		T_TIPO_DATA('SUPADM', '15', '', '', 'usugruadm', ''),
		T_TIPO_DATA('SUPACT', '15', '', '', 'odelatorre', ''),
		T_TIPO_DATA('SPUBL', '15', '', '', 'saragon', ''),
		T_TIPO_DATA('SFORM', '15', '', '', 'falves', '')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA ||' WHERE COD_CARTERA = 15'; 
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
					' AND COD_SUBCARTERA = '''||TRIM(V_TMP_TIPO_DATA(3))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION = '''||TRIM(V_TMP_TIPO_DATA(6))||''' '|| 
					' AND (COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(4))||''') '||
					' AND COD_MUNICIPIO  IS NULL '||
					' AND COD_POSTAL IS NULL ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
		  DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    ' SET USERNAME = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' , NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(5))||''') '||
					' , USUARIOMODIFICAR = ''REMVIP-5325'' , FECHAMODIFICAR = SYSDATE '||
					' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_SUBCARTERA = '''||TRIM(V_TMP_TIPO_DATA(3))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND (COD_TIPO_COMERZIALZACION  IS NULL OR COD_TIPO_COMERZIALZACION = '''||TRIM(V_TMP_TIPO_DATA(6))||''') '||
					' AND (COD_PROVINCIA IS NULL OR COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(4))||''') '||
					' AND COD_MUNICIPIO  IS NULL '||
					' AND COD_POSTAL IS NULL ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''');
          
       --Si no existe, lo insertamos   
       ELSE
  		  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''');
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''' ' ||
						','''||V_TMP_TIPO_DATA(6)||''', '''||V_TMP_TIPO_DATA(4)||''','''||V_TMP_TIPO_DATA(5)||''' ' ||
						', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(5))||''') '||
						', 0, ''REMVIP-5325'',SYSDATE,0,'''||TRIM(V_TMP_TIPO_DATA(3))||''' FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''');
        
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
