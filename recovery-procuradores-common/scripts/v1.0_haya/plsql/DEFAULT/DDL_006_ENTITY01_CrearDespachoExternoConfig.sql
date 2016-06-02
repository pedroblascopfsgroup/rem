--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150601
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Tabla que recoge la configuración de los despachos externos.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('******** DEC_DESPACHO_EXT_CONFIG ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DEC_DESPACHO_EXT_CONFIG... Comprobaciones previas');
	
	
		-- Si existe la tabla la borramos
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DEC_DESPACHO_EXT_CONFIG'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DEC_DESPACHO_EXT_CONFIG... Ya existe');
	ELSE
		-- Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.DEC_DESPACHO_EXT_CONFIG...');
		V_MSQL := 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_DEC_DESPACHO_EXT_CONFIG';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'S_DEC_DESPACHO_EXT_CONFIG... Secuencia creada');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.DEC_DESPACHO_EXT_CONFIG
		(
		  DEC_ID                 NUMBER,
		  DES_ID                 NUMBER,
		  DEC_CTG_TAREAS         NUMBER,
		  DEC_CTG_RESOLUCIONES   NUMBER,
		  DEC_DESPACHO_INTEGRAL  NUMBER(1)              DEFAULT 0,
		  VERSION                NUMBER                 DEFAULT 0                     NOT NULL,
		  USUARIOCREAR           VARCHAR2(10 CHAR)      NOT NULL,
		  FECHACREAR             TIMESTAMP(6)           NOT NULL,
		  USUARIOMODIFICAR       VARCHAR2(10 CHAR),
		  FECHAMODIFICAR         TIMESTAMP(6),
		  USUARIOBORRAR          VARCHAR2(10 CHAR),
		  FECHABORRAR            TIMESTAMP(6),
		  BORRADO                NUMBER(1)              DEFAULT 0                     NOT NULL
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		MONITORING
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DEC_DESPACHO_EXT_CONFIG... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.PK_DEC_DESPACHO_EXT_CONFIG ON '||V_ESQUEMA|| '.DEC_DESPACHO_EXT_CONFIG
					(DEC_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DEC_DESPACHO_EXT_CONFIG... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.UK_DEC_DESPACHO_EXT_CONFIG ON '||V_ESQUEMA|| '.DEC_DESPACHO_EXT_CONFIG
					(DES_ID)';
		EXECUTE IMMEDIATE V_MSQL;	
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DEC_DESPACHO_EXT_CONFIG ADD (
						CONSTRAINT PK_DEC_DESPACHO_EXT_CONFIG PRIMARY KEY (DEC_ID) USING INDEX
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.PK_DEC_DESPACHO_EXT_CONFIG... Creando PK');
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DEC_DESPACHO_EXT_CONFIG... OK');
	END IF;
	COMMIT;
	
EXCEPTION


	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;
END;
/

EXIT;