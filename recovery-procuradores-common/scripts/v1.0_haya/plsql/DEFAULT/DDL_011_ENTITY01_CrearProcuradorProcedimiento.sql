--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150622
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Tabla que recoge la relación entre procurador y procedimiento.
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

	DBMS_OUTPUT.PUT_LINE('******** PPR_PROCURADOR_PROCEDIMIENTO ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PPR_PROCURADOR_PROCEDIMIENTO... Comprobaciones previas');
	

	-- Si existe la tabla la borramos
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''PPR_PROCURADOR_PROCEDIMIENTO'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PPR_PROCURADOR_PROCEDIMIENTO... Ya existe');
	ELSE
		-- Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.PPR_PROCURADOR_PROCEDIMIENTO...');
		V_MSQL := 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_PPR_PROCURADOR_PROCEDIMIENTO';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'S_PPR_PROCURADOR_PROCEDIMIENTO... Secuencia creada');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.PPR_PROCURADOR_PROCEDIMIENTO
		(
			PPR_ID  NUMBER(16)                            NOT NULL,
			PRO_ID  NUMBER(16)                            NOT NULL,
			PRC_ID  NUMBER(16)                            NOT NULL
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.PPR_PROCURADOR_PROCEDIMIENTO... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.PPR_PK ON '||V_ESQUEMA|| '.PPR_PROCURADOR_PROCEDIMIENTO
					(PPR_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PPR_PROCURADOR_PROCEDIMIENTO ADD (
						CONSTRAINT PPR_PK PRIMARY KEY (PPR_ID) USING INDEX
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.PPR_PK... Creando PK');
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PPR_PROCURADOR_PROCEDIMIENTO ADD (
						CONSTRAINT FK_PPR_PROCURADOR FOREIGN KEY (PRO_ID) REFERENCES PRO_PROCURADORES (PRO_ID)
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_PPR_PROCURADOR... Creando FK');
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PPR_PROCURADOR_PROCEDIMIENTO ADD (
						CONSTRAINT FK_PPR_PROCEDIMIENTO FOREIGN KEY (PRC_ID) REFERENCES PRC_PROCEDIMIENTOS (PRC_ID)
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_PPR_PROCEDIMIENTO... Creando FK');
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.PPR_PROCURADOR_PROCEDIMIENTO... OK');
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