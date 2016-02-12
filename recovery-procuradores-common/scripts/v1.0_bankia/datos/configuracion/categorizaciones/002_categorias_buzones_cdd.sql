SET DEFINE OFF;
INSERT INTO cat_categorias (cat_id, ctg_id, cat_nombre, cat_descripcion, VERSION,usuariocrear, fechacrear, borrado, cat_orden)
     VALUES (s_cat_categorias.NEXTVAL, (SELECT ctg_id FROM ctg_categorizaciones ctg WHERE ctg.ctg_nombre LIKE '%CDD%'), 
                'Documentación', 'Documentación', 0, 'MOD_PROC', SYSDATE, 0, 1);
INSERT INTO cat_categorias (cat_id, ctg_id, cat_nombre, cat_descripcion, VERSION,usuariocrear, fechacrear, borrado, cat_orden)
     VALUES (s_cat_categorias.NEXTVAL, (SELECT ctg_id FROM ctg_categorizaciones ctg WHERE ctg.ctg_nombre LIKE '%CDD%'), 
                'Sin Respuesta', 'Sin Respuesta', 0, 'MOD_PROC', SYSDATE, 0, 2);
INSERT INTO cat_categorias (cat_id, ctg_id, cat_nombre, cat_descripcion, VERSION,usuariocrear, fechacrear, borrado, cat_orden)
     VALUES (s_cat_categorias.NEXTVAL, (SELECT ctg_id FROM ctg_categorizaciones ctg WHERE ctg.ctg_nombre LIKE '%CDD%'), 
                'Con Plazo', 'Con Plazo', 0, 'MOD_PROC', SYSDATE, 0, 3);
INSERT INTO cat_categorias (cat_id, ctg_id, cat_nombre, cat_descripcion, VERSION,usuariocrear, fechacrear, borrado, cat_orden)
     VALUES (s_cat_categorias.NEXTVAL, (SELECT ctg_id FROM ctg_categorizaciones ctg WHERE ctg.ctg_nombre LIKE '%CDD%'), 
                'Subastas', 'Subastas', 0, 'MOD_PROC', SYSDATE, 0, 4);
INSERT INTO cat_categorias (cat_id, ctg_id, cat_nombre, cat_descripcion, VERSION,usuariocrear, fechacrear, borrado, cat_orden)
     VALUES (s_cat_categorias.NEXTVAL, (SELECT ctg_id FROM ctg_categorizaciones ctg WHERE ctg.ctg_nombre LIKE '%CDD%'), 
                'Sin Plazo', 'Sin Plazo', 0, 'MOD_PROC', SYSDATE, 0, 5);
INSERT INTO cat_categorias (cat_id, ctg_id, cat_nombre, cat_descripcion, VERSION,usuariocrear, fechacrear, borrado, cat_orden)
     VALUES (s_cat_categorias.NEXTVAL, (SELECT ctg_id FROM ctg_categorizaciones ctg WHERE ctg.ctg_nombre LIKE '%CDD%'), 
                'Minutas', 'Minutas', 0, 'MOD_PROC', SYSDATE, 0, 6);
INSERT INTO cat_categorias (cat_id, ctg_id, cat_nombre, cat_descripcion, VERSION,usuariocrear, fechacrear, borrado, cat_orden)
     VALUES (s_cat_categorias.NEXTVAL, (SELECT ctg_id FROM ctg_categorizaciones ctg WHERE ctg.ctg_nombre LIKE '%CDD%'), 
                'Acta Subastas', 'Acta Subastas', 0, 'MOD_PROC', SYSDATE, 0, 7);
INSERT INTO cat_categorias (cat_id, ctg_id, cat_nombre, cat_descripcion, VERSION,usuariocrear, fechacrear, borrado, cat_orden)
     VALUES (s_cat_categorias.NEXTVAL, (SELECT ctg_id FROM ctg_categorizaciones ctg WHERE ctg.ctg_nombre LIKE '%CDD%'), 
                'Toma y Lanzamiento', 'Toma y Lanzamiento', 0, 'MOD_PROC', SYSDATE, 0, 8);
                
COMMIT;