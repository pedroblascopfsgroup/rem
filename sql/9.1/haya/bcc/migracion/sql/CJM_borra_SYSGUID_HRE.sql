--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20151203
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=XXXXXX
--## PRODUCTO=NO
--## 
--## Finalidad: Ponemos los SYSGUID a nulo para reasignarlos
--## INSTRUCCIONES:  
--## VERSIONES:
--##        20151203 GMN  0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

        TABLE_COUNT  NUMBER(3);
        EXISTE       NUMBER;
        V_SQL        VARCHAR2(10000 CHAR);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'HAYA02';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';
        USUARIO      VARCHAR2(50 CHAR):= 'MIGRAHAYA02';
        
        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
  
        
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Inicio limpieza SYSGUID');   

   --quitamos duplicado por bienes repetidos

    EXECUTE IMMEDIATE('UPDATE '||V_ESQUEMA||'.ASU_ASUNTOS SET SYS_GUID = NULL WHERE USUARIOCREAR = '''||USUARIO||''''); 

   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de ASU_ASUNTOS actualizados. '||SQL%ROWCOUNT||' Filas.');       
    COMMIT;
    
    EXECUTE IMMEDIATE('UPDATE '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS SET SYS_GUID = NULL WHERE USUARIOCREAR = '''||USUARIO||''''); 

   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de PRC_PROCEDIMIENTOS actualizados. '||SQL%ROWCOUNT||' Filas.');    
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE '||V_ESQUEMA||'.PRB_PRC_BIE SET SYS_GUID = NULL WHERE USUARIOCREAR = '''||USUARIO||''''); 

   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de PRB_PRC_BIE actualizados. '||SQL%ROWCOUNT||' Filas.');    
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE SET SYS_GUID = NULL WHERE USUARIOCREAR = '''||USUARIO||''''); 
    
   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de CEX_CONTRATOS_EXPEDIENTE actualizados. '||SQL%ROWCOUNT||' Filas.');    
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET SYS_GUID = NULL WHERE USUARIOCREAR = '''||USUARIO||''''); 
    
   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de TAR_TAREAS_NOTIFICACIONES actualizados. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE '||V_ESQUEMA||'.SUB_SUBASTA SET SYS_GUID = NULL WHERE USUARIOCREAR = '''||USUARIO||''''); 
    
   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de SUB_SUBASTA actualizados. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    EXECUTE IMMEDIATE('UPDATE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA SET SYS_GUID = NULL WHERE USUARIOCREAR = '''||USUARIO||''''); 
    
   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Registros de LOS_LOTE_SUBASTA actualizados. '||SQL%ROWCOUNT||' Filas.');    
    COMMIT;

   DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Fin limpieza SYSGUID');      
   
--/***************************************
--*     FIN BORRA SYSGUID               *
--***************************************/

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













