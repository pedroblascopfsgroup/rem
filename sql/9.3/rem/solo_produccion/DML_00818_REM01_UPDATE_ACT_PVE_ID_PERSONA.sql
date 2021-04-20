--/*
--#########################################
--## AUTOR=vIOREL rEMUS oVIDIU
--## FECHA_CREACION=20210420
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9531
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA_AUX VARCHAR( 100 CHAR ) := 'AUX_REMVIP_9531';

    V_USR VARCHAR2(30 CHAR) := 'REMVIP-9531'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR VPO EN ACTIVOS');

	V_MSQL :=  'MERGE INTO '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR T1 
		    USING(
			SELECT PVE.PVE_COD_REM, AUX.PVE_ID_PERSONA 
			FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
			INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON AUX.CODIGO_REM = PVE.PVE_COD_REM
		     ) T2
		     ON (T1.PVE_COD_REM = T2.PVE_COD_REM)
		     WHEN MATCHED THEN UPDATE SET 
		     T1.PVE_ID_PERSONA_HAYA = T2.PVE_ID_PERSONA,
		     T1.USUARIOMODIFICAR = '''||V_USR||''',
		     T1.FECHAMODIFICAR = SYSDATE';

	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros '); 

        COMMIT;

EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;

END;

/

EXIT
