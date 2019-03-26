--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190326
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-3744
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
	V_SQL VARCHAR2(20000 CHAR);
    TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso...'); 
    
    V_SQL :=   'MERGE INTO '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES T1
				USING (
					SELECT T1.ACT_NUMERO_ACTIVO                                                                                                         AS ACTIVO,
						   ACT.ACT_ID,
						   BIE.BIE_ID,
						   REG.BIE_DREG_ID,
						   INFO.REG_ID,
						   T1.REG_SUPERFICIE_CONSTRUIDA                                                                                                 AS REG_SUPERFICIE_CONSTRUIDA_1,
						   T2.REG_SUPERFICIE_CONSTRUIDA                                                                                                 AS REG_SUPERFICIE_CONSTRUIDA_2,
						   TO_NUMBER(
						   CASE WHEN T2.ACT_NUMERO_ACTIVO IS NULL THEN 
									 SUBSTR(T1.REG_SUPERFICIE_CONSTRUIDA,0,LENGTH(T1.REG_SUPERFICIE_CONSTRUIDA)-2)||'',''||
									 SUBSTR(T1.REG_SUPERFICIE_CONSTRUIDA,LENGTH(T1.REG_SUPERFICIE_CONSTRUIDA)-1,LENGTH(T1.REG_SUPERFICIE_CONSTRUIDA)) 
								ELSE 
									 SUBSTR(T2.REG_SUPERFICIE_CONSTRUIDA,0,LENGTH(T2.REG_SUPERFICIE_CONSTRUIDA)-2)||'',''||
									 SUBSTR(T2.REG_SUPERFICIE_CONSTRUIDA,LENGTH(T2.REG_SUPERFICIE_CONSTRUIDA)-1,LENGTH(T2.REG_SUPERFICIE_CONSTRUIDA))                                                                                                                         
																																					END) AS SUP_CONSTR
					FROM '||V_ESQUEMA||'.AUX_MMC_REMVIP_3744_1            T1
					LEFT JOIN '||V_ESQUEMA||'.AUX_MMC_REMVIP_3744_2       T2 ON T1.ACT_NUMERO_ACTIVO = T2.ACT_NUMERO_ACTIVO
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO                       ACT ON ACT.ACT_NUM_ACTIVO = T1.ACT_NUMERO_ACTIVO
					JOIN '||V_ESQUEMA||'.BIE_BIEN                         BIE ON BIE.BIE_ID = ACT.BIE_ID
					JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES            REG ON REG.BIE_ID = BIE.BIE_ID
					JOIN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL           INFO ON INFO.ACT_ID = ACT.ACT_ID
				) T2
				ON (T1.BIE_DREG_ID = T2.BIE_DREG_ID AND T1.BIE_ID = T2.BIE_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.BIE_DREG_SUPERFICIE_CONSTRUIDA = T2.SUP_CONSTR,
					T1.USUARIOMODIFICAR = ''MIG_APPLE_POST'',
					T1.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se ha actualizado la Superficie construida de '||SQL%ROWCOUNT||' activos. En la BIE_DATOS_REGISTRALES.'); 
	
	
	V_SQL :=   'MERGE INTO REM01.ACT_REG_INFO_REGISTRAL T1
				USING (
					SELECT T1.ACT_NUMERO_ACTIVO                                                                                                         AS ACTIVO,
						   ACT.ACT_ID,
						   BIE.BIE_ID,
						   REG.BIE_DREG_ID,
						   INFO.REG_ID,
						   T1.REG_SUPERFICIE_UTIL                                                                                                       AS REG_SUPERFICIE_UTIL_1,
						   T2.REG_SUPERFICIE_UTIL                                                                                                       AS REG_SUPERFICIE_UTIL_2,       
						   TO_NUMBER(
						   CASE WHEN T2.ACT_NUMERO_ACTIVO IS NULL THEN 
									 SUBSTR(T1.REG_SUPERFICIE_UTIL,0,LENGTH(T1.REG_SUPERFICIE_UTIL)-2)||'',''||
									 SUBSTR(T1.REG_SUPERFICIE_UTIL,LENGTH(T1.REG_SUPERFICIE_UTIL)-1,LENGTH(T1.REG_SUPERFICIE_UTIL)) 
								ELSE 
									 SUBSTR(T2.REG_SUPERFICIE_UTIL,0,LENGTH(T2.REG_SUPERFICIE_UTIL)-2)||'',''||
									 SUBSTR(T2.REG_SUPERFICIE_UTIL,LENGTH(T2.REG_SUPERFICIE_UTIL)-1,LENGTH(T2.REG_SUPERFICIE_UTIL))
																																					END) AS SUP_UTIL 
					FROM REM01.AUX_MMC_REMVIP_3744_1            T1
					LEFT JOIN REM01.AUX_MMC_REMVIP_3744_2       T2 ON T1.ACT_NUMERO_ACTIVO = T2.ACT_NUMERO_ACTIVO
					JOIN REM01.ACT_ACTIVO                       ACT ON ACT.ACT_NUM_ACTIVO = T1.ACT_NUMERO_ACTIVO
					JOIN REM01.BIE_BIEN                         BIE ON BIE.BIE_ID = ACT.BIE_ID
					JOIN REM01.BIE_DATOS_REGISTRALES            REG ON REG.BIE_ID = BIE.BIE_ID
					JOIN REM01.ACT_REG_INFO_REGISTRAL           INFO ON INFO.ACT_ID = ACT.ACT_ID
				) T2
				ON (T1.REG_ID = T2.REG_ID AND T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.REG_SUPERFICIE_UTIL = T2.SUP_UTIL,
					T1.USUARIOMODIFICAR = ''MIG_APPLE_POST'',
					T1.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se ha actualizado la Superficie útil de '||SQL%ROWCOUNT||' activos. En la ACT_REG_INFO_REGISTRAL.');


	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT
