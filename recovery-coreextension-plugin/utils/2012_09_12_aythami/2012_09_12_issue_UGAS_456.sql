-- MODIFICACION DE LA TABLA TEV_TAREA_EXTERNA_VALOR AŅADIENDOLE UNA NUEVA COLUMNA
ALTER TABLE TEV_TAREA_EXTERNA_VALOR ADD TEV_VALOR_CLOB CLOB;
-- INSERTAMOS UNA NUEVA COLUMNA DTYPE
ALTER TABLE TEV_TAREA_EXTERNA_VALOR add DTYPE VARCHAR2(30) DEFAULT 'EXTTareaExternaValor';
-- AŅADIMOS EL VALOR POR DEFECTO A LA COLUMNA DTYPE
UPDATE  TEV_TAREA_EXTERNA_VALOR SET DTYPE = 'TareaExternaValor'

