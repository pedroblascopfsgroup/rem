--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150622
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Modificacion longitud de campos DD_TR_TIPOS_RESOLUCION
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

	DBMS_OUTPUT.PUT_LINE('******** DD_TR_TIPOS_RESOLUCION ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION... Comprobaciones previas');
	
	-- Comprobamos si ya se ha modificado la columna
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_TR_AYUDA'' and DATA_TYPE = ''VARCHAR2'' and DATA_LENGTH = ''4000'' and TABLE_NAME=''DD_TR_TIPOS_RESOLUCION'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TR_TIPOS_RESOLUCION.DD_TR_AYUDA... Ya está modificada');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.DD_TR_TIPOS_RESOLUCION MODIFY 
			(DD_TR_AYUDA VARCHAR2(4000))';
		
		DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| V_ESQUEMA ||'.DD_TR_TIPOS_RESOLUCION MODIFY DD_TR_AYUDA ... OK');
	END IF;
	
	-- Comprobamos si ya se ha modificado la columna
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_TR_CODIGO'' and DATA_TYPE = ''VARCHAR2'' and DATA_LENGTH = ''25'' and TABLE_NAME=''DD_TR_TIPOS_RESOLUCION'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TR_TIPOS_RESOLUCION.DD_TR_CODIGO... Ya está modificada');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.DD_TR_TIPOS_RESOLUCION MODIFY 
			(DD_TR_CODIGO VARCHAR2(25))';
		
		DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| V_ESQUEMA ||'.DD_TR_TIPOS_RESOLUCION MODIFY DD_TR_CODIGO ... OK');
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION... OK');

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