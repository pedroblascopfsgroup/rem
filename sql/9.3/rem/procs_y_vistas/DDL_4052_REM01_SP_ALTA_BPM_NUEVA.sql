--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171105
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.8
--## INCIDENCIA_LINK=HREOS-3095
--## PRODUCTO=SI
--## 
--## Finalidad: Alta BPM GENERAL
--## VERSIONES:
--##        0.3 Version
--##########################################
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

create or replace PROCEDURE ALTA_BPM_NUEVA AS

--***********************************************************************************
--Revisado a 03/02/2017 con el alta de asuntos para comprobar el funcionamiento.                                           
--Da de alta BPMs para todos aquellos PRC/TEX sin BPMs asociados.                                                           
--Se considera la posibilidad de que existan varias tareas asignadas a un PRC.                                              
--Utiliza para el proceso general una Global Temporaly Table, evitando el uso de cursores, por lo que es más óptimo         
--Para que funcione adecuadamente, la relación DD_TPO_TIPO_PROCEDIMIENTO-TAP_TAREA_PROCEDIMIENTO-JBPM_NODE debe ser correcta
--La asignación del ID del BPM a PRC y TEX se hace al final, por lo que el proceso es relanzable                           
--***********************************************************************************

  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

  CURSOR CUR_PROCEDIMIENTOS IS
  WITH BPM_DEFINITIONS AS (
    SELECT NAME_, MAX(ID_) ID_
    FROM #ESQUEMA_MASTER#.JBPM_PROCESSDEFINITION
    GROUP BY NAME_
  )
  , TAREAS AS (
    SELECT  PRC_ID, TAR_ID
    FROM #ESQUEMA#.TAR_TAREAS_NOTIFICACIONES
    WHERE (TAR_TAREA_FINALIZADA IS NULL OR TAR_TAREA_FINALIZADA = 0) AND BORRADO = 0
  ), FORK_NODE AS (
    select PROCESSDEFINITION_,
      min(ID_) FORK_NODE
    from #ESQUEMA_MASTER#.jbpm_node
    where class_='F' group by PROCESSDEFINITION_
  )
  SELECT PRC.PRC_ID, DEF.ID_ DEFINITION_ID, NODE.ID_ NODE_ID, TAP.TAP_CODIGO, TEX.TEX_ID, Fk.FORK_NODE
  FROM #ESQUEMA#.PRC_PROCEDIMIENTOS PRC
    JOIN #ESQUEMA#.DD_TPO_TIPO_PROCEDIMIENTO TPO ON PRC.DD_TPO_ID = TPO.DD_TPO_ID
    JOIN #ESQUEMA#.BPM_DEFINITIONS DEF ON TPO.DD_TPO_XML_JBPM = DEF.NAME_
    JOIN #ESQUEMA#.TAREAS TAR ON PRC.PRC_ID = TAR.PRC_ID
    JOIN #ESQUEMA#.TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID
    JOIN #ESQUEMA#.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
    JOIN #ESQUEMA_MASTER#.JBPM_NODE NODE ON DEF.ID_ = NODE.PROCESSDEFINITION_ AND TAP.TAP_CODIGO = NODE.NAME_
    left join #ESQUEMA#.FORK_NODE FK ON FK.PROCESSDEFINITION_=DEF.ID_
  WHERE (PRC.PRC_PROCESS_BPM IS NULL or tex_token_id_bpm IS NULL)
  ORDER BY PRC_ID;

  --/* CUR_PROCEDIMIENTOS2 se utiliza para el tratamiento de varias tareas asociadas a un único PRC */

  CURSOR CUR_PROCEDIMIENTOS2 IS
  SELECT PRC_ID, count(*) AS CUENTA FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES group by PRC_ID having count(*)>1;

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

	V_SQL_1 VARCHAR2(32000 CHAR) := 'insert into '||V_ESQUEMA_M||'.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) ' ||
	'select '||V_ESQUEMA_M||'.hibernate_sequence.nextval id_, :1 name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ ' ||
	'from ( ' ||
	'select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex ' ||
	'from '||V_ESQUEMA||'.tar_tareas_notificaciones tar ' ||
	'    join '||V_ESQUEMA||'.tex_tarea_externa tex on tar.tar_id = tex.tar_id ' ||
	'    join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id ' ||
	'    join '||V_ESQUEMA||'.prc_procedimientos prc on tar.prc_id = prc.prc_id ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.roottoken_ = tk.id_ ' ||
	'    join '||V_ESQUEMA_M||'.jbpm_node nd on tk.node_ = nd.id_  and nd.class_ <> ''F'' ' ||
	'    left join '||V_ESQUEMA_M||'.jbpm_transition aux on nd.id_ = aux.from_ ' ||
	'    left join '||V_ESQUEMA_M||'.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = :2 ' ||
	'where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null ' ||
	'    and tap.tap_autoprorroga = 1 and tr.id_ is null ' ||
	'group by nd.id_,nd.processdefinition_)' ;

	TYPE T_AUX IS TABLE OF VARCHAR2(50);
	TYPE T_ARRAY_INPUT IS TABLE OF T_AUX;
	V_AUX T_ARRAY_INPUT := T_ARRAY_INPUT(
		T_AUX('activarProrroga'),
		T_AUX('activarTareas'),
		T_AUX('aplazarTareas'),
		T_AUX('paralizarTareas'),
		T_AUX('activarAlerta')
	);
	V_TMP_T_AUX T_AUX;


  /* Variables */
  err_num NUMBER;
  err_msg VARCHAR2(255);
  V_DBID NUMBER(16);

BEGIN
  SELECT ENTIDAD_ID INTO V_DBID
  FROM #ESQUEMA_MASTER#.ENTIDADCONFIG
  WHERE DATAKEY = 'schema' AND UPPER(DATAVALUE) = '#ESQUEMA#';

  --OPEN CUR_PROCEDIMIENTOS;

  /* ----- Reservamos id's objetos de BPM ------- */
  DELETE FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES;

  FOR L_PRC in CUR_PROCEDIMIENTOS
  LOOP

    ID_PROCEDIMIENTO_ACTUAL:= L_PRC.PRC_ID;
    IF ID_PROCEDIMIENTO_ACTUAL<>ID_PROCEDIMIENTO THEN
      ID_PROCEDIMIENTO := ID_PROCEDIMIENTO_ACTUAL;
      INSTANCE_ID_ := #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL;
    END IF;

    INSERT INTO #ESQUEMA#.TMP_ALTA_BPM_INSTANCES(PRC_ID, INST_ID,DEF_ID, NODE_ID, TAP_CODIGO, TEX_ID, FORK_NODE)
    VALUES (L_PRC.PRC_ID, INSTANCE_ID_, L_PRC.DEFINITION_ID, L_PRC.NODE_ID, L_PRC.TAP_CODIGO, L_PRC.TEX_ID, L_PRC.FORK_NODE);

    --DBMS_OUTPUT.PUT_LINE(L_PRC.PRC_ID || '--' || INSTANCE_ID_ || '--' || L_PRC.DEFINITION_ID) ;
  END LOOP;

  ID_PROCEDIMIENTO := -1;

  --/* En este LOOP se va a realizar el tratamiento de varios TAR para un mismo PRC */

  FOR L_PRC2 in CUR_PROCEDIMIENTOS2
  LOOP

    ID_PROCEDIMIENTO_ACTUAL:= L_PRC2.PRC_ID;
    IF ID_PROCEDIMIENTO_ACTUAL<>ID_PROCEDIMIENTO THEN
      ID_PROCEDIMIENTO := ID_PROCEDIMIENTO_ACTUAL;
      CURRENT_TOKEN_PADRE_ := #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL;
    END IF;

    UPDATE #ESQUEMA#.TMP_ALTA_BPM_INSTANCES
    SET
      TOKEN_PADRE_ID=CURRENT_TOKEN_PADRE_,
      MODULE_PADRE_ID=CURRENT_TOKEN_PADRE_,
      VMAP_PADRE_ID=CURRENT_TOKEN_PADRE_
    WHERE PRC_ID=ID_PROCEDIMIENTO_ACTUAL;

    --DBMS_OUTPUT.PUT_LINE(L_PRC.PRC_ID || '--' || INSTANCE_ID_ || '--' || L_PRC.DEFINITION_ID);
  END LOOP;

  UPDATE #ESQUEMA#.TMP_ALTA_BPM_INSTANCES SET
    TOKEN_ID = #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL
    ,MODULE_ID = #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL
    ,VMAP_ID = #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL;

  UPDATE #ESQUEMA#.TMP_ALTA_BPM_INSTANCES SET
    TOKEN_PADRE_ID = TOKEN_ID
    ,MODULE_PADRE_ID=MODULE_ID
    ,VMAP_PADRE_ID = VMAP_ID
    WHERE TOKEN_PADRE_ID IS NULL;

/* En este momento, la tabla temporal TMP_ALTA_BPM_INSTANCES está totalmente rellena. Ojo que es una GTT y se borrará al final   */

  INSERT INTO #ESQUEMA_MASTER#.JBPM_PROCESSINSTANCE
      (ID_, VERSION_, START_, END_, ISSUSPENDED_, PROCESSDEFINITION_)
  SELECT DISTINCT TMP.INST_ID -- ID_
          ,1 --VERSION
          , SYSDATE --START_
          ,NULL --END_
          , 0 --ISSUSPENDED_
          , TMP.DEF_ID --PRCESSDEFINITION_
  FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES TMP;

  INSERT INTO #ESQUEMA_MASTER#.JBPM_TOKEN
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
      FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES TMP WHERE TOKEN_PADRE_ID<>TOKEN_ID;

  INSERT INTO #ESQUEMA_MASTER#.JBPM_TOKEN
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
      FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES TMP;

	UPDATE #ESQUEMA_MASTER#.Jbpm_Token SET parent_=null WHERE id_=parent_;

	MERGE INTO #ESQUEMA_MASTER#.Jbpm_Token T
	USING (
	select T.ID_, N.NAME_  from #ESQUEMA_MASTER#.Jbpm_Token T
	join #ESQUEMA_MASTER#.Jbpm_Node N on T.NODE_=N.ID_
	where T.name_ is null) TMP
	ON (TMP.ID_=T.ID_)
	WHEN MATCHED THEN UPDATE SET T.NAME_=TMP.NAME_;

  MERGE INTO #ESQUEMA_MASTER#.JBPM_PROCESSINSTANCE INS
  USING (SELECT DISTINCT INST_ID, TOKEN_PADRE_ID AS TOKEN FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES) TMP
  ON (INS.ID_ = TMP.INST_ID)
  WHEN MATCHED THEN UPDATE SET INS.ROOTTOKEN_ = TMP.TOKEN;

    INSERT INTO #ESQUEMA_MASTER#.JBPM_MODULEINSTANCE
            (ID_, CLASS_, VERSION_, PROCESSINSTANCE_, NAME_)
        SELECT  DISTINCT TMP.MODULE_PADRE_ID
            , 'C' --CLASS_
            , 0 --VERSION_
            , TMP.INST_ID --PROCESSINSTANCE_
            , 'org.jbpm.context.exe.ContextInstance' --NAME_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES TMP;

    INSERT INTO #ESQUEMA_MASTER#.JBPM_TOKENVARIABLEMAP
            (ID_, VERSION_, TOKEN_, CONTEXTINSTANCE_)
      SELECT DISTINCT TMP.VMAP_PADRE_ID
        , 0 --VERSION_
        , TMP.TOKEN_PADRE_ID --ROOTTOKEN_
        , TMP.MODULE_PADRE_ID  --CONTEXTINSTANCE_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES TMP;

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
    FROM (SELECT DISTINCT INST_ID, PRC_ID, TOKEN_PADRE_ID AS TOKEN_ID,MODULE_PADRE_ID AS MODULE_ID,VMAP_PADRE_ID AS VMAP_ID FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES) TMP;

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
    FROM (SELECT DISTINCT INST_ID, PRC_ID, TOKEN_PADRE_ID AS TOKEN_ID,MODULE_PADRE_ID AS MODULE_ID,VMAP_PADRE_ID AS VMAP_ID FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES) TMP;

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
    FROM (SELECT DISTINCT INST_ID, PRC_ID, TOKEN_PADRE_ID AS TOKEN_ID,MODULE_PADRE_ID AS MODULE_ID,VMAP_PADRE_ID AS VMAP_ID FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES) TMP;

    INSERT INTO #ESQUEMA_MASTER#.JBPM_VARIABLEINSTANCE
        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT #ESQUEMA_MASTER#.HIBERNATE_SEQUENCE.NEXTVAL
      ,'L' --CLASS_
      , 0 --VERSION_
      , 'id'||TMP.TAP_CODIGO||'.'||TMP.TOKEN_ID --NAME_
      , TMP.TOKEN_ID --TOKEM_
      , TMP.VMAP_PADRE_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , TMP.TEX_ID --LONGVLAUE_
    FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES TMP;


/* La asignación del ID del BPM a PRC y TEX se hace al final, por lo que el proceso es relanzable                             */
  MERGE INTO #ESQUEMA#.PRC_PROCEDIMIENTOS PRC
  USING (SELECT DISTINCT PRC_ID,INST_ID FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES) TMP
  ON (PRC.PRC_ID = TMP.PRC_ID)
  WHEN MATCHED
    THEN UPDATE
      SET PRC.PRC_PROCESS_BPM = TMP.INST_ID
          , USUARIOMODIFICAR = 'AUTO'
          , fechamodificar = sysdate;

  MERGE INTO #ESQUEMA#.TEX_TAREA_EXTERNA TEX
  USING (SELECT * FROM #ESQUEMA#.TMP_ALTA_BPM_INSTANCES) TMP
  ON (TEX.TEX_ID = TMP.TEX_ID)
  WHEN MATCHED
    THEN UPDATE
      SET TEX.TEX_TOKEN_ID_BPM = TMP.TOKEN_ID
          , USUARIOMODIFICAR = 'AUTO'
          , fechamodificar = sysdate;

  DBMS_OUTPUT.PUT_LINE('[INI] ... Insertar transiciones automáticas HAYAMASTER.JBPM_TRANSITION');

  FOR I IN V_AUX.FIRST .. V_AUX.LAST
  LOOP
    V_TMP_T_AUX := V_AUX(I);
    DBMS_OUTPUT.PUT_LINE('INSERTANDO TRANSICION ' || V_TMP_T_AUX(1)); 
    EXECUTE IMMEDIATE V_SQL_1 USING V_TMP_T_AUX(1),  V_TMP_T_AUX(1);
    DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL_1, 1, 60), 60, ' ') || '...' || sql%rowcount);
  END LOOP;

  COMMIT;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || TO_CHAR (SQLCODE));
      DBMS_OUTPUT.put_line (SQLERRM);
      ROLLBACK;
      RAISE;

END ALTA_BPM_NUEVA;
/
exit;

