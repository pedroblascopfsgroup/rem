--/*
--#########################################
--## AUTOR=José Antonio Gigante
--## FECHA_CREACION=20190723
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.17.0
--## INCIDENCIA_LINK=HREOS-6920
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion registros ID_CES e ID_SNTANDER de la tabla ACT_ACTIVO.
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_TABLA_TMP VARCHAR2(30 CHAR) := 'TMP_ACT_ACTIVO_SANTANDER'; -- Variable para tabla de salida para el borrado
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-6920';
	

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));
	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT
		USING 
		(   SELECT
        	A.ACT_ID,
        	CASE S.ID_SERVICER
            	WHEN ''n.a.'' THEN null
            	WHEN ''#N/D'' THEN null
            	ELSE S.ID_SERVICER
        	END
        	AS ID_CES,
        	CASE S.ID_INMUEBLE_BS
            	WHEN ''n.a.'' THEN null
            	WHEN ''#N/D'' THEN null
            ELSE S.ID_INMUEBLE_BS
        	END
        	AS ID_SANTANDER
        	FROM '||V_ESQUEMA||'.TMP_ACT_ACTIVO_SANTANDER S
        	JOIN '||V_ESQUEMA||'.ACT_ACTIVO A ON A.ACT_NUM_ACTIVO =  S.ID_HAYA
		) AUX
    	ON (ACT.ACT_ID = AUX.ACT_ID)
    	WHEN MATCHED THEN
        	UPDATE SET
            	ACT.ID_CES = AUX.ID_CES,
            	ACT.ID_SANTANDER = AUX.ID_SANTANDER,
            	ACT.USUARIOMODIFICAR = ''HREOS-6920'',
           		ACT.FECHAMODIFICAR = SYSDATE,
            	ACT.VERSION = ACT.VERSION+1';
				

		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han mergeado en total '||SQL%ROWCOUNT||' registros en la tabla ACT_ACTIVO');

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
