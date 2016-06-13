--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160610
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1491
--## PRODUCTO=SI
--## Finalidad: DDL para generar una nueva tabla DD_OOF_ORIGEN_OFICINA.
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    BEGIN

    -- ******** DD_OOF_ORIGEN_OFICINA *******
    DBMS_OUTPUT.PUT_LINE('******** DD_OOF_ORIGEN_OFICINA ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_OOF_ORIGEN_OFICINA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA
               (DD_OOF_ID NUMBER(16, 0) NOT NULL
				, DD_OOF_CODIGO VARCHAR2(20 CHAR) NOT NULL 
				, DD_OOF_DESCRIPCION VARCHAR2(50 CHAR) 
				, DD_OOF_DESCRIPCION_LARGA VARCHAR2(250 CHAR) 
				, VERSION NUMBER(38, 0) DEFAULT 0 NOT NULL 
				, USUARIOCREAR VARCHAR2(50 BYTE) NOT NULL 
				, FECHACREAR DATE NOT NULL 
				, USUARIOMODIFICAR VARCHAR2(50 BYTE) 
				, FECHAMODIFICAR DATE 
				, USUARIOBORRAR VARCHAR2(50 BYTE) 
				, FECHABORRAR DATE 
				, BORRADO NUMBER(1, 0) DEFAULT 0 NOT NULL 
			  )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_OOF_ORIGEN_OFICINA... Tabla creada');
		
		-- Creamos sequencia.
  	    EXECUTE immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_OOF_ORIGEN_OFICINA  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_OOF_ORIGEN_OFICINA... Secuencia creada correctamente.');
		
		-- Creamos Indices.
		V_SQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.IDX1_DD_OOF_ORIGEN_OFICINA ON '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA (DD_OOF_ID)  TABLESPACE ' || V_TS_INDEX;
    	EXECUTE IMMEDIATE V_SQL;
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_OOF_ORIGEN_OFICINA... Indice creado');
		
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