--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190409
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-3944
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
V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3944';

BEGIN
	
	PL_OUTPUT := '[INICIO]'||CHR(10);

	V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.GGE_GASTOS_GESTION T1 USING
(
    SELECT GPV.GPV_ID
    FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV
    JOIN ' || V_ESQUEMA || '.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
    WHERE GPV.GPV_NUM_GASTO_HAYA IN ( 
                                                    	10370496	,
                                                    	10370495	,
                                                    	10370494	,
                                                    	10370493	,
                                                    	10370492	,
                                                    	10370491	,
                                                    	10370490	,
                                                    	10370489	,
                                                    	10370488	,
                                                    	10370487	,
                                                    	10370486	,
                                                    	10370485	,
                                                    	10370484	,
                                                    	10370483	,
                                                    	10286154	,
                                                    	10286155	,
                                                    	10286156	,
                                                    	10286157	,
                                                    	10286158	,
                                                    	10286159	,
                                                    	10286160	,
                                                    	10286161	,
                                                    	10286162	,
                                                    	10286163	,
                                                    	10290392	,
                                                    	10290393	,
                                                    	10290394	,
                                                    	10290395	,
                                                    	10290396	,
                                                    	10290397	,
                                                    	10290398	,
                                                    	10290399	,
                                                    	10290400	,
                                                    	10290401	,
                                                    	10290402	,
                                                    	10290403	,
                                                    	10290404	,
                                                    	10290405	,
                                                    	10290406	,
                                                    	10290407	,
                                                    	10290408	,
                                                    	10290409	,
                                                    	10290410	,
                                                    	10290411	,
                                                    	10290992	,
                                                    	10290993	,
                                                    	10290994	,
                                                    	10290995	,
                                                    	10290996	,
                                                    	10290997	,
                                                    	10290998	,
                                                    	10290999	,
                                                    	10291000	,
                                                    	10291001	,
                                                    	10291002	,
                                                    	10291003	,
                                                    	10291004	,
                                                    	10291005	,
                                                    	10291006	,
                                                    	10291007	,
                                                    	10291008	,
                                                    	10291009	,
                                                    	10291010	,
                                                    	10291011	,
                                                    	10291012	,
                                                    	10291013	,
                                                    	10291014	,
                                                    	10291015	,
                                                    	10291016	,
                                                    	10291017	,
                                                    	10291018	,
                                                    	10291019	,
                                                    	10291020	,
                                                    	10291021	,
                                                    	10291022	,
                                                    	10291023	,
                                                    	10291024	,
                                                    	10291025	,
                                                    	10291026	,
                                                    	10291027	,
                                                    	10291028	,
                                                    	10291029	,
                                                    	10291030	,
                                                    	10291031	,
                                                    	10291032	,
                                                    	10291033	,
                                                    	10291034	,
                                                    	10291035	,
                                                    	10291036	,
                                                    	10291037	,
                                                    	10291038	,
                                                    	10291039	,
                                                    	10291040	,
                                                    	10291041	,
                                                    	10291042	,
                                                    	10291043	,
                                                    	10291044	,
                                                    	10291045	,
                                                    	10291046	,
                                                    	10291047	,
                                                    	10291048	,
                                                    	10291049	,
                                                    	10291050	,
                                                    	10291051	,
                                                    	10370467	,
                                                    	10370468	,
                                                    	10370469	,
                                                    	10370470	,
                                                    	10370471	,
                                                    	10370472	,
                                                    	10370473	,
                                                    	10370474	,
                                                    	10370475	,
                                                    	10370476	,
                                                    	10370477	,
                                                    	10370478	,
                                                    	10370479	,
                                                    	10370480	,
                                                    	10370481	,
                                                    	10370482	
  
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

                                                    	10370496	,
                                                    	10370495	,
                                                    	10370494	,
                                                    	10370493	,
                                                    	10370492	,
                                                    	10370491	,
                                                    	10370490	,
                                                    	10370489	,
                                                    	10370488	,
                                                    	10370487	,
                                                    	10370486	,
                                                    	10370485	,
                                                    	10370484	,
                                                    	10370483	,
                                                    	10286154	,
                                                    	10286155	,
                                                    	10286156	,
                                                    	10286157	,
                                                    	10286158	,
                                                    	10286159	,
                                                    	10286160	,
                                                    	10286161	,
                                                    	10286162	,
                                                    	10286163	,
                                                    	10290392	,
                                                    	10290393	,
                                                    	10290394	,
                                                    	10290395	,
                                                    	10290396	,
                                                    	10290397	,
                                                    	10290398	,
                                                    	10290399	,
                                                    	10290400	,
                                                    	10290401	,
                                                    	10290402	,
                                                    	10290403	,
                                                    	10290404	,
                                                    	10290405	,
                                                    	10290406	,
                                                    	10290407	,
                                                    	10290408	,
                                                    	10290409	,
                                                    	10290410	,
                                                    	10290411	,
                                                    	10290992	,
                                                    	10290993	,
                                                    	10290994	,
                                                    	10290995	,
                                                    	10290996	,
                                                    	10290997	,
                                                    	10290998	,
                                                    	10290999	,
                                                    	10291000	,
                                                    	10291001	,
                                                    	10291002	,
                                                    	10291003	,
                                                    	10291004	,
                                                    	10291005	,
                                                    	10291006	,
                                                    	10291007	,
                                                    	10291008	,
                                                    	10291009	,
                                                    	10291010	,
                                                    	10291011	,
                                                    	10291012	,
                                                    	10291013	,
                                                    	10291014	,
                                                    	10291015	,
                                                    	10291016	,
                                                    	10291017	,
                                                    	10291018	,
                                                    	10291019	,
                                                    	10291020	,
                                                    	10291021	,
                                                    	10291022	,
                                                    	10291023	,
                                                    	10291024	,
                                                    	10291025	,
                                                    	10291026	,
                                                    	10291027	,
                                                    	10291028	,
                                                    	10291029	,
                                                    	10291030	,
                                                    	10291031	,
                                                    	10291032	,
                                                    	10291033	,
                                                    	10291034	,
                                                    	10291035	,
                                                    	10291036	,
                                                    	10291037	,
                                                    	10291038	,
                                                    	10291039	,
                                                    	10291040	,
                                                    	10291041	,
                                                    	10291042	,
                                                    	10291043	,
                                                    	10291044	,
                                                    	10291045	,
                                                    	10291046	,
                                                    	10291047	,
                                                    	10291048	,
                                                    	10291049	,
                                                    	10291050	,
                                                    	10291051	,
                                                    	10370467	,
                                                    	10370468	,
                                                    	10370469	,
                                                    	10370470	,
                                                    	10370471	,
                                                    	10370472	,
                                                    	10370473	,
                                                    	10370474	,
                                                    	10370475	,
                                                    	10370476	,
                                                    	10370477	,
                                                    	10370478	,
                                                    	10370479	,
                                                    	10370480	,
                                                    	10370481	,
                                                    	10370482	


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
