/**
 * Trámite: T. EMBARGO DE SALARIOS
 * Resolución: Confirmar retenciones
 * Tareas: H038_ConfirmarRetenciones 
 **/

-- Insertamos en la tabla dd_tr_tipos_resolucion el tipo de resolución
INSERT INTO dd_tr_tipos_resolucion
            (dd_tr_id, dd_tr_codigo, dd_tr_descripcion, dd_tr_descripcion_larga, dd_tj_id, VERSION, usuariocrear, fechacrear, borrado, dd_tr_ayuda, bpm_dd_tac_id)
   SELECT '294', 'R_ACU_ENT_CNT', 'DO Acuerda entrega cantidades retenidas','DO Acuerda entrega cantidades retenidas',(SELECT dd_tj_id FROM dd_tj_tipo_juicio WHERE dd_tj_codigo = 'EMS')
          , '0','MOD_PROC', SYSDATE, '0', 'Ayuda DO Acuerda entrega cantidades retenidas.', (SELECT bpm_dd_tac_id FROM bpm_dd_tac_tipo_accion WHERE bpm_dd_tac_codigo = 'ADVANCE')
     FROM DUAL;

-- Insertamos en la tabla BPM_DD_TIN_TIPO_INPUTS el tipo de input
Insert into BPM_DD_TIN_TIPO_INPUT (BPM_DD_TIN_ID,BPM_DD_TIN_CODIGO,BPM_DD_TIN_DESCRIPCION,
BPM_DD_TIN_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR, BORRADO,BPM_DD_TIN_CLASE) 
SELECT S_BPM_DD_TIN_TIPO_INPUT.nextVal,'I_ACU_ENT_CNT','Input DO Acuerda entrega cantidades retenidas',
'Input DO Acuerda entrega cantidades retenidas.', 0, 'MOD_PROC', sysdate, '0',null from dual;

-- Insertamos en BPM_TPI_TIPO_PROC_INPUT para crear la relación entre inputs y los nodos del procedimiento
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, 
BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, 
FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='H038'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='I_ACU_ENT_CNT'),'H038_ConfirmarRetenciones', 'NONE', 0, 'MOD_PROC', 
SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),null,null);

--Insertamos en la Tabla BPM_IDT_INPUTS_DATOS: los campos del formulario(los de la tarea) más los obligatorios (idAsunto, d_numAutos).
Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_ACU_ENT_CNT') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='H038');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_ACU_ENT_CNT') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='H038');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecha', 'generico', 'fecha', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_ACU_ENT_CNT') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='H038');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_comboCorr', 'generico', 'comboCorr', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_ACU_ENT_CNT') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='H038');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_ACU_ENT_CNT') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='H038');




