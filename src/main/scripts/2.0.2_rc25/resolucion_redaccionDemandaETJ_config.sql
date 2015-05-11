Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (92, 'REDACC_DEM', 'Redacción demanda', 'Redacción demanda', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 92', 2);

Insert into BPM_DD_TIN_TIPO_INPUT
   (BPM_DD_TIN_ID, BPM_DD_TIN_CODIGO, BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TIN_TIPO_INPUT.nextval, 'REDACC_DEM', 'Redacción demanda', 'Redacción demanda', 0, 'DIANA', sysdate, 0);
 
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P72'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='REDACC_DEM'),'P72_RedaccionDemanda', 'NONE', 0, 'MASIVO', SYSDATE, 0,
(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),null,'avanzaBPM');
   

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'REDACC_DEM%') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P72');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'REDACC_DEM%') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P72');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'REDACC_DEM%') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P72');
 
Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRedaccDemand', 'generico', 'fecRedaccDemand', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'REDACC_DEM%') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P72');

-- y para el etnj

Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P76'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='REDACC_DEM'),'P76_RedaccionDemanda', 'NONE', 0, 'MASIVO', SYSDATE, 0,
(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),null,'avanzaBPM');
   

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'REDACC_DEM%') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P76');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'REDACC_DEM%') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P76');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'REDACC_DEM%') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P76');
 
Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRedaccDemand', 'generico', 'fecRedaccDemand', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'REDACC_DEM%') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P76');

