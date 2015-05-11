
INSERT INTO fun_pef
            (fun_id, pef_id, fp_id, VERSION, usuariocrear, fechacrear,
             borrado)
   SELECT (SELECT fun_id
             FROM linmaster.fun_funciones
            WHERE fun_descripcion = 'OBSERVACIONES_BIENES_PRC'), pef.pef_id,
          s_fun_pef.NEXTVAL, 0, 'CPEREZ', SYSDATE, 0
     FROM pef_perfiles pef;

     
COMMIT;     