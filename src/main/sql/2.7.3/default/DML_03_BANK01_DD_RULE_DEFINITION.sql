whenever sqlerror exit sql.sqlcode;
set serveroutput on;

DECLARE
  V_COUNT NUMBER(16);
BEGIN
  SELECT COUNT(1) INTO V_COUNT FROM BANK01.DD_RULE_DEFINITION WHERE rd_title like 'Es titular del contrato%';
  IF V_COUNT <> 0 THEN
    DBMS_OUTPUT.PUT_LINE('Variable Es titular del contrato existe: actualizando');
    UPDATE BANK01.DD_RULE_DEFINITION SET RD_COLUMN = 'ES_TITULAR' where rd_title like 'Es titular del contrato%';
  ELSE
    DBMS_OUTPUT.PUT_LINE('Variable Es titular del contrato no existe: insertando');
    Insert into BANK01.DD_RULE_DEFINITION (RD_ID,RD_TITLE,RD_COLUMN,RD_TYPE,RD_VALUE_FORMAT,RD_BO_VALUES,RD_TAB,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
    values (BANK01.S_DD_RULE_DEFINITION.NEXTVAL,'Es titular del contrato 1/0','ES_TITULAR','compare1','number',null,'Contrato','PFS',sysdate,null,null,null,null,0);
  END IF;
  
  SELECT COUNT(1) INTO V_COUNT FROM BANK01.DD_RULE_DEFINITION WHERE UPPER(RD_COLUMN) = 'MAX_DIAS_IRREGULAR';
  IF V_COUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Variable MAX_DIAS_IRREGULAR no existe: insertando');
    Insert into BANK01.DD_RULE_DEFINITION (RD_ID,RD_TITLE,RD_COLUMN,RD_TYPE,RD_VALUE_FORMAT,RD_BO_VALUES,RD_TAB,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
    values (BANK01.S_DD_RULE_DEFINITION.NEXTVAL,'Máximo en irregular - Compara1Valor','MAX_DIAS_IRREGULAR','compare1','number',null,'Persona','PFS',sysdate,null,null,null,null,0);
  END IF;
  
  COMMIT;
END;
/
EXIT