UPDATE dd_opm_operacion_masiva
   SET dd_opm_validacion_formato = 'n*,f',
        DD_OPM_CODIGO = 'CAS',
        DD_OPM_DESCRIPCION = 'Cancelación Asuntos',
        DD_OPM_DESCRIPCION_LARGA = 'Cancelación Asuntos'
 WHERE dd_opm_codigo = 'CPA';
 
 INSERT INTO dd_opm_operacion_masiva
            (dd_opm_id, dd_opm_codigo,
             dd_opm_descripcion, dd_opm_descripcion_larga,
             fun_id, VERSION, usuariocrear, fechacrear, usuariomodificar,
             fechamodificar, usuarioborrar, fechaborrar, borrado,
             dd_opm_validacion_formato
            )
     VALUES (s_dd_opm_operacion_masiva.nextval, 'PAS',
             'Paralización Asuntos', 'Paralización Asuntos',
             (SELECT fun_id
                FROM linmaster.fun_funciones
               WHERE fun_descripcion = 'ROLE_LEGAL'), 0, 'DD', SYSDATE, NULL,
             NULL, NULL, NULL, 0,
             'n*,f'
            );

UPDATE pop_plantillas_operacion
   SET pop_nombre = 'PLANTILLA7 - CANCELACIÓN ASUNTOS',
       pop_directorio = 'Cancelacion_asuntos.xls'
 WHERE dd_opm_id = 7;
 
 
INSERT INTO pop_plantillas_operacion
            (pop_id,
             pop_nombre, pop_directorio,
             dd_opm_id, VERSION, usuariocrear, fechacrear, usuariomodificar,
             fechamodificar, usuarioborrar, fechaborrar, borrado
            )
     VALUES (s_pop_plantillas_operacion.NEXTVAL,
             'PLANTILLA16 - PARALIACIÓN ASUNTOS', 'Paralizacion_asuntos.xls',
             (SELECT dd_opm_id
                FROM dd_opm_operacion_masiva
               WHERE dd_opm_codigo = 'PAS'), 0, 'SUPER', SYSDATE, NULL,
             NULL, NULL, NULL, 0
            );
