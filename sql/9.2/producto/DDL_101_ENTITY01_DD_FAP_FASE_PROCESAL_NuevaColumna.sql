--/*
--##########################################
--## AUTOR=PEDRO BLASCO
--## FECHA_CREACION=20160719
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2.8
--## INCIDENCIA_LINK=RECOVERY-558
--## PRODUCTO=SI
--##
--## Finalidad: Actualizacion para añadir un nuevo campo a la tabla DD_FAP_FASE_PROCESAL.
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    L_NULLABLE  VARCHAR2(1); -- Vble. para validar si un campo puede ser nulo.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN

    -- ******** Update de la tabla DD_FAP_FASE_PROCESAL *******
    DBMS_OUTPUT.PUT_LINE('******** Update de la tabla DD_FAP_FASE_PROCESAL *******'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_FAP_FASE_PROCESAL... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla.
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_FAP_FASE_PROCESAL'' and UPPER(owner) = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si NO existe la tabla no hacemos nada.
    IF V_NUM_TABLAS = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('[ERROR] '||V_ESQUEMA||'.DD_FAP_FASE_PROCESAL... La tabla NO existe, no se puede continuar..');    
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.DD_FAP_FASE_PROCESAL... Comienza la actualización.');
        
        -- Comprobamos si existe la columna, si no la creamos.
        V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''DD_FAP_FASE_PROCESAL'' and UPPER(owner) = '''||V_ESQUEMA||''' and column_name = ''DD_EPC_ID''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF(V_NUM_TABLAS < 1) THEN
          V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_FAP_FASE_PROCESAL ADD (DD_EPC_ID NUMBER(16) )';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] Se ha creado la columna DD_EPC_ID.');
          -- Generar la Foreign Key de la nueva columna.
          V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_FAP_FASE_PROCESAL ADD CONSTRAINT FK_DD_FAP_DD_EPR FOREIGN KEY (DD_EPC_ID) REFERENCES '||V_ESQUEMA||'.DD_EPC_ESTADO_PROCESAL (DD_EPC_ID) ENABLE';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] Se ha generado la foreign key para la columna DD_EPC_ID.');
        ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO] La columna DD_EPC_ID ya existe.');
        END IF;
        
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_FAP_FASE_PROCESAL... Actualizada.');

	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin script.');

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
