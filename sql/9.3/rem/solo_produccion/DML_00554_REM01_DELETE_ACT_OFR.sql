--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8424
--## PRODUCTO=NO
--##
--## Finalidad: Eliminar relación activo/oferta borrado
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
    V_TABLA VARCHAR( 100 CHAR ) := 'ACT_OFR';
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8424'; -- USUARIOCREAR/USUARIOMODIFICAR

    V_ACTIVO NUMBER(25):= 6876756;
    V_ACT_ID NUMBER(16) := 0;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINAR CONFLICTO AGRUPACION/ACTIVOS BORRADOS');

    V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_ACTIVO||' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;

    IF V_ACT_ID != 0 THEN

        V_MSQL :=   'DELETE '||V_ESQUEMA||'.'||V_TABLA||' WHERE OFR_ID IN (
                        SELECT OFR.OFR_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                        INNER JOIN '||V_ESQUEMA||'.'||V_TABLA||' AOFR ON ACT.ACT_ID = AOFR.ACT_ID 
                        INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AOFR.OFR_ID AND OFR.BORRADO = 1
                        WHERE ACT.ACT_ID = '||V_ACT_ID||')';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS '||SQL%ROWCOUNT||' ACTIVOS RELACIONADOS CONFLICTIVOS');  

    ELSE 

        DBMS_OUTPUT.PUT_LINE('[INFO] LA AGRUPACION '||V_ACTIVO||' NO EXISTE O HA SIDO BORRADA'); 

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
