--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20160107
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-1750
--## PRODUCTO=SI
--## 
--## Finalidad: Creación de tabla CMA_CAMBIOS_MASIVOS_ASUNTOS
--##
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
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
    
BEGIN

    -- ******** CMA_CAMBIOS_MASIVOS_ASUNTOS *******
    DBMS_OUTPUT.PUT_LINE('******** CMA_CAMBIOS_MASIVOS_ASUNTOS ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.CMA_CAMBIOS_MASIVOS_ASUNTOS... Comprobaciones previas'); 
    
    -- Creacion Tabla CMA_CAMBIOS_MASIVOS_ASUNTOS
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''CMA_CAMBIOS_MASIVOS_ASUNTOS'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.CMA_CAMBIOS_MASIVOS_ASUNTOS... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.CMA_CAMBIOS_MASIVOS_ASUNTOS
               (CMA_ID NUMBER(16) NOT NULL
			    ,SOL_ID NUMBER(16) NOT NULL
			    ,ASU_ID NUMBER(16) NOT NULL
			    ,COD_TIPO_GESTOR VARCHAR2 (10 CHAR) NOT NULL
			    ,USD_ID_ORIGINAL NUMBER(16) NOT NULL
			    ,USD_ID_NUEVO NUMBER(16) NOT NULL
			    ,FECHA_INICIO TIMESTAMP NOT NULL
			    ,FECHA_FIN TIMESTAMP
			    ,REASIGNADO NUMBER(1) DEFAULT 0 NOT NULL
			    ,VERSION                        INTEGER        DEFAULT 0                     NOT NULL
			    ,USUARIOCREAR                   VARCHAR2(10 CHAR) NOT NULL
			    ,FECHACREAR                     TIMESTAMP(6)   NOT NULL
			    ,USUARIOMODIFICAR               VARCHAR2(10 CHAR)
			    ,FECHAMODIFICAR                 TIMESTAMP(6)
			    ,USUARIOBORRAR                  VARCHAR2(10 CHAR)
			    ,FECHABORRAR                    TIMESTAMP(6)
			    ,BORRADO                        NUMBER(1)      DEFAULT 0
			   ,CONSTRAINT PK_CMA_CAMBIOS_MASIVOS_ASU PRIMARY KEY (CMA_ID)
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CMA_CAMBIOS_MASIVOS_ASUNTOS... Tabla creada');
		
  	    execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_CMA_CAMBIOS_MASIVOS_ASUNTOS  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_CMA_CAMBIOS_MASIVOS_ASUNTOS... Secuencia creada correctamente.');		
    END IF;


    DBMS_OUTPUT.PUT_LINE('******** INSERCION NUEVO CAMPO CMA_ID EN TABLA MEJ_REG_REGISTRO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MEJ_REG_REGISTRO... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME=''CMA_ID'' AND TABLE_NAME=''MEJ_REG_REGISTRO'' AND OWNER = ''' || V_ESQUEMA || '''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe los valores
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la columna CMA_ID en la tabla '||V_ESQUEMA||'.MEJ_REG_REGISTRO...no se modifica nada.');
	ELSE
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.MEJ_REG_REGISTRO ADD CMA_ID NUMBER(16,0)'; 
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_ESQUEMA||'.MEJ_REG_REGISTRO actualizada correctamente.');
    END IF;	
    
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');
    
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