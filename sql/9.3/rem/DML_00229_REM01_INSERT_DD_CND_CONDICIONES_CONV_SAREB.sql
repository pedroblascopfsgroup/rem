--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200709
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10920
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	  V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_CND_CONDICIONES_CONV_SAREB'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('OFR_VUE', 'Si hay ofertas en vuelo', 'Si hay ofertas en vuelo', 'EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' AND ACTO.ACT_ID = ACT.ACT_ID)')
      , T_TIPO_DATA('MOD_REM', 'Primera modificado en REM, deja de actualizarse', 'Si se han modificado los datos en REM, deja de actualizarse este campo con la información del Data Tape y permanece la de REM', 'EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' AND ACTO.ACT_ID = ACT.ACT_ID)')
      , T_TIPO_DATA('CHK_SUB', 'Check de subrogado diferente de lo que se recibe', 'Si el check de subrogado es diferente en REM que lo que se recibe de SAREB', 'EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' AND ACTO.ACT_ID = ACT.ACT_ID)')
      , T_TIPO_DATA('ACT_SIEMPRE_PRISMA', 'Se actualizará siempre REM con la información procedente de PRISMA salvo algún caso', 'Se actualizará siempre REM con la información procedente de PRISMA salvo en el caso de que el valor de PRISMA venga vacío y  El dato existente en REM hubiese sido modificado previamente a que las gestorías de Fase 1 trabajasen con PRISMA (fecha corte 01/06/2020)', 'EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' AND ACTO.ACT_ID = ACT.ACT_ID)')
      , T_TIPO_DATA('ELI_VAL', 'Si se elimina el valor (vacía el campo)', 'Si se elimina el valor (vacía el campo)', 'EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' AND ACTO.ACT_ID = ACT.ACT_ID)')
      , T_TIPO_DATA('ADJ_NO', 'Si el valor es Adjudicación judicial y el valor recibido no', 'Si el valor de REM es Adjudicación judicial y el valor recibido no', 'EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' AND ACTO.ACT_ID = ACT.ACT_ID)')
      , T_TIPO_DATA('ADN_LC_ADJ', 'Si el valor es ADN y el valor recibido es LQ colateral o ADJ', 'Si el valor de REM es Adjudicación no judicial y el valor recibido de Sareb es Liquidación de colateral o adjudicación judicial', 'EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' AND ACTO.ACT_ID = ACT.ACT_ID)')
      , T_TIPO_DATA('NUE_CAR', 'Si aparecen cargas en un activo que no tenía cargas', 'Bloque datos cargas: Si aparecen cargas en un activo que no tenía cargas', 'EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' AND ACTO.ACT_ID = ACT.ACT_ID)')
      , T_TIPO_DATA('OFR_VUE_CAR', 'Si teniendo ofertas en vuelo, aparecen o desaparecen cargas', 'Bloque datos cargas: Si teniendo ofertas en vuelo, aparecen o desaparecen cargas', 'EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' AND ACTO.ACT_ID = ACT.ACT_ID)')
      , T_TIPO_DATA('CEE_OBT', 'Si el activo no tiene estado de la etiqueta de efi. energética y se recibe una S', 'Si el activo no tiene estado de la etiqueta de eficiencia energética y se recibe una S desde Sareb', 'EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' AND ACTO.ACT_ID = ACT.ACT_ID)')
      , T_TIPO_DATA('CEE_NOB', 'Si el activo tiene estado de la etiqueta de efi. energética y se recibe una N', 'Si el activo tiene estado de la etiqueta de eficiencia energética y se recibe una N desde Sareb', 'EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' AND ACTO.ACT_ID = ACT.ACT_ID)')
      , T_TIPO_DATA('ALQ_DIV', 'Si se recibe alquilado y no está alquilado o viceversa', 'Si se recibe alquilado y en REM no está alquilado o viceversa', 'EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' AND ACTO.ACT_ID = ACT.ACT_ID)')
      , T_TIPO_DATA('RES_DIV', 'Si se recibe reservado y el estado anterior a dicho estado, o viceversa', 'Si se recibe reservado y el estado en REM es anterior a dicho estado, o viceversa', 'EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' AND ACTO.ACT_ID = ACT.ACT_ID)')
      , T_TIPO_DATA('INT_MOD', 'Si se modifica el valor existente en REM', 'Si se modifica el valor existente en REM', 'EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''''01'''' AND ACTO.ACT_ID = ACT.ACT_ID)')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        --Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
					WHERE DD_CND_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
        ELSE
          -- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' no existe');

          DBMS_OUTPUT.PUT_LINE('[INFO]: '''||TRIM(V_TMP_TIPO_DATA(4))||'''');
            V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              DD_CND_ID,
              DD_CND_CODIGO,
              DD_CND_DESCRIPCION,
              DD_CND_DESCRIPCION_LARGA,
              QUERY,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
              '||V_ID||',
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              '''||TRIM(V_TMP_TIPO_DATA(4))||''',
              0,
              ''HREOS-10920'',
              SYSDATE,
              0
                        )';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''');

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
