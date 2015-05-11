SET DEFINE OFF;

INSERT into LINMASTER.FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, 
    FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, 
    BORRADO)
 Values
   (LINMASTER.S_FUN_FUNCIONES.NEXTVAL, 'Funcion de supervisor LEGAL Lindorff', 'ROLE_SUP_LEGAL', 0, 'CPEREZ', 
    SYSDATE, NULL, NULL, NULL, NULL, 0);


INSERT INTO fun_pef
            (fun_id,
             pef_id,
             fp_id, VERSION, usuariocrear, fechacrear, usuariomodificar,
             fechamodificar, usuarioborrar, fechaborrar, borrado
            )
     VALUES ((SELECT f.fun_id
                FROM linmaster.fun_funciones f
               WHERE fun_descripcion = 'ROLE_SUP_LEGAL'),
             (SELECT p.pef_id
                FROM lin001.pef_perfiles p
               WHERE pef_descripcion = 'SUPERVISOR OFI. PROCESAL'),
             s_fun_pef.NEXTVAL, 0, 'CPEREZ', SYSDATE, NULL,
             NULL, NULL, NULL, 0
            );
COMMIT;
