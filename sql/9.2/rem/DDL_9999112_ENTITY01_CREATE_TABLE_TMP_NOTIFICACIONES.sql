--/*
--##########################################
--## AUTOR=JOSE MANUEL PÉREZ BARBERÁ
--## FECHA_CREACION=20161228
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2.14
--## INCIDENCIA_LINK=RECOVERY-4197
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla TMP_NOTIFICACIONES
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

    -- ******** TMP_NOTIFICACIONES *******
    DBMS_OUTPUT.PUT_LINE('******** TMP_NOTIFICACIONES ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_NOTIFICACIONES... Comprobaciones previas'); 
    
    -- Creacion Tabla TMP_NOTIFICACIONES
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_NOTIFICACIONES'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_NOTIFICACIONES... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.TMP_NOTIFICACIONES
               (TAR_ID NUMBER(16,0) NOT NULL ENABLE
				,REG_ID NUMBER(16,0) NOT NULL ENABLE
				,MNO_ID NUMBER (16,0) NOT NULL ENABLE
			)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TMP_NOTIFICACIONES... Tabla creada');
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
