--/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20151221
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=PRODUCTO-526
--## PRODUCTO=SI
--##
--## Finalidad: Nuevo campo PCO_BUR_REF_EXTERNA_ENVIO en PCO_BUR_ENVIO
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

	DBMS_OUTPUT.PUT_LINE('******** PCO_BUR_ENVIO ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PCO_BUR_ENVIO... Comprobaciones previas');

	-- Comprobamos si ya existe la columna
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''PCO_BUR_REF_EXTERNA_ENVIO'' and TABLE_NAME=''PCO_BUR_ENVIO'' and owner = ''' || V_ESQUEMA || '''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;

	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_BUR_ENVIO.PCO_BUR_REF_EXTERNA_ENVIO... Ya existe');
	ELSE

		EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.PCO_BUR_ENVIO ADD (PCO_BUR_REF_EXTERNA_ENVIO VARCHAR2(50 CHAR))';

		DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| V_ESQUEMA ||'.PCO_BUR_ENVIO ADD PCO_BUR_REF_EXTERNA_ENVIO ... OK');

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