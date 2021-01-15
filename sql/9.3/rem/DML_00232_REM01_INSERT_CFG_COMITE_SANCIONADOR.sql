--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200712
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11161
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
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'CFG_COMITE_SANCIONADOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('01','02','01','01'),
      T_TIPO_DATA('01','02','01','02'),
      T_TIPO_DATA('01','02','01','03'),
      T_TIPO_DATA('01','02','01','04'),
      T_TIPO_DATA('01','02','01','05'),
      T_TIPO_DATA('01','02','01','06'),
      T_TIPO_DATA('01','02','01','07'),
      T_TIPO_DATA('01','02','02','13'),
      T_TIPO_DATA('01','02','02','14'),
      T_TIPO_DATA('01','02','02','15'),
      T_TIPO_DATA('01','02','02','16'),
      T_TIPO_DATA('01','02','02','17'),
      T_TIPO_DATA('01','02','02','18'),
      T_TIPO_DATA('01','02','02','19'),
      T_TIPO_DATA('01','02','02','20'),
      T_TIPO_DATA('01','02','02','21'),
      T_TIPO_DATA('01','02','02','22'),
      T_TIPO_DATA('01','02','02','23'),
      T_TIPO_DATA('01','02','02','24'),
      T_TIPO_DATA('01','02','02','25'),
      T_TIPO_DATA('01','02','03','ACO'),
      T_TIPO_DATA('01','02','03','FOT'),
      T_TIPO_DATA('01','02','03','INT'),
      T_TIPO_DATA('01','02','03','PAQ'),
      T_TIPO_DATA('01','02','03','RAN'),
      T_TIPO_DATA('01','02','03','SIN'),
      T_TIPO_DATA('01','02','03','VAL'),
      T_TIPO_DATA('01','02','03','100'),
      T_TIPO_DATA('01','02','03','101'),
      T_TIPO_DATA('01','02','03','102'),
      T_TIPO_DATA('01','02','03','103'),
      T_TIPO_DATA('01','02','03','104'),
      T_TIPO_DATA('01','02','03','105'),
      T_TIPO_DATA('01','02','03','106'),
      T_TIPO_DATA('01','02','03','107'),
      T_TIPO_DATA('01','02','03','108'),
      T_TIPO_DATA('01','02','03','109'),
      T_TIPO_DATA('01','02','03','110'),
      T_TIPO_DATA('01','02','03','111'),
      T_TIPO_DATA('01','02','03','112'),
      T_TIPO_DATA('01','02','03','113'),
      T_TIPO_DATA('01','02','03','114'),
      T_TIPO_DATA('01','02','03','115'),
      T_TIPO_DATA('01','02','03','116'),
      T_TIPO_DATA('01','02','03','117'),
      T_TIPO_DATA('01','02','03','118'),
      T_TIPO_DATA('01','02','03','119'),
      T_TIPO_DATA('01','02','03','120'),
      T_TIPO_DATA('01','02','03','121'),
      T_TIPO_DATA('01','02','03','122'),
      T_TIPO_DATA('01','02','03','123'),
      T_TIPO_DATA('01','02','03','124'),
      T_TIPO_DATA('01','02','03','125'),
      T_TIPO_DATA('01','02','03','126'),
      T_TIPO_DATA('01','02','03','127'),
      T_TIPO_DATA('01','02','03','128'),
      T_TIPO_DATA('01','02','03','129'),
      T_TIPO_DATA('01','02','03','26'),
      T_TIPO_DATA('01','02','03','27'),
      T_TIPO_DATA('01','02','03','28'),
      T_TIPO_DATA('01','02','03','29'),
      T_TIPO_DATA('01','02','03','30'),
      T_TIPO_DATA('01','02','03','31'),
      T_TIPO_DATA('01','02','03','32'),
      T_TIPO_DATA('01','02','03','33'),
      T_TIPO_DATA('01','02','03','34'),
      T_TIPO_DATA('01','02','03','35'),
      T_TIPO_DATA('01','02','03','36'),
      T_TIPO_DATA('01','02','03','37'),
      T_TIPO_DATA('01','02','03','38'),
      T_TIPO_DATA('01','02','03','39'),
      T_TIPO_DATA('01','02','03','40'),
      T_TIPO_DATA('01','02','03','41'),
      T_TIPO_DATA('01','02','03','57'),
      T_TIPO_DATA('01','02','03','58'),
      T_TIPO_DATA('01','02','03','59'),
      T_TIPO_DATA('01','02','03','60'),
      T_TIPO_DATA('01','02','03','61'),
      T_TIPO_DATA('01','02','03','62'),
      T_TIPO_DATA('01','02','03','63'),
      T_TIPO_DATA('01','02','03','64'),
      T_TIPO_DATA('01','02','03','65'),
      T_TIPO_DATA('01','02','03','66'),
      T_TIPO_DATA('01','02','03','67'),
      T_TIPO_DATA('01','02','03','68'),
      T_TIPO_DATA('01','02','03','69'),
      T_TIPO_DATA('01','02','03','70'),
      T_TIPO_DATA('01','02','03','71'),
      T_TIPO_DATA('01','02','03','72'),
      T_TIPO_DATA('01','02','03','73'),
      T_TIPO_DATA('01','02','04','42'),
      T_TIPO_DATA('01','02','04','43'),
      T_TIPO_DATA('01','02','04','44'),
      T_TIPO_DATA('01','02','04','45'),
      T_TIPO_DATA('01','02','04','46'),
      T_TIPO_DATA('01','02','04','47'),
      T_TIPO_DATA('01','02','05','48'),
      T_TIPO_DATA('01','02','05','49'),
      T_TIPO_DATA('01','02','05','50'),
      T_TIPO_DATA('01','02','05','51'),
      T_TIPO_DATA('01','02','05','52'),
      T_TIPO_DATA('01','02','05','53'),
      T_TIPO_DATA('01','02','06','55'),
      T_TIPO_DATA('01','02','06','56'),
      T_TIPO_DATA('01','02','07','130'),
      T_TIPO_DATA('01','02','07','131'),
      T_TIPO_DATA('01','02','07','132'),
      T_TIPO_DATA('01','02','07','133'),
      T_TIPO_DATA('01','02','07','134'),
      T_TIPO_DATA('01','02','07','135'),
      T_TIPO_DATA('01','02','07','136'),
      T_TIPO_DATA('01','02','07','137'),
      T_TIPO_DATA('01','02','07','138'),
      T_TIPO_DATA('01','02','07','139'),
      T_TIPO_DATA('01','02','07','140'),
      T_TIPO_DATA('01','02','07','141'),
      T_TIPO_DATA('01','02','07','142'),
      T_TIPO_DATA('01','02','07','143'),
      T_TIPO_DATA('01','02','07','144'),
      T_TIPO_DATA('01','02','07','145'),
      T_TIPO_DATA('01','01','01','01'),
      T_TIPO_DATA('01','01','01','02'),
      T_TIPO_DATA('01','01','01','03'),
      T_TIPO_DATA('01','01','01','04'),
      T_TIPO_DATA('01','01','01','05'),
      T_TIPO_DATA('01','01','01','06'),
      T_TIPO_DATA('01','01','01','07'),
      T_TIPO_DATA('01','01','02','13'),
      T_TIPO_DATA('01','01','02','14'),
      T_TIPO_DATA('01','01','02','15'),
      T_TIPO_DATA('01','01','02','16'),
      T_TIPO_DATA('01','01','02','17'),
      T_TIPO_DATA('01','01','02','18'),
      T_TIPO_DATA('01','01','02','19'),
      T_TIPO_DATA('01','01','02','20'),
      T_TIPO_DATA('01','01','02','21'),
      T_TIPO_DATA('01','01','02','22'),
      T_TIPO_DATA('01','01','02','23'),
      T_TIPO_DATA('01','01','02','24'),
      T_TIPO_DATA('01','01','02','25'),
      T_TIPO_DATA('01','01','03','ACO'),
      T_TIPO_DATA('01','01','03','FOT'),
      T_TIPO_DATA('01','01','03','INT'),
      T_TIPO_DATA('01','01','03','PAQ'),
      T_TIPO_DATA('01','01','03','RAN'),
      T_TIPO_DATA('01','01','03','SIN'),
      T_TIPO_DATA('01','01','03','VAL'),
      T_TIPO_DATA('01','01','03','100'),
      T_TIPO_DATA('01','01','03','101'),
      T_TIPO_DATA('01','01','03','102'),
      T_TIPO_DATA('01','01','03','103'),
      T_TIPO_DATA('01','01','03','104'),
      T_TIPO_DATA('01','01','03','105'),
      T_TIPO_DATA('01','01','03','106'),
      T_TIPO_DATA('01','01','03','107'),
      T_TIPO_DATA('01','01','03','108'),
      T_TIPO_DATA('01','01','03','109'),
      T_TIPO_DATA('01','01','03','110'),
      T_TIPO_DATA('01','01','03','111'),
      T_TIPO_DATA('01','01','03','112'),
      T_TIPO_DATA('01','01','03','113'),
      T_TIPO_DATA('01','01','03','114'),
      T_TIPO_DATA('01','01','03','115'),
      T_TIPO_DATA('01','01','03','116'),
      T_TIPO_DATA('01','01','03','117'),
      T_TIPO_DATA('01','01','03','118'),
      T_TIPO_DATA('01','01','03','119'),
      T_TIPO_DATA('01','01','03','120'),
      T_TIPO_DATA('01','01','03','121'),
      T_TIPO_DATA('01','01','03','122'),
      T_TIPO_DATA('01','01','03','123'),
      T_TIPO_DATA('01','01','03','124'),
      T_TIPO_DATA('01','01','03','125'),
      T_TIPO_DATA('01','01','03','126'),
      T_TIPO_DATA('01','01','03','127'),
      T_TIPO_DATA('01','01','03','128'),
      T_TIPO_DATA('01','01','03','129'),
      T_TIPO_DATA('01','01','03','26'),
      T_TIPO_DATA('01','01','03','27'),
      T_TIPO_DATA('01','01','03','28'),
      T_TIPO_DATA('01','01','03','29'),
      T_TIPO_DATA('01','01','03','30'),
      T_TIPO_DATA('01','01','03','31'),
      T_TIPO_DATA('01','01','03','32'),
      T_TIPO_DATA('01','01','03','33'),
      T_TIPO_DATA('01','01','03','34'),
      T_TIPO_DATA('01','01','03','35'),
      T_TIPO_DATA('01','01','03','36'),
      T_TIPO_DATA('01','01','03','37'),
      T_TIPO_DATA('01','01','03','38'),
      T_TIPO_DATA('01','01','03','39'),
      T_TIPO_DATA('01','01','03','40'),
      T_TIPO_DATA('01','01','03','41'),
      T_TIPO_DATA('01','01','03','57'),
      T_TIPO_DATA('01','01','03','58'),
      T_TIPO_DATA('01','01','03','59'),
      T_TIPO_DATA('01','01','03','60'),
      T_TIPO_DATA('01','01','03','61'),
      T_TIPO_DATA('01','01','03','62'),
      T_TIPO_DATA('01','01','03','63'),
      T_TIPO_DATA('01','01','03','64'),
      T_TIPO_DATA('01','01','03','65'),
      T_TIPO_DATA('01','01','03','66'),
      T_TIPO_DATA('01','01','03','67'),
      T_TIPO_DATA('01','01','03','68'),
      T_TIPO_DATA('01','01','03','69'),
      T_TIPO_DATA('01','01','03','70'),
      T_TIPO_DATA('01','01','03','71'),
      T_TIPO_DATA('01','01','03','72'),
      T_TIPO_DATA('01','01','03','73'),
      T_TIPO_DATA('01','01','04','42'),
      T_TIPO_DATA('01','01','04','43'),
      T_TIPO_DATA('01','01','04','44'),
      T_TIPO_DATA('01','01','04','45'),
      T_TIPO_DATA('01','01','04','46'),
      T_TIPO_DATA('01','01','04','47'),
      T_TIPO_DATA('01','01','05','48'),
      T_TIPO_DATA('01','01','05','49'),
      T_TIPO_DATA('01','01','05','50'),
      T_TIPO_DATA('01','01','05','51'),
      T_TIPO_DATA('01','01','05','52'),
      T_TIPO_DATA('01','01','05','53'),
      T_TIPO_DATA('01','01','06','55'),
      T_TIPO_DATA('01','01','06','56'),
      T_TIPO_DATA('01','01','07','130'),
      T_TIPO_DATA('01','01','07','131'),
      T_TIPO_DATA('01','01','07','132'),
      T_TIPO_DATA('01','01','07','133'),
      T_TIPO_DATA('01','01','07','134'),
      T_TIPO_DATA('01','01','07','135'),
      T_TIPO_DATA('01','01','07','136'),
      T_TIPO_DATA('01','01','07','137'),
      T_TIPO_DATA('01','01','07','138'),
      T_TIPO_DATA('01','01','07','139'),
      T_TIPO_DATA('01','01','07','140'),
      T_TIPO_DATA('01','01','07','141'),
      T_TIPO_DATA('01','01','07','142'),
      T_TIPO_DATA('01','01','07','143'),
      T_TIPO_DATA('01','01','07','144'),
      T_TIPO_DATA('01','01','07','145'),
      T_TIPO_DATA('02','04','01','01'),
      T_TIPO_DATA('02','04','01','02'),
      T_TIPO_DATA('02','04','01','03'),
      T_TIPO_DATA('02','04','01','04'),
      T_TIPO_DATA('02','04','01','05'),
      T_TIPO_DATA('02','04','01','06'),
      T_TIPO_DATA('02','04','01','07'),
      T_TIPO_DATA('02','04','02','13'),
      T_TIPO_DATA('02','04','02','14'),
      T_TIPO_DATA('02','04','02','15'),
      T_TIPO_DATA('02','04','02','16'),
      T_TIPO_DATA('02','04','02','17'),
      T_TIPO_DATA('02','04','02','18'),
      T_TIPO_DATA('02','04','02','19'),
      T_TIPO_DATA('02','04','02','20'),
      T_TIPO_DATA('02','04','02','21'),
      T_TIPO_DATA('02','04','02','22'),
      T_TIPO_DATA('02','04','02','23'),
      T_TIPO_DATA('02','04','02','24'),
      T_TIPO_DATA('02','04','02','25'),
      T_TIPO_DATA('02','04','03','ACO'),
      T_TIPO_DATA('02','04','03','FOT'),
      T_TIPO_DATA('02','04','03','INT'),
      T_TIPO_DATA('02','04','03','PAQ'),
      T_TIPO_DATA('02','04','03','RAN'),
      T_TIPO_DATA('02','04','03','SIN'),
      T_TIPO_DATA('02','04','03','VAL'),
      T_TIPO_DATA('02','04','03','100'),
      T_TIPO_DATA('02','04','03','101'),
      T_TIPO_DATA('02','04','03','102'),
      T_TIPO_DATA('02','04','03','103'),
      T_TIPO_DATA('02','04','03','104'),
      T_TIPO_DATA('02','04','03','105'),
      T_TIPO_DATA('02','04','03','106'),
      T_TIPO_DATA('02','04','03','107'),
      T_TIPO_DATA('02','04','03','108'),
      T_TIPO_DATA('02','04','03','109'),
      T_TIPO_DATA('02','04','03','110'),
      T_TIPO_DATA('02','04','03','111'),
      T_TIPO_DATA('02','04','03','112'),
      T_TIPO_DATA('02','04','03','113'),
      T_TIPO_DATA('02','04','03','114'),
      T_TIPO_DATA('02','04','03','115'),
      T_TIPO_DATA('02','04','03','116'),
      T_TIPO_DATA('02','04','03','117'),
      T_TIPO_DATA('02','04','03','118'),
      T_TIPO_DATA('02','04','03','119'),
      T_TIPO_DATA('02','04','03','120'),
      T_TIPO_DATA('02','04','03','121'),
      T_TIPO_DATA('02','04','03','122'),
      T_TIPO_DATA('02','04','03','123'),
      T_TIPO_DATA('02','04','03','124'),
      T_TIPO_DATA('02','04','03','125'),
      T_TIPO_DATA('02','04','03','126'),
      T_TIPO_DATA('02','04','03','127'),
      T_TIPO_DATA('02','04','03','128'),
      T_TIPO_DATA('02','04','03','129'),
      T_TIPO_DATA('02','04','03','26'),
      T_TIPO_DATA('02','04','03','27'),
      T_TIPO_DATA('02','04','03','28'),
      T_TIPO_DATA('02','04','03','29')
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
          WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0) 
          AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND BORRADO = 0)
					AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND BORRADO = 0) 
          AND DD_STR_ID = (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''' AND BORRADO = 0)';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' ,'''||TRIM(V_TMP_TIPO_DATA(2))||''' , '''||TRIM(V_TMP_TIPO_DATA(3))||''' y '''||TRIM(V_TMP_TIPO_DATA(4))||''' ya existe');
        ELSE
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              CCS_ID,
              DD_CRA_ID,
              DD_SCR_ID,
              DD_TTR_ID,
              DD_STR_ID,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
              '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
              (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0),
              (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND BORRADO = 0),
              (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND BORRADO = 0),
              (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''' AND BORRADO = 0),
              0,
              ''HREOS-11161'',
              SYSDATE,
              0
                        )';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' , '''||TRIM(V_TMP_TIPO_DATA(2))||''' , '''||TRIM(V_TMP_TIPO_DATA(3))||''' y '''||TRIM(V_TMP_TIPO_DATA(4))||'''');

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
