--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20150929
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=PRODUCTO
--## PRODUCTO=SI
--##
--## Finalidad: Nuevo campo DD_EGT_ID en TEA_TERMINOS_ACUERDO
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

	DBMS_OUTPUT.PUT_LINE('******** TEA_TERMINOS_ACUERDO ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO... Comprobaciones previas');

	-- Comprobamos si ya existe la columna
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_EGT_ID'' and TABLE_NAME=''TEA_TERMINOS_ACUERDO'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO.DD_EGT_ID... Ya existe');
	ELSE
		
		----Tipo Gestor proponente
		EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO ADD 
			(DD_EGT_ID NUMBER(16))';
		
		DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| V_ESQUEMA ||'.TEA_TERMINOS_ACUERDO ADD DD_EGT_ID ... OK');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO ADD (
						CONSTRAINT FK_TERMINO_ACUERDO_EGT FOREIGN KEY (DD_EGT_ID) REFERENCES '||V_ESQUEMA_M||'.DD_EGT_EST_GEST_TERMINO (DD_EGT_ID) ON DELETE SET NULL
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_TERMINO_ACUERDO_EGT... Creando FK');
		
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