--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190408
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-3930
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
V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3930';

BEGIN
	
	PL_OUTPUT := '[INICIO]'||CHR(10);

	V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.GGE_GASTOS_GESTION T1 USING
(
    SELECT GPV.GPV_ID
    FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV
    JOIN ' || V_ESQUEMA || '.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
    WHERE GPV.GPV_NUM_GASTO_HAYA IN ( 
                                                                          	9606295	,
                                                                          	10264925,
                                                                          	10227050,
                                                                          	10227057,
                                                                          	10227053,
                                                                          	9583787	,
                                                                          	9462705	,
                                                                          	9462698	,
                                                                          	9462697	,
                                                                          	10248470,
                                                                          	10248472,
                                                                          	10217558,
                                                                          	10217559,
                                                                          	10217569,
                                                                          	10217570,
                                                                          	10217571,
                                                                          	9453766	,
                                                                          	9453765	,
                                                                          	9453762	,
                                                                          	9453763	,
                                                                          	9453759	,
                                                                          	9606319	,
                                                                          	9606317	,
                                                                          	9583787	,
                                                                          	10217795,
                                                                          	10217797,
                                                                          	10217798,
                                                                          	10217800,
                                                                          	10217804,
                                                                          	10217801,
                                                                          	10227156,
                                                                          	10227154,
                                                                          	10227119,
                                                                          	10227117,
                                                                          	10227116,
                                                                          	10227115,
                                                                          	10227114,
                                                                          	10227113,
                                                                          	10227112,
                                                                          	10227150,
                                                                          	10227148,
                                                                          	10227147,
                                                                          	10217815,
                                                                          	10227146,
                                                                          	10227144,
                                                                          	10217816,
                                                                          	10227143,
                                                                          	10217817,
                                                                          	10227142,
                                                                          	10227141,
                                                                          	10217818,
                                                                          	10227140,
                                                                          	10217819,
                                                                          	10217826,
                                                                          	10217827,
                                                                          	10227138,
                                                                          	10217828,
                                                                          	10227136,
                                                                          	10217829,
                                                                          	10227135,
                                                                          	10217830,
                                                                          	10217832,
                                                                          	10227134,
                                                                          	10217835,
                                                                          	10217834,
                                                                          	10227132,
                                                                          	10217820,
                                                                          	10217821,
                                                                          	10217822,
                                                                          	10217544,
                                                                          	10217547,
                                                                          	10217548,
                                                                          	10394757
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
                                                                          	9606295	,
                                                                          	10264925,
                                                                          	10227050,
                                                                          	10227057,
                                                                          	10227053,
                                                                          	9583787	,
                                                                          	9462705	,
                                                                          	9462698	,
                                                                          	9462697	,
                                                                          	10248470,
                                                                          	10248472,
                                                                          	10217558,
                                                                          	10217559,
                                                                          	10217569,
                                                                          	10217570,
                                                                          	10217571,
                                                                          	9453766	,
                                                                          	9453765	,
                                                                          	9453762	,
                                                                          	9453763	,
                                                                          	9453759	,
                                                                          	9606319	,
                                                                          	9606317	,
                                                                          	9583787	,
                                                                          	10217795,
                                                                          	10217797,
                                                                          	10217798,
                                                                          	10217800,
                                                                          	10217804,
                                                                          	10217801,
                                                                          	10227156,
                                                                          	10227154,
                                                                          	10227119,
                                                                          	10227117,
                                                                          	10227116,
                                                                          	10227115,
                                                                          	10227114,
                                                                          	10227113,
                                                                          	10227112,
                                                                          	10227150,
                                                                          	10227148,
                                                                          	10227147,
                                                                          	10217815,
                                                                          	10227146,
                                                                          	10227144,
                                                                          	10217816,
                                                                          	10227143,
                                                                          	10217817,
                                                                          	10227142,
                                                                          	10227141,
                                                                          	10217818,
                                                                          	10227140,
                                                                          	10217819,
                                                                          	10217826,
                                                                          	10217827,
                                                                          	10227138,
                                                                          	10217828,
                                                                          	10227136,
                                                                          	10217829,
                                                                          	10227135,
                                                                          	10217830,
                                                                          	10217832,
                                                                          	10227134,
                                                                          	10217835,
                                                                          	10217834,
                                                                          	10227132,
                                                                          	10217820,
                                                                          	10217821,
                                                                          	10217822,
                                                                          	10217544,
                                                                          	10217547,
                                                                          	10217548,
                                                                          	10394757

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



	V_SQL := '
	MERGE INTO ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR T1 USING
(
    SELECT GPV.GPV_ID
    FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV
    JOIN ' || V_ESQUEMA || '.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
    WHERE GPV.GPV_NUM_GASTO_HAYA IN  ( 

                                                                          	10285547	,
                                                                          	10328095	,
                                                                          	10328096	,
                                                                          	10331226	,
                                                                          	10331185	,
                                                                          	10284797	,
                                                                          	10417370	,
                                                                          	10417450	,
                                                                          	10417389	,
                                                                          	10417384	,
                                                                          	10417242	,
                                                                          	10417449	,
                                                                          	10417441	,
                                                                          	10417421	,
                                                                          	10417454	,
                                                                          	10417224	,
                                                                          	10417288	,
                                                                          	10417188	,
                                                                          	10417068	,
                                                                          	10416987	,
                                                                          	10416983	,
                                                                          	10416898	,
                                                                          	10416956	,
                                                                          	10416901	,
                                                                          	10417353	,
                                                                          	10416897	,
                                                                          	10417308	,
                                                                          	10417299	,
                                                                          	10417092	,
                                                                          	10416902	,
                                                                          	10413431	,
                                                                          	10413429	,
                                                                          	10417448	,
                                                                          	10451379	,
                                                                          	10451387	,
                                                                          	10451390	,
                                                                          	10451396	,
                                                                          	10451416	,
                                                                          	10451419	,
                                                                          	10451420	,
                                                                          	10451423	,
                                                                          	10451378	,
                                                                          	10451383	,
                                                                          	10451388	,
                                                                          	10451389	,
                                                                          	10451392	,
                                                                          	10451394	,
                                                                          	10451402	,
                                                                          	10451418	


				)     
)T2 ON (T1.GPV_ID = T2.GPV_ID) 
WHEN MATCHED THEN
        UPDATE
        SET T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM  ' || V_ESQUEMA || '.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''04''),
    	    T1.USUARIOMODIFICAR = ''' || V_USUARIO || ''',
            T1.FECHAMODIFICAR = SYSDATE';
            
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' GASTOS CAMBIADOS A ESTADO <CONTABILIZADO> ');



         
	V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.GGE_GASTOS_GESTION T1 USING
(
    SELECT GPV.GPV_ID
    FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV
    JOIN ' || V_ESQUEMA || '.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
    WHERE GPV.GPV_NUM_GASTO_HAYA IN ( 

                                                                          	10379616	,
                                                                          	10379612	,
                                                                          	10379610	,
                                                                          	10379600	,
                                                                          	9605748	,
                                                                          	9606290	,
                                                                          	10217894	,
                                                                          	10217895	,
                                                                          	10217897	,
                                                                          	10217900	,
                                                                          	10217902	,
                                                                          	10217903	,
                                                                          	10217904	,
                                                                          	10217905	,
                                                                          	10217907	,
                                                                          	10217909	,
                                                                          	10217910	,
                                                                          	10217889	,
                                                                          	9676602	,
                                                                          	10217286	,
                                                                          	10217287	,
                                                                          	10217288	,
                                                                          	10217289	,
                                                                          	10217290	,
                                                                          	10217291	,
                                                                          	10217292	,
                                                                          	10217293	,
                                                                          	10217294	,
                                                                          	10217296	,
                                                                          	10217297	,
                                                                          	10217299	,
                                                                          	10217300	,
                                                                          	10217301	,
                                                                          	10217302	,
                                                                          	10217303	,
                                                                          	10217304	,
                                                                          	10217305	,
                                                                          	10217306	,
                                                                          	10217307	,
                                                                          	10217308	,
                                                                          	10217309	,
                                                                          	10217310	,
                                                                          	10217312	,
                                                                          	10217313	,
                                                                          	10217314	,
                                                                          	10217315	,
                                                                          	10217316	,
                                                                          	10217280	,
                                                                          	10217281	,
                                                                          	10264632	,
                                                                          	10264633	,
                                                                          	10264634	,
                                                                          	10264635	,
                                                                          	10264636	,
                                                                          	9472921	,
                                                                          	10415493	,
                                                                          	10415496	,
                                                                          	10415499	,
                                                                          	10415466	,
                                                                          	10415469	,
                                                                          	10415472	,
                                                                          	10415475	,
                                                                          	10415478	,
                                                                          	10415481	,
                                                                          	10415503	,
                                                                          	10415506	,
                                                                          	10415491	,
                                                                          	10415494	,
                                                                          	10415497	,
                                                                          	10415500	,
                                                                          	10415467	,
                                                                          	10415470	,
                                                                          	10415473	,
                                                                          	10415476	,
                                                                          	10419323	,
                                                                          	10419327	,
                                                                          	10419330	,
                                                                          	10419325	,
                                                                          	10419328	,
                                                                          	10435559	,
                                                                          	10280850	,
                                                                          	10422228	,
                                                                          	10422240	,
                                                                          	10425234	,
                                                                          	10414420	,
                                                                          	10422231	,
                                                                          	10413610	,
                                                                          	10413613	,
                                                                          	10415107	,
                                                                          	10415114	,
                                                                          	10415111	,
                                                                          	10415110	,
                                                                          	10415103	,
                                                                          	10415106	,
                                                                          	10415102	,
                                                                          	10415100	,
                                                                          	10415105	,
                                                                          	10415109	,
                                                                          	10425722	,
                                                                          	10264562	,
                                                                          	9462344	,
                                                                          	9462341	,
                                                                          	10394465	,
                                                                          	10394461	,
                                                                          	10394457	,
                                                                          	10394453	,
                                                                          	10394449	,
                                                                          	10394445	,
                                                                          	10394481	,
                                                                          	10394477	,
                                                                          	10394473	,
                                                                          	10394470	,
                                                                          	10394491	,
                                                                          	10394487	,
                                                                          	10394464	,
                                                                          	10394460	,
                                                                          	10394456	,
                                                                          	10394452	,
                                                                          	10394448	,
                                                                          	10394484	,
                                                                          	10394480	,
                                                                          	10394476	,
                                                                          	10394472	,
                                                                          	10394493	,
                                                                          	10394490	,
                                                                          	10394486	,
                                                                          	10394463	,
                                                                          	10394459	,
                                                                          	10394455	,
                                                                          	10394451	,
                                                                          	10394447	,
                                                                          	10394483	,
                                                                          	10394479	,
                                                                          	10394475	,
                                                                          	9462096	,
                                                                          	10422850	,
                                                                          	10422846	,
                                                                          	10422842	,
                                                                          	10422838	,
                                                                          	10422834	,
                                                                          	10422830	,
                                                                          	10422826	,
                                                                          	10422822	,
                                                                          	10422818	,
                                                                          	10422814	,
                                                                          	10422811	,
                                                                          	10422853	,
                                                                          	10422849	,
                                                                          	10422845	,
                                                                          	10422841	,
                                                                          	10422837	,
                                                                          	10422833	,
                                                                          	10422829	,
                                                                          	10422825	,
                                                                          	10422821	,
                                                                          	10422833	,
                                                                          	10422829	,
                                                                          	10422825	,
                                                                          	10422821	,
                                                                          	10422817	,
                                                                          	10422813	,
                                                                          	10422855	,
                                                                          	10422852	,
                                                                          	10422848	,
                                                                          	10422844	,
                                                                          	10422840	,
                                                                          	10422836	,
                                                                          	10422832	,
                                                                          	10422828	,
                                                                          	10422824	,
                                                                          	10422820	,
                                                                          	10422816	,
                                                                          	9606291	


				    )
            
 
)T2 ON (T1.GPV_ID = T2.GPV_ID)
WHEN MATCHED THEN
UPDATE
SET T1.GGE_FECHA_ENVIO_PRPTRIO = NULL,
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

                                                                          	10379616	,
                                                                          	10379612	,
                                                                          	10379610	,
                                                                          	10379600	,
                                                                          	9605748	,
                                                                          	9606290	,
                                                                          	10217894	,
                                                                          	10217895	,
                                                                          	10217897	,
                                                                          	10217900	,
                                                                          	10217902	,
                                                                          	10217903	,
                                                                          	10217904	,
                                                                          	10217905	,
                                                                          	10217907	,
                                                                          	10217909	,
                                                                          	10217910	,
                                                                          	10217889	,
                                                                          	9676602	,
                                                                          	10217286	,
                                                                          	10217287	,
                                                                          	10217288	,
                                                                          	10217289	,
                                                                          	10217290	,
                                                                          	10217291	,
                                                                          	10217292	,
                                                                          	10217293	,
                                                                          	10217294	,
                                                                          	10217296	,
                                                                          	10217297	,
                                                                          	10217299	,
                                                                          	10217300	,
                                                                          	10217301	,
                                                                          	10217302	,
                                                                          	10217303	,
                                                                          	10217304	,
                                                                          	10217305	,
                                                                          	10217306	,
                                                                          	10217307	,
                                                                          	10217308	,
                                                                          	10217309	,
                                                                          	10217310	,
                                                                          	10217312	,
                                                                          	10217313	,
                                                                          	10217314	,
                                                                          	10217315	,
                                                                          	10217316	,
                                                                          	10217280	,
                                                                          	10217281	,
                                                                          	10264632	,
                                                                          	10264633	,
                                                                          	10264634	,
                                                                          	10264635	,
                                                                          	10264636	,
                                                                          	9472921	,
                                                                          	10415493	,
                                                                          	10415496	,
                                                                          	10415499	,
                                                                          	10415466	,
                                                                          	10415469	,
                                                                          	10415472	,
                                                                          	10415475	,
                                                                          	10415478	,
                                                                          	10415481	,
                                                                          	10415503	,
                                                                          	10415506	,
                                                                          	10415491	,
                                                                          	10415494	,
                                                                          	10415497	,
                                                                          	10415500	,
                                                                          	10415467	,
                                                                          	10415470	,
                                                                          	10415473	,
                                                                          	10415476	,
                                                                          	10419323	,
                                                                          	10419327	,
                                                                          	10419330	,
                                                                          	10419325	,
                                                                          	10419328	,
                                                                          	10435559	,
                                                                          	10280850	,
                                                                          	10422228	,
                                                                          	10422240	,
                                                                          	10425234	,
                                                                          	10414420	,
                                                                          	10422231	,
                                                                          	10413610	,
                                                                          	10413613	,
                                                                          	10415107	,
                                                                          	10415114	,
                                                                          	10415111	,
                                                                          	10415110	,
                                                                          	10415103	,
                                                                          	10415106	,
                                                                          	10415102	,
                                                                          	10415100	,
                                                                          	10415105	,
                                                                          	10415109	,
                                                                          	10425722	,
                                                                          	10264562	,
                                                                          	9462344	,
                                                                          	9462341	,
                                                                          	10394465	,
                                                                          	10394461	,
                                                                          	10394457	,
                                                                          	10394453	,
                                                                          	10394449	,
                                                                          	10394445	,
                                                                          	10394481	,
                                                                          	10394477	,
                                                                          	10394473	,
                                                                          	10394470	,
                                                                          	10394491	,
                                                                          	10394487	,
                                                                          	10394464	,
                                                                          	10394460	,
                                                                          	10394456	,
                                                                          	10394452	,
                                                                          	10394448	,
                                                                          	10394484	,
                                                                          	10394480	,
                                                                          	10394476	,
                                                                          	10394472	,
                                                                          	10394493	,
                                                                          	10394490	,
                                                                          	10394486	,
                                                                          	10394463	,
                                                                          	10394459	,
                                                                          	10394455	,
                                                                          	10394451	,
                                                                          	10394447	,
                                                                          	10394483	,
                                                                          	10394479	,
                                                                          	10394475	,
                                                                          	9462096	,
                                                                          	10422850	,
                                                                          	10422846	,
                                                                          	10422842	,
                                                                          	10422838	,
                                                                          	10422834	,
                                                                          	10422830	,
                                                                          	10422826	,
                                                                          	10422822	,
                                                                          	10422818	,
                                                                          	10422814	,
                                                                          	10422811	,
                                                                          	10422853	,
                                                                          	10422849	,
                                                                          	10422845	,
                                                                          	10422841	,
                                                                          	10422837	,
                                                                          	10422833	,
                                                                          	10422829	,
                                                                          	10422825	,
                                                                          	10422821	,
                                                                          	10422833	,
                                                                          	10422829	,
                                                                          	10422825	,
                                                                          	10422821	,
                                                                          	10422817	,
                                                                          	10422813	,
                                                                          	10422855	,
                                                                          	10422852	,
                                                                          	10422848	,
                                                                          	10422844	,
                                                                          	10422840	,
                                                                          	10422836	,
                                                                          	10422832	,
                                                                          	10422828	,
                                                                          	10422824	,
                                                                          	10422820	,
                                                                          	10422816	,
                                                                          	9606291	


				)     
)T2 ON (T1.GPV_ID = T2.GPV_ID) 
WHEN MATCHED THEN
        UPDATE
        SET T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM  ' || V_ESQUEMA || '.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''01''),
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
