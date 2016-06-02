--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160316
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-1316
--## PRODUCTO=NO
--##
--## Finalidad: DDL borra y crea indice para BANKIA sobre DD_IMV_IMPOSICION_VENTA
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN

    -- ******** DD_IMV_IMPOSICION_VENTA *******
    DBMS_OUTPUT.PUT_LINE('******** DD_IMV_IMPOSICION_VENTA ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_IMV_IMPOSICION_VENTA... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_IMV_IMPOSICION_VENTA
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE TABLE_NAME = ''DD_IMV_IMPOSICION_VENTA'' and index_name = ''IDX_DD_IMV_IMPOSICION_VENTA'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_IMV_IMPOSICION_VENTA... Tabla NO existe');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'DROP INDEX '||V_ESQUEMA_M||'.IDX_DD_IMV_IMPOSICION_VENTA ';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_IMV_IMPOSICION_VENTA... INDICE IDX_DD_IMV_IMPOSICION_VENTA BORRADO');
		
		V_MSQL := 'CREATE INDEX ' || V_ESQUEMA_M || '.IDX_DD_IMV_IMPOSICION_VENTA ON ' || V_ESQUEMA_M || '.DD_IMV_IMPOSICION_VENTA (DD_IMV_DESCRIPCION) TABLESPACE ' || V_ESQUEMA_M || ' ';
  		EXECUTE IMMEDIATE V_MSQL;
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_IMV_DESCRIPCION... Indice creado IDX_DD_IMV_IMPOSICION_VENTA con tablespace en master');
	
  		commit;
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