--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150618
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Tabla que recoge los procuradores
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

	DBMS_OUTPUT.PUT_LINE('******** PRO_PROCURADORES ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PRO_PROCURADORES... Comprobaciones previas');
	

	-- Si existe la tabla la borramos
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''PRO_PROCURADORES'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PRO_PROCURADORES... Ya existe');
	ELSE
		-- Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.PRO_PROCURADORES...');
		V_MSQL := 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_PRO_PROCURADORES';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'S_PRO_PROCURADORES... Secuencia creada');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.PRO_PROCURADORES
		(
			  PRO_ID  NUMBER(16),
			  NOMBRE  VARCHAR2(50 CHAR)
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.PRO_PROCURADORES... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.PK_PRO_PROCURADORES ON '||V_ESQUEMA|| '.PRO_PROCURADORES
					(PRO_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PRO_PROCURADORES ADD (
						CONSTRAINT PK_PRO_PROCURADORES PRIMARY KEY (PRO_ID) USING INDEX
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.PK_PRO_PROCURADORES... Creando PK');
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.PRO_PROCURADORES... OK');
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