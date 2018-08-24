--/*
--#########################################
--## AUTOR=Juanjo Arbona
--## FECHA_CREACION=20180703
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1210
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

    V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; 			--REM01
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; 	--REMMASTER
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1210';
    V_TABLA_MIG VARCHAR2(40 CHAR) := 'AUX_REMVIP_COORDENADAS';
    V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    EXECUTE IMMEDIATE 'MERGE INTO REM01.ACT_LOC_LOCALIZACION T1
                       USING (select distinct LOC.LOC_ID
                                   , AUX.NEW_LATITUD, AUX.NEW_LONGITUD
                               from REM01.ACT_ACTIVO ACT
                               join REM01.ACT_LOC_LOCALIZACION LOC on LOC.ACT_ID = ACT.ACT_ID
                               join REM01.AUX_REMVIP_COORDENADAS AUX on AUX.ACT_NUM_ACTIVO = TO_CHAR(ACT.ACT_NUM_ACTIVO)
                       ) T2
		ON (T1.LOC_ID = T2.LOC_ID)
		WHEN MATCHED THEN UPDATE SET
			T1.LOC_LATITUD = T2.NEW_LATITUD
		      , T1.LOC_LONGITUD = T2.NEW_LONGITUD
		      , T1.USUARIOMODIFICAR = ''REMVIP-1210''
		      , T1.FECHAMODIFICAR = SYSDATE';
		      
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||SQL%ROWCOUNT||' registros de ACT_LOC_LOCALIZACION actualizados.');    
    
        
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
EXIT;
