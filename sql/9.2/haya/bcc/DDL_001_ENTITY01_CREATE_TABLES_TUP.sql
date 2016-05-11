--/*
--##########################################
--## AUTOR=Óscar
--## FECHA_CREACION=20160511
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.4
--## INCIDENCIA_LINK=PRODUCTO-1313
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas TUP
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

    DBMS_OUTPUT.PUT_LINE('******** TUP_ETP_ESQ_TURNADO_PROCU ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TUP_ETP_ESQ_TURNADO_PROCU... Comprobaciones previas'); 
    
    -- Creacion Tabla TUP_ETP_ESQUEMA_TURNADO_PROCU
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TUP_ETP_ESQ_TURNADO_PROCU'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TUP_ETP_ESQ_TURNADO_PROCU... Tabla YA EXISTE y va a ser borrada');    
            EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.TUP_ETP_ESQ_TURNADO_PROCU';    
  	 ELSE
        execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_TUP_ETP_ESQ_TURNADO_PROCU  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_TUP_ETP_ESQ_TURNADO_PROCU... Secuencia creada correctamente.');		
         
     END IF;
  	   
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.TUP_ETP_ESQ_TURNADO_PROCU
               (ETP_ID NUMBER(16) NOT NULL
				,ETP_CODIGO VARCHAR2(10 CHAR)
			    ,ETP_DESCRIPCION NUMBER(16) NOT NULL
			    ,ETP_DESCRIPCION_LARGA NUMBER(16) NOT NULL
			    ,VERSION                        INTEGER        DEFAULT 0                     NOT NULL
			    ,USUARIOCREAR                   VARCHAR2(50 CHAR) NOT NULL
			    ,FECHACREAR                     TIMESTAMP(6)   NOT NULL
			    ,USUARIOMODIFICAR               VARCHAR2(50 CHAR)
			    ,FECHAMODIFICAR                 TIMESTAMP(6)
			    ,USUARIOBORRAR                  VARCHAR2(50 CHAR)
			    ,FECHABORRAR                    TIMESTAMP(6)
			    ,BORRADO                        NUMBER(1)      DEFAULT 0
			   ,CONSTRAINT PK_TUP_ETP PRIMARY KEY (ETP_ID)
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TUP_ETP_ESQ_TURNADO_PROCU... Tabla creada');
	

   DBMS_OUTPUT.PUT_LINE('******** TUP_EPT_ESQUEMA_PLAZAS_TPO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TUP_EPT_ESQUEMA_PLAZAS_TPO... Comprobaciones previas'); 
    
    -- Creacion Tabla TUP_ETP_ESQUEMA_TURNADO_PROCU
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TUP_EPT_ESQUEMA_PLAZAS_TPO'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TUP_EPT_ESQUEMA_PLAZAS_TPO... Tabla YA EXISTE y va a ser borrada'); 
            EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.TUP_EPT_ESQUEMA_PLAZAS_TPO'; 
    ELSE  
    
     execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_TUP_EPT_ESQUEMA_PLAZAS_TPO  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_TUP_EPT_ESQUEMA_PLAZAS_TPO... Secuencia creada correctamente.');		
    END IF;
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.TUP_EPT_ESQUEMA_PLAZAS_TPO
               (EPT_ID NUMBER(16) NOT NULL
				,ETP_ID NUMBER(16) NOT NULL
			    ,DD_PLA_ID NUMBER(16) 
			    ,DD_TPO_ID NUMBER(16) 
			    ,DD_TGE_ID NUMBER(16) NOT NULL
			    ,EPT_GRUPO_ASIGNADO NUMBER(16) NOT NULL
			    ,VERSION                        INTEGER        DEFAULT 0                     NOT NULL
			    ,USUARIOCREAR                   VARCHAR2(50 CHAR) NOT NULL
			    ,FECHACREAR                     TIMESTAMP(6)   NOT NULL
			    ,USUARIOMODIFICAR               VARCHAR2(50 CHAR)
			    ,FECHAMODIFICAR                 TIMESTAMP(6)
			    ,USUARIOBORRAR                  VARCHAR2(50 CHAR)
			    ,FECHABORRAR                    TIMESTAMP(6)
			    ,BORRADO                        NUMBER(1)      DEFAULT 0
			   ,CONSTRAINT PK_EPT PRIMARY KEY (EPT_ID)
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TUP_EPT_ESQUEMA_PLAZAS_TPO... Tabla creada');
		
  	   

       DBMS_OUTPUT.PUT_LINE('******** TUP_TPC_TURNADO_PROCU_CONFIG ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TUP_TPC_TURNADO_PROCU_CONFIG... Comprobaciones previas'); 
    
    -- Creacion Tabla TUP_TPC_TURNADO_PROCU_CONFIG
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TUP_TPC_TURNADO_PROCU_CONFIG'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TUP_TPC_TURNADO_PROCU_CONFIG... Tabla YA EXISTE y va a ser borrada');   
    		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.TUP_TPC_TURNADO_PROCU_CONFIG'; 
    ELSE	  
    	execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_TUP_TPC_TURNADO_PROCU_CONFIG  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_TUP_TPC_TURNADO_PROCU_CONFIG... Secuencia creada correctamente.');		
    END IF; 
    
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.TUP_TPC_TURNADO_PROCU_CONFIG
               (TPC_ID NUMBER(16) NOT NULL
			    ,EPT_ID NUMBER(16) NOT NULL
			    ,TPC_IMPORTE_DESDE NUMBER(16) 
			    ,TPC_IMPORTE_HASTA NUMBER(16) 
			    ,TPC_PORCENTAJE NUMBER(5,2) 
			    ,VERSION                        INTEGER        DEFAULT 0                     NOT NULL
			    ,USUARIOCREAR                   VARCHAR2(50 CHAR) NOT NULL
			    ,FECHACREAR                     TIMESTAMP(6)   NOT NULL
			    ,USUARIOMODIFICAR               VARCHAR2(50 CHAR)
			    ,FECHAMODIFICAR                 TIMESTAMP(6)
			    ,USUARIOBORRAR                  VARCHAR2(50 CHAR)
			    ,FECHABORRAR                    TIMESTAMP(6)
			    ,BORRADO                        NUMBER(1)      DEFAULT 0
			   ,CONSTRAINT PK_TPC PRIMARY KEY (TPC_ID)
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TUP_TPC_TURNADO_PROCU_CONFIG... Tabla creada');
		
  

    
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