--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201028
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8279
--## PRODUCTO=NO
--## 
--## Finalidad: Subcarterizar usuarios
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_ACTIVO NUMBER(16); -- Vble. sin prefijo.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA_CARTERA VARCHAR2(100 CHAR):= 'UCA_USUARIO_CARTERA';
    V_TABLA_USUARIOS VARCHAR2(100 CHAR):= 'USU_USUARIOS';
    V_TABLA_DD_CARTERA VARCHAR2(100 CHAR):= 'DD_CRA_CARTERA';
    V_TABLA_DD_SUBCARTERA VARCHAR2(100 CHAR):= 'DD_SCR_SUBCARTERA';
    V_ID_USER VARCHAR2(100 CHAR); --Vble. para almacenar usuario del bucle
    V_ID_CARTERA NUMBER(16);
    V_ID_SUBCARTERA1 NUMBER(16);
    V_ID_SUBCARTERA2 NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('ext.agarcia'),
        T_TIPO_DATA('ext.balonso'),
        T_TIPO_DATA('ext.csanchezv'),
        T_TIPO_DATA('ext.ibunzl'),
        T_TIPO_DATA('ext.ivilar'),
        T_TIPO_DATA('ext.jdavis'),
        T_TIPO_DATA('ext.lblanco'),
        T_TIPO_DATA('ext.mdiazbraun'),
        T_TIPO_DATA('ext.pbordas'),
        T_TIPO_DATA('ext.pdominguez'),
        T_TIPO_DATA('ext.pmotta'),
        T_TIPO_DATA('ext.prodriguezg'),
        T_TIPO_DATA('ext.sarana')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');	

    -- LOOP para insertar los usuarios en la tabla de UCA_USUARIO_CARTERA con ambas subcarteras de Divarian --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR USUARIOS EN '||V_TABLA_CARTERA);

    -- Obtener ID de la cartera Cerberus
    V_MSQL := 'SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_DD_CARTERA||' WHERE DD_CRA_CODIGO = ''07''';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID_CARTERA;

    -- Obtener ID de la subcartera Divarian Industrial
    V_MSQL := 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_DD_SUBCARTERA||' WHERE DD_SCR_CODIGO = ''151''';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID_SUBCARTERA1;

    -- Obtener ID de la subcartera Divarian Remaining
    V_MSQL := 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_DD_SUBCARTERA||' WHERE DD_SCR_CODIGO = ''152''';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID_SUBCARTERA2;

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        -- Obtener ID de usuario por si la comprobación falla
        V_MSQL := 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.'||V_TABLA_USUARIOS||' WHERE USU_USERNAME = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID_USER;

        --Comprobar si el usuario ya existe en la tabla UCA_USUARIO_CARTERA.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_CARTERA||' WHERE USU_ID = '''||V_ID_USER||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        -- Si no existe el usuario en la tabla USU_USUARIO_CARTERA se inserta con ambas subcarteras de Divarian.
        IF V_NUM_TABLAS = 0 THEN

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_CARTERA||' (
                UCA_ID,
                USU_ID,
                DD_CRA_ID,
                DD_SCR_ID
             )
             VALUES
             (
                '||V_ESQUEMA||'.S_'||V_TABLA_CARTERA||'.NEXTVAL, 
                '||V_ID_USER||',
                '||V_ID_CARTERA||',
                '||V_ID_SUBCARTERA1||'
             )';
	
	        EXECUTE IMMEDIATE V_MSQL;

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_CARTERA||' (
                UCA_ID,
                USU_ID,
                DD_CRA_ID,
                DD_SCR_ID
             )
             VALUES
             (
                '||V_ESQUEMA||'.S_'||V_TABLA_CARTERA||'.NEXTVAL, 
                '||V_ID_USER||',
                '||V_ID_CARTERA||',
                '||V_ID_SUBCARTERA2||'
             )';
	
	        EXECUTE IMMEDIATE V_MSQL;
        
        ELSE
            -- Si ya existe el código sin el prefijo se muestra por consola
			DBMS_OUTPUT.PUT_LINE('[INFO]: El usuario con USERNAME: '''||V_TMP_TIPO_DATA(1)||''' ya existe en la tabla: '||V_TABLA_CARTERA||'. Se procede a actualizar la subcartera existente y añadir la segunda');

            V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA_CARTERA||' SET 
            DD_CRA_ID = '''||V_ID_CARTERA||''',
            DD_SCR_ID = '''||V_ID_SUBCARTERA1||'''
            WHERE USU_ID = '||V_ID_USER||'';
	
	        EXECUTE IMMEDIATE V_MSQL;

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_CARTERA||' (
                UCA_ID,
                USU_ID,
                DD_CRA_ID,
                DD_SCR_ID
             )
             VALUES
             (
                '||V_ESQUEMA||'.S_'||V_TABLA_CARTERA||'.NEXTVAL, 
                '||V_ID_USER||',
                '||V_ID_CARTERA||',
                '||V_ID_SUBCARTERA2||'
             )';
	
	        EXECUTE IMMEDIATE V_MSQL;

		END IF;

      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: INSERTADOS CORRECTAMENTE LOS USUARIOS EN LA TABLA '||V_TABLA_CARTERA||' CON LAS DOS SUBCARTERAS DIVARIAN');
 
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