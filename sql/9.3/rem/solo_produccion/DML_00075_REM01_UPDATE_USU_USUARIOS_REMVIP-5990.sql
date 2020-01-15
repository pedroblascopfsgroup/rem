--/*
--######################################### 
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5990
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

	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master 
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIOMODIFICAR VARCHAR2(50 CHAR) := 'REMVIP-5990';
	V_NUM NUMBER(25);
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualización mail usuario ''ficticioOfertaCajamar''');
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_MAIL = ''HayaOfertasyContraof@cajamar.com'' AND USU_USERNAME = ''ficticioOfertaCajamar''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
    IF V_NUM > 0 THEN
	    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET USU_MAIL = ''ofertasyreservascajamar@haya.es''
					, USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''', FECHAMODIFICAR = SYSDATE WHERE USU_USERNAME = ''ficticioOfertaCajamar''';
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
  
EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    
    DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
    DBMS_OUTPUT.PUT_LINE(err_msg);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;
