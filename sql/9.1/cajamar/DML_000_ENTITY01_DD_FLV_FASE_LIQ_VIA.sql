--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150717
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=CMREC-369
--## PRODUCTO=NO
--## Finalidad: DDL
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	DBMS_OUTPUT.PUT_LINE('******** DD_FLV_FASE_LIQ_VIA ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA WHERE DD_FLV_CODIGO = ''SUB_CON'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA (DD_FLV_ID,DD_FLV_CODIGO,DD_FLV_DESCRIPCION,DD_FLV_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||'.S_DD_FLV_FASE_LIQ_VIA.nextval,''SUB_CON'',''Subasta concursal'',''Subasta concursal'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA.');
	END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA WHERE DD_FLV_CODIGO = ''VEN_DIR'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA (DD_FLV_ID,DD_FLV_CODIGO,DD_FLV_DESCRIPCION,DD_FLV_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||'.S_DD_FLV_FASE_LIQ_VIA.nextval,''VEN_DIR'',''Venta directa'',''Venta directa'',0,''DML'',sysdate,0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA.');
	END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA WHERE DD_FLV_CODIGO = ''DAC_PAG'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA (DD_FLV_ID,DD_FLV_CODIGO,DD_FLV_DESCRIPCION,DD_FLV_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||'.S_DD_FLV_FASE_LIQ_VIA.nextval,''DAC_PAG'',''Dación en pago'',''Dación en pago'',0,''DML'',sysdate,0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA.');
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA WHERE DD_FLV_CODIGO = ''OTR'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA (DD_FLV_ID,DD_FLV_CODIGO,DD_FLV_DESCRIPCION,DD_FLV_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||'.S_DD_FLV_FASE_LIQ_VIA.nextval,''OTR'',''Otras'',''Otras'',0,''DML'',sysdate,0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_FLV_FASE_LIQ_VIA.');
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
