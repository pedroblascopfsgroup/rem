--/*
--##########################################
--## AUTOR=Luis Antonio Prato Paredes
--## FECHA_CREACION=20160331
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=BKREC-1716
--## PRODUCTO=NO
--## 
--## Finalidad: crear la tabla de rechazos para CNV_AUX_PRC_PRO
--## INSTRUCCIONES: crear tabla con las columnas de fila erronea, codigo de error, mensaje de error y como añadido fecha del error
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);

    -- Otras variables

 BEGIN
	V_MSQL:='create table ' || V_ESQUEMA || '.CNV_AUX_PRC_PRO_REJECT(ROW_REJECTED VARCHAR(1024 BYTE),ERROR_CODE VARCHAR(255 BYTE), ERROR_MESSAGE VARCHAR(255 BYTE), ERROR_DATE TIMESTAMP(6))';
   
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

EXIT;
