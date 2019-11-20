--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190903
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5169
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-5169';
    V_SQL VARCHAR2(8192 CHAR);


BEGIN			

	DBMS_OUTPUT.PUT_LINE('[INICIO] Borra ECO_COND_CONDICIONES_ACTIVO - Borrado físico ');
										
	 V_SQL := ' DELETE '||V_ESQUEMA||'.ECO_COND_CONDICIONES_ACTIVO T1
		    WHERE ACT_ID = 13436
		    AND ECO_ID = 172027
		    AND COND_ID = 100401
	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrado '||SQL%ROWCOUNT||' registros en ECO_COND_CONDICIONES_ACTIVO ');  

 	V_SQL := ' DELETE '||V_ESQUEMA||'.ECO_COND_CONDICIONES_ACTIVO T1
		    WHERE ACT_ID = 80532
		    AND ECO_ID = 173235
		    AND COND_ID = 103745
	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrado '||SQL%ROWCOUNT||' registros en ECO_COND_CONDICIONES_ACTIVO ');  

 	V_SQL := ' DELETE '||V_ESQUEMA||'.ECO_COND_CONDICIONES_ACTIVO T1
		    WHERE ACT_ID = 237163
		    AND ECO_ID = 176373
		    AND COND_ID = 100401
	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrado '||SQL%ROWCOUNT||' registros en ECO_COND_CONDICIONES_ACTIVO ');  

 	V_SQL := ' DELETE '||V_ESQUEMA||'.ECO_COND_CONDICIONES_ACTIVO T1
		    WHERE ACT_ID = 266188
		    AND ECO_ID = 156947
		    AND COND_ID = 81816
	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrado '||SQL%ROWCOUNT||' registros en ECO_COND_CONDICIONES_ACTIVO ');  

 	V_SQL := ' DELETE '||V_ESQUEMA||'.ECO_COND_CONDICIONES_ACTIVO T1
		    WHERE ACT_ID = 286589
		    AND ECO_ID = 175424
		    AND COND_ID = 103024
	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrado '||SQL%ROWCOUNT||' registros en ECO_COND_CONDICIONES_ACTIVO ');  



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
