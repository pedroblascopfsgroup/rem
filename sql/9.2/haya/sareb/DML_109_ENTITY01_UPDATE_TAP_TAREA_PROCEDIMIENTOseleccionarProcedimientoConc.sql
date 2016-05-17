/*
--##########################################
--## AUTOR=Alberto b.
--## FECHA_CREACION=20160517
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.4-hy-rc08
--## INCIDENCIA_LINK=HR-2584
--## PRODUCTO=NO
--##
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    VAR_TIPOACTUACION VARCHAR2(50 CHAR); -- Tipo de actuación a insertar

       
BEGIN	
	
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_DESCRIPCION = ''H067_seleccionarProcedimientoConc''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS > 0 THEN
		V_MSQL_1 := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = NULL, USUARIOMODIFICAR = ''HR-2584'', FECHAMODIFICAR = SYSDATE WHERE TAP_DESCRIPCION = ''H067_seleccionarProcedimientoConc''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL_1);
		EXECUTE IMMEDIATE V_MSQL_1;
		
		DBMS_OUTPUT.PUT_LINE('[FIN] REGISTRO ACTUALIZADO');	
	ELSE
		DBMS_OUTPUT.PUT_LINE('[FIN] NO EXISTE LA TAREA');
	END IF;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');

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