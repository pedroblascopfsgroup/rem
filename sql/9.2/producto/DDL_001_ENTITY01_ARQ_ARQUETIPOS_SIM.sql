--/*
--##########################################
--## AUTOR=salvador Gorrita
--## FECHA_CREACION=20160204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-cj
--## INCIDENCIA_LINK=CMREC-2003
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN

	-- ******** ARQ_ARQUETIPOS_SIM *******
    DBMS_OUTPUT.PUT_LINE('******** ARQ_ARQUETIPOS_SIM ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ARQ_ARQUETIPOS_SIM... Comprobaciones previas'); 
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''ARQ_ARQUETIPOS_SIM'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ARQ_ARQUETIPOS_SIM
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ARQ_ARQUETIPOS_SIM... Claves primarias eliminadas');	
    END IF;
		-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ARQ_ARQUETIPOS_SIM'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.ARQ_ARQUETIPOS_SIM CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ARQ_ARQUETIPOS_SIM... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_ARQ_ARQUETIPOS_SIM'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_ARQ_ARQUETIPOS_SIM';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_ARQ_ARQUETIPOS_SIM... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ARQ_ARQUETIPOS_SIM... Comprobaciones previas FIN'); 
    
    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_ARQ_ARQUETIPOS_SIM...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_ARQ_ARQUETIPOS_SIM';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_ARQ_ARQUETIPOS_SIM... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.ARQ_ARQUETIPOS_SIM
					(
					    ARQ_ID NUMBER(16,0) NOT NULL ENABLE, 
						ITI_ID NUMBER(16,0), 
						ARQ_PRIORIDAD NUMBER(16,0), 
						ARQ_NOMBRE VARCHAR2(100 CHAR), 
						VERSION NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE, 
						USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL ENABLE, 
						FECHACREAR TIMESTAMP (6) NOT NULL ENABLE, 
						USUARIOMODIFICAR VARCHAR2(50 CHAR), 
						FECHAMODIFICAR TIMESTAMP (6), 
						USUARIOBORRAR VARCHAR2(50 CHAR), 
						FECHABORRAR TIMESTAMP (6), 
						BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE, 
						ARQ_NIVEL NUMBER(4,0) DEFAULT 0 NOT NULL ENABLE, 
						ARQ_GESTION NUMBER(1,0) DEFAULT 1 NOT NULL ENABLE, 
						ARQ_PLAZO_DISPARO NUMBER(16,0) DEFAULT 0, 
						DD_TSN_ID NUMBER(16,0), 
						RD_ID NUMBER(16,0), 
						MRA_ID NUMBER(16,0), 
						DTYPE VARCHAR2(200 CHAR) DEFAULT ''ARQArquetipoSim'' NOT NULL ENABLE
					)';
					
    EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ARQ_ARQUETIPOS_SIM... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_ARQ_ARQUETIPOS_SIM ON ' || V_ESQUEMA || '.ARQ_ARQUETIPOS_SIM
					(ARQ_ID)  TABLESPACE ' || V_TS_INDEX;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_ARQ_ARQUETIPOS_SIM... Indice creado');
		
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.ARQ_ARQUETIPOS_SIM ADD (
		  CONSTRAINT PK_ARQ_ARQUETIPOS_SIM PRIMARY KEY (ARQ_ID))';
		EXECUTE IMMEDIATE V_MSQL;              
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_ARQ_ARQUETIPOS_SIM... PK creada');
		
	V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.ARQ_ARQUETIPOS_SIM ADD (
		  CONSTRAINT FK_ARQ_ARQU_FK_MRA_REL_MODELO FOREIGN KEY (MRA_ID) REFERENCES ' || V_ESQUEMA || '.MRA_REL_MODELO_ARQ (MRA_ID) ENABLE)';
		EXECUTE IMMEDIATE V_MSQL;              
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.FK_ARQ_ARQU_FK_MRA_REL_MODELO... FK creada');	
		
	V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.ARQ_ARQUETIPOS_SIM ADD (
		  CONSTRAINT FK_ARQ_ARQU_FK_DD_TSN_ID FOREIGN KEY (DD_TSN_ID) REFERENCES ' || V_ESQUEMA_M || '.DD_TSN_TIPO_SALTO_NIVEL" (DD_TSN_ID) ENABLE)';
		EXECUTE IMMEDIATE V_MSQL;              
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.FK_ARQ_ARQU_FK_DD_TSN_ID... FK creada');		
		
	V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.ARQ_ARQUETIPOS_SIM ADD (
		  CONSTRAINT FK_ARQ_ARQU_FK_ITI_AR_ITI_ITIN FOREIGN KEY (ITI_ID) REFERENCES ' || V_ESQUEMA || '.ITI_ITINERARIOS (ITI_ID) ENABLE)';
		EXECUTE IMMEDIATE V_MSQL;              
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.FK_ARQ_ARQU_FK_ITI_AR_ITI_ITIN... FK creada');	
    
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
