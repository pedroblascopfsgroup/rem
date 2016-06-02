-- Permisos temporales --
-- Hay que crear el perfile del procurador y asignarle lo permisos que toca --
/*
Insert into FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, 
    FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, 
    BORRADO)
 Values
   (S_FUN_FUNCIONES.NEXTVAL, 'Mantenimiento de categorías', 'MANTENIMIENTO_CATEGORIAS', 0, 'PFS', SYSDATE, NULL, NULL, NULL, NULL, 0);
  */
   
   
Insert into FUN_PEF
   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, 
    FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, 
    BORRADO)
 Values
   ((select fun_id from HAYAMASTER.fun_funciones fun where fun.FUN_DESCRIPCION = 'MANTENIMIENTO_CATEGORIAS'), 10000000000701, S_FUN_PEF.NEXTVAL, 0, 'SUPER_PR', SYSDATE, NULL, NULL, NULL, NULL,0);
   
Insert into FUN_PEF
   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, 
    FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, 
    BORRADO)
 Values
   ((select fun_id from HAYAMASTER.fun_funciones fun where fun.FUN_DESCRIPCION = 'MENU_PROCURADORES_GENERAL'), 10000000000700, S_FUN_PEF.NEXTVAL, 0, 'SUPER_PR', SYSDATE, NULL, NULL, NULL, NULL,0);
   
Insert into FUN_PEF
   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, 
    FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, 
    BORRADO)
 Values
   ((select fun_id from HAYAMASTER.fun_funciones fun where fun.FUN_DESCRIPCION = 'MENU_PROCESADO_PROCURADORES'), 10000000000700, S_FUN_PEF.NEXTVAL, 0, 'SUPER_PR', SYSDATE, NULL, NULL, NULL, NULL,0);
   
Insert into FUN_PEF
   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, 
    FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, 
    BORRADO)
 Values
   ((select fun_id from HAYAMASTER.fun_funciones fun where fun.FUN_DESCRIPCION = 'INITIAL_TAB_RESOL_PROC'), 10000000000700, S_FUN_PEF.NEXTVAL, 0, 'SUPER_PR', SYSDATE, NULL, NULL, NULL, NULL,0);
   
 Insert into FUN_PEF
   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, 
    FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, 
    BORRADO)
 Values
   ((select fun_id from HAYAMASTER.fun_funciones fun where fun.FUN_DESCRIPCION = 'RAMA_TAREAS_PENDIENTES_VALIDAR'), 10000000000700, S_FUN_PEF.NEXTVAL, 0, 'SUPER_PR', SYSDATE, NULL, NULL, NULL, NULL,0);
     
-- BANKIA --
/* Formatted on 2015/02/16 18:21 (Formatter Plus v4.8.8) */
-- Permisos temporales --
-- Hay que crear el perfile del procurador y asignarle lo permisos que toca --
/*
INSERT INTO bankmaster.fun_funciones
            (fun_id, fun_descripcion_larga, fun_descripcion, VERSION,
             usuariocrear, fechacrear, usuariomodificar, fechamodificar, usuarioborrar, fechaborrar, borrado
            )
     VALUES (bankmaster.s_fun_funciones.NEXTVAL, 'Mantenimiento de categorías', 'MANTENIMIENTO_CATEGORIAS', 0,
             'PFS', SYSDATE, NULL, NULL, NULL, NULL, 0
            );
*/

/*
INSERT INTO fun_pef
            (fun_id, pef_id, fp_id, VERSION,
             usuariocrear, fechacrear, usuariomodificar, fechamodificar, usuarioborrar, fechaborrar, borrado
            )
     VALUES ((SELECT fun_id
                FROM bankmaster.fun_funciones fun
               WHERE fun.fun_descripcion = 'MANTENIMIENTO_CATEGORIAS'), 10000000000701, s_fun_pef.NEXTVAL, 0,
             'SUPER_PR', SYSDATE, NULL, NULL, NULL, NULL, 0
            );   
   */