--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190506
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-3594
--## PRODUCTO=NO
--## 
--## Finalidad: Actualiza cuenta y partida de los gastos incorrectos
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-3594';

BEGIN


	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD T1
				 USING (

					SELECT GPV.GPV_ID, GIC.GIC_CUENTA_CONTABLE, GIC.GIC_PTDA_PRESUPUESTARIA, 
					( SELECT CCC_CUENTA_CONTABLE
					  FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
					  WHERE CCC.DD_STG_ID = GPV.DD_STG_ID
					  AND CCC.DD_CRA_ID = ACT.DD_CRA_ID
					  AND ( CCC.DD_SCR_ID = ACT.DD_SCR_ID  OR CCC.DD_SCR_ID IS NULL) 
					  AND CCC.EJE_ID = GIC.EJE_ID
					  AND CCC_ARRENDAMIENTO = 0
					) AS PROP_CTA,	
					( SELECT CPP_PARTIDA_PRESUPUESTARIA
					  FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP
					  WHERE CPP.DD_STG_ID = GPV.DD_STG_ID
					  AND CPP.DD_CRA_ID = ACT.DD_CRA_ID 
					  AND ( CPP.DD_SCR_ID = ACT.DD_SCR_ID  OR CPP.DD_SCR_ID IS NULL) 
					  AND CPP.EJE_ID = GIC.EJE_ID
					  AND CPP_ARRENDAMIENTO = 0
					 ) AS PROP_PAR
					FROM REM01.GPV_GASTOS_PROVEEDOR GPV,
					'||V_ESQUEMA||'.ACT_ACTIVO ACT,
					'||V_ESQUEMA||'.GPV_ACT,
					'||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC,
					'||V_ESQUEMA||'.AUX_GASTOS_REMVIP_3594 AUX
					WHERE 1 = 1
					AND GPV.GPV_ID = GPV_ACT.GPV_ID
					AND ACT.ACT_ID = GPV_ACT.ACT_ID
					AND GIC.GPV_ID = GPV.GPV_ID
					AND GPV.GPV_NUM_GASTO_HAYA = AUX.GPV_NUM_GASTO_HAYA

				       ) T2 
						ON ( T1.GPV_ID = T2.GPV_ID ) 
						WHEN MATCHED THEN UPDATE SET 
							T1.GIC_CUENTA_CONTABLE 	   = T2.PROP_CTA,
							T1.GIC_PTDA_PRESUPUESTARIA = T2.PROP_PAR, 
							T1.USUARIOMODIFICAR = ''' || V_USUARIO || ''', 
							T1.FECHAMODIFICAR = SYSDATE'; 

	EXECUTE IMMEDIATE V_SQL;
		
	COMMIT;

      DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registro en la tabla GIC_GASTOS_INFO_CONTABILIDAD');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
