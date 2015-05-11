--************************************************************
--*** tabla V_PC_CONT_ZON_ZONIFICACION   *********************
--************************************************************
drop table PC_COT_COLUMNS_EXP_TAR;

CREATE TABLE SCF01.PC_COT_COLUMNS_EXP_TAR
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
)

select * from V_PC_COT_EXP_TAR 

SELECT * FROM PC_COT_COLUMNS_EXP_TAR;

-- TAREAS
insert into PC_COT_COLUMNS_EXP_TAR values
(1,'id',9, 'TAR_ID','200','center','1',1,'TAR','0','')

insert into PC_COT_COLUMNS_EXP_TAR values
(2,'Tipo',10, 'TIPO_TAREA','500','center','1',2,'TAR','0','')

insert into PC_COT_COLUMNS_EXP_TAR values
(3,'Tarea',11, 'DESCRIPCION_TAREA','500','center','1',3,'TAR','1','')

insert into PC_COT_COLUMNS_EXP_TAR values
(4,'Gestión',12, 'TIPO_GESTION','200','center','1',4,'TAR','1','')

insert into PC_COT_COLUMNS_EXP_TAR values
(5,'Fecha Vto.',13, 'TAR_FECHA_VENC','200','left','1',5,'TAR','1','fecha')

insert into PC_COT_COLUMNS_EXP_TAR values
(6,'Fecha Vto. original',14, 'TAR_FECHA_VENC_REAL','200','left','1',6,'TAR','1','fecha')

insert into PC_COT_COLUMNS_EXP_TAR values
(7,'Tipo solicitud',16, 'TIPO_SOLICITUD','200','left','1',7,'TAR','1','')

insert into PC_COT_COLUMNS_EXP_TAR values
(8,'Días vencida',15, 'DIAS_VENCIDA','200','left','1',8,'TAR','1','')

insert into PC_COT_COLUMNS_EXP_TAR values
(9,'VRE',17, 'VRE','200','left','1',9,'TAR','1','numero')

-- EXPEDIENTES
insert into PC_COT_COLUMNS_EXP_TAR values
(10,'id',9, 'TAR_ID','200','center','1',1,'EXP','0','')

insert into PC_COT_COLUMNS_EXP_TAR values
(11,'Código expediente',1, 'ZON_COD','200','center','1',2,'EXP','1','')

insert into PC_COT_COLUMNS_EXP_TAR values
(12,'Nombre',20, 'NOMBRE_ASUNTO','200','center','1',3,'EXP','1','')

insert into PC_COT_COLUMNS_EXP_TAR values
(13,'Fecha de creación',21, 'FECHA_CREAR_ASUNTO','200','center','1',4,'EXP','1','fecha')

insert into PC_COT_COLUMNS_EXP_TAR values
(14,'Estado',22, 'ESTADO_ASUNTO','200','center','1',5,'EXP','1','')

insert into PC_COT_COLUMNS_EXP_TAR values
(15,'Gestor Interno',23, 'GESTOR_INTERNO','200','center','1',6,'EXP','1','')

insert into PC_COT_COLUMNS_EXP_TAR values
(16,'Supervisor',25, 'SUPERVISOR','200','center','1',7,'EXP','1','')

insert into PC_COT_COLUMNS_EXP_TAR values
(17,'Saldo total',26, 'SALDO_TOTAL','200','center','1',8,'EXP','1','numero')

insert into PC_COT_COLUMNS_EXP_TAR values
(18,'Despacho',28, 'DESPACHO','200','center','1',9,'EXP','1','')

insert into PC_COT_COLUMNS_EXP_TAR values
(19,'Código',30, 'CODIGO','200','center','1',10,'EXP','1','')
 


