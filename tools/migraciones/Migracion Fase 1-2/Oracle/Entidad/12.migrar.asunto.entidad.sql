-- Setear los estados
/*
En fase 1 solo se usa el estado 'Vacio' cuando se crea el asunto.

Se migran todos los asuntos al estado 'cerrado'
 */
UPDATE ASU_ASUNTOS
SET DD_EAS_ID = (SELECT DD_EAS_ID FROM PFSMASTER.DD_EAS_ESTADO_ASUNTOS WHERE DD_EAS_CODIGO = '06');

-- Migrar el gestor
UPDATE ASU_ASUNTOS a
SET GAS_ID = (SELECT USD_ID FROM GAS_GESTOR_ASUNTO G WHERE A.GAS_ID = G.GAS_ID);


--Creamos una ficha de aceptación por cada asunto existente
insert into AFA_FICHA_ACEPTACION(afa_id, asu_id, usuariocrear, fechacrear, borrado)
select S_AFA_FICHA_ACEPTACION.nextval, asu_id, 'DD', fechacrear, borrado FROM asu_asuntos;



commit;