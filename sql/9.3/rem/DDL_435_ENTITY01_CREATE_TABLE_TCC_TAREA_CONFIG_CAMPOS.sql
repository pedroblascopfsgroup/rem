--/*
--##########################################
--## AUTOR=JOSE LUIS BARBA
--## FECHA_CREACION=20190820
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-6461
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla TCC_TAREA_CONFIG_CAMPOS
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Viorel Remus Ovidiu - Modificacion tamaño campos
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TCC_TAREA_CONFIG_CAMPOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar


    BEGIN
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe.');
    ELSE
              -- Creamos la tabla
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
    		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
               (
                TCC_ID				  		    NUMBER(16) NOT NULL,
                TAP_ID                     	    NUMBER(16) NOT NULL,
                TFI_ID                          NUMBER(16,0) NOT NULL,
                TCC_INSTANCIA                   NUMBER,
                TCC_VALOR                       VARCHAR2(200 CHAR),
                TCC_ACCION                      VARCHAR2(200 CHAR),
			    USUARIOCREAR              		VARCHAR2(50 CHAR) NOT NULL,
			    FECHACREAR                		TIMESTAMP(6) NOT NULL,
			    USUARIOMODIFICAR          		VARCHAR2(50 CHAR),
			    FECHAMODIFICAR            		TIMESTAMP(6),
			    USUARIOBORRAR             		VARCHAR2(50 CHAR),
			    FECHABORRAR               		TIMESTAMP(6),
			    BORRADO                   		NUMBER(1) DEFAULT 0 NOT NULL,
			   CONSTRAINT PK_TCC_TAREA_CONFIG_CAMPOS PRIMARY KEY (TCC_ID),
		       CONSTRAINT FK_TCC_TAREA_TAP_ID FOREIGN KEY (TAP_ID) REFERENCES TAP_TAREA_PROCEDIMIENTO (TAP_ID),
               CONSTRAINT FK_TCC_TAREA_TFI_ID FOREIGN KEY (TFI_ID) REFERENCES TFI_TAREAS_FORM_ITEMS (TFI_ID)
               )';
    		EXECUTE IMMEDIATE V_MSQL;
    		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TCC_TAREA_CONFIG_CAMPOS... Tabla creada');
    		
    		EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_TCC_TAREA_CONFIG_CAMPOS  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_TCC_TAREA_CONFIG_CAMPOS... Secuencia creada correctamente.');
        COMMIT;
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
