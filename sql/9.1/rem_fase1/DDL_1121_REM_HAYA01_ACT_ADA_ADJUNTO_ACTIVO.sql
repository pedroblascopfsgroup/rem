--/*
--##########################################
--## AUTOR=CARLOS PONS
--## FECHA_CREACION=20160317
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: DDL
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    COL_DOC_REST NUMBER := 0;
    
BEGIN
	
	-- ******** ACT_ADA_ADJUNTO_ACTIVO *******
    DBMS_OUTPUT.PUT_LINE('******** ACT_ADA_ADJUNTO_ACTIVO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO... Comprobaciones previas'); 
	
	-- Comprobamos si existe la tabla   
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ACT_ADA_ADJUNTO_ACTIVO'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO CUENTA;
    
    -- Comprobamos si existe columna en la tabla  
    IF CUENTA = 1 THEN
        V_MSQL := 'SELECT COUNT(*) FROM user_tab_cols WHERE column_name = ''ADA_ID_DOCUMENTO_REST'' AND TABLE_NAME = ''ACT_ADA_ADJUNTO_ACTIVO'' ';
        EXECUTE IMMEDIATE V_MSQL INTO COL_DOC_REST;
    END IF;

    -- Si no existe añadimos la columna
    IF COL_DOC_REST = 0 THEN 
		V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.ACT_ADA_ADJUNTO_ACTIVO ADD ADA_ID_DOCUMENTO_REST NUMBER(16,0)';
		EXECUTE IMMEDIATE V_MSQL;              
        DBMS_OUTPUT.PUT_LINE('[INFO] ANYADIDA COLUMNA A ' || V_ESQUEMA || '.ACT_ADA_ADJUNTO_ACTIVO... OK');
    END IF;
    
END;
/

EXIT;
