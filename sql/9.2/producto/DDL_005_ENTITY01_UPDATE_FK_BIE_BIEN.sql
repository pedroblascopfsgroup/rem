--/*
--##########################################
--## AUTOR=IVAN PICAZO
--## FECHA_CREACION=20160309
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2052
--## PRODUCTO=SI
--##
--## Finalidad: Actualización de la FK FK_BIEN_DD_IMV en la tabla BIE_BIEN para que apunte a la tabla DD_IMV_IMPOSICION_VENTA en lugar de DD_TPI_TIPO_IMPOSICION
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    v_numero NUMBER(16);
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_fk_count number(16);
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
BEGIN

	-- Comprobamos si ya existe la FK
	V_MSQL := 'SELECT count(1) CONSTRAINT_NAME FROM all_constraints where CONSTRAINT_NAME = ''FK_BIEN_DD_TPIV'' AND TABLE_NAME= ''BIE_BIEN'' ';
	EXECUTE IMMEDIATE V_MSQL INTO v_fk_count;
	
	IF v_fk_count = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN... No existe la FK FK_BIEN_DD_TPIV EN LA TABLA BIE_BIEN');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.BIE_BIEN DROP CONSTRAINT FK_BIEN_DD_TPIV';
						
		DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| V_ESQUEMA ||'.BIE_BIEN ... FK FK_BIEN_DD_TPIV eliminada ');
	END IF;

	COMMIT;

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