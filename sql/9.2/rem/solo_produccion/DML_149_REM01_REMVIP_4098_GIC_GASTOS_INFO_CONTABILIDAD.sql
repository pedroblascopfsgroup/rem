--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190625
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-4098
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar datos diversos
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

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema	
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    	V_SQL VARCHAR2(4000 CHAR); -- Vble. sentencia a ejecutar.

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]'); 

	-------------------------------------------------------------------------------------------
	-- => CAT_REF_CATASTRAL

	DBMS_OUTPUT.PUT_LINE('[INFO] Preparando actualización de GIC_GASTOS_INFO_CONTABILIDAD '); 
	V_SQL :=
	       'MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD T1 
		USING (

			SELECT GIC.GIC_ID
			FROM '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC, '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV, '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
			WHERE 1 = 1
			AND GIC.GPV_ID = GPV.GPV_ID
			AND GPV.GPV_ID IN
					(
					SELECT GPV_ID
					FROM
						(
							 SELECT GPV_ID,GIC_ID,ROW_NUMBER() OVER (PARTITION BY GPV_ID ORDER BY 1 ASC) AS RN
					                 FROM '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
                      					 WHERE GIC.BORRADO = 0
                      					 ORDER BY 1 ASC
						)
					WHERE RN > 1
					)
			AND GIC.GIC_CUENTA_CONTABLE = CCC.CCC_CUENTA_CONTABLE
			AND CCC.BORRADO = 1
			AND CCC.EJE_ID = ( SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = ''2019'' )
			AND CCC.DD_CRA_ID = ( SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO  = ''12'' )
			AND CCC.DD_STG_ID = GPV.DD_STG_ID


		) T2
			ON (T1.GIC_ID = T2.GIC_ID )
		WHEN MATCHED THEN UPDATE
               	SET T1.BORRADO = 1, 
		    T1.USUARIOBORRAR = ''REMVIP-4098'', 
		    T1.FECHABORRAR= SYSDATE
		';

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] '||SQL%ROWCOUNT||' registros actualizados.'); 


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
