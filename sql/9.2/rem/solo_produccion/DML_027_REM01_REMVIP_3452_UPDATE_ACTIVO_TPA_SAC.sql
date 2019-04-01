--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190226
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-3452
--## PRODUCTO=NO
--## 
--## Finalidad: Actualiza DD_TPA_ID y DD_SAC_ID de ACT_ACTIVO
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-3452';

BEGIN


	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
				 USING (
					SELECT ACT_NUM_ACTIVO, DD_TPA_ID, DD_SAC_ID
					FROM '||V_ESQUEMA||'.AUX_ACT_TPA_SAC
					WHERE 1 = 1
				       ) T2 
						ON (T1.ACT_NUM_ACTIVO = T2.ACT_NUM_ACTIVO) 
						WHEN MATCHED THEN UPDATE SET 
							T1.DD_TPA_ID = T2.DD_TPA_ID, 
							T1.DD_SAC_ID = T2.DD_SAC_ID, 

							T1.USUARIOMODIFICAR = ''REMVIP-3452'', 
							T1.FECHAMODIFICAR = SYSDATE'; 

	EXECUTE IMMEDIATE V_SQL;
		
	COMMIT;

      DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registro en la tabla ACT_ACTIVO');

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
