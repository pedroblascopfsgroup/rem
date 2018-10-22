--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180914
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-1881
--## PRODUCTO=NO
--## 
--## Finalidad: Marcamos gastos de VPSITEX para reenviarlos.
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_TABLA VARCHAR2(40 CHAR) := '';
V_SQL VARCHAR2(12000 CHAR);
V_SENTENCIA VARCHAR2(32000 CHAR);
PL_OUTPUT VARCHAR2(32000 CHAR);
V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1881';

BEGIN
	
	PL_OUTPUT := '[INICIO]'||CHR(10);
	
	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GGE_GASTOS_GESTION T1 
	          USING
					(
							select GPV.GPV_ID
							from '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR         GPV
							JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
							JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION           GGE ON GGE.GPV_ID = GPV.GPV_ID
							JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR            PVE ON PVE.PVE_ID = GPV.PVE_ID_EMISOR
							join '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO         DD on GPV.DD_EGA_ID = DD.DD_EGA_ID
							JOIN '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA  EAH ON EAH.DD_EAH_ID = GGE.DD_EAH_ID 
							join '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP  eap on eap.dd_eap_id = GGE.DD_EAP_ID
							WHERE GPV.GPV_NUM_GASTO_HAYA IN 
							(
								9556236,
								9699892,
								9560966,
								9560976,
								9560975,
								9490565,
								9259135,
								9492530,
								9693203,
								9689955,
								9612911,
								9577593,
								9463619,
								9594713,
								9594699,
								9497379 
							)
					) T2 
					ON (T1.GPV_ID = T2.GPV_ID) 
					WHEN MATCHED THEN
					UPDATE
					SET     T1.DD_EAH_ID = (SELECT DD_EAH_ID FROM  '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''03''),
							T1.GGE_FECHA_EAH = SYSDATE,
							T1.DD_EAP_ID = (SELECT DD_EAP_ID FROM  '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = ''01''),
							T1.GGE_FECHA_EAP = NULL,
							T1.GGE_MOTIVO_RECHAZO_PROP = NULL,
							T1.GGE_FECHA_ENVIO_PRPTRIO = NULL,
							T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
							T1.FECHAMODIFICAR = SYSDATE';
            
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' filas actualizadas en tabla GGE_GASTOS_GESTION merge 1.');

            
	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR T1 
			  USING
					(
							select GPV.GPV_ID
							from '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR         GPV
							JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
							JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION           GGE ON GGE.GPV_ID = GPV.GPV_ID
							JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR            PVE ON PVE.PVE_ID = GPV.PVE_ID_EMISOR
							join '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO         DD on GPV.DD_EGA_ID = DD.DD_EGA_ID
							JOIN '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA  EAH ON EAH.DD_EAH_ID = GGE.DD_EAH_ID 
							join '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP  eap on eap.dd_eap_id = GGE.DD_EAP_ID
							WHERE GPV.GPV_NUM_GASTO_HAYA IN 
							(
								9556236,
								9699892,
								9560966,
								9560976,
								9560975,
								9490565,
								9259135,
								9492530,
								9693203,
								9689955,
								9612911,
								9577593,
								9463619,
								9594713,
								9594699,
								9497379 
							)
					) T2 
			ON (T1.GPV_ID = T2.GPV_ID) 
			WHEN MATCHED THEN
			UPDATE
			SET T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM  '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''03''),
					T1.PRG_ID = NULL,
					T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
					T1.FECHAMODIFICAR = SYSDATE';
											
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' filas actualizadas en tabla GPV_GASTOS_PROVEEDOR merge 2.');
    
    COMMIT;

	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

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
