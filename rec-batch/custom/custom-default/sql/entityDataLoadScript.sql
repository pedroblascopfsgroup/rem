INSERT INTO config (id, valor) VALUES ('entidadId', :entidadId);
INSERT INTO config (id, valor) VALUES ('entidadDescripcion', :entidadDescripcion);

INSERT INTO niv_nivel (niv_id,niv_descripcion,niv_descripcion_larga,usuariocrear,fechacrear)
values (1,'Entidad','Nivel Entidad - Maximo Nivel','BatchUser',${sql.function.curdate});
INSERT INTO niv_nivel (niv_id,niv_descripcion,niv_descripcion_larga,usuariocrear,fechacrear)
values (2,'Territorio','Nivel Territorio','BatchUser',${sql.function.curdate});
INSERT INTO niv_nivel (niv_id,niv_descripcion,niv_descripcion_larga,usuariocrear,fechacrear)
values (3,'Zona','Nivel Zona','BatchUser',${sql.function.curdate});
INSERT INTO niv_nivel (niv_id,niv_descripcion,niv_descripcion_larga,usuariocrear,fechacrear)
values (4,'Oficina','Nivel Oficina','BatchUser',${sql.function.curdate});

INSERT INTO ofi_oficinas (OFI_ID,DD_PRV_ID,OFI_CODIGO,OFI_NOMBRE,OFI_TIPO_VIA,OFI_DOMICILIO,OFI_DOMICILIO_PLAZA,OFI_CODIGO_POSTAL,OFI_PERSONA_CONTACTO,OFI_TELEFONO2,OFI_TELEFONO1,usuariocrear,fechacrear,borrado)
VALUES (1,'1','5005','Oficina','Via','domicilio','domicilio plaza','1250','Juan Carlos Persona Contacto','15-5520-1121','15-5520-1122','BATCH_USER',${sql.function.curdate},'0');
INSERT INTO ofi_oficinas (OFI_ID,DD_PRV_ID,OFI_CODIGO,OFI_NOMBRE,OFI_TIPO_VIA,OFI_DOMICILIO,OFI_DOMICILIO_PLAZA,OFI_CODIGO_POSTAL,OFI_PERSONA_CONTACTO,OFI_TELEFONO2,OFI_TELEFONO1,usuariocrear,fechacrear,borrado)
VALUES (2,'1','5006','Oficina','Via','domicilio','domicilio plaza','1250','Juan Carlos Persona Contacto','15-5520-1121','15-5520-1122','BATCH_USER',${sql.function.curdate},'0');
INSERT INTO ofi_oficinas (OFI_ID,DD_PRV_ID,OFI_CODIGO,OFI_NOMBRE,OFI_TIPO_VIA,OFI_DOMICILIO,OFI_DOMICILIO_PLAZA,OFI_CODIGO_POSTAL,OFI_PERSONA_CONTACTO,OFI_TELEFONO2,OFI_TELEFONO1,usuariocrear,fechacrear,borrado)
VALUES (3,'1','5007','Oficina','Via','domicilio','domicilio plaza','1250','Juan Carlos Persona Contacto','15-5520-1121','15-5520-1122','BATCH_USER',${sql.function.curdate},'0');
INSERT INTO ofi_oficinas (OFI_ID,DD_PRV_ID,OFI_CODIGO,OFI_NOMBRE,OFI_TIPO_VIA,OFI_DOMICILIO,OFI_DOMICILIO_PLAZA,OFI_CODIGO_POSTAL,OFI_PERSONA_CONTACTO,OFI_TELEFONO2,OFI_TELEFONO1,usuariocrear,fechacrear,borrado)
VALUES (4,'1','5008','Oficina','Via','domicilio','domicilio plaza','1250','Juan Carlos Persona Contacto','15-5520-1121','15-5520-1122','BATCH_USER',${sql.function.curdate},'0');
INSERT INTO ofi_oficinas (OFI_ID,DD_PRV_ID,OFI_CODIGO,OFI_NOMBRE,OFI_TIPO_VIA,OFI_DOMICILIO,OFI_DOMICILIO_PLAZA,OFI_CODIGO_POSTAL,OFI_PERSONA_CONTACTO,OFI_TELEFONO2,OFI_TELEFONO1,usuariocrear,fechacrear,borrado)
VALUES (5,'1','5009','Oficina','Via','domicilio','domicilio plaza','1250','Juan Carlos Persona Contacto','15-5520-1121','15-5520-1122','BATCH_USER',${sql.function.curdate},'0');
INSERT INTO ofi_oficinas (OFI_ID,DD_PRV_ID,OFI_CODIGO,OFI_NOMBRE,OFI_TIPO_VIA,OFI_DOMICILIO,OFI_DOMICILIO_PLAZA,OFI_CODIGO_POSTAL,OFI_PERSONA_CONTACTO,OFI_TELEFONO2,OFI_TELEFONO1,usuariocrear,fechacrear,borrado)
VALUES (6,'2','5010','Oficina','Via','domicilio','domicilio plaza','1250','Juan Carlos Persona Contacto','15-5520-1121','15-5520-1122','BATCH_USER',${sql.function.curdate},'0');

-- INSERTING INTO ZON_ZONIFICACION
INSERT INTO ZON_ZONIFICACION (zon_id,ZON_COD,ZON_NUM_CENTRO,ZON_DESCRIPCION,ZON_DESCRIPCION_LARGA,ZON_PID,NIV_ID,OFI_ID,usuariocrear,fechacrear)
values (1,1001,001,'Entidad Banco Rio','Entidad Banco Santender Rio',null,1,null,'BatchUser',${sql.function.curdate});
INSERT INTO ZON_ZONIFICACION (zon_id,ZON_COD,ZON_NUM_CENTRO,ZON_DESCRIPCION,ZON_DESCRIPCION_LARGA,ZON_PID,NIV_ID,OFI_ID,usuariocrear,fechacrear)
values (2,10011001,002,'Valencia','Territorio Capital Federal',1,2,null,'BatchUser',${sql.function.curdate});
INSERT INTO ZON_ZONIFICACION (zon_id,ZON_COD,ZON_NUM_CENTRO,ZON_DESCRIPCION,ZON_DESCRIPCION_LARGA,ZON_PID,NIV_ID,OFI_ID,usuariocrear,fechacrear)
values (3,10011002,003,'Resto de Espaï¿½a','Territorio Resto de Espaï¿½a',1,2,null,'BatchUser',${sql.function.curdate});
INSERT INTO ZON_ZONIFICACION (zon_id,ZON_COD,ZON_NUM_CENTRO,ZON_DESCRIPCION,ZON_DESCRIPCION_LARGA,ZON_PID,NIV_ID,OFI_ID,usuariocrear,fechacrear)
values (4,100110011001,004,'Norte','Zona Norte',2,3,null,'BatchUser',${sql.function.curdate});
INSERT INTO ZON_ZONIFICACION (zon_id,ZON_COD,ZON_NUM_CENTRO,ZON_DESCRIPCION,ZON_DESCRIPCION_LARGA,ZON_PID,NIV_ID,OFI_ID,usuariocrear,fechacrear)
values (5,100110011002,005,'Sur','Zona Sur',2,3,null,'BatchUser',${sql.function.curdate});
INSERT INTO ZON_ZONIFICACION (zon_id,ZON_COD,ZON_NUM_CENTRO,ZON_DESCRIPCION,ZON_DESCRIPCION_LARGA,ZON_PID,NIV_ID,OFI_ID,usuariocrear,fechacrear)
values (6,100110021001,006,'Madrid','Zona Madrid',3,3,null,'BatchUser',${sql.function.curdate});
INSERT INTO ZON_ZONIFICACION (zon_id,ZON_COD,ZON_NUM_CENTRO,ZON_DESCRIPCION,ZON_DESCRIPCION_LARGA,ZON_PID,NIV_ID,OFI_ID,usuariocrear,fechacrear)
values (7,1001100110011001,007,'Plaza de Toros','Oficina Plaza de Toros',4,4,1,'BatchUser',${sql.function.curdate});
INSERT INTO ZON_ZONIFICACION (zon_id,ZON_COD,ZON_NUM_CENTRO,ZON_DESCRIPCION,ZON_DESCRIPCION_LARGA,ZON_PID,NIV_ID,OFI_ID,usuariocrear,fechacrear)
values (8,1001100110011002,008,'Plaza Reina','Oficina Plaza Reina',4,4,2,'BatchUser',${sql.function.curdate});
INSERT INTO ZON_ZONIFICACION (zon_id,ZON_COD,ZON_NUM_CENTRO,ZON_DESCRIPCION,ZON_DESCRIPCION_LARGA,ZON_PID,NIV_ID,OFI_ID,usuariocrear,fechacrear)
values (9,1001100110011003,009,'Aeropuerto','Oficina Aeropuerto',4,4,3,'BatchUser',${sql.function.curdate});
INSERT INTO ZON_ZONIFICACION (zon_id,ZON_COD,ZON_NUM_CENTRO,ZON_DESCRIPCION,ZON_DESCRIPCION_LARGA,ZON_PID,NIV_ID,OFI_ID,usuariocrear,fechacrear)
values (10,1001100110021001,010,'Puerto','Oficina Puerto',5,4,4,'BatchUser',${sql.function.curdate});
INSERT INTO ZON_ZONIFICACION (zon_id,ZON_COD,ZON_NUM_CENTRO,ZON_DESCRIPCION,ZON_DESCRIPCION_LARGA,ZON_PID,NIV_ID,OFI_ID,usuariocrear,fechacrear)
values (11,1001100110021002,011,'Oceanografico','Oficina Oceanografico',5,4,5,'BatchUser',${sql.function.curdate});
INSERT INTO ZON_ZONIFICACION (zon_id,ZON_COD,ZON_NUM_CENTRO,ZON_DESCRIPCION,ZON_DESCRIPCION_LARGA,ZON_PID,NIV_ID,OFI_ID,usuariocrear,fechacrear)
values (12,1001100210011001,012,'Centro','Oficina Centro',6,4,6,'BatchUser',${sql.function.curdate});

-- PERFILES
INSERT INTO pef_perfiles (pef_id,pef_codigo, pef_descripcion_larga,pef_descripcion,version,usuariocrear,fechacrear,borrado)
VALUES (1,'1', 'Gestor Clientes', 'Gestor Clientes de Prueba', 0,'DD', ${sql.function.curdate}, 0);
INSERT INTO pef_perfiles (pef_id,pef_codigo, pef_descripcion_larga,pef_descripcion,version,usuariocrear,fechacrear,borrado)
VALUES (2,'2', 'Supervisor Clientes', 'Supervisor Clientes de Prueba', 0,'DD', ${sql.function.curdate}, 0);
INSERT INTO pef_perfiles (pef_id,pef_codigo, pef_descripcion_larga,pef_descripcion,version,usuariocrear,fechacrear,borrado)
VALUES (3,'3', 'Gestor Expedientes', 'Gestor Expedientes de Prueba', 0,'DD', ${sql.function.curdate}, 0);
INSERT INTO pef_perfiles (pef_id,pef_codigo, pef_descripcion_larga,pef_descripcion,version,usuariocrear,fechacrear,borrado)
VALUES (4,'4', 'Supervisor Expedientes', 'Supervisor Expedientes de Prueba', 0,'DD', ${sql.function.curdate}, 0);
INSERT INTO pef_perfiles (pef_id,pef_codigo, pef_descripcion_larga,pef_descripcion,version,usuariocrear,fechacrear,borrado)
VALUES (5,'5', 'Comite', 'Comite', 0,'DD', ${sql.function.curdate}, 0);
INSERT INTO pef_perfiles (pef_id,pef_codigo, pef_descripcion_larga,pef_descripcion,version,usuariocrear,fechacrear,borrado)
VALUES (6,'6', 'Administrador', 'Administrador', 0,'DD', ${sql.function.curdate}, 0);

-- COMITE por defecto entidad
INSERT INTO com_comites (com_id, zon_id, com_nombre, com_atribucion_min, com_atribucion_max, com_prioridad, usuariocrear, fechacrear, borrado)
VALUES(1, 1, 'Comite default', null, null, 9, 'DD', ${sql.function.curdate} ,0);

INSERT INTO com_comites (com_id, zon_id, com_nombre, com_atribucion_min, com_atribucion_max, com_prioridad, usuariocrear, fechacrear, borrado)
VALUES(2, 1, 'Comite 1', 100001, 100000000, 1, 'DD', ${sql.function.curdate} ,0);

INSERT INTO com_comites (com_id, zon_id, com_nombre, com_atribucion_min, com_atribucion_max, com_prioridad,  usuariocrear, fechacrear, borrado)
VALUES(3, 1, 'Comite 2', 0, 100000, 2, 'DD', ${sql.function.curdate} ,0);

--PCO_PUESTOS_COMITE
INSERT INTO pco_puestos_comite (pco_id, com_id, pef_id, zon_id, pco_restrictivo, pco_supervisor, version, usuariocrear, fechacrear, borrado)
VALUES(1, 1, 5, 1, 0, 1, 0, 'dd', ${sql.function.curdate} ,0);

INSERT INTO pco_puestos_comite (pco_id, com_id, pef_id, zon_id, pco_restrictivo, pco_supervisor, version, usuariocrear, fechacrear, borrado)
VALUES(2, 2, 5, 1, 0, 1, 0, 'dd', ${sql.function.curdate} ,0);

INSERT INTO pco_puestos_comite (pco_id, com_id, pef_id, zon_id, pco_restrictivo, pco_supervisor, version, usuariocrear, fechacrear, borrado)
VALUES(3, 3, 5, 1, 0, 1, 0, 'DD', ${sql.function.curdate} ,0);

INSERT INTO des_despacho_externo (des_id,des_despacho,des_tipo_via,des_domicilio,des_domicilio_plaza,des_codigo_postal,des_persona_contacto,des_telefono2,des_telefono1,version,usuariocrear,fechacrear,usuariomodificar,fechamodificar,usuarioborrar,fechaborrar,borrado)
VALUES (1,'Despacho','Avenida','9 de Julio','456','12345','Sergio Denis','1234-5678','1234-5679',0,'DD',${sql.function.curdate},null,null,null,null,'0');

INSERT INTO des_despacho_externo (des_id,des_despacho,des_tipo_via,des_domicilio,des_domicilio_plaza,des_codigo_postal,des_persona_contacto,des_telefono2,des_telefono1,version,usuariocrear,fechacrear,usuariomodificar,fechamodificar,usuarioborrar,fechaborrar,borrado)
VALUES (2,'Despachio','Avenida','25 de Mayo','456','12345','Guillermo Guido','1234-5678','1234-5679',0,'DD',${sql.function.curdate},null,null,null,null,'0');

INSERT INTO usd_usuarios_despachos (usd_id,usu_id,des_id,usd_gestor_defecto,usd_supervisor,version,usuariocrear,fechacrear,borrado)
values (1,6,1,1,1,1,'DD',${sql.function.curdate},0);

INSERT INTO usd_usuarios_despachos (usd_id,usu_id,des_id,usd_gestor_defecto,usd_supervisor,version,usuariocrear,fechacrear,borrado)
values (2,5,1,0,0,1,'DD',${sql.function.curdate},0);

INSERT INTO usd_usuarios_despachos (usd_id,usu_id,des_id,usd_gestor_defecto,usd_supervisor,version,usuariocrear,fechacrear,borrado)
values (3,4,2,0,1,1,'DD',${sql.function.curdate},0);

INSERT INTO usd_usuarios_despachos (usd_id,usu_id,des_id,usd_gestor_defecto,usd_supervisor,version,usuariocrear,fechacrear,borrado)
values (4,3,2,1,0,1,'DD',${sql.function.curdate},0);

INSERT INTO DD_PLA_PLAZAS (DD_PLA_ID, DD_PLA_CODIGO, DD_PLA_DESCRIPCION, DD_PLA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES (1, '1', 'Plaza Lalala', 'Plaza Lalala!!!', 'DD', ${sql.function.curdate});
INSERT INTO DD_PLA_PLAZAS (DD_PLA_ID, DD_PLA_CODIGO, DD_PLA_DESCRIPCION, DD_PLA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES (2, '2', 'Plaza Italia', 'Cruzate y anda a la rural', 'DD', ${sql.function.curdate});
INSERT INTO DD_PLA_PLAZAS (DD_PLA_ID, DD_PLA_CODIGO, DD_PLA_DESCRIPCION, DD_PLA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES (3, '3', 'Plaza Lobelto', '....', 'DD', ${sql.function.curdate});

INSERT INTO DD_JUZ_JUZGADOS_PLAZA (DD_JUZ_ID, DD_JUZ_CODIGO, DD_JUZ_DESCRIPCION, DD_JUZ_DESCRIPCION_LARGA, DD_PLA_ID, USUARIOCREAR, FECHACREAR) VALUES (1, '1', 'Juzgado Correccional XX', 'Juzgado Correccional Nro XX', 1, 'DD', ${sql.function.curdate});
INSERT INTO DD_JUZ_JUZGADOS_PLAZA (DD_JUZ_ID, DD_JUZ_CODIGO, DD_JUZ_DESCRIPCION, DD_JUZ_DESCRIPCION_LARGA, DD_PLA_ID, USUARIOCREAR, FECHACREAR) VALUES (2, '2', 'Juzgado Don Roque!', 'Juzgado Don Roque Nro 145', 2, 'DD', ${sql.function.curdate});
INSERT INTO DD_JUZ_JUZGADOS_PLAZA (DD_JUZ_ID, DD_JUZ_CODIGO, DD_JUZ_DESCRIPCION, DD_JUZ_DESCRIPCION_LARGA, DD_PLA_ID, USUARIOCREAR, FECHACREAR) VALUES (3, '3', 'Juzgado La Cometa', '....', 2, 'DD', ${sql.function.curdate});

INSERT INTO DD_TSA_TIPO_SOLUC_AMISTO (DD_TSA_ID, DD_TSA_CODIGO,DD_TSA_DESCRIPCION,DD_TSA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 1,'01', 'Tipo Solucion 1', 'Tipo Solucion 1', 'DD', ${sql.function.curdate} );
INSERT INTO DD_TSA_TIPO_SOLUC_AMISTO (DD_TSA_ID, DD_TSA_CODIGO,DD_TSA_DESCRIPCION,DD_TSA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 2,'02', 'Tipo Solucion 2', 'Tipo Solucion 2', 'DD', ${sql.function.curdate} );
INSERT INTO DD_TSA_TIPO_SOLUC_AMISTO (DD_TSA_ID, DD_TSA_CODIGO,DD_TSA_DESCRIPCION,DD_TSA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 3,'03', 'Tipo Solucion 3', 'Tipo Solucion 3', 'DD', ${sql.function.curdate} );
INSERT INTO DD_TSA_TIPO_SOLUC_AMISTO (DD_TSA_ID, DD_TSA_CODIGO,DD_TSA_DESCRIPCION,DD_TSA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( 4,'04', 'Tipo Solucion 4', 'Tipo Solucion 4', 'DD', ${sql.function.curdate} );

INSERT INTO DD_SSA_SUBTI_SOLUC_AMIST (DD_SSA_ID, DD_TSA_ID, DD_SSA_CODIGO,DD_SSA_DESCRIPCION,DD_SSA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( S_DD_SSA_SUBTI_SOLUC_AMIST.nextVal, 1,'11', 'SubTipo 1 Solucion 1', 'SubTipo 1 Solucion 1', 'DD', ${sql.function.curdate} );
INSERT INTO DD_SSA_SUBTI_SOLUC_AMIST (DD_SSA_ID, DD_TSA_ID, DD_SSA_CODIGO,DD_SSA_DESCRIPCION,DD_SSA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( S_DD_SSA_SUBTI_SOLUC_AMIST.nextVal, 1,'12', 'SubTipo 2 Solucion 1', 'SubTipo 2 Solucion 1', 'DD', ${sql.function.curdate} );
INSERT INTO DD_SSA_SUBTI_SOLUC_AMIST (DD_SSA_ID, DD_TSA_ID, DD_SSA_CODIGO,DD_SSA_DESCRIPCION,DD_SSA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( S_DD_SSA_SUBTI_SOLUC_AMIST.nextVal, 2,'21', 'SubTipo 1 Solucion 2', 'SubTipo 1 Solucion 2', 'DD', ${sql.function.curdate} );
INSERT INTO DD_SSA_SUBTI_SOLUC_AMIST (DD_SSA_ID, DD_TSA_ID, DD_SSA_CODIGO,DD_SSA_DESCRIPCION,DD_SSA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( S_DD_SSA_SUBTI_SOLUC_AMIST.nextVal, 2,'22', 'SubTipo 2 Solucion 2', 'SubTipo 2 Solucion 2', 'DD', ${sql.function.curdate} );
INSERT INTO DD_SSA_SUBTI_SOLUC_AMIST (DD_SSA_ID, DD_TSA_ID, DD_SSA_CODIGO,DD_SSA_DESCRIPCION,DD_SSA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( S_DD_SSA_SUBTI_SOLUC_AMIST.nextVal, 3,'31', 'SubTipo 1 Solucion 3', 'SubTipo 1 Solucion 3', 'DD', ${sql.function.curdate} );
INSERT INTO DD_SSA_SUBTI_SOLUC_AMIST (DD_SSA_ID, DD_TSA_ID, DD_SSA_CODIGO,DD_SSA_DESCRIPCION,DD_SSA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( S_DD_SSA_SUBTI_SOLUC_AMIST.nextVal, 3,'32', 'SubTipo 2 Solucion 3', 'SubTipo 2 Solucion 3', 'DD', ${sql.function.curdate} );
INSERT INTO DD_SSA_SUBTI_SOLUC_AMIST (DD_SSA_ID, DD_TSA_ID, DD_SSA_CODIGO,DD_SSA_DESCRIPCION,DD_SSA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( S_DD_SSA_SUBTI_SOLUC_AMIST.nextVal, 4,'41', 'SubTipo 1 Solucion 4', 'SubTipo 1 Solucion 4', 'DD', ${sql.function.curdate} );
INSERT INTO DD_SSA_SUBTI_SOLUC_AMIST (DD_SSA_ID, DD_TSA_ID, DD_SSA_CODIGO,DD_SSA_DESCRIPCION,DD_SSA_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) values ( S_DD_SSA_SUBTI_SOLUC_AMIST.nextVal, 4,'42', 'SubTipo 2 Solucion 4', 'SubTipo 2 Solucion 4', 'DD', ${sql.function.curdate} );

-- Proveedores de telecobro
INSERT INTO pte_proveedor_telecobro (PTE_ID, PTE_PROVEEDOR, USUARIOCREAR, FECHACREAR)
VALUES(600, 'Proveeder telecobro', 'TEST', ${sql.function.curdate});

-- Estados de telecobro 
INSERT INTO tel_estado_telecobro(TEL_ID, PTE_ID, TEL_PLAZO_INI, TEL_PLAZO_FIN, TEL_DIAS_ANTELACION, TEL_PLAZO_RESPUESTA,  USUARIOCREAR, FECHACREAR) 
VALUES(1, 600, 40000, 50000, 1, 4000,'Test', ${sql.function.curdate});

-- ITINERARIOS
INSERT INTO iti_itinerarios (iti_id, iti_nombre,DD_TIT_ID, usuariocrear, fechacrear, dd_aex_id)
VALUES(1,'Default Cliente',(SELECT DD_TIT_ID FROM ${master.schema}.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO ='REC'), 'N/A', ${sql.function.curdate}, (select dd_aex_id from ${master.schema}.dd_aex_ambitos_expediente where dd_aex_codigo = 'CSGRA'));
INSERT INTO iti_itinerarios (iti_id, iti_nombre,DD_TIT_ID, usuariocrear, fechacrear, dd_aex_id)
VALUES(2,'Default Expediente',(SELECT DD_TIT_ID FROM ${master.schema}.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO ='REC'), 'N/A', ${sql.function.curdate}, (select dd_aex_id from ${master.schema}.dd_aex_ambitos_expediente where dd_aex_codigo = 'CSGRA'));
INSERT INTO iti_itinerarios (iti_id, iti_nombre,DD_TIT_ID, usuariocrear, fechacrear, dd_aex_id)
VALUES(3,'Default Automatico',(SELECT DD_TIT_ID FROM ${master.schema}.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO ='REC'), 'N/A', ${sql.function.curdate}, (select dd_aex_id from ${master.schema}.dd_aex_ambitos_expediente where dd_aex_codigo = 'CSGRA'));
INSERT INTO iti_itinerarios (iti_id, iti_nombre,DD_TIT_ID, usuariocrear, fechacrear, dd_aex_id)
VALUES(4,'Default',(SELECT DD_TIT_ID FROM ${master.schema}.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO ='REC'), 'N/A', ${sql.function.curdate}, (select dd_aex_id from ${master.schema}.dd_aex_ambitos_expediente where dd_aex_codigo = 'CSGRA'));
INSERT INTO iti_itinerarios (iti_id, iti_nombre,DD_TIT_ID, usuariocrear, fechacrear, dd_aex_id)
VALUES(5,'Telecobro',(SELECT DD_TIT_ID FROM ${master.schema}.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO ='REC'), 'N/A', ${sql.function.curdate}, (select dd_aex_id from ${master.schema}.dd_aex_ambitos_expediente where dd_aex_codigo = 'CSGRA'));
INSERT INTO iti_itinerarios (iti_id, iti_nombre,DD_TIT_ID, usuariocrear, fechacrear, dd_aex_id)
VALUES(6,'Auto Asu Manual',(SELECT DD_TIT_ID FROM ${master.schema}.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO ='REC'), 'N/A', ${sql.function.curdate}, (select dd_aex_id from ${master.schema}.dd_aex_ambitos_expediente where dd_aex_codigo = 'CSGRA'));
INSERT INTO iti_itinerarios (iti_id, iti_nombre,DD_TIT_ID, usuariocrear, fechacrear, dd_aex_id)
VALUES(7,'Auto Asu Aceptado',(SELECT DD_TIT_ID FROM ${master.schema}.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO ='REC'), 'N/A', ${sql.function.curdate}, (select dd_aex_id from ${master.schema}.dd_aex_ambitos_expediente where dd_aex_codigo = 'CSGRA'));

-- Tipos de producto
INSERT INTO dd_tpr_tipo_prod (dd_tpr_id,dd_tpr_codigo,dd_tpr_descripcion,dd_tpr_descripcion_larga,usuariocrear,fechacrear)
VALUES (10101,'t1', 'CC Cliente','Cuenta Corriente de Cliente','DD',${sql.function.curdate});
INSERT INTO dd_tpr_tipo_prod (dd_tpr_id,dd_tpr_codigo,dd_tpr_descripcion,dd_tpr_descripcion_larga,usuariocrear,fechacrear)
VALUES (10102,'t2', 'Hipoteca Expediente','Prestamo hipotecario','dd',${sql.function.curdate});
INSERT INTO dd_tpr_tipo_prod(dd_tpr_id,dd_tpr_codigo,dd_tpr_descripcion, dd_tpr_descripcion_larga, usuariocrear, fechacrear)
VALUES (10103,'t3', 'Hipoteca Automatico','Hipoteca Automatico', 'TEST', ${sql.function.curdate});
INSERT INTO dd_tpr_tipo_prod(dd_tpr_id,dd_tpr_codigo,dd_tpr_descripcion, dd_tpr_descripcion_larga, usuariocrear, fechacrear)
VALUES (10104,'t4', 'Telecobro','Telecobro', 'TEST', ${sql.function.curdate});
INSERT INTO dd_tpr_tipo_prod(dd_tpr_id,dd_tpr_codigo,dd_tpr_descripcion, dd_tpr_descripcion_larga, usuariocrear, fechacrear)
VALUES (10105,'t5', 'AutoAsuManual','Auto Asu Manual', 'TEST', ${sql.function.curdate});
INSERT INTO dd_tpr_tipo_prod(dd_tpr_id,dd_tpr_codigo,dd_tpr_descripcion, dd_tpr_descripcion_larga, usuariocrear, fechacrear)
VALUES (10106,'t6', 'AutoAsuAceptado','Auto Asu Aceptado', 'TEST', ${sql.function.curdate});
INSERT INTO dd_tpr_tipo_prod(dd_tpr_id,dd_tpr_codigo,dd_tpr_descripcion, dd_tpr_descripcion_larga, usuariocrear, fechacrear)
VALUES (10109,'t9', 'Pasivo','Pasivo', 'TEST', ${sql.function.curdate});

INSERT INTO dd_tpe_tipo_prod_entidad (dd_tpe_id,dd_tpr_id,dd_tpe_codigo,dd_tpe_activo, dd_tpe_descripcion,dd_tpe_descripcion_larga,usuariocrear,fechacrear)
VALUES (1,10101,'10101',1,'CC Cliente','CC Cliente','DD',${sql.function.curdate});
INSERT INTO dd_tpe_tipo_prod_entidad (dd_tpe_id,dd_tpr_id,dd_tpe_codigo,dd_tpe_activo, dd_tpe_descripcion,dd_tpe_descripcion_larga,usuariocrear,fechacrear)
VALUES (2,10102,'10102',1,'Hipoteca Expediente','Hipoteca Expediente','DD',${sql.function.curdate});
INSERT INTO dd_tpe_tipo_prod_entidad (dd_tpe_id,dd_tpr_id,dd_tpe_codigo,dd_tpe_activo, dd_tpe_descripcion,dd_tpe_descripcion_larga,usuariocrear,fechacrear)
VALUES (3,10103,'10103',1,'Automatico','Automatico','DD',${sql.function.curdate});
INSERT INTO dd_tpe_tipo_prod_entidad (dd_tpe_id,dd_tpr_id,dd_tpe_codigo,dd_tpe_activo, dd_tpe_descripcion,dd_tpe_descripcion_larga,usuariocrear,fechacrear)
VALUES (4,10109,'10109',0,'Pasivo','Pasivo','DD',${sql.function.curdate});
INSERT INTO dd_tpe_tipo_prod_entidad (dd_tpe_id,dd_tpr_id,dd_tpe_codigo,dd_tpe_activo, dd_tpe_descripcion,dd_tpe_descripcion_larga,usuariocrear,fechacrear)
VALUES (5,10104,'10104',1,'Telecobro','Telecobro','DD',${sql.function.curdate});
INSERT INTO dd_tpe_tipo_prod_entidad (dd_tpe_id,dd_tpr_id,dd_tpe_codigo,dd_tpe_activo, dd_tpe_descripcion,dd_tpe_descripcion_larga,usuariocrear,fechacrear)
VALUES (6,10105,'10105',1,'AutoAsuManual','AutoAsuManual','DD',${sql.function.curdate});
INSERT INTO dd_tpe_tipo_prod_entidad (dd_tpe_id,dd_tpr_id,dd_tpe_codigo,dd_tpe_activo, dd_tpe_descripcion,dd_tpe_descripcion_larga,usuariocrear,fechacrear)
VALUES (7,10106,'10106',1,'AutoAsuAceptado','AutoAsuAceptado','DD',${sql.function.curdate});

-- Arquetipos por Default
INSERT INTO arq_arquetipos (arq_id, iti_id, dd_tpe_id, arq_prioridad, arq_nombre, arq_reincidencias, arq_riesgo_total_fin, arq_riesgo_total_ini, usuariocrear, fechacrear)
VALUES(9001, 1, null, 1, 'Default Cliente',null,null, null,'Default', ${sql.function.curdate});

INSERT INTO arq_arquetipos (arq_id, iti_id, dd_tpe_id, arq_prioridad, arq_nombre, arq_reincidencias, arq_riesgo_total_fin, arq_riesgo_total_ini, usuariocrear, fechacrear)
VALUES(9002, 2, null, 2, 'Default Expediente',null,null,null,'Default', ${sql.function.curdate});

INSERT INTO arq_arquetipos (arq_id, iti_id, dd_tpe_id, arq_prioridad, arq_nombre, arq_reincidencias, arq_riesgo_total_fin, arq_riesgo_total_ini, usuariocrear, fechacrear)
VALUES(9003, 3, null, 3, 'Default automatico',null,null, null,'Default', ${sql.function.curdate});

INSERT INTO arq_arquetipos (arq_id, iti_id, dd_tpe_id, arq_prioridad, arq_nombre, arq_reincidencias, arq_riesgo_total_fin, arq_riesgo_total_ini, usuariocrear, fechacrear)
VALUES(9004, 5, null, 1000, 'Default Telecobro',null,null, null,'Default', ${sql.function.curdate});

INSERT INTO arq_arquetipos (arq_id, iti_id, dd_tpe_id, arq_prioridad, arq_nombre, arq_reincidencias, arq_riesgo_total_fin, arq_riesgo_total_ini, usuariocrear, fechacrear)
VALUES(9005, 6, null, 3, 'Auto Asu Manual',null,null, null,'Default', ${sql.function.curdate});

INSERT INTO arq_arquetipos (arq_id, iti_id, dd_tpe_id, arq_prioridad, arq_nombre, arq_reincidencias, arq_riesgo_total_fin, arq_riesgo_total_ini, usuariocrear, fechacrear)
VALUES(9006, 7, null, 3, 'Auto Asu aceptado',null,null, null,'Default', ${sql.function.curdate});

INSERT INTO arq_arquetipos (arq_id, iti_id, dd_tpe_id, arq_prioridad, arq_nombre, arq_reincidencias, arq_riesgo_total_fin, arq_riesgo_total_ini, usuariocrear, fechacrear)
VALUES(9999, 4, null, 99999999999999, 'Default para todos',null,null, null,'Default', ${sql.function.curdate});

-- El arq. 'Default Cliente' NO debe tener producto del tipo 10102, 10103, 10104, 10105 y 10106
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1101, 9001,10102,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1102, 9001,10103,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1103, 9001,10104,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1104, 9001,10105,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1105, 9001,10106,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});

-- El arq. 'Default Expediente' NO debe tener producto del tipo '10101', '10103', 10104, 10105 y 10106
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1201, 9002,10101,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1202, 9002,10103,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1203, 9002,10104,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1204, 9002,10105,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1205, 9002,10106,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});

-- El arq. 'Default automatico' NO debe tener producto del tipo 10101, 10102, 10104, 10105 y 10106
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1301, 9003,10101,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1302, 9003,10102,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1303, 9003,10104,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1304, 9003,10105,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1305, 9003,10106,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});

-- El arq. 'Default Telecobro' debe tener producto del tipo 10104 y no 10105 y 10106
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1401, 9004,10104,0, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1402, 9004,10105,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1403, 9004,10106,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});

-- El arq. 'Auto Asu Manual' debe tener producto del tipo 10105 y no 10104 y 10106
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1501, 9005,10105,0, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1502, 9005,10104,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1503, 9005,10106,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});

-- El arq. 'Auto Asu Aceptado' debe tener producto del tipo 10106 y no 10104 y 10105
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1601, 9006,10106,0, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1602, 9006,10104,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});
INSERT INTO arq_cnt_tipos_producto (arq_cnt_id, arq_id, dd_tpr_id, arq_cnt_inclusion_exclusion, arq_cnt_importe_desde, arq_cnt_importe_hasta, arq_cnt_fallido, usuariocrear, fechacrear)
VALUES(1603, 9006,10105,1, 0, 99999999999999,0, 'Default', ${sql.function.curdate});

INSERT INTO dd_scl_segto_cli (dd_scl_id,DD_SCL_CODIGO,dd_scl_descripcion,dd_scl_descripcion_larga,usuariocrear,fechacrear)
VALUES (1,'C','Cliente A','Cliente A','DD',${sql.function.curdate});
INSERT INTO dd_scl_segto_cli (dd_scl_id,DD_SCL_CODIGO,dd_scl_descripcion,dd_scl_descripcion_larga,usuariocrear,fechacrear)
VALUES (2,'A','Cliente B','Cliente B','DD',${sql.function.curdate});

INSERT INTO DD_SCE_SEGTO_CLI_ENTIDAD (DD_SCE_ID,DD_SCL_ID,DD_SCE_CODIGO, DD_SCE_DESCRIPCION,DD_SCE_DESCRIPCION_LARGA,usuariocrear,fechacrear)
VALUES (1,1,'A1','SegmentoA1','SegmentoA1','DD',${sql.function.curdate});
INSERT INTO DD_SCE_SEGTO_CLI_ENTIDAD (DD_SCE_ID,DD_SCL_ID,DD_SCE_CODIGO, DD_SCE_DESCRIPCION,DD_SCE_DESCRIPCION_LARGA,usuariocrear,fechacrear)
VALUES (2,1,'A2','SegmentoA2','SegmentoA2','DD',${sql.function.curdate});
INSERT INTO DD_SCE_SEGTO_CLI_ENTIDAD (DD_SCE_ID,DD_SCL_ID,DD_SCE_CODIGO, DD_SCE_DESCRIPCION,DD_SCE_DESCRIPCION_LARGA,usuariocrear,fechacrear)
VALUES (3,2,'B1','SegmentoB1','SegmentoB1','DD',${sql.function.curdate});
INSERT INTO DD_SCE_SEGTO_CLI_ENTIDAD (DD_SCE_ID,DD_SCL_ID,DD_SCE_CODIGO, DD_SCE_DESCRIPCION,DD_SCE_DESCRIPCION_LARGA,usuariocrear,fechacrear)
VALUES (4,2,'B2','SegmentoB2','SegmentoB2','DD',${sql.function.curdate});

-- DD_TIN_TIPO_INTERVENCION (DD_TIN_TIPO_INTERVENCION)
INSERT INTO DD_TIN_TIPO_INTERVENCION (DD_TIN_ID,DD_TIN_CODIGO,DD_TIN_TITULAR,DD_TIN_AVALISTA,DD_TIN_DESCRIPCION,DD_TIN_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) 
VALUES (S_DD_TIN_TIPO_INTERVENCION.nextVal,'Tit',1,0,'Titular','Titular','DD',${sql.function.curdate});
INSERT INTO DD_TIN_TIPO_INTERVENCION (DD_TIN_ID,DD_TIN_CODIGO,DD_TIN_TITULAR,DD_TIN_AVALISTA,DD_TIN_DESCRIPCION,DD_TIN_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) 
VALUES (S_DD_TIN_TIPO_INTERVENCION.nextVal,'03',0,1,'Avalista','Avalista','DD',${sql.function.curdate});
INSERT INTO DD_TIN_TIPO_INTERVENCION (DD_TIN_ID,DD_TIN_CODIGO,DD_TIN_TITULAR,DD_TIN_AVALISTA,DD_TIN_DESCRIPCION,DD_TIN_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) 
VALUES (S_DD_TIN_TIPO_INTERVENCION.nextVal,'04',0,1,'Avalista no solidario','Avalista no solidario','DD',${sql.function.curdate});
INSERT INTO DD_TIN_TIPO_INTERVENCION (DD_TIN_ID,DD_TIN_CODIGO,DD_TIN_TITULAR,DD_TIN_AVALISTA,DD_TIN_DESCRIPCION,DD_TIN_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) 
VALUES (S_DD_TIN_TIPO_INTERVENCION.nextVal,'19',0,1,'Avalista subsidiario','Avalista subsidiario','DD',${sql.function.curdate});

-- FUN_PEF
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-CLI'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-EXP'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-ASU'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ROLE_ADMIN'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BUSQUEDA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ROLE_COMITE'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_TITULOS'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_PROCEDIMIENTO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_GYA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='CERRAR_DECISION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_CONTRATO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_CONTRATO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ASIGNAR_ASUNTO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='COMUNICACION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='RESPONDER'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_SOLVENCIA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_ANTECEDENTES'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='SOLICITAR_PRORROGA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-CLI'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Oficina'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-EXP'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Oficina'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BUSQUEDA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Oficina'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_TITULOS'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Oficina'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_GYA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Oficina'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='COMUNICACION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Oficina'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='RESPONDER'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Oficina'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_SOLVENCIA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Oficina'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_ANTECEDENTES'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Oficina'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Oficina'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Oficina'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='SOLICITAR_PRORROGA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Oficina'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-CLI'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Zona'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-EXP'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Zona'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BUSQUEDA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Zona'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_TITULOS'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Zona'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_GYA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Zona'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='COMUNICACION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Zona'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='RESPONDER'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Zona'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_SOLVENCIA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Zona'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_ANTECEDENTES'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Zona'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Zona'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Zona'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='SOLICITAR_PRORROGA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Zona'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-CLI'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-EXP'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BUSQUEDA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_TITULOS'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_GYA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='COMUNICACION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='RESPONDER'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_SOLVENCIA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_ANTECEDENTES'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='SOLICITAR_PRORROGA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-CLI'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-EXP'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BUSQUEDA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_TITULOS'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_GYA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='COMUNICACION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='RESPONDER'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_SOLVENCIA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_ANTECEDENTES'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='SOLICITAR_PRORROGA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-CLI'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-EXP'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BUSQUEDA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_TITULOS'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_GYA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='COMUNICACION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='RESPONDER'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_SOLVENCIA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_ANTECEDENTES'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='SOLICITAR_PRORROGA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-CLI'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-EXP'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BUSQUEDA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_TITULOS'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_GYA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='COMUNICACION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='RESPONDER'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_SOLVENCIA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_ANTECEDENTES'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='SOLICITAR_PRORROGA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='SOLICITAR_PRORROGA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Comite No Restrict.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BUSQUEDA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Comite No Restrict.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ROLE_COMITE'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Comite No Restrict.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='CERRAR_DECISION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Comite No Restrict.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_CONTRATO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Comite No Restrict.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_CONTRATO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Comite No Restrict.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ASIGNAR_ASUNTO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Comite No Restrict.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='COMUNICACION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Comite No Restrict.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='RESPONDER'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Comite No Restrict.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-CLI'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-EXP'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-ASU'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ROLE_ADMIN'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BUSQUEDA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ROLE_COMITE'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_TITULOS'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_PROCEDIMIENTO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_GYA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='CERRAR_DECISION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_CONTRATO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_CONTRATO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ASIGNAR_ASUNTO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='COMUNICACION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='RESPONDER'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_SOLVENCIA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_ANTECEDENTES'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='SOLICITAR_PRORROGA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Miembro Com. Ficticio'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-CLI'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Director General'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-EXP'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Director General'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BUSQUEDA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Director General'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ROLE_COMITE'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='CERRAR_DECISION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_CONTRATO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_CONTRATO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ASIGNAR_ASUNTO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ROLE_COMITE'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='CERRAR_DECISION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_CONTRATO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_CONTRATO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ASIGNAR_ASUNTO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ROLE_COMITE'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='CERRAR_DECISION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_CONTRATO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_CONTRATO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ASIGNAR_ASUNTO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ROLE_COMITE'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='CERRAR_DECISION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_CONTRATO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_CONTRATO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ASIGNAR_ASUNTO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ROLE_COMITE'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Director General'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='CERRAR_DECISION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Director General'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_CONTRATO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Director General'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_CONTRATO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Director General'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='ASIGNAR_ASUNTO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Director General'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_PROCEDIMIENTO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Director General'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_PROCEDIMIENTO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_PROCEDIMIENTO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_PROCEDIMIENTO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_PROCEDIMIENTO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-CLI'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Auditoria Interna'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-EXP'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Auditoria Interna'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BUSQUEDA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Auditoria Interna'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_TITULOS'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Auditoria Interna'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_GYA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Auditoria Interna'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='COMUNICACION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Auditoria Interna'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='RESPONDER'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Auditoria Interna'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_SOLVENCIA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Auditoria Interna'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_ANTECEDENTES'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Auditoria Interna'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Auditoria Interna'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Auditoria Interna'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='SOLICITAR_PRORROGA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Auditoria Interna'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-CLI'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrativos zonas'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-LIST-EXP'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrativos zonas'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BUSQUEDA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrativos zonas'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_TITULOS'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrativos zonas'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_GYA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrativos zonas'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='COMUNICACION'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrativos zonas'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='RESPONDER'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrativos zonas'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_SOLVENCIA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrativos zonas'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='EDITAR_ANTECEDENTES'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrativos zonas'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='NUEVO_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrativos zonas'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='BORRA_TITULO'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrativos zonas'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='SOLICITAR_PRORROGA'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrativos zonas'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='SOLICITAR_EXP_MANUAL'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Oficina'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='SOLICITAR_EXP_MANUAL'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Zona'));
INSERT INTO FUN_PEF (FUN_ID,PEF_ID) VALUES ((SELECT FUN_ID FROM ${master.schema}.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='MENU-ANALISIS'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'));

INSERT INTO fun_pef
   SELECT fun_id, (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador')
     FROM ${master.schema}.fun_funciones
    WHERE (fun_id, (SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Administrador')) NOT IN (SELECT fun_id, pef_id
                                FROM fun_pef);

-- ZON_PEF_USU
-- Gestor
INSERT INTO ZON_PEF_USU (ZON_ID,PEF_ID,USU_ID) VALUES ((SELECT ZON_ID FROM ZON_ZONIFICACION WHERE ZON_COD ='01'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Oficina'),(SELECT USU_ID FROM ${master.schema}.USU_USUARIOS WHERE USU_USERNAME='gestor'));
INSERT INTO ZON_PEF_USU (ZON_ID,PEF_ID,USU_ID) VALUES ((SELECT ZON_ID FROM ZON_ZONIFICACION WHERE ZON_COD ='01'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Zona'),(SELECT USU_ID FROM ${master.schema}.USU_USUARIOS WHERE USU_USERNAME='gestor'));

-- Supervisor
INSERT INTO ZON_PEF_USU (ZON_ID,PEF_ID,USU_ID) VALUES ((SELECT ZON_ID FROM ZON_ZONIFICACION WHERE ZON_COD ='01'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'),(SELECT USU_ID FROM ${master.schema}.USU_USUARIOS WHERE USU_USERNAME='supervisor'));
INSERT INTO ZON_PEF_USU (ZON_ID,PEF_ID,USU_ID) VALUES ((SELECT ZON_ID FROM ZON_ZONIFICACION WHERE ZON_COD ='01'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Especialista Recup.'),(SELECT USU_ID FROM ${master.schema}.USU_USUARIOS WHERE USU_USERNAME='supervisor'));


-- Comite (Zona 1, Dtor. Riesgos, comite)
INSERT INTO ZON_PEF_USU (ZON_ID,PEF_ID,USU_ID) VALUES ((SELECT ZON_ID FROM ZON_ZONIFICACION WHERE ZON_COD ='01'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Recup.'),(SELECT USU_ID FROM ${master.schema}.USU_USUARIOS WHERE USU_USERNAME='comite'));
INSERT INTO ZON_PEF_USU (ZON_ID,PEF_ID,USU_ID) VALUES ((SELECT ZON_ID FROM ZON_ZONIFICACION WHERE ZON_COD ='01'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Dtor. Riesgos'),(SELECT USU_ID FROM ${master.schema}.USU_USUARIOS WHERE USU_USERNAME='comite'));
INSERT INTO ZON_PEF_USU (ZON_ID,PEF_ID,USU_ID) VALUES ((SELECT ZON_ID FROM ZON_ZONIFICACION WHERE ZON_COD ='01'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Resp. Espec. Recup.'),(SELECT USU_ID FROM ${master.schema}.USU_USUARIOS WHERE USU_USERNAME='comite'));

--Gestor Externo
INSERT INTO ZON_PEF_USU (ZON_ID,PEF_ID,USU_ID) VALUES ((SELECT ZON_ID FROM ZON_ZONIFICACION WHERE ZON_COD ='01'),(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_DESCRIPCION ='Gestor externo.'),(SELECT USU_ID FROM ${master.schema}.USU_USUARIOS WHERE USU_USERNAME='gestorExterno'));

-- todos los perfiles a Admin
INSERT INTO zon_pef_usu
   SELECT (SELECT ZON_ID FROM ZON_ZONIFICACION WHERE ZON_COD ='01'), pef_id, (SELECT USU_ID FROM ${master.schema}.USU_USUARIOS WHERE USU_USERNAME='admin')
     FROM pef_perfiles
    WHERE ((SELECT ZON_ID FROM ZON_ZONIFICACION WHERE ZON_COD ='01'), pef_id, (SELECT USU_ID FROM ${master.schema}.USU_USUARIOS WHERE USU_USERNAME='admin')) NOT IN (SELECT zon_id, pef_id, usu_id
                                   FROM zon_pef_usu);

-- Plazos por default
INSERT INTO PLA_PLAZOS_DEFAULT(PLA_ID, DD_STA_ID, PLA_PLAZO, PLA_CODIGO, PLA_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (1, 29, 5000, '1', 'Solicitud Expediente Manual', 'DD', ${sql.function.curdate});
INSERT INTO PLA_PLAZOS_DEFAULT(PLA_ID, DD_STA_ID, PLA_PLAZO, PLA_CODIGO, PLA_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (2, 30, 129600000, '2', 'Solicitud de Preasunto', 'DD', ${sql.function.curdate});
INSERT INTO PLA_PLAZOS_DEFAULT(PLA_ID, DD_STA_ID, PLA_PLAZO, PLA_CODIGO, PLA_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (3, 31, 129600000, '3', 'Solicitud de Prorroga', 'DD', ${sql.function.curdate});
INSERT INTO PLA_PLAZOS_DEFAULT(PLA_ID, DD_STA_ID, PLA_PLAZO, PLA_CODIGO, PLA_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (4, 36, 5000, '4', 'Aceptación asunto', 'DD', ${sql.function.curdate});
INSERT INTO PLA_PLAZOS_DEFAULT(PLA_ID, DD_STA_ID, PLA_PLAZO, PLA_CODIGO, PLA_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (5, 35, 5000, '5', 'Recopilar documentacion', 'DD', ${sql.function.curdate});
INSERT INTO PLA_PLAZOS_DEFAULT(PLA_ID, DD_STA_ID, PLA_PLAZO, PLA_CODIGO, PLA_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (6, 38, 500000, '6', 'Recopilar documentacion', 'DD', ${sql.function.curdate});
INSERT INTO PLA_PLAZOS_DEFAULT(PLA_ID, DD_STA_ID, PLA_PLAZO, PLA_CODIGO, PLA_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (7, 43, 10000, '7', 'Actualizar estado del recurso', 'DD', ${sql.function.curdate});
INSERT INTO PLA_PLAZOS_DEFAULT(PLA_ID, DD_STA_ID, PLA_PLAZO, PLA_CODIGO, PLA_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (8, 49, 10000, '8', 'Aprobar Acuerdo Propuesto', 'DD', ${sql.function.curdate});
INSERT INTO PLA_PLAZOS_DEFAULT(PLA_ID, DD_STA_ID, PLA_PLAZO, PLA_CODIGO, PLA_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (9, 51, 10000, '9', 'Cerrar Gestiones Acuerdo', 'DD', ${sql.function.curdate});

-- PEN_PARAM_ENTIDAD
-- Porcentajes de validacion de carga
INSERT INTO PEN_PARAM_ENTIDAD (PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (1, 'porcentajeToleranciaActivoLineas', '40', 'Porcentaje de tolerancia de la cantidad de lineas de activo en la carga de los contratos', 'DD', ${sql.function.curdate});
INSERT INTO PEN_PARAM_ENTIDAD (PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (2, 'porcentajeToleranciaActivoPosicionVencida', '40', 'Porcentaje de tolerancia de la cantidad de posicion vencida de los activos en la carga de los contratos', 'DD', ${sql.function.curdate});
INSERT INTO PEN_PARAM_ENTIDAD (PEN_ID, PEN_PARAM, PEN_VALOR,PEN_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (3, 'porcentajeToleranciaActivoPosicionViva', '40', 'Porcentaje de tolerancia de la cantidad de posicion viva de los activos en la carga de los contratos', 'DD', ${sql.function.curdate});
INSERT INTO PEN_PARAM_ENTIDAD (PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (4, 'porcentajeToleranciaPasivoLineas', '40', 'Porcentaje de tolerancia de la cantidad de lineas de los pasivos en la carga de los contratos', 'DD', ${sql.function.curdate});
INSERT INTO PEN_PARAM_ENTIDAD (PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (5, 'porcentajeToleranciaPasivoPosicionVencida', '40', 'Porcentaje de tolerancia de la cantidad de posicion vencida de los pasivos en la carga de los contratos', 'DD', ${sql.function.curdate});
INSERT INTO PEN_PARAM_ENTIDAD (PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (6, 'porcentajeToleranciaPasivoPosicionViva', '40', 'Porcentaje de tolerancia de la cantidad de posicion via de los pasivos en la carga de los contratos', 'DD', ${sql.function.curdate});

-- Porcentaje de disminucion de movimientos
INSERT INTO PEN_PARAM_ENTIDAD (PEN_ID, PEN_PARAM, PEN_VALOR,  PEN_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (10, 'porcentajeDisminucionMovimientos', '4.5', 'Porcentaje de disminucion de movimientos para generar una notificacion', 'DD', ${sql.function.curdate});

INSERT INTO PEN_PARAM_ENTIDAD (PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (11, 'expediente.obtenerContratosAdicionales.limite', '40', 'Limite de contratos adicionales para un expediente', 'DD', ${sql.function.curdate});

-- Rangos para el analisis
INSERT INTO PEN_PARAM_ENTIDAD (PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (20, 'rango.GV1', '15', 'Primer rango de analisis', 'DD', ${sql.function.curdate});
INSERT INTO PEN_PARAM_ENTIDAD (PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (21, 'rango.GV2', '30', 'Segundo rango de analisis', 'DD', ${sql.function.curdate});
INSERT INTO PEN_PARAM_ENTIDAD (PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (22, 'rango.GV3', '60', 'Tercer rango de analisis', 'DD', ${sql.function.curdate});

INSERT INTO PEN_PARAM_ENTIDAD (PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (23, 'limiteExportExcel', '2000', 'Limite de resultados para una exportación a Excel', 'DD', ${sql.function.curdate});

INSERT INTO PEN_PARAM_ENTIDAD (PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, USUARIOCREAR, FECHACREAR)
VALUES (31, 'scoring.rangoIntervalo', '4', 'Número de intervalos para generar el indicador', 'DD', ${sql.function.curdate});


-- CONFIGURACION DEL MAIL PARA LOS TIPOS DE BIENES
INSERT INTO CNF_CORREO_VERIF (CNF_ID, DD_TBI_ID, CNF_DESTINATARIO, USUARIOCREAR, FECHACREAR)
VALUES(1, 1, 'cosmefulanito@pfs.com', 'DD', ${sql.function.curdate});
INSERT INTO CNF_CORREO_VERIF (CNF_ID, DD_TBI_ID, CNF_DESTINATARIO, USUARIOCREAR, FECHACREAR)
VALUES(2, 2, 'cosmefulanito@pfs.com', 'DD', ${sql.function.curdate});
INSERT INTO CNF_CORREO_VERIF (CNF_ID, DD_TBI_ID, CNF_DESTINATARIO, USUARIOCREAR, FECHACREAR)
VALUES(3, 3, 'cosmefulanito@pfs.com', 'DD', ${sql.function.curdate});
INSERT INTO CNF_CORREO_VERIF (CNF_ID, DD_TBI_ID, CNF_DESTINATARIO, USUARIOCREAR, FECHACREAR)
VALUES(4, 4, 'cosmefulanito@pfs.com', 'DD', ${sql.function.curdate});


-- *************************************************************************** --
-- **                   BPM Ejecución de título judicial                    ** --
-- *************************************************************************** --

--Insercion de procedimiento
INSERT INTO DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (116, 'P16', 'Ejecución Título Judicial', 'Procedimiento Ejecución de Título Judicial', '<h1>FIXME</h1>Texto descripcion tarea... ', 'ejecucionTituloJudicial', 0, 'DD', ${sql.function.curdate}, 0);

--Insercion de las tareas/pantallas
-- Pantalla 1
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_VALIDACION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11601, 116, 'P16_InterposicionDemanda', 'tieneBienes() && !isBienesConFechaSolicitud() AAAAA ''Antes de realizar la tarea es necesario marcar los bienes con fecha de solicitud de embargo''DOS_PUNTOSnull',
0, 'Interposición de la demanda de título judicial + Marcado de bienes', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11601, '5*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11601, 0, 'label', 'titulo', 'Interposición de la demanda de título', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11601, 1, 'date', 'fecha', 'Fecha de demanda', 0, 'DD', ${sql.function.curdate}, 0);


--Pantalla 2
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_VIEW, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES								(11602, 116, 'P16_AutoDespachando', 0, 'Auto Despachando ejecución + Marcado de bienes decreto embargo','bpm/ejecucionTituloJudicial/autoDespachandoForm', 'aaa', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11602, '20*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11602, 0, 'label', 'titulo', 'Auto despacho ejecución', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11602, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11602, 2, 'combo', 'nPlaza', 'Plaza', 'TipoPlaza', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11602, 3, 'combo', 'nJuz', 'Nº Juzgado', 'TipoJuzgado', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11602, 4, 'text', 'nProc', 'Nº Procedimiento', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11602, 5, 'combo', 'comboSiNo', 'SI/NO', 'DDSiNo', 0, 'DD', ${sql.function.curdate}, 0);


--Pantalla 3
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_DECISION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11603, 116, 'P16_RegistrarAnotacion', 'isBienesConFechaDecreto() && !isBienesConFechaRegistro() AAAAA ''Antes de realizar la tarea es necesario marcar los bienes con fecha de registro de embargo''DOS_PUNTOSnull','''repite''', 0, 'Registrar anotación en registro', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11603, 'nVecesTareaExterna == 0 AAAAA 30*24*60*60*1000LDOS_PUNTOS23*7*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11603, 0, 'label', 'titulo', 'Registrar anotación en registro', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11603, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);


--Pantalla 4
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11604, 116, 'P16_ConfirmarNotificacion', 0, 'Confirmar notificacion','aaa', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11604, '30*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11604, 0, 'label', 'titulo', 'Confirmar notificacion', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11604, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11604, 2, 'combo', 'comboSiNo', 'SI/NO', 'DDSiNo', 0, 'DD', ${sql.function.curdate}, 0);


--Pantalla 5
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11605, 116, 'P16_BPMTramiteNotificacion', null, 0, 'Ejecución del BPM de Trámite de Notificación', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11605, '300*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11605, 0, 'label', 'titulo', 'Ejecución del BPM de Trámite de Notificación', 0, 'DD', ${sql.function.curdate}, 0);


--Pantalla 6
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11606, 116, 'P16_RegistrarOposicion', 0, 'Registrar oposición vista','aaa', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11606, '10*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11606, 0, 'label', 'titulo', 'Registrar oposición vista', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11606, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11606, 2, 'combo', 'comboSiNo', 'SI/NO', 'DDSiNo', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11606, 3, 'date', 'fechaAudi', 'Fecha de audiencia previa', 0, 'DD', ${sql.function.curdate}, 0);


--Pantalla 7
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11607, 116, 'P16_HayVista', 0, '¿Hay VistaAAAAA','aaa', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11607, '10*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11607, 0, 'label', 'titulo', '¿Hay VistaAAAAA', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11607, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11607, 2, 'date', 'fechaVista', 'Fecha vista', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11607, 3, 'combo', 'comboSiNo', 'SI/NO', 'DDSiNo', 0, 'DD', ${sql.function.curdate}, 0);

--Pantalla 8
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11608, 116, 'P16_RegistrarVista', 0, 'Registrar Vista', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11608, 'damePlazo(valores[''P16_HayVista''][''fechaVista''])', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11608, 0, 'label', 'titulo', 'Registrar Vista', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11608, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);


--Pantalla 9
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11609, 116, 'P16_RegistrarResolucion', 0, 'Registrar Resolución', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11609, '20*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11609, 0, 'label', 'titulo', 'Registrar Resolución', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11609, 1, 'date', 'fecha', 'Fecha de resolución', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11609, 2, 'combo', 'resultado', 'Resultado', 'DDResultadoResolucion', 0, 'DD', ${sql.function.curdate}, 0);


--Pantalla 10
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11610, 116, 'P16_ResolucionFirme', 0, 'Resolución firme', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11610, '20*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11610, 0, 'label', 'titulo', 'Registrar Resolución', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11610, 1, 'date', 'fecha', 'Fecha de resolución', 0, 'DD', ${sql.function.curdate}, 0);




-- *************************************************************************** --
-- **                   BPM Tramite de embargo de salarios                  ** --
-- *************************************************************************** --

--Insercion de procedimiento
INSERT INTO DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(109, 'P09', 'Embargo de Salarios', 'Trámite de Embargo de Salarios', '<h1>FIXME</h1>Texto descripcion tarea... ', 'tramiteEmbargoSalarios', 0, 'DD', ${sql.function.curdate}, 0);


--Insercion de las tareas/pantallas
-- Pantalla 1
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(10901, 109, 'P09_SolicitarNotificacion', 0, 'Solicitar la notificación Ret. pagador', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 10901, '2*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 10901, 0, 'label', 'titulo', 'Solicitar la notificación Ret. pagador', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 10901, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 10901, 2, 'currency', 'importeNom', 'Importe nómina', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 10901, 3, 'currency', 'importeRet', 'Importe de retención', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 2
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(10902, 109, 'P09_ConfirmarRetenciones', 0, 'Confirmar retenciones',
'valores[''P09_ConfirmarRetenciones''][''comboCorr''] == DDCorrectoCobro.CORRECTO_COBROS_PENDIENTES AAAAA ''CorrectoCobros''DOS_PUNTOSvalores[''P09_ConfirmarRetenciones''][''comboCorr''] == DDCorrectoCobro.INCORRECTO_COBROS_PENDIENTES AAAAA ''IncorrectoCobros''DOS_PUNTOS''CorrectoFin''', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 10902, '90*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 10902, 0, 'label', 'titulo', 'Confirmar retenciones', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 10902, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 10902, 2, 'combo', 'comboCorr', 'Correcto/Incorrecto', 'DDCorrectoCobro', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 3
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(10903, 109, 'P09_GestionarProblemas', 0, 'Gestionar problemas de retención',
'valores[''P09_GestionarProblemas''][''comboCorr''] == DDCorrecto.CORRECTO AAAAA ''Correcto''DOS_PUNTOS''Incorrecto''', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 10903, '10*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 10903, 0, 'label', 'titulo', 'Gestionar problemas de retención', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 10903, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 10903, 2, 'combo', 'comboCorr', 'Correcto/Incorrecto', 'DDCorrecto', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 4
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(10904, 109, 'P09_ActualizarDatos', 1, 'Actualizar datos solvencia cliente', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 10904, '10*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 10904, 0, 'label', 'titulo', 'Actualizar datos solvencia cliente', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 10904, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);




-- *************************************************************************** --
-- **                        BPM Tramite de intereses                       ** --
-- *************************************************************************** --
--Insercion de procedimiento
INSERT INTO DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(110, 'P10', 'Trámite de Intereses', 'Trámite de Intereses', '<h1>FIXME</h1>Texto descripcion tarea... ', 'tramiteIntereses', 0, 'DD', ${sql.function.curdate}, 0);

--Insercion de las tareas/pantallas
-- Pantalla 1
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11001, 110, 'P10_ElaborarLiquidacion', 1, 'Elaborar, enviar Liquidación de intereses', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11001, '3*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11001, 0, 'label', 'titulo', 'Elaborar, enviar Liquidación de intereses', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11001, 1, 'date', 'fechaLiq', 'Fecha de liquidación', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11001, 2, 'currency', 'importe', 'Importe calculado', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11001, 3, 'date', 'fechaEnv', 'Fecha de envío', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 2
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11002, 110, 'P10_SolicitarLiquidacion', 0, 'Solicitar Liquidación de Intereses', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11002, '5*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11002, 0, 'label', 'titulo', 'Solicitar Liquidación de Intereses', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11002, 1, 'date', 'fechaRec', 'Fecha de recepción', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11002, 2, 'date', 'fechaPre', 'Fecha de presentación', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 3
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11003, 110, 'P10_RegistrarResolucion', 0, 'Registrar Resolución', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11003, '20*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11003, 0, 'label', 'titulo', 'Registrar Resolución', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11003, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 4
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11004, 110, 'P10_ConfirmarNotificacion', 0, 'Confirmar Notificación','aaa', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11004, '30*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11004, 0, 'label', 'titulo', 'Confirmar Notificación', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11004, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11004, 2, 'combo', 'comboSiNo', 'SI/NO', 'DDSiNo', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 5
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11005, 110, 'P10_BPMTramiteNotificacion', null, 0, 'Ejecución del BPM de Trámite de Notificación', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11005, '300*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11005, 0, 'label', 'titulo', 'Ejecución del BPM de Trámite de Notificación', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 6
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11006, 110, 'P10_RegistrarImpugnacion', 0, 'Registrar Impugnación','aaa', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11006, '10*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11006, 0, 'label', 'titulo', 'Registrar Impugnación', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11006, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11006, 2, 'date', 'fechaVista', 'Fecha vista', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11006, 3, 'combo', 'comboSiNo', 'SI/NO', 'DDSiNo', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 7
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11007, 110, 'P10_RegistrarVista', 0, 'Registrar Vista', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11007, 'damePlazo(valores[''P10_RegistrarImpugnacion''][''fechaVista''])', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11007, 0, 'label', 'titulo', 'Registrar Vista', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11007, 1, 'date', 'fecha', 'Fecha vista', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 8
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11008, 110, 'P10_RegistrarResolucionVista', 0, 'Registrar Resolución de la Vista', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11008, '20*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11008, 0, 'label', 'titulo', 'Registrar Resolución de la Vista', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11008, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 9
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11009, 110, 'P10_ResolucionFirme', 0, 'Resolución firme', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11009, '2*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11009, 0, 'label', 'titulo', 'Resolución firme', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11009, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);



-- *************************************************************************** --
-- **                        BPM Tramite de subasta                         ** --
-- *************************************************************************** --
--Insercion de procedimiento
INSERT INTO DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(111, 'P11', 'Trámite de Subasta', 'Trámite de Subasta', '<h1>FIXME</h1>Texto descripcion tarea... ', 'tramiteSubasta', 0, 'DD', ${sql.function.curdate}, 0);

--Insercion de las tareas/pantallas
-- Pantalla 1
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11101, 111, 'P11_SolicitudSubasta', 0, 'Solicitud de subasta', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11101, '5*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11101, 0, 'label', 'titulo', 'Solicitud de subasta', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11101, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11101, 2, 'currency', 'estimacion', 'Estimación costas', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 2
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11102, 111, 'P11_DictarInstrucciones', 1, 'Dictar Instrucciones', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11102, '10*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11102, 0, 'label', 'titulo', 'Dictar Instrucciones', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11102, 1, 'combo', 'comboConPost', 'CON/SIN Postores', 'DDPostores1', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11102, 2, 'combo', 'comboSinPost', 'SIN POSTORES A/B/C', 'DDPostores2', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11102, 3, 'currency', 'limite', 'Límite', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 3
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11103, 111, 'P11_LeerInstrucciones', 0, 'Lectura y aceptacion de instrucciones', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval,11103, '5*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval,11103, 0, 'label', 'titulo', 'Lectura y aceptacion de instrucciones', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval,11103, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 4
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11104, 111, 'P11_AnuncioSubasta', 0, 'Anuncio de Subasta', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11104, '20*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11104, 0, 'label', 'titulo', 'Anuncio de Subasta', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11104, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11104, 2, 'date', 'fechaSubasta', 'Fecha celebración subasta', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 5
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11105, 111, 'P11_CelebracionSubasta', 0, 'Celebración subasta',
'valores[''P11_CelebracionSubasta''][''comboNosTerc''] == DDTerceros.TERCEROS AAAAA ''terceros''DOS_PUNTOS''nosotros''', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11105, 'damePlazo(valores[''P11_AnuncioSubasta''][''fechaSubasta''])', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11105, 0, 'label', 'titulo', 'Celebración subasta', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11105, 1, 'combo', 'comboNosTerc', 'NOSOTROS/TERCEROS', 'DDTerceros', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11105, 2, 'combo', 'comboSinPost', 'SIN POSTORES A/B/C', 'DDPostores2', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11105, 3, 'currency', 'limite', 'Límite', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 6
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11106, 111, 'P11_SolicitudPago', 0, 'Solicitud mandamiento de pago', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11106, '2*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11106, 0, 'label', 'titulo', 'Solicitud mandamiento de pago', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11106, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);


-- Pantalla 7
INSERT INTO TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(11107, 111, 'P11_Cobro', 0, 'Cobro', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, 11107, '10*24*60*60*1000L', 0, 'DD', ${sql.function.curdate}, 0);

INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11107, 0, 'label', 'titulo', 'Cobro', 0, 'DD', ${sql.function.curdate}, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES(S_TFI_TAREAS_FORM_ITEMS.nextval, 11107, 1, 'date', 'fecha', 'Fecha', 0, 'DD', ${sql.function.curdate}, 0);


-- DCA_DECISION_COMITE_AUTO
-- Aceptacion Gestor manual.
INSERT INTO DCA_DECISION_COMITE_AUTO (DCA_ID, GAS_ID, SUP_ID, COM_ID, DD_TAC_ID, DD_TRE_ID, DD_TPO_ID, DCA_PORCENTAJE_RECUPERACION, DCA_PLAZO_RECUPERACION, DCA_ACEPTACION_AUTO, USUARIOCREAR, FECHACREAR)
VALUES(501, 2, 1,1,1, 1, 116, 90, 2, 0,'DD',${sql.function.curdate});
-- Aceptacion Gestor automatica.
INSERT INTO DCA_DECISION_COMITE_AUTO (DCA_ID, GAS_ID, SUP_ID, COM_ID, DD_TAC_ID, DD_TRE_ID, DD_TPO_ID, DCA_PORCENTAJE_RECUPERACION, DCA_PLAZO_RECUPERACION, DCA_ACEPTACION_AUTO, USUARIOCREAR, FECHACREAR)
VALUES(502, 2, 1,1,1, 1, 116, 90, 2, 1,'DD',${sql.function.curdate});

-- ESTADOS_ITINERARIOS
-- Itinerario Default Cliente
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (11, 1, 2, 1, 1, 5000, 0, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (12, 1, 2, 1, 2, 1296000000, 0, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (13, 3, 4, 1, 3, 1296000000, 0, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (14, 3, 4, 1, 4, 1296000000, 0, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (15, 5, 5, 1, 5, 1296000000, 0, 'N/A', ${sql.function.curdate});

-- Itinerario Default Expediente
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (21, 1, 2, 2, 1, 5000, 0, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (22, 1, 2, 2, 2, 5000, 0, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (23, 3, 4, 2, 3, 5000, 0, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (24, 3, 4, 2, 4, 60000, 0, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (25, 5, 5, 2, 5, 60000, 0, 'N/A', ${sql.function.curdate});

-- Itinerario Default Automatico
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (31, 1, 2, 3, 1, 5000, 1,'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (32, 1, 2, 3, 2, 5000, 1,'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (33, 3, 4, 3, 3, 5000, 1,'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (34, 3, 4, 3, 4, 5000, 1,'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (35, 5, 5, 3, 5, 5000, 0,'N/A', ${sql.function.curdate});

-- Itinerario Default
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (41, 1, 2, 4, 1, 5000, 0, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (42, 1, 2, 4, 2, 10000, 0, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (43, 3, 4, 4, 3, 50000, 0, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (44, 3, 4, 4, 4, 60000, 0, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, usuariocrear, fechacrear)
VALUES (45, 5, 5, 4, 5, 80000, 0, 'N/A', ${sql.function.curdate});

-- Itinerario Telecobro
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, est_telecobro, tel_id, usuariocrear, fechacrear)
VALUES (51, 1, 2, 5, 1, 5000, 0, 1, 1,'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, est_telecobro, tel_id, usuariocrear, fechacrear)
VALUES (52, 1, 2, 5, 2, 60000, 0, 1, 1, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id,  pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, est_telecobro, tel_id, usuariocrear, fechacrear)
VALUES (53, 3, 4, 5, 3, 50000, 0, 1, 1, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, est_telecobro, tel_id, usuariocrear, fechacrear)
VALUES (54, 3, 4, 5, 4, 60000, 0, 1, 1, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, est_telecobro, tel_id, usuariocrear, fechacrear)
VALUES (55, 5, 5, 5, 5, 80000, 0, 1, 1, 'N/A', ${sql.function.curdate});

-- Itinerario Auto Asu Manual
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, dca_id, usuariocrear, fechacrear)
VALUES (61, 1, 2, 6, 1, 1000, 1, null, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, dca_id, usuariocrear, fechacrear)
VALUES (62, 1, 2, 6, 2, 1000, 1, null, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, dca_id, usuariocrear, fechacrear)
VALUES (63, 3, 4, 6, 3, 1000, 1, null, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, dca_id, usuariocrear, fechacrear)
VALUES (64, 3, 4, 6, 4, 1000, 1, null, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, dca_id, usuariocrear, fechacrear)
VALUES (65, 5, 5, 6, 5, 1000, 1, 501, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, dca_id, usuariocrear, fechacrear)
VALUES (66, 5, 5, 6, 6, 1000, 1, null, 'N/A', ${sql.function.curdate});

-- Itinerario Auto Asu Aceptado
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, dca_id, usuariocrear, fechacrear)
VALUES (71, 1, 2, 7, 1, 1000, 1, null, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, dca_id, usuariocrear, fechacrear)
VALUES (72, 1, 2, 7, 2, 1000, 1, null, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, dca_id, usuariocrear, fechacrear)
VALUES (73, 3, 4, 7, 3, 1000, 1, null, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, dca_id, usuariocrear, fechacrear)
VALUES (74, 3, 4, 7, 4, 1000, 1, null, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, dca_id, usuariocrear, fechacrear)
VALUES (75, 5, 5, 7, 5, 1000, 1, 502, 'N/A', ${sql.function.curdate});
INSERT INTO est_estados (est_id, pef_id_gestor, pef_id_supervisor, iti_id, dd_est_id, est_plazo, est_automatico, dca_id, usuariocrear, fechacrear)
VALUES (76, 5, 5, 7, 6, 1000, 1, null, 'N/A', ${sql.function.curdate});


-- Tipos de grupos de carga
INSERT INTO GRC_GRUPO_CARGA(grc_id,grc_codigo,grc_descripcion,usuariocrear,fechacrear,borrado)
VALUES      (1, 'GR1', 'GR1', 'DD', ${sql.function.now}, 0);
INSERT INTO GRC_GRUPO_CARGA(grc_id,grc_codigo,grc_descripcion,usuariocrear,fechacrear,borrado)
VALUES      (2, 'GR2', 'GR2', 'DD', ${sql.function.now}, 0);
INSERT INTO GRC_GRUPO_CARGA(grc_id,grc_codigo,grc_descripcion,usuariocrear,fechacrear,borrado)
VALUES      (3, 'GR3', 'GR3', 'DD', ${sql.function.now}, 0);
INSERT INTO GRC_GRUPO_CARGA(grc_id,grc_codigo,grc_descripcion,usuariocrear,fechacrear,borrado)
VALUES      (4, 'GR4', 'GR4', 'DD', ${sql.function.now}, 0);

-- Tipos de grupos de alerta
INSERT INTO GAL_GRUPO_ALERTA(gal_id,gal_codigo,gal_descripcion,usuariocrear,fechacrear,borrado)
VALUES      (1, 'GA1', 'GA1', 'DD', ${sql.function.now}, 0);
INSERT INTO GAL_GRUPO_ALERTA(gal_id,gal_codigo,gal_descripcion,usuariocrear,fechacrear,borrado)
VALUES      (2, 'GA2', 'GA2', 'DD', ${sql.function.now}, 0);

-- Tipos de alertas
INSERT INTO tal_tipo_alerta(tal_id,tal_codigo,grc_id,gal_id,tal_descripcion,usuariocrear,fechacrear,borrado)
VALUES      (1, 'ALE01',1,1, 'dummy alerta 01', 'dummy', ${sql.function.now}, 0);
INSERT INTO tal_tipo_alerta(tal_id,tal_codigo,grc_id,gal_id,tal_descripcion,usuariocrear,fechacrear,borrado)
VALUES      (2, 'ALE02',1,1, 'dummy alerta 02', 'dummy', ${sql.function.now}, 0); 
INSERT INTO tal_tipo_alerta(tal_id,tal_codigo,grc_id,gal_id,tal_descripcion,usuariocrear,fechacrear,borrado)
VALUES      (3, 'ALE03',3,2, 'dummy alerta 03', 'dummy', ${sql.function.now}, 0);

-- Tipos de niveles de gravedad
INSERT INTO ngr_nivel_gravedad(ngr_id,ngr_orden,ngr_peso,ngr_codigo,ngr_descripcion,usuariocrear,fechacrear,borrado)
VALUES      (1,1,1, 'NGR01', 'dummy nivel 01', 'dummy', ${sql.function.now}, 0);
INSERT INTO ngr_nivel_gravedad(ngr_id,ngr_orden,ngr_peso,ngr_codigo,ngr_descripcion,usuariocrear,fechacrear,borrado)
VALUES      (2,2,2, 'NGR02', 'dummy nivel 02', 'dummy', ${sql.function.now}, 0);
INSERT INTO ngr_nivel_gravedad(ngr_id,ngr_orden,ngr_peso,ngr_codigo,ngr_descripcion,usuariocrear,fechacrear,borrado)
VALUES      (3,3,3, 'NGR03', 'dummy nivel 03', 'dummy', ${sql.function.now}, 0);

-- Modulo de politicas
INSERT INTO MOT_MOTIVO(MOT_ID, MOT_CODIGO, MOT_DESCRIPCION, USUARIOCREAR,FECHACREAR)
VALUES      (1, 'PREPOL', 'Prepolitica', 'dummy', SYSDATE);
INSERT INTO MOT_MOTIVO(MOT_ID, MOT_CODIGO, MOT_DESCRIPCION, USUARIOCREAR,FECHACREAR)
VALUES      (2, 'MANUAL', 'Manual', 'dummy', SYSDATE);
INSERT INTO MOT_MOTIVO(MOT_ID, MOT_CODIGO, MOT_DESCRIPCION, USUARIOCREAR,FECHACREAR)
VALUES      (3, 'GESTOR', 'Coincidencia gestores', 'dummy', SYSDATE);
INSERT INTO MOT_MOTIVO(MOT_ID, MOT_CODIGO, MOT_DESCRIPCION, USUARIOCREAR,FECHACREAR)
VALUES      (4, 'COMITE', 'Comité', 'dummy', SYSDATE);

INSERT INTO TEN_TENDENCIA(TEN_ID, TEN_CODIGO, TEN_DESCRIPCION, USUARIOCREAR,FECHACREAR)
VALUES      (1, 'ASC', 'Ascendente', 'dummy', SYSDATE);
INSERT INTO TEN_TENDENCIA(TEN_ID, TEN_CODIGO, TEN_DESCRIPCION, USUARIOCREAR,FECHACREAR)
VALUES      (2, 'MAN', 'Mantener', 'dummy', SYSDATE);
INSERT INTO TEN_TENDENCIA(TEN_ID, TEN_CODIGO, TEN_DESCRIPCION, USUARIOCREAR,FECHACREAR)
VALUES      (3, 'DES', 'Descendente', 'dummy', SYSDATE);

INSERT INTO TPL_TIPO_POLITICA(TPL_ID,TEN_ID, TPL_CODIGO, TPL_DESCRIPCION, USUARIOCREAR,FECHACREAR, DD_POL_ID)
VALUES      (1, 1, 'TPL01', 'Afianzar', 'dummy', SYSDATE, (SELECT DD_POL_ID FROM ${master.schema}.DD_POL_POLITICAS WHERE DD_POL_CODIGO='1'));
INSERT INTO TPL_TIPO_POLITICA(TPL_ID,TEN_ID, TPL_CODIGO, TPL_DESCRIPCION, USUARIOCREAR,FECHACREAR, DD_POL_ID)
VALUES      (2, 3, 'TPL02', 'Extingir', 'dummy', SYSDATE, (SELECT DD_POL_ID FROM ${master.schema}.DD_POL_POLITICAS WHERE DD_POL_CODIGO='2'));
INSERT INTO TPL_TIPO_POLITICA(TPL_ID,TEN_ID, TPL_CODIGO, TPL_DESCRIPCION, USUARIOCREAR,FECHACREAR, DD_POL_ID)
VALUES      (3, 3, 'TPL03', 'Reducir', 'dummy', SYSDATE, (SELECT DD_POL_ID FROM ${master.schema}.DD_POL_POLITICAS WHERE DD_POL_CODIGO='2'));
INSERT INTO TPL_TIPO_POLITICA(TPL_ID,TEN_ID, TPL_CODIGO, TPL_DESCRIPCION, USUARIOCREAR,FECHACREAR, DD_POL_ID)
VALUES      (4, 2, 'TPL04', 'Seguir', 'dummy', SYSDATE, (SELECT DD_POL_ID FROM ${master.schema}.DD_POL_POLITICAS WHERE DD_POL_CODIGO='3'));
INSERT INTO TPL_TIPO_POLITICA(TPL_ID,TEN_ID, TPL_CODIGO, TPL_DESCRIPCION, USUARIOCREAR,FECHACREAR, DD_POL_ID)
VALUES      (5, 2, 'TPL05', 'Normal', 'dummy', SYSDATE, (SELECT DD_POL_ID FROM ${master.schema}.DD_POL_POLITICAS WHERE DD_POL_CODIGO='4'));

INSERT INTO TOB_TIPO_OBJETIVO(TOB_ID,TOB_CODIGO,TOB_DESCRIPCION,TOB_AUTOMATICO,TOB_CONTRATO,USUARIOCREAR,FECHACREAR)
VALUES      (1, 'TOB01', 'Credito personal Manual', 0, 0, 'dummy', SYSDATE);
INSERT INTO TOB_TIPO_OBJETIVO(TOB_ID,TOB_CODIGO,TOB_DESCRIPCION,TOB_AUTOMATICO,TOB_CONTRATO,USUARIOCREAR,FECHACREAR)
VALUES      (2, 'TOB02', 'Credito personal Auto', 1, 0, 'dummy', SYSDATE);
INSERT INTO TOB_TIPO_OBJETIVO(TOB_ID,TOB_CODIGO,TOB_DESCRIPCION,TOB_AUTOMATICO,TOB_CONTRATO,USUARIOCREAR,FECHACREAR)
VALUES      (3, 'TOB03', 'Prestamo Manual', 0, 0, 'dummy', SYSDATE);
INSERT INTO TOB_TIPO_OBJETIVO(TOB_ID,TOB_CODIGO,TOB_DESCRIPCION,TOB_AUTOMATICO,TOB_CONTRATO,USUARIOCREAR,FECHACREAR)
VALUES      (4, 'TOB04', 'Prestamo Auto', 1, 1, 'dummy', SYSDATE);

INSERT INTO DD_PAR_PARCELAS (DD_PAR_ID, DD_PAR_CODIGO, DD_PAR_DESCRIPCION, DD_PAR_DESCRIPCION_LARGA, DD_TAN_ID, DD_SCL_ID, DD_TPE_ID, USUARIOCREAR,FECHACREAR)
VALUES (1,'ACTIVIDAD','Actividad','Actividad',1,1,1,'DD',SYSDATE);
INSERT INTO DD_PAR_PARCELAS (DD_PAR_ID, DD_PAR_CODIGO, DD_PAR_DESCRIPCION, DD_PAR_DESCRIPCION_LARGA, DD_TAN_ID, DD_SCL_ID, DD_TPE_ID, USUARIOCREAR,FECHACREAR)
VALUES (2,'PROD.MERCADO','Productos/Mercado','Productos/Mercado',1,1,1,'DD',SYSDATE);
INSERT INTO DD_PAR_PARCELAS (DD_PAR_ID, DD_PAR_CODIGO, DD_PAR_DESCRIPCION, DD_PAR_DESCRIPCION_LARGA, DD_TAN_ID, DD_SCL_ID, DD_TPE_ID, USUARIOCREAR,FECHACREAR)
VALUES (3,'SOLVENCIA','Solvencia','Solvencia',1,1,1,'DD',SYSDATE);

INSERT INTO DD_TIG_TIPO_GESTION (DD_TIG_ID,DD_TIG_CODIGO,DD_TIG_DESCRIPCION,DD_TIG_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (1, '1', 'Análisis de la operativa', 'Análisis de la operativa', 'DD', sysdate);
INSERT INTO DD_TIG_TIPO_GESTION (DD_TIG_ID,DD_TIG_CODIGO,DD_TIG_DESCRIPCION,DD_TIG_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (2, '2', 'Gestiones con el cliente', 'Gestiones con el cliente', 'DD', sysdate);
INSERT INTO DD_TIG_TIPO_GESTION (DD_TIG_ID,DD_TIG_CODIGO,DD_TIG_DESCRIPCION,DD_TIG_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
VALUES (3, '3', 'Contraste externo de la información', 'Contraste externo de la información', 'DD', sysdate);
