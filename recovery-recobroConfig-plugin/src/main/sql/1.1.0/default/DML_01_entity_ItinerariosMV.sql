-- crear itinerario genérico recobro

insert into BANK01.iti_itinerarios iti (iti_id, ITI.ITI_NOMBRE, ITI.DD_AEX_ID, ITI.DD_TIT_ID, ITI.USUARIOCREAR, fechacrear)
values (BANK01.s_iti_itinerarios.nextval, 'Genérico recobro', 
        (select DD_AEX_ID from BANKMASTER.DD_AEX_AMBITOS_EXPEDIENTE where DD_AEX_CODIGO = 'CPGRA'),
        (SELECT DD_TIT_ID FROM bankmaster.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO = 'REC'),
        'SAG', SYSDATE);

--COMMIT;

-- insertar el nuevo estado de itinerario

insert into BANKMASTER.DD_EST_ESTADOS_ITINERARIOS ESTI (ESTI.DD_EST_ID, ESTI.DD_EIN_ID, ESTI.DD_EST_CODIGO, ESTI.DD_EST_DESCRIPCION, ESTI.DD_EST_DESCRIPCION_LARGA,
    ESTI.DD_EST_ORDEN, USUARIOCREAR, FECHACREAR) VALUES
    ((SELECT MAX(DD_EST_ID) +1 FROM BANKMASTER.DD_EST_ESTADOS_ITINERARIOS), 2, 'VMV', 
    'Vigilancia metas volantes',  'Vigilancia metas volantes', 1, 'SAG', SYSDATE);

--COMMIT;

-- NUEVOS PERFILES PARA RECOBRO

INSERT INTO BANK01.PEF_PERFILES PEF (PEF.PEF_ID, PEF.PEF_CODIGO, PEF_DESCRIPCION, PEF_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (BANK01.S_PEF_PERFILES.NEXTVAL, 'SREC', 'Supervisor itineario exp. recobro', 'Supervisor itineario exp. recobro', 'SAG', SYSDATE);

INSERT INTO BANK01.PEF_PERFILES PEF (PEF.PEF_ID, PEF.PEF_CODIGO, PEF_DESCRIPCION, PEF_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (BANK01.S_PEF_PERFILES.NEXTVAL, 'GREC', 'Gestor itineario exp. recobro', 'Gestor itineario exp. recobro', 'SAG', SYSDATE);

--COMMIT;

-- asociar el nuevo estado al itinerario genérico recobro

insert into BANK01.EST_ESTADOS
(
  EST_ID,
  PEF_ID_GESTOR,
  PEF_ID_SUPERVISOR,
  ITI_ID,
  DD_EST_ID,
  EST_PLAZO,
  EST_AUTOMATICO,
  USUARIOCREAR,
  FECHACREAR
) values (
  BANK01.s_EST_ESTADOS.nextval,
  (SELECT MAX(PEF_ID) FROM BANK01.PEF_PERFILES where pef_codigo = 'GREC'),
  (SELECT MAX(PEF_ID) FROM BANK01.PEF_PERFILES where pef_codigo = 'SREC'),
  (SELECT MAX(ITI_ID) FROM BANK01.ITI_ITINERARIOS where iti_nombre = 'Genérico recobro'),
  (SELECT MAX(DD_EST_ID) FROM BANKMASTER.DD_EST_ESTADOS_ITINERARIOS where dd_est_codigo = 'VMV'),
  1,0,'SAG',SYSDATE
);
    
--COMMIT;

-- insertar el arquetipo genérico para expedientes de recobro

insert into BANK01.arq_arquetipos arq (arq_id, ARQ.ARQ_NOMBRE, ARQ.ITI_ID, arq_gestion, usuariocrear, fechacrear)
values (BANK01.s_arq_arquetipos.nextval, 'Genérico expediente de recobro',
        (SELECT MAX(ITI_ID) FROM BANK01.ITI_ITINERARIOS where iti_nombre = 'Genérico recobro'),
        1, 'SAG', SYSDATE);

COMMIT;
