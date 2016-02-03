--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20151103
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-1728
--## PRODUCTO=NO
--## 
--## Finalidad: Modificar la situación del itinerario en CLI_CLIENTES (DD_EST_ID)
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
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'HAYA02';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';
        USUARIO      VARCHAR2(50 CHAR):= 'MIGRAHAYA02';
        USUARIO_PCO  VARCHAR2(50 CHAR):= 'MIGRAHAYA02PCO';        
        
        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
  
        
BEGIN


      v_SQL := 'UPDATE '||V_ESQUEMA||'.CLI_CLIENTES 
                SET DD_EST_ID = (SELECT DD_EST_ID FROM '||V_ESQUEMA_MASTER||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''AS'')
                WHERE usuariocrear IN ('''||USUARIO||''', '''||USUARIO_PCO||''')';
      
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





