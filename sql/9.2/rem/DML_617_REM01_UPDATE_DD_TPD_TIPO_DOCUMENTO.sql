--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20191014
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-8020
--## PRODUCTO=NO
--##
--## Finalidad: Hacer borrado lógico de documentos que no tienen que verse a nivel de activo.
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
    V_USUARIO VARCHAR2(100 CHAR) := 'HREOS-8020';
    V_COUNT NUMBER(16);

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE ('[INICIO] Empieza la ejecucion ');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO SET 
					BORRADO = 1 
				,   USUARIOBORRAR = '''||V_USUARIO||'''
				,   FECHABORRAR = SYSDATE
				WHERE DD_TPD_CODIGO IN (''140'', ''141'', ''142'', ''143'', ''146'', ''147'', ''148'', ''149'', ''150'', ''151'')';
	
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE ('Filas actualizadas ' || SQL%ROWCOUNT);
	
	DBMS_OUTPUT.PUT_LINE ('[FIN] Fin de la ejecucion ');
	
	COMMIT;
	
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          ROLLBACK;
          RAISE;
END;

/

EXIT
