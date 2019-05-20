--/*
--#########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190118
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-3086
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiamos el Estado de una serie de activos.
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
	V_SQL VARCHAR2(2000 CHAR);
    	TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso...'); 
    
    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT
						USING '||V_ESQUEMA||'.AUX_REMVIP_3725 AUX
						ON (ACT.ACT_NUM_ACTIVO = AUX.ACTIVO)
						WHEN MATCHED THEN UPDATE SET
						ACT.DD_CAP_ID = AUX.DD_CAP_ID,
						ACT.USUARIOMODIFICAR = ''REMVIP-3725'',
						ACT.FECHAMODIFICAR = SYSDATE
	';
    
    --DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;
    
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. En la ACT_ACTIVO.'); 

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
EXIT
