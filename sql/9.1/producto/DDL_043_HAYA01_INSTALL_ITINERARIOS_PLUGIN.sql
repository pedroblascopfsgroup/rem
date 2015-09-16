--/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=20150908
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-224
--## PRODUCTO=SI
--## Finalidad: DDL Para ejecutar los requisitos de instalación del plugin de itinerarios
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
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage
    
    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'VTAR_TAREA_VS_USUARIO';

BEGIN
	-- #################################################### Secuencias ##############################################################
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''ITINERARIO_SEQ''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
		EXECUTE IMMEDIATE 'CREATE SEQUENCE '||V_ESQUEMA||'.ITINERARIO_SEQ START WITH 1';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ITINERARIO_SEQ creado OK');
	ELSE 
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ITINERARIO_SEQ ya existe');
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_TEL_ESTADO_TELECOBRO''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
		EXECUTE IMMEDIATE 'CREATE SEQUENCE '||V_ESQUEMA||'.S_TEL_ESTADO_TELECOBRO START WITH 1 
			MAXVALUE 999999999999999999999999999
  			MINVALUE 1
  			NOCYCLE
  			CACHE 100
  			NOORDER';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_TEL_ESTADO_TELECOBRO creado OK');
	ELSE 
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_TEL_ESTADO_TELECOBRO ya existe');
	END IF;
	
	-- #################################################### Drop index ##############################################################
    -- Comprobamos si existe la restriccion
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''UK_REE_REGLAS_ELEVACION_ESTADO'' AND OWNER='''||V_ESQUEMA||'''';  
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
         
    if V_NUM_TABLAS > 0 then          
          V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.REE_REGLAS_ELEVACION_ESTADO DISABLE CONSTRAINT UK_REE_REGLAS_ELEVACION_ESTADO';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] Restriccion UK_REE_REGLAS_ELEVACION_ESTADO deshabilitada OK');
    ELSE
    	DBMS_OUTPUT.PUT_LINE('[INFO] Restriccion UK_REE_REGLAS_ELEVACION_ESTADO NO ENCONTRADA');
    END IF;
    
    -- Borrado del índice con el mismo nombre
    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME=''REE_REGLAS_ELEVACION_ESTADO'' AND INDEX_NAME=''UK_REE_REGLAS_ELEVACION_ESTADO''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS > 0 THEN
    	V_MSQL := 'DROP INDEX '||V_ESQUEMA||'.UK_REE_REGLAS_ELEVACION_ESTADO';
    	EXECUTE IMMEDIATE V_MSQL;
    	DBMS_OUTPUT.PUT_LINE('[INFO] Indice UK_REE_REGLAS_ELEVACION_ESTADO borrada');
    ELSE
    	DBMS_OUTPUT.PUT_LINE('[INFO] Indice UK_REE_REGLAS_ELEVACION_ESTADO NO ENCONTRADO');
    END IF;	
    
    -- Comprobamos si existe la restriccion
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''UK_RVP_REGLAS_VIGENCIA_POL'' AND OWNER='''||V_ESQUEMA||'''';  
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
         
    if V_NUM_TABLAS > 0 then          
          V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.RVP_REGLAS_VIGENCIA_POLITICA DISABLE CONSTRAINT UK_RVP_REGLAS_VIGENCIA_POL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] Restriccion UK_RVP_REGLAS_VIGENCIA_POL deshabilitada OK');
    ELSE
    	DBMS_OUTPUT.PUT_LINE('[INFO] Restriccion UK_RVP_REGLAS_VIGENCIA_POL NO ENCONTRADA');
    END IF;
    
    -- Borrado del índice con el mismo nombre
    V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME=''RVP_REGLAS_VIGENCIA_POLITICA'' AND INDEX_NAME=''UK_RVP_REGLAS_VIGENCIA_POL''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS > 0 THEN
    	V_MSQL := 'DROP INDEX '||V_ESQUEMA||'.UK_RVP_REGLAS_VIGENCIA_POL';
    	EXECUTE IMMEDIATE V_MSQL;
    	DBMS_OUTPUT.PUT_LINE('[INFO] Indice UK_RVP_REGLAS_VIGENCIA_POL borrada');
    ELSE
    	DBMS_OUTPUT.PUT_LINE('[INFO] Indice UK_RVP_REGLAS_VIGENCIA_POL NO ENCONTRADO');
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
