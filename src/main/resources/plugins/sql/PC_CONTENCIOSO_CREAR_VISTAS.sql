--
-- SCRIP PARA MONTAR EL PANEL DE CONTROL CONTENCIOSO PARA SCE
-- Autor: Bruno Anglés
-- Fecha última modificación: 26/03/2012 
--
--************************************************************
--*** table SCF_CAMPANYA_MAYOR45 *****************************
--************************************************************
CREATE TABLE SCF01.SCF_CAMPANYA_MAYOR45
(
  LAMINADA      NUMBER(1),
  CLAVEEXTERNA  VARCHAR2(50 CHAR),
  ZONA          VARCHAR2(50 CHAR),
  OPERACION     VARCHAR2(50 CHAR),
  FECHA_INSERT  TIMESTAMP(6)                    DEFAULT sysdate
)

--************************************************************
--*** view V_PC_CONT_NIV_NIVELES AS **************************
--************************************************************
drop view V_PC_CONT_NIV_NIVELES;

create view V_PC_CONT_NIV_NIVELES AS
select niv_id, 
    case niv_id
        when 303 then 'Asesoría'
        when 304 then 'Centro'
        else niv_descripcion
    end niv_descripcion 
from niv_nivel
union select 305,'Letrado/Gestor' from dual;

--************************************************************
--*** view V_PC_CONT_ZON_ZONIFICACION AS *********************
--************************************************************
drop view V_PC_CONT_ZON_ZONIFICACION;

create view V_PC_CONT_ZON_ZONIFICACION AS
select niv_id, zon_cod, zon_id, zon_descripcion
from zon_zonificacion
union select 301,'SZ',-1,'SIN ZONIFICAR' from dual
union select 302,'SZ01',-2,'SIN ZONIFICAR' from dual
union select 303,'SZ0101',-3,'SIN ZONIFICAR' from dual
union select 304,'SZ010101',-4,'SIN ZONIFICAR' from dual;

--************************************************************
--*** view V_PC_COT_EXP_TAR AS *******************************
--************************************************************
drop materialized view V_PC_COT_EXP_TAR;

create materialized view V_PC_COT_EXP_TAR AS
SELECT DISTINCT 
    NVL (zon.zon_cod, 'SZ010101') zon_cod                     -- 1
    ,gas.usu_username                                           --2
    ,vzon.zon_descripcion asesoria                             -- 3
    ,gas.usu_nombre || ' '|| gas.usu_apellido1|| ' ' || gas.usu_apellido2 letrado                               --4
    ,CASE
       WHEN (    tar.borrado = 0
             AND (   tar.tar_tarea_finalizada IS NULL
                  OR tar.tar_tarea_finalizada = 0
                 )
            )
          THEN 'Pendiente'
       ELSE 'Finalizada'
    END estado_tarea                                           --5
   ,CASE
       WHEN tar.tar_fecha_fin IS NULL
          THEN 'N/A'
       ELSE CASE
       WHEN TRUNC (tar.tar_fecha_fin) <=
                          TRUNC (tar.tar_fecha_venc)
          THEN 'SI'
       ELSE 'NO'
    END
    END fin_en_plazo                                           --6
    ,TO_DATE (TRUNC (SYSDATE)) - TO_DATE (TRUNC (tar.tar_fecha_venc)) dias_vencida       -- 7
    ,tar.tar_tarea tipo_tarea                                   --8
    ,prc.prc_saldo_recuperacion saldo_tarea                     --9
    ,CASE
       WHEN (    (cmay45.claveexterna IS NOT NULL)
             AND (tar.tar_fecha_fin IS NOT NULL)
             AND (tar.tar_fecha_ini > cmay45.fecha_insert)
            )
          THEN 'Mayor 45 DIAS'
       WHEN (    (cmay45.claveexterna IS NOT NULL)
             AND (tar.tar_fecha_fin IS NULL)
            )
          THEN 'Mayor 45 DIAS'
       WHEN tar.tar_tarea = 'Control de confeccion de expediente'
          THEN 'SIN PROCEDIMIENTO'
       WHEN tar.tar_tarea =
              'Introduzca acciones correctas para el estado procesal'
          THEN 'SIN ACCION'
       WHEN tar.tar_tarea = 'TAREA PARA INCONSISTENCIAS'
          THEN 'INCONSISTENCIAS'
       WHEN tar.usuariomodificar = '*EMBARGOS*'
          THEN 'EMBARGOS'
       ELSE 'NINGUNA'
    END campaña                                              -- 10
    ,NVL (asu.asu_codigo_exp, asu.asu_codigo) expediente      -- 11
    ,tar.tar_id                                                --12
    ,TO_CHAR (tar.tar_fecha_venc, 'yyyy') anyo                 --13
    ,TO_CHAR (tar.tar_fecha_venc, 'mm') mes                    --14
    ,TO_CHAR (tar.tar_fecha_venc, 'dd') dia                    --15
    ,asu.asu_id asu_id                                         --16
    ,asu.asu_nombre nombre_asunto                             -- 17
    ,trunc(asu.fechacrear) fecha_crear_asunto                        -- 18
    ,eas.dd_eas_descripcion estado_asunto                     -- 19
    ,gas.usu_nombre|| ' ' || gas.usu_apellido1|| ' '|| gas.usu_apellido2 gestor_interno                       --20
    ,sup.usu_nombre|| ' '|| sup.usu_apellido1|| ' '|| sup.usu_apellido2 supervisor                          -- 21
    ,prc.prc_saldo_recuperacion saldo_expediente               --22
    ,des_gas.des_despacho despacho                             --23
    ,asu.asu_nombre descripcion_tarea
    ,CASE prc.dd_tac_id
       WHEN 10000000000001
          THEN 'Presencial'
       ELSE 'Contencioso'
    END tipo_gestion
    ,TO_DATE (TRUNC (tar.tar_fecha_venc),'dd/mm/yy') tar_fecha_venc
    ,TO_DATE (TRUNC (tar.tar_fecha_venc),'dd/mm/yy') tar_fecha_venc_real
    ,' ' tipo_solicitud, prc.prc_saldo_recuperacion vre
    ,CASE
       WHEN (    tar.borrado = 0
             AND (   tar.tar_tarea_finalizada IS NULL
                  OR tar.tar_tarea_finalizada = 0
                 )
            )
          THEN CASE
                 WHEN trunc(tar.tar_fecha_venc) > TRUNC (SYSDATE + 365)
                    THEN 'PA'
                 WHEN trunc(tar.tar_fecha_venc) > TRUNC (SYSDATE + 30)
                    THEN 'PMM'
                 WHEN trunc(tar.tar_fecha_venc) > TRUNC (SYSDATE + 7)
                    THEN 'PM'
                 WHEN trunc(tar.tar_fecha_venc) > TRUNC (SYSDATE)
                    THEN 'PS'
                 WHEN trunc(tar.tar_fecha_venc) = TRUNC (SYSDATE)
                    THEN 'PH'
                 ELSE 'TV'
              END
       ELSE CASE
       WHEN TRUNC (tar_fecha_fin) = TRUNC (SYSDATE - 1)
          THEN 'FH'
       WHEN tar.tar_fecha_fin BETWEEN TRUNC (SYSDATE - 7)
                                  AND TRUNC (SYSDATE - 1)
          THEN 'FS'
       WHEN tar.tar_fecha_fin BETWEEN TRUNC (SYSDATE - 30)
                                  AND TRUNC (SYSDATE - 1)
          THEN 'FM'
       WHEN tar.tar_fecha_fin BETWEEN TRUNC (SYSDATE - 365)
                                  AND TRUNC (SYSDATE - 1)
          THEN 'FA'
       ELSE 'TF'
    END
    END tipo
    ,tar.tar_tarea, ' ' grupo_interno
    ,prc.prc_saldo_recuperacion saldo_total
    ,usu.usu_nombre|| ' '|| usu.usu_apellido1|| ' ' || usu.usu_apellido2 gestor_externo
    ,'Reintegra' proveedor, asu.estado_procesal estado_procesal
    ,CASE
       WHEN tpo.dd_tac_id IN (8, 2)
          THEN tpo_padre.dd_tpo_descripcion
       ELSE tpo.dd_tpo_descripcion
    END tipo_procedimiento
    ,CASE
       WHEN tpo.dd_tac_id IN (8, 2)
          THEN tpo_padre.dd_tpo_codigo
       ELSE tpo.dd_tpo_codigo
    END cod_prod,
    CASE
       WHEN tpo.dd_tac_id IN (8, 2)
          THEN tpo.dd_tpo_descripcion
       ELSE ' '
    END tramite,
	CASE
       WHEN tpo.dd_tac_id IN (8, 2)
          THEN tac_padre.dd_tac_descripcion
       ELSE tac.dd_tac_descripcion
    END tipo_actuacion
    ,epc.epc_descripcion ultima_accion_rx
    ,epc.epc_codigo ultima_accion_rx_cod
    ,TO_DATE (TRUNC (procesable.acj_fechaaccion),'dd/mm/yy') fecha_accion
    ,TO_DATE (TRUNC (tar.tar_fecha_ini), 'dd/mm/yy') tar_fecha_ini
    ,prc.prc_id prc_id, tar.tar_alerta tarea_alertada
    ,asu.asu_codigo
    ,tap.tap_id
    ,tte.DD_TTE_DESCRIPCION TIPOTAREA
    ,tar.SCF_PRC_CONGELADO
    ,asu.gas_id
    ,tar.tar_tarea_finalizada
    ,to_date(trunc (tar.tar_fecha_fin),'dd/mm/yy') tar_fecha_fin
    ,o.situacion situacion	
   FROM tar_tareas_notificaciones tar JOIN asu_asuntos asu
        ON tar.asu_id = asu.asu_id                
        inner join tex_tarea_externa tex on tex.tar_id = tar.tar_id
        inner join tap_tarea_procedimiento tap on tap.tap_id =  tex.TAP_ID and tap.BORRADO=0
        left join dd_tte_tipo_tarea_externa tte on tte.DD_TTE_ID = tap.DD_TTE_ID and tte.BORRADO=0                                                
        JOIN sormaster.dd_eas_estado_asuntos eas
        ON asu.dd_eas_id = eas.dd_eas_id and eas.dd_eas_id not in (5,6)
        JOIN prc_procedimientos prc ON tar.prc_id = prc.prc_id
        JOIN usd_usuarios_despachos usd ON asu.san_gex_id = usd.usd_id
        JOIN des_despacho_externo des ON usd.des_id = des.des_id
        JOIN usd_usuarios_despachos usd_sup
        ON asu.sup_id = usd_sup.usd_id
        JOIN des_despacho_externo des_sup
        ON usd_sup.des_id = des_sup.des_id
        JOIN usd_usuarios_despachos usd_gas
        ON asu.gas_id = usd_gas.usd_id
        JOIN des_despacho_externo des_gas
        ON usd_gas.des_id = des_gas.des_id
        -- Quitamos los perfiles de DIRECTOR ZONA
        LEFT JOIN zon_pef_usu zpu
        ON usd_gas.usu_id = zpu.usu_id
      AND zpu.borrado = 0
      AND zpu.pef_id NOT IN (10000000000200, 10000000000203)
        LEFT JOIN zon_zonificacion zon ON zpu.zon_id = zon.zon_id
        LEFT JOIN v_pc_cont_zon_zonificacion vzon
        ON zon.zon_id = vzon.zon_id
        JOIN sormaster.usu_usuarios usu ON usd.usu_id = usu.usu_id
        JOIN sormaster.usu_usuarios sup ON usd_sup.usu_id = sup.usu_id
        JOIN sormaster.usu_usuarios gas ON usd_gas.usu_id = gas.usu_id
        --join tmp_expedientes_scf tmp on asu.asu_codigo = tmp.idexpediente
        --join tmp_scf_asesorias_implantadas scf on tmp.centro = scf.codigo
        LEFT JOIN prc_procedimientos padre ON prc.prc_prc_id = padre.prc_id
        LEFT JOIN dd_tpo_tipo_procedimiento tpo_padre  ON padre.dd_tpo_id = tpo_padre.dd_tpo_id
        LEFT JOIN dd_tpo_tipo_procedimiento tpo ON prc.dd_tpo_id = tpo.dd_tpo_id
		left join dd_tac_tipo_actuacion tac on tac.dd_tac_id=tpo.dd_tac_id
		left join dd_tac_tipo_actuacion tac_padre on tac_padre.dd_tac_id=tpo_padre.dd_tac_id
        LEFT JOIN scf_campanya_mayor45 cmay45 ON asu.asu_codigo_exp = cmay45.claveexterna
        LEFT JOIN
        (SELECT   MAX (acj_accion) accion, acj_expediente_ext
             FROM sidhi_dat_acj_acciones
            WHERE acj_accion IS NOT NULL
              AND epc_id NOT IN (106, 107)
              AND acj_accion != 1
              AND acj_fechaborrado IS NULL
              AND epc_id IN (SELECT epc_id
                               FROM sidhi_eng_hee_he)
         GROUP BY acj_expediente_ext) acj
            ON asu.asu_codigo = acj.acj_expediente_ext
        LEFT JOIN sidhi_dat_acj_acciones procesable ON procesable.acj_accion = acj.accion
        LEFT JOIN sidhi_dat_epc_estado_proces epc ON epc.epc_id = procesable.epc_id
	left join oni_operaciones_no_impulso o on o.asu_id=asu.asu_id                
  WHERE (   usu.usu_username IS NULL
         OR usu.usu_username NOT IN (SELECT username
                                       FROM tmp_scf_letrados_residuales
                                      WHERE username IS NOT NULL)
        )
    --and (tmp.idprocedimiento is null or tmp.idprocedimiento not in (9,14,16,17,18,19,23))
    --and tmp.fechabaja is null and tmp.estado != 'F' and tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0)
    --and tar.borrado = 0 and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0)
    AND usu.usu_nombre not in ('Gestor-dummy', 'RED-GESFI')
    and (
        (NVL (zon.zon_cod, 'SZ010101') like '0103%' and prc.dd_tac_id=10000000000001) -- Zona de presencial
        or (NVL (zon.zon_cod, 'SZ010101') not like '0103%' and prc.dd_tac_id!=10000000000001) -- Zonas de Contencioso 
    )
    AND (
        (NVL (tar.scf_prc_congelado, 0) =NVL (asu.scf_prc_congelado, 0) and (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada=0))
        or
        (tar.tar_tarea_finalizada=1)
        );

    
    
ALTER TABLE SCF01.V_PC_COT_EXP_TAR
MODIFY(ESTADO_TAREA VARCHAR2(50 CHAR));
    
--************************************************************
--*** view V_PC_COT_EXP_TAR_RESUMEN AS ***********************
--************************************************************
drop MATERIALIZED VIEW V_PC_COT_EXP_TAR_RESUMEN;


CREATE MATERIALIZED VIEW V_PC_COT_EXP_TAR_RESUMEN AS
SELECT DISTINCT
USU_USERNAME USU_USERNAME,
ZON_COD ZON_COD,
LETRADO LETRADO,
COUNT(EXPEDIENTE) EXPEDIENTE,
SUM (SALDO_EXPEDIENTE) SALDO_EXPEDIENTE,
SUM(NUM_TV) NUM_TV,
SUM(NUM_PM) NUM_PM,
SUM(NUM_PS) NUM_PS,
SUM(NUM_PH) NUM_PH,
SUM(NUM_PMM) NUM_PMM,
SUM(NUM_PA) NUM_PA,
SUM(NUM_FH) NUM_FH,
SUM(NUM_FS) NUM_FS,
SUM(NUM_FM) NUM_FM,
SUM(NUM_FA) NUM_FA,
SUM(NUM_TF) NUM_TF
FROM(
                SELECT DISTINCT
                USU_USERNAME USU_USERNAME,
                ZON_COD ZON_COD,
                LETRADO LETRADO,
                EXPEDIENTE,
                MAX (SALDO_EXPEDIENTE) SALDO_EXPEDIENTE,
                SUM(DECODE(TIPO,'TV',1,0)) NUM_TV,
                SUM(DECODE(TIPO,'PM',1,0)) NUM_PM,
                SUM(DECODE(TIPO,'PS',1,0)) NUM_PS,
                SUM(DECODE(TIPO,'PH',1,0)) NUM_PH,
                SUM(DECODE(TIPO,'PMM',1,0)) NUM_PMM,
                SUM(DECODE(TIPO,'PA',1,0)) NUM_PA,
                SUM(DECODE(TIPO,'FH',1,0)) NUM_FH,
                SUM(DECODE(TIPO,'FS',1,0)) NUM_FS,
                SUM(DECODE(TIPO,'FM',1,0)) NUM_FM,
                SUM(DECODE(TIPO,'FA',1,0)) NUM_FA,
                SUM(DECODE(TIPO,'TF',1,0)) NUM_TF
                FROM
                V_PC_COT_EXP_TAR
                GROUP BY
                USU_USERNAME,LETRADO,ZON_COD, EXPEDIENTE
)
GROUP BY USU_USERNAME,LETRADO,ZON_COD;

--************************************************************
--*** CONFIGURAR LAS COLUMNAS PARA DETALLE *******************
--************************************************************

drop table PC_COT_COLUMNS_EXP_TAR;

CREATE TABLE PC_COT_COLUMNS_EXP_TAR
(
  COL_ID      NUMBER                            NOT NULL,
  HEADER      VARCHAR2(200 BYTE),
  COL_INDEX   NUMBER(16),
  DATAINDEX   VARCHAR2(200 BYTE),
  WIDTH       INTEGER,
  ALIGN       VARCHAR2(200 BYTE),
  SORTABLE    CHAR(1 BYTE)                      DEFAULT 1,
  ORDEN       INTEGER,
  FORMULARIO  VARCHAR2(50 BYTE),
  HIDDEN      CHAR(1 BYTE)                      DEFAULT 1,
  TYPE        VARCHAR2(10 BYTE)
);

--select * from V_PC_COT_EXP_TAR;

--
-- Detalle de Tareas
--
insert into PC_COT_COLUMNS_EXP_TAR values
(1,'Asesoría',3, 'asesoria','150','left','1',1,'TAR','0','');

insert into PC_COT_COLUMNS_EXP_TAR values
(2,'Letrado',4, 'letrado','200','left','1',2,'TAR','0','');

insert into PC_COT_COLUMNS_EXP_TAR values
(3,'Estado',5, 'estado','50','left','1',3,'TAR','0','');

insert into PC_COT_COLUMNS_EXP_TAR values
(4,'En plazo',6, 'enPlazo','50','left','1',4,'TAR','1','');

insert into PC_COT_COLUMNS_EXP_TAR values
(5,'Días vencida',7, 'diasVencida','50','right','1',5,'TAR','0','');

insert into PC_COT_COLUMNS_EXP_TAR values
(6,'Tarea',8, 'tarea','200','left','1',8,'TAR','0','');

insert into PC_COT_COLUMNS_EXP_TAR values
(7,'Saldo',9, 'saldo','50','left','1',7,'TAR','0','numero');

insert into PC_COT_COLUMNS_EXP_TAR values
(8,'Campaña',10, 'camp','100','left','1',8,'TAR','0','');

insert into PC_COT_COLUMNS_EXP_TAR values
(9,'Expediente',11, 'expediente','50','left','1',9,'TAR','0','');

insert into PC_COT_COLUMNS_EXP_TAR values
(10,'Id Tarea',12, 'tar_id','100','left','1',10,'TAR','0','');

--
-- Expedientes
--
insert into PC_COT_COLUMNS_EXP_TAR values
(11,'id',16, 'idasunto','100','left','1',1,'EXP','1','');

insert into PC_COT_COLUMNS_EXP_TAR values
(12,'Código expediente',11,'expediente','100','left','1',2,'EXP','0','');

insert into PC_COT_COLUMNS_EXP_TAR values
(13,'Nombre',17, 'nombreAsunto','200','left','1',3,'EXP','0','');

insert into PC_COT_COLUMNS_EXP_TAR values
(14,'Fecha de creación',18, 'fechaCrear','100','left','1',4,'EXP','0','fecha');

insert into PC_COT_COLUMNS_EXP_TAR values
(15,'Estado',19, 'estadoAsunto','100','left','1',5,'EXP','0','');

insert into PC_COT_COLUMNS_EXP_TAR values
(16,'Gestor Interno',20, 'gestorInterno','200','left','1',6,'EXP','1','');

insert into PC_COT_COLUMNS_EXP_TAR values
(17,'Supervisor',21, 'supervisor','200','left','1',7,'EXP','1','');

insert into PC_COT_COLUMNS_EXP_TAR values
(18,'Saldo total',22, 'saldoTotal','200','left','1',8,'EXP','0','numero');

insert into PC_COT_COLUMNS_EXP_TAR values
(19,'Despacho',23, 'despacho','200','left','1',9,'EXP','0','');

commit;
    
   
--************************************************************
--'*** alter view V_PC_COT_EXP_TAR AS ************************
--'*********************************************************** 
-- Necesario para modificar el tipo de gestión de char a varCahr sino
-- en el grid solo muestra el primer carácter C y no todo el literal Contencioso

ALTER TABLE SCF01.V_PC_COT_EXP_TAR
MODIFY(TIPO_GESTION VARCHAR2(11 BYTE));

