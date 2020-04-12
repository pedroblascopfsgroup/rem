--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200412
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-6942
--## PRODUCTO=NO
--## 
--## Finalidad: Borrado de tareas de ofertas anuladas y expedientes anulados/denegados
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
BEGIN


                DBMS_OUTPUT.PUT_LINE('[INFO] Merge TAR_TAREAS_NOTIFICACIONES...Finalizar tareas expedientes anulados');
                EXECUTE IMMEDIATE 'MERGE INTO TAR_TAREAS_NOTIFICACIONES TAB USING (
                    SELECT DISTINCT TAR.TAR_ID
                    FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
                    INNER JOIN '||V_ESQUEMA||'.tac_tareas_activos tac
                    on tac.tar_id = tar.tar_id
                    INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA
                    ON TAC.TRA_ID = TRA.TRA_ID
                    INNER JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
                    ON TBJ.TBJ_ID = TRA.TBJ_ID
                    INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
                    ON ECO.TBJ_ID = TBJ.TBJ_ID
                    INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR
                    ON OFR.OFR_ID = ECO.OFR_ID
                    WHERE OFR.USUARIOCREAR = ''MIG_DIVARIAN''
                    AND OFR.DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.dd_eof_estados_oferta WHERE DD_EOF_CODIGO = ''02'')--ANULADA/DENAGADA
                    AND ECO.DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.dd_eec_est_exp_comercial WHERE DD_EEC_ID = ''02'')--ANULADO
                ) TMP
                ON (TMP.TAR_ID = TAB.TAR_ID)
                WHEN MATCHED THEN UPDATE SET
                TAB.TAR_TAREA_FINALIZADA = 1,
                TAB.TAR_FECHA_FIN = SYSDATE,
                TAB.USUARIOBORRAR = ''REMVIP-6942'',
                TAB.FECHABORRAR = SYSDATE,
                TAB.BORRADO = 1
                ';
                DBMS_OUTPUT.PUT_LINE('      [INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Merge TAR_TAREAS_NOTIFICACIONES. Finalizar tareas de expedientes anulados OK. '||SQL%ROWCOUNT||' Filas.');
                COMMIT;


                -- Merge 3, finalizamos tareas:
                DBMS_OUTPUT.PUT_LINE('[INFO] Merge TAR_TAREAS_NOTIFICACIONES...Finalizar tareas expedientes denegados');
                EXECUTE IMMEDIATE 'MERGE INTO TAR_TAREAS_NOTIFICACIONES TAB USING (
                    SELECT DISTINCT TAR.TAR_ID 
                    FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
                    INNER JOIN '||V_ESQUEMA||'.tac_tareas_activos tac
                    on tac.tar_id = tar.tar_id
                    INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA
                    ON TAC.TRA_ID = TRA.TRA_ID
                    INNER JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
                    ON TBJ.TBJ_ID = TRA.TBJ_ID
                    INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
                    ON ECO.TBJ_ID = TBJ.TBJ_ID
                    INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR
                    ON OFR.OFR_ID = ECO.OFR_ID
                    WHERE OFR.USUARIOCREAR = ''MIG_DIVARIAN''
                    AND OFR.DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.dd_eof_estados_oferta WHERE DD_EOF_CODIGO = ''02'')--ANULADA/DENAGADA
                    AND ECO.DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.dd_eec_est_exp_comercial WHERE DD_EEC_ID = ''12'')--DENEGADO
                ) TMP
                ON (TMP.TAR_ID = TAB.TAR_ID)
                WHEN MATCHED THEN UPDATE SET
                TAB.TAR_TAREA_FINALIZADA = 1,
                TAB.TAR_FECHA_FIN = SYSDATE,
                TAB.USUARIOBORRAR = ''REMVIP-6942'',
                TAB.FECHABORRAR = SYSDATE,
                TAB.BORRADO = 1
                ';
                DBMS_OUTPUT.PUT_LINE('      [INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Merge TAR_TAREAS_NOTIFICACIONES. Finalizar tareas de expedientes denegados OK. '||SQL%ROWCOUNT||' Filas.');
                COMMIT;


    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
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
