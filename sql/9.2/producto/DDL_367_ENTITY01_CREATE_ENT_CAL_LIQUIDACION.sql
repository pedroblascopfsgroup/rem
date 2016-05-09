--/*
--##########################################
--## AUTOR=Carlos Gil Gimeno
--## FECHA_CREACION=20160404
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1323
--## PRODUCTO=SI
--## Finalidad: DDL
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN

	-- ******** ENT_CAL_LIQUIDACION *******
    DBMS_OUTPUT.PUT_LINE('******** ENT_CAL_LIQUIDACION ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ENT_CAL_LIQUIDACION... Comprobaciones previas'); 
	
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ENT_CAL_LIQUIDACION'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si no existe la creamos
	    IF V_NUM_TABLAS = 0 THEN 
		    --Creamos la tabla
		    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.ENT_CAL_LIQUIDACION
							(
								ENT_CAL_ID NUMBER(16,0) NOT NULL,
								CAL_ID NUMBER(16,0) NOT NULL,
								ENT_FECHA DATE NOT NULL,
								ENT_FECHA_VALOR DATE NOT NULL,
								DD_ATE_ID NUMBER(16,0),
								DD_ACE_ID NUMBER(16,0),
								ENT_TOTAL NUMBER(16,2),
								ENT_GASTOS_PROCURADOR NUMBER(16,2), 
								ENT_GASTOS_LETRADO NUMBER(16,2), 
								ENT_OTROS_GASTOS NUMBER(16,2), 
								VERSION INTEGER DEFAULT 0 NOT NULL,
								USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL,
								FECHACREAR TIMESTAMP(6) NOT NULL,
								USUARIOMODIFICAR VARCHAR2(50 CHAR),
								FECHAMODIFICAR TIMESTAMP(6),
								USUARIOBORRAR VARCHAR2(50 CHAR),
								FECHABORRAR TIMESTAMP(6),
								BORRADO NUMBER(1) DEFAULT 0 NOT NULL
							)';
		    EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ENT_CAL_LIQUIDACION... Tabla creada');  
    	END IF;
    	
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''ENT_CAL_LIQUIDACION'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si no existe la PK
    IF V_NUM_TABLAS = 0 THEN	
	    	
    		V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_ENT_CAL_LIQUIDACION ON ' || V_ESQUEMA || '.ENT_CAL_LIQUIDACION (ENT_CAL_ID)  TABLESPACE ' || V_TS_INDEX;
			EXECUTE IMMEDIATE V_MSQL;
			
		    V_SQL := 'CREATE INDEX '||V_ESQUEMA||'.IDX_CAL_ID_ENTCAL ON '||V_ESQUEMA||'.ENT_CAL_LIQUIDACION (CAL_ID)  TABLESPACE ' || V_TS_INDEX;
	    	EXECUTE IMMEDIATE V_SQL;
	    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ENT_CAL_LIQUIDACION CAL_ID... Indice creado');
	    	
	    	V_SQL := 'CREATE INDEX '||V_ESQUEMA||'.IDX_DD_ATE_ID_ENTCAL ON '||V_ESQUEMA||'.ENT_CAL_LIQUIDACION (DD_ATE_ID )  TABLESPACE ' || V_TS_INDEX;
	    	EXECUTE IMMEDIATE V_SQL;
	    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ENT_CAL_LIQUIDACION DD_ATE_ID ... Indice creado');
	    	
	    	V_SQL := 'CREATE INDEX '||V_ESQUEMA||'.IDX_DD_ACE_ID_ENTCAL ON '||V_ESQUEMA||'.ENT_CAL_LIQUIDACION (DD_ACE_ID )  TABLESPACE ' || V_TS_INDEX;
	    	EXECUTE IMMEDIATE V_SQL;
	    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ENT_CAL_LIQUIDACION DD_ACE_ID ... Indice creado');
	    	
    	
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_ENT_CAL_LIQUIDACION... Indice creado');
	    	V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.ENT_CAL_LIQUIDACION ADD (
			  CONSTRAINT PK_ENT_CAL_LIQUIDACION PRIMARY KEY (ENT_CAL_ID),
			  CONSTRAINT FK_ENT_CAL_CAL_ID FOREIGN KEY (CAL_ID) REFERENCES  ' || V_ESQUEMA || '.CAL_CALCULO_LIQUIDACION (CAL_ID),
			  CONSTRAINT FK_ENT_CAL_DD_ATE_ID FOREIGN KEY (DD_ATE_ID) REFERENCES  ' || V_ESQUEMA || '.DD_ATE_ADJ_TPO_ENTREGA (DD_ATE_ID),
			  CONSTRAINT FK_ENT_CAL_DD_ACE_ID FOREIGN KEY (DD_ACE_ID) REFERENCES  ' || V_ESQUEMA || '.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID))';
			EXECUTE IMMEDIATE V_MSQL;              
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_ENT_CAL_LIQUIDACION... PK creada');	
    END IF;
    
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_ENT_CAL_LIQUIDACION'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 0 THEN			
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_ENT_CAL_LIQUIDACION...');
		    	V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_ENT_CAL_LIQUIDACION';
				EXECUTE IMMEDIATE V_MSQL; 
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_ENT_CAL_LIQUIDACION... Secuencia creada');    
		END IF; 

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ENT_CAL_LIQUIDACION... OK');
	
    DBMS_OUTPUT.PUT_LINE('[INFO] Fin script.');

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