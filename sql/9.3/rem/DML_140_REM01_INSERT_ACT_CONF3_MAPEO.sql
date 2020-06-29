--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200629
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10515
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
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONF3_MAPEO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('TMP_CONV_SAREB.ACT_NUM_ACTIVO' , 'ACT_ACTIVO.ACT_NUM_ACTIVO' , null),
      T_TIPO_DATA('TMP_CONV_SAREB.ACT_NUM_ACTIVO_SAREB' , 'ACT_ACTIVO.ACT_NUM_ACTIVO_SAREB' , null),
      T_TIPO_DATA('TMP_CONV_SAREB.TIPO_ACTIVO' , 'ACT_ACTIVO.DD_TPA_ID' ,'Cruce con DD_TPA_TIPO_ACTIVO'),
      T_TIPO_DATA('TMP_CONV_SAREB.SUBTIPO_ACTIVO' , 'ACT_ACTIVO.DD_SAC_ID' , 'Cruce con DD_SAC_SUBTIPO_ACTIVO'),
      T_TIPO_DATA('TMP_CONV_SAREB.ESTADO_COMERCIAL' , 'ACT_ACTIVO.DD_SCM_ID' , 'Cruce con DD_SCM_SITUACION_COMERCIAL'),
      T_TIPO_DATA('TMP_CONV_SAREB.PROVINCIA' , 'BIE_LOCALIZACION.DD_PRV_ID' , 'Cruce con DD_PRV_PROVINCIA'),
      T_TIPO_DATA('TMP_CONV_SAREB.MUNICIPIO' , 'BIE_LOCALIZACION.DD_LOC_ID' , 'Cruce con DD_LOC_LOCALIDAD'),
      T_TIPO_DATA('TMP_CONV_SAREB.CODIGO_POSTAL' , 'BIE_LOCALIZACION.BIE_LOC_COD_POST' ,null),
      T_TIPO_DATA('TMP_CONV_SAREB.NOMBRE_VIA' , 'BIE_LOCALIZACION.BIE_LOC_NOMBRE_VIA' , null),
      T_TIPO_DATA('TMP_CONV_SAREB.NUMERO_VIA' , 'BIE_LOCALIZACION.BIE_LOC_NUMERO_DOMICILIO' , null),
      T_TIPO_DATA('TMP_CONV_SAREB.ESCALERA' , 'BIE_LOCALIZACION.BIE_LOC_ESCALERA' , null),
      T_TIPO_DATA('TMP_CONV_SAREB.PLANTA' , 'BIE_LOCALIZACION.BIE_LOC_PISO' , null),
      T_TIPO_DATA('TMP_CONV_SAREB.PUERTA' , 'BIE_LOCALIZACION.BIE_LOC_PUERTA' , null),
      T_TIPO_DATA('TMP_CONV_SAREB.LATITUD' , 'ACT_LOC_LOCALIZACION.LOC_LATITUD' , null),
      T_TIPO_DATA('TMP_CONV_SAREB.LONGITUD' , 'ACT_LOC_LOCALIZACION.LOC_LONGITUD' , null),
      T_TIPO_DATA('TMP_CONV_SAREB.TIPO_TITULO' , 'TIT_TITULO.DD_TTI_ID' , 'Cruce con DD_TTI_TIPO_TITULO'),
      T_TIPO_DATA('TMP_CONV_SAREB.SUBTIPO_TITULO' , 'TIT_TITULO.DD_STI_ID' , 'Cruce con DD_STI_SUBTIPO_TITULO'),
      T_TIPO_DATA('TMP_CONV_SAREB.ESTADO_CEE' ,'ACT_ADO_ADMISION_DOCUMENTO.DD_EDC_ID' , 'Cruce con ACT_CFD_CONFIG_DOCUMENTO por CFD_ID, con DD_TPD_TIPO_DOCUMENTO por DD_TPD_ID y con DD_EDC_ESTADO_DOCUMENTO'),
      T_TIPO_DATA('TMP_CONV_SAREB.OCUPACION_ILEGAL' , 'ACT_SPS_SITUACION_POSESORIA.SPS_OCUPADO' , 'Si viene S o 1, entonces 1. N, 0 o nulo, entonces 0.'),
      T_TIPO_DATA('TMP_CONV_SAREB.OCUPACION_ILEGAL' , 'ACT_SPS_SITUACION_POSESORIA.DD_TPA_ID' , 'Si viene S o 1, cruce con DD_TPA_TIPO_TITULO_ACT y 01. N, 0 o nulo, entonces 02.')
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
					WHERE DD_CCS_ID_ORIGEN = (SELECT DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB WHERE DD_CCS_TABLA || ''.'' || DD_CCS_CAMPO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
           AND DD_CCS_ID_DESTINO = (SELECT DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB WHERE DD_CCS_TABLA || ''.'' || DD_CCS_CAMPO = '''||TRIM(V_TMP_TIPO_DATA(2))||''')
           AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' y '''||TRIM(V_TMP_TIPO_DATA(2))||''' ya existe');
        ELSE
          -- Si no existe se inserta.
            V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              AC3_ID,
              DD_CCS_ID_ORIGEN,
              DD_CCS_ID_DESTINO,
              AC3_TRANSFORMACION,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
              '||V_ID||',
              (SELECT DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB WHERE DD_CCS_TABLA || ''.'' || DD_CCS_CAMPO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''),
              (SELECT DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB WHERE DD_CCS_TABLA || ''.'' || DD_CCS_CAMPO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),
              '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              0,
              ''HREOS-10515'',
              SYSDATE,
              0
                        )';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' y '''||TRIM(V_TMP_TIPO_DATA(2))||'''');

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
