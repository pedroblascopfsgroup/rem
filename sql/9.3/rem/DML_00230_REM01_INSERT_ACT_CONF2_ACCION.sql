--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200709
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10500
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
      T_TIPO_DATA('001','001','NO_ACT'),
      T_TIPO_DATA('002','002','ACT_CND'),
      T_TIPO_DATA('003','002','WRN_CND'),
      T_TIPO_DATA('004','004','ACT_CND'),
      T_TIPO_DATA('005','004','WRN_CND'),
      T_TIPO_DATA('006','006','ACT'),
      T_TIPO_DATA('007','007','NO_ACT'),
      T_TIPO_DATA('008','011','ACT'),
      T_TIPO_DATA('009','011','WRN_CND'),
      T_TIPO_DATA('010','013','ACT'),
      T_TIPO_DATA('011','014','ACT'),
      T_TIPO_DATA('012','015','ACT'),
      T_TIPO_DATA('013','017','ACT'),
      T_TIPO_DATA('014','017','WRN'),
      T_TIPO_DATA('015','018','ACT_CND'),
      T_TIPO_DATA('016','018','WRN_CND'),
      T_TIPO_DATA('017','019','NO_ACT'),
      T_TIPO_DATA('018','020','NO_ACT'),
      T_TIPO_DATA('019','019','WRN_CND'),
      T_TIPO_DATA('020','020','WRN_CND'),
      T_TIPO_DATA('021','021','ACT'),
      T_TIPO_DATA('022','021','WRN_CND'),
      T_TIPO_DATA('023','022','ACT'),
      T_TIPO_DATA('024','023','ACT'),
      T_TIPO_DATA('025','024','ACT'),
      T_TIPO_DATA('026','027','ACT'),
      T_TIPO_DATA('027','028','ACT'),
      T_TIPO_DATA('028','029','ACT'),
      T_TIPO_DATA('029','029','WRN_CND'),
      T_TIPO_DATA('030','030','ACT'),
      T_TIPO_DATA('031','030','WRN_CND'),
      T_TIPO_DATA('032','031','ACT'),
      T_TIPO_DATA('033','031','WRN_CND'),
      T_TIPO_DATA('034','032','ACT'),
      T_TIPO_DATA('035','032','WRN_CND'),
      T_TIPO_DATA('036','033','ACT'),
      T_TIPO_DATA('037','033','WRN_CND'),
      T_TIPO_DATA('038','034','ACT'),
      T_TIPO_DATA('039','034','WRN_CND'),
      T_TIPO_DATA('040','035','ACT'),
      T_TIPO_DATA('041','035','WRN_CND'),
      T_TIPO_DATA('042','039','ACT'),
      T_TIPO_DATA('043','039','WRN_CND'),
      T_TIPO_DATA('044','037','ACT'),
      T_TIPO_DATA('045','037','WRN_CND'),
      T_TIPO_DATA('046','038','ACT'),
      T_TIPO_DATA('047','038','WRN_CND'),
      T_TIPO_DATA('048','040','ACT_CND'),
      T_TIPO_DATA('049','040','WRN_CND'),
      T_TIPO_DATA('050','042','ACT_CND'),
      T_TIPO_DATA('051','042','WRN_CND'),
      T_TIPO_DATA('052','044','ACT_CND'),
      T_TIPO_DATA('053','044','WRN_CND'),
      T_TIPO_DATA('054','046','ACT_CND'),
      T_TIPO_DATA('055','046','WRN_CND'),
      T_TIPO_DATA('056','048','ACT_CND'),
      T_TIPO_DATA('057','048','WRN_CND'),
      T_TIPO_DATA('058','050','ACT_CND'),
      T_TIPO_DATA('059','050','WRN_CND'),
      T_TIPO_DATA('060','052','ACT_CND'),
      T_TIPO_DATA('061','052','WRN_CND'),
      T_TIPO_DATA('062','054','ACT_CND'),
      T_TIPO_DATA('063','054','WRN_CND'),
      T_TIPO_DATA('064','056','ACT'),
      T_TIPO_DATA('065','058','ACT_CND'),
      T_TIPO_DATA('066','058','WRN_CND'),
      T_TIPO_DATA('067','060','ACT_CND'),
      T_TIPO_DATA('068','060','WRN_CND'),
      T_TIPO_DATA('069','062','ACT_CND'),
      T_TIPO_DATA('070','062','WRN_CND'),
      T_TIPO_DATA('071','065','ACT'),
      T_TIPO_DATA('072','066','ACT'),
      T_TIPO_DATA('073','067','ACT'),
      T_TIPO_DATA('074','068','ACT'),
      T_TIPO_DATA('075','069','ACT'),
      T_TIPO_DATA('076','070','ACT'),
      T_TIPO_DATA('077','071','ACT'),
      T_TIPO_DATA('078','073','ACT'),
      T_TIPO_DATA('079','074','ACT'),
      T_TIPO_DATA('080','075','ACT'),
      T_TIPO_DATA('081','076','ACT'),
      T_TIPO_DATA('082','077','ACT'),
      T_TIPO_DATA('083','078','ACT'),
      T_TIPO_DATA('084','079','ACT'),
      T_TIPO_DATA('085','080','ACT'),
      T_TIPO_DATA('086','081','ACT'),
      T_TIPO_DATA('087','082','ACT'),
      T_TIPO_DATA('088','083','ACT_CND'),
      T_TIPO_DATA('089','083','WRN_CND'),
      T_TIPO_DATA('090','084','ACT'),
      T_TIPO_DATA('091','086','NO_ACT'),
      T_TIPO_DATA('092','086','WRN_CND'),
      T_TIPO_DATA('093','092','ACT'),
      T_TIPO_DATA('094','093','ACT'),
      T_TIPO_DATA('095','094','ACT'),
      T_TIPO_DATA('096','095','ACT'),
      T_TIPO_DATA('097','096','ACT'),
      T_TIPO_DATA('098','096','WRN'),
      T_TIPO_DATA('099','097','ACT'),
      T_TIPO_DATA('100','102','ACT'),
      T_TIPO_DATA('101','103','ACT'),
      T_TIPO_DATA('102','104','ACT'),
      T_TIPO_DATA('103','105','ACT'),
      T_TIPO_DATA('104','106','ACT'),
      T_TIPO_DATA('105','107','ACT'),
      T_TIPO_DATA('106','108','ACT'),
      T_TIPO_DATA('107','117','NO_ACT'),
      T_TIPO_DATA('108','118','NO_ACT'),
      T_TIPO_DATA('109','125','ACT'),
      T_TIPO_DATA('110','126','ACT'),
      T_TIPO_DATA('111','128','NO_ACT'),
      T_TIPO_DATA('112','129','NO_ACT')
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
              DD_COS_ID,
              DD_ACS_ID,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
              '||V_ID||',
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB WHERE DD_COS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),
              (SELECT DD_ACS_ID FROM '||V_ESQUEMA||'.DD_ACS_ACCION_CONV_SAREB WHERE DD_ACS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''),
              0,
              ''HREOS-10500'',
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
