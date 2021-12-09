--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211025
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10584
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
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_SGT_SUBTIPO_GPV_TBJ'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USR VARCHAR2(100 CHAR):='REMVIP-10584';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('03','ADA','15','79')
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
        V_SQL := 'SELECT COUNT(1) 
            FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR
            JOIN '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR ON TTR.DD_TTR_ID = STR.DD_TTR_ID
              AND TTR.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON 1 = 1
              AND STG.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID
              AND TGA.BORRADO = 0
            WHERE STR.BORRADO = 0
              AND STR.DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
              AND TTR.DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
              AND STG.DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''
              AND TGA.DD_TGA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''
            ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN

            V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
              USING (
                SELECT STR.DD_STR_ID
                  , STG.DD_STG_ID
                FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR
                JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON 1 = 1
                  AND STG.BORRADO = 0
                WHERE STR.BORRADO = 0
                  AND STR.DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
                  AND STG.DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''' 
              ) T2
              ON (T1.DD_STR_ID = T2.DD_STR_ID)
              WHEN MATCHED THEN
                UPDATE SET
                  T1.DD_STG_ID = T2.DD_STG_ID
                  , T1.USUARIOMODIFICAR = '''||V_USR||'''
                  , T1.FECHAMODIFICAR = SYSDATE
              WHERE T1.DD_STG_ID <> T2.DD_STG_ID
              WHEN NOT MATCHED THEN
                INSERT (
                  T1.SGT_ID
                  , T1.DD_STR_ID
                  , T1.DD_STG_ID
                  , T1.USUARIOCREAR
                  , T1.FECHACREAR
                )
                VALUES (
                  '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
                  , T2.DD_STR_ID
                  , T2.DD_STG_ID
                  , '''||V_USR||'''
                  , SYSDATE
                )
              ';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha fusionado el valor '''||TRIM(V_TMP_TIPO_DATA(2))||''' y '''||TRIM(V_TMP_TIPO_DATA(4))||'''');

        ELSE

            DBMS_OUTPUT.PUT_LINE('[KO]: No existe el tipo de trabajo ('''||TRIM(V_TMP_TIPO_DATA(1))||'''), o subtipo de trabajo ('''||TRIM(V_TMP_TIPO_DATA(2))||'''), o tipo de gasto ('''||TRIM(V_TMP_TIPO_DATA(3))||''') o subtipo de gasto ('''||TRIM(V_TMP_TIPO_DATA(4))||''')');

        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA.');

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