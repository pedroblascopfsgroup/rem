--/*
--#########################################
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20191017
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=func-rem-gestObjCajamar
--## INCIDENCIA_LINK=HREOS-7298
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion registros PGC_ID, PVE_ID, USU_ID  gestor comercial, 
--## 			identificador del proveedor y identificador de usuario respectivamente.
--## INSTRUCCIONES:
--## 				Una vez creado el script que genera el DDL con la estructura de la tabla
--##			temporal, y teniendo en cuenta que las columnas CSV son seleccionadas de forma
--##			secuencial, eliminar del fichero CSV aquellas columnas que sean innecesarias 
--##			para la migración.
--## VERSIONES:
--##        0.1 Versión inicial - José Antonio Gigante
--##        0.2 HREOS-8054 - Alejandro Valverde - Comprobación del JOIN de los campos PVE_COD_UVEM con ID_OFICINA y TRUNCATE table.
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_TABLA_TMP VARCHAR2(30 CHAR) := 'TMP_HREOS_7298'; -- Variable para tabla de salida para el borrado
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR); -- Variable para lanzar consultas
	PL_OUTPUT VARCHAR2(32000 CHAR); 
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-7298'; -- Usuario para auditoria
	V_TABLA VARCHAR2(30) :='PGC_PROVE_GES_CAJAMAR'; -- Nombre de la tabla a rellenar
	

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));
	-- En primer lugar eliminamos duplicados de la tabla:
	V_SQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' T
				WHERE EXISTS (
				SELECT 1
				FROM (SELECT USUARIO_REM ,ID_ENTIDAD, ID_OFICINA 
        		FROM (SELECT USUARIO_REM, ID_ENTIDAD, ID_OFICINA, ROW_NUMBER() OVER (PARTITION BY CONCAT(ID_ENTIDAD,ID_OFICINA) ORDER BY USUARIO_REM desc) R 
				FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||') WHERE R > 1) ELIM WHERE ELIM.USUARIO_REM = T.USUARIO_REM AND ELIM.ID_ENTIDAD = T.ID_ENTIDAD AND ELIM.ID_OFICINA = T.ID_OFICINA
				)';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Eliminados '||SQL%ROWCOUNT||' registros de la tabla temporal '||V_TABLA_TMP);

	V_SQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Eliminados '||SQL%ROWCOUNT||' registros de la tabla '||V_TABLA);

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' PGC 
		(PGC.PGC_ID, 
		PGC.USU_ID,
		PGC.PVE_ID,
		PGC.VERSION,
		PGC.USUARIOCREAR,
		PGC.FECHACREAR 
		)
		SELECT S_PGC_PROVE_GES_CAJAMAR.NEXTVAL PGC_ID,
    	U.USU_ID, 
		P.PVE_ID,
		1,
		'''||V_USUARIO||''' USUARIOCREAR,
		SYSDATE FECHACREAR
    	FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
    	JOIN '||V_ESQUEMA_M||'.USU_USUARIOS U
    	ON U.USU_USERNAME = TMP.USUARIO_REM
    	JOIN ACT_PVE_PROVEEDOR P
    	ON SUBSTR(P.PVE_COD_UVEM,-4,4) = LPAD(TMP.ID_OFICINA,4,0)
	WHERE P.DD_TPR_ID = (SELECT TPR.DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR TPR WHERE TPR.DD_TPR_CODIGO = ''29'')';
				
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_TABLA);

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
