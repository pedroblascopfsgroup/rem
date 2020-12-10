--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8484
--## PRODUCTO=NO
--##
--## Finalidad: Modificar fecha fin por fechaborrar, falla en procesos
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8484'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL :=   'MERGE INTO '||V_ESQUEMA||'.ACT_VAL_VALORACIONES T1 USING (
                    SELECT VAL_ID, FECHABORRAR FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES WHERE VAL_ID IN(
                    132870985,96368751,163777329,132870833,124669943,86431304,149305521,132870377,176267068,
                    90440554,114430492,113402365,96716441,213257059,82900,132869846,163777704,143145227)) T2
                    ON (T1.VAL_ID = T2.VAL_ID)
                    WHEN MATCHED THEN UPDATE
                    SET T1.VAL_FECHA_FIN = T2.FECHABORRAR,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
                    T1.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADAS '||SQL%ROWCOUNT||' FILAS');  

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
