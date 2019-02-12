--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190118
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-2067
--## PRODUCTO=NO
--## 
--## Finalidad: Reenviamos gastos a ASPRO.
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
	TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de marcado y reenvio de gastos...'); 

	EXECUTE IMMEDIATE  'MERGE INTO REM01.GGE_GASTOS_GESTION T1 
						USING
						(
							SELECT DISTINCT GGE.GGE_ID
							FROM REM01.GPV_GASTOS_PROVEEDOR         GPV
							JOIN REM01.GGE_GASTOS_GESTION           GGE
							  ON GPV.GPV_ID = GGE.GPV_ID
							WHERE GPV.GPV_NUM_GASTO_HAYA IN (
								9492684,
								9492686,
								9492687,
								9492688,
								9492689,
								9492690,
								9493991,
								9493992
							)	
						) T2 
						ON (T1.GGE_ID = T2.GGE_ID)
						WHEN MATCHED THEN
						UPDATE
						SET 
							T1.DD_EAH_ID = (SELECT DD_EAH_ID FROM REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''03''),
							T1.GGE_FECHA_EAH = SYSDATE,
							T1.DD_EAP_ID = (SELECT DD_EAP_ID FROM REM01.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = ''01''),
							T1.GGE_FECHA_EAP = NULL,
							T1.GGE_MOTIVO_RECHAZO_PROP = NULL,
							T1.GGE_FECHA_ENVIO_PRPTRIO = NULL,
							T1.USUARIOMODIFICAR = ''REMVIP-2067'',
							T1.FECHAMODIFICAR = SYSDATE
	';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' gastos en la GGE_GASTOS_GESTION'); 
	
	
	EXECUTE IMMEDIATE  'MERGE INTO REM01.GPV_GASTOS_PROVEEDOR T1 
						USING 
						(
							SELECT DISTINCT GPV.GPV_ID
							FROM REM01.GPV_GASTOS_PROVEEDOR         GPV
							JOIN REM01.GGE_GASTOS_GESTION           GGE
							  ON GPV.GPV_ID = GGE.GPV_ID
							WHERE GPV.GPV_NUM_GASTO_HAYA IN (
								9492684,
								9492686,
								9492687,
								9492688,
								9492689,
								9492690,
								9493991,
								9493992
							)	 
						) T2 
						ON (T1.GPV_ID = T2.GPV_ID) 
						WHEN MATCHED THEN
						UPDATE
						SET T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM REM01.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''03''),
							T1.USUARIOMODIFICAR = ''REMVIP-2067'',
							T1.FECHAMODIFICAR = SYSDATE
	';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' gastos en la GPV_GASTOS_PROVEEDOR');	


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
