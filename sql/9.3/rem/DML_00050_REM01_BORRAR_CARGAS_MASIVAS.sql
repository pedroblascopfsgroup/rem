--/*
--######################################### 
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8341
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
	V_USUARIOBORRAR VARCHAR2(50 CHAR) := 'HREOS-8341';
	
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
    /*
	* Carga masiva actualiza toma de posesión.
	* Carga masiva de inscripciones.
	* SuperUsuario (Área Operaciones): Borrado de trabajos
	*/
    
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_OPM_OPERACION_MASIVA 
				SET USUARIOBORRAR = '''||V_USUARIOBORRAR||''',
				    FECHABORRAR = SYSDATE,
				    BORRADO = 1
				WHERE DD_OPM_CODIGO IN (
				    ''MSTP'',
				    ''CMIN'',
				    ''SUBT''
				)';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han borrado '||SQL%ROWCOUNT||' cargas masivas');

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