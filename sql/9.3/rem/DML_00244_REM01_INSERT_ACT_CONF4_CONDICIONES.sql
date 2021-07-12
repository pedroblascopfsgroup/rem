--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20201202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12338
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
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONF4_CONDICIONES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('002','Tipo Activo','002','ACT_CND','OFR_NVU','OFR_VUE'),
      T_TIPO_DATA('004','Subtipo Activo','004','ACT_CND','OFR_NVU','OFR_VUE'),
      T_TIPO_DATA('040','Tipo de vía','048','ACT_CND','OFR_NVU','OFR_VUE'),
      T_TIPO_DATA('042','Nombre de vía','050','ACT_CND','OFR_NVU','OFR_VUE'),
      T_TIPO_DATA('044','Nº','052','ACT_CND','OFR_NVU','OFR_VUE'),
      T_TIPO_DATA('046','Escalera','054','ACT_CND','OFR_NVU','OFR_VUE'),
      T_TIPO_DATA('048','Planta','056','ACT_CND','OFR_NVU','OFR_VUE'),
      T_TIPO_DATA('050','Puerta','058','ACT_CND','OFR_NVU','OFR_VUE'),
      T_TIPO_DATA('052','Provincia','060','ACT_CND','OFR_NVU','OFR_VUE'),
      T_TIPO_DATA('054','Municipio','062','ACT_CND','OFR_NVU','OFR_VUE'),
      T_TIPO_DATA('058','Código Postal','065','ACT_CND','OFR_NVU','OFR_VUE'),
      T_TIPO_DATA('060','Latitud','067','ACT_CND','OFR_NVU','OFR_VUE'),
      T_TIPO_DATA('062','Longitud','069','ACT_CND','OFR_NVU','OFR_VUE')
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
					WHERE AC2_ID = (SELECT AC2_ID FROM '||V_ESQUEMA||'.ACT_CONF2_ACCION WHERE AC2_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''') 
          AND AC4_CONDICION = (SELECT DD_CND_ID FROM '||V_ESQUEMA||'.DD_CND_CONDICIONES_CONV_SAREB WHERE DD_CND_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||''' AND BORRADO = 0)';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(3))||'''.'''||TRIM(V_TMP_TIPO_DATA(5))||''' ya existe, actualizamos');
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET 
              AC4_CONDICION = (SELECT DD_CND_ID FROM '||V_ESQUEMA||'.DD_CND_CONDICIONES_CONV_SAREB WHERE DD_CND_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(6))||''' AND BORRADO = 0),
              USUARIOMODIFICAR = ''HREOS-12338'',
              FECHAMODIFICAR = SYSDATE
              WHERE AC2_ID = (SELECT AC2_ID FROM '||V_ESQUEMA||'.ACT_CONF2_ACCION WHERE AC2_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''')
				      AND AC4_CONDICION = (SELECT DD_CND_ID FROM '||V_ESQUEMA||'.DD_CND_CONDICIONES_CONV_SAREB WHERE DD_CND_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||''' AND BORRADO = 0)';
            EXECUTE IMMEDIATE V_MSQL;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: No existe configuración para '''||TRIM(V_TMP_TIPO_DATA(2))||'''');
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
