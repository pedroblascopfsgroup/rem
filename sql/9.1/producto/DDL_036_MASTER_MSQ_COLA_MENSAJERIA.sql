--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20150710
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=HR-970
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

	-- ******** MSQ_COLA_MENSAJERIA *******
    DBMS_OUTPUT.PUT_LINE('******** MSQ_COLA_MENSAJERIA ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.MSQ_COLA_MENSAJERIA... Comprobaciones previas'); 
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''MSQ_COLA_MENSAJERIA'' and owner = '''||V_ESQUEMA_M||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA_M||'.MSQ_COLA_MENSAJERIA
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.MSQ_COLA_MENSAJERIA... Claves primarias eliminadas');	
    END IF;
		-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MSQ_COLA_MENSAJERIA'' and owner = '''||V_ESQUEMA_M||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA_M||'.MSQ_COLA_MENSAJERIA CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.MSQ_COLA_MENSAJERIA... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_MSQ_COLA_MENSAJERIA'' and sequence_owner = '''||V_ESQUEMA_M||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA_M||'.S_MSQ_COLA_MENSAJERIA';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.S_MSQ_COLA_MENSAJERIA... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.MSQ_COLA_MENSAJERIA... Comprobaciones previas FIN'); 
    
    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.S_MSQ_COLA_MENSAJERIA...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA_M || '.S_MSQ_COLA_MENSAJERIA';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.S_MSQ_COLA_MENSAJERIA... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA_M || '.MSQ_COLA_MENSAJERIA
					(
					  MSQ_ID                 NUMBER(16)          NOT NULL,
					  MSQ_FECHA             TIMESTAMP(6)   NOT NULL,
					  MSQ_DIRECCION        VARCHAR2(1 CHAR)   NOT NULL,
					  MSQ_ESTADO  VARCHAR2(1 CHAR)  NOT NULL,
					  SYS_GUID_GRP  VARCHAR2(36 CHAR)  NOT NULL,
					  MSQ_TIPO  VARCHAR2(50 CHAR)  NOT NULL,
					  MSQ_MENSAJE CLOB NOT NULL,
					  MSQ_LOG  VARCHAR2(4000 CHAR) NULL,
					  VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
					  USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
					  FECHACREAR                TIMESTAMP(6)        NOT NULL,
					  USUARIOMODIFICAR          VARCHAR2(10 CHAR),
					  FECHAMODIFICAR            TIMESTAMP(6),
					  USUARIOBORRAR             VARCHAR2(10 CHAR),
					  FECHABORRAR               TIMESTAMP(6),
					  BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
					)';
    EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.MSQ_COLA_MENSAJERIA... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA_M || '.PK_MSQ_COLA_MENSAJERIA ON ' || V_ESQUEMA_M || '.MSQ_COLA_MENSAJERIA
					(MSQ_ID)  TABLESPACE ' || V_TS_INDEX;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.PK_MSQ_COLA_MENSAJERIA... Indice creado');
    V_MSQL := 'CREATE INDEX ' || V_ESQUEMA_M || '.IDX_MSQ_FECHA_1 ON ' || V_ESQUEMA_M || '.MSQ_COLA_MENSAJERIA
					(MSQ_FECHA)  TABLESPACE ' || V_TS_INDEX;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.IDX_MSQ_FECHA_1... Indice creado');
    V_MSQL := 'CREATE INDEX ' || V_ESQUEMA_M || '.IDX_MSQ_ESTADOTIP_1 ON ' || V_ESQUEMA_M || '.MSQ_COLA_MENSAJERIA
					(MSQ_TIPO,MSQ_ESTADO)  TABLESPACE ' || V_TS_INDEX;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.IDX_MSQ_ESTADOTIP_1... Indice creado');
    V_MSQL := 'CREATE INDEX ' || V_ESQUEMA_M || '.IDX_MSQ_ESTADOGUID_1 ON ' || V_ESQUEMA_M || '.MSQ_COLA_MENSAJERIA
					(MSQ_ESTADO,SYS_GUID_GRP)  TABLESPACE ' || V_TS_INDEX;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.IDX_MSQ_ESTADOGUID_1... Indice creado');

	V_MSQL := 'ALTER TABLE ' || V_ESQUEMA_M || '.MSQ_COLA_MENSAJERIA ADD (
		  CONSTRAINT PK_MSQ_COLA_MENSAJERIA PRIMARY KEY (MSQ_ID))';
		EXECUTE IMMEDIATE V_MSQL;              
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.PK_MSQ_COLA_MENSAJERIA... PK creada');
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.MSQ_COLA_MENSAJERIA... OK');
    
    -- ejecutamos grants --
    V_MSQL := 'GRANT ALL ON '||V_ESQUEMA_M||'.MSQ_COLA_MENSAJERIA TO '||V_ESQUEMA; 			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Grant ejecutado correctamente.');
	
	V_SQL := 'SELECT COUNT(1) FROM ALL_USERS WHERE USERNAME = ''RECOVERY_BANKIA_DWH'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN 
    	 V_MSQL := 'GRANT ALL ON '||V_ESQUEMA_M||'.MSQ_COLA_MENSAJERIA TO RECOVERY_BANKIA_DWH'; 			
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Grant ejecutado correctamente.');
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_USERS WHERE USERNAME = ''MINIREC'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN 
    	 V_MSQL := 'GRANT ALL ON '||V_ESQUEMA_M||'.MSQ_COLA_MENSAJERIA TO MINIREC'; 			
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Grant ejecutado correctamente.');
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_USERS WHERE USERNAME = ''RECOVERY_BANKIA_DATASTAGE'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN 
    	 V_MSQL := 'GRANT ALL ON '||V_ESQUEMA_M||'.MSQ_COLA_MENSAJERIA TO RECOVERY_BANKIA_DATASTAGE'; 			
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Grant ejecutado correctamente.');
    END IF;
	
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