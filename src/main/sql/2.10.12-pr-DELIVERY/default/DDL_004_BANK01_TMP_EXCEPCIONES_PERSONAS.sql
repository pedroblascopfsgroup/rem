SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

    TABLE_COUNT NUMBER(3);
    ERR_NUM NUMBER(25);
    ERR_MSG VARCHAR2(1024);
    
BEGIN

    SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES 
     WHERE UPPER(table_name) = 'TMP_EXCEPCIONES_PERSONAS' 
       AND OWNER = 'BANK01';
         
    if TABLE_COUNT = 0 then 
    
          EXECUTE IMMEDIATE 'CREATE GLOBAL TEMPORARY TABLE TMP_EXCEPCIONES_PERSONAS
                             ( PER_ID  NUMBER(16)
                             , CRE_ID  NUMBER(16)
                             , EXC_ID  NUMBER(16) 
                             ) ON COMMIT PRESERVE ROWS
                            ';                             
          DBMS_OUTPUT.PUT_LINE('[INFO] TMP_EXCEPCIONES_PERSONAS Creada');
    else
          DBMS_OUTPUT.PUT_LINE('[INFO] TMP_EXCEPCIONES_PERSONAS Ya existe');
          
    end if;     

EXCEPTION

  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   

END;