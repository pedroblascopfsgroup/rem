--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150622
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Tabla que recoge las relaciones de resolución y categoría.
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

	DBMS_OUTPUT.PUT_LINE('******** REC_RES_CAT ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.REC_RES_CAT... Comprobaciones previas');
	

	-- Si existe la tabla la borramos
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''REC_RES_CAT'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.REC_RES_CAT... Ya existe');
	ELSE
		-- Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.REC_RES_CAT...');
		V_MSQL := 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_REC_RES_CAT';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'S_REC_RES_CAT... Secuencia creada');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.REC_RES_CAT
		(
		  REC_ID  NUMBER(16)                            NOT NULL,
		  RES_ID  NUMBER(16)                            NOT NULL,
		  CAT_ID  NUMBER(16)                            NOT NULL
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.REC_RES_CAT... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.REC_RES_CAT_PK ON '||V_ESQUEMA|| '.REC_RES_CAT
					(REC_ID) TABLESPACE haya_idx';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.REC_RES_CAT ADD (
						CONSTRAINT REC_RES_CAT_PK PRIMARY KEY (REC_ID) USING INDEX
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.REC_RES_CAT_PK... Creando PK');
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.REC_RES_CAT.REC_RES_CAT_PK... OK');
		
		
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.REC_RES_CAT_UNIQUE ON '||V_ESQUEMA|| '.REC_RES_CAT
					(RES_ID) TABLESPACE haya_idx';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.REC_RES_CAT ADD (
						CONSTRAINT REC_RES_CAT_UNIQUE UNIQUE (RES_ID) USING INDEX
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.REC_RES_CAT_UNIQUE... Creando FK');
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.REC_RES_CAT.REC_RES_CAT_UNIQUE... OK');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.REC_RES_CAT ADD (
						CONSTRAINT REC_RES_CAT_CATEGORIAS_FK FOREIGN KEY (CAT_ID) REFERENCES '||V_ESQUEMA||'.CAT_CATEGORIAS (CAT_ID)
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| V_ESQUEMA ||'.REC_RES_CAT ADD REC_RES_CAT_CATEGORIAS_FK ... OK');
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.REC_RES_CAT.REC_RES_CAT_UNIQUE... OK');
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.REC_RES_CAT... OK');
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