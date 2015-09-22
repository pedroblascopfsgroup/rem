/**
 * Trámite: T. CERTIFICADO DE CARGAS Y REVISIÓN
 * Resolución: Requerir información que falta
 * Tareas: P08_RequerirMasInfo 
 **/

-- Insertamos en la tabla dd_tr_tipos_resolucion el tipo de resolución
INSERT INTO dd_tr_tipos_resolucion
            (dd_tr_id, dd_tr_codigo, dd_tr_descripcion, dd_tr_descripcion_larga, dd_tj_id, VERSION, usuariocrear, fechacrear, borrado, dd_tr_ayuda, bpm_dd_tac_id)
   SELECT '285', 'R_SOL_INF_CANT', 'Escrito sellado solicitando más información cargas anteriores','Escrito sellado solicitando más información cargas anteriores',(SELECT dd_tj_id FROM dd_tj_tipo_juicio WHERE dd_tj_codigo = 'CCR')
          , '0','MOD_PROC', SYSDATE, '0', 'Ayuda Escrito sellado solicitando más información cargas anteriores.', (SELECT bpm_dd_tac_id FROM bpm_dd_tac_tipo_accion WHERE bpm_dd_tac_codigo = 'ADVANCE')
     FROM DUAL;

-- Insertamos en la tabla BPM_DD_TIN_TIPO_INPUTS el tipo de input
Insert into BPM_DD_TIN_TIPO_INPUT (BPM_DD_TIN_ID,BPM_DD_TIN_CODIGO,BPM_DD_TIN_DESCRIPCION,
BPM_DD_TIN_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR, BORRADO,BPM_DD_TIN_CLASE) 
SELECT S_BPM_DD_TIN_TIPO_INPUT.nextVal,'I_SOL_INF_CANT','Input escrito sellado solicitando más información cargas anteriores',
'Input escrito sellado solicitando más información cargas anteriores.', 0, 'MOD_PROC', sysdate, '0',null from dual;

-- Insertamos en BPM_TPI_TIPO_PROC_INPUT para crear la relación entre inputs y los nodos del procedimiento
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, 
BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, 
FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P08'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='I_SOL_INF_CANT'),'P08_RequerirMasInfo', 'NONE', 0, 'MOD_PROC', 
SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),null,null);

--Insertamos en la Tabla BPM_IDT_INPUTS_DATOS: los campos del formulario(los de la tarea) más los obligatorios (idAsunto, d_numAutos).
Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_SOL_INF_CANT') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P08');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_SOL_INF_CANT') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P08');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecha', 'generico', 'fecha', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_SOL_INF_CANT') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P08');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_SOL_INF_CANT') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P08');




