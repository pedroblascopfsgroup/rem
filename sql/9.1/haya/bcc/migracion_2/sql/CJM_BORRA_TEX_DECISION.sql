--/*
--##########################################
--## AUTOR=JTD
--## FECHA_CREACION=20160527
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-3388
--## PRODUCTO=NO
--## 
--## Finalidad: Borra TEX de tareas_notificaciones de decision
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
        V_SQL        VARCHAR2(12000 CHAR);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'HAYA02';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';
        USUARIO      VARCHAR2(50 CHAR):= 'MIGRA2HAYA02';
        
        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
  
        
BEGIN    
    ------------------
    --    TEX
    ------------------

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' EMPIEZA BORRADO DE TEX DE DECISION');
    
	V_SQL:='delete from '||V_ESQUEMA||'.tex_tarea_externa where tar_id in (select tar_id from '||V_ESQUEMA||
	       '.tar_tareas_notificaciones where tar_descripcion = ''Tarea toma de decisión'' AND usuariocrear = ''MIGRA2HAYA02'')';
	EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  BORRADOS DE TEX DE DECISION. '||SQL%ROWCOUNT||' Filas.');
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
