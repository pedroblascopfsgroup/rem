--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20191001
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5279
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-5279';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			

-----------------------------------------------------------------------------------------------------------------
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_TBJ_TRABAJO - Estado = "Pagado con tarifa plana" ');
										
	 V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO 
		    SET DD_EST_ID = ( SELECT DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO = ''14'' ),
	    		USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
		    	FECHAMODIFICAR   = SYSDATE
		    WHERE 1 = 1
		    AND TBJ_NUM_TRABAJO IN
			(
				9000194121,
				9000199027,
				9000224882,
				9000203722,
				9000203026,
				9000213793,
				9000213797,
				9000213795,
				9000213792
			) ';	

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_TBJ_TRABAJO ');  

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
