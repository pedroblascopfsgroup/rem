--/*
--##########################################
--## AUTOR=OSCAR DORADO
--## FECHA_CREACION=20160215
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-578
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de vistas de procuradores
--##                               
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';               -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';       -- Configuracion Esquema Master
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);
 S_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);


BEGIN 


  
 V_MSQL := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASU_PROC_V2 
(ID_, ASU_ID, PRC_ID, ASU_NOMBRE, PLAZA, JUZGADO, AUTO, TIPO_PRC, PRINCIPAL, TEX_ID, COD_ESTADO_PRC, DES_ESTADO_PRC, PRC_SALDO_RECUPERACION, PRC_FECHA_CREAR, TAR_TAREA)
AS 
  (SELECT DISTINCT ROWNUM                      id_, 
                   asu.asu_id                  ASU_ID, 
                   prc.prc_id                  PRC_ID, 
                   asu.asu_nombre              ASU_NOMBRE, 
                   pla.dd_pla_descripcion      PLAZA, 
                   juz.dd_juz_descripcion      JUZGADO, 
                   prc.prc_cod_proc_en_juzgado AUTO, 
                   tpo.dd_tpo_descripcion      TIPO_PRC, 
                   prc.prc_saldo_recuperacion  PRINCIPAL, 
                   tex.tex_id                  TEX_ID, 
                   epr.dd_epr_codigo           COD_ESTADO_PRC, 
                   epr.dd_epr_descripcion      DES_ESTADO_PRC, 
                   prc.prc_saldo_recuperacion, 
                   prc.fechacrear, 
                   tar.tar_tarea 
   FROM   '||V_ESQUEMA||'.ASU_ASUNTOS asu 
          INNER JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc 
                  ON asu.asu_id = prc.asu_id 
                     AND prc.borrado = 0 
          LEFT JOIN '||V_ESQUEMA||'.DD_JUZ_JUZGADOS_PLAZA juz 
                 ON prc.dd_juz_id = juz.dd_juz_id 
                    AND ( juz.borrado = 0 
                           OR juz.borrado IS NULL ) 
          LEFT JOIN '||V_ESQUEMA||'.DD_PLA_PLAZAS pla 
                 ON pla.dd_pla_id = juz.dd_pla_id 
                    AND ( pla.borrado = 0 
                           OR pla.borrado IS NULL ) 
          INNER JOIN '||V_ESQUEMA||'.DD_TJ_TIPO_JUICIO tj 
                  ON prc.dd_tpo_id = tj.dd_tpo_id 
          INNER JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO tpo 
                  ON prc.dd_tpo_id = tpo.dd_tpo_id 
                     AND ( tpo.dd_tac_id <> (SELECT dd_tac_id 
                                             FROM   '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION tac 
                                             WHERE  tac.dd_tac_codigo = ''TR'') ) 
          LEFT JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar 
                 ON prc.prc_id = tar.prc_id 
                    AND ( tar.tar_tarea_finalizada = 0 
                           OR tar.tar_tarea_finalizada IS NULL ) 
          LEFT JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex 
                 ON tex.tar_id = tar.tar_id 
                    AND tex.borrado = 0 
          INNER JOIN '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO epr 
                  ON prc.dd_epr_id = epr.dd_epr_id 
          JOIN '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE sta 
            ON sta.dd_sta_id = tar.dd_sta_id 
   WHERE  asu.borrado = 0)';

EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('CREADA VISTA V_MSV_BUSQUEDA_ASU_PROC_V2');

V_MSQL := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASU_TRAM_V2 
(ID_, ASU_ID, PRC_ID, ASU_NOMBRE, PLAZA, JUZGADO, AUTO, TIPO_PRC, PRINCIPAL, TEX_ID, COD_ESTADO_PRC, DES_ESTADO_PRC, PRC_SALDO_RECUPERACION, PRC_FECHA_CREAR, TAR_TAREA)
AS 
  (SELECT DISTINCT ROWNUM                      id_, 
                   asu.asu_id                  ASU_ID, 
                   prc.prc_id                  PRC_ID, 
                   asu.asu_nombre              ASU_NOMBRE, 
                   pla.dd_pla_descripcion      PLAZA, 
                   juz.dd_juz_descripcion      JUZGADO, 
                   prc.prc_cod_proc_en_juzgado AUTO, 
                   tpo.dd_tpo_descripcion      TIPO_PRC, 
                   prc.prc_saldo_recuperacion  PRINCIPAL, 
                   tex.tex_id                  TEX_ID, 
                   epr.dd_epr_codigo           COD_ESTADO_PRC, 
                   epr.dd_epr_descripcion      DES_ESTADO_PRC, 
                   prc.prc_saldo_recuperacion, 
                   prc.fechacrear, 
                   tar.tar_tarea 
   FROM   '||V_ESQUEMA||'.ASU_ASUNTOS asu 
          INNER JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc 
                  ON asu.asu_id = prc.asu_id 
                     AND prc.borrado = 0 
          LEFT JOIN '||V_ESQUEMA||'.DD_JUZ_JUZGADOS_PLAZA juz 
                 ON prc.dd_juz_id = juz.dd_juz_id 
                    AND ( juz.borrado = 0 
                           OR juz.borrado IS NULL ) 
          LEFT JOIN '||V_ESQUEMA||'.DD_PLA_PLAZAS pla 
                 ON pla.dd_pla_id = juz.dd_pla_id 
                    AND ( pla.borrado = 0 
                           OR pla.borrado IS NULL ) 
          INNER JOIN '||V_ESQUEMA||'.DD_TJ_TIPO_JUICIO tj 
                  ON prc.dd_tpo_id = tj.dd_tpo_id 
          INNER JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO tpo 
                  ON prc.dd_tpo_id = tpo.dd_tpo_id 
                     AND ( tpo.dd_tac_id = (SELECT dd_tac_id 
                                            FROM   '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION tac 
                                            WHERE  tac.dd_tac_codigo = ''TR'') ) 
          LEFT JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar 
                 ON prc.prc_id = tar.prc_id 
                    AND ( tar.tar_tarea_finalizada = 0 
                           OR tar.tar_tarea_finalizada IS NULL ) 
          INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex 
                  ON tex.tar_id = tar.tar_id 
          INNER JOIN '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO epr 
                  ON prc.dd_epr_id = epr.dd_epr_id 
          JOIN '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE sta 
            ON sta.dd_sta_id = tar.dd_sta_id 
   WHERE  asu.borrado = 0)'; 

EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('CREADA VISTA V_MSV_BUSQUEDA_ASU_TRAM_V2');

V_MSQL := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS_V2 
(ID_, ASU_ID, PRC_ID, ASU_NOMBRE, PLAZA, JUZGADO, AUTO, TIPO_PRC, PRINCIPAL, TEX_ID, COD_ESTADO_PRC, DES_ESTADO_PRC, PRC_SALDO_RECUPERACION, PRC_FECHA_CREAR, TAR_TAREA)
AS 
  (SELECT vproc.id_, 
          vproc.asu_id, 
          vproc.prc_id, 
          vproc.asu_nombre, 
          vproc.plaza, 
          vproc.juzgado, 
          vproc.auto, 
          vproc.tipo_prc, 
          vproc.principal, 
          vproc.tex_id, 
          vproc.cod_estado_prc, 
          vproc.des_estado_prc, 
          vproc.prc_saldo_recuperacion, 
          vproc.prc_fecha_crear, 
          vproc.tar_tarea 
   FROM   '||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASU_PROC_V2 vproc 
   UNION ALL 
   SELECT vtram.id_, 
          vtram.asu_id, 
          vtram.prc_id, 
          vtram.asu_nombre, 
          vtram.plaza, 
          vtram.juzgado, 
          vtram.auto, 
          vtram.tipo_prc, 
          vtram.principal, 
          vtram.tex_id, 
          vtram.cod_estado_prc, 
          vtram.des_estado_prc, 
          vtram.prc_saldo_recuperacion, 
          vtram.prc_fecha_crear, 
          vtram.tar_tarea 
   FROM   '||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASU_TRAM_V2 vtram)'; 

EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('CREADA VISTA V_MSV_BUSQUEDA_ASU_PROC_V2');

V_MSQL := 'CREATE OR REPLACE VIEW '||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS_USU_V2 
(ID_, ASU_ID, PRC_ID, ASU_NOMBRE, PLAZA, JUZGADO, AUTO, TIPO_PRC, PRINCIPAL, TEX_ID, COD_ESTADO_PRC, DES_ESTADO_PRC, PRC_SALDO_RECUPERACION, PRC_FECHA_CREAR, USU_ID, TAR_TAREA)
AS 
  SELECT DISTINCT asu.id_, 
                  asu.asu_id, 
                  asu.prc_id, 
                  asu.asu_nombre, 
                  asu.plaza, 
                  asu.juzgado, 
                  asu.auto, 
                  asu.tipo_prc, 
                  asu.principal, 
                  asu.tex_id, 
                  asu.cod_estado_prc, 
                  asu.des_estado_prc, 
                  asu.prc_saldo_recuperacion, 
                  asu.prc_fecha_crear, 
                  usu.usu_id, 
                  asu.tar_tarea 
  FROM   '||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS_V2 asu 
         LEFT JOIN '||V_ESQUEMA||'.VTAR_ASU_VS_USU usu 
                ON asu.asu_id = usu.asu_id'; 
 
 
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('CREADA VISTA V_MSV_BUSQUEDA_ASUNTOS_USU_V2');


EXCEPTION
WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
END;
/
EXIT;   
