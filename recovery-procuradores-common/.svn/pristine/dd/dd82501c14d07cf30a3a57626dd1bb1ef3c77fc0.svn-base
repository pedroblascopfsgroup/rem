SET DEFINE OFF;

-- HIPOTECARIO --
INSERT INTO dd_tj_tipo_juicio (dd_tj_id, dd_tj_codigo, dd_tj_descripcion, dd_tj_descripcion_larga, VERSION, usuariocrear, fechacrear, borrado, dd_tpo_id)
     VALUES (s_dd_tj_tipo_juicio.NEXTVAL, 'HIP', 'Hipotecario', 'Hipotecario', 0, 'MOD_PROC',
             SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P01'));

-- SUBASTA BANKIA--
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'SUB', 'Subasta Bankia', 'Subasta Bankia', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P401'));


-- CESION DE REMATE--
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'CES', 'Cesión de remate', 'Cesión de remate', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P410'));

-- ADJUDICACION --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'ADJ', 'Adjudicación', 'Adjudicación', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P413'));

-- COSTAS --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'TCS', 'Trámite de Costas', 'Trámite de Costas', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P07'));
 			
-- CERTIFICACION CARGAS --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'CCG', 'Certificación cargas', 'Certificación cargas', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P08'));
 			
-- T.INTERESES --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'INT', 'T. Intereses', 'T. Intereses', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P10'));
 			
 -- T.GESTIÓN DE LLAVES --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'GLL', 'T. Gestión de llaves', 'T. Gestión de llaves', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P417'));
 			
 -- T.OCUPANTES --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'OCU', 'T. Ocupantes', 'T. Ocupantes', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P419'));
 			
 -- T.MORATORIA DE LANZAMIENTO --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'MRL', 'T. Moratoria de lanzamiento', 'T. Moratoria de lanzamiento', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P418'));
   
 -- T.DE POSESIÓN --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'POS', 'T. de posesión', 'T. de posesión', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P416'));
 			
-- P.ORDINARIO --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'ORD', 'Procedimiento ordinario', 'Procedimiento ordinario', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P03'));
 			
-- P.MONITORIO --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'MON', 'Procedimiento monitorio', 'Procedimiento monitorio', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P02'));
 			
-- P.VERBAL --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'VBL', 'Procedimiento verbal', 'Procedimiento verbal', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P04'));
 			
-- P.VERBAL DESDE MONITORIO--
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'VMN', 'Procedimiento verbal desde monitorio', 'Procedimiento verbal desde monitorio', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P21'));
 			
-- T. CERTIFICADO DE CARGAS Y REVISIÓN --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'CCR', 'Trámite certificado de cargas y revisión', 'Trámite certificado de cargas y revisión', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P08'));
 			
-- T. EMBARGO DE SALARIOS --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'EMS', 'T. Embargo de salarios', 'T. Embargo de salarios', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P09'));
 			
 -- TRAMITE DE VALORACIÓN DE BIENES INMUEBLES --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'VBI', 'T. Valoración de bienes e inmuebles', 'T. Valoración de bienes e inmuebles', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P12'));
 			
-- TRAMITE DE VALORACIÓN DE BIENES MUEBLES --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'VBM', 'T. Valoración de bienes muebles', 'T. Valoración de bienes muebles', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P13'));
 			
 -- TRAMITE DE MEJORA DE EMBARGO --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'MEM', 'T. Mejora de embargo', 'T. Mejora de embargo', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P14')); 			
 			
 -- P. DE DEPOSITO --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'PDD', 'P. De depósito', 'P. De depósito', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P18'));
 			
 -- P. DE PRECINTO --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'PRE', 'P. De precinto', 'P. De precinto', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P19'));
 			
-- T. INVESTIGACIÓN JUDICIAL --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'INJ', 'T. Investigación judicial', 'T. Investigación judicial', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P20'));
 						
 -- P. EJECUCION TITULO NO JUDICIAL --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'PNJ', 'P. Ejecución título no judicial', 'P. Ejecución título no judicial', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P15'));
 			
-- P. EJECUCION TITULO JUDICIAL --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'PTJ', 'P. Ejecución título judicial', 'P. Ejecución título judicial', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P16'));
 			
 -- P. CAMBIARIO --
INSERT into DD_TJ_TIPO_JUICIO
   (DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)
 VALUES (S_DD_TJ_TIPO_JUICIO.NEXTVAL, 'PCM', 'P. Cambiario', 'P. Cambiario', 0, 'MOD_PROC', 
 			SYSDATE, 0, (SELECT dd_tpo_id FROM dd_tpo_tipo_procedimiento dd WHERE dd.dd_tpo_codigo = 'P17'));
 			
COMMIT;
