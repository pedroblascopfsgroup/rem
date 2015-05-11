SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

    TABLE_COUNT NUMBER(3);
    ERR_NUM NUMBER(25);
    ERR_MSG VARCHAR2(1024);
    
BEGIN

    SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES 
     WHERE UPPER(table_name) = 'TMP_CNT_FIN_EXCEPCION' 
       AND OWNER = 'BANK01';
         
    if TABLE_COUNT = 0 then 
    
          EXECUTE IMMEDIATE 'CREATE GLOBAL TEMPORARY TABLE TMP_CNT_FIN_EXCEPCION
                             ( CRC_ID                   NUMBER(16)
                             , CNT_ID                   NUMBER(16)
                             , CRE_ID                   NUMBER(16)
                             , CRC_ID_ENVIO             NUMBER(16)
                             , CRC_FECHA_ALTA           TIMESTAMP(6)
                             , CRC_POS_VIVA_NO_VENCIDA  NUMBER(16,2)
                             , CRC_POS_VIVA_VENCIDA     NUMBER(16,2)
                             , CRC_INT_ORDIN_DEVEN      NUMBER(16,2)
                             , CRC_INT_MORAT_DEVEN      NUMBER(16,2)
                             , CRC_COMISIONES           NUMBER(16,2)
                             , CRC_GASTOS               NUMBER(16,2)
                             , CRC_IMPUESTOS            NUMBER(16,2)
                             , VERSION                  INTEGER
                             , USUARIOCREAR             VARCHAR2(10 Char)
                             , FECHACREAR               TIMESTAMP(6)
                             , BORRADO                  NUMBER(1)
                             ) ON COMMIT PRESERVE ROWS
                            ';                             
          DBMS_OUTPUT.PUT_LINE('[INFO] TMP_CNT_FIN_EXCEPCION Creada');
    else
          DBMS_OUTPUT.PUT_LINE('[INFO] TMP_CNT_FIN_EXCEPCION Ya Existe');
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