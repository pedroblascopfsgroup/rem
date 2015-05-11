-- resolución de generación de fichero de tasas
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (84, 'FICHERO_TASAS_GEN', 'Fichero de tasas generado', 'Fichero de tasas generado', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 83', 2);

Insert into BPM_DD_TIN_TIPO_INPUT
   (BPM_DD_TIN_ID, BPM_DD_TIN_CODIGO, BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TIN_TIPO_INPUT.nextval, 'RES_FICHERO_TASAS_GENERADO', 'Fichero de tasas generado', 'Fichero de tasas generado', 0, 'DIANA', sysdate, 0);

Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P71'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='RES_FICHERO_TASAS_GENERADO'),'P71_GenerarFicheroTasas', 'NONE', 0, 
'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),
null,'avanzaBPM');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecResolucionGeneracionFichero', 'generico', 'fecResolucionGeneracionFichero', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_FICHERO_TASAS_GENERADO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepResolGeneracionFichero', 'generico', 'fecRecepResolGeneracionFichero', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_FICHERO_TASAS_GENERADO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');


Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numContrato', 'generico', 'Num. Contrato', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_FICHERO_TASAS_GENERADO%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numNova', 'generico', 'Num. Caso NOVA', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_FICHERO_TASAS_GENERADO%') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_FICHERO_TASAS_GENERADO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'Observaciones', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_FICHERO_TASAS_GENERADO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

-- validación de fichero de tasas
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (85, 'VALIDACION_FICHERO', 'Validar fichero tasas', 'Validar fichero tasas', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 83', 2);

Insert into BPM_DD_TIN_TIPO_INPUT
   (BPM_DD_TIN_ID, BPM_DD_TIN_CODIGO, BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TIN_TIPO_INPUT.nextval, 'RES_FICHERO_TASAS_VALIDO', 'Fichero de tasas valido', 'Fichero de tasas valido', 0, 'DIANA', sysdate, 0);

Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P71'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='RES_FICHERO_TASAS_VALIDO'),'P71_ValidarFicheroTasas', 'NONE', 0, 
'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),
null,'presentacionManual');

Insert into BPM_DD_TIN_TIPO_INPUT
   (BPM_DD_TIN_ID, BPM_DD_TIN_CODIGO, BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TIN_TIPO_INPUT.nextval, 'RES_FICHERO_TASAS_NO_VALIDO', 'Fichero de tasas valido', 'Fichero de tasas valido', 0, 'DIANA', sysdate, 0);

Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P71'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='RES_FICHERO_TASAS_NO_VALIDO'),'P71_ValidarFicheroTasas', 'NONE', 0, 
'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),
null,'NoValido');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecResolucionValidarFichero', 'generico', 'fecResolucionValidarFichero', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_FICHERO_TASAS%VALIDO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepResolValidarFichero', 'generico', 'fecRecepResolValidarFichero', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_FICHERO_TASAS%VALIDO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_tipoValidarFichero', 'generico', 'tipoValidarFichero', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_FICHERO_TASAS%VALIDO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');


Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numContrato', 'generico', 'Num. Contrato', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_FICHERO_TASAS%VALIDO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numNova', 'generico', 'Num. Caso NOVA', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_FICHERO_TASAS%VALIDO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_FICHERO_TASAS%VALIDO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'Observaciones', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_FICHERO_TASAS%VALIDO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

-- solicitar pago de tasas

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (86, 'SOLICITUD_PAGO', 'Solicitado pago de tasas', 'Solicitado pago de tasas', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 86', 2);

Insert into BPM_DD_TIN_TIPO_INPUT
   (BPM_DD_TIN_ID, BPM_DD_TIN_CODIGO, BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TIN_TIPO_INPUT.nextval, 'SOLICITUD_PAGO', 'Solicitado pago de tasas', 'Solicitado pago de tasas', 0, 'DIANA', sysdate, 0);

Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P71'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='SOLICITUD_PAGO'),'P71_SolicitarPagoTasas', 'NONE', 0, 
'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),
null,'avanzaBPM');



Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecResolucionSolicitudPago', 'generico', 'fecResolucionSolicitudPago', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'SOLICITUD_PAGO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepResolSolicitudPago', 'generico', 'fecRecepResolSolicitudPago', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'SOLICITUD_PAGO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numContrato', 'generico', 'Num. Contrato', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'SOLICITUD_PAGO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numNova', 'generico', 'Num. Caso NOVA', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'SOLICITUD_PAGO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'SOLICITUD_PAGO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'Observaciones', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'SOLICITUD_PAGO') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

-- confirmar recepción documentación tasas

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (87, 'RECEP_DOC', 'Documentación tasas recibida', 'Documentación tasas recibida', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 87', 2);

Insert into BPM_DD_TIN_TIPO_INPUT
   (BPM_DD_TIN_ID, BPM_DD_TIN_CODIGO, BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TIN_TIPO_INPUT.nextval, 'RES_DOC_RECIBIDA', 'Documentación tasas recibida', 'Documentación tasas recibida', 0, 'DIANA', sysdate, 0);

Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P71'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='RES_DOC_RECIBIDA'),'P71_ConfirmarRecepcionDocumentacion', 'NONE', 0, 
'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),
null,'avanzaBPM');



Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecResolucionRecepcionPago', 'generico', 'fecResolucionSolicitudPago', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_DOC_RECIBIDA') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepResolRecepcionPago', 'generico', 'fecRecepResolSolicitudPago', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_DOC_RECIBIDA') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numContrato', 'generico', 'Num. Contrato', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_DOC_RECIBIDA') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numNova', 'generico', 'Num. Caso NOVA', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_DOC_RECIBIDA') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_DOC_RECIBIDA') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'Observaciones', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_DOC_RECIBIDA') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

-- enviado a imprimir

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (88, 'ENVIADO_IMPRIMIR', 'Enviado a imprimir', 'Enviado a imprimir', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 88', 2);

Insert into BPM_DD_TIN_TIPO_INPUT
   (BPM_DD_TIN_ID, BPM_DD_TIN_CODIGO, BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TIN_TIPO_INPUT.nextval, 'RES_IMP', 'Enviado a imprimir', 'Enviado a imprimir', 0, 'DIANA', sysdate, 0);

Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P71'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='RES_IMP'),'P71_EnviarImprimir', 'NONE', 0, 
'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),
null,'avanzaBPM');



Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecResolucionEnviadoImp', 'generico', 'fecResolucionEnviadoImp', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_IMP') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepResolEnviadoImp', 'generico', 'fecRecepResolEnviadoImp', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_IMP') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numContrato', 'generico', 'Num. Contrato', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_IMP') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numNova', 'generico', 'Num. Caso NOVA', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_IMP') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_IMP') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'Observaciones', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_IMP') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

-- Confirmar recepción documentación impresa

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (89, 'RECEP_DOC_IMP', 'Documentación impresa reciba', 'Documentación impresa reciba', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 89', 2);

Insert into BPM_DD_TIN_TIPO_INPUT
   (BPM_DD_TIN_ID, BPM_DD_TIN_CODIGO, BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TIN_TIPO_INPUT.nextval, 'RES_RECEP_DOC_IMP', 'Documentación impresa reciba', 'Documentación impresa reciba', 0, 'DIANA', sysdate, 0);

Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P71'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='RES_RECEP_DOC_IMP'),'P71_ConfirmarRecepcionDocumentacionImpresa', 'NONE', 0, 
'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),
null,'avanzaBPM');


Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecResolucionRecepDocImp', 'generico', 'fecResolucionRecepDocImp', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_RECEP_DOC_IMP') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepResolRecepDocImp', 'generico', 'fecRecepResolRecepDocImp', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_RECEP_DOC_IMP') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numContrato', 'generico', 'Num. Contrato', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_RECEP_DOC_IMP') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numNova', 'generico', 'Num. Caso NOVA', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_RECEP_DOC_IMP') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_RECEP_DOC_IMP') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'Observaciones', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_RECEP_DOC_IMP') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

-- Enviado al juzgado

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (90, 'ENVIADO_JUZ', 'Enviado al juzgado', 'Enviado al juzgado', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 90', 2);

Insert into BPM_DD_TIN_TIPO_INPUT
   (BPM_DD_TIN_ID, BPM_DD_TIN_CODIGO, BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TIN_TIPO_INPUT.nextval, 'RES_ENVIADO_JUZ', 'Enviado al juzgado', 'Enviado al juzgado', 0, 'DIANA', sysdate, 0);

Insert into BPM_TPI_TIPO_PROC_INPUT (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID, BPM_TPI_NOMBRE_TRANSICION) 
Values(S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P71'), 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='RES_ENVIADO_JUZ'),'P71_EnviarJuzgado', 'NONE', 0, 
'MASIVO', SYSDATE, 0,(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='ADVANCE'),
null,'avanzaBPM');


Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecResolucionEnviadoJuzgado', 'generico', 'fecResolucionEnviadoJuzgado', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_ENVIADO_JUZ') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_fecRecepResolEnviadoJuzgado', 'generico', 'fecRecepResolEnviadoJuzgado', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_ENVIADO_JUZ') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numContrato', 'generico', 'Num. Contrato', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_ENVIADO_JUZ') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_numNova', 'generico', 'Num. Caso NOVA', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_ENVIADO_JUZ') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'idAsunto', 'generico', 'idAsunto', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_ENVIADO_JUZ') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_observaciones', 'generico', 'Observaciones', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_ENVIADO_JUZ') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_juzgado', 'generico', 'juzgado', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_ENVIADO_JUZ') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');

Insert into BPM_IDT_INPUT_DATOS(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO, VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
select S_BPM_IDT_INPUT_DATOS.nextVal, bpm_tpi_id , 'd_plaza', 'generico', 'plaza', 0, 'diana', sysdate, 0 
from bpm_tpi_tipo_proc_input where bpm_dd_tin_id in (select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo like 'RES_ENVIADO_JUZ') 
and dd_tpo_id=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71');
