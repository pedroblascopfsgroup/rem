--/*
--##########################################
--## AUTOR= Pau Serrano
--## FECHA_CREACION=20180529
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4102
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

    --TIPO_GESTOR COD_CARTERA COD_ESTADO_ACTIVO COD_TIPO_COMERZIALZACION COD_PROVINCIA COD_MUNICIPIO COD_POSTAL USERNAME NOMBRE_USUARIO VERSION USUARIOCREAR FECHACREAR

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    			    -- TGE		   CRA	  EAC	 TCR	PRV	   LOC  POSTAL USERNAME
-- Grupo Liberbank Residencial
		T_TIPO_DATA('GLIBRES'  ,'08'  ,''  ,''  ,''    ,''  ,''    ,'grulibres'),
-- Grupo Liberbank Inversión Inmobiliaria
    T_TIPO_DATA('GLIBINVINM'  ,'08'  ,''  ,''  ,''    ,''  ,''    ,'grulibinvinm'),
-- Grupo Liberbank Singular - Terciario
    T_TIPO_DATA('GLIBSINTER'  ,'08'  ,''  ,''  ,''    ,''  ,''    ,'grulibsinter'),
-- Grupo Comité de Inversiones Inmobiliarias
    T_TIPO_DATA('GCOIN'  ,'08'  ,''  ,''  ,''    ,''  ,''    ,'grucoinv'),
-- Grupo Comité Inmobiliario
    T_TIPO_DATA('GCOINM'  ,'08'  ,''  ,''  ,''    ,''  ,''    ,'grucoinm'),
-- Grupo Comité de Dirección
    T_TIPO_DATA('GCODI'  ,'08'  ,''  ,''  ,''    ,''  ,''    ,'grucodi')		
    );

    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Insertar valores en '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.');
	 
    -- LOOP para insertar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: Inicio de comprobaciones previas.');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := '
          SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
          WHERE 
            TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' 
            AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' 
            AND COD_ESTADO_ACTIVO IS NULL 
            AND COD_TIPO_COMERZIALZACION IS NULL 
            AND COD_PROVINCIA IS NULL
            AND COD_MUNICIPIO IS NULL 
            AND COD_POSTAL IS NULL 
        ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
       	  V_MSQL := '
            UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' 
            SET 
              USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''',
              NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||'''),
              USUARIOMODIFICAR = ''HREOS-4102'',
              FECHAMODIFICAR = SYSDATE 
            WHERE 
              TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' 
              AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' 
              AND COD_ESTADO_ACTIVO IS NULL 
              AND COD_TIPO_COMERZIALZACION IS NULL 
              AND COD_PROVINCIA IS NULL 
              AND COD_MUNICIPIO IS NULL 
              AND COD_POSTAL IS NULL ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: Registro MODIFICADO para la el COD_CARTERA: '||TRIM(V_TMP_TIPO_DATA(2)));
          
       --Si no existe, lo insertamos   
       ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' 
              (ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
            SELECT 
              '|| V_ID ||',
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '||V_TMP_TIPO_DATA(2)||',
              '''||V_TMP_TIPO_DATA(3)||''',
              '''||V_TMP_TIPO_DATA(4)||''',
              '''||V_TMP_TIPO_DATA(5)||''',
              '''||TRIM(V_TMP_TIPO_DATA(6))||''',
              '''||TRIM(V_TMP_TIPO_DATA(7))||''',
              '''||TRIM(V_TMP_TIPO_DATA(8))||''',
              (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||'''),
              0,
              ''HREOS-4102'',
              SYSDATE,
              0
            FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: Registro INSERTADO para la el COD_CARTERA: '||TRIM(V_TMP_TIPO_DATA(2)));
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TEXT_TABLA||' actualizado corresctamente.');

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
