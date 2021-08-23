--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210812
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10299
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-10299'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_ACTIVO'; --Vble. auxiliar para almacenar la tabla a insertar
    V_ID NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('103214'),
        T_TIPO_DATA('101163'),
        T_TIPO_DATA('101555'),
        T_TIPO_DATA('102943'),
        T_TIPO_DATA('94309'),
        T_TIPO_DATA('94698'),
        T_TIPO_DATA('94821'),
        T_TIPO_DATA('103162'),
        T_TIPO_DATA('101106'),
        T_TIPO_DATA('101553'),
        T_TIPO_DATA('100922'),
        T_TIPO_DATA('100924'),
        T_TIPO_DATA('98626'),
        T_TIPO_DATA('98440'),
        T_TIPO_DATA('94822'),
        T_TIPO_DATA('100980'),
        T_TIPO_DATA('102942'),
        T_TIPO_DATA('98543'),
        T_TIPO_DATA('100983'),
        T_TIPO_DATA('98678'),
        T_TIPO_DATA('103217'),
        T_TIPO_DATA('100982'),
        T_TIPO_DATA('94307'),
        T_TIPO_DATA('100925'),
        T_TIPO_DATA('103163'),
        T_TIPO_DATA('101554'),
        T_TIPO_DATA('94823'),
        T_TIPO_DATA('98539'),
        T_TIPO_DATA('98625'),
        T_TIPO_DATA('94430'),
        T_TIPO_DATA('94427'),
        T_TIPO_DATA('100981'),
        T_TIPO_DATA('98679'),
        T_TIPO_DATA('94824'),
        T_TIPO_DATA('98544'),
        T_TIPO_DATA('98680'),
        T_TIPO_DATA('101492'),
        T_TIPO_DATA('94699'),
        T_TIPO_DATA('67638'),
        T_TIPO_DATA('82462'),
        T_TIPO_DATA('98441'),
        T_TIPO_DATA('98540'),
        T_TIPO_DATA('98677'),
        T_TIPO_DATA('94308'),
        T_TIPO_DATA('103216'),
        T_TIPO_DATA('94429'),
        T_TIPO_DATA('101161'),
        T_TIPO_DATA('100976'),
        T_TIPO_DATA('103161'),
        T_TIPO_DATA('94700'),
        T_TIPO_DATA('118050'),
        T_TIPO_DATA('94428')


    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ACT_NUM_ACTIVO EN '||V_TABLA);

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        --Comprobar si ya existe en la tabla sin el prefijo 999.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' ACT
                    JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID=ACT.ACT_ID        
                    WHERE ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' AND ACT.BORRADO = 0 AND APU.BORRADO = 0 ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        -- Si no existe sin el prefijo 999 se actualiza.
        IF V_NUM_TABLAS = 1 THEN

            --Comprobar si ya existe en la tabla sin el prefijo 999.
        V_MSQL := 'SELECT APU.APU_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' ACT
                    JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID=ACT.ACT_ID        
                    WHERE ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' AND ACT.BORRADO = 0 AND APU.BORRADO = 0 ';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;
       	
           V_MSQL :='UPDATE '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION SET 
                DD_EPV_ID = (SELECT DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA WHERE BORRADO = 0 AND DD_EPV_CODIGO=''01''),
                DD_EPA_ID = (SELECT DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER WHERE BORRADO = 0 AND DD_EPA_CODIGO=''01''),
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE 
                WHERE APU_ID = '||V_ID||' ';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado publicacion del activo con codigo '''||TRIM(V_TMP_TIPO_DATA(1))||''' ');

		ELSE
            -- Si ya existe el código sin el prefijo se muestra por consola
			DBMS_OUTPUT.PUT_LINE('[INFO]: El activo '''||V_TMP_TIPO_DATA(1)||''' NO tiene registro en la ACT_APU_ACTIVO_PUBLICACION');

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