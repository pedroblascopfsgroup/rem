--/*
--#########################################
--## AUTOR=Pier Gotta
--## FECHA_CREACION=20220921
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18630
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
	V_TABLA_TMP VARCHAR2(30 CHAR) := 'APR_AUX_HREOS_18630'; -- Variable para tabla de salida para el borrado	
	V_TABLA VARCHAR2(30 CHAR) := 'ACT_PVE_PROVEEDOR'; -- Variable para tabla de salida para el borrado	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error	
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar	
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-18630';
	
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));
	DBMS_OUTPUT.PUT_LINE('[INFO] FUSIONANDO LOS DATOS DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_TMP||' EN LA TABLA '||V_TABLA||'');

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR 
              (PVE_ID
              , DD_TPR_ID
              , PVE_NOMBRE
              , PVE_NOMBRE_COMERCIAL
              , DD_TDI_ID
              , PVE_DOCIDENTIF
              , PVE_CP
	      , PVE_DIRECCION
              , PVE_TELF1
              , PVE_FAX
              , PVE_EMAIL
              , PVE_PAGINA_WEB
              , DD_PRV_ID
              , DD_LOC_ID
              , VERSION
              , USUARIOCREAR
              , FECHACREAR
              , BORRADO
              , PVE_COD_REM
              , PVE_FECHA_ALTA
	      , DD_EPR_ID
	      , DD_TPC_ID
	      , DD_TPE_ID
	      , PVE_LOCALIZADA
	      , PVE_HOMOLOGADO
	      , PVE_RETENER
	      , PVE_AUTORIZACION_WEB
              )
          SELECT
              '||V_ESQUEMA||'.S_ACT_PVE_PROVEEDOR.NEXTVAL PVE_ID
              , (SELECT TPR.DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR WHERE TPR.DD_TPR_CODIGO = AUX.SUBTIPO_PROVEEDOR) DD_TPR_ID
              , AUX.NOMBRE AS PVE_NOMBRE
              , AUX.NOMBRE AS PVE_NOMBRE_COMERCIAL
              , (SELECT TDI.DD_TDI_ID FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID TDI WHERE TDI.DD_TDI_CODIGO = ''02'') DD_TDI_ID
              , AUX.CIF AS PVE_DOCIDENTIF
              , AUX.COD_POSTAL AS PVE_CP
              , AUX.CALLE AS PVE_DIRECCION
              , AUX.TELEFONO AS PVE_TELF1
              , AUX.FAX AS PVE_FAX
              , SUBSTR(AUX.EMAIL,1,50) AS PVE_EMAIL
              , SUBSTR(AUX.WEB, 1,50)  AS  PVE_PAGINA_WEB
              , (SELECT PRV.DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV WHERE PRV.DD_PRV_CODIGO = AUX.PROVINCIA_COD)
              , (SELECT LOC.DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC WHERE LOC.DD_LOC_CODIGO = AUX.LOCALIDAD)
              , 0 VERSION
              , '''||V_USUARIO||''' USUARIOCREAR
              , SYSDATE FECHACREAR
              , 0 BORRADO
              , '||V_ESQUEMA||'.S_PVE_COD_REM.NEXTVAL PVE_COD_REM
              , SYSDATE PVE_FECHA_ALTA
              , (SELECT EPR.DD_EPR_ID FROM '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR EPR WHERE EPR.DD_EPR_CODIGO = ''04'') DD_EPR_ID
	      , (SELECT TPC.DD_TPC_ID FROM '||V_ESQUEMA||'.DD_TPC_TIPOS_COLABORADOR TPC WHERE TPC.DD_TPC_CODIGO = ''01'') DD_TPC_ID
	      , (SELECT TPE.DD_TPE_ID FROM '||V_ESQUEMA_M||'.DD_TPE_TIPO_PERSONA TPE WHERE TPE.DD_TPE_CODIGO = ''2'') DD_TPE_ID
	      , 1 PVE_LOCALIZADA
	      , 1 PVE_HOMOLOGADO
	      , 0 PVE_RETENER
	      , 0 PVE_AUTORIZACION_WEB
              FROM '||V_ESQUEMA||'.APR_AUX_HREOS_18630 AUX WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE WHERE PVE.PVE_DOCIDENTIF = AUX.CIF AND PVE.BORRADO = 0)';
              
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han fusionado un total de '||SQL%ROWCOUNT||' filas de la tabla ACT_ETP_ENTIDAD_PROVEEDOR');

	COMMIT;
	
	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||'[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE)||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||'-----------------------------------------------------------'||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||SQLERRM||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||V_SQL||CHR(10);
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
