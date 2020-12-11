--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8425
--## PRODUCTO=NO
--##
--## Finalidad: Eliminar relación activos borrados
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
    V_TABLA VARCHAR( 100 CHAR ) := 'ACT_AGA_AGRUPACION_ACTIVO';
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8425'; -- USUARIOCREAR/USUARIOMODIFICAR

    V_AGRUPACION NUMBER(25):= 1000017015;
    V_AGR_ID NUMBER(16) := 0;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINAR CONFLICTO AGRUPACION/ACTIVOS BORRADOS');

    V_MSQL := 'SELECT AGR_ID FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE AGR_NUM_AGRUP_REM = '||V_AGRUPACION||' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_AGR_ID;

    IF V_AGR_ID != 0 THEN

        V_MSQL :=   'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 USING(
                        SELECT AGA.AGA_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' AGA 
                        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID AND ACT.BORRADO = 1
                        WHERE AGA.AGR_ID = '||V_AGR_ID||') T2
                    ON (T1.AGA_ID = T2.AGA_ID)
                    WHEN MATCHED THEN UPDATE SET
                    T1.BORRADO = 1,		     
                    T1.FECHABORRAR = SYSDATE,
                    T1.USUARIOBORRAR = '''||V_USUARIO||'''';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS '||SQL%ROWCOUNT||' ACTIVOS RELACIONADOS CONFLICTIVOS');  

    ELSE 

        DBMS_OUTPUT.PUT_LINE('[INFO] LA AGRUPACION '||V_AGRUPACION||' NO EXISTE O HA SIDO BORRADA'); 

    END IF;

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
