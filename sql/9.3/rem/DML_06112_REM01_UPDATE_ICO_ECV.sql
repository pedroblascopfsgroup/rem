--/*
--#########################################
--## AUTOR=Jesus Jativa
--## FECHA_CREACION=20220620
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11525
--## PRODUCTO=NO
--##
--## INSTRUCCIONES:
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
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-11525';

	MUY_BUENO VARCHAR2(5 CHAR) := '01';
    BUENO VARCHAR2(5 CHAR) := '02';
    REGULAR VARCHAR2(5 CHAR) := '03';
    MALO VARCHAR2(5 CHAR) := '04';
    MUY_MALO VARCHAR2(5 CHAR) := '999';
    A_ESTRENAR VARCHAR2(5 CHAR) := '05';
    A_REFORMAR VARCHAR2(5 CHAR) := '07';
    BUEN_ESTADO VARCHAR2(5 CHAR) := '06';


BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE ESTADO CONSERVACION ICO');

                   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO USING
                                                       (select ico.ico_id, ecv.dd_ecv_codigo from '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ico
                                                       join '||V_ESQUEMA||'.dd_ecv_estado_conservacion ecv on ico.dd_ecv_id = ecv.dd_ecv_id
                                                       where ico.dd_ecv_id is not null
                                                       AND ecv.dd_ecv_codigo IN ('''||MALO||''','''||BUENO||''','''||MUY_BUENO||''','''||REGULAR||''')
                                                       ) AUX
                                                       ON (AUX.ico_id = ico.ico_id)
                                                       WHEN MATCHED THEN UPDATE SET
                                                       ICO.dd_ecv_id = (
                                                       case
                                                       when (AUX.dd_ecv_codigo = '''||MALO||''')
                                                       then (SELECT DD_ECV_ID FROM '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION WHERE DD_ECV_CODIGO = '''||A_REFORMAR||''')
                                                       when (AUX.dd_ecv_codigo = '''||BUENO||''')
                                                       then (SELECT DD_ECV_ID FROM '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION WHERE DD_ECV_CODIGO = '''||BUEN_ESTADO||''')
                                                       when (AUX.dd_ecv_codigo = '''||MUY_BUENO||''')
                                                       then (SELECT DD_ECV_ID FROM '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION WHERE DD_ECV_CODIGO = '''||BUEN_ESTADO||''')
                                                       when (AUX.dd_ecv_codigo = '''||REGULAR||''')
                                                       then (SELECT DD_ECV_ID FROM '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION WHERE DD_ECV_CODIGO = '''||BUEN_ESTADO||''')
                                                       end
                                                       ),
                                                       ico.usuariomodificar = '''||V_USUARIO||''',
                                                       ico.fechamodificar = sysdate';

            EXECUTE IMMEDIATE V_MSQL ;



            COMMIT;
            DBMS_OUTPUT.PUT_LINE('[FIN] ICO ECV ACTUALIZADADO CORRECTAMENTE ');
            DBMS_OUTPUT.PUT_LINE('[FIN]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS ');




          DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO LOGICO ESTADO CONSERVACION ICO');



                                V_MSQL := 'update '||V_ESQUEMA||'.dd_ecv_estado_conservacion
                                              set borrado = 1,
                                                  usuarioborrar = '''||V_USUARIO||''',
                                                  fechaborrar = sysdate
                                            where dd_ecv_codigo IN ('''||MALO||''','''||BUENO||''','''||MUY_BUENO||''','''||REGULAR||''')';
                                EXECUTE IMMEDIATE V_MSQL;


          EXECUTE IMMEDIATE V_MSQL ;

            COMMIT;
            DBMS_OUTPUT.PUT_LINE('[FIN] ICO ECV BORRADOS CORRECTAMENTE ');
            DBMS_OUTPUT.PUT_LINE('[FIN]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS ');



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