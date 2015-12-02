
delete from lin_asuntos_nuevos;
commit;

/**
Procedimiento hipotecario con ID: 2353
despacho: 11015
letrado: DLETR
procurador: PROCU
id juzgado: 27562
Litigio: 01

1500 asuntos concursales con los siguientes datos:
Procedimiento concursal con ID: 2358
despacho: 11015
letrado: DLETR
procurador: PROCU
id juzgado: 27562
Concursal: 02
**/

--alter table haya01.lin_asuntos_nuevos add dd_tas_codigo varchar2(10);

/*
15 asuntos de prelitigio con los siguientes datos:
Procedimiento prelitigio con ID: 2358
despacho: 11015
letrado: DLETR
procurador: PROCU
id juzgado: 27562
Concursal: 02
*/

SELECT 'INSERT INTO LIN_ASUNTOS_NUEVOS
  (N_CASO,CREADO,FECHA_ALTA,N_REFERENCIA,DESPACHO,LETRADO,GRUPO,TIPO_PROC,PROCURADOR,PLAZA,JUZGADO,PRINCIPAL,ID,VERSION,N_LOTE,LIN_ID,PRM_ID,DD_TAS_CODIGO)
 VALUES (''' || 
 cnt.CNT_CONTRATO || ''',''N'',SYSDATE,''' || rownum || ''',''11015'',NULL,''DLETR'',''' || (SELECT DD_TPO_ID FROM HAYA01.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='PCO') || 
      ''',''PROCU'',''16626'',NULL,''' || ROWNUM || '000000'',''' || ROWNUM || ''', ''0'',NULL,NULL,NULL,''01'');' 
 FROM CNT_CONTRATOS cnt
                          /*JOIN cex_contratos_expediente cex
                          ON cex.cnt_id = cnt.cnt_id
                          JOIN prc_cex ON prc_cex.cex_id = cex.cex_id
                          JOIN prc_procedimientos prc
                          ON prc.prc_id = prc_cex.prc_id
                          JOIN asu_asuntos asu ON asu.asu_id = prc.asu_id*/
                    WHERE /*prc.borrado = 0
                      AND cex.borrado = 0
                      AND asu.dd_eas_id NOT IN (
                                    SELECT eas6.dd_eas_id
                                      FROM dd_eas_estado_asuntos eas6
                                     WHERE eas6.dd_eas_codigo IN ('05', '06'))
                                      and*/ cnt.CNT_ID NOT IN (SELECT CNT_ID FROM PRC_CEX PC INNER JOIN cex_contratos_expediente CEX ON CEX.CEX_ID = PC.CEX_ID) AND ROWNUM <= 50;


/*
SELECT 'INSERT INTO LIN_ASUNTOS_NUEVOS
  (N_CASO,CREADO,FECHA_ALTA,N_REFERENCIA,DESPACHO,LETRADO,GRUPO,TIPO_PROC,PROCURADOR,PLAZA,JUZGADO,PRINCIPAL,ID,VERSION,N_LOTE,LIN_ID,PRM_ID,DD_TAS_CODIGO) VALUES (''' || 
  cnt.CNT_CONTRATO || ''',''N'',SYSDATE,''' || rownum || ''',''11015'',NULL,''DLETR'',''' || (SELECT DD_TPO_ID FROM HAYA01.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='PCO') || 
  ''',''PROCU'',''16626'',NULL,''' || ROWNUM || '000000'',''' || ROWNUM || ''', ''0'',NULL,NULL,NULL,''02'');' 
FROM CNT_CONTRATOS cnt
WHERE cnt.CNT_ID NOT IN (SELECT CNT_ID FROM PRC_CEX PC INNER JOIN cex_contratos_expediente CEX ON CEX.CEX_ID = PC.CEX_ID) AND ROWNUM <= 15;
*/

/**
Insert into LIN_ASUNTOS_NUEVOS (N_CASO,CREADO,FECHA_ALTA,
N_REFERENCIA,DESPACHO,LETRADO,GRUPO,TIPO_PROC,PROCURADOR,PLAZA,JUZGADO,PRINCIPAL,ID,VERSION,N_LOTE,LIN_ID,PRM_ID) 
values ('000002100000000000923437831000000000000000','S',to_date('09/09/15','DD/MM/RR'),
'1154','11015',null,'DLETR','2358','PROCU','16626',null,'1154000000','1154','0',null,null,null);
*/