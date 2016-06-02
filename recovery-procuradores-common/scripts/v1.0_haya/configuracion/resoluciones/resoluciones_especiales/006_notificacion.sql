-- Creamos el tipo de acción upload.
INSERT INTO bpm_dd_tac_tipo_accion
            (bpm_dd_tac_id, bpm_dd_tac_codigo, bpm_dd_tac_descripcion, bpm_dd_tac_descripcion_larga, VERSION, usuariocrear, fechacrear, borrado)
     VALUES (56, 'NOTIFICACION', 'Notificacion', 'Notificacion', 0, 'MOD_PROC', SYSDATE, 0);
     
-- Insertamos en la tabla DD_TR_TIPOS_RESOLUCIONES (OJO!! El id debe coincidir con el FactoriaFormulario.js y deberá haber una de estas por cada pantalla)
Insert into DD_TR_TIPOS_RESOLUCION (DD_TR_ID,DD_TR_CODIGO,DD_TR_DESCRIPCION,DD_TR_DESCRIPCION_LARGA,
DD_TJ_ID,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,
DD_TR_AYUDA,BPM_DD_TAC_ID) 
SELECT '1005','RESOL_ESP_NOTI','Notificacion','Notificacion',
(SELECT DD_TJ_ID FROM DD_TJ_TIPO_JUICIO WHERE DD_TJ_CODIGO = 'HIP'),'0','MOD_PROC', sysdate, '0',
'Ayuda de resolución de notificación.', 
(SELECT BPM_DD_TAC_ID FROM BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO='NOTIFICACION') from dual;
