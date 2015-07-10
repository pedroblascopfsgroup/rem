--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150601
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Tabla que recoge las categorias.
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_ENTIDAD#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('******** CAT_CATEGORIAS ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.CAT_CATEGORIAS... Comprobaciones previas');
	

	-- Si existe la tabla la borramos
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''CAT_CATEGORIAS'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CAT_CATEGORIAS... Ya existe');
	ELSE
		-- Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.CAT_CATEGORIAS...');
		V_MSQL := 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_CAT_CATEGORIAS';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'S_CAT_CATEGORIAS... Secuencia creada');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.CAT_CATEGORIAS
		(
		  CAT_ID            NUMBER                  	NOT NULL,
		  CTG_ID			NUMBER						NOT NULL,
		  CAT_NOMBRE        VARCHAR2(200 BYTE)          NOT NULL,
		  CAT_DESCRIPCION   VARCHAR2(500 BYTE),
		  CAT_ORDEN			NUMBER(3),
		  VERSION           INTEGER                     DEFAULT 0                     NOT NULL,
		  USUARIOCREAR      VARCHAR2(10 CHAR)           NOT NULL,
		  FECHACREAR        TIMESTAMP(6)                NOT NULL,
		  USUARIOMODIFICAR  VARCHAR2(10 CHAR),
		  FECHAMODIFICAR    TIMESTAMP(6),
		  USUARIOBORRAR     VARCHAR2(10 CHAR),
		  FECHABORRAR       TIMESTAMP(6),
		  BORRADO           NUMBER(1)                   DEFAULT 0                     NOT NULL
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.CAT_CATEGORIAS... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.PK_CAT_CATEGORIAS ON '||V_ESQUEMA|| '.CAT_CATEGORIAS
					(CAT_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.CAT_CATEGORIAS ADD (
						CONSTRAINT PK_CAT_CATEGORIAS PRIMARY KEY (CAT_ID) USING INDEX
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.PK_CAT_CATEGORIAS... Creando PK');
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.CAT_CATEGORIAS... OK');
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