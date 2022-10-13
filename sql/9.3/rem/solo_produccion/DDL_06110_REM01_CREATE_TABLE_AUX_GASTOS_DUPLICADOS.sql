--/*
--#########################################
--## AUTOR=Remus Ovidiu
--## FECHA_CREACION=20220922
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP_12544
--## PRODUCTO=NO
--## 
--## Finalidad:
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

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA_1 VARCHAR2(20 CHAR) := 'REM01';
V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REMMASTER'; --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';
V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := 'REM_IDX';
V_TABLA VARCHAR2(40 CHAR) := 'GASTOS_SALIENTES_SP_REMVIP_12544';
V_TABLA_2 VARCHAR2(40 CHAR) := 'GASTOS_SALIENTES_CP_REMVIP_12544';
V_TABLA_3 VARCHAR2(40 CHAR) := 'GASTOS_ENVIADOS_SP_23_27_REMVIP_12544';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA_2||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA_2||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA_2||'';
    
END IF;

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA_3||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA_3||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA_3||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||' AS
(
select * from (
WITH PROPIETARIOS_ACTIVOS AS(
    SELECT /*+ MATERIALIZE */ GLD.GPV_ID, PRO.PRO_ID 
	FROM REM01.GPV_GASTOS_PROVEEDOR GPV
    JOIN '||V_ESQUEMA_1||'.GLD_GASTOS_LINEA_DETALLE GLD ON GPV.GPV_ID = GLD.GPV_ID
    JOIN '||V_ESQUEMA_1||'.GLD_ENT GLDENT ON GLDENT.GLD_ID = GLD.GLD_ID
    JOIN '||V_ESQUEMA_1||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = GLDENT.DD_ENT_ID AND ENT.DD_ENT_CODIGO = ''ACT''
    JOIN '||V_ESQUEMA_1||'.ACT_ACTIVO ACTIVO ON ACTIVO.ACT_ID = GLDENT.ENT_ID
    JOIN '||V_ESQUEMA_1||'.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID = ACTIVO.ACT_ID AND PAC.BORRADO = 0
    JOIN '||V_ESQUEMA_1||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = PAC.PRO_ID AND PRO.BORRADO = 0
	JOIN '||V_ESQUEMA_1||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID
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
	FROM '||V_ESQUEMA_1||'.GPV_GASTOS_PROVEEDOR GPV
	JOIN '||V_ESQUEMA_1||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
		AND GLD.BORRADO = 0
	WHERE GPV.BORRADO = 0
	GROUP BY GPV.GPV_ID	
)
SELECT DISTINCT
    GPV.GPV_NUM_GASTO_HAYA AS FAC_ID_REM,
    gpv.dd_ega_id

FROM '||V_ESQUEMA_1||'.GPV_GASTOS_PROVEEDOR GPV
JOIN SUMATORIO_LINEAS SUL ON SUL.GPV_ID = GPV.GPV_ID
JOIN '||V_ESQUEMA_1||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID 
    AND GLD.BORRADO = 0
JOIN '||V_ESQUEMA_1||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID 
    AND GDE.BORRADO = 0
JOIN '||V_ESQUEMA_1||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID 
    AND GIC.BORRADO = 0
JOIN '||V_ESQUEMA_1||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID 
    AND GGE.BORRADO = 0
JOIN '||V_ESQUEMA_1||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
    AND EGA.BORRADO = 0
JOIN '||V_ESQUEMA_1||'.DD_EAH_ESTADOS_AUTORIZ_HAYA DD_EAH ON DD_EAH.DD_EAH_ID = GGE.DD_EAH_ID
    AND DD_EAH.BORRADO = 0
JOIN '||V_ESQUEMA_1||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = GPV.PVE_ID_EMISOR 
    AND PVE.BORRADO = 0
JOIN '||V_ESQUEMA_1||'.DD_STG_SUBTIPOS_GASTO STG ON GLD.DD_STG_ID = STG.DD_STG_ID
    AND STG.BORRADO = 0
JOIN '||V_ESQUEMA_1||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
    AND PRO.BORRADO = 0
JOIN '||V_ESQUEMA_1||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID
    AND CRA.BORRADO = 0
JOIN '||V_ESQUEMA_1||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = GIC.EJE_ID 
    AND EJE.BORRADO = 0 
LEFT JOIN '||V_ESQUEMA_1||'.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID 
    AND GEN.BORRADO = 0
LEFT JOIN '||V_ESQUEMA_1||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = GEN.DD_ENT_ID 
    AND ENT.BORRADO = 0 
    AND ENT.DD_ENT_CODIGO = ''ACT''
LEFT JOIN '||V_ESQUEMA_1||'.DD_TIT_TIPOS_IMPUESTO DD_TIT ON DD_TIT.DD_TIT_ID = GLD.DD_TIT_ID 
    AND DD_TIT.BORRADO = 0
LEFT JOIN '||V_ESQUEMA_1||'.DD_TDI_TIPO_DOCUMENTO_ID TDI ON TDI.DD_TDI_ID = PVE.DD_TDI_ID
    AND TDI.BORRADO = 0
LEFT JOIN '||V_ESQUEMA_1||'.DD_TPR_TIPO_PROVEEDOR DD_TPR ON DD_TPR.DD_TPR_ID = PVE.DD_TPR_ID
    AND DD_TPR.BORRADO = 0
LEFT JOIN '||V_ESQUEMA_1||'.DD_TOG_TIPO_OPERACION_GASTO TOG ON TOG.DD_TOG_ID = GPV.DD_TOG_ID
    AND TOG.BORRADO = 0
LEFT JOIN '||V_ESQUEMA_1||'.GPV_GASTOS_PROVEEDOR GPV2 ON GPV.NUM_GASTO_ABONADO = GPV2.GPV_ID 
    AND GPV2.BORRADO = 0
JOIN '||V_ESQUEMA_1||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = GPV.DD_TGA_ID
    AND TGA.BORRADO = 0
WHERE GPV.BORRADO = 0
    AND (GPV.PRG_ID IS NULL OR STG.DD_STG_CODIGO IN (''237'', ''238'', ''239''))
    AND DD_EAH.DD_EAH_CODIGO = ''03''
    AND CRA.DD_CRA_CODIGO = ''03''
    AND EGA.DD_EGA_CODIGO IN (''03'',''10'')
	AND TGA.DD_TGA_CODIGO NOT IN (''09'',''18'')
	AND STG.DD_STG_CODIGO NOT IN (''89'')
	AND NOT EXISTS (
			SELECT 1
            FROM '||V_ESQUEMA_1||'.GPV_GASTOS_PROVEEDOR GPV3
            JOIN '||V_ESQUEMA_1||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV3.GPV_ID
                AND GLD.BORRADO = 0
			JOIN '||V_ESQUEMA_1||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = GPV3.DD_TGA_ID
                AND TGA.BORRADO = 0
            JOIN '||V_ESQUEMA_1||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = GLD.DD_STG_ID
                AND STG.BORRADO = 0
            WHERE TGA.DD_TGA_CODIGO IN (''01'',''02'')
                AND STG.DD_STG_CODIGO NOT IN (''237'', ''238'', ''239'')
                AND GPV3.PVE_ID_GESTORIA IS NOT NULL
                AND GPV3.BORRADO = 0
                AND GPV3.GPV_ID = GPV.GPV_ID
	)
    AND NOT EXISTS (
            SELECT 1
            FROM '||V_ESQUEMA_1||'.GPV_GASTOS_PROVEEDOR GPV2
            JOIN '||V_ESQUEMA_1||'.ACT_PRO_PROPIETARIO PRO2 ON GPV2.PRO_ID = PRO2.PRO_ID
                AND PRO2.BORRADO = 0
            JOIN '||V_ESQUEMA_1||'.DD_CRA_CARTERA CRA2 ON PRO2.DD_CRA_ID = CRA2.DD_CRA_ID 
                AND CRA2.BORRADO = 0
            JOIN '||V_ESQUEMA_1||'.DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.DD_DEG_ID = GPV2.DD_DEG_ID 
                AND DEG.BORRADO = 0
            JOIN '||V_ESQUEMA_1||'.GDE_GASTOS_DETALLE_ECONOMICO GDE2 ON GPV2.GPV_ID = GDE2.GPV_ID 
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
                FROM '||V_ESQUEMA_1||'.GLD_GASTOS_LINEA_DETALLE GLD2
                LEFT JOIN '||V_ESQUEMA_1||'.GLD_ENT GLDENT2 ON GLDENT2.GLD_ID = GLD2.GLD_ID
                    AND GLDENT2.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA_1||'.DD_ENT_ENTIDAD_GASTO ENT2 ON ENT2.DD_ENT_ID = GLDENT2.DD_ENT_ID 
                    AND ENT2.DD_ENT_CODIGO = ''ACT''
                    AND ENT2.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA_1||'.ACT_ACTIVO ACTIVO ON ACTIVO.ACT_ID = GLDENT2.ENT_ID
                    AND ACTIVO.BORRADO = 0
                WHERE GLD2.GPV_ID = GPV.GPV_ID 
                    AND GLD2.BORRADO = 0 
                    AND ACTIVO.ACT_ID IS NULL
            )
        )
	AND (
		(GGE.GGE_CLIENTE_PAGADOR = (SELECT PRO_ID FROM '||V_ESQUEMA_1||'.ACT_PRO_PROPIETARIO WHERE PRO_SOCIEDAD_PAGADORA = ''0015'') AND GGE.GGE_FECHA_ENVIO_PRPTRIO IS NULL)
		 OR 
		 (GGE.GGE_CLIENTE_INFORMADOR = (SELECT PRO_ID FROM '||V_ESQUEMA_1||'.ACT_PRO_PROPIETARIO WHERE PRO_SOCIEDAD_PAGADORA = ''0015'') AND GGE.GGE_FECHA_ENVIO_INFORMATIVA IS NULL)
		)
)
)'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA_2||' AS
(
SELECT 
GPV_ID,
gpv_num_gasto_haya,
dd_ega_id
FROM (
	SELECT
		GPV_ID,
        gpv_num_gasto_haya,
         dd_ega_id
		, PVE_ID_GESTORIA
		, PRO_ID
		, DD_TGA_ID
		, ANYO_DEVENGO
		, NULL AS BH_VENDIDO
		, 0 AS PRG_ID
		, TO_NUMBER(RK || CEIL(RN/999)) R
		, ROW_NUMBER() OVER(PARTITION BY GPV_ID ORDER BY 1) RW
	FROM (
		SELECT 
			GPV.GPV_ID,
            gpv.gpv_num_gasto_haya,
            gpv.dd_ega_id
			, GPV.PVE_ID_GESTORIA
			, PRO.PRO_ID
			, DECODE(GPV.DD_TGA_ID,2,1,GPV.DD_TGA_ID) AS DD_TGA_ID
			, TO_CHAR(GPV.GPV_FECHA_EMISION,''YY'') AS ANYO_DEVENGO
			, RANK() OVER (
				ORDER BY GPV.PVE_ID_GESTORIA
					, PRO.PRO_ID
					, DECODE(TGA.DD_TGA_CODIGO,''02'',1,GPV.DD_TGA_ID)
					, TO_CHAR(GPV.GPV_FECHA_EMISION,''YYYYMMDD'')
					, GDE.GDE_ANTICIPO
					, DECODE(STG.DD_STG_CODIGO,''04'',1, 0)
					, DECODE(SCR.DD_SCR_CODIGO,''14'',1, 0)    
					, CASE WHEN GDE.GDE_IMPORTE_TOTAL < 0 THEN ''GASTO NEGATIVO'' ELSE ''GASTO POSITIVO'' END   
				) AS RK
			, ROW_NUMBER() OVER (
				PARTITION BY GPV.PVE_ID_GESTORIA
					, PRO.PRO_ID
					, DECODE(TGA.DD_TGA_CODIGO,''02'',1,GPV.DD_TGA_ID)
					, TO_CHAR(GPV.GPV_FECHA_EMISION,''YYYYMMDD'')
					, GDE.GDE_ANTICIPO
					, DECODE(STG.DD_STG_CODIGO,''04'',1, 0)
					, DECODE(SCR.DD_SCR_CODIGO,''14'',1, 0)    
					, CASE WHEN GDE.GDE_IMPORTE_TOTAL < 0 THEN ''GASTO NEGATIVO'' ELSE ''GASTO POSITIVO'' END  
				ORDER BY 1 
				) AS RN
		FROM '||V_ESQUEMA_1||'.GPV_GASTOS_PROVEEDOR GPV
		JOIN '||V_ESQUEMA_1||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
			AND PRO.BORRADO = 0
		JOIN '||V_ESQUEMA_1||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID 
			AND GGE.BORRADO = 0 
		JOIN '||V_ESQUEMA_1||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID 
			AND GDE.BORRADO = 0  
		JOIN '||V_ESQUEMA_1||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID 
			AND GLD.BORRADO = 0
		JOIN '||V_ESQUEMA_1||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GPV.GPV_ID = GIC.GPV_ID 
			AND GIC.BORRADO = 0  
		JOIN '||V_ESQUEMA_1||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = GIC.EJE_ID 
			AND EJE.BORRADO = 0  
		JOIN '||V_ESQUEMA_1||'.DD_EAH_ESTADOS_AUTORIZ_HAYA EAH ON GGE.DD_EAH_ID = EAH.DD_EAH_ID
			AND EAH.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA_1||'.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID
			AND GEN.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA_1||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = GEN.DD_ENT_ID
			AND ENT.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA_1||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GEN.ENT_ID
			AND ACT.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA_1||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
			AND CRA.BORRADO = 0
		JOIN '||V_ESQUEMA_1||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = GPV.PVE_ID_EMISOR 
			AND PVE.BORRADO = 0
		JOIN '||V_ESQUEMA_1||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
			AND TPR.BORRADO = 0
		JOIN '||V_ESQUEMA_1||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = GPV.DD_TGA_ID
			AND TGA.BORRADO = 0
		JOIN '||V_ESQUEMA_1||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_TGA_ID = TGA.DD_TGA_ID 
			AND STG.DD_STG_ID = GLD.DD_STG_ID
			AND STG.BORRADO = 0
		JOIN '||V_ESQUEMA_1||'.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_ID = GPV.DD_TPE_ID
			AND TPE.BORRADO = 0
		JOIN '||V_ESQUEMA_1||'.DD_EGA_ESTADOS_GASTO EGA ON GPV.DD_EGA_ID = EGA.DD_EGA_ID
			AND EGA.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA_1||'.DD_SCR_SUBCARTERA SCR ON ACT.DD_SCR_ID = SCR.DD_SCR_ID
			AND SCR.BORRADO = 0
		JOIN '||V_ESQUEMA_1||'.DD_GRF_GESTORIA_RECEP_FICH GRF ON GRF.DD_GRF_ID = GPV.DD_GRF_ID
			AND GRF.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA_1||'.ACT_PTA_PATRIMONIO_ACTIVO PTA ON PTA.ACT_ID = ACT.ACT_ID
   			AND PTA.BORRADO = 0
		WHERE TGA.DD_TGA_CODIGO IN (''01'',''02'',''09'',''18'')
			AND STG.DD_STG_CODIGO NOT IN (''237'',''238'',''239'',''254'',''90'',''98'',''99'',''255'',''91'')
			AND GPV.PVE_ID_GESTORIA IS NOT NULL
			AND GPV.PRG_ID IS NULL 
			AND GPV.BORRADO = 0
			AND GRF.NUCLII IS NOT NULL
			AND EAH.DD_EAH_CODIGO = ''03''
			AND ENT.DD_ENT_CODIGO = ''ACT''
			AND CRA.DD_CRA_CODIGO = ''03''
			AND (
				EGA.DD_EGA_CODIGO IN (''03'',''10'')
				OR NVL(GDE.GDE_INCLUIR_PAGO_PROVISION, 0) = 1
				OR NVL(GDE.GDE_PAGADO_CONEXION_BANKIA, 0) = 1
				OR NVL(GDE.GDE_ANTICIPO, 0) = 1
			)
AND (
		(GGE.GGE_CLIENTE_PAGADOR = (SELECT PRO_ID FROM '||V_ESQUEMA_1||'.ACT_PRO_PROPIETARIO WHERE PRO_SOCIEDAD_PAGADORA = ''0015'') AND GGE.GGE_FECHA_ENVIO_PRPTRIO IS NULL)
		 OR 
		 (GGE.GGE_CLIENTE_INFORMADOR = (SELECT PRO_ID FROM '||V_ESQUEMA_1||'.ACT_PRO_PROPIETARIO WHERE PRO_SOCIEDAD_PAGADORA = ''0015'') AND GGE.GGE_FECHA_ENVIO_INFORMATIVA IS NULL)
		)

	) 
)
	WHERE RW = 1
)'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA_2||' CREADA');  

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA_3||' AS
(		
SELECT gpv.gpv_id, gpv.gpv_num_gasto_haya, gpv.dd_ega_id, gge.gge_fecha_envio_prptrio, gge.gge_fecha_envio_informativa
FROM '||V_ESQUEMA_1||'.h_apr_aux_i_ru_fact_sin_prov AUX
inner join '||V_ESQUEMA_1||'.gpv_gastos_proveedor gpv on gpv.gpv_num_gasto_haya = AUX.FAC_ID_REM
inner join '||V_ESQUEMA_1||'.gge_gastos_gestion gge on gge.gpv_id = gpv.gpv_id
WHERE TRUNC(AUX.fecha_procesado)>=TRUNC(TO_DATE(''23/09/2022'',''DD/MM/YYYY'')) 
AND TRUNC(AUX.fecha_procesado)<=TRUNC(TO_DATE(''28/09/2022'',''DD/MM/YYYY''))
)'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA_3||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||''); 
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA_2||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA_2||' OTORGADOS A '||V_ESQUEMA_2||''); 
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA_3||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA_3||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;

IF V_ESQUEMA_3 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_3||''); 
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA_2||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA_2||' OTORGADOS A '||V_ESQUEMA_3||''); 
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA_3||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA_3||' OTORGADOS A '||V_ESQUEMA_3||''); 

END IF;

IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_4||''); 
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA_2||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA_2||' OTORGADOS A '||V_ESQUEMA_4||''); 
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA_3||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA_3||' OTORGADOS A '||V_ESQUEMA_4||''); 

END IF;

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;

