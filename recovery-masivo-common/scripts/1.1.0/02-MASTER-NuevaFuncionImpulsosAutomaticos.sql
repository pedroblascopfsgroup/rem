INSERT INTO fun_funciones
            (fun_id,
             fun_descripcion_larga,
             fun_descripcion, VERSION, usuariocrear, fechacrear,
             usuariomodificar, fechamodificar, usuarioborrar, fechaborrar,
             borrado
            )
     VALUES ((select max(fun_id)+1 from fun_funciones),
             'Ver opciones de configuración de impulsos procesales',
             'ROLE_CONFIMPULSOS', 0, 'PBO', SYSDATE,
             NULL, NULL, NULL, NULL,
             0);

COMMIT;