--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150601
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Tabla que recoge las relaciones de procurador y procedimiento.
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

	DBMS_OUTPUT.PUT_LINE('******** CTG_CATEGORIZACIONES ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.CTG_CATEGORIZACIONES... Comprobaciones previas');
	

	-- Si existe la tabla la borramos
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''CTG_CATEGORIZACIONES'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CTG_CATEGORIZACIONES... Ya existe');
	ELSE
		-- Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.CTG_CATEGORIZACIONES...');
		V_MSQL := 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_CTG_CATEGORIZACIONES';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.S_CTG_CATEGORIZACIONES... Secuencia creada');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.CTG_CATEGORIZACIONES
		(
		  CTG_ID               NUMBER	                NOT NULL,
		  CTG_DESP_EXT_ID      NUMBER,
		  CTG_NOMBRE           VARCHAR2(200)            NOT NULL,
		  VERSION              INTEGER                  DEFAULT 0                     NOT NULL,
		  USUARIOCREAR         VARCHAR2(10 CHAR)        NOT NULL,
		  FECHACREAR           TIMESTAMP(6)             NOT NULL,
		  USUARIOMODIFICAR     VARCHAR2(10 CHAR),
		  FECHAMODIFICAR       TIMESTAMP(6),
		  USUARIOBORRAR        VARCHAR2(10 CHAR),
		  FECHABORRAR          TIMESTAMP(6),
		  BORRADO              NUMBER(1)                DEFAULT 0                     NOT NULL,
		  CTG_CODIGO           VARCHAR2(50)            NOT NULL
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.CTG_CATEGORIZACIONES... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.PK_CTG_CATEGORIZACIONES ON '||V_ESQUEMA|| '.CTG_CATEGORIZACIONES
					(CTG_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.CTG_CATEGORIZACIONES ADD (
						CONSTRAINT PK_CTG_CATEGORIZACIONES PRIMARY KEY (CTG_ID) USING INDEX
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.PK_CTG_CATEGORIZACIONES... Creando PK');
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.CTG_CATEGORIZACIONES... OK');
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