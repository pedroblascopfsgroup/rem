--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190322
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0
--## INCIDENCIA_LINK=REMVIP-3722
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
TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]'); 

	EXECUTE IMMEDIATE  'MERGE INTO '||V_ESQUEMA||'.ACT_CAT_CATASTRO T1 
						USING (
						SELECT DISTINCT
							   CAT.CAT_ID, 
							   ACT.ACT_ID,
							   CAT.CAT_VALOR_CATASTRAL_CONST, 
							   CAT.CAT_VALOR_CATASTRAL_SUELO
						FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
						JOIN '||V_ESQUEMA||'.ACT_CAT_CATASTRO CAT ON ACT.ACT_ID = CAT.ACT_ID
						WHERE ACT.USUARIOCREAR = ''MIG_APPLE''
						  AND CAT.USUARIOCREAR = ''MIG_APPLE''
						) T2
						ON (T1.CAT_ID = T2.CAT_ID)
						WHEN MATCHED THEN UPDATE SET
							T1.USUARIOMODIFICAR = ''REMVIP-3722'',
							T1.FECHAMODIFICAR = SYSDATE,
							T1.CAT_VALOR_CATASTRAL_CONST = NULL,
							T1.CAT_VALOR_CATASTRAL_SUELO = NULL
	';

	DBMS_OUTPUT.PUT_LINE('	[INFO] '||SQL%ROWCOUNT||' catastros actualizados. Valores puestos a NULL');  

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
