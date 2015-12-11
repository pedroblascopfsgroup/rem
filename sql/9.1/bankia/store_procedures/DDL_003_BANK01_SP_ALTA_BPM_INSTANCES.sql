--/*
--##########################################
--## AUTOR=David González
--## FECHA_CREACION=20151027
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.3
--## INCIDENCIA_LINK=BKREC-1114
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        	0.1 Versión inicial
--##		0.2 Adaptacion a plantilla
--##		
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
create or replace PROCEDURE ALTA_BPM_INSTANCES AS

  --/* Consulta, procedimientos sin BPM */
  CURSOR CUR_PROCEDIMIENTOS IS
  WITH BPM_DEFINITIONS AS (
    SELECT NAME_, MAX(ID_) ID_
    FROM #ESQUEMA_MASTER#.JBPM_PROCESSDEFINITION
    GROUP BY NAME_
  )
  , TAREAS AS (
    SELECT PRC_ID, TAR_ID, USUARIOCREAR FROM #ESQUEMA#.TAR_TAREAS_NOTIFICACIONES
    WHERE (TAR_TAREA_FINALIZADA IS NULL OR TAR_TAREA_FINALIZADA = 0) AND BORRADO = 0
      AND PRC_ID IS NOT NULL
      AND TAR_CODIGO = 1
      AND TAR_ID NOT IN (
        SELECT TAR_ID FROM #ESQUEMA#.TEX_TAREA_EXTERNA WHERE BORRADO = 0 GROUP BY TAR_ID HAVING COUNT(DISTINCT TAP_ID) > 1
      )
  )
  , PROCEDIMIENTOS AS (
    SELECT PRC.PRC_ID, PRC.DD_TPO_ID
    FROM #ESQUEMA#.PRC_PROCEDIMIENTOS PRC
      JOIN #ESQUEMA#.TAREAS TAR ON PRC.PRC_ID = TAR.PRC_ID AND PRC.USUARIOCREAR = TAR.USUARIOCREAR
    WHERE PRC.PRC_PROCESS_BPM IS NULL AND PRC.BORRADO = 0
    GROUP BY PRC.PRC_ID, PRC.DD_TPO_ID
    HAVING COUNT(TAR.TAR_ID) = 1
  )
  SELECT PRC.PRC_ID, DEF.ID_ DEFINITION_ID, NODE.ID_ NODE_ID, TAP.TAP_CODIGO, TEX.TEX_ID
  FROM #ESQUEMA#.PROCEDIMIENTOS PRC
    JOIN #ESQUEMA#.DD_TPO_TIPO_PROCEDIMIENTO TPO ON PRC.DD_TPO_ID = TPO.DD_TPO_ID
    JOIN #ESQUEMA#.BPM_DEFINITIONS DEF ON TPO.DD_TPO_XML_JBPM = DEF.NAME_
    JOIN #ESQUEMA#.TAREAS TAR ON PRC.PRC_ID = TAR.PRC_ID
    JOIN #ESQUEMA#.TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID AND TEX.BORRADO = 0
    JOIN #ESQUEMA#.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
    JOIN #ESQUEMA_MASTER#.JBPM_NODE NODE ON DEF.ID_ = NODE.PROCESSDEFINITION_ AND TAP.TAP_CODIGO = NODE.NAME_;

  TYPE T_PRC IS TABLE OF CUR_PROCEDIMIENTOS%ROWTYPE INDEX BY BINARY_INTEGER;
  L_PRC T_PRC;

  --/* Variables */
  V_DBID NUMBER(16);
  
BEGIN
/* v0.3 */

  SELECT ENTIDAD_ID INTO V_DBID
  FROM #ESQUEMA_MASTER#.ENTIDADCONFIG
  WHERE DATAKEY = 'schema' AND UPPER(DATAVALUE) = '#ESQUEMA#';

  --/* ----- Reservamos id's objetos de BPM ------- */
  EXECUTE IMMEDIATE 'TRUNCATE TABLE  #ESQUEMA#.TMP_ALTA_BPM_INSTANCES';

  OPEN CUR_PROCEDIMIENTOS;
  LOOP
    FETCH CUR_PROCEDIMIENTOS BULK COLLECT INTO L_PRC LIMIT 1000;

    FORALL I IN 1..L_PRC.COUNT
    INSERT INTO #ESQUEMA#.TMP_ALTA_BPM_INSTANCES(PRC_ID, DEF_ID, NODE_ID, TAP_CODIGO, TEX_ID, INST_ID, TOKEN_ID, MODULE_ID, VMAP_ID)
    VALUES (L_PRC(I).PRC_ID, L_PRC(I).DEFINITION_ID, L_PRC(I).NODE_ID, L_PRC(I).TAP_CODIGO, L_PRC(I).TEX_ID
      , #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL, #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.CURRVAL, #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.CURRVAL, #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.CURRVAL);


    EXIT WHEN CUR_PROCEDIMIENTOS%NOTFOUND;
  END LOOP;
  CLOSE CUR_PROCEDIMIENTOS;

    --/* ----- Insertamos instancia de BPM ------- */
    INSERT INTO #ESQUEMA_MASTER#.JBPM_PROCESSINSTANCE
        (ID_, VERSION_, START_, END_, ISSUSPENDED_, PROCESSDEFINITION_)
    SELECT TMP.INST_ID -- ID_
            ,1 --VERSION
            , SYSDATE --START_
            ,NULL --END_
            , 0 --ISSUSPENDED_
            , TMP.DEF_ID --PRCESSDEFINITION_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES TMP;

    --/* ----- Insertamos el token para la instancia ------- */
    INSERT INTO #ESQUEMA_MASTER#.JBPM_TOKEN
              (ID_, VERSION_, START_, END_, NODEENTER_, ISSUSPENDED_, NODE_, PROCESSINSTANCE_, NEXTLOGINDEX_,ISABLETOREACTIVATEPARENT_,ISTERMINATIONIMPLICIT_)
        SELECT TMP.TOKEN_ID
              , 1 --VERSION_
              , SYSDATE --START_
              , NULL --END_
              , SYSDATE --NODEENTER_
              , 0 --ISSUSPENDED_
              , TMP.NODE_ID --_ NODE_
              , TMP.INST_ID  --PROCESSINSTANCE_
              ,0
              ,0
              ,0
    FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES TMP;

    --/* ----- Actualizamos el roottoken en cada instancia ------- */
    MERGE INTO #ESQUEMA_MASTER#.JBPM_PROCESSINSTANCE INS
    USING (SELECT * FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES) TMP
    ON (INS.ID_ = TMP.INST_ID)
    WHEN MATCHED THEN UPDATE SET INS.ROOTTOKEN_ = TMP.TOKEN_ID;

    --/* ----- Actualizamos el id de instancia en el procedimiento ------- */
    MERGE INTO #ESQUEMA#.PRC_PROCEDIMIENTOS PRC
    USING (SELECT * FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES) TMP
    ON (PRC.PRC_ID = TMP.PRC_ID)
    WHEN MATCHED THEN UPDATE SET PRC.PRC_PROCESS_BPM = TMP.INST_ID
      ,USUARIOMODIFICAR = 'AUTO', fechamodificar = sysdate;

    --/* ----- Actualizamos el id de instancia en el procedimiento ------- */
    MERGE INTO #ESQUEMA#.TEX_TAREA_EXTERNA TEX
    USING (SELECT * FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES) TMP
    ON (TEX.TEX_ID = TMP.TEX_ID)
    WHEN MATCHED THEN UPDATE SET TEX.TEX_TOKEN_ID_BPM = TMP.TOKEN_ID
      ,USUARIOMODIFICAR = 'AUTO', fechamodificar = sysdate;

    --/* ----- Insertamos el moduleinstance para cada instancia ------- */
    INSERT INTO #ESQUEMA_MASTER#.JBPM_MODULEINSTANCE
            (ID_, CLASS_, VERSION_, PROCESSINSTANCE_, NAME_)
        SELECT  TMP.MODULE_ID
            , 'C' --CLASS_
            , 0 --VERSION_
            , TMP.INST_ID --PROCESSINSTANCE_
            , 'org.jbpm.context.exe.ContextInstance' --NAME_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES TMP;

    --/* ----- Insertamos el variablemap para cada instancia ------- */
    INSERT INTO #ESQUEMA_MASTER#.JBPM_TOKENVARIABLEMAP
            (ID_, VERSION_, TOKEN_, CONTEXTINSTANCE_)
      SELECT TMP.VMAP_ID
        , 0 --VERSION_
        , TMP.TOKEN_ID --ROOTTOKEN_
        , TMP.MODULE_ID  --CONTEXTINSTANCE_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES TMP;

    --/* ----- Insertamos la variable DB_ID para cada instancia ------- */
    INSERT INTO #ESQUEMA_MASTER#.JBPM_VARIABLEINSTANCE
        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL
      ,'L' --CLASS_
      , 0 --VERSION_
      , 'DB_ID' --NAME_
      , TMP.TOKEN_ID --TOKEM_
      , TMP.VMAP_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , V_DBID --LONGVLAUE_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES TMP;

    --/* ----- Insertamos la variable procedimientoTareaExterna para cada instancia ------- */
    INSERT INTO #ESQUEMA_MASTER#.JBPM_VARIABLEINSTANCE
        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL
      ,'L' --CLASS_
      , 0 --VERSION_
      , 'procedimientoTareaExterna' --NAME_
      , TMP.TOKEN_ID --TOKEM_
      , TMP.VMAP_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , TMP.PRC_ID --LONGVLAUE_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES TMP;

    --/* ----- Insertamos la variable bpmParalizado para cada instancia ------- */
    INSERT INTO #ESQUEMA_MASTER#.JBPM_VARIABLEINSTANCE
        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL
      ,'L' --CLASS_
      , 0 --VERSION_
      , 'bpmParalizado' --NAME_
      , TMP.TOKEN_ID --TOKEM_
      , TMP.VMAP_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , 0 --LONGVLAUE_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES TMP;

    --/* ----- Insertamos la variable idCODIGOTAREA para cada instancia ------- */
    INSERT INTO #ESQUEMA_MASTER#.JBPM_VARIABLEINSTANCE
        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL
      ,'L' --CLASS_
      , 0 --VERSION_
      , 'id'||TMP.TAP_CODIGO --NAME_
      , TMP.TOKEN_ID --TOKEM_
      , TMP.VMAP_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , TMP.TEX_ID --LONGVLAUE_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES TMP;

    COMMIT;

    EXCEPTION
     WHEN OTHERS THEN

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(SQLERRM);
          ROLLBACK;
          RAISE;

END ALTA_BPM_INSTANCES;
/

EXIT;
