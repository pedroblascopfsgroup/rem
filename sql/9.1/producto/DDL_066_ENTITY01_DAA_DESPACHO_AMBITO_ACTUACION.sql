--/*
--##########################################
--## AUTOR=ALBERTO CAMPOS
--## FECHA_CREACION=20151013
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.12-bk
--## INCIDENCIA_LINK=PRODUCTO-109
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TABLA VARCHAR2(50 CHAR) := 'DAA_DESPACHO_AMBITO_ACTUACION';
    V_SECUENCIA VARCHAR2(30 CHAR) := 'S_DAA_DESPACHO_AMBITO_ACTUACIO';
    V_PRIMARY VARCHAR2(30 CHAR) := 'PK_DAA_DESPACHO_AMBITO_ACTUACI';

BEGIN

	--Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||'
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Claves primarias eliminadas');	
    END IF;
	
--##COMPROBACION EXISTENCIA SECUENCIA, BORRAR PRIMERO
V_NUM_SEQ := 0;
select count(1) INTO V_NUM_SEQ from all_sequences
where sequence_owner = V_ESQUEMA
and sequence_name = V_SECUENCIA;

if V_NUM_SEQ > 0 then 
--YA existe una versión de la secuencia , se elimina primero
  DBMS_OUTPUT.PUT('[INFO] Ya existe una versión de la secuencia '||V_SECUENCIA||': se ELIMINA...');
  EXECUTE IMMEDIATE 'drop sequence '||V_ESQUEMA||'.'||V_SECUENCIA||'';
  DBMS_OUTPUT.PUT_LINE('OK');
END IF;


--##COMPROBACION EXISTENCIA TABLA, BORRAR PRIMERO
V_NUM_TABLAS := 0;
select count(1) INTO V_NUM_TABLAS from all_tables 
where table_name = ''||V_TABLA||'' and OWNER = V_ESQUEMA;

if V_NUM_TABLAS > 0 then 
--YA existe una versión de la tabla , se elimina primero

  DBMS_OUTPUT.PUT('[INFO] Ya existe una versión de la tabla '||V_TABLA||': se ELIMINA...');
	EXECUTE IMMEDIATE 'drop table '||V_ESQUEMA||'.'||V_TABLA||'';
  DBMS_OUTPUT.PUT_LINE('OK');

END IF;


--##CREACION DE TABLA, SECUENCIA Y PK de tabla
  DBMS_OUTPUT.PUT('[INFO] Secuencia '||V_SECUENCIA||': CREADA...');
	EXECUTE IMMEDIATE 'CREATE SEQUENCE '||V_ESQUEMA||'.'||V_SECUENCIA||''; 
  DBMS_OUTPUT.PUT_LINE('OK');

  DBMS_OUTPUT.PUT('[INFO] Tabla '||V_TABLA||': CREADA...');	     	 
	EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
	(
		DAA_ID				        NUMBER(16)          NOT NULL,
		DES_ID	            		NUMBER(16)          NOT NULL,
		DD_PRV_ID 		    		NUMBER(16)          ,
		DD_CCA_ID 		    		NUMBER(16)          ,
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


	DBMS_OUTPUT.PUT('[INFO] PK DAA_DESPACHO_AMBITO_ACTUACI (DAA_ID): CREADA...');
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (
  			CONSTRAINT '||V_PRIMARY||' PRIMARY KEY(DAA_ID))';

  	DBMS_OUTPUT.PUT_LINE('OK');
  
  	V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TABLA||'  ADD (
			CONSTRAINT FK_DAA_DES FOREIGN KEY (DES_ID) 
				 REFERENCES ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO (DES_ID))';
			
	EXECUTE IMMEDIATE V_MSQL;     
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.FK_DAA_DES ... FK Creada');
  	
	V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TABLA||'  ADD (
			CONSTRAINT FK_DAA_PRV FOREIGN KEY (DD_PRV_ID) 
				 REFERENCES ' || V_ESQUEMA_M || '.DD_PRV_PROVINCIA (DD_PRV_ID))';
			
	EXECUTE IMMEDIATE V_MSQL;     
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.FK_DAA_PRV ... FK Creada');
  	
	V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TABLA||'  ADD (
			CONSTRAINT FK_DAA_CCA FOREIGN KEY (DD_CCA_ID) 
				 REFERENCES ' || V_ESQUEMA_M || '.DD_CCA_COMUNIDAD (DD_CCA_ID))';
			
	EXECUTE IMMEDIATE V_MSQL;     
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.FK_DAA_CCA ... FK Creada');
	
	V_MSQL := 'GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON '
                  || V_ESQUEMA ||' .'||V_TABLA||' TO ' || V_ESQUEMA_M || '';
		EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Permisos dados a ' || V_ESQUEMA_M || '');
    V_MSQL := 'GRANT SELECT ON '|| V_ESQUEMA ||' .'||V_SECUENCIA||' TO ' || V_ESQUEMA_M || '';
		EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_SECUENCIA||'... Permisos de Select dados a ' || V_ESQUEMA_M || '');
    
	DBMS_OUTPUT.PUT_LINE('[INFO] Proceso ejecutado CORRECTAMENTE. Tabla y referencias creadas.');	
	
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