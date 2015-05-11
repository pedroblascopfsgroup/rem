-- ampliar la table PC_COT_COLUMNS_EXP_TAR para poner una operación de negocio
ALTER TABLE PC_COT_COLUMNS_EXP_TAR ADD(FLOW_CLICK VARCHAR2(500CHAR));

-- ampliar la table PC_COT_COLUMNS_EXP_TAR para poner una operación de negocio
ALTER TABLE PC_COT_COLUMNS_EXP_TAR ADD(TAR_PANEL VARCHAR2(20 CHAR));

-- insertar las columnas de la tabla resumen

Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK)
 Values
   (22, 'N.', 1, 'nivel', 150, 'left', '1', 1, 'RES', '0','plugin.panelControl.letrados');
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK)
 Values
   (23, 'T.E.', 4, 'totalExpedientes', 150, 'left', '1', 2, 'RES', '0','plugin.panelControl.letrados.asuntos');
   
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,TYPE)
 Values
   (24, 'I.', 5, 'importe', 150, 'left', '1', 3, 'RES', '0','numero');
 
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (25, 'T.V.', 6, 'tareasVencidas', 150, 'left', '1', 4, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','TV');   
        
 
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (26, 'T.P.H.', 7, 'tareasPendientesHoy', 150, 'left', '1', 5, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','PH');   
  
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (27, 'T.P.S.', 8, 'tareasPendientesSemana', 150, 'left', '1', 6, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','PS');   
  
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (28, 'T.P.M.', 9, 'tareasPendientesMes', 150, 'left', '1', 7, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','PM');   
 
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (29, 'T.P.M.M.', 10, 'tareasPendientesMasMes', 150, 'left', '1', 8, 'RES', '0','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','PMM');   
  
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (30, 'T.P.M.A.', 11, 'tareasPendientesMasAnyo', 150, 'left', '1', 9, 'RES', '1','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','PA');   
 
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (31, 'T.F.Ay.', 12, 'tareasFinalizadasAyer', 150, 'left', '1', 10, 'RES', '1','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','FH');   
    
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (32, 'T.F.S.', 13, 'tareasFinalizadasSemana', 150, 'left', '1', 11, 'RES', '1','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','FS');   
 
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (33, 'T.F.M.', 14, 'tareasFinalizadasMes', 150, 'left', '1', 11, 'RES', '1','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','FM');   
 
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (34, 'T.F.A.', 15, 'tareasFinalizadasAnyo', 150, 'left', '1', 11, 'RES', '1','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','FA');   
  
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN,FLOW_CLICK,TAR_PANEL)
 Values
   (35, 'T.F.M.A', 16, 'tareasFinalizadas', 150, 'left', '1', 12, 'RES', '1','plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas','TF');   
  
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (36, 'idNivel', 17, 'id', 150, 'left', '1', 12, 'RES', '1');   
  
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (37, 'cod', 18, 'cod', 150, 'left', '1', 14, 'RES', '1'); 
   
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN)
 Values
   (38, 'userName', 19, 'userName', 150, 'left', '1', 15, 'RES', '1');   
    
     
   
-- modificar la consulta de la vista de resumen para que se adapte también a los requisitos de santander
DROP TABLE SCF01.V_PC_COT_EXP_TAR_RESUMEN CASCADE CONSTRAINTS;

CREATE MATERIALIZED VIEW scf01.V_PC_COT_EXP_TAR_RESUMEN AS
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


   
   
   