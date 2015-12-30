/***************************************/
-- PARALIZAR PROCEDIMIENTOS PRECONTENCIOSO CAJAMAR (BCC)
-- Creador: Gustavo Mora Navarro 
-- Modificador: 
-- Fecha: 28/12/2015
-- Modificacion: 
--          GMN:> Versión Inicial
/***************************************/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
set timing ON
set linesize 2000
SET VERIFY OFF
set feedback on

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    USUARIO_C varchar2(20 CHAR) := 'MIGRACM01PCO';    
    USUARIO_M varchar2(20 CHAR) := 'PARAMIGRACM01PCO';

/********************************************************/
/**       Se paralizan los procedimientos y tareas    **/
/*******************************************************/

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INICIO] CJM_migracion_paraliza_procedimientos_precontencioso.sql');  


-- PARALIZAMOS EL PROCEDIMIENTO

   V_SQL:= 'UPDATE '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS SET USUARIOMODIFICAR = '''||USUARIO_M||'''
                                             , FECHAMODIFICAR =  TO_TIMESTAMP(sysdate,''DD/MM/YYYY fmHH24fm:MI:SS.FF'')
                                             , PRC_FECHA_PARALIZADO = TO_TIMESTAMP(sysdate,''DD/MM/YYYY fmHH24fm:MI:SS.FF'')
                                             , PRC_PARALIZADO = 1 
            WHERE PRC_ID IN (select PRC.PRC_ID
                             from '||V_ESQUEMA||'.MIG_EXPEDIENTES_CABECERA cab
                                , '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP
                                , '||V_ESQUEMA||'.ASU_ASUNTOS asu
                                , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc
                             where exp.CD_EXPEDIENTE_NUSE  = cab.cd_expediente
                               and exp.exp_id              = asu.exp_id 
                               and asu.asu_id              = prc.asu_id
                               and cab.fecha_paralizacion is not null
                               and cab.motivo_paralizacion = ''PARALIZADO''
                               and exp.usuariocrear        = '''||USUARIO_C||''')';

                   
     EXECUTE IMMEDIATE V_SQL;

     DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);                   
                   
-- PARALIZAMOS LAS TAREAS

   V_SQL:= 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET USUARIOMODIFICAR = '''||USUARIO_M||'''
                                        , FECHAMODIFICAR = TO_TIMESTAMP(sysdate,''DD/MM/YYYY fmHH24fm:MI:SS.FF'')
                                        , BORRADO = 1 
            WHERE TAR_CODIGO = 1
              AND PRC_ID IN (SELECT PRC_ID FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS WHERE USUARIOMODIFICAR = '''||USUARIO_M||''')';

     EXECUTE IMMEDIATE V_SQL;

     DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);                    
              
-- PARALIZAMOS LAS TAREAS_EXTERNAS

   V_SQL:= 'UPDATE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA SET  USUARIOMODIFICAR = '''||USUARIO_M||'''
                                             , FECHAMODIFICAR = TO_TIMESTAMP(sysdate,''DD/MM/YYYY fmHH24fm:MI:SS.FF'')
                                             , TEX_DETENIDA = 1 
            WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES WHERE USUARIOMODIFICAR = '''||USUARIO_M||''')';


     EXECUTE IMMEDIATE V_SQL;

     DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);                  
            
-- CREAMOS LAS DECISIONES

   V_SQL:= 'INSERT INTO '||V_ESQUEMA||'.DPR_DECISIONES_PROCEDIMIENTOS (
                                                      DPR_ID, PRC_ID , TAR_ID, DPR_FINALIZA, DPR_PARALIZA, DD_DPA_ID,DD_EDE_ID, DPR_PROCESS_BPM,
                                                      DPR_FECHA_PARA, DPR_COMENTARIOS, USUARIOCREAR, FECHACREAR
                                                      ) 
            SELECT
                S_DPR_DEC_PROCEDIMIENTOS.NEXTVAL dpr_id,
                PRC.PRC_ID prc_id, 
                NULL tar_id, 
                0 as dpr_finaliza, 
                1 as dpr_paraliza, 
                (select DD_DPA_ID from  '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR      where DD_DPA_CODIGO = ''RD'') as dd_dpa_id,    --> Causa de decisión PDTE RESOLUCIÓN OTRAS OPERACIONES
                (select DD_EDE_ID from  '||V_ESQUEMA_MASTER||'.DD_EDE_ESTADOS_DECISION where DD_EDE_CODIGO = ''02'')   as dd_ede_id,  --> Estado ACEPTADO
                NULL dpr_process_bpm, 
                 TO_TIMESTAMP(sysdate + 700,''DD/MM/YYYY fmHH24fm:MI:SS.FF'') dpr_fecha_para, -- Fecha hasta la que paralizar
                ''PDTE RESOLUCIÓN OTRAS OPERACIONES'',
                '''||USUARIO_C||''', 
                TO_TIMESTAMP(sysdate,''DD/MM/YYYY fmHH24fm:MI:SS.FF'')
            FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC 
                WHERE USUARIOMODIFICAR = '''||USUARIO_M||'''';

     EXECUTE IMMEDIATE V_SQL;

     DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);      
                
                
-- CREAMOS LOS PROCEDIMIENTOS DERIVADOS

   V_SQL:= 'INSERT INTO '||V_ESQUEMA||'.PRD_PROCEDIMIENTOS_DERIVADOS
                        (
                           PRD_ID
                         , PRC_ID
                         , DPR_ID
                         , USUARIOCREAR
                         , FECHACREAR
                         , BORRADO
                         ) 
            SELECT
                S_PRD_PROCED_DERIVADOS.NEXTVAL as PRD_ID,
                DPR.PRC_ID as PRC_ID, 
                DPR.DPR_ID as DPR_ID, 
                '''||USUARIO_C||''' as USUARIOCREAR,
                TO_TIMESTAMP(sysdate,''DD/MM/YYYY fmHH24fm:MI:SS.FF'') as FECHACREAR,
                0 as BORRADO                
            FROM '||V_ESQUEMA||'.DPR_DECISIONES_PROCEDIMIENTOS DPR
                WHERE DPR.DPR_COMENTARIOS = ''PDTE RESOLUCIÓN OTRAS OPERACIONES''';

     EXECUTE IMMEDIATE V_SQL;

     DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);      
                
    
-- INSERTAMOS LOS PARALIZADOS EN PCO_PRC_HEP_HISTOR_EST_PREP

/*************************************/
/** INSERTAR ESTADO PARALIZADO         **/
/*************************************/

       V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP (PCO_PRC_HEP_ID, PCO_PRC_ID, DD_PCO_PEP_ID, PCO_PRC_HEP_FECHA_INCIO, USUARIOCREAR, FECHACREAR, SYS_GUID)
                                SELECT '||V_ESQUEMA||'.S_PCO_PRC_HEP_HIST_EST_PREP.NEXTVAL, 
                                           PCO_PRC_ID,
                                           (SELECT DD_PCO_PEP_ID FROM  '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''PA'') ,-- PARALIZADO
                                           PRC_FECHA_PARALIZADO AS PRC_HEP_FECHA_INICIO,
                                           '''||USUARIO_C||''' AS USUARIOCREAR,
                                           SYSDATE, SYS_GUID() AS SYS_GUID
                                FROM(
                                     SELECT PCO.PCO_PRC_ID, PRC.PRC_FECHA_PARALIZADO
                                     FROM '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
                                        , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
                                        , '||V_ESQUEMA||'.MIG_EXPEDIENTES_CABECERA EXP
                                     WHERE PCO.PRC_ID = PRC.PRC_ID
                                       AND PCO.PCO_PRC_NUM_EXP_EXT = EXP.CD_EXPEDIENTE
                                       AND NOT EXISTS(SELECT 1
                                               FROM '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_CABECERA CAB
                                               WHERE CAB.CD_EXPEDIENTE_NUSE = EXP.CD_EXPEDIENTE)
                                       AND EXP.FECHA_PARALIZACION IS NOT NULL
                                       AND EXP.MOTIVO_PARALIZACION = ''PARALIZADO'')';

      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

      
/**************************************************/
/*******   ACTUALIZAMOS FECHA FIN EN PARALIZADOS  */
/**************************************************/
      v_SQL:= 'UPDATE '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP
               SET PCO_PRC_HEP_FECHA_FIN =  TO_TIMESTAMP(sysdate,''DD/MM/YYYY fmHH24fm:MI:SS.FF'')
               WHERE DD_PCO_PEP_ID <> (SELECT DD_PCO_PEP_ID FROM  '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''PA'') 
                 AND PCO_PRC_ID IN (SELECT PCO.PCO_PRC_ID
                                     FROM '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
                                        , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
                                        , '||V_ESQUEMA||'.MIG_EXPEDIENTES_CABECERA EXP
                                     WHERE PCO.PRC_ID = PRC.PRC_ID
                                       AND PCO.PCO_PRC_NUM_EXP_EXT = EXP.CD_EXPEDIENTE
                                       AND NOT EXISTS(SELECT 1
                                               FROM '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_CABECERA CAB
                                               WHERE CAB.CD_EXPEDIENTE_NUSE = EXP.CD_EXPEDIENTE)
                                       AND EXP.FECHA_PARALIZACION IS NOT NULL
                                       AND EXP.MOTIVO_PARALIZACION = ''PARALIZADO'')';


      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);                                       

      
 -- CREAMOS LAS VARIABLES DEL BMP (SOLO SE CREARAN PARA LAS TAREAS NO FICTICIAS)

-- 1


--   V_SQL:= 'INSERT INTO '||V_ESQUEMA_MASTER||'.JBPM_VARIABLEINSTANCE
--               (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
--            SELECT
--                '||V_ESQUEMA_MASTER||'.hibernate_sequence.nextval,
--                ''L'',
--                0,
--                ''idP01_AutoDespachandoEjecucion'',
--                TEX.TEX_TOKEN_ID_BPM,
--                null, --MAP.ID_,
--                PRC.PRC_PROCESS_BPM,
--                TEX.TEX_ID
--            FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
--                JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON PRC.PRC_ID = TAR.PRC_ID
--                JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID
----                JOIN '||V_ESQUEMA_MASTER||'.JBPM_TOKENVARIABLEMAP MAP ON TEX.TEX_TOKEN_ID_BPM = MAP.TOKEN_
--                WHERE PRC.USUARIOMODIFICAR = '''||USUARIO_M||'''';
--
--     EXECUTE IMMEDIATE V_SQL;
--
--     DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);                                   
---- 2
--
--   V_SQL:= 'INSERT INTO '||V_ESQUEMA_MASTER||'.JBPM_VARIABLEINSTANCE
--               (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
--            SELECT
--                '||V_ESQUEMA_MASTER||'.hibernate_sequence.nextval,
--                ''L'',
--                0,
--                ''DB_ID'',
--                TEX.TEX_TOKEN_ID_BPM,
--                null, --MAP.ID_,
--                PRC.PRC_PROCESS_BPM,
--                1
--            FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
--                JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON PRC.PRC_ID = TAR.PRC_ID
--                JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID
----                JOIN '||V_ESQUEMA_MASTER||'.JBPM_TOKENVARIABLEMAP MAP ON TEX.TEX_TOKEN_ID_BPM = MAP.TOKEN_
--                WHERE PRC.USUARIOMODIFICAR = '''||USUARIO_M||'''';
--
--     EXECUTE IMMEDIATE V_SQL;
--
--     DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);                   
--     
---- 3
--    
--   V_SQL:= 'INSERT INTO '||V_ESQUEMA_MASTER||'.JBPM_VARIABLEINSTANCE
--               (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
--            SELECT
--                '||V_ESQUEMA_MASTER||'.hibernate_sequence.nextval,
--                ''L'',
--                0,
--                ''procedimientoTareaExterna'',
--                TEX.TEX_TOKEN_ID_BPM,
--                null, --MAP.ID_,
--                PRC.PRC_PROCESS_BPM,
--                PRC.PRC_ID
--            FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
--                JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON PRC.PRC_ID = TAR.PRC_ID
--                JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID
----                JOIN '||V_ESQUEMA_MASTER||'.JBPM_TOKENVARIABLEMAP MAP ON TEX.TEX_TOKEN_ID_BPM = MAP.TOKEN_
--                WHERE PRC.USUARIOMODIFICAR = '''||USUARIO_M||'''';
--
--     EXECUTE IMMEDIATE V_SQL;
--
--     DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);                   
--                
---- 4
--    
--   V_SQL:= 'INSERT INTO '||V_ESQUEMA_MASTER||'.JBPM_VARIABLEINSTANCE
--               (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
--            SELECT
--                '||V_ESQUEMA_MASTER||'.hibernate_sequence.nextval,
--                ''L'',
--                1,
--                ''bpmParalizado'',
--                TEX.TEX_TOKEN_ID_BPM,
--                null, --MAP.ID_,
--                PRC.PRC_PROCESS_BPM,
--                1
--            FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
--                JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON PRC.PRC_ID = TAR.PRC_ID
--                JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID
--                JOIN '||V_ESQUEMA_MASTER||'.JBPM_TOKENVARIABLEMAP MAP ON TEX.TEX_TOKEN_ID_BPM = MAP.TOKEN_
--                WHERE PRC.USUARIOMODIFICAR = '''||USUARIO_M||'''';
--
--     EXECUTE IMMEDIATE V_SQL;
--
--     DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);                   
--                
---- 5
--    
--   V_SQL:= 'INSERT INTO '||V_ESQUEMA_MASTER||'.JBPM_VARIABLEINSTANCE
--               (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, DATEVALUE_)
--            SELECT
--                '||V_ESQUEMA_MASTER||'.hibernate_sequence.nextval,
--                ''D'',
--                0,
--                ''fechaAplazamientoTareas'',
--                TEX.TEX_TOKEN_ID_BPM,
--                null, --MAP.ID_,
--                PRC.PRC_PROCESS_BPM,
--                DPR.DPR_FECHA_PARA
--            FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
--                JOIN '||V_ESQUEMA||'.DPR_DECISIONES_PROCEDIMIENTOS DPR ON PRC.PRC_ID = DPR.PRC_ID
--                JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON PRC.PRC_ID = TAR.PRC_ID
--                JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID
--                JOIN '||V_ESQUEMA_MASTER||'.JBPM_TOKENVARIABLEMAP MAP ON TEX.TEX_TOKEN_ID_BPM = MAP.TOKEN_
--                WHERE PRC.USUARIOMODIFICAR = '''||USUARIO_M||'''';
--
--     EXECUTE IMMEDIATE V_SQL;
--
--     DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);                   
--     
---- 6
--    
--   V_SQL:= 'INSERT INTO '||V_ESQUEMA_MASTER||'.JBPM_VARIABLEINSTANCE
--               (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, STRINGVALUE_)
--            SELECT
--                '||V_ESQUEMA_MASTER||'.hibernate_sequence.nextval,
--                ''S'',
--                0,
--                ''NOMBRE_NODO_SALIENTE'',
--                TEX.TEX_TOKEN_ID_BPM,
--                null, --MAP.ID_,
--                PRC.PRC_PROCESS_BPM,
--                TAP_CODIGO
--            FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
--                JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON PRC.PRC_ID = TAR.PRC_ID
--                JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID
--                JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
--                JOIN '||V_ESQUEMA_MASTER||'.JBPM_TOKENVARIABLEMAP MAP ON TEX.TEX_TOKEN_ID_BPM = MAP.TOKEN_
--                WHERE PRC.USUARIOMODIFICAR = '''||USUARIO_M||'''';
--
--     EXECUTE IMMEDIATE V_SQL;
--
--     DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);                   
--     
---- 7
--    
--   V_SQL:= 'INSERT INTO '||V_ESQUEMA_MASTER||'.JBPM_VARIABLEINSTANCE
--               (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, DATEVALUE_)
--            SELECT
--                '||V_ESQUEMA_MASTER||'.hibernate_sequence.nextval,
--                ''D'',
--                0,
--                ''PROfechaParalizacionTareas'',
--                TEX.TEX_TOKEN_ID_BPM,
--                null, --MAP.ID_,
--                PRC.PRC_PROCESS_BPM,
--                TO_TIMESTAMP(sysdate,''DD/MM/YYYY fmHH24fm:MI:SS.FF'')
--            FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
--                JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON PRC.PRC_ID = TAR.PRC_ID
--                JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID
--                JOIN '||V_ESQUEMA_MASTER||'.JBPM_TOKENVARIABLEMAP MAP ON TEX.TEX_TOKEN_ID_BPM = MAP.TOKEN_
--                WHERE PRC.USUARIOMODIFICAR = '''||USUARIO_M||'''';
--
--     EXECUTE IMMEDIATE V_SQL;
--
--     DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);                                   

  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN] CJM_migracion_paraliza_procedimientos_precontencioso.sql');        
   
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/

EXIT;
