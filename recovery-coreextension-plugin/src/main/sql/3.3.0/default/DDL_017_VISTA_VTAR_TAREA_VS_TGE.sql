--/*
--##########################################
--## Author: Gonzalo
--## Mejora de la búsqueda de tareas pendientes
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 
    
BEGIN

  -- CREACION DE INDICES
  DBMS_OUTPUT.PUT_LINE('CREATE INDEX '|| V_ESQUEMA ||'.VTAR_TAREA_VS_TGE...');
  
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW '|| V_ESQUEMA ||'.VTAR_TAREA_VS_TGE (DD_TGE_ID_PENDIENTE, DD_TGE_ID_ESPERA, DD_TGE_ID_ALERTA, DD_TGE_ID_SUPERVISOR, TAR_ID, CLI_ID, EXP_ID, ASU_ID, TAR_TAR_ID, SPR_ID, SCX_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, TAR_FECHA_FIN, TAR_FECHA_INI, TAR_EN_ESPERA, TAR_ALERTA, TAR_TAREA_FINALIZADA, TAR_EMISOR, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, PRC_ID, CMB_ID, SET_ID, TAR_FECHA_VENC, OBJ_ID, TAR_FECHA_VENC_REAL, DTYPE, NFA_TAR_REVISADA, NFA_TAR_FECHA_REVIS_ALER, NFA_TAR_COMENTARIOS_ALERTA, DD_TRA_ID, CNT_ID, TAR_DESTINATARIO, TAR_TIPO_DESTINATARIO, TAR_ID_DEST, PER_ID, RPR_REFERENCIA, T_REFERENCIA) AS
  SELECT CASE
               WHEN (sta.dd_sta_id = 700 OR sta.dd_sta_id = 701)
                  THEN -1 -- Quitamos las anotaciones
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
                  THEN  --(select vusu.usu_id from bankmaster.usu_usuarios where tar_emisor = usu_nombre)
                  vusu.dd_tgE_id
               ELSE -1
            END dd_tge_id_espera
            -- tipo de gestor para las alertas
            , CASE
               WHEN (tar.tar_alerta IS NOT NULL AND tar.tar_alerta = 1)
                  THEN NVL (tap.dd_tsup_id, 3)
               ELSE -1
            END dd_tge_id_alerta, NVL (tap.dd_tsup_id, 3) dd_tge_id_supervisor, tar.TAR_ID, tar.CLI_ID, tar.EXP_ID, tar.ASU_ID, tar.TAR_TAR_ID, tar.SPR_ID, tar.SCX_ID, tar.DD_EST_ID,
            tar.DD_EIN_ID, tar.DD_STA_ID, tar.TAR_CODIGO, tar.TAR_TAREA, tar.TAR_DESCRIPCION, tar.TAR_FECHA_FIN, tar.TAR_FECHA_INI, tar.TAR_EN_ESPERA, tar.TAR_ALERTA,
           tar.TAR_TAREA_FINALIZADA, tar.TAR_EMISOR, tar.VERSION, tar.USUARIOCREAR, tar.FECHACREAR, tar.USUARIOMODIFICAR, tar.FECHAMODIFICAR, tar.USUARIOBORRAR, tar.FECHABORRAR,
            tar.BORRADO, tar.PRC_ID, tar.CMB_ID, tar.SET_ID, tar.TAR_FECHA_VENC, tar.OBJ_ID, tar.TAR_FECHA_VENC_REAL, tar.DTYPE, tar.NFA_TAR_REVISADA, tar.NFA_TAR_FECHA_REVIS_ALER,
            tar.NFA_TAR_COMENTARIOS_ALERTA, tar.DD_TRA_ID, tar.CNT_ID, tar.TAR_DESTINATARIO, tar.TAR_TIPO_DESTINATARIO, tar.TAR_ID_DEST, tar.PER_ID, tar.RPR_REFERENCIA,
            tar.T_REFERENCIA 
       FROM tar_tareas_notificaciones tar 
            JOIN '|| V_ESQUEMA_M ||'.dd_sta_subtipo_tarea_base sta ON tar.dd_sta_id = sta.dd_sta_id 
            LEFT JOIN tex_tarea_externa tex ON tar.tar_id = tex.tar_id 
            LEFT JOIN tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id 
            LEFT JOIN vtar_asu_vs_usu vusu ON tar.asu_id = vusu.asu_id 
      WHERE 1 = 1 AND tar.dd_ein_id IN (3, 5, 2, 9)  -- solo asuntos y procedimientos
            AND tar.borrado = 0 AND (tar.tar_tarea_finalizada IS NULL OR tar.tar_tarea_finalizada = 0)
   --AND TAR_ID_DEST=1 
   --ORDER BY tar.tar_fecha_venc
   ';
   
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VTAR_TAREA_VS_TGE...Creado');

END;
/

EXIT;

