--/*
--######################################### 
--## AUTOR=Daniel Gallego
--## FECHA_CREACION=20210602
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13618
--## PRODUCTO=NO
--##
--## Finalidad: Introduccir Datos a la tabla TSC_CONFIG_SOCIEDAD_CORREO
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_ENTORNO NUMBER(16); -- Vble. para validar el entorno en el que estamos. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TSC_CONFIG_SOCIEDAD_CORREO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TSP_ID NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	
        T_TIPO_DATA('A','0','ventainmuebles@bbva.com'),
        T_TIPO_DATA('B','0','ventainmuebles@bbva.com'),
        T_TIPO_DATA('C','0','contabilidad.recatalunya@bbva.com'),
        T_TIPO_DATA('B','1','recupera@edt-sg.com')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        -- Obtenemos DD_TSP_ID --
        V_MSQL := 'SELECT DD_TSP_ID FROM '||V_ESQUEMA||'.DD_TSP_TIPO_CORREO
					  WHERE DD_TSP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_TSP_ID;

        -- Comprobamos si existe registro
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TSP_ID = '||V_TSP_ID||'
					  AND TSC_TIPO_CORREO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        -- Comprobamos entorno
        V_MSQL := 'SELECT CASE
                  WHEN SYS_CONTEXT ( ''USERENV'', ''DB_NAME'' ) = ''orarem'' THEN 1
                  ELSE 0
                  END AS ES_PRO
              FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTORNO; 

        -- Entorno PRO y no existe
        IF V_ENTORNO = 1 AND V_NUM_TABLAS = 0 THEN

        DBMS_OUTPUT.PUT_LINE('[INFO]: ENTORNO PRO Y NO EXISTE: INSERTAMOS');
      
       	-- Si no existe se inserta.
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
					  TSC_ID,
                      DD_TSP_ID,
					  TSC_TIPO_CORREO,
					  TSC_CORREO,
					  VERSION,
					  USUARIOCREAR,
					  FECHACREAR,
					  BORRADO
					  ) VALUES (
					  '||V_ID||',
					  '||V_TSP_ID||',
					  '''||TRIM(V_TMP_TIPO_DATA(2))||''',
					  '''||TRIM(V_TMP_TIPO_DATA(3))||''',
					  0,
					  ''HREOS-13618'',
					  SYSDATE,
					  0
                      )';
        
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el config del correo '''||TRIM(V_TMP_TIPO_DATA(2))||'''');

        -- Entorno previo y si existe: modificamos correo dummy
        ELSIF V_ENTORNO = 0 AND V_NUM_TABLAS = 1 THEN

        DBMS_OUTPUT.PUT_LINE('[INFO]: ENTORNO PREVIO Y EXISTE: MODIFICAMOS CORREO');

            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TSP_ID = '||V_TSP_ID||'
					  AND TSC_TIPO_CORREO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND TSC_CORREO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

            IF V_COUNT = 1 THEN

                V_MSQL := 'SELECT TSC_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TSP_ID = '||V_TSP_ID||'
                        AND TSC_TIPO_CORREO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND TSC_CORREO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_ID;

                V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET TSC_CORREO = ''pruebashrem@gmail.com'',
                        USUARIOMODIFICAR = ''HREOS-13618'', FECHAMODIFICAR = SYSDATE 
                        WHERE TSC_ID = '||V_ID||'';
            
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado el correo del config del correo '''||TRIM(V_TMP_TIPO_DATA(2))||''' en entorno previo');

            END IF;

        -- Entorno previo y no existe: insertamos con correo dummy
        ELSIF V_ENTORNO = 0 AND V_NUM_TABLAS = 0 THEN

        DBMS_OUTPUT.PUT_LINE('[INFO]: ENTORNO PREVIO Y NO EXISTE: INSERTAMOS');

            V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                        TSC_ID,
                        DD_TSP_ID,
                        TSC_TIPO_CORREO,
                        TSC_CORREO,
                        VERSION,
                        USUARIOCREAR,
                        FECHACREAR,
                        BORRADO
                        ) VALUES (
                        '||V_ID||',
                        '||V_TSP_ID||',
                        '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                        ''pruebashrem@gmail.com'',
                        0,
                        ''HREOS-13618'',
                        SYSDATE,
                        0
                        )';
            
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el config del correo '''||TRIM(V_TMP_TIPO_DATA(2))||''' en entorno previo');

          END IF;
  
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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
EXIT;