--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190729
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4964
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-4964';
    V_SQL VARCHAR2(8192 CHAR);


BEGIN			

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ECO_COND_CONDICIONES_ACTIVO - Borrado lógico ');
										
	 V_SQL := ' UPDATE '||V_ESQUEMA||'.ECO_COND_CONDICIONES_ACTIVO T1
        	    SET T1.BORRADO = 1,
	    	        T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    		T1.FECHABORRAR   = SYSDATE
		    WHERE ACT_ID = 267137
		    AND ECO_ID = 172631
		    AND COND_ID = 99562	
	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ECO_COND_CONDICIONES_ACTIVO ');  



----------------------------------------------------------------------------------------------------------------- 

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
