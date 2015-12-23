--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20151221
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.12-bk
--## INCIDENCIA_LINK=HR-1675
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TABLA VARCHAR2(50 CHAR) := 'USU_ENTIDADES';

BEGIN

	--Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA_M||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA_M||'.'||V_TABLA||'
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.'||V_TABLA||'... Claves primarias eliminadas');	
    END IF;
	
	-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA_M||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA_M||'.'||V_TABLA||' CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.'||V_TABLA||'... Tabla borrada');  
    END IF;
	
	--##COMPROBACION EXISTENCIA SECUENCIA, BORRAR PRIMERO
	V_NUM_SEQ := 0;
	select count(1) INTO V_NUM_SEQ from all_sequences
	where sequence_owner = V_ESQUEMA_M
	and sequence_name = 'S_'||V_TABLA||'';
	
	if V_NUM_SEQ > 0 then 
	--YA existe una versión de la secuencia , se elimina primero
	  DBMS_OUTPUT.PUT('[INFO] Ya existe una versión de la secuencia S_'||V_TABLA||': se ELIMINA...');
	  EXECUTE IMMEDIATE 'drop sequence '||V_ESQUEMA_M||'.S_'||V_TABLA||'';
	  DBMS_OUTPUT.PUT_LINE('OK');
	END IF;
		
	--##CREACION DE TABLA, SECUENCIA Y PK de tabla
	  DBMS_OUTPUT.PUT('[INFO] Secuencia S_'||V_TABLA||': CREADA...');
		EXECUTE IMMEDIATE 'CREATE SEQUENCE '||V_ESQUEMA_M||'.S_'||V_TABLA||''; 
	  DBMS_OUTPUT.PUT_LINE('OK');
	
	  DBMS_OUTPUT.PUT('[INFO] Tabla '||V_TABLA||': CREADA...');	     	 
		EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA_M||'.'||V_TABLA||'
		(
		  UE_ID				NUMBER(16)			NOT NULL,
		  USU_ID			NUMBER(16)          NOT NULL,
		  ENTIDAD_ID	    NUMBER(16)          NOT NULL,
		  VERSION           INTEGER                     DEFAULT 0                     NOT NULL,
		  USUARIOCREAR      VARCHAR2(10 CHAR)           NOT NULL,
		  FECHACREAR        TIMESTAMP(6)                NOT NULL,
		  USUARIOMODIFICAR  VARCHAR2(10 CHAR),
		  FECHAMODIFICAR    TIMESTAMP(6),
		  USUARIOBORRAR     VARCHAR2(10 CHAR),
		  FECHABORRAR       TIMESTAMP(6),
		  BORRADO           NUMBER(1)                   DEFAULT 0                     NOT NULL
		)';
	  DBMS_OUTPUT.PUT_LINE('OK');
	
	
	  DBMS_OUTPUT.PUT('[INFO] PK '||V_TABLA||' (UE_ID): CREADA...');
	EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA_M||'.'||V_TABLA||' ADD (
	  CONSTRAINT PK_'||V_TABLA||' PRIMARY KEY (UE_ID))';
	  DBMS_OUTPUT.PUT_LINE('OK');
	  
	  
	  -- ********** USU_ENTIDADES - FKs
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '||V_TABLA||' and owner = '''||V_ESQUEMA_M||''' and CONSTRAINT_NAME = ''FK_ENT_USU_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.'||V_TABLA||' ... FK ya existe');
    ELSE
	    V_MSQL := 'ALTER TABLE '||V_ESQUEMA_M||'.'||V_TABLA||'  ADD (CONSTRAINT FK_ENT_USU_ID FOREIGN KEY (USU_ID)
				 REFERENCES ' || V_ESQUEMA_M || '.USU_USUARIOS (USU_ID))';
			
		EXECUTE IMMEDIATE V_MSQL;     
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA_M || '.'||V_TABLA||' ... FK Creada');
	END IF;
	
	
	V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '||V_TABLA||' and owner = '''||V_ESQUEMA_M||''' and CONSTRAINT_NAME = ''FK_ENT_ENT_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.'||V_TABLA||' ... FK ya existe');
    ELSE
	    V_MSQL := 'ALTER TABLE '||V_ESQUEMA_M||'.'||V_TABLA||'  ADD (CONSTRAINT FK_ENT_ENT_ID FOREIGN KEY (ENTIDAD_ID)
				 REFERENCES ' || V_ESQUEMA_M || '.ENTIDAD (ID))';
			
		EXECUTE IMMEDIATE V_MSQL;     
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA_M || '.'||V_TABLA||' ... FK Creada');
	END IF;
	  
	
COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT	