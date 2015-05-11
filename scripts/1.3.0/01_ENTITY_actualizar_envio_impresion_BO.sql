UPDATE DD_OPM_OPERACION_MASIVA SET DD_OPM_VALIDACION_FORMATO = 'n,n*,f,s*' WHERE DD_OPM_CODIGO = 'IMD';

UPDATE lin001.bpm_tpi_tipo_proc_input tpi
   SET tpi.bpm_tpi_post_process_bo = NULL
 WHERE bpm_dd_tin_id = (SELECT tin.bpm_dd_tin_id
                          FROM lin001.bpm_dd_tin_tipo_input tin
                         WHERE bpm_dd_tin_codigo = 'IMP');
                         
                         

INSERT INTO bpm_idt_input_datos
            (bpm_idt_id,
             bpm_tpi_id, bpm_idt_nombre,
             bpm_idt_grupo, bpm_idt_dato, VERSION, usuariocrear, fechacrear,
             usuariomodificar, fechamodificar, usuarioborrar, fechaborrar,
             borrado
            )
     VALUES (s_bpm_idt_input_datos.NEXTVAL,
             (SELECT TPI.BPM_TPI_ID FROM lin001.bpm_tpi_tipo_proc_input tpi
 WHERE bpm_dd_tin_id = (SELECT tin.bpm_dd_tin_id
                          FROM lin001.bpm_dd_tin_tipo_input tin
                         WHERE bpm_dd_tin_codigo = 'IMP')), 'Tipo documentacion',
             'cabecera', 'Tipo documentacion', 0, 'MASIVO', SYSDATE,
             NULL, NULL, NULL, NULL,
             0
            );                       