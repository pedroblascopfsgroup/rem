
--select max(vbl_id) from vbl_variables

exec setSequence ('S_PRF_PARRAFOS', 80);


exec setSequence ('s_vbl_variables', 80);


Insert into PRF_PARRAFOS
   (PRF_PARRAFO_ID, PRF_PARRAFO_CODIGO, PRF_PARRAFO_CONTENIDO)
 Values
   (S_PRF_PARRAFOS.nextVal, 'direccionJuzgado', '<juzgado> de <plaza><br/><domicilioJuzgado><br/><codigoPostalJuzgado> <poblacionJuzgado><br/><provinciaJuzgado>');

commit;   
   
Insert into vbl_variables(vbl_id, vbl_codigo)
values(s_vbl_variables.nextval, 'domicilioJuzgado');

Insert into vbl_variables(vbl_id, vbl_codigo)
values(s_vbl_variables.nextval, 'codigoPostalJuzgado');

Insert into vbl_variables(vbl_id, vbl_codigo)
values(s_vbl_variables.nextval, 'poblacionJuzgado');

Insert into vbl_variables(vbl_id, vbl_codigo)
values(s_vbl_variables.nextval, 'provinciaJuzgado');

COMMIT;

insert into pvb_parrafos_variables (prf_parrafo_id, vbl_id)
values((select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado')
    , (select vbl_id from vbl_variables where vbl_codigo='plaza'));
    
insert into pvb_parrafos_variables (prf_parrafo_id, vbl_id)
values((select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado')
    , (select vbl_id from vbl_variables where vbl_codigo='juzgado'));    

insert into pvb_parrafos_variables (prf_parrafo_id, vbl_id)
values((select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado')
    , (select vbl_id from vbl_variables where vbl_codigo='domicilioJuzgado'));
    
insert into pvb_parrafos_variables (prf_parrafo_id, vbl_id)
values((select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado')
    , (select vbl_id from vbl_variables where vbl_codigo='codigoPostalJuzgado'));
    
insert into pvb_parrafos_variables (prf_parrafo_id, vbl_id)
values((select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado')
    , (select vbl_id from vbl_variables where vbl_codigo='poblacionJuzgado'));
    
insert into pvb_parrafos_variables (prf_parrafo_id, vbl_id)
values((select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado')
    , (select vbl_id from vbl_variables where vbl_codigo='provinciaJuzgado'));    
    
    
commit;

insert into ipa_informe_parrafos (dd_informe_id, prf_parrafo_id)
values((select dd_informe_id from dd_informes where dd_informe_codigo='DESGLOSE_CPROC'), (select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado'));


insert into ipa_informe_parrafos (dd_informe_id, prf_parrafo_id)
values((select dd_informe_id from dd_informes where dd_informe_codigo='DESGLOSE_SPROC'), (select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado'));


insert into ipa_informe_parrafos (dd_informe_id, prf_parrafo_id)
values((select dd_informe_id from dd_informes where dd_informe_codigo='ENVIO_MDTO_EXHORTO_CPROC'), (select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado'));


insert into ipa_informe_parrafos (dd_informe_id, prf_parrafo_id)
values((select dd_informe_id from dd_informes where dd_informe_codigo='ENVIO_MDTO_EXHORTO_SPROC'), (select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado'));


insert into ipa_informe_parrafos (dd_informe_id, prf_parrafo_id)
values((select dd_informe_id from dd_informes where dd_informe_codigo='ESCRITO_NOCTURNAS_CPROC'), (select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado'));


insert into ipa_informe_parrafos (dd_informe_id, prf_parrafo_id)
values((select dd_informe_id from dd_informes where dd_informe_codigo='ESCRITO_NOCTURNAS_SPROC'), (select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado'));

insert into ipa_informe_parrafos (dd_informe_id, prf_parrafo_id)
values((select dd_informe_id from dd_informes where dd_informe_codigo='INGRESO_CUANTIA_CPROC'), (select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado'));


insert into ipa_informe_parrafos (dd_informe_id, prf_parrafo_id)
values((select dd_informe_id from dd_informes where dd_informe_codigo='INGRESO_CUANTIA_SPROC'), (select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado'));

insert into ipa_informe_parrafos (dd_informe_id, prf_parrafo_id)
values((select dd_informe_id from dd_informes where dd_informe_codigo='LIBRAR_OFC_LOCAL_CPROC'), (select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado'));


insert into ipa_informe_parrafos (dd_informe_id, prf_parrafo_id)
values((select dd_informe_id from dd_informes where dd_informe_codigo='LIBRAR_OFC_LOCAL_SPROC'), (select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado'));

insert into ipa_informe_parrafos (dd_informe_id, prf_parrafo_id)
values((select dd_informe_id from dd_informes where dd_informe_codigo='REQ_DOMICILIO_LABORAL_SPROC'), (select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado'));


insert into ipa_informe_parrafos (dd_informe_id, prf_parrafo_id)
values((select dd_informe_id from dd_informes where dd_informe_codigo='REQ_DOMICILIO_LABORAL_CPROC'), (select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado'));

insert into ipa_informe_parrafos (dd_informe_id, prf_parrafo_id)
values((select dd_informe_id from dd_informes where dd_informe_codigo='REQ_OTROS_DOMICILIO_CPROC'), (select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado'));


insert into ipa_informe_parrafos (dd_informe_id, prf_parrafo_id)
values((select dd_informe_id from dd_informes where dd_informe_codigo='REQ_OTROS_DOMICILIO_SPROC'), (select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado'));

insert into ipa_informe_parrafos (dd_informe_id, prf_parrafo_id)
values((select dd_informe_id from dd_informes where dd_informe_codigo='SOL_DEC_FIN_MONIT_CPROC'), (select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado'));


insert into ipa_informe_parrafos (dd_informe_id, prf_parrafo_id)
values((select dd_informe_id from dd_informes where dd_informe_codigo='SOL_DEC_FIN_MONIT_SPROC'), (select prf_parrafo_id from PRF_PARRAFOS where prf_parrafo_codigo='direccionJuzgado'));


commit;
