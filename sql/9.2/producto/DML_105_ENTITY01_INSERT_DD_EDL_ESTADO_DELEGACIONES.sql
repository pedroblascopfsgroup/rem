--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20160516
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.4
--## INCIDENCIA_LINK=PRODUCTO-1349
--## PRODUCTO=SI
--## Finalidad: DML que crea los registros necesarios en el diccionario de estado de delegaciones
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    

BEGIN
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EDL_ESTADO_DELEGACIONES WHERE DD_EDL_CODIGO = ''PREPARADA'' AND BORRADO=0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_EDL_ESTADO_DELEGACIONES (DD_EDL_ID, DD_EDL_CODIGO, DD_EDL_DESCRIPCION, DD_EDL_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO)
					VALUES ('||V_ESQUEMA||'.S_DD_EDL_ESTADO_DELEGACIONES.NEXTVAL, ''PREPARADA'', ''Preparada'', ''Delegación Preparada'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Estado PREPARADA insertada OK.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya estaba insertado el estado PREPARADA.');
	END IF;		
	
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EDL_ESTADO_DELEGACIONES WHERE DD_EDL_CODIGO = ''ACTIVA'' AND BORRADO=0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_EDL_ESTADO_DELEGACIONES (DD_EDL_ID, DD_EDL_CODIGO, DD_EDL_DESCRIPCION, DD_EDL_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO)
					VALUES ('||V_ESQUEMA||'.S_DD_EDL_ESTADO_DELEGACIONES.NEXTVAL, ''ACTIVA'', ''Activa'', ''Delegación Activa'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Estado ACTIVA insertada OK.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya estaba insertado el estado ACTIVA.');
	END IF;
			
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EDL_ESTADO_DELEGACIONES WHERE DD_EDL_CODIGO = ''CERRADA'' AND BORRADO=0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_EDL_ESTADO_DELEGACIONES (DD_EDL_ID, DD_EDL_CODIGO, DD_EDL_DESCRIPCION, DD_EDL_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO)
					VALUES ('||V_ESQUEMA||'.S_DD_EDL_ESTADO_DELEGACIONES.NEXTVAL, ''CERRADA'', ''Cerrada'', ''Delegación Cerrada'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Estado CERRADA insertada OK.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya estaba insertado el estado CERRADA.');
	END IF;	
	
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
