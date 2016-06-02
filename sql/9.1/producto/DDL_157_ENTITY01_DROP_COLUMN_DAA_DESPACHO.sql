--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20160129
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-677
--## PRODUCTO=SI
--## Finalidad: Alteracion tabla - eliminar columna DAA_PROV_CALIDAD_PORCENTAJE
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_STRING VARCHAR2(10); -- Vble. para validar la existencia de si el campo es nulo
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.DAA_DESPACHO_AMBITO_ACTUACION - Borrar columna DAA_DESPACHO_AMBITO_ACTUACION');

	---- Se comprueba que exista la columna
	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = ''DAA_PROV_CALIDAD_PORCENTAJE'' AND TABLE_NAME = ''DAA_DESPACHO_AMBITO_ACTUACION''';
		  
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] El campo DAA_PROV_CALIDAD_PORCENTAJE  *NO* existe en la tabla. Por tanto no se hará nada.');
	ELSE 
		-- Vacíamos la columna
		V_SQL := 'UPDATE '||V_ESQUEMA||'.DAA_DESPACHO_AMBITO_ACTUACION SET DAA_PROV_CALIDAD_PORCENTAJE=null';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.DAA_DESPACHO_AMBITO_ACTUACION... se han eliminado los registros de esta columna');
		--Se borra la columna	
		V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.DAA_DESPACHO_AMBITO_ACTUACION DROP COLUMN DAA_PROV_CALIDAD_PORCENTAJE';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.DAA_DESPACHO_AMBITO_ACTUACION... Columna  eliminada correctamente');
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