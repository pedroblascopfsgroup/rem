--##########################################
--## AUTOR=Enrique Jimenez Diaz
--## FECHA_CREACION=20151112
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-915
--## PRODUCTO=NO
--## 
--## Finalidad: Enganchar el motor de BPMs a los Procedimeintos Concursales.
--## INSTRUCCIONES:  
--## VERSIONES:
--##            0.1 Versión inicial
--##            0.2 Ajustes para Cajamar y Concursales.
--##   20151127 0.3 Actualizacion fechas vencimiento en tar_tareas_notificaciones
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

--  numberReg NUMBER(10);

  /* Consulta, procedimientos sin BPM */
  CURSOR CUR_PROCEDIMIENTOS IS 
  WITH BPM_DEFINITIONS AS (
    SELECT NAME_, MAX(ID_) ID_
    FROM CMMASTER.JBPM_PROCESSDEFINITION
    GROUP BY NAME_
  )
  , TAREAS AS (
    SELECT  PRC_ID, TAR_ID
    FROM TAR_TAREAS_NOTIFICACIONES
    WHERE (TAR_TAREA_FINALIZADA IS NULL OR TAR_TAREA_FINALIZADA = 0) AND BORRADO = 0
  ), FORK_NODE AS (
    select PROCESSDEFINITION_, 
      min(ID_) FORK_NODE
    from CMMASTER.jbpm_node 
    where class_='F' group by PROCESSDEFINITION_
  )
  SELECT PRC.PRC_ID, DEF.ID_ DEFINITION_ID, NODE.ID_ NODE_ID, TAP.TAP_CODIGO, TEX.TEX_ID, Fk.FORK_NODE
  FROM PRC_PROCEDIMIENTOS PRC
    JOIN PCO_PRC_PROCEDIMIENTOS PCO ON PRC.PRC_ID = PCO.PRC_ID    
    JOIN DD_TPO_TIPO_PROCEDIMIENTO TPO ON PRC.DD_TPO_ID = TPO.DD_TPO_ID
    JOIN BPM_DEFINITIONS DEF ON TPO.DD_TPO_XML_JBPM = DEF.NAME_
    JOIN TAREAS TAR ON PRC.PRC_ID = TAR.PRC_ID
    JOIN TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID
    JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
    JOIN CMMASTER.JBPM_NODE NODE ON DEF.ID_ = NODE.PROCESSDEFINITION_ AND TAP.TAP_CODIGO = NODE.NAME_
    left join FORK_NODE FK ON FK.PROCESSDEFINITION_=DEF.ID_
  WHERE PRC.PRC_PROCESS_BPM IS NULL
    -- and prc.prc_id  = 100047719 -- Procedimiento Precontencioso de prueba
    and PRC.usuariocrear = 'MIGRACM01PCO'
  ORDER BY PRC_ID;
  
  CURSOR CUR_PROCEDIMIENTOS2 IS
  SELECT PRC_ID, count(*) AS CUENTA FROM TMP_ALTA_BPM_INSTANCES group by PRC_ID having count(*)>1;
  
  TYPE T_PRC IS TABLE OF CUR_PROCEDIMIENTOS%ROWTYPE INDEX BY BINARY_INTEGER;
  L_PRC T_PRC;

  TYPE T_PRC2 IS TABLE OF CUR_PROCEDIMIENTOS2%ROWTYPE INDEX BY BINARY_INTEGER;
  L_PRC2 T_PRC2;
  
  ID_PROCEDIMIENTO NUMBER(16,0) := -1;
  ID_PROCEDIMIENTO_ACTUAL NUMBER(16,0);
  INSTANCE_ID_ NUMBER(16,0);
  CURRENT_NODE_ NUMBER(16,0);
  CURRENT_FORK_ NUMBER(16,0);
  CURRENT_TOKEN_ NUMBER(16,0);
  CURRENT_TOKEN_PADRE_ NUMBER(16,0);
  CURRENT_MODULE_ID_ NUMBER(16,0);
  CURRENT_VMAP_ID_ NUMBER(16,0);
  err_num NUMBER;
  err_msg VARCHAR2(2048 CHAR);
  /* Variables */
  V_DBID NUMBER(16);

  V_SQL           VARCHAR2(5000 CHAR);
  V_ESQUEMA       VARCHAR2(25 CHAR) := 'CM01';
  V_ESQUEMA_M     VARCHAR2(25 CHAR) := 'CMMASTER';  
  V_USUARIO_MIGRA VARCHAR2(25 CHAR) := 'MIGRACM01PCO';    
  
BEGIN

--  SELECT ENTIDAD_ID INTO V_DBID
--  FROM CMMASTER.ENTIDADCONFIG
--  WHERE DATAKEY = 'schema' AND UPPER(DATAVALUE) = 'CM01';
  
  V_SQL := 'SELECT ENTIDAD_ID 
            FROM '||V_ESQUEMA_M||'.ENTIDADCONFIG
            WHERE DATAKEY = ''schema'' AND UPPER(DATAVALUE) = '''||V_ESQUEMA||'''';
  
  EXECUTE IMMEDIATE V_SQL INTO V_DBID;

  --OPEN CUR_PROCEDIMIENTOS;

  /* ----- Reservamos id's objetos de BPM ------- */
  DELETE FROM TMP_ALTA_BPM_INSTANCES;
  
  
  /*------------ Cerramos conjunto de Asuntos a usar ---------------------- */
  V_SQL := 'UPDATE '||V_ESQUEMA||'.prc_procedimientos prc set  prc.prc_process_bpm = null 
            WHERE prc.prc_id IN (
                 select distinct prc.prc_id
                 from '||V_ESQUEMA||'.Prc_Procedimientos prc
                 inner join '||V_ESQUEMA||'.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id
                 inner join '||V_ESQUEMA||'.asu_asuntos asu on prc.asu_id = asu.asu_id 
                 where prc.usuariocrear = '''||V_USUARIO_MIGRA||'''
            )';

  EXECUTE IMMEDIATE V_SQL;                                
  COMMIT;  
  
  DBMS_OUTPUT.PUT_LINE('[INFO] prc_process_bpm = null en prc_procedimientos.');


  V_SQL := 'UPDATE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX2 set TEX2.TEX_TOKEN_ID_BPM=null
             WHERE TEX2.TEX_ID IN (
             SELECT tex.tex_id
             FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX
                INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
                INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TEX.TAR_ID = TAR.TAR_ID
                INNER JOIN '||V_ESQUEMA||'.prc_procedimientos prc ON tar.prc_id = prc.prc_id
                inner join '||V_ESQUEMA||'.pco_prc_procedimientos pco on prc.prc_id = pco.prc_id                
                inner join '||V_ESQUEMA||'.asu_asuntos asu on prc.asu_id = asu.asu_id 
                where prc.usuariocrear = '''||V_USUARIO_MIGRA||'''
              )';  

  EXECUTE IMMEDIATE V_SQL;    
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] TEX2.TEX_TOKEN_ID_BPM=null en TEX_TAREA_EXTERNA.');
  
    
  /*------------ CURSOR ---------------------- */

  DBMS_OUTPUT.PUT_LINE('Asigna las instancias...') ;
  FOR L_PRC in CUR_PROCEDIMIENTOS
  LOOP

    ID_PROCEDIMIENTO_ACTUAL:= L_PRC.PRC_ID;
    IF ID_PROCEDIMIENTO_ACTUAL<>ID_PROCEDIMIENTO THEN
      ID_PROCEDIMIENTO := ID_PROCEDIMIENTO_ACTUAL;
      INSTANCE_ID_ := CMMASTER.HIBERNATE_SEQUENCE.NEXTVAL;
    END IF;
    
    INSERT INTO TMP_ALTA_BPM_INSTANCES(PRC_ID, INST_ID,DEF_ID, NODE_ID, TAP_CODIGO, TEX_ID, FORK_NODE) 
    VALUES (L_PRC.PRC_ID, INSTANCE_ID_, L_PRC.DEFINITION_ID, L_PRC.NODE_ID, L_PRC.TAP_CODIGO, L_PRC.TEX_ID, L_PRC.FORK_NODE);
    

  --  SELECT COUNT(1) INTO numberReg FROM TMP_ALTA_BPM_INSTANCES;        
  --  DBMS_OUTPUT.PUT_LINE(L_PRC.PRC_ID || '--' || INSTANCE_ID_ || '--' || L_PRC.DEFINITION_ID|| '--' ||L_PRC.NODE_ID|| '--' ||L_PRC.TAP_CODIGO|| '--' ||L_PRC.TEX_ID|| '--' ||L_PRC.FORK_NODE) ;
  END LOOP;
  
  --  DBMS_OUTPUT.PUT_LINE('Instancias asignadas!!...'||numberReg) ;

  DBMS_OUTPUT.PUT_LINE('Asigna los nodos root...') ;
  FOR L_PRC2 in CUR_PROCEDIMIENTOS2
  LOOP

    ID_PROCEDIMIENTO_ACTUAL:= L_PRC2.PRC_ID;
    IF ID_PROCEDIMIENTO_ACTUAL<>ID_PROCEDIMIENTO THEN
      ID_PROCEDIMIENTO := ID_PROCEDIMIENTO_ACTUAL;
      CURRENT_TOKEN_PADRE_ := CMMASTER.HIBERNATE_SEQUENCE.NEXTVAL;
    END IF;

    UPDATE TMP_ALTA_BPM_INSTANCES
    SET
      TOKEN_PADRE_ID=CURRENT_TOKEN_PADRE_, 
      MODULE_PADRE_ID=CURRENT_TOKEN_PADRE_, 
      VMAP_PADRE_ID=CURRENT_TOKEN_PADRE_
    WHERE PRC_ID=ID_PROCEDIMIENTO_ACTUAL;
    
    --DBMS_OUTPUT.PUT_LINE(L_PRC.PRC_ID || '--' || INSTANCE_ID_ || '--' || L_PRC.DEFINITION_ID) ;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Asignados los nodos root!!') ;
 
  DBMS_OUTPUT.PUT_LINE('Asigna los IDs de token...') ;
  UPDATE TMP_ALTA_BPM_INSTANCES SET 
    TOKEN_ID = CMMASTER.HIBERNATE_SEQUENCE.NEXTVAL
    ,MODULE_ID=CMMASTER.HIBERNATE_SEQUENCE.NEXTVAL
    ,VMAP_ID = CMMASTER.HIBERNATE_SEQUENCE.NEXTVAL;
  DBMS_OUTPUT.PUT_LINE('IDs de token asignados...') ;

  DBMS_OUTPUT.PUT_LINE('Actualizando tokens padre...') ;
  
  UPDATE TMP_ALTA_BPM_INSTANCES SET 
    TOKEN_PADRE_ID = TOKEN_ID
    ,MODULE_PADRE_ID=MODULE_ID
    ,VMAP_PADRE_ID = VMAP_ID
    WHERE TOKEN_PADRE_ID IS NULL;
    
  DBMS_OUTPUT.PUT_LINE('Actualizando tokens padre!!') ;

  DBMS_OUTPUT.PUT_LINE('---------------------------------') ;
  DBMS_OUTPUT.PUT_LINE('COMIENZA LA INSERCION DE DATOS...') ;
  DBMS_OUTPUT.PUT_LINE('---------------------------------') ;


  DBMS_OUTPUT.PUT_LINE('Inserta las instancias...') ;
  INSERT INTO CMMASTER.JBPM_PROCESSINSTANCE
      (ID_, VERSION_, START_, END_, ISSUSPENDED_, PROCESSDEFINITION_)
  SELECT DISTINCT TMP.INST_ID -- ID_
          ,1 --VERSION
          , SYSDATE --START_
          ,NULL --END_
          , 0 --ISSUSPENDED_
          , TMP.DEF_ID --PRCESSDEFINITION_
  FROM TMP_ALTA_BPM_INSTANCES TMP;
  DBMS_OUTPUT.PUT_LINE('Instancias insertados!!') ;

  DBMS_OUTPUT.PUT_LINE('Insertando los root token...') ;
  INSERT INTO CMMASTER.JBPM_TOKEN
            (ID_, VERSION_, START_, END_, NODEENTER_, ISSUSPENDED_, NODE_, PROCESSINSTANCE_, NEXTLOGINDEX_,ISABLETOREACTIVATEPARENT_,ISTERMINATIONIMPLICIT_)
          select DISTINCT 
            TOKEN_PADRE_ID --ID
            , 1 --VERSION_
            , SYSDATE --START_
            , NULL --END_
            , SYSDATE --NODEENTER_
            , 0 --ISSUSPENDED_
            , FORK_NODE --_ NODE_
            , INST_ID  --PROCESSINSTANCE_
            ,0
            ,0
            ,0
      FROM TMP_ALTA_BPM_INSTANCES TMP WHERE TOKEN_PADRE_ID<>TOKEN_ID;
  DBMS_OUTPUT.PUT_LINE('Insertadoslos root token!!!') ;

  DBMS_OUTPUT.PUT_LINE('Insertando tokens...') ;
  INSERT INTO CMMASTER.JBPM_TOKEN
            (ID_, VERSION_, START_, END_, NODEENTER_, ISSUSPENDED_, NODE_, PROCESSINSTANCE_, PARENT_, NEXTLOGINDEX_,ISABLETOREACTIVATEPARENT_,ISTERMINATIONIMPLICIT_)
      SELECT TMP.TOKEN_ID
            , 1 --VERSION_
            , SYSDATE --START_
            , NULL --END_
            , SYSDATE --NODEENTER_
            , 0 --ISSUSPENDED_
            , TMP.NODE_ID --_ NODE_
            , TMP.INST_ID  --PROCESSINSTANCE_
            , TMP.TOKEN_PADRE_ID --PARENT_
            ,0
            ,0
            ,0
      FROM TMP_ALTA_BPM_INSTANCES TMP;


   UPDATE CMMASTER.Jbpm_Token SET parent_=null WHERE id_=parent_;
   
   MERGE INTO CMMASTER.Jbpm_Token T
   USING (
          select T.ID_, N.NAME_  from CMMASTER.Jbpm_Token T
          join CMMASTER.Jbpm_Node N on T.NODE_=N.ID_
          where T.name_ is null
          ) TMP
   ON (TMP.ID_=T.ID_)
   WHEN MATCHED THEN UPDATE SET T.NAME_=TMP.NAME_;

  DBMS_OUTPUT.PUT_LINE('TOKENS insertados...') ;

  DBMS_OUTPUT.PUT_LINE('Actualizando las instancias...') ;
  MERGE INTO CMMASTER.JBPM_PROCESSINSTANCE INS
  USING (SELECT DISTINCT INST_ID, TOKEN_PADRE_ID AS TOKEN FROM TMP_ALTA_BPM_INSTANCES) TMP
  ON (INS.ID_ = TMP.INST_ID)
  WHEN MATCHED THEN UPDATE SET INS.ROOTTOKEN_ = TMP.TOKEN;
  DBMS_OUTPUT.PUT_LINE('Instancias actualizadas!!');

    DBMS_OUTPUT.PUT_LINE('Actualizando las module y vmap...') ;
    INSERT INTO CMMASTER.JBPM_MODULEINSTANCE
            (ID_, CLASS_, VERSION_, PROCESSINSTANCE_, NAME_)
        SELECT  DISTINCT TMP.MODULE_PADRE_ID
            , 'C' --CLASS_
            , 0 --VERSION_
            , TMP.INST_ID --PROCESSINSTANCE_
            , 'org.jbpm.context.exe.ContextInstance' --NAME_
    FROM TMP_ALTA_BPM_INSTANCES TMP;

    INSERT INTO CMMASTER.JBPM_TOKENVARIABLEMAP
            (ID_, VERSION_, TOKEN_, CONTEXTINSTANCE_)
      SELECT DISTINCT TMP.VMAP_PADRE_ID
        , 0 --VERSION_
        , TMP.TOKEN_PADRE_ID --ROOTTOKEN_
        , TMP.MODULE_PADRE_ID  --CONTEXTINSTANCE_
    FROM TMP_ALTA_BPM_INSTANCES TMP;
  DBMS_OUTPUT.PUT_LINE('module y vmap actualizadas!!') ;

    DBMS_OUTPUT.PUT_LINE('Actualizando VARIABLE INSTABLE...') ;

    DBMS_OUTPUT.PUT_LINE('Insertamos la variable DB_ID para cada instancia..') ;
    INSERT INTO CMMASTER.JBPM_VARIABLEINSTANCE
        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT CMMASTER.HIBERNATE_SEQUENCE.NEXTVAL
      ,'L' --CLASS_
      , 0 --VERSION_
      , 'DB_ID' --NAME_
      , TMP.TOKEN_ID --TOKEM_
      , TMP.VMAP_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , V_DBID --LONGVLAUE_
    FROM (SELECT DISTINCT INST_ID, PRC_ID, TOKEN_PADRE_ID AS TOKEN_ID,MODULE_PADRE_ID AS MODULE_ID,VMAP_PADRE_ID AS VMAP_ID FROM TMP_ALTA_BPM_INSTANCES) TMP;

    DBMS_OUTPUT.PUT_LINE('Insertamos la variable procedimientoTareaExterna para cada instancia..') ;
    INSERT INTO CMMASTER.JBPM_VARIABLEINSTANCE
        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT CMMASTER.HIBERNATE_SEQUENCE.NEXTVAL
        ,'L' --CLASS_
        , 0 --VERSION_
        , 'procedimientoTareaExterna' --NAME_
        , TMP.TOKEN_ID --TOKEM_
        , TMP.VMAP_ID  --TOKENVARIABLEMAP_
        , TMP.INST_ID --PROCESSINSTANCE_
        , TMP.PRC_ID --LONGVLAUE_
    FROM (SELECT DISTINCT INST_ID, PRC_ID, TOKEN_PADRE_ID AS TOKEN_ID,MODULE_PADRE_ID AS MODULE_ID,VMAP_PADRE_ID AS VMAP_ID FROM TMP_ALTA_BPM_INSTANCES) TMP;

    DBMS_OUTPUT.PUT_LINE('Insertamos la variable bpmParalizado para cada instancia..') ;
    INSERT INTO CMMASTER.JBPM_VARIABLEINSTANCE
        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT CMMASTER.HIBERNATE_SEQUENCE.NEXTVAL
      ,'L' --CLASS_
      , 0 --VERSION_
      , 'bpmParalizado' --NAME_
      , TMP.TOKEN_ID --TOKEM_
      , TMP.VMAP_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , 0 --LONGVLAUE_
    FROM (SELECT DISTINCT INST_ID, PRC_ID, TOKEN_PADRE_ID AS TOKEN_ID,MODULE_PADRE_ID AS MODULE_ID,VMAP_PADRE_ID AS VMAP_ID FROM TMP_ALTA_BPM_INSTANCES) TMP;

    DBMS_OUTPUT.PUT_LINE('Insertamos la variable idCODIGOTAREA para cada instancia..') ;
    INSERT INTO CMMASTER.JBPM_VARIABLEINSTANCE
        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT CMMASTER.HIBERNATE_SEQUENCE.NEXTVAL
      ,'L' --CLASS_
      , 0 --VERSION_
      , 'id'||TMP.TAP_CODIGO||'.'||TMP.TOKEN_PADRE_ID --NAME_
      , TMP.TOKEN_PADRE_ID --TOKEM_
      , TMP.VMAP_PADRE_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , TMP.TEX_ID --LONGVLAUE_
    FROM TMP_ALTA_BPM_INSTANCES TMP;
  DBMS_OUTPUT.PUT_LINE('FIN VARIABLE INSTANCE!!') ;

--Insertamos variable sin concatenar TOKEN_PADRE_ID    
  
    INSERT INTO CMMASTER.JBPM_VARIABLEINSTANCE
        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT CMMASTER.HIBERNATE_SEQUENCE.NEXTVAL
      ,'L' --CLASS_
      , 0 --VERSION_
      , 'id'||TMP.TAP_CODIGO --||'.'||TMP.TOKEN_PADRE_ID --NAME_
      , TMP.TOKEN_PADRE_ID --TOKEM_
      , TMP.VMAP_PADRE_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , TMP.TEX_ID --LONGVLAUE_va
    FROM TMP_ALTA_BPM_INSTANCES TMP;
  DBMS_OUTPUT.PUT_LINE('FIN VARIABLE INSTANCE!!') ;  
  
  
  DBMS_OUTPUT.PUT_LINE('Actualizando los procedimientos...') ;
  MERGE INTO PRC_PROCEDIMIENTOS PRC
  USING (SELECT DISTINCT PRC_ID,INST_ID FROM TMP_ALTA_BPM_INSTANCES) TMP
  ON (PRC.PRC_ID = TMP.PRC_ID)
  WHEN MATCHED THEN UPDATE SET PRC.PRC_PROCESS_BPM = TMP.INST_ID
    ,USUARIOMODIFICAR = 'AUTO', fechamodificar = sysdate;
  DBMS_OUTPUT.PUT_LINE('Procedimientos actualizados!!!') ;

  DBMS_OUTPUT.PUT_LINE('Actualizando las TEX...') ;
  MERGE INTO TEX_TAREA_EXTERNA TEX
  USING (SELECT * FROM TMP_ALTA_BPM_INSTANCES) TMP
  ON (TEX.TEX_ID = TMP.TEX_ID)
  WHEN MATCHED THEN UPDATE SET TEX.TEX_TOKEN_ID_BPM = TMP.TOKEN_ID
    ,USUARIOMODIFICAR = 'AUTO', fechamodificar = sysdate;
  DBMS_OUTPUT.PUT_LINE('TEX actualizadas...') ;

  COMMIT;

-- select PROCESSINSTANCE_, count(*) from CMMASTER.JBPM_VARIABLEINSTANCE where NAME_='DB_ID' group by PROCESSINSTANCE_ having count(*)>1 
--select count(*) from TMP_ALTA_BPM_INSTANCES;
--select prc_id, count(*) from TMP_ALTA_BPM_INSTANCES group by prc_id having count(*)>1;
-- select * from TMP_ALTA_BPM_INSTANCES where prc_id=1000000000066843;
-- select count(distinct token_padre_id) from TMP_ALTA_BPM_INSTANCES 

--select * from prc_procedimientos where prc_id=1000000000066843
--select * from CMMASTER.Jbpm_Variableinstance where processinstance_=164046426

--Actualizamos fechas vencimiento en tar_tareas_notificaciones

  V_SQL := 'UPDATE '||V_ESQUEMA||'.tar_tareas_notificaciones
               SET tar_fecha_venc = SYSDATE + (DBMS_RANDOM.VALUE (1, 5))
             WHERE fechacrear > SYSDATE - 1
               AND tar_fecha_venc IS NULL
               AND prc_id IS NOT NULL
               AND tar_tarea_finalizada = 0
               AND tar_tar_id IS NULL
               AND USUARIOCREAR = '''||V_USUARIO_MIGRA||'''';
            --   and prc_id = 100047719;

   EXECUTE IMMEDIATE V_SQL;            
   COMMIT ;



  V_SQL := 'UPDATE '||V_ESQUEMA||'.tar_tareas_notificaciones
               SET tar_fecha_venc_real = tar_fecha_venc
             WHERE tar_fecha_venc IS NOT NULL AND tar_fecha_venc_real IS NULL
             AND USUARIOCREAR = '''||V_USUARIO_MIGRA||'''';
            --  and prc_id = 100047719;

 EXECUTE IMMEDIATE V_SQL;               
 COMMIT ;


EXCEPTION
WHEN OTHERS THEN
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);

  ROLLBACK;
  RAISE;
  
END;
/
EXIT;
