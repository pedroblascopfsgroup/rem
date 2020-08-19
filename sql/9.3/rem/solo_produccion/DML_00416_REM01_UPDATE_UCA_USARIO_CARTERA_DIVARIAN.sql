--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200805
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7337
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-7337';
    V_MSQL VARCHAR2(32000 CHAR);
    
BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza UCA_USUARIO_CARTERA');	

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.UCA_USUARIO_CARTERA SET DD_SCR_ID = null WHERE DD_SCR_ID = 403';

	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en UCA_USUARIO_CARTERA ');
/*
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.UCA_USUARIO_CARTERA (UCA_ID,
                                                                USU_ID,
                                                                DD_CRA_ID,
																DD_SCR_ID) 
                                    VALUES('||V_ESQUEMA||'.S_UCA_USUARIO_CARTERA.NEXTVAL,
                                            (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''ogf.sdelgado''),
                                            (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''152''),
											(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''152'')
                                    	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Insertados '||SQL%ROWCOUNT||' registros en UCA_USARIO_CARTERA ');  
	
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.UCA_USUARIO_CARTERA (UCA_ID,
                                                                USU_ID,
                                                                DD_CRA_ID,
																DD_SCR_ID) 
                                    VALUES('||V_ESQUEMA||'.S_UCA_USUARIO_CARTERA.NEXTVAL,
                                            (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''ogf.isardinero''),
                                            (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''152''),
											(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''152'')
                                    	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Insertados '||SQL%ROWCOUNT||' registros en UCA_USARIO_CARTERA ');  
*/
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN] Proceso realizado');
	

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
