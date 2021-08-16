--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210804
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10280
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar error de activos
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-10280';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			
			

-----------------------------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ERROR a 0 en BBVA_VT1_ST6');


    --GASTOS < 2016 CUENTAS
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.BBVA_VT1_ST6 T1
		        USING (
                    SELECT DISTINCT ST6.ACT_ID,ST6.ERROR,ST6.COD_ERROR FROM REM01.BBVA_VT1_ST6 ST6 
                    WHERE st6.cod_error IN (''108'', ''088'', ''086'', ''022'') AND ST6.ERROR=1
                
        		) T2 
        	  ON (T1.ACT_ID = T2.ACT_ID  AND T1.COD_ERROR=T2.COD_ERROR )
				WHEN MATCHED THEN UPDATE SET 
                    T1.ERROR = 0
                    WHERE T1.ERROR = 1';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' ACTIVOS en BBVA_VT1_ST6');  



-----------------------------------------------------------------------------------------------------------------


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
