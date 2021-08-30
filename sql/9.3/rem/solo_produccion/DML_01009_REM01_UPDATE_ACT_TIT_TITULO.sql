--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210819
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10261
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar ACT_NUM_ACTIVO
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_ACTIVO NUMBER(16); -- Vble. sin prefijo.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-10261'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_ACTIVO'; --Vble. auxiliar para almacenar la tabla a insertar
    V_ID NUMBER(16);
    V_ID_2 NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        -- ACT_NUM_ACTIVO   DD_ETI_CODIGO
        T_TIPO_DATA('6986496','06'),
        T_TIPO_DATA('6995742','04'),
        T_TIPO_DATA('7000539','04'),
        T_TIPO_DATA('6991621','06'),
        T_TIPO_DATA('6983765','06'),
        T_TIPO_DATA('7000993','04'),
        T_TIPO_DATA('6981536','06'),
        T_TIPO_DATA('5928982','04'),
        T_TIPO_DATA('6986081','04'),
        T_TIPO_DATA('7000660','04'),
        T_TIPO_DATA('7001015','04'),
        T_TIPO_DATA('7000450','06'),
        T_TIPO_DATA('6986239','06')


    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ESTADO INSCRIPCION EN '||V_TABLA);

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        --Comprobar si ya existe en la tabla sin el prefijo 999.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' ACT
                    JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO TIT ON TIT.ACT_ID=ACT.ACT_ID
                    JOIN '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO AHT ON AHT.TIT_ID=TIT.TIT_ID AND AHT.BORRADO = 0        
                    WHERE ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' AND ACT.BORRADO = 0 AND TIT.BORRADO = 0 ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        -- Si no existe sin el prefijo 999 se actualiza.
        IF V_NUM_TABLAS = 1 THEN

            --Comprobar si ya existe en la tabla sin el prefijo 999.
         V_MSQL := 'SELECT TIT.TIT_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' ACT
                    JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO TIT ON TIT.ACT_ID=ACT.ACT_ID
                    JOIN '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO AHT ON AHT.TIT_ID=TIT.TIT_ID AND AHT.BORRADO = 0        
                    WHERE ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' AND ACT.BORRADO = 0 AND TIT.BORRADO = 0 ';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;

                 V_MSQL := 'SELECT AHT.AHT_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' ACT
                    JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO TIT ON TIT.ACT_ID=ACT.ACT_ID
                    JOIN '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO AHT ON AHT.TIT_ID=TIT.TIT_ID AND AHT.BORRADO = 0        
                    WHERE ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' AND ACT.BORRADO = 0 AND TIT.BORRADO = 0 ';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID_2;
       	
           V_MSQL :='UPDATE '||V_ESQUEMA||'.ACT_TIT_TITULO SET 
                TIT_FECHA_INSC_REG = NULL,
                DD_ETI_ID = (SELECT DD_ETI_ID FROM '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO WHERE BORRADO = 0 AND DD_ETI_CODIGO='''||V_TMP_TIPO_DATA(2)||'''),
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE 
                WHERE TIT_ID = '||V_ID||' ';

          	EXECUTE IMMEDIATE V_MSQL;

            V_MSQL :='UPDATE '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO SET 
                BORRADO = 1,
                USUARIOBORRAR = '''||V_USUARIO||''', 
                FECHABORRAR = SYSDATE 
                WHERE AHT_ID = '||V_ID_2||' ';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado titulo del activo con codigo '''||TRIM(V_TMP_TIPO_DATA(1))||''' ');

		ELSE
            -- Si ya existe el código sin el prefijo se muestra por consola
			DBMS_OUTPUT.PUT_LINE('[INFO]: El activo '''||V_TMP_TIPO_DATA(1)||''' NO tiene registro en la ACT_TIT_TITULO o en el historico o esta borrado');

		END IF;

      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_TIT_TITULO ACTUALIZADA CORRECTAMENTE ');
    
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