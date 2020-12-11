--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201207
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8456
--## PRODUCTO=NO
--##
--## Finalidad: Eliminar relación gasto/activo borrado
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
    V_TABLA VARCHAR( 100 CHAR ) := 'GPV_ACT';
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8456'; -- USUARIOCREAR/USUARIOMODIFICAR

    V_GASTO NUMBER(25):= 12197722;
    V_COUNT NUMBER(16);

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINAR CONFLICTO GASTO/ACTIVO BORRADOS');

    V_MSQL := 'SELECT COUNT(ACT.ACT_ID) FROM '||V_ESQUEMA||'.'||V_TABLA||' GACT
                INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GACT.GPV_ID
                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GACT.ACT_ID AND ACT.BORRADO = 1
                WHERE GPV.BORRADO = 0 AND GPV.GPV_NUM_GASTO_HAYA = '||V_GASTO||'';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT > 0 THEN

        V_MSQL :=   'DELETE '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_ID IN (
                        SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' GACT
                        INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GACT.GPV_ID
                        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GACT.ACT_ID AND ACT.BORRADO = 1
                        WHERE GPV.BORRADO = 0 AND GPV.GPV_NUM_GASTO_HAYA = '||V_GASTO||')';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS '||SQL%ROWCOUNT||' ACTIVOS RELACIONADOS CONFLICTIVOS');  

    ELSE 

        DBMS_OUTPUT.PUT_LINE('[INFO] EL GASTO '||V_GASTO||' NO TIENE ACTIVOS CONFLICTIVOS'); 

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
