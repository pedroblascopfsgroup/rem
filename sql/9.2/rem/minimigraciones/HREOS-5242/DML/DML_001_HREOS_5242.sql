--/*
--#########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20190116
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.2.0
--## INCIDENCIA_LINK=HREOS-5242
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion ACT_DCA_DATOS_CONTRATO_ALQ.
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

	V_TABLA VARCHAR2(30 CHAR) := 'ACT_DCA_DATOS_CONTRATO_ALQ'; -- Variable para tabla de salida para el borrado
	V_TABLA_TMP VARCHAR2(30 CHAR) := 'TMP_VISTA_ALQUILERES'; -- Variable para tabla de salida para el borrado
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-5242';

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));
	
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
						   		(
								DCA_ID,
								DCA_FECHA_CREACION,
								DCA_NOM_PRINEX,
								ACT_ID,
								DCA_UHEDIT,
								DCA_ID_CONTRATO,
								DCA_EST_CONTRATO,
								DCA_FECHA_FIRMA,
								DCA_FECHA_FIN_CONTRATO,
								DCA_CUOTA,
								DCA_NOMBRE_CLIENTE,
								DCA_DEUDA_PENDIENTE,
								DCA_RECIBOS_PENDIENTES,
								DCA_F_ULTIMO_PAGADO,
								DCA_F_ULTIMO_ADEUDADO,
								VERSION,
								USUARIOCREAR,
								FECHACREAR,
								BORRADO,
								ID_AAII,
								ID_PRINEX
						   		)
							SELECT
								S_'||V_TABLA||'.NEXTVAL,
								AUX.DCA_FECHA_CREACION,
								AUX.DCA_NOM_PRINEX,
								AUX.ACT_ID,
								AUX.DCA_UHEDIT,
								AUX.DCA_ID_CONTRATO,
								AUX.DCA_EST_CONTRATO,
								AUX.DCA_FECHA_FIRMA,
								AUX.DCA_FECHA_FIN_CONTRATO,
								AUX.DCA_CUOTA,
								AUX.DCA_NOMBRE_CLIENTE,
								AUX.DCA_DEUDA_PENDIENTE,
								AUX.DCA_RECIBOS_PENDIENTES,
								AUX.DCA_F_ULTIMO_PAGADO,
								AUX.DCA_F_ULTIMO_ADEUDADO,
								0,
								'''||V_USUARIO||''',
								SYSDATE,
								0,
								AUX.ID_AAII,
								AUX.ID_PRINEX
							FROM (SELECT
										DCA_FECHA_CREACION,
										DCA_NOM_PRINEX,
										ID_AAII,
										ID_PRINEX,
										DCA_UHEDIT,
										DCA_ID_CONTRATO,
										DCA_EST_CONTRATO,
										DCA_FECHA_FIRMA,
										DCA_FECHA_FIN_CONTRATO,
										DCA_CUOTA,
										DCA_NOMBRE_CLIENTE,
										DCA_DEUDA_PENDIENTE,
										DCA_RECIBOS_PENDIENTES,
										DCA_F_ULTIMO_PAGADO,
										DCA_F_ULTIMO_ADEUDADO,
										(SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = TMP.ID_AAII) AS ACT_ID
										FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
					   		  			WHERE ID_AAII IS NOT NULL
									) AUX WHERE AUX.ACT_ID IS NOT NULL';

		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han mergeado en total '||SQL%ROWCOUNT||' registros en la tabla ACT_DCA_DATOS_CONTRATO_ALQ');

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
