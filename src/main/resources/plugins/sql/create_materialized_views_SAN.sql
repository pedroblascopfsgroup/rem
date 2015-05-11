
/*

-- CREAR GESTORES DE ASUNTOS

Insert into SORMASTER.USU_USUARIOS
   (USU_ID, ENTIDAD_ID, USU_USERNAME, USU_PASSWORD, USU_NOMBRE,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO, USU_EXTERNO, USU_FECHA_VIGENCIA_PASS)
 Values
   (SORMASTER.S_USU_USUARIOS.NEXTVAL, 1, '62130', '62130', '62130', 0, 'diana', SYSDATE, 0, 1, SYSDATE+1000);
   
   
Insert into SORMASTER.USU_USUARIOS
   (USU_ID, ENTIDAD_ID, USU_USERNAME, USU_PASSWORD, USU_NOMBRE,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO, USU_EXTERNO, USU_FECHA_VIGENCIA_PASS)
 Values
   (SORMASTER.S_USU_USUARIOS.NEXTVAL, 1, '63068', '63068', '63068', 0, 'diana', SYSDATE, 0, 1, SYSDATE+1000); 

Insert into SORMASTER.USU_USUARIOS
   (USU_ID, ENTIDAD_ID, USU_USERNAME, USU_PASSWORD, USU_NOMBRE,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO, USU_EXTERNO, USU_FECHA_VIGENCIA_PASS)
 Values
   (SORMASTER.S_USU_USUARIOS.NEXTVAL, 1, '63065', '63065', '63065', 0, 'diana', SYSDATE, 0, 1, SYSDATE+1000);  

Insert into SORMASTER.USU_USUARIOS
   (USU_ID, ENTIDAD_ID, USU_USERNAME, USU_PASSWORD, USU_NOMBRE,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO, USU_EXTERNO, USU_FECHA_VIGENCIA_PASS)
 Values
   (SORMASTER.S_USU_USUARIOS.NEXTVAL, 1, '62271', '62271', '62271', 0, 'diana', SYSDATE, 0, 1, SYSDATE+1000); 

Insert into SORMASTER.USU_USUARIOS
   (USU_ID, ENTIDAD_ID, USU_USERNAME, USU_PASSWORD, USU_NOMBRE,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO, USU_EXTERNO, USU_FECHA_VIGENCIA_PASS)
 Values
   (SORMASTER.S_USU_USUARIOS.NEXTVAL, 1, '62131', '62131', '62131', 0, 'diana', SYSDATE, 0, 1, SYSDATE+1000);

Insert into SORMASTER.USU_USUARIOS
   (USU_ID, ENTIDAD_ID, USU_USERNAME, USU_PASSWORD, USU_NOMBRE,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO, USU_EXTERNO, USU_FECHA_VIGENCIA_PASS)
 Values
   (SORMASTER.S_USU_USUARIOS.NEXTVAL, 1, '63066', '63066', '63066', 0, 'diana', SYSDATE, 0, 1, SYSDATE+1000);   
COMMIT;


-- zonificar los usuarios

Insert into ZON_PEF_USU
   (ZON_ID, PEF_ID, USU_ID, ZPU_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (8201, 701, (select usu_id from sormaster.usu_usuarios where usu_username='62130'), s_ZON_PEF_USU.nextval, 0, 'diana', sysdate, 0);
   
Insert into ZON_PEF_USU
   (ZON_ID, PEF_ID, USU_ID, ZPU_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (8201, 701, (select usu_id from sormaster.usu_usuarios where usu_username='63068'), s_ZON_PEF_USU.nextval, 0, 'diana', sysdate, 0);

Insert into ZON_PEF_USU
   (ZON_ID, PEF_ID, USU_ID, ZPU_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (8201, 701, (select usu_id from sormaster.usu_usuarios where usu_username='63065'), s_ZON_PEF_USU.nextval, 0, 'diana', sysdate, 0);

Insert into ZON_PEF_USU
   (ZON_ID, PEF_ID, USU_ID, ZPU_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (8201, 701, (select usu_id from sormaster.usu_usuarios where usu_username='62271'), s_ZON_PEF_USU.nextval, 0, 'diana', sysdate, 0);

Insert into ZON_PEF_USU
   (ZON_ID, PEF_ID, USU_ID, ZPU_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (8201, 701, (select usu_id from sormaster.usu_usuarios where usu_username='62131'), s_ZON_PEF_USU.nextval, 0, 'diana', sysdate, 0);

Insert into ZON_PEF_USU
   (ZON_ID, PEF_ID, USU_ID, ZPU_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (8201, 701, (select usu_id from sormaster.usu_usuarios where usu_username='63066'), s_ZON_PEF_USU.nextval, 0, 'diana', sysdate, 0);   
COMMIT;

-- ASOCIAR USUARIOS A DESPACHO

Insert into USD_USUARIOS_DESPACHOS
   (USD_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_USD_USUARIOS_DESPACHOS.nextval, (select usu_id from sormaster.usu_usuarios where usu_username='62130'), (select des_id from des_despacho_externo where des_despacho='LINDORFF', 0, 0, 0, 'DIANA', SYSDATE, 0);

   
Insert into USD_USUARIOS_DESPACHOS
   (USD_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_USD_USUARIOS_DESPACHOS.nextval, (select usu_id from sormaster.usu_usuarios where usu_username='63068'), (select des_id from des_despacho_externo where des_despacho='LINDORFF', 0, 0, 0, 'DIANA', SYSDATE, 0);
 

Insert into USD_USUARIOS_DESPACHOS
   (USD_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_USD_USUARIOS_DESPACHOS.nextval, (select usu_id from sormaster.usu_usuarios where usu_username='62131'), (select des_id from des_despacho_externo where des_despacho='ESCO EXPANSION', 0, 0, 0, 'DIANA', SYSDATE, 0);
 
Insert into USD_USUARIOS_DESPACHOS
   (USD_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_USD_USUARIOS_DESPACHOS.nextval, (select usu_id from sormaster.usu_usuarios where usu_username='63066'), (select des_id from des_despacho_externo where des_despacho='ESCO EXPANSION', 0, 0, 0, 'DIANA', SYSDATE, 0);
  
 
Insert into USD_USUARIOS_DESPACHOS
   (USD_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_USD_USUARIOS_DESPACHOS.nextval, (select usu_id from sormaster.usu_usuarios where usu_username='62271'), (select des_id from des_despacho_externo where des_despacho='LUCANIA', 0, 0, 0, 'DIANA', SYSDATE, 0);
 
Insert into USD_USUARIOS_DESPACHOS
   (USD_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_USD_USUARIOS_DESPACHOS.nextval, (select usu_id from sormaster.usu_usuarios where usu_username='63065'), (select des_id from des_despacho_externo where des_despacho='LUCANIA', 0, 0, 0, 'DIANA', SYSDATE, 0);
  
   
COMMIT;*/


-- CARTERIZAR LOS ASUNTOS CON EL GESTOR CORRESPONDIENTE
--update /*+BYPASS_UJVC*/(
--SELECT ASU.GAS_ID GESTORASU, USD.USD_ID GESTORCNT  FROM ASU_ASUNTOS ASU
--JOIN CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.EXP_ID=ASU.EXP_ID AND CEX.CEX_PASE=1
--JOIN CNT_CONTRATOS CNT ON CNT.CNT_ID=CEX.CNT_ID
--JOIN TMP_CNT_CONTRATOS TMP ON TMP.TMP_CNT_CONTRATO=CNT.CNT_CONTRATO AND TMP.TMP_CNT_COD_CENTRO=CNT.CNT_COD_CENTRO AND TMP.TMP_CNT_CONTRATO=CNT.CNT_CONTRATO
--JOIN SORMASTER.USU_USUARIOS USU ON USU.USU_USERNAME=TMP.tmp_cnt_cod_extra3
--JOIN USD_USUARIOS_DESPACHOS USD ON USD.USU_ID=USU.USU_ID
--) SET GESTORASU=GESTORCNT;




-- vistas
DROP TABLE LIN01.PC_COT_COLUMNS_EXP_TAR
 CASCADE CONSTRAINTS;

CREATE TABLE LIN01.PC_COT_COLUMNS_EXP_TAR
(
  COL_ID      NUMBER                            NOT NULL,
  HEADER      VARCHAR2(200 BYTE),
  COL_INDEX   NUMBER(16),
  DATAINDEX   VARCHAR2(200 BYTE),
  WIDTH       INTEGER,
  ALIGN       VARCHAR2(200 BYTE),
  SORTABLE    CHAR(1 BYTE)                      DEFAULT 1,
  ORDEN       INTEGER,
  FORMULARIO  VARCHAR2(50 BYTE),
  HIDDEN      CHAR(1 BYTE)                      DEFAULT 1,
  TYPE        VARCHAR2(10 BYTE)
) ;


Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (1, 'SGM', 3, 'asesoria', 150, 'left', '1', 1, 'TAR', '0');
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (2, 'Tarea', 8, 'tarea', 200, 'left', '1',2, 'TAR', '0'); 
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (3, 'Gestor', 4, 'letrado', 100, 'left', '1',3, 'TAR', '0');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (4, 'Estado', 5, 'estado_tarea', 100, 'left', '1',4, 'TAR', '0');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (5, 'En plazo', 6, 'enPlazo', 50, 'left', '1', 5, 'TAR', '1');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (6, 'Días vencida', 7, 'diasVencida', 50, 'right', '1', 6, 'TAR', '0');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (7, 'Num. cnts', 41 ,'numContratos', 50, 'left', '1', 7, 'TAR', '0'); 

Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (8, 'Contrato', 42 , 'codigoContrato', 200, 'right', '1', 8, 'TAR', '0'); 

Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, TYPE)
 Values
   (9, 'Importe', 9 ,'saldo_tarea', 50, 'left', '1', 9, 'TAR', '0','numero');     
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (10, 'Estado procesal', 10, 'camp', 150, 'left', '1', 10, 'TAR', '0');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (11, 'Asunto', 16, 'asunto', 100, 'left', '1', 11, 'TAR', '0');
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (12, 'Id Tarea', 12, 'tar_id', 100, 'left', '1', 12, 'TAR', '1');
   
-- columnas de expedientes   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (13, 'SGM', 3, 'asesoria', 150, 'left', '1', 1, 'EXP', '0');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (14, 'Contrato', 42 , 'codigoContrato', 200, 'right', '1', 2,  'EXP', '0');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (15, 'Nombre', 17, 'nombreAsunto', 200, 'left', '1', 3, 'EXP', '0');

Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (16, 'Gestor', 4, 'letrado', 100, 'left', '1',4, 'EXP', '0');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (17, 'Estado procesal', 10, 'camp', 150, 'left', '1', 5, 'EXP', '0');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (18, 'Supervisor', 21, 'supervisor', 200, 'left', '1', 6, 'EXP', '1');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, TYPE)
 Values
   (19, 'Saldo total', 22, 'saldoTotal', 200, 'left', '1', 7, 'EXP', '0', 'numero');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (20, 'Num cnts', 41 ,'numContratos', 50, 'left', '1', 8, 'EXP', '0');
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, TYPE)
 Values
   (21, 'Fecha de creación', 43, 'fechaEntradaCnt', 100, 'left', '1', 9, 'EXP', '0', 'fecha');
   
commit;   

-- ampliar la table PC_COT_COLUMNS_EXP_TAR para poner una operación de negocio
ALTER TABLE PC_COT_COLUMNS_EXP_TAR ADD(FLOW_CLICK VARCHAR2(500CHAR));

-- ampliar la table PC_COT_COLUMNS_EXP_TAR para poner una operación de negocio
ALTER TABLE PC_COT_COLUMNS_EXP_TAR ADD(TAR_PANEL VARCHAR2(20 CHAR));


-- insertar las columnas de la tabla resumen

Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK)
 Values
   (22, 'Nivel', 1, 'nivel', 150, 'left', '1', 1, 'RES', '0','plugin.panelControl.lindorff');
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK)
 Values
   (23, 'Total Contratos', 2, 'totalExpedientes', 150, 'left', '1', 2, 'RES', '0','plugin.panelControl.letrados.asuntos');
   
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,TYPE)
 Values
   (24, 'Importe total', 3, 'importe', 150, 'left', '1', 3, 'RES', '0','numero');
 
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (25, 'Venc. más 6 meses', 4, 'vencidasMas6Meses', 150, 'left', '1', 4, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','VM6M');   

Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (40, 'Venc 6 Meses', 5, 'vencidas6Meses', 150, 'left', '1',5, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','V6M');   
 
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (26, 'Venc 5 meses', 6, 'vencidas5Meses', 150, 'left', '1', 6, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','V5M');   
 
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (27, 'Venc 4 meses', 7, 'vencidas4Meses', 150, 'left', '1', 7, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','V4M');   
 
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (28, 'Venc 3 meses', 8, 'vencidas3Meses', 150, 'left', '1', 8, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','V3M');   

Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (29, 'Venc 2 meses', 9, 'vencidas2Meses', 150, 'left', '1', 9, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','V2M');   
  
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (30, 'Venc 1 mes', 10, 'vencidas1Mes', 150, 'left', '1', 10, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','V1M');   
 
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (31, 'Venc semana', 11, 'vencidasSemana', 150, 'left', '1', 11, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','VS');    
 
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (32, 'Ptes. Hoy', 12, 'tareasPendientesHoy', 150, 'left', '1', 12, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','PH');   
  
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (33, 'Ptes Semana', 13, 'tareasPendientesSemana', 150, 'left', '1', 13, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','PS');   
  
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (34, 'Ptes Mes', 14, 'tareasPendientesMes', 150, 'left', '1', 14, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','PM');   
 
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (35, 'Ptes 2 Meses', 15, 'tareasPendientes2Meses', 150, 'left', '1', 15, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','P2M');   
  
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (36, 'Ptes 3 Meses', 16, 'tareasPendientes3Meses', 150, 'left', '1', 16, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','P3M');   
  
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (37, 'Ptes 4 Meses', 17, 'tareasPendientes4Meses', 150, 'left', '1', 17, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','P4M');   

Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (38, 'Ptes 5 Meses', 18, 'tareasPendientes5Meses', 150, 'left', '1', 18, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','P5M');   
 
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (39, 'Ptes más 6 Meses', 19, 'tareasPendientesMas6Meses', 150, 'left', '1', 19, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','PM6');   
           	  
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (41, 'idNivel', 20, 'id', 150, 'left', '1', 20, 'RES', '1');   
  
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (42, 'cod', 21, 'cod', 150, 'left', '1', 21, 'RES', '1'); 
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (43, 'userName', 22, 'userName', 150, 'left', '1', 22, 'RES', '1');   
     
COMMIT;

DROP VIEW Sor01.V_PC_CONT_ZON_ZONIFICACION;

/* Formatted on 2012/11/19 18:58 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW sor01.v_pc_cont_zon_zonificacion (niv_id,
                                                               zon_cod,
                                                               zon_id,
                                                               zon_descripcion
                                                              )
AS
   SELECT 303, zon_cod, zon_id, zon_descripcion
     FROM zon_zonificacion where zon_cod='01'
   UNION
   SELECT 304, '01'||des.des_id ,des.des_id, des.des_despacho
     FROM des_despacho_externo des 
     where des.DD_TDE_ID=22 ;
	 
	 
DROP VIEW SOR01.PC_CONTENCIOSO_NIV_NIVELES;

/* Formatted on 2012/11/14 17:35 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW SOR01.pc_contencioso_niv_niveles (niv_id,
                                                               niv_descripcion
                                                              )
AS
   SELECT 303,
           niv_descripcion
     FROM niv_nivel WHERE NIV_ID=301
	UNION 
		SELECT 304, 'SGM'
	FROM DUAL
	UNION 
		SELECT 305,'GESTOR'
	FROM DUAL	;



	
DROP VIEW SOR01.V_PC_CONT_NIV_NIVELES;

/* Formatted on 2012/11/19 19:05 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW SOR01.v_pc_cont_niv_niveles (niv_id,
                                                          niv_descripcion
                                                         )
AS
   SELECT 303,
           niv_descripcion
     FROM niv_nivel WHERE NIV_ID=301
	UNION 
		SELECT 304, 'SGM'
	FROM DUAL
	UNION 
		SELECT 305,'GESTOR'
	FROM DUAL;
	 


DROP MATERIALIZED VIEW SOR01.V_PC_COT_EXP_TAR;

CREATE MATERIALIZED VIEW SOR01.V_PC_COT_EXP_TAR as
SELECT DISTINCT '01'||des.DES_ID zon_cod                                       -- 1
                                   ,
               usu.USU_USERNAME usu_username                                    --2
                                       ,
               ere.SGM_ORIGEN asesoria                               -- 3
                                           ,
               usu.usu_username letrado                          --4
                                                 ,
               ere.ESTADO_TAREA estado_tarea                                   --5
                                        ,
                CASE
                   WHEN ere.FECHA_VENCIMIENTO_TAREA > TRUNC (SYSDATE)
                      THEN 'SI'
                   ELSE 'NO'
                END fin_en_plazo,                                          --6
                  TO_DATE (TRUNC (SYSDATE))
                - TO_DATE (TRUNC (ere.FECHA_VENCIMIENTO_TAREA)) dias_vencida       -- 7
                                                                   ,
                ere.TAREA tipo_tarea                                   --8
                                        ,
                ere.importe saldo_tarea                                              --9
                             ,
                CASE
                   WHEN ere.fase_procesal like '%NO RECLAMABLE%'
                      THEN 'NO RECLAMABLE'
                   WHEN ere.fase_procesal like '%NO DEMANDABLE%'
                      THEN 'NO DEMANDABLE'
                   WHEN ere.fase_procesal like '%ACTIVIDAD PRECONTENCIOSA%'
                      THEN 'ACTIVIDAD PRECONTENCIOSA'
                   ELSE 'ACTIVIDAD CONTENCIOSA'
                END AS campaña                                     -- 10
                                    ,
                asu.exp_id AS expediente                                 -- 11
                                        ,
                ere.TAREA AS tar_id                                   --12
                                       ,
                TO_CHAR (ere.FECHA_VENCIMIENTO_TAREA , 'yyyy') anyo                 --13
                                                         ,
                TO_CHAR (ere.FECHA_VENCIMIENTO_TAREA, 'mm') mes                    --14
                                                      ,
                TO_CHAR (ere.FECHA_VENCIMIENTO_TAREA, 'dd') dia                    --15
                                                      ,
                ere.ASU_ID asu_id                                         --16
                                 ,
                ere.ASU_ID nombre_asunto                             -- 17
                                            ,
                ere.FECHA_ENTRADA_CONTRATO fecha_crear_asunto                -- 18
                                                         ,
                ere.ESTADO_TAREA estado_asuntos                    -- 19
                                                     ,
                ere.codgestor gestor_interno                                 --20
                                         ,
                ere.CODGESTOR supervisor                                    -- 21
                                     ,
                ere.IMPORTE saldo_expediente                                        --22
                                  ,
                ere.SGM_ORIGEN despacho                               --23
                                           ,
                ere.tarea descripcion_tarea, --24
                'Contencioso' tipo_gestion, --25 
                ere.fecha_vencimiento_tarea tar_fecha_venc, --26
                ere.FECHA_VENCIMIENTO_TAREA tar_fecha_venc_real, --27
                CASE
					 WHEN TRUNC (ere.FECHA_VENCIMIENTO_TAREA) >
                                      TRUNC (SYSDATE + 150)
                        THEN 'PM6'
                    WHEN TRUNC (ere.FECHA_VENCIMIENTO_TAREA) >
                                      TRUNC (SYSDATE + 120)
						THEN 'P5M'
                    WHEN TRUNC (ere.FECHA_VENCIMIENTO_TAREA) >
                                       TRUNC (SYSDATE + 90)
                        THEN 'P4M'
                    WHEN TRUNC (ere.FECHA_VENCIMIENTO_TAREA) >
                                       TRUNC (SYSDATE + 60)
						THEN 'P3M'
                    WHEN TRUNC (ere.FECHA_VENCIMIENTO_TAREA) >
                                       TRUNC (SYSDATE + 30)
                        THEN 'P2M'
                    WHEN TRUNC (ere.FECHA_VENCIMIENTO_TAREA) >
                                        TRUNC (SYSDATE + 7)
                        THEN 'PM'
                    WHEN TRUNC (ere.FECHA_VENCIMIENTO_TAREA) >
                                            TRUNC (SYSDATE)
						THEN 'PS'
                    WHEN TRUNC (ere.FECHA_VENCIMIENTO_TAREA) =
                                            TRUNC (SYSDATE)
                        THEN 'PH'
                    WHEN TRUNC (ere.FECHA_VENCIMIENTO_TAREA) >
                                        TRUNC (SYSDATE - 7)
                        THEN 'VS'
                    WHEN TRUNC (ere.FECHA_VENCIMIENTO_TAREA) >
                                       TRUNC (SYSDATE - 30)
						THEN 'V1M'
                    WHEN TRUNC (ere.FECHA_VENCIMIENTO_TAREA) >
                                       TRUNC (SYSDATE - 60)
						THEN 'V2M'
                    WHEN TRUNC (ere.FECHA_VENCIMIENTO_TAREA) >
                                       TRUNC (SYSDATE - 90)
                        THEN 'V3M'
                    WHEN TRUNC (ere.FECHA_VENCIMIENTO_TAREA) >
										TRUNC (SYSDATE - 120)
                        THEN 'V4M'
                    WHEN TRUNC (ere.FECHA_VENCIMIENTO_TAREA) >
                                      TRUNC (SYSDATE - 150)
                        THEN 'V5M'
                    WHEN TRUNC (ere.FECHA_VENCIMIENTO_TAREA ) >
                                      TRUNC (SYSDATE - 180)
                        THEN 'V6M'
                    ELSE 'VM6M'
                END tipo, --28
                ere.TAREA tarea, --29
                ere.IMPORTE saldo_total, --30
                ere.CODGESTOR gestor_externo, --31
                ere.SGM_ORIGEN proveedor, --32
                ere.TIPO_PROCEDIMIENTO tipo_procedimiento,                                   --33
                ere.PRODUCTO cod_prod,                          --34
                ere.EPC_PROC_DESC ultima_accion_rx,            --35
                ere.EPC_PROCESABLE ultima_accion_rx_cod,            --36
                ere.FECHA_ULT_ACC_PROCESABLE fecha_accion,                                 --37        
                ere.EPC_ULT_ACC ultima_anotacion_rx,                        --38
                ere.FECHA_ULT_ACC fecha_anotacion,                                --39
                ere.FECHA_INICIO_TAREA tar_fecha_ini,         --40
                ere.NUM_CNT_ASU numContratos,                                     --41
                lpad(ere.CNT_COD_ENTIDAD,4,0)||lpad(ere.CNT_COD_OFICINA,4.0)||lpad(ere.CNT_CONTRATO,10,0)  codigoContrato,                                --42
                ere.FECHA_ENTRADA_CONTRATO  fechaEntradaCnt,                                --43
                ere.prioridad        
 from ere_envio_revision ere
 JOIN asu_asuntos asu ON asu.asu_id = ere.asu_id
                JOIN sormaster.dd_eas_estado_asuntos eas
                ON eas.dd_eas_id = asu.dd_eas_id
                JOIN USD_USUARIOS_DESPACHOS USD ON USD.USD_ID=ASU.GAS_ID
				JOIN SORMASTER.USU_USUARIOS USU ON USU.USU_ID=USD.USU_ID
                JOIN DES_DESPACHO_EXTERNO DES ON DES.DES_ID=USD.DES_ID
                JOIN
                        (SELECT   asu_id, MAX (tar_id) tar_id
                             FROM tar_tareas_notificaciones
                            WHERE tar_codigo != 3
                         GROUP BY asu_id) tar ON tar.asu_id = asu.asu_id; 

COMMENT ON MATERIALIZED VIEW SOR01.V_PC_COT_EXP_TAR IS 'snapshot table for snapshot SOR01.V_PC_COT_EXP_TAR';


--************************************************************
--*** view V_PC_COT_EXP_TAR_RESUMEN AS ***********************
--************************************************************
drop MATERIALIZED VIEW V_PC_COT_EXP_TAR_RESUMEN;


CREATE MATERIALIZED VIEW V_PC_COT_EXP_TAR_RESUMEN AS
SELECT DISTINCT
USU_USERNAME USU_USERNAME, 					--1
ZON_COD ZON_COD, 							--2
LETRADO LETRADO,							--3
COUNT(EXPEDIENTE) EXPEDIENTE,				--4
 SUM (SALDO_EXPEDIENTE) SALDO_EXPEDIENTE,	--5
 SUM(NUM_TV) NUM_TV,						--6
 SUM(NUM_PM) NUM_PM,						--7
 SUM(NUM_PS) NUM_PS,						--8
 SUM(NUM_PH) NUM_PH,						--9
 SUM(NUM_PMM) NUM_PMM,						--10
 SUM(NUM_PA) NUM_PA,						--11
 SUM(NUM_FH) NUM_FH,						--12
 SUM(NUM_FS) NUM_FS,						--14
 SUM(NUM_FM) NUM_FM,						--15
 SUM(NUM_FA) NUM_FA,						--16
 SUM(NUM_TF) NUM_TF,							--17
 SUM(NUM_VS) NUM_VS,
 SUM(NUM_V1M) NUM_V1M,
 SUM(NUM_V2M) NUM_V2M,
 SUM(NUM_V3M) NUM_V3M,
 SUM(NUM_V4M) NUM_V4M,
 SUM(NUM_V5M) NUM_V5M,
 SUM(NUM_V6M) NUM_V6M,
 SUM(NUM_VM6M) NUM_VM6M,
 SUM(NUM_P2M) NUM_P2M,
 SUM(NUM_P3M) NUM_P3M,
 SUM(NUM_P4M) NUM_P4M,
 SUM(NUM_P5M) NUM_P5M,
 SUM(NUM_PM6) NUM_PM6
 FROM(
        SELECT DISTINCT
        USU_USERNAME USU_USERNAME, 
        ZON_COD ZON_COD,			
        LETRADO LETRADO, 				
        EXPEDIENTE,					
        MAX (SALDO_EXPEDIENTE) SALDO_EXPEDIENTE,
		SUM(DECODE(TIPO,'VS',1,0)) NUM_VS,
		SUM(DECODE(TIPO,'V1M',1,0)) NUM_V1M,
		SUM(DECODE(TIPO,'V2M',1,0)) NUM_V2M,
		SUM(DECODE(TIPO,'V3M',1,0)) NUM_V3M,
		SUM(DECODE(TIPO,'V4M',1,0)) NUM_V4M,
		SUM(DECODE(TIPO,'V5M',1,0)) NUM_V5M,
		SUM(DECODE(TIPO,'V6M',1,0)) NUM_V6M,
		SUM(DECODE(TIPO,'VM6M',1,0)) NUM_VM6M,
        SUM(DECODE(TIPO,'TV',1,0)) NUM_TV,
        SUM(DECODE(TIPO,'PM',1,0)) NUM_PM,
		SUM(DECODE(TIPO,'P2M',1,0)) NUM_P2M,
		SUM(DECODE(TIPO,'P3M',1,0)) NUM_P3M,
		SUM(DECODE(TIPO,'P4M',1,0)) NUM_P4M,
		SUM(DECODE(TIPO,'P5M',1,0)) NUM_P5M,
		SUM(DECODE(TIPO,'PM6',1,0)) NUM_PM6,
        SUM(DECODE(TIPO,'PS',1,0)) NUM_PS,
        SUM(DECODE(TIPO,'PH',1,0)) NUM_PH,
        SUM(DECODE(TIPO,'PMM',1,0)) NUM_PMM,
        SUM(DECODE(TIPO,'PA',1,0)) NUM_PA,
        SUM(DECODE(TIPO,'FH',1,0)) NUM_FH,
        SUM(DECODE(TIPO,'FS',1,0)) NUM_FS,
        SUM(DECODE(TIPO,'FM',1,0)) NUM_FM,
        SUM(DECODE(TIPO,'FA',1,0)) NUM_FA,
        SUM(DECODE(TIPO,'TF',1,0)) NUM_TF
        FROM
        V_PC_COT_EXP_TAR
        GROUP BY
        USU_USERNAME,LETRADO,ZON_COD, EXPEDIENTE
)
GROUP BY USU_USERNAME,LETRADO,ZON_COD;