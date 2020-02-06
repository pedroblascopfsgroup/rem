--/*
--######################################### 
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20200127
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6261
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
	V_USUARIOBORRAR VARCHAR2(50 CHAR) := 'REMVIP-6261';
	
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO 
				SET USUARIOBORRAR = '''||V_USUARIOBORRAR||''',
				    FECHABORRAR = SYSDATE,
				    BORRADO = 1
				WHERE DD_TPD_CODIGO = ''06''';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han borrado '||SQL%ROWCOUNT||' registros');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO 
				SET USUARIOMODIFICAR = '''||V_USUARIOBORRAR||''',
				    FECHAMODIFICAR = SYSDATE,
				    DD_TPD_MATRICULA_GD = ''AI-01-NOTS-08''
				WHERE DD_TPD_CODIGO = ''98''';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han modificado '||SQL%ROWCOUNT||' registros');

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