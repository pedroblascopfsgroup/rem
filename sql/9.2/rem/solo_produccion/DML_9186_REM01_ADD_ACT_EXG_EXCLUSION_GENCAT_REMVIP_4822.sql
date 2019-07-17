--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190716
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4822
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
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-4822';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Creación de activos de exclusión GENCAT ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_EXG_EXCLUSION_GENCAT T1
        USING (

		SELECT DISTINCT ACT_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		WHERE  1=1
        	AND ACT.BORRADO = 0
		AND ACT_NUM_ACTIVO IN
		(
			5960921,
			5930373,
			5938308,
			5941013,
			5959914,
			5944490,
			5960794,
			5955144,
			5952721,
			5952490,
			5947557,
			5941786,
			5941110,
			5939883,
			5937124,
			5932053,
			5931922,
			5930115,
			5927289,
			5926766,
			5930124,
			5961767,
			5925890,
			5932179,
			5952685,
			5966419,
			5965443,
			5961034,
			5968046,
			5942516,
			5968341,
			5952051,
			5943630,
			5968600,
			5956580,
			5931743,
			5954117,
			5939953,
			5955793,
			5951554,
			5931511,
			5966112,
			5966803,
			5947842,
			5962997,
			5944594,
			5942474,
			5936920,
			6999509,
			5931431,
			5942911,
			6988853,
			5947194,
			6988852,
			5941869,
			5934710,
			5944397,
			5945879,
			6998868,
			5931145,
			5954858,
			6824793,
			5969318,
			6990056,
			5946189,
			5967629,
			7001665,
			6060281,
			6061753,
			6989918,
			6988502,
			5940528,
			5948005,
			6956361,
			6938934,
			5947365,
			7001445,
			5944839
		)

        ) T2 
        ON (T1.ACT_ID = T2.ACT_ID )
	WHEN NOT MATCHED THEN INSERT
	( ACT_ID )
	VALUES
	( T2.ACT_ID )	
	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Creados '||SQL%ROWCOUNT||' registros en ACT_EXG_EXCLUSION_GENCAT ');  


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
