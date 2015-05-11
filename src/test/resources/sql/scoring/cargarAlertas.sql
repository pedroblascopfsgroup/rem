-- Alertas
-- Per 1, tipo alerta 1, los 3 nvl de gravedad
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (10,1,1,1,1,1,1,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (11,1,1,1,1,1,2,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (12,1,1,1,1,1,3,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);

-- Per 2, tipo alerta 3, los 3 nvl de gravedad
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (20,2,2,1,1,3,1,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (21,2,2,1,1,3,2,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (22,2,2,1,1,3,3,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);

-- Per 13, tipo alerta 2, 2 nvl de gravedad
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (30,13,13,1,1,2,1,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (31,13,13,1,1,2,3,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);

-- Per 12, tipo alerta 1, 2 nvl de gravedad
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (40,12,12,1,1,1,2,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (41,12,12,1,1,1,3,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);

-- Per 5, tipo alerta 2, 1 nvl de gravedad
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (50,5,5,1,1,2,2,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);

-- Per 6, tipo alerta 2, los 3 nvl de gravedad
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (60,6,6,1,1,2,1,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (61,6,6,1,1,2,2,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (62,6,6,1,1,2,3,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);

-- Per 7, tipo alerta 3, los 3 nvl de gravedad
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (70,7,7,1,1,3,1,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (71,7,7,1,1,3,2,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (72,7,7,1,1,3,3,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);

-- Per 9, tipo alerta 2, los 2 nvl de gravedad
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (80,9,9,1,1,2,1,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);
INSERT INTO ALE_ALERTAS (ale_id,per_id,cnt_id,ofi_id_cnt,ofi_id_ale,tal_id,ngr_id,ale_fecha_extraccion,ale_fecha_carga,ale_fichero_carga,ale_activo,usuariocrear,fechacrear,borrado)
VALUES (81,9,9,1,1,2,2,${sql.function.curdate},${sql.function.curdate},'dummyFile',1,'testuser',${sql.function.curdate},0);

INSERT INTO FRC_FICHEROS_CARGADOS (FRC_ID,DD_TFI_ID,FRC_ULTIMO,FRC_FECHA_EXTRACCION,USUARIOCREAR,FECHACREAR,BORRADO)
VALUES (1,2,1,${sql.function.curdate},'testuser',${sql.function.curdate},0);