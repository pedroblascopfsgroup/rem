--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190930
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5348
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-5348';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			

-----------------------------------------------------------------------------------------------------------------
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_ACTIVO - Núm. activo HAYA y SAREB ');
										
	 V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_ACTIVO 
		    SET ACT_NUM_ACTIVO = ''99999107032'',
			ACT_NUM_ACTIVO_SAREB = ''99999816245'',
	    		USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
		    	FECHAMODIFICAR   = SYSDATE
		    WHERE ACT_RECOVERY_ID = ''1000000000279201'' ';	

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_ACTIVO ');  

-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_ACTIVO - Núm. activo HAYA y SAREB ');
										
	 V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_ACTIVO 
		    SET ACT_NUM_ACTIVO = ''99999181541'',
			ACT_NUM_ACTIVO_SAREB = ''999991071209'',
	    		USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
		    	FECHAMODIFICAR   = SYSDATE
		    WHERE ACT_RECOVERY_ID = ''1000000000271835'' ';	

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_ACTIVO ');  

-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_ACTIVO - Núm. activo HAYA y SAREB ');
										
	 V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_ACTIVO 
		    SET ACT_NUM_ACTIVO = ''107032'',
			ACT_NUM_ACTIVO_SAREB = ''816245'',
	    		USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
		    	FECHAMODIFICAR   = SYSDATE
		    WHERE ACT_RECOVERY_ID = ''1000000000279201'' ';	

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_ACTIVO ');  

-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_ACTIVO - Núm. activo HAYA y SAREB ');
										
	 V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_ACTIVO 
		    SET ACT_NUM_ACTIVO = ''181541'',
			ACT_NUM_ACTIVO_SAREB = ''1071209'',
	    		USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
		    	FECHAMODIFICAR   = SYSDATE
		    WHERE ACT_RECOVERY_ID = ''1000000000271835'' ';	

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_ACTIVO ');  

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
