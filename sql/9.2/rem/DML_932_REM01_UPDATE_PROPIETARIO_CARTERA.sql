--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20160929
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-893
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade la cartera CAJAMAR a ACT_PRO_PROPIETARIO. A fecha de hoy, todos son de Cajamar.
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
	
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ACT_PRO_PROPIETARIO'' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DE LOS REGISTROS');
    	
		V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO pro SET pro.DD_CRA_ID = ('||
				 'SELECT cra.DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA cra WHERE cra.DD_CRA_CODIGO =''01''),'||
				 'pro.USUARIOMODIFICAR = ''HREOS-893'', pro.FECHAMODIFICAR = sysdate '||
				 'WHERE pro.DD_CRA_ID IS NULL';
		EXECUTE IMMEDIATE V_SQL;
    	
    END IF;
    
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DEL REGISTRO DE LOS REGISTROS' );
    
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