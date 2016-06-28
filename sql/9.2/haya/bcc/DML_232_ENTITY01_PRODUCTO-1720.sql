--/*
--##########################################
--## AUTOR=CARLOS LOPEZ VIDAL
--## FECHA_CREACION=20160609
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK= PRODUCTO-1720
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar a la fecha de la implantación la Fecha de Avaluo de los Asuntos que la tiene a null.
--##                   
--##       
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
  /* Consulta, procedimientos sin BPM */
  CURSOR CUR_PROCEDIMIENTOS IS 

    WITH BPM_DEFINITIONS AS (
    SELECT NAME_, MAX(ID_) ID_
    FROM HAYAMASTER.JBPM_PROCESSDEFINITION
    GROUP BY NAME_
  )
  , TAREAS AS (
    SELECT  PRC_ID, TAR_ID
    FROM HAYA02.TAR_TAREAS_NOTIFICACIONES
    WHERE (TAR_TAREA_FINALIZADA IS NULL OR TAR_TAREA_FINALIZADA = 0) AND BORRADO = 0
  ), FORK_NODE AS (
    select PROCESSDEFINITION_, 
      min(ID_) FORK_NODE
    from HAYAMASTER.jbpm_node 
    where class_='F' group by PROCESSDEFINITION_
  )
  SELECT PRC.PRC_ID, DEF.ID_ DEFINITION_ID, NODE.ID_ NODE_ID, TAP.TAP_CODIGO, TEX.TEX_ID, Fk.FORK_NODE
  FROM HAYA02.PRC_PROCEDIMIENTOS PRC
     inner join HAYA02.asu_asuntos asu on prc.asu_id = asu.asu_id and asu.DD_TAS_ID = 1
    JOIN HAYA02.DD_TPO_TIPO_PROCEDIMIENTO TPO ON PRC.DD_TPO_ID = TPO.DD_TPO_ID
    JOIN BPM_DEFINITIONS DEF ON TPO.DD_TPO_XML_JBPM = DEF.NAME_
    JOIN TAREAS TAR ON PRC.PRC_ID = TAR.PRC_ID
    JOIN HAYA02.TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID
    JOIN HAYA02.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
    JOIN HAYAMASTER.JBPM_NODE NODE ON DEF.ID_ = NODE.PROCESSDEFINITION_ AND TAP.TAP_CODIGO = NODE.NAME_
    left join FORK_NODE FK ON FK.PROCESSDEFINITION_=DEF.ID_
  WHERE PRC.PRC_PROCESS_BPM IS    NULL
    AND PRC.PRC_ID IN (select tar.PRC_ID 
                                      from HAYA02.TAR_TAREAS_NOTIFICACIONES tar, HAYA02.TEX_TAREA_EXTERNA TEX
                                    WHERE TAR.TAR_ID = TEX.TAR_ID
                                      AND tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) 
                                      AND tar.USUARIOCREAR LIKE '%MIGRA%'
                                    GROUP BY tar.PRC_ID
                                    HAVING COUNT(1) > 1)
    AND PRC.USUARIOCREAR = 'MIGRAHAYA02'
  ORDER BY PRC_ID;
  CURSOR CUR_PROCEDIMIENTOS2 IS
  SELECT PRC_ID, count(*) AS CUENTA FROM HAYA02.TMP_ALTA_BPM_INSTANCES group by PRC_ID having count(*)>1;
  
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
  /* Variables */
  V_DBID NUMBER(16);

V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

USUARIO VARCHAR(50) := 'PRODUCTO-1720';
BEGIN

  SELECT ENTIDAD_ID INTO V_DBID
  FROM HAYAMASTER.ENTIDADCONFIG
  WHERE DATAKEY = 'schema' AND UPPER(DATAVALUE) = 'HAYA02';

  --OPEN CUR_PROCEDIMIENTOS;

  /* ----- Reservamos id's objetos de BPM ------- */
  DELETE FROM HAYA02.TMP_ALTA_BPM_INSTANCES;
  
  
  /*------------ Cerramos conjunto de litigios a usar ---------------------- */
  update HAYA02.prc_procedimientos prc set  prc.prc_process_bpm = null 
  where prc.prc_id in (
    select distinct prc.prc_id
    from HAYA02.Prc_Procedimientos prc
      inner join HAYA02.asu_asuntos asu on prc.asu_id = asu.asu_id and asu.DD_TAS_ID = 1
    where PRC.USUARIOCREAR = 'MIGRAHAYA02'
        AND PRC.PRC_ID IN (select tar.PRC_ID 
                                      from HAYA02.TAR_TAREAS_NOTIFICACIONES tar, HAYA02.TEX_TAREA_EXTERNA TEX
                                    WHERE TAR.TAR_ID = TEX.TAR_ID
                                      AND tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) 
                                      AND tar.USUARIOCREAR LIKE '%MIGRA%'
                                    GROUP BY tar.PRC_ID
                                    HAVING COUNT(1) > 1)
  ) and PRC.USUARIOCREAR = 'MIGRAHAYA02';

  DBMS_OUTPUT.PUT_LINE('[INFO] prc_process_bpm = null en prc_procedimientos.');


  update HAYA02.TEX_TAREA_EXTERNA TEX2 set TEX2.TEX_TOKEN_ID_BPM=null
  WHERE TEX2.TEX_ID IN (
  SELECT tex.tex_id
  FROM HAYA02.TEX_TAREA_EXTERNA TEX
    INNER JOIN HAYA02.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
    INNER JOIN HAYA02.TAR_TAREAS_NOTIFICACIONES TAR ON TEX.TAR_ID = TAR.TAR_ID
    INNER JOIN HAYA02.prc_procedimientos prc ON tar.prc_id = prc.prc_id
    inner join HAYA02.asu_asuntos asu on prc.asu_id = asu.asu_id and asu.DD_TAS_ID = 1
  where tex.USUARIOCREAR = 'MIGRAHAYA02'
       AND PRC.PRC_ID IN (select tar.PRC_ID 
                                      from HAYA02.TAR_TAREAS_NOTIFICACIONES tar, HAYA02.TEX_TAREA_EXTERNA TEX
                                    WHERE TAR.TAR_ID = TEX.TAR_ID
                                      AND tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) 
                                      AND tar.USUARIOCREAR LIKE '%MIGRA%'
                                    GROUP BY tar.PRC_ID
                                    HAVING COUNT(1) > 1)   
  )and tex2.USUARIOCREAR = 'MIGRAHAYA02';  


  DBMS_OUTPUT.PUT_LINE('[INFO] TEX2.TEX_TOKEN_ID_BPM=null en TEX_TAREA_EXTERNA.');
  
    
  /*------------ CURSOR ---------------------- */

  DBMS_OUTPUT.PUT_LINE('Asigna las instancias...') ;
  FOR L_PRC in CUR_PROCEDIMIENTOS
  LOOP

    ID_PROCEDIMIENTO_ACTUAL:= L_PRC.PRC_ID;
    IF ID_PROCEDIMIENTO_ACTUAL<>ID_PROCEDIMIENTO THEN
      ID_PROCEDIMIENTO := ID_PROCEDIMIENTO_ACTUAL;
      INSTANCE_ID_ := HAYAMASTER.HIBERNATE_SEQUENCE.NEXTVAL;
    END IF;
    
    INSERT INTO HAYA02.TMP_ALTA_BPM_INSTANCES(PRC_ID, INST_ID,DEF_ID, NODE_ID, TAP_CODIGO, TEX_ID, FORK_NODE) 
    VALUES (L_PRC.PRC_ID, INSTANCE_ID_, L_PRC.DEFINITION_ID, L_PRC.NODE_ID, L_PRC.TAP_CODIGO, L_PRC.TEX_ID, L_PRC.FORK_NODE);
    
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Instancias asignadas!!') ;
  ID_PROCEDIMIENTO := -1;
  DBMS_OUTPUT.PUT_LINE('Asigna los nodos root...') ;
  FOR L_PRC2 in CUR_PROCEDIMIENTOS2
  LOOP

    ID_PROCEDIMIENTO_ACTUAL:= L_PRC2.PRC_ID;
    IF ID_PROCEDIMIENTO_ACTUAL<>ID_PROCEDIMIENTO THEN
      ID_PROCEDIMIENTO := ID_PROCEDIMIENTO_ACTUAL;
      CURRENT_TOKEN_PADRE_ := HAYAMASTER.HIBERNATE_SEQUENCE.NEXTVAL;
    END IF;

    UPDATE HAYA02.TMP_ALTA_BPM_INSTANCES
    SET
      TOKEN_PADRE_ID=CURRENT_TOKEN_PADRE_, 
      MODULE_PADRE_ID=CURRENT_TOKEN_PADRE_, 
      VMAP_PADRE_ID=CURRENT_TOKEN_PADRE_
    WHERE PRC_ID=ID_PROCEDIMIENTO_ACTUAL;
    
    --DBMS_OUTPUT.PUT_LINE(L_PRC.PRC_ID || '--' || INSTANCE_ID_ || '--' || L_PRC.DEFINITION_ID) ;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Asignados los nodos root!!') ;
 
  DBMS_OUTPUT.PUT_LINE('Asigna los IDs de token...') ;
  UPDATE HAYA02.TMP_ALTA_BPM_INSTANCES SET 
    TOKEN_ID = HAYAMASTER.HIBERNATE_SEQUENCE.NEXTVAL
    ,MODULE_ID=HAYAMASTER.HIBERNATE_SEQUENCE.NEXTVAL
    ,VMAP_ID = HAYAMASTER.HIBERNATE_SEQUENCE.NEXTVAL;
  DBMS_OUTPUT.PUT_LINE('IDs de token asignados...') ;

  DBMS_OUTPUT.PUT_LINE('Actualizando tokens padre...') ;
  UPDATE HAYA02.TMP_ALTA_BPM_INSTANCES SET 
    TOKEN_PADRE_ID = TOKEN_ID
    ,MODULE_PADRE_ID=MODULE_ID
    ,VMAP_PADRE_ID = VMAP_ID
    WHERE TOKEN_PADRE_ID IS NULL;
  DBMS_OUTPUT.PUT_LINE('Actualizando tokens padre!!') ;

  DBMS_OUTPUT.PUT_LINE('---------------------------------') ;
  DBMS_OUTPUT.PUT_LINE('COMIENZA LA INSERCION DE DATOS...') ;
  DBMS_OUTPUT.PUT_LINE('---------------------------------') ;

  DBMS_OUTPUT.PUT_LINE('Inserta las instancias...') ;
  INSERT INTO HAYAMASTER.JBPM_PROCESSINSTANCE
      (ID_, VERSION_, START_, END_, ISSUSPENDED_, PROCESSDEFINITION_)
  SELECT DISTINCT TMP.INST_ID -- ID_
          ,1 --VERSION
          , SYSDATE --START_
          ,NULL --END_
          , 0 --ISSUSPENDED_
          , TMP.DEF_ID --PRCESSDEFINITION_
  FROM HAYA02.TMP_ALTA_BPM_INSTANCES TMP;
  DBMS_OUTPUT.PUT_LINE('Instancias insertados!!') ;

  DBMS_OUTPUT.PUT_LINE('Insertando los root token...') ;
  INSERT INTO HAYAMASTER.JBPM_TOKEN
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
      FROM HAYA02.TMP_ALTA_BPM_INSTANCES TMP WHERE TOKEN_PADRE_ID<>TOKEN_ID;
  DBMS_OUTPUT.PUT_LINE('Insertadoslos root token!!!') ;

  DBMS_OUTPUT.PUT_LINE('Insertando tokens...') ;
  INSERT INTO HAYAMASTER.JBPM_TOKEN
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
      FROM HAYA02.TMP_ALTA_BPM_INSTANCES TMP;


	UPDATE HAYAMASTER.Jbpm_Token SET parent_=null WHERE id_=parent_;

	MERGE INTO HAYAMASTER.Jbpm_Token T
	USING (
	select T.ID_, N.NAME_  from HAYAMASTER.Jbpm_Token T
	join HAYAMASTER.Jbpm_Node N on T.NODE_=N.ID_
	where T.name_ is null) TMP
	ON (TMP.ID_=T.ID_)
	WHEN MATCHED THEN UPDATE SET T.NAME_=TMP.NAME_;

  DBMS_OUTPUT.PUT_LINE('TOKENS insertados...') ;

  DBMS_OUTPUT.PUT_LINE('Actualizando las instancias...') ;
  MERGE INTO HAYAMASTER.JBPM_PROCESSINSTANCE INS
  USING (
                    SELECT DISTINCT INST_ID, TOKEN_PADRE_ID AS TOKEN 
                       FROM HAYA02.TMP_ALTA_BPM_INSTANCES
         ) TMP
  ON (INS.ID_ = TMP.INST_ID)
  WHEN MATCHED THEN UPDATE SET INS.ROOTTOKEN_ = TMP.TOKEN;
  DBMS_OUTPUT.PUT_LINE('Instancias actualizadas!!');

    DBMS_OUTPUT.PUT_LINE('Actualizando las module y vmap...') ;
    INSERT INTO HAYAMASTER.JBPM_MODULEINSTANCE
            (ID_, CLASS_, VERSION_, PROCESSINSTANCE_, NAME_)
        SELECT  DISTINCT TMP.MODULE_PADRE_ID
            , 'C' --CLASS_
            , 0 --VERSION_
            , TMP.INST_ID --PROCESSINSTANCE_
            , 'org.jbpm.context.exe.ContextInstance' --NAME_
    FROM HAYA02.TMP_ALTA_BPM_INSTANCES TMP;

    INSERT INTO HAYAMASTER.JBPM_TOKENVARIABLEMAP
            (ID_, VERSION_, TOKEN_, CONTEXTINSTANCE_)
      SELECT DISTINCT TMP.VMAP_PADRE_ID
        , 0 --VERSION_
        , TMP.TOKEN_PADRE_ID --ROOTTOKEN_
        , TMP.MODULE_PADRE_ID  --CONTEXTINSTANCE_
    FROM HAYA02.TMP_ALTA_BPM_INSTANCES TMP;
  DBMS_OUTPUT.PUT_LINE('module y vmap actualizadas!!') ;

    DBMS_OUTPUT.PUT_LINE('Actualizando VARIABLE INSTABLE...') ;

    DBMS_OUTPUT.PUT_LINE('Insertamos la variable DB_ID para cada instancia..') ;
    INSERT INTO HAYAMASTER.JBPM_VARIABLEINSTANCE
        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT HAYAMASTER.HIBERNATE_SEQUENCE.NEXTVAL
      ,'L' --CLASS_
      , 0 --VERSION_
      , 'DB_ID' --NAME_
      , TMP.TOKEN_ID --TOKEM_
      , TMP.VMAP_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , V_DBID --LONGVLAUE_
    FROM (SELECT DISTINCT INST_ID, PRC_ID, TOKEN_PADRE_ID AS TOKEN_ID,MODULE_PADRE_ID AS MODULE_ID,VMAP_PADRE_ID AS VMAP_ID FROM HAYA02.TMP_ALTA_BPM_INSTANCES) TMP;

    DBMS_OUTPUT.PUT_LINE('Insertamos la variable procedimientoTareaExterna para cada instancia..') ;
    INSERT INTO HAYAMASTER.JBPM_VARIABLEINSTANCE
        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT HAYAMASTER.HIBERNATE_SEQUENCE.NEXTVAL
        ,'L' --CLASS_
        , 0 --VERSION_
        , 'procedimientoTareaExterna' --NAME_
        , TMP.TOKEN_ID --TOKEM_
        , TMP.VMAP_ID  --TOKENVARIABLEMAP_
        , TMP.INST_ID --PROCESSINSTANCE_
        , TMP.PRC_ID --LONGVLAUE_
    FROM (SELECT DISTINCT INST_ID, PRC_ID, TOKEN_PADRE_ID AS TOKEN_ID,MODULE_PADRE_ID AS MODULE_ID,VMAP_PADRE_ID AS VMAP_ID FROM HAYA02.TMP_ALTA_BPM_INSTANCES) TMP;

    DBMS_OUTPUT.PUT_LINE('Insertamos la variable bpmParalizado para cada instancia..') ;
    INSERT INTO HAYAMASTER.JBPM_VARIABLEINSTANCE
        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT HAYAMASTER.HIBERNATE_SEQUENCE.NEXTVAL
      ,'L' --CLASS_
      , 0 --VERSION_
      , 'bpmParalizado' --NAME_
      , TMP.TOKEN_ID --TOKEM_
      , TMP.VMAP_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , 0 --LONGVLAUE_
    FROM (SELECT DISTINCT INST_ID, PRC_ID, TOKEN_PADRE_ID AS TOKEN_ID,MODULE_PADRE_ID AS MODULE_ID,VMAP_PADRE_ID AS VMAP_ID FROM HAYA02.TMP_ALTA_BPM_INSTANCES) TMP;

    DBMS_OUTPUT.PUT_LINE('Insertamos la variable idCODIGOTAREA para cada instancia..') ;
    INSERT INTO HAYAMASTER.JBPM_VARIABLEINSTANCE
        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT HAYAMASTER.HIBERNATE_SEQUENCE.NEXTVAL
      ,'L' --CLASS_
      , 0 --VERSION_
      , 'id'||TMP.TAP_CODIGO||'.'||TMP.TOKEN_PADRE_ID --NAME_
      , TMP.TOKEN_PADRE_ID --TOKEM_
      , TMP.VMAP_PADRE_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , TMP.TEX_ID --LONGVLAUE_
    FROM HAYA02.TMP_ALTA_BPM_INSTANCES TMP;
  DBMS_OUTPUT.PUT_LINE('FIN VARIABLE INSTANCE!!') ;

--Insertamos variable sin concatenar TOKEN_PADRE_ID  
  
    DBMS_OUTPUT.PUT_LINE('Insertamos la variable idCODIGOTAREA para cada instancia..') ;
    INSERT INTO HAYAMASTER.JBPM_VARIABLEINSTANCE
        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
      SELECT HAYAMASTER.HIBERNATE_SEQUENCE.NEXTVAL
      ,'L' --CLASS_
      , 0 --VERSION_
      , 'id'||TMP.TAP_CODIGO --||'.'||TMP.TOKEN_PADRE_ID --NAME_
      , TMP.TOKEN_PADRE_ID --TOKEM_
      , TMP.VMAP_PADRE_ID  --TOKENVARIABLEMAP_
      , TMP.INST_ID --PROCESSINSTANCE_
      , TMP.TEX_ID --LONGVLAUE_
    FROM HAYA02.TMP_ALTA_BPM_INSTANCES TMP;
  DBMS_OUTPUT.PUT_LINE('FIN VARIABLE INSTANCE!!') ;  
  
  
  DBMS_OUTPUT.PUT_LINE('Actualizando los procedimientos...') ;
  MERGE INTO HAYA02.PRC_PROCEDIMIENTOS PRC
  USING (SELECT DISTINCT PRC_ID,INST_ID FROM HAYA02.TMP_ALTA_BPM_INSTANCES) TMP
  ON (PRC.PRC_ID = TMP.PRC_ID)
  WHEN MATCHED THEN UPDATE SET PRC.PRC_PROCESS_BPM = TMP.INST_ID
    ,USUARIOMODIFICAR = 'AUTO', fechamodificar = sysdate;
  DBMS_OUTPUT.PUT_LINE('Procedimientos actualziados!!!') ;

  DBMS_OUTPUT.PUT_LINE('Actualizando las TEX...') ;
  MERGE INTO HAYA02.TEX_TAREA_EXTERNA TEX
  USING (SELECT * FROM HAYA02.TMP_ALTA_BPM_INSTANCES) TMP
  ON (TEX.TEX_ID = TMP.TEX_ID)
  WHEN MATCHED THEN UPDATE SET TEX.TEX_TOKEN_ID_BPM = TMP.TOKEN_ID
    ,USUARIOMODIFICAR = 'AUTO', fechamodificar = sysdate;
  DBMS_OUTPUT.PUT_LINE('TEX actualiziadas...') ;

insert into HAYAMASTER.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_) 
	select HAYAMASTER.hibernate_sequence.nextval id_, 'activarProrroga' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_ 
	from ( 
	select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex 
	from HAYA02.tar_tareas_notificaciones tar 
	   join HAYA02.tex_tarea_externa tex on tar.tar_id = tex.tar_id 
	   join HAYA02.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id 
	   join HAYA02.prc_procedimientos prc on tar.prc_id = prc.prc_id 
	   join HAYAMASTER.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
	   join HAYAMASTER.jbpm_token tk on  tex.TEX_TOKEN_ID_BPM=tk.id_
  join HAYAMASTER.jbpm_node nd on tk.node_ = nd.id_  and nd.class_ <> 'F' 
    left join HAYAMASTER.jbpm_transition aux on nd.id_ = aux.from_ 
	   left join HAYAMASTER.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = 'activarProrroga' 
	where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) 
       and tar.prc_id is not null 
	     and tr.id_ is  null 
	group by nd.id_,nd.processdefinition_
  );

    Commit;


DBMS_OUTPUT.PUT_LINE('[FIN]');

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
