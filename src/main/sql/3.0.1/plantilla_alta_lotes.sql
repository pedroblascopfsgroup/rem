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