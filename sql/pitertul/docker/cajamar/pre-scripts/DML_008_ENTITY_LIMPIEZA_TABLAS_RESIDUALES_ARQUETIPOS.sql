--/*
--##########################################
--## AUTOR=Carlos Pérez
--## FECHA_CREACION=20151223
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=-
--## INCIDENCIA_LINK=-
--## PRODUCTO=NO
--## Finalidad: DML para limpiar las tablas residuales de arquetipos
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_CODIGO VARCHAR2(2 CHAR); -- Vble. auxiliar para codigo diccionario
BEGIN
	DBMS_OUTPUT.PUT_LINE('******** LIMPIEZA TABLAS ARQUETIPOS ********'); 

		V_MSQL := 'delete from ' || V_ESQUEMA || '.MRA_REL_MODELO_ARQ';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Borrado el modelo de arquetipos');

    V_MSQL := 'delete from ' || V_ESQUEMA || '.LIA_LISTA_ARQUETIPOS';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Borrado el listado de arquetipos');

    V_MSQL := 'delete from ' || V_ESQUEMA || '.rule_definition';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Borrado de la definición de reglas');

    V_MSQL := 'delete from ' || V_ESQUEMA || '.MOA_MODELOS_ARQ';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Borrado de la relación de arquetipos');

		DBMS_OUTPUT.PUT_LINE('[FIN] Limpieza realizada correctamente');
	
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
