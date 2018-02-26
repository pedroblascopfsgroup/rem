--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180223
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.14
--## INCIDENCIA_LINK=REMVIP-148
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

    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-130/131';
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
    
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de reposicionamiento de trámites de ofertas.');    
    DBMS_OUTPUT.PUT_LINE('');
    
    V_MSQL := 'MERGE INTO REM01.TAC_TAREAS_ACTIVOS T1
		USING (SELECT TAC.TAR_ID, TAC.TRA_ID, TAC.ACT_ID
		    FROM ACT_TRA_TRAMITE TRA
		    JOIN DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TRA.DD_TPO_ID 
		        AND TPO.DD_TPO_CODIGO = ''T003''
		    JOIN TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
		    JOIN REMMASTER.USU_USUARIOS USU ON USU.USU_ID = TAC.USU_ID 
		        AND USU.USU_USERNAME = ''tinsacer01''
		    JOIN TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID AND TAR.TAR_FECHA_FIN IS NULL) T2
		ON (T1.TAR_ID = T2.TAR_ID AND T1.TRA_ID = T2.TRA_ID AND T1.ACT_ID = T2.ACT_ID)
		WHEN MATCHED THEN UPDATE SET
		    T1.USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE USU_USERNAME = ''B86689494'')';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' gestores reasignados.');
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('[FIN] Reposicionamiento de trámites de ofertas.');

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(V_MSQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
