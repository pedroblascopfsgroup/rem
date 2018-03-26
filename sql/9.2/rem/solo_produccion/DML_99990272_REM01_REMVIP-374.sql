--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180326
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-374
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Cañonazo anular expediente comercial');
    
	/*
Anular tarea de resolución de expediente y también de resultado de PBC. expediente 94722
*/

MERGE INTO REM01.TAR_TAREAS_NOTIFICACIONES T1
USING (SELECT DISTINCT TAR.TAR_ID
    FROM REM01.TAC_TAREAS_ACTIVOS TAC
    JOIN REM01.ACT_ACTIVO ACT ON TAC.ACT_ID = ACT.ACT_ID
    JOIN REM01.ACT_TRA_TRAMITE TRA ON TRA.TRA_ID = TAC.TRA_ID
    JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
    JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.TBJ_ID = TRA.TBJ_ID
    JOIN REM01.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
    JOIN REM01.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_CODIGO = '02'
    JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_CODIGO = '02'
    JOIN REMMASTER.DD_EPR_ESTADO_PROCEDIMIENTO EPR ON EPR.DD_EPR_CODIGO = '05'
    WHERE ECO.ECO_NUM_EXPEDIENTE = 94722
    AND TAR.TAR_TAREA IN ('Resultado PBC','Resolución expediente')
    ) T2
ON (T1.TAR_ID = T2.TAR_ID)
WHEN MATCHED THEN UPDATE SET
    T1.TAR_TAREA_FINALIZADA = 1, T1.TAR_FECHA_FIN = SYSDATE, T1.BORRADO = 1
    , T1.USUARIOMODIFICAR = 'REMVIP-374', T1.FECHAMODIFICAR = SYSDATE;
        
	COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
