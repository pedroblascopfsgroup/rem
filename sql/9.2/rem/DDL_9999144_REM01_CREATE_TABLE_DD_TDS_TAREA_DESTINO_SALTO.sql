--/*
--##########################################
--## AUTOR=ISIDRO SOTOCA
--## FECHA_CREACION=20180312
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3893
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla DD_TDS_TAREA_DESTINO_SALTO
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
    DBMS_OUTPUT.PUT_LINE('******** DD_TDS_TAREA_DESTINO_SALTO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TDS_TAREA_DESTINO_SALTO... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_TDS_TAREA_DESTINO_SALTO
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_TDS_TAREA_DESTINO_SALTO'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TDS_TAREA_DESTINO_SALTO... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.DD_TDS_TAREA_DESTINO_SALTO
               (DD_TDS_ID NUMBER (16,0) NOT NULL ENABLE
				  , DD_TDS_CODIGO VARCHAR2(100 CHAR) NOT NULL ENABLE
				  , DD_TDS_DESCRIPCION VARCHAR2(200 CHAR) NOT NULL ENABLE
				  , DD_TDS_DESCRIPCION_LARGA VARCHAR2(4000 CHAR) NOT NULL ENABLE
				  , VERSION NUMBER(1,0) DEFAULT 0
				  , USUARIOCREAR VARCHAR2 (50 CHAR) NOT NULL ENABLE
				  , FECHACREAR TIMESTAMP(6) DEFAULT SYSTIMESTAMP
				  , USUARIOMODIFICAR VARCHAR2 (50 CHAR) 
				  , FECHAMODIFICAR TIMESTAMP(6)
				  , USUARIOBORRAR VARCHAR2 (50 CHAR)
				  , FECHABORRAR TIMESTAMP(6)
				  , BORRADO NUMBER(1,0) DEFAULT 0
				  , CONSTRAINT PK_DD_TDS_ID PRIMARY KEY(DD_TDS_ID)
			  )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TDS_TAREA_DESTINO_SALTO... Tabla creada');
		
  	    execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_TDS_TAREA_DESTINO_SALTO  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_TDS_TAREA_DESTINO_SALTO... Secuencia creada correctamente.');
		
		execute immediate 'grant select, insert, delete, update, REFERENCES(DD_TDS_ID) on ' || V_ESQUEMA || '.DD_TDS_TAREA_DESTINO_SALTO to '||V_ESQUEMA_M||'';
		
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
