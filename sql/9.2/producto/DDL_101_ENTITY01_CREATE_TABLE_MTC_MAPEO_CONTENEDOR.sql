--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160413
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1114
--## PRODUCTO=SI
--##
--## Finalidad: DDL Creación de la tabla MTC_MAPEO_TIPO_CONTENEDOR
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
    
BEGIN

    -- ******** MTC_MAPEO_TIPO_CONTENEDOR *******
    DBMS_OUTPUT.PUT_LINE('******** MTC_MAPEO_TIPO_CONTENEDOR ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MTC_MAPEO_TIPO_CONTENEDOR... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_IMV_IMPOSICION_VENTA
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MTC_MAPEO_TIPO_CONTENEDOR'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MTC_MAPEO_TIPO_CONTENEDOR... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MTC_MAPEO_TIPO_CONTENEDOR
               	(MTC_ID							NUMBER(16) 		 	NOT NULL ENABLE PRIMARY KEY
			   	,MTC_TDN2_CODIGO				VARCHAR2(20 CHAR)   NOT NULL ENABLE
				,DD_TFA_ID						NUMBER(16)			NOT NULL ENABLE
 				,VERSION 				  	  	INTEGER DEFAULT 0   NOT NULL
  			   	,USUARIOCREAR              	  	VARCHAR2(50 CHAR)   NOT NULL
  			   	,FECHACREAR                	  	TIMESTAMP(6)        NOT NULL
  			   	,USUARIOMODIFICAR          	  	VARCHAR2(50 CHAR)
  			   	,FECHAMODIFICAR            	  	TIMESTAMP(6)
  			   	,USUARIOBORRAR             	  	VARCHAR2(50 CHAR)
  			   	,FECHABORRAR               	  	TIMESTAMP(6)
  			   	,BORRADO                   	  	NUMBER(1)           DEFAULT 0  NOT NULL
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTC_MAPEO_TIPO_CONTENEDOR... Tabla creada');
		
		V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.MTC_MAPEO_TIPO_CONTENEDOR ADD CONSTRAINT FK1_MTC_DD_TFA_ID_DD_TFA FOREIGN KEY (DD_TFA_ID) ' ||
		'  REFERENCES  ' || V_ESQUEMA || '.DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID)';
  		EXECUTE IMMEDIATE V_MSQL;
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.FK1_DD_TFA_ID_DD_TFA... FK1 creada');
  		
  	    execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_MTC_MAPEO_TIPO_CONTENEDOR  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_MTC_MAPEO_TIPO_CONTENEDOR... Secuencia creada correctamente.');
		
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