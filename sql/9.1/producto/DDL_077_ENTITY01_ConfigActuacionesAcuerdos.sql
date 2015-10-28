--/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO
--## FECHA_CREACION=20150917
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=PRODUCTO-174
--## PRODUCTO=SI
--##
--## Finalidad: Tabla que almacena la configuración de actuaciones para Acuerdos
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

	DBMS_OUTPUT.PUT_LINE('******** ACU_CDE_DERIVACIONES ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACU_CDE_DERIVACIONES... Comprobaciones previas');
	

	-- Si existe la tabla la borramos
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ACU_CDE_DERIVACIONES'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ACU_CDE_DERIVACIONES... Ya existe');
	ELSE
		-- Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.S_ACU_CDE_DERIVACIONES...');
		V_MSQL := 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_ACU_CDE_DERIVACIONES';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'S_ACU_CDE_DERIVACIONES... Secuencia creada');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.ACU_CDE_DERIVACIONES
		(
		  ACU_CDE_ID           NUMBER(16)                   NOT NULL,
		  DD_TPA_ID            NUMBER(16)                   NOT NULL,
          DD_TPO_ID    	       NUMBER(16) 		            NOT NULL,
		  ACU_CDE_RESTRICTIVO  NUMBER(1),
		  ACU_CDE_RESTRICTIVO_TEXTO  VARCHAR2(4000 BYTE), 					
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
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACU_CDE_DERIVACIONES... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.ACU_CDE_DERIVACIONES_PK ON '||V_ESQUEMA|| '.ACU_CDE_DERIVACIONES
					(ACU_CDE_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACU_CDE_DERIVACIONES ADD (
						CONSTRAINT ACU_CDE_DERIVACIONES_PK PRIMARY KEY (ACU_CDE_ID) USING INDEX
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACU_CDE_DERIVACIONES_PK... Creando PK');
		
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACU_CDE_DERIVACIONES ADD (
						CONSTRAINT ACU_CDE_DERIVACIONES_UNIQUE UNIQUE (DD_TPA_ID)
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACU_CDE_DERIVACIONES_UNIQUE... Creando UNIQUE TIPO ACUERDO');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACU_CDE_DERIVACIONES ADD (
						CONSTRAINT TIPOS_ACUERDOS_FK FOREIGN KEY (DD_TPA_ID) REFERENCES '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID) ON DELETE SET NULL
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.TIPOS_ACUERDOS_FK... Creando FK');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACU_CDE_DERIVACIONES ADD (
						CONSTRAINT TIPO_PROCEDIMIENTO_FK FOREIGN KEY (DD_TPO_ID) REFERENCES '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO (DD_TPO_ID) ON DELETE SET NULL
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.TIPO_PROCEDIMIENTO_FK... Creando FK');
		
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACU_CDE_DERIVACIONES... OK');
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