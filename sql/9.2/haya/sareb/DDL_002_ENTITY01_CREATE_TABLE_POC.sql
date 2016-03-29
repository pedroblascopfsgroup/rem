--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20160322
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-861
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla DD_DES_DECISION_SANCION
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

    -- ******** DD_DES_DECISION_SANCION *******
    DBMS_OUTPUT.PUT_LINE('******** POC_PETICION_OPM_CARTERIZAR ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.POC_PETICION_OPM_CARTERIZAR... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_PCO_LIQ_ESTADO
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''POC_PETICION_OPM_CARTERIZAR'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.POC_PETICION_OPM_CARTERIZAR... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.POC_PETICION_OPM_CARTERIZAR
               (POC_ID                	 NUMBER(16,0) NOT NULL PRIMARY KEY,
			    POC_ACREDITADO_DOC_ID    VARCHAR2(20 CHAR) NOT NULL,
			    POC_GESTOR_USERNAME      VARCHAR2(50 CHAR) NOT NULL,
			    POC_PENDIENTE 			 NUMBER(1,0) DEFAULT 0,
				POC_RESULTADO			 NUMBER(1,0),
			    PRM_ID					 NUMBER(16,0) NOT NULL,
				POC_RESULTADO_DESCRIP	 VARCHAR2(2000 CHAR),
				VERSION                  NUMBER(*,0) DEFAULT 0 NOT NULL,
			    USUARIOCREAR             VARCHAR2(50 CHAR) NOT NULL,
			    FECHACREAR               DATE DEFAULT SYSDATE NOT NULL,
			    BORRADO                  NUMBER(*,0) DEFAULT 0 NOT NULL,
			    USUARIOMODIFICAR         VARCHAR2(50 CHAR),
			    FECHAMODIFICAR           DATE,
			    USUARIOBORRAR            VARCHAR2(50 CHAR),
			    FECHABORRAR              DATE
			  )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.POC_PETICION_OPM_CARTERIZAR... Tabla creada');
		
		V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.POC_PETICION_OPM_CARTERIZAR ADD CONSTRAINT FK1_PRM_ID_PROCESO_MASIVO FOREIGN KEY (PRM_ID) ' ||
		'  REFERENCES  ' || V_ESQUEMA || '.PRM_PROCESO_MASIVO (PRM_ID)';
  		EXECUTE IMMEDIATE V_MSQL;
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.FK1_PRM_ID_PROCESO_MASIVO... FK1 creada');
		
  	    execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_POC_PETICION_OPM_CARTERIZAR  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_POC_PETICION_OPM_CARTERIZAR... Secuencia creada correctamente.');
		
    END IF;
    
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
