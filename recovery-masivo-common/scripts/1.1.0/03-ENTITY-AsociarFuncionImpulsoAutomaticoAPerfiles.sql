INSERT INTO fun_pef
            (fun_id,
             pef_id,
             fp_id, VERSION, usuariocrear, fechacrear, usuariomodificar,
             fechamodificar, usuarioborrar, fechaborrar, borrado
            )
     VALUES ((SELECT fun_id
                FROM linmaster.fun_funciones
               WHERE fun_descripcion = 'ROLE_CONFIMPULSOS'),
             (SELECT PEF_ID
                FROM pef_perfiles
               WHERE pef_descripcion = 'SUPERVISOR OFI. PROCESAL'),
             s_fun_pef.NEXTVAL, 0, 'PBO', SYSDATE, NULL,
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
               WHERE fun_descripcion = 'ROLE_CONFIMPULSOS'),
             (SELECT PEF_ID
                FROM pef_perfiles
               WHERE pef_descripcion = 'SUPER ADMINISTRADOR'),
             s_fun_pef.NEXTVAL, 0, 'PBO', SYSDATE, NULL,
             NULL, NULL, NULL, 0
            );
            
COMMIT;            