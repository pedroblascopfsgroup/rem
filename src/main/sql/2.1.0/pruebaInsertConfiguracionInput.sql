Insert into BPM_TPI_TIPO_PROC_INPUT
   (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID)
 Values
   (S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P70'), (SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='INADM_CON_PROC_LEGAL'),
    'ALL', 'NONE', 0, 'MASIVO', SYSDATE, 0, 4, (SELECT DD_INFORME_ID FROM DD_INFORMES WHERE DD_INFORME_CODIGO='DESGLOSE_CPROC'));
    
    
Insert into BPM_TPI_TIPO_PROC_INPUT
   (BPM_TPI_ID, DD_TPO_ID, BPM_DD_TIN_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TAC_ID, DD_INFORME_ID)
 Values
   (S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL, (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P70'), (SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO='REQ_PAG_POS_CON_PROC_LEG'),
    'ALL', 'NONE', 0, 'MASIVO', SYSDATE, 0, 4, (SELECT DD_INFORME_ID FROM DD_INFORMES WHERE DD_INFORME_CODIGO='SOL_DEC_FIN_MONIT_CPROC'));    

