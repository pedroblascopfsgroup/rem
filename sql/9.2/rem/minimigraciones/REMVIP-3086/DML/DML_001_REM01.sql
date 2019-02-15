--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190118
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-3086
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiamos el Estado del gasto a 'Pagado' de una serie de gastos.
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
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso...'); 

	EXECUTE IMMEDIATE  'MERGE INTO REM01.GPV_GASTOS_PROVEEDOR T1
						USING (
							SELECT DISTINCT GPV.GPV_ID AS GPV_ID
							FROM REM01.AUX_MMC_REMVIP_3086 				AUX
							JOIN REM01.GPV_GASTOS_PROVEEDOR 			GPV
							  ON GPV.GPV_NUM_GASTO_HAYA = AUX.GASTO
						) T2
						ON (T1.GPV_ID = T2.GPV_ID)
						WHEN MATCHED THEN UPDATE SET
						T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM REM01.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''05''),
						T1.USUARIOMODIFICAR = ''REMVIP-3086'',
						T1.FECHAMODIFICAR = SYSDATE
	';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se ha actualizado el estado del gasto a Pagado en '||SQL%ROWCOUNT||' gastos. En la GPV_GASTOS_PROVEEDOR.'); 

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
