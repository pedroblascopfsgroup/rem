--/*
--#########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180612
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-1049
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    --V_TABLA VARCHAR2(25 CHAR):= 'ACT_ACTIVO';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	
	V_SQL := 'MERGE INTO REM01.ACT_ACTIVO T1 USING (
		SELECT ACT.ACT_ID
		FROM REM01.ACT_ACTIVO ACT
		LEFT JOIN REM01.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID
		LEFT JOIN REM01.BIE_ADJ_ADJUDICACION BIE ON BIE.BIE_ID = ACT.BIE_ID
		WHERE DD_CRA_ID = 43
		AND BIE.BIE_ADJ_F_INSCRIPCION_TITULO IS NOT NULL
		AND (BIE.BIE_ADJ_F_REA_POSESION IS NOT NULL OR SPS.SPS_FECHA_TOMA_POSESION IS NOT NULL)
		AND (ACT.ACT_CON_CARGAS = 0 OR ACT.ACT_CON_CARGAS IS NULL)
		) T2 ON (T1.ACT_ID = T2.ACT_ID)
		WHEN MATCHED THEN UPDATE SET
		T1.USUARIOMODIFICAR = ''REMVIP-1533''
		T1.FECHAMODIFICAR = SYSDATE
		T1.ACT_ADMISION = 1
		':
		
		EXECUTE IMMEDIATE V_SQL;
	
    
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
