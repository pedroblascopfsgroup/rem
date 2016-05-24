--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20160411
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1188
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: Relanzable
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

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION ENTIDAD HAYA-SAREB');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.ENTIDAD SET CODIGO = ''HAYA'', DESCRIPCION=''HAYA'', DESCRIPCION_LARGA=''SAREB'' WHERE DESCRIPCION = ''HAYA'' OR DESCRIPCION = ''SAREB''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[FIN] ENTIDAD HAYA-SAREB actualizada');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION ENTIDAD HAYA-CAJAMAR');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.ENTIDAD SET CODIGO = ''CAJAMAR'', DESCRIPCION_LARGA=''CAJAMAR'' WHERE DESCRIPCION = ''CAJAMAR''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[FIN] ENTIDAD HAYA-CAJAMAR actualizada');
	
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
