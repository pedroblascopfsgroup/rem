--/*
--##########################################
--## AUTOR=Adrián Molina Garrido
--## FECHA_CREACION=20200410
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6933
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


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

    V_TABLA VARCHAR2(30 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL';  -- Tabla a modificar
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6933'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

		DBMS_OUTPUT.PUT_LINE('[INICIO]');

        V_MSQL :=   'MERGE INTO REM01.ACT_ACTIVO T1
                     USING (
                         SELECT AUX.ACT_NUM_ACTIVO, TAL.DD_TAL_ID FROM REM01.AUX_REMVIP_6933 AUX
                         LEFT JOIN DD_TAL_TIPO_ALQUILER TAL ON TAL.DD_TAL_DESCRIPCION = AUX.TIPO_ALQUILER
                     ) T2
                     ON (T1.ACT_NUM_ACTIVO = T2.ACT_NUM_ACTIVO)
                     WHEN MATCHED THEN UPDATE SET
                         T1.DD_TAL_ID = T2.DD_TAL_ID,
                         T1.USUARIOMODIFICAR = ''REMVIP-6933'',
                         T1.FECHAMODIFICAR = SYSDATE';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' registros actualizados en la act_activo');

        V_MSQL :=   'MERGE INTO REM01.ACT_PTA_PATRIMONIO_ACTIVO T1
                     USING (
                         SELECT ACT.ACT_ID, CDU.DD_CDU_ID,
                             CASE WHEN AUX.ALQUILER_SOCIAL = ''SI'' THEN 1
                                 ELSE 0
                             END ALQUILER_SOCIAL
                         FROM REM01.AUX_REMVIP_6933 AUX
                         LEFT JOIN REM01.DD_CDU_CESION_USO CDU ON CDU.DD_CDU_DESCRIPCION = AUX.CESION_USO
                         LEFT JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
                     ) T2
                     ON (T1.ACT_ID = T2.ACT_ID)
                     WHEN MATCHED THEN UPDATE SET
                         T1.DD_CDU_ID = T2.DD_CDU_ID,
                         T1.PTA_TRAMITE_ALQ_SOCIAL = T2.ALQUILER_SOCIAL,
                         T1.USUARIOMODIFICAR = ''REMVIP-6933'',
                         T1.FECHAMODIFICAR = SYSDATE';

                EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' registros actualizados en la act_pta_patrimonio_activo');

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;

END;

/

EXIT
