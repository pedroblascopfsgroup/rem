--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200825
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7987
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
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA_AUX VARCHAR( 100 CHAR ) := 'AUX_REMVIP_7987';

    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7987'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR FECHA INFORME COMERCIAL');


	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR REGISTROS EN ACT_HIC_INF_COMER_HIST');


	V_MSQL :=   'MERGE INTO '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST T1 
		     USING(	
				SELECT 
				    HIC.HIC_ID, AUX.HIC_FECHA    				
				FROM '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST HIC
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT					 ON ACT.ACT_ID = HIC.ACT_ID
					JOIN '||V_ESQUEMA||'.AUX_REMVIP_7987 AUX 			 ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
					JOIN '||V_ESQUEMA||'.DD_AIC_ACCION_INF_COMERCIAL AIC ON AIC.DD_AIC_ID = HIC.DD_AIC_ID AND AIC.DD_AIC_CODIGO = ''02''				
				WHERE HIC.HIC_FECHA = (SELECT MAX(HIC_FECHA) FROM '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST WHERE ACT_ID = HIC.ACT_ID)
				AND HIC.BORRADO = 0 
		     ) T2
		     ON (T1.HIC_ID = T2.HIC_ID)
		     WHEN MATCHED THEN UPDATE SET		 
		     T1.HIC_FECHA = TO_DATE(T2.HIC_FECHA, ''DD/MM/YYYY''),		   		     
		     T1.FECHAMODIFICAR = SYSDATE,
		     T1.USUARIOMODIFICAR = '''||V_USR||'''';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros '); 
        DBMS_OUTPUT.PUT_LINE('[FIN] '); 

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
