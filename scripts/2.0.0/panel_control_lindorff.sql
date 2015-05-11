-- primero habrá que crear unas tablas con la cartera y lote
drop sequence s_car_cartera;

CREATE SEQUENCE S_CAR_CARTERA;

drop table lot_lote;

drop table car_cartera;

CREATE TABLE CAR_CARTERA (
   CAR_ID                     NUMBER(16)                NOT NULL,
   CAR_DESCRIPCION           VARCHAR2(50 BYTE),
   CAR_DESCRIPCION_LARGA     VARCHAR2(250 BYTE),
   VERSION                     INTEGER     DEFAULT 0      NOT NULL,
   USUARIOCREAR                VARCHAR2(10 BYTE)       NOT NULL,
   FECHACREAR                  TIMESTAMP(6)            NOT NULL,
   USUARIOMODIFICAR            VARCHAR2(10 BYTE),
   FECHAMODIFICAR           TIMESTAMP(6),
   USUARIOBORRAR            VARCHAR2(10 BYTE),
   FECHABORRAR              TIMESTAMP(6),
   BORRADO                      NUMBER(1)     DEFAULT 0    NOT NULL,   
   CONSTRAINT PK_CAR_CARTERA PRIMARY KEY (CAR_ID)
);

INSERT INTO CAR_CARTERA(CAR_ID, CAR_DESCRIPCION, CAR_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR)
VALUES(S_CAR_CARTERA.nextval, 'CARTERA PROPIA', 'CARTERA PROPIA', 0, 'DIA', SYSDATE);

INSERT INTO CAR_CARTERA(CAR_ID, CAR_DESCRIPCION, CAR_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR)
VALUES(S_CAR_CARTERA.nextval, 'CARTERA AJENA', 'CARTERA AJENA', 0, 'DIA', SYSDATE);

INSERT INTO CAR_CARTERA(CAR_ID, CAR_DESCRIPCION, CAR_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR)
VALUES(S_CAR_CARTERA.nextval, 'CARTERA COMPARTIDA', 'CARTERA COMPARTIDA', 0, 'DIA', SYSDATE);

COMMIT;

drop sequence s_lot_lote;

CREATE SEQUENCE S_LOT_LOTE;



CREATE TABLE LOT_LOTE (
   LOT_ID                     NUMBER(16)                NOT NULL,
   LOT_DESCRIPCION           VARCHAR2(50 BYTE),
   LOT_DESCRIPCION_LARGA     VARCHAR2(250 BYTE),
   CAR_ID                    NUMBER(16)                NOT NULL,
   VERSION                     INTEGER     DEFAULT 0      NOT NULL,
   USUARIOCREAR             VARCHAR2(10 BYTE)       NOT NULL,
   FECHACREAR               TIMESTAMP(6)            NOT NULL,
   USUARIOMODIFICAR            VARCHAR2(10 BYTE),
   FECHAMODIFICAR           TIMESTAMP(6),
   USUARIOBORRAR            VARCHAR2(10 BYTE),
   FECHABORRAR                TIMESTAMP(6),
   BORRADO                      NUMBER(1)    DEFAULT 0    NOT NULL,   
   CONSTRAINT PK_LOT_LOTE PRIMARY KEY (LOT_ID),
   CONSTRAINT FK_LOT_LOTE_CAR_ID FOREIGN KEY (CAR_ID)REFERENCES CAR_CARTERA(CAR_ID)
);

INSERT INTO LOT_LOTE (LOT_ID, LOT_DESCRIPCION, LOT_DESCRIPCION_LARGA, CAR_ID, VERSION, USUARIOCREAR, FECHACREAR)
VALUES(S_LOT_LOTE.NEXTVAL, 'LOTE_ENERO_C1', 'LOTE_ENERO_C1', 1, 0, 'DIA', SYSDATE);

INSERT INTO LOT_LOTE (LOT_ID, LOT_DESCRIPCION, LOT_DESCRIPCION_LARGA, CAR_ID, VERSION, USUARIOCREAR, FECHACREAR)
VALUES(S_LOT_LOTE.NEXTVAL, 'LOTE_FEBRERO_C1', 'LOTE_FEBRERO_C1', 1, 0, 'DIA', SYSDATE);

INSERT INTO LOT_LOTE (LOT_ID, LOT_DESCRIPCION, LOT_DESCRIPCION_LARGA, CAR_ID, VERSION, USUARIOCREAR, FECHACREAR)
VALUES(S_LOT_LOTE.NEXTVAL, 'LOTE_ENERO_C2', 'LOTE_ENERO_C2', 2, 0, 'DIA', SYSDATE);

INSERT INTO LOT_LOTE (LOT_ID, LOT_DESCRIPCION, LOT_DESCRIPCION_LARGA, CAR_ID, VERSION, USUARIOCREAR, FECHACREAR)
VALUES(S_LOT_LOTE.NEXTVAL, 'LOTE_FEBRERO_C2', 'LOTE_FEBRERO_C2', 2, 0, 'DIA', SYSDATE);

INSERT INTO LOT_LOTE (LOT_ID, LOT_DESCRIPCION, LOT_DESCRIPCION_LARGA, CAR_ID, VERSION, USUARIOCREAR, FECHACREAR)
VALUES(S_LOT_LOTE.NEXTVAL, 'LOTE_ENERO_C3', 'LOTE_ENERO_C3', 3, 0, 'DIA', SYSDATE);

INSERT INTO LOT_LOTE (LOT_ID, LOT_DESCRIPCION, LOT_DESCRIPCION_LARGA, CAR_ID, VERSION, USUARIOCREAR, FECHACREAR)
VALUES(S_LOT_LOTE.NEXTVAL, 'LOTE_FEBRERO_C3', 'LOTE_FEBRERO_C3', 3, 0, 'DIA', SYSDATE);

commit;

-- asignar lotes a contratos
-- MODIFICAMOS LOS CONTRATOS PARA AÑADIR UN LOTE
ALTER TABLE CNT_CONTRATOS
 ADD (LOT_ID  NUMBER);
 
update cnt_contratos set lot_id = floor(dbms_random.value(1,7.99999999999));

commit;

-- tabla de columnas PC_COT_COLUMNS_EXP_TAR
drop sequence s_pc_cot_columns_exp_tar;

create sequence S_PC_COT_COLUMNS_EXP_TAR;

DROP TABLE PC_COT_COLUMNS_EXP_TAR
 CASCADE CONSTRAINTS;

CREATE TABLE PC_COT_COLUMNS_EXP_TAR
(
  COL_ID          NUMBER                            NOT NULL,
  HEADER          VARCHAR2(200 BYTE),
  COL_INDEX       NUMBER(16),
  DATAINDEX       VARCHAR2(200 BYTE),
  WIDTH           INTEGER,
  ALIGN           VARCHAR2(200 BYTE),
  SORTABLE        CHAR(1 BYTE)                      DEFAULT 1,
  ORDEN           INTEGER,
  FORMULARIO      VARCHAR2(50 BYTE),
  HIDDEN          CHAR(1 BYTE)                      DEFAULT 1,
  TYPE            VARCHAR2(10 BYTE),
  FLOW_CLICK     VARCHAR2(500CHAR),
  TAR_PANEL     VARCHAR2(20 CHAR),
  ETIQUETA      VARCHAR2(20 CHAR)
) ;


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, ETIQUETA)
 Values
   (8, 'Nivel', 1, 'nivel', 150, 'left', '1', 1, 'RES', '0', 'plugin.panelControl.lindorff', 'Nivel');
   
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, ETIQUETA)
 Values
   (9, 'Total Asuntos', 2, 'totalExpedientes', 150, 'left', '1', 2, 'RES', '0', 'plugin.panelControl.letrados.asuntos', 'Total Asuntos');
   
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, TYPE, ETIQUETA)
 Values
   (10, 'Importe total', 5, 'importe', 150, 'left', '1', 3, 'RES', '0', 'numero', 'Importe total');
   
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (11, 'Tareas vencidas', 'tareasVencidas', 150, 'left', '1', 4, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'TV', 'Tareas vencidas');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, TYPE, ETIQUETA)
 Values
   (12, 'Importe tareas vencidas', 5, 'importeVencido', 150, 'left', '1', 5, 'RES', '1', 'numero', 'Importe vencido');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (13, 'Tareas pendientes', 'tareasPendientesMes', 150, 'left', '1', 6, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'PM', 'Tareas pendientes');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, TYPE, ETIQUETA)
 Values
   (14, 'Importe tareas pendientes', 5, 'importePendiente', 150, 'left', '1', 7, 'RES', '1', 'numero', 'Importe pendiente');



Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (15, 'idNivel', 20, 'id', 150, 'left', '1', 20, 'RES', '1');



Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (16, 'cod', 21, 'cod', 150, 'left', '1', 21, 'RES', '1');



Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (17, 'userName', 22, 'userName', 150, 'left', '1', 22, 'RES', '1');



Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (21, 'Asesoría', 3, 'asesoria', 150, 'left', '1', 1, 'TAR', '1');



Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (22, 'Letrado/Gestor', 3, 'letrado', 200, 'left', '1', 2, 'TAR', '0');



Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (23, 'Estado', 29, 'estado', 50, 'left', '1', 3, 'TAR', '1');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (24, 'En plazo', 6, 'enPlazo', 50, 'left', '1', 4, 'TAR', '1');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (25, 'Días vencida', 32, 'diasVencida', 50, 'right', '1', 5, 'TAR', '0');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (26, 'Tarea', 35, 'tarea', 200, 'left', '1', 8, 'TAR', '0');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, TYPE)
 Values
   (27, 'Saldo', 28, 'saldo', 50, 'left', '1', 7, 'TAR', '0', 'numero');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (28, 'Campaña', 34, 'camp', 100, 'left', '1', 8, 'TAR', '1');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (29, 'Expediente', 4, 'expediente', 50, 'left', '1', 9, 'TAR', '1');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (30, 'Id Tarea', 9, 'tar_id', 100, 'left', '1', 10, 'TAR', '1');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (31, 'Procedimiento', 39, 'prc_id', 100, 'left', '1', 11, 'TAR', '1');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (32, 'Descripción', 19, 'descripcion', 200, 'left', '1', 12, 'TAR', '0');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (41, 'id', 4, 'idasunto', 100, 'left', '1', 1, 'EXP', '1');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (42, 'Código expediente', 4, 'expediente', 100, 'left', '1', 2, 'EXP', '1');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (43, 'Nombre', 19, 'nombreAsunto', 250, 'left', '1', 3, 'EXP', '0');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, TYPE)
 Values
   (44, 'Fecha de creación', 30, 'fechaCrear', 75, 'left', '1', 4, 'EXP', '0', 'fecha');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (45, 'Estado', 29, 'estadoAsunto', 100, 'left', '1', 5, 'EXP', '1');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (46, 'Gestor Interno', 3, 'gestorInterno', 200, 'left', '1', 6, 'EXP', '1');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (47, 'Supervisor', 21, 'supervisor', 200, 'left', '1', 7, 'EXP', '1');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, TYPE)
 Values
   (48, 'Saldo total', 5, 'saldoTotal', 50, 'left', '1', 8, 'EXP', '0', 'numero');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (49, 'Juzgado', 41, 'juzgado', 200, 'left', '1', 10, 'EXP', '0');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (50, 'Plaza', 43, 'plaza', 100, 'left', '1', 9, 'EXP', '0');


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (51, 'Estado', 44, 'estado', 100, 'left', '1', 11, 'EXP', '0');


COMMIT;

-- vistas 

DROP VIEW V_PC_CONT_ZON_ZONIFICACION;

/* Formatted on 2013/03/07 17:15 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW v_pc_cont_zon_zonificacion (niv_id,
                                                                zon_cod,
                                                                zon_id,
                                                                zon_descripcion
                                                               )
AS
   SELECT 301, '01' || car_id, car_id, car_descripcion
     FROM car_cartera
   UNION
   SELECT 302, '01' || car_id || lot_id, lot_id, lot_descripcion
     FROM lot_lote
   UNION
   SELECT 303, '01' || car_id || lot_id||dd_tpo_id, dd_tpo_id, dd_tpo_descripcion
     FROM lot_lote , dd_tpo_tipo_procedimiento where dd_tac_id=(select dd_tac_id from dd_tac_tipo_actuacion where dd_tac_codigo='LIN') 
   UNION
   SELECT 304, '01' || lot.car_id || lot.lot_id ||tpo.dd_tpo_id||tap.tap_id, tap.tap_id,
          tap.tap_descripcion
     FROM lot_lote lot,  dd_tpo_tipo_procedimiento tpo ,tap_tarea_procedimiento tap
    where tpo.dd_tpo_id=tap.dd_tpo_id and tpo.dd_tac_id=(select dd_tac_id from dd_tac_tipo_actuacion where dd_tac_codigo='LIN');
                            
                       

DROP VIEW V_PC_CONT_NIV_NIVELES;

/* Formatted on 2013/03/07 17:17 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW pc_contencioso_niv_niveles (niv_id,
                                                               niv_descripcion
                                                              )
AS
   SELECT 301,
           'CARTERA'
     FROM DUAL
    UNION 
        SELECT 302, 'LOTE'
        FROM DUAL
    UNION 
        SELECT 303,'PROCEDIMIENTO'
    FROM DUAL    
    UNION 
        SELECT 304,'TAREA'
    FROM DUAL;
    
    
DROP VIEW V_PC_CONT_NIV_NIVELES;

CREATE OR REPLACE FORCE VIEW v_pc_cont_niv_niveles (niv_id,
                                                          niv_descripcion
                                                         )
AS
   SELECT 301,
           'CARTERA'
    FROM DUAL
    UNION 
        SELECT 302, 'LOTE'
    FROM DUAL
    UNION 
        SELECT 303,'PROCEDIMIENTO'
    FROM DUAL
    UNION
    SELECT 304,'TAREA'
    FROM DUAL;


-- VISTAS MATERIALIZADAS

DROP MATERIALIZED VIEW V_PC_COT_EXP_TAR;

CREATE MATERIALIZED VIEW V_PC_COT_EXP_TAR 
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 2013/03/07 17:20 (Formatter Plus v4.8.8) */
SELECT '01' || lot.car_id || lot.lot_id ||tpo.dd_tpo_id|| tap.tap_id AS zon_cod,          --1
       gas.usu_username usu_username,                                      --2
          gas.usu_nombre
       || ' '
       || gas.usu_apellido1
       || ' '
       || gas.usu_apellido2 letrado,                                       --3
       asu.asu_id expediente,                                              --4
                             mov.mov_deuda_irregular saldo_expediente,     --5
       ' ' anyo,                                                           --6
                ' ' mes,                                                   --7
                        ' ' dia,                                           --8
                                tar.tar_id tar_id,                         --9
                                                  tar.tar_tarea tipo_tarea,
       --10
       tpo.dd_tpo_descripcion tipo_procedimiento,                         --11
                                                 tpo.dd_tpo_codigo cod_prod,
       --12
       ' ' tipo_solicitud,                                                --13
                          tar.tar_fecha_venc tar_fecha_venc,              --14
       tar.tar_fecha_venc tar_fecha_venc_real,                            --15
       tar.tar_descripcion descripcion_tarea,                             --16
                                             'Contencioso' tipo_gestion,  --17
       mov.mov_deuda_irregular vre,                                       --18
                                   asu.asu_nombre nombre_asunto,          --19
       gas.usu_username gestor_interno,                                   --20
                                       ' ' gestor_externo,                --21
                                                          ' ' despacho,   --22
       ' ' proveedor,                                                     --23
                     ' ' codigo,                                          --24
                                ' ' estado_procesal,                      --25
                                                    ' ' grupo_interno,    --26
       ' ' supervisor,                                                    --27
                      mov.mov_deuda_irregular saldo_total,                --28
       asu.dd_eas_id estado_asunto,                                       --29
                                   asu.fechacrear fecha_crear_asunto,     --30
       ' ' campaÑa,                                                       --31
                   TRUNC (SYSDATE) - TRUNC (tar.tar_fecha_venc) dias_vencida,   --32
       car.car_descripcion cartera,                                       --33
                                   lot.lot_descripcion lote,              --34
       tar.tar_tarea AS tarea, tap.tap_id tap_id,                         --35
       CASE
          WHEN TRUNC (tar.tar_fecha_venc) < TRUNC (SYSDATE)
             THEN 'TV'
          ELSE 'PM'
       END tipo,                                                          --36
       cnt.cnt_id                                                         --38
                 ,
       prc.prc_id                                                         --39
                 ,
       juz.dd_juz_codigo idjuzgado                                        --40
                                  ,
       juz.dd_juz_descripcion                                             --41
                             ,
       pla.dd_pla_codigo idplaza                                          --42
                                ,
       pla.dd_pla_descripcion                                             --43
                             ,
       eas.dd_eas_descripcion                                             --44
  FROM car_cartera car JOIN lot_lote lot ON car.car_id = lot.car_id
       JOIN cnt_contratos cnt ON cnt.lot_id = lot.lot_id
       JOIN cex_contratos_expediente cex ON cex.cnt_id = cnt.cnt_id
       JOIN prc_cex pc ON pc.cex_id = cex.cex_id
       JOIN prc_procedimientos prc ON prc.prc_id = pc.prc_id
       JOIN asu_asuntos asu ON asu.asu_id = prc.asu_id
       JOIN gaa_gestor_adicional_asunto gaa_gas
       ON gaa_gas.asu_id = asu.asu_id AND gaa_gas.dd_tge_id = 2
       JOIN usd_usuarios_despachos usd_gas ON usd_gas.usd_id = gaa_gas.usd_id
       JOIN linmaster.usu_usuarios gas ON gas.usu_id = usd_gas.usu_id
       JOIN tar_tareas_notificaciones tar
       ON tar.prc_id = prc.prc_id
     AND (tar.tar_tarea_finalizada = 0 OR tar.tar_tarea_finalizada IS NULL)
     AND tar.borrado = 0
       JOIN tex_tarea_externa tex ON tex.tar_id = tar.tar_id
       JOIN tap_tarea_procedimiento tap ON tap.tap_id = tex.tap_id
       JOIN dd_tpo_tipo_procedimiento tpo ON tpo.dd_tpo_id = tap.dd_tpo_id and tpo.dd_tac_id=(select dd_tac_id from dd_tac_tipo_actuacion where dd_tac_codigo='LIN' )
       JOIN mov_movimientos mov ON mov.cnt_id = cnt.cnt_id AND TRUNC (mov.mov_fecha_extraccion) =
                                  (SELECT TRUNC (MAX (mov_fecha_extraccion))
                                     FROM mov_movimientos)
       left JOIN dd_juz_juzgados_plaza juz ON juz.dd_juz_id = prc.dd_juz_id
       left JOIN dd_pla_plazas pla ON pla.dd_pla_id = juz.dd_pla_id
       JOIN linmaster.dd_eas_estado_asuntos eas
       ON asu.dd_eas_id = eas.dd_eas_id
     ;

COMMENT ON MATERIALIZED VIEW V_PC_COT_EXP_TAR IS 'snapshot table for snapshot V_PC_COT_EXP_TAR';


DROP MATERIALIZED VIEW V_PC_COT_EXP_TAR_RESUMEN;


CREATE MATERIALIZED VIEW V_PC_COT_EXP_TAR_RESUMEN 
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 2013/03/07 17:22 (Formatter Plus v4.8.8) */
SELECT DISTINCT usu_username usu_username, zon_cod zon_cod,                --1
                                                           letrado letrado,
                COUNT (expediente) expediente,                             --4
                SUM (saldo_expediente) saldo_expediente,                   --5
                                                        SUM (num_tv) num_tv,
                                                                           --6
                SUM (num_pm) num_pm,                                       --7
                                    SUM (num_ps) num_ps,                   --8
                                                        SUM (num_ph) num_ph,
                                                                           --9
                SUM (num_pmm) num_pmm,                                    --10
                                      SUM (num_pa) num_pa,                --11
                                                          SUM (num_fh) num_fh,
                                                                          --12
                SUM (num_fs) num_fs,                                      --14
                                    SUM (num_fm) num_fm,                  --15
                                                        SUM (num_fa) num_fa,
                                                                          --16
                SUM (num_tf) num_tf,                                      --17
                                    SUM (num_vs) num_vs, SUM (num_v1m)
                                                                      num_v1m,
                SUM (num_v2m) num_v2m, SUM (num_v3m) num_v3m,
                SUM (num_v4m) num_v4m, SUM (num_v5m) num_v5m,
                SUM (num_v6m) num_v6m, SUM (num_vm6m) num_vm6m,
                SUM (num_p2m) num_p2m, SUM (num_p3m) num_p3m,
                SUM (num_p4m) num_p4m, SUM (num_p5m) num_p5m,
                SUM (num_pm6) num_pm6
           FROM (SELECT DISTINCT usu_username usu_username, zon_cod zon_cod,
                                 letrado letrado, expediente,
                                 MAX (saldo_expediente) saldo_expediente,
                                 SUM (DECODE (tipo, 'VS', 1, 0)) num_vs,
                                 SUM (DECODE (tipo, 'V1M', 1, 0)) num_v1m,
                                 SUM (DECODE (tipo, 'V2M', 1, 0)) num_v2m,
                                 SUM (DECODE (tipo, 'V3M', 1, 0)) num_v3m,
                                 SUM (DECODE (tipo, 'V4M', 1, 0)) num_v4m,
                                 SUM (DECODE (tipo, 'V5M', 1, 0)) num_v5m,
                                 SUM (DECODE (tipo, 'V6M', 1, 0)) num_v6m,
                                 SUM (DECODE (tipo, 'VM6M', 1, 0)) num_vm6m,
                                 SUM (DECODE (tipo, 'TV', 1, 0)) num_tv,
                                 SUM (DECODE (tipo, 'PM', 1, 0)) num_pm,
                                 SUM (DECODE (tipo, 'P2M', 1, 0)) num_p2m,
                                 SUM (DECODE (tipo, 'P3M', 1, 0)) num_p3m,
                                 SUM (DECODE (tipo, 'P4M', 1, 0)) num_p4m,
                                 SUM (DECODE (tipo, 'P5M', 1, 0)) num_p5m,
                                 SUM (DECODE (tipo, 'PM6', 1, 0)) num_pm6,
                                 SUM (DECODE (tipo, 'PS', 1, 0)) num_ps,
                                 SUM (DECODE (tipo, 'PH', 1, 0)) num_ph,
                                 SUM (DECODE (tipo, 'PMM', 1, 0)) num_pmm,
                                 SUM (DECODE (tipo, 'PA', 1, 0)) num_pa,
                                 SUM (DECODE (tipo, 'FH', 1, 0)) num_fh,
                                 SUM (DECODE (tipo, 'FS', 1, 0)) num_fs,
                                 SUM (DECODE (tipo, 'FM', 1, 0)) num_fm,
                                 SUM (DECODE (tipo, 'FA', 1, 0)) num_fa,
                                 SUM (DECODE (tipo, 'TF', 1, 0)) num_tf
                            FROM v_pc_cot_exp_tar
                        GROUP BY usu_username, letrado, zon_cod, expediente)
       GROUP BY usu_username, letrado, zon_cod;

COMMENT ON MATERIALIZED VIEW V_PC_COT_EXP_TAR_RESUMEN IS 'snapshot table for snapshot V_PC_COT_EXP_TAR_RESUMEN';


