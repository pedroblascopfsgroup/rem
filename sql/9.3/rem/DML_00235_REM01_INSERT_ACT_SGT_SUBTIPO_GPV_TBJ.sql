--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200917
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10742
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

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('01','01','11','43'),
      T_TIPO_DATA('01','02','11','52'),
      T_TIPO_DATA('01','03','11','52'),
      T_TIPO_DATA('01','04','11','52'),
      T_TIPO_DATA('01','05','11','52'),
      T_TIPO_DATA('01','06','11','52'),
      T_TIPO_DATA('01','07','11','52'),
      T_TIPO_DATA('02','13','14','64'),
      T_TIPO_DATA('02','14','14','57'),
      T_TIPO_DATA('02','15','14','67'),
      T_TIPO_DATA('02','16','14','66'),
      T_TIPO_DATA('02','17','14','65'),
      T_TIPO_DATA('02','18','14','58'),
      T_TIPO_DATA('02','19','14','59'),
      T_TIPO_DATA('02','20','14','60'),
      T_TIPO_DATA('02','21','14','61'),
      T_TIPO_DATA('02','22','14','62'),
      T_TIPO_DATA('02','23','14','62'),
      T_TIPO_DATA('02','24','14','62'),
      T_TIPO_DATA('02','25','14','63'),
      T_TIPO_DATA('02','ACO','15','79'),
      T_TIPO_DATA('02','FOT','14','57'),
      T_TIPO_DATA('03','26','15','70'),
      T_TIPO_DATA('03','27','15','71'),
      T_TIPO_DATA('03','28','15','72'),
      T_TIPO_DATA('03','29','15','73'),
      T_TIPO_DATA('03','30','15','73'),
      T_TIPO_DATA('03','31','15','73'),
      T_TIPO_DATA('03','32','15','76'),
      T_TIPO_DATA('03','33','14','57'),
      T_TIPO_DATA('03','34','16','85'),
      T_TIPO_DATA('03','35','15','77'),
      T_TIPO_DATA('03','36','15','78'),
      T_TIPO_DATA('03','37','15','79'),
      T_TIPO_DATA('03','38','15','79'),
      T_TIPO_DATA('03','39','15','81'),
      T_TIPO_DATA('03','40','15','82'),
      T_TIPO_DATA('03','41','15','83'),
      T_TIPO_DATA('03','58','15','82'),
      T_TIPO_DATA('03','57','15','75'),
      T_TIPO_DATA('03','59','15','73'),
      T_TIPO_DATA('03','60','15','76'),
      T_TIPO_DATA('03','61','15','70'),
      T_TIPO_DATA('03','62','14','57'),
      T_TIPO_DATA('03','63','15','73'),
      T_TIPO_DATA('03','64','15','71'),
      T_TIPO_DATA('03','65','15','79'),
      T_TIPO_DATA('03','66','15','76'),
      T_TIPO_DATA('03','67','15','76'),
      T_TIPO_DATA('03','68','15','75'),
      T_TIPO_DATA('03','69','14','57'),
      T_TIPO_DATA('03','70','15','79'),
      T_TIPO_DATA('03','71','11','51'),
      T_TIPO_DATA('03','72','15','79'),
      T_TIPO_DATA('03','73','18','91'),
      T_TIPO_DATA('03','100','15','73'),
      T_TIPO_DATA('03','101','15','73'),
      T_TIPO_DATA('03','102','15','73'),
      T_TIPO_DATA('03','103','15','73'),
      T_TIPO_DATA('03','104','15','73'),
      T_TIPO_DATA('03','105','15','73'),
      T_TIPO_DATA('03','106','15','83'),
      T_TIPO_DATA('03','107','15','79'),
      T_TIPO_DATA('03','108','15','76'),
      T_TIPO_DATA('03','109','15','79'),
      T_TIPO_DATA('03','110','15','79'),
      T_TIPO_DATA('03','111','15','79'),
      T_TIPO_DATA('03','112','15','79'),
      T_TIPO_DATA('03','113','15','79'),
      T_TIPO_DATA('03','114','15','79'),
      T_TIPO_DATA('03','115','15','79'),
      T_TIPO_DATA('03','116','15','72'),
      T_TIPO_DATA('03','117','15','79'),
      T_TIPO_DATA('03','118','15','79'),
      T_TIPO_DATA('03','119','15','76'),
      T_TIPO_DATA('03','120','15','70'),
      T_TIPO_DATA('03','121','15','80'),
      T_TIPO_DATA('03','122','15','79'),
      T_TIPO_DATA('03','123','15','79'),
      T_TIPO_DATA('03','124','15','79'),
      T_TIPO_DATA('03','125','15','79'),
      T_TIPO_DATA('03','126','15','79'),
      T_TIPO_DATA('03','127','15','79'),
      T_TIPO_DATA('03','128','15','70'),
      T_TIPO_DATA('03','129','15','79'),
      T_TIPO_DATA('03','PAQ','15','75'),
      T_TIPO_DATA('03','INT','15','79'),
      T_TIPO_DATA('03','RAN','15','73'),
      T_TIPO_DATA('03','VAL','15','79'),
      T_TIPO_DATA('03','SIN','15','79'),
      T_TIPO_DATA('04','42','18','91'),
      T_TIPO_DATA('04','43','18','91'),
      T_TIPO_DATA('04','44','18','91'),
      T_TIPO_DATA('04','45','18','91'),
      T_TIPO_DATA('04','46','18','91'),
      T_TIPO_DATA('04','47','18','91'),
      T_TIPO_DATA('05','48','18','91'),
      T_TIPO_DATA('05','49','18','91'),
      T_TIPO_DATA('05','50','18','91'),
      T_TIPO_DATA('05','51','18','91'),
      T_TIPO_DATA('05','52','18','91'),
      T_TIPO_DATA('05','53','18','91'),
      T_TIPO_DATA('06','56','13','55'),
      T_TIPO_DATA('06','55','13','55'),
      T_TIPO_DATA('07','130','15','80'),
      T_TIPO_DATA('07','131','15','80'),
      T_TIPO_DATA('07','132','15','79'),
      T_TIPO_DATA('07','133','15','79'),
      T_TIPO_DATA('07','134','15','79'),
      T_TIPO_DATA('07','135','14','57'),
      T_TIPO_DATA('07','136','14','63'),
      T_TIPO_DATA('07','137','14','57'),
      T_TIPO_DATA('07','138','15','84'),
      T_TIPO_DATA('07','139','18','91'),
      T_TIPO_DATA('07','140','18','91'),
      T_TIPO_DATA('07','141','14','63'),
      T_TIPO_DATA('07','142','14','57'),
      T_TIPO_DATA('07','143','14','68'),
      T_TIPO_DATA('07','144','11','52'),
      T_TIPO_DATA('07','145','14','57')
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
					WHERE DD_STR_ID = (SELECT DD_STR_ID FROM DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND DD_TTR_ID = (SELECT DD_TTR_ID FROM DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')) 
          AND DD_STG_ID = (SELECT DD_STG_ID FROM DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''' AND DD_TGA_ID = (SELECT DD_TGA_ID FROM DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''')) AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(2))||''' y '''||TRIM(V_TMP_TIPO_DATA(4))||''' ya existe');
        ELSE
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                SGT_ID
                , DD_STR_ID
                , DD_STG_ID
                , USUARIOCREAR
                , FECHACREAR
              ) 
              SELECT 
                '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
                , STR.DD_STR_ID
                , STG.DD_STG_ID
                , ''HREOS-10742''
                , SYSDATE
              FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR
              JOIN '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR ON TTR.DD_TTR_ID = STR.DD_STR_ID
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
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(2))||''' y '''||TRIM(V_TMP_TIPO_DATA(4))||'''');

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
