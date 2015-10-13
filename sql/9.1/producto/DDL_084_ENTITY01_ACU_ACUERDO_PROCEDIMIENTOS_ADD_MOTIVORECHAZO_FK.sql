--/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO	
--## FECHA_CREACION=20151007
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=PRODUCTO-290
--## PRODUCTO=SI
--##
--## Finalidad: Añadir DD_MTR_ID de ACU_ACUERDO_PROCEDIMIENTOS
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

	DBMS_OUTPUT.PUT_LINE('******** ACU_ACUERDO_PROCEDIMIENTOS ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS... Comprobaciones previas');
	

	-- Si existe la tabla la borramos
	V_MSQL :=  q'[SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = 'ACU_ACUERDO_PROCEDIMIENTOS' and owner=']' || V_ESQUEMA || q'[']';
	--DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		-- Si existe la columna la borramos
		V_MSQL := q'[select count(1) from all_tab_cols where table_name='ACU_ACUERDO_PROCEDIMIENTOS' and column_name='DD_MTR_ID' and owner=']' || V_ESQUEMA || q'[']';
		--DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO table_count;
		
		IF table_count = 1 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ACU_ACUERDO_PROCEDIMIENTOS... existe la columna DD_MTR_ID, no la creamos');
        ELSE
        	V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.ACU_ACUERDO_PROCEDIMIENTOS ADD (DD_MTR_ID NUMBER(16))';
        	EXECUTE IMMEDIATE V_MSQL;
        	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS... Columna creada');  
        	
        	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ADD (
						CONSTRAINT FK_MOTIVO_RECHAZO FOREIGN KEY (DD_MTR_ID) REFERENCES '||V_ESQUEMA||'.DD_MTR_MOTIVO_RECHAZO_ACUERDO (DD_MTR_ID) ON DELETE SET NULL
						)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_MOTIVO_RECHAZO... Creando FK');
		END IF;

	END IF;

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('******** FIN DE LA MODIFICACION DE ACU_ACUERDO_PROCEDIMIENTOS ********'); 
	
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