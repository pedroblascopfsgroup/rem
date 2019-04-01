--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190312
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-3501
--## PRODUCTO=NO
--## 
--## Finalidad: Actualiza APR_AUX_STOCK_UVEM_TO_REM
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
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-3501';

BEGIN


	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM T1
				 USING (
					SELECT AUX.ACT_NUMERO_UVEM, AUX.COD_ENTRADA_ACTIVO
					FROM '||V_ESQUEMA||'.AUX_STOCK_120319 AUX
					WHERE 1 = 1
				       ) T2 
						ON (T1.ACT_NUMERO_UVEM = T2.ACT_NUMERO_UVEM) 
						WHEN MATCHED THEN UPDATE SET 
							T1.COD_ENTRADA_ACTIVO = T2.COD_ENTRADA_ACTIVO

						'; 

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
