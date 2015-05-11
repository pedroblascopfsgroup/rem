--
delete from msv_campos_dinamicos;
delete from RES_RESOLUCIONES_MASIVO;
delete from DD_TR_TIPOS_RESOLUCION;

commit;
--
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (1, 'MDP', 'Demanda presentada', 'Mon: Demanda presentada', 1, 0, 'SUPER', sysdate, 0, 'Introduzca estos datos:</br> Fecha de presentaci�n de la demanda (obligatorio)<br/>Fecha de recepci�n de la resoluci�n (obligatorio)', 1);
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (2, 'MID', 'Inadmisi�n de la demanda', 'Mon: Inadmisi�n de la demanda', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 2', 4);
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (3, 'MRPREV', 'Requerimientos previos', 'Mon: Requerimientos previos', 1, 0, 'SUPER', sysdate , 0, 'Ayuda 3', 2);
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (4, 'MADM', 'Admisi�n de la demanda', 'Mon: Admisi�n de la demanda', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 4', 4);
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (5, 'MRPAG', 'Requerimiento Pago', 'Mon: Requerimiento Pago', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 5', 2);
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (6, 'MSOL', 'Oficios de Localizaci�n', 'Mon:Oficios de Localizaci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 6', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (7, 'HHNOC', 'Habilitaci�n horario nocturno', 'Mon: Habilitaci�n horario nocturno', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 6', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (8, 'CONSIG', 'Consignaci�n', 'Mon: Consignaci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 8', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (9, 'JUSGRAT', 'Solicitud de justicia gratuita', 'Mon: Solicitud de justicia gratuita', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 9', 4);
    
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (10, 'JGRATPROF', 'Justicia Gratuita: Designaci�n de profesionales', 'Mon: Justicia Gratuita: Designaci�n de profesionales', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 10', 3);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (11, 'ALLAN', 'Allanamiento', 'Mon: Justicia Gratuita: Allanamiento', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 11', 4);
   
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (12, 'OPO', 'Oposici�n', 'Mon: Oposici�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 12', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (13, 'OPOIMPUG', 'Oposici�n: Impugnaci�n', 'Mon: Oposici�n: Impugnaci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 13', 4);
    
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (14, 'AUTOFIN', 'Auto Fin de monitorio', 'Mon: Auto Fin de monitorio', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 14', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (15, 'COMPDEM', 'Comparecencia del demandado', 'Mon: Comparecencia del demandado', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 15', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (16, 'ARCH', 'Archivo', 'Mon: Archivo', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 16', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (17, 'DESIS', 'Desistimiento', 'Mon: Desistimiento', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 17', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (18, 'SUSP', 'Suspensi�n', 'Mon: Suspensi�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 18', 4);
    
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (19, 'IMP', 'Solicitud impulso procesal', 'Mon: Solicitud impulso procesal', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 19', 4);
   
-- nuevos tipos de resolucion
--Insert into DD_TR_TIPOS_RESOLUCION
--   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
-- Values
--   (20, 'MSOL', 'Solicitud Oficios de Localizaci�n', 'Mon: Solicitud Oficios de Localizaci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 20', 4);
 
--Insert into DD_TR_TIPOS_RESOLUCION
--   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
-- Values
--   (21, 'SOLNOCT', 'Solicitud de habilitaci�n horario nocturno', 'Mon: Solicitud de habilitaci�n horario nocturno', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 20', 4);
    
   
COMMIT;
