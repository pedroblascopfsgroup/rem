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
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONF2_ACCION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('001' , 'ACT_ACTIVO.DD_TPA_ID' , 'ACT_CND'),
      T_TIPO_DATA('002' , 'ACT_ACTIVO.DD_SAC_ID' , 'ACT_CND'),
      T_TIPO_DATA('003' , 'ACT_ACTIVO.DD_TPA_ID' , 'WRN_CND'),
      T_TIPO_DATA('004' , 'ACT_ACTIVO.DD_SAC_ID' , 'WRN_CND'),
      T_TIPO_DATA('005' , 'ACT_ACTIVO.DD_SCM_ID' , 'WRN_CND'),
      T_TIPO_DATA('006' , 'BIE_LOCALIZACION.DD_PRV_ID' , 'ACT_CND'),
      T_TIPO_DATA('007' , 'BIE_LOCALIZACION.DD_LOC_ID' , 'ACT_CND'),
      T_TIPO_DATA('008' , 'BIE_LOCALIZACION.BIE_LOC_COD_POST' , 'ACT_CND'),
      T_TIPO_DATA('009' , 'BIE_LOCALIZACION.BIE_LOC_NOMBRE_VIA' , 'ACT_CND'),
      T_TIPO_DATA('010' , 'BIE_LOCALIZACION.BIE_LOC_NUMERO_DOMICILIO' , 'ACT_CND'),
      T_TIPO_DATA('011' , 'BIE_LOCALIZACION.BIE_LOC_ESCALERA' , 'ACT_CND'),
      T_TIPO_DATA('012' , 'BIE_LOCALIZACION.BIE_LOC_PISO' , 'ACT_CND'),
      T_TIPO_DATA('013' , 'BIE_LOCALIZACION.BIE_LOC_PUERTA', 'ACT_CND'),
      T_TIPO_DATA('014' , 'ACT_LOC_LOCALIZACION.LOC_LATITUD' , 'ACT_CND'),
      T_TIPO_DATA('015' , 'ACT_LOC_LOCALIZACION.LOC_LONGITUD' , 'ACT_CND'),
      T_TIPO_DATA('016' , 'BIE_LOCALIZACION.DD_PRV_ID' , 'WRN_CND'),
      T_TIPO_DATA('017' , 'BIE_LOCALIZACION.DD_LOC_ID' , 'WRN_CND'),
      T_TIPO_DATA('018' , 'BIE_LOCALIZACION.BIE_LOC_COD_POST' , 'WRN_CND'),
      T_TIPO_DATA('019' , 'BIE_LOCALIZACION.BIE_LOC_NOMBRE_VIA' , 'WRN_CND'),
      T_TIPO_DATA('020' , 'BIE_LOCALIZACION.BIE_LOC_NUMERO_DOMICILIO' , 'WRN_CND'),
      T_TIPO_DATA('021' , 'BIE_LOCALIZACION.BIE_LOC_ESCALERA' , 'WRN_CND'),
      T_TIPO_DATA('022' , 'BIE_LOCALIZACION.BIE_LOC_PISO' , 'WRN_CND'),
      T_TIPO_DATA('023' , 'BIE_LOCALIZACION.BIE_LOC_PUERTA' , 'WRN_CND'),
      T_TIPO_DATA('024' , 'ACT_LOC_LOCALIZACION.LOC_LATITUD' , 'WRN_CND'),
      T_TIPO_DATA('025' , 'ACT_LOC_LOCALIZACION.LOC_LONGITUD' , 'WRN_CND'),
      T_TIPO_DATA('026' , 'TIT_TITULO.DD_TTI_ID' , 'WRN_CND'),
      T_TIPO_DATA('027' , 'TIT_TITULO.DD_STI_ID' , 'WRN_CND'),
      T_TIPO_DATA('028' , 'ACT_ADO_ADMISION_DOCUMENTO.DD_EDC_ID' , 'ACT_CND'),
      T_TIPO_DATA('029' , 'ACT_ADO_ADMISION_DOCUMENTO.DD_EDC_ID' , 'WRN_CND'),
      T_TIPO_DATA('030' , 'ACT_SPS_SITUACION_POSESORIA.SPS_OCUPADO' , 'ACT_CND'),
      T_TIPO_DATA('031' , 'ACT_SPS_SITUACION_POSESORIA.DD_TPA_ID' , 'ACT_CND'),
      T_TIPO_DATA('032' , 'ACT_SPS_SITUACION_POSESORIA.SPS_OCUPADO' , 'WRN_CND'),
      T_TIPO_DATA('033' , 'ACT_SPS_SITUACION_POSESORIA.DD_TPA_ID' , 'WRN_CND')
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
					WHERE AC2_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
        ELSE
          -- Si no existe se inserta.
            V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              AC2_ID,
              AC2_CODIGO,
              DD_CCS_ID,
              DD_ACS_ID,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
              '||V_ID||',
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              (SELECT DD_CCS_ID FROM '||V_ESQUEMA||'.DD_CCS_CAMPOS_CONV_SAREB WHERE DD_CCS_TABLA || ''.'' || DD_CCS_CAMPO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),
              (SELECT DD_ACS_ID FROM '||V_ESQUEMA||'.DD_ACS_ACCION_CONV_SAREB WHERE DD_ACS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''),
              0,
              ''HREOS-10515'',
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
