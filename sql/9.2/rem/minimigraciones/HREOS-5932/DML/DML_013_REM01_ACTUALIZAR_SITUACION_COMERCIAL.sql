--/*
--#########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190411
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6164
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
	V_MSQL VARCHAR(4000 CHAR);
	TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(200 CHAR);
    PL_OUTPUT VARCHAR2(32000 CHAR);
    P_ACT_ID NUMBER;
    P_ALL_ACTIVOS NUMBER;

BEGIN			
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Recalcular Situacion comercial '); 
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se procede a borrar la situación comercial de los activos migrados.'); 
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET DD_SCM_ID = NULL WHERE USUARIOMODIFICAR LIKE ''HREOS-5932-PUNTO1'' AND BORRADO = 0';

	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET DD_SCM_ID = NULL WHERE USUARIOMODIFICAR LIKE ''HREOS-5932-PUNTO3'' AND BORRADO = 0';

	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET DD_SCM_ID = NULL WHERE USUARIOMODIFICAR LIKE ''HREOS-5932-PUNTO3-VA-V'' AND BORRADO = 0';
	
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.'); 
				
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de recalcular Situacion comercial'); 
	
	REM01.SP_ASC_ACT_SIT_COM_VACIOS(0,1);
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');

	COMMIT;
	
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
