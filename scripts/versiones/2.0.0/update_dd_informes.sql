UPDATE DD_INFORMES SET DD_INFORME_CODIGO = 'DEMANDA_MONITORIO_CPROC' 
WHERE DD_INFORME_CODIGO = 'DEMANDA_MONITORIO_CON_PROC';

UPDATE DD_INFORMES SET DD_INFORME_CODIGO = 'DEMANDA_MONITORIO_SPROC' 
WHERE DD_INFORME_CODIGO = 'DEMANDA_MONITORIO_SIN_PROC';

UPDATE DD_INFORMES SET DD_INFORME_CODIGO = 'CERTIFICADO_DEUDA_CPROC' 
WHERE DD_INFORME_CODIGO = 'CERTIFICADO_DEUDA_CON_PROC';

UPDATE DD_INFORMES SET DD_INFORME_CODIGO = 'CERTIFICADO_DEUDA_SPROC' 
WHERE DD_INFORME_CODIGO = 'CERTIFICADO_DEUDA_SIN_PROC';

COMMIT;