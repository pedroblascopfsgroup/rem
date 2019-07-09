--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190621
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
	-- => TOMO

	DBMS_OUTPUT.PUT_LINE('[INFO] Preparando actualización de BIE_DATOS_REGISTRALES '); 
	V_SQL :=
	       'MERGE INTO '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES T1 
		USING (


		SELECT  ACT.ACT_NUM_ACTIVO, 
			BIE_DREG_TOMO,
			BIE_DREG_LIBRO,
			BIE_DREG_FOLIO,
			BIE_DREG_NUM_FINCA,
			BIE_ID
		FROM '||V_ESQUEMA||'.AUX_REMVIP_4374_REG_RES AUX,
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT
                WHERE 1 = 1
		AND ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO

		) T2
			ON (T1.BIE_ID = T2.BIE_ID )
		WHEN MATCHED THEN UPDATE
               	SET T1.BIE_DREG_TOMO = T2.BIE_DREG_TOMO, 
		    T1.BIE_DREG_LIBRO = T2.BIE_DREG_LIBRO, 
		    T1.BIE_DREG_FOLIO = T2.BIE_DREG_FOLIO, 
		    T1.BIE_DREG_NUM_FINCA = T2.BIE_DREG_NUM_FINCA, 
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
