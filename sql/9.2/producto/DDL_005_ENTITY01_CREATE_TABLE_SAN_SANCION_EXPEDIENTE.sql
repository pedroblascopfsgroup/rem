--/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO
--## FECHA_CREACION=20160222
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-798
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla SAE_SANCION_EXPEDIENTE
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
    DBMS_OUTPUT.PUT_LINE('******** SAE_SANCION_EXPEDIENTE ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.SAE_SANCION_EXPEDIENTE... Comprobaciones previas'); 
    
    -- Creacion Tabla SAE_SANCION_EXPEDIENTE
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''SAE_SANCION_EXPEDIENTE'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.SAE_SANCION_EXPEDIENTE... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.SAE_SANCION_EXPEDIENTE
               (SAE_ID                	 NUMBER(16,0) NOT NULL PRIMARY KEY,
			    DD_DES_ID            	 NUMBER(16,0) NOT NULL,
			    SAE_OBSERVACION 		 VARCHAR2(100 BYTE),
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
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.SAE_SANCION_EXPEDIENTE... Tabla creada');
		
		V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.SAE_SANCION_EXPEDIENTE ADD CONSTRAINT FK1_DD_DES_ID_DECISION_SANCION FOREIGN KEY (DD_DES_ID) ' ||
		'  REFERENCES  ' || V_ESQUEMA || '.DD_DES_DECISION_SANCION (DD_DES_ID)';
  		EXECUTE IMMEDIATE V_MSQL;
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.FK1_DD_DES_ID_DECISION_SANCION... FK1 creada');
		
  	    execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_SAE_SANCION_EXPEDIENTE  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_SAE_SANCION_EXPEDIENTE... Secuencia creada correctamente.');
		
    END IF;
    
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
