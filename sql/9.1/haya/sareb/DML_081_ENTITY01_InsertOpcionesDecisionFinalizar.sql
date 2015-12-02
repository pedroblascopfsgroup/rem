--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20151015	
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.7-hy-rc01
--## INCIDENCIA_LINK=HR-1322
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
	
    -- AÑADIENDO OPCIONES --
    DBMS_OUTPUT.PUT_LINE('******** DD_DFI_DECISION_FINALIZAR ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR WHERE DD_DFI_CODIGO=''QUITA''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si ya existe la opción QUITA
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] El valor QUITA ya existe en la tabla '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR...no se modifica nada.');
	ELSE
		V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR' ||
				' (DD_DFI_ID, DD_DFI_CODIGO, DD_DFI_DESCRIPCION, DD_DFI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
				'VALUES ('||V_ESQUEMA||'.S_DD_DFI_DECISION_FINALIZAR.NEXTVAL, ''QUITA'', ''Quita'', ''Quita'', 1, ''DML'', SYSDATE, 0)';
    	
		EXECUTE IMMEDIATE V_MSQL_1;
		DBMS_OUTPUT.PUT_LINE('[INFO] Opción QUITA insertada correctamente.');
	
    END IF;	

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR WHERE DD_DFI_CODIGO=''REGUL''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si ya existe la opción REGULARIZACIÓN
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] El valor REGULARIZACIÓN ya existe en la tabla '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR...no se modifica nada.');
	ELSE
		V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR' ||
				' (DD_DFI_ID, DD_DFI_CODIGO, DD_DFI_DESCRIPCION, DD_DFI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
				'VALUES ('||V_ESQUEMA||'.S_DD_DFI_DECISION_FINALIZAR.NEXTVAL, ''REGUL'', ''Regularización'', ''Regularización'', 1, ''DML'', SYSDATE, 0)';
    	
		EXECUTE IMMEDIATE V_MSQL_1;
		DBMS_OUTPUT.PUT_LINE('[INFO] Opción REGULARIZACIÓN insertada correctamente.');
	
    END IF;	

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR WHERE DD_DFI_CODIGO=''ACUE''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si ya existe la opción ACUERDO CON EL DEUDOR
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] El valor ACUERDO CON EL DEUDOR ya existe en la tabla '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR...no se modifica nada.');
	ELSE
		V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR' ||
				' (DD_DFI_ID, DD_DFI_CODIGO, DD_DFI_DESCRIPCION, DD_DFI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
				'VALUES ('||V_ESQUEMA||'.S_DD_DFI_DECISION_FINALIZAR.NEXTVAL, ''ACUE'', ''Acuerdo con el deudor'', ''Acuerdo con el deudor'', 1, ''DML'', SYSDATE, 0)';
    	
		EXECUTE IMMEDIATE V_MSQL_1;
		DBMS_OUTPUT.PUT_LINE('[INFO] Opción ACUERDO CON EL DEUDOR insertada correctamente.');
	
    END IF;	
    
    COMMIT;
    
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');


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