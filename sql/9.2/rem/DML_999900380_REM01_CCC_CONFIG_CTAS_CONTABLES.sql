--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20190108
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1945
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-1945'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION ACT_PRO_PROPIETARIO');
	
	V_SQL := 'SELECT COUNT(1) FROM CCC_CONFIG_CTAS_CONTABLES WHERE DD_STG_ID = 101 AND DD_CRA_ID = 21 AND EJE_ID = 68';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES
			   SET CCC_CUENTA_CONTABLE = ''11083'',
				   FECHAMODIFICAR = SYSDATE, 
				   USUARIOMODIFICAR = '''||V_USR||''' 
			   WHERE DD_STG_ID = 101 
			   AND DD_CRA_ID = 21
			   AND EJE_ID = 68
';
    EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADA CCC_CONFIG_CTAS_CONTABLES');
	
	ELSE 
	
	DBMS_OUTPUT.PUT_LINE('[FIN] El registro no existe');
	
	END IF;
	
	COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
