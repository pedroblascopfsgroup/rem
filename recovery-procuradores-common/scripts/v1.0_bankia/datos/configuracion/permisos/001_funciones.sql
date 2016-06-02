SET DEFINE OFF;
INSERT INTO bankmaster.fun_funciones
            (fun_id, fun_descripcion_larga, fun_descripcion, VERSION,
             usuariocrear, fechacrear, usuariomodificar, fechamodificar, usuarioborrar, fechaborrar, borrado
            )
     VALUES (bankmaster.s_fun_funciones.NEXTVAL, 'Muestra el menú de procuradores', 'MENU_PROCURADORES_GENERAL', 0,
             'MOD_PROC', SYSDATE, NULL, NULL, NULL, NULL, 0
            );
            
INSERT INTO bankmaster.fun_funciones
            (fun_id, fun_descripcion_larga, fun_descripcion, VERSION,
             usuariocrear, fechacrear, usuariomodificar, fechamodificar, usuarioborrar, fechaborrar, borrado
            )
     VALUES (bankmaster.s_fun_funciones.NEXTVAL, 'Muestra el menú de procesador de resoluciones del procurador', 'MENU_PROCESADO_PROCURADORES', 0,
             'MOD_PROC', SYSDATE, NULL, NULL, NULL, NULL, 0
            );
            
INSERT INTO bankmaster.fun_funciones
            (fun_id, fun_descripcion_larga, fun_descripcion, VERSION,
             usuariocrear, fechacrear, usuariomodificar, fechamodificar, usuarioborrar, fechaborrar, borrado
            )
     VALUES (bankmaster.s_fun_funciones.NEXTVAL, 'Muestra el menú de mantenimiento de categorías', 'MANTENIMIENTO_CATEGORIAS', 0,
             'MOD_PROC', SYSDATE, NULL, NULL, NULL, NULL, 0
            );
            
INSERT INTO bankmaster.fun_funciones
            (fun_id, fun_descripcion_larga, fun_descripcion, VERSION,
             usuariocrear, fechacrear, usuariomodificar, fechamodificar, usuarioborrar, fechaborrar, borrado
            )
     VALUES (bankmaster.s_fun_funciones.NEXTVAL, 'Abre la ventana de resoluciones por defecto', 'INITIAL_TAB_RESOL_PROC', 0,
             'MOD_PROC', SYSDATE, NULL, NULL, NULL, NULL, 0
            );   
            
INSERT INTO bankmaster.fun_funciones
            (fun_id, fun_descripcion_larga, fun_descripcion, VERSION,
             usuariocrear, fechacrear, usuariomodificar, fechamodificar, usuarioborrar, fechaborrar, borrado
            )
     VALUES (bankmaster.s_fun_funciones.NEXTVAL, 'Muestra la rama de tareas pendientes de validar', 'RAMA_TAREAS_PENDIENTES_VALIDAR', 0,
             'MOD_PROC', SYSDATE, NULL, NULL, NULL, NULL, 0
            ); 
COMMIT;