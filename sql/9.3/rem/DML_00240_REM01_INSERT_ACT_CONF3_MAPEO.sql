--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20201110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11966
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
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONF3_MAPEO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('141','REO Contabilizado SAP','ACT_SAREB_ACTIVOS','REO_CONTABILIZADO','ACT_ID','LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO CRUCE ON CRUCE.DD_SIN_CODIGO = TMP.VALOR_NUEVO AND CRUCE.BORRADO = 0')
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
					WHERE DD_CCS_ID = (SELECT DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB WHERE DD_CCS_TABLA = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND DD_CCS_CAMPO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''
          AND DD_COS_ID = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB WHERE BORRADO = 0 AND DD_COS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''))
          AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(3))||''' y '''||TRIM(V_TMP_TIPO_DATA(4))||''' ya existe');
        ELSE
          IF TRIM(V_TMP_TIPO_DATA(3)) IS NOT NULL THEN
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              AC3_ID,
              DD_CCS_ID,
              AC3_TRANSFORMACION,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
              '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
              (SELECT DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB WHERE DD_CCS_TABLA = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND DD_CCS_CAMPO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''
                AND DD_COS_ID = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB WHERE BORRADO = 0 AND DD_COS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')),
              '''||TRIM(V_TMP_TIPO_DATA(6))||''',
              0,
              ''HREOS-11215'',
              SYSDATE,
              0)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(3))||''' y '''||TRIM(V_TMP_TIPO_DATA(4))||'''');
          ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO]: No existe configuración para '''||TRIM(V_TMP_TIPO_DATA(1))||''' y '''||TRIM(V_TMP_TIPO_DATA(2))||'''');
          END IF;
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
