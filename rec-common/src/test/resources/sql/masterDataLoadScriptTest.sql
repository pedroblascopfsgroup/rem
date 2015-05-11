--Borramos el resto de las entidades para bajar los tiempos
--DELETE ${master.schema}.ENTIDADCONFIG WHERE ENTIDAD_ID > 1;
--DELETE ${master.schema}.ENTIDAD WHERE ID > 1;

--Cargamos los usuarios
-- Usuarios globales
INSERT INTO usu_usuarios (USU_ID, ENTIDAD_ID, USU_username, USU_password, USU_nombre, USU_apellido1, USU_apellido2, USU_mail, USUARIOCREAR, FECHACREAR, version)
      VALUES (S_USU_USUARIOS.nextVal, 1, 'admin', 'admin', 'Usuario', 'Administrador', null, 'admin@pfs.es', 'DD', SYSDATE, 1);

INSERT INTO usu_usuarios (USU_ID, ENTIDAD_ID, USU_username, USU_password, USU_nombre, USU_apellido1, USU_apellido2, USU_mail, USUARIOCREAR, FECHACREAR, version)
     VALUES (S_USU_USUARIOS.nextVal, 1, 'gestor', 'gestor', 'Esteban', 'Rodríguez', null, 'arridriguez@bancaja.es', 'DD', SYSDATE, 1);

INSERT INTO usu_usuarios (USU_ID, ENTIDAD_ID, USU_username, USU_password, USU_nombre, USU_apellido1, USU_apellido2, USU_mail, USUARIOCREAR, FECHACREAR, version)
     VALUES (S_USU_USUARIOS.nextVal, 1, 'gestorExterno', 'gestorExterno', 'Esteban', 'Rodríguez', null, 'arridriguez@bancaja.es', 'DD', SYSDATE, 1);

INSERT INTO usu_usuarios (USU_ID, ENTIDAD_ID, USU_username, USU_password, USU_nombre, USU_apellido1, USU_apellido2, USU_mail, USUARIOCREAR, FECHACREAR, version)
     VALUES (S_USU_USUARIOS.nextVal, 1, 'supervisor', 'supervisor', 'Esteban', 'Rodríguez', null, 'arridriguez@bancaja.es', 'DD', SYSDATE, 1);

INSERT INTO usu_usuarios (USU_ID, ENTIDAD_ID, USU_username, USU_password, USU_nombre, USU_apellido1, USU_apellido2, USU_mail, USUARIOCREAR, FECHACREAR, version)
     VALUES (S_USU_USUARIOS.nextVal, 1, 'comite', 'comite', 'Juan', 'Bosnjak', 'Costa', 'jpbosnjak@bancaja.es', 'DD', SYSDATE, 1);

