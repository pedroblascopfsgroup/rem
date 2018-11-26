--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2625
--## PRODUCTO=NO
--##
--## Finalidad: Script para borrar migradas desde ACT_HEP_HIST_EST_PUBLICACION que no son correctas
--## VERSIONES:
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_ESQUEMA   VARCHAR2(50 CHAR) := 'REM01';
    V_MSQL      VARCHAR2(32000 CHAR);
    SOURCE_DATA VARCHAR2(3 CHAR) := 'ACT';
    DATA_SOURCE VARCHAR2(32000 CHAR);

BEGIN   

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('  BORRADO LOGICO DE MIGRADAS PARA VENTA');
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET 
                    USUARIOBORRAR = ''REMVIP-2625'', 
                    FECHABORRAR = SYSDATE, 
                    BORRADO = 1 
                    WHERE AHP_ID IN   (WITH ACTIVOS_MOFIDICADOS AS (
                                       SELECT * 
                                       FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP 
                                       WHERE USUARIOCREAR = ''REMVIP-2625''
                                    )
                                    SELECT T1.AHP_ID 
                                    FROM ACTIVOS_MOFIDICADOS            T1
                                    JOIN '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T2
                                    ON T1.ACT_ID = T2.ACT_ID
                                    AND TRUNC(T1.AHP_FECHA_INI_VENTA) = TRUNC(T2.AHP_FECHA_INI_VENTA)
                                    AND T2.AHP_FECHA_FIN_VENTA IS NULL)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE(' REGISTROS BORRADOS: '||SQL%ROWCOUNT);

    DBMS_OUTPUT.PUT_LINE('  BORRADO LOGICO DE MIGRADAS PARA ALQUILER');
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET 
                    USUARIOBORRAR = ''REMVIP-2625'', 
                    FECHABORRAR = SYSDATE, 
                    BORRADO = 1 
                    WHERE AHP_ID IN   (WITH ACTIVOS_MOFIDICADOS AS (
                                       SELECT * 
                                       FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP 
                                       WHERE USUARIOCREAR = ''REMVIP-2625''
                                    )
                                    SELECT T1.AHP_ID 
                                    FROM ACTIVOS_MOFIDICADOS            T1
                                    JOIN '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T2
                                    ON T1.ACT_ID = T2.ACT_ID
                                    AND TRUNC(T1.AHP_FECHA_INI_ALQUILER) = TRUNC(T2.AHP_FECHA_INI_ALQUILER)
                                    AND T2.AHP_FECHA_FIN_ALQUILER IS NULL)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE(' REGISTROS BORRADOS: '||SQL%ROWCOUNT);
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
            
    COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(SQLERRM);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;          
END;
/
EXIT
