--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20191002
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5425
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-5425';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			

-----------------------------------------------------------------------------------------------------------------
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza histórico ASPRO H_ASPRO_10_CABECERA - FEPAGO = null ');
										
	 V_SQL := ' 
		    MERGE INTO ' ||V_ESQUEMA||'.H_ASPRO_10_CABECERA T1
		    USING
		    (
			SELECT 
			DISTINCT
			H_ASPRO_10_ID
			FROM ' ||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
			JOIN ' ||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
			JOIN ' ||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
			JOIN ' ||V_ESQUEMA||'.PRG_PROVISION_GASTOS PRG ON PRG.PRG_ID = GPV.PRG_ID
			JOIN ' ||V_ESQUEMA||'.H_ASPRO_10_CABECERA HCAB ON HCAB.NUFREM = PRG.PRG_NUM_PROVISION
			WHERE 1 = 1
			AND DD_EGA_ID = ( SELECT DD_EGA_ID FROM ' ||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''05'' )
			AND GPV_NUM_GASTO_HAYA IN 
			(
10876015,
10876044,
10875889,
10875930,
10875931,
10875932,
10875885,
10875977,
10876034,
10876035,
10875928,
10875933,
10875944,
10876000,
10875999,
10876023,
10876054,
10876055,
10875917,
10875918,
10875985,
10875940,
10875929,
10875966,
10875979,
10875998,
10875925,
10875968,
10875978,
10876033,
10873537,
10873535,
10873538,
10873539,
10873536,
10875920,
10875980,
10876007,
10875950,
10876036,
10876017,
10876019,
10876053,
10876086,
10876095,
10899679,
10899696,
10899707,
10899713,
10899715,
10899746,
10899747,
10899749,
10899815,
10899816,
10899824,
10899837,
10899839,
10899841,
10899848,
10899849,
10899854,
10899856,
10876085,
10876087,
10876092,
10876094,
10876101,
10876103,
10876109,
10876110,
10876117,
10899673,
10899680,
10899704,
10899705,
10899706,
10899763,
10899764,
10899823,
10899829,
10899830,
10899831,
10899832,
10899846,
10899847,
10876091,
10876104,
10899675,
10899676,
10899703,
10899728,
10899735,
10899736,
10899751,
10899761,
10899776,
10899828,
10899834,
10899851,
10899852,
10875963,
10875995,
10875927,
10875926,
10875942,
10875945,
10876016,
10876045,
10876084,
10876093,
10876100,
10876102,
10899674,
10899712,
10899714,
10899729,
10899730,
10899748,
10899762,
10899838,
10899840,
10876083,
10876088,
10876089,
10876108,
10876113,
10899677,
10899702,
10899708,
10899727,
10899734,
10899744,
10899745,
10899750,
10899825,
10899833,
10899835,
10899842,
10899844,
10899850,
10899859,
10899861,
10876041,
10876090,
10876096,
10876097,
10876098,
10876099,
10876106,
10899678,
10899709,
10899710,
10899711,
10899726,
10899733,
10899759,
10899760,
10899794,
10899826,
10899827,
10899836,
10899843,
10899845,
10899853,
10875921

			)

		    ) AUX
		    ON ( T1.H_ASPRO_10_ID = AUX.H_ASPRO_10_ID )
		    WHEN MATCHED THEN UPDATE SET
			FEPAGA = NULL ';	

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en H_ASPRO_10_CABECERA ');  


-----------------------------------------------------------------------------------------------------------------
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza GDE_GASTOS_DETALLE_ECONOMICO.GDE_FECHA_PAGO = null ');
										
	 V_SQL := ' 
		    MERGE INTO ' ||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO T1
		    USING
		    (
			SELECT 
			DISTINCT
			GDE.GDE_ID
			FROM ' ||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
			JOIN ' ||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
			JOIN ' ||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
			JOIN ' ||V_ESQUEMA||'.PRG_PROVISION_GASTOS PRG ON PRG.PRG_ID = GPV.PRG_ID
			JOIN ' ||V_ESQUEMA||'.H_ASPRO_10_CABECERA HCAB ON HCAB.NUFREM = PRG.PRG_NUM_PROVISION
			WHERE 1 = 1
			AND DD_EGA_ID = ( SELECT DD_EGA_ID FROM ' ||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''05'' )
			AND GPV_NUM_GASTO_HAYA IN 
			(
10876015,
10876044,
10875889,
10875930,
10875931,
10875932,
10875885,
10875977,
10876034,
10876035,
10875928,
10875933,
10875944,
10876000,
10875999,
10876023,
10876054,
10876055,
10875917,
10875918,
10875985,
10875940,
10875929,
10875966,
10875979,
10875998,
10875925,
10875968,
10875978,
10876033,
10873537,
10873535,
10873538,
10873539,
10873536,
10875920,
10875980,
10876007,
10875950,
10876036,
10876017,
10876019,
10876053,
10876086,
10876095,
10899679,
10899696,
10899707,
10899713,
10899715,
10899746,
10899747,
10899749,
10899815,
10899816,
10899824,
10899837,
10899839,
10899841,
10899848,
10899849,
10899854,
10899856,
10876085,
10876087,
10876092,
10876094,
10876101,
10876103,
10876109,
10876110,
10876117,
10899673,
10899680,
10899704,
10899705,
10899706,
10899763,
10899764,
10899823,
10899829,
10899830,
10899831,
10899832,
10899846,
10899847,
10876091,
10876104,
10899675,
10899676,
10899703,
10899728,
10899735,
10899736,
10899751,
10899761,
10899776,
10899828,
10899834,
10899851,
10899852,
10875963,
10875995,
10875927,
10875926,
10875942,
10875945,
10876016,
10876045,
10876084,
10876093,
10876100,
10876102,
10899674,
10899712,
10899714,
10899729,
10899730,
10899748,
10899762,
10899838,
10899840,
10876083,
10876088,
10876089,
10876108,
10876113,
10899677,
10899702,
10899708,
10899727,
10899734,
10899744,
10899745,
10899750,
10899825,
10899833,
10899835,
10899842,
10899844,
10899850,
10899859,
10899861,
10876041,
10876090,
10876096,
10876097,
10876098,
10876099,
10876106,
10899678,
10899709,
10899710,
10899711,
10899726,
10899733,
10899759,
10899760,
10899794,
10899826,
10899827,
10899836,
10899843,
10899845,
10899853,
10875921

			)

		    ) AUX
		    ON ( T1.GDE_ID = AUX.GDE_ID )
		    WHEN MATCHED THEN UPDATE SET
			GDE_FECHA_PAGO = NULL,
	    		USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
		    	FECHAMODIFICAR   = SYSDATE  ';	

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GDE_GASTOS_DETALLE_ECONOMICO ');  

-----------------------------------------------------------------------------------------------------------------
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza estado GPV_GASTOS_PROVEEDOR cambia a ''Contabilizado'' ');
										
	 V_SQL := ' 
		    MERGE INTO ' ||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR T1
		    USING
		    (
			SELECT 
			DISTINCT
			GPV.GPV_ID
			FROM ' ||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
			JOIN ' ||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
			JOIN ' ||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
			JOIN ' ||V_ESQUEMA||'.PRG_PROVISION_GASTOS PRG ON PRG.PRG_ID = GPV.PRG_ID
			JOIN ' ||V_ESQUEMA||'.H_ASPRO_10_CABECERA HCAB ON HCAB.NUFREM = PRG.PRG_NUM_PROVISION
			WHERE 1 = 1
			AND DD_EGA_ID = ( SELECT DD_EGA_ID FROM ' ||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''05'' )
			AND GPV_NUM_GASTO_HAYA IN 
			(
10876015,
10876044,
10875889,
10875930,
10875931,
10875932,
10875885,
10875977,
10876034,
10876035,
10875928,
10875933,
10875944,
10876000,
10875999,
10876023,
10876054,
10876055,
10875917,
10875918,
10875985,
10875940,
10875929,
10875966,
10875979,
10875998,
10875925,
10875968,
10875978,
10876033,
10873537,
10873535,
10873538,
10873539,
10873536,
10875920,
10875980,
10876007,
10875950,
10876036,
10876017,
10876019,
10876053,
10876086,
10876095,
10899679,
10899696,
10899707,
10899713,
10899715,
10899746,
10899747,
10899749,
10899815,
10899816,
10899824,
10899837,
10899839,
10899841,
10899848,
10899849,
10899854,
10899856,
10876085,
10876087,
10876092,
10876094,
10876101,
10876103,
10876109,
10876110,
10876117,
10899673,
10899680,
10899704,
10899705,
10899706,
10899763,
10899764,
10899823,
10899829,
10899830,
10899831,
10899832,
10899846,
10899847,
10876091,
10876104,
10899675,
10899676,
10899703,
10899728,
10899735,
10899736,
10899751,
10899761,
10899776,
10899828,
10899834,
10899851,
10899852,
10875963,
10875995,
10875927,
10875926,
10875942,
10875945,
10876016,
10876045,
10876084,
10876093,
10876100,
10876102,
10899674,
10899712,
10899714,
10899729,
10899730,
10899748,
10899762,
10899838,
10899840,
10876083,
10876088,
10876089,
10876108,
10876113,
10899677,
10899702,
10899708,
10899727,
10899734,
10899744,
10899745,
10899750,
10899825,
10899833,
10899835,
10899842,
10899844,
10899850,
10899859,
10899861,
10876041,
10876090,
10876096,
10876097,
10876098,
10876099,
10876106,
10899678,
10899709,
10899710,
10899711,
10899726,
10899733,
10899759,
10899760,
10899794,
10899826,
10899827,
10899836,
10899843,
10899845,
10899853,
10875921

			)

		    ) AUX
		    ON ( T1.GPV_ID = AUX.GPV_ID )
		    WHEN MATCHED THEN UPDATE SET
			DD_EGA_ID = ( SELECT DD_EGA_ID FROM ' ||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''04'' ),
	    		USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
		    	FECHAMODIFICAR   = SYSDATE  ';	

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GPV_GASTOS_PROVEEDOR ');  


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
