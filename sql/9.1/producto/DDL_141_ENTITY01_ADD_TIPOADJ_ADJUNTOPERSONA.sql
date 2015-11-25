--/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO
--## FECHA_CREACION=20151120
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=CMREC-1083
--## PRODUCTO=SI
--##
--## Finalidad: Crear nuevo campo en la table ADP_ADJUNTOS_PERSONAS
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

	DBMS_OUTPUT.PUT_LINE('******** ADP_ADJUNTOS_PERSONAS ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ADP_ADJUNTOS_PERSONAS... Comprobaciones previas');

	-- Comprobamos si ya existe la columna
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_TAE_ID'' and TABLE_NAME=''ADP_ADJUNTOS_PERSONAS'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ADP_ADJUNTOS_PERSONAS.DD_TAE_ID... Ya existe');
	ELSE
		----Creamos el campo
		EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.ADP_ADJUNTOS_PERSONAS ADD 
			(DD_TAE_ID NUMBER(16))';
		
		DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| V_ESQUEMA ||'.ADP_ADJUNTOS_PERSONAS ADD DD_TAE_ID ... OK');
		
		V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.ADP_ADJUNTOS_PERSONAS ADD (
						CONSTRAINT DD_TAE_ID_ADJUNTOS_PERSONA_FK FOREIGN KEY (DD_TAE_ID) REFERENCES '|| V_ESQUEMA ||'.DD_TAE_TIPO_ADJUNTO_ENTIDAD (DD_TAE_ID) ON DELETE SET NULL
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_TAE_ID_FK... Creando FK');
		
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