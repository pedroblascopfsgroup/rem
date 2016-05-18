--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20160518
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HR-2358
--## PRODUCTO=NO
--## 
--## Finalidad: Corrige autoprórrogas
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 20151126 GMN Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

        v_usuario_id HAYAMASTER.USU_USUARIOS.USU_ID%TYPE;
	v_letrado    HAYA02.MIG_PROCEDIMIENTOS_ACTORES.CD_ACTOR%TYPE;

        V_MSQL  VARCHAR2(2500);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'HAYA02';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';

        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
   
        V_EXISTE NUMBER (1):=null;

        
  
BEGIN

  DBMS_OUTPUT.PUT_LINE(' [INICIO] - '||to_char(sysdate,'HH24:MI:SS'));
     
   EXECUTE IMMEDIATE('  
             insert into '||V_ESQUEMA_MASTER||'.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_)   
             select '||V_ESQUEMA_MASTER||'.hibernate_sequence.nextval id_ 
                  , ''activarProrroga'' as NAME_
                  , pd processdefinition_
                  , nd from_      
                  , nd to_ 
                  , max_fromindex_ fromindex_
             FROM (    
             SELECT jno.id_ nd,jno.processdefinition_ pd 
                 , (SELECT COUNT(*) FROM '||V_ESQUEMA_MASTER||'.JBPM_TRANSITION JTR WHERE JTR.PROCESSDEFINITION_ = JNO.PROCESSDEFINITION_ AND JTR.FROM_ = JNO.ID_) max_fromindex_
             FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
                  '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
                  '||V_ESQUEMA_MASTER||'.JBPM_TOKEN TOK,
                  '||V_ESQUEMA_MASTER||'.JBPM_NODE JNO
             WHERE TAP_AUTOPRORROGA = 1
               AND TAP.TAP_ID = TEX.TAP_ID
               AND TEX.TEX_TOKEN_ID_BPM = TOK.ID_
               AND TOK.NODE_ = JNO.ID_
               AND JNO.CLASS_ <> ''F''
               AND NOT EXISTS
                 (SELECT 1
                  FROM '||V_ESQUEMA_MASTER||'.JBPM_TRANSITION JTR
                  WHERE JNO.ID_ = JTR.FROM_
                  AND JTR.NAME_ = ''activarProrroga''
                  )
              group by jno.id_,jno.processdefinition_)
           ');
       
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - HAYAMASTER.jbpm_transition. Se insertan autoprórrogas  '||SQL%ROWCOUNT||' Filas.');        
       
   COMMIT;
  


  DBMS_OUTPUT.PUT_LINE(' [FIN] - '||to_char(sysdate,'HH24:MI:SS'));

EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_MSQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;