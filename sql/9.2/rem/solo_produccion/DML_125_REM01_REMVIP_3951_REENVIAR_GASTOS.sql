--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190410
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-3951
--## PRODUCTO=NO
--## 
--## Finalidad: Reenviar gastos
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
V_SQL VARCHAR2(32767 CHAR);
V_SENTENCIA VARCHAR2(32000 CHAR);
PL_OUTPUT VARCHAR2(32000 CHAR);
V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3951';

BEGIN
	
	PL_OUTPUT := '[INICIO]'||CHR(10);

	V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.GGE_GASTOS_GESTION T1 USING
(
    SELECT GPV.GPV_ID
    FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV
    JOIN ' || V_ESQUEMA || '.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
    WHERE GPV.GPV_NUM_GASTO_HAYA IN ( 
                                                    	
                            	10034229	,
                          	10417143	,
                          	10417144	,
                          	10417145	,
                          	10417316	,
                          	10339419	,
                          	10340319	,
                          	10410718	,
                          	10292033	,
                          	10292034	,
                          	10445243	,
                          	10445315	,
                          	10445319	,
                          	10413721	,
                          	10413722	,
                          	10344286	,
                          	10373667	,
                          	10373741	,
                          	10452587	,
                          	10373886	,
                          	10374093	,
                          	10404842	,
                          	10404843	,
                          	10404844	,
                          	10402521	,
                          	10402522	,
                          	10402523	,
                          	10406068	,
                          	10406069	,
                          	10406070	,
                          	10405328	,
                          	10405329	,
                          	10405330	,
                          	10405345	,
                          	10364170	,
                          	10365122	,
                          	10362947	,
                          	10363704	,
                          	10363055	,
                          	10366211	,
                          	10363919	,
                          	10365583	,
                          	10364868	,
                          	10365689	,
                          	10425821	,
                          	10425833	,
                          	10376138	,
                          	10376139	,
                          	10375238	,
                          	10375239	,
                          	10331733	,
                          	10331734	,
                          	10331735	,
                          	10331736	,
                          	10331737	,
                          	10331738	,
                          	10331739	,
                          	10331740	,
                          	10331741	,
                          	10331742	,
                          	10331809	,
                          	10331810	,
                          	10386637	,
                          	10331849	,
                          	10331850	,
                          	10331851	,
                          	10330876	,
                          	10332103	,
                          	10436831	,
                          	10436828	,
                          	10436832	

				    )
            
 
)T2 ON (T1.GPV_ID = T2.GPV_ID)
WHEN MATCHED THEN
UPDATE
SET T1.DD_EAH_ID = (SELECT DD_EAH_ID FROM  ' || V_ESQUEMA || '.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''03''),
    T1.GGE_FECHA_EAH = SYSDATE,
    T1.DD_EAP_ID = (SELECT DD_EAP_ID FROM  ' || V_ESQUEMA || '.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = ''01''),
    T1.GGE_FECHA_EAP = NULL,
    T1.GGE_MOTIVO_RECHAZO_PROP = NULL,
    T1.GGE_FECHA_ENVIO_PRPTRIO = NULL,
    T1.USUARIOMODIFICAR = ''' || V_USUARIO || ''',
    T1.FECHAMODIFICAR = SYSDATE';
											
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' GESTIÓN DE GASTOS CAMBIADOS');
      
	
	V_SQL := '
	MERGE INTO ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR T1 USING
(
    SELECT GPV.GPV_ID
    FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV
    JOIN ' || V_ESQUEMA || '.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
    WHERE GPV.GPV_NUM_GASTO_HAYA IN  ( 
                          	10034229	,
                          	10417143	,
                          	10417144	,
                          	10417145	,
                          	10417316	,
                          	10339419	,
                          	10340319	,
                          	10410718	,
                          	10292033	,
                          	10292034	,
                          	10445243	,
                          	10445315	,
                          	10445319	,
                          	10413721	,
                          	10413722	,
                          	10344286	,
                          	10373667	,
                          	10373741	,
                          	10452587	,
                          	10373886	,
                          	10374093	,
                          	10404842	,
                          	10404843	,
                          	10404844	,
                          	10402521	,
                          	10402522	,
                          	10402523	,
                          	10406068	,
                          	10406069	,
                          	10406070	,
                          	10405328	,
                          	10405329	,
                          	10405330	,
                          	10405345	,
                          	10364170	,
                          	10365122	,
                          	10362947	,
                          	10363704	,
                          	10363055	,
                          	10366211	,
                          	10363919	,
                          	10365583	,
                          	10364868	,
                          	10365689	,
                          	10425821	,
                          	10425833	,
                          	10376138	,
                          	10376139	,
                          	10375238	,
                          	10375239	,
                          	10331733	,
                          	10331734	,
                          	10331735	,
                          	10331736	,
                          	10331737	,
                          	10331738	,
                          	10331739	,
                          	10331740	,
                          	10331741	,
                          	10331742	,
                          	10331809	,
                          	10331810	,
                          	10386637	,
                          	10331849	,
                          	10331850	,
                          	10331851	,
                          	10330876	,
                          	10332103	,
                          	10436831	,
                          	10436828	,
                          	10436832	




				)     
)T2 ON (T1.GPV_ID = T2.GPV_ID) 
WHEN MATCHED THEN
        UPDATE
        SET T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM  ' || V_ESQUEMA || '.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''03''),
            T1.PRG_ID = NULL,
    	    T1.USUARIOMODIFICAR = ''' || V_USUARIO || ''',
            T1.FECHAMODIFICAR = SYSDATE';
            
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' GASTOS RELANZADOS');

    
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
