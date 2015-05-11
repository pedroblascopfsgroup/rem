Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (93, 'ACU_EXTRAJUD', 'Acuerdo Extrajudicial', 'Acuerdo Extrajudicial', 1, 0, 'MANUEL', sysdate, 0, 
   'Indíquese la <b>fecha de comunicación</b> del acuerdo extrajudicial por parte de la oficina de Gestión Extrajudicial o la de presentación en el juzgado del escrito de homologación del acuerdo.<br/>En el campo <b>observaciones</b> consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.', 2);

Insert into BPM_DD_TIN_TIPO_INPUT
   (BPM_DD_TIN_ID, BPM_DD_TIN_CODIGO, BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TIN_TIPO_INPUT.nextval, 'ACU_EXTRAJUD', 'Acuerdo Extrajudicial', 'Acuerdo Extrajudicial', 0, 'MANUEL', sysdate, 0);
   
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P70'), (SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='ACU_EXTRAJUD'),'ALL', 'NONE', 0, 'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='FORWARD'),null,'paralizarTareas');
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P72'), (SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='ACU_EXTRAJUD'),'ALL', 'NONE', 0, 'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='FORWARD'),null,'paralizarTareas');
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P73'), (SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='ACU_EXTRAJUD'),'ALL', 'NONE', 0, 'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='FORWARD'),null,'paralizarTareas');
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P75'), (SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='ACU_EXTRAJUD'),'ALL', 'NONE', 0, 'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='FORWARD'),null,'paralizarTareas');
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P76'), (SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='ACU_EXTRAJUD'),'ALL', 'NONE', 0, 'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='FORWARD'),null,'paralizarTareas');
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P77'), (SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='ACU_EXTRAJUD'),'ALL', 'NONE', 0, 'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='FORWARD'),null,'paralizarTareas');
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P78'), (SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='ACU_EXTRAJUD'),'ALL', 'NONE', 0, 'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='FORWARD'),null,'paralizarTareas');
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P79'), (SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='ACU_EXTRAJUD'),'ALL', 'NONE', 0, 'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='FORWARD'),null,'paralizarTareas');
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P80'), (SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='ACU_EXTRAJUD'),'ALL', 'NONE', 0, 'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='FORWARD'),null,'paralizarTareas');
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P81'), (SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='ACU_EXTRAJUD'),'ALL', 'NONE', 0, 'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='FORWARD'),null,'paralizarTareas');
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P83'), (SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='ACU_EXTRAJUD'),'ALL', 'NONE', 0, 'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='FORWARD'),null,'paralizarTareas');

-- P70

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P70');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P70');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P70');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepAcuExtrajud', 'generico', 'fecRecepAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P70');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_nombreDemandadoExtrajud', 'generico', 'nombreDemandadoExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P70');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_motivoAcuExtrajud', 'generico', 'motivoAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P70');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecPresenAcuExtrajud', 'generico', 'fecPresenAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P70');

-- P72

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P72');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P72');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P72');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepAcuExtrajud', 'generico', 'fecRecepAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P72');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_nombreDemandadoExtrajud', 'generico', 'nombreDemandadoExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P72');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_motivoAcuExtrajud', 'generico', 'motivoAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P72');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecPresenAcuExtrajud', 'generico', 'fecPresenAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P72');

-- P73

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P73');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P73');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P73');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepAcuExtrajud', 'generico', 'fecRecepAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P73');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_nombreDemandadoExtrajud', 'generico', 'nombreDemandadoExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P73');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_motivoAcuExtrajud', 'generico', 'motivoAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P73');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecPresenAcuExtrajud', 'generico', 'fecPresenAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P73');

-- P75

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P75');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P75');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P75');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepAcuExtrajud', 'generico', 'fecRecepAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P75');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_nombreDemandadoExtrajud', 'generico', 'nombreDemandadoExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P75');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_motivoAcuExtrajud', 'generico', 'motivoAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P75');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecPresenAcuExtrajud', 'generico', 'fecPresenAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P75');


-- P76

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P76');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P76');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P76');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepAcuExtrajud', 'generico', 'fecRecepAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P76');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_nombreDemandadoExtrajud', 'generico', 'nombreDemandadoExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P76');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_motivoAcuExtrajud', 'generico', 'motivoAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P76');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecPresenAcuExtrajud', 'generico', 'fecPresenAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P76');

-- P77

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P77');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P77');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P77');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepAcuExtrajud', 'generico', 'fecRecepAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P77');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_nombreDemandadoExtrajud', 'generico', 'nombreDemandadoExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P77');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_motivoAcuExtrajud', 'generico', 'motivoAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P77');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecPresenAcuExtrajud', 'generico', 'fecPresenAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P77');

-- P78

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P78');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P78');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P78');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepAcuExtrajud', 'generico', 'fecRecepAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P78');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_nombreDemandadoExtrajud', 'generico', 'nombreDemandadoExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P78');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_motivoAcuExtrajud', 'generico', 'motivoAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P78');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecPresenAcuExtrajud', 'generico', 'fecPresenAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P78');

-- P79

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P79');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P79');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P79');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepAcuExtrajud', 'generico', 'fecRecepAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P79');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_nombreDemandadoExtrajud', 'generico', 'nombreDemandadoExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P79');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_motivoAcuExtrajud', 'generico', 'motivoAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P79');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecPresenAcuExtrajud', 'generico', 'fecPresenAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P79');

-- P80

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P80');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P80');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P80');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepAcuExtrajud', 'generico', 'fecRecepAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P80');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_nombreDemandadoExtrajud', 'generico', 'nombreDemandadoExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P80');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_motivoAcuExtrajud', 'generico', 'motivoAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P80');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecPresenAcuExtrajud', 'generico', 'fecPresenAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P80');

-- P81

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P81');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P81');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P81');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepAcuExtrajud', 'generico', 'fecRecepAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P81');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_nombreDemandadoExtrajud', 'generico', 'nombreDemandadoExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P81');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_motivoAcuExtrajud', 'generico', 'motivoAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P81');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecPresenAcuExtrajud', 'generico', 'fecPresenAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P81');

-- P83

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P83');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'observaciones', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P83');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numAutos', 'generico', 'numAutos', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P83');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepAcuExtrajud', 'generico', 'fecRecepAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P83');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_nombreDemandadoExtrajud', 'generico', 'nombreDemandadoExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P83');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_motivoAcuExtrajud', 'generico', 'motivoAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P83');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecPresenAcuExtrajud', 'generico', 'fecPresenAcuExtrajud', 0, 'manuel', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in  (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo = 'ACU_EXTRAJUD') 
and dd_tpo_id =(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P83');



