--
-- Añade una función para visualizar las observaciones del bien
-- Ejecutar como usuario MASTER
--
INSERT INTO fun_funciones
            (fun_id, fun_descripcion,
             fun_descripcion_larga,
             VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_fun_funciones.NEXTVAL, 'OBSERVACIONES_BIENES_PRC',
             'Visualizar las observaciones del bien en listado de embargos del procedimiento',
             0, 'CPEREZ', SYSDATE, 0
            );

     
COMMIT;