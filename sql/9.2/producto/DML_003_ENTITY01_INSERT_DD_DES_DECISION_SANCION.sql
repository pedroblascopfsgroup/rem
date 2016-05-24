--/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO
--## FECHA_CREACION=20160218
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1.0-cj-rc26
--## INCIDENCIA_LINK=PRODUCTO-798
--## PRODUCTO=SI
--## Finalidad: Insercion registros tabla 
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_STRING VARCHAR2(10); -- Vble. para validar la existencia de si el campo es nulo
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    BEGIN

	V_SQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DES_DECISION_SANCION WHERE DD_DES_CODIGO = ''APRB''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro en la tabla');
	ELSE
		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.DD_DES_DECISION_SANCION (DD_DES_ID,DD_DES_CODIGO,DD_DES_DESCRIPCION,DD_DES_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||'.S_DD_DES_DECISION_SANCION.NEXTVAL, ''APRB'', ''Aprobado'', ''Aprobado'',0,''DD'',SYSDATE,0)';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en la tabla');
	END IF;
	
	V_SQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DES_DECISION_SANCION WHERE DD_DES_CODIGO = ''APRB_COND''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro en la tabla');
	ELSE
		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.DD_DES_DECISION_SANCION (DD_DES_ID,DD_DES_CODIGO,DD_DES_DESCRIPCION,DD_DES_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||'.S_DD_DES_DECISION_SANCION.NEXTVAL, ''APRB_COND'', ''Aprobado con condiciones'', ''Aprobado con condiciones'',0,''DD'',SYSDATE,0)';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en la tabla');
	END IF;
	
	V_SQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DES_DECISION_SANCION WHERE DD_DES_CODIGO = ''RECHZ''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro en la tabla');
	ELSE
		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.DD_DES_DECISION_SANCION (DD_DES_ID,DD_DES_CODIGO,DD_DES_DESCRIPCION,DD_DES_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||'.S_DD_DES_DECISION_SANCION.NEXTVAL, ''RECHZ'', ''Rechazado'',''Rechazado'',0,''DD'',SYSDATE,0)';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en la tabla');
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
