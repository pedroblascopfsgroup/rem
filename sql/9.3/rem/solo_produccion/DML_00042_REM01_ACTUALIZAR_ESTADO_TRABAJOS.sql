--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191128
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5872
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-5872';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			

			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ESTADO ACT_TBJ_TRABAJO');
										
	 V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO 
		    SET DD_EST_ID = 5,
	    		USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
		    	FECHAMODIFICAR   = SYSDATE
		    WHERE TBJ_NUM_TRABAJO IN (9000147455, 9000168297)';	

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
