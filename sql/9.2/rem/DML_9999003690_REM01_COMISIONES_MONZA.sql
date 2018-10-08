--/*
--#########################################
--## AUTOR=JINLI, HU
--## FECHA_CREACION=20181007
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=?
--## INCIDENCIA_LINK=REMVIP-2190
--## PRODUCTO=NO
--## 
--## Finalidad: 
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

	V_TABLA VARCHAR2(30 CHAR) := 'GEX_GASTOS_EXPEDIENTE'; -- Variable para tabla de salida para el borrado
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-2190';

BEGIN
	
	PL_OUTPUT := '[INICIO]'||CHR(10);

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
					USING (
					SELECT DISTINCT
					gex.GEX_ID,
					ofr.ofr_num_oferta, 
					ofr.OFR_IMPORTE, 
					ofr.OFR_IMPORTE_CONTRAOFERTA, 
					act.ACT_NUM_ACTIVO, 
					gex.GEX_IMPORTE_CALCULO, 
					ao.ACT_OFR_IMPORTE, 
					gex.GEX_IMPORTE_FINAL, 
					accion.dd_acc_descripcion 
					from REM_EXT.TMP_MONZA_FIN tmp
					join '||V_ESQUEMA||'.ofr_ofertas ofr on ofr.ofr_num_oferta = tmp.ofr_num_oferta
					join '||V_ESQUEMA||'.eco_expediente_comercial eco on eco.ofr_id = ofr.ofr_id
					join '||V_ESQUEMA||'.GEX_GASTOS_EXPEDIENTE gex on gex.eco_id = eco.eco_id
					join '||V_ESQUEMA||'.act_activo act on act.act_id = gex.act_id
					join '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS accion on accion.dd_acc_id = gex.dd_acc_id
					join '||V_ESQUEMA||'.DD_TPH_TIPO_PROV_HONORARIO tph on tph.dd_tph_id = gex.dd_tph_id
					join '||V_ESQUEMA||'.act_ofr ao on ao.act_id = act.act_id
					WHERE gex.USUARIOMODIFICAR <> ''REMVIP-2190'') T2 ON (T1.GEX_ID = T2.GEX_ID)
					WHEN MATCHED THEN UPDATE SET 
					T1.GEX_IMPORTE_FINAL = T1.GEX_IMPORTE_FINAL * (CASE WHEN T1.DD_ACC_ID = (SELECT ACC.DD_ACC_ID FROM DD_ACC_ACCION_GASTOS ACC WHERE ACC.DD_ACC_CODIGO = ''04'')
																		THEN 0.75
																		WHEN T1.DD_ACC_ID = (SELECT ACC.DD_ACC_ID FROM DD_ACC_ACCION_GASTOS ACC WHERE ACC.DD_ACC_CODIGO = ''05'')
																		THEN 0.25
																   END),
					T1.USUARIOMODIFICAR = ''REMVIP-2190'',
					T1.FECHAMODIFICAR = SYSDATE';
	
	EXECUTE IMMEDIATE V_SQL;

	COMMIT;

	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||'[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE)||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||'-----------------------------------------------------------'||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||SQLERRM||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||V_SQL||CHR(10);
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
