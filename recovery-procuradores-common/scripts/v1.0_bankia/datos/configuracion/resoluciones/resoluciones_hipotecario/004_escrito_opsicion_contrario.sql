/**
 * Trámite: Procedimiento Hipotecario.
 * Resolución: Escrito de Oposición del Contrario.
 * Tareas: P01_ConfirmarSiExisteOposicion
 **/


INSERT INTO dd_tr_tipos_resolucion
            (dd_tr_id, dd_tr_codigo, dd_tr_descripcion, dd_tr_descripcion_larga, dd_tj_id, VERSION, usuariocrear, fechacrear, borrado, dd_tr_ayuda, bpm_dd_tac_id)
   SELECT '208', 'R_PR_HIP_ESCR_OPOS_CONTR', 'Escrito de oposición de contrario', 'Escrito de oposición de contrario', (SELECT dd_tj_id FROM dd_tj_tipo_juicio WHERE dd_tj_codigo = 'HIP')
          , '0','MOD_PROC', SYSDATE, '0', 'Ayuda de escrito de oposición de contrario.', (SELECT bpm_dd_tac_id FROM bpm_dd_tac_tipo_accion WHERE bpm_dd_tac_codigo = 'ADVANCE')
     FROM DUAL;    

-- Insertamos en la tabla BPM_DD_TIN_TIPO_INPUTS el tipo de input
Insert into BPM_DD_TIN_TIPO_INPUT (BPM_DD_TIN_ID,BPM_DD_TIN_CODIGO,BPM_DD_TIN_DESCRIPCION,
BPM_DD_TIN_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR, BORRADO,BPM_DD_TIN_CLASE) 
SELECT S_BPM_DD_TIN_TIPO_INPUT.nextVal,'I_PR_HIP_ESCR_OPOS_CONTR','Input Escrito de oposición de contrario',
'Input Escrito de oposición de contrario', 0, 'MOD_PROC', sysdate, '0',null from dual;

-- Insertamos en BPM_TPI_TIPO_PROC_INPUT para crear la relación entre inputs y los nodos del procedimiento
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, 
BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, 
FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P01'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='I_PR_HIP_ESCR_OPOS_CONTR'),'P01_ConfirmarSiExisteOposicion', 'NONE', 0, 'MOD_PROC', 
SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),null,null);


--Insertamos en la Tabla BPM_IDT_INPUTS_DATOS: los campos del formulario(los de la tarea) más los obligatorios (idAsunto, d_numAutos).

-- FAVORABLE --
Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_ESCR_OPOS_CONTR') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_ESCR_OPOS_CONTR') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_comboResultado', 'generico', 'comboResultado', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_ESCR_OPOS_CONTR') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fechaComparecencia', 'generico', 'fechaComparecencia', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_ESCR_OPOS_CONTR') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_ESCR_OPOS_CONTR') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fechaOposicion', 'generico', 'fechaOposicion', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_ESCR_OPOS_CONTR') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');


/* Aquí está hecho con dos input. (Si se opone y si no se opone)
-- Insertamos en la tabla dd_tr_tipos_resolucion el tipo de resolución.
INSERT INTO dd_tr_tipos_resolucion
            (dd_tr_id, dd_tr_codigo, dd_tr_descripcion, dd_tr_descripcion_larga, dd_tj_id, VERSION, usuariocrear, fechacrear, borrado, dd_tr_ayuda, bpm_dd_tac_id)
   SELECT '206', 'R_PR_HIP_CONF_EXI_FAV', 'Confirmar si existe oposición Favorable', 'Confirmar si existe oposición Favorable', (SELECT dd_tj_id FROM dd_tj_tipo_juicio WHERE dd_tj_codigo = 'HIP')
          , '0','MOD_PROC', SYSDATE, '0', 'Ayuda de Confirmar si existe oposición Favorable.', (SELECT bpm_dd_tac_id FROM bpm_dd_tac_tipo_accion WHERE bpm_dd_tac_codigo = 'ADVANCE')
     FROM DUAL;
     
INSERT INTO dd_tr_tipos_resolucion
            (dd_tr_id, dd_tr_codigo, dd_tr_descripcion, dd_tr_descripcion_larga, dd_tj_id, VERSION, usuariocrear, fechacrear, borrado, dd_tr_ayuda, bpm_dd_tac_id)
   SELECT '207', 'R_PR_HIP_CONF_EXI_DESF', 'Confirmar si existe oposición Desfavorable', 'Confirmar si existe oposición Desfavorable', (SELECT dd_tj_id FROM dd_tj_tipo_juicio WHERE dd_tj_codigo = 'HIP')
          , '0','MOD_PROC', SYSDATE, '0', 'Ayuda de Confirmar si existe oposición Desfavorable.', (SELECT bpm_dd_tac_id FROM bpm_dd_tac_tipo_accion WHERE bpm_dd_tac_codigo = 'ADVANCE')
     FROM DUAL;     

-- Insertamos en la tabla BPM_DD_TIN_TIPO_INPUTS el tipo de input
Insert into BPM_DD_TIN_TIPO_INPUT (BPM_DD_TIN_ID,BPM_DD_TIN_CODIGO,BPM_DD_TIN_DESCRIPCION,
BPM_DD_TIN_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR, BORRADO,BPM_DD_TIN_CLASE) 
SELECT S_BPM_DD_TIN_TIPO_INPUT.nextVal,'I_PR_HIP_CONF_EXI_FAV','Input Confirmar si existe oposición Favorable',
'Input Confirmar si existe oposición favorable', 0, 'MOD_PROC', sysdate, '0',null from dual;

Insert into BPM_DD_TIN_TIPO_INPUT (BPM_DD_TIN_ID,BPM_DD_TIN_CODIGO,BPM_DD_TIN_DESCRIPCION,
BPM_DD_TIN_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR, BORRADO,BPM_DD_TIN_CLASE) 
SELECT S_BPM_DD_TIN_TIPO_INPUT.nextVal,'I_PR_HIP_CONF_EXI_DESF','Input Confirmar si existe oposición Desfavorable',
'Input Confirmar si existe oposición Desfavorable', 0, 'MOD_PROC', sysdate, '0',null from dual;

-- Insertamos en BPM_TPI_TIPO_PROC_INPUT para crear la relación entre inputs y los nodos del procedimiento
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, 
BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, 
FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P01'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='I_PR_HIP_CONF_EXI_FAV'),'P01_ConfirmarSiExisteOposicion', 'NONE', 0, 'MOD_PROC', 
SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),null,null);

Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, 
BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, 
FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P01'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='I_PR_HIP_CONF_EXI_DESF'),'P01_ConfirmarSiExisteOposicion', 'NONE', 0, 'MOD_PROC', 
SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),null,null);

--Insertamos en la Tabla BPM_IDT_INPUTS_DATOS: los campos del formulario(los de la tarea) más los obligatorios (idAsunto, d_numAutos).

-- FAVORABLE --
Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_CONF_EXI_FAV') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_CONF_EXI_FAV') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_comboResultado', 'generico', 'comboResultado', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_CONF_EXI_FAV') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fechaComparecencia', 'generico', 'fechaComparecencia', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_CONF_EXI_FAV') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_CONF_EXI_FAV') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fechaOposicion', 'generico', 'fechaOposicion', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_CONF_EXI_FAV') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');



-- DESFAVORABLE --

-- FAVORABLE --
Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_CONF_EXI_DESF') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_CONF_EXI_DESF') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_comboResultado', 'generico', 'comboResultado', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_CONF_EXI_DESF') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fechaComparecencia', 'generico', 'fechaComparecencia', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_CONF_EXI_DESF') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_CONF_EXI_DESF') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fechaOposicion', 'generico', 'fechaOposicion', 0, 'MOD_PROC', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id = (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='I_PR_HIP_CONF_EXI_DESF') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P01');


*/