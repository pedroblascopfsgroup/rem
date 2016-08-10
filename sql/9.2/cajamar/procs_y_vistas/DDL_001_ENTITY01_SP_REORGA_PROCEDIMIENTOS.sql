--/*
--##########################################
--## AUTOR=Carlos Gil
--## FECHA_CREACION=20160520
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-54
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

CREATE OR REPLACE PROCEDURE REORGA_PROCEDIMIENTOS(OUTPUT_PL OUT VARCHAR2) AS


    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');
-- Preparar las tablas

/********************************************************************************/
/******** ATENCION, ESTE SCRIPT SOLO PUEDE SER LANZADO UNA VEZ AL DIA ***********/
/********************************************************************************/


DBMS_OUTPUT.PUT_LINE(' Indexando las revisiones pendientes');

execute immediate 'update '||V_ESQUEMA||'.rpr_revision_procedimiento set rpr_referencia = null';

execute immediate 'update '||V_ESQUEMA||'.rpr_revision_procedimiento set rpr_referencia = '||V_ESQUEMA||'.s_rpr_revision_procedimiento.nextval where rpr_fecha_revisado is null';

DBMS_OUTPUT.PUT_LINE(' Limpiando restos de ejecuciones anteriores');

execute immediate 'update '||V_ESQUEMA||'.prc_procedimientos set rpr_referencia = null where rpr_referencia is not null';

execute immediate 'update '||V_ESQUEMA||'.tar_tareas_notificaciones set rpr_referencia = null where rpr_referencia is not null';

execute immediate 'update '||V_ESQUEMA||'.tex_tarea_externa set rpr_referencia = null where rpr_referencia is not null';

execute immediate 'update '||V_ESQUEMA_M||'.jbpm_token set rpr_referencia = null where rpr_referencia is not null';

execute immediate 'update '||V_ESQUEMA_M||'.jbpm_processinstance set rpr_referencia = null where rpr_referencia is not null';

DBMS_OUTPUT.PUT_LINE(' Guardando los cambios');
OUTPUT_PL:= 'Indexadas las revisiones pendientes';

--CUIDADO AL BORRAR HIJOAS A PARTIR DE AHORA
--PRIMER NIVEL

DBMS_OUTPUT.PUT_LINE(' Borrando tareas externas de hijos de derivados');

execute immediate 'update '||V_ESQUEMA||'.tex_tarea_externa
set borrado = 1, usuarioborrar = ''REORGANIZADO'', fechaborrar = SYSDATE 
where tar_id in (  
    select tar_id from '||V_ESQUEMA||'.tar_tareas_notificaciones
    where prc_id in (
        select prc.prc_id
        from '||V_ESQUEMA||'.prc_procedimientos prc
            join '||V_ESQUEMA||'.prc_procedimientos padre on prc.prc_prc_id = padre.prc_id
        where padre.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''08'') and prc.dd_epr_id != (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    ) and borrado = 0 and (tar_tarea_finalizada is null or tar_tarea_finalizada = 0)
)';
OUTPUT_PL:= OUTPUT_PL||'| Borradas las tareas externas de hijos de derivados';

DBMS_OUTPUT.PUT_LINE(' Borrando tareas notificaciones de hijos de derivados');

execute immediate 'update '||V_ESQUEMA||'.tar_tareas_notificaciones
set tar_tarea_finalizada = 1, tar_fecha_fin = SYSDATE, usuariomodificar = ''REORGANIZADO'', fechamodificar = SYSDATE
    , borrado = 1, usuarioborrar = ''REORGANIZADO'', fechaborrar = SYSDATE 
where prc_id in (
    select prc.prc_id
    from '||V_ESQUEMA||'.prc_procedimientos prc
        join '||V_ESQUEMA||'.prc_procedimientos padre on prc.prc_prc_id = padre.prc_id
    where padre.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''08'') and prc.dd_epr_id != (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    
) and borrado = 0 and (tar_tarea_finalizada is null or tar_tarea_finalizada = 0)';

OUTPUT_PL:= OUTPUT_PL||'| Borradas las tareas notificaciones de hijos de derivados';

DBMS_OUTPUT.PUT_LINE(' Marcando como reorganizados los procedimientos hijos de los reorganizados');

execute immediate 'update '||V_ESQUEMA||'.prc_procedimientos set dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09''), fechamodificar = sysdate, usuariomodificar=''REORGANIZADO'' where prc_id in (
select prc.prc_id
    from '||V_ESQUEMA||'.prc_procedimientos prc
        join '||V_ESQUEMA||'.prc_procedimientos padre on prc.prc_prc_id = padre.prc_id
    where padre.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''08'') 
    and prc.dd_epr_id != (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')       
)';
 
OUTPUT_PL:= OUTPUT_PL||'| Marcados como reorganizados los procedimientos hijos de los reorganizados';
        
--SEGUNDO NIVEL

-- Borrando tareas externas de hijos de hijos de derivados
DBMS_OUTPUT.PUT_LINE(' Borrando tareas externas de hijos de derivados');

execute immediate 'update '||V_ESQUEMA||'.tex_tarea_externa
set borrado = 1, usuarioborrar = ''REORGANIZADO'', fechaborrar = SYSDATE 
where tar_id in (   
   select tar_id from '||V_ESQUEMA||'.tar_tareas_notificaciones
    where prc_id in (
        select hijo2.prc_id
    from '||V_ESQUEMA||'.prc_procedimientos hijo2 
    join '||V_ESQUEMA||'.prc_procedimientos hijo1 on hijo2.prc_prc_id = hijo1.prc_prc_id
        join '||V_ESQUEMA||'.prc_procedimientos padre on hijo1.prc_prc_id = padre.prc_id
    where padre.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'') and hijo1.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    and hijo2.dd_epr_id != (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    and trunc(padre.fechamodificar) = trunc(sysdate)
    ) and borrado = 0 and (tar_tarea_finalizada is null or tar_tarea_finalizada = 0)    
)';

OUTPUT_PL:= OUTPUT_PL||'| Borradas las tareas externas de hijos de derivados';

-- Borrando tareas notificaciones de hijos de hijos de derivados
DBMS_OUTPUT.PUT_LINE(' Borrando tareas notificaciones de hijos de derivados');

execute immediate 'update '||V_ESQUEMA||'.tar_tareas_notificaciones
set tar_tarea_finalizada = 1, tar_fecha_fin = SYSDATE, usuariomodificar = ''REORGANIZADO'', fechamodificar = SYSDATE
    , borrado = 1, usuarioborrar = ''REORGANIZADO'', fechaborrar = SYSDATE 
where prc_id in (
    select hijo2.prc_id
    from '||V_ESQUEMA||'.prc_procedimientos hijo2 
    join '||V_ESQUEMA||'.prc_procedimientos hijo1 on hijo2.prc_prc_id = hijo1.prc_prc_id
        join '||V_ESQUEMA||'.prc_procedimientos padre on hijo1.prc_prc_id = padre.prc_id
    where padre.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'') and hijo1.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    and hijo2.dd_epr_id != (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    and trunc(padre.fechamodificar) = trunc(sysdate)
) and borrado = 0 and (tar_tarea_finalizada is null or tar_tarea_finalizada = 0)';

OUTPUT_PL:= OUTPUT_PL||'| Borradas las tareas notificaciones de hijos de derivados';

-- Borrando procedimientos de hijos de hijos de derivados
DBMS_OUTPUT.PUT_LINE(' Marcando como reorganizados los procedimientos hijos de los reorganizados');

execute immediate 'update '||V_ESQUEMA||'.prc_procedimientos set dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'') where prc_id in (
select hijo2.prc_id
    from '||V_ESQUEMA||'.prc_procedimientos hijo2 
    join '||V_ESQUEMA||'.prc_procedimientos hijo1 on hijo2.prc_prc_id = hijo1.prc_prc_id
        join '||V_ESQUEMA||'.prc_procedimientos padre on hijo1.prc_prc_id = padre.prc_id
    where padre.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'') and hijo1.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    and hijo2.dd_epr_id != (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    and trunc(padre.fechamodificar) = trunc(sysdate)
)';

OUTPUT_PL:= OUTPUT_PL||'| Marcados como reorganizados los procedimientos hijos de los reorganizados';


--TERCER NIVEL

-- Borrando tareas externas de hijos de hijos de hijos de derivados
DBMS_OUTPUT.PUT_LINE(' Borrando tareas externas de hijos de derivados');

execute immediate 'update '||V_ESQUEMA||'.tex_tarea_externa
set borrado = 1, usuarioborrar = ''REORGANIZADO'', fechaborrar = SYSDATE 
where tar_id in (  
    select tar_id from '||V_ESQUEMA||'.tar_tareas_notificaciones
    where prc_id in (
       select hijo3.prc_id
    from '||V_ESQUEMA||'.prc_procedimientos hijo3  
    join '||V_ESQUEMA||'.prc_procedimientos hijo2 on hijo3.PRC_PRC_ID = hijo2.prc_id 
    join '||V_ESQUEMA||'.prc_procedimientos hijo1 on hijo2.prc_prc_id = hijo1.prc_prc_id
        join '||V_ESQUEMA||'.prc_procedimientos padre on hijo1.prc_prc_id = padre.prc_id
    where padre.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'') and hijo1.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    and hijo2.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    and hijo3.dd_epr_id != (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    and trunc(padre.fechamodificar) = trunc(sysdate)
    ) and borrado = 0 and (tar_tarea_finalizada is null or tar_tarea_finalizada = 0)
)';

OUTPUT_PL:= OUTPUT_PL||'| Borradas las tareas externas de hijos de derivados';

-- Borrando tareas notificaciones de hijos de hijos de hijos de derivados
DBMS_OUTPUT.PUT_LINE(' Borrando tareas notificaciones de hijos de derivados');

execute immediate 'update '||V_ESQUEMA||'.tar_tareas_notificaciones
set tar_tarea_finalizada = 1, tar_fecha_fin = SYSDATE, usuariomodificar = ''REORGANIZADO'', fechamodificar = SYSDATE
    , borrado = 1, usuarioborrar = ''REORGANIZADO'', fechaborrar = SYSDATE 
where prc_id in (
    select hijo3.prc_id
    from '||V_ESQUEMA||'.prc_procedimientos hijo3  
    join '||V_ESQUEMA||'.prc_procedimientos hijo2 on hijo3.PRC_PRC_ID = hijo2.prc_id 
    join '||V_ESQUEMA||'.prc_procedimientos hijo1 on hijo2.prc_prc_id = hijo1.prc_prc_id
        join '||V_ESQUEMA||'.prc_procedimientos padre on hijo1.prc_prc_id = padre.prc_id
    where padre.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'') and hijo1.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    and hijo2.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    and hijo3.dd_epr_id != (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    and trunc(padre.fechamodificar) = trunc(sysdate)
) and borrado = 0 and (tar_tarea_finalizada is null or tar_tarea_finalizada = 0)';

OUTPUT_PL:= OUTPUT_PL||'| Borradas las tareas notificaciones de hijos de derivados';

-- Borrando procedimientos de hijos de hijos de hijos de derivados
DBMS_OUTPUT.PUT_LINE(' Marcando como reorganizados los procedimientos hijos de los reorganizados');

execute immediate 'update '||V_ESQUEMA||'.prc_procedimientos set dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'') where prc_id in (
 select hijo3.prc_id
    from '||V_ESQUEMA||'.prc_procedimientos hijo3  
    join '||V_ESQUEMA||'.prc_procedimientos hijo2 on hijo3.PRC_PRC_ID = hijo2.prc_id 
    join '||V_ESQUEMA||'.prc_procedimientos hijo1 on hijo2.prc_prc_id = hijo1.prc_prc_id
        join '||V_ESQUEMA||'.prc_procedimientos padre on hijo1.prc_prc_id = padre.prc_id
    where padre.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'') and hijo1.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    and hijo2.dd_epr_id = (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    and hijo3.dd_epr_id != (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'')
    and trunc(padre.fechamodificar) = trunc(sysdate)
)';

OUTPUT_PL:= OUTPUT_PL||'| Marcados como reorganizados los procedimientos hijos de los reorganizados';


--INSERTAMOS EL NUEVO PROCEDIMIENTO
DBMS_OUTPUT.PUT_LINE(' Insertando nuevos procedimientos');

DBMS_OUTPUT.PUT_LINE('[INICIO] Insertando nuevos procedimientos'); 
       
      EXECUTE IMMEDIATE 'insert into '||V_ESQUEMA||'.prc_procedimientos (prc_id, asu_id, dd_tac_id, dd_tre_id, dd_tpo_id, PRC_PORCENTAJE_RECUPERACION, prc_plazo_recuperacion, prc_saldo_original_vencido, PRC_SALDO_ORIGINAL_NO_VENCIDO,PRC_SALDO_RECUPERACION, version, usuariocrear, FECHACREAR, BORRADO, prc_prc_id, DD_JUZ_ID, PRC_COD_PROC_EN_JUZGADO,dtype, dd_epr_id, rpr_referencia)  
select '||V_ESQUEMA||'.s_prc_procedimientos.nextval,
 RPR.ASU_ID,RPR.DD_TAC_ID, PRC.DD_TRE_ID , RPR.DD_TPO_ID, PRC.PRC_PORCENTAJE_RECUPERACION, prc_plazo_recuperacion, prc.prc_saldo_original_vencido, PRC.PRC_SALDO_ORIGINAL_NO_VENCIDO, PRC.PRC_SALDO_RECUPERACION,0,''REORGANIZADO'', SYSDATE,0,prc.prc_id, PRC.DD_JUZ_ID, PRC.PRC_COD_PROC_EN_JUZGADO, ''MEJProcedimiento'', 3, rpr.rpr_referencia 
from '||V_ESQUEMA||'.rpr_revision_procedimiento rpr join '||V_ESQUEMA||'.prc_procedimientos PRC on rpr.prc_id= PRC.PRC_ID
where rpr.rpr_fecha_revisado is null and PRC.DD_EPR_ID=(select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''08'')';

OUTPUT_PL:= OUTPUT_PL||'| Insertados nuevos procedimientos';

-- Insertamos los demandados del procedimiento
 EXECUTE IMMEDIATE 'insert into '||V_ESQUEMA||'.prc_per
select prc.prc_id, prc_per.per_id, 0
from '||V_ESQUEMA||'.rpr_revision_procedimiento rpr
    join '||V_ESQUEMA||'.prc_per  on rpr.prc_id = prc_per.prc_id
    join '||V_ESQUEMA||'.prc_procedimientos prc on rpr.rpr_referencia = prc.rpr_referencia';

OUTPUT_PL:= OUTPUT_PL||'| Insertados los demandados del procedimiento';
    
-- Insertamos los contratos del procedimiento    
 EXECUTE IMMEDIATE 'insert into '||V_ESQUEMA||'.prc_cex
select prc.prc_id, prc_cex.cex_id, 0
from '||V_ESQUEMA||'.rpr_revision_procedimiento rpr
    join '||V_ESQUEMA||'.prc_cex  on rpr.prc_id = prc_cex.prc_id
    join '||V_ESQUEMA||'.prc_procedimientos prc on rpr.rpr_referencia = prc.rpr_referencia';
    
OUTPUT_PL:= OUTPUT_PL||'| Insertados los contratos del procedimiento';
    
--Cerramos los procedimientos

DBMS_OUTPUT.PUT_LINE(' Cerrando los procedimientos a reorganizar');

execute immediate 'update '||V_ESQUEMA||'.prc_procedimientos set dd_epr_id=(select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''09'') where prc_id in (
select prc.prc_id from '||V_ESQUEMA||'.rpr_revision_procedimiento rpr join '||V_ESQUEMA||'.prc_procedimientos PRC on rpr.prc_id= PRC.PRC_ID
where rpr.rpr_fecha_revisado is null and PRC.DD_EPR_ID=(select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''08'')
)';

OUTPUT_PL:= OUTPUT_PL||'| Cerrados los procedimientos a reorganizar';

-- Terminamos de limpiar las tareas pendientes de los procedimientos a reorganizar

execute immediate 'update '||V_ESQUEMA||'.tex_tarea_externa set borrado = 1, usuarioborrar = ''REORGANIZADO'', fechaborrar = SYSDATE where tex_id in (
select tex.tex_id
from '||V_ESQUEMA||'.tex_tarea_externa tex
   join '||V_ESQUEMA||'.tar_tareas_notificaciones tar on tex.tar_id = tar.tar_id and tar.tar_tarea_finalizada = 1
   join '||V_ESQUEMA||'.prc_procedimientos prc on tar.prc_id = prc.prc_id
   join '||V_ESQUEMA||'.rpr_revision_procedimiento rpr on prc.prc_id = rpr.prc_id
where tex.borrado = 0
)';

OUTPUT_PL:= OUTPUT_PL||'| Borradas las tareas pendientes de los procedimientos a reorganizar';

DBMS_OUTPUT.PUT_LINE(' Creando las tareas');

-- Insert de la tarea
 EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES
   (TAR_ID, ASU_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, TAR_FECHA_FIN, TAR_FECHA_INI, tar_fecha_venc, TAR_EN_ESPERA, TAR_ALERTA, TAR_TAREA_FINALIZADA, TAR_EMISOR, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PRC_ID, DTYPE, NFA_TAR_REVISADA, rpr_referencia)
    select '||V_ESQUEMA||'.s_tar_tareas_notificaciones.nextval tar_id 
    ,prc.asu_id
    ,6 dd_est_id
    ,5 dd_ein_id
    ,tap.dd_sta_id dd_sta_id
    ,1 tar_codigo
    ,tap.tap_descripcion tar_tarea
    ,tap.tap_descripcion tar_descripcion
    , null tar_fecha_fin
    , SYSDATE tar_fecha_ini
    , trunc(SYSDATE + 15) tar_fecha_venc
    , 0 tar_en_espera
    , 0 tar_alerta
    , null tar_tarea_finalizada
    , nvl(tmp.usuariocrear, ''DEFAULT'') tar_emisor
    , 0, ''REORGANIZADO'', SYSDATE, 0
    , prc.prc_id
    ,''EXTTareaNotificacion'' DTYPE
    , 0 nfa_tar_revisada
    ,tmp.rpr_referencia
from '||V_ESQUEMA||'.rpr_revision_procedimiento tmp
    join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tmp.tar_id=tap.tap_id
    join '||V_ESQUEMA||'.prc_procedimientos prc on tmp.rpr_referencia = prc.rpr_referencia
    where prc.borrado = 0
    and tmp.rpr_fecha_revisado is null';

OUTPUT_PL:= OUTPUT_PL||'| Creadas las tareas';


 EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.TEX_TAREA_EXTERNA
   (TEX_ID, TAR_ID, TAP_ID, TEX_TOKEN_ID_BPM, TEX_DETENIDA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, rpr_referencia)
  select '||V_ESQUEMA||'.s_TEX_TAREA_EXTERNA.nextval
, tar.tar_id
, tmp.tar_id
, null
, 0
, 0, ''REORGANIZADO'', SYSDATE, 0, ''EXTTareaExterna''
, tmp.rpr_referencia
from '||V_ESQUEMA||'.rpr_revision_procedimiento tmp
    join '||V_ESQUEMA||'.tar_tareas_notificaciones tar on tmp.rpr_referencia = tar.rpr_referencia
where tmp.rpr_fecha_revisado is null';

OUTPUT_PL:= OUTPUT_PL||'| Creadas las tareas externas';

DBMS_OUTPUT.PUT_LINE(' Creando instancias del BPM');

 EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA_M||'.JBPM_PROCESSINSTANCE
   (ID_, VERSION_, START_, END_, ISSUSPENDED_, PROCESSDEFINITION_,rpr_referencia)
select '||V_ESQUEMA_M||'.HIBERNATE_SEQUENCE.nextval
,1 VERSION_
, SYSDATE START_
,NULL END_
, 0 issuspended_
, maxpd.id_ PROCESSDEFINITION_
, tmp.rpr_referencia
from '||V_ESQUEMA||'.rpr_revision_procedimiento tmp
    join '||V_ESQUEMA||'.prc_procedimientos prc on tmp.rpr_referencia = prc.rpr_referencia
    join '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento tpo on tmp.dd_tpo_id = tpo.dd_tpo_id
    join '||V_ESQUEMA||'.tar_tareas_notificaciones tar on tmp.rpr_referencia = tar.rpr_referencia
    join (select name_, max(id_) id_ from '||V_ESQUEMA_M||'.jbpm_processdefinition group by name_) maxpd on tpo.dd_tpo_xml_jbpm = maxpd.name_
    where prc.borrado = 0 and prc.dd_Epr_id not in (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''04'' OR dd_epr_codigo = ''05'' ) 
    and tmp.rpr_fecha_revisado is null';


execute immediate 'merge into '||V_ESQUEMA||'.prc_procedimientos prc
using (select prc.prc_id, pi.id_ 
from '||V_ESQUEMA||'.prc_procedimientos prc
    join '||V_ESQUEMA||'.rpr_revision_procedimiento tmp on prc.rpr_referencia = tmp.rpr_referencia
    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on tmp.rpr_referencia = pi.rpr_referencia 
where tmp.rpr_fecha_revisado is null
and prc.borrado = 0 and prc.dd_Epr_id not in (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''04'' OR dd_epr_codigo = ''05'' ) ) nuevo
on (prc.prc_id = nuevo.prc_id)
when matched then update set prc.prc_process_bpm = nuevo.id_';



--update /*+ bypass_ujvc */
--(
--select prc.prc_process_bpm viejo, pi.id_ nuevo
--from '||V_ESQUEMA||'.prc_procedimientos prc
--    join '||V_ESQUEMA||'.rpr_revision_procedimiento tmp on prc.rpr_referencia = tmp.rpr_referencia
--    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on tmp.rpr_referencia = pi.rpr_referencia 
--where tmp.rpr_fecha_revisado is null
--and prc.borrado = 0 and prc.dd_Epr_id not in (4,5) 
--)set viejo = nuevo;


 EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA_M||'.JBPM_TOKEN
   (ID_, VERSION_, START_, END_, NODEENTER_, ISSUSPENDED_, NODE_, PROCESSINSTANCE_, rpr_referencia)
select '||V_ESQUEMA_M||'.hibernate_sequence.nextval
, 1 VERSION_
, SYSDATE START_
, null end_
, SYSDATE nodeenter_
, 0 issuspended_
, node.id_ node_
, pi.id_ processinstance_
, tmp.rpr_referencia
from '||V_ESQUEMA||'.rpr_revision_procedimiento tmp
    join '||V_ESQUEMA||'.tar_tareas_notificaciones tar on tmp.rpr_referencia = tar.rpr_referencia
    join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tmp.tar_id = tap.tap_id
    join '||V_ESQUEMA||'.prc_procedimientos prc on tmp.rpr_referencia = prc.rpr_referencia
    join '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento tpo on tmp.dd_tpo_id = tpo.dd_tpo_id
    join (select name_, max(id_) id_ from '||V_ESQUEMA_M||'.jbpm_processdefinition group by name_) maxpd on tpo.dd_tpo_xml_jbpm = maxpd.name_
    join '||V_ESQUEMA_M||'.jbpm_node node on maxpd.id_ = node.processdefinition_ and tap.tap_codigo = node.name_
    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on tmp.rpr_referencia = pi.rpr_referencia
    where prc.borrado = 0 and prc.dd_Epr_id not in (select dd_epr_id from '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO where dd_epr_codigo = ''04'' OR dd_epr_codigo = ''05'' ) 
    and tmp.rpr_fecha_revisado is null';
    
DBMS_OUTPUT.PUT_LINE(' Actualizando el roottoken en la instancia del BPM');
    
execute immediate 'merge into '||V_ESQUEMA_M||'.jbpm_processinstance pi 
using (select pi.id_, tk.id_ nuevo
from '||V_ESQUEMA_M||'.jbpm_processinstance pi
    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.rpr_referencia = tk.rpr_referencia    
) tmp 
on (pi.id_ = tmp.id_)
when matched then update set pi.roottoken_ = tmp.nuevo';

OUTPUT_PL:= OUTPUT_PL||'| Creadas instancias del BPM';
--update /*+BYPASS_UJVC*/(    
--select pi.roottoken_ viejo, tk.id_ nuevo
--from '||V_ESQUEMA_M||'.jbpm_processinstance pi
--    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.rpr_referencia = tk.rpr_referencia    
--) set viejo = nuevo;

DBMS_OUTPUT.PUT_LINE(' Actualizando el token en la tarea externa');

execute immediate 'merge into '||V_ESQUEMA||'.tex_tarea_externa tex
using (select tex.tex_id id, tk.id_ nuevo
from '||V_ESQUEMA||'.tex_tarea_externa tex
    join '||V_ESQUEMA_M||'.jbpm_token tk on tex.rpr_referencia = tk.rpr_referencia) tmp
on (tex.tex_id = tmp.id)
when matched then update set tex.tex_token_id_bpm = tmp.nuevo';

OUTPUT_PL:= OUTPUT_PL||'| Actualizado el token en la tarea externa';

--update /*+BYPASS_UJVC*/(    
--select tex.tex_token_id_bpm viejo, tk.id_ nuevo
--from '||V_ESQUEMA||'.tex_tarea_externa tex
--    join '||V_ESQUEMA_M||'.jbpm_token tk on tex.rpr_referencia = tk.rpr_referencia    
--) set viejo = nuevo;


DBMS_OUTPUT.PUT_LINE(' Preparando el contexto del BPM');

 EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA_M||'.JBPM_MODULEINSTANCE
   (ID_, CLASS_, VERSION_, PROCESSINSTANCE_, NAME_)   
select '||V_ESQUEMA_M||'.hibernate_sequence.nextval
, ''C'' class_
, 0 version_
, prc.prc_process_bpm processinstance_
, ''org.jbpm.context.exe.ContextInstance'' name_
from '||V_ESQUEMA||'.prc_procedimientos prc
    join '||V_ESQUEMA||'.rpr_revision_procedimiento rpr on prc.rpr_referencia = rpr.rpr_referencia
    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_
    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.roottoken_ = tk.id_
    join '||V_ESQUEMA_M||'.jbpm_node nd on tk.node_ = nd.id_
    join '||V_ESQUEMA||'.tex_tarea_externa tex on tk.id_ = tex.tex_token_id_bpm and tex.borrado = 0
where not exists (
    select * from '||V_ESQUEMA_M||'.JBPM_MODULEINSTANCE where processinstance_ = prc.prc_process_bpm
)';


 EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA_M||'.JBPM_TOKENVARIABLEMAP 
   (ID_, VERSION_, TOKEN_, CONTEXTINSTANCE_)      
select '||V_ESQUEMA_M||'.hibernate_sequence.nextval
, 0 version_
, pi.roottoken_
, mi.id_  contextinstance_
from '||V_ESQUEMA||'.prc_procedimientos prc
    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_
    join '||V_ESQUEMA_M||'.JBPM_MODULEINSTANCE mi on pi.id_ = mi.processinstance_
    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.roottoken_ = tk.id_
    join '||V_ESQUEMA_M||'.jbpm_node nd on tk.node_ = nd.id_
    join '||V_ESQUEMA||'.tex_tarea_externa tex on tk.id_ = tex.tex_token_id_bpm and tex.borrado = 0
where not exists (select * from '||V_ESQUEMA_M||'.JBPM_TOKENVARIABLEMAP where token_ = pi.roottoken_)';

OUTPUT_PL:= OUTPUT_PL||'| Preparado el contexto del BPM';

DBMS_OUTPUT.PUT_LINE(' Insertando variables en el contexto del BPM');

 EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA_M||'.JBPM_VARIABLEINSTANCE
   (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)      
select '||V_ESQUEMA_M||'.hibernate_sequence.nextval
,''L'' class_
, 0 version_ 
, ''DB_ID'' name_
, pi.roottoken_ tokem_
, vm.id_ tokenvariablemap_
, pi.id_ processinstance_
, 1 longvlaue_
from '||V_ESQUEMA||'.prc_procedimientos prc
    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_
    join '||V_ESQUEMA_M||'.JBPM_TOKENVARIABLEMAP vm on pi.roottoken_ = vm.token_
    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.roottoken_ = tk.id_
    join '||V_ESQUEMA_M||'.jbpm_node nd on tk.node_ = nd.id_
    join '||V_ESQUEMA||'.tex_tarea_externa tex on tk.id_ = tex.tex_token_id_bpm and tex.borrado = 0
where not exists (select * from '||V_ESQUEMA_M||'.JBPM_VARIABLEINSTANCE where processinstance_ = pi.id_ and name_ = ''DB_ID'')';
   
   
 EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA_M||'.JBPM_VARIABLEINSTANCE
   (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)      
select '||V_ESQUEMA_M||'.hibernate_sequence.nextval
,''L'' class_
, 0 version_ 
, ''procedimientoTareaExterna'' name_
, pi.roottoken_ tokem_
, vm.id_ tokenvariablemap_
, pi.id_ processinstance_
, prc.prc_id longvlaue_
from '||V_ESQUEMA||'.prc_procedimientos prc
    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_
    join '||V_ESQUEMA_M||'.JBPM_TOKENVARIABLEMAP vm on pi.roottoken_ = vm.token_
    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.roottoken_ = tk.id_
    join '||V_ESQUEMA_M||'.jbpm_node nd on tk.node_ = nd.id_
    join '||V_ESQUEMA||'.tex_tarea_externa tex on tk.id_ = tex.tex_token_id_bpm and tex.borrado = 0
where not exists (select * from '||V_ESQUEMA_M||'.JBPM_VARIABLEINSTANCE where processinstance_ = pi.id_ and name_ = ''procedimientoTareaExterna'')';
   
 EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA_M||'.JBPM_VARIABLEINSTANCE
   (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)      
select '||V_ESQUEMA_M||'.hibernate_sequence.nextval
,''L'' class_
, 0 version_ 
, ''bpmParalizado'' name_
, pi.roottoken_ tokem_
, vm.id_ tokenvariablemap_
, pi.id_ processinstance_
, 0 longvlaue_
from '||V_ESQUEMA||'.prc_procedimientos prc
    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_
    join '||V_ESQUEMA_M||'.JBPM_TOKENVARIABLEMAP vm on pi.roottoken_ = vm.token_
    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.roottoken_ = tk.id_
    join '||V_ESQUEMA_M||'.jbpm_node nd on tk.node_ = nd.id_
    join '||V_ESQUEMA||'.tex_tarea_externa tex on tk.id_ = tex.tex_token_id_bpm and tex.borrado = 0
where not exists (select * from '||V_ESQUEMA_M||'.JBPM_VARIABLEINSTANCE where processinstance_ = pi.id_ and name_ = ''bpmParalizado'')';


 EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA_M||'.JBPM_VARIABLEINSTANCE
   (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_)      
select '||V_ESQUEMA_M||'.hibernate_sequence.nextval
,''L'' class_
, 0 version_ 
, ''id''||nd.name_ name_
, pi.roottoken_ tokem_
, vm.id_ tokenvariablemap_
, pi.id_ processinstance_
, tex.tex_id longvlaue_
from '||V_ESQUEMA||'.prc_procedimientos prc
    join '||V_ESQUEMA||'.rpr_revision_procedimiento tmp on prc.rpr_referencia = tmp.rpr_referencia
    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_
    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.roottoken_ = tk.id_
    join '||V_ESQUEMA_M||'.jbpm_node nd on tk.node_ = nd.id_
    join '||V_ESQUEMA_M||'.JBPM_TOKENVARIABLEMAP vm on pi.roottoken_ = vm.token_
    join '||V_ESQUEMA||'.tex_tarea_externa tex on tk.id_ = tex.tex_token_id_bpm and tex.borrado = 0
where not exists (select * from '||V_ESQUEMA_M||'.JBPM_VARIABLEINSTANCE where processinstance_ = pi.id_ and name_ = ''id''||nd.name_)';

OUTPUT_PL:= OUTPUT_PL||'| Insertadas variables en el contexto del BPM';

--select * from jbpm_token;

DBMS_OUTPUT.PUT_LINE(' Actualizando tablas del BPM');

execute immediate 'update '||V_ESQUEMA_M||'.jbpm_token set nextlogindex_ = 0 where nextlogindex_ is null';

execute immediate 'update '||V_ESQUEMA_M||'.jbpm_token set isabletoreactivateparent_ = 0 where isabletoreactivateparent_ is null';

execute immediate 'update '||V_ESQUEMA_M||'.jbpm_token set isterminationimplicit_ = 0 where isterminationimplicit_ is null';

OUTPUT_PL:= OUTPUT_PL||'| Actualizadas tablas del BPM';

DBMS_OUTPUT.PUT_LINE(' Actualizando la fecha de revision de los procedimientos revisados');

execute immediate 'update '||V_ESQUEMA||'.rpr_revision_procedimiento set rpr_fecha_revisado=SYSDATE where rpr_fecha_revisado is null';

OUTPUT_PL:= OUTPUT_PL||'| Actualizada la fecha de revision de los procedimientos revisados';

DBMS_OUTPUT.PUT_LINE(' Insertando transiciones que puedan faltar');

execute immediate 'insert into '||V_ESQUEMA_M||'.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_)
select '||V_ESQUEMA_M||'.hibernate_sequence.nextval id_, ''activarProrroga'' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_
from (
select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex
from '||V_ESQUEMA||'.tar_tareas_notificaciones tar
    join '||V_ESQUEMA||'.rpr_revision_procedimiento  rpr on tar.rpr_referencia = rpr.rpr_referencia
    join '||V_ESQUEMA||'.tex_tarea_externa tex on tar.tar_id = tex.tar_id
    join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id
    join '||V_ESQUEMA||'.prc_procedimientos prc on tar.prc_id = prc.prc_id
    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.roottoken_ = tk.id_
    join '||V_ESQUEMA_M||'.jbpm_node nd on tk.node_ = nd.id_
    left join '||V_ESQUEMA_M||'.jbpm_transition aux on nd.id_ = aux.from_
    left join '||V_ESQUEMA_M||'.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = ''activarProrroga''
where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null
    and tap.tap_autoprorroga = 1 and tr.id_ is null
group by nd.id_,nd.processdefinition_)';


execute immediate 'insert into '||V_ESQUEMA_M||'.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_)
select '||V_ESQUEMA_M||'.hibernate_sequence.nextval id_, ''aplazarTareas'' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_
from (
select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex
from '||V_ESQUEMA||'.tar_tareas_notificaciones tar
    join '||V_ESQUEMA||'.rpr_revision_procedimiento  rpr on tar.rpr_referencia = rpr.rpr_referencia
    join '||V_ESQUEMA||'.tex_tarea_externa tex on tar.tar_id = tex.tar_id
    join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id
    join '||V_ESQUEMA||'.prc_procedimientos prc on tar.prc_id = prc.prc_id
    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.roottoken_ = tk.id_
    join '||V_ESQUEMA_M||'.jbpm_node nd on tk.node_ = nd.id_
    left join '||V_ESQUEMA_M||'.jbpm_transition aux on nd.id_ = aux.from_
    left join '||V_ESQUEMA_M||'.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = ''aplazarTareas''
where tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null
    and tr.id_ is null
group by nd.id_,nd.processdefinition_)';  

execute immediate 'insert into '||V_ESQUEMA_M||'.jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_)
select '||V_ESQUEMA_M||'.hibernate_sequence.nextval id_, ''activarTareas'' name_, pd processdefinition_, nd from_, nd to_, (max_fromindex + 1) fromindex_
from (
select nd.id_ nd, nd.processdefinition_ pd, max(aux.fromindex_) max_fromindex
from '||V_ESQUEMA||'.tar_tareas_notificaciones tar
    join '||V_ESQUEMA||'.rpr_revision_procedimiento  rpr on tar.rpr_referencia = rpr.rpr_referencia
    join '||V_ESQUEMA||'.tex_tarea_externa tex on tar.tar_id = tex.tar_id
    join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id
    join '||V_ESQUEMA||'.prc_procedimientos prc on tar.prc_id = prc.prc_id
    join '||V_ESQUEMA_M||'.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_ 
    join '||V_ESQUEMA_M||'.jbpm_token tk on pi.roottoken_ = tk.id_
    join '||V_ESQUEMA_M||'.jbpm_node nd on tk.node_ = nd.id_
    left join '||V_ESQUEMA_M||'.jbpm_transition aux on nd.id_ = aux.from_
    left join '||V_ESQUEMA_M||'.jbpm_transition tr on nd.id_ = tr.from_ and tr.name_ = ''activarTareas''
where (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) and tar.prc_id is not null
    and tr.id_ is null
group by  nd.id_,nd.processdefinition_)';

OUTPUT_PL:= OUTPUT_PL||'| Insertadas transiciones que puedan faltar';

DBMS_OUTPUT.PUT_LINE(' Limpiando restos de la ejecucion');

execute immediate 'update '||V_ESQUEMA||'.rpr_revision_procedimiento set rpr_referencia = null where rpr_referencia is not null';

execute immediate 'update '||V_ESQUEMA||'.prc_procedimientos set rpr_referencia = null where rpr_referencia is not null';

execute immediate 'update '||V_ESQUEMA||'.tar_tareas_notificaciones set rpr_referencia = null where rpr_referencia is not null';

execute immediate 'update '||V_ESQUEMA||'.tex_tarea_externa set rpr_referencia = null where rpr_referencia is not null';

execute immediate 'update '||V_ESQUEMA_M||'.jbpm_token set rpr_referencia = null where rpr_referencia is not null';

execute immediate 'update '||V_ESQUEMA_M||'.jbpm_processinstance set rpr_referencia = null where rpr_referencia is not null';

OUTPUT_PL:= OUTPUT_PL||'| Limpiados restos de la ejecucion';

DBMS_OUTPUT.PUT_LINE(' Guardando los cambios');

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] SCRIPT');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
		  OUTPUT_PL := 'Error:'||TO_CHAR(err_num)||'['||err_msg||']';
          ROLLBACK;
          RAISE;          

END REORGA_PROCEDIMIENTOS;

/

EXIT

    