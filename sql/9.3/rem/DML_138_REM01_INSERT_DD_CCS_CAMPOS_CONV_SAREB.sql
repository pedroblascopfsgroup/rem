--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200629
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10495
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
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_CCS_CAMPOS_CONV_SAREB'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    T_TIPO_DATA('TMP_CONV_SAREB' , 'ACT_NUM_ACTIVO' , 1 , 0 , 'Número activo REM'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'ACT_NUM_ACTIVO_SAREB' , 1 , 0 , 'Número activo SAREB'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'TIPO_ACTIVO' , 1 , 0 , 'Tipo activo'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'SUBTIPO_ACTIVO' , 1 , 0 , 'Subtipo activo'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'ESTADO_COMERCIAL' , 1 , 0 , 'Estado comercial del activo'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'PROVINCIA' , 1 , 0 , 'Provincia del activo'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'MUNICIPIO' , 1 , 0 , 'Municipio del activo'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'CODIGO_POSTAL' , 1 , 0 , 'Código Postal del activo'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'NOMBRE_VIA' , 1 , 0 , 'Nombre de la vía donde se encuentra ubicada el activo'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'NUMERO_VIA' , 1 , 0 , 'Número en la vía donde se encuentra ubicado el activo'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'ESCALERA' , 1 , 0 , 'Escalera del activo'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'PLANTA' , 1 , 0 , 'Planta donde se encuentra el activo'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'PUERTA' , 1 , 0 , 'Puerta del activo'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'LATITUD' , 1 , 0 , 'Latitud donde se encuentra el activo'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'LONGITUD' , 1 , 0 , 'Longitud donde se encuentra el activo'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'TIPO_TITULO' , 1 , 0 , 'Tipo título del activo'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'SUBTIPO_TITULO' , 1 , 0 , 'Subtipo título del activo'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'ESTADO_CEE' , 1 , 0 , 'Estado de expedición de la etiqueta energética del activo'),
    T_TIPO_DATA('TMP_CONV_SAREB' , 'OCUPACION_ILEGAL' , 1 , 0 , 'Determina si el activo se encuentra ocupado ilegalmente'),
    T_TIPO_DATA('ACT_ACTIVO' , 'ACT_NUM_ACTIVO' , 0 , 1 , 'Número activo REM'),
    T_TIPO_DATA('ACT_ACTIVO' , 'ACT_NUM_ACTIVO_SAREB' , 0 , 1 , 'Número activo SAREB'),
    T_TIPO_DATA('ACT_ACTIVO' , 'DD_TPA_ID' , 0 , 1 , 'Tipo activo'),
    T_TIPO_DATA('ACT_ACTIVO' , 'DD_SAC_ID' , 0 , 1 , 'Subtipo activo'),
    T_TIPO_DATA('ACT_ACTIVO' , 'DD_SCM_ID' , 0 , 1 , 'Estado comercial del activo'),
    T_TIPO_DATA('BIE_LOCALIZACION' , 'DD_PRV_ID' , 0 , 1 , 'Provincia del activo'),
    T_TIPO_DATA('BIE_LOCALIZACION' , 'DD_LOC_ID' , 0 , 1 , 'Municipio del activo'),
    T_TIPO_DATA('BIE_LOCALIZACION' , 'BIE_LOC_COD_POST' , 0 , 1 , 'Código Postal del activo'),
    T_TIPO_DATA('BIE_LOCALIZACION' , 'BIE_LOC_NOMBRE_VIA' , 0 , 1 , 'Nombre de la vía donde se encuentra ubicada el activo'),
    T_TIPO_DATA('BIE_LOCALIZACION' , 'BIE_LOC_NUMERO_DOMICILIO' , 0 , 1 , 'Número en la vía donde se encuentra ubicado el activo'),
    T_TIPO_DATA('BIE_LOCALIZACION' , 'BIE_LOC_ESCALERA' , 0 , 1 , 'Escalera del activo'),
    T_TIPO_DATA('BIE_LOCALIZACION' , 'BIE_LOC_PISO' , 0 , 1 , 'Planta donde se encuentra el activo'),
    T_TIPO_DATA('BIE_LOCALIZACION' , 'BIE_LOC_PUERTA' , 0 , 1 , 'Puerta del activo'),
    T_TIPO_DATA('ACT_LOC_LOCALIZACION' , 'LOC_LATITUD' , 0 , 1 , 'Latitud donde se encuentra el activo'),
    T_TIPO_DATA('ACT_LOC_LOCALIZACION', 'LOC_LONGITUD' , 0 , 1 , 'Longitud donde se encuentra el activo'),
    T_TIPO_DATA('TIT_TITULO' , 'DD_TTI_ID' , 0 , 1 , 'Tipo título'),
    T_TIPO_DATA('TIT_TITULO' , 'DD_STI_ID' , 0 , 1 , 'Subipo título'),
    T_TIPO_DATA('ACT_ADO_ADMISION_DOCUMENTO' , 'DD_EDC_ID' , 0 , 1 , 'Estado de expedición de la etiqueta energética del activo cuando se hace referencia al documento CEE'),
    T_TIPO_DATA('ACT_SPS_SITUACION_POSESORIA' , 'SPS_OCUPADO' , 0 , 1 , 'Determina si el activo se encuentra ocupado'),
    T_TIPO_DATA('ACT_SPS_SITUACION_POSESORIA' , 'DD_TPA_ID' , 0 , 1 , 'Determina si el activo tiene título de ocupación')
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
					WHERE DD_CCS_TABLA = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND DD_CCS_CAMPO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' 
          AND DD_CCS_ORIGEN = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND DD_CCS_DESTINO = '''||TRIM(V_TMP_TIPO_DATA(4))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''.'''||TRIM(V_TMP_TIPO_DATA(2))||''' ya existe');
        ELSE
          -- Si no existe se inserta.
            V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              DD_CCS_ID,
              DD_CCS_TABLA,
              DD_CCS_CAMPO,
              DD_CCS_ORIGEN,
              DD_CCS_DESTINO,
              DD_CCS_DESCRIPCION,
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
              '''||TRIM(V_TMP_TIPO_DATA(5))||''',
              0,
              ''HREOS-10495'',
              SYSDATE,
              0
                        )';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''.'''||TRIM(V_TMP_TIPO_DATA(2))||'''');

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
