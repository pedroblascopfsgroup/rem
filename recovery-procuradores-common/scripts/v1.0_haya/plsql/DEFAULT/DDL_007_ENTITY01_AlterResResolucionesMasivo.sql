--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150601
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Nuevo campo en RES_RESOLUCIONES_MASIVO
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

	DBMS_OUTPUT.PUT_LINE('******** RES_RESOLUCIONES_MASIVO ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.RES_RESOLUCIONES_MASIVO... Comprobaciones previas');

	-- Comprobamos si ya existe la columna
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''RES_MSV_TMP_ID'' and TABLE_NAME=''RES_RESOLUCIONES_MASIVO'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.RES_RESOLUCIONES_MASIVO.RES_MSV_TMP_ID... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.RES_RESOLUCIONES_MASIVO ADD RES_MSV_TMP_ID NUMBER(16)';
		
		EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.FK_RES_MSV_TMP_ID ON '||V_ESQUEMA|| '.RES_RESOLUCIONES_MASIVO
					(RES_MSV_TMP_ID)';
					
		EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.RES_RESOLUCIONES_MASIVO ADD (CONSTRAINT FK_RES_MSV_TMP_ID FOREIGN KEY
		(RES_MSV_TMP_ID) REFERENCES '|| V_ESQUEMA ||'.MSV_TMP_FILES (MSV_TMP_ID))';
						
						
		DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| V_ESQUEMA ||'.RES_RESOLUCIONES_MASIVO ADD RES_MSV_TMP_ID ... OK');
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