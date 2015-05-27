--/*
--##########################################
--## Autor: #AUTOR#
--## Descripción:
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
 
 
    -- Otras variables
 
BEGIN
     
    -- CUERPO DEL SCRIPT
    -- PARA LA CREACIÓN DE OBJETOS USAR LA CONSULTA DE EXISTENCIA PREVIA
    -- USAR M_SQL para construir SQL a ejecutar
    -- USAR EXECUTE IMMEDIATE para ejecutar M_SQL
 
	V_MSQL := 'CREATE VIEW ' || V_ESQUEMA || '.VLOS_TASACION_ACTIVA AS ' || 
		' SELECT LOS.LOS_ID, SUM(VAL.BIE_IMPORTE_VALOR_TASACION) AS IMPORTE_TASACION FROM ' || V_ESQUEMA || '.LOB_LOTE_BIEN LOS ' || 
		' INNER JOIN ' || V_ESQUEMA || '.BIE_VALORACIONES VAL ON VAL.BIE_ID=LOS.BIE_ID ' || 
		' INNER JOIN (SELECT BVAL.BIE_ID, MAX(BVAL.BIE_FECHA_VALOR_TASACION) AS BIE_FECHA_VALTAS_MAXIMA FROM ' || V_ESQUEMA || 
		'.BIE_VALORACIONES BVAL ' || 
		' WHERE BVAL.BIE_FECHA_VALOR_TASACION IS NOT NULL AND BVAL.BORRADO=0 GROUP BY BVAL.BIE_ID) T ON T.BIE_ID=VAL.BIE_ID AND  ' || 
		' T.BIE_FECHA_VALTAS_MAXIMA=VAL.BIE_FECHA_VALOR_TASACION AND VAL.BORRADO=0 ' || 
		' GROUP BY LOS.LOS_ID';
 	EXECUTE IMMEDIATE V_MSQL;

EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
