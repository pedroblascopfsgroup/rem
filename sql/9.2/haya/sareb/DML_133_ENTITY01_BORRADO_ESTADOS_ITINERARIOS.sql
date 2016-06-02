--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20160419
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1146
--## PRODUCTO=SI
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Elimina logicamente los estados itinerarios "Creación manual expediente recobro" y "Formalizar Propuesta"
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
    TABLADD1 VARCHAR(31) :='DD_EST_ESTADOS_ITINERARIOS';
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_EXISTE NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** DD_EST_ESTADOS_ITINERARIOS BORRADO LOGICO ********'); 
	
	V_MSQL := 'UPDATE ' ||V_ESQUEMA_M|| '.'||TABLADD1||' EXT SET EXT.BORRADO = 1, EXT.USUARIOBORRAR=''DML'', EXT.FECHABORRAR=SYSDATE 
		WHERE EXT.DD_EST_CODIGO = ''CMER'' or  EXT.DD_EST_CODIGO = ''FP''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS');
	
		
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
