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

dbms_output.put_line('[INICIO] creación vistas');


V_MSQL := 'SELECT COUNT(1) FROM all_tab_cols  
         WHERE UPPER(table_name) = ''V_DD_STA_SUBTIPO_TAREA_BASE''
         AND OWNER = ''' || V_ESQUEMA || ''''; 
       
       EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
       
     if V_NUM_TABLAS = 0 then 
     
     DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO VISTAS');
     
     
     EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW ' || V_ESQUEMA || '.V_DD_STA_SUBTIPO_TAREA_BASE 
REFRESH COMPLETE
START WITH TO_DATE(sysdate)
NEXT sysdate+1 
AS 
SELECT DD_STA_ID, DD_STA_CODIGO, DD_TGE_ID, 
   DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_STA_GESTOR
  FROM BANKmaster.dd_sta_subtipo_tarea_base dd_sta';


EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW ' || V_ESQUEMA || '.V_TAREA_USUPENDIENTE 
REFRESH COMPLETE
START WITH TO_DATE(sysdate)
NEXT sysdate+1 
AS 
SELECT pendientes.tar_id, asu_pendientes.usu_id
  FROM tar_tareas_notificaciones pendientes LEFT JOIN v_dd_sta_subtipo_tarea_base sta ON pendientes.dd_sta_id = sta.dd_sta_id
       LEFT JOIN vtar_asu_vs_usu asu_pendientes ON pendientes.asu_id = asu_pendientes.asu_id AND sta.dd_tge_id = asu_pendientes.dd_tge_id
 WHERE pendientes.dd_ein_id IN (3, 5) AND pendientes.borrado = 0 AND (pendientes.tar_tarea_finalizada IS NULL OR pendientes.tar_tarea_finalizada = 0)';

EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA || '.IDX_TAREA_USUPENDIENTE_2 ON ' || V_ESQUEMA || '.V_TAREA_USUPENDIENTE
(USU_ID)';

EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.IDX_TAREA_USUPENDIENTE_1 ON ' || V_ESQUEMA || '.V_TAREA_USUPENDIENTE
(TAR_ID)';


EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE VIEW vtar_tar_iac (tar_id, cartera)
AS
   SELECT   tar_id, DECODE (COUNT (*), 1, MAX (cartera), ''COMPARTIDA'') cartera
       FROM (
       SELECT DISTINCT (iac.iac_value) cartera, tar.tar_id
                        FROM tar_tareas_notificaciones tar JOIN asu_asuntos asu ON tar.asu_id = asu.asu_id AND asu.borrado = 0
                             JOIN cex_contratos_expediente cex ON asu.exp_id = cex.exp_id
                             JOIN ext_iac_info_add_contrato iac ON cex.cnt_id = iac.cnt_id AND iac.dd_ifc_id = 43 AND iac.iac_value IS NOT NULL
                             )
   GROUP BY tar_id';




EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE VIEW ' || V_ESQUEMA || '.vtar_tar_iac_count (count_carteras, tar_id)
AS
   SELECT DISTINCT COUNT (v.tar_id), v.tar_id
              FROM vtar_tar_iac v
          GROUP BY v.tar_id';


EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW ' || V_ESQUEMA || '.V_DD_EST_ESTADOS_ITINERARIOS 
REFRESH COMPLETE
START WITH TO_DATE(sysdate)
NEXT sysdate+7 
AS 
SELECT DD_EST_ID, DD_EIN_ID, DD_EST_ORDEN, 
   DD_EST_CODIGO, DD_EST_DESCRIPCION, DD_EST_DESCRIPCION_LARGA
  FROM bankmaster.dd_est_estados_itinerarios dd_est';

EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW ' || V_ESQUEMA || '.V_TAREA_TIPOANOTACION 
REFRESH COMPLETE
START WITH TO_DATE(sysdate)
NEXT sysdate+1 
AS 
SELECT   tar_id, MAX (flag) flag_envio_correo, MAX (tipo) tipo_anotacion
    FROM (SELECT DISTINCT ireg1.irg_valor AS tar_id, DECODE (ireg2.irg_clave, ''FLAG_MAIL_TAREA'', ireg2.irg_valor) flag, DECODE (ireg2.irg_clave, ''TIPO_ANO_TAREA'', ireg2.irg_valor) tipo, ireg2.irg_valor AS tipo_anotacion,
                          ireg2.irg_clave AS clave
                     FROM mej_irg_info_registro ireg1 JOIN mej_reg_registro reg1 ON ireg1.reg_id = reg1.reg_id
                          JOIN mej_dd_trg_tipo_registro tipo1 ON reg1.dd_trg_id = tipo1.dd_trg_id
                          JOIN mej_reg_registro reg2 ON reg1.reg_id = reg2.reg_id
                          JOIN mej_irg_info_registro ireg2 ON reg2.reg_id = ireg2.reg_id
                          JOIN mej_dd_trg_tipo_registro tipo2 ON reg2.dd_trg_id = tipo2.dd_trg_id
                    WHERE (tipo1.dd_trg_id = 6 AND tipo2.dd_trg_id = 6 AND ireg1.irg_clave = ''ID_TAREA'') OR (tipo1.dd_trg_id = 8 AND tipo2.dd_trg_id = 8 AND ireg1.irg_clave = ''ID_NOTIF''))
   WHERE (clave = ''TIPO_ANO_TAREA'' AND REGEXP_INSTR (tipo_anotacion, ''[0-9]'') = 0) OR clave = ''FLAG_MAIL_TAREA''
GROUP BY tar_id';

EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.IDX_TAREA_TIPOANOTACION_1 ON ' || V_ESQUEMA || '.V_TAREA_TIPOANOTACION
(TAR_ID)';

EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA || '.IDX_TAREA_TIPOANOTACION_2 ON ' || V_ESQUEMA || '.V_TAREA_TIPOANOTACION
(TIPO_ANOTACION)';

EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA || '.IDX_TAREA_TIPOANOTACION_3 ON ' || V_ESQUEMA || '.V_TAREA_TIPOANOTACION
(FLAG_ENVIO_CORREO)';

EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW ' || V_ESQUEMA || '.V42_BUSQUEDA_TAREAS 
REFRESH COMPLETE
START WITH TO_DATE(sysdate)
NEXT sysdate+1/48 
AS 
SELECT DISTINCT tar_id, tar_id tarea, asu_nombre asudesc, dd_tpo_descripcion tipoprcdesc, nombre_cliente nombrecliente, exp_descripcion descexpediente, est_id estado, pef_id_gestor gestorperfil,
                pef_id_supervisor supervisorperfil, CAST (MAX (usugestor) AS NUMBER (16)) usugestor, CAST (MAX (ususupervisor) AS NUMBER (16)) ususupervisor, asu_id asunto,
                usu_username usuariodestinotarea, tar_emisor usuarioorigentarea, tipo_anotacion tipoanotacion, flag_envio_correo flagenviocorreo, usu_id usupendiente, cartera,
                CAST (tipo_asunto AS CHAR) tipo_asunto, dtype
           FROM (SELECT tar.tar_id, asu.asu_nombre, tpo.dd_tpo_descripcion,
                        CASE
                           WHEN per.per_apellido1 IS NULL AND per.per_apellido2 IS NULL
                              THEN per.per_nombre
                           WHEN per.per_apellido2 IS NULL
                              THEN per.per_apellido1 || '', '' || per.per_nombre
                           WHEN per.per_apellido1 IS NULL
                              THEN per.per_apellido2 || '', '' || per.per_nombre
                           ELSE per.per_apellido1 || '' '' || per.per_apellido2 || '', '' || per.per_nombre
                        END nombre_cliente,
                        expe.exp_descripcion, est_id, pef_id_gestor, est.pef_id_supervisor, DECODE (gaa.dd_tge_id, 2, usd.usu_id) usugestor, DECODE (gaa.dd_tge_id, 3, usd.usu_id) ususupervisor,
                        asu.asu_id, usu.usu_username, tar.tar_emisor, tipo_anotacion, CASE
                           WHEN flag_envio_correo = 1
                              THEN ''true''
                           ELSE ''false''
                        END flag_envio_correo, tarusu.usu_id, CASE
                           WHEN viac_count.count_carteras = 1
                              THEN NVL (viac.cartera, ''Compartida'')
                           ELSE ''Compartida''
                        END cartera, asu.dd_tas_id AS tipo_asunto, ''UGASTareaEncontrada'' AS dtype
                   FROM tar_tareas_notificaciones tar LEFT JOIN v_tarea_tipoanotacion anot ON TO_CHAR (tar.tar_id) = anot.tar_id
                        LEFT JOIN asu_asuntos asu ON tar.asu_id = asu.asu_id
                        LEFT JOIN cli_clientes cli ON tar.cli_id = cli.cli_id
                        LEFT JOIN v_dd_est_estados_itinerarios estiti ON cli.dd_est_id = estiti.dd_est_id
                        LEFT JOIN est_estados est ON estiti.dd_est_id = est.dd_est_id
                        LEFT JOIN prc_procedimientos prc ON tar.prc_id = prc.prc_id
                        LEFT JOIN dd_tpo_tipo_procedimiento tpo ON prc.dd_tpo_id = tpo.dd_tpo_id
                        LEFT JOIN per_personas per ON cli.per_id = per.per_id
                        LEFT JOIN exp_expedientes expe ON tar.exp_id = expe.exp_id
                        LEFT JOIN vtar_tar_iac_count viac_count ON tar.tar_id = viac_count.tar_id
                        LEFT JOIN vtar_tar_iac viac ON tar.tar_id = viac.tar_id
                        LEFT JOIN v_tarea_usupendiente tarusu ON tar.tar_id = tarusu.tar_id
                        LEFT JOIN gaa_gestor_adicional_asunto gaa ON asu.asu_id = gaa.asu_id
                        LEFT JOIN usd_usuarios_despachos usd ON gaa.usd_id = usd.usd_id
                        LEFT JOIN v_usu_usuarios usu ON tar.tar_id_dest = usu.usu_id
                        )
       GROUP BY tar_id,
                asu_nombre,
                dd_tpo_descripcion,
                nombre_cliente,
                exp_descripcion,
                est_id,
                pef_id_gestor,
                pef_id_supervisor,
                asu_id,
                usu_username,
                tar_emisor,
                tipo_anotacion,
                flag_envio_correo,
                usu_id,
                cartera,
                tipo_asunto,
                dtype';

EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA || '.IDX_BUSQUEDA_TAREAS_M_3 ON ' || V_ESQUEMA || '.V42_BUSQUEDA_TAREAS
(ASUNTO)';

EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.IDX_BUSQUEDA_TAREAS_M_4 ON ' || V_ESQUEMA || '.V42_BUSQUEDA_TAREAS
(TAREA)';

EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.IDX_BUSQUEDA_TAREAS_M_1 ON ' || V_ESQUEMA || '.V42_BUSQUEDA_TAREAS
(TAR_ID)';

EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA || '.IDX_BUSQUEDA_TAREAS_M_2 ON ' || V_ESQUEMA || '.V42_BUSQUEDA_TAREAS
(USUPENDIENTE)';

        DBMS_OUTPUT.PUT_LINE('[INFO] BUSQUEDA TAREAS AÑADIDAS'); 

 
   
   end if; 


    V_MSQL := 'SELECT COUNT(1) FROM all_tab_cols  
         WHERE UPPER(table_name) = ''VTAR_ASU_VS_USU''
         AND OWNER = ''' || V_ESQUEMA || ''''; 
       
       EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
       
       
    if V_NUM_TABLAS > 0 then 
      execute immediate 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VTAR_ASU_VS_USU';
      DBMS_OUTPUT.put_line('[INFO] VTAR_ASU_VS_USU Borrada correctamente');
    end if;
     
    execute immediate 'CREATE MATERIALIZED VIEW ' || V_ESQUEMA || '.VTAR_ASU_VS_USU
REFRESH COMPLETE
START WITH TO_DATE(sysdate)
NEXT sysdate+1 
AS 
  SELECT DISTINCT CASE usu.usu_grupo
                   WHEN 0
                      THEN usu.usu_id
                   ELSE gru.usu_id_usuario
                END usu_id,
                usd.des_id, ges.dd_tge_id, usd.usu_id usu_id_original, asu.*
           FROM asu_asuntos asu
                JOIN
                (SELECT asu_id, usd_id, 4 dd_tge_id
                   FROM asu_asuntos
                  WHERE usd_id IS NOT NULL                     -- procuradores
                 UNION
                 SELECT asu_id, usd_id, dd_tge_id
                   FROM gaa_gestor_adicional_asunto       -- resto de gestores
                                                   ) ges
                ON asu.asu_id = ges.asu_id
                JOIN usd_usuarios_despachos usd ON ges.usd_id = usd.usd_id
                JOIN bankmaster.usu_usuarios usu ON usd.usu_id = usu.usu_id
                LEFT JOIN bankmaster.gru_grupos_usuarios gru
                ON usd.usu_id = gru.usu_id_grupo AND gru.borrado = 0';
                
                
                 if V_NUM_TABLAS > 0 then 
      execute immediate 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VTAR_ASUNTO_GESTOR';
      DBMS_OUTPUT.put_line('[INFO] VTAR_ASUNTO_GESTOR Borrada correctamente');
    end if;
     
    execute immediate 'CREATE MATERIALIZED VIEW ' || V_ESQUEMA || '.VTAR_ASUNTO_GESTOR 
	REFRESH COMPLETE
	START WITH TO_DATE(sysdate)
	NEXT sysdate+1 
  	AS SELECT DISTINCT asu.asu_id, asu.dd_tge_id,
                CASE
                   WHEN usu.usu_apellido1 IS NULL
                   AND usu.usu_apellido2 IS NULL
                      THEN usu.usu_nombre
                   WHEN usu.usu_apellido2 IS NULL
                      THEN usu.usu_apellido1 || '', '' || usu.usu_nombre
                   WHEN usu.usu_apellido1 IS NULL
                      THEN usu.usu_apellido2 || '', '' || usu.usu_nombre
                   ELSE    usu.usu_apellido1
                        || '' ''
                        || usu.usu_apellido2
                        || '', ''
                        || usu.usu_nombre
                END apellido_nombre,
                usu.*
           FROM vtar_asu_vs_usu asu JOIN bankmaster.usu_usuarios usu
                ON asu.usu_id_original = usu.usu_id';
	
	
--COMMIT;

dbms_output.put_line('[FIN] creación vistas');

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