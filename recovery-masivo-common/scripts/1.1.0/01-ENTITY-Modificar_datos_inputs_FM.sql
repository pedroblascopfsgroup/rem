--Modificamos el input
UPDATE bpm_idt_input_datos idt
   SET idt.bpm_idt_nombre = 'd_fecResolucionDecretoFinMon',
       idt.bpm_idt_dato = 'fecResolucionDecretoFinMon'
 WHERE idt.bpm_tpi_id =
          (SELECT tpi.bpm_tpi_id
             FROM bpm_tpi_tipo_proc_input tpi
            WHERE tpi.dd_tpo_id = (SELECT tpo.dd_tpo_id
                                     FROM dd_tpo_tipo_procedimiento tpo
                                    WHERE tpo.dd_tpo_codigo = 'P70')
              AND tpi.bpm_dd_tin_id =
                               (SELECT tin.bpm_dd_tin_id
                                  FROM bpm_dd_tin_tipo_input tin
                                 WHERE tin.bpm_dd_tin_codigo = 'AUTO_FIN_MON'))
   AND idt.bpm_idt_nombre = 'd_fecResolucionImpugnaOposicion';



UPDATE bpm_idt_input_datos idt
   SET idt.bpm_idt_nombre = 'd_fecRecepResolDecretoFinMon',
       idt.bpm_idt_dato = 'fecRecepResolDecretoFinMon'
 WHERE idt.bpm_tpi_id =
          (SELECT tpi.bpm_tpi_id
             FROM bpm_tpi_tipo_proc_input tpi
            WHERE tpi.dd_tpo_id = (SELECT tpo.dd_tpo_id
                                     FROM dd_tpo_tipo_procedimiento tpo
                                    WHERE tpo.dd_tpo_codigo = 'P70')
              AND tpi.bpm_dd_tin_id =
                               (SELECT tin.bpm_dd_tin_id
                                  FROM bpm_dd_tin_tipo_input tin
                                 WHERE tin.bpm_dd_tin_codigo = 'AUTO_FIN_MON'))
   AND idt.bpm_idt_nombre = 'd_fecRecepResolImpugnaOposicion';


 --Modificamos los datos del input
UPDATE bpm_dip_datos_input dip
   SET dip.bpm_dip_nombre = 'd_fecResolucionDecretoFinMon'
 WHERE dip.bpm_ipt_id IN (
          SELECT ipt.bpm_ipt_id
            FROM bpm_ipt_input ipt
           WHERE ipt.bpm_dd_tin_id =
                               (SELECT tin.bpm_dd_tin_id
                                  FROM bpm_dd_tin_tipo_input tin
                                 WHERE tin.bpm_dd_tin_codigo = 'AUTO_FIN_MON'))
   AND dip.bpm_dip_nombre = 'd_fecResolucionImpugnaOposicion';


UPDATE bpm_dip_datos_input dip
   SET dip.bpm_dip_nombre = 'd_fecRecepResolDecretoFinMon'
 WHERE dip.bpm_ipt_id IN (
          SELECT ipt.bpm_ipt_id
            FROM bpm_ipt_input ipt
           WHERE ipt.bpm_dd_tin_id =
                               (SELECT tin.bpm_dd_tin_id
                                  FROM bpm_dd_tin_tipo_input tin
                                 WHERE tin.bpm_dd_tin_codigo = 'AUTO_FIN_MON'))
   AND dip.bpm_dip_nombre = 'd_fecRecepResolImpugnaOposicion';

--Modificamos los datos de la cabecera
UPDATE bpm_gva_grupos_valores gva
   SET gva.bpm_gva_nombre_dato = 'fecResolucionDecretoFinMon'
 WHERE gva.prc_id IN (
                    SELECT prc.prc_id
                      FROM prc_procedimientos prc
                     WHERE prc.dd_tpo_id =
                                         (SELECT tpo.dd_tpo_id
                                            FROM dd_tpo_tipo_procedimiento tpo
                                           WHERE tpo.dd_tpo_codigo = 'P70'))
   AND gva.bpm_gva_nombre_dato = 'fecResolucionImpugnaOposicion';


UPDATE bpm_gva_grupos_valores gva
   SET gva.bpm_gva_nombre_dato = 'fecRecepResolDecretoFinMon'
 WHERE gva.prc_id IN (
                    SELECT prc.prc_id
                      FROM prc_procedimientos prc
                     WHERE prc.dd_tpo_id =
                                         (SELECT tpo.dd_tpo_id
                                            FROM dd_tpo_tipo_procedimiento tpo
                                           WHERE tpo.dd_tpo_codigo = 'P70'))
   AND gva.bpm_gva_nombre_dato = 'fecRecepResolImpugnaOposicion';