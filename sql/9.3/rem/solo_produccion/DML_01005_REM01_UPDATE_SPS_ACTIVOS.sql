--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210813
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10329
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-10329'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_ACTIVO'; --Vble. auxiliar para almacenar la tabla a insertar
    V_ID NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('6852987'),
        T_TIPO_DATA('6854085'),
        T_TIPO_DATA('6857243'),
        T_TIPO_DATA('6862080'),
        T_TIPO_DATA('6866838'),
        T_TIPO_DATA('6866840'),
        T_TIPO_DATA('6867323'),
        T_TIPO_DATA('6867325'),
        T_TIPO_DATA('6867597'),
        T_TIPO_DATA('6867599'),
        T_TIPO_DATA('6867600'),
        T_TIPO_DATA('6867601'),
        T_TIPO_DATA('6867669'),
        T_TIPO_DATA('6867670'),
        T_TIPO_DATA('6867671'),
        T_TIPO_DATA('6867674'),
        T_TIPO_DATA('6867675'),
        T_TIPO_DATA('6868011'),
        T_TIPO_DATA('6868012'),
        T_TIPO_DATA('6868361'),
        T_TIPO_DATA('6868362'),
        T_TIPO_DATA('6868363'),
        T_TIPO_DATA('6868364'),
        T_TIPO_DATA('6868636'),
        T_TIPO_DATA('6869010'),
        T_TIPO_DATA('6869011'),
        T_TIPO_DATA('6869012'),
        T_TIPO_DATA('6869013'),
        T_TIPO_DATA('6872767'),
        T_TIPO_DATA('6873449'),
        T_TIPO_DATA('6874150'),
        T_TIPO_DATA('6874285'),
        T_TIPO_DATA('6874739'),
        T_TIPO_DATA('6874994'),
        T_TIPO_DATA('6875158'),
        T_TIPO_DATA('6875447'),
        T_TIPO_DATA('6875450'),
        T_TIPO_DATA('6875605'),
        T_TIPO_DATA('6876625'),
        T_TIPO_DATA('6877095'),
        T_TIPO_DATA('6878611'),
        T_TIPO_DATA('6879910'),
        T_TIPO_DATA('6880652'),
        T_TIPO_DATA('6881075'),
        T_TIPO_DATA('6881710'),
        T_TIPO_DATA('6881769'),
        T_TIPO_DATA('6881806'),
        T_TIPO_DATA('6882091'),
        T_TIPO_DATA('6882729'),
        T_TIPO_DATA('6883013'),
        T_TIPO_DATA('6883981'),
        T_TIPO_DATA('6884143'),
        T_TIPO_DATA('6884252'),
        T_TIPO_DATA('6884358'),
        T_TIPO_DATA('6965659'),
        T_TIPO_DATA('7072704'),
        T_TIPO_DATA('7293296'),
        T_TIPO_DATA('7466247'),
        T_TIPO_DATA('7466248'),
        T_TIPO_DATA('7466253'),
        T_TIPO_DATA('7466257'),
        T_TIPO_DATA('7466260'),
        T_TIPO_DATA('7466263'),
        T_TIPO_DATA('7466264'),
        T_TIPO_DATA('7466265'),
        T_TIPO_DATA('7466267')


    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR OCUPADO, CON TITULO EN  ACT_SPS_SIT_POSESORIA');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        --Comprobar si ya existe en la tabla sin el prefijo 999.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' ACT
                    JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID=ACT.ACT_ID        
                    WHERE ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' AND ACT.BORRADO = 0 AND SPS.BORRADO = 0 ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        -- Si no existe sin el prefijo 999 se actualiza.
        IF V_NUM_TABLAS = 1 THEN

            --Comprobar si ya existe en la tabla sin el prefijo 999.
        V_MSQL := 'SELECT SPS.SPS_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' ACT
                    JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID=ACT.ACT_ID        
                    WHERE ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' AND ACT.BORRADO = 0 AND SPS.BORRADO = 0 ';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;
       	
           V_MSQL :='UPDATE '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SET 
                SPS_OCUPADO = 1,
                DD_TPA_ID = (SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_TITULO_ACT WHERE BORRADO = 0 AND DD_TPA_CODIGO=''02''),
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE 
                WHERE SPS_ID = '||V_ID||' ';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado A OCUPADO = 1 y CON TITULO = NO del activo con codigo '''||TRIM(V_TMP_TIPO_DATA(1))||''' ');

		ELSE
            -- Si ya existe el código sin el prefijo se muestra por consola
			DBMS_OUTPUT.PUT_LINE('[INFO]: El activo '''||V_TMP_TIPO_DATA(1)||''' NO tiene registro en la ACT_SPS_SIT_POSESORIA');

		END IF;

      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_APU_ACTIVO_PUBLICACION ACTUALIZADA CORRECTAMENTE ');
    
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