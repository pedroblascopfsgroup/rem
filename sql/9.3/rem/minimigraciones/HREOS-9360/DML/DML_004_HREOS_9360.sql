--/*
--#########################################
--## AUTOR=José Antonio Gigante
--## FECHA_CREACION=20200205
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9360
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion registros 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_TABLA_TMP VARCHAR2(100 CHAR) := 'AUX_INSERTA_MOVIMIENTOS_LLAVES_ACTIVO'; -- Variable para tabla de salida para el borrado
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-9360';
	

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));
	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
		USING 
		(   
			select 
			ID
			, LLV_NUM_LLAVE
			, CASE WHEN DD_TTE_CODIGO_POSEEDOR not like ''08'' THEN MLV_COD_TENEDOR_POSEEDOR
			END MLV_COD_TENEDOR_POSEEDOR
			, CASE WHEN DD_TTE_CODIGO_POSEEDOR = ''08'' THEN MLV_COD_TENEDOR_POSEEDOR
			WHEN MLV_COD_TENEDOR_POSEEDOR IS NULL THEN ''Sin tenedor poseedor''
			END MLV_COD_TENEDOR_POSEEDOR_NO_PVE
			, CASE WHEN DD_TTE_CODIGO_PEDIDOR not like ''08'' THEN MLV_COD_TENEDOR_PEDIDOR
			END MLV_COD_TENEDOR_PEDIDOR
			, CASE WHEN DD_TTE_CODIGO_PEDIDOR = ''08'' THEN MLV_COD_TENEDOR_PEDIDOR
			WHEN MLV_COD_TENEDOR_PEDIDOR IS NULL THEN ''Sin tenedor pedidor''
			END MLV_COD_TENEDOR_PEDIDOR_NO_PVE
			from '||V_ESQUEMA||'.'||V_TABLA_TMP||'
		) AUX
    	ON (TMP.ID = AUX.ID)
    	WHEN MATCHED THEN
        	UPDATE SET
            	TMP.MLV_COD_TENEDOR_POSEEDOR = AUX.MLV_COD_TENEDOR_POSEEDOR
				, TMP.MLV_COD_TENEDOR_POSEEDOR_NO_PVE = AUX.MLV_COD_TENEDOR_POSEEDOR_NO_PVE
				, TMP.MLV_COD_TENEDOR_PEDIDOR = AUX.MLV_COD_TENEDOR_PEDIDOR
				, TMP.MLV_COD_TENEDOR_PEDIDOR_NO_PVE = AUX.MLV_COD_TENEDOR_PEDIDOR_NO_PVE';				

		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han mergeado en total '||SQL%ROWCOUNT||' registros en la tabla AUX_INSERTA_MOVIMIENTOS_LLAVES_ACTIVO');

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
