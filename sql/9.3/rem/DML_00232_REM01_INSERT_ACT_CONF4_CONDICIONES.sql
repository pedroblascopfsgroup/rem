--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200709
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
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONF4_CONDICIONES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('001','OFR_VUE'),
      T_TIPO_DATA('001','MOD_REM'),
      T_TIPO_DATA('002','OFR_VUE'),
      T_TIPO_DATA('004','OFR_VUE'),
      T_TIPO_DATA('004','MOD_REM'),
      T_TIPO_DATA('005','OFR_VUE'),
      T_TIPO_DATA('009','INT_MOD'),
      T_TIPO_DATA('015','ACT_SIEMPRE_PRISMA'),
      T_TIPO_DATA('016','INT_MOD'),
      T_TIPO_DATA('016','ELI_VAL'),
      T_TIPO_DATA('019','ADJ_NO'),
      T_TIPO_DATA('019','ADN_LC_ADJ'),
      T_TIPO_DATA('020','ADJ_NO'),
      T_TIPO_DATA('020','ADN_LC_ADJ'),
      T_TIPO_DATA('022','INT_MOD'),
      T_TIPO_DATA('022','ELI_VAL'),
      T_TIPO_DATA('029','NUE_CAR'),
      T_TIPO_DATA('029','OFR_VUE_CAR'),
      T_TIPO_DATA('031','NUE_CAR'),
      T_TIPO_DATA('031','OFR_VUE_CAR'),
      T_TIPO_DATA('033','NUE_CAR'),
      T_TIPO_DATA('033','OFR_VUE_CAR'),
      T_TIPO_DATA('035','NUE_CAR'),
      T_TIPO_DATA('035','OFR_VUE_CAR'),
      T_TIPO_DATA('037','NUE_CAR'),
      T_TIPO_DATA('037','OFR_VUE_CAR'),
      T_TIPO_DATA('039','NUE_CAR'),
      T_TIPO_DATA('039','OFR_VUE_CAR'),
      T_TIPO_DATA('041','NUE_CAR'),
      T_TIPO_DATA('041','OFR_VUE_CAR'),
      T_TIPO_DATA('045','NUE_CAR'),
      T_TIPO_DATA('045','OFR_VUE_CAR'),
      T_TIPO_DATA('047','NUE_CAR'),
      T_TIPO_DATA('047','OFR_VUE_CAR'),
      T_TIPO_DATA('043','NUE_CAR'),
      T_TIPO_DATA('043','OFR_VUE_CAR'),
      T_TIPO_DATA('048','OFR_VUE'),
      T_TIPO_DATA('048','MOD_REM'),
      T_TIPO_DATA('049','OFR_VUE'),
      T_TIPO_DATA('050','OFR_VUE'),
      T_TIPO_DATA('050','MOD_REM'),
      T_TIPO_DATA('051','OFR_VUE'),
      T_TIPO_DATA('052','OFR_VUE'),
      T_TIPO_DATA('052','MOD_REM'),
      T_TIPO_DATA('053','OFR_VUE'),
      T_TIPO_DATA('054','OFR_VUE'),
      T_TIPO_DATA('054','MOD_REM'),
      T_TIPO_DATA('055','OFR_VUE'),
      T_TIPO_DATA('056','OFR_VUE'),
      T_TIPO_DATA('056','MOD_REM'),
      T_TIPO_DATA('057','OFR_VUE'),
      T_TIPO_DATA('058','OFR_VUE'),
      T_TIPO_DATA('058','MOD_REM'),
      T_TIPO_DATA('059','OFR_VUE'),
      T_TIPO_DATA('060','OFR_VUE'),
      T_TIPO_DATA('060','MOD_REM'),
      T_TIPO_DATA('061','OFR_VUE'),
      T_TIPO_DATA('062','OFR_VUE'),
      T_TIPO_DATA('062','MOD_REM'),
      T_TIPO_DATA('063','OFR_VUE'),
      T_TIPO_DATA('065','OFR_VUE'),
      T_TIPO_DATA('065','MOD_REM'),
      T_TIPO_DATA('066','OFR_VUE'),
      T_TIPO_DATA('067','OFR_VUE'),
      T_TIPO_DATA('067','MOD_REM'),
      T_TIPO_DATA('068','OFR_VUE'),
      T_TIPO_DATA('069','OFR_VUE'),
      T_TIPO_DATA('069','MOD_REM'),
      T_TIPO_DATA('070','OFR_VUE'),
      T_TIPO_DATA('088','CEE_OBT'),
      T_TIPO_DATA('089','CEE_OBT'),
      T_TIPO_DATA('089','CEE_NOB'),
      T_TIPO_DATA('092','ALQ_DIV'),
      T_TIPO_DATA('092','RES_DIV'),
      T_TIPO_DATA('098','INT_MOD')
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
					WHERE AC2_ID = (SELECT AC2_ID FROM '||V_ESQUEMA||'.ACT_CONF2_ACCION WHERE AC2_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''') 
          AND AC4_CONDICION = (SELECT DD_CND_ID FROM '||V_ESQUEMA||'.DD_CND_CONDICIONES_CONV_SAREB WHERE DD_CND_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND BORRADO = 0)';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''.'''||TRIM(V_TMP_TIPO_DATA(2))||''' ya existe');
        ELSE
          -- Si no existe se inserta.
            V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              AC4_ID,
              AC2_ID,
              AC4_CONDICION,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
              '||V_ID||',
              (SELECT AC2_ID FROM '||V_ESQUEMA||'.ACT_CONF2_ACCION WHERE AC2_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''),
              (SELECT DD_CND_ID FROM '||V_ESQUEMA||'.DD_CND_CONDICIONES_CONV_SAREB WHERE DD_CND_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND BORRADO = 0),
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
