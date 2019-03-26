--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190326
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-3743
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
    
    V_SQL :=   'MERGE INTO '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION T1
				USING (
					SELECT
						 ACT.ACT_NUM_ACTIVO,
						 ACT.ACT_ID,
						 BIE.BIE_ID,
						 LOC.LOC_ID,
						 AUX.SIGNO_LOC_LATITUD||AUX.LOC_LATITUD                                                                                           AS LATITUD_FICHERO
						,AUX.SIGNO_LOC_LONGITUD||AUX.LOC_LONGITUD                                                                                         AS LONGITUD_FICHERO
						,TO_NUMBER(SUBSTR(AUX.SIGNO_LOC_LATITUD||AUX.LOC_LATITUD,1,7)||'',''||SUBSTR(AUX.SIGNO_LOC_LATITUD||AUX.LOC_LATITUD,8,15))        AS LATITUD
						,TO_NUMBER(SUBSTR(AUX.SIGNO_LOC_LONGITUD||AUX.LOC_LONGITUD,1,7)||'',''||SUBSTR(AUX.SIGNO_LOC_LONGITUD||AUX.LOC_LONGITUD,8,15))    AS LONGITUD
						,MIG.LOC_LATITUD AS LATITUD_1ER_FICH
						,MIG.LOC_LONGITUD AS LONGITUD_1ER_FICH
					FROM '||V_ESQUEMA||'.AUX_MMC_REMVIP_3743  AUX 
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO           ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUMERO_ACTIVO
					JOIN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION LOC ON LOC.ACT_ID = ACT.ACT_ID
					JOIN '||V_ESQUEMA||'.BIE_BIEN             BIE ON BIE.BIE_ID = ACT.BIE_ID
					JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION     LOC2 ON LOC2.BIE_ID = BIE.BIE_ID
					JOIN '||V_ESQUEMA||'.MIG_ADA_DATOS_ADI    MIG ON MIG.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
				) T2
				ON (T1.LOC_ID = T2.LOC_ID AND T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET 
					T1.LOC_LATITUD = T2.LATITUD,
					T1.LOC_LONGITUD = T2.LONGITUD,
					T1.USUARIOMODIFICAR = ''MIG_APPLE_POST'',
					T1.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO_MIGRA] Se han actualizado la LATITUD y LONGITUD de '||SQL%ROWCOUNT||' registros. En la ACT_LOC_LOCALIZACION.'); 
	
	
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
