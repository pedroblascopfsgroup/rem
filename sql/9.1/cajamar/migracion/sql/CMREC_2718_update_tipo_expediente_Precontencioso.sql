--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20160309
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-2718
--## PRODUCTO=NO
--## 
--## Finalidad: se informa el tipo del expediente para precontencioso
--## INSTRUCCIONES:  
--## VERSIONES:
--##         0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

        TABLE_COUNT  NUMBER(3);
        EXISTE       NUMBER;
        v_SQL        VARCHAR2(12000 CHAR);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'CM01';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'CMMASTER';
        V_USUARIO VARCHAR2(25 CHAR):= 'MIGRACM01PCO';        
        
        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
  
        
BEGIN


      v_SQL := 'UPDATE '||V_ESQUEMA||'.EXP_EXPEDIENTES 
                SET DD_TPX_ID = (select dd_TPX_ID from '||V_ESQUEMA||'.DD_TPX_TIPO_EXPEDIENTE where DD_TPX_CODIGO = ''RECU'')
                WHERE  usuariocrear = '''||V_USUARIO||''' AND DD_TPX_ID is null';
      
      EXECUTE IMMEDIATE(v_SQL);

      DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);  
    
    COMMIT;


DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO');

EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;





