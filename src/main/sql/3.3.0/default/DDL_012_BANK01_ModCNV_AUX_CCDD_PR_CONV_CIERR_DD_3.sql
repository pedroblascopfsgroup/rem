--/*
--##########################################
--## Author: Gonzalo Estellés
--## Finalidad: DDL tabla cierre de deudas
--##            
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
--Para permitir la visualizaci?n de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE

    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas    
    V_MSQL VARCHAR2(4000 CHAR); 

BEGIN

    SELECT COUNT(1) INTO v_column_count FROM user_tab_cols WHERE UPPER(table_name) = 'CNV_AUX_CCDD_PR_CONV_CIERR_DD' and UPPER(column_name) = 'BIE_ID';
    IF v_column_count = 1 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CNV_AUX_CCDD_PR_CONV_CIERR_DD... BIE_ID ya existe');
    ELSE
        EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.CNV_AUX_CCDD_PR_CONV_CIERR_DD ADD (BIE_ID  NUMBER(22))';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CNV_AUX_CCDD_PR_CONV_CIERR_DD... BIE_ID creada');
    END IF;

    SELECT COUNT(1) INTO v_column_count FROM user_tab_cols WHERE UPPER(table_name) = 'CNV_AUX_CCDD_PR_CONV_CIERR_DD' and UPPER(column_name) = 'ENTIDAD';
    IF v_column_count = 1 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CNV_AUX_CCDD_PR_CONV_CIERR_DD... ENTIDAD ya existe');
    ELSE
        EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.CNV_AUX_CCDD_PR_CONV_CIERR_DD ADD (ENTIDAD VARCHAR(20 CHAR))';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CNV_AUX_CCDD_PR_CONV_CIERR_DD... ENTIDAD creada');
    END IF;


EXCEPTION

     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          ROLLBACK;
          RAISE;
END;
/

EXIT;