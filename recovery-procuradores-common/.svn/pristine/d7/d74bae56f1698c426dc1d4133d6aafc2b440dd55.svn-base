SET DEFINE OFF;
INSERT INTO cat_categorias (cat_id, ctg_id, cat_nombre, cat_descripcion, VERSION,usuariocrear, fechacrear, borrado, cat_orden)
     VALUES (s_cat_categorias.NEXTVAL, (SELECT ctg_id FROM ctg_categorizaciones ctg WHERE ctg.ctg_nombre LIKE '%Procedimiento%'), 
                'Hipotecario', 'Hipotecario', 0, 'MOD_PROC', SYSDATE, 0, 1);
INSERT INTO cat_categorias (cat_id, ctg_id, cat_nombre, cat_descripcion, VERSION,usuariocrear, fechacrear, borrado, cat_orden)
     VALUES (s_cat_categorias.NEXTVAL, (SELECT ctg_id FROM ctg_categorizaciones ctg WHERE ctg.ctg_nombre LIKE '%Procedimiento%'), 
                'Monitorio', 'Monitorio', 0, 'MOD_PROC', SYSDATE, 0, 2);
INSERT INTO cat_categorias (cat_id, ctg_id, cat_nombre, cat_descripcion, VERSION,usuariocrear, fechacrear, borrado, cat_orden)
     VALUES (s_cat_categorias.NEXTVAL, (SELECT ctg_id FROM ctg_categorizaciones ctg WHERE ctg.ctg_nombre LIKE '%Procedimiento%'), 
                'ETJ', 'ETJ', 0, 'MOD_PROC', SYSDATE, 0, 3);
commit;