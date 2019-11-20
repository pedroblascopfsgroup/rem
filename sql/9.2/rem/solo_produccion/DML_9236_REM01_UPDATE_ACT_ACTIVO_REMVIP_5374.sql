--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20191001
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5374
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
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_ACTIVO - Venta ');
										
	 V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_ACTIVO 
		    SET DD_TCO_ID = ( SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = ''01'' ),
	    		USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
		    	FECHAMODIFICAR   = SYSDATE
		    WHERE 1 = 1
		    AND ACT_NUM_ACTIVO = 6879803 ';	

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_ACTIVO ');  

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
