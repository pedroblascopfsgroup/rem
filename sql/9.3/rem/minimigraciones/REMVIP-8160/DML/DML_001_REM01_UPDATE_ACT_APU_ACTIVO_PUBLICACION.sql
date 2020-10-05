--/*
--#########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200930
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8160
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar tabla 'ACT_APU_ACTIVO_PUBLICACION'
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
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-8160';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			
			

-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_APU_ACTIVO_PUBLICACION - Fecha revisión publicación venta');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION T1
		        USING (
					SELECT DISTINCT ACT_ID, FECHA_REVISION_PUBLICACION
					FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
					JOIN '||V_ESQUEMA||'.AUX_REMVIP_8160 AUX ON AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
					WHERE ACT.BORRADO = 0	
        		) T2 
        	  ON (T1.ACT_ID = T2.ACT_ID )
				WHEN MATCHED THEN UPDATE
					SET T1.APU_FECHA_REVISION_PUB_VENTA = TO_DATE(T2.FECHA_REVISION_PUBLICACION, ''DD/MM/YYYY''),	  
	    				T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	    				T1.FECHAMODIFICAR   = SYSDATE';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_APU_ACTIVO_PUBLICACION ');  


-----------------------------------------------------------------------------------------------------------------


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
