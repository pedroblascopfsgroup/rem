--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20160211	
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.2.0-hy-rc01
--## INCIDENCIA_LINK=HR-1920
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la restricción en la tabla BIE_ADJ_ADJUDICACION 
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

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#';
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    BEGIN

    -- ******** BIE_ADJ_ADJUDICACION *******
    DBMS_OUTPUT.PUT_LINE('******** BIE_ADJ_ADJUDICACION ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   						   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''BIE_ADJ_ADJUDICACION'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si no existe la tabla no hacemos nada
    IF V_NUM_TABLAS < 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION... Tabla NO EXISTE');    
    ELSE
    	-- Eliminamos índice antiguo
    	V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''IDX_BIE_ADJ_BIEN'' AND TABLE_NAME= ''BIE_ADJ_ADJUDICACION'' AND TABLE_OWNER='''|| V_ESQUEMA ||'''';
    	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    	IF V_NUM_TABLAS > 0 THEN
    		EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.IDX_BIE_ADJ_BIEN';
  	 	END IF;	
    	-- Creamos índice nuevo
    	V_SQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.IDX_BIE_ADJ_BIEN ON '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION (BIE_ID)  TABLESPACE ' || V_TS_INDEX;
    	EXECUTE IMMEDIATE V_SQL;
  		
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... Indice creado');  	
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