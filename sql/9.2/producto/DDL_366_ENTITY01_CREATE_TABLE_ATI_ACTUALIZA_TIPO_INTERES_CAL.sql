--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20160504
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1323
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla ATI_ACTUALIZA_TIPO_INTERES_CAL
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    BEGIN

    -- ******** SAE_SANCION_EXPEDIENTE *******
    DBMS_OUTPUT.PUT_LINE('******** ATI_ACTUALIZA_TIPO_INTERES_CAL ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ATI_ACTUALIZA_TIPO_INTERES_CAL... Comprobaciones previas'); 
    
    -- Creacion Tabla SAE_SANCION_EXPEDIENTE
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ATI_ACTUALIZA_TIPO_INTERES_CAL'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ATI_ACTUALIZA_TIPO_INTERES_CAL... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.ATI_ACTUALIZA_TIPO_INTERES_CAL
               (
				ATI_ID NUMBER(16,0) NOT NULL,
			    CAL_ID NUMBER(16,0) NOT NULL,
				ATI_FECHA DATE NOT NULL,
				ATI_TIPO NUMBER(5,2) NOT NULL,
				VERSION NUMBER(38,0),
				USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL,
				FECHACREAR TIMESTAMP(6) NOT NULL,
				USUARIOMODIFICAR VARCHAR2(50 CHAR),
				FECHAMODIFICAR TIMESTAMP(6),
				USUARIOBORRAR VARCHAR2(50 CHAR),
				FECHABORRAR TIMESTAMP(6),
				BORRADO NUMBER(1) DEFAULT 0 NOT NULL
			  )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ATI_ACTUALIZA_TIPO_INTERES_CAL... Tabla creada');
		
    END IF;
    
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''ATI_ACTUALIZA_TIPO_INTERES_CAL'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 0 THEN
    	V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_ATI_ACTUALIZA_TIPO_INTERES ON ' || V_ESQUEMA || '.ATI_ACTUALIZA_TIPO_INTERES_CAL (ATI_ID)  TABLESPACE ' || V_TS_INDEX;
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'CREATE INDEX ' || V_ESQUEMA || '.IDX_CAL_ID_ACTUALIZA_TIPO_INTE ON ' || V_ESQUEMA || '.ATI_ACTUALIZA_TIPO_INTERES_CAL (CAL_ID)  TABLESPACE ' || V_TS_INDEX;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_ATI_ACTUALIZA_TIPO_INTERES... Indice creado');
		
		V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.ATI_ACTUALIZA_TIPO_INTERES_CAL ADD (
			  CONSTRAINT PK_ATI_ACTUALIZA_TIPO_INTERES PRIMARY KEY (ATI_ID),
			  CONSTRAINT FK_ATI_CAL_CALCULO_LIQUIDACION FOREIGN KEY (CAL_ID) REFERENCES  ' || V_ESQUEMA || '.CAL_CALCULO_LIQUIDACION (CAL_ID))';
		EXECUTE IMMEDIATE V_MSQL;              
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_CAL_CALCULO_LIQUIDACION... PK creada');
	END IF;
		
		 -- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_ATI_ACTUALIZA_TIPO_INTERES_C'' and sequence_owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 0 THEN			
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_ATI_ACTUALIZA_TIPO_INTERES_C...');
		V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_ATI_ACTUALIZA_TIPO_INTERES_C';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_ATI_ACTUALIZA_TIPO_INTERES_C... Secuencia creada');    
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ATI_ACTUALIZA_TIPO_INTERES_CAL... OK');
	
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
