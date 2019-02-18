--/*
--#########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20190218
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-3377
--## PRODUCTO=NO
--## 
--## Finalidad: Marcamos gastos para reenviarlos.
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
V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3377';

BEGIN
	
	PL_OUTPUT := '[INICIO]'||CHR(10);
	
	V_SQL := '
	MERGE INTO REM01.GPV_GASTOS_PROVEEDOR T1 USING
(
    SELECT GPV.GPV_ID
    FROM rem01.GPV_GASTOS_PROVEEDOR GPV
    JOIN REM01.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
    WHERE GPV.GPV_NUM_GASTO_HAYA IN  ( 
    10264834,9462186,9462172,9462177,9462171,9462180,9463059,9463060,10295000,
    9645487,
    9645490,
    10216650,
    10216652,
    10216653,
    10216654,
    10216656,
    9691377,
    10217771,
    10217772,
    10217773,
    10217774,
    10217775,
    10217776,
    10217777,
    10217778,
    10217779,
    10217780,
    10217781,
    10217785,
    10217786,
    10217787,
    10217783)   
  
)T2 ON (T1.GPV_ID = T2.GPV_ID) 
WHEN MATCHED THEN
        UPDATE
        SET T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM  REM01.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''01''),
            T1.PRG_ID = NULL,
            T1.USUARIOMODIFICAR = ''REMV-3377'',
            T1.FECHAMODIFICAR = SYSDATE';
            
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' gastos sacados de provision y puestos como pendientes.');

            
	V_SQL := 'MERGE INTO REM01.GIC_GASTOS_INFO_CONTABILIDAD T1 USING
(
     SELECT GPV.GPV_ID, GIC.GIC_PTDA_PRESUPUESTARIA
    FROM rem01.GPV_GASTOS_PROVEEDOR GPV
    JOIN rem01.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
    WHERE GPV.GPV_NUM_GASTO_HAYA IN  (9691377)
  
)T2 ON (T1.GPV_ID = T2.GPV_ID) 
WHEN MATCHED THEN
        UPDATE
        SET T1.GIC_PTDA_PRESUPUESTARIA = 656250,
            T1.USUARIOMODIFICAR = ''REMV-3377'',
            T1.FECHAMODIFICAR = SYSDATE';
											
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' cambiamos partida presupuestaria.');






	V_SQL := 'MERGE INTO REM01.GPV_GASTOS_PROVEEDOR T1 USING
(
    SELECT GPV.GPV_ID
    FROM rem01.GPV_GASTOS_PROVEEDOR GPV
    JOIN REM01.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
    WHERE GPV.GPV_NUM_GASTO_HAYA IN  (  
        10280773,
        10280837,
        10281214,
        10281229,
        10281258,
        10281262,
        10281274,
        10281094,
        10281143,
        10281145,
        10281190,
        10281202,
        10281497,
        10281507,
        10280955,
        10280993,
        10281174,
        10281067)   
          
)T2 ON (T1.GPV_ID = T2.GPV_ID) 
WHEN MATCHED THEN
        UPDATE
        SET T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM  REM01.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''04''),
            T1.USUARIOMODIFICAR = ''REMV-3377'',
            T1.FECHAMODIFICAR = SYSDATE'

            ;
											
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' ponemos como contabilizados gastos.');










	V_SQL := 'MERGE INTO REM01.PRG_PROVISION_GASTOS T1 USING
(
    SELECT GPV.PRG_ID
    FROM rem01.GPV_GASTOS_PROVEEDOR GPV
    JOIN rem01.PRG_PROVISION_GASTOS PRG ON PRG.PRG_ID = GPV.PRG_ID
    WHERE GPV.GPV_NUM_GASTO_HAYA IN  (  
        10280773,
        10280837,
        10281214,
        10281229,
        10281258,
        10281262,
        10281274,
        10281094,
        10281143,
        10281145,
        10281190,
        10281202,
        10281497,
        10281507,
        10280955,
        10280993,
        10281174,
        10281067)   
          
)T2 ON (T1.PRG_ID = T2.PRG_ID) 
WHEN MATCHED THEN
        UPDATE
        SET T1.DD_EPR_ID = (SELECT DD_EPR_ID FROM  REM01.DD_EPR_ESTADOS_PROVISION_GASTO WHERE DD_EPR_CODIGO = ''06''),
            T1.USUARIOMODIFICAR = ''REMV-3377'',
            T1.FECHAMODIFICAR = SYSDATE';
											
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' ponemos como contabilizadas provisiones.');






	V_SQL := 'MERGE INTO REM01.GGE_GASTOS_GESTION T1 USING
(
    SELECT GPV.GPV_ID
    FROM rem01.GPV_GASTOS_PROVEEDOR GPV
    JOIN REM01.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
    WHERE GPV.GPV_NUM_GASTO_HAYA IN ( 
        9606308,
        9606103,
        10226612,
        10226614,
        10226615,
        10226616,
        10226617,
        10226618,
        10226619,
        10226620,
        10226622,
        10226623,
        10226624,
        10226625,
        10226626,
        10226627,
        10226628,
        10226630,
        10226631,
        10226632,
        10226633,
        10226634,
        10226635,
        10226636,
        10226638,
        10226639,
        10226640,
        10226641,
        10226642,
        10226643,
        10226644,
        10286563,
        10286565,
        10286567,
        10286573)
            
 
)T2 ON (T1.GPV_ID = T2.GPV_ID)
WHEN MATCHED THEN
UPDATE
SET T1.DD_EAH_ID = (SELECT DD_EAH_ID FROM  REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''03''),
    T1.GGE_FECHA_EAH = SYSDATE,
    T1.DD_EAP_ID = (SELECT DD_EAP_ID FROM  REM01.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = ''01''),
    T1.GGE_FECHA_EAP = NULL,
    T1.GGE_MOTIVO_RECHAZO_PROP = NULL,
    T1.GGE_FECHA_ENVIO_PRPTRIO = NULL,
    T1.USUARIOMODIFICAR = ''REMV-3377'',
    T1.FECHAMODIFICAR = SYSDATE';
											
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' relanzamos y sacamos de PF 1.');



	V_SQL := 'MERGE INTO REM01.GPV_GASTOS_PROVEEDOR T1 USING
(
    SELECT GPV.GPV_ID
    FROM rem01.GPV_GASTOS_PROVEEDOR GPV
    JOIN REM01.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
    WHERE GPV.GPV_NUM_GASTO_HAYA IN  
     ( 
        9606308,
        9606103,
        10226612,
        10226614,
        10226615,
        10226616,
        10226617,
        10226618,
        10226619,
        10226620,
        10226622,
        10226623,
        10226624,
        10226625,
        10226626,
        10226627,
        10226628,
        10226630,
        10226631,
        10226632,
        10226633,
        10226634,
        10226635,
        10226636,
        10226638,
        10226639,
        10226640,
        10226641,
        10226642,
        10226643,
        10226644,
        10286563,
        10286565,
        10286567,
        10286573)
            
    
)T2 ON (T1.GPV_ID = T2.GPV_ID) 
WHEN MATCHED THEN
        UPDATE
        SET T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM  REM01.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''03''),
            T1.PRG_ID = NULL,
            T1.USUARIOMODIFICAR = ''REMV-3377'',
            T1.FECHAMODIFICAR = SYSDATE';
											
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' relanzamos y sacamos de PF 2.');




    
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
