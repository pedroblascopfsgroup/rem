--/*
--##########################################
--## AUTOR=MANUEL_MEJIAS
--## FECHA_CREACION=20151029
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=BKREC-1325
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la secuencia BUR_FICHERO_DOC
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

    -- ******** DD_PCO_LIQ_TIPO *******
    DBMS_OUTPUT.PUT_LINE('******** S_BUR_FICHERO_DOC ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_BUR_FICHERO_DOC... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_PCO_LIQ_TIPO
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_BUR_FICHERO_DOC'' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la secuencia no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_BUR_FICHERO_DOC... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la secuencia
    	execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_BUR_FICHERO_DOC  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_BUR_FICHERO_DOC... Secuencia creada correctamente.');  	
  		
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
