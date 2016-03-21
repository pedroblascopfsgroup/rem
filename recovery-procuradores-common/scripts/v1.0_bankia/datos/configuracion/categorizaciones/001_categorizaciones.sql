/* Formatted on 2015/02/13 12:25 (Formatter Plus v4.8.8) */
SET DEFINE OFF;
INSERT INTO ctg_categorizaciones
            (ctg_id, ctg_nombre, VERSION, usuariocrear, fechacrear, borrado, ctg_codigo
            )
     VALUES (s_ctg_categorizaciones.NEXTVAL, 'Prioridad', 0, 'MOD_PROC', SYSDATE, 0, 'PRIORIDAD'
            );

INSERT INTO ctg_categorizaciones
            (ctg_id, ctg_nombre, VERSION, usuariocrear, fechacrear, borrado, ctg_codigo
            )
     VALUES (s_ctg_categorizaciones.NEXTVAL, 'Tipo de Procedimiento', 0, 'MOD_PROC', SYSDATE, 0, 'TIPO_PROC'
            );

INSERT INTO ctg_categorizaciones
            (ctg_id, ctg_nombre, VERSION, usuariocrear, fechacrear, borrado, ctg_codigo
            )
     VALUES (s_ctg_categorizaciones.NEXTVAL, 'Buzones CDD', 0, 'MOD_PROC', SYSDATE, 0, 'CDD'
            );

COMMIT ;