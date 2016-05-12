--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20160303
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-1866
--## PRODUCTO=NO
--## 
--## Finalidad: se informa el nombre del expediente para precontencioso
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
        
        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
  
        
BEGIN


      v_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
                SET PCO_PRC_NOM_EXP_JUD = (SELECT ASU.ASU_NOMBRE
                            FROM '||V_ESQUEMA||'.ASU_ASUNTOS ASU, '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
                            WHERE ASU.ASU_ID = PRC.ASU_ID
                            AND PRC.PRC_ID = PCO.PRC_ID)';
      
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





