--/*
--##########################################
--## AUTOR=Angel Pastelero
--## FECHA_CREACION=20180910
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-4472
--## PRODUCTO=NO
--## 
--## Finalidad: DDL
--## INSTRUCCIONES: Crear tabla HDC_HIST_DESTINO_COMERCIAL, donde poder guardar un historico del destino comercial de los activos
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
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquemas  
    V_ESQUEMA_DS VARCHAR2(25 CHAR):= '#ESQUEMA_DATASTAGE#'; -- Configuracion Esquemas 
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TABLA VARCHAR2(32 CHAR) := 'HDC_HIST_DESTINO_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    BEGIN

    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla la borramos
    IF V_NUM_TABLAS = 1 THEN 
	-- Borramos la tabla
    	 V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' CASCADE CONSTRAINTS';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla eliminada');  		
    END IF;
	
    --Creamos la tabla
    V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'(
		  HDC_ID                    NUMBER(16)			PRIMARY KEY,
		  ACT_ID                    NUMBER(16)			NOT NULL,
		  DD_TCO_ID                 NUMBER(16)			NOT NULL,
		  HDC_FECHA_INICIO          TIMESTAMP(6)		NOT NULL,
  		  HDC_FECHA_FIN             TIMESTAMP(6),
		  HDC_GESTOR_ACTUALIZACION  VARCHAR2(50 CHAR)		NOT NULL,
		  VERSION		    NUMBER(38,0) 		DEFAULT 0	NOT NULL,
		  USUARIOCREAR	       	    VARCHAR2(50 CHAR)		NOT NULL,
		  FECHACREAR                TIMESTAMP(6)		NOT NULL,
   		  USUARIOMODIFICAR	    VARCHAR2(50 CHAR),
 		  FECHAMODIFICAR	    TIMESTAMP(6),
		  USUARIOBORRAR		    VARCHAR2(50 CHAR),
		  FECHABORRAR		    TIMESTAMP(6),
		  BORRADO		    NUMBER(1,0)			DEFAULT 0	NOT NULL,
		  CONSTRAINT FK_HDC_ACT_ID FOREIGN KEY (ACT_ID) REFERENCES ACT_ACTIVO (ACT_ID),
		  CONSTRAINT FK_HDC_DD_TCO_ID FOREIGN KEY (DD_TCO_ID) REFERENCES DD_TCO_TIPO_COMERCIALIZACION (DD_TCO_ID)
    )'; 
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');

	-- Comprobamos si existe la secuencia
    V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and sequence_owner = '''||V_ESQUEMA||'''';
      
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
    IF V_NUM_TABLAS = 0 THEN

        DBMS_OUTPUT.PUT_LINE ( '[INFO] ' || V_ESQUEMA || '.S_'||V_TABLA||'... Secuencia no existe');

	--Creamos la secuencia
    V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||' START WITH 1'; 
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE ( '[INFO] ' || V_ESQUEMA || '.S_'||V_TABLA||'... Secuencia creada');

    ELSE
        DBMS_OUTPUT.PUT_LINE ( '[INFO] ' || V_ESQUEMA || '.S_'||V_TABLA||'... Secuencia ya existe');
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
