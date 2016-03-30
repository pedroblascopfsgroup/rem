--/*
--##########################################
--## AUTOR=Nacho Arcos
--## FECHA_CREACION=20150330
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-953
--## PRODUCTO=NO
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

	-- ******** DD_ACE_ADJ_CONCEPTO_ENTREGA *******
    DBMS_OUTPUT.PUT_LINE('******** DD_ACE_ADJ_CONCEPTO_ENTREGA ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA... Comprobaciones previas'); 
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_ACE_ADJ_CONCEPTO_ENTREGA'' and owner = '''||V_ESQUEMA||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla
    IF V_NUM_TABLAS < 1 THEN	
    
	    --Creamos la tabla y secuencias
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_ACE_ADJ_CONCEPTO_ENTREGA...');
	    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_ACE_ADJ_CONCEPTO_ENTREGA';
			EXECUTE IMMEDIATE V_MSQL; 
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_ACE_ADJ_CONCEPTO_ENTREGA... Secuencia creada');
	    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.DD_ACE_ADJ_CONCEPTO_ENTREGA
						(
						  DD_ACE_ID                 NUMBER(16)          NOT NULL,
						  DD_ACE_CODIGO             VARCHAR2(10 CHAR)   NOT NULL,
						  DD_ACE_DESCRIPCION        VARCHAR2(50 CHAR)   NOT NULL,
						  DD_ACE_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  NOT NULL,
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
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_ACE_ADJ_CONCEPTO_ENTREGA... Tabla creada');
	    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_DD_ACE_ADJ_CONCEPTO_ENTREGA ON ' || V_ESQUEMA || '.DD_ACE_ADJ_CONCEPTO_ENTREGA
						(DD_ACE_ID)  TABLESPACE ' || V_TS_INDEX;
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_DD_ACE_ADJ_CONCEPTO_ENTREGA... Indice creado');
	    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.DD_ACE_ADJ_CONCEPTO_ENTREGA ADD (
			  CONSTRAINT PK_DD_ACE_ADJ_CONCEPTO_ENTREGA PRIMARY KEY (DD_ACE_ID),
	         CONSTRAINT UK_DD_ACE_CODIGO UNIQUE (DD_ACE_CODIGO))';
			EXECUTE IMMEDIATE V_MSQL;              
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_DD_ACE_ADJ_CONCEPTO_ENTREGA... PK creada');
	    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DD_ACE_ADJ_CONCEPTO_ENTREGA... OK');
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