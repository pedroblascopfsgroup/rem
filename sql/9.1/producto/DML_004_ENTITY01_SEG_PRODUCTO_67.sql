--/*
--##########################################
--## AUTOR=ALBERTO RAMÍREZ LOSILLA
--## FECHA_CREACION=20150803
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-67
--## PRODUCTO=SI
--## 
--## Finalidad: DML
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	

    DBMS_OUTPUT.PUT_LINE('******** DD_TPX_TIPO_EXPEDIENTE ********'); 
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobaciones previas registro con código ''RECU'''); 
    V_SQL := 'SELECT count(*) FROM '||V_ESQUEMA||'.DD_TPX_TIPO_EXPEDIENTE tpx WHERE tpx.DD_TPX_CODIGO = ''RECU''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe los valores
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO]: Ya existen el registro en la tabla.');
	ELSE
		V_MSQL_1 :='INSERT INTO '||V_ESQUEMA||'.DD_TPX_TIPO_EXPEDIENTE tpx
					(tpx.DD_TPX_ID, tpx.DD_TPX_CODIGO, tpx.DD_TPX_DESCRIPCION, tpx.DD_TPX_DESCRIPCION_LARGA, tpx.VERSION , tpx.USUARIOCREAR, tpx.FECHACREAR, tpx.BORRADO)
					VALUES
					('||V_ESQUEMA||'.S_DD_TPX_TIPO_EXPEDIENTE.nextval, ''RECU'', ''Expediente de Recuperación'', ''Expediente de Recuperación'', 0, ''PRODUCT-67'', sysdate, 0)';
    	
		EXECUTE IMMEDIATE V_MSQL_1;
		DBMS_OUTPUT.PUT_LINE('[INFO]: Registro insertado correctamente.');
	
    END IF;	
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobaciones previas registro con código ''SEG'''); 
    V_SQL := 'SELECT count(*) FROM '||V_ESQUEMA||'.DD_TPX_TIPO_EXPEDIENTE tpx WHERE tpx.DD_TPX_CODIGO = ''SEG''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe los valores
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO]: Ya existen el registro en la tabla.');
	ELSE
		V_MSQL_1 :='INSERT INTO '||V_ESQUEMA||'.DD_TPX_TIPO_EXPEDIENTE tpx
					(tpx.DD_TPX_ID, tpx.DD_TPX_CODIGO, tpx.DD_TPX_DESCRIPCION, tpx.DD_TPX_DESCRIPCION_LARGA, tpx.VERSION , tpx.USUARIOCREAR, tpx.FECHACREAR, tpx.BORRADO)
					VALUES
					('||V_ESQUEMA||'.S_DD_TPX_TIPO_EXPEDIENTE.nextval, ''SEG'', ''Expediente de Seguimiento'', ''Expediente de Seguimiento'', 0, ''PRODUCT-67'', sysdate, 0)';
    	
		EXECUTE IMMEDIATE V_MSQL_1;
		DBMS_OUTPUT.PUT_LINE('[INFO]: Registro insertado correctamente.');
	
    END IF;	
    
    COMMIT;
    
	DBMS_OUTPUT.PUT_LINE('[INFO]: Script finalizado correctamente.');


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
  	
  	