--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210527
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9782
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla 'AUX_REMVIP_9782'
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
V_TABLA VARCHAR2(40 CHAR) := 'AUX_REMVIP_9782';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
		CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
		AS (

SELECT DISTINCT CRA.DD_cRA_ID,SCR.DD_SCR_ID,GIC.EJE_ID,
GPV.GPV_NUM_GASTO_HAYA,
GLD.GLD_ID,
GPV.DD_TGA_ID,
GLD.DD_STG_ID,
GPV.PRO_ID,
NVL2(ARR.GLD_ID, 1, 0) ARRENDADO,
NVL2(VEN.GLD_ID, 1, 0) VENDIDO FROM '||V_ESQUEMA_1||'.GPV_GASTOS_PROVEEDOR GPV
JOIN '||V_ESQUEMA_1||'.gld_gastos_linea_detalle GLD ON GLD.GPV_ID=GPV.GPV_ID
JOIN '||V_ESQUEMA_1||'.act_pro_propietario PRO ON PRO.PRO_ID=GPV.PRO_ID
JOIN '||V_ESQUEMA_1||'.GLD_ENT GLENT ON GLENT.GLD_ID=GLD.GLD_ID
JOIN '||V_ESQUEMA_1||'.ACT_ACTIVO ACT ON ACT.ACT_ID=GLENT.ENT_ID
JOIN '||V_ESQUEMA_1||'.DD_cRA_CARTERA CRA ON CRA.DD_cRA_ID=ACT.DD_CRA_ID
JOIN '||V_ESQUEMA_1||'.dd_scr_subcartera SCR ON SCR.DD_SCR_ID=ACT.DD_SCR_ID
JOIN '||V_ESQUEMA_1||'.gic_gastos_info_contabilidad GIC ON GIC.GPV_ID=GPV.GPV_ID
JOIN '||V_ESQUEMA_1||'.aux_remvip_9782_gastos AUX2 ON AUX2.NUM_GASTO=gpv.gpv_num_gasto_haya
LEFT JOIN (SELECT GEN.GLD_ID, SCM.DD_SCM_CODIGO
    FROM '||V_ESQUEMA_1||'.GLD_ENT GEN
    JOIN '||V_ESQUEMA_1||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = GEN.DD_ENT_ID
        AND ENT.BORRADO = 0
    JOIN '||V_ESQUEMA_1||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GEN.ENT_ID
        AND ACT.BORRADO = 0
    JOIN '||V_ESQUEMA_1||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
        AND SCM.BORRADO = 0
    WHERE GEN.BORRADO = 0
        AND ENT.DD_ENT_CODIGO = ''ACT''
    GROUP BY GEN.GLD_ID, SCM.DD_SCM_CODIGO
    HAVING COUNT(1) = 1) VEN ON VEN.GLD_ID = GLD.GLD_ID
    AND VEN.DD_SCM_CODIGO = ''05''
LEFT JOIN (SELECT GEN.GLD_ID, SCM.DD_SCM_CODIGO
    FROM '||V_ESQUEMA_1||'.GLD_ENT GEN
    JOIN '||V_ESQUEMA_1||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = GEN.DD_ENT_ID
        AND ENT.BORRADO = 0
    JOIN '||V_ESQUEMA_1||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GEN.ENT_ID
        AND ACT.BORRADO = 0
    JOIN '||V_ESQUEMA_1||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
        AND SCM.BORRADO = 0
    WHERE GEN.BORRADO = 0
        AND ENT.DD_ENT_CODIGO = ''ACT''
    GROUP BY GEN.GLD_ID, SCM.DD_SCM_CODIGO
    HAVING COUNT(1) = 1) ARR ON ARR.GLD_ID = GLD.GLD_ID
    AND ARR.DD_SCM_CODIGO = ''10''
WHERE GPV.BORRADO=0 AND GLD.BORRADO=0 AND GIC.EJE_ID NOT IN (1,21,68,70,71,72)
AND GPV.DD_EGA_ID IN (1) AND (GLD.GLD_CCC_BASE IS NULL OR gld.gld_cpp_base IS NULL)



)'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;

IF V_ESQUEMA_3 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_3||''); 

END IF;

IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_4||''); 

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

/

EXIT;
