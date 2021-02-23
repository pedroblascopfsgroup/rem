--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20210222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13210
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
      T_TIPO_DATA('145','Nº Autos','ACT_AJD_ADJJUDICIAL','AJD_NUM_AUTO','ACT_ID'),
      T_TIPO_DATA('146','Procurador','ACT_AJD_ADJJUDICIAL','AJD_PROCURADOR','ACT_ID'),
      T_TIPO_DATA('147','Letrado','ACT_AJD_ADJJUDICIAL','AJD_LETRADO','ACT_ID'),
      T_TIPO_DATA('148','ID Asunto Recovery','ACT_AJD_ADJJUDICIAL','AJD_ID_ASUNTO','ACT_ID'),
      T_TIPO_DATA('149','Fecha solicitud moratoria','BIE_ADJ_ADJUDICACION','BIE_ADJ_F_SOL_MORATORIA','BIE_ID'),
      T_TIPO_DATA('150','Fecha resolución moratoria','BIE_ADJ_ADJUDICACION','BIE_ADJ_F_RES_MORATORIA','BIE_ID'),
      T_TIPO_DATA('151','Resolución moratoria','BIE_ADJ_ADJUDICACION','DD_FAV_ID','BIE_ID'),
      T_TIPO_DATA('152','Fecha señalamiento posesión','BIE_ADJ_ADJUDICACION','BIE_ADJ_F_SEN_POSESION','BIE_ID'),
      T_TIPO_DATA('153','Fecha realización posesión','BIE_ADJ_ADJUDICACION','BIE_ADJ_F_REA_POSESION','BIE_ID'),
      T_TIPO_DATA('154','Lanzamiento necesario','BIE_ADJ_ADJUDICACION','BIE_ADJ_LANZAMIENTO_NECES','BIE_ID'),
      T_TIPO_DATA('155','Fecha lanzamiento efectuado','BIE_ADJ_ADJUDICACION','BIE_ADJ_F_REA_LANZAMIENTO','BIE_ID'),
      
      T_TIPO_DATA('156','Fecha título','ACT_ADN_ADJNOJUDICIAL','ADN_FECHA_TITULO','ACT_ID'),
      
      T_TIPO_DATA('157','Fecha entrega del título a la gestoria','ACT_TIT_TITULO','TIT_FECHA_ENTREGA_GESTORIA','ACT_ID'),
      T_TIPO_DATA('158','Fecha presentación en Hacienda','ACT_TIT_TITULO','TIT_FECHA_PRESENT_HACIENDA','ACT_ID'),
      T_TIPO_DATA('159','Fecha última presentación en el registro','ACT_TIT_TITULO','TIT_FECHA_PRESENT2_REG','ACT_ID'),
      T_TIPO_DATA('160','Fecha presentación en el registro','ACT_TIT_TITULO','TIT_FECHA_PRESENT1_REG','ACT_ID'),
      T_TIPO_DATA('161','Fecha retirada definitiva registro','ACT_TIT_TITULO','TIT_FECHA_RETIRADA_REG','ACT_ID'),
      T_TIPO_DATA('163','Fecha de presentación en el registro','ACT_TIT_TITULO','TIT_FECHA_PRESENT2_REG','ACT_ID')
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
					WHERE DD_CCS_TABLA = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND DD_CCS_CAMPO = '''||TRIM(V_TMP_TIPO_DATA(4))||''' 
          AND DD_COS_ID = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB WHERE DD_COS_CODIGO ='''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0) AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''.'''||TRIM(V_TMP_TIPO_DATA(2))||''' ya existe');
        ELSE
          IF TRIM(V_TMP_TIPO_DATA(3)) IS NOT NULL THEN
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              DD_CCS_ID,
              DD_CCS_TABLA,
              DD_CCS_CAMPO,
              DD_CCS_CRUCE,
              DD_CCS_DESCRIPCION,
              DD_COS_ID,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
              '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
              '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              '''||TRIM(V_TMP_TIPO_DATA(4))||''',
              '''||TRIM(V_TMP_TIPO_DATA(5))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB WHERE DD_COS_CODIGO ='''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0),
              0,
              ''HREOS-13209'',
              SYSDATE,
              0
                        )';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''.'''||TRIM(V_TMP_TIPO_DATA(2))||'''');
          ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO]: No existe tabla de destino para '''||TRIM(V_TMP_TIPO_DATA(1))||'''.'''||TRIM(V_TMP_TIPO_DATA(2))||'''');
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
