--/*
--######################################### 
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=202200307
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11299
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
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CRG_CARGAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-11299';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                   --ID_CARGA    Estado Carga/DD_ECG_DESCRIPCION   
        T_TIPO_DATA('31257619','03'),
        T_TIPO_DATA('9492405','03'),
        T_TIPO_DATA('9495345','03'),
        T_TIPO_DATA('9499930','03'),
        T_TIPO_DATA('26201234','03'),
        T_TIPO_DATA('9502878','03'),
        T_TIPO_DATA('20171909','03'),
        T_TIPO_DATA('19803687','03'),
        T_TIPO_DATA('9494522','03'),
        T_TIPO_DATA('26201230','03'),
        T_TIPO_DATA('26201229','03'),
        T_TIPO_DATA('30924714','03'),
        T_TIPO_DATA('9494003','03'),
        T_TIPO_DATA('19163105','03'),
        T_TIPO_DATA('30898921','03'),
        T_TIPO_DATA('31616758','03'),
        T_TIPO_DATA('9493469','03'),
        T_TIPO_DATA('30898918','03'),
        T_TIPO_DATA('9501548','03'),
        T_TIPO_DATA('9494351','03'),
        T_TIPO_DATA('9499237','03'),
        T_TIPO_DATA('19162717','03'),
        T_TIPO_DATA('9494727','03'),
        T_TIPO_DATA('15234470','03'),
        T_TIPO_DATA('34528129','03'),
        T_TIPO_DATA('15234514','03'),
        T_TIPO_DATA('15234517','03'),
        T_TIPO_DATA('15234572','03'),
        T_TIPO_DATA('9499070','03'),
        T_TIPO_DATA('9499776','03'),
        T_TIPO_DATA('9499774','03'),
        T_TIPO_DATA('28080715','03'),
        T_TIPO_DATA('26369573','03'),
        T_TIPO_DATA('20225694','03'),
        T_TIPO_DATA('9503193','03'),
        T_TIPO_DATA('20561831','03'),
        T_TIPO_DATA('9499869','03'),
        T_TIPO_DATA('20098217','03'),
        T_TIPO_DATA('29856554','03'),
        T_TIPO_DATA('13275370','03'),
        T_TIPO_DATA('14444840','03'),
        T_TIPO_DATA('14488384','03'),
        T_TIPO_DATA('25508976','03'),
        T_TIPO_DATA('20353145','03'),
        T_TIPO_DATA('18819963','03'),
        T_TIPO_DATA('20407058','03'),
        T_TIPO_DATA('26513664','03'),
        T_TIPO_DATA('18951132','03'),
        T_TIPO_DATA('18951131','03'),
        T_TIPO_DATA('27806497','03'),
        T_TIPO_DATA('27806498','03'),
        T_TIPO_DATA('20407081','03'),
        T_TIPO_DATA('21539378','03'),
        T_TIPO_DATA('21707527','03'),
        T_TIPO_DATA('20824853','03'),
        T_TIPO_DATA('20824850','03'),
        T_TIPO_DATA('24064019','03'),
        T_TIPO_DATA('25509070','03'),
        T_TIPO_DATA('26562633','03'),
        T_TIPO_DATA('34296692','03'),
        T_TIPO_DATA('34296694','03'),
        T_TIPO_DATA('35191837','03'),
        T_TIPO_DATA('36416610','03'),
        T_TIPO_DATA('36416611','03'),
        T_TIPO_DATA('36416608','03'),
        T_TIPO_DATA('37648237','03'),
        T_TIPO_DATA('39438613','03')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a updatear.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' acc
                         WHERE acc.CRG_ID = '||TRIM(V_TMP_TIPO_DATA(1))||'
                         AND acc.BORRADO= 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
        -- Si existe se modifica.
        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAD EL REGISTRO  CRG_ID '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' CON ESTADO DE CARGA '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'');
            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' 
                        SET USUARIOMODIFICAR = '''||V_USUARIO||''' 
                            , FECHAMODIFICAR = SYSDATE '||
                           ', DD_ECG_ID = (SELECT ecg.DD_ECG_ID
                                            FROM '||V_ESQUEMA||'.DD_ECG_ESTADO_CARGA ecg
                                    WHERE ecg.DD_ECG_CODIGO = '||TRIM(V_TMP_TIPO_DATA(2))||'
                                    AND ecg.BORRADO= 0) 
                        WHERE CRG_ID =  '||TRIM(V_TMP_TIPO_DATA(1))||'
                            AND BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE EN ACT_CRG_CARGAS');
       ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL REGISTRO CON CRG_ID:  '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
       END IF;
      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

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
