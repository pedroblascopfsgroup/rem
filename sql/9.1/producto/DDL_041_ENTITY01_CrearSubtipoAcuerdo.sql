--/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO
--## FECHA_CREACION=20150728
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=PRODUCTO-159
--## PRODUCTO=SI
--##
--## Finalidad: Tabla diccionario de subtipos de acuerdo
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(2000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('******** DD_SBT_SUBTIPO_ACUERDO ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SBT_SUBTIPO_ACUERDO... Comprobaciones previas');
	

	-- Si existe la tabla la borramos
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_SBT_SUBTIPO_ACUERDO'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SBT_SUBTIPO_ACUERDO... Ya existe');
	ELSE
		-- Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.DD_SBT_SUBTIPO_ACUERDO...');
		V_MSQL := 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_DD_SBT_SUBTIPO_ACUERDO';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'S_DD_SBT_SUBTIPO_ACUERDO... Secuencia creada');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.DD_SBT_SUBTIPO_ACUERDO
		(
		  DD_SBT_ID           NUMBER(16)                   NOT NULL,
		  DD_SBT_CODIGO       VARCHAR2(500 BYTE),
		  DD_SBT_DESCRIPCION  VARCHAR2(1000 BYTE),
		  DD_SBT_DESCRIPCION_LARGA  VARCHAR2(2000 BYTE),
          VERSION                  INTEGER,
          USUARIOCREAR             VARCHAR2(10 CHAR),
          FECHACREAR               TIMESTAMP(6),
          BORRADO                  NUMBER(1),
		  USUARIOMODIFICAR VARCHAR2(10 CHAR), 
		  FECHAMODIFICAR TIMESTAMP (6), 
	      USUARIOBORRAR VARCHAR2(10 CHAR), 
		  FECHABORRAR TIMESTAMP (6) 
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_SBT_SUBTIPO_ACUERDO... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.DD_SBT_SUBTIPO_ACUERDO_PK ON '||V_ESQUEMA|| '.DD_SBT_SUBTIPO_ACUERDO
					(DD_SBT_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_SBT_SUBTIPO_ACUERDO ADD (
						CONSTRAINT DD_SBT_SUBTIPO_ACUERDO_PK PRIMARY KEY (DD_SBT_ID) USING INDEX
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_SBT_SUBTIPO_ACUERDO_PK... Creando PK');
		
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_SBT_SUBTIPO_ACUERDO... OK');
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