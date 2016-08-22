--/*
--##########################################
--## AUTOR=DAVID GONZALEZ
--## FECHA_CREACION=20160509
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-354
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(2048 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    		
    
BEGIN
    
--##CREACION DE TABLA, PK y FK de tabla

  	     	 
	EXECUTE IMMEDIATE 'CREATE OR REPLACE PROCEDURE '||V_ESQUEMA||'.ALTA_BPM_INSTANCES AS
				
		CURSOR CUR_PROCEDIMIENTOS IS WITH BPM_DEFINITIONS AS (
	     	SELECT NAME_, MAX(ID_) ID_ 
	     	FROM '||V_ESQUEMA_M||'.JBPM_PROCESSDEFINITION 
	     	GROUP BY NAME_
	    )
	    
	    , TAREAS AS (
		    SELECT  TAC.TRA_ID, TAR.TAR_ID
		    FROM TAR_TAREAS_NOTIFICACIONES TAR
		    JOIN TAC_TAREAS_ACTIVOS TAC on tac.tar_id = tar.tar_id
		   	WHERE (TAR_TAREA_FINALIZADA IS NULL OR TAR_TAREA_FINALIZADA = 0) AND TAC.BORRADO = 0
		)
		 
		, FORK_NODE AS (
		    SELECT PROCESSDEFINITION_, 
		    min(ID_) FORK_NODE
		    FROM '||V_ESQUEMA_M||'.jbpm_node 
			WHERE class_=''F'' GROUP BY PROCESSDEFINITION_
		)
		  	
		SELECT TRA.TRA_ID, DEF.ID_ DEFINITION_ID, NODE.ID_ NODE_ID, TAP.TAP_CODIGO, TEX.TEX_ID, Fk.FORK_NODE
		FROM ACT_TRA_TRAMITE TRA
		JOIN DD_TPO_TIPO_PROCEDIMIENTO TPO ON TRA.DD_TPO_ID = TPO.DD_TPO_ID
		JOIN BPM_DEFINITIONS DEF ON TPO.DD_TPO_XML_JBPM = DEF.NAME_
		JOIN TAREAS TAR ON TRA.TRA_ID = TAR.TRA_ID
		JOIN TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID
		JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
		JOIN '||V_ESQUEMA_M||'.JBPM_NODE NODE ON DEF.ID_ = NODE.PROCESSDEFINITION_ AND TAP.TAP_CODIGO = NODE.NAME_
		left join FORK_NODE FK ON FK.PROCESSDEFINITION_=DEF.ID_
		WHERE TRA.TRA_PROCESS_BPM IS NULL
		ORDER BY TRA_ID;
		  
		CURSOR CUR_PROCEDIMIENTOS2 IS
		SELECT TRA_ID, count(*) AS CUENTA FROM APR_AUX_ALTA_BPM_INSTANCES group by TRA_ID having count(*)>1;
		  
		TYPE T_PRC IS TABLE OF CUR_PROCEDIMIENTOS%ROWTYPE INDEX BY BINARY_INTEGER;
		L_PRC T_PRC;
		
		TYPE T_PRC2 IS TABLE OF CUR_PROCEDIMIENTOS2%ROWTYPE INDEX BY BINARY_INTEGER;
		L_PRC2 T_PRC2;
		  	
	 
	  	ID_TRAMITE NUMBER(16,0) := -1;
	  	ID_TRAMITE_ACTUAL NUMBER(16,0);
	 	INSTANCE_ID_ NUMBER(16,0);
	  	CURRENT_NODE_ NUMBER(16,0);
	  	CURRENT_FORK_ NUMBER(16,0);
	  	CURRENT_TOKEN_ NUMBER(16,0);
	  	CURRENT_TOKEN_PADRE_ NUMBER(16,0);
	  	CURRENT_MODULE_ID_ NUMBER(16,0);
	  	CURRENT_VMAP_ID_ NUMBER(16,0);
	  	V_DBID NUMBER(16);


		BEGIN
	
	  	  SELECT ENTIDAD_ID INTO V_DBID
		  FROM '||V_ESQUEMA_M||'.ENTIDADCONFIG
		  WHERE DATAKEY = ''schema'' AND UPPER(DATAVALUE) = ''REM01'';
		
		  /* ----- Reservamos ids objetos de BPM ------- */
		  DELETE FROM APR_AUX_ALTA_BPM_INSTANCES;
		  
		  
		    
		  /*------------ CURSOR ---------------------- */
		
		  DBMS_OUTPUT.PUT_LINE(''Asigna las instancias...'') ;
		  FOR L_PRC in CUR_PROCEDIMIENTOS
		  LOOP
		
		    ID_TRAMITE_ACTUAL:= L_PRC.TRA_ID;
		    IF ID_TRAMITE_ACTUAL<>ID_TRAMITE THEN
		      ID_TRAMITE := ID_TRAMITE_ACTUAL;
		      INSTANCE_ID_ := '||V_ESQUEMA_M||'.HIBERNATE_SEQUENCE.NEXTVAL;
		    END IF;
		    
		    INSERT INTO APR_AUX_ALTA_BPM_INSTANCES(TRA_ID, INST_ID,DEF_ID, NODE_ID, TAP_CODIGO, TEX_ID, FORK_NODE) 
		    VALUES (L_PRC.TRA_ID, INSTANCE_ID_, L_PRC.DEFINITION_ID, L_PRC.NODE_ID, L_PRC.TAP_CODIGO, L_PRC.TEX_ID, L_PRC.FORK_NODE);
		    
		    --DBMS_OUTPUT.PUT_LINE(L_PRC.TRA_ID || ''--'' || INSTANCE_ID_ || ''--'' || L_PRC.DEFINITION_ID) ;
		  END LOOP;

		  COMMIT;
		  DBMS_OUTPUT.PUT_LINE(''Instancias asignadas!!'') ;
		 
		  DBMS_OUTPUT.PUT_LINE(''Asigna los nodos root...'') ;
		  ID_TRAMITE := -1;
		  FOR L_PRC2 in CUR_PROCEDIMIENTOS2
		  LOOP
		
		    ID_TRAMITE_ACTUAL:= L_PRC2.TRA_ID;
		    IF ID_TRAMITE_ACTUAL<>ID_TRAMITE THEN
		      ID_TRAMITE := ID_TRAMITE_ACTUAL;
		      CURRENT_TOKEN_PADRE_ := '||V_ESQUEMA_M||'.HIBERNATE_SEQUENCE.NEXTVAL;
		    END IF;
		
		    UPDATE APR_AUX_ALTA_BPM_INSTANCES
		    SET
		      TOKEN_PADRE_ID=CURRENT_TOKEN_PADRE_, 
		      MODULE_PADRE_ID=CURRENT_TOKEN_PADRE_, 
		      VMAP_PADRE_ID=CURRENT_TOKEN_PADRE_
		    WHERE TRA_ID=ID_TRAMITE_ACTUAL;
		    
		    --DBMS_OUTPUT.PUT_LINE(L_PRC.TRA_ID || ''--'' || INSTANCE_ID_ || ''--'' || L_PRC.DEFINITION_ID) ;
		  END LOOP;
		  DBMS_OUTPUT.PUT_LINE(''Asignados los nodos root!!'') ;
		 
		  DBMS_OUTPUT.PUT_LINE(''Asigna los IDs de token...'') ;
		  UPDATE APR_AUX_ALTA_BPM_INSTANCES SET 
		    TOKEN_ID = '||V_ESQUEMA_M||'.HIBERNATE_SEQUENCE.NEXTVAL
		    ,MODULE_ID='||V_ESQUEMA_M||'.HIBERNATE_SEQUENCE.NEXTVAL
		    ,VMAP_ID = '||V_ESQUEMA_M||'.HIBERNATE_SEQUENCE.NEXTVAL;
		  DBMS_OUTPUT.PUT_LINE(''IDs de token asignados...'') ;
		
		  DBMS_OUTPUT.PUT_LINE(''Actualizando tokens padre...'') ;
		  UPDATE APR_AUX_ALTA_BPM_INSTANCES SET 
		    TOKEN_PADRE_ID = TOKEN_ID
		    ,MODULE_PADRE_ID=MODULE_ID
		    ,VMAP_PADRE_ID = VMAP_ID
		    WHERE TOKEN_PADRE_ID IS NULL;
		  DBMS_OUTPUT.PUT_LINE(''Actualizando tokens padre!!'') ;
		
		  COMMIT;
		  DBMS_OUTPUT.PUT_LINE(''---------------------------------'') ;
		  DBMS_OUTPUT.PUT_LINE(''COMIENZA LA INSERCION DE DATOS...'') ;
		  DBMS_OUTPUT.PUT_LINE(''---------------------------------'') ;
		
		  DBMS_OUTPUT.PUT_LINE(''Inserta las instancias...'') ;
		  INSERT INTO '||V_ESQUEMA_M||'.JBPM_PROCESSINSTANCE
		      (ID_, VERSION_, START_, END_, ISSUSPENDED_, PROCESSDEFINITION_)
		  SELECT DISTINCT TMP.INST_ID -- ID_
		          ,1 --VERSION
		          , SYSDATE --START_
		          ,NULL --END_
		          , 0 --ISSUSPENDED_
		          , TMP.DEF_ID --PRCESSDEFINITION_
		  FROM APR_AUX_ALTA_BPM_INSTANCES TMP;
		  DBMS_OUTPUT.PUT_LINE(''Instancias insertados!!'') ;
		
		  DBMS_OUTPUT.PUT_LINE(''Insertando los root token...'') ;
		  INSERT INTO '||V_ESQUEMA_M||'.JBPM_TOKEN
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
		      FROM APR_AUX_ALTA_BPM_INSTANCES TMP WHERE TOKEN_PADRE_ID<>TOKEN_ID;
		  DBMS_OUTPUT.PUT_LINE(''Insertadoslos root token!!!'') ;
		
		  DBMS_OUTPUT.PUT_LINE(''Insertando tokens...'') ;
		  INSERT INTO '||V_ESQUEMA_M||'.JBPM_TOKEN
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
		      FROM APR_AUX_ALTA_BPM_INSTANCES TMP;
		
		
			UPDATE '||V_ESQUEMA_M||'.Jbpm_Token SET parent_=null WHERE id_=parent_;
		
			MERGE INTO '||V_ESQUEMA_M||'.Jbpm_Token T
			USING (
			select T.ID_, N.NAME_  from '||V_ESQUEMA_M||'.Jbpm_Token T
			join '||V_ESQUEMA_M||'.Jbpm_Node N on T.NODE_=N.ID_
			where T.name_ is null) TMP
			ON (TMP.ID_=T.ID_)
			WHEN MATCHED THEN UPDATE SET T.NAME_=TMP.NAME_;
		
		  DBMS_OUTPUT.PUT_LINE(''TOKENS insertados...'') ;
		
		  DBMS_OUTPUT.PUT_LINE(''Actualizando las instancias...'') ;
		  MERGE INTO '||V_ESQUEMA_M||'.JBPM_PROCESSINSTANCE INS
		  USING (SELECT DISTINCT INST_ID, TOKEN_PADRE_ID AS TOKEN FROM APR_AUX_ALTA_BPM_INSTANCES) TMP
		  ON (INS.ID_ = TMP.INST_ID)
		  WHEN MATCHED THEN UPDATE SET INS.ROOTTOKEN_ = TMP.TOKEN;
		  DBMS_OUTPUT.PUT_LINE(''Instancias actualizadas!!'');
		
		    DBMS_OUTPUT.PUT_LINE(''Actualizando las module y vmap...'') ;
		    INSERT INTO '||V_ESQUEMA_M||'.JBPM_MODULEINSTANCE
		            (ID_, CLASS_, VERSION_, PROCESSINSTANCE_, NAME_)
		        SELECT  DISTINCT TMP.MODULE_PADRE_ID
		            , ''C'' --CLASS_
		            , 0 --VERSION_
		            , TMP.INST_ID --PROCESSINSTANCE_
		            , ''org.jbpm.context.exe.ContextInstance'' --NAME_
		    FROM APR_AUX_ALTA_BPM_INSTANCES TMP;
		
		    INSERT INTO '||V_ESQUEMA_M||'.JBPM_TOKENVARIABLEMAP
		            (ID_, VERSION_, TOKEN_, CONTEXTINSTANCE_)
		      SELECT DISTINCT TMP.VMAP_PADRE_ID
		        , 0 --VERSION_
		        , TMP.TOKEN_PADRE_ID --ROOTTOKEN_
		        , TMP.MODULE_PADRE_ID  --CONTEXTINSTANCE_
		    FROM APR_AUX_ALTA_BPM_INSTANCES TMP;
		  DBMS_OUTPUT.PUT_LINE(''module y vmap actualizadas!!'') ;
		
		    DBMS_OUTPUT.PUT_LINE(''Actualizando VARIABLE INSTABLE...'') ;
		
		    DBMS_OUTPUT.PUT_LINE(''Insertamos la variable DB_ID para cada instancia..'') ;
		    INSERT INTO '||V_ESQUEMA_M||'.JBPM_VARIABLEINSTANCE
		        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
		      SELECT '||V_ESQUEMA_M||'.HIBERNATE_SEQUENCE.NEXTVAL
		      ,''L'' --CLASS_
		      , 0 --VERSION_
		      , ''DB_ID'' --NAME_
		      , TMP.TOKEN_ID --TOKEM_
		      , TMP.VMAP_ID  --TOKENVARIABLEMAP_
		      , TMP.INST_ID --PROCESSINSTANCE_
		      , V_DBID --LONGVLAUE_
		    FROM (SELECT DISTINCT INST_ID, TRA_ID, TOKEN_PADRE_ID AS TOKEN_ID,MODULE_PADRE_ID AS MODULE_ID,VMAP_PADRE_ID AS VMAP_ID FROM APR_AUX_ALTA_BPM_INSTANCES) TMP;
		
		    DBMS_OUTPUT.PUT_LINE(''Insertamos la variable procedimientoTareaExterna para cada instancia..'') ;
		    INSERT INTO '||V_ESQUEMA_M||'.JBPM_VARIABLEINSTANCE
		        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
		      SELECT '||V_ESQUEMA_M||'.HIBERNATE_SEQUENCE.NEXTVAL
		        ,''L'' --CLASS_
		        , 0 --VERSION_
		        , ''procedimientoTareaExterna'' --NAME_
		        , TMP.TOKEN_ID --TOKEM_
		        , TMP.VMAP_ID  --TOKENVARIABLEMAP_
		        , TMP.INST_ID --PROCESSINSTANCE_
		        , TMP.TRA_ID --LONGVLAUE_
		    FROM (SELECT DISTINCT INST_ID, TRA_ID, TOKEN_PADRE_ID AS TOKEN_ID,MODULE_PADRE_ID AS MODULE_ID,VMAP_PADRE_ID AS VMAP_ID FROM APR_AUX_ALTA_BPM_INSTANCES) TMP;
		
		    DBMS_OUTPUT.PUT_LINE(''Insertamos la variable bpmParalizado para cada instancia..'') ;
		    INSERT INTO '||V_ESQUEMA_M||'.JBPM_VARIABLEINSTANCE
		        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
		      SELECT '||V_ESQUEMA_M||'.HIBERNATE_SEQUENCE.NEXTVAL
		      ,''L'' --CLASS_
		      , 0 --VERSION_
		      , ''bpmParalizado'' --NAME_
		      , TMP.TOKEN_ID --TOKEM_
		      , TMP.VMAP_ID  --TOKENVARIABLEMAP_
		      , TMP.INST_ID --PROCESSINSTANCE_
		      , 0 --LONGVLAUE_
		    FROM (SELECT DISTINCT INST_ID, TRA_ID, TOKEN_PADRE_ID AS TOKEN_ID,MODULE_PADRE_ID AS MODULE_ID,VMAP_PADRE_ID AS VMAP_ID FROM APR_AUX_ALTA_BPM_INSTANCES) TMP;
		
		    DBMS_OUTPUT.PUT_LINE(''Insertamos la variable idCODIGOTAREA para cada instancia..'') ;
		    INSERT INTO '||V_ESQUEMA_M||'.JBPM_VARIABLEINSTANCE
		        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
		      SELECT '||V_ESQUEMA_M||'.HIBERNATE_SEQUENCE.NEXTVAL
		      ,''L'' --CLASS_
		      , 0 --VERSION_
		      , ''id''||TMP.TAP_CODIGO||''.''||TMP.TOKEN_PADRE_ID --NAME_
		      , TMP.TOKEN_PADRE_ID --TOKEM_
		      , TMP.VMAP_PADRE_ID  --TOKENVARIABLEMAP_
		      , TMP.INST_ID --PROCESSINSTANCE_
		      , TMP.TEX_ID --LONGVLAUE_
		    FROM APR_AUX_ALTA_BPM_INSTANCES TMP;
		  DBMS_OUTPUT.PUT_LINE(''FIN VARIABLE INSTANCE!!'') ;
		
		--Insertamos variable sin concatenar TOKEN_PADRE_ID    
		  
		    INSERT INTO '||V_ESQUEMA_M||'.JBPM_VARIABLEINSTANCE
		        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
		      SELECT '||V_ESQUEMA_M||'.HIBERNATE_SEQUENCE.NEXTVAL
		      ,''L'' --CLASS_
		      , 0 --VERSION_
		      , ''id''||TMP.TAP_CODIGO --||''.''||TMP.TOKEN_PADRE_ID --NAME_
		      , TMP.TOKEN_PADRE_ID --TOKEM_
		      , TMP.VMAP_PADRE_ID  --TOKENVARIABLEMAP_
		      , TMP.INST_ID --PROCESSINSTANCE_
		      , TMP.TEX_ID --LONGVLAUE_
		    FROM APR_AUX_ALTA_BPM_INSTANCES TMP;
		  DBMS_OUTPUT.PUT_LINE(''FIN VARIABLE INSTANCE!!'') ;  
		  
		    INSERT INTO '||V_ESQUEMA_M||'.JBPM_VARIABLEINSTANCE
		        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)
		      SELECT '||V_ESQUEMA_M||'.HIBERNATE_SEQUENCE.NEXTVAL
		      ,''L'' --CLASS_
		      , 0 --VERSION_
		      , ''activoTramiteTareaExterna''--NAME_
		      , TMP.TOKEN_PADRE_ID --TOKEM_
		      , TMP.VMAP_PADRE_ID  --TOKENVARIABLEMAP_
		      , TMP.INST_ID --PROCESSINSTANCE_
		      , TMP.TRA_ID --LONGVLAUE_
		    FROM APR_AUX_ALTA_BPM_INSTANCES TMP;  
		  DBMS_OUTPUT.PUT_LINE(''FIN VARIABLE INSTANCE!!'') ;  
		  
		  DBMS_OUTPUT.PUT_LINE(''Actualizando los trámites...'') ;
		  MERGE INTO ACT_TRA_TRAMITE TRA
		  USING (SELECT DISTINCT TRA_ID,INST_ID FROM APR_AUX_ALTA_BPM_INSTANCES) TMP
		  ON (TRA.TRA_ID = TMP.TRA_ID)
		  WHEN MATCHED THEN UPDATE SET TRA.TRA_PROCESS_BPM = TMP.INST_ID
		    ,USUARIOMODIFICAR = ''AUTO'', fechamodificar = sysdate;
		  DBMS_OUTPUT.PUT_LINE(''Trámites actualziados!!!'') ;
		
		  DBMS_OUTPUT.PUT_LINE(''Actualizando las TEX...'') ;
		  MERGE INTO TEX_TAREA_EXTERNA TEX
		  USING (SELECT * FROM APR_AUX_ALTA_BPM_INSTANCES) TMP
		  ON (TEX.TEX_ID = TMP.TEX_ID)
		  WHEN MATCHED THEN UPDATE SET TEX.TEX_TOKEN_ID_BPM = TMP.TOKEN_ID
		    ,USUARIOMODIFICAR = ''AUTO'', fechamodificar = sysdate;
		  DBMS_OUTPUT.PUT_LINE(''TEX actualiziadas...'');
		  
	END ALTA_BPM_INSTANCES;';
		  
	DBMS_OUTPUT.PUT('[INFO] Procedure PROCEDURE ALTA_BPM_INSTANCES: CREADO...OK');
		
			
	COMMIT;
		


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
