TRUNCATE TABLE CNT_CONTRATOS_FORMULAS;

INSERT INTO TMP_CNT_FORM_FONDO
select iac.cnt_id, tfo.dd_tfo_ces_rem titulizado, tfo.dd_tfo_descripcion fondo from ext_iac_info_add_contrato iac inner join dd_tfo_tipo_fondo tfo on iac.iac_value = tfo.dd_tfo_codigo 
and iac.dd_ifc_id = (SELECT ifc.dd_ifc_id FROM ext_dd_ifc_info_contrato ifc WHERE ifc.dd_ifc_codigo = 'char_extra7');
	
INSERT INTO TMP_CNT_FORM_NUMEXTRA1 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where iac.dd_ifc_id = 
(select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'num_extra1');

INSERT INTO TMP_CNT_FORM_NUMEXTRA2 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where iac.dd_ifc_id = 
(select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'num_extra2');

INSERT INTO TMP_CNT_FORM_NUMEXTRA3 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where iac.dd_ifc_id = 
(select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'num_extra3');

INSERT INTO TMP_CNT_FORM_DATEEXTRA1 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where iac.dd_ifc_id = 
(select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'date_extra1');

INSERT INTO TMP_CNT_FORM_CHAREXTRA1 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where iac.dd_ifc_id = 
(select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'char_extra1');

INSERT INTO TMP_CNT_FORM_CHAREXTRA2 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where iac.dd_ifc_id = 
(select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'char_extra2');

INSERT INTO TMP_CNT_FORM_CHAREXTRA3 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where iac.dd_ifc_id = 
(select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'char_extra3');


INSERT INTO TMP_CNT_FORM_CHAREXTRA4 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where iac.dd_ifc_id = 
(select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'char_extra4');


INSERT INTO TMP_CNT_FORM_CHAREXTRA5 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where iac.dd_ifc_id = 
(select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'char_extra5');


INSERT INTO TMP_CNT_FORM_CHAREXTRA6 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where iac.dd_ifc_id = 
(select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'char_extra6');


INSERT INTO TMP_CNT_FORM_CHAREXTRA7 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where iac.dd_ifc_id = 
(select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'char_extra7');


INSERT INTO TMP_CNT_FORM_CHAREXTRA8 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where iac.dd_ifc_id = 
(select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'char_extra8');


  
INSERT INTO TMP_CNT_FORM_FLAGEXTRA1
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where iac.dd_ifc_id = 
(select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'flag_extra1');

  
INSERT INTO TMP_CNT_FORM_FLAGEXTRA2
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where iac.dd_ifc_id = 
(select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'flag_extra2');

  
INSERT INTO TMP_CNT_FORM_FLAGEXTRA3
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where iac.dd_ifc_id = 
(select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'flag_extra3');

  
INSERT INTO TMP_CNT_FORM_MARCAOPERACION
select iac.cnt_id, mrf.dd_mrf_descripcion marcaoperacion from ext_iac_info_add_contrato iac,CMMASTER.dd_mrf_marca_refinanciacion mrf where 
 iac.iac_value = mrf.dd_mrf_codigo and iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'char_extra9');

  
INSERT INTO TMP_CNT_FORM_MOTIVOMARCA
select iac.cnt_id, mom.dd_mom_descripcion motivomarca from ext_iac_info_add_contrato iac,CMMASTER.dd_mom_motivo_marca_r mom where 
iac.iac_value = mom.dd_mom_codigo and iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'char_extra10');

  
INSERT INTO TMP_CNT_FORM_INDICADORNOMPEN
select iac.cnt_id, idn.dd_idn_descripcion from ext_iac_info_add_contrato iac,CMMASTER.dd_idn_indicador_nomina idn where 
iac.iac_value = idn.dd_idn_codigo and iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'num_extra4');

  
INSERT INTO TMP_CNT_FORM_NCODIGOOFICINA
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where
iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'CODEXTRA2');

  
INSERT INTO TMP_CNT_FORM_ENTIDADORIGEN 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where 
iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'CODEXTRA1');

  
INSERT INTO TMP_CNT_FORM_CONTRATOORIGEN 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where 
iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'CODEXTRA3');

  
INSERT INTO TMP_CNT_FORM_TIPOPRODORIGEN
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where 
iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'INFEXTRA5');

--TODO - este ya campo ya se consume anteriormente  
INSERT INTO TMP_CNT_FORM_CONTRATOPRINCIPAL 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where 
iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'char_extra1');

  
INSERT INTO TMP_CNT_FORM_ESTADOLITIGIO
select iac.cnt_id, stl.dd_stl_descripcion from ext_iac_info_add_contrato iac inner join dd_stl_situacion_litigio stl on iac.iac_value = stl.dd_stl_codigo
and iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'flag_extra1');
  
INSERT INTO TMP_CNT_FORM_FASERECUPERACION     
select iac.cnt_id, frl.dd_frl_descripcion from ext_iac_info_add_contrato iac inner join dd_frl_fase_recup_litigio frl on iac.iac_value = frl.dd_frl_codigo
and iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'flag_extra1');


INSERT INTO TMP_CNT_FORM_GASTOS 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where 
iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'num_extra6');

  
INSERT INTO TMP_CNT_FORM_PROVPROCURADOR 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where 
iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'num_extra7');
  
INSERT INTO TMP_CNT_FORM_INTERESESDEMORA
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where 
iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'num_extra8');
  
INSERT INTO TMP_CNT_FORM_MINUTALETRADO
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where 
iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'num_extra9');
  
INSERT INTO TMP_CNT_FORM_ENTREGAS
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where 
iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'num_extra10');

  
INSERT INTO TMP_CNT_FORM_ESTCNTENTIDAD 
select iac.cnt_id, ece.dd_ece_descripcion from ext_iac_info_add_contrato iac inner join dd_ece_estado_contrato_entidad ece on iac.iac_value = ece.dd_ece_codigo
and iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'DD_ECE_CODIGO');

  
INSERT INTO TMP_CNT_FORM_CREDITOR 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where 
iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'char_extra3');

  
INSERT INTO TMP_CNT_FORM_CODENTIDADPROP 
select iac.cnt_id, dd_pro.DD_PRO_DESCRIPCION from ext_iac_info_add_contrato iac inner join DD_PRO_PROPIETARIOS dd_pro on iac.iac_value = dd_pro.dd_pro_codigo
and iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'char_extra1');

  
INSERT INTO TMP_CNT_FORM_CONDESPECIALES 
select iac.cnt_id, iac.iac_value from ext_iac_info_add_contrato iac where 
iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'NUMERO_ESPEC');

  
INSERT INTO TMP_CNT_FORM_SEGCARTERA 
select iac.cnt_id, DD_SEC.DD_SEC_DESCRIPCION from ext_iac_info_add_contrato iac inner join DD_SEC_SEGMENTO_CARTERA DD_SEC on iac.iac_value = DD_SEC.dd_sec_codigo
and iac.dd_ifc_id = (select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = 'num_extra2');


INSERT INTO CNT_CONTRATOS_FORMULAS (CNT_ID, TITULIZADO, FONDO, NUMEXTRA1, NUMEXTRA2, NUMEXTRA3,
  DATEEXTRA1, CHAREXTRA1, CHAREXTRA2, CHAREXTRA3, CHAREXTRA4, CHAREXTRA5, CHAREXTRA6, CHAREXTRA7,
  CHAREXTRA8, FLAGEXTRA1, FLAGEXTRA2, FLAGEXTRA3,  MARCAOPERACION, MOTIVOMARCA, INDICADORNOMINAPENSION,
  NUEVOCODIGOOFICINA, ENTIDADORIGEN, CONTRATOORIGEN, TIPOPRODUCTOORIGEN, CONTRATOPRINCIPAL, ESTADOLITIGIO,
  FASERECUPERACION, GASTOS, PROVISIONPROCURADOR, INTERESESDEMORA, MINUTALETRADO, ENTREGAS, ESTADOCONTRATOENTIDAD,
  CREDITOR, CODENTIDADPROPIETARIA, CONDICIONESESPECIALES, SEGMENTOCARTERA)
SELECT CNT.CNT_ID,
  T1.TITULIZADO, T1.FONDO,
  T2.NUMEXTRA1,
  T3.NUMEXTRA2,
  T4.NUMEXTRA3,
  T5.DATEEXTRA1,
  T6.CHAREXTRA1,
  T7.CHAREXTRA2,
  T8.CHAREXTRA3,
  T9.CHAREXTRA4,
  T10.CHAREXTRA5,
  T11.CHAREXTRA6,
  T12.CHAREXTRA7,
  T13.CHAREXTRA8,
  T14.FLAGEXTRA1,
  T15.FLAGEXTRA2,
  T16.FLAGEXTRA3,
  T17.MARCAOPERACION,
  T18.MOTIVOMARCA,
  T19.INDICADORNOMINAPENSION,
  T20.NUEVOCODIGOOFICINA,
  T21.ENTIDADORIGEN,
  T22.CONTRATOORIGEN,
  T23.TIPOPRODUCTOORIGEN,
  T24.CONTRATOPRINCIPAL,
  T25.ESTADOLITIGIO,
  T26.FASERECUPERACION,
  T27.GASTOS,
  T28.PROVISIONPROCURADOR,
  T29.INTERESESDEMORA,
  T30.MINUTALETRADO,
  T31.ENTREGAS,
  T32.ESTADOCONTRATOENTIDAD,
  T33.CREDITOR,
  T34.CODENTIDADPROPIETARIA,
  T35.CONDICIONESESPECIALES,
  T36.SEGMENTOCARTERA 
FROM CNT_CONTRATOS CNT
LEFT JOIN TMP_CNT_FORM_FONDO T1 ON CNT.CNT_ID = T1.CNT_ID
LEFT JOIN TMP_CNT_FORM_NUMEXTRA1 T2 ON CNT.CNT_ID = T2.CNT_ID
LEFT JOIN TMP_CNT_FORM_NUMEXTRA2 T3 ON CNT.CNT_ID = T3.CNT_ID
LEFT JOIN TMP_CNT_FORM_NUMEXTRA3 T4 ON CNT.CNT_ID = T4.CNT_ID
LEFT JOIN TMP_CNT_FORM_DATEEXTRA1 T5 ON CNT.CNT_ID = T5.CNT_ID
LEFT JOIN TMP_CNT_FORM_CHAREXTRA1 T6 ON CNT.CNT_ID = T6.CNT_ID
LEFT JOIN TMP_CNT_FORM_CHAREXTRA2 T7 ON CNT.CNT_ID = T7.CNT_ID
LEFT JOIN TMP_CNT_FORM_CHAREXTRA3 T8 ON CNT.CNT_ID = T8.CNT_ID
LEFT JOIN TMP_CNT_FORM_CHAREXTRA4 T9 ON CNT.CNT_ID = T9.CNT_ID
LEFT JOIN TMP_CNT_FORM_CHAREXTRA5 T10 ON CNT.CNT_ID = T10.CNT_ID
LEFT JOIN TMP_CNT_FORM_CHAREXTRA6 T11 ON CNT.CNT_ID = T11.CNT_ID
LEFT JOIN TMP_CNT_FORM_CHAREXTRA7 T12 ON CNT.CNT_ID = T12.CNT_ID
LEFT JOIN TMP_CNT_FORM_CHAREXTRA8 T13 ON CNT.CNT_ID = T13.CNT_ID
LEFT JOIN TMP_CNT_FORM_FLAGEXTRA1 T14 ON CNT.CNT_ID = T14.CNT_ID
LEFT JOIN TMP_CNT_FORM_FLAGEXTRA2 T15 ON CNT.CNT_ID = T15.CNT_ID
LEFT JOIN TMP_CNT_FORM_FLAGEXTRA3 T16 ON CNT.CNT_ID = T16.CNT_ID
LEFT JOIN TMP_CNT_FORM_MARCAOPERACION T17 ON CNT.CNT_ID = T17.CNT_ID
LEFT JOIN TMP_CNT_FORM_MOTIVOMARCA T18 ON CNT.CNT_ID = T18.CNT_ID
LEFT JOIN TMP_CNT_FORM_INDICADORNOMPEN T19 ON CNT.CNT_ID = T19.CNT_ID
LEFT JOIN TMP_CNT_FORM_NCODIGOOFICINA T20 ON CNT.CNT_ID = T20.CNT_ID
LEFT JOIN TMP_CNT_FORM_ENTIDADORIGEN T21 ON CNT.CNT_ID = T21.CNT_ID
LEFT JOIN TMP_CNT_FORM_CONTRATOORIGEN T22 ON CNT.CNT_ID = T22.CNT_ID
LEFT JOIN TMP_CNT_FORM_TIPOPRODORIGEN T23 ON CNT.CNT_ID = T23.CNT_ID
LEFT JOIN TMP_CNT_FORM_CONTRATOPRINCIPAL T24 ON CNT.CNT_ID = T24.CNT_ID
LEFT JOIN TMP_CNT_FORM_ESTADOLITIGIO T25 ON CNT.CNT_ID = T25.CNT_ID
LEFT JOIN TMP_CNT_FORM_FASERECUPERACION T26 ON CNT.CNT_ID = T26.CNT_ID
LEFT JOIN TMP_CNT_FORM_GASTOS T27 ON CNT.CNT_ID = T27.CNT_ID
LEFT JOIN TMP_CNT_FORM_PROVPROCURADOR T28 ON CNT.CNT_ID = T28.CNT_ID
LEFT JOIN TMP_CNT_FORM_INTERESESDEMORA T29 ON CNT.CNT_ID = T29.CNT_ID
LEFT JOIN TMP_CNT_FORM_MINUTALETRADO T30 ON CNT.CNT_ID = T30.CNT_ID
LEFT JOIN TMP_CNT_FORM_ENTREGAS T31 ON CNT.CNT_ID = T31.CNT_ID
LEFT JOIN TMP_CNT_FORM_ESTCNTENTIDAD T32 ON CNT.CNT_ID = T32.CNT_ID
LEFT JOIN TMP_CNT_FORM_CREDITOR T33 ON CNT.CNT_ID = T33.CNT_ID
LEFT JOIN TMP_CNT_FORM_CODENTIDADPROP T34 ON CNT.CNT_ID = T34.CNT_ID
LEFT JOIN TMP_CNT_FORM_CONDESPECIALES T35 ON CNT.CNT_ID = T35.CNT_ID
LEFT JOIN TMP_CNT_FORM_SEGCARTERA T36 ON CNT.CNT_ID = T36.CNT_ID;

