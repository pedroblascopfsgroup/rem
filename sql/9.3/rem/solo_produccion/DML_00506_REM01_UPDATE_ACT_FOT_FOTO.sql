--/*
--#########################################
--## AUTOR= Carlos Santos Vílchez
--## FECHA_CREACION=20201102
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6865
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar tabla 'ACT_FOT_FOTO'
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
	V_TABLA_FOTOS VARCHAR2(100 CHAR):= 'ACT_FOT_FOTO';
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6865';
    V_SQL VARCHAR2(4000 CHAR);

BEGIN						

-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza FOT_GDF_URL, FOT_GDF_OPTIMIZED, FOT_GDF_WATERMARK, FOR_GDF_THUMBNAIL de la tabla '||V_TABLA_FOTOS);
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_FOTOS||' T1
		        USING (
					SELECT DISTINCT FOT_ID, FOT_GDF_URL, FOT_GDF_OPTIMIZED, FOT_GDF_WATERMARK, FOT_GDF_THUMBNAIL
					FROM '||V_ESQUEMA||'.AUX_REMVIP_6865
        		) T2 
        	  ON (T1.FOT_ID = T2.FOT_ID )
				WHEN MATCHED THEN UPDATE
					SET T1.FOT_GDF_URL = T2.FOT_GDF_URL,
						T1.FOT_GDF_OPTIMIZED = T2.FOT_GDF_OPTIMIZED,
						T1.FOT_GDF_WATERMARK = T2.FOT_GDF_WATERMARK,
						T1.FOT_GDF_THUMBNAIL = T2.FOT_GDF_THUMBNAIL,
	    				T1.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''',
	    				T1.FECHAMODIFICAR   = SYSDATE';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en '||V_TABLA_FOTOS);  


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
