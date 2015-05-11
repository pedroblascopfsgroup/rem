truncate table load_ciclos_nuse_stage_1;

insert into LOAD_CICLOS_NUSE_STAGE_1 (CODIGO_PROPIETARIO, TIPO_PRODUCTO, NUMERO_CONTRATO, NUMERO_ESPEC, CODIGO_AGENCIA, DESCRIPCION_TIPO_GESTION, FECHA_BAJA_AGENCIA, ID_EXPEDIENTE)
select substr(cnt.cnt_contrato, 1,5) codigo_propietario
  , substr(cnt.cnt_contrato, 6,5) tipo_producto
  , substr(cnt.cnt_contrato, 11,17) numero_contrato
  , substr(cnt.cnt_contrato, 28,15) num_espec
  , (select rcf_age_codigo from rcf_age_agencias where rcf_age_id = (mod(cnt.cnt_id, 5) + (select min(rcf_age_id) from rcf_age_agencias)))
  , 'Telecobro Pequeño Deudor' tipo_gestion
  , '00000000' fecha_baja_agencia
  , S_EXP_EXPEDIENTES.NEXTVAL 
from cnt_contratos cnt;



COMMIT;