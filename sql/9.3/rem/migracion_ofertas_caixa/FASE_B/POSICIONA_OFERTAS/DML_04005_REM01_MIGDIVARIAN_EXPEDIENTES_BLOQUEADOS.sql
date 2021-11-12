--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200227
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-9585
--## PRODUCTO=NO
--## 
--## Finalidad: Calcular comité Divarian
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

  V_ESQUEMA VARCHAR2(30 CHAR):= 'REM01'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(30 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO]');

       DBMS_OUTPUT.PUT_LINE('[INICIO] Comentado para BBVA. El calculo del comite se hace de otra forma.');

      -------------------------------------------------
      --Cálculo comité Divarian--
      -------------------------------------------------
       V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO USING(
			SELECT DISTINCT ECO.ECO_ID 
			FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
			INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID
			INNER JOIN '||V_ESQUEMA||'.ACT_OFR ACO ON ACO.OFR_ID = OFR.OFR_ID
			INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACO.ACT_ID
			INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE ATR ON ATR.TBJ_ID=ECO.TBJ_ID
			INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON ATR.TRA_ID = TAC.TRA_ID
			INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
			INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TXT ON TXT.TAR_ID = TAR.TAR_ID
			INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TXT.TAP_ID = TAP.TAP_ID
			WHERE TAP.TAP_CODIGO IN (''T017_DocsPosVenta'', ''T017_CierreEconomico'') AND ACT.USUARIOCREAR = ''MIG_BBVA'' 
			AND ECO.DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''08'')
		) AUX ON (AUX.ECO_ID = ECO.ECO_ID)
		WHEN MATCHED THEN UPDATE SET
		ECO.ECO_BLOQUEADO = 1';

      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('Se han actualizado '||SQL%ROWCOUNT||' expedientes bloqueados');

     
      COMMIT; 
      
      DBMS_OUTPUT.PUT_LINE('[FIN]');
      
EXCEPTION
      WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.put_line('-----------------------------------------------------------');
            DBMS_OUTPUT.put_line(SQLERRM);
            ROLLBACK;
            RAISE;
END;

/

EXIT;

