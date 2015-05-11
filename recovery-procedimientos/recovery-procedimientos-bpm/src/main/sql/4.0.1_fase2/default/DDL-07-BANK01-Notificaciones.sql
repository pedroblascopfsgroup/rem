--/*
--##########################################
--## Author: Óscar
--## Finalidad: DDL que añade nuevas vistas para buscador de tareas
--##            
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

BEGIN

     
     DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO VISTAS');
     
     
     EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE VIEW ' || V_ESQUEMA || '.vtar_tarea_vs_usuario (usu_pendientes,
                                                           usu_espera,
                                                           usu_alerta,
                                                           dd_tge_id_pendiente,
                                                           dd_tge_id_espera,
                                                           dd_tge_id_alerta,
                                                           tar_id,
                                                           cli_id,
                                                           exp_id,
                                                           asu_id,
                                                           tar_tar_id,
                                                           spr_id,
                                                           scx_id,
                                                           dd_est_id,
                                                           dd_ein_id,
                                                           dd_sta_id,
                                                           tar_codigo,
                                                           tar_tarea,
                                                           tar_descripcion,
                                                           tar_fecha_fin,
                                                           tar_fecha_ini,
                                                           tar_en_espera,
                                                           tar_alerta,
                                                           tar_tarea_finalizada,
                                                           tar_emisor,
                                                           VERSION,
                                                           usuariocrear,
                                                           fechacrear,
                                                           usuariomodificar,
                                                           fechamodificar,
                                                           usuarioborrar,
                                                           fechaborrar,
                                                           borrado,
                                                           prc_id,
                                                           cmb_id,
                                                           set_id,
                                                           tar_fecha_venc,
                                                           obj_id,
                                                           tar_fecha_venc_real,
                                                           dtype,
                                                           nfa_tar_revisada,
                                                           nfa_tar_fecha_revis_aler,
                                                           nfa_tar_comentarios_alerta,
                                                           dd_tra_id,
                                                           cnt_id,
                                                           tar_destinatario,
                                                           tar_tipo_destinatario,
                                                           tar_id_dest,
                                                           per_id,
                                                           rpr_referencia,
                                                           tar_tipo_ent_cod,
                                                           tar_dtype,
                                                           tar_subtipo_cod,
                                                           tar_subtipo_desc,
                                                           plazo,
                                                           entidadinformacion,
                                                           codentidad,
                                                           gestor,
                                                           tiposolicitudsql,
                                                           identidad,
                                                           fcreacionentidad,
                                                           codigosituacion,
                                                           idtareaasociada,
                                                           descripciontareaasociada,
                                                           supervisor,
                                                           diasvencidosql,
                                                           descripcionentidad,
                                                           subtipotarcodtarea,
                                                           fechacreacionentidadformateada,
                                                           descripcionexpediente,
                                                           descripcioncontrato,
                                                           identidadpersona,
                                                           volumenriesgosql,
                                                           tipoitinerarioentidad,
                                                           prorrogafechapropuesta,
                                                           prorrogacausadescripcion,
                                                           codigocontrato,
                                                           contrato
                                                          )
AS
SELECT distinct v.usu_pendiente, v.usu_espera, v.usu_alerta, v.dd_tge_id_pendiente, v.dd_tge_id_espera, v.dd_tge_id_alerta, v.tar_id, v.cli_id, v.exp_id, v.asu_id, v.tar_tar_id, v.spr_id, v.scx_id,
          v.dd_est_id, v.dd_ein_id, v.dd_sta_id, v.tar_codigo, v.tar_tarea, CASE dd_ein_id
             WHEN 5
                THEN v.nombre_procedimiento
             WHEN 3
                THEN v.nombre_asunto
             ELSE v.tar_descripcion
          END tar_descripcion, v.tar_fecha_fin, v.tar_fecha_ini, v.tar_en_espera, v.tar_alerta, v.tar_tarea_finalizada, v.tar_emisor, v.VERSION, v.usuariocrear, v.fechacrear, v.usuariomodificar,
          v.fechamodificar, v.usuarioborrar, v.fechaborrar, v.borrado, v.prc_id, v.cmb_id, v.set_id, v.tar_fecha_venc, v.obj_id, v.tar_fecha_venc_real, v.dtype, v.nfa_tar_revisada,
          v.nfa_tar_fecha_revis_aler, v.nfa_tar_comentarios_alerta, v.dd_tra_id, v.cnt_id, v.tar_destinatario, v.tar_tipo_destinatario, v.tar_id_dest, v.per_id, v.rpr_referencia, v.dd_ein_codigo,
          v.tar_dtype, v.dd_sta_codigo, v.dd_sta_descripcion, '''' plazo                                                                                     -- TODO Sacar plazo para expediente y cliente
                                                                      ,
          CASE v.dd_ein_codigo
             WHEN ''3''
                THEN v.entidadinformacion || '' ['' || v.asu_id || '']''
             WHEN ''5''
                THEN v.entidadinformacion || '' ['' || v.prc_id || '']''
             WHEN ''2''
                THEN v.entidadinformacion || '' ['' || v.exp_id || '']''
             WHEN ''9''
                THEN v.entidadinformacion || '' ['' || v.per_id || '']''
             -- TODO poner para el resto de unidades de gestion
          ELSE ''''
          END entidadinformacion,
          CASE v.dd_ein_codigo
             WHEN ''3''
                THEN v.asu_id
             WHEN ''5''
                THEN v.prc_id
             WHEN ''2''
                THEN v.exp_id
             WHEN ''9''
                THEN v.per_id
             -- TODO poner para el resto de unidades de gestion
          ELSE -1
          END codentidad, CASE v.dd_ein_codigo
             WHEN ''3''
                THEN v.asu_apenom_gestor
             WHEN ''5''
                THEN v.asu_apenom_gestor
             WHEN ''2''
                THEN v.asu_apenom_gestor
             WHEN ''9''
                THEN v.asu_apenom_gestor
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END gestor, v.tiposolicitudsql, CASE v.dd_ein_codigo
             WHEN ''3''
                THEN v.asu_id
             WHEN ''5''
                THEN v.prc_id
             WHEN ''2''
                THEN v.exp_id
             WHEN ''9''
                THEN v.per_id
             -- TODO poner para el resto de unidades de gestion
          ELSE -1
          END identidad, CASE v.dd_ein_codigo
             WHEN ''3''
                THEN v.asu_fechacrear
             WHEN ''5''
                THEN v.prc_fechacrear
             WHEN ''2''
                THEN v.exp_fechacrear
             WHEN ''2''
                THEN v.per_fechacrear
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END fcreacionentidad, CASE v.dd_ein_codigo
             WHEN ''3''
                THEN v.asu_situacion
             -- TODO poner para el resto de unidades de gestion
          ELSE ''''
          END codigosituacion, v.tar_tar_id idtareaasociada, v.desc_tar_asociada descripciontareaasociada,
          CASE v.dd_ein_codigo
             WHEN ''3''
                THEN v.asu_apenom_supervisor
             WHEN ''5''
                THEN v.asu_apenom_supervisor
             WHEN ''2''
                THEN v.asu_apenom_supervisor
             WHEN ''9''
                THEN v.asu_apenom_supervisor
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END supervisor, CASE
             WHEN v.diasvencidosql <= 0
                THEN NULL
             ELSE v.diasvencidosql
          END diasvencidosql, CASE v.dd_ein_codigo
             WHEN ''3''
                THEN v.nombre_asunto
             WHEN ''5''
                THEN v.nombre_procedimiento
             WHEN ''2''
                THEN v.exp_ape_nom
             WHEN ''9''
                THEN v.per_ape_nom
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END descripcionentidad, v.dd_sta_codigo subtipotarcodtarea,
          CASE v.dd_ein_codigo
             WHEN ''3''
                THEN TO_CHAR (v.asu_fechacrear, ''dd/mm/yyyy'')
             WHEN ''5''
                THEN TO_CHAR (v.prc_fechacrear, ''dd/mm/yyyy'')
             WHEN ''2''
                THEN TO_CHAR (v.exp_fechacrear, ''dd/mm/yyyy'')
             WHEN ''9''
                THEN TO_CHAR (v.per_fechacrear, ''dd/mm/yyyy'')
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END fechacreacionentidadformateada,
          NULL descripcionexpediente                                                                                                                                       -- TODO poner para expediente
                                    ,
          NULL descripcioncontrato                                                                                                                                           -- TODO poner para contrato
                                  ,
          NULL identidadpersona                                                                                                                               -- TODO poner para objetivo y para cliente
                               ,
          CASE v.dd_ein_codigo
             WHEN ''5''
                THEN v.vre_via_prc
             -- TODO poner para el resto de unidades de gestion
          ELSE 0
          END volumenriesgosql, NULL tipoitinerarioentidad                                                                                                       -- TODO sacar para cliente y expediente
                                                          ,
          NULL prorrogafechapropuesta
                                     -- TODO calcular la fecha prorroga propuesta
          , NULL prorrogacausadescripcion
                                         -- TODO calcular la causa de la prorroga
          , NULL codigocontrato                                                                                                                                              -- TODO poner para contrato
                               ,
          NULL contrato                                                                                                                                                                 -- TODO calcular
     FROM (SELECT *
             FROM ' || V_ESQUEMA || '.vtar_tarea_vs_usuario_part1
           UNION ALL
           SELECT *
             FROM ' || V_ESQUEMA || '.vtar_tarea_vs_usuario_part2) v';

        DBMS_OUTPUT.PUT_LINE('[INFO] NOTIFICACIONES SOLUCIONADAS'); 
   

	
--COMMIT;

dbms_output.put_line('[FIN] replace or create vistas');

EXCEPTION
     WHEN OTHERS THEN
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