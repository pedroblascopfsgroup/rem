-- modificar tamaño del campo descripcio de la tabla resoluciones
alter table DD_TR_TIPOS_RESOLUCION modify DD_TR_DESCRIPCION varchar2 (100byte) ;

commit;
 
--TIPOS DE RESOLUCION
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (20, 'MOAP', 'Oficios de Averiguación Patrimonial', 'Mon: Oficios de Averiguación Patrimonial', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 20', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (21, 'RESPPRUETESTSOL', 'Contestación de prueba testifical solicitada', 'ETJ: Aceptación/Denegación de prueba testifical solicitada', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 20', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (22, 'AUDE', 'Auto despacho ejecución', 'ETJ: Auto despacho ejecución', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 22', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (23, 'NOTEDICT', 'Requerimiento de notificación por edictos', 'ETJ: Requerimiento de notificación por edictos', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 23', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (24, 'EMB', 'Embargo / Mejora embargo', 'ETJ: Embargo / Mejora embargo', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 24', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (25, 'ANOT_EMB', 'Embargo: Anotación', 'ETJ: Embargo: Anotación', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 25', 4);
  
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (26, 'RENOV_ANOT_EMB', 'Embargo: Renovación anotación', 'ETJ: Embargo: Renovación anotación', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 26', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (27, 'REQ_RET_PAGAD', 'Requerimiento de retención al pagador: Solicitud', 'ETJ:Requerimiento de retención al pagador: Solicitud', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 27', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (28, 'REQ_RET_PAGAD_CONF', 'Requerimiento de retención al pagador: Confirmación del pagador', 'ETJ:Requerimiento de retención al pagador: Confirmación del pagador', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 28', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (29, 'CERDC', 'Certificación dominio y cargas', 'ETJ:Certificación dominio y cargas', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 29', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (30, 'CAL_NEG_REG', 'Calificación negativa del Registro', 'ETJ:Calificación negativa del Registro', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 30', 4);
   
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (31, 'CERT_CARG_PREC', 'Certificación cargas precedentes', 'HIP:Certificación cargas precedentes', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 31', 4);
  
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (32, 'SOL_AMP_CERDCPRE_INC', 'Solicitud de ampliación de certificación cargas precedentes incompleta', 'HIP:(Confirmación de presentación) Solicitud de ampliación de certificación cargas precedentes incompleta', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 32', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (33, 'OPO_SENT', 'Oposición: Sentencia ', 'ETJ: Oposición: Sentencia ', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 33', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (34, 'OPO_REC', 'Oposición: Recurso Sentencia', 'ETJ: Oposición: Recurso Sentencia ', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 34', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (35, 'AUDPREV', 'Audiencia Previa', 'ETJ:Audiencia Previa', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 35', 4);
   
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (36, 'VISTA', 'Vista', 'ETJ:Vista', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 36', 4);
    
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (37, 'DIL_FIN', 'Diligencia Final', 'ETJ:Diligencia Final', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 37', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (38, 'SENTENCIA', 'Sentencia', 'ETJ:Sentencia', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 38', 4);
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (39, 'SENTENCIA_IMP', 'Sentencia: Impugnación', 'ETJ:Sentencia: Impugnación', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 39', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (40, 'ADJ', 'Adjudicación', 'ETJ:Adjudicación', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 40', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (41, 'ADJ_SUB', 'Adjudicación: Subsanación', 'ETJ:Adjudicación: Subsanación', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 41', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (41, 'ADJ_SUB', 'Adjudicación: Subsanación', 'ETJ:Adjudicación: Subsanación', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 41', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (42, 'ADJ_TEST_DEC', 'Adjudicación: Testimonio del Decreto', 'ETJ:Adjudicación: Testimonio del Decreto', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 42', 4);
   
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (43, 'TAS_COS', 'Tasación costas', 'ETJ:Tasación costas', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 43', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (44, 'TAS_COS_IMP', 'Tasación costas: Impugnación Notificación', 'ETJ:Tasación costas: Impugnación Notificación', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 44', 4);
  
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (45, 'TAS_COS_VIST', 'Tasación costas: Vista', 'ETJ:Tasación costas: Vista', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 45', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (46, 'TAS_COS_RES', 'Tasación costas: Resolución', 'ETJ:Tasación costas: Resolución', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 46', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (47, 'TAS_COS_RES_VIS', 'Tasación costas: Impugnación Resolución Vista', 'ETJ:Tasación costas: Impugnación Resolución Vista', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 47', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (48, 'TAS_COS_AUT_AP', 'Tasación costas: Auto aprobación', 'ETJ:Tasación costas: Auto aprobación', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 48', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (49, 'LIQ_INT', 'Liquidación intereses', 'ETJ:Liquidación intereses', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 49', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (50, 'LIQ_INT_IMP', 'Liquidación intereses: Impugnación', 'ETJ:Liquidación intereses: Impugnación', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 50', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (51, 'LIQ_INT_VIST', 'Liquidación intereses: Vista', 'ETJ:Liquidación intereses: Vista', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 51', 4);
   
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (52, 'LIQ_INT_RES_VIST', 'Liquidación intereses: Resolución Vista', 'ETJ:Liquidación intereses: Resolución Vista', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 52', 4);
   
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (53, 'LIQ_INT_IMP_RES_VIST', 'Liquidación intereses: Impugnación Resolución Vista', 'ETJ:Liquidación intereses: Impugnación Resolución Vista', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 53', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (54, 'SUB', 'Subasta', 'ETJ:Subasta', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 54', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (55, 'SUB_ACT', 'Subasta: Acta', 'ETJ:Subasta: Acta', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 55', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (56, 'MAND_PAG', 'Mandamiento de pago', 'ETJ:Mandamiento de pago', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 56', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (57, 'AVALUO', 'Avalúo', 'ETJ:Avalúo', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 57', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (58, 'AVALUO_TJ', 'Avalúo: Tasador Judicial ', 'ETJ:Avalúo: Tasador Judicial ', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 58', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (59, 'AVALUO_AL', 'Avalúo: Alegaciones', 'ETJ:Avalúo: Alegaciones', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 59', 4);
   
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (60, 'AVALUO_COMP', 'Avalúo: Comparecencia', 'ETJ:Avalúo: Comparecencia', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 60', 4);
  
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (61, 'AVALUO_RES', 'Avalúo: Resolución', 'ETJ: Avalúo: Resolución', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 61', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (62, 'AVALUO_IMP', 'Avalúo: Impugnación', 'ETJ: Avalúo: Impugnación', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 62', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (63, 'AVALUO_JUST', 'Avalúo: Justiprecio', 'ETJ: Avalúo: Justiprecio', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 63', 4);
   
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (64, 'CES_REMAT_COMP', 'Cesión remate: Comparecencia', 'ETJ: Cesión remate: Comparecencia', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 64', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (65, 'SOL_POSESION_BIEN', '(Confirmación de presentación) Solicitud posesión bien', 'ETJ: (Confirmación de presentación) Solicitud posesión bien', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 65', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (66, 'LANZ', 'Lanzamiento', 'ETJ: Lanzamiento', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 66', 4);
   
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (67, 'LANZ_VIST', 'Lanzamiento: Vista', 'ETJ: Lanzamiento: Vista', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 67', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (68, 'LANZ_RES', 'Lanzamiento: Resolución', 'ETJ: Lanzamiento: Resolución', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 68', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (69, 'LANZ_IMP_RES', 'Lanzamiento: Impugnación Resolución', 'ETJ: Lanzamiento: Impugnación Resolución', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 69', 4);
 

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (70, 'DEP_NOMB_DEP', 'Depósito: Nombramiento depositario', 'ETJ: Depósito: Nombramiento depositario', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 70', 4);
    
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (71, 'DEP_CIT_DEP', 'Depósito: Citación depositario', 'ETJ: Depósito: Citación depositario', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 71', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (72, 'DEP_RESP_DEP', 'Depósito: Respuesta depositario', 'ETJ: Depósito: Respuesta depositario', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 72', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (73, 'DEP_SOL_REM', 'Depósito: Solicitud remoción', 'ETJ: Depósito: Solicitud remoción', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 73', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (74, 'NOT_ACU_ENT_BI', 'Depósito: Notificación acuerdo entrega bien', 'ETJ: Depósito: Notificación acuerdo entrega bien', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 74', 4);
  
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (75, 'PRECINTO', 'Precinto', 'ETJ: Precinto', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 75', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (76, 'DEM_OPO_CAMB', 'Demanda Oposición Cambiario', 'CAMB: Demanda Oposición Cambiario', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 76', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (77, 'DEM_OPO_CAMB_IMP', 'Demanda Oposición Cambiario: Impugnación', 'CAMB: Demanda Oposición Cambiario: Impugnación', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 77', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (78, 'DEM_OPO_CAMB_SENT', 'Demanda Oposición Cambiario: Sentencia', 'CAMB: Demanda Oposición Cambiario: Sentencia', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 78', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (79, 'OPO_CAMB_REC_SENT', 'Demanda Oposición Cambiario: Recurso Sentencia ', 'CAMB: Demanda Oposición Cambiario: Recurso Sentencia ', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 79', 4);
   
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (80, 'ESP_CONT', 'Esperar/Continuar procedimiento ', 'Esperar/Continuar procedimiento ', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 80', 4);
    
    
   
COMMIT;
