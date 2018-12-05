--/*
--#########################################
--## AUTOR=Javier Pons
--## FECHA_CREACION=20181126
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-2633
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar NUM FINCA de la tabla BIE_DATOS REGISTRALES
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
V_TABLA VARCHAR2(40 CHAR) := 'AUX_JPR_BIE_DATOS_REGISTRALES';

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES T1
						USING (
							        SELECT  ID_HAYA,
                                   			BIE_DREG_NUM_FINCA,
							       			ACT.BIE_ID
							FROM '||V_ESQUEMA||'.'||V_TABLA||' AUX
                            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA                       
						) T2 
						ON (T1.BIE_ID = T2.BIE_ID)
						WHEN MATCHED THEN UPDATE SET
							T1.BIE_DREG_NUM_FINCA = T2.BIE_DREG_NUM_FINCA,
							T1.USUARIOMODIFICAR = ''REMVIP-2633'',
							T1.FECHAMODIFICAR = SYSDATE
	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' Activos a los que actualizamos el numero de finca.');  

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
