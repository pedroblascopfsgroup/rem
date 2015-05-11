/*
1. se han modificado las vistas materializadas del panel de control. Buscar el script de creación.

2. Se añade un nuevo campo a la tabla que contiene la información sobre las columnas de los grids del panel de control. 

Campo ETIQUETA: contien la etiqueta que se va a mostrar en los checks de la pestaña Columnas del filtro del panel de control.

*/
--SE DEBE EJECUTAR TANTO EN SCF01 COMO EN SOR01

ALTER TABLE SCF01.PC_COT_COLUMNS_EXP_TAR
ADD (ETIQUETA VARCHAR2(200 BYTE));

ALTER TABLE SOR01.PC_COT_COLUMNS_EXP_TAR
ADD (ETIQUETA VARCHAR2(200 BYTE));

/*
Insertar las columnas de la tabla resumen. 
Esquema:SOR01
Es posible que estas filas ya existan, habrá que borrarlas. Delete from PC_COT_COLUMNS_EXP_TAR where COL_ID >= 22 and col_ID <=43
Para SCF01. ver más abajo.
 */

Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, ETIQUETA)
 Values
   (22, 'Nivel', 1, 'nivel', 150, 'left', '1', 1, 'RES', '0', 'plugin.panelControl.letrados', 'Nivel');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, ETIQUETA)
 Values
   (23, 'Total Contratos', 2, 'totalExpedientes', 150, 'left', '1', 2, 'RES', '0', 'plugin.panelControl.letrados.asuntos', 'Total Contratos');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, TYPE, ETIQUETA)
 Values
   (24, 'Importe total', 3, 'importe', 150, 'left', '1', 3, 'RES', '0', 'numero', 'Importe Total');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (25, 'Venc. más 6 meses', 4, 'vencidasMas6Meses', 150, 'left', '1', 4, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'VM6M', 'Tareas Vencidas más de 6 Meses');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (40, 'Venc 6 Meses', 5, 'vencidas6Meses', 150, 'left', '1', 5, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'V6M', 'Tareas Vencidas 6 Meses');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (26, 'Venc 5 meses', 6, 'vencidas5Meses', 150, 'left', '1', 6, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'V5M', 'Tareas Vencidas 5 Meses');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (27, 'Venc 4 meses', 7, 'vencidas4Meses', 150, 'left', '1', 7, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'V4M', 'Tareas Vencidas 4 Meses');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (28, 'Venc 3 meses', 8, 'vencidas3Meses', 150, 'left', '1', 8, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'V3M', 'Tareas Vencidas 3 Meses');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (29, 'Venc 2 meses', 9, 'vencidas2Meses', 150, 'left', '1', 9, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'V2M', 'Tareas Vencidas 2 Meses');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (30, 'Venc 1 mes', 10, 'vencidas1Mes', 150, 'left', '1', 10, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'V1M', 'Tareas Vencidas 1 Mes');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (31, 'Venc semana', 11, 'vencidasSemana', 150, 'left', '1', 11, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'VS', 'Tareas Vencidas 1 Semana');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (32, 'Ptes. Hoy', 12, 'tareasPendientesHoy', 150, 'left', '1', 12, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'PH', 'Tareas Pendientes Hoy');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (33, 'Ptes Semana', 13, 'tareasPendientesSemana', 150, 'left', '1', 13, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'PS', 'Tareas Pendientes 1 Semana');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (34, 'Ptes Mes', 14, 'tareasPendientesMes', 150, 'left', '1', 14, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'PM', 'Tareas Pendientes 1 Mes');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (35, 'Ptes 2 Meses', 15, 'tareasPendientes2Meses', 150, 'left', '1', 15, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'P2M', 'Tareas Pendientes 2 Meses');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (36, 'Ptes 3 Meses', 16, 'tareasPendientes3Meses', 150, 'left', '1', 16, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'P3M', 'Tareas Pendientes 3 Meses');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (37, 'Ptes 4 Meses', 17, 'tareasPendientes4Meses', 150, 'left', '1', 17, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'P4M', 'Tareas Pendientes 4 Meses');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (38, 'Ptes 5 Meses', 18, 'tareasPendientes5Meses', 150, 'left', '1', 18, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'P5M', 'Tareas Pendientes 5 Meses');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (39, 'Ptes más 6 Meses', 19, 'tareasPendientesMas6Meses', 150, 'left', '1', 19, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'PM6', 'Tareas Pendientes más de 6 Meses');
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

/*
Insertar las columnas de la tabla resumen. 
Esquema:SCF01
Es posible que estas filas ya existan, habrá que borrarlas. Delete from PC_COT_COLUMNS_EXP_TAR where COL_ID >= 22 and col_ID <=43
 */



SET DEFINE OFF;
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, ETIQUETA)
 Values
   (22, 'N.', 1, 'nivel', 150, 'left', '1', 1, 'RES', '0', 'plugin.panelControl.letrados', 'N.: Nivel');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, ETIQUETA)
 Values
   (23, 'T.E.', 4, 'totalExpedientes', 150, 'left', '1', 2, 'RES', '0', 'plugin.panelControl.letrados.asuntos', 'T.E.: Total Expedientes');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, TYPE, ETIQUETA)
 Values
   (24, 'I.', 5, 'importe', 150, 'left', '1', 3, 'RES', '0', 'numero', 'I.: Importe total');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (25, 'T.V.', 6, 'tareasVencidas', 150, 'left', '1', 4, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'TV', 'T.V.: Tareas vencidas');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (26, 'T.P.H.', 7, 'tareasPendientesHoy', 150, 'left', '1', 5, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'PH', 'T.P.H.: Tareas pendientes hoy');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (27, 'T.P.S.', 8, 'tareasPendientesSemana', 150, 'left', '1', 6, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'PS', 'T.P.S.: Tareas pendientes semana');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (28, 'T.P.M.', 9, 'tareasPendientesMes', 150, 'left', '1', 7, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'PM', 'T.P.M.: Tareas pendientes mes');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (29, 'T.P.M.M.', 10, 'tareasPendientesMasMes', 150, 'left', '1', 8, 'RES', '0', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'PMM', 'T.P.M.M.: Tareas pendientes más de un mes');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (30, 'T.P.M.A.', 11, 'tareasPendientesMasAnyo', 150, 'left', '1', 9, 'RES', '1', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'PA', 'T.P.M.A.: Tareas pendientes más de un año');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (31, 'T.F.Ay.', 12, 'tareasFinalizadasAyer', 150, 'left', '1', 10, 'RES', '1', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'FH', 'T.F.Ay.: Tareas finalizadas ayer');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (32, 'T.F.S.', 13, 'tareasFinalizadasSemana', 150, 'left', '1', 11, 'RES', '1', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'FS', 'T.F.S.: Tareas finalizadas semana');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (33, 'T.F.M.', 14, 'tareasFinalizadasMes', 150, 'left', '1', 11, 'RES', '1', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'FM', 'T.F.M.: Tareas finalizadas mes');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (34, 'T.F.A.', 15, 'tareasFinalizadasAnyo', 150, 'left', '1', 11, 'RES', '1', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'FA', 'T.F.A.: Tareas finalizadas año');
Insert into PC_COT_COLUMNS_EXP_TAR
   (COL_ID, HEADER, COL_INDEX, DATAINDEX, WIDTH, ALIGN, SORTABLE, ORDEN, FORMULARIO, HIDDEN, FLOW_CLICK, TAR_PANEL, ETIQUETA)
 Values
   (35, 'T.F.M.A', 16, 'tareasFinalizadas', 150, 'left', '1', 12, 'RES', '1', 'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas', 'TF', 'T.F.M.A.: Tareas finalizadas más de un año');
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
COMMIT;
