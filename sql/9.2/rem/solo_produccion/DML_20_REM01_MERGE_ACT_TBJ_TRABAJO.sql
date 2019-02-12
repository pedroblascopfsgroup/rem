--/*
--#########################################
--## AUTOR=Javier Pons
--## FECHA_CREACION=20190109
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-2702
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar FECHA_SOLICITUD de trabajos
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
V_SQL VARCHAR2(10000 CHAR);
TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
V_TABLA VARCHAR2(40 CHAR) := 'AUX_REMVIP_2702';

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO T1
					USING (
						SELECT NUM_TRABAJO, FECHA_SOLICITUD 
						FROM '||V_ESQUEMA||'.'||V_TABLA||'
					) T2 
					ON (T1.TBJ_NUM_TRABAJO = T2.NUM_TRABAJO)
					WHEN MATCHED THEN UPDATE SET
					T1.TBJ_FECHA_APROBACION = TO_DATE(T2.FECHA_SOLICITUD, ''DD/MM/YYYY''),
					T1.USUARIOMODIFICAR = ''REMVIP-2702'',
					T1.FECHAMODIFICAR = SYSDATE'
					;

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' Trabajos a los que actualizamos la fecha de solicitud.');  

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
		DBMS_OUTPUT.PUT_LINE(V_SQL);
        ROLLBACK;
        RAISE;
END;

/

EXIT
