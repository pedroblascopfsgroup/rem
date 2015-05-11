INSERT INTO LINMASTER.fun_funciones
            (fun_id,
             fun_descripcion_larga, fun_descripcion,
             VERSION, usuariocrear, fechacrear, usuariomodificar,
             fechamodificar, usuarioborrar, fechaborrar, borrado
            )
     VALUES (s_fun_funciones.NEXTVAL,
             'Permitir la prorroga masiva de tareas', 'ROLE_PRORROGA_MASIVA',
             0, 'CPEREZ', SYSDATE, NULL,
             NULL, NULL, NULL, 0
            );

INSERT INTO fun_pef
            (fun_id,
             pef_id,
             fp_id, VERSION, usuariocrear, fechacrear, usuariomodificar,
             fechamodificar, usuarioborrar, fechaborrar, borrado
            )
     VALUES ((SELECT fun_id
                FROM linmaster.fun_funciones
               WHERE fun_descripcion = 'ROLE_PRORROGA_MASIVA'),
             (SELECT PEF_ID
                FROM pef_perfiles
               WHERE pef_descripcion = 'SUPERVISOR Y LETRADO'),
             s_fun_pef.NEXTVAL, 0, 'CPEREZ', SYSDATE, NULL,
             NULL, NULL, NULL, 0
            );