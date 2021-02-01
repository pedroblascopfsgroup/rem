--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8462
--## PRODUCTO=NO
--##
--## Finalidad: Modificar estado expediente y poner tarea activa
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8462'; -- USUARIOCREAR/USUARIOMODIFICAR

    V_OFERTA NUMBER(25):= 90250525;
    V_EEC_ID NUMBER(25):= 16; --ESTADO *EN DEVOLUCION*
    V_TAR_ID NUMBER(25) := 5655733;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[MODIFICAMOS ESTADO EXPEDIENTE]');

    V_MSQL :=   'MERGE INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL T1 USING (
                    SELECT ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
                    INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
                    WHERE OFR_NUM_OFERTA = '||V_OFERTA||') T2
                    ON (T1.ECO_ID = T2.ECO_ID)
                    WHEN MATCHED THEN UPDATE
                    SET T1.DD_EEC_ID = '||V_EEC_ID||',
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
                    T1.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[MODIFICAMOS TAREA PARA ACTIVAR]');

    V_MSQL :=   'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET BORRADO = 0,
                    USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
                    WHERE TAR_ID = '||V_TAR_ID||'';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

    V_MSQL :=   'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS SET BORRADO = 0,
                    USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
                    WHERE TAR_ID = '||V_TAR_ID||'';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

    COMMIT;

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
