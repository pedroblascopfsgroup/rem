--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20190201
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-3256
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización tabla 'AUX_HREOS_5185_3'
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
    V_MSQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
BEGIN

V_MSQL :=
 'CREATE TABLE REM01.AUX_HREOS_5319_3 (
ACT_ID NUMBER(16),
USU_ID_GEE NUMBER(16),
USU_ID_DIST NUMBER(16),
GEE_CUR NUMBER(16),
GEH_CUR NUMBER(16),
GEH_NEXT NUMBER(16))';
EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] TABLA AUX CREADA');

V_MSQL :=
 '
INSERT INTO REM01.AUX_HREOS_5319_3
(ACT_ID,GEE_CUR,USU_ID_GEE)
SELECT ACT.ACT_ID, GEE.GEE_ID, GEE.USU_ID 
FROM REM01.GEE_GESTOR_ENTIDAD GEE 
INNER JOIN REM01.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
INNER JOIN REM01.ACT_ACTIVO ACT ON GAC.ACT_ID = ACT.ACT_ID
INNER JOIN REM01.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID
INNER JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID
INNER JOIN REM01.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
WHERE CRA.DD_CRA_CODIGO = ''03''
AND DD_TGE_CODIGO = ''GIAADMT''
AND DD_SCM_CODIGO <> ''05''
AND GEE.BORRADO = 0';
EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] AUX CON  '|| SQL%ROWCOUNT ||' FILAS ');
V_MSQL :=
 '
MERGE INTO REM01.AUX_HREOS_5319_3 AUX
USING(
SELECT ACT_ID, USU_ID
FROM REM01.V_GESTORES_ACTIVO VGES
INNER JOIN REMMASTER.USU_USUARIOS USU
ON VGES.USERNAME = USU.USU_USERNAME
WHERE VGES.DD_CRA_CODIGO = 3
AND VGES.TIPO_GESTOR = ''GIAADMT'' 
AND VGES.DD_PRV_CODIGO IS NOT NULL) TMP
ON (TMP.ACT_ID = AUX.ACT_ID)
WHEN MATCHED THEN UPDATE
SET AUX.USU_ID_DIST = TMP.USU_ID ';
EXECUTE IMMEDIATE V_MSQL;

V_MSQL :=

 '
MERGE INTO REM01.AUX_HREOS_5319_3 AUX
USING(
SELECT DISTINCT ACT_ID, USU_ID
FROM REM01.V_GESTORES_ACTIVO VGES
INNER JOIN REMMASTER.USU_USUARIOS USU
ON VGES.USERNAME = USU.USU_USERNAME
WHERE VGES.DD_CRA_CODIGO = 3
AND VGES.TIPO_GESTOR = ''GIAADMT'' 
AND VGES.DD_PRV_CODIGO IS NOT NULL) TMP
ON (TMP.ACT_ID = AUX.ACT_ID)
WHEN MATCHED THEN UPDATE
SET AUX.USU_ID_DIST = TMP.USU_ID'
;
EXECUTE IMMEDIATE V_MSQL;

-- ELIMINAR LOS DE PROVINCIAS VACÍAS
V_MSQL := 'DELETE FROM REM01.AUX_HREOS_5319_3 WHERE USU_ID_DIST IS NULL'; 

EXECUTE IMMEDIATE V_MSQL;

V_MSQL := '
MERGE INTO REM01.AUX_HREOS_5319_3 AUX
USING(
SELECT  GEH.GEH_ID, ACT.ACT_ID
FROM REM01.GEH_GESTOR_ENTIDAD_HIST GEH
INNER JOIN REM01.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.GEH_ID = GEH.GEH_ID
INNER JOIN REM01.ACT_ACTIVO ACT ON GAH.ACT_ID = ACT.ACT_ID
INNER JOIN REM01.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID
INNER JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON GEH.DD_TGE_ID = TGE.DD_TGE_ID
INNER JOIN DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
WHERE CRA.DD_CRA_CODIGO = ''03''
AND DD_TGE_CODIGO = ''GIAADMT''
AND DD_SCM_CODIGO <> ''05''
AND GEH.GEH_FECHA_HASTA IS NULL 
) TMP
ON (TMP.ACT_ID = AUX.ACT_ID)
WHEN MATCHED THEN UPDATE
SET AUX.GEH_CUR = TMP.GEH_ID';
EXECUTE IMMEDIATE V_MSQL;

V_MSQL := '
UPDATE REM01.AUX_HREOS_5319_3
SET GEH_NEXT = S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL 
WHERE USU_ID_DIST <> USU_ID_GEE';
EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS A MODIFICAR:  '|| SQL%ROWCOUNT ||' FILAS ');

-----PASO A TABLAS FINALES
--CAMBIO USUARIO GEE
V_MSQL := '
MERGE INTO REM01.GEE_GESTOR_ENTIDAD GEE
USING 
(SELECT * FROM REM01.AUX_HREOS_5319_3 WHERE USU_ID_DIST <> USU_ID_GEE ) TMP
ON (GEE.GEE_ID = TMP.GEE_CUR)
WHEN MATCHED THEN UPDATE
SET
GEE.USU_ID = TMP.USU_ID_DIST,
GEE.USUARIOMODIFICAR = ''HREOS-5319'',
GEE.FECHAMODIFICAR = SYSDATE ';
EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS MODIFICADOS GEE:  '|| SQL%ROWCOUNT ||' FILAS ');

--FINALIZAMOS GEH
V_MSQL := '
MERGE INTO REM01.GEH_GESTOR_ENTIDAD_HIST GEH
USING 
(SELECT * FROM REM01.AUX_HREOS_5319_3 WHERE USU_ID_DIST <> USU_ID_GEE ) TMP
ON (GEH.GEH_ID = TMP.GEH_CUR)
WHEN MATCHED THEN UPDATE
SET
GEH.GEH_FECHA_HASTA = TRUNC(SYSDATE),
GEH.USUARIOMODIFICAR = ''HREOS-5319'',
GEH.FECHAMODIFICAR = SYSDATE ';

EXECUTE IMMEDIATE V_MSQL;


	DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS MODIFICADOS GEH:  '|| SQL%ROWCOUNT ||' FILAS ');

--INSERTAMOS NUEVO GEH

V_MSQL := '
INSERT INTO REM01.GEH_GESTOR_ENTIDAD_HIST
(GEH_ID,
USU_ID,
DD_TGE_ID,
GEH_FECHA_DESDE,
USUARIOCREAR,
FECHACREAR)

SELECT GEH_NEXT AS GEH_ID , 
USU_ID_DIST AS USU_ID,
(SELECT DD_TGE_ID FROM REMMASTER.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GIAADMT''),
TRUNC(SYSDATE) AS GEH_FECHA_DESDE,
''HREOS-5319'' AS USUARIOCREAR,
SYSDATE AS FECHACREAR

FROM REM01.AUX_HREOS_5319_3 WHERE USU_ID_DIST <> USU_ID_GEE';
EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS INSERTADOS GEH:  '|| SQL%ROWCOUNT ||' FILAS ');

--INSERTAMOS NUEVO GAH
V_MSQL :=
 '
INSERT INTO REM01.GAH_GESTOR_ACTIVO_HISTORICO
(GEH_ID, ACT_ID)
SELECT GEH_NEXT AS GEH_ID , ACT_ID FROM REM01.AUX_HREOS_5319_3 WHERE USU_ID_DIST <> USU_ID_GEE';
EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS INSERTADOS GAH:  '|| SQL%ROWCOUNT ||' FILAS ');

commit;

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(V_MSQL);
        ROLLBACK;
        RAISE;
END;
/

EXIT;









