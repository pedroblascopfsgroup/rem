whenever sqlerror exit sql.sqlcode;


DECLARE
  N NUMBER(16);
BEGIN

    select count(1) into N from ALL_TAB_COLS where owner='BANK01' and table_name = 'RDF_RECOBRO_DETALLE_FACTURA' and column_name = 'CPR_ID';
    IF (N = 0) THEN
      EXECUTE IMMEDIATE 'ALTER TABLE BANK01.RDF_RECOBRO_DETALLE_FACTURA ADD CPR_ID NUMBER(16)';
    END IF;
   
END;
/

EXIT