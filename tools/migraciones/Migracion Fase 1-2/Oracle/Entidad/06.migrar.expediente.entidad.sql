-- Calcular el estado del expediente
-- Expediente Activo
UPDATE EXP_EXPEDIENTES
SET DD_EEX_ID = (SELECT DD_EEX_ID FROM PFSMASTER.DD_EEX_ESTADO_EXPEDIENTE WHERE DD_EEX_CODIGO = '1')
WHERE EXP_ESTADO = 1;
-- Expediente Congelado
UPDATE EXP_EXPEDIENTES
SET DD_EEX_ID = (SELECT DD_EEX_ID FROM PFSMASTER.DD_EEX_ESTADO_EXPEDIENTE WHERE DD_EEX_CODIGO = '2')
WHERE EXP_ESTADO = 2;
-- Expediente Decidido
UPDATE EXP_EXPEDIENTES
SET DD_EEX_ID = (SELECT DD_EEX_ID FROM PFSMASTER.DD_EEX_ESTADO_EXPEDIENTE WHERE DD_EEX_CODIGO = '3')
WHERE EXP_ESTADO = 3;
-- Expediente Bloqueado
UPDATE EXP_EXPEDIENTES
SET DD_EEX_ID = (SELECT DD_EEX_ID FROM PFSMASTER.DD_EEX_ESTADO_EXPEDIENTE WHERE DD_EEX_CODIGO = '4')
WHERE EXP_ESTADO = 4;
-- Expediente Cancelado
UPDATE EXP_EXPEDIENTES
SET DD_EEX_ID = (SELECT DD_EEX_ID FROM PFSMASTER.DD_EEX_ESTADO_EXPEDIENTE WHERE DD_EEX_CODIGO = '5')
WHERE EXP_ESTADO = 5;

update EXP_EXPEDIENTES A
set A.exp_descripcion =
(
    SELECT CASE
                 WHEN (COALESCE (per.per_apellido1, NULL) || ' ' || COALESCE (per.per_apellido2, '') || ', ') = ' , '
                    THEN ''
                 ELSE COALESCE (per.per_apellido1, NULL) || ' ' || COALESCE (per.per_apellido2, '') || ', '
              END
           || COALESCE (per.per_nombre, '')
      FROM cex_contratos_expediente cex,
           cpe_contratos_personas cpe,
           dd_tin_tipo_intervencion tin,
           per_personas per
     WHERE cpe.cnt_id = cex.cnt_id
       AND cpe.dd_tin_id = tin.dd_tin_id
       AND cex.cex_pase = 1
       AND cex.exp_id = A.exp_id
       AND cpe.cpe_orden = 1
       AND cpe.per_id = per.per_id
       AND tin.dd_tin_titular = 1
)

commit;
