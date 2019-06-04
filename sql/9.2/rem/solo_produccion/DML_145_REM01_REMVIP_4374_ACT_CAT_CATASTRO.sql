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
	-- => CAT_REF_CATASTRAL

	DBMS_OUTPUT.PUT_LINE('[INFO] Preparando actualización de ACT_CAT_CATASTRO. CAT_REF_CATASTRAL '); 
	V_SQL :=
	       'MERGE INTO '||V_ESQUEMA||'.ACT_CAT_CATASTRO T1 
		USING (

		SELECT  CAT_REF_CATASTRAL,
			ACT.ACT_ID
		FROM '||V_ESQUEMA||'.AUX_REMVIP_4374_RC AUX,
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT
                WHERE 1 = 1
		AND ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO

		) T2
			ON (T1.ACT_ID = T2.ACT_ID )
		WHEN MATCHED THEN UPDATE
               	SET T1.CAT_REF_CATASTRAL = T2.CAT_REF_CATASTRAL, 
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
