/*
--##########################################
--## AUTOR=Sergio Nieto Gil
--## FECHA_CREACION=20160609
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1942
--## PRODUCTO=SI
--##
--## Finalidad: Recuperar tarea perdida P. Hipotecario
--## INSTRUCCIONES:  Ejecutar y definir las variables
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_TGE VARCHAR2(4000 CHAR); -- Vble. para la query de consultar el id del codigo TGE.  
    V_ID_TGE VARCHAR2(25 CHAR); --Vbla. para almacenar el id del TGE
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT2 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID_ASUNTO VARCHAR2(2400 CHAR); -- Vble. auxiliar para guardarnos el id del asunto a modificar
    V_ID_PROCEDIMIENTO VARCHAR2(2400 CHAR); -- Vble. auxiliar para guardarnos el id del procedimiento a modificar
	V_TAP_ID VARCHAR2(2400 CHAR); -- Vble. auxiliar para guardarnos el tap_id a insertar modificar
	V_TAREA_DESCRIPCION VARCHAR2(2400 CHAR); -- Vble. auxiliar para guardarnos el nombre de la tarea faltante
	V_USU_CREAR VARCHAR2(2400 CHAR); -- Vble. auxiliar para guardarnos el nombre de la incidencia
	V_TAP_CODIGO VARCHAR2(2400 CHAR); -- Vble. auxiliar para guardarnos el tab_codigo para buscar el DD_STA_ID

BEGIN	
	

	-- Seteamos las variables a utilizar(ID_Asunto, ID_Procedimiento, Tap_id, descripción de la tarea, usu_crear, tap_codigo )
	V_ID_ASUNTO:= 1000000000003872;
	V_ID_PROCEDIMIENTO := 1000000000033872;
	V_TAREA_DESCRIPCION := 'Confirmar si existe oposición';
	V_USU_CREAR := 'PRODUCTO-1974';
	V_TAP_CODIGO := 'H001_ConfirmarSiExisteOposicion';
      -- LOOP Insertando valores en DD_STA_SUBTIPO_TAREA_BASE ------------------------------------------------------------------------

    DBMS_OUTPUT.PUT_LINE('[INICIO] Creación de las tareas en el caso que no existan');
    
	DBMS_OUTPUT.PUT_LINE('Buscamos el tap_id');
    
    V_SQL := 'SELECT TAP_ID FROM ' ||V_ESQUEMA|| '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAP_CODIGO||''''; 

    EXECUTE IMMEDIATE V_SQL INTO V_TAP_ID;
    
    DBMS_OUTPUT.PUT_LINE('Comprobación en TAR_TAREAS_NOTIFICACIONES');

	V_SQL := 'SELECT COUNT(1) FROM ' ||V_ESQUEMA|| '.TAR_TAREAS_NOTIFICACIONES WHERE PRC_ID = '||V_ID_PROCEDIMIENTO||' and TAR_TAREA = '''||V_TAREA_DESCRIPCION||''' and ASU_ID = '||V_ID_ASUNTO||'' ;
    
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TAR_TAREAS_NOTIFICACIONES... Ya existe la tarea Confirmar si existe oposición en TAR_TAREA_NOTIFICACION ');
    ELSE
    
    V_SQL := 'SELECT DD_STA_ID FROM ' ||V_ESQUEMA|| '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAP_CODIGO||''''; 

    EXECUTE IMMEDIATE V_SQL INTO V_TEXT1;
    
    	V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.TAR_TAREAS_NOTIFICACIONES (TAR_ID, ASU_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, TAR_FECHA_INI ,TAR_EN_ESPERA, TAR_ALERTA, TAR_TAREA_FINALIZADA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PRC_ID,DTYPE, NFA_TAR_REVISADA) 
				VALUES ('||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL, '||V_ID_ASUNTO||', 6, 5, '||V_TEXT1||', ''1'', '''||V_TAREA_DESCRIPCION||''', '''||V_TAREA_DESCRIPCION||''', SYSDATE, 0, 0, 0, 0, '''||V_USU_CREAR||''', SYSDATE, 0, '||V_ID_PROCEDIMIENTO||', ''EXTTareaNotificacion'', 0)';
				EXECUTE IMMEDIATE V_MSQL;	
      	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TAR_TAREAS_NOTIFICACIONES... Insertada la tarea en TAR_TAREA_NOTIFICACION ');
	END IF;
   
	DBMS_OUTPUT.PUT_LINE('[INFO]Comprobación terminada en TAR_TAREAS_NOTIFICACIONES');
   
    DBMS_OUTPUT.PUT_LINE('Comprobación en TEX_TAREA_EXTERNA');
    
    V_SQL := 'SELECT TAR_ID FROM ' ||V_ESQUEMA|| '.TAR_TAREAS_NOTIFICACIONES WHERE PRC_ID = '||V_ID_PROCEDIMIENTO||' and TAR_TAREA ='''||V_TAREA_DESCRIPCION||''' and ASU_ID = '||V_ID_ASUNTO||''; 

    EXECUTE IMMEDIATE V_SQL INTO V_TEXT1;
    
	V_SQL := 'SELECT COUNT(1) FROM ' ||V_ESQUEMA|| '.TEX_TAREA_EXTERNA WHERE TAR_ID = '||V_TEXT1||' '; 
    
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEX_TAREA_EXTERNA... Ya existe la TAR_TAREA_NOTIFICACION en TEX_TAREA_EXTERNA ');
    ELSE
    	V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.TEX_TAREA_EXTERNA (TEX_ID, TAR_ID, TAP_ID,TEX_DETENIDA, VERSION, USUARIOCREAR, FECHACREAR, TEX_CANCELADA,TEX_NUM_AUTOP, DTYPE) 
				VALUES ('||V_ESQUEMA||'.S_TEX_TAREA_EXTERNA.NEXTVAL, '||V_TEXT1||', '||V_TAP_ID||', 0, 0, '''||V_USU_CREAR||''', SYSDATE, 0, 0,  ''EXTTareaExterna'')';
				EXECUTE IMMEDIATE V_MSQL;	
      	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEX_TAREA_EXTERNA... Insertada la tarea en TEX_TAREA_EXTERNA ');
	END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO]Comprobación terminada en TEX_TAREA_EXTERNA');  
    
    DBMS_OUTPUT.PUT_LINE('Insertando en BPM_REACTIVAR_BPM');
    
    V_SQL := 'SELECT TEX_ID FROM ' ||V_ESQUEMA|| '.TEX_TAREA_EXTERNA WHERE TAR_ID = '||V_TEXT1||' ';  

    EXECUTE IMMEDIATE V_SQL INTO V_TEXT2;
        
    V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.BPM_REACTIVAR_BPM (RPR_REFERENCIA, PRC_ID, TAP_ID, TEX_ID) 
				VALUES ('||V_ESQUEMA||'.S_BPM_REACTIVAR_BPM.NEXTVAL, '||V_ID_PROCEDIMIENTO||','||V_TAP_ID||','||V_TEXT2||')';
		EXECUTE IMMEDIATE V_MSQL;	
      	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BPM_REACTIVAR_BPM... Insertado en la tabla ');

    DBMS_OUTPUT.PUT_LINE('[INFO]Comprobación terminada en BPM_REACTIVAR_BPM');
    
	
        
    DBMS_OUTPUT.PUT_LINE('Limpiando restos de ejecuciones anteriores');
    
	V_MSQL := 'update ' || V_ESQUEMA || '.prc_procedimientos set rpr_referencia = null where rpr_referencia is not null';
	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'update ' || V_ESQUEMA || '.tar_tareas_notificaciones set rpr_referencia = null where rpr_referencia is not null';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'update ' || V_ESQUEMA || '.tex_tarea_externa set rpr_referencia = null where rpr_referencia is not null';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'update ' || V_ESQUEMA_M || '.jbpm_token set rpr_referencia = null where rpr_referencia is not null';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'update ' || V_ESQUEMA_M || '.jbpm_processinstance set rpr_referencia = null where rpr_referencia is not null';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('Guardando los cambios');
	    
    V_SQL := 'select count(*) rpr_ref from ' || V_ESQUEMA_M || '.JBPM_PROCESSINSTANCE where rpr_referencia is not null';
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('Creando instancias del BPM');

	V_MSQL := 'Insert into ' || V_ESQUEMA_M || '.JBPM_PROCESSINSTANCE
	   (ID_, VERSION_, START_, END_, ISSUSPENDED_, PROCESSDEFINITION_,rpr_referencia)
	select ' || V_ESQUEMA_M || '.HIBERNATE_SEQUENCE.nextval
	,1 VERSION_
	, SYSDATE START_
	,NULL END_
	, 0 issuspended_
	, maxpd.id_ PROCESSDEFINITION_
	, tmp.rpr_referencia
	from bpm_reactivar_bpm tmp
	    join ' || V_ESQUEMA || '.prc_procedimientos prc on tmp.prc_id = prc.prc_id
	    join ' || V_ESQUEMA || '.dd_tpo_tipo_procedimiento tpo on prc.dd_tpo_id = tpo.dd_tpo_id
	    join (select name_, max(id_) id_ from ' || V_ESQUEMA_M || '.jbpm_processdefinition group by name_) maxpd on tpo.dd_tpo_xml_jbpm = maxpd.name_';
	EXECUTE IMMEDIATE V_MSQL;

	V_SQL := 'select count(*) inst_ref from hayamaster.JBPM_PROCESSINSTANCE where rpr_referencia is not null';
	EXECUTE IMMEDIATE V_SQL;

	V_MSQL := 'merge into ' || V_ESQUEMA || '.prc_procedimientos prc using
	(
	    select prc.prc_id, prc.prc_process_bpm viejo, pi.id_ nuevo
	    from ' || V_ESQUEMA || '.prc_procedimientos prc
	    join ' || V_ESQUEMA || '.bpm_reactivar_bpm tmp on prc.prc_id = tmp.prc_id
	    join ' || V_ESQUEMA_M || '.jbpm_processinstance pi on tmp.rpr_referencia = pi.rpr_referencia 
	) tmp
	on (prc.prc_id = tmp.prc_id)
	when matched then update set prc.PRC_PROCESS_BPM = tmp.nuevo';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('insertando el token');


	V_MSQL := 'Insert into ' || V_ESQUEMA_M || '.JBPM_TOKEN
	   (ID_, VERSION_, START_, END_, NODEENTER_, ISSUSPENDED_, NODE_, PROCESSINSTANCE_, rpr_referencia)
	select ' || V_ESQUEMA_M || '.hibernate_sequence.nextval
	, 1 VERSION_
	, SYSDATE START_
	, null end_
	, sysdate nodeenter_
	, 0 issuspended_
	, node.id_ node_
	, pi.id_ processinstance_
	, tmp.rpr_referencia
	from ' || V_ESQUEMA || '.bpm_reactivar_bpm tmp
	    join ' || V_ESQUEMA || '.tap_tarea_procedimiento tap on tmp.tap_id = tap.tap_id
	    join ' || V_ESQUEMA || '.prc_procedimientos prc on tmp.prc_id = prc.prc_id
	    join ' || V_ESQUEMA || '.dd_tpo_tipo_procedimiento tpo on prc.dd_tpo_id = tpo.dd_tpo_id
	    join ' || V_ESQUEMA_M || '.jbpm_processinstance pi on tmp.rpr_referencia = pi.rpr_referencia
	    join ' || V_ESQUEMA_M || '.jbpm_node node on pi.processdefinition_ = node.processdefinition_ and tap.tap_codigo = node.name_';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('Actualizando el roottoken en la instancia del BPM');

	V_MSQL := 'merge into ' || V_ESQUEMA_M || '.jbpm_processinstance pi using
	(
	select pi.id_ id, pi.roottoken_ viejo, tk.id_ nuevo
	from ' || V_ESQUEMA_M || '.jbpm_processinstance pi
	    join ' || V_ESQUEMA_M || '.jbpm_token tk on pi.rpr_referencia = tk.rpr_referencia    
	where pi.rpr_referencia is not null
	) tmp on (pi.id_ = tmp.id)
	when matched then update set pi.roottoken_ = tmp.nuevo';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('Actualizando el token en la tarea externa');


	V_MSQL := 'merge into ' || V_ESQUEMA || '.tex_tarea_externa tex using 
	(
	select tex.tex_id, tex.tex_token_id_bpm viejo, tk.id_ nuevo
	from ' || V_ESQUEMA || '.bpm_reactivar_bpm tmp
	    join ' || V_ESQUEMA || '.tex_tarea_externa tex on tmp.tex_id = tex.tex_id
	    join ' || V_ESQUEMA_M || '.jbpm_token tk on tmp.rpr_referencia = tk.rpr_referencia    
	) tmp on (tex.tex_id = tmp.tex_id)
	when matched then update set tex.tex_token_id_bpm = tmp.nuevo';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('Preparando el contexto del BPM');

	V_MSQL := 'Insert into ' || V_ESQUEMA_M || '.JBPM_MODULEINSTANCE
	   (ID_, CLASS_, VERSION_, PROCESSINSTANCE_, NAME_)   
	select ' || V_ESQUEMA_M || '.hibernate_sequence.nextval
	, ''C'' class_
	, 0 version_
	, prc.prc_process_bpm processinstance_
	, ''org.jbpm.context.exe.ContextInstance'' name_
	from ' || V_ESQUEMA || '.bpm_reactivar_bpm tmp
	    join ' || V_ESQUEMA || '.prc_procedimientos prc on tmp.prc_id = prc.prc_id
	    join ' || V_ESQUEMA_M || '.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_
	    join ' || V_ESQUEMA_M || '.jbpm_token tk on pi.roottoken_ = tk.id_
	    join ' || V_ESQUEMA_M || '.jbpm_node nd on tk.node_ = nd.id_
	    join ' || V_ESQUEMA || '.tex_tarea_externa tex on tk.id_ = tex.tex_token_id_bpm and tex.borrado = 0
	where not exists (
	    select * from hayamaster.JBPM_MODULEINSTANCE where processinstance_ = prc.prc_process_bpm
	)';
	EXECUTE IMMEDIATE V_MSQL;
      
	V_MSQL := 'Insert into ' || V_ESQUEMA_M || '.JBPM_TOKENVARIABLEMAP 
   	(ID_, VERSION_, TOKEN_, CONTEXTINSTANCE_)      
	select hayamaster.hibernate_sequence.nextval
	, 0 version_
	, pi.roottoken_
	, mi.id_  contextinstance_
	from bpm_reactivar_bpm tmp
	    join prc_procedimientos prc on tmp.prc_id = prc.prc_id
	    join ' || V_ESQUEMA_M || '.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_
	    join ' || V_ESQUEMA_M || '.JBPM_MODULEINSTANCE mi on pi.id_ = mi.processinstance_
	    join ' || V_ESQUEMA_M || '.jbpm_token tk on pi.roottoken_ = tk.id_
	    join ' || V_ESQUEMA_M || '.jbpm_node nd on tk.node_ = nd.id_
	    join ' || V_ESQUEMA || '.tex_tarea_externa tex on tk.id_ = tex.tex_token_id_bpm and tex.borrado = 0
	where not exists (select * from ' || V_ESQUEMA_M || '.JBPM_TOKENVARIABLEMAP where token_ = pi.roottoken_)';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('Insertando variables en el contexto del BPM');

	V_MSQL := 'Insert into ' || V_ESQUEMA_M || '.JBPM_VARIABLEINSTANCE
	   (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)      
	select ' || V_ESQUEMA_M || '.hibernate_sequence.nextval
	,''L'' class_
	, 0 version_ 
	, ''DB_ID'' name_
	, pi.roottoken_ tokem_
	, vm.id_ tokenvariablemap_
	, pi.id_ processinstance_
	, 1 longvlaue_
	from ' || V_ESQUEMA || '.bpm_reactivar_bpm tmp
	    join ' || V_ESQUEMA || '.prc_procedimientos prc on tmp.prc_id = prc.prc_id
	    join ' || V_ESQUEMA_M || '.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_
	    join ' || V_ESQUEMA_M || '.JBPM_TOKENVARIABLEMAP vm on pi.roottoken_ = vm.token_
	    join ' || V_ESQUEMA_M || '.jbpm_token tk on pi.roottoken_ = tk.id_
	    join ' || V_ESQUEMA_M || '.jbpm_node nd on tk.node_ = nd.id_
	    join ' || V_ESQUEMA || '.tex_tarea_externa tex on tk.id_ = tex.tex_token_id_bpm and tex.borrado = 0
	where not exists (select * from ' || V_ESQUEMA_M || '.JBPM_VARIABLEINSTANCE where processinstance_ = pi.id_ and name_ = ''DB_ID'')';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'Insert into ' || V_ESQUEMA_M || '.JBPM_VARIABLEINSTANCE
   	(ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)      
	select ' || V_ESQUEMA_M || '.hibernate_sequence.nextval
	,''L'' class_
	, 0 version_ 
	, ''procedimientoTareaExterna'' name_
	, pi.roottoken_ tokem_
	, vm.id_ tokenvariablemap_
	, pi.id_ processinstance_
	, prc.prc_id longvlaue_
	from ' || V_ESQUEMA || '.bpm_reactivar_bpm tmp
	    join ' || V_ESQUEMA || '.prc_procedimientos prc on tmp.prc_id = prc.prc_id
	    join ' || V_ESQUEMA_M || '.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_
	    join ' || V_ESQUEMA_M || '.JBPM_TOKENVARIABLEMAP vm on pi.roottoken_ = vm.token_
	    join ' || V_ESQUEMA_M || '.jbpm_token tk on pi.roottoken_ = tk.id_
	    join ' || V_ESQUEMA_M || '.jbpm_node nd on tk.node_ = nd.id_
	    join ' || V_ESQUEMA || '.tex_tarea_externa tex on tk.id_ = tex.tex_token_id_bpm and tex.borrado = 0
	where not exists (select * from ' || V_ESQUEMA_M || '.JBPM_VARIABLEINSTANCE where processinstance_ = pi.id_ and name_ = ''procedimientoTareaExterna'')';
	EXECUTE IMMEDIATE V_MSQL;
	
	
	V_MSQL := 'Insert into ' || V_ESQUEMA_M || '.JBPM_VARIABLEINSTANCE
   	(ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)      
	select ' || V_ESQUEMA_M || '.hibernate_sequence.nextval
	,''L'' class_
	, 0 version_ 
	, ''bpmParalizado'' name_
	, pi.roottoken_ tokem_
	, vm.id_ tokenvariablemap_
	, pi.id_ processinstance_
	, 0 longvlaue_
	from ' || V_ESQUEMA || '.bpm_reactivar_bpm tmp
	    join ' || V_ESQUEMA || '.prc_procedimientos prc on tmp.prc_id = prc.prc_id
	    join ' || V_ESQUEMA_M || '.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_
	    join ' || V_ESQUEMA_M || '.JBPM_TOKENVARIABLEMAP vm on pi.roottoken_ = vm.token_
	    join ' || V_ESQUEMA_M || '.jbpm_token tk on pi.roottoken_ = tk.id_
	    join ' || V_ESQUEMA_M || '.jbpm_node nd on tk.node_ = nd.id_
	    join ' || V_ESQUEMA || '.tex_tarea_externa tex on tk.id_ = tex.tex_token_id_bpm and tex.borrado = 0
	where not exists (select * from ' || V_ESQUEMA_M || '.JBPM_VARIABLEINSTANCE where processinstance_ = pi.id_ and name_ = ''bpmParalizado'')';
	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'Insert into ' || V_ESQUEMA_M || '.JBPM_VARIABLEINSTANCE
   (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)      
	select ' || V_ESQUEMA_M || '.hibernate_sequence.nextval
	,''L'' class_
	, 0 version_ 
	, ''id''||nd.name_ name_
	, pi.roottoken_ tokem_
	, vm.id_ tokenvariablemap_
	, pi.id_ processinstance_
	, tex.tex_id longvlaue_
	from ' || V_ESQUEMA || '.bpm_reactivar_bpm tmp
	    join ' || V_ESQUEMA || '.prc_procedimientos prc on tmp.prc_id = prc.prc_id
	    join ' || V_ESQUEMA_M || '.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_
	    join ' || V_ESQUEMA_M || '.jbpm_token tk on pi.roottoken_ = tk.id_
	    join ' || V_ESQUEMA_M || '.jbpm_node nd on tk.node_ = nd.id_
	    join ' || V_ESQUEMA_M || '.JBPM_TOKENVARIABLEMAP vm on pi.roottoken_ = vm.token_
	    join ' || V_ESQUEMA || '.tex_tarea_externa tex on tk.id_ = tex.tex_token_id_bpm and tex.borrado = 0
	where not exists (select * from ' || V_ESQUEMA_M || '.JBPM_VARIABLEINSTANCE where processinstance_ = pi.id_ and name_ = ''id''||nd.name_)';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('Actualizando tablas del BPM');

	V_MSQL := 'update ' || V_ESQUEMA_M || '.jbpm_token set nextlogindex_ = 0 where nextlogindex_ is null';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'update ' || V_ESQUEMA_M || '.jbpm_token set isabletoreactivateparent_ = 0 where isabletoreactivateparent_ is null';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'update ' || V_ESQUEMA_M || '.jbpm_token set isterminationimplicit_ = 0 where isterminationimplicit_ is null';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('Actualizando la fecha de revision de los procedimientos revisados');
	
	DBMS_OUTPUT.PUT_LINE('Insertando transiciones que puedan faltar');

	V_MSQL := 'insert into ' || V_ESQUEMA_M || '.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_)
	select ' || V_ESQUEMA_M || '.hibernate_sequence.nextval id_, ''activarProrroga'' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_
	from (
	select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex
	from ' || V_ESQUEMA || '.bpm_reactivar_bpm tmp
	    join ' || V_ESQUEMA || '.prc_procedimientos prc on tmp.prc_id = prc.prc_id
	    join ' || V_ESQUEMA || '.tex_tarea_externa tex on tmp.tex_id = tex.tex_id
	    join ' || V_ESQUEMA || '.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id
	    join ' || V_ESQUEMA_M || '.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
	    join ' || V_ESQUEMA_M || '.jbpm_token tk on pi.roottoken_ = tk.id_
	    join ' || V_ESQUEMA_M || '.jbpm_node nd on tk.node_ = nd.id_
	    left join ' || V_ESQUEMA_M || '.jbpm_transition aux on nd.id_ = aux.from_
	    left join ' || V_ESQUEMA_M || '.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = ''activarProrroga''
	group by nd.id_,nd.processdefinition_)';
	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'insert into ' || V_ESQUEMA_M || '.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_)
	select ' || V_ESQUEMA_M || '.hibernate_sequence.nextval id_, ''aplazarTareas'' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_
	from (
	select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex
	from ' || V_ESQUEMA || '.bpm_reactivar_bpm tmp
	    join ' || V_ESQUEMA || '.prc_procedimientos prc on tmp.prc_id = prc.prc_id
	    join ' || V_ESQUEMA || '.tex_tarea_externa tex on tmp.tex_id = tex.tex_id
	    join ' || V_ESQUEMA || '.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id
	    join ' || V_ESQUEMA_M || '.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_
	    join ' || V_ESQUEMA_M || '.jbpm_token tk on pi.roottoken_ = tk.id_
	    join ' || V_ESQUEMA_M || '.jbpm_node nd on tk.node_ = nd.id_
	    left join ' || V_ESQUEMA_M || '.jbpm_transition aux on nd.id_ = aux.from_
	    left join ' || V_ESQUEMA_M || '.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = ''aplazarTareas''
	group by nd.id_,nd.processdefinition_)';  
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'insert into ' || V_ESQUEMA_M || '.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_)
	select ' || V_ESQUEMA_M || '.hibernate_sequence.nextval id_, ''activarTareas'' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_
	from (
	select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex
	from ' || V_ESQUEMA || '.bpm_reactivar_bpm tmp
	    join ' || V_ESQUEMA || '.prc_procedimientos prc on tmp.prc_id = prc.prc_id
	    join ' || V_ESQUEMA || '.tex_tarea_externa tex on tmp.tex_id = tex.tex_id
	    join ' || V_ESQUEMA || '.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id
	    join ' || V_ESQUEMA_M || '.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_
	    join ' || V_ESQUEMA_M || '.jbpm_token tk on pi.roottoken_ = tk.id_
	    join ' || V_ESQUEMA_M || '.jbpm_node nd on tk.node_ = nd.id_
	    left join ' || V_ESQUEMA_M || '.jbpm_transition aux on nd.id_ = aux.from_
	    left join ' || V_ESQUEMA_M || '.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = ''activarTareas''
	group by  nd.id_,nd.processdefinition_)';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('Limpiando restos de la ejecucion');

	V_MSQL := 'update ' || V_ESQUEMA || '.prc_procedimientos set rpr_referencia = null where rpr_referencia is not null';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'update ' || V_ESQUEMA || '.tar_tareas_notificaciones set rpr_referencia = null where rpr_referencia is not null';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'update ' || V_ESQUEMA || '.tex_tarea_externa set rpr_referencia = null where rpr_referencia is not null';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'update ' || V_ESQUEMA_M || '.jbpm_token set rpr_referencia = null where rpr_referencia is not null';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'update ' || V_ESQUEMA_M || '.jbpm_processinstance set rpr_referencia = null where rpr_referencia is not null';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'delete ' || V_ESQUEMA || '.bpm_reactivar_bpm';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('Guardando los cambios');
	
	--COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;