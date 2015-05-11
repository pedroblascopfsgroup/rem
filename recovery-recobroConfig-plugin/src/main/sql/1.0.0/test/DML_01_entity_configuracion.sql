 set verify off;

define MASTER_SCHEMA = BANKMASTER;

 -- insertar agencias
 Insert into RCF_AGE_AGENCIAS
   (RCF_AGE_ID, RCF_AGE_CODIGO, RCF_AGE_NOMBRE, RCF_AGE_NIF, RCF_AGE_CONTACTO_NOMBRE, RCF_AGE_CONTACTO_APE1, RCF_AGE_CONTACTO_APE2,
    RCF_AGE_CONTACTO_MAIL, RCF_AGE_CONTACTO_TELF,
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_AGE_AGENCIAS.nextval, 'AGE1', 'Agencia 1', 'A11222444', 'Sergio', 'Alarcón', 'Guardia',
   'sergio.alarcon@pfsgroup.es', '112244578', 
    1, 'SAG', sysdate, 0);

 Insert into RCF_AGE_AGENCIAS
   (RCF_AGE_ID, RCF_AGE_CODIGO, RCF_AGE_NOMBRE, RCF_AGE_NIF, RCF_AGE_CONTACTO_NOMBRE, RCF_AGE_CONTACTO_APE1, RCF_AGE_CONTACTO_APE2,
    RCF_AGE_CONTACTO_MAIL, RCF_AGE_CONTACTO_TELF,
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_AGE_AGENCIAS.nextval, 'AGE2', 'Agencia 2', 'A11222444', 'Diana', 'Bosque', 'Guardia',
   'diana.bosque@pfsgroup.es', '112244578', 
    1, 'SAG', sysdate, 0); 

 Insert into RCF_AGE_AGENCIAS
   (RCF_AGE_ID, RCF_AGE_CODIGO, RCF_AGE_NOMBRE, RCF_AGE_NIF, RCF_AGE_CONTACTO_NOMBRE, RCF_AGE_CONTACTO_APE1, RCF_AGE_CONTACTO_APE2,
    RCF_AGE_CONTACTO_MAIL, RCF_AGE_CONTACTO_TELF,
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_AGE_AGENCIAS.nextval, 'AGE3', 'Agencia 3', 'A11222444', 'Carlos', 'Pérez', 'Guardia',
   'carlos.perez@pfsgroup.es', '112244578', 
    1, 'SAG', sysdate, 0); 
    
COMMIT; 

-- insertar despacho por defecto

insert into des_despacho_externo des 
    (des_id, des_despacho, des_tipo_via, des_domicilio, des_codigo_postal, des_persona_contacto, des_telefono1, zon_id, dd_tde_id, usuariocrear, fechacrear)
    select s_des_despacho_externo.nextval, agencia, tipo_via, nombre_via, cod_postal, contacto, telf, zona, tipo, 'SAG', sysdate
    from 
        (select AGE.RCF_AGE_NOMBRE agencia, TVI.DD_TVI_DESCRIPCION tipo_via, AGE.RCF_AGE_NOMBRE_VIA nombre_via, AGE.RCF_AGE_COD_POSTAL cod_postal, 
                AGE.RCF_AGE_CONTACTO_NOMBRE || ' ' || AGE.RCF_AGE_CONTACTO_APE1 contacto, AGE.RCF_AGE_CONTACTO_TELF telf, 
                (select zon_id from zon_zonificacion where zon_cod = '01') zona,
                (select tde.dd_tde_id from &MASTER_SCHEMA..dd_tde_tipo_despacho tde where TDE.DD_TDE_CODIGO = 'AGER') tipo 
         from rcf_age_agencias age left join 
              &MASTER_SCHEMA..DD_TVI_TIPO_VIA tvi on TVI.DD_TVI_ID = AGE.DD_TVI_ID
         where not exists (select 1
                           from rcf_age_agencias rcf inner join 
                                des_despacho_externo des on DES.DES_DESPACHO = RCF.RCF_AGE_NOMBRE )
        );
       
insert into &MASTER_SCHEMA..usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, usu_telefono, usu_mail, usuariocrear, fechacrear, usu_externo, usu_fecha_vigencia_pass, usu_grupo)
 select &MASTER_SCHEMA..s_usu_usuarios.nextval, 1, username, '1234', agencia, telf, mail, 'SAG', sysdate, 1, sysdate + 360, 1
 from (select AGE.RCF_AGE_CODIGO username, AGE.RCF_AGE_NOMBRE agencia, AGE.RCF_AGE_CONTACTO_TELF telf, AGE.RCF_AGE_CONTACTO_MAIL mail
       from rcf_age_agencias age left join
            &MASTER_SCHEMA..usu_usuarios usu on USU.USU_USERNAME = AGE.RCF_AGE_CODIGO
       where not exists (select 1
                         from rcf_age_agencias rcf inner join 
                              &MASTER_SCHEMA..usu_usuarios usu on usu.usu_username = RCF.RCF_AGE_CODIGO
                         where RCF.RCF_AGE_ID = AGE.RCF_AGE_ID)
        );
        
insert into USD_USUARIOS_DESPACHOS usd (usd_id, usu_id, des_id, USD_GESTOR_DEFECTO, USD.USD_SUPERVISOR, usuariocrear, fechacrear)
 select S_USD_USUARIOS_DESPACHOS.nextval, usu_id, des_id, 1, 0, 'SAG', sysdate
 from (select usu.usu_id, des.des_id
       from rcf_age_agencias age left join
            &MASTER_SCHEMA..usu_usuarios usu on USU.USU_username = AGE.RCF_AGE_CODIGO left join 
            des_despacho_externo des on DES.DES_DESPACHO = age.RCF_AGE_NOMBRE
       where not exists (select 1
                         from USD_USUARIOS_DESPACHOS us inner join 
                              &MASTER_SCHEMA..usu_usuarios usu on USU.USU_ID = us.usu_id inner join 
                              rcf_age_agencias rcf on RCF.RCF_AGE_CODIGO = usu.usu_username inner join
                              des_despacho_externo des on DES.DES_DESPACHO = RCF.RCF_AGE_NOMBRE
                         where RCF.RCF_AGE_ID = age.rcf_age_id )
        );
 
-- insetar usuario y despacho de la agencia

update RCF_AGE_AGENCIAS set 
    usu_id = (select usu_id from &MASTER_SCHEMA..usu_usuarios where usu_username = 'AGE1'),
    des_id = (select des_id from des_despacho_externo where des_despacho = 'Agencia 1')
where RCF_AGE_CODIGO = 'AGE1';

update RCF_AGE_AGENCIAS set 
    usu_id = (select usu_id from &MASTER_SCHEMA..usu_usuarios where usu_username = 'AGE2'),
    des_id = (select des_id from des_despacho_externo where des_despacho = 'Agencia 2')
where RCF_AGE_CODIGO = 'AGE2';

update RCF_AGE_AGENCIAS set 
    usu_id = (select usu_id from &MASTER_SCHEMA..usu_usuarios where usu_username = 'AGE3'),
    des_id = (select des_id from des_despacho_externo where des_despacho = 'Agencia 3')
where RCF_AGE_CODIGO = 'AGE3';
        
commit;
        
-- insertar carteras
 Insert into RCF_CAR_CARTERA
   (RCF_CAR_ID, RCF_CAR_NOMBRE, RCF_CAR_DESCRIPCION, RD_ID, RCF_DD_ECM_ID, 
    RCF_CAR_FECHA_ALTA,USU_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_CAR_CARTERA.nextval, 'cartera 1', 'cartera 1', 1,  (select RCF_DD_ECM_ID from RCF_DD_ECM_ESTADO_COMPONENT where RCF_DD_ECM_CODIGO='DEF'), 
    sysdate, (SELECT MAX(USU_ID) FROM &MASTER_SCHEMA..USU_USUARIOS WHERE USU_USERNAME in ('SUPER','BANKMASTER')),1, 'diana', sysdate, 0);

   
Insert into RCF_CAR_CARTERA
   (RCF_CAR_ID, RCF_CAR_NOMBRE, RCF_CAR_DESCRIPCION, RD_ID, RCF_DD_ECM_ID, 
    RCF_CAR_FECHA_ALTA,USU_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_CAR_CARTERA.nextval, 'cartera 2', 'cartera 2', 1,  (select RCF_DD_ECM_ID from RCF_DD_ECM_ESTADO_COMPONENT where RCF_DD_ECM_CODIGO='DEF'), 
    sysdate,((SELECT MAX(USU_ID) FROM &MASTER_SCHEMA..USU_USUARIOS WHERE USU_USERNAME in ('SUPER','BANKMASTER'))), 1, 'diana', sysdate, 0);   

 Insert into RCF_CAR_CARTERA
   (RCF_CAR_ID, RCF_CAR_NOMBRE, RCF_CAR_DESCRIPCION, RD_ID, RCF_DD_ECM_ID, 
    RCF_CAR_FECHA_ALTA,USU_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_CAR_CARTERA.nextval, 'cartera 3', 'cartera 3', 1,  (select RCF_DD_ECM_ID from RCF_DD_ECM_ESTADO_COMPONENT where RCF_DD_ECM_CODIGO='DEF'), 
    sysdate, ((SELECT MAX(USU_ID) FROM &MASTER_SCHEMA..USU_USUARIOS WHERE USU_USERNAME in ('SUPER','BANKMASTER'))),1, 'diana', sysdate, 0);   
    
COMMIT;

-- insertar itinerarios de metas volantes

Insert into RCF_ITV_ITI_METAS_VOLANTES
   (RCF_ITV_ID, RCF_ITV_NOMBRE, RCF_ITV_FECHA_ALTA, RCF_ITV_PLAZO_MAX, RCF_ITV_NO_GEST, 
    RCF_DD_ECM_ID, USU_ID, 
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_ITV_ITI_METAS_VOLANTES.nextval, 'Modelo de metas volantes estandar', sysdate, 60, 5, 
    (select RCF_DD_ECM_ID from RCF_DD_ECM_ESTADO_COMPONENT where RCF_DD_ECM_CODIGO='DEF'),((SELECT MAX(USU_ID) FROM &MASTER_SCHEMA..USU_USUARIOS WHERE USU_USERNAME in ('SUPER','BANKMASTER'))),
    0, 'diana', sysdate, 0);

 Insert into RCF_ITV_ITI_METAS_VOLANTES
   (RCF_ITV_ID, RCF_ITV_NOMBRE, RCF_ITV_FECHA_ALTA, RCF_ITV_PLAZO_MAX, RCF_ITV_NO_GEST, 
    RCF_DD_ECM_ID, USU_ID,
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_ITV_ITI_METAS_VOLANTES.nextval, 'Modelo de metas volantes agresivo', sysdate, 60, 5, 
    (select RCF_DD_ECM_ID from RCF_DD_ECM_ESTADO_COMPONENT where RCF_DD_ECM_CODIGO='DEF'),((SELECT MAX(USU_ID) FROM &MASTER_SCHEMA..USU_USUARIOS WHERE USU_USERNAME in ('SUPER','BANKMASTER'))),
    0, 'diana', sysdate, 0);
    
COMMIT;

-- insertar politica de acuerdos

Insert into RCF_POA_POLITICA_ACUERDOS
   (RCF_POA_ID, RCF_POA_CODIGO, RCF_POA_NOMBRE,RCF_DD_ECM_ID,  USU_ID,
   VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_POA_POLITICA_ACUERDOS.nextval, '001', 'Política acuerdos 1', 
    (select RCF_DD_ECM_ID from RCF_DD_ECM_ESTADO_COMPONENT where RCF_DD_ECM_CODIGO='DEF'),((SELECT MAX(USU_ID) FROM &MASTER_SCHEMA..USU_USUARIOS WHERE USU_USERNAME in ('SUPER','BANKMASTER'))), 
    1, 'SAG', sysdate, 0);
    
Insert into RCF_POA_POLITICA_ACUERDOS
   (RCF_POA_ID, RCF_POA_CODIGO, RCF_POA_NOMBRE,RCF_DD_ECM_ID,USU_ID, 
   VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_POA_POLITICA_ACUERDOS.nextval, '002', 'Política acuerdos 2', 
    (select RCF_DD_ECM_ID from RCF_DD_ECM_ESTADO_COMPONENT where RCF_DD_ECM_CODIGO='DEF'),((SELECT MAX(USU_ID) FROM &MASTER_SCHEMA..USU_USUARIOS WHERE USU_USERNAME in ('SUPER','BANKMASTER'))),
    1, 'SAG', sysdate, 0);
    
COMMIT;

Insert into RCF_PAA_POL_ACUERDOS_PALANCAS
   (RCF_PAA_ID, RCF_POA_ID, RCF_STP_ID, RCF_PAA_PRIORIDAD, DD_SIN_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_PAA_POL_ACUER_PALANCAS.nextval, (select max(rcf_poa_id) FROM RCF_POA_POLITICA_ACUERDOS),
       (select max(RCF_STP_ID) FROM RCF_STP_SUBTIPO_PALANCA), 1, 
       (select max(DD_SIN_ID) FROM &MASTER_SCHEMA..DD_SIN_SINO),
    1, 'SAG', sysdate, 0);
 
 Insert into RCF_PAA_POL_ACUERDOS_PALANCAS
   (RCF_PAA_ID, RCF_POA_ID, RCF_STP_ID, RCF_PAA_PRIORIDAD, DD_SIN_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_PAA_POL_ACUER_PALANCAS.nextval, (select max(rcf_poa_id) FROM RCF_POA_POLITICA_ACUERDOS),
       (select min(RCF_STP_ID) FROM RCF_STP_SUBTIPO_PALANCA), 1, 
       (select max(DD_SIN_ID) FROM &MASTER_SCHEMA..DD_SIN_SINO),
    1, 'SAG', sysdate, 0);
    
COMMIT;

-- insertar modelos de ranking

Insert into RCF_MOR_MODELO_RANKING
   (RCF_MOR_ID, RCF_MOR_NOMBRE,
   RCF_DD_ECM_ID, USU_ID, 
   VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_MOR_MODELO_RANKING.nextval, 'Modelo de Ranking 1',
   (select RCF_DD_ECM_ID from RCF_DD_ECM_ESTADO_COMPONENT where RCF_DD_ECM_CODIGO='DEF'),((SELECT MAX(USU_ID) FROM &MASTER_SCHEMA..USU_USUARIOS WHERE USU_USERNAME in ('SUPER','BANKMASTER'))),
   1, 'SAG', sysdate, 0);

 Insert into RCF_MOR_MODELO_RANKING
   (RCF_MOR_ID, RCF_MOR_NOMBRE,
    RCF_DD_ECM_ID, USU_ID,
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_MOR_MODELO_RANKING.nextval, 'Modelo de Ranking 2', 
   (select RCF_DD_ECM_ID from RCF_DD_ECM_ESTADO_COMPONENT where RCF_DD_ECM_CODIGO='DEF'),((SELECT MAX(USU_ID) FROM &MASTER_SCHEMA..USU_USUARIOS WHERE USU_USERNAME in ('SUPER','BANKMASTER'))),
   1, 'SAG', sysdate, 0);
   
 Insert into RCF_MRV_MODELO_RANKING_VARS
   (RCF_MRV_ID, RCF_MOR_ID, RCF_DD_VAR_ID, RCF_MRV_COEFICIENTE,
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_MRV_MODELO_RANKING_VARS.nextval, 
    (select max(RCF_MOR_ID) from RCF_MOR_MODELO_RANKING),
    (select max(RCF_DD_VAR_ID) from RCF_DD_VAR_VARIABLES_RANKING),
    25.3, 1, 'SAG', sysdate, 0);

Insert into RCF_MRV_MODELO_RANKING_VARS
   (RCF_MRV_ID, RCF_MOR_ID, RCF_DD_VAR_ID, RCF_MRV_COEFICIENTE,
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values
   (S_RCF_MRV_MODELO_RANKING_VARS.nextval, 
    (select max(RCF_MOR_ID) from RCF_MOR_MODELO_RANKING),
    (select min(RCF_DD_VAR_ID) from RCF_DD_VAR_VARIABLES_RANKING),
    50, 1, 'SAG', sysdate, 0);
    
COMMIT;

-- insertar modelos de facturacion

Insert into RCF_MFA_MODELOS_FACTURACION
   (RCF_MFA_ID, RCF_MFA_NOMBRE, RCF_MFA_DESCRIPCION, RCF_DD_TCO_ID, RCF_MFA_OBJETIVO_RECOBRO,
    RCF_DD_ECM_ID,USU_ID, 
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_MFA_MODELOS_FACTURACION.nextval, 'Modelos facturación 1', 'Modelos facturación 1',
    (select RCF_DD_TCO_ID from RCF_DD_TCO_TIPO_CORRECTOR where RCF_DD_TCO_CODIGO = 'MEO'), 
    20, (select RCF_DD_ECM_ID from RCF_DD_ECM_ESTADO_COMPONENT where RCF_DD_ECM_CODIGO='DEF'), ((SELECT MAX(USU_ID) FROM &MASTER_SCHEMA..USU_USUARIOS WHERE USU_USERNAME in ('SUPER','BANKMASTER'))),
    1, 'SAG', sysdate, 0);

   Insert into RCF_MFA_MODELOS_FACTURACION
   (RCF_MFA_ID, RCF_MFA_NOMBRE,
    RCF_DD_ECM_ID,USU_ID ,
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_MFA_MODELOS_FACTURACION.nextval, 'Modelos facturación 2',(select RCF_DD_ECM_ID from RCF_DD_ECM_ESTADO_COMPONENT where RCF_DD_ECM_CODIGO='DEF'), ((SELECT MAX(USU_ID) FROM &MASTER_SCHEMA..USU_USUARIOS WHERE USU_USERNAME in ('SUPER','BANKMASTER'))),
   1, 'SAG', sysdate, 0);
   
COMMIT;

-- insertar cobros facturables al modelo de facturacion

insert into DD_SCP_SUBTIPO_COBRO_PAGO (dd_scp_id, dd_scp_codigo, dd_scp_descripcion, dd_scp_descripcion_larga, dd_tcp_id, usuariocrear, fechacrear)
values (s_dd_scp_subtipo_cobro_pago.nextval, 'SCBR1', 'Subtipo cobro 1', 'Subtipo cobro 1', (select max(dd_tcp_id) from  DD_TCP_TIPO_COBRO_PAGO), 'SAG', sysdate);

commit;

insert into RCF_TCF_TIPO_COBRO_FACTURA 
select S_RCF_TCF_TIPO_COBRO_FACTURA.nextval, 
       (select RCF_MFA_ID from RCF_MFA_MODELOS_FACTURACION where RCF_MFA_DESCRIPCION = 'Modelos facturación 1'),
        dd_scp_id, 
        0, 'SAG', sysdate, null, null, null, null, 0
from (select scp.DD_SCP_ID from DD_SCP_SUBTIPO_COBRO_PAGO scp /*where tcb.RCF_DD_TCB_FACTURABLE = 1*/);

commit;

-- insertar conceptos de cobro a los cobros facturables del modelo
-- al no haber cobros se comenta esta parte

insert into RCF_TCC_TARIFAS_CONCEP_COBRO 
select S_RCF_TCC_TARIFAS_CONCEP_COB.nextval, 
       (select min(RCF_TCF_ID) from RCF_TCF_TIPO_COBRO_FACTURA),
        RCF_DD_COC_ID, 100, 5000,10,
        0, 'SAG', sysdate, null, null, null, null, 0
from (select RCF_DD_COC_ID from RCF_DD_COC_CONCEPTO_COBRO);

insert into RCF_TCC_TARIFAS_CONCEP_COBRO 
select S_RCF_TCC_TARIFAS_CONCEP_COB.nextval, 
       (select max(RCF_TCF_ID) from RCF_TCF_TIPO_COBRO_FACTURA),
        RCF_DD_COC_ID, 100, 5000,0,
        0, 'SAG', sysdate, null, null, null, null, 0
from (select RCF_DD_COC_ID from RCF_DD_COC_CONCEPTO_COBRO);

commit;

-- insertar tramos al modelo de facturacion

insert into RCF_TRF_TRAMO_FACTURACION
   (RCF_TRF_ID, RCF_MFA_ID, RCF_TRF_DIAS,
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values
   (S_RCF_TRF_TRAMO_FACTURACION.nextval, 
    (select RCF_MFA_ID from RCF_MFA_MODELOS_FACTURACION where RCF_MFA_DESCRIPCION = 'Modelos facturación 1'),
    30, 1, 'SAG', sysdate, 0);
   
insert into RCF_TRF_TRAMO_FACTURACION
   (RCF_TRF_ID, RCF_MFA_ID, RCF_TRF_DIAS,
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values
   (S_RCF_TRF_TRAMO_FACTURACION.nextval, 
    (select RCF_MFA_ID from RCF_MFA_MODELOS_FACTURACION where RCF_MFA_DESCRIPCION = 'Modelos facturación 1'),
    60, 1, 'SAG', sysdate, 0);

commit;

-- insertar tramos a los conceptos de cobro asociados al modelo

insert into RCF_TCT_TARIF_COBRO_TRAMO
select S_RCF_TCT_TARIF_COBRO_TRAMO.nextval, 
       (select max(RCF_TRF_ID) from RCF_TRF_TRAMO_FACTURACION where RCF_TRF_DIAS = 30),
        RCF_TCC_ID, 30,
        1, 'SAG', sysdate, null, null, null, null, 0
from (select tcc.RCF_TCC_ID 
      from RCF_MFA_MODELOS_FACTURACION mfa inner join
           RCF_TCF_TIPO_COBRO_FACTURA tcf on tcf.RCF_MFA_ID = mfa.RCF_MFA_ID inner join   
           RCF_TCC_TARIFAS_CONCEP_COBRO tcc on tcc.RCF_TCF_ID = tcf.RCF_TCF_ID);

insert into RCF_TCT_TARIF_COBRO_TRAMO
select S_RCF_TCT_TARIF_COBRO_TRAMO.nextval, 
       (select max(RCF_TRF_ID) from RCF_TRF_TRAMO_FACTURACION where RCF_TRF_DIAS = 60),
        RCF_TCC_ID, 30,
        1, 'SAG', sysdate, null, null, null, null, 0
from (select tcc.RCF_TCC_ID 
      from RCF_MFA_MODELOS_FACTURACION mfa inner join
           RCF_TCF_TIPO_COBRO_FACTURA tcf on tcf.RCF_MFA_ID = mfa.RCF_MFA_ID inner join   
           RCF_TCC_TARIFAS_CONCEP_COBRO tcc on tcc.RCF_TCF_ID = tcf.RCF_TCF_ID);

commit;
             
-- insertar esquema

Insert into RCF_ESQ_ESQUEMA
   (RCF_ESQ_ID, RCF_ESQ_NOMBRE, RCF_ESQ_DESCRIPCION, RCF_DD_EES_ID, RCF_ESQ_FECHA_ALTA, 
    RCF_ESQ_PLAZO, RCF_DD_MTR_ID, USU_ID, RCF_ID_GRUPO_VERSION, RCF_VERSION, RCF_MAJOR_RELEASE, 
    RCF_MINOR_RELEASE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_ESQ_ESQUEMA.NEXTVAL , 'Esquema prueba 1', 'Esquema para pruebas número 1', 
       (select max(RCF_DD_EES_ID) from RCF_DD_EES_ESTADO_ESQUEMA), sysdate, 70,
       (select max(RCF_DD_MTR_ID) from RCF_DD_MTR_MODELO_TRANSICION),
    (SELECT MAX(USU_ID) FROM &MASTER_SCHEMA..USU_USUARIOS WHERE USU_USERNAME in ('SUPER','BANKMASTER')),    
    S_RCF_ESQ_ESQUEMA.CURRVAL, 1, 0, 0, 1, 'SAG', sysdate , 0);

commit;

-- relacion esquema cartera
Insert into RCF_ESC_ESQUEMA_CARTERAS
   (RCF_ESC_ID, RCF_ESQ_ID, RCF_CAR_ID, DD_TCE_ID, RCF_ESC_PRIORIDAD, DD_TGC_ID, DD_AER_ID,
    USUARIOCREAR, FECHACREAR, BORRADO)
Values
   (s_RCF_ESC_ESQUEMA_CARTERAS.nextval, (select min(rcf_esq_id) from rcf_esq_esquema), (select min(rcf_car_id) from RCF_CAR_CARTERA),
   (select min(DD_TCE_ID) from RCF_DD_TCE_TIPO_CARTERA_ESQ), 1,  
   (select dd_tgc_id from RCF_DD_TGC_TIPO_GESTION_CART where dd_tgc_codigo = 'GI'),
   (select dd_aer_id from RCF_DD_AER_AMBITO_EXP_REC where dd_aer_codigo = 'CPGRA'),
    'diana', sysdate, 0);

Insert into RCF_ESC_ESQUEMA_CARTERAS
   (RCF_ESC_ID, RCF_ESQ_ID, RCF_CAR_ID, DD_TCE_ID, RCF_ESC_PRIORIDAD, DD_TGC_ID, DD_AER_ID,
    USUARIOCREAR, FECHACREAR, BORRADO)
Values
   (s_RCF_ESC_ESQUEMA_CARTERAS.nextval, (select min(rcf_esq_id) from rcf_esq_esquema), (select max(rcf_car_id) from RCF_CAR_CARTERA),
   (select min(DD_TCE_ID) from RCF_DD_TCE_TIPO_CARTERA_ESQ), 2,  
   (select dd_tgc_id from RCF_DD_TGC_TIPO_GESTION_CART where dd_tgc_codigo = 'GI'),
   (select dd_aer_id from RCF_DD_AER_AMBITO_EXP_REC where dd_aer_codigo = 'CPGRA'),
    'diana', sysdate, 0);
        
COMMIT;

-- insertar subcartera



Insert into RCF_SCA_SUBCARTERA
   (RCF_SCA_ID, RCF_ESC_ID, RCF_SCA_NOMBRE, RCF_SCA_PARTICION, RCF_DD_TPR_ID, 
    RCF_ITV_ID, RCF_MFA_ID, RCF_POA_ID, RCF_MOR_ID,
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_SCA_SUBCARTERA.nextval, (SELECT MAX(RCF_ESC_ID) FROM RCF_ESC_ESQUEMA_CARTERAS), 'Reparto', 100, 
   (SELECT MAX(RCF_DD_TPR_ID) FROM RCF_DD_TPR_TIPO_REPARTO_SUBC),
   (SELECT MAX(RCF_ITV_ID) FROM RCF_ITV_ITI_METAS_VOLANTES),
   (SELECT MAX(RCF_MFA_ID) FROM RCF_MFA_MODELOS_FACTURACION),
   (SELECT MAX(RCF_POA_ID) FROM RCF_POA_POLITICA_ACUERDOS),
   (SELECT MAX(RCF_MOR_ID) FROM RCF_MOR_MODELO_RANKING), 
    1, 'diana', sysdate, 0);

COMMIT;

Insert into RCF_SCA_SUBCARTERA
   (RCF_SCA_ID, RCF_ESC_ID, RCF_SCA_NOMBRE, RCF_SCA_PARTICION, RCF_DD_TPR_ID, 
    RCF_ITV_ID, RCF_MFA_ID, RCF_POA_ID, RCF_MOR_ID,
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_SCA_SUBCARTERA.nextval, (SELECT MIN(RCF_ESC_ID) FROM RCF_ESC_ESQUEMA_CARTERAS), 'Reparto', 100, 
   (SELECT MAX(RCF_DD_TPR_ID) FROM RCF_DD_TPR_TIPO_REPARTO_SUBC),
   (SELECT MAX(RCF_ITV_ID) FROM RCF_ITV_ITI_METAS_VOLANTES),
   (SELECT MAX(RCF_MFA_ID) FROM RCF_MFA_MODELOS_FACTURACION),
   (SELECT MAX(RCF_POA_ID) FROM RCF_POA_POLITICA_ACUERDOS),
   (SELECT MAX(RCF_MOR_ID) FROM RCF_MOR_MODELO_RANKING), 
    1, 'diana', sysdate, 0);
        
COMMIT;

-- insertar agencias subcartera

Insert into RCF_SUA_SUBCARTERA_AGENCIAS
   (RCF_SUA_ID, RCF_AGE_ID, RCF_SCA_ID, RCF_SUA_COEFICIENTE, 
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_SUA_SUBCARTERA_AGENCIAS.nextval, 
   (select max(RCF_AGE_ID) from RCF_AGE_AGENCIAS WHERE BORRADO = 0), 
   (select max(RCF_SCA_ID) from RCF_SCA_SUBCARTERA), 
   50, 1, 'SAG', sysdate, 0);
   
Insert into RCF_SUA_SUBCARTERA_AGENCIAS
   (RCF_SUA_ID, RCF_AGE_ID, RCF_SCA_ID, RCF_SUA_COEFICIENTE, 
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_SUA_SUBCARTERA_AGENCIAS.nextval, 
   (select min(RCF_AGE_ID) from RCF_AGE_AGENCIAS WHERE BORRADO = 0), 
   (select max(RCF_SCA_ID) from RCF_SCA_SUBCARTERA), 
   50, 1, 'SAG', sysdate, 0);
    
COMMIT;

Insert into RCF_SUA_SUBCARTERA_AGENCIAS
   (RCF_SUA_ID, RCF_AGE_ID, RCF_SCA_ID, RCF_SUA_COEFICIENTE, 
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_SUA_SUBCARTERA_AGENCIAS.nextval, 
   (select max(RCF_AGE_ID) from RCF_AGE_AGENCIAS WHERE BORRADO = 0), 
   (select MIN(RCF_SCA_ID) from RCF_SCA_SUBCARTERA), 
   50, 1, 'SAG', sysdate, 0);
   
Insert into RCF_SUA_SUBCARTERA_AGENCIAS
   (RCF_SUA_ID, RCF_AGE_ID, RCF_SCA_ID, RCF_SUA_COEFICIENTE, 
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_SUA_SUBCARTERA_AGENCIAS.nextval, 
   (select min(RCF_AGE_ID) from RCF_AGE_AGENCIAS WHERE BORRADO = 0), 
   (select MIN(RCF_SCA_ID) from RCF_SCA_SUBCARTERA), 
   50, 1, 'SAG', sysdate, 0);
    
COMMIT;

-- INSERTAR DATOS EN LAS TABLAS DE PROCESOS DE FACTURACIÓN PARA PRUEBAS
-- procesos de facturacion

INSERT INTO PRF_PROCESO_FACTURACION(PRF_ID, PRF_NOMBRE, PRF_FECHA_DESDE ,PRF_FECHA_HASTA, RCF_DD_EPF_ID, REA_ID, 
    VERSION, USUARIOCREAR,FECHACREAR, BORRADO, USU_ID_CREAR, PRF_FECHA_CREAR)    
VALUES (S_PRF_PROCESO_FACTURACION.nextval, 'Proceso 1', to_date('01/01/2014'), to_date('01/02/2014'),
(select rcf_dd_epf_id from  RCF_DD_EPF_ESTADO_PROC_FAC where rcf_dd_epf_codigo='PTE'),
    null, 0, 'DIA', sysdate, 0,(select USU_ID from &MASTER_SCHEMA..usu_usuarios where USU_username in ('SUPER','BANKMASTER')),to_date('01/01/2014'));
    
INSERT INTO PRF_PROCESO_FACTURACION(PRF_ID, PRF_NOMBRE, PRF_FECHA_DESDE ,PRF_FECHA_HASTA, RCF_DD_EPF_ID, REA_ID, 
    VERSION, USUARIOCREAR,FECHACREAR, BORRADO, USU_ID_CREAR, PRF_FECHA_CREAR )    
VALUES (S_PRF_PROCESO_FACTURACION.nextval, 'Proceso 2', to_date('01/02/2014'), to_date('01/03/2014'),
(select rcf_dd_epf_id from  RCF_DD_EPF_ESTADO_PROC_FAC where rcf_dd_epf_codigo='PRC'),
    null, 0, 'DIA', sysdate, 0,(select USU_ID from &MASTER_SCHEMA..usu_usuarios where USU_username in ('SUPER','BANKMASTER')),to_date('03/01/2014'));
    
INSERT INTO PRF_PROCESO_FACTURACION(PRF_ID, PRF_NOMBRE, PRF_FECHA_DESDE ,PRF_FECHA_HASTA, RCF_DD_EPF_ID, REA_ID, 
    VERSION, USUARIOCREAR,FECHACREAR, BORRADO, USU_ID_CREAR, PRF_FECHA_CREAR, USU_ID_LIBERAR, PRF_FECHA_LIBERAR)    
VALUES (S_PRF_PROCESO_FACTURACION.nextval, 'Proceso 3', to_date('01/03/2014'), to_date('01/04/2014'),
(select rcf_dd_epf_id from  RCF_DD_EPF_ESTADO_PROC_FAC where rcf_dd_epf_codigo='LBR'),
    null, 0, 'DIA', sysdate, 0,(select USU_ID from &MASTER_SCHEMA..usu_usuarios where USU_username in ('SUPER','BANKMASTER')),to_date('05/01/2014')
    ,(select USU_ID from &MASTER_SCHEMA..usu_usuarios where USU_username = 'SUPER'),to_date('08/01/2014'));    
    
INSERT INTO PRF_PROCESO_FACTURACION(PRF_ID, PRF_NOMBRE, PRF_FECHA_DESDE ,PRF_FECHA_HASTA, RCF_DD_EPF_ID, REA_ID, 
    VERSION, USUARIOCREAR,FECHACREAR, BORRADO, USU_ID_CREAR, PRF_FECHA_CREAR, 
    USU_ID_LIBERAR, PRF_FECHA_LIBERAR, USU_ID_CANCELAR, PRF_FECHA_CANCELAR)    
VALUES (S_PRF_PROCESO_FACTURACION.nextval, 'Proceso 4', to_date('15/01/2014'), to_date('15/03/2014'),
(select rcf_dd_epf_id from  RCF_DD_EPF_ESTADO_PROC_FAC where rcf_dd_epf_codigo='CNL'),
    null, 0, 'DIA', sysdate, 0,(select USU_ID from &MASTER_SCHEMA..usu_usuarios where USU_username in ('SUPER','BANKMASTER')),to_date('07/01/2014')
    ,(select USU_ID from &MASTER_SCHEMA..usu_usuarios where USU_username in ('SUPER','BANKMASTER')),to_date('07/01/2014')
    ,(select USU_ID from &MASTER_SCHEMA..usu_usuarios where USU_username in ('SUPER','BANKMASTER')),to_date('12/01/2014'));    
    
-- procesos de facturacion- subcarteras

INSERT INTO PFS_PROC_FAC_SUBCARTERA (PFS_ID, PRF_ID, 
    RCF_SCA_ID, RCF_MFA_ID_ORIGINAL, 
    RCF_MFA_ID_ACTUAL, RCF_TOTAL_COBROS, 
    RCF_TOTAL_FACTURABLE, VERSION, USUARIOCREAR,FECHACREAR, BORRADO )
VALUES (S_PFS_PROC_FAC_SUBCARTERA.nextVal,(select prf_id from PRF_PROCESO_FACTURACION where prf_nombre='Proceso 1'),
    (select min(rcf_sca_id) from RCF_SCA_SUBCARTERA),  (select rcf_mfa_id from RCF_MFA_MODELOS_FACTURACION where rcf_mfa_nombre='Modelos facturación 1'),
    null, 25000,
    20000, 0, 'DIANA', SYSDATE, 0);    
    
INSERT INTO PFS_PROC_FAC_SUBCARTERA (PFS_ID, PRF_ID, 
    RCF_SCA_ID, RCF_MFA_ID_ORIGINAL, 
    RCF_MFA_ID_ACTUAL, RCF_TOTAL_COBROS, 
    RCF_TOTAL_FACTURABLE, VERSION, USUARIOCREAR,FECHACREAR, BORRADO )
VALUES (S_PFS_PROC_FAC_SUBCARTERA.nextVal,(select prf_id from PRF_PROCESO_FACTURACION where prf_nombre='Proceso 1'),
    (select max(rcf_sca_id) from RCF_SCA_SUBCARTERA),(select rcf_mfa_id from RCF_MFA_MODELOS_FACTURACION where rcf_mfa_nombre='Modelos facturación 1'), 
    null, 12000,
    10000, 0, 'DIANA', SYSDATE, 0);    
    
INSERT INTO PFS_PROC_FAC_SUBCARTERA (PFS_ID, PRF_ID, 
    RCF_SCA_ID, RCF_MFA_ID_ORIGINAL, 
    RCF_MFA_ID_ACTUAL, RCF_TOTAL_COBROS, 
    RCF_TOTAL_FACTURABLE, VERSION, USUARIOCREAR,FECHACREAR, BORRADO )
VALUES (S_PFS_PROC_FAC_SUBCARTERA.nextVal,(select prf_id from PRF_PROCESO_FACTURACION where prf_nombre='Proceso 2'),
     (select min(rcf_sca_id) from RCF_SCA_SUBCARTERA), (select rcf_mfa_id from RCF_MFA_MODELOS_FACTURACION where rcf_mfa_nombre='Modelos facturación 2'), 
    (select rcf_mfa_id from RCF_MFA_MODELOS_FACTURACION where rcf_mfa_nombre='Modelos facturación 1'), 6000,
    4000, 0, 'DIANA', SYSDATE, 0);
    
INSERT INTO PFS_PROC_FAC_SUBCARTERA (PFS_ID, PRF_ID, 
    RCF_SCA_ID, RCF_MFA_ID_ORIGINAL, 
    RCF_MFA_ID_ACTUAL, RCF_TOTAL_COBROS, 
    RCF_TOTAL_FACTURABLE, VERSION, USUARIOCREAR,FECHACREAR, BORRADO )
VALUES (S_PFS_PROC_FAC_SUBCARTERA.nextVal,(select prf_id from PRF_PROCESO_FACTURACION where prf_nombre='Proceso 2'),
     (select max(rcf_sca_id) from RCF_SCA_SUBCARTERA),  (select rcf_mfa_id from RCF_MFA_MODELOS_FACTURACION where rcf_mfa_nombre='Modelos facturación 2'),
    (select rcf_mfa_id from RCF_MFA_MODELOS_FACTURACION where rcf_mfa_nombre='Modelos facturación 1'), 5000,
    3500, 0, 'DIANA', SYSDATE, 0);
    
-- detalles de facturacion

/*
INSERT INTO RDF_RECOBRO_DETALLE_FACTURA(RDF_ID, PFS_ID,CPA_ID, 
CNT_ID, EXP_ID, 
RDF_FECHA_COBRO, RDF_PORCENTAJE,RDF_IMPORTE_A_PAGAR,VERSION, USUARIOCREAR,FECHACREAR, BORRADO )    
VALUES (S_RDF_RECOBRO_DETALLE_FACTURA.nextVal, (select max(pfs_id) from PFS_PROC_FAC_SUBCARTERA), (select max(cpa_id) from cpa_cobros_pagos),
(select max(cnt_id) from cnt_contratos),( select max(exp_id) from exp_expedientes) ,
to_date('15/01/2014'), 15, 200, 0, 'DIANA', SYSDATE, 0);   

INSERT INTO RDF_RECOBRO_DETALLE_FACTURA(RDF_ID, PFS_ID,CPA_ID, 
CNT_ID, EXP_ID, 
RDF_FECHA_COBRO, RDF_PORCENTAJE,RDF_IMPORTE_A_PAGAR,VERSION, USUARIOCREAR,FECHACREAR, BORRADO )    
VALUES (S_RDF_RECOBRO_DETALLE_FACTURA.nextVal, (select max(pfs_id) from PFS_PROC_FAC_SUBCARTERA), (select MIN(cpa_id) from cpa_cobros_pagos),
(select MIN(cnt_id) from cnt_contratos),( select MIN(exp_id) from exp_expedientes) ,
to_date('15/01/2014'), 18, 1000, 0, 'DIANA', SYSDATE, 0);   

INSERT INTO RDF_RECOBRO_DETALLE_FACTURA(RDF_ID, PFS_ID,CPA_ID, 
CNT_ID, EXP_ID, 
RDF_FECHA_COBRO, RDF_PORCENTAJE,RDF_IMPORTE_A_PAGAR,VERSION, USUARIOCREAR,FECHACREAR, BORRADO )    
VALUES (S_RDF_RECOBRO_DETALLE_FACTURA.nextVal, (select min(pfs_id) from PFS_PROC_FAC_SUBCARTERA), (select MIN(cpa_id) from cpa_cobros_pagos where rownum<100),
(select MIN(cnt_id) from cnt_contratos where rownum<100),( select MIN(exp_id) from exp_expedientes where rownum<100) ,
to_date('15/01/2014'), 18, 1000, 0, 'DIANA', SYSDATE, 0); 

INSERT INTO RDF_RECOBRO_DETALLE_FACTURA(RDF_ID, PFS_ID,CPA_ID, 
CNT_ID, EXP_ID, 
RDF_FECHA_COBRO, RDF_PORCENTAJE,RDF_IMPORTE_A_PAGAR,VERSION, USUARIOCREAR,FECHACREAR, BORRADO )    
VALUES (S_RDF_RECOBRO_DETALLE_FACTURA.nextVal, (select min(pfs_id) from PFS_PROC_FAC_SUBCARTERA), (select max(cpa_id) from cpa_cobros_pagos where rownum<100),
(select max(cnt_id) from cnt_contratos where rownum<100),( select max(exp_id) from exp_expedientes where rownum<100) ,
to_date('15/01/2014'), 18, 7840, 0, 'DIANA', SYSDATE, 0);
*/
-- Resultado de la simulacion

INSERT INTO RCF_ESS_ESQUEMA_SIMULACION
    (RCF_ESS_ID, RCF_ESQ_ID, RCF_DD_ESI_ID, RCF_ESS_FECHA_PETICION, RCF_ESS_FECHA_RESULTADO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
VALUES (S_RCF_ESS_ESQUEMA_SIMULACION.nextval, (select min(rcf_esq_id) from rcf_esq_esquema), (select min(rcf_dd_esi_id) from RCF_DD_ESI_ESTADO_SIMULACION), TO_TIMESTAMP('2014-04-08 12:56:05.277000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 
    TO_TIMESTAMP('2014-04-09 05:56:20.717000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '0', 'CPEREZ', sysdate, '0');

commit;
