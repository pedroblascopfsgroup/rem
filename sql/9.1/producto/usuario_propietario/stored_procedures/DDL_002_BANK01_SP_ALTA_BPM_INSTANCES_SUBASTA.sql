--/*
--##########################################
--## AUTOR=Rubén Rovira
--## FECHA_CREACION=20151027
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.2
--## INCIDENCIA_LINK=BKREC-58
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

create or replace PROCEDURE ALTA_BPM_INSTANCES_SUBASTAS AUTHID CURRENT_USER AS
  --/* Consulta, procedimientos sin BPM */
  CURSOR CUR_PROCEDIMIENTOS IS
  WITH BPM_DEFINITIONS AS (
    SELECT NAME_, MAX(ID_) ID_
    FROM #ESQUEMA_MASTER#.JBPM_PROCESSDEFINITION
    GROUP BY NAME_
  )
  , TAP AS (
    SELECT TAP_ID, TAP_CODIGO FROM #ESQUEMA#.TAP_TAREA_PROCEDIMIENTO
    WHERE TAP_CODIGO LIKE '%CelebracionSubasta'
      OR TAP_CODIGO LIKE '%AdjuntarInformeSubasta'
      OR TAP_CODIGO LIKE '%PrepararPropuestaSubasta'
  )
  , TEX AS (
    SELECT TEX.TEX_ID, TEX.TAR_ID, TAP.TAP_CODIGO
    FROM #ESQUEMA#.TEX_TAREA_EXTERNA TEX
      JOIN TAP ON TEX.TAP_ID = TAP.TAP_ID
    WHERE TEX.BORRADO = 0
    GROUP BY TEX.TEX_ID, TEX.TAR_ID, TAP.TAP_CODIGO
    HAVING COUNT(1) = 1
  )
  , TAREAS AS (
    SELECT TAR.PRC_ID, TAR.TAR_ID, TAR.USUARIOCREAR, TEX.TEX_ID, TEX.TAP_CODIGO
    FROM #ESQUEMA#.TAR_TAREAS_NOTIFICACIONES TAR
      JOIN TEX ON TAR.TAR_ID = TEX.TAR_ID
    WHERE (TAR.TAR_TAREA_FINALIZADA IS NULL OR TAR.TAR_TAREA_FINALIZADA = 0) AND TAR.BORRADO = 0
      AND TAR.PRC_ID IS NOT NULL
      AND TAR.TAR_CODIGO = 1
  )
  , PROCEDIMIENTOS AS (
    SELECT * FROM (
      SELECT PRC.PRC_ID, PRC.DD_TPO_ID, TAR.TEX_ID, TAR.TAP_CODIGO, TPO.DD_TPO_XML_JBPM
        ,COUNT(1) OVER (PARTITION BY PRC.PRC_ID) COUNT_TARS
      FROM #ESQUEMA#.PRC_PROCEDIMIENTOS PRC
        JOIN #ESQUEMA#.DD_TPO_TIPO_PROCEDIMIENTO TPO ON PRC.DD_TPO_ID = TPO.DD_TPO_ID
        JOIN TAREAS TAR ON PRC.PRC_ID = TAR.PRC_ID AND PRC.USUARIOCREAR = TAR.USUARIOCREAR
      WHERE PRC.PRC_PROCESS_BPM IS NULL AND PRC.BORRADO = 0
        AND TPO.DD_TPO_CODIGO IN ('P401', 'P409')
    ) WHERE COUNT_TARS = 3
  )
  SELECT PRC.PRC_ID, DEF.ID_ DEFINITION_ID, NODE.ID_ NODE_ID, PRC.TAP_CODIGO, PRC.TEX_ID
    , ROW_NUMBER() OVER (PARTITION BY PRC.PRC_ID ORDER BY PRC.TEX_ID) N
  FROM PROCEDIMIENTOS PRC
    JOIN BPM_DEFINITIONS DEF ON PRC.DD_TPO_XML_JBPM = DEF.NAME_
    JOIN #ESQUEMA_MASTER#.JBPM_NODE NODE ON DEF.ID_ = NODE.PROCESSDEFINITION_ AND PRC.TAP_CODIGO = NODE.NAME_
  ORDER BY PRC.PRC_ID;

  TYPE T_PRC IS TABLE OF CUR_PROCEDIMIENTOS%ROWTYPE INDEX BY BINARY_INTEGER;
  L_PRC T_PRC;

  --/* Variables */
  V_DBID NUMBER(16);
  V_SQL VARCHAR2(3000 CHAR);
  V_LIMIT NUMBER(16);

  --/* Constantes */
  C_DEBUG NUMBER(1);

BEGIN
  -- Configurar el modo DEBUG 1=si, 0 = no
  C_DEBUG := 0;

  SELECT ENTIDAD_ID INTO V_DBID
  FROM #ESQUEMA_MASTER#.ENTIDADCONFIG
  WHERE DATAKEY = 'schema' AND UPPER(DATAVALUE) = 'BANK01';

  --/* ----- Reservamos id's objetos de BPM ------- */
 -- #ESQUEMA#.OPERACION_DDL.DDL_TABLE('TRUNCATE','TMP_ALTA_BPM_INSTANCES');
    delete #ESQUEMA#.TMP_ALTA_BPM_INSTANCES;

  IF C_DEBUG = 1 THEN
      V_LIMIT := 3;
  ELSE
      V_LIMIT := 3000;
  END IF;

  OPEN CUR_PROCEDIMIENTOS;
  LOOP
    FETCH CUR_PROCEDIMIENTOS BULK COLLECT INTO L_PRC LIMIT V_LIMIT;

    FORALL I IN 1..L_PRC.COUNT
    INSERT INTO #ESQUEMA#.TMP_ALTA_BPM_INST_SUBASTAS(PRC_ID, DEF_ID, INST_ID, TOKEN_ID, MODULE_ID, VMAP_ID)
    SELECT L_PRC(I).PRC_ID, L_PRC(I).DEFINITION_ID
      , #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL, #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.CURRVAL, #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.CURRVAL, #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.CURRVAL
    FROM DUAL WHERE 1 = L_PRC(I).N;

    FORALL I IN 1..L_PRC.COUNT
    INSERT INTO #ESQUEMA#.TMP_ALTA_BPM_TKNS_SUBASTAS(PRC_ID, NODE_ID, TAP_CODIGO, TEX_ID, TOKEN_ID)
    VALUES (L_PRC(I).PRC_ID, L_PRC(I).NODE_ID, L_PRC(I).TAP_CODIGO, L_PRC(I).TEX_ID
      , #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL);

    IF C_DEBUG = 1 THEN
      EXIT;
    ELSE
      EXIT WHEN CUR_PROCEDIMIENTOS%NOTFOUND;
    END IF;
  END LOOP;
  CLOSE CUR_PROCEDIMIENTOS;


  /* ----- Insertamos instancia de BPM ------- */

    IF C_DEBUG <> 1 THEN
      V_SQL := 'INSERT INTO #ESQUEMA_MASTER#.JBPM_PROCESSINSTANCE';
    ELSE
      V_SQL := 'INSERT INTO #ESQUEMA#.TMP_BPM_PROCESSINSTANCE';
    END IF;
    V_SQL := V_SQL||' (ID_, VERSION_, START_, END_, ISSUSPENDED_, PROCESSDEFINITION_)
    SELECT TMP.INST_ID -- ID_
            ,1 --VERSION
            , SYSDATE --START_
            ,NULL --END_
            , 0 --ISSUSPENDED_
            , TMP.DEF_ID --PRCESSDEFINITION_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INST_SUBASTAS TMP';

    EXECUTE IMMEDIATE V_SQL;

     --/* ----- Insertamos el token para la instancia ------- */
    IF C_DEBUG <> 1 THEN
      V_SQL := 'INSERT INTO #ESQUEMA_MASTER#.JBPM_TOKEN';
    ELSE
      V_SQL := 'INSERT INTO #ESQUEMA#.TMP_BPM_TOKEN';
    END IF;
    V_SQL := V_SQL||' (ID_, NAME_, VERSION_, START_, END_, NODEENTER_, ISSUSPENDED_, NODE_, PROCESSINSTANCE_, NEXTLOGINDEX_,ISABLETOREACTIVATEPARENT_,ISTERMINATIONIMPLICIT_, PARENT_)
        SELECT TMP.TOKEN_ID
              , TMP.TK_NAME
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
              , TMP.PARENT_TOKEN --PARENT_
    FROM (
      SELECT INS.TOKEN_ID, NULL TK_NAME, NOD.ID_ NODE_ID, INS.INST_ID, NULL PARENT_TOKEN
      FROM #ESQUEMA#.TMP_ALTA_BPM_INST_SUBASTAS INS
        JOIN #ESQUEMA_MASTER#.JBPM_NODE NOD ON INS.DEF_ID = NOD.PROCESSDEFINITION_ AND NOD.NAME_ = ''fork1''
      UNION ALL
      SELECT TKNS.TOKEN_ID
      , CASE WHEN TKNS.TAP_CODIGO LIKE ''%Adjuntar%'' THEN ''AdjuntarInforme''
            WHEN TKNS.TAP_CODIGO LIKE ''%Celebra%'' THEN ''Celebracion''
            WHEN TKNS.TAP_CODIGO LIKE ''%Preparar%'' THEN ''PrepararPropuesta''
            ELSE NULL
        END TK_NAME
      , TKNS.NODE_ID, INS.INST_ID, INS.TOKEN_ID PARENT_TOKEN
      FROM #ESQUEMA#.TMP_ALTA_BPM_TKNS_SUBASTAS TKNS
        JOIN #ESQUEMA#.TMP_ALTA_BPM_INST_SUBASTAS INS ON TKNS.PRC_ID = INS.PRC_ID
    ) TMP';

    EXECUTE IMMEDIATE V_SQL;

    IF C_DEBUG = 1 THEN
      EXECUTE IMMEDIATE 'INSERT INTO #ESQUEMA#.TMP_BPM_PRC_PROCEDIMIENTOS
      SELECT * FROM #ESQUEMA#.PRC_PROCEDIMIENTOS WHERE PRC_ID IN (SELECT PRC_ID FROM #ESQUEMA#.TMP_ALTA_BPM_INST_SUBASTAS)';

      EXECUTE IMMEDIATE 'INSERT INTO #ESQUEMA#.TMP_BPM_TEX_TAREA_EXTERNA
      SELECT * FROM #ESQUEMA#.TEX_TAREA_EXTERNA WHERE TEX_ID IN (SELECT TEX_ID FROM #ESQUEMA#.TMP_ALTA_BPM_TKNS_SUBASTAS)';
    END IF;

    --/* ----- Actualizamos el roottoken en cada instancia ------- */
    IF C_DEBUG <> 1 THEN
      V_SQL := 'MERGE INTO #ESQUEMA_MASTER#.JBPM_PROCESSINSTANCE INS';
    ELSE
      V_SQL := 'MERGE INTO #ESQUEMA#.TMP_BPM_PROCESSINSTANCE INS';
    END IF;
    V_SQL := V_SQL||' USING (SELECT * FROM #ESQUEMA#.TMP_ALTA_BPM_INST_SUBASTAS) TMP
    ON (INS.ID_ = TMP.INST_ID)
    WHEN MATCHED THEN UPDATE SET INS.ROOTTOKEN_ = TMP.TOKEN_ID';

     EXECUTE IMMEDIATE V_SQL;

  --/* ----- Actualizamos el id de instancia en el procedimiento ------- */
    IF C_DEBUG <> 1 THEN
      V_SQL := 'MERGE INTO #ESQUEMA#.PRC_PROCEDIMIENTOS PRC';
    ELSE
      V_SQL := 'MERGE INTO #ESQUEMA#.TMP_BPM_PRC_PROCEDIMIENTOS PRC';
    END IF;
    V_SQL:= V_SQL||' USING (SELECT * FROM #ESQUEMA#.TMP_ALTA_BPM_INST_SUBASTAS) TMP
    ON (PRC.PRC_ID = TMP.PRC_ID)
    WHEN MATCHED THEN UPDATE SET PRC.PRC_PROCESS_BPM = TMP.INST_ID
      ,USUARIOMODIFICAR = ''AUTO'', fechamodificar = sysdate';

    EXECUTE IMMEDIATE V_SQL;
  --/* ----- Actualizamos el token id de la tarea externa ------- */
    IF C_DEBUG <> 1 THEN
      V_SQL := 'MERGE INTO #ESQUEMA#.TEX_TAREA_EXTERNA TEX';
    ELSE
      V_SQL := 'MERGE INTO #ESQUEMA#.TMP_BPM_TEX_TAREA_EXTERNA TEX';
    END IF;
    V_SQL:= V_SQL||' USING (SELECT * FROM #ESQUEMA#.TMP_ALTA_BPM_TKNS_SUBASTAS) TMP
    ON (TEX.TEX_ID = TMP.TEX_ID)
    WHEN MATCHED THEN UPDATE SET TEX.TEX_TOKEN_ID_BPM = TMP.TOKEN_ID
      ,USUARIOMODIFICAR = ''AUTO'', fechamodificar = sysdate';

    EXECUTE IMMEDIATE V_SQL;

  --/* ----- Insertamos el moduleinstance para cada instancia ------- */
    IF C_DEBUG <> 1 THEN
      V_SQL := 'INSERT INTO #ESQUEMA_MASTER#.JBPM_MODULEINSTANCE';
    ELSE
      V_SQL := 'INSERT INTO #ESQUEMA#.TMP_BPM_MODULEINSTANCE';
    END IF;
    V_SQL := V_SQL||' (ID_, CLASS_, VERSION_, PROCESSINSTANCE_, NAME_)
        SELECT  TMP.MODULE_ID
            , ''C'' --CLASS_
            , 0 --VERSION_
            , TMP.INST_ID --PROCESSINSTANCE_
            , ''org.jbpm.context.exe.ContextInstance'' --NAME_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INST_SUBASTAS TMP';

    EXECUTE IMMEDIATE V_SQL;

    IF C_DEBUG <> 1 THEN
      V_SQL := 'INSERT INTO #ESQUEMA_MASTER#.JBPM_MODULEINSTANCE';
    ELSE
      V_SQL := 'INSERT INTO #ESQUEMA#.TMP_BPM_MODULEINSTANCE';
    END IF;
    V_SQL := V_SQL||' (ID_, CLASS_, VERSION_, PROCESSINSTANCE_, NAME_, TASKMGMTDEFINITION_)
        SELECT  #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL
            , ''T'' --CLASS_
            , 0 --VERSION_
            , TMP.INST_ID --PROCESSINSTANCE_
            , DEF.NAME_ --NAME_
            , DEF.ID_ --TASKMGMTDEFINITION_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INST_SUBASTAS TMP
      JOIN #ESQUEMA_MASTER#.JBPM_MODULEDEFINITION DEF ON TMP.DEF_ID = DEF.PROCESSDEFINITION_
            AND DEF.NAME_ = ''org.jbpm.taskmgmt.def.TaskMgmtDefinition''';

    EXECUTE IMMEDIATE V_SQL;

    --/* ----- Insertamos el variablemap para cada instancia ------- */
    IF C_DEBUG <> 1 THEN
      V_SQL := 'INSERT INTO #ESQUEMA_MASTER#.JBPM_TOKENVARIABLEMAP';
    ELSE
      V_SQL := 'INSERT INTO #ESQUEMA#.TMP_BPM_TOKENVARIABLEMAP';
    END IF;
    V_SQL := V_SQL||' (ID_, VERSION_, TOKEN_, CONTEXTINSTANCE_)
      SELECT TMP.VMAP_ID
        , 0 --VERSION_
        , TMP.TOKEN_ID --ROOTTOKEN_
        , TMP.MODULE_ID  --CONTEXTINSTANCE_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INST_SUBASTAS TMP';

    EXECUTE IMMEDIATE V_SQL;

    --/* ----- Insertamos las variable instance para cada instancia ------- */
    IF C_DEBUG <> 1 THEN
      V_SQL := 'INSERT INTO #ESQUEMA_MASTER#.JBPM_VARIABLEINSTANCE';
    ELSE
      V_SQL := 'INSERT INTO #ESQUEMA#.TMP_BPM_VARIABLEINSTANCE';
    END IF;
    V_SQL := V_SQL||' (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL
      ,''L'' --CLASS_
      , 0 --VERSION_
      , ''DB_ID'' --NAME_
      , TMP.TOKEN_ID --TOKEM_
      , TMP.VMAP_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , '||V_DBID||' --LONGVLAUE_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INST_SUBASTAS TMP';

    EXECUTE IMMEDIATE V_SQL;

    IF C_DEBUG <> 1 THEN
      V_SQL := 'INSERT INTO #ESQUEMA_MASTER#.JBPM_VARIABLEINSTANCE';
    ELSE
      V_SQL := 'INSERT INTO #ESQUEMA#.TMP_BPM_VARIABLEINSTANCE';
    END IF;
    V_SQL := V_SQL||' (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL
      ,''L'' --CLASS_
      , 0 --VERSION_
      , ''procedimientoTareaExterna'' --NAME_
      , TMP.TOKEN_ID --TOKEM_
      , TMP.VMAP_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , TMP.PRC_ID --LONGVLAUE_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INST_SUBASTAS TMP';

    EXECUTE IMMEDIATE V_SQL;

    IF C_DEBUG <> 1 THEN
      V_SQL := 'INSERT INTO #ESQUEMA_MASTER#.JBPM_VARIABLEINSTANCE';
    ELSE
      V_SQL := 'INSERT INTO #ESQUEMA#.TMP_BPM_VARIABLEINSTANCE';
    END IF;
    V_SQL := V_SQL||' (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL
      ,''L'' --CLASS_
      , 0 --VERSION_
      , ''bpmParalizado'' --NAME_
      , TMP.TOKEN_ID --TOKEM_
      , TMP.VMAP_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , 0 --LONGVLAUE_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INST_SUBASTAS TMP';

    EXECUTE IMMEDIATE V_SQL;

    IF C_DEBUG <> 1 THEN
      V_SQL := 'INSERT INTO #ESQUEMA_MASTER#.JBPM_VARIABLEINSTANCE';
    ELSE
      V_SQL := 'INSERT INTO #ESQUEMA#.TMP_BPM_VARIABLEINSTANCE';
    END IF;
    V_SQL := V_SQL||' (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, STRINGVALUE_)
      SELECT #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL
      ,''S'' --CLASS_
      , 0 --VERSION_
      , ''NOMBRE_NODO_SALIENTE'' --NAME_
      , TMP.TOKEN_ID --TOKEM_
      , TMP.VMAP_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , TPO.DD_TPO_CODIGO||''_SenyalamientoSubasta'' --STRINGVALUE_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INST_SUBASTAS TMP
      JOIN #ESQUEMA#.PRC_PROCEDIMIENTOS PRC ON TMP.PRC_ID = PRC.PRC_ID
      JOIN #ESQUEMA#.DD_TPO_TIPO_PROCEDIMIENTO TPO ON PRC.DD_TPO_ID = TPO.DD_TPO_ID';

    EXECUTE IMMEDIATE V_SQL;

    IF C_DEBUG <> 1 THEN
      V_SQL := 'INSERT INTO #ESQUEMA_MASTER#.JBPM_VARIABLEINSTANCE';
    ELSE
      V_SQL := 'INSERT INTO #ESQUEMA#.TMP_BPM_VARIABLEINSTANCE';
    END IF;
    V_SQL := V_SQL||' (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL
      ,''L'' --CLASS_
      , 0 --VERSION_
      , ''id''||TKNS.TAP_CODIGO||''.''||TKNS.TOKEN_ID --NAME_
      , INST.TOKEN_ID --TOKEM_
      , INST.VMAP_ID  --TOKENVARIABLEMAP_
      , INST.INST_ID --PROCESSINSTANCE_
      , TKNS.TEX_ID --LONGVLAUE_
    FROM #ESQUEMA#.TMP_ALTA_BPM_TKNS_SUBASTAS TKNS
      JOIN #ESQUEMA#.TMP_ALTA_BPM_INST_SUBASTAS INST ON TKNS.PRC_ID = INST.PRC_ID';

    EXECUTE IMMEDIATE V_SQL;

  IF C_DEBUG <> 1 THEN
    COMMIT;

    INSERT INTO #ESQUEMA_MASTER#.JBPM_JOB (ID_, CLASS_, VERSION_, DUEDATE_, PROCESSINSTANCE_,TOKEN_, ISSUSPENDED_,ISEXCLUSIVE_, NAME_, TRANSITIONNAME_)
    SELECT #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL ID_
      , 'T' CLASS_
      , 0 VERSION_
      , SYSDATE -1 DUEDATE_
      , INS.ID_ PROCESSINSTANCE_
      , TKN.ID_ TOKEN_
      , 0 ISSUSPEND_
      , 1 ISEXCLUSIVE_
      , 'Solicitar num activo migracion' NAME_
      , TRA.NAME_ TRANSITIONNAME_
    FROM #ESQUEMA#.PRC_PROCEDIMIENTOS PRC
      JOIN #ESQUEMA#.DD_TPO_TIPO_PROCEDIMIENTO TPO ON PRC.DD_TPO_ID = TPO.DD_TPO_ID
      JOIN #ESQUEMA_MASTER#.JBPM_PROCESSINSTANCE INS ON PRC.PRC_PROCESS_BPM = INS.ID_
      JOIN #ESQUEMA_MASTER#.JBPM_TOKEN TKN ON INS.ROOTTOKEN_ = TKN.ID_
      JOIN #ESQUEMA_MASTER#.JBPM_NODE NOD ON TKN.NODE_ = NOD.ID_
      JOIN #ESQUEMA_MASTER#.JBPM_TRANSITION TRA ON NOD.ID_ = TRA.FROM_ AND TRA.NAME_ = 'SolicitarNumActivo'
    WHERE DD_TPO_CODIGO IN ('P401','P409')
      AND NOD.NAME_ = 'fork1'
      AND NOT EXISTS (SELECT 1 FROM #ESQUEMA_MASTER#.JBPM_JOB WHERE TOKEN_ = TKN.ID_ AND TRANSITIONNAME_ = TRA.NAME_);

      COMMIT;

  END IF;


    EXCEPTION
     WHEN OTHERS THEN

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(SQLERRM);

          ROLLBACK;
          RAISE;

END ALTA_BPM_INSTANCES_SUBASTAS;
/

EXIT;
