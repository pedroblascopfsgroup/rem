--
delete from msv_campos_dinamicos;
delete from RES_RESOLUCIONES_MASIVO;
delete from DD_TR_TIPOS_RESOLUCION;

commit;
--
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (1, 'MDP', 'Demanda presentada', 'Mon: Demanda presentada', 1, 0, 'SUPER', sysdate, 0, 'Introduzca estos datos:</br> Fecha de presentación de la demanda (obligatorio)<br/>Fecha de recepción de la resolución (obligatorio)', 1);
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (2, 'MID', 'Inadmisión de la demanda', 'Mon: Inadmisión de la demanda', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 2', 4);
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (3, 'MRPREV', 'Requerimientos previos', 'Mon: Requerimientos previos', 1, 0, 'SUPER', sysdate , 0, 'Ayuda 3', 2);
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (4, 'MADM', 'Admisión de la demanda', 'Mon: Admisión de la demanda', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 4', 4);
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (5, 'MRPAG', 'Requerimiento Pago', 'Mon: Requerimiento Pago', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 5', 2);
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (6, 'MSOL', 'Oficios de Localización', 'Mon:Oficios de Localización', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 6', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (7, 'HHNOC', 'Habilitación horario nocturno', 'Mon: Habilitación horario nocturno', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 6', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (8, 'CONSIG', 'Consignación', 'Mon: Consignación', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 8', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (9, 'JUSGRAT', 'Solicitud de justicia gratuita', 'Mon: Solicitud de justicia gratuita', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 9', 4);
    
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (10, 'JGRATPROF', 'Justicia Gratuita: Designación de profesionales', 'Mon: Justicia Gratuita: Designación de profesionales', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 10', 3);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (11, 'ALLAN', 'Allanamiento', 'Mon: Justicia Gratuita: Allanamiento', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 11', 4);
   
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (12, 'OPO', 'Oposición', 'Mon: Oposición', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 12', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (13, 'OPOIMPUG', 'Oposición: Impugnación', 'Mon: Oposición: Impugnación', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 13', 4);
    
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
   (18, 'SUSP', 'Suspensión', 'Mon: Suspensión', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 18', 4);
    
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (19, 'IMP', 'Solicitud impulso procesal', 'Mon: Solicitud impulso procesal', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 19', 4);
   
-- nuevos tipos de resolucion
--Insert into DD_TR_TIPOS_RESOLUCION
--   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
-- Values
--   (20, 'MSOL', 'Solicitud Oficios de Localización', 'Mon: Solicitud Oficios de Localización', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 20', 4);
 
--Insert into DD_TR_TIPOS_RESOLUCION
--   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
-- Values
--   (21, 'SOLNOCT', 'Solicitud de habilitación horario nocturno', 'Mon: Solicitud de habilitación horario nocturno', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 20', 4);
    
   
COMMIT;
