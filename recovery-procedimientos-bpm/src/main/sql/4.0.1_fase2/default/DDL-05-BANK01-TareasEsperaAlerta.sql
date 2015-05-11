--/*
--##########################################
--## Author: Óscar
--## Finalidad: DDL que arregla las tareas en espera y alertas
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
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] TAREAS EN ESPERA'); 

execute immediate 'CREATE OR REPLACE FORCE VIEW ' || V_ESQUEMA || '.vtar_tarea_vs_tge (dd_tge_id_pendiente,
                                                       dd_tge_id_espera,
                                                       dd_tge_id_alerta,
                                                       dd_tge_id_supervisor,
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
                                                       t_referencia
                                                      )
AS  
 SELECT  CASE
               WHEN (sta.dd_sta_id = 700 OR sta.dd_sta_id = 701)
                  THEN -1                                                                                                                               -- Quitamos las anotaciones
               WHEN NVL (tap.dd_tge_id, 0) != 0
                  THEN tap.dd_tge_id
               WHEN sta.dd_tge_id IS NULL
                  THEN CASE sta.dd_sta_gestor
                         WHEN 0
                            THEN 3
                         ELSE 2
                      END
               ELSE sta.dd_tge_id
            END dd_tge_id_pendiente
-- tipo de gestor para las tareas en espera
            --,tar.tar_en_espera, tar.tar_en_espera,tap.dd_tge_id,
            ,CASE
               WHEN (tar.tar_en_espera IS NOT NULL AND tar.tar_en_espera = 1)
                  THEN --(select vusu.usu_id from bankmaster.usu_usuarios where tar_emisor = usu_nombre)
                  vusu.dd_tgE_id
               ELSE -1
            END dd_tge_id_espera
-- tipo de gestor para las alertas
            , CASE
               WHEN (tar.tar_alerta IS NOT NULL AND tar.tar_alerta = 1)
                  THEN NVL (tap.dd_tsup_id, 3)
               ELSE -1
            END dd_tge_id_alerta, NVL (tap.dd_tsup_id, 3) dd_tge_id_supervisor, tar."TAR_ID", tar."CLI_ID", tar."EXP_ID", tar."ASU_ID", tar."TAR_TAR_ID", tar."SPR_ID", tar."SCX_ID", tar."DD_EST_ID",
            tar."DD_EIN_ID", tar."DD_STA_ID", tar."TAR_CODIGO", tar."TAR_TAREA", tar."TAR_DESCRIPCION", tar."TAR_FECHA_FIN", tar."TAR_FECHA_INI", tar."TAR_EN_ESPERA", tar."TAR_ALERTA",
            tar."TAR_TAREA_FINALIZADA", tar."TAR_EMISOR", tar."VERSION", tar."USUARIOCREAR", tar."FECHACREAR", tar."USUARIOMODIFICAR", tar."FECHAMODIFICAR", tar."USUARIOBORRAR", tar."FECHABORRAR",
            tar."BORRADO", tar."PRC_ID", tar."CMB_ID", tar."SET_ID", tar."TAR_FECHA_VENC", tar."OBJ_ID", tar."TAR_FECHA_VENC_REAL", tar."DTYPE", tar."NFA_TAR_REVISADA", tar."NFA_TAR_FECHA_REVIS_ALER",
            tar."NFA_TAR_COMENTARIOS_ALERTA", tar."DD_TRA_ID", tar."CNT_ID", tar."TAR_DESTINATARIO", tar."TAR_TIPO_DESTINATARIO", tar."TAR_ID_DEST", tar."PER_ID", tar."RPR_REFERENCIA",
            tar."T_REFERENCIA"
       FROM tar_tareas_notificaciones tar JOIN bankmaster.dd_sta_subtipo_tarea_base sta ON tar.dd_sta_id = sta.dd_sta_id
            LEFT JOIN tex_tarea_externa tex ON tar.tar_id = tex.tar_id
            LEFT JOIN tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id
            left JOIN vtar_asu_vs_usu vusu ON tar.asu_id = vusu.asu_id 
      WHERE 1 = 1 AND tar.dd_ein_id IN (3, 5, 2, 9)                                                                                                                     -- solo asuntos y procedimientos
            AND tar.borrado = 0 AND (tar.tar_tarea_finalizada IS NULL OR tar.tar_tarea_finalizada = 0)
   --AND TAR_ID_DEST=1   
   ORDER BY tar.tar_fecha_venc';
        
   execute immediate 'CREATE OR REPLACE FORCE VIEW ' || V_ESQUEMA || '.vtar_tarea_vs_responsables (tar_id,
                                                                dtype,
                                                                tar_fecha_venc,
                                                                prc_id,
                                                                dd_ein_id,
                                                                dd_sta_id,
                                                                tar_tar_id,
                                                                dd_est_id,
                                                                asu_id,
                                                                asu_nombre,
                                                                fechacrear_asu,
                                                                rpr_referencia,
                                                                per_id,
                                                                tar_id_dest,
                                                                tar_tipo_destinatario,
                                                                tar_destinatario,
                                                                cnt_id,
                                                                dd_tra_id,
                                                                nfa_tar_comentarios_alerta,
                                                                nfa_tar_fecha_revis_aler,
                                                                nfa_tar_revisada,
                                                                tar_fecha_venc_real,
                                                                obj_id,
                                                                set_id,
                                                                cmb_id,
                                                                borrado,
                                                                fechaborrar,
                                                                usuarioborrar,
                                                                fechacrear,
                                                                usuariocrear,
                                                                fechamodificar,
                                                                usuariomodificar,
                                                                VERSION,
                                                                tar_emisor,
                                                                tar_tarea_finalizada,
                                                                tar_alerta,
                                                                tar_en_espera,
                                                                tar_fecha_ini,
                                                                tar_fecha_fin,
                                                                tar_descripcion,
                                                                tar_tarea,
                                                                tar_codigo,
                                                                scx_id,
                                                                spr_id,
                                                                exp_id,
                                                                cli_id,
                                                                dd_tge_id_alerta,
                                                                dd_tge_id_espera,
                                                                dd_tge_id_pendiente,
                                                                dd_tge_id_supervisor,
                                                                usu_pendiente,
                                                                usu_alerta,
                                                                usu_espera,
                                                                usu_id_original,
                                                                usu_supervisor
                                                               )
AS
   SELECT distinct tar_id, dtype, tar_fecha_venc, prc_id, dd_ein_id, dd_sta_id, tar_tar_id, dd_est_id, asu_id, asu_nombre, fechacrear_asu, rpr_referencia, per_id, tar_id_dest, tar_tipo_destinatario,
          tar_destinatario, cnt_id, dd_tra_id, nfa_tar_comentarios_alerta, nfa_tar_fecha_revis_aler, nfa_tar_revisada, tar_fecha_venc_real, obj_id, set_id, cmb_id, borrado, fechaborrar, usuarioborrar,
          fechacrear, usuariocrear, fechamodificar, usuariomodificar, VERSION, tar_emisor, tar_tarea_finalizada, tar_alerta, tar_en_espera, tar_fecha_ini, tar_fecha_fin, tar_descripcion, tar_tarea,
          tar_codigo, scx_id, spr_id, exp_id, cli_id, dd_tge_id_alerta, dd_tge_id_espera, dd_tge_id_pendiente, dd_tge_id_supervisor, NVL (usu_pendiente, -1) usu_pendiente,
          NVL (usu_alerta, -1) usu_alerta, NVL (usu_espera, 1) usu_espera, NVL (usu_id_original, -1) usu_id_original, NVL (usu_supervisor, -1) usu_supervisor
     FROM (     
     SELECT vtar.*, vusu.asu_nombre, vusu.fechacrear fechacrear_asu, DECODE (vusu.dd_tge_id, vtar.dd_tge_id_pendiente, vusu.usu_id) usu_pendiente,
                  DECODE (vusu.dd_tge_id, vtar.dd_tge_id_espera, vusu.usu_id) usu_espera, DECODE (vusu.dd_tge_id, vtar.dd_tge_id_alerta, vusu.usu_id) usu_alerta,
                  DECODE (vusu.dd_tge_id, vtar.dd_tge_id_supervisor, vusu.usu_id) usu_supervisor, DECODE (vusu.dd_tge_id, vtar.dd_tge_id_pendiente, vusu.usu_id_original) usu_id_original
      FROM vtar_tarea_vs_tge vtar JOIN vtar_asu_vs_usu vusu ON vtar.asu_id = vusu.asu_id
         )
    WHERE (usu_pendiente > 0 or usu_espera > 0 or usu_alerta > 0)';
   
	
	DBMS_OUTPUT.PUT_LINE('[FIN] FINALIZADO CORRECTAMENTE');
  
--COMMIT;


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