--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16116
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla DD_LES_LISTADO_ERRORES_SAP.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-13884] - PIER GOTTA
--##        0.2 Ampliar campo DD_LES_CODIGO a 32 BYTE - [HREOS-16116] - Alejandra García
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'DD_LES_LISTADO_ERRORES_SAP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-16116';
    
    
 BEGIN
 
 	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	
	IF V_COUNT = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' CASCADE CONSTRAINTS';
		
	END IF;
 
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';	 
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT; 
 
	IF V_COUNT = 0 THEN	 
		V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
		EXECUTE IMMEDIATE V_SQL;        
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la SECUENCIA S_'||V_TABLA);
	ELSE    
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la secuencia S_'||V_TABLA);		  
	END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
	IF V_COUNT = 0 THEN 
		V_SQL := 'CREATE TABLE ' || V_ESQUEMA || '.'||V_TABLA||'
                    (
                      DD_LES_ID         		NUMBER(16)          NOT NULL,
                      DD_LES_CODIGO            	VARCHAR2(32 BYTE)   NOT NULL,
                      DD_RETORNO_SAPBC        	VARCHAR2(50 CHAR)   NOT NULL,
                      DD_TEXT_MENSAJE_SAP	  	VARCHAR2(300 CHAR)  NOT NULL,
                      DD_EGA_ID			NUMBER(16),
                      DD_EAH_ID			NUMBER(16),
                      DD_EAP_ID			NUMBER(16),
                      VERSION                   	INTEGER             DEFAULT 0                     NOT NULL,
                      USUARIOCREAR             	VARCHAR2(50 CHAR)   NOT NULL,
                      FECHACREAR                	TIMESTAMP(6)        NOT NULL,
                      USUARIOMODIFICAR          	VARCHAR2(50 CHAR),
                      FECHAMODIFICAR            	TIMESTAMP(6),
                      USUARIOBORRAR             	VARCHAR2(50 CHAR),
                      FECHABORRAR               	TIMESTAMP(6),
                      BORRADO                   	NUMBER(1)           DEFAULT 0                     NOT NULL
                    )';
    EXECUTE IMMEDIATE V_SQL;
    
    	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT DD_LES_LISTADO_ERRORES_SAP_PK PRIMARY KEY (DD_LES_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_LES_LISTADO_ERRORES_SAP_PK... PK creada.');
    
    	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT FK_DD_EGA_ID FOREIGN KEY (DD_EGA_ID) REFERENCES '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO (DD_EGA_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_DD_EGA_ID... Foreign key creada.');
	
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT FK_EAH FOREIGN KEY (DD_EAH_ID) REFERENCES '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA (DD_EAH_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_DD_EAH_ID... Foreign key creada.');
	
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT FK_DD_EAP_ID FOREIGN KEY (DD_EAP_ID) REFERENCES '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP (DD_EAP_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_DD_EAP_ID... Foreign key creada.');

        
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la tabla '||V_TABLA);
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la tabla '||V_TABLA);		
	END IF;

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
