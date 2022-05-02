--/*
--######################################### 
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10958
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar fechas cédulas de habitabilidad
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_ADO_ADMISION_DOCUMENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-10958';
    V_CODIGO_HABITABILIDAD VARCHAR2(32 CHAR) := '13';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            --ID_HAYA/NUM_ACTIVO            Dato REM            Dato a incluir en REM           0-EMISION/1-CADUCIDAD
        T_TIPO_DATA('6812126',              '20270424',         '20070424',                     '0'),
        T_TIPO_DATA('7096880',              '20210424',         '20210422',                     '0'),
        T_TIPO_DATA('7386535',              '20211027',         '20201027',                     '0'),
        T_TIPO_DATA('7246469',              '20210914',         '20111213',                     '0'),
        T_TIPO_DATA('5959304',              '20200316',         '20100316',                     '0'),
        T_TIPO_DATA('7299675',              '20371231',         '20211109',                     '0'),
        T_TIPO_DATA('6812126',              '20270424',         '20070424',                     '0'),

        T_TIPO_DATA('6831749',              '20350915',         '20360915',                     '1'),
        T_TIPO_DATA('7096880',              '20360424',         '20360422',                     '1'),
        T_TIPO_DATA('7268927',              '20210723',         '20360723',                     '1'),
        T_TIPO_DATA('7294365',              '20211029',         '20361029',                     '1'),
        T_TIPO_DATA('7310801',              '20351014',         '20361014',                     '1'),
        T_TIPO_DATA('7299675',              '20211109',         '20371231',                     '1'),
        T_TIPO_DATA('7492556',              '20210630',         '20360630',                     '1')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a updatear.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO aa
                         WHERE aa.ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(1))||'
                         AND aa.BORRADO= 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
        -- Si existe se modifica.
        IF V_NUM_TABLAS > 0 THEN
                -- Si es 0 se modifica ADO_FECHA_EMISION
                IF V_TMP_TIPO_DATA(4) = 0 THEN				
                        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO  ACT_NUM '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
                        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' 
                                    SET ADO_FECHA_EMISION = TO_DATE('''|| TRIM(V_TMP_TIPO_DATA(3)) ||''',''yyyymmdd'')
                                        , USUARIOMODIFICAR = '''||V_USUARIO||''' 
                                        , FECHAMODIFICAR = SYSDATE '||
                                    'WHERE ADO_ID IN ( SELECT
                                            ado.ADO_ID
                                        FROM
                                            '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' ado
                                            JOIN '|| V_ESQUEMA ||'.act_activo aa ON aa.act_id = ado.act_id
                                            JOIN '|| V_ESQUEMA ||'.act_cfd_config_documento cfd ON cfd.cfd_ID = ado.cfd_id
                                            JOIN '|| V_ESQUEMA ||'.DD_TPD_TIPO_DOCUMENTO tpd ON tpd.DD_TPD_ID = cfd.DD_TPD_ID
                                        WHERE
                                            aa.act_num_activo = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
                                        AND tpd.DD_TPD_CODIGO = '''|| V_CODIGO_HABITABILIDAD ||'''
                                        AND aa.BORRADO= 0)
                                        AND ADO_FECHA_EMISION = TO_DATE('''|| TRIM(V_TMP_TIPO_DATA(2)) ||''',''yyyymmdd'')
                                        AND BORRADO = 0';
                        EXECUTE IMMEDIATE V_MSQL;
                        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE ADO_FECHA_EMISION');
                ELSE
                        -- Si es 0 se modifica ADO_FECHA_CADUCIDAD
                        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO  ACT_NUM '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
                        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'
                                    SET ADO_FECHA_CADUCIDAD = TO_DATE('''|| TRIM(V_TMP_TIPO_DATA(3)) ||''',''yyyymmdd'')
                                        , USUARIOMODIFICAR = '''||V_USUARIO||''' 
                                        , FECHAMODIFICAR = SYSDATE '||
                                  'WHERE ADO_ID IN ( SELECT
                                            ado.ADO_ID
                                        FROM
                                            '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' ado
                                            JOIN '|| V_ESQUEMA ||'.act_activo aa ON aa.act_id = ado.act_id
                                            JOIN '|| V_ESQUEMA ||'.act_cfd_config_documento cfd ON cfd.cfd_ID = ado.cfd_id
                                            JOIN '|| V_ESQUEMA ||'.DD_TPD_TIPO_DOCUMENTO tpd ON tpd.DD_TPD_ID = cfd.DD_TPD_ID
                                        WHERE
                                            aa.act_num_activo = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
                                        AND tpd.DD_TPD_CODIGO = '''|| V_CODIGO_HABITABILIDAD ||'''
                                        AND aa.BORRADO= 0)
                                        AND ADO_FECHA_CADUCIDAD = TO_DATE('''|| TRIM(V_TMP_TIPO_DATA(2)) ||''',''yyyymmdd'')
                                        AND BORRADO = 0';
                        EXECUTE IMMEDIATE V_MSQL;
                        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE ADO_FECHA_CADUCIDAD');
                END IF;
       ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL REGISTRO CON ACT_NUM:  '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
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
