--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20181002
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2088
--## PRODUCTO=SI
--## Finalidad: Se corrigen los gestores GFORM de Giants.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR) := 'REM01';				-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := 'REMMASTER';		-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1973';
    V_SQL VARCHAR2(4000 CHAR); 
    ERR_NUM NUMBER;										-- Numero de errores
    ERR_MSG VARCHAR2(2048);							    -- Mensaje de error
    PL_OUTPUT VARCHAR2(32000 CHAR);

BEGIN

       
    EXECUTE IMMEDIATE  
    'DELETE FROM REM01.GCO_GESTOR_ADD_ECO GCO
		WHERE EXISTS (
			SELECT 1 
			FROM REM01.AUX_MMC_GIANTS_GFORM_GCO AUX
			WHERE AUX.GEE_ID = GCO.GEE_ID 
			  AND AUX.ECO_ID = GCO.ECO_ID
	)'; 
    DBMS_OUTPUT.PUT_LINE('[INFO] Se borran '||SQL%ROWCOUNT||' registros de la GCO_GESTOR_ADD_ECO.');   
    
    EXECUTE IMMEDIATE  
    'MERGE INTO REM01.GEE_GESTOR_ENTIDAD GEE
		USING (
			  SELECT GEE_ID,
					 USU_ID
			  FROM REM01.AUX_MMC_GIANTS_GFORM_USU
		) T2
		ON (T2.GEE_ID = GEE.GEE_ID)
		WHEN MATCHED THEN UPDATE 
		SET
			GEE.USU_ID = T2.USU_ID,
			GEE.USUARIOMODIFICAR = ''REMVIP-2088'',
			GEE.FECHAMODIFICAR = SYSDATE'; 
    DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros de la GEE_GESTOR_ENTIDAD.');   
       
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;

END;
/
EXIT;
