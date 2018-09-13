--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180913
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-1852
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva: Update del campo DD_LOC_ID en la BIE_LOCALIZACION.
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_TABLA VARCHAR2(40 CHAR) := 'BIE_LOCALIZACION';
V_SQL VARCHAR2(12000 CHAR);
V_SENTENCIA VARCHAR2(32000 CHAR);
PL_OUTPUT VARCHAR2(32000 CHAR);
V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1852';

BEGIN
	
	PL_OUTPUT := '[INICIO]'||CHR(10);
	
	V_SQL := '  MERGE INTO REM01.BIE_LOCALIZACION T1
				USING (
					SELECT LOC.BIE_LOC_ID,
						   AUX.DD_LOC_ID
					FROM REM01.AUX_MMC_LOCALIZACION_BIEN AUX
					JOIN REM01.BIE_LOCALIZACION          LOC
					  ON LOC.BIE_LOC_ID = AUX.BIE_LOC_ID
					WHERE LOC.USUARIOMODIFICAR = ''GLLP'' 
					  AND AUX.DD_LOC_ID <> LOC.DD_LOC_ID
				) T2
				ON (T1.BIE_LOC_ID = T2.BIE_LOC_ID)
				WHEN MATCHED THEN 
				UPDATE SET
				 T1.DD_LOC_ID = T2.DD_LOC_ID,
				 T1.USUARIOMODIFICAR = ''REMVIP-1852'',
				 T1.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_SQL;		
	PL_OUTPUT := PL_OUTPUT || '[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros en la '|| V_TABLA || ' ' || CHR(10);

    COMMIT;

	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

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
