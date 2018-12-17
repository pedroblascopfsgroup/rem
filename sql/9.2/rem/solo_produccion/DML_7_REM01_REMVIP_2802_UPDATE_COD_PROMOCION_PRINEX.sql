--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181217
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-2802
--## PRODUCTO=NO
--## 
--## Finalidad: Actualiza importes erroneos de la tabla GEX_GASTOS_EXPEDIENTE
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
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2802';

BEGIN


	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
				 USING (SELECT ACT.ACT_NUM_ACTIVO, AUX.COD_PROMOCION, AUX.ACT_HAYA 
					FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
					JOIN '||V_ESQUEMA||'.AUX_REMVIP_2802 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_HAYA 
					WHERE ACT.ACT_COD_PROMOCION_PRINEX IS NULL 
					AND DD_CRA_ID = 43   
				       ) T2 
						ON (T1.GEX_ID = T2.GEX_ID) 
						WHEN MATCHED THEN UPDATE SET 
							T1.ACT_COD_PROMOCION_PRINEX = T2.COD_PROMOCION, 
							T1.USUARIOMODIFICAR = ''REMVIP-2802'', 
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
