

/* INSERTAMOS CLI_CLIENTE  */

/*20150303: ROBERTO*/
INSERT INTO CLI_CLIENTES(
CLI_ID,
PER_ID,
ARQ_ID,
DD_EST_ID,
CLI_FECHA_EST_ID,
VERSION,
USUARIOCREAR,
FECHACREAR,
BORRADO,
CLI_FECHA_CREACION,
DD_ECL_ID,
CLI_TELECOBRO,
OFI_ID)

SELECT 
S_CLI_CLIENTES.NEXTVAL ,
TMP.PER_ID,
arq.ARQ_ID, 
iti.DD_EST_ID,
PER.PER_FECHA_EXTRACCION,
'0',
'CONVIVE_F2',
SYSDATE, 
'0',
SYSDATE,
cli.DD_ECL_CODIGO,
'0',
OFI_ID
FROM  CNV_TMP_PER_ID TMP
/*
LEFT JOIN ARQ_ARQUETIPOS arq ON arq.ITI_ID ='1'
LEFT JOIN HAYAMASTER.DD_ECL_ESTADO_CLIENTE cli ON cli.DD_ECL_CODIGO = '1'
LEFT JOIN HAYAMASTER.DD_EST_ESTADOS_ITINERARIOS iti on iti.DD_EST_CODIGO = 'CMER'
LEFT JOIN PER_PERSONAS PER ON TMP.PER_ID=PER.PER_ID
*/
inner JOIN ARQ_ARQUETIPOS arq ON arq.ITI_ID ='1'
inner JOIN HAYAMASTER.DD_ECL_ESTADO_CLIENTE cli ON cli.DD_ECL_CODIGO = '1'
inner JOIN HAYAMASTER.DD_EST_ESTADOS_ITINERARIOS iti on iti.DD_EST_CODIGO = 'CMER'
inner JOIN PER_PERSONAS PER ON TMP.PER_ID=PER.PER_ID
where TMP.PER_ID not in ( SELECT CLIENTES.PER_ID  FROM CLI_CLIENTES CLIENTES) AND TMP.PER_ID IS NOT NULL;





/* INSERT CCL_CONTRATOS_CLIENTE  */

/*20150303: ROBERTO*/
INSERT INTO CCL_CONTRATOS_CLIENTE(
CCL_ID,
CNT_ID,
CLI_ID,
CCL_PASE,
VERSION,
USUARIOCREAR,
FECHACREAR,
BORRADO)

SELECT 
S_CCL_CONTRATOS_CLIENTE.NEXTVAL,
CNT_ID,
CLI_ID,
'1',
'0',
'CONVIVE_F2',
SYSDATE,
'0'

FROM  CNV_AUX_ALTA_PRC_PER P
INNER JOIN CNV_TMP_PER_ID PER ON P.CODIGO_PERSONA=PER.CODIGO_PERSONA
INNER JOIN CLI_CLIENTES CLI ON PER.PER_ID=CLI.PER_ID,
CNV_AUX_ALTA_PRC_CNT C 
--LEFT JOIN CNV_TMP_CNT_ID CNT ON C.NUMERO_CONTRATO=CNT.NUMERO_CONTRATO AND C.NUMERO_ESPEC=CNT.NUMERO_ESPEC AND C.TIPO_PRODUCTO=CNT.TIPO_PRODUCTO  
INNER JOIN CNV_TMP_CNT_ID CNT ON C.NUMERO_CONTRATO=CNT.NUMERO_CONTRATO AND C.NUMERO_ESPEC=CNT.NUMERO_ESPEC AND C.TIPO_PRODUCTO=CNT.TIPO_PRODUCTO
WHERE PER.PER_ID NOT IN (SELECT CLIENTE.CLI_ID  FROM CCL_CONTRATOS_CLIENTE CLIENTE)  
  AND PER.PER_ID IS NOT NULL AND P.CODIGO_PROCEDIMIENTO=C.CODIGO_PROCEDIMIENTO 
  AND CNT.CNT_ID NOT IN (SELECT CLIENTE.CNT_ID  FROM CCL_CONTRATOS_CLIENTE CLIENTE)  
  AND CNT.CNT_ID IS NOT NULL;
  




/*  INSERT EXP_EXPEDIENTES   */ 

/*20150303: ROBERTO*/
INSERT INTO EXP_EXPEDIENTES(
EXP_ID,
DD_EST_ID,
EXP_FECHA_EST_ID,
OFI_ID,
ARQ_ID,
EXP_PROCESS_BPM,
EXP_MANUAL,
VERSION,
USUARIOCREAR,
FECHACREAR,
BORRADO,
DD_EEX_ID,
DD_TPX_ID,
CD_EXPEDIENTE_NUSE,
NUMERO_EXP_NUSE,
CD_PROCEDIMIENTO)
SELECT 
S_EXP_EXPEDIENTES.NEXTVAL,
iti.DD_EST_ID,
CNV_AUX_ALTA_PRC.FECHA_PROCESO, 
zon.OFI_ID,
arq.ARQ_ID,
'0',
'0',
'0',
'CONVIVE_F2',
SYSDATE,
'0',
est.DD_EEX_ID,
exp.DD_TPX_ID,
CNV_AUX_ALTA_PRC.CODIGO_EXPEDIENTE_NUSE, 
CNV_AUX_ALTA_PRC.NUMERO_EXP_NUSE,
CNV_AUX_ALTa_PRC.CODIGO_PROCEDIMIENTO_NUSE
FROM CNV_AUX_ALTA_PRC 
/*
LEFT JOIN HAYAMASTER.DD_EEX_ESTADO_EXPEDIENTE est ON est.DD_EEX_CODIGO = '1'
LEFT JOIN DD_TPX_TIPO_EXPEDIENTE exp ON exp.DD_TPX_CODIGO = 'REC'
LEFT JOIN ZON_ZONIFICACION zon ON zon.zon_cod = '01'
LEFT JOIN ARQ_ARQUETIPOS arq ON arq.ITI_ID ='1'
LEFT JOIN HAYAMASTER.DD_EST_ESTADOS_ITINERARIOS iti on iti.DD_EST_CODIGO = 'CMER'
*/
INNER JOIN HAYAMASTER.DD_EEX_ESTADO_EXPEDIENTE est ON est.DD_EEX_CODIGO = '1'
INNER JOIN DD_TPX_TIPO_EXPEDIENTE exp ON exp.DD_TPX_CODIGO = 'REC'
INNER JOIN ZON_ZONIFICACION zon ON zon.zon_cod = '01'
INNER JOIN ARQ_ARQUETIPOS arq ON arq.ITI_ID ='1'
INNER JOIN HAYAMASTER.DD_EST_ESTADOS_ITINERARIOS iti on iti.DD_EST_CODIGO = 'CMER'
where CNV_AUX_ALTA_PRC.CODIGO_PROCEDIMIENTO_NUSE not in 
   ( SELECT EXPE.CD_PROCEDIMIENTO FROM EXP_EXPEDIENTES EXPE WHERE CD_PROCEDIMIENTO IS NOT NULL);
  



  
/* INSERT PEX_PERSONAS_EXPEDIENTE   */

/*20150303: ROBERTO*/
INSERT INTO PEX_PERSONAS_EXPEDIENTE(
PEX_ID,
PER_ID,
EXP_ID,
DD_AEX_ID,
PEX_PASE,
VERSION,
USUARIOCREAR,
FECHACREAR,
BORRADO)

SELECT 
S_PEX_PERSONAS_EXPEDIENTE.NEXTVAL,
TMP.PER_ID,
EXP.EXP_ID,
AMB.DD_AEX_ID,
'0',
'0',
'CONVIVE_F2',
SYSDATE,
'0'

FROM  CNV_AUX_ALTA_PRC_PER PER
/*
LEFT JOIN HAYAMASTER.DD_AEX_AMBITOS_EXPEDIENTE AMB ON AMB.DD_AEX_CODIGO = 'AE_AUTO'
LEFT JOIN EXP_EXPEDIENTES EXP ON EXP.CD_PROCEDIMIENTO=PER.CODIGO_PROCEDIMIENTO
LEFT JOIN CNV_TMP_PER_ID TMP ON TMP.CODIGO_PERSONA=PER.CODIGO_PERSONA 
*/
INNER JOIN HAYAMASTER.DD_AEX_AMBITOS_EXPEDIENTE AMB ON AMB.DD_AEX_CODIGO = 'AE_AUTO'
INNER JOIN EXP_EXPEDIENTES EXP ON EXP.CD_PROCEDIMIENTO=PER.CODIGO_PROCEDIMIENTO
INNER JOIN CNV_TMP_PER_ID TMP ON TMP.CODIGO_PERSONA=PER.CODIGO_PERSONA 
where TMP.PER_ID not in ( SELECT PEX.PER_ID  FROM PEX_PERSONAS_EXPEDIENTE PEX) AND TMP.PER_ID IS NOT NULL AND EXP.EXP_ID IS NOT NULL;



   
   

/* INSERT CEX_CONTRATOS_EXPEDIENTE   */

/* Elimino las relaciones de contratos antiguas para generar las nuevas*/
delete from CEX_CONTRATOS_EXPEDIENTE where cnt_id in (
  SELECT TMP.CNT_ID
  FROM  CNV_AUX_ALTA_PRC_CNT CNT
  inner JOIN HAYAMASTER.DD_AEX_AMBITOS_EXPEDIENTE AMB ON AMB.DD_AEX_CODIGO = 'AE_AUTO'
  inner JOIN EXP_EXPEDIENTES EXP ON EXP.CD_PROCEDIMIENTO=CNT.CODIGO_PROCEDIMIENTO
  inner JOIN CNV_TMP_CNT_ID TMP ON TMP.NUMERO_CONTRATO=CNT.NUMERO_CONTRATO 
    AND TMP.NUMERO_ESPEC=CNT.NUMERO_ESPEC AND TMP.TIPO_PRODUCTO=CNT.TIPO_PRODUCTO
  inner join   CNV_AUX_ALTA_PRC p on p.codigo_procedimiento_nuse=cnt.codigo_procedimiento
  where 
    TMP.CNT_ID IS NOT NULL 
    AND EXP.EXP_ID IS NOT NULL
);

/*20150303: ROBERTO*/
INSERT INTO CEX_CONTRATOS_EXPEDIENTE(
CEX_ID,
CNT_ID,
EXP_ID,
CEX_PASE,
CEX_SIN_ACTUACION,
VERSION,
USUARIOCREAR,
FECHACREAR,
BORRADO,
DD_AEX_ID)

SELECT 
S_CEX_CONTRATOS_EXPEDIENTE.NEXTVAL,
TMP.CNT_ID,
EXP.EXP_ID,
'0',
'0',
'0',
'CONVIVE_F2',
SYSDATE,
'0',
AMB.DD_AEX_ID

FROM  CNV_AUX_ALTA_PRC_CNT CNT
/*
LEFT JOIN HAYAMASTER.DD_AEX_AMBITOS_EXPEDIENTE AMB ON AMB.DD_AEX_CODIGO = 'AE_AUTO'
LEFT JOIN EXP_EXPEDIENTES EXP ON EXP.CD_PROCEDIMIENTO=CNT.CODIGO_PROCEDIMIENTO
LEFT JOIN CNV_TMP_CNT_ID TMP ON TMP.NUMERO_CONTRATO=CNT.NUMERO_CONTRATO 
  AND TMP.NUMERO_ESPEC=CNT.NUMERO_ESPEC AND TMP.TIPO_PRODUCTO=CNT.TIPO_PRODUCTO
*/
inner JOIN HAYAMASTER.DD_AEX_AMBITOS_EXPEDIENTE AMB ON AMB.DD_AEX_CODIGO = 'AE_AUTO'
inner JOIN EXP_EXPEDIENTES EXP ON EXP.CD_PROCEDIMIENTO=CNT.CODIGO_PROCEDIMIENTO
inner JOIN CNV_TMP_CNT_ID TMP ON TMP.NUMERO_CONTRATO=CNT.NUMERO_CONTRATO 
  AND TMP.NUMERO_ESPEC=CNT.NUMERO_ESPEC AND TMP.TIPO_PRODUCTO=CNT.TIPO_PRODUCTO
where TMP.CNT_ID not in ( SELECT CEX.CNT_ID FROM CEX_CONTRATOS_EXPEDIENTE CEX) 
	AND TMP.CNT_ID IS NOT NULL 
	AND EXP.EXP_ID IS NOT NULL;







/* INSERT ASU_ASUNTOS   */

/*20150303: ROBERTO*/
INSERT INTO ASU_ASUNTOS(
ASU_ID,
DD_EST_ID,
ASU_FECHA_EST_ID,
ASU_NOMBRE,
EXP_ID,
VERSION,
USUARIOCREAR,
FECHACREAR,
BORRADO,
DD_EAS_ID,
DTYPE,
ASU_ID_EXTERNO)
SELECT 
S_ASU_ASUNTOS.NEXTVAL,
iti.DD_EST_ID,
SYSDATE, 
CNV_AUX_ALTA_PRC.CODIGO_PROCEDIMIENTO_NUSE, 
EXPE.EXP_ID,
'0',
'CONVIVE_F2',
SYSDATE, 
'0',
DD_EAS_ID,
'EXTAsunto',
CNV_AUX_ALTA_PRC.CODIGO_PROCEDIMIENTO_NUSE 
FROM CNV_AUX_ALTA_PRC 
/*
LEFT JOIN HAYAMASTER.DD_EAS_ESTADO_ASUNTOS asu ON asu.DD_EAS_CODIGO = '03'
LEFT JOIN HAYAMASTER.DD_EST_ESTADOS_ITINERARIOS iti on iti.DD_EST_CODIGO = 'AS'
LEFT JOIN EXP_EXPEDIENTES EXPE ON CNV_AUX_ALTA_PRC.CODIGO_EXPEDIENTE_NUSE=EXPE.CD_EXPEDIENTE_NUSE
*/
inner JOIN HAYAMASTER.DD_EAS_ESTADO_ASUNTOS asu ON asu.DD_EAS_CODIGO = '03'
inner JOIN HAYAMASTER.DD_EST_ESTADOS_ITINERARIOS iti on iti.DD_EST_CODIGO = 'AS'
inner JOIN EXP_EXPEDIENTES EXPE ON CNV_AUX_ALTA_PRC.CODIGO_EXPEDIENTE_NUSE=EXPE.CD_EXPEDIENTE_NUSE
where CNV_AUX_ALTA_PRC.CODIGO_PROCEDIMIENTO_NUSE not in ( SELECT ASUNTOS.ASU_ID_EXTERNO FROM ASU_ASUNTOS ASUNTOS WHERE ASU_ID_EXTERNO IS NOT NULL)
AND EXPE.EXP_ID IN (SELECT EXP_ID FROM CEX_CONTRATOS_EXPEDIENTE);

