-- modificar tama�o del campo descripcio de la tabla resoluciones
alter table DD_TR_TIPOS_RESOLUCION modify DD_TR_DESCRIPCION varchar2 (100byte) ;

commit;
 
--TIPOS DE RESOLUCION
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (20, 'MOAP', 'Oficios de Averiguaci�n Patrimonial', 'Mon: Oficios de Averiguaci�n Patrimonial', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 20', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (21, 'RESPPRUETESTSOL', 'Contestaci�n de prueba testifical solicitada', 'ETJ: Aceptaci�n/Denegaci�n de prueba testifical solicitada', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 20', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (22, 'AUDE', 'Auto despacho ejecuci�n', 'ETJ: Auto despacho ejecuci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 22', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (23, 'NOTEDICT', 'Requerimiento de notificaci�n por edictos', 'ETJ: Requerimiento de notificaci�n por edictos', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 23', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (24, 'EMB', 'Embargo / Mejora embargo', 'ETJ: Embargo / Mejora embargo', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 24', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (25, 'ANOT_EMB', 'Embargo: Anotaci�n', 'ETJ: Embargo: Anotaci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 25', 4);
  
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (26, 'RENOV_ANOT_EMB', 'Embargo: Renovaci�n anotaci�n', 'ETJ: Embargo: Renovaci�n anotaci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 26', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (27, 'REQ_RET_PAGAD', 'Requerimiento de retenci�n al pagador: Solicitud', 'ETJ:Requerimiento de retenci�n al pagador: Solicitud', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 27', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (28, 'REQ_RET_PAGAD_CONF', 'Requerimiento de retenci�n al pagador: Confirmaci�n del pagador', 'ETJ:Requerimiento de retenci�n al pagador: Confirmaci�n del pagador', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 28', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (29, 'CERDC', 'Certificaci�n dominio y cargas', 'ETJ:Certificaci�n dominio y cargas', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 29', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (30, 'CAL_NEG_REG', 'Calificaci�n negativa del Registro', 'ETJ:Calificaci�n negativa del Registro', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 30', 4);
   
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (31, 'CERT_CARG_PREC', 'Certificaci�n cargas precedentes', 'HIP:Certificaci�n cargas precedentes', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 31', 4);
  
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (32, 'SOL_AMP_CERDCPRE_INC', 'Solicitud de ampliaci�n de certificaci�n cargas precedentes incompleta', 'HIP:(Confirmaci�n de presentaci�n) Solicitud de ampliaci�n de certificaci�n cargas precedentes incompleta', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 32', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (33, 'OPO_SENT', 'Oposici�n: Sentencia ', 'ETJ: Oposici�n: Sentencia ', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 33', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (34, 'OPO_REC', 'Oposici�n: Recurso Sentencia', 'ETJ: Oposici�n: Recurso Sentencia ', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 34', 4);
 
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
   (39, 'SENTENCIA_IMP', 'Sentencia: Impugnaci�n', 'ETJ:Sentencia: Impugnaci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 39', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (40, 'ADJ', 'Adjudicaci�n', 'ETJ:Adjudicaci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 40', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (41, 'ADJ_SUB', 'Adjudicaci�n: Subsanaci�n', 'ETJ:Adjudicaci�n: Subsanaci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 41', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (41, 'ADJ_SUB', 'Adjudicaci�n: Subsanaci�n', 'ETJ:Adjudicaci�n: Subsanaci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 41', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (42, 'ADJ_TEST_DEC', 'Adjudicaci�n: Testimonio del Decreto', 'ETJ:Adjudicaci�n: Testimonio del Decreto', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 42', 4);
   
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (43, 'TAS_COS', 'Tasaci�n costas', 'ETJ:Tasaci�n costas', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 43', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (44, 'TAS_COS_IMP', 'Tasaci�n costas: Impugnaci�n Notificaci�n', 'ETJ:Tasaci�n costas: Impugnaci�n Notificaci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 44', 4);
  
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (45, 'TAS_COS_VIST', 'Tasaci�n costas: Vista', 'ETJ:Tasaci�n costas: Vista', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 45', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (46, 'TAS_COS_RES', 'Tasaci�n costas: Resoluci�n', 'ETJ:Tasaci�n costas: Resoluci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 46', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (47, 'TAS_COS_RES_VIS', 'Tasaci�n costas: Impugnaci�n Resoluci�n Vista', 'ETJ:Tasaci�n costas: Impugnaci�n Resoluci�n Vista', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 47', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (48, 'TAS_COS_AUT_AP', 'Tasaci�n costas: Auto aprobaci�n', 'ETJ:Tasaci�n costas: Auto aprobaci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 48', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (49, 'LIQ_INT', 'Liquidaci�n intereses', 'ETJ:Liquidaci�n intereses', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 49', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (50, 'LIQ_INT_IMP', 'Liquidaci�n intereses: Impugnaci�n', 'ETJ:Liquidaci�n intereses: Impugnaci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 50', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (51, 'LIQ_INT_VIST', 'Liquidaci�n intereses: Vista', 'ETJ:Liquidaci�n intereses: Vista', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 51', 4);
   
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (52, 'LIQ_INT_RES_VIST', 'Liquidaci�n intereses: Resoluci�n Vista', 'ETJ:Liquidaci�n intereses: Resoluci�n Vista', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 52', 4);
   
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (53, 'LIQ_INT_IMP_RES_VIST', 'Liquidaci�n intereses: Impugnaci�n Resoluci�n Vista', 'ETJ:Liquidaci�n intereses: Impugnaci�n Resoluci�n Vista', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 53', 4);
 
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
   (57, 'AVALUO', 'Aval�o', 'ETJ:Aval�o', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 57', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (58, 'AVALUO_TJ', 'Aval�o: Tasador Judicial ', 'ETJ:Aval�o: Tasador Judicial ', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 58', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (59, 'AVALUO_AL', 'Aval�o: Alegaciones', 'ETJ:Aval�o: Alegaciones', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 59', 4);
   
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (60, 'AVALUO_COMP', 'Aval�o: Comparecencia', 'ETJ:Aval�o: Comparecencia', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 60', 4);
  
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (61, 'AVALUO_RES', 'Aval�o: Resoluci�n', 'ETJ: Aval�o: Resoluci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 61', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (62, 'AVALUO_IMP', 'Aval�o: Impugnaci�n', 'ETJ: Aval�o: Impugnaci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 62', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (63, 'AVALUO_JUST', 'Aval�o: Justiprecio', 'ETJ: Aval�o: Justiprecio', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 63', 4);
   
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (64, 'CES_REMAT_COMP', 'Cesi�n remate: Comparecencia', 'ETJ: Cesi�n remate: Comparecencia', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 64', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (65, 'SOL_POSESION_BIEN', '(Confirmaci�n de presentaci�n) Solicitud posesi�n bien', 'ETJ: (Confirmaci�n de presentaci�n) Solicitud posesi�n bien', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 65', 4);
 
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
   (68, 'LANZ_RES', 'Lanzamiento: Resoluci�n', 'ETJ: Lanzamiento: Resoluci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 68', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (69, 'LANZ_IMP_RES', 'Lanzamiento: Impugnaci�n Resoluci�n', 'ETJ: Lanzamiento: Impugnaci�n Resoluci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 69', 4);
 

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (70, 'DEP_NOMB_DEP', 'Dep�sito: Nombramiento depositario', 'ETJ: Dep�sito: Nombramiento depositario', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 70', 4);
    
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (71, 'DEP_CIT_DEP', 'Dep�sito: Citaci�n depositario', 'ETJ: Dep�sito: Citaci�n depositario', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 71', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (72, 'DEP_RESP_DEP', 'Dep�sito: Respuesta depositario', 'ETJ: Dep�sito: Respuesta depositario', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 72', 4);
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (73, 'DEP_SOL_REM', 'Dep�sito: Solicitud remoci�n', 'ETJ: Dep�sito: Solicitud remoci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 73', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (74, 'NOT_ACU_ENT_BI', 'Dep�sito: Notificaci�n acuerdo entrega bien', 'ETJ: Dep�sito: Notificaci�n acuerdo entrega bien', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 74', 4);
  
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (75, 'PRECINTO', 'Precinto', 'ETJ: Precinto', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 75', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (76, 'DEM_OPO_CAMB', 'Demanda Oposici�n Cambiario', 'CAMB: Demanda Oposici�n Cambiario', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 76', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (77, 'DEM_OPO_CAMB_IMP', 'Demanda Oposici�n Cambiario: Impugnaci�n', 'CAMB: Demanda Oposici�n Cambiario: Impugnaci�n', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 77', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (78, 'DEM_OPO_CAMB_SENT', 'Demanda Oposici�n Cambiario: Sentencia', 'CAMB: Demanda Oposici�n Cambiario: Sentencia', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 78', 4);

Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (79, 'OPO_CAMB_REC_SENT', 'Demanda Oposici�n Cambiario: Recurso Sentencia ', 'CAMB: Demanda Oposici�n Cambiario: Recurso Sentencia ', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 79', 4);
   
 
Insert into DD_TR_TIPOS_RESOLUCION
   (DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID)
 Values
   (80, 'ESP_CONT', 'Esperar/Continuar procedimiento ', 'Esperar/Continuar procedimiento ', 1, 0, 'SUPER', sysdate, 0, 'Ayuda 80', 4);
    
    
   
COMMIT;
