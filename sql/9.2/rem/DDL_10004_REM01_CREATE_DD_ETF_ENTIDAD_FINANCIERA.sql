--/*
--##########################################
--## AUTOR=Mariam Lliso
--## FECHA_CREACION=20190325
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v2.9.0-rem
--## INCIDENCIA_LINK=HREOS-5925
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla DD_ETF_ENTIDAD_FINANCIERA
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

     V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_ETF_ENTIDAD_FINANCIERA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN

    DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
    
    -- Verificar si la tabla ya existe
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
    IF V_NUM_TABLAS = 1 THEN
    
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe.');
    
    ELSE 

    	 --Creamos la tabla
         DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
        V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                ( DD_ETF_ID NUMBER(16,0) NOT NULL ENABLE
				, DD_ETF_CODIGO VARCHAR2(20 CHAR) NOT NULL ENABLE
				, DD_ETF_DESCRIPCION VARCHAR2(100 CHAR) NOT NULL ENABLE
				, DD_ETF_DESCRIPCION_LARGA VARCHAR2(250 CHAR) NOT NULL ENABLE
				, VERSION NUMBER(1,0) DEFAULT 0
				, USUARIOCREAR VARCHAR2 (50 CHAR) NOT NULL ENABLE
				, FECHACREAR TIMESTAMP(6) DEFAULT SYSTIMESTAMP
				, USUARIOMODIFICAR VARCHAR2 (50 CHAR) 
				, FECHAMODIFICAR TIMESTAMP(6)
				, USUARIOBORRAR VARCHAR2 (50 CHAR)
				, FECHABORRAR TIMESTAMP(6)
				, BORRADO NUMBER(1,0) DEFAULT 0
			  )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_ETF_ENTIDAD_FINANCIERA... Tabla creada');

        -- Creamos primary key
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (DD_ETF_ID))';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');

        -- Comprobamos si existe la secuencia
        V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and sequence_owner = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		
        IF V_NUM_TABLAS = 0 THEN

  	      EXECUTE IMMEDIATE 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');

        END IF;
		
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