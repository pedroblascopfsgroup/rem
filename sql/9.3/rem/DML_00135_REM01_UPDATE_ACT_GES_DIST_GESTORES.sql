--/*
--##########################################
--## AUTOR=Mª José Ponce
--## FECHA_CREACION=20200310
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9692
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
    
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.    
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-9692';
    V_USERNAME VARCHAR2(50 CHAR) := 'tecnotra03'; -- vble. para el usuario a modificar
    V_PROVINCIA VARCHAR2(50 CHAR); --vble. para almacenar la descripción de la provincia
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	-- TIPO_GESTOR,	DD_CRA_CODIGO, USERNAME, DD_PRV_CODIGO
		T_TIPO_DATA('GIAFORM', '02', 'ogf03', '4'),
		T_TIPO_DATA('GIAFORM', '02', 'ogf03', '11'),
		T_TIPO_DATA('GIAFORM', '02', 'ogf03', '41'),
		T_TIPO_DATA('GIAFORM', '02', 'ogf03', '21'),
		T_TIPO_DATA('GIAFORM', '02', 'ogf03', '18'),
		T_TIPO_DATA('GIAFORM', '02', 'ogf03', '29'),
		T_TIPO_DATA('GIAFORM', '02', 'ogf03', '23'),
		T_TIPO_DATA('GIAFORM', '02', 'ogf03', '17'),
		T_TIPO_DATA('GIAFORM', '02', 'ogf03', '43'),
		T_TIPO_DATA('GIAFORM', '02', 'ogf03', '25'),
		T_TIPO_DATA('GIAFORM', '02', 'ogf03', '8'),
		T_TIPO_DATA('GIAFORM', '02', 'ogf03', '28')		

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
		 
    -- LOOP para actualizar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACIÓN EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a modificar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
        			    WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' 	
					        AND COD_CARTERA = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''')
                  AND COD_PROVINCIA = (SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO ='''||TRIM(V_TMP_TIPO_DATA(4))||''') 
					        AND USERNAME = '''||V_USERNAME||'''';					
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
                
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN		    
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'
                     SET USERNAME = '''||TRIM(V_TMP_TIPO_DATA(3))||''' 
					          , USUARIOMODIFICAR = '''||V_USUARIO||''' 
                    , FECHAMODIFICAR = SYSDATE 
					          WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' 
					          AND COD_CARTERA = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''') 
									  AND COD_PROVINCIA = (SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO ='''||TRIM(V_TMP_TIPO_DATA(4))||''')';					
          EXECUTE IMMEDIATE V_MSQL;          

          --Recogemos en una variable la descripción de la provincia
          V_SQL := 'SELECT DD_PRV_DESCRIPCION FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO ='''||TRIM(V_TMP_TIPO_DATA(4))||'''';
          EXECUTE IMMEDIATE V_SQL INTO V_PROVINCIA;

          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA LA PROVINCIA: '||V_PROVINCIA);      
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;
/

EXIT
