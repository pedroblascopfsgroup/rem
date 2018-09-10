--/*
--#########################################
--## AUTOR=Ivan Castelló
--## FECHA_CREACION=20180910
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1641
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar valor de tasación del activo
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
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1641';
    V_SQL VARCHAR2(4000 CHAR); 
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    PL_OUTPUT VARCHAR2(32000 CHAR);
    ACT_NUM_ACTIVO NUMBER(16,0):= 5929497;

BEGIN



	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TAS_TASACION TAS
			USING (
			        select TAS.TAS_ID from act_activo act
			            join '||V_ESQUEMA||'.ACT_TAS_TASACION tas on tas.act_id = act.act_id
			            join '||V_ESQUEMA||'.BIE_VALORACIONES bie_val on bie_val.bie_val_id = tas.bie_val_id
			        where act.ACT_NUM_ACTIVO = 5949376 and ACT.ACT_NUM_ACTIVO_UVEM = 4917976 and tas_id = 491135
			       ) ORIGEN
			ON (TAS.TAS_ID = ORIGEN.TAS_ID)
			WHEN MATCHED THEN
			UPDATE SET TAS.TAS_IMPORTE_TAS_FIN = 89490.09
			        , TAS.USUARIOMODIFICAR = '''||V_USUARIO||'''
			        , TAS.FECHAMODIFICAR   = SYSDATE
				';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' Valor tasación actualizado en la tabla ACT_TAS_TASACION');




	V_SQL := 'UPDATE '||V_ESQUEMA||'.BIE_VALORACIONES BIE SET 
				 BIE.BIE_IMPORTE_VALOR_TASACION = 89490.09
				    , BIE.USUARIOMODIFICAR =  '''||V_USUARIO||'''
				    , BIE.FECHAMODIFICAR   = SYSDATE
				WHERE BIE.BIE_VAL_ID = 492374
				';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' Valor tasación actualizado BIE_VALORACIONES');

	


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
