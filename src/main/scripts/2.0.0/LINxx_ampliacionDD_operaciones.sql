/* INSERTAMOS LAS OPERACIONES */
INSERT INTO DD_OPM_OPERACION_MASIVA (DD_OPM_ID,DD_OPM_CODIGO,DD_OPM_DESCRIPCION,DD_OPM_DESCRIPCION_LARGA,FUN_ID,USUARIOCREAR,FECHACREAR,DD_OPM_VALIDACION_FORMATO) 
    VALUES (S_DD_OPM_OPERACION_MASIVA.nextVal,'STO','Solicitar testimonio','Solicitar testimonio',(select fun_id from linmaster.fun_funciones where fun_descripcion='ROLE_BO'),'DD',SYSDATE, 'n,n*,f*');

INSERT INTO DD_OPM_OPERACION_MASIVA (DD_OPM_ID,DD_OPM_CODIGO,DD_OPM_DESCRIPCION,DD_OPM_DESCRIPCION_LARGA,FUN_ID,USUARIOCREAR,FECHACREAR,DD_OPM_VALIDACION_FORMATO) 
    VALUES (S_DD_OPM_OPERACION_MASIVA.nextVal,'RDO','Regenerar documentación','Regenerar documentación',(select fun_id from linmaster.fun_funciones where fun_descripcion='ROLE_BO'),'DD',SYSDATE, 'n,n*');
    
INSERT INTO DD_OPM_OPERACION_MASIVA (DD_OPM_ID,DD_OPM_CODIGO,DD_OPM_DESCRIPCION,DD_OPM_DESCRIPCION_LARGA,FUN_ID,USUARIOCREAR,FECHACREAR,DD_OPM_VALIDACION_FORMATO) 
    VALUES (S_DD_OPM_OPERACION_MASIVA.nextVal,'GFT','Generar fichero tasas','Generar fichero tasas',(select fun_id from linmaster.fun_funciones where fun_descripcion='ROLE_BO'),'DD',SYSDATE, 'n,n*,f*');
    
INSERT INTO DD_OPM_OPERACION_MASIVA (DD_OPM_ID,DD_OPM_CODIGO,DD_OPM_DESCRIPCION,DD_OPM_DESCRIPCION_LARGA,FUN_ID,USUARIOCREAR,FECHACREAR,DD_OPM_VALIDACION_FORMATO) 
    VALUES (S_DD_OPM_OPERACION_MASIVA.nextVal,'VFT','Validar fichero tasas','Validar fichero tasas',(select fun_id from linmaster.fun_funciones where fun_descripcion='ROLE_BO'),'DD',SYSDATE,'n,n*,b*,b');
    
INSERT INTO DD_OPM_OPERACION_MASIVA (DD_OPM_ID,DD_OPM_CODIGO,DD_OPM_DESCRIPCION,DD_OPM_DESCRIPCION_LARGA,FUN_ID,USUARIOCREAR,FECHACREAR,DD_OPM_VALIDACION_FORMATO) 
    VALUES (S_DD_OPM_OPERACION_MASIVA.nextVal,'SPT','Solicitar pago tasas','Solicitar pago tasas - generar fichero AEAT',(select fun_id from linmaster.fun_funciones where fun_descripcion='ROLE_BO'),'DD',SYSDATE,'n,n*,f*');
    
INSERT INTO DD_OPM_OPERACION_MASIVA (DD_OPM_ID,DD_OPM_CODIGO,DD_OPM_DESCRIPCION,DD_OPM_DESCRIPCION_LARGA,FUN_ID,USUARIOCREAR,FECHACREAR,DD_OPM_VALIDACION_FORMATO) 
    VALUES (S_DD_OPM_OPERACION_MASIVA.nextVal,'CRJT','Confirmar recepción justificante tasas','Confirmar recepción justificante tasas',(select fun_id from linmaster.fun_funciones where fun_descripcion='ROLE_BO'),'DD',SYSDATE,'n,n*,f*');

INSERT INTO DD_OPM_OPERACION_MASIVA (DD_OPM_ID,DD_OPM_CODIGO,DD_OPM_DESCRIPCION,DD_OPM_DESCRIPCION_LARGA,FUN_ID,USUARIOCREAR,FECHACREAR,DD_OPM_VALIDACION_FORMATO) 
    VALUES (S_DD_OPM_OPERACION_MASIVA.nextVal,'CRDI','Confirmar recepción documentación impresa','Confirmar recepción documentación impresa',(select fun_id from linmaster.fun_funciones where fun_descripcion='ROLE_BO'),'DD',SYSDATE,'n,n*,f*');


/* INSERTAMOS LAS PLANTILLAS */
INSERT INTO pop_plantillas_operacion
            (pop_id,
             pop_nombre, pop_directorio,
             dd_opm_id, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_pop_plantillas_operacion.NEXTVAL,
             'PLANTILLA9 - SOLICITAR TESTIMONIO', 'Solicitar_testimonio.xls',
             (SELECT dd_opm_id
                FROM dd_opm_operacion_masiva
               WHERE dd_opm_codigo = 'STO'), 0, 'DD', SYSDATE, 0
            );

INSERT INTO pop_plantillas_operacion
            (pop_id,
             pop_nombre,
             pop_directorio, dd_opm_id,
             VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_pop_plantillas_operacion.NEXTVAL,
             'PLANTILLA10 - REGENERAR DOCUMENTACION',
             'Regenerar_documentacion.xls', (SELECT dd_opm_id
                                               FROM dd_opm_operacion_masiva
                                              WHERE dd_opm_codigo = 'RDO'),
             0, 'DD', SYSDATE, 0
            );

INSERT INTO pop_plantillas_operacion
            (pop_id,
             pop_nombre,
             pop_directorio, dd_opm_id, VERSION,
             usuariocrear, fechacrear, borrado
            )
     VALUES (s_pop_plantillas_operacion.NEXTVAL,
             'PLANTILLA11 - GENERAR FICHERO TASAS',
             'Generar_fichero_tasas.xls', (SELECT dd_opm_id
                                             FROM dd_opm_operacion_masiva
                                            WHERE dd_opm_codigo = 'GFT'), 0,
             'DD', SYSDATE, 0
            );

INSERT INTO pop_plantillas_operacion
            (pop_id,
             pop_nombre,
             pop_directorio, dd_opm_id, VERSION,
             usuariocrear, fechacrear, borrado
            )
     VALUES (s_pop_plantillas_operacion.NEXTVAL,
             'PLANTILLA12 - VALIDAR FICHERO TASAS',
             'Validar_fichero_tasas.xls', (SELECT dd_opm_id
                                             FROM dd_opm_operacion_masiva
                                            WHERE dd_opm_codigo = 'VFT'), 0,
             'DD', SYSDATE, 0
            );

INSERT INTO pop_plantillas_operacion
            (pop_id,
             pop_nombre,
             pop_directorio, dd_opm_id, VERSION,
             usuariocrear, fechacrear, borrado
            )
     VALUES (s_pop_plantillas_operacion.NEXTVAL,
             'PLANTILLA13 - SOLICITAR PAGO TASAS',
             'Solicitar_pago_tasas.xls', (SELECT dd_opm_id
                                            FROM dd_opm_operacion_masiva
                                           WHERE dd_opm_codigo = 'SPT'), 0,
             'DD', SYSDATE, 0
            );

INSERT INTO pop_plantillas_operacion
            (pop_id,
             pop_nombre,
             pop_directorio,
             dd_opm_id, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_pop_plantillas_operacion.NEXTVAL,
             'PLANTILLA14 - CONFIRMAR RECEPCION JUSTIFICANTE TASAS',
             'Confirmar_recep_justif_tasas.xls',
             (SELECT dd_opm_id
                FROM dd_opm_operacion_masiva
               WHERE dd_opm_codigo = 'CRJT'), 0, 'DD', SYSDATE, 0
            );

INSERT INTO pop_plantillas_operacion
            (pop_id,
             pop_nombre,
             pop_directorio,
             dd_opm_id, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_pop_plantillas_operacion.NEXTVAL,
             'PLANTILLA15 - CONFIRMAR RECEPCION DOCUMENTACION IMPRESA',
             'Confirmar_recep_docu_impresa.xls',
             (SELECT dd_opm_id
                FROM dd_opm_operacion_masiva
               WHERE dd_opm_codigo = 'CRDI'), 0, 'DD', SYSDATE, 0
            );
    

/* MODIFICAMOS LA VALIDACION DE LAS OPERACIONES CREADAS EN UN SCRIPT ANTERIOR */
UPDATE DD_OPM_OPERACION_MASIVA SET DD_OPM_VALIDACION_FORMATO = 'n,n*,f*,b' WHERE DD_OPM_CODIGO = 'CRCO';    
UPDATE DD_OPM_OPERACION_MASIVA SET DD_OPM_VALIDACION_FORMATO = 'n,n*,f*,n*,n*' WHERE DD_OPM_CODIGO = 'CRT';    
UPDATE DD_OPM_OPERACION_MASIVA SET DD_OPM_VALIDACION_FORMATO = 'n,n*,f*' WHERE DD_OPM_CODIGO = 'IMD';    
UPDATE DD_OPM_OPERACION_MASIVA SET DD_OPM_VALIDACION_FORMATO = 'n,n*,f*,s' WHERE DD_OPM_CODIGO = 'EJZ';            
    
COMMIT;