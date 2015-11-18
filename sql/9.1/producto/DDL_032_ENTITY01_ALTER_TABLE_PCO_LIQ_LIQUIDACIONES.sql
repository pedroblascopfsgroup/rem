--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20151116
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=PRODUCTO-422
--## PRODUCTO=SI
--##
--## Finalidad: Nuevo campo PCO_LIQ_FECHA_VISADO en PCO_LIQ_LIQUIDACIONES
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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('******** PCO_LIQ_LIQUIDACIONES ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES... Comprobaciones previas');

	-- Comprobamos si ya existe la columna
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''PCO_LIQ_FECHA_VISADO'' and TABLE_NAME=''PCO_LIQ_LIQUIDACIONES'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_LIQ_LIQUIDACIONES.PCO_LIQ_FECHA_VISADO... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.PCO_LIQ_LIQUIDACIONES ADD 
			(PCO_LIQ_FECHA_VISADO TIMESTAMP(6))';
		
		DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| V_ESQUEMA ||'.PCO_LIQ_LIQUIDACIONES ADD PCO_LIQ_LIQUIDACIONES ... OK');
	END IF;	


EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Código de error obtenido:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT