--/*
--#########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20200224
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6503
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
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6503';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Eliminando fecha de baja del proveedor con código 10004312');
										
	 V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR
		  		SET PVE_FECHA_BAJA = NULL, USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''', FECHAMODIFICAR = SYSDATE
	   			WHERE PVE_COD_REM = 10004312'; 
 

	EXECUTE IMMEDIATE V_SQL;
	
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
