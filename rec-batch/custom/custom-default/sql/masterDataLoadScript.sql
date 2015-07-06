-- Entidades
INSERT INTO Entidad (id, descripcion,USUARIOCREAR,FECHACREAR)
VALUES (1, 'Entidad de prueba 1','DD',${sql.function.now});
INSERT INTO Entidad (id, descripcion,USUARIOCREAR,FECHACREAR)
VALUES (2, 'Entidad de prueba 2','DD',${sql.function.now});

-- ConfiguraciÃ³n Base de datos de Entidades

-- DB01
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (1, 1, 'workingCode', '1001');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (2, 1, 'jndiName', '${sql.conn.jndi1}');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (3, 1, 'driverClassName', '${sql.conn.driverClassName}');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (4, 1, 'url', '${sql.conn.url1}');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (5, 1, 'username', '${sql.conn.username1}');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (6, 1, 'password', 'admin');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (7, 1, 'initialId', '1');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (8, 1, 'theme', 'slateGreen');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (9, 1, 'logo', 'ciudad_real.gif');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (10, 1, 'schema', '${sql.schema1}');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (21,1,'pathToSqlLoader','C:\\ORACLE\\product\\10.2.0\\server\\BIN\\sqlldr.exe');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (22,1,'connectionInfo','pfs01/admin@PFS');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (23,1,'sqlLoaderParameters','direct=true bindsize=512000 rows=10000');

-- DB02
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (11, 2, 'workingCode', '1002');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (12, 2, 'jndiName', null);
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (13, 2, 'driverClassName', '${sql.conn.driverClassName}');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (14, 2, 'url', '${sql.conn.url2}');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (15, 2, 'username', '${sql.conn.username2}');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (16, 2, 'password', 'admin');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (17, 2, 'initialId', '1');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (18, 2, 'theme', 'slate');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (19, 2, 'logo', 'cajacampo.gif');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (20, 2, 'schema', '${sql.schema2}');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (24,2,'pathToSqlLoader','C:\\ORACLE\\product\\10.2.0\\server\\BIN\\sqlldr.exe');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (25,2,'connectionInfo','pfs02/admin@PFS');
INSERT INTO EntidadConfig (id, entidad_id, dataKey, dataValue)
VALUES (26,2,'sqlLoaderParameters','direct=true bindsize=512000 rows=10000');


-- Usuarios globales
INSERT INTO usu_usuarios (USU_ID, ENTIDAD_ID, USU_username, USU_password, USU_nombre, USU_apellido1, USU_apellido2, USU_mail, USUARIOCREAR, FECHACREAR, version)
VALUES (1, 1, 'admin', 'admin', 'Usuario', 'Administrador', null, 'admin@pfs.es', 'DD', ${sql.function.now}, 1);

-- Usuarios de la entidad 1
INSERT INTO usu_usuarios (USU_ID, ENTIDAD_ID, USU_username, USU_password, USU_nombre, USU_apellido1, USU_apellido2, USU_mail, USUARIOCREAR, FECHACREAR, version)
VALUES (2, 1, 'user11', 'user11', 'Alberto', 'RamÃ­rez', null, 'aramirez@bancaja.es', 'DD', ${sql.function.now}, 1);

INSERT INTO usu_usuarios (USU_ID, ENTIDAD_ID, USU_username, USU_password, USU_nombre, USU_apellido1, USU_apellido2, USU_mail, USUARIOCREAR, FECHACREAR, version)
VALUES (3, 1, 'gestor', 'gestor', 'Esteban', 'RodrÃ­guez', null, 'arridriguez@bancaja.es', 'DD', ${sql.function.now}, 1);

INSERT INTO usu_usuarios (USU_ID, ENTIDAD_ID, USU_username, USU_password, USU_nombre, USU_apellido1, USU_apellido2, USU_mail, USUARIOCREAR, FECHACREAR, version)
VALUES (4, 1, 'comite', 'comite', 'Juan', 'Bosnjak', 'Costa', 'jpbosnjak@bancaja.es', 'DD', ${sql.function.now}, 1);

INSERT INTO usu_usuarios (USU_ID, ENTIDAD_ID, USU_username, USU_password, USU_nombre, USU_apellido1, USU_apellido2, USU_mail, USUARIOCREAR, FECHACREAR, version)
VALUES (5, 1, 'sup21', 'sup21', 'Mariano', 'Pichincha', null, 'marianopi@bancaja.es', 'DD', ${sql.function.now}, 1);

INSERT INTO usu_usuarios (USU_ID, ENTIDAD_ID, USU_username, USU_password, USU_nombre, USU_apellido1, USU_apellido2, USU_mail, USUARIOCREAR, FECHACREAR, version)
VALUES (6, 1, 'supervisor', 'supervisor', 'Esteban', 'RodrÃ­guez', null, 'arridriguez@bancaja.es', 'DD', ${sql.function.now}, 1);

-- Usuarios de la entidad 2
INSERT INTO usu_usuarios (USU_ID, ENTIDAD_ID, USU_username, USU_password, USU_nombre, USU_apellido1, USU_apellido2, USU_mail, USUARIOCREAR, FECHACREAR, version)    
VALUES (7, 2, 'user21', 'user21', 'Roberto', 'MartÃ­nez', 'Torrijo', 'amartinez@caixa.es', 'DD', ${sql.function.now}, 1);


-- FUN_FUNCIONES
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(1,'MENU-LIST-CLI','Listado de Clientes','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(2,'MENU-LIST-EXP','Listado de Expedientes','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(3,'MENU-LIST-ASU','Listado de Asuntos','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(4,'ROLE_ADMIN','Menï¿½ de administrador','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(5,'BUSQUEDA','Menï¿½ Bï¿½squeda','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(6,'ROLE_COMITE','Comitï¿½','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(7,'EDITAR_TITULOS','Editar TÃ­tulos','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(8,'EDITAR_PROCEDIMIENTO','Editar Procedimientos','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(9,'EDITAR_GYA','Editar Gestiï¿½n y Anï¿½lisis','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(10,'CERRAR_DECISION','Cerrar Decisiï¿½n','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(11,'NUEVO_CONTRATO','Nuevo Contrato','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(12,'BORRA_CONTRATO','Borrar Contrato','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(13,'ASIGNAR_ASUNTO','Asignar Asunto','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(14,'COMUNICACION','Generar Tarea','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(15,'RESPONDER','Generar Notificacion','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(16,'EDITAR_SOLVENCIA','ABM de Bienes y Ingresos, y modificaciÃ³n de observaciones solvencia','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(17,'EDITAR_ANTECEDENTES','ABM de antecedentes externos, modificaciÃ³n de observaciones antecedentes','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(18,'NUEVO_TITULO','ABM de titulos','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(19,'BORRA_TITULO','ABM de titulos','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(20,'SOLICITAR_PRORROGA','Solicitar Prï¿½rroga','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(21,'SOLICITAR_EXP_MANUAL','Solicitar Expediente Manual','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(23,'MENU-LIST-ASU','Listado Asuntos','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(25,'MENU-TELECOBRO','Menu de telecobro','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(26,'MENU-ANALISIS','Menu de analisis','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES(27,'EDITAR_UMBRAL','Edita el umbral de deuda por persona para pasar a Expediente','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) 
VALUES (28,'MENU-LIST-CNT','Puede buscar Contratos','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) 
VALUES (29,'EDITAR_GYA_REV','Editar Revisión en Gestión y Análisis','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) 
VALUES (30,'VER_UMBRAL','Visualizar la solapa del umbral','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) 
VALUES (31,'INCLUIR_EXCLUIR_CONTRATOS','Incluir-Excluir contratos en expediente','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) 
VALUES (32,'EXPORTAR_ANALISIS_PDF','Exportar información de análisis global a PDF','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) 
VALUES (33,'TAB-CNT-EXP-ASU','Ver Tab de Expedientes Asuntos en la consulta de contratos','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) 
VALUES (34,'MENU-SCORING-ALERTAS','Menú Scoring y Alertas','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) 
VALUES (35,'VER-SCORING-CLIENTE','Ver el scoring de un cliente','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) 
VALUES (36,'MOSTRAR_VR_TAREAS','Mostrar VR en Listado de Tareas','DD', ${sql.function.now});
INSERT INTO FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) 
VALUES (37,'POLITICA_SUPER','Superusuario de políticas','DD', ${sql.function.now});

--DD_TPR_TIPO_PRORROGA
INSERT INTO DD_TPR_TIPO_PRORROGA (DD_TPR_ID,DD_TPR_CODIGO,DD_TPR_DESCRIPCION,DD_TPR_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) 
VALUES (S_DD_TPR_TIPO_PRORROGA.nextVal,'INT','Primaria / Interna','Primaria / Interna','DD',${sql.function.now});
INSERT INTO DD_TPR_TIPO_PRORROGA (DD_TPR_ID,DD_TPR_CODIGO,DD_TPR_DESCRIPCION,DD_TPR_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) 
VALUES (S_DD_TPR_TIPO_PRORROGA.nextVal,'EXT','Externa','Externa','DD',${sql.function.now});

-- dd_dti_tipo_incidencias
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (1,null,'Error de test',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'test.pruebaError');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (2,null,'Error al insertar nuevos contratos',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaContratos.insertNuevos');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (3,null,'Error al actualizar los contratos con los datos de la tabla temporal',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'carga.contratos.updateDatos');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (4,null,'Error al insertar los saldos de la tabla de contratos de la tabla temporal',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaContratos.insertMovimientos');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (5,null,'Error al insertar las personas de la tabla temporal',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaPersonas.insertNuevos');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (6,null,'Error al actualizar los datos de las personas con los de la tabla temporal',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'carga.personas.updateDatos');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (7,null,'Error al insertar las nuevas direcciones de la tabla temporal',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDirecciones.insertNuevos');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (8,null,'Error al actualizar las direcciones con las de la tabla temporal',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'carga.direcciones.updateDatos');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (9,null,'Error al insertar las relaciones de la tabla temporal',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaRelaciones.insertNuevos');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (10,null,'Error en la descompresin del archivo .zip',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'unzip.FileError');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (11,null,'El archivo TXT de contratos no existe o el nombre es incorrecto',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaContratos.itemReader.fileNotFound');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (12,null,'El archivo TXT de contratos es incorrecto',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaContratos.itemReader.tokenizerError');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (13,null,'Hubo un error al crear el archivo CSV de contratos',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaContratos.itemWriter');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (14,null,'Error al truncar la tabla temporal de contratos',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaContratos.truncateError');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (15,null,'Hubo un error en el gestor de base de datos al analizar la tabla temporal de contratos',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaContratos.');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (16,null,'Error al cargar los datos a la tabla temporal de contratos',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaContratos.dataLoad');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (17,null,'El archivo TXT de personas no existe o el nombre es incorrecto',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaPersonas.itemReader.fileNotFound');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (18,null,'El archivo TXT de personas es incorrecto',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaPersonas.itemReader.tokenizerError');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (19,null,'Hubo un error al crear el archivo CSV de personas',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaPersonas.itemWriter');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (20,null,'Error al truncar la tabla temporal de personas',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaPersonas.truncateError');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (21,null,'Hubo un error en el gestor de base de datos al analizar la tabla temporal de personas',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaPersonas.analizeWarn');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (22,null,'Error al cargar los datos a la tabla temporal de personas',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaPersonas.dataLoad');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (23,null,'El archivo TXT de relaciones no existe o el nombre es incorrecto',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaRelacion.itemReader.fileNotFound');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (24,null,'El archivo TXT de relaciones es incorrecto',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaRelacion.itemReader.tokenizerError');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (25,null,'Hubo un error al crear el archivo CSV de relaciones',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaRelacion.itemWriter');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (26,null,'Error al truncar la tabla temporal de relaciones',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaRelacion.truncateError');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (27,null,'Hubo un error en el gestor de base de datos al analizar la tabla temporal de relaciones',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaRelacion.analizeWarn');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (28,null,'Error al cargar los datos a la tabla temporal de relaciones',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaRelacion.dataLoad');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (29,null,'El archivo TXT de direcciones no existe o el nombre es incorrecto',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDirecciones.itemReader.fileNotFound');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (30,null,'El archivo TXT de direcciones es incorrecto',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDirecciones.itemReader.tokenizerError');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (31,null,'Hubo un error al crear el archivo CSV de direcciones',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDirecciones.itemWriter');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (32,null,'Error al truncar la tabla temporal de direcciones',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDirecciones.truncateError');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (33,null,'Hubo un error en el gestor de base de datos al analizar la tabla temporal de direcciones',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDirecciones.analizeWarn');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (34,null,'Error al cargar los datos a la tabla temporal de direcciones',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDirecciones.dataLoad');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (35,null,'PCR semaphore read error',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'batch.pcr.semreaderror');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (36,null,'Error en la fecha de extraccin de las tablas de carga temporal',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'carga.fechaExtraccion');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (37,null,'Error en la validacin de suma de contratos en la tabla temporal',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaContrato.contractSumValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (38,null,'La cantidad de registros de la tabla temporal de contratos no coincide con la informada en el archivo semforo',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaContrato.countValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (39,'CNT-02','Validacin en la fecha de carga de la tabla temporal de contratos, las fechas no coinciden',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaContrato.loadDateValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (40,'CNT-01','La entidad de la tabla temporal de contratos no corresponde a la de la carga',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaContrato.entityValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (41,null,'La cantidad de registros de la tabla temporal de personas no coincide con la informada en el archivo semforo',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaPersona.validateCount');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (42,'PER-02','Validacin fecha de carga de la tabla temporal de personas, las fechas no coinciden',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaPersona.loadDateValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (43,'PER-01','La entidad de la tabla temporal de personas no corresponde a la de la carga',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaPersona.entityValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (44,null,'La cantidad de registros de la tabla temporal de personas no coincide con la informada en el archivo semforo',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaRelacion.countValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (45,'CNT-PER-01','La entidad de la tabla temporal de relaciones no corresponde a la de la carga',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaRelacion.entityValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (46,'CNT-PER-02','ValidaciÃ³n fecha de carga de la tabla temporal de relaciones, las fechas no coinciden',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaRelacion.loadDateValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (47,'CNT-PER-03','Error en el cdigo de tipo de intervencin en la tabla temporal de relaciones',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaRelacion.intervencionValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (48,null,'Error de integridad en la tabla temporal de relaciones, algunas referencias a las tablas de personas o contratos no existen',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaRelacion.integridadValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (49,null,'Error en la tabla temporal de relaciones, cdigo de oficina incorrecto',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaRelacion.integridadCodOficinaValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (50,'CNT-04','Error en la validacin de carga temp. de contratos, el cdigo de oficina no corresponde',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaContrato.officeCodeValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (51,'CNT-06','Error en la validacin del tipo de moneda en la tabla temporal de contratos',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaContrato.currencyCodeValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (52,'CNT-07','Tipo de producto en tabla temporal de contratos no tiene correspondencia en el diccionario de datos de tipo de productos',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaContrato.productTypeCodeValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (53,'CNT-03','La carga de movimientos que se intenta hacer tiene fecha anterior o igual a la ltima realizada',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaContrato.movementValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (54,'PER-03','El valor del fichero para tipo de persona no tiene correspondencia en el diccionario de datos de tipo de persona',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaPersona.personTypeValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (55,'PER-04','El valor del fichero para tipo de documento no tiene correspondencia en el diccionario de datos de tipo de documentos',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaPersona.documentTypeValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (56,'PER-05','El valor del fichero para segmento del cliente no tiene correspondencia en el diccionario de datos de segmentos del cliente',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaPersona.segmentValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (57,'PER-06','El valor del fichero para cdigo de cliente no tiene relacin alguna con los contratos cargados en el da',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaPersona.personaRelacionValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (58,null,'La cantidad de registros de la tabla temporal de direcciones no coincide con la informada en el archivo semforo',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDirecciones.countValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (65,'DIR-01','La entidad de la tabla temporal de direcciones no corresponde a la de la carga',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDirecciones.entityValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (66,'DIR-02','ValidaciÃ³n fecha de carga de la tabla temporal de direcciones, las fechas no coinciden',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDirecciones.loadDateValidator');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (67,'DIR-03','Error en la tabla temporal de direcciones, cÃ³digo de cliente entidad incorrecto. No existe en la tabla de personas',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDirecciones.validarPersona');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (68,'DIR-04','Error en la tabla temporal de direcciones, cÃ³digo de vï¿½a incorrecto. No existe en la tabla de tipos de vï¿½a',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDirecciones.validarVia');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (69,'DIR-05','Error en la tabla temporal de direcciones, cÃ³digo de provincia incorrecto. No existe en la tabla de provincias',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDirecciones.validarProvincia');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (70,'DIR-06','Error en la tabla temporal de direcciones, cÃ³digo de localidad incorrecto. No existe en la tabla de localidades',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDirecciones.validarLocalidad');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (72,null,'Error actualizando registros de direcciones',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDirecciones.updateDatos');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (73,null,'NÃºmero BAJO de registros de contrato activos a cargar',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDatosValidator.activoLineasBajo');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (74,null,'NÃºmero ALTO de registros de contrato activos a cargar',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDatosValidator.activoLineasAlto');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (75,null,'La suma de los contratos activos con posiciÃ³n vencida a cargar es BAJA',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDatosValidator.activoPosicionVencidaBajo');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (76,null,'La suma de los contratos activos con posiciÃ³n vencida a cargar es ALTA',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDatosValidator.activoPosicionVencidaAlto');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (77,null,'La suma de los contratos activos con posiciÃ³n viva a cargar es BAJA',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDatosValidator.activoPosicionVivaBajo');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (78,null,'La suma de los contratos activos con posiciÃ³n viva a cargar es ALTA',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDatosValidator.activoPosicionVivaAlta');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (79,null,'NÃºmero BAJO de registros de contrato pasivos a cargar',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDatosValidator.pasivoLineasBajo');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (80,null,'NÃºmero ALTO de registros de contrato pasivos a cargar',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDatosValidator.pasivoLineasAlto');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (81,null,'La suma de los contratos pasivos con posiciÃ³n vencida a cargar es BAJA',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDatosValidator.pasivoPosicionVencidaBajo');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (82,null,'La suma de los contratos pasivos con posiciÃ³n vencida a cargar es ALTO',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDatosValidator.pasivoPosicionVencidaAlto');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (83,null,'La suma de los contratos pasivos con posiciÃ³n viva a cargar es BAJO',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDatosValidator.pasivoPosicionVivaBajo');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO)
VALUES (84,null,'La suma de los contratos pasivos con posiciÃ³n viva a cargar es ALTO',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDatosValidator.pasivoPosicionVivaAlto');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO) 
VALUES (85,null,'No se pudo descomprimir el fichero zip',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'unzip.errorUnziping');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO) 
VALUES (86,null,'El archivo TXT de direcciones es incorrecto',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDireccion.itemReader.tokenizerError');
INSERT INTO DD_DTI_TIPO_INCIDENCIAS (DTI_ID,DTI_DESCRIPCION,DTI_DESCRIPCION_LARGA,DTI_PATRON,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTI_CODIGO) 
VALUES (87,null,'Hubo un error al crear el archivo CSV de direcciones',null,'BATCH_USER',${sql.function.now},null,null,null,null,0,'cargaDireccion.itemWriter');
-- dd_dti_tipo_incidencias_lg

-- dd_ein_entidad_informacion
INSERT INTO DD_EIN_ENTIDAD_INFORMACION (DD_EIN_ID,DD_EIN_CODIGO,DD_EIN_DESCRIPCION,DD_EIN_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (1,'1','Cliente','Cliente','DD',${sql.function.now});
INSERT INTO DD_EIN_ENTIDAD_INFORMACION (DD_EIN_ID,DD_EIN_CODIGO,DD_EIN_DESCRIPCION,DD_EIN_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (2,'2','Expediente','Expediente','DD',${sql.function.now});
INSERT INTO DD_EIN_ENTIDAD_INFORMACION (DD_EIN_ID,DD_EIN_CODIGO,DD_EIN_DESCRIPCION,DD_EIN_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (3,'3','Asunto','Asunto','DD',${sql.function.now});
INSERT INTO DD_EIN_ENTIDAD_INFORMACION (DD_EIN_ID,DD_EIN_CODIGO,DD_EIN_DESCRIPCION,DD_EIN_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (4,'4','Tarea','Tarea Relacionada','DD',${sql.function.now});
INSERT INTO DD_EIN_ENTIDAD_INFORMACION (DD_EIN_ID,DD_EIN_CODIGO,DD_EIN_DESCRIPCION,DD_EIN_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (5,'5','Procedimiento','Procedimiento Relacionado','DD',${sql.function.now});


-- dd_ein_entidad_informacion_lg

-- dd_esc_estado_cnt
INSERT INTO DD_ESC_ESTADO_CNT (DD_ESC_ID,DD_ESC_CODIGO,DD_ESC_DESCRIPCION,DD_ESC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) 
VALUES (1,'4','Activo','Activo','DD',${sql.function.now});
INSERT INTO DD_ESC_ESTADO_CNT (DD_ESC_ID,DD_ESC_CODIGO,DD_ESC_DESCRIPCION,DD_ESC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) 
VALUES (2,'5','Suspendido','Suspendido','DD',${sql.function.now});
INSERT INTO DD_ESC_ESTADO_CNT (DD_ESC_ID,DD_ESC_CODIGO,DD_ESC_DESCRIPCION,DD_ESC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) 
VALUES (3,'6','Vencido','Vencido','DD',${sql.function.now});
INSERT INTO DD_ESC_ESTADO_CNT (DD_ESC_ID,DD_ESC_CODIGO,DD_ESC_DESCRIPCION,DD_ESC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) 
VALUES (4,'7','Cancelado','Cancelado','DD',${sql.function.now});


-- dd_esc_estado_cnt_lng

-- dd_est_estados_itinerarios
INSERT INTO DD_EST_ESTADOS_ITINERARIOS (DD_EST_ID,DD_EIN_ID,DD_EST_ORDEN,DD_EST_CODIGO,DD_EST_DESCRIPCION,DD_EST_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (1,1,1,'CAR','Gestin de Vencidos Carencia','Gestin de Vencidos Carencia','DD',${sql.function.now});
INSERT INTO DD_EST_ESTADOS_ITINERARIOS (DD_EST_ID,DD_EIN_ID,DD_EST_ORDEN,DD_EST_CODIGO,DD_EST_DESCRIPCION,DD_EST_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (2,1,2,'GV','Gestin de Vencidos','Gestin de Vencidos','DD',${sql.function.now});
INSERT INTO DD_EST_ESTADOS_ITINERARIOS (DD_EST_ID,DD_EIN_ID,DD_EST_ORDEN,DD_EST_CODIGO,DD_EST_DESCRIPCION,DD_EST_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (3,2,3,'CE','Completar Expediente','Completar Expediente','DD',${sql.function.now});
INSERT INTO DD_EST_ESTADOS_ITINERARIOS (DD_EST_ID,DD_EIN_ID,DD_EST_ORDEN,DD_EST_CODIGO,DD_EST_DESCRIPCION,DD_EST_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (4,2,4,'RE','Revisar Expediente','Revisar Expediente','DD',${sql.function.now});
INSERT INTO DD_EST_ESTADOS_ITINERARIOS (DD_EST_ID,DD_EIN_ID,DD_EST_ORDEN,DD_EST_CODIGO,DD_EST_DESCRIPCION,DD_EST_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (5,2,5,'DC','Decisin Comit','Decisin Comit','DD',${sql.function.now});
INSERT INTO DD_EST_ESTADOS_ITINERARIOS (DD_EST_ID,DD_EIN_ID,DD_EST_ORDEN,DD_EST_CODIGO,DD_EST_DESCRIPCION,DD_EST_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (6,3,6,'AS','Asunto','Asunto','DD',${sql.function.now});
-- dd_est_estados_itinerarios_lg
-- dd_prv_provincia
INSERT INTO DD_PRV_PROVINCIA (DD_PRV_ID, DD_PRV_CODIGO,DD_PRV_DESCRIPCION,DD_PRV_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (1,1,'lava','lava','DD',${sql.function.now});
INSERT INTO DD_PRV_PROVINCIA (DD_PRV_ID, DD_PRV_CODIGO,DD_PRV_DESCRIPCION,DD_PRV_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (2,2,'Albacete','Albacete','DD',${sql.function.now});
INSERT INTO DD_PRV_PROVINCIA (DD_PRV_ID, DD_PRV_CODIGO,DD_PRV_DESCRIPCION,DD_PRV_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (3,3,'Alicante','Alicante','DD',${sql.function.now});
INSERT INTO DD_PRV_PROVINCIA (DD_PRV_ID, DD_PRV_CODIGO,DD_PRV_DESCRIPCION,DD_PRV_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (4,4,'Almeria','Almeria','DD',${sql.function.now});

-- dd_prv_provincia_lg
-- dd_loc_localidad
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (1,01,'0014','Alegra-Dulantzi','Alegra-Dulantzi','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (2,01,'0029','Amurrio','Amurrio','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (3,01,'0493','Aana','Aana','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (4,01,'0035','Aramaio','Aramaio','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (5,01,'0066','Armin','Armin','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (6,01,'0376','Arraia-Maeztu','Arraia-Maeztu','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (7,01,'0088','Arrazua-Ubarrundia','Arrazua-Ubarrundia','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (8,01,'0040','Artziniega','Artziniega','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (9,01,'0091','Asparrena','Asparrena','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (10,01,'0105','Ayala/Aiara','Ayala/Aiara','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (11,01,'0112','Baos de Ebro/Maueta','Baos de Ebro/Maueta','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (12,01,'0133','Barrundia','Barrundia','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (13,01,'0148','Berantevilla','Berantevilla','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (14,01,'0164','Bernedo','Bernedo','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (15,01,'0170','Campezo/Kanpezu','Campezo/Kanpezu','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (16,01,'0210','Elburgo/Burgelu','Elburgo/Burgelu','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (17,01,'0225','Elciego','Elciego','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (18,01,'0231','Elvillar/Bilar','Elvillar/Bilar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (19,01,'0565','Harana/Valle de Arana','Harana/Valle de Arana','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (20,01,'9015','Irua Oka/Irua de Oca','Irua Oka/Irua de Oca','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (21,01,'0278','Iruraiz-Gauna','Iruraiz-Gauna','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (22,01,'0199','Kripan','Kripan','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (23,01,'0203','Kuartango','Kuartango','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (24,01,'0284','Labastida/Bastida','Labastida/Bastida','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (25,01,'0301','Lagrn','Lagrn','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (26,01,'0318','Laguardia','Laguardia','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (27,01,'0323','Lanciego/Lantziego','Lanciego/Lantziego','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (28,01,'9020','Lantarn','Lantarn','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (29,01,'0339','Lapuebla de Labarca','Lapuebla de Labarca','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (30,01,'0360','Laudio/Llodio','Laudio/Llodio','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (31,01,'0587','Legutiano','Legutiano','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (32,01,'0344','Leza','Leza','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (33,01,'0395','Moreda de lava','Moreda de lava','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (34,01,'0416','Navaridas','Navaridas','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (35,01,'0421','Okondo','Okondo','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (36,01,'0437','Oyn-Oion','Oyn-Oion','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (37,01,'0442','Peacerrada-Urizaharra','Peacerrada-Urizaharra','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (38,01,'0468','Ribera Alta','Ribera Alta','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (39,01,'0474','Ribera Baja/Erribera Beitia','Ribera Baja/Erribera Beitia','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (40,01,'0513','Salvatierra/Agurain','Salvatierra/Agurain','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (41,01,'0528','Samaniego','Samaniego','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (42,01,'0534','San Milln/Donemiliaga','San Milln/Donemiliaga','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (43,01,'0549','Urkabustaiz','Urkabustaiz','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (44,01,'0552','Valdegova/Gaubea','Valdegova/Gaubea','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (45,01,'0571','Villabuena de lava/Eskuernaga','Villabuena de lava/Eskuernaga','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (46,01,'0590','Vitoria-Gasteiz','Vitoria-Gasteiz','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (47,01,'0604','Ycora/Iekora','Ycora/Iekora','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (48,01,'0611','Zalduondo','Zalduondo','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (49,01,'0626','Zambrana','Zambrana','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (50,01,'0186','Zigoitia','Zigoitia','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (51,01,'0632','Zuia','Zuia','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (52,02,'0019','Abengibre','Abengibre','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (53,02,'0024','Alatoz','Alatoz','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (54,02,'0030','Albacete','Albacete','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (55,02,'0045','Albatana','Albatana','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (56,02,'0058','Alborea','Alborea','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (57,02,'0061','Alcadozo','Alcadozo','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (58,02,'0077','Alcal del Jcar','Alcal del Jcar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (59,02,'0083','Alcaraz','Alcaraz','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (60,02,'0096','Almansa','Almansa','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (61,02,'0100','Alpera','Alpera','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (62,02,'0117','Ayna','Ayna','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (63,02,'0122','Balazote','Balazote','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (64,02,'0143','Ballestero (El)','Ballestero (El)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (65,02,'0138','Balsa de Ves','Balsa de Ves','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (66,02,'0156','Barrax','Barrax','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (67,02,'0169','Bienservida','Bienservida','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (68,02,'0175','Bogarra','Bogarra','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (69,02,'0181','Bonete','Bonete','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (70,02,'0194','Bonillo (El)','Bonillo (El)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (71,02,'0208','Carceln','Carceln','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (72,02,'0215','Casas de Juan Nez','Casas de Juan Nez','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (73,02,'0220','Casas de Lzaro','Casas de Lzaro','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (74,02,'0236','Casas de Ves','Casas de Ves','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (75,02,'0241','Casas-Ibez','Casas-Ibez','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (76,02,'0254','Caudete','Caudete','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (77,02,'0267','Cenizate','Cenizate','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (78,02,'0292','Chinchilla de Monte-Aragn','Chinchilla de Monte-Aragn','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (79,02,'0273','Corral-Rubio','Corral-Rubio','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (80,02,'0289','Cotillas','Cotillas','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (81,02,'0306','Elche de la Sierra','Elche de la Sierra','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (82,02,'0313','Frez','Frez','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (83,02,'0328','Fuensanta','Fuensanta','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (84,02,'0334','Fuente-lamo','Fuente-lamo','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (85,02,'0349','Fuentealbilla','Fuentealbilla','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (86,02,'0352','Gineta (La)','Gineta (La)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (87,02,'0365','Golosalvo','Golosalvo','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (88,02,'0371','Helln','Helln','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (89,02,'0387','Herrera (La)','Herrera (La)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (90,02,'0390','Higueruela','Higueruela','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (91,02,'0404','Hoya-Gonzalo','Hoya-Gonzalo','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (92,02,'0411','Jorquera','Jorquera','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (93,02,'0426','Letur','Letur','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (94,02,'0432','Lezuza','Lezuza','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (95,02,'0447','Litor','Litor','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (96,02,'0450','Madrigueras','Madrigueras','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (97,02,'0463','Mahora','Mahora','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (98,02,'0479','Masegoso','Masegoso','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (99,02,'0485','Minaya','Minaya','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (100,02,'0498','Molinicos','Molinicos','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (101,02,'0501','Montalvos','Montalvos','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (102,02,'0518','Montealegre del Castillo','Montealegre del Castillo','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (103,02,'0523','Motilleja','Motilleja','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (104,02,'0539','Munera','Munera','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (105,02,'0544','Navas de Jorquera','Navas de Jorquera','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (106,02,'0557','Nerpio','Nerpio','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (107,02,'0560','Ontur','Ontur','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (108,02,'0576','Ossa de Montiel','Ossa de Montiel','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (109,02,'0582','Paterna del Madera','Paterna del Madera','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (110,02,'0609','Peas de San Pedro','Peas de San Pedro','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (111,02,'0595','Peascosa','Peascosa','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (112,02,'0616','Ptrola','Ptrola','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (113,02,'0621','Povedilla','Povedilla','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (114,02,'9010','Pozo Caada','Pozo Caada','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (115,02,'0637','Pozohondo','Pozohondo','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (116,02,'0642','Pozo-Lorente','Pozo-Lorente','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (117,02,'0655','Pozuelo','Pozuelo','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (118,02,'0668','Recueja (La)','Recueja (La)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (119,02,'0674','Ripar','Ripar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (120,02,'0680','Robledo','Robledo','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (121,02,'0693','Roda (La)','Roda (La)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (122,02,'0707','Salobre','Salobre','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (123,02,'0714','San Pedro','San Pedro','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (124,02,'0729','Socovos','Socovos','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (125,02,'0735','Tarazona de la Mancha','Tarazona de la Mancha','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (126,02,'0740','Tobarra','Tobarra','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (127,02,'0753','Valdeganga','Valdeganga','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (128,02,'0766','Vianos','Vianos','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (129,02,'0772','Villa de Ves','Villa de Ves','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (130,02,'0788','Villalgordo del Jcar','Villalgordo del Jcar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (131,02,'0791','Villamalea','Villamalea','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (132,02,'0805','Villapalacios','Villapalacios','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (133,02,'0812','Villarrobledo','Villarrobledo','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (134,02,'0827','Villatoya','Villatoya','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (135,02,'0833','Villavaliente','Villavaliente','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (136,02,'0848','Villaverde de Guadalimar','Villaverde de Guadalimar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (137,02,'0851','Viveros','Viveros','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (138,02,'0864','Yeste','Yeste','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (139,03,'0015','Adsubia','Adsubia','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (140,03,'0020','Agost','Agost','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (141,03,'0036','Agres','Agres','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (142,03,'0041','Aiges','Aiges','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (143,03,'0054','Albatera','Albatera','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (144,03,'0067','Alcalal','Alcalal','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (145,03,'0073','Alcocer de Planes','Alcocer de Planes','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (146,03,'0089','Alcoleja','Alcoleja','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (147,03,'0092','Alcoy/Alcoi','Alcoy/Alcoi','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (148,03,'0106','Alfafara','Alfafara','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (150,03,'0128','Algorfa','Algorfa','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (151,03,'0134','Alguea','Alguea','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (152,03,'0149','Alicante/Alacant','Alicante/Alacant','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (153,03,'0152','Almorad','Almorad','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (154,03,'0165','Almudaina','Almudaina','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (156,03,'0187','Altea','Altea','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (157,03,'0190','Aspe','Aspe','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (158,03,'0204','Balones','Balones','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (159,03,'0211','Banyeres de Mariola','Banyeres de Mariola','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (160,03,'0226','Benasau','Benasau','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (161,03,'0232','Beneixama','Beneixama','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (162,03,'0247','Benejzar','Benejzar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (163,03,'0250','Benferri','Benferri','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (164,03,'0263','Beniarbeig','Beniarbeig','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (165,03,'0279','Beniard','Beniard','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (166,03,'0285','Beniarrs','Beniarrs','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (167,03,'0302','Benidoleig','Benidoleig','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (168,03,'0319','Benidorm','Benidorm','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (169,03,'0324','Benifallim','Benifallim','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (170,03,'0330','Benifato','Benifato','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (171,03,'0298','Benigembla','Benigembla','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (172,03,'0345','Benijfar','Benijfar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (173,03,'0358','Benilloba','Benilloba','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (174,03,'0361','Benillup','Benillup','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (175,03,'0377','Benimantell','Benimantell','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (176,03,'0383','Benimarfull','Benimarfull','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (177,03,'0396','Benimassot','Benimassot','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (178,03,'0400','Benimeli','Benimeli','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (179,03,'0417','Benissa','Benissa','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (180,03,'0422','Benitachell/Poble Nou de Benitatxell (el)','Benitachell/Poble Nou de Benitatxell (el)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (181,03,'0438','Biar','Biar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (182,03,'0443','Bigastro','Bigastro','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (183,03,'0456','Bolulla','Bolulla','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (184,03,'0469','Busot','Busot','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (185,03,'0494','Callosa de Segura','Callosa de Segura','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (187,03,'0475','Calpe/Calp','Calpe/Calp','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (188,03,'0507','Campello (el)','Campello (el)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (189,03,'0514','Campo de Mirra/Camp de Mirra (el)','Campo de Mirra/Camp de Mirra (el)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (190,03,'0529','Caada','Caada','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (191,03,'0535','Castalla','Castalla','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (192,03,'0540','Castell de Castells','Castell de Castells','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (193,03,'0759','Castell de Guadalest (el)','Castell de Guadalest (el)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (194,03,'0553','Catral','Catral','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (195,03,'0566','Cocentaina','Cocentaina','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (196,03,'0572','Confrides','Confrides','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (197,03,'0588','Cox','Cox','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (198,03,'0591','Crevillent','Crevillent','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (199,03,'0612','Daya Nueva','Daya Nueva','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (200,03,'0627','Daya Vieja','Daya Vieja','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (201,03,'0633','Dnia','Dnia','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (202,03,'0648','Dolores','Dolores','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (203,03,'0651','Elche/Elx','Elche/Elx','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (204,03,'0664','Elda','Elda','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (205,03,'0670','Facheca','Facheca','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (206,03,'0686','Famorca','Famorca','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (207,03,'0699','Finestrat','Finestrat','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (208,03,'0778','Fond de les Neus (el)/Hondn de las Nieves','Fond de les Neus (el)/Hondn de las Nieves','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (209,03,'0703','Formentera del Segura','Formentera del Segura','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (210,03,'0725','Gaianes','Gaianes','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (211,03,'0710','Gata de Gorgos','Gata de Gorgos','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (212,03,'0731','Gorga','Gorga','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (213,03,'0746','Granja de Rocamora','Granja de Rocamora','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (214,03,'0762','Guardamar del Segura','Guardamar del Segura','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (215,03,'0784','Hondn de los Frailes','Hondn de los Frailes','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (216,03,'0797','Ibi','Ibi','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (217,03,'0801','Jacarilla','Jacarilla','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (218,03,'0823','Jvea/Xbia','Jvea/Xbia','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (219,03,'0839','Jijona/Xixona','Jijona/Xixona','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (220,03,'0857','Llber','Llber','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (222,03,'0860','Millena','Millena','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (223,03,'0882','Monforte del Cid','Monforte del Cid','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (224,03,'0895','Monvar/Monver','Monvar/Monver','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (225,03,'9037','Montesinos (Los)','Montesinos (Los)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (226,03,'0916','Murla','Murla','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (227,03,'0921','Muro de Alcoy','Muro de Alcoy','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (228,03,'0909','Mutxamel','Mutxamel','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (229,03,'0937','Novelda','Novelda','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (230,03,'0942','Nucia (la)','Nucia (la)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (231,03,'0955','Ondara','Ondara','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (232,03,'0968','Onil','Onil','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (233,03,'0974','Orba','Orba','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (234,03,'0993','Orihuela','Orihuela','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (235,03,'0980','Orxeta','Orxeta','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (236,03,'1007','Parcent','Parcent','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (237,03,'1014','Pedreguer','Pedreguer','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (238,03,'1029','Pego','Pego','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (239,03,'1035','Penguila','Penguila','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (240,03,'1040','Petrer','Petrer','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (241,03,'9021','Pilar de la Horadada','Pilar de la Horadada','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (242,03,'1053','Pins (el)/Pinoso','Pins (el)/Pinoso','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (243,03,'1066','Planes','Planes','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (244,03,'9016','Poblets (els)','Poblets (els)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (245,03,'1072','Polop','Polop','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (246,03,'0605','Quatretondeta','Quatretondeta','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (247,03,'1091','Rafal','Rafal','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (249,03,'1112','Redovn','Redovn','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (250,03,'1127','Relleu','Relleu','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (251,03,'1133','Rojales','Rojales','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (252,03,'1148','Romana (la)','Romana (la)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (253,03,'1151','Sagra','Sagra','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (254,03,'1164','Salinas','Salinas','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (255,03,'1186','San Fulgencio','San Fulgencio','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (256,03,'9042','San Isidro','San Isidro','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (257,03,'1203','San Miguel de Salinas','San Miguel de Salinas','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (258,03,'1225','San Vicente del Raspeig/Sant Vicent del Raspeig','San Vicente del Raspeig/Sant Vicent del Raspeig','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (259,03,'1170','Sanet y Negrals','Sanet y Negrals','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (261,03,'1210','Santa Pola','Santa Pola','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (262,03,'1231','Sax','Sax','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (263,03,'1246','Sella','Sella','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (264,03,'1259','Senija','Senija','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (265,03,'1278','Trbena','Trbena','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (266,03,'1284','Teulada','Teulada','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (267,03,'1297','Tibi','Tibi','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (268,03,'1301','Tollos','Tollos','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (269,03,'1318','Tormos','Tormos','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (270,03,'1323','Torremanzanas/Torre de les Maanes (la)','Torremanzanas/Torre de les Maanes (la)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (271,03,'1339','Torrevieja','Torrevieja','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (273,03,'1360','Vall de Gallinera','Vall de Gallinera','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (274,03,'1376','Vall de Laguar (la)','Vall de Laguar (la)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (276,03,'1382','Verger (el)','Verger (el)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (277,03,'1395','Villajoyosa/Vila Joiosa (la)','Villajoyosa/Vila Joiosa (la)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (278,03,'1409','Villena','Villena','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (279,03,'0818','Xal','Xal','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (280,04,'0010','Abla','Abla','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (281,04,'0025','Abrucena','Abrucena','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (282,04,'0031','Adra','Adra','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (283,04,'0046','Albnchez','Albnchez','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (284,04,'0059','Alboloduy','Alboloduy','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (285,04,'0062','Albox','Albox','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (286,04,'0078','Alcolea','Alcolea','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (287,04,'0084','Alcntar','Alcntar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (288,04,'0097','Alcudia de Monteagud','Alcudia de Monteagud','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (289,04,'0101','Alhabia','Alhabia','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (290,04,'0118','Alhama de Almera','Alhama de Almera','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (291,04,'0123','Alicn','Alicn','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (292,04,'0139','Almera','Almera','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (293,04,'0144','Almcita','Almcita','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (294,04,'0157','Alsodux','Alsodux','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (295,04,'0160','Antas','Antas','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (296,04,'0176','Arboleas','Arboleas','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (297,04,'0182','Armua de Almanzora','Armua de Almanzora','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (298,04,'0195','Bacares','Bacares','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (299,04,'0209','Bayrcal','Bayrcal','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (300,04,'0216','Bayarque','Bayarque','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (301,04,'0221','Bdar','Bdar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (302,04,'0237','Beires','Beires','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (303,04,'0242','Benahadux','Benahadux','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (304,04,'0268','Benitagla','Benitagla','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (305,04,'0274','Benizaln','Benizaln','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (306,04,'0280','Bentarique','Bentarique','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (307,04,'0293','Berja','Berja','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (308,04,'0307','Canjyar','Canjyar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (309,04,'0314','Cantoria','Cantoria','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (310,04,'0329','Carboneras','Carboneras','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (311,04,'0335','Castro de Filabres','Castro de Filabres','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (312,04,'0366','Chercos','Chercos','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (313,04,'0372','Chirivel','Chirivel','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (314,04,'0340','Cbdar','Cbdar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (315,04,'0353','Cuevas del Almanzora','Cuevas del Almanzora','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (316,04,'0388','Dalas','Dalas','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (317,04,'9026','Ejido (El)','Ejido (El)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (318,04,'0412','Enix','Enix','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (319,04,'0433','Felix','Felix','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (320,04,'0448','Fines','Fines','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (321,04,'0451','Fiana','Fiana','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (322,04,'0464','Fondn','Fondn','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (323,04,'0470','Gdor','Gdor','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (324,04,'0486','Gallardos (Los)','Gallardos (Los)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (325,04,'0499','Garrucha','Garrucha','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (326,04,'0502','Grgal','Grgal','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (327,04,'0519','Hucija','Hucija','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (328,04,'0524','Hurcal de Almera','Hurcal de Almera','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (329,04,'0530','Hurcal-Overa','Hurcal-Overa','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (330,04,'0545','Illar','Illar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (331,04,'0558','Instincin','Instincin','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (332,04,'0561','Laroya','Laroya','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (333,04,'0577','Lujar de Andarax','Lujar de Andarax','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (334,04,'0583','Ljar','Ljar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (335,04,'0596','Lubrn','Lubrn','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (336,04,'0600','Lucainena de las Torres','Lucainena de las Torres','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (337,04,'0617','Lcar','Lcar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (338,04,'0622','Macael','Macael','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (339,04,'0638','Mara','Mara','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (340,04,'0643','Mojcar','Mojcar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (341,04,'9032','Mojonera (La)','Mojonera (La)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (342,04,'0656','Nacimiento','Nacimiento','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (343,04,'0669','Njar','Njar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (344,04,'0675','Ohanes','Ohanes','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (345,04,'0681','Olula de Castro','Olula de Castro','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (346,04,'0694','Olula del Ro','Olula del Ro','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (347,04,'0708','Oria','Oria','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (348,04,'0715','Padules','Padules','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (349,04,'0720','Partaloa','Partaloa','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (350,04,'0736','Paterna del Ro','Paterna del Ro','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (351,04,'0741','Pechina','Pechina','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (352,04,'0754','Pulp','Pulp','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (353,04,'0767','Purchena','Purchena','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (354,04,'0773','Rgol','Rgol','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (355,04,'0789','Rioja','Rioja','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (356,04,'0792','Roquetas de Mar','Roquetas de Mar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (357,04,'0806','Santa Cruz de Marchena','Santa Cruz de Marchena','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (358,04,'0813','Santa Fe de Mondjar','Santa Fe de Mondjar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (359,04,'0828','Sens','Sens','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (360,04,'0834','Sern','Sern','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (361,04,'0849','Sierro','Sierro','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (362,04,'0852','Somontn','Somontn','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (363,04,'0865','Sorbas','Sorbas','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (364,04,'0871','Sufl','Sufl','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (365,04,'0887','Tabernas','Tabernas','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (366,04,'0890','Taberno','Taberno','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (367,04,'0904','Tahal','Tahal','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (368,04,'0911','Terque','Terque','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (369,04,'0926','Tjola','Tjola','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (370,04,'9011','Tres Villas (Las)','Tres Villas (Las)','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (371,04,'0932','Turre','Turre','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (372,04,'0947','Turrillas','Turrillas','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (373,04,'0950','Uleila del Campo','Uleila del Campo','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (374,04,'0963','Urrcal','Urrcal','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (375,04,'0979','Velefique','Velefique','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (376,04,'0985','Vlez-Blanco','Vlez-Blanco','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (377,04,'0998','Vlez-Rubio','Vlez-Rubio','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (378,04,'1002','Vera','Vera','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (379,04,'1019','Viator','Viator','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (380,04,'1024','Vcar','Vcar','DD',${sql.function.now});
INSERT INTO DD_LOC_LOCALIDAD (DD_LOC_ID,DD_PRV_ID,DD_LOC_CODIGO,DD_LOC_DESCRIPCION,DD_LOC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (381,04,'1030','Zurgena','Zurgena','DD',${sql.function.now});

-- dd_loc_localidad_lg
-- dd_mon_monedas
INSERT INTO DD_MON_MONEDAS (DD_MON_ID,DD_MON_CODIGO,DD_MON_DESCRIPCION,DD_MON_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (1,'1','Dirham','Dirham de los Emiratos Arabes Unidos','DD',${sql.function.now});
INSERT INTO DD_MON_MONEDAS (DD_MON_ID,DD_MON_CODIGO,DD_MON_DESCRIPCION,DD_MON_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (2,'2','Euro','Comunidad Economica Europea','DD',${sql.function.now});

-- dd_mon_monedas_lg

-- dd_rpr_razon_prorroga
INSERT INTO DD_RPR_RAZON_PRORROGA (DD_RPR_ID,DD_RPR_CODIGO,DD_RPR_DESCRIPCION,DD_RPR_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,DD_TPR_ID) 
VALUES (S_DD_RPR_RAZON_PRORROGA.nextVal,'1','Aceptada','Aceptada','DD',${sql.function.now},(SELECT dd_tpr_id FROM DD_TPR_TIPO_PRORROGA where dd_tpr_codigo = 'INT'));
INSERT INTO DD_RPR_RAZON_PRORROGA (DD_RPR_ID,DD_RPR_CODIGO,DD_RPR_DESCRIPCION,DD_RPR_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,DD_TPR_ID) 
VALUES (S_DD_RPR_RAZON_PRORROGA.nextVal,'2','Denegada – Muy Urgente','Denegada – Muy Urgente','DD',${sql.function.now},(SELECT dd_tpr_id FROM DD_TPR_TIPO_PRORROGA where dd_tpr_codigo = 'INT'));
INSERT INTO DD_RPR_RAZON_PRORROGA (DD_RPR_ID,DD_RPR_CODIGO,DD_RPR_DESCRIPCION,DD_RPR_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,DD_TPR_ID) 
VALUES (S_DD_RPR_RAZON_PRORROGA.nextVal,'3','Denegada – Causa Incorrecta','Denegada – Causa Incorrecta','DD',${sql.function.now},(SELECT dd_tpr_id FROM DD_TPR_TIPO_PRORROGA where dd_tpr_codigo = 'INT'));
INSERT INTO DD_RPR_RAZON_PRORROGA (DD_RPR_ID,DD_RPR_CODIGO,DD_RPR_DESCRIPCION,DD_RPR_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,DD_TPR_ID) 
VALUES (S_DD_RPR_RAZON_PRORROGA.nextVal,'4','Denegada – Otros motivos','Denegada – Otros motivos','DD',${sql.function.now},(SELECT dd_tpr_id FROM DD_TPR_TIPO_PRORROGA where dd_tpr_codigo = 'INT'));
INSERT INTO dd_rpr_razon_prorroga (DD_RPR_ID, DD_RPR_CODIGO,DD_RPR_DESCRIPCION,DD_RPR_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,DD_TPR_ID) 
VALUES (S_DD_RPR_RAZON_PRORROGA.nextval,'5','Denegago, falta documentacin','Denegago, falta documentacin','DD',${sql.function.now},(SELECT dd_tpr_id FROM DD_TPR_TIPO_PRORROGA where dd_tpr_codigo = 'INT'));
INSERT INTO dd_rpr_razon_prorroga (DD_RPR_ID, DD_RPR_CODIGO,DD_RPR_DESCRIPCION,DD_RPR_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,DD_TPR_ID) 
VALUES (S_DD_RPR_RAZON_PRORROGA.nextval,'6','Reincidente','Reincidente','DD',${sql.function.now},(SELECT dd_tpr_id FROM DD_TPR_TIPO_PRORROGA where dd_tpr_codigo = 'INT'));

-- dd_rpr_razon_prorroga_lg
-- dd_tar_tipo_tarea_base
INSERT INTO DD_TAR_TIPO_TAREA_BASE (DD_TAR_ID,DD_TAR_CODIGO,DD_TAR_DESCRIPCION,DD_TAR_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (1,'1','Tarea','Tarea','DD',${sql.function.now});
INSERT INTO DD_TAR_TIPO_TAREA_BASE (DD_TAR_ID,DD_TAR_CODIGO,DD_TAR_DESCRIPCION,DD_TAR_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (3,'3','NotifiaciÃ³n','NotifiaciÃ³n','DD',${sql.function.now});
-- dd_tar_tipo_tarea_base_lg
-- dd_sta_subtipo_tarea_base
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (1,1,'1','GV','Gestin de Vencidos',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (2,1,'2','CE','Completar Expediente',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (3,1,'3','RE','Revisar Expediente',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (4,1,'4','DC','Decisin Comit',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (5,1,'5','Solicitar Prorroga CE','Solicitar Prorroga CE',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (6,1,'6','Solicitar Prorroga RE','Solicitar Prorroga RE',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (7,3,'7','Notificacin Contrato Cancelado','Notificacin Contrato Cancelado',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (8,3,'8','Notificacin Saldo Reducido','Notificacin Saldo Reducido',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (9,3,'9','Notificacin Cliente cancelado','Notificacin Cliente cancelado',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (10,3,'10','Notificacin Expediente cerrado','Notificacin Expediente cerrado',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (11,3,'11','Notificacin Contrato pagado','Notificacin Contrato pagado',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (12,3,'12','Notificacion CE Vencida','Notificacion Tarea Completar Expediente Vencida',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (13,3,'13','Notificacion RE Vencida','Notificacion Tarea Revision Expediente Vencida',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (14,3,'14','Notificacion DC Vencida','Notificacion Tarea Decision Comite Vencida',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (15,3,'15','Notificacion Comunicacion','Notificacion Comunicacion respondida',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (16,1,'16','Comunicacion','Comunicacion Pendiente de Respuesta',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (17,1,'17','Solicitud Cancelar Expediente','Solicitud Cancelacion Expediente',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (18,3,'18','Solic Canc Expe rechazada','Solicitud Cancelacion Expediente Rechazada',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (19,1,'19','Tarea CE Completada','Tarea Completar Expediente Completada',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (20,1,'20','Tarea RE Completada','Tarea Revision Expediente Completada',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (21,3,'21','Notif Solic Prorroga CE Rechazada','Notificacion Solicitud Prorroga CE Rechazada',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (22,3,'22','Notif Solic Prorroga RE Rechazada','Notificacion Solicitud Prorroga RE Rechazada',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (23,3,'23','Notif Cierre sesiï¿½n comitï¿½','NotificaciÃ³n de cierre de sesiï¿½n del comitï¿½',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (24,3,'24','Comunicacion','NotificaciÃ³n de Comunicacion sin Respuesta',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (25,3,'25','Notif Expediente Decidido','NotificaciÃ³n de Expediente Decidido',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (26,3,'26','Comunicacion de Supervisor','NotificaciÃ³n de Comunicacion sin Respuesta enviada por Supervisor',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (27,3,'27','Notificacion Comunicacion de Gestor','Notificacion Comunicacion respondida enviada por Gestor',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (28,1,'28','Comunicacion de Supervisor','Comunicacion Pendiente de Respuesta enviada por Supervisor',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (29,1,'29','Solicitud Expediente Manual','Pedido al Supervisor de Expediente Manual',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (30,1,'30','Solicitud de Preasunto','Pedido al Comite de confirmacion de un preasunto',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (31,1,'31','Verificar Telecobro','Verificar si el cliente tendrï¿½ telecobro',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (32,1,'32','Solicitud exclusiï¿½n de telecobro','Confirmar exclusiï¿½n del cliente de telecobro',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (33,3,'33','Respuesta solicitud exclusiï¿½n de telecobro','Respuesta solicitud exclusiï¿½n del cliente de telecobro',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (34,1,'34','Solicitud de cancelaciÃ³n de Expediente Rechazada','Solicitud de cancelaciÃ³n de Expediente Rechazada',1,'DD',${sql.function.now});

INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (35,1,'35','RecopilaciÃ³n de documentos','RecopilaciÃ³n de documentos',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (36,1,'36','AceptaciÃ³n asunto gestor','AceptaciÃ³n asunto gestor',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (37,1,'37','AceptaciÃ³n asunto supervisor','AceptaciÃ³n asunto supervisor',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (38,1,'38','Asunto Propuesto','Asunto Propuesto',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (39,1,'39','Tarea externa de Gestor', 'Tarea externa de Gestor',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (40,1,'40','Tarea externa de supervisor', 'Tarea externa de supervisor',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (41,1,'41','Solicitar Prorroga PRC','Solicitar Prorroga Procedimiento',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (42,3,'42','Notif Solic Prorroga PRC Rechazada','Notificacion Solicitud Prorroga Procedimiento Rechazada',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (43,1,'43','Actualizar estado recurso','Actualizar estado recurso (Gestor)',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (44,1,'44','Actualizar estado recurso','Actualizar estado recurso (Supervisor)',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (45,3,'45','NotificaciÃ³n de recurso','NotificaciÃ³n de recurso',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (46,1,'46','Tomar Decisiï¿½n de Continuidad','Tomar Decisiï¿½n de Continuidad en procedimiento',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (47,3,'47','Propuesta Decision Procedimiento','Propuesta Decision Procedimiento',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (48,3,'48','Aceptacion/Rechazo Decision Procedimiento','Aceptacion/Rechazo Decision Procedimiento',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (49,1,'49','Acuerdo Propuesto','Acuerdo Propuesto',0,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (50,3,'50','AcuerdoRechazado','Acuerdo Rechazado',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (51,1,'51','Gestiones para el cierre del acuerdo','Gestiones para el cierre del acuerdo',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (52,3,'52','Acuerdo Cerrado','Acuerdo Cerrado',0,'DD',${sql.function.now});

-- Subtipos para los procesos judiciales
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (101,1,'101','Interpos. demanda de tï¿½t. + marcado de bienes','InterposiciÃ³n de la demanda de tÃ­tulos + marcado de bienes',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (102,1,'102','Auto despacho ejec. + Marcado bienes dec. embargo','Auto despacho ejecuciÃ³n + Marcado bienes decreto embargo',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (103,1,'103','Registrar AnotaciÃ³n en Registro','Registrar AnotaciÃ³n en Registro',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (104,1,'104','Confirmar notificaciÃ³n','Confirmar notificaciÃ³n',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (105,1,'105','Registrar oposiciÃ³n vista','Registrar oposiciÃ³n vista',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (106,1,'106','ï¿½Hay vista?','ï¿½Hay vista?',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (107,1,'107','Registrar vista','Registrar vista',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (108,1,'108','Registrar resoluciÃ³n','Registrar resoluciÃ³n',1,'DD',${sql.function.now});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (109,1,'109','ResoluciÃ³n firme','ResoluciÃ³n firme',1,'DD',${sql.function.now});

INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (201,1,'201','Solicitar la notificaciÃ³n ret. pagador','Solicitar la notificaciÃ³n ret. pagador',1,'DD',${sql.function.curdate});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (202,1,'202','Confirmar retenciones','Confirmar retenciones',1,'DD',${sql.function.curdate});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (203,1,'203','Gestionar problemas de retenciÃ³n','Gestionar problemas de retenciÃ³n',1,'DD',${sql.function.curdate});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (204,1,'204','Actualizar datos solvencia cliente','Actualizar datos solvencia cliente',0,'DD',${sql.function.curdate});

INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (301,1,'301','Elaborar y enviar liquidaciÃ³n de intereses','Elaborar y enviar liquidaciÃ³n de intereses',1,'DD',${sql.function.curdate});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (302,1,'302','Solicitud de liquidaciÃ³n de intereses','Solicitud de liquidaciÃ³n de intereses',0,'DD',${sql.function.curdate});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (303,1,'303','Registrar resoluciÃ³n','Registrar resoluciÃ³n',0,'DD',${sql.function.curdate});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (304,1,'304','Confirmar notificaciÃ³n','Confirmar notificaciÃ³n',0,'DD',${sql.function.curdate});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (305,1,'305','Registrar ImpugnaciÃ³n','Registrar ImpugnaciÃ³n',0,'DD',${sql.function.curdate});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (306,1,'306','Registrar vista','Registrar vista',0,'DD',${sql.function.curdate});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (307,1,'307','Registrar resoluciÃ³n 2','Registrar resoluciÃ³n 2',0,'DD',${sql.function.curdate});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (308,1,'308','ResoluciÃ³n firme','ResoluciÃ³n firme',0,'DD',${sql.function.curdate});

INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (401,1,'401','Sol. de subasta + Estim. de costas','Solicitud de subasta + EstimaciÃ³n de costas',0,'DD',${sql.function.curdate});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (402,1,'402','Dictar instrucciones','Dictar instrucciones',1,'DD',${sql.function.curdate});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (403,1,'403','Lectura y acep. de instrucciones','Lectura y aceptaciÃ³n de instrucciones',1,'DD',${sql.function.curdate});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (404,1,'404','Anuncio de subasta','Anuncio de subasta',1,'DD',${sql.function.curdate});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (405,1,'405','CelebraciÃ³n subasta','CelebraciÃ³n subasta',1,'DD',${sql.function.curdate});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (406,1,'406','Solicitud mandamiento de pago','Solicitud mandamiento de pago',1,'DD',${sql.function.curdate});
INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (407,1,'407','Cobro','Cobro',1,'DD',${sql.function.curdate});

INSERT INTO DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID,DD_TAR_ID, DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR)
VALUES (501,1,'501','Solicitud Expediente Manual Seguimiento','Pedido al Supervisor de Expediente Manual de Seguimiento',0,'DD',${sql.function.curdate});



-- dd_sta_subtipo_tarea_base_lg
-- dd_sti_situacion
INSERT INTO DD_STI_SITUACION (DD_STI_ID, DD_STI_CODIGO, DD_STI_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(1, '1','NINGUNO', 1,'BATCHUSER',${sql.function.now},0);
-- dd_sti_situacion_lg
-- dd_taa_tipo_ayuda_actuacion
INSERT INTO DD_TAA_TIPO_AYUDA_ACTUACION
VALUES(1,'1','Tipo ayuda 1','Tipo de ayuda 1',1,'BATCHUSER',${sql.function.now},null,null,null,null,0);
INSERT INTO DD_TAA_TIPO_AYUDA_ACTUACION
VALUES(2,'2','Tipo ayuda 2','Tipo de ayuda 2',1,'BATCHUSER',${sql.function.now},null,null,null,null,0);
-- dd_taa_tipo_ayuda_actuacion_lg
-- dd_tac_tipo_actuacion
-- dd_tac_tipo_actuacion_lg
-- dd_tbi_tipo_bien
INSERT INTO DD_TBI_TIPO_BIEN (DD_TBI_ID,DD_TBI_CODIGO,DD_TBI_DESCRIPCION,DD_TBI_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (1,'1','Piso','Piso','DD',${sql.function.now});
INSERT INTO DD_TBI_TIPO_BIEN (DD_TBI_ID,DD_TBI_CODIGO,DD_TBI_DESCRIPCION,DD_TBI_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (2,'2','Finca Rstica','Finca Rstica','DD',${sql.function.now});
INSERT INTO DD_TBI_TIPO_BIEN (DD_TBI_ID,DD_TBI_CODIGO,DD_TBI_DESCRIPCION,DD_TBI_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (3,'3','Coche','Coche','DD',${sql.function.now});
INSERT INTO DD_TBI_TIPO_BIEN (DD_TBI_ID,DD_TBI_CODIGO,DD_TBI_DESCRIPCION,DD_TBI_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (4,'4','Moto','Moto','DD',${sql.function.now});
-- dd_tbi_tipo_bien_lg
-- dd_tdi_tipo_documento_id
INSERT INTO DD_TDI_TIPO_DOCUMENTO_ID (DD_TDI_ID,DD_TDI_CODIGO,DD_TDI_DESCRIPCION,DD_TDI_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (1,'NIF','NIF','Numero Identificacin Fiscal','DD',${sql.function.now});
INSERT INTO DD_TDI_TIPO_DOCUMENTO_ID (DD_TDI_ID,DD_TDI_CODIGO,DD_TDI_DESCRIPCION,DD_TDI_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (2,'CIF','CIF','Codigo Identificacin Fiscal','DD',${sql.function.now});
INSERT INTO DD_TDI_TIPO_DOCUMENTO_ID (DD_TDI_ID,DD_TDI_CODIGO,DD_TDI_DESCRIPCION,DD_TDI_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (3,'NIE','NIE','NIE','DD',${sql.function.now});
INSERT INTO DD_TDI_TIPO_DOCUMENTO_ID (DD_TDI_ID,DD_TDI_CODIGO,DD_TDI_DESCRIPCION,DD_TDI_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (4,'Pas','Pasaporte','Pasaporte','DD',${sql.function.now});
-- dd_tdi_tipo_documento_id_lg
-- dd_tga_tipo_garantia
-- dd_tga_tipo_garantia_lg
-- dd_tig_tipo_ingreso
INSERT INTO DD_TIG_TIPO_INGRESO (DD_TIG_ID,DD_TIG_CODIGO,DD_TIG_DESCRIPCION,DD_TIG_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (1,'1','Ninguno','Ninguno','DD',${sql.function.now});
INSERT INTO DD_TIG_TIPO_INGRESO (DD_TIG_ID,DD_TIG_CODIGO,DD_TIG_DESCRIPCION,DD_TIG_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (2,'2','Nmina','Nmina','DD',${sql.function.now});
INSERT INTO DD_TIG_TIPO_INGRESO (DD_TIG_ID,DD_TIG_CODIGO,DD_TIG_DESCRIPCION,DD_TIG_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (3,'3','Seguro Desempleo','Seguro Desempleo','DD',${sql.function.now});

-- dd_tig_tipo_ingreso_lg
-- dd_tpe_tipo_persona
INSERT INTO DD_TPE_TIPO_PERSONA (DD_TPE_ID,DD_TPE_CODIGO,DD_TPE_DESCRIPCION,DD_TPE_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (1,'1','Fisica','Persona Fisica','DD',${sql.function.now});
INSERT INTO DD_TPE_TIPO_PERSONA (DD_TPE_ID,DD_TPE_CODIGO,DD_TPE_DESCRIPCION,DD_TPE_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (2,'2','Juridica','Persona Fisica','DD',${sql.function.now});
-- dd_tpe_tipo_persona_lg
-- dd_tpr_tipo_procedimiento
-- dd_tpr_tipo_procedimiento_lg
-- dd_tre_tipo_reclamacion
-- dd_tre_tipo_reclamacion_lg
-- dd_tti_tipo_titulo
INSERT INTO DD_TTG_TIPO_TIT_GEN(DD_TTG_ID, DD_TTG_CODIGO, DD_TTG_DESCRIPCION, DD_TTG_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (1,'1','Titulo','Titulo','DD',${sql.function.now});
INSERT INTO DD_TTG_TIPO_TIT_GEN(DD_TTG_ID, DD_TTG_CODIGO, DD_TTG_DESCRIPCION, DD_TTG_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (2,'2','Garantï¿½a','Garantï¿½a','DD',${sql.function.now});

INSERT INTO DD_TTI_TIPO_TITULO (DD_TTI_ID,DD_TTI_CODIGO,DD_TTI_DESCRIPCION,DD_TTI_DESCRIPCION_LARGA,DD_TTG_ID,USUARIOCREAR,FECHACREAR)
VALUES (1,'1','Ninguno','Ninguno',1, 'DD',${sql.function.now});
INSERT INTO DD_TTI_TIPO_TITULO (DD_TTI_ID,DD_TTI_CODIGO,DD_TTI_DESCRIPCION,DD_TTI_DESCRIPCION_LARGA,DD_TTG_ID,USUARIOCREAR,FECHACREAR)
VALUES (2,'2','Pagar','Pagar',1, 'DD',${sql.function.now});
INSERT INTO DD_TTI_TIPO_TITULO (DD_TTI_ID,DD_TTI_CODIGO,DD_TTI_DESCRIPCION,DD_TTI_DESCRIPCION_LARGA,DD_TTG_ID,USUARIOCREAR,FECHACREAR)
VALUES (3,'3','Escritura','Escritura',2, 'DD',${sql.function.now});
INSERT INTO DD_TTI_TIPO_TITULO (DD_TTI_ID,DD_TTI_CODIGO,DD_TTI_DESCRIPCION,DD_TTI_DESCRIPCION_LARGA,DD_TTG_ID,USUARIOCREAR,FECHACREAR)
VALUES (4,'4','Aval','Aval',2, 'DD',${sql.function.now});
-- dd_tti_tipo_titulo_lg
-- dd_tvi_tipo_via
INSERT INTO DD_TVI_TIPO_VIA (DD_TVI_ID,DD_TVI_CODIGO,DD_TVI_DESCRIPCION,DD_TVI_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (1,'Calle','Calle','','DD',${sql.function.now});
INSERT INTO DD_TVI_TIPO_VIA (DD_TVI_ID,DD_TVI_CODIGO,DD_TVI_DESCRIPCION,DD_TVI_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (2,'Avenida','Avenida','','DD',${sql.function.now});
INSERT INTO DD_TVI_TIPO_VIA (DD_TVI_ID,DD_TVI_CODIGO,DD_TVI_DESCRIPCION,DD_TVI_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (3,'Plaza','Plaza','','DD',${sql.function.now});
INSERT INTO DD_TVI_TIPO_VIA (DD_TVI_ID,DD_TVI_CODIGO,DD_TVI_DESCRIPCION,DD_TVI_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (4,'Boulevard','Boulevard','','DD',${sql.function.now});
-- dd_tvi_tipo_via_lg

-- dd_fmg_fases_mapa_global

INSERT INTO dd_fmg_fases_mapa_global (DD_FMG_ID, DD_FMG_CODIGO, DD_FMG_DESCRIPCION, USUARIOCREAR, FECHACREAR,BORRADO)
VALUES(1, 'NORMAL', 'Normal', 'BATCH', ${sql.function.now},0);
INSERT INTO dd_fmg_fases_mapa_global (DD_FMG_ID, DD_FMG_CODIGO, DD_FMG_DESCRIPCION, USUARIOCREAR, FECHACREAR,BORRADO)
VALUES(2, 'PRIMARIA', 'Primaria', 'BATCH', ${sql.function.now},0);
INSERT INTO dd_fmg_fases_mapa_global (DD_FMG_ID, DD_FMG_CODIGO, DD_FMG_DESCRIPCION, USUARIOCREAR, FECHACREAR,BORRADO)
VALUES(3, 'INTERNA', 'Interna', 'BATCH', ${sql.function.now},0);
INSERT INTO dd_fmg_fases_mapa_global (DD_FMG_ID, DD_FMG_CODIGO, DD_FMG_DESCRIPCION, USUARIOCREAR, FECHACREAR,BORRADO)
VALUES(4, 'EXTERNA', 'Externa', 'BATCH', ${sql.function.now},0);

-- dd_smg_subfases_mapa_global; 
INSERT INTO dd_smg_subfases_mapa_global(DD_SMG_ID,DD_FMG_ID, DD_SMG_CODIGO, DD_SMG_DESCRIPCION, DD_SMG_ORDEN, USUARIOCREAR, FECHACREAR)
VALUES(1,1, 'NV', 'No Vencido',1,'DD', ${sql.function.now});
INSERT INTO dd_smg_subfases_mapa_global(DD_SMG_ID,DD_FMG_ID, DD_SMG_CODIGO, DD_SMG_DESCRIPCION, DD_SMG_ORDEN, USUARIOCREAR, FECHACREAR)
VALUES(2,1, 'CAR', 'Período de Carencia',2,'DD', ${sql.function.now});
INSERT INTO dd_smg_subfases_mapa_global(DD_SMG_ID,DD_FMG_ID, DD_SMG_CODIGO, DD_SMG_DESCRIPCION, DD_SMG_ORDEN, USUARIOCREAR, FECHACREAR)
VALUES(3,2, 'GV15', 'Gestión Vencido menos 15 días',3,'DD', ${sql.function.now});
INSERT INTO dd_smg_subfases_mapa_global(DD_SMG_ID,DD_FMG_ID, DD_SMG_CODIGO, DD_SMG_DESCRIPCION, DD_SMG_ORDEN, USUARIOCREAR, FECHACREAR)
VALUES(4,2,'GV15-30','Gestión Vencido 15-30 días',4,'DD', ${sql.function.now});
INSERT INTO dd_smg_subfases_mapa_global(DD_SMG_ID,DD_FMG_ID, DD_SMG_CODIGO, DD_SMG_DESCRIPCION, DD_SMG_ORDEN, USUARIOCREAR, FECHACREAR)
VALUES(5,2,'GV30-60','Gestión Vencido 30-60 días',5,'DD', ${sql.function.now});
INSERT INTO dd_smg_subfases_mapa_global(DD_SMG_ID,DD_FMG_ID, DD_SMG_CODIGO, DD_SMG_DESCRIPCION, DD_SMG_ORDEN, USUARIOCREAR, FECHACREAR)
VALUES(6,2,'GV60','Gestión Vencido más 60 días',6,'DD', ${sql.function.now});
INSERT INTO dd_smg_subfases_mapa_global(DD_SMG_ID,DD_FMG_ID, DD_SMG_CODIGO, DD_SMG_DESCRIPCION, DD_SMG_ORDEN, USUARIOCREAR, FECHACREAR)
VALUES(7,2, 'CE', 'Completar Expediente',7,'DD', ${sql.function.now});
INSERT INTO dd_smg_subfases_mapa_global(DD_SMG_ID,DD_FMG_ID, DD_SMG_CODIGO, DD_SMG_DESCRIPCION, DD_SMG_ORDEN, USUARIOCREAR, FECHACREAR)
VALUES(8,3,'RE','Revisar Expediente',8,'DD', ${sql.function.now});
INSERT INTO dd_smg_subfases_mapa_global(DD_SMG_ID,DD_FMG_ID, DD_SMG_CODIGO, DD_SMG_DESCRIPCION, DD_SMG_ORDEN, USUARIOCREAR, FECHACREAR)
VALUES(9,3, 'DC', 'Decisión Comité',9,'DD', ${sql.function.now});
INSERT INTO dd_smg_subfases_mapa_global(DD_SMG_ID,DD_FMG_ID, DD_SMG_CODIGO, DD_SMG_DESCRIPCION, DD_SMG_ORDEN, USUARIOCREAR, FECHACREAR)
VALUES(10,4, 'CA', 'Amistosa',10,'DD', ${sql.function.now});
INSERT INTO dd_smg_subfases_mapa_global(DD_SMG_ID,DD_FMG_ID, DD_SMG_CODIGO, DD_SMG_DESCRIPCION, DD_SMG_ORDEN, USUARIOCREAR, FECHACREAR)
VALUES(11,4, 'CJ', 'Judicial',11,'DD', ${sql.function.now});
INSERT INTO dd_smg_subfases_mapa_global(DD_SMG_ID,DD_FMG_ID, DD_SMG_CODIGO, DD_SMG_DESCRIPCION, DD_SMG_ORDEN, USUARIOCREAR, FECHACREAR)
VALUES(12,4, 'CSC', 'Soc. Cobro',12,'DD', ${sql.function.now});

insert into DD_TAC_TIPO_ACTUACION (DD_TAC_ID,DD_TAC_CODIGO, DD_TAC_DESCRIPCION,DD_TAC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)VALUES(1,'CA','Amistosa','Tipo de AcctuaciÃ³n Amistosa','DD',${sql.function.now} );
insert into DD_TAC_TIPO_ACTUACION (DD_TAC_ID,DD_TAC_CODIGO, DD_TAC_DESCRIPCION,DD_TAC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)VALUES(2,'CJ','Judicial','Tipo de AcctuaciÃ³n Judicial','DD',${sql.function.now} );

INSERT INTO dd_tre_tipo_reclamacion
VALUES (1,'REC', 'ReclamaciÃ³n', 'ReclamaciÃ³n larga',1,'DD',${sql.function.now},null,null,null,null,0);

INSERT INTO DD_ECL_ESTADO_CLIENTE
VALUES (1,'0', 'Manual', 'ESTADO_CLIENTE_MANUAL',1,'DD',${sql.function.now},null,null,null,null,0);
INSERT INTO DD_ECL_ESTADO_CLIENTE
VALUES (2,'1', 'Activo', 'ESTADO_CLIENTE_ACTIVO',1,'DD',${sql.function.now},null,null,null,null,0);
INSERT INTO DD_ECL_ESTADO_CLIENTE
VALUES (3,'2', 'Cancelado', 'ESTADO_CLIENTE_CANCELADO',1,'DD',${sql.function.now},null,null,null,null,0);

INSERT INTO DD_EEX_ESTADO_EXPEDIENTE
VALUES (1,'0', 'Propuesto', 'ESTADO_EXPEDIENTE_PROPUESTO',1,'DD',${sql.function.now},null,null,null,null,0);
INSERT INTO DD_EEX_ESTADO_EXPEDIENTE
VALUES (2,'1', 'Activo', 'ESTADO_EXPEDIENTE_ACTIVO',1,'DD',${sql.function.now},null,null,null,null,0);
INSERT INTO DD_EEX_ESTADO_EXPEDIENTE
VALUES (3,'2', 'Congelado', 'ESTADO_EXPEDIENTE_CONGELADO',1,'DD',${sql.function.now},null,null,null,null,0);
INSERT INTO DD_EEX_ESTADO_EXPEDIENTE
VALUES (4,'3', 'Decidido', 'ESTADO_EXPEDIENTE_DECIDIDO',1,'DD',${sql.function.now},null,null,null,null,0);
INSERT INTO DD_EEX_ESTADO_EXPEDIENTE
VALUES (5,'4', 'Bloqueado', 'ESTADO_EXPEDIENTE_BLOQUEADO',1,'DD',${sql.function.now},null,null,null,null,0);
INSERT INTO DD_EEX_ESTADO_EXPEDIENTE
VALUES (6,'5', 'Cancelado', 'ESTADO_EXPEDIENTE_CANCELADO',1,'DD',${sql.function.now},null,null,null,null,0);

INSERT INTO DD_EAS_ESTADO_ASUNTOS (DD_EAS_ID, DD_EAS_CODIGO, DD_EAS_DESCRIPCION, DD_EAS_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
VALUES (1,'01', 'Propuesto', 'Propuesto', 'DD',${sql.function.now},NULL,NULL,NULL,NULL,0);
INSERT INTO DD_EAS_ESTADO_ASUNTOS (DD_EAS_ID, DD_EAS_CODIGO, DD_EAS_DESCRIPCION, DD_EAS_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
VALUES (2,'02', 'Confirmado', 'Confirmado', 'DD',${sql.function.now},NULL,NULL,NULL,NULL,0);
INSERT INTO DD_EAS_ESTADO_ASUNTOS (DD_EAS_ID, DD_EAS_CODIGO, DD_EAS_DESCRIPCION, DD_EAS_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
VALUES (3,'03', 'Aceptado', 'Aceptado', 'DD',${sql.function.now},NULL,NULL,NULL,NULL,0);
INSERT INTO DD_EAS_ESTADO_ASUNTOS (DD_EAS_ID, DD_EAS_CODIGO, DD_EAS_DESCRIPCION, DD_EAS_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
VALUES (4,'04', 'Vacio', 'Vacio', 'DD',${sql.function.now},NULL,NULL,NULL,NULL,0);
INSERT INTO DD_EAS_ESTADO_ASUNTOS (DD_EAS_ID, DD_EAS_CODIGO, DD_EAS_DESCRIPCION, DD_EAS_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
VALUES (5,'05', 'Cancelado', 'Cancelado', 'DD',${sql.function.now},NULL,NULL,NULL,NULL,0);
INSERT INTO DD_EAS_ESTADO_ASUNTOS (DD_EAS_ID, DD_EAS_CODIGO, DD_EAS_DESCRIPCION, DD_EAS_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
VALUES (6,'06', 'Cerrado', 'Cerrado', 'DD',${sql.function.now},NULL,NULL,NULL,NULL,0);
INSERT INTO DD_EAS_ESTADO_ASUNTOS (DD_EAS_ID, DD_EAS_CODIGO, DD_EAS_DESCRIPCION, DD_EAS_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
VALUES (7,'07', 'En ConformaciÃ³n', 'En ConformaciÃ³n', 'DD',${sql.function.now},NULL,NULL,NULL,NULL,0);

INSERT INTO DD_EPR_ESTADO_PROCEDIMIENTO (DD_EPR_ID, DD_EPR_CODIGO, DD_EPR_DESCRIPCION, DD_EPR_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
VALUES (1,'01', 'Propuesto', 'Propuesto', 'DD',${sql.function.now},NULL,NULL,NULL,NULL,0);
INSERT INTO DD_EPR_ESTADO_PROCEDIMIENTO (DD_EPR_ID, DD_EPR_CODIGO, DD_EPR_DESCRIPCION, DD_EPR_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
VALUES (2,'02', 'Confirmado', 'Confirmado', 'DD',${sql.function.now},NULL,NULL,NULL,NULL,0);
INSERT INTO DD_EPR_ESTADO_PROCEDIMIENTO (DD_EPR_ID, DD_EPR_CODIGO, DD_EPR_DESCRIPCION, DD_EPR_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
VALUES (3,'03', 'Aceptado', 'Aceptado', 'DD',${sql.function.now},NULL,NULL,NULL,NULL,0);
INSERT INTO DD_EPR_ESTADO_PROCEDIMIENTO (DD_EPR_ID, DD_EPR_CODIGO, DD_EPR_DESCRIPCION, DD_EPR_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
VALUES (4,'04', 'Cancelado', 'Cancelado', 'DD',${sql.function.now},NULL,NULL,NULL,NULL,0);
INSERT INTO DD_EPR_ESTADO_PROCEDIMIENTO (DD_EPR_ID, DD_EPR_CODIGO, DD_EPR_DESCRIPCION, DD_EPR_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
VALUES (5,'06', 'Cerrado', 'Cerrado', 'DD',${sql.function.now},NULL,NULL,NULL,NULL,0);

INSERT INTO DD_MEX_MOTIVOS_EXP_MANUAL (DD_MEX_ID,DD_MEX_CODIGO,DD_MEX_DESCRIPCION,DD_MEX_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO)
VALUES (1,'1','Bancarrota','Cliente en Bancarrota',0,'DD',${sql.function.now},null,null,null,null,0);
INSERT INTO DD_MEX_MOTIVOS_EXP_MANUAL (DD_MEX_ID,DD_MEX_CODIGO,DD_MEX_DESCRIPCION,DD_MEX_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO)
VALUES (2,'2','Reincidente','Cliente Reincidente',0,'DD',${sql.function.now},null,null,null,null,0);

INSERT INTO DD_MET_MOT_EXC_TELECOBRO(DD_MET_ID, DD_MET_CODIGO, DD_MET_DESCRIPCION, DD_MET_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (1, '1','Causa 1', 'Causa de exclusiï¿½n de telecobro 1', 'DD', ${sql.function.now});
INSERT INTO DD_MET_MOT_EXC_TELECOBRO(DD_MET_ID, DD_MET_CODIGO, DD_MET_DESCRIPCION, DD_MET_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (2, '2','Causa 2', 'Causa de exclusiï¿½n de telecobro 2', 'DD', ${sql.function.now});


--FIXME Estos datos son inventados, hay que cambiarlos por tipo reales
INSERT INTO DD_PRA_PROPUESTA_AAA
VALUES (1,'1', 'Propuesta AAA 1', 'Propuesta Actitud ActuaciÃ³n 1',1,'DD',${sql.function.now},null,null,null,null,0);
INSERT INTO DD_PRA_PROPUESTA_AAA
VALUES (2,'2', 'Propuesta AAA 2', 'Propuesta Actitud ActuaciÃ³n 2',1,'DD',${sql.function.now},null,null,null,null,0);
INSERT INTO DD_PRA_PROPUESTA_AAA
VALUES (3,'3', 'Propuesta AAA 3', 'Propuesta Actitud ActuaciÃ³n 3',1,'DD',${sql.function.now},null,null,null,null,0);


INSERT INTO DD_TPA_TIPO_ACUERDO (DD_TPA_ID, DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 1,'01', 'DaciÃ³n en pago', 'DaciÃ³n en pago', 'DD', ${sql.function.now} );
INSERT INTO DD_TPA_TIPO_ACUERDO (DD_TPA_ID, DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 2,'02', 'Efectivo', 'Efectivo', 'DD', ${sql.function.now} );
INSERT INTO DD_TPA_TIPO_ACUERDO (DD_TPA_ID, DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 3,'03', 'EnervaciÃ³n', 'EnervaciÃ³n', 'DD', ${sql.function.now} );
INSERT INTO DD_TPA_TIPO_ACUERDO (DD_TPA_ID, DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 4,'04', 'RefinanciaciÃ³n', 'RefinanciaciÃ³n', 'DD', ${sql.function.now} );

INSERT INTO DD_SOL_SOLICITANTE (DD_SOL_ID, DD_SOL_CODIGO,DD_SOL_DESCRIPCION,DD_SOL_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 1,'01', 'Entidad', 'Entidad', 'DD', ${sql.function.now} );
INSERT INTO DD_SOL_SOLICITANTE (DD_SOL_ID, DD_SOL_CODIGO,DD_SOL_DESCRIPCION,DD_SOL_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 2,'02', 'Parte Contraria', 'Parte Contraria', 'DD', ${sql.function.now} );
INSERT INTO DD_SOL_SOLICITANTE (DD_SOL_ID, DD_SOL_CODIGO,DD_SOL_DESCRIPCION,DD_SOL_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 3,'03', 'Terceros', 'Terceros', 'DD', ${sql.function.now} );

INSERT INTO DD_EAC_ESTADO_ACUERDO (DD_EAC_ID, DD_EAC_CODIGO,DD_EAC_DESCRIPCION,DD_EAC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 1,'01', 'En Conformacion', 'En Conformacion', 'DD', ${sql.function.now} );
INSERT INTO DD_EAC_ESTADO_ACUERDO (DD_EAC_ID, DD_EAC_CODIGO,DD_EAC_DESCRIPCION,DD_EAC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 2,'02', 'Propuesto ', 'Propuesto ', 'DD', ${sql.function.now} );
INSERT INTO DD_EAC_ESTADO_ACUERDO (DD_EAC_ID, DD_EAC_CODIGO,DD_EAC_DESCRIPCION,DD_EAC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 3,'03', 'Vigente', 'Vigente', 'DD', ${sql.function.now} );
INSERT INTO DD_EAC_ESTADO_ACUERDO (DD_EAC_ID, DD_EAC_CODIGO,DD_EAC_DESCRIPCION,DD_EAC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 4,'04', 'Rechazado', 'Rechazado', 'DD', ${sql.function.now} );
INSERT INTO DD_EAC_ESTADO_ACUERDO (DD_EAC_ID, DD_EAC_CODIGO,DD_EAC_DESCRIPCION,DD_EAC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 5,'05', 'Cancelado', 'Cancelado', 'DD', ${sql.function.now} );

INSERT INTO DD_RAA_RESULTADO_ACUERDO (DD_RAA_ID, DD_RAA_CODIGO,DD_RAA_DESCRIPCION,DD_RAA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 1,'01', 'Positivo', 'Positivo', 'DD', ${sql.function.now} );
INSERT INTO DD_RAA_RESULTADO_ACUERDO (DD_RAA_ID, DD_RAA_CODIGO,DD_RAA_DESCRIPCION,DD_RAA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 2,'02', 'Negativo', 'Negativo', 'DD', ${sql.function.now} );

INSERT INTO DD_VAA_VALORA_ACTU_AMIST (DD_VAA_ID, DD_VAA_CODIGO,DD_VAA_DESCRIPCION,DD_VAA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 1,'01', 'Valoracion Actuacion 1', 'Valoracion Actuacion 1', 'DD', ${sql.function.now} );
INSERT INTO DD_VAA_VALORA_ACTU_AMIST (DD_VAA_ID, DD_VAA_CODIGO,DD_VAA_DESCRIPCION,DD_VAA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 2,'02', 'Valoracion Actuacion 2', 'Valoracion Actuacion 2', 'DD', ${sql.function.now} );

INSERT INTO DD_EDE_ESTADOS_DECISION ( DD_EDE_ID, DD_EDE_CODIGO, DD_EDE_DESCRIPCION,DD_EDE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR) VALUES (1, '01', 'PROPUESTO', 'PROPUESTO', 1, 'DD', ${sql.function.now}); 
INSERT INTO DD_EDE_ESTADOS_DECISION ( DD_EDE_ID, DD_EDE_CODIGO, DD_EDE_DESCRIPCION,DD_EDE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR) VALUES (2, '02', 'ACEPTADO', 'ACEPTADO', 1, 'DD', ${sql.function.now}); 
INSERT INTO DD_EDE_ESTADOS_DECISION ( DD_EDE_ID, DD_EDE_CODIGO, DD_EDE_DESCRIPCION,DD_EDE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR) VALUES (3, '03', 'RECHAZADO', 'RECHAZADO', 1, 'DD', ${sql.function.now});


INSERT INTO DD_CRA_CRITERIO_ANALISIS (DD_CRA_ID, DD_CRA_CODIGO, DD_CRA_DESCRIPCION,DD_CRA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (1, 'jerarq', 'Por jerarquía', 'Por jerarquía', 'DD', ${sql.function.now});
INSERT INTO DD_CRA_CRITERIO_ANALISIS (DD_CRA_ID, DD_CRA_CODIGO, DD_CRA_DESCRIPCION,DD_CRA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (2, 'producto', 'Por tipo de producto', 'Por tipo de producto', 'DD', ${sql.function.now});
INSERT INTO DD_CRA_CRITERIO_ANALISIS (DD_CRA_ID, DD_CRA_CODIGO, DD_CRA_DESCRIPCION,DD_CRA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (3, 'segmento', 'Por tipo de segmento', 'Por tipo de segmento', 'DD', ${sql.function.now});
INSERT INTO DD_CRA_CRITERIO_ANALISIS (DD_CRA_ID, DD_CRA_CODIGO, DD_CRA_DESCRIPCION,DD_CRA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (4, 'fase', 'Por situación (fase y subfases)', 'Por situación (fase y subfases)', 'DD', ${sql.function.now});


-- Tipo de Ayuda Actuacion Acuerdo Fase 3
INSERT INTO DD_TAY_TIPO_AYUDA_ACUERDO  (DD_TAY_ID,DD_TAY_CODIGO,DD_TAY_DESCRIPCION,DD_TAY_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (S_DD_TAY_TIP_ACTU_ACUERDO.nextVal,'1','Tipo Ayuda Actuacion Acuerdo 1','Tipo Ayuda Actuacion Acuerdo 1','DD',${sql.function.now});
INSERT INTO DD_TAY_TIPO_AYUDA_ACUERDO  (DD_TAY_ID,DD_TAY_CODIGO,DD_TAY_DESCRIPCION,DD_TAY_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (S_DD_TAY_TIP_ACTU_ACUERDO.nextVal,'2','Tipo Ayuda Actuacion Acuerdo 2','Tipo Ayuda Actuacion Acuerdo 2','DD',${sql.function.now});
INSERT INTO DD_TAY_TIPO_AYUDA_ACUERDO  (DD_TAY_ID,DD_TAY_CODIGO,DD_TAY_DESCRIPCION,DD_TAY_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (S_DD_TAY_TIP_ACTU_ACUERDO.nextVal,'3','Tipo Ayuda Actuacion Acuerdo 3','Tipo Ayuda Actuacion Acuerdo 3','DD',${sql.function.now});

-- Tipos de ficheros de carga
INSERT INTO DD_TFI_TIPO_FICHERO(dd_tfi_id,dd_tfi_codigo,dd_tfi_descripcion,usuariocrear,fechacrear,borrado)
VALUES      (1, 'PCR', 'PCR', 'DD', ${sql.function.now}, 0);
INSERT INTO DD_TFI_TIPO_FICHERO(dd_tfi_id,dd_tfi_codigo,dd_tfi_descripcion,usuariocrear,fechacrear,borrado)
VALUES      (2, 'ALE', 'Alertas', 'DD', ${sql.function.now}, 0);
INSERT INTO DD_TFI_TIPO_FICHERO(dd_tfi_id,dd_tfi_codigo,dd_tfi_descripcion,usuariocrear,fechacrear,borrado)
VALUES      (3, 'CIRBE', 'CIRBE', 'DD', ${sql.function.now}, 0);
INSERT INTO DD_TFI_TIPO_FICHERO(dd_tfi_id,dd_tfi_codigo,dd_tfi_descripcion,usuariocrear,fechacrear,borrado)
VALUES      (4, 'GCL', 'Grupo clientes', 'DD', ${sql.function.now}, 0);

INSERT INTO DD_CRC_CLASE_RIESGO_CIRBE (DD_CRC_ID,DD_CRC_CODIGO,DD_CRC_DESCRIPCION,DD_CRC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (1,'0','Créditos Unipersonales','Créditos Unipersonales','DD',${sql.function.now});
INSERT INTO DD_CRC_CLASE_RIESGO_CIRBE (DD_CRC_ID,DD_CRC_CODIGO,DD_CRC_DESCRIPCION,DD_CRC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (2,'2','Riesgos de Valores de renta fija','Riesgos de Valores de renta fija','DD',${sql.function.now});
INSERT INTO DD_CRC_CLASE_RIESGO_CIRBE (DD_CRC_ID,DD_CRC_CODIGO,DD_CRC_DESCRIPCION,DD_CRC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (3,'4','Riesgos de Crédito Solidarios','Riesgos de Crédito Solidarios','DD',${sql.function.now});
INSERT INTO DD_CRC_CLASE_RIESGO_CIRBE (DD_CRC_ID,DD_CRC_CODIGO,DD_CRC_DESCRIPCION,DD_CRC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (4,'6','Pertenencia a sociedades regulares colectivas','Pertenencia a sociedades regulares colectivas','DD',${sql.function.now});

INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (1,'A','PESETA','PESETA','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (2,'B','DÓLAR USA','DÓLAR USA','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (3,'C','DÓLAR CANADIENSE','DÓLAR CANADIENSE','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (4,'D','FRANCO FRANCÉS','FRANCO FRANCÉS','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (5,'E','LIBRA ESTERLINA','LIBRA ESTERLINA','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (6,'F','LIBRA IRLANDESA','LIBRA IRLANDESA','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (7,'G','FRANCO SUIZO','FRANCO SUIZO','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (8,'H','FRANCO BELGA','FRANCO BELGA','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (9,'I','MARCO ALEMAN','MARCO ALEMAN','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (10,'J','LIBRA ITALIANA','LIBRA ITALIANA','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (11,'K','FLORIN HOLANDES','FLORIN HOLANDES','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (12,'L','CORONA SUECA','CORONA SUECA','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (13,'M','CORONA DANESA','CORONA DANESA','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (14,'N','CORONA NORUEGA','CORONA NORUEGA','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (15,'O','MARCO FINLANDES','MARCO FINLANDES','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (16,'P','CHELIN AUSTRIACO','CHELIN AUSTRIACO','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (17,'Q','ESCUDO PORTUGUES','ESCUDO PORTUGUES','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (18,'R','YEN JAPONES','YEN JAPONES','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (19,'S','EUROS','EUROS','DD',${sql.function.now});
INSERT INTO DD_TMC_TIPO_MONEDA_CIRBE (DD_TMC_ID,DD_TMC_CODIGO,DD_TMC_DESCRIPCION,DD_TMC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (20,'T','OTRAS','OTRAS','DD',${sql.function.now});

INSERT INTO DD_TSC_TIPO_SITUAC_CIRBE (DD_TSC_ID,DD_TSC_CODIGO,DD_TSC_DESCRIPCION,DD_TSC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (1,'K','Ef. Redescontados','Ef. Redescontados','DD',${sql.function.now});
INSERT INTO DD_TSC_TIPO_SITUAC_CIRBE (DD_TSC_ID,DD_TSC_CODIGO,DD_TSC_DESCRIPCION,DD_TSC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (2,'J','En Suspenso','En Suspenso','DD',${sql.function.now});
INSERT INTO DD_TSC_TIPO_SITUAC_CIRBE (DD_TSC_ID,DD_TSC_CODIGO,DD_TSC_DESCRIPCION,DD_TSC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (3,'I','Moroso','Moroso','DD',${sql.function.now});
INSERT INTO DD_TSC_TIPO_SITUAC_CIRBE (DD_TSC_ID,DD_TSC_CODIGO,DD_TSC_DESCRIPCION,DD_TSC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (4,'H','Moroso','Moroso','DD',${sql.function.now});
INSERT INTO DD_TSC_TIPO_SITUAC_CIRBE (DD_TSC_ID,DD_TSC_CODIGO,DD_TSC_DESCRIPCION,DD_TSC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (5,'G','Moroso','Moroso','DD',${sql.function.now});
INSERT INTO DD_TSC_TIPO_SITUAC_CIRBE (DD_TSC_ID,DD_TSC_CODIGO,DD_TSC_DESCRIPCION,DD_TSC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (6,'F','Moroso','Moroso','DD',${sql.function.now});
INSERT INTO DD_TSC_TIPO_SITUAC_CIRBE (DD_TSC_ID,DD_TSC_CODIGO,DD_TSC_DESCRIPCION,DD_TSC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (7,'E','Moroso','Moroso','DD',${sql.function.now});
INSERT INTO DD_TSC_TIPO_SITUAC_CIRBE (DD_TSC_ID,DD_TSC_CODIGO,DD_TSC_DESCRIPCION,DD_TSC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (8,'D','Dudoso','Dudoso','DD',${sql.function.now});
INSERT INTO DD_TSC_TIPO_SITUAC_CIRBE (DD_TSC_ID,DD_TSC_CODIGO,DD_TSC_DESCRIPCION,DD_TSC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (9,'C','Dudoso','Dudoso','DD',${sql.function.now});
INSERT INTO DD_TSC_TIPO_SITUAC_CIRBE (DD_TSC_ID,DD_TSC_CODIGO,DD_TSC_DESCRIPCION,DD_TSC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (10,'B','Vencido','Vencido','DD',${sql.function.now});
INSERT INTO DD_TSC_TIPO_SITUAC_CIRBE (DD_TSC_ID,DD_TSC_CODIGO,DD_TSC_DESCRIPCION,DD_TSC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (11,'A','Normal','Normal','DD',${sql.function.now});
INSERT INTO DD_TSC_TIPO_SITUAC_CIRBE (DD_TSC_ID,DD_TSC_CODIGO,DD_TSC_DESCRIPCION,DD_TSC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (12,'L','Conv. Acreedores','Conv. Acreedores','DD',${sql.function.now});

INSERT INTO DD_TVC_TIPO_VENC_CIRBE (DD_TVC_ID,DD_TVC_CODIGO,DD_TVC_DESCRIPCION,DD_TVC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (1,'M','L/P','L/P','DD',${sql.function.now});
INSERT INTO DD_TVC_TIPO_VENC_CIRBE (DD_TVC_ID,DD_TVC_CODIGO,DD_TVC_DESCRIPCION,DD_TVC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (2,'D','L/P','L/P','DD',${sql.function.now});
INSERT INTO DD_TVC_TIPO_VENC_CIRBE (DD_TVC_ID,DD_TVC_CODIGO,DD_TVC_DESCRIPCION,DD_TVC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (3,'C','L/P','L/P','DD',${sql.function.now});
INSERT INTO DD_TVC_TIPO_VENC_CIRBE (DD_TVC_ID,DD_TVC_CODIGO,DD_TVC_DESCRIPCION,DD_TVC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (4,'B','C/P','C/P','DD',${sql.function.now});
INSERT INTO DD_TVC_TIPO_VENC_CIRBE (DD_TVC_ID,DD_TVC_CODIGO,DD_TVC_DESCRIPCION,DD_TVC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (5,'A','C/P','C/P','DD',${sql.function.now});

INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (1,'A','Crédito Comercial','Crédito Comercial','DD',${sql.function.now});
INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (2,'L','Crédito Comercial','Crédito Comercial','DD',${sql.function.now});
INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (3,'J','Otros','Otros','DD',${sql.function.now});
INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (4,'K','Leasing','Leasing','DD',${sql.function.now});
INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (5,'G','Otros','Otros','DD',${sql.function.now});
INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (6,'E','Avales','Avales','DD',${sql.function.now});
INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (7,'C','Avales','Avales','DD',${sql.function.now});
INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (8,'X','Pol. Riesgo','Pol. Riesgo','DD',${sql.function.now});
INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (9,'R','Otros','Otros','DD',${sql.function.now});
INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (10,'M','Factoring','Factoring','DD',${sql.function.now});
INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (11,'Q','Crédito Financiero','Crédito Financiero','DD',${sql.function.now});
INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (12,'S','Otros','Otros','DD',${sql.function.now});
INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (13,'B','Crédito Financiero','Crédito Financiero','DD',${sql.function.now});
INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (14,'D','Avales','Avales','DD',${sql.function.now});
INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (15,'F','Otros','Otros','DD',${sql.function.now});
INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (16,'H','Aceptantes Efectos','Aceptantes Efectos','DD',${sql.function.now});
INSERT INTO DD_COC_COD_OPERAC_CIRBE (DD_COC_ID,DD_COC_CODIGO,DD_COC_DESCRIPCION,DD_COC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (17,'I','R. Indirecto','R. Indirecto','DD',${sql.function.now});

INSERT INTO DD_TGC_TIPO_GARANTIA_CIRBE (DD_TGC_ID,DD_TGC_CODIGO,DD_TGC_DESCRIPCION,DD_TGC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (1,'A','Gar. Real','Gar. Real','DD',${sql.function.now});
INSERT INTO DD_TGC_TIPO_GARANTIA_CIRBE (DD_TGC_ID,DD_TGC_CODIGO,DD_TGC_DESCRIPCION,DD_TGC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (2,'E','Otros','Otros','DD',${sql.function.now});
INSERT INTO DD_TGC_TIPO_GARANTIA_CIRBE (DD_TGC_ID,DD_TGC_CODIGO,DD_TGC_DESCRIPCION,DD_TGC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (3,'F','Otros','Otros','DD',${sql.function.now});
INSERT INTO DD_TGC_TIPO_GARANTIA_CIRBE (DD_TGC_ID,DD_TGC_CODIGO,DD_TGC_DESCRIPCION,DD_TGC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (4,'D','Otros','Otros','DD',${sql.function.now});
INSERT INTO DD_TGC_TIPO_GARANTIA_CIRBE (DD_TGC_ID,DD_TGC_CODIGO,DD_TGC_DESCRIPCION,DD_TGC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (5,'B','Gar. Real','Gar. Real','DD',${sql.function.now});
INSERT INTO DD_TGC_TIPO_GARANTIA_CIRBE (DD_TGC_ID,DD_TGC_CODIGO,DD_TGC_DESCRIPCION,DD_TGC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (6,'C','Gar. Real Parcial','Gar. Real Parcial','DD',${sql.function.now});
INSERT INTO DD_TGC_TIPO_GARANTIA_CIRBE (DD_TGC_ID,DD_TGC_CODIGO,DD_TGC_DESCRIPCION,DD_TGC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (7,'V','Personal','Personal','DD',${sql.function.now});
INSERT INTO DD_TGC_TIPO_GARANTIA_CIRBE (DD_TGC_ID,DD_TGC_CODIGO,DD_TGC_DESCRIPCION,DD_TGC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (8,'H','Gar. Decl. CIR','Gar. Decl. CIR','DD',${sql.function.now});

--CODIGOS ISO


INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'AFGHANISTAN','AF','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ÅLAND ISLANDS','AX','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ALBANIA','AL','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ALGERIA','DZ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'AMERICAN SAMOA','AS','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ANDORRA','AD','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ANGOLA','AO','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ANGUILLA','AI','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ANTARCTICA','AQ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ANTIGUA AND BARBUDA','AG','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ARGENTINA','AR','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ARMENIA','AM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ARUBA','AW','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'AUSTRALIA','AU','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'AUSTRIA','AT','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'AZERBAIJAN','AZ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BAHAMAS','BS','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BAHRAIN','BH','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BANGLADESH','BD','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BARBADOS','BB','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BELARUS','BY','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BELGIUM','BE','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BELIZE','BZ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BENIN','BJ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BERMUDA','BM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BHUTAN','BT','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BOLIVIA, PLURINATIONAL STATE OF','BO','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BOSNIA AND HERZEGOVINA','BA','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BOTSWANA','BW','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BOUVET ISLAND','BV','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BRAZIL','BR','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BRITISH INDIAN OCEAN TERRITORY','IO','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BRUNEI DARUSSALAM','BN','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BULGARIA','BG','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BURKINA FASO','BF','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'BURUNDI','BI','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CAMBODIA','KH','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CAMEROON','CM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CANADA','CA','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CAPE VERDE','CV','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CAYMAN ISLANDS','KY','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CENTRAL AFRICAN REPUBLIC','CF','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CHAD','TD','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CHILE','CL','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CHINA','CN','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CHRISTMAS ISLAND','CX','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'COCOS (KEELING) ISLANDS','CC','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'COLOMBIA','CO','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'COMOROS','KM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CONGO','CG','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CONGO, THE DEMOCRATIC REPUBLIC OF THE','CD','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'COOK ISLANDS','CK','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'COSTA RICA','CR','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CÔTE D''IVOIRE','CI','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CROATIA','HR','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CUBA','CU','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CYPRUS','CY','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'CZECH REPUBLIC','CZ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'DENMARK','DK','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'DJIBOUTI','DJ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'DOMINICA','DM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'DOMINICAN REPUBLIC','DO','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ECUADOR','EC','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'EGYPT','EG','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'EL SALVADOR','SV','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'EQUATORIAL GUINEA','GQ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ERITREA','ER','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ESTONIA','EE','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ETHIOPIA','ET','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'FALKLAND ISLANDS (MALVINAS)','FK','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'FAROE ISLANDS','FO','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'FIJI','FJ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'FINLAND','FI','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'FRANCE','FR','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'FRENCH GUIANA','GF','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'FRENCH POLYNESIA','PF','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'FRENCH SOUTHERN TERRITORIES','TF','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'GABON','GA','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'GAMBIA','GM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'GEORGIA','GE','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'GERMANY','DE','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'GHANA','GH','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'GIBRALTAR','GI','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'GREECE','GR','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'GREENLAND','GL','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'GRENADA','GD','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'GUADELOUPE','GP','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'GUAM','GU','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'GUATEMALA','GT','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'GUERNSEY','GG','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'GUINEA','GN','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'GUINEA-BISSAU','GW','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'GUYANA','GY','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'HAITI','HT','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'HEARD ISLAND AND MCDONALD ISLANDS','HM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'HOLY SEE (VATICAN CITY STATE)','VA','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'HONDURAS','HN','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'HONG KONG','HK','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'HUNGARY','HU','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ICELAND','IS','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'INDIA','IN','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'INDONESIA','ID','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'IRAN, ISLAMIC REPUBLIC OF','IR','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'IRAQ','IQ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'IRELAND','IE','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ISLE OF MAN','IM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ISRAEL','IL','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ITALY','IT','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'JAMAICA','JM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'JAPAN','JP','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'JERSEY','JE','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'JORDAN','JO','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'KAZAKHSTAN','KZ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'KENYA','KE','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'KIRIBATI','KI','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'KOREA, DEMOCRATIC PEOPLE''S REPUBLIC OF','KP','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'KOREA, REPUBLIC OF','KR','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'KUWAIT','KW','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'KYRGYZSTAN','KG','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'LAO PEOPLE''S DEMOCRATIC REPUBLIC','LA','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'LATVIA','LV','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'LEBANON','LB','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'LESOTHO','LS','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'LIBERIA','LR','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'LIBYAN ARAB JAMAHIRIYA','LY','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'LIECHTENSTEIN','LI','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'LITHUANIA','LT','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'LUXEMBOURG','LU','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MACAO','MO','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF','MK','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MADAGASCAR','MG','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MALAWI','MW','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MALAYSIA','MY','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MALDIVES','MV','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MALI','ML','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MALTA','MT','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MARSHALL ISLANDS','MH','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MARTINIQUE','MQ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MAURITANIA','MR','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MAURITIUS','MU','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MAYOTTE','YT','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MEXICO','MX','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MICRONESIA, FEDERATED STATES OF','FM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MOLDOVA, REPUBLIC OF','MD','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MONACO','MC','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MONGOLIA','MN','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MONTENEGRO','ME','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MONTSERRAT','MS','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MOROCCO','MA','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MOZAMBIQUE','MZ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'MYANMAR','MM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'NAMIBIA','NA','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'NAURU','NR','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'NEPAL','NP','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'NETHERLANDS','NL','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'NETHERLANDS ANTILLES','AN','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'NEW CALEDONIA','NC','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'NEW ZEALAND','NZ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'NICARAGUA','NI','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'NIGER','NE','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'NIGERIA','NG','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'NIUE','NU','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'NORFOLK ISLAND','NF','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'NORTHERN MARIANA ISLANDS','MP','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'NORWAY','NO','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'OMAN','OM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'PAKISTAN','PK','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'PALAU','PW','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'PALESTINIAN TERRITORY, OCCUPIED','PS','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'PANAMA','PA','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'PAPUA NEW GUINEA','PG','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'PARAGUAY','PY','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'PERU','PE','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'PHILIPPINES','PH','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'PITCAIRN','PN','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'POLAND','PL','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'PORTUGAL','PT','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'PUERTO RICO','PR','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'QATAR','QA','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'RÉUNION','RE','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ROMANIA','RO','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'RUSSIAN FEDERATION','RU','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'RWANDA','RW','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SAINT BARTHÉLEMY','BL','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SAINT HELENA','SH','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SAINT KITTS AND NEVIS','KN','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SAINT LUCIA','LC','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SAINT MARTIN','MF','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SAINT PIERRE AND MIQUELON','PM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SAINT VINCENT AND THE GRENADINES','VC','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SAMOA','WS','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SAN MARINO','SM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SAO TOME AND PRINCIPE','ST','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SAUDI ARABIA','SA','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SENEGAL','SN','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SERBIA','RS','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SEYCHELLES','SC','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SIERRA LEONE','SL','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SINGAPORE','SG','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SLOVAKIA','SK','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SLOVENIA','SI','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SOLOMON ISLANDS','SB','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SOMALIA','SO','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SOUTH AFRICA','ZA','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS','GS','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SPAIN','ES','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SRI LANKA','LK','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SUDAN','SD','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SURINAME','SR','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SVALBARD AND JAN MAYEN','SJ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SWAZILAND','SZ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SWEDEN','SE','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SWITZERLAND','CH','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'SYRIAN ARAB REPUBLIC','SY','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'TAIWAN, PROVINCE OF CHINA','TW','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'TAJIKISTAN','TJ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'TANZANIA, UNITED REPUBLIC OF','TZ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'THAILAND','TH','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'TIMOR-LESTE','TL','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'TOGO','TG','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'TOKELAU','TK','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'TONGA','TO','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'TRINIDAD AND TOBAGO','TT','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'TUNISIA','TN','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'TURKEY','TR','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'TURKMENISTAN','TM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'TURKS AND CAICOS ISLANDS','TC','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'TUVALU','TV','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'UGANDA','UG','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'UKRAINE','UA','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'UNITED ARAB EMIRATES','AE','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'UNITED KINGDOM','GB','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'UNITED STATES','US','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'UNITED STATES MINOR OUTLYING ISLANDS','UM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'URUGUAY','UY','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'UZBEKISTAN','UZ','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'VANUATU','VU','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'VENEZUELA, BOLIVARIAN REPUBLIC OF','VE','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'VIET NAM','VN','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'VIRGIN ISLANDS, BRITISH','VG','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'VIRGIN ISLANDS, U.S.','VI','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'WALLIS AND FUTUNA','WF','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'WESTERN SAHARA','EH','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'YEMEN','YE','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ZAMBIA','ZM','DD',${sql.function.now},0);
INSERT INTO DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_CODIGO, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_CIC_CODIGO_ISO_CIRBE.nextVal, 'ZIMBABWE','ZW','DD',${sql.function.now},0);


INSERT INTO DD_TGL_TIPO_GRUPO_CLIENTE (DD_TGL_ID, DD_TGL_CODIGO, DD_TGL_DESCRIPCION, DD_TGL_DESCRIPCION_LARGA,USUARIOCREAR, FECHACREAR, BORRADO) VALUES (1,'01', 'Riesgo interno','Riesgo interno','DD',SYSDATE,0);
INSERT INTO DD_TGL_TIPO_GRUPO_CLIENTE (DD_TGL_ID, DD_TGL_CODIGO, DD_TGL_DESCRIPCION, DD_TGL_DESCRIPCION_LARGA,USUARIOCREAR, FECHACREAR, BORRADO) VALUES (2,'02', 'Riesgo B.E.','Riesgo B.E.','DD',SYSDATE,0);
INSERT INTO DD_TGL_TIPO_GRUPO_CLIENTE (DD_TGL_ID, DD_TGL_CODIGO, DD_TGL_DESCRIPCION, DD_TGL_DESCRIPCION_LARGA,USUARIOCREAR, FECHACREAR, BORRADO) VALUES (3,'03', 'Colectivo','Colectivo','DD',SYSDATE,0);
INSERT INTO DD_TGL_TIPO_GRUPO_CLIENTE (DD_TGL_ID, DD_TGL_CODIGO, DD_TGL_DESCRIPCION, DD_TGL_DESCRIPCION_LARGA,USUARIOCREAR, FECHACREAR, BORRADO) VALUES (4,'04', 'Económico','Económico','DD',SYSDATE,0);
INSERT INTO DD_TGL_TIPO_GRUPO_CLIENTE (DD_TGL_ID, DD_TGL_CODIGO, DD_TGL_DESCRIPCION, DD_TGL_DESCRIPCION_LARGA,USUARIOCREAR, FECHACREAR, BORRADO) VALUES (5,'05', 'Simulación','Simulación','DD',SYSDATE,0);
INSERT INTO DD_TGL_TIPO_GRUPO_CLIENTE (DD_TGL_ID, DD_TGL_CODIGO, DD_TGL_DESCRIPCION, DD_TGL_DESCRIPCION_LARGA,USUARIOCREAR, FECHACREAR, BORRADO) VALUES (6,'06', 'Famil. Imposic.','Famil. Imposic.','DD',SYSDATE,0);

-- Modulo de Politicas
INSERT INTO DD_EPI_EST_POL_ITINERARIO (DD_EPI_ID, DD_EST_ID, DD_EPI_CODIGO, DD_EPI_DESCRIPCION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (1,null,'PRE', 'Pre-Politica','DD',${sql.function.now},0);
INSERT INTO DD_EPI_EST_POL_ITINERARIO (DD_EPI_ID, DD_EST_ID, DD_EPI_CODIGO, DD_EPI_DESCRIPCION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (2,3,'CE', 'P. Completar Expediente','DD',${sql.function.now},0);
INSERT INTO DD_EPI_EST_POL_ITINERARIO (DD_EPI_ID, DD_EST_ID, DD_EPI_CODIGO, DD_EPI_DESCRIPCION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (3,4,'RE', 'P. Revisar Expediente','DD',${sql.function.now},0);
INSERT INTO DD_EPI_EST_POL_ITINERARIO (DD_EPI_ID, DD_EST_ID, DD_EPI_CODIGO, DD_EPI_DESCRIPCION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (4,5,'DC', 'P. Decisión Comité','DD',${sql.function.now},0);
INSERT INTO DD_EPI_EST_POL_ITINERARIO (DD_EPI_ID, DD_EST_ID, DD_EPI_CODIGO, DD_EPI_DESCRIPCION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (5,null,'VIG', 'P. Vigente','DD',${sql.function.now},0);

INSERT INTO DD_ESP_ESTADO_POLITICA (DD_ESP_ID, DD_ESP_CODIGO, DD_ESP_DESCRIPCION, DD_ESP_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (1,'PROP', 'Propuesta','','DD',${sql.function.now},0);
INSERT INTO DD_ESP_ESTADO_POLITICA (DD_ESP_ID, DD_ESP_CODIGO, DD_ESP_DESCRIPCION, DD_ESP_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (2,'VIGE', 'Vigente','','DD',${sql.function.now},0);
INSERT INTO DD_ESP_ESTADO_POLITICA (DD_ESP_ID, DD_ESP_CODIGO, DD_ESP_DESCRIPCION, DD_ESP_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (3,'HIST', 'Histórica','','DD',${sql.function.now},0);
INSERT INTO DD_ESP_ESTADO_POLITICA (DD_ESP_ID, DD_ESP_CODIGO, DD_ESP_DESCRIPCION, DD_ESP_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (4,'CANC', 'Cancelado','','DD',${sql.function.now},0);

INSERT INTO DD_POL_POLITICAS (DD_POL_ID, DD_POL_CODIGO, DD_POL_DESCRIPCION, DD_POL_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_POL_POLITICAS.nextval,'1', 'Politica 1','Politica 1','DD',sysdate,0);
INSERT INTO DD_POL_POLITICAS (DD_POL_ID, DD_POL_CODIGO, DD_POL_DESCRIPCION, DD_POL_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_POL_POLITICAS.nextval,'2', 'Politica 2','Politica 2','DD',sysdate,0);
INSERT INTO DD_POL_POLITICAS (DD_POL_ID, DD_POL_CODIGO, DD_POL_DESCRIPCION, DD_POL_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_POL_POLITICAS.nextval,'3', 'Politica 3','Politica 3','DD',sysdate,0);
INSERT INTO DD_POL_POLITICAS (DD_POL_ID, DD_POL_CODIGO, DD_POL_DESCRIPCION, DD_POL_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (S_DD_POL_POLITICAS.nextval,'4', 'Politica 4','Politica 4','DD',sysdate,0);

INSERT INTO DD_ESO_ESTADO_OBJETIVO (DD_ESO_ID, DD_ESO_CODIGO, DD_ESO_DESCRIPCION, DD_ESO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (1,'PROP', 'Propuesto','','DD',${sql.function.now},0);
INSERT INTO DD_ESO_ESTADO_OBJETIVO (DD_ESO_ID, DD_ESO_CODIGO, DD_ESO_DESCRIPCION, DD_ESO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (2,'CONF', 'Confirmado','','DD',${sql.function.now},0);
INSERT INTO DD_ESO_ESTADO_OBJETIVO (DD_ESO_ID, DD_ESO_CODIGO, DD_ESO_DESCRIPCION, DD_ESO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (3,'RECH', 'Rechazado','','DD',${sql.function.now},0);
INSERT INTO DD_ESO_ESTADO_OBJETIVO (DD_ESO_ID, DD_ESO_CODIGO, DD_ESO_DESCRIPCION, DD_ESO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (4,'BORR', 'Borrado','','DD',${sql.function.now},0);

INSERT INTO DD_ESC_ESTADO_CUMPLIMIENTO (DD_ESC_ID, DD_ESC_CODIGO, DD_ESC_DESCRIPCION, DD_ESC_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (1,'CANC', 'Cancelado','','DD',${sql.function.now},0);
INSERT INTO DD_ESC_ESTADO_CUMPLIMIENTO (DD_ESC_ID, DD_ESC_CODIGO, DD_ESC_DESCRIPCION, DD_ESC_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (2,'PEND', 'Pendiente','','DD',${sql.function.now},0);
INSERT INTO DD_ESC_ESTADO_CUMPLIMIENTO (DD_ESC_ID, DD_ESC_CODIGO, DD_ESC_DESCRIPCION, DD_ESC_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (3,'CUMP', 'Cumplido','','DD',${sql.function.now},0);
INSERT INTO DD_ESC_ESTADO_CUMPLIMIENTO (DD_ESC_ID, DD_ESC_CODIGO, DD_ESC_DESCRIPCION, DD_ESC_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (4,'INCU', 'Incumplido','','DD',${sql.function.now},0);
INSERT INTO DD_ESC_ESTADO_CUMPLIMIENTO (DD_ESC_ID, DD_ESC_CODIGO, DD_ESC_DESCRIPCION, DD_ESC_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (5,'JUST', 'Justificado','','DD',${sql.function.now},0);

INSERT INTO DD_TOP_TIPO_OPERADOR (DD_TOP_ID, DD_TOP_CODIGO, DD_TOP_DESCRIPCION, DD_TOP_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (1,'MENOR', 'Menor','','DD',${sql.function.now},0);
INSERT INTO DD_TOP_TIPO_OPERADOR (DD_TOP_ID, DD_TOP_CODIGO, DD_TOP_DESCRIPCION, DD_TOP_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (2,'MAYOR', 'Mayor','','DD',${sql.function.now},0);
INSERT INTO DD_TOP_TIPO_OPERADOR (DD_TOP_ID, DD_TOP_CODIGO, DD_TOP_DESCRIPCION, DD_TOP_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (3,'DISTI', 'Distinto','','DD',${sql.function.now},0);

INSERT INTO DD_TAN_TIPO_ANALISIS (DD_TAN_ID, DD_TAN_CODIGO, DD_TAN_DESCRIPCION, DD_TAN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (1,'CUANTITATIVO', 'Cuantitativo','Cuantitativo', 'DD',sysdate,0);
INSERT INTO DD_TAN_TIPO_ANALISIS (DD_TAN_ID, DD_TAN_CODIGO, DD_TAN_DESCRIPCION, DD_TAN_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (2,'CUALITATIVO', 'Cualiitativo','Cualitativo', 'DD',sysdate,0);

insert into DD_TIT_TIPO_ITINERARIOS(DD_TIT_ID, DD_TIT_CODIGO, DD_TIT_DESCRIPCION, DD_TIT_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) values (S_DD_TIT_TIPO_ITINERARIOS.nextval, 'REC', 'Recuperación', 'Itinerario de recuperación', 'DD', sysdate, 0);
insert into DD_TIT_TIPO_ITINERARIOS(DD_TIT_ID, DD_TIT_CODIGO, DD_TIT_DESCRIPCION, DD_TIT_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) values (S_DD_TIT_TIPO_ITINERARIOS.nextval, 'SEG', 'Seguimiento', 'Itinerario de seguimiento', 'DD', sysdate, 0);

insert into DD_TRE_TIPO_REGLAS_ELEVACION(DD_TRE_ID, DD_TRE_CODIGO, DD_TRE_DESCRIPCION, DD_TRE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values(S_DD_TRE_TIPO_REGLAS_ELEVACION.nextval, 'POLITICA', 'Proponer Política', 'Proponer Política', 0, 'DD', sysdate, 0);
insert into DD_TRE_TIPO_REGLAS_ELEVACION(DD_TRE_ID, DD_TRE_CODIGO, DD_TRE_DESCRIPCION, DD_TRE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values(S_DD_TRE_TIPO_REGLAS_ELEVACION.nextval, 'GESTION_SINTESIS', 'Gestión de la Síntesis de Análisis', 'Gestión de la Síntesis de Análisis', 0, 'DD', sysdate, 0);
insert into DD_TRE_TIPO_REGLAS_ELEVACION(DD_TRE_ID, DD_TRE_CODIGO, DD_TRE_DESCRIPCION, DD_TRE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values(S_DD_TRE_TIPO_REGLAS_ELEVACION.nextval, 'SOLVENCIA', 'Solvencia', 'Solvencia', 0, 'DD', sysdate, 0);
insert into DD_TRE_TIPO_REGLAS_ELEVACION(DD_TRE_ID, DD_TRE_CODIGO, DD_TRE_DESCRIPCION, DD_TRE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values(S_DD_TRE_TIPO_REGLAS_ELEVACION.nextval, 'ANTECEDENTES', 'Antecedentes', 'Antecedentes', 0, 'DD', sysdate, 0);
insert into DD_TRE_TIPO_REGLAS_ELEVACION(DD_TRE_ID, DD_TRE_CODIGO, DD_TRE_DESCRIPCION, DD_TRE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values(S_DD_TRE_TIPO_REGLAS_ELEVACION.nextval, 'GESTION_ANALISIS', 'Gestión y Análisis', 'Gestión y Análisis', 0, 'DD', sysdate, 0);
insert into DD_TRE_TIPO_REGLAS_ELEVACION(DD_TRE_ID, DD_TRE_CODIGO, DD_TRE_DESCRIPCION, DD_TRE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values(S_DD_TRE_TIPO_REGLAS_ELEVACION.nextval, 'DOCUMENTOS', 'Documentos', 'Documentos', 0, 'DD', sysdate, 0);


insert into DD_AEX_AMBITOS_EXPEDIENTE(DD_AEX_ID, DD_AEX_CODIGO, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values (S_DD_AEX_AMBITOS_EXPEDIENTE.nextval, 'CP', 'Solo el contrato de pase', 'Solo el contrato de pase', 0, 'DD', sysdate, 0);
insert into DD_AEX_AMBITOS_EXPEDIENTE(DD_AEX_ID, DD_AEX_CODIGO, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values (S_DD_AEX_AMBITOS_EXPEDIENTE.nextval, 'CG', 'Contrato de pase y contratos del grupo de clientes', 'Contrato de pase y contratos del grupo de clientes (del cliente que es primer titular del contrato de pase)', 0, 'DD', sysdate, 0);
insert into DD_AEX_AMBITOS_EXPEDIENTE(DD_AEX_ID, DD_AEX_CODIGO, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values (S_DD_AEX_AMBITOS_EXPEDIENTE.nextval, 'CPGRA', 'Contrato de pase, contratos del grupo de clientes y contratos de primera generación', 'Contrato de pase, contratos del grupo de clientes (del cliente que es primer titular del contrato de pase) y contratos de primera generación', 0, 'DD', sysdate, 0);
insert into DD_AEX_AMBITOS_EXPEDIENTE(DD_AEX_ID, DD_AEX_CODIGO, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values (S_DD_AEX_AMBITOS_EXPEDIENTE.nextval, 'CSGRA', 'Contrato de pase, contratos del grupo de clientes y contratos de primera y segunda generación', 'Contrato de pase, contratos del grupo de clientes (del cliente que es primer titular del contrato de pase) y contratos de primera y segunda generación', 0, 'DD', sysdate, 0);
insert into DD_AEX_AMBITOS_EXPEDIENTE(DD_AEX_ID, DD_AEX_CODIGO, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values (S_DD_AEX_AMBITOS_EXPEDIENTE.nextval, 'PP', 'Solo la persona de pase', 'Solo la persona de pase', 0, 'DD', sysdate, 0);
insert into DD_AEX_AMBITOS_EXPEDIENTE(DD_AEX_ID, DD_AEX_CODIGO, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values (S_DD_AEX_AMBITOS_EXPEDIENTE.nextval, 'PG', 'Persona de pase y personas del grupo de clientes', 'Persona de pase y personas del grupo de clientes (de la persona de pase)', 0, 'DD', sysdate, 0);
insert into DD_AEX_AMBITOS_EXPEDIENTE(DD_AEX_ID, DD_AEX_CODIGO, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values (S_DD_AEX_AMBITOS_EXPEDIENTE.nextval, 'PPGRA', 'Persona de pase, personas del grupo de clientes y personas de primera generación', 'Persona de pase, personas del grupo de clientes (de la persona de pase) y personas de primera generación', 0, 'DD', sysdate, 0);
insert into DD_AEX_AMBITOS_EXPEDIENTE(DD_AEX_ID, DD_AEX_CODIGO, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values (S_DD_AEX_AMBITOS_EXPEDIENTE.nextval, 'PSGRA', 'Persona de pase, personas del grupo de clientes y personas de primera y segunda generación', 'Persona de pase, personas del grupo de clientes (de la persona de pase) y personas de primera y segunda generación', 0, 'DD', sysdate, 0);

insert into DD_TTE_TIPO_TELEFONO       (DD_TTE_ID, DD_TTE_CODIGO,DD_TTE_DESCRIPCION,DD_TTE_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values (1,'9','codigo 9','Codigo 9','DD',sysdate);                                                           
insert into DD_TTE_TIPO_TELEFONO       (DD_TTE_ID, DD_TTE_CODIGO,DD_TTE_DESCRIPCION,DD_TTE_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values (2,'09','codigo 09','Codigo 09','DD',sysdate);                                                        
insert into DD_TTE_TIPO_TELEFONO       (DD_TTE_ID, DD_TTE_CODIGO,DD_TTE_DESCRIPCION,DD_TTE_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values (3,'07','codigo 07','Codigo 07','DD',sysdate);                                                        
insert into DD_TTE_TIPO_TELEFONO       (DD_TTE_ID, DD_TTE_CODIGO,DD_TTE_DESCRIPCION,DD_TTE_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values (4,'02','codigo 02','Codigo 02','DD',sysdate);                                                        
insert into DD_TTE_TIPO_TELEFONO       (DD_TTE_ID, DD_TTE_CODIGO,DD_TTE_DESCRIPCION,DD_TTE_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values (5,'30','codigo 30','Codigo 30','DD',sysdate);                                                        
                                                                                                                                                                                                                                                   
insert into DD_REX_RATING_EXTERNO      (DD_REX_ID, DD_REX_CODIGO,DD_REX_DESCRIPCION,DD_REX_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values (1,'9','codigo 9','Codigo 9','DD',sysdate);                                                           
insert into DD_RAX_RATING_AUXILIAR     (DD_RAX_ID, DD_RAX_CODIGO,DD_RAX_DESCRIPCION,DD_RAX_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values (1,'9','codigo 9','Codigo 9','DD',sysdate);                                                           
                                                                                                                                                                                                                                                   
insert into DD_MX3_MOVIMIENTO_EXTRA_3  (DD_MX3_ID, DD_MX3_CODIGO,DD_MX3_DESCRIPCION,DD_MX3_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values (1,'999999999','codigo 9','Codigo 9','DD',sysdate);                                                   
insert into DD_MX3_MOVIMIENTO_EXTRA_3  (DD_MX3_ID, DD_MX3_CODIGO,DD_MX3_DESCRIPCION,DD_MX3_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values (2,'9','codigo 9','Codigo 9','DD',sysdate);                                                   
insert into DD_MX4_MOVIMIENTO_EXTRA_4  (DD_MX4_ID, DD_MX4_CODIGO,DD_MX4_DESCRIPCION,DD_MX4_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values (1,'999999999','codigo 9','Codigo 9','DD',sysdate);                                                   
insert into DD_MX4_MOVIMIENTO_EXTRA_4  (DD_MX4_ID, DD_MX4_CODIGO,DD_MX4_DESCRIPCION,DD_MX4_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values (2,'9','codigo 9','Codigo 9','DD',sysdate);                                                   
--INSERT                                                                                                                                                                                                                                           
insert into DD_SEX_SEXOS               (DD_SEX_ID, DD_SEX_CODIGO,DD_SEX_DESCRIPCION,DD_SEX_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values (1,'H','Hombre','Hombre','DD',sysdate);                                                               
insert into DD_SEX_SEXOS               (DD_SEX_ID, DD_SEX_CODIGO,DD_SEX_DESCRIPCION,DD_SEX_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values (2,'M','Mujer','Mujer','DD',sysdate);                                                                 
insert into DD_SEX_SEXOS               (DD_SEX_ID, DD_SEX_CODIGO,DD_SEX_DESCRIPCION,DD_SEX_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values (3,'D','Desconocido','Desconocido','DD',sysdate);                                                                 
                                                                                                                                                                                                                                                   
insert into DD_PX3_PERSONA_EXTRA_3     (DD_PX3_ID, DD_PX3_CODIGO,DD_PX3_DESCRIPCION,DD_PX3_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values (1,'9','codigo 9','Codigo 9','DD',sysdate);                                                           
insert into DD_PX4_PERSONA_EXTRA_4     (DD_PX4_ID, DD_PX4_CODIGO,DD_PX4_DESCRIPCION,DD_PX4_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values (1,'9','codigo 9','Codigo 9','DD',sysdate);                                                           

INSERT INTO DD_PAC_PLAZO_ACEPTACION (DD_PAC_ID, DD_PAC_CODIGO, DD_PAC_DESCRIPCION, DD_PAC_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (S_DD_PAC_PLAZO_ACEPTACION.nextval, '1', 'Menor a 3 meses', 'Menor a 3 meses', 'DD', sysdate, 0);

INSERT INTO DD_PAC_PLAZO_ACEPTACION (DD_PAC_ID, DD_PAC_CODIGO, DD_PAC_DESCRIPCION, DD_PAC_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (S_DD_PAC_PLAZO_ACEPTACION.nextval, '2', 'Entre 3 meses y 6 meses', 'Entre 3 meses y 6 meses', 'DD', sysdate, 0);

INSERT INTO DD_PAC_PLAZO_ACEPTACION (DD_PAC_ID, DD_PAC_CODIGO, DD_PAC_DESCRIPCION, DD_PAC_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (S_DD_PAC_PLAZO_ACEPTACION.nextval, '3', 'Entre 6 meses y 12 meses', 'Entre 6 meses y 12 meses', 'DD', sysdate, 0);

INSERT INTO DD_PAC_PLAZO_ACEPTACION (DD_PAC_ID, DD_PAC_CODIGO, DD_PAC_DESCRIPCION, DD_PAC_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (S_DD_PAC_PLAZO_ACEPTACION.nextval, '4', 'Entre 12 meses y 24 meses', 'Entre 12 meses y 24 meses', 'DD', sysdate, 0);

INSERT INTO DD_PAC_PLAZO_ACEPTACION (DD_PAC_ID, DD_PAC_CODIGO, DD_PAC_DESCRIPCION, DD_PAC_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (S_DD_PAC_PLAZO_ACEPTACION.nextval, '5', 'Más de 24 meses', 'Más de 24 meses','DD', sysdate, 0);

insert into DD_TDE_TIPO_DESPACHO(dd_tde_id, dd_tde_codigo, dd_tde_descripcion, dd_tde_descripcion_larga, usuariocrear, fechacrear)
values (S_DD_TDE_TIPO_DESPACHO.nextval, '1', 'Despacho Externo', 'Despacho Externo', 'DD', sysdate);

insert into DD_TDE_TIPO_DESPACHO(dd_tde_id, dd_tde_codigo, dd_tde_descripcion, dd_tde_descripcion_larga, usuariocrear, fechacrear)
values (S_DD_TDE_TIPO_DESPACHO.nextval, '2', 'Despacho Procurador', 'Despacho Procurador', 'DD', sysdate);


