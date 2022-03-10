--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220308
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17266
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-17266] - Alejandra García
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						


create or replace PROCEDURE SP_RETENCION_GASTOS_BC (OUTPUT OUT VARCHAR2)

AS

V_MSQL VARCHAR2(32000 CHAR);
GASTOS_PROVISION NUMBER(10);
GASTOS_MANUALES NUMBER(10);
GASTOS_RETENIDOS NUMBER(10);
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GASTOS_RETENIDOS_BC (GPV_ID)
		SELECT DISTINCT
			GPV.GPV_ID
		FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
		JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
			AND PRO.BORRADO = 0
		JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID 
			AND GGE.BORRADO = 0 
		JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID 
			AND GDE.BORRADO = 0  
		JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID 
			AND GLD.BORRADO = 0
		JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GPV.GPV_ID = GIC.GPV_ID 
			AND GIC.BORRADO = 0  
		JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = GIC.EJE_ID 
			AND EJE.BORRADO = 0  
		JOIN '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA EAH ON GGE.DD_EAH_ID = EAH.DD_EAH_ID
			AND EAH.BORRADO = 0
		JOIN '||V_ESQUEMA||'.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID
			AND GEN.BORRADO = 0
		JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = GEN.DD_ENT_ID
			AND ENT.BORRADO = 0
		JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GEN.ENT_ID
			AND ACT.BORRADO = 0
		JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
			AND CRA.BORRADO = 0
		JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = GPV.PVE_ID_EMISOR 
			AND PVE.BORRADO = 0
		JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
			AND TPR.BORRADO = 0
		JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = GPV.DD_TGA_ID
			AND TGA.BORRADO = 0
		JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_TGA_ID = TGA.DD_TGA_ID 
			AND STG.DD_STG_ID = GLD.DD_STG_ID
			AND STG.BORRADO = 0
		JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON GPV.DD_EGA_ID = EGA.DD_EGA_ID
			AND EGA.BORRADO = 0
		JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON ACT.DD_SCR_ID = SCR.DD_SCR_ID
			AND SCR.BORRADO = 0
		JOIN '||V_ESQUEMA||'.DD_GRF_GESTORIA_RECEP_FICH GRF ON GRF.DD_GRF_ID = GPV.DD_GRF_ID
			AND GRF.BORRADO = 0
		WHERE GGE.GGE_FECHA_ENVIO_PRPTRIO IS NULL 
			AND TGA.DD_TGA_CODIGO IN (''01'',''02'',''09'')
			AND NVL(GLD.GLD_IMP_IND_TIPO_IMPOSITIVO, 0) = 0
			AND NVL(GLD.GLD_IMP_IND_EXENTO, 0) = 0
			AND NVL(GLD.GLD_PRINCIPAL_NO_SUJETO, 0) <> 0
			AND GPV.PRG_ID IS NULL 
			AND GPV.BORRADO = 0
			AND EAH.DD_EAH_CODIGO = ''03''
			AND ENT.DD_ENT_CODIGO = ''ACT''
			AND CRA.DD_CRA_CODIGO = ''03''
			AND (
				EGA.DD_EGA_CODIGO = (''03'')
				OR NVL(GDE.GDE_INCLUIR_PAGO_PROVISION, 0) = 1
				OR NVL(GDE.GDE_PAGADO_CONEXION_BANKIA, 0) = 1
				OR NVL(GDE.GDE_ANTICIPO, 0) = 1
			)
			AND (GGE.GGE_CLIENTE_PAGADOR = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_SOCIEDAD_PAGADORA = ''0015'')
					OR
				 GGE.GGE_CLIENTE_INFORMADOR = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_SOCIEDAD_PAGADORA = ''0015'')
				)
			AND ( 
				  EXISTS (SELECT 
							1
						  FROM PFSREM.GASTOS_COMPENSABLES_20220301_AGRUPADOS AUX
						  WHERE AUX.NIF_EMISOR = PVE.PVE_DOCIDENTIF
						 )
				OR 
				  EXISTS (SELECT 
				  			1
						  FROM PFSREM.GASTOS_PAGADOS_CXB_NO_ENVIADOS_BC AUX2
						  JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV2 ON GPV2.GPV_NUM_GASTO_HAYA = AUX2.GASTO
						  	AND GPV2.BORRADO = 0
						  JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE2 ON PVE2.PVE_ID = GPV2.PVE_ID_EMISOR
						  	AND PVE2.BORRADO = 0
						  WHERE PVE2.PVE_ID = PVE.PVE_ID
						 )
			)	
				
				';
EXECUTE IMMEDIATE V_MSQL;
GASTOS_PROVISION := SQL%ROWCOUNT;


V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GASTOS_RETENIDOS_BC (GPV_ID)
WITH PROPIETARIOS_ACTIVOS AS(
    SELECT /*+ MATERIALIZE */ GLD.GPV_ID, PRO.PRO_ID 
	FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
    JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GPV.GPV_ID = GLD.GPV_ID
    JOIN '||V_ESQUEMA||'.GLD_ENT GLDENT ON GLDENT.GLD_ID = GLD.GLD_ID
    JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = GLDENT.DD_ENT_ID AND ENT.DD_ENT_CODIGO = ''ACT''
    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACTIVO ON ACTIVO.ACT_ID = GLDENT.ENT_ID
    JOIN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID = ACTIVO.ACT_ID AND PAC.BORRADO = 0
    JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = PAC.PRO_ID AND PRO.BORRADO = 0
	JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID
    	AND CRA.BORRADO = 0
    WHERE GLD.BORRADO = 0 AND PRO.PRO_ID = GPV.PRO_ID
	AND CRA.DD_CRA_CODIGO = ''03''
    GROUP BY GLD.GPV_ID, PRO.PRO_ID
), GASTOS_UNICOS AS(
    SELECT /*+ MATERIALIZE */ GPV_ID 
	FROM PROPIETARIOS_ACTIVOS
    GROUP BY GPV_ID
    HAVING COUNT(1) = 1
), PROPIETARIOS_UNICOS AS(
    SELECT PRO.PRO_ID, GU.GPV_ID 
	FROM PROPIETARIOS_ACTIVOS PRO
    JOIN GASTOS_UNICOS GU ON GU.GPV_ID = PRO.GPV_ID
), SUMATORIO_LINEAS AS (
	SELECT GPV.GPV_ID, SUM(NVL(GLD.GLD_PRINCIPAL_SUJETO,0)
        +NVL(GLD.GLD_PRINCIPAL_NO_SUJETO,0)
        +NVL(GLD.GLD_RECARGO,0)
        +NVL(GLD.GLD_INTERES_DEMORA,0)
        +NVL(GLD.GLD_COSTAS,0)
        +NVL(GLD.GLD_OTROS_INCREMENTOS,0)
        +NVL(GLD.GLD_PROV_SUPLIDOS,0)) SUMA_IMPORTES_BASE
	FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
	JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
		AND GLD.BORRADO = 0
	WHERE GPV.BORRADO = 0
	GROUP BY GPV.GPV_ID	
)
SELECT DISTINCT
    GPV.GPV_ID
FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
JOIN '||V_ESQUEMA||'.SUMATORIO_LINEAS SUL ON SUL.GPV_ID = GPV.GPV_ID
JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID 
    AND GLD.BORRADO = 0
JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID 
    AND GDE.BORRADO = 0
JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID 
    AND GIC.BORRADO = 0
JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID 
    AND GGE.BORRADO = 0
JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
    AND EGA.BORRADO = 0
JOIN '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA DD_EAH ON DD_EAH.DD_EAH_ID = GGE.DD_EAH_ID
    AND DD_EAH.BORRADO = 0
JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = GPV.PVE_ID_EMISOR 
    AND PVE.BORRADO = 0
JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = GPV.DD_TGA_ID
	AND TGA.BORRADO = 0
JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON GLD.DD_STG_ID = STG.DD_STG_ID
    AND STG.BORRADO = 0
JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
    AND PRO.BORRADO = 0
JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID
    AND CRA.BORRADO = 0
JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = GIC.EJE_ID 
	AND EJE.BORRADO = 0 
LEFT JOIN '||V_ESQUEMA||'.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID 
    AND GEN.BORRADO = 0
LEFT JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = GEN.DD_ENT_ID 
    AND ENT.BORRADO = 0 
    AND ENT.DD_ENT_CODIGO = ''ACT''
LEFT JOIN '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO DD_TIT ON DD_TIT.DD_TIT_ID = GLD.DD_TIT_ID 
    AND DD_TIT.BORRADO = 0
LEFT JOIN '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID TDI ON TDI.DD_TDI_ID = PVE.DD_TDI_ID
    AND TDI.BORRADO = 0
LEFT JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR DD_TPR ON DD_TPR.DD_TPR_ID = PVE.DD_TPR_ID
    AND DD_TPR.BORRADO = 0
LEFT JOIN '||V_ESQUEMA||'.DD_TOG_TIPO_OPERACION_GASTO TOG ON TOG.DD_TOG_ID = GPV.DD_TOG_ID
    AND TOG.BORRADO = 0
LEFT JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV2 ON GPV.NUM_GASTO_ABONADO = GPV2.GPV_ID 
    AND GPV2.BORRADO = 0
WHERE GPV.BORRADO = 0
    AND GGE.GGE_FECHA_ENVIO_PRPTRIO IS NULL
    AND GPV.PRG_ID IS NULL
    AND DD_EAH.DD_EAH_CODIGO = ''03''
    AND CRA.DD_CRA_CODIGO = ''03''
    AND EGA.DD_EGA_CODIGO = ''03''
	AND TGA.DD_TGA_CODIGO <> ''09''
	AND NOT EXISTS (
                SELECT 1
                FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV3
                JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = GPV3.DD_TGA_ID
                    AND TGA.BORRADO = 0
                WHERE TGA.DD_TGA_CODIGO IN (''01'',''02'')
                    AND GPV3.PVE_ID_GESTORIA IS NOT NULL
                    AND GPV3.BORRADO = 0
                    AND GPV3.GPV_ID = GPV.GPV_ID
            )
    AND NOT EXISTS (
            SELECT 1
            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV2
            JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO2 ON GPV2.PRO_ID = PRO2.PRO_ID
                AND PRO2.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA2 ON PRO2.DD_CRA_ID = CRA2.DD_CRA_ID 
                AND CRA2.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.DD_DEG_ID = GPV2.DD_DEG_ID 
                AND DEG.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE2 ON GPV2.GPV_ID = GDE2.GPV_ID 
                AND GDE2.BORRADO = 0
            WHERE GPV2.GPV_ID = GPV.GPV_ID
                AND CRA2.DD_CRA_CODIGO =''03''
                AND DEG.DD_DEG_CODIGO = ''02''
                AND GDE2.GDE_GASTO_REFACTURABLE = 1
        )  
    AND (
            EXISTS (
                SELECT 1 
                FROM PROPIETARIOS_UNICOS PU
                WHERE GPV.GPV_ID = PU.GPV_ID 
                    AND GPV.PRO_ID = PU.PRO_ID
            ) OR EXISTS (
                SELECT 1 
                FROM '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD2
                LEFT JOIN '||V_ESQUEMA||'.GLD_ENT GLDENT2 ON GLDENT2.GLD_ID = GLD2.GLD_ID
                    AND GLDENT2.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO ENT2 ON ENT2.DD_ENT_ID = GLDENT2.DD_ENT_ID 
                    AND ENT2.DD_ENT_CODIGO = ''ACT''
                    AND ENT2.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACTIVO ON ACTIVO.ACT_ID = GLDENT2.ENT_ID
                    AND ACTIVO.BORRADO = 0
                WHERE GLD2.GPV_ID = GPV.GPV_ID 
                    AND GLD2.BORRADO = 0 
                    AND ACTIVO.ACT_ID IS NULL
            ) 
        )
	AND (GGE.GGE_CLIENTE_PAGADOR = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_SOCIEDAD_PAGADORA = ''0015'')
			OR
		 GGE.GGE_CLIENTE_INFORMADOR = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_SOCIEDAD_PAGADORA = ''0015'')
		)
	AND ( 
			EXISTS (SELECT 
					1
					FROM PFSREM.GASTOS_COMPENSABLES_20220301_AGRUPADOS AUX
					WHERE AUX.NIF_EMISOR = PVE.PVE_DOCIDENTIF
					)
		OR 
			EXISTS (SELECT 
					1
					FROM PFSREM.GASTOS_PAGADOS_CXB_NO_ENVIADOS_BC AUX2
					JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV2 ON GPV2.GPV_NUM_GASTO_HAYA = AUX2.GASTO
					AND GPV2.BORRADO = 0
					JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE2 ON PVE2.PVE_ID = GPV2.PVE_ID_EMISOR
					AND PVE2.BORRADO = 0
					WHERE PVE2.PVE_ID = PVE.PVE_ID
					)
	)	
		';
EXECUTE IMMEDIATE V_MSQL;
GASTOS_MANUALES := SQL%ROWCOUNT;

V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR T1
USING (
    SELECT DISTINCT GPV_ID, DD_EGA_ID
    FROM GASTOS_RETENIDOS_BC AUX
    JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_CODIGO = ''07''
        AND EGA.BORRADO = 0
) T2
ON (T1.GPV_ID = T2.GPV_ID)
WHEN MATCHED THEN
    UPDATE SET T1.DD_EGA_ID = T2.DD_EGA_ID';
EXECUTE IMMEDIATE V_MSQL;
GASTOS_RETENIDOS := SQL%ROWCOUNT;

V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GASTOS_RETENIDOS_BC T1
WHERE EXISTS (
    SELECT 1
    FROM (
        SELECT GPV_ID, ROW_NUMBER() OVER(PARTITION BY GPV_ID ORDER BY 1) RN, ROWID
        FROM GASTOS_RETENIDOS_BC) T2
    WHERE T2.RN > 1
        AND T2.GPV_ID = T2.GPV_ID
        AND T1.ROWID = T2.ROWID)';
EXECUTE IMMEDIATE V_MSQL;
OUTPUT := 'Se han insertado ' || GASTOS_PROVISION || ' gastos provisionados y ' || GASTOS_MANUALES || ' gastos manuales en la tabla GASTOS_RETENIDOS_BC. ' || GASTOS_RETENIDOS || ' gastos retenidos actualmente. Adicionalmente, se han borrado ' || SQL%ROWCOUNT || ' que estaban duplicados en la tabla de gastos retenidos';

COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      OUTPUT := OUTPUT || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      OUTPUT := OUTPUT || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END SP_RETENCION_GASTOS_BC;
/
EXIT;
