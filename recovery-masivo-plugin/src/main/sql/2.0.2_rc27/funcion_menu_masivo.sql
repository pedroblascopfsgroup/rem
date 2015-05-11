update linmaster.fun_funciones set fun_descripcion_larga = 'Ver menú de procesado masivo de tareas'
where fun_descripcion = 'PROCESADO_TAREAS';

insert into linmaster.fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(linmaster.s_fun_funciones.nextval, 'MENU_MASIVO_GENERAL', 'Ver cabecera de las opciones del menú masivo',0,'CPEREZ',sysdate,0);

Insert into FUN_PEF
   (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
SELECT (SELECT fun_id
          FROM linmaster.fun_funciones
         WHERE fun_descripcion = 'MENU_MASIVO_GENERAL'), pef.pef_id,
       s_fun_pef.NEXTVAL, 0, 'CPEREZ', SYSDATE, 0
  FROM pef_perfiles pef
 WHERE pef.pef_id IN (
          SELECT DISTINCT pef_id
                     FROM fun_pef
                    WHERE fun_id IN (
                             SELECT   fun_id
                                 FROM linmaster.fun_funciones
                                WHERE fun_descripcion = 'PROCESADO_TAREAS'
                                   OR fun_descripcion =
                                                      'PROCESADO_RESOLUCIONES'
                             GROUP BY fun_id));
commit;   