--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200409
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6922
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-6922'; -- Incidencia Link
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
    
    DBMS_OUTPUT.put_line('[INICIO]');

    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.OFR_OFERTAS OFR USING (
		    SELECT DISTINCT OFR.OFR_ID,  PVE_ID, PVE_COD_REM
		    FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
		    INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
		    inner join '||V_ESQUEMA||'.mig2_ofr_ofertas MIG on MIG.OFR_COD_PRESCRIPTOR = pve.pve_cod_origen
		    INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = MIG.OFR_COD_OFERTA
		    WHERE
		    TPR.DD_TPR_CODIGO IN (''04'',''18'',''23'',''28'',''29'',''30'',''31'',''38'')
		    AND PVE.PVE_COD_ORIGEN = TO_CHAR(MIG.OFR_COD_PRESCRIPTOR)
		    AND PVE_ID_PRESCRIPTOR IS NULL
		) TMP
		ON (TMP.OFR_ID = OFR.OFR_ID)
		WHEN MATCHED THEN UPDATE SET
		OFR.PVE_ID_PRESCRIPTOR = PVE_ID,
		OFR.USUARIOMODIFICAR = ''REMVIP-6911'',
		OFR.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.put_line('[INFO] Se han borrado '||SQL%ROWCOUNT||' tareas de trabajos de Divarian.');

    V_SQL := 'MERGE INTO OFR_OFERTAS OFR USING (
		    SELECT DISTINCT OFR.OFR_ID,  PVE_ID
		    FROM ACT_PVE_PROVEEDOR PVE
		    INNER JOIN DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
		     inner join mig2_ofr_ofertas MIG on MIG.OFR_COD_PRESCRIPTOR = pve.pve_cod_REM
		     INNER JOIN OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = MIG.OFR_COD_OFERTA
		     WHERE
		     TPR.DD_TPR_CODIGO IN (''04'',''18'',''23'',''28'',''29'',''30'',''31'',''38'')
		      AND
		      PVE_ID_PRESCRIPTOR IS NULL
		      AND PVE_COD_REM IN (110167296, 6877, 110167484, 2321)
		) TMP
		ON (TMP.OFR_ID = OFR.OFR_ID)
		WHEN MATCHED THEN UPDATE SET
		OFR.PVE_ID_PRESCRIPTOR = PVE_ID,
		OFR.USUARIOMODIFICAR = ''REMVIP-6911_2'',
		OFR.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.put_line('[INFO] Se han borrado '||SQL%ROWCOUNT||' tareas de trabajos de Divarian.');

COMMIT;
    
    DBMS_OUTPUT.put_line('[FIN]');
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
