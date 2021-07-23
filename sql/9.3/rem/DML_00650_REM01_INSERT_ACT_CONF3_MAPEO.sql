--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210708
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10042
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
    V_USUARIO VARCHAR2(100 CHAR) :='REMVIP-10042';
    V_ID NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('072','Subfinca','BIE_DATOS_REGISTRALES','BIE_DREG_NUM_FINCA','BIE_ID','LEFT JOIN (SELECT CASE WHEN AUX.VALOR_NUEVO IS NULL THEN COALESCE(AUX2.VALOR_NUEVO, CASE WHEN INSTR(BREG.BIE_DREG_NUM_FINCA,''''/'''') = 0 THEN BREG.BIE_DREG_NUM_FINCA ELSE SUBSTR(BREG.BIE_DREG_NUM_FINCA,0,INSTR(BREG.BIE_DREG_NUM_FINCA,''''/'''')-1) END) ELSE COALESCE(AUX2.VALOR_NUEVO, CASE WHEN INSTR(BREG.BIE_DREG_NUM_FINCA,''''/'''') = 0 THEN BREG.BIE_DREG_NUM_FINCA ELSE SUBSTR(BREG.BIE_DREG_NUM_FINCA,0,INSTR(BREG.BIE_DREG_NUM_FINCA,''''/'''')-1) END) || ''''/'''' || AUX.VALOR_NUEVO END AS BIE_DREG_NUM_FINCA, AUX.ACT_NUM_ACTIVO FROM REM01.ESPARTA_EXCEL1 AUX LEFT JOIN REM01.ESPARTA_EXCEL1 AUX2 ON AUX2.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO AND AUX2.CAMPO = ''''071'''' JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO JOIN REM01.ACT_REG_INFO_REGISTRAL REG ON REG.ACT_ID = ACT.ACT_ID JOIN REM01.BIE_DATOS_REGISTRALES BREG ON BREG.BIE_DREG_ID = REG.BIE_DREG_ID WHERE AUX.CAMPO = ''''072'''' AND ACT.BORRADO = 0 AND REG.BORRADO = 0 AND BREG.BORRADO = 0) CRUCE ON CRUCE.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO')
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

           V_SQL := 'SELECT AC3_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
					WHERE DD_CCS_ID = (SELECT DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB WHERE DD_CCS_TABLA = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND DD_CCS_CAMPO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''
          AND DD_COS_ID = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB WHERE BORRADO = 0 AND DD_COS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''))
          AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_ID;

          V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET 
              DD_CCS_ID = (SELECT DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB WHERE DD_CCS_TABLA = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND DD_CCS_CAMPO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''
                AND DD_COS_ID = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB WHERE BORRADO = 0 AND DD_COS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')),
              AC3_TRANSFORMACION = '''||TRIM(V_TMP_TIPO_DATA(6))||''',
              USUARIOMODIFICAR = '''||V_USUARIO||''',
              FECHAMODIFICAR = SYSDATE              
            WHERE AC3_ID='||V_ID||'
          ';
          EXECUTE IMMEDIATE V_SQL;


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
              '''||V_USUARIO||''',
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
