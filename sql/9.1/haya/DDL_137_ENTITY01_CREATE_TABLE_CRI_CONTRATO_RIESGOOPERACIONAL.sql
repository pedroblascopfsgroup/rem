--/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=19-11-2015
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-463
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla CRI_CONTRATO_RIESGOOPERACIONAL
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

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage

    BEGIN

    -- ******** CRI_CONTRATO_RIESGOOPERACIONAL *******
    DBMS_OUTPUT.PUT_LINE('******** CRI_CONTRATO_RIESGOOPERACIONAL ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.CRI_CONTRATO_RIESGOOPERACIONAL... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_PCO_LIQ_ESTADO
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''CRI_CONTRATO_RIESGOOPERACIONAL'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.CRI_CONTRATO_RIESGOOPERACIONAL... Tabla YA EXISTE');
    ELSE
		--Creamos la tabla
		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.CRI_CONTRATO_RIESGOOPERACIONAL (' ||
						'CRI_ID NUMBER(16, 0) NOT NULL PRIMARY KEY '|| 
						', CNT_ID NUMBER(16, 0) NOT NULL' || 
						', DD_RIO_ID NUMBER(16, 0) NOT NULL'|| 
						', VERSION NUMBER(*, 0) DEFAULT 0 NOT NULL'|| 
						', USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL'|| 
						', FECHACREAR TIMESTAMP(6) NOT NULL'|| 
						', USUARIOMODIFICAR VARCHAR2(50 CHAR)'|| 
						', FECHAMODIFICAR TIMESTAMP(6)'|| 
						', USUARIOBORRAR VARCHAR2(50 CHAR)'|| 
						', FECHABORRAR TIMESTAMP(6)'|| 
						', BORRADO NUMBER(1, 0) DEFAULT 0 NOT NULL'||
						')';
		EXECUTE IMMEDIATE V_MSQL;


		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.CRI_CONTRATO_RIESGOOPERACIONAL ADD CONSTRAINT CRI_CNT_FK FOREIGN KEY (CNT_ID) REFERENCES '||V_ESQUEMA||'.CNT_CONTRATOS (CNT_ID) ENABLE';
		EXECUTE IMMEDIATE V_MSQL;

		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.CRI_CONTRATO_RIESGOOPERACIONAL ADD CONSTRAINT CRI_DD_RIO_FK FOREIGN KEY (DD_RIO_ID) REFERENCES '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL (DD_RIO_ID) ENABLE';
		EXECUTE IMMEDIATE V_MSQL;
               
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CRI_CONTRATO_RIESGOOPERACIONAL... Tabla creada');
	
	  	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_CRI_CONTRATO_RIESOPERACIONAL'' AND SEQUENCE_OWNER = '''||V_ESQUEMA||''' ';
  		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  		IF V_NUM_TABLAS = 0 THEN
  	    	execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_CRI_CONTRATO_RIESOPERACIONAL  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_CRI_CONTRATO_RIESOPERACIONAL... Secuencia creada correctamente.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] La secuencia '|| V_ESQUEMA || '.S_CRI_CONTRATO_RIESOPERACIONAL... ya existe.');
		END IF;
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
