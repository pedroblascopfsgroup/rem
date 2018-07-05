--/*
--##########################################
--## AUTOR=ISIDRO SOTOCA
--## FECHA_CREACION=20180705
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4208
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
    			-- TIPO_GESTOR		CODIGO_CARTERA		USERNAME	  	NOMBRE_USUARIO
    	-- Gestor de Alquileres
		--T_TIPO_DATA('GALQ',		'01',				'gestalq',		'Gestor de Alquileres'),
		-- Supervisor de Alquileres
	    --T_TIPO_DATA('SUALQ',		'01',				'supalq',		'Supervisor de Alquileres'),
	    
    	-- Gestor de Edificaciones
	    T_TIPO_DATA('GEDI',			'01',				'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'02',				'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'03',				'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'04',				'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'05',				'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'06',				'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'07',				'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'08',				'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'09',				'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'10',				'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'11',				'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'12',				'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'13',				'gestedi',		'Gestor de Edificaciones'),
	    -- Supervisor de Edificaciones
	    T_TIPO_DATA('SUPEDI',		'01',				'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'02',				'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'03',				'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'04',				'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'05',				'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'06',				'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'07',				'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'08',				'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'09',				'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'10',				'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'11',				'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'12',				'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'13',				'supedi',		'Supervisor de Edificaciones'),
	    
	    -- Gestor de Suelos
	    T_TIPO_DATA('GSUE',			'01',				'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'02',				'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'03',				'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'04',				'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'05',				'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'06',				'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'07',				'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'08',				'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'09',				'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'10',				'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'11',				'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'12',				'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'13',				'gestsue',		'Gestor de Suelos'),
	    -- Supervisor de Suelos
	    T_TIPO_DATA('SUPSUE',		'01',				'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'02',				'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'03',				'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'04',				'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'05',				'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'06',				'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'07',				'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'08',				'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'09',				'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'10',				'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'11',				'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'12',				'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'13',				'supsue',		'Supervisor de Suelos')
    );

    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Insertar valores en '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.');
	
	-- Se borraran los registros de este gestor si tienen asignado un COD_ESTADO_ACTIVO
	V_MSQL := '
            DELETE FROM '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' 
            WHERE 
              TIPO_GESTOR IN (''GEDI'', ''SUPEDI'', ''GSUE'', ''SUPSUE'')
              AND COD_CARTERA IS NOT NULL 
              AND COD_ESTADO_ACTIVO IS NOT NULL';
	EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: Se han eliminado todos los registros con estos gestores que tenian asignado un COD_ESTADO_ACTIVO');
	 
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
              USERNAME = '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              NOMBRE_USUARIO =  '''||TRIM(V_TMP_TIPO_DATA(4))||''',
              USUARIOMODIFICAR = ''HREOS-4208'',
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
          DBMS_OUTPUT.PUT_LINE('[INFO]: '||TRIM(V_TMP_TIPO_DATA(1))||' actualizado correctamente');
          
       --Si no existe, lo insertamos   
       ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (
				ID, 
				TIPO_GESTOR, 
				COD_CARTERA,
				USERNAME, 
				NOMBRE_USUARIO, 
				VERSION, 
				USUARIOCREAR, 
				FECHACREAR, 
				BORRADO
			) 
            SELECT 
              	'|| V_ID ||',
              	'''||TRIM(V_TMP_TIPO_DATA(1))||''',
				'''||TRIM(V_TMP_TIPO_DATA(2))||''',
              	'''||TRIM(V_TMP_TIPO_DATA(3))||''',
          		'''||TRIM(V_TMP_TIPO_DATA(4))||''',
				0,
				''HREOS-4208'',
				SYSDATE,
				0
			FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: '||TRIM(V_TMP_TIPO_DATA(1))||' insertado correctamente');
        
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
