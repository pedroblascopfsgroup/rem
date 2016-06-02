--/*
--##########################################
--## AUTOR=Alberto b
--## FECHA_CREACION=20151218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc34
--## INCIDENCIA_LINK=CMREC-1584
--## PRODUCTO=NO
--##
--## Finalidad: Resolución de incidencia acuerdos
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

	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION MOT_MOTIVO');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.MOT_MOTIVO WHERE BORRADO = ''0'' AND MOT_CODIGO = ''PREPOL''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.MOT_MOTIVO SET MOT_DESCRIPCION = ''Política de seguimiento'' WHERE MOT_CODIGO = ''PREPOL''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[FIN] El motivo PREPOL ha sido actualizado');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[FIN] El motivo PREPOL no existe');
		
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