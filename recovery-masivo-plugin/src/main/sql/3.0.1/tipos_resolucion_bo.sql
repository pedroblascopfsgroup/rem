-- crear los tipos de resolución para BO

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (81, 'CONF_RECEP_CNT', 'Confirmar Recepción del contrato', 'Confirmar Recepción del contrato', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 81', 2);

-- crear tipos de input para resolucion

Insert into BPM_DD_TIN_TIPO_INPUT
   (BPM_DD_TIN_ID, BPM_DD_TIN_CODIGO, BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TIN_TIPO_INPUT.nextval, 'RES_CNT_ORIGINAL_NO_RECIBIDO', 'Contrato original no recibido', 'Contrato original no recibido', 0, 'DIANA', sysdate, 0);

Insert into BPM_DD_TIN_TIPO_INPUT
   (BPM_DD_TIN_ID, BPM_DD_TIN_CODIGO, BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TIN_TIPO_INPUT.nextval, 'RES_CNT_ORIGINAL_RECIBIDO', 'Contrato original recibido', 'Contrato original recibido', 0, 'DIANA', sysdate, 0);
 
-- crear configuración para el procedimiento
Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P71'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='RES_CNT_ORIGINAL_NO_RECIBIDO'),'P71_ConfirmarRecepcionContrato', 'NONE', 0, 
'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),
(select dd_informe_id from dd_informes where dd_informe_codigo='DEMANDA_MONITORIO_SPROC'),'SinContrato');

Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P71'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='RES_CNT_ORIGINAL_RECIBIDO'),'P71_ConfirmarRecepcionContrato', 'NONE', 0, 
'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),null,'ConContrato');

-- datos del input
Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecResolucionConfRecepCnt', 'generico', 'fecResolucionConfRecepCnt', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_CNT_ORIGINAL%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepResolConfRecepCnt', 'generico', 'Fecha resolucion', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_CNT_ORIGINAL%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numContrato', 'generico', 'Num. Contrato', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_CNT_ORIGINAL%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numNova', 'generico', 'Num. Caso NOVA', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_CNT_ORIGINAL%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_contratoRecibido', 'generico', 'contratoRecibido', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_CNT_ORIGINAL%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_CNT_ORIGINAL%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'Observaciones', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_CNT_ORIGINAL%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

commit;


-- resolucion testimonio solicitado
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (82, 'TESTIMONIO_SOLIC', 'Solicitud de testimonio', 'Solicitud de testimonio', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 82', 2);

Insert into BPM_DD_TIN_TIPO_INPUT
   (BPM_DD_TIN_ID, BPM_DD_TIN_CODIGO, BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TIN_TIPO_INPUT.nextval, 'RES_TESTIMONIO_SOLICITADO', 'Solicitud de testimonio', 'Solicitud de testimonio', 0, 'DIANA', sysdate, 0);

Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P71'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='RES_TESTIMONIO_SOLICITADO'),'P71_SolicitarTestimonio', 'NONE', 0, 
'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),null,'avanzaBPM');
 
Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecResolucionSolicitudTestimonio', 'generico', 'fecResolucionConfRecepCnt', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_TESTIMONIO_SOLICITADO%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepResolSolicitudTestimonio', 'generico', 'Fecha solicitud', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_TESTIMONIO_SOLICITADO%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numContrato', 'generico', 'Num. Contrato', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_TESTIMONIO_SOLICITADO%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numNova', 'generico', 'Num. Caso NOVA', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_TESTIMONIO_SOLICITADO%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_TESTIMONIO_SOLICITADO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'Observaciones', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_TESTIMONIO_SOLICITADO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

   

-- resolucion testimonio recibido

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (83, 'TESTIMONIO_RECIB', 'Recepción de testimonio', 'Recepción de testimonio', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 83', 2);

Insert into BPM_DD_TIN_TIPO_INPUT
   (BPM_DD_TIN_ID, BPM_DD_TIN_CODIGO, BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TIN_TIPO_INPUT.nextval, 'RES_TESTIMONIO_RECIBIDO', 'Recepcion de testimonio', 'Recepcion de testimonio', 0, 'DIANA', sysdate, 0);

Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P71'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='RES_TESTIMONIO_RECIBIDO'),'P71_ConfirmarRecepcionTestimonio', 'NONE', 0, 
'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),
(select dd_informe_id from dd_informes where dd_informe_codigo='DEMANDA_MONITORIO_SPROC'),'avanzaBPM');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_protocolo', 'generico', 'Protocolo', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_TESTIMONIO_RECIBIDO%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_notario', 'generico', 'Notario', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_TESTIMONIO_RECIBIDO%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepResolRecepcionTestimonio', 'generico', 'fecRecepResolRecepcionTestimonio', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_TESTIMONIO_RECIBIDO%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecResolucionRecepcionTestimonio', 'generico', 'fecResolucionRecepcionTestimonio', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_TESTIMONIO_RECIBIDO%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numContrato', 'generico', 'Num. Contrato', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_TESTIMONIO_RECIBIDO%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numNova', 'generico', 'Num. Caso NOVA', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_TESTIMONIO_RECIBIDO%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_TESTIMONIO_RECIBIDO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'Observaciones', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_TESTIMONIO_RECIBIDO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');
   