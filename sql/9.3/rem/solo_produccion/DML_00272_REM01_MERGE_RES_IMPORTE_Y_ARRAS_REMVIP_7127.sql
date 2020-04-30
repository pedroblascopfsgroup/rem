--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200424
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7127
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva. RESERVAS importe y arras
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	PL_OUTPUT VARCHAR2(32000 CHAR);

	V_COUNT NUMBER(25);
	
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Se van a actualizar ACT_ICO_INFO_COMERCIAL > Descripcion comercial desde AUX_DESCRIPCION_COMERCIAL_REMVIP_7064.');

	execute immediate 'MERGE INTO '||V_ESQUEMA||'.RES_RESERVAS T1 USING (
	    SELECT DISTINCT
	    OFR.OFR_ID, OFR.OFR_NUM_OFERTA, OFR.DD_EOF_ID, ECO.ECO_NUM_EXPEDIENTE, RES.RES_ID, RES.DD_TAR_ID, TAR.DD_TAR_ID DD_TAR_ID_NUEVO, COE.COE_ID, COE.COE_IMPORTE_RESERVA, AUX.IMPORTE
	    FROM '||V_ESQUEMA||'.aux_res_importe_y_arras_remvip_7127 AUX
	    left JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = AUX.OFERTA
	    LEFT JOIN '||V_ESQUEMA||'.eco_expediente_comercial ECO ON ECO.OFR_ID = OFR.OFR_ID
	    LEFT JOIN '||V_ESQUEMA||'.res_reservas RES ON RES.ECO_ID = ECO.ECO_ID
	    LEFT JOIN '||V_ESQUEMA||'.coe_condicionantes_expediente COE ON COE.ECO_ID = ECO.ECO_ID
	    LEFT JOIN '||V_ESQUEMA||'.dd_tar_tipos_arras TAR ON upper(TAR.DD_TAR_DESCRIPCION) = upper(AUX.ARRAS)
	) T2
	ON (T1.RES_ID = T2.RES_ID)
	WHEN MATCHED THEN UPDATE SET
	T1.DD_TAR_ID = T2.DD_TAR_ID_NUEVO,
	T1.USUARIOMODIFICAR = ''REMVIP-7127'',
	T1.FECHAMODIFICAR = SYSDATE';

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en RES_RESERVAS. Deberian ser 390 ');  

	COMMIT;

	execute immediate 'MERGE INTO '||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE T1 USING (
	    SELECT DISTINCT
	    OFR.OFR_ID, OFR.OFR_NUM_OFERTA, OFR.DD_EOF_ID, ECO.ECO_NUM_EXPEDIENTE, RES.RES_ID, RES.DD_TAR_ID, TAR.DD_TAR_ID DD_TAR_ID_NUEVO, COE.COE_ID, COE.COE_IMPORTE_RESERVA, AUX.IMPORTE
	    FROM '||V_ESQUEMA||'.aux_res_importe_y_arras_remvip_7127 AUX
	    left JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = AUX.OFERTA
	    LEFT JOIN '||V_ESQUEMA||'.eco_expediente_comercial ECO ON ECO.OFR_ID = OFR.OFR_ID
	    LEFT JOIN '||V_ESQUEMA||'.res_reservas RES ON RES.ECO_ID = ECO.ECO_ID
	    LEFT JOIN '||V_ESQUEMA||'.coe_condicionantes_expediente COE ON COE.ECO_ID = ECO.ECO_ID
	    LEFT JOIN '||V_ESQUEMA||'.dd_tar_tipos_arras TAR ON upper(TAR.DD_TAR_DESCRIPCION) = upper(AUX.ARRAS)
	) T2
	ON (T1.COE_ID = T2.COE_ID)
	WHEN MATCHED THEN UPDATE SET
	T1.COE_IMPORTE_RESERVA = T2.IMPORTE,
	T1.USUARIOMODIFICAR = ''REMVIP-7127'',
	T1.FECHAMODIFICAR = SYSDATE';

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en COE_CONDICIONANTES_EXPEDIENTE. Deberian ser 395 ');  

	COMMIT;

    
    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);    
    ROLLBACK;
    RAISE;        

END;
/
EXIT;
