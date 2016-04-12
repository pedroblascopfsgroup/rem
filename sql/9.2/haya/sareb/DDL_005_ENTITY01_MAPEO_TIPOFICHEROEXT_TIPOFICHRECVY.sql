--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=11042016
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-1116
--## PRODUCTO=No
--## Finalidad: DDL de creación de la tabla de mapeo entre tipo de documento y tipo de documento del gestor documental de haya
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
    -- ******** MTT_MAP_ADJRECOVERY_ADJCM *******
    DBMS_OUTPUT.PUT_LINE('******** MTT_MAP_ADJRECOVERY_ADJCM ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM... Comprobaciones previas'); 
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''MTT_MAP_ADJRECOVERY_ADJCM'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM... Claves primarias eliminadas');	
    END IF;
	-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MTT_MAP_ADJRECOVERY_ADJCM'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
--	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_MTT_MAP_ADJRECOVERY_ADJCM'' and sequence_owner = '''||V_ESQUEMA||'''';
--	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
--	if V_NUM_TABLAS = 1 THEN			
--		V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_MTT_MAP_ADJRECOVERY_ADJCM';
--		EXECUTE IMMEDIATE V_MSQL;
--		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTT_MAP_ADJRECOVERY_ADJCM... Secuencia eliminada');    
--	END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTT_MAP_ADJRECOVERY_ADJCM... Comprobaciones previas FIN'); 
    --Creamos la tabla y secuencias
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTT_MAP_ADJRECOVERY_ADJCM...');
--    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_MTT_MAP_ADJRECOVERY_ADJCM';
--	EXECUTE IMMEDIATE V_MSQL; 
--	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_MTT_MAP_ADJRECOVERY_ADJCM... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.MTT_MAP_ADJRECOVERY_ADJCM
					(
					  MTT_ID                    NUMBER(16)          NOT NULL,
					  DD_TFA_ID                 NUMBER(16)          NOT NULL,
					  TFA_CODIGO_EXTERNO        VARCHAR2(10 CHAR)   NOT NULL,
					  VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
					  USUARIOCREAR              VARCHAR2(50 CHAR)   NOT NULL,
					  FECHACREAR                TIMESTAMP(6)        NOT NULL,
					  USUARIOMODIFICAR          VARCHAR2(50 CHAR),
					  FECHAMODIFICAR            TIMESTAMP(6),
					  USUARIOBORRAR             VARCHAR2(50 CHAR),
					  FECHABORRAR               TIMESTAMP(6),
					  BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
					)';
    EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTT_MAP_ADJRECOVERY_ADJCM... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_MTT_MAP_ADJRECOVERY_ADJCM ON ' || V_ESQUEMA || '.MTT_MAP_ADJRECOVERY_ADJCM
					(MTT_ID)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTT_MAP_ADJRECOVERY_ADJCM... Indice creado');
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.MTT_MAP_ADJRECOVERY_ADJCM ADD (
		  CONSTRAINT PK_MTT_MAP_ADJRECOVERY_ADJCM
		 PRIMARY KEY
		 (MTT_ID))';
	EXECUTE IMMEDIATE V_MSQL;              
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTT_MAP_ADJRECOVERY_ADJCM... PK creada');
	V_MSQL := 'ALTER TABLE MTT_MAP_ADJRECOVERY_ADJCM ADD (
			 CONSTRAINT FK_MAPEO_TIPO_FICHERO_ADJUNTO
			 FOREIGN KEY (DD_TFA_ID) 
			 REFERENCES DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID)
			)';
	EXECUTE IMMEDIATE V_MSQL;     
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTT_MAP_ADJRECOVERY_ADJCM... FK Creada');
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTT_MAP_ADJRECOVERY_ADJCM... OK');
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