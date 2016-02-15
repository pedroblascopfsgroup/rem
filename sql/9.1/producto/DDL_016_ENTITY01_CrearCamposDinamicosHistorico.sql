--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150622
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Tabla que recoge el histórico de la tabla de campos dinamicos (MSV_CAMPOS_DINAMICOS)
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

	DBMS_OUTPUT.PUT_LINE('******** MSV_CAMPOS_DINAMICOS_HISTORICO ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MSV_CAMPOS_DINAMICOS_HISTORICO... Comprobaciones previas');
	

	-- Si existe la tabla la borramos
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MSV_CAMPOS_DINAMICOS_HISTORICO'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MSV_CAMPOS_DINAMICOS_HISTORICO... Ya existe');
	ELSE
		-- Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.MSV_CAMPOS_DINAMICOS_HISTORICO...');
		V_MSQL := 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_MSV_CAMPOS_DINAMICOS_HISTORI';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'S_MSV_CAMPOS_DINAMICOS_HISTORI... Secuencia creada');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.MSV_CAMPOS_DINAMICOS_HISTORICO
		(
			CDH_ID            NUMBER,
			CDH_NOMBRE_CAMPO  VARCHAR2(50 BYTE),
			CDH_VALOR_CAMPO   VARCHAR2(1000 CHAR),
			CDH_RES_ID        NUMBER,
			VERSION           INTEGER                     DEFAULT 0                     NOT NULL,
			USUARIOCREAR      VARCHAR2(10 CHAR)           NOT NULL,
			FECHACREAR        TIMESTAMP(6)                NOT NULL,
			USUARIOMODIFICAR  VARCHAR2(10 CHAR),
			FECHAMODIFICAR    TIMESTAMP(6),
			USUARIOBORRAR     VARCHAR2(10 CHAR),
			FECHABORRAR       TIMESTAMP(6),
			BORRADO           NUMBER                      DEFAULT 0                     NOT NULL
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.MSV_CAMPOS_DINAMICOS_HISTORICO... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.MSV_CAMPOS_DIN_HIST_PK ON '||V_ESQUEMA|| '.MSV_CAMPOS_DINAMICOS_HISTORICO
					(CDH_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.MSV_CAMPOS_DINAMICOS_HISTORICO ADD (
						CONSTRAINT MSV_CAMPOS_DIN_HIST_PK PRIMARY KEY (CDH_ID) USING INDEX
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.MSV_CAMPOS_DIN_HIST_PK... Creando PK');

		V_MSQL := 'GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON '
	                  || V_ESQUEMA ||' .MSV_CAMPOS_DINAMICOS_HISTORICO TO '|| V_ESQUEMA_M;
		EXECUTE IMMEDIATE V_MSQL; 
	    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MSV_CAMPOS_DINAMICOS_HISTORICO... Permisos dados a '|| V_ESQUEMA_M);
    
	    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.MSV_CAMPOS_DINAMICOS_HISTORICO... OK');
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