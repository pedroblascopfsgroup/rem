
--/*
--##########################################
--## AUTOR=Luis Ruiz
--## FECHA_CREACION=20160613
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.6
--## INCIDENCIA_LINK=PRODUCTO-1797
--## PRODUCTO=SI
--## Finalidad: DDL la vista de tareas pendientes
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'VTAR_TAREA_VS_USUARIO';

BEGIN

    V_MSQL := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||' ("USU_PENDIENTES", "USU_ESPERA", "USU_ALERTA", "DD_TGE_ID_PENDIENTE", "DD_TGE_ID_ESPERA", "DD_TGE_ID_ALERTA", "TAR_ID", "CLI_ID", "EXP_ID", "ASU_ID", "TAR_TAR_ID", "SPR_ID", "SCX_ID", "DD_EST_ID", "DD_EIN_ID", "DD_STA_ID", "TAR_CODIGO", "TAR_TAREA", "TAR_DESCRIPCION", "TAR_FECHA_FIN", "TAR_FECHA_INI", "TAR_EN_ESPERA", "TAR_ALERTA", "TAR_TAREA_FINALIZADA", "TAR_EMISOR", "VERSION", "USUARIOCREAR", "FECHACREAR", "USUARIOMODIFICAR", "FECHAMODIFICAR", "USUARIOBORRAR", "FECHABORRAR", "BORRADO", "PRC_ID", "CMB_ID", "SET_ID", "TAR_FECHA_VENC", "OBJ_ID", "TAR_FECHA_VENC_REAL", "DTYPE", "NFA_TAR_REVISADA", "NFA_TAR_FECHA_REVIS_ALER", "NFA_TAR_COMENTARIOS_ALERTA", "DD_TRA_ID", "CNT_ID", "TAR_DESTINATARIO", "TAR_TIPO_DESTINATARIO", "TAR_ID_DEST", "PER_ID", "RPR_REFERENCIA", "TAR_TIPO_ENT_COD", "TAR_DTYPE", "TAR_SUBTIPO_COD", "TAR_SUBTIPO_DESC", "PLAZO", "ENTIDADINFORMACION", "CODENTIDAD", "GESTOR", "TIPOSOLICITUDSQL", "IDENTIDAD", "FCREACIONENTIDAD", "CODIGOSITUACION", "IDTAREAASOCIADA", "DESCRIPCIONTAREAASOCIADA", "SUPERVISOR", "DIASVENCIDOSQL", "DESCRIPCIONENTIDAD", "SUBTIPOTARCODTAREA", "FECHACREACIONENTIDADFORMATEADA", "DESCRIPCIONEXPEDIENTE", "DESCRIPCIONCONTRATO", "IDENTIDADPERSONA", "VOLUMENRIESGOSQL", "TIPOITINERARIOENTIDAD", "PRORROGAFECHAPROPUESTA", "PRORROGACAUSADESCRIPCION", "CODIGOCONTRATO", "CONTRATO", "ZON_COD", "PEF_ID", "DD_TAC_ID", "DD_TPO_ID")
        As
        Select tar.USU_PENDIENTES,
               tar.USU_ESPERA,
               tar.USU_ALERTA,
               tar.DD_TGE_ID_PENDIENTE,
               tar.DD_TGE_ID_ESPERA,
               tar.DD_TGE_ID_ALERTA,
               tar.TAR_ID,
               tar.CLI_ID,
               tar.EXP_ID,
               tar.ASU_ID,
               tar.TAR_TAR_ID,
               tar.SPR_ID,
               tar.SCX_ID,
               tar.DD_EST_ID,
               tar.DD_EIN_ID,
               tar.DD_STA_ID,
               tar.TAR_CODIGO,
               tar.TAR_TAREA,
               tar.TAR_DESCRIPCION,
               tar.TAR_FECHA_FIN,
               tar.TAR_FECHA_INI,
               tar.TAR_EN_ESPERA,
               tar.TAR_ALERTA,
               tar.TAR_TAREA_FINALIZADA,
               tar.TAR_EMISOR,
               tar.VERSION,
               tar.USUARIOCREAR,
               tar.FECHACREAR,
               tar.USUARIOMODIFICAR,
               tar.FECHAMODIFICAR,
               tar.USUARIOBORRAR,
               tar.FECHABORRAR,
               tar.BORRADO,
               tar.PRC_ID,
               tar.CMB_ID,
               tar.SET_ID,
               tar.TAR_FECHA_VENC,
               tar.OBJ_ID,
               tar.TAR_FECHA_VENC_REAL,
               tar.DTYPE,
               tar.NFA_TAR_REVISADA,
               tar.NFA_TAR_FECHA_REVIS_ALER,
               tar.NFA_TAR_COMENTARIOS_ALERTA,
               tar.DD_TRA_ID,
               tar.CNT_ID,
               tar.TAR_DESTINATARIO,
               tar.TAR_TIPO_DESTINATARIO,
               tar.TAR_ID_DEST,
               tar.PER_ID,
               tar.RPR_REFERENCIA,
               tar.TAR_TIPO_ENT_COD,
               tar.TAR_DTYPE,
               tar.TAR_SUBTIPO_COD,
               tar.TAR_SUBTIPO_DESC,
               cast(null as char(1)) as PLAZO,
               tar.ENTIDADINFORMACION,
               tar.CODENTIDAD,
               tar.GESTOR,
               tar.TIPOSOLICITUDSQL,
               tar.IDENTIDAD,
               tar.FCREACIONENTIDAD,
               tar.CODIGOSITUACION,
               tar.IDTAREAASOCIADA,
               tar.DESCRIPCIONTAREAASOCIADA,
               tar.SUPERVISOR,
               tar.DIASVENCIDOSQL,
               tar.DESCRIPCIONENTIDAD,
               tar.SUBTIPOTARCODTAREA,
               tar.FECHACREACIONENTIDADFORMATEADA,
               tar.DESCRIPCIONEXPEDIENTE,
               cast(Null as varchar2(1)) as DESCRIPCIONCONTRATO,    --poner para cnt
               tar.IDENTIDADPERSONA,
               tar.VOLUMENRIESGOSQL,
               tit.DD_TIT_DESCRIPCION as TIPOITINERARIOENTIDAD,
               cast(NULL as varchar2(1)) as PRORROGAFECHAPROPUESTA,
               cast(NULL as varchar2(1)) as PRORROGACAUSADESCRIPCION,
               cast(NULL as varchar2(1)) as CODIGOCONTRATO,
               cast(NULL as varchar2(1)) as CONTRATO,
               tar.ZON_COD,
               CASE
                 WHEN tar.dd_sta_gestor = 1
                   THEN decode(tar.tar_tipo_ent_cod
                              ,''1'', est.pef_id_gestor
                              ,''2'', est.pef_id_gestor
                              ,''7'', tar.pef_id)
                    ELSE decode(tar.tar_tipo_ent_cod
                               ,''1'', est.pef_id_supervisor
                               ,''2'', est.pef_id_supervisor
                               ,''7'', tar.pef_id)
               END as PEF_ID,
               tar.DD_TAC_ID,
               tar.DD_TPO_ID
          From
           (
           SELECT CASE
                   WHEN sta.dd_sta_codigo in (''ACP_ACU'',''REV_ACU'',''GST_CIE_ACU'',''NOTIF_ACU'')
                    THEN tn.tar_id_dest
                   ELSE decode(tvr.usu_pendientes,null,tn.tar_id_dest,-1,tn.tar_id_dest,tvr.usu_pendientes)
                  END as USU_PENDIENTES
                , CASE
                     WHEN (NVL(tn.TAR_EN_ESPERA, 0) = 1)
                       THEN
                         COALESCE((SELECT usu_id
                                     FROM '||V_ESQUEMA_M||'.USU_USUARIOS usu
                                    WHERE CASE
                                             WHEN usu.usu_apellido1 IS NULL AND usu.usu_apellido2 IS NULL
                                             THEN
                                                usu.usu_nombre
                                             WHEN usu.usu_apellido2 IS NULL
                                             THEN
                                                usu.usu_apellido1 || '', '' || usu.usu_nombre
                                             WHEN usu.usu_apellido1 IS NULL
                                             THEN
                                                usu.usu_apellido2 || '', '' || usu.usu_nombre
                                             ELSE
                                                   usu.usu_apellido1
                                                || '' ''
                                                || usu.usu_apellido2
                                                || '', ''
                                                || usu.usu_nombre
                                          END = tn.tar_emisor)
                                 ,NVL((SELECT usu_id
                                         FROM '||V_ESQUEMA_M||'.USU_USUARIOS
                                        WHERE usu_username = tn.tar_emisor)
                                     ,(SELECT usu_id
                                         FROM '||V_ESQUEMA_M||'.USU_USUARIOS
                                        WHERE usu_username = tn.usuariocrear))
                                ,-1)
                     ELSE -1
                  END as USU_ESPERA
                , decode(tvr.tar_id,null,-1,tvr.usu_alerta)  as USU_ALERTA
                , CASE
                     WHEN sta.dd_sta_codigo IN (''700'',''701'')
                        THEN -1
                     WHEN NVL(tap.dd_tge_id, 0) <> 0
                        THEN tap.dd_tge_id
                     WHEN sta.dd_tge_id is null
                        THEN decode(sta.dd_sta_gestor,0,3,2)
                     ELSE sta.dd_tge_id
                  END as DD_TGE_ID_PENDIENTE
                , -1  as DD_TGE_ID_ESPERA
                , decode(tvr.tar_id,null,decode(tn.tar_alerta, 1, nvl(tap.dd_tsup_id, 3), -1),tvr.dd_tge_id_alerta) as DD_TGE_ID_ALERTA
                , tn.TAR_ID
                , tn.CLI_ID
                , tn.EXP_ID
                , tn.ASU_ID
                , tn.TAR_TAR_ID
                , tn.SPR_ID
                , tn.SCX_ID
                , tn.DD_EST_ID
                , tn.DD_EIN_ID
                , tn.DD_STA_ID
                , tn.TAR_CODIGO
                , tn.TAR_TAREA
                , CASE ein.DD_EIN_CODIGO
                     WHEN ''1''
                        THEN tn.TAR_TAREA
                     WHEN ''3''
                        THEN asu.ASU_NOMBRE
                     WHEN ''5''
                        THEN decode(tpo.DD_TPO_DESCRIPCION
                                   ,null ,asu.ASU_NOMBRE
                                   ,asu.ASU_NOMBRE||''-''||TPO.DD_TPO_DESCRIPCION)
                     ELSE tn.TAR_DESCRIPCION
                  END as TAR_DESCRIPCION
                , tn.TAR_FECHA_FIN
                , tn.TAR_FECHA_INI
                , tn.TAR_EN_ESPERA
                , tn.TAR_ALERTA
                , tn.TAR_TAREA_FINALIZADA
                , tn.TAR_EMISOR
                , tn.VERSION
                , tn.USUARIOCREAR
                , tn.FECHACREAR
                , tn.USUARIOMODIFICAR
                , tn.FECHAMODIFICAR
                , tn.USUARIOBORRAR
                , tn.FECHABORRAR
                , tn.BORRADO
                , tn.PRC_ID
                , tn.CMB_ID
                , tn.SET_ID
                , tn.TAR_FECHA_VENC
                , tn.OBJ_ID
                , tn.TAR_FECHA_VENC_REAL
                , tn.DTYPE
                , tn.NFA_TAR_REVISADA
                , tn.NFA_TAR_FECHA_REVIS_ALER
                , tn.NFA_TAR_COMENTARIOS_ALERTA
                , tn.DD_TRA_ID
                , tn.CNT_ID
                , tn.TAR_DESTINATARIO
                , tn.TAR_TIPO_DESTINATARIO
                , tn.TAR_ID_DEST
                , tn.PER_ID
                , tn.RPR_REFERENCIA
                , ein.DD_EIN_CODIGO as TAR_TIPO_ENT_COD
                , tn.DTYPE as TAR_DTYPE
                , sta.DD_STA_CODIGO as TAR_SUBTIPO_COD
                , sta.DD_STA_DESCRIPCION as TAR_SUBTIPO_DESC
                , CASE ein.DD_EIN_CODIGO
                     WHEN ''1''                                                --Cliente
                       THEN ein.DD_EIN_DESCRIPCION||'' [''||tn.CLI_ID||'']''
                     WHEN ''2''                                             --Expediente
                       THEN ein.DD_EIN_DESCRIPCION||'' [''||tn.EXP_ID||'']''
                     WHEN ''3''                                                 --Asunto
                       THEN ein.DD_EIN_DESCRIPCION||'' [''||tn.ASU_ID||'']''
                     WHEN ''5''                                          --Procedimiento
                       THEN ein.DD_EIN_DESCRIPCION||'' [''||tn.PRC_ID||'']''
                     WHEN ''7''                                              -- Objetivo
                       THEN ein.DD_EIN_DESCRIPCION||'' [''||tn.OBJ_ID||'']''
                     WHEN ''9''                                                --Persona
                       THEN ein.DD_EIN_DESCRIPCION||'' [''||tn.PER_ID||'']''
                     WHEN ''10''                                          --Notificacion
                       THEN ein.DD_EIN_DESCRIPCION||'' [''||tn.TAR_ID||'']''
                     ELSE ''''
                  END as ENTIDADINFORMACION
                , CASE ein.DD_EIN_CODIGO
                     WHEN ''1''                                                --Cliente
                        THEN tn.CLI_ID
                     WHEN ''2''                                             --Expediente
                        THEN tn.EXP_ID
                     WHEN ''3''                                                 --Asunto
                        THEN tn.ASU_ID
                     WHEN ''5''                                          --Procedimiento
                        THEN tn.PRC_ID
                     WHEN ''7''                                              -- Objetivo
                        THEN tn.OBJ_ID
                     WHEN ''9''                                                --Persona
                        THEN tn.PER_ID
                     WHEN ''10''                                          --Notificacion
                        THEN tn.TAR_ID
                     ELSE -1
                  END as CODENTIDAD
                , CASE
                     WHEN sta.DD_STA_ID NOT IN (700, 701)
                      THEN
                        CASE
                          WHEN ges.usu_apellido1 IS NULL AND ges.usu_apellido2 IS NULL
                             THEN
                                ges.usu_nombre
                          WHEN ges.usu_apellido2 IS NULL
                             THEN
                                ges.usu_apellido1 || '', '' || ges.usu_nombre
                          WHEN ges.usu_apellido1 IS NULL
                             THEN
                                ges.usu_apellido2 || '', '' || ges.usu_nombre
                          ELSE
                               ges.usu_apellido1
                                || '' ''
                                || ges.usu_apellido2
                                || '', ''
                                || ges.usu_nombre
                        END
                     ELSE NULL
                  END as GESTOR
                , CASE
                     WHEN sta.DD_STA_CODIGO IN (''5'', ''6'', ''54'', ''41'', ''SOLPRORRFP'')
                        THEN ''Prórroga''
                     WHEN sta.DD_STA_CODIGO IN (''17'')
                        THEN ''Cancelación Expediente''
                     WHEN sta.DD_STA_CODIGO IN (''29'', ''SOLEXPMGDEUDA'')
                        THEN ''Expediente Manual''
                     WHEN sta.DD_STA_CODIGO IN (''16'', ''28'', ''24'', ''26'', ''27'', ''589'', ''590'', ''15'')
                        THEN ''Comunicación''
                     WHEN sta.DD_STA_CODIGO IN (''NTGPS'')
                        THEN ''NOTIFICACIÓN AUTOMÁTICA''
                     ELSE ''''
                  END as TIPOSOLICITUDSQL
                , CASE ein.DD_EIN_CODIGO
                     WHEN ''1''                                               -- Cliente
                        THEN tn.CLI_ID
                     WHEN ''2''                                             --Expediente
                        THEN tn.EXP_ID
                     WHEN ''3''                                                 --Asunto
                        THEN tn.ASU_ID
                     WHEN ''5''                                          --Procedimiento
                        THEN tn.PRC_ID
                     WHEN ''7''                                              -- Objetivo
                        THEN tn.OBJ_ID
                     WHEN ''9''                                                --Persona
                        THEN tn.PER_ID
                     WHEN ''10''                                          --Notificacion
                        THEN tn.PRC_ID
                  ELSE -1
                  END as IDENTIDAD
                , CASE ein.DD_EIN_CODIGO
                     WHEN ''1''                                                --Cliente
                        THEN cli.CLI_FECHA_CREACION
                     WHEN ''2''                                             --Expediente
                        THEN exp.FECHACREAR
                     WHEN ''3''                                                 --Asunto
                        THEN asu.FECHACREAR
                     WHEN ''5''                                          --Procedimiento
                        THEN prc.FECHACREAR
                     WHEN ''7''                                              -- Objetivo
                        THEN obj.FECHACREAR
                     WHEN ''9''                                                --Persona
                        THEN per.FECHACREAR
                     WHEN ''10''                                          --Notificacion
                        THEN tn.FECHACREAR
                  ELSE Null
                  END as FCREACIONENTIDAD
                , CASE ein.DD_EIN_CODIGO
                    WHEN ''3''
                       THEN ddestiti.DD_EST_DESCRIPCION
                    ELSE ''''
                  END as CODIGOSITUACION
                , asoc.TAR_TAR_ID as IDTAREAASOCIADA
                , asoc.TAR_DESCRIPCION as DESCRIPCIONTAREAASOCIADA
                , CASE
                    WHEN sup.usu_apellido1 IS NULL AND sup.usu_apellido2 IS NULL
                     THEN
                        sup.usu_nombre
                    WHEN sup.usu_apellido2 IS NULL
                     THEN
                        sup.usu_apellido1 || '', '' || sup.usu_nombre
                    WHEN sup.usu_apellido1 IS NULL
                     THEN
                        sup.usu_apellido2 || '', '' || sup.usu_nombre
                    ELSE
                       sup.usu_apellido1
                        || '' ''
                        || sup.usu_apellido2
                        || '', ''
                        || sup.usu_nombre
                  END as SUPERVISOR
                , CASE
                     WHEN TRUNC(tn.TAR_FECHA_VENC) >= TRUNC(SYSDATE)
                        THEN Null
                     ELSE
                        EXTRACT(DAY FROM (SYSTIMESTAMP - (TRUNC(tn.TAR_FECHA_VENC))))
                  END as DIASVENCIDOSQL
                , CASE ein.DD_EIN_CODIGO
                     WHEN ''1''                                                --Cliente
                        THEN (select p.PER_NOM50
                              from '||V_ESQUEMA||'.PER_PERSONAS p
                              where cli.per_id = p.per_id)
                     WHEN ''2''                                             --Expediente
                        THEN exp.EXP_DESCRIPCION
                     WHEN ''3''                                                 --Asunto
                        THEN asu.ASU_NOMBRE
                     WHEN ''4''                                                  --Tarea
                        THEN tn.TAR_DESCRIPCION
                     WHEN ''5''                                          --Procedimiento
                        THEN decode(tpo.DD_TPO_DESCRIPCION
                                   ,null, asu.asu_nombre
                                   ,asu.ASU_NOMBRE
                                     ||''-''
                                     ||tpo.DD_TPO_DESCRIPCION)
                     WHEN ''7''                                               --Objetivo
                        THEN tob.TOB_DESCRIPCION
                     WHEN ''9''                                                --Persona
                        THEN per.PER_NOM50
                     WHEN ''10''                                          --Notificacion
                        THEN tn.TAR_DESCRIPCION
                     ELSE
                        NULL
                  END as DESCRIPCIONENTIDAD
                , STA.DD_STA_CODIGO as SUBTIPOTARCODTAREA
                , CASE ein.DD_EIN_CODIGO
                     WHEN ''1''                                                --Cliente
                        THEN to_char(cli.FECHACREAR, ''DD/MM/YYYY'')
                     WHEN ''2''                                             --Expediente
                        THEN to_char(exp.FECHACREAR, ''DD/MM/YYYY'')
                     WHEN ''3''                                                 --Asunto
                        THEN to_char(asu.FECHACREAR, ''DD/MM/YYYY'')
                     WHEN ''5''                                          --Procedimiento
                        THEN to_char(prc.FECHACREAR, ''DD/MM/YYYY'')
                     WHEN ''7''                                               --Objetivo
                        THEN to_char(obj.FECHACREAR, ''DD/MM/YYYY'')
                     WHEN ''9''                                                --Persona
                        THEN to_char(per.FECHACREAR, ''DD/MM/YYYY'')
                     WHEN ''10''                                          --Notificacion
                        THEN to_char(tn.FECHACREAR,  ''DD/MM/YYYY'')
                  ELSE Null
                  END as FECHACREACIONENTIDADFORMATEADA
                , exp.EXP_DESCRIPCION as DESCRIPCIONEXPEDIENTE
                , CASE ein.DD_EIN_CODIGO
                     WHEN ''1''                                                --Cliente
                       THEN cli.PER_ID
                     WHEN ''7''                                               --Objetivo
                       THEN cmp.PER_ID
                     ELSE NULL
                  END as IDENTIDADPERSONA
                , CASE ein.DD_EIN_CODIGO
                     WHEN ''5''                                          --Procedimiento
                        THEN NVL(prc.PRC_SALDO_RECUPERACION, 0)
                     WHEN ''2''                                             --Expediente
                        THEN NVL(prc.PRC_SALDO_RECUPERACION, 0)
                  ELSE 0
                  END as VOLUMENRIESGOSQL
                , CASE
                     WHEN ein.dd_ein_codigo = ''7''
                      THEN CASE
                              WHEN sta.dd_sta_gestor = 1
                               THEN TO_CHAR (zonges.zon_cod)
                              ELSE TO_CHAR (zonsup.zon_cod)
                           END
                     WHEN ein.dd_ein_codigo in (''1'',''2'')
                      THEN (select zon.zon_cod
                              from '||V_ESQUEMA||'.OFI_OFICINAS ofi
                                 , '||V_ESQUEMA||'.ZON_ZONIFICACION zon
                            where ofi.ofi_id = zon.ofi_id
                              and decode(ein.dd_ein_codigo
                                        ,''1'', cli.ofi_id
                                        ,''2'', exp.ofi_id) = zon.ofi_id)
                  END as ZON_COD
                , sta.dd_sta_gestor as DD_STA_GESTOR
                , decode(ein.dd_ein_codigo,''7''
                        ,decode(sta.dd_sta_gestor,1,pol.pef_id_gestor,pol.pef_id_super)
                        ,null) as PEF_ID
                , tac.DD_TAC_ID
                , tpo.DD_TPO_ID
                , CASE
                     WHEN cli.cli_id is not null                             --Cliente
                        THEN cli.arq_id
                     WHEN exp.exp_id is not null                          --Expediente
                        THEN exp.arq_id
                     WHEN per.per_id is not null                             --Persona
                        THEN per.arq_id
                     WHEN obj.obj_id is not null                            --Objetivo
                        THEN arr.arq_id
                  ELSE null
                  END as ARQ_ID
                , CASE ein.dd_ein_codigo
                     WHEN ''1''                                                --Cliente
                        THEN cli.dd_est_id
                     WHEN ''2''                                             --Expediente
                        THEN exp.dd_est_id
                  ELSE Null
                  END as DD_EST_ID_EIN
             FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tn
             -- Expedientes
             LEFT JOIN '||V_ESQUEMA||'.EXP_EXPEDIENTES exp
               ON tn.exp_id = exp.exp_id
             -- Asuntos y Procedimientos
             LEFT JOIN '||V_ESQUEMA||'.ASU_ASUNTOS asu
               ON tn.ASU_ID = asu.ASU_ID AND asu.BORRADO = 0
             LEFT JOIN (SELECT /*+ ORDERED */ vtar.tar_id,
                               max(decode(nvl(vtar.tar_alerta, 0), 1, nvl(vtap.dd_tsup_id, 3), -1)) as dd_tge_id_alerta,
                               max(CASE WHEN (vsta.dd_sta_id = 700 OR vsta.dd_sta_id = 701) THEN -1
                                        WHEN nvl(vtap.dd_tge_id, 0) <> 0 THEN vtap.dd_tge_id
                                        WHEN vsta.dd_tge_id IS NULL THEN decode(vsta.dd_sta_gestor,0,3,2)
                                        ELSE vsta.dd_tge_id END) as  dd_tge_id_pendiente,
                               max(nvl(vtap.dd_tsup_id, 3)) as dd_tge_id_supervisor,
                               max(decode(vges.dd_tge_id
                                         ,CASE WHEN (vsta.dd_sta_id = 700 OR vsta.dd_sta_id = 701) THEN -1
                                               WHEN NVL (vtap.dd_tge_id, 0) != 0 THEN vtap.dd_tge_id
                                               WHEN vsta.dd_tge_id IS NULL THEN CASE vsta.dd_sta_gestor WHEN 0 THEN 3 ELSE 2 END
                                               ELSE vsta.dd_tge_id
                                          END, vusd.usu_id
                                         ,-1)) as usu_pendientes,
                               max(decode(vges.dd_tge_id, decode(nvl(vtar.tar_alerta, 0), 1, nvl(vtap.dd_tsup_id, 3), -1), vusd.usu_id, -1)) as usu_alerta,
                               max(decode(vges.dd_tge_id, nvl(vtap.dd_tsup_id, 3), vusd.usu_id, -1)) as usu_supervisor
                          FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES vtar
                               JOIN '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base vsta
                                 ON vtar.dd_sta_id = vsta.dd_sta_id
                               JOIN '||V_ESQUEMA_M||'.dd_ein_entidad_informacion vein
                                 ON vtar.dd_ein_id = vein.dd_ein_id
                               LEFT JOIN '||V_ESQUEMA||'.tex_tarea_externa vtex
                                 ON vtar.tar_id = vtex.tar_id
                               LEFT JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento vtap
                                 ON vtex.tap_id = vtap.tap_id,
                               (SELECT asu_id,
                                       usd_id,
                                       4 dd_tge_id
                                  FROM '||V_ESQUEMA||'.ASU_ASUNTOS
                                 WHERE usd_id IS NOT NULL
                                   AND borrado = 0
                                UNION ALL
                                SELECT asu_id,
                                       usd_id,
                                       dd_tge_id
                                  FROM '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO
                                 WHERE borrado = 0) vges,
                               '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS vusd
                         WHERE nvl(vtar.tar_tarea_finalizada, 0) = 0
                           AND vtar.borrado = 0
                           AND vtar.asu_id > 0
                           AND vein.dd_ein_codigo IN (''3'', ''5'', ''2'', ''9'', ''10'')
                           AND vges.usd_id = vusd.usd_id
                           AND vtar.asu_id = vges.asu_id
                           AND (decode(vges.dd_tge_id
                                     ,CASE WHEN (vsta.dd_sta_id = 700 OR vsta.dd_sta_id = 701) THEN -1
                                           WHEN nvl(vtap.dd_tge_id, 0) <> 0 THEN vtap.dd_tge_id
                                           WHEN vsta.dd_tge_id IS NULL THEN decode(vsta.dd_sta_gestor,0,3,2)
                                           ELSE vsta.dd_tge_id
                                      END, vusd.usu_id
                                     ,-1) > 0
                                OR
                                decode(vges.dd_tge_id
                                      ,decode(nvl(vtar.tar_alerta, 0), 1, nvl(vtap.dd_tsup_id, 3), -1), vusd.usu_id
                                      , -1) > 0)
                         GROUP BY vtar.tar_id) tvr
               ON tn.tar_id = tvr.tar_id
             LEFT JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc
               ON tn.PRC_ID = prc.PRC_ID AND prc.BORRADO = 0
               LEFT JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO tpo
                 ON prc.DD_TPO_ID = tpo.DD_TPO_ID
                 LEFT JOIN '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION tac
                   ON tpo.DD_TAC_ID = tac.DD_TAC_ID
             -- Objetivos
             LEFT JOIN '||V_ESQUEMA||'.OBJ_OBJETIVO obj
               ON tn.obj_id = obj.obj_id AND obj.borrado = 0
               LEFT JOIN '||V_ESQUEMA||'.TOB_TIPO_OBJETIVO tob
                 ON obj.TOB_ID = tob.TOB_ID
               LEFT JOIN '||V_ESQUEMA||'.POL_POLITICA pol
                 ON obj.pol_id = pol.pol_id
                 LEFT JOIN '||V_ESQUEMA||'.ZON_ZONIFICACION zonges
                   ON pol.zon_id_gestor = zonges.zon_id
                 LEFT JOIN '||V_ESQUEMA||'.ZON_ZONIFICACION zonsup
                   ON pol.zon_id_super = zonsup.zon_id
                 LEFT JOIN '||V_ESQUEMA||'.CMP_CICLO_MARCADO_POLITICA cmp
                   ON pol.CMP_ID = cmp.CMP_ID
                   LEFT JOIN '||V_ESQUEMA||'.ARR_ARQ_RECUPERACION_PERSONA arr
                     ON cmp.per_id = arr.per_id
             -- Clientes
             LEFT JOIN '||V_ESQUEMA||'.CLI_CLIENTES cli
               ON tn.cli_id = cli.cli_id --AND cli.borrado = 0
             -- Personas
             LEFT JOIN '||V_ESQUEMA||'.PER_PERSONAS per
               ON tn.per_id = per.per_id and per.borrado = 0
             -- Comunes
             LEFT JOIN '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS ddestiti
               ON tn.dd_est_id = ddestiti.dd_est_id
             INNER JOIN '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION ein
               ON tn.dd_ein_id = ein.dd_ein_id
             INNER JOIN '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE sta
               ON tn.dd_sta_id = sta.dd_sta_id
             LEFT JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex
               ON tn.tar_id = tex.tar_id
             LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap
               ON tex.tap_id = tap.tap_id
             LEFT JOIN '||V_ESQUEMA_M||'.USU_USUARIOS ges
               ON decode(tvr.tar_id,null,tn.tar_id_dest,tvr.usu_pendientes) = ges.usu_id
             LEFT JOIN '||V_ESQUEMA_M||'.USU_USUARIOS sup
               ON CASE WHEN sta.dd_sta_codigo IN (''700'',''701'',''ACP_ACU'',''REV_ACU'',''GST_CIE_ACU'',''NOTIF_ACU'')
                       THEN nvl(tap.dd_tsup_id, 3)
                       ELSE decode(tvr.tar_id,null,-1,tvr.usu_supervisor)
                  END = sup.usu_id
             LEFT JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES asoc
               ON tn.tar_tar_id = asoc.tar_id AND asoc.borrado = 0
            WHERE nvl(tn.tar_tarea_finalizada,0) = 0
              AND tn.borrado = 0
              AND  ( ein.dd_ein_codigo in (''1'',''2'',''7'')
                 OR (ein.dd_ein_codigo in (''3'', ''5'', ''9'', ''10'')
                    AND sta.dd_sta_codigo IN (''700'', ''701'',''ACP_ACU'',''REV_ACU'',''GST_CIE_ACU'',''NOTIF_ACU''))
                 OR tvr.tar_id is not null )
          ) tar
          Left Join '||V_ESQUEMA||'.ARQ_ARQUETIPOS arq
            On tar.arq_id = arq.arq_id
            Left Join '||V_ESQUEMA||'.ITI_ITINERARIOS iti
              On arq.iti_id = iti.iti_id
              Left Join '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS tit
                On iti.dd_tit_id = tit.dd_tit_id
          Left Join '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS ddest
            On tar.dd_est_id_ein = ddest.dd_est_id
            Left Join '||V_ESQUEMA||'.EST_ESTADOS est
              On ddest.dd_est_id = est.dd_est_id AND arq.iti_id = est.iti_id
 ';

 EXECUTE IMMEDIATE V_MSQL;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NOMBRE_VISTA||' Creada o reemplazada');

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
