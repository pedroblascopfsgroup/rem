--/*
--#########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20190125
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-3147
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
	TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso...'); 

	EXECUTE IMMEDIATE  'MERGE INTO REM01.ACT_APU_ACTIVO_PUBLICACION T1 USING
				(
				    SELECT ACT.ACT_ID
				    FROM REM01.AUX_MMC_REMVIP_3147 aux
				    JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACTIVO
				    
				)T2 ON (T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN
				UPDATE
				    SET
				    T1.APU_CHECK_PUBLICAR_V = 0,
				    T1.APU_CHECK_PUBLICAR_A = 0,
				    T1.USUARIOMODIFICAR = ''REMVIP-3147'',
				    T1.FECHAMODIFICAR = SYSDATE
	';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' checks de publicaciones.'); 

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
