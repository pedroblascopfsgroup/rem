--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20160311
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

DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    COL_MATRICULA NUMBER := 0;
    
BEGIN
	
	-- ******** DD_TPD_TIPO_DOCUMENTO *******
    DBMS_OUTPUT.PUT_LINE('******** DD_TPD_TIPO_DOCUMENTO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO... Comprobaciones previas'); 
	
	-- Comprobamos si existe la tabla   
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_TPD_TIPO_DOCUMENTO'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO CUENTA;
    
    -- Comprobamos si existe columna en la tabla  
    IF CUENTA = 1 THEN
        V_MSQL := 'SELECT COUNT(*) FROM user_tab_cols WHERE column_name = ''DD_TPD_MATRICULA_GD'' AND TABLE_NAME = ''DD_TPD_TIPO_DOCUMENTO'' ';
        EXECUTE IMMEDIATE V_MSQL INTO COL_MATRICULA;
    END IF;

    -- Si no existe añadimos la columna y campos provisionales columna
    IF COL_MATRICULA = 0 THEN 
	    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.DD_TPD_TIPO_DOCUMENTO ADD DD_TPD_MATRICULA_GD VARCHAR2(20 CHAR)';
		EXECUTE IMMEDIATE V_MSQL;              
        DBMS_OUTPUT.PUT_LINE('[INFO] ANYADIDA COLUMNA A ' || V_ESQUEMA_M || '.DD_TPD_TIPO_DOCUMENTO... OK');
    END IF;
    
END;
/

EXIT;
