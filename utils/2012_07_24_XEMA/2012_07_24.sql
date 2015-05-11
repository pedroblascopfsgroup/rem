ALTER TABLE UGAS001.DD_TFA_FICHERO_ADJUNTO
 ADD (DD_TAC_ID  NUMBER(16));

ALTER TABLE UGAS001.DD_TFA_FICHERO_ADJUNTO
 ADD CONSTRAINT FK_DD_TFA_DD_TAC 
 FOREIGN KEY (DD_TAC_ID) 
 REFERENCES UGAS001.DD_TAC_TIPO_ACTUACION (DD_TAC_ID);

 
update DD_TFA_FICHERO_ADJUNTO 
set dd_tac_id = (select dd_tac_id from dd_tac_tipo_actuacion where dd_tac_codigo = 'CO')
where dd_tfa_descripcion like '%(Con)-%';

commit;