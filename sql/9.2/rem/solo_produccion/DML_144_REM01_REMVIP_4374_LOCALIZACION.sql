--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190530
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-4374
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar datos diversos
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

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema	
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    	V_SQL VARCHAR2(4000 CHAR); -- Vble. sentencia a ejecutar.

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]'); 

	-------------------------------------------------------------------------------------------
	-- => LONGITUD 1)

	DBMS_OUTPUT.PUT_LINE('[INFO] Preparando actualización de ACT_LOC_LOCALIZACION. LONGITUD '); 
	V_SQL :=
	       'MERGE INTO '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION T1 
		USING (

		SELECT  DISTINCT ACT.ACT_ID,
			LOC_LONGITUD
		FROM '||V_ESQUEMA||'.AUX_REMVIP_4374_LOC AUX,
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT
                WHERE 1 = 1
		AND ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
		AND LOC_LONGITUD IS NOT NULL

		) T2
			ON (T1.ACT_ID = T2.ACT_ID )
		WHEN MATCHED THEN UPDATE
               	SET T1.LOC_LONGITUD = T2.LOC_LONGITUD, 
		    T1.USUARIOMODIFICAR = ''REMVIP-4374'', 
		    T1.FECHAMODIFICAR = SYSDATE
		';

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] '||SQL%ROWCOUNT||' registros actualizados.'); 


	-------------------------------------------------------------------------------------------
	-- => LATITUD 2)

	DBMS_OUTPUT.PUT_LINE('[INFO] Preparando actualización de ACT_LOC_LOCALIZACION. LATITUD '); 
	V_SQL :=
	       'MERGE INTO '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION T1 
		USING (

		SELECT  DISTINCT ACT.ACT_ID,
			LOC_LATITUD
		FROM '||V_ESQUEMA||'.AUX_REMVIP_4374_LOC AUX,
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT
                WHERE 1 = 1
		AND ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
		AND LOC_LATITUD IS NOT NULL

		) T2
			ON (T1.ACT_ID = T2.ACT_ID )
		WHEN MATCHED THEN UPDATE
               	SET T1.LOC_LONGITUD = T2.LOC_LATITUD, 
		    T1.USUARIOMODIFICAR = ''REMVIP-4374'', 
		    T1.FECHAMODIFICAR = SYSDATE
		';

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] '||SQL%ROWCOUNT||' registros actualizados.'); 


	-------------------------------------------------------------------------------------------
	-- => NOMBRE VIA 3)

	DBMS_OUTPUT.PUT_LINE('[INFO] Preparando actualización de BIE_LOCALIZACION. NOMBRE VIA '); 
	V_SQL :=
	       'MERGE INTO '||V_ESQUEMA||'.BIE_LOCALIZACION T1 
		USING (

		SELECT DISTINCT BIE_ID,
		BIE_LOC_NOMBRE_VIA
		FROM '||V_ESQUEMA||'.AUX_REMVIP_4374_LOC AUX,
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT
                WHERE 1 = 1
		AND ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
		AND BIE_LOC_NOMBRE_VIA IS NOT NULL

		) T2
			ON (T1.BIE_ID = T2.BIE_ID )
		WHEN MATCHED THEN UPDATE
               	SET T1.BIE_LOC_NOMBRE_VIA = T2.BIE_LOC_NOMBRE_VIA, 
		    T1.USUARIOMODIFICAR = ''REMVIP-4374'', 
		    T1.FECHAMODIFICAR = SYSDATE
		';

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] '||SQL%ROWCOUNT||' registros actualizados.'); 




	-------------------------------------------------------------------------------------------
	-- => DD_TVI_ID 4)

	DBMS_OUTPUT.PUT_LINE('[INFO] Preparando actualización de BIE_LOCALIZACION. DD_TVI_ID '); 
	V_SQL :=
	       'MERGE INTO '||V_ESQUEMA||'.BIE_LOCALIZACION T1 
		USING (

		SELECT DISTINCT BIE_ID,
		DD_TVI_ID
		FROM '||V_ESQUEMA||'.AUX_REMVIP_4374_LOC AUX,
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT
                WHERE 1 = 1
		AND ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
		AND DD_TVI_ID IS NOT NULL

		) T2
			ON (T1.BIE_ID = T2.BIE_ID )
		WHEN MATCHED THEN UPDATE
               	SET T1.DD_TVI_ID = T2.DD_TVI_ID, 
		    T1.USUARIOMODIFICAR = ''REMVIP-4374'', 
		    T1.FECHAMODIFICAR = SYSDATE
		';

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] '||SQL%ROWCOUNT||' registros actualizados.'); 





	-------------------------------------------------------------------------------------------
	-- => BIE_LOC_NUMERO_DOMICILIO 5)

	DBMS_OUTPUT.PUT_LINE('[INFO] Preparando actualización de BIE_LOCALIZACION. BIE_LOC_NUMERO_DOMICILIO '); 
	V_SQL :=
	       'MERGE INTO '||V_ESQUEMA||'.BIE_LOCALIZACION T1 
		USING (

		SELECT DISTINCT BIE_ID,
		BIE_LOC_NUMERO_DOMICILIO
		FROM '||V_ESQUEMA||'.AUX_REMVIP_4374_LOC AUX,
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT
                WHERE 1 = 1
		AND ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
		AND BIE_LOC_NUMERO_DOMICILIO IS NOT NULL

		) T2
			ON (T1.BIE_ID = T2.BIE_ID )
		WHEN MATCHED THEN UPDATE
               	SET T1.BIE_LOC_NUMERO_DOMICILIO = T2.BIE_LOC_NUMERO_DOMICILIO, 
		    T1.USUARIOMODIFICAR = ''REMVIP-4374'', 
		    T1.FECHAMODIFICAR = SYSDATE
		';

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] '||SQL%ROWCOUNT||' registros actualizados.'); 



	-------------------------------------------------------------------------------------------
	-- => BIE_LOC_PORTAL 6)

	DBMS_OUTPUT.PUT_LINE('[INFO] Preparando actualización de BIE_LOCALIZACION. BIE_LOC_PORTAL '); 
	V_SQL :=
	       'MERGE INTO '||V_ESQUEMA||'.BIE_LOCALIZACION T1 
		USING (

		SELECT DISTINCT BIE_ID,
		BIE_LOC_PORTAL
		FROM '||V_ESQUEMA||'.AUX_REMVIP_4374_LOC AUX,
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT
                WHERE 1 = 1
		AND ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
		AND BIE_LOC_PORTAL IS NOT NULL

		) T2
			ON (T1.BIE_ID = T2.BIE_ID )
		WHEN MATCHED THEN UPDATE
               	SET T1.BIE_LOC_PORTAL = T2.BIE_LOC_PORTAL, 
		    T1.USUARIOMODIFICAR = ''REMVIP-4374'', 
		    T1.FECHAMODIFICAR = SYSDATE
		';

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] '||SQL%ROWCOUNT||' registros actualizados.'); 




	-------------------------------------------------------------------------------------------
	-- => BIE_LOC_PISO 7)

	DBMS_OUTPUT.PUT_LINE('[INFO] Preparando actualización de BIE_LOCALIZACION. BIE_LOC_PISO '); 
	V_SQL :=
	       'MERGE INTO '||V_ESQUEMA||'.BIE_LOCALIZACION T1 
		USING (

		SELECT DISTINCT BIE_ID,
		BIE_LOC_PISO
		FROM '||V_ESQUEMA||'.AUX_REMVIP_4374_LOC AUX,
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT
                WHERE 1 = 1
		AND ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
		AND BIE_LOC_PISO IS NOT NULL

		) T2
			ON (T1.BIE_ID = T2.BIE_ID )
		WHEN MATCHED THEN UPDATE
               	SET T1.BIE_LOC_PISO = T2.BIE_LOC_PISO, 
		    T1.USUARIOMODIFICAR = ''REMVIP-4374'', 
		    T1.FECHAMODIFICAR = SYSDATE
		';

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] '||SQL%ROWCOUNT||' registros actualizados.'); 



	-------------------------------------------------------------------------------------------
	-- => BIE_LOC_PUERTA 8)

	DBMS_OUTPUT.PUT_LINE('[INFO] Preparando actualización de BIE_LOCALIZACION. BIE_LOC_PUERTA '); 
	V_SQL :=
	       'MERGE INTO '||V_ESQUEMA||'.BIE_LOCALIZACION T1 
		USING (

		SELECT DISTINCT BIE_ID,
		BIE_LOC_PUERTA
		FROM '||V_ESQUEMA||'.AUX_REMVIP_4374_LOC AUX,
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT
                WHERE 1 = 1
		AND ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
		AND BIE_LOC_PUERTA IS NOT NULL

		) T2
			ON (T1.BIE_ID = T2.BIE_ID )
		WHEN MATCHED THEN UPDATE
               	SET T1.BIE_LOC_PUERTA = T2.BIE_LOC_PUERTA, 
		    T1.USUARIOMODIFICAR = ''REMVIP-4374'', 
		    T1.FECHAMODIFICAR = SYSDATE
		';

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] '||SQL%ROWCOUNT||' registros actualizados.'); 

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
