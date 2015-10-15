--/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO
--## FECHA_CREACION=20150803
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=PRODUCTO-174
--## PRODUCTO=SI
--##
--## Finalidad: Tabla que almacena los diferentes campos dependiendo del tipo de acuerdo y la entidad.
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

	DBMS_OUTPUT.PUT_LINE('******** ACU_CAMPOS_TIPO_ACUERDO ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO... Comprobaciones previas');
	

	-- Si existe la tabla la borramos
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ACU_CAMPOS_TIPO_ACUERDO'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ACU_CAMPOS_TIPO_ACUERDO... Ya existe');
	ELSE
		-- Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.S_ACU_CAMPOS_TIPO_ACUERDO...');
		V_MSQL := 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_ACU_CAMPOS_TIPO_ACUERDO';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'S_ACU_CAMPOS_TIPO_ACUERDO... Secuencia creada');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO
		(
		  CMP_ID           NUMBER(16)                   NOT NULL,
		  DD_TPA_ID               NUMBER(16)                   NOT NULL,
          CMP_NOMBRE_CAMPO    	VARCHAR2(4000 BYTE) 		NOT NULL,
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
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO_PK ON '||V_ESQUEMA|| '.ACU_CAMPOS_TIPO_ACUERDO
					(CMP_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO ADD (
						CONSTRAINT ACU_CAMPOS_TIPO_ACUERDO_PK PRIMARY KEY (CMP_ID) USING INDEX
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO_PK... Creando PK');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO ADD (
						CONSTRAINT CAMPOS_TIPACU_FK FOREIGN KEY (DD_TPA_ID) REFERENCES '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID) ON DELETE SET NULL
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.CAMPOS_TIPACU_FK... Creando FK');
		
		
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