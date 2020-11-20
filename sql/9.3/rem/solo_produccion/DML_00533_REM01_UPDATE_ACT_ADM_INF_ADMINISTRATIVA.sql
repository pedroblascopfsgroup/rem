--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201112
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8359
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar datos VPO
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA_AUX VARCHAR( 100 CHAR ) := 'AUX_REMVIP_8359';

    V_USR VARCHAR2(30 CHAR) := 'REMVIP-8359'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR REGISTROS EN ACT_ADM_INF_ADMINISTRATIVA');

	V_MSQL :=   'MERGE INTO '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA T1 
		     USING(
			SELECT ADM.ACT_ID, AUX.ADM_DESCALIFICADO, AUX.ADM_FECHA_VIGENCIA
			FROM '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA ADM 
			INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ADM.ACT_ID
			INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
		     ) T2
		     ON (T1.ACT_ID = T2.ACT_ID)
		     WHEN MATCHED THEN UPDATE SET
		     T1.ADM_DESCALIFICADO = T2.ADM_DESCALIFICADO,
		     T1.ADM_VIGENCIA = T2.ADM_FECHA_VIGENCIA,		     
		     T1.FECHAMODIFICAR = SYSDATE,
		     T1.USUARIOMODIFICAR = '''||V_USR||'''';

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
