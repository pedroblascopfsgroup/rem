--/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO
--## FECHA_CREACION=20150902
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=PRODUCTO-174
--## PRODUCTO=SI
--##
--## Finalidad: Tabla que almacena la configuración de los usuarios proponente, validador y decisor de los acuerdos en el asunto
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

	DBMS_OUTPUT.PUT_LINE('******** ACU_CONFIG_ACUERDO_ASUNTO ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACU_CONFIG_ACUERDO_ASUNTO... Comprobaciones previas');
	

	-- Si existe la tabla la borramos
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ACU_CONFIG_ACUERDO_ASUNTO'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '. la tabla ya existe');
	ELSE
		-- Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.S_ACU_CONFIG_ACUERDO_ASUNTO...');
		V_MSQL := 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_ACU_CONFIG_ACUERDO_ASUNTO';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'S_ACU_CONFIG_ACUERDO_ASUNTO... Secuencia creada');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.ACU_CONFIG_ACUERDO_ASUNTO
		(
		  ACU_DGE_ID           NUMBER(16)                   NOT NULL,
		  DD_TDE_ID_PROPONENTE    NUMBER(16)                   NOT NULL,
		  DD_TDE_ID_VALIDADOR    NUMBER(16)                   NOT NULL,
		  DD_TDE_ID_DECISOR    NUMBER(16)                   NOT NULL,
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
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACU_CONFIG_ACUERDO_ASUNTO... Tabla creada');
		
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.ACU_CONFIG_ACUERDO_ASUNTO_IDX ON '||V_ESQUEMA|| '.ACU_CONFIG_ACUERDO_ASUNTO
					(ACU_DGE_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACU_CONFIG_ACUERDO_ASUNTO ADD (
						CONSTRAINT ACU_CONFIG_ACUERDO_ASUNTO_PK PRIMARY KEY (ACU_DGE_ID) USING INDEX
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACU_CONFIG_ACUERDO_ASUNTO_PK... Creando PK');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACU_CONFIG_ACUERDO_ASUNTO ADD (
						CONSTRAINT DD_TDE_ID_PROPONENTE_FK FOREIGN KEY (DD_TDE_ID_PROPONENTE) REFERENCES '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO (DD_TDE_ID) ON DELETE SET NULL
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_TDE_ID_PROPONENTE_FK... Creando FK');
		
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACU_CONFIG_ACUERDO_ASUNTO ADD (
						CONSTRAINT DD_TDE_ID_VALIDADOR_FK FOREIGN KEY (DD_TDE_ID_VALIDADOR) REFERENCES '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO (DD_TDE_ID) ON DELETE SET NULL
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_TGE_ID_VALIDADOR_FK... Creando FK');
		
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACU_CONFIG_ACUERDO_ASUNTO ADD (
						CONSTRAINT DD_TDE_ID_DECISOR_FK FOREIGN KEY (DD_TDE_ID_DECISOR) REFERENCES '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO (DD_TDE_ID) ON DELETE SET NULL
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_TGE_ID_DECISOR_FK... Creando FK');
		
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO... OK');
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