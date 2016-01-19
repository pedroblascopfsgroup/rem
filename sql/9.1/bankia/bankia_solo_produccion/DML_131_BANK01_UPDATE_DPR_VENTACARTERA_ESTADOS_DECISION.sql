UPDATE BANK01.DPR_DECISIONES_PROCEDIMIENTOS
SET DD_EDE_ID = (SELECT DD_EDE_ID FROM BANKMASTER.DD_EDE_ESTADOS_DECISION WHERE DD_EDE_DESCRIPCION = 'ACEPTADO')
WHERE DD_DFI_ID = (SELECT DD_DFI_ID FROM BANK01.DD_DFI_DECISION_FINALIZAR WHERE DD_DFI_CODIGO = 'VENTACAR') 
  AND DD_EDE_ID != (SELECT DD_EDE_ID FROM BANKMASTER.DD_EDE_ESTADOS_DECISION WHERE DD_EDE_DESCRIPCION = 'ACEPTADO');
  
COMMIT;
