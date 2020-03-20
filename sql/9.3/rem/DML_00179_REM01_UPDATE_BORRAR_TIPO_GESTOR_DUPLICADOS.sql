--/*
--#########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20200305
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6033
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6033';
    V_MSQL VARCHAR2(4000 CHAR);


BEGIN			
													
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    DBMS_OUTPUT.PUT_LINE('[INFO]: BORRANDO TIPOS DE GESTOR DUPLICADOS EN LA  DD_TGE_TIPO_GESTOR ' );
    
	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR 
				SET BORRADO = 1, 
					USUARIOBORRAR =  '''||V_USUARIOMODIFICAR||''', 
					FECHABORRAR = SYSDATE 
				WHERE DD_TGE_CODIGO IN (''GCBOFIN'', ''SBOINM'', ''GCBOINM'', ''SBOFIN'')';

 	EXECUTE IMMEDIATE V_MSQL;	

    DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADOS LOS TIPOS DE GESTOR DUPLICADOS DE LA  DD_TGE_TIPO_GESTOR ' );

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] ');

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
