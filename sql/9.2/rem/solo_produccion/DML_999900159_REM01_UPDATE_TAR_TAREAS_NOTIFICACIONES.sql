--/*
--#########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20171109
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-3125
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso para finalizar las tareas de trámites finalizados
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

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
    V_TABLA VARCHAR2(40 CHAR) := 'TAR_TAREAS_NOTIFICACIONES'; -- Vble. Tabla
    
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de finalizado de tareas en tramites finalizados.');    
    DBMS_OUTPUT.PUT_LINE('');

    V_MSQL := 'MERGE INTO '||V_TABLA||' TAR
	USING (SELECT TAR2.TAR_ID FROM '||V_TABLA||' TAR2
		join TEX_TAREA_EXTERNA tex on TAR2.TAR_ID = tex.TAR_ID
        join TAC_TAREAS_ACTIVOS tac on TAR2.TAR_ID = tac.TAR_ID
        join ACT_TRA_TRAMITE acttra on tac.TRA_ID = acttra.TRA_ID
        join '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO epr on acttra.DD_EPR_ID = epr.DD_EPR_ID
        where epr.DD_EPR_CODIGO = ''11'' and (TAR2.TAR_TAREA_FINALIZADA= 0 or TAR2.TAR_FECHA_FIN is null or TAR2.BORRADO= 0)
    ) AUX
	ON (AUX.TAR_ID = TAR.TAR_ID)
	WHEN MATCHED THEN UPDATE SET
	TAR.BORRADO = 1,
	TAR.USUARIOBORRAR = ''HREOS-3125'',
	TAR.FECHABORRAR = SYSDATE,
    TAR.TAR_FECHA_FIN= SYSDATE,
    TAR.TAR_TAREA_FINALIZADA= 1';
    
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Tareas finalizadas: '||SQL%ROWCOUNT);
    
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('[FIN] Tareas finalizadas.');

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
