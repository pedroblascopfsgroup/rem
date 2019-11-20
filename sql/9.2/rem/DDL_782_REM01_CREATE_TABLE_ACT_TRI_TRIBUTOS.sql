--/*
--##########################################
--## AUTOR=Ivan Serrano
--## FECHA_CREACION=20190708
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6633
--## PRODUCTO=NO
--##
--## Finalidad: DDL Creación de la tabla ACT_TRI_TRIBUTOS
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_TABLA VARCHAR2(150 CHAR):= 'ACT_TRI_TRIBUTOS'; -- Vble. con el nombre de la tabla.
    V_FK VARCHAR2(20 CHAR):= 'ACT_TRI_FK'; -- Vble. con el prefijo de las claves ajenas.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    -- ******** ACT_TRI_TRIBUTOS *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla ACT_TRI_TRIBUTOS
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
               (ACT_TRI_ID NUMBER (16,0) NOT NULL ENABLE
				  , ACT_ID NUMBER (16,0) NOT NULL ENABLE 
				  , ACT_TRI_FECHA_PRESENTACION_RECURSO DATE NOT NULL ENABLE 
				  , ACT_TRI_FECHA_RECEPCION_PROPIETARIO DATE NOT NULL ENABLE
				  , ACT_TRI_FECHA_RECEPCION_GESTORIA DATE NOT NULL ENABLE
				  , DD_TST_ID NUMBER (16,0) NOT NULL ENABLE
				  , OBSERVACIONES VARCHAR2 (1000 CHAR)
				  , ACT_TRI_FECHA_RECEPCION_RECURSO_PROPIETARIO DATE NOT NULL ENABLE
				  , ACT_TRI_FECHA_RECEPCION_RECURSO_GESTORIA DATE NOT NULL ENABLE
				  , ACT_TRI_FECHA_RESPUESTA_RECURSO DATE NOT NULL ENABLE
				  , DD_FAV_ID NUMBER (16,0) NOT NULL ENABLE
				  , GPV_ID NUMBER (16,0)
				  , VERSION NUMBER(1,0) DEFAULT 0
				  , USUARIOCREAR VARCHAR2 (50 CHAR) 
				  , FECHACREAR TIMESTAMP(6) DEFAULT SYSTIMESTAMP
				  , USUARIOMODIFICAR VARCHAR2 (50 CHAR) 
				  , FECHAMODIFICAR TIMESTAMP(6)
				  , USUARIOBORRAR VARCHAR2 (50 CHAR)
				  , FECHABORRAR TIMESTAMP(6)
				  , BORRADO NUMBER(1,0) DEFAULT 0
				  , CONSTRAINT PK_ACT_TRI_ID PRIMARY KEY(ACT_TRI_ID)
			  )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
		
		-- Creamos foreign key ACT_ID
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_FK||'_ACT_ID FOREIGN KEY (ACT_ID) REFERENCES '||V_ESQUEMA||'.ACT_ACTIVO (ACT_ID) ON DELETE SET NULL)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_FK||'_ACT_ID... Foreign key creada.');
		
		-- Creamos foreign key DD_TST_ID
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_FK||'_DD_TST_ID FOREIGN KEY (DD_TST_ID) REFERENCES '||V_ESQUEMA||'.DD_TST_TIPO_SOLICITUD_TRIB (DD_TST_ID) ON DELETE SET NULL)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_FK||'_DD_TST_ID... Foreign key creada.');
		
		-- Creamos foreign key DD_FAV_ID
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_FK||'_DD_FAV_ID FOREIGN KEY (DD_FAV_ID) REFERENCES '||V_ESQUEMA_M||'.DD_FAV_FAVORABLE (DD_FAV_ID) ON DELETE SET NULL)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_FK||'_DD_FAV_ID... Foreign key creada.');
		
		-- Creamos foreign key GPV_ID
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_FK||'_GPV_ID FOREIGN KEY (GPV_ID) REFERENCES '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR (GPV_ID) ON DELETE SET NULL)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_FK||'_GPV_ID... Foreign key creada.');
		
		-- Creamos la secuencia
  	    execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_'||V_TABLA||'  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_'||V_TABLA||'... Secuencia creada correctamente.');
		
		-- execute immediate 'grant select, insert, delete, update, REFERENCES(ACT_TRI_ID) on ' || V_ESQUEMA || '.'||V_TABLA||' to '||V_ESQUEMA||'';
		
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
