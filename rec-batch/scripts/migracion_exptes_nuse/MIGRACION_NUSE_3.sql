-- ----------------------------------------------------------------------------
-- SCRIPTS DE MIGRACIÓN DE NUSE A RECOVERY
-- ORDEN DEL SCRIPT: 3
-- SCRIPT: Creación de los datos
-- AUTOR: Guillem Pascual Serra   
-- EMPRESA: PFSGROUP
-- -----------------------------------------------------------------------------

-- Creamos una tabla temporal que contendrá los datos provenientes de NUSE filtrados
create table LOAD_CICLOS_NUSE_STAGE_2 as
  select nuse.*, cnt.CNT_CONTRATO AS CNT_CONTRATO
  from LOAD_CICLOS_NUSE_STAGE_1 nuse
  join cnt_contratos cnt on cnt.CNT_CONTRATO = (nuse.CODIGO_PROPIETARIO || nuse.TIPO_PRODUCTO || nuse.NUMERO_CONTRATO || nuse.NUMERO_ESPEC)
  where FECHA_BAJA_AGENCIA = '00000000'
  and NUMERO_CONTRATO <> '00000000000000000';

-- Creamos una tabla TEMPORAL que contendrá los nuevos ids de expediente y sus contratos vinculados
CREATE TABLE TMP_MIGRACION_NUSE_1 (EXP_ID NUMBER(16) NOT NULL, CNT_CONTRATO VARCHAR2(50 BYTE) NOT NULL, CEX_PASE NUMBER(1) DEFAULT 0);

-- Creamos una tabla TEMPORAL que contendrá los nuevos ids de expediente y sus personas vinculadas
CREATE TABLE TMP_MIGRACION_NUSE_2 (EXP_ID NUMBER(16) NOT NULL, PER_ID NUMBER(16) NOT NULL, PEX_PASE NUMBER(1) DEFAULT 0);

-- Cargamos en una TMP los nuevos ids de expediente y sus contratos vinculados
-- inicio sustitucion del PLSQL
CREATE TABLE TMP_NUSE_EXP_ID_NUEVOS AS
SELECT S_EXP_EXPEDIENTES.NEXTVAL EXP_ID, ID_EXPEDIENTE FROM (
  SELECT DISTINCT ID_EXPEDIENTE FROM LOAD_CICLOS_NUSE_STAGE_2
);

INSERT /*+ APPEND PARALLEL(TMP_MIGRACION_NUSE_1, 16) PQ_DISTRIBUTE(TMP_MIGRACION_NUSE_1, NONE) */ INTO TMP_MIGRACION_NUSE_1 (EXP_ID, CNT_CONTRATO, CEX_PASE)
      SELECT EID.EXP_ID, NUSE.CODIGO_PROPIETARIO || NUSE.TIPO_PRODUCTO || NUSE.NUMERO_CONTRATO || NUSE.NUMERO_ESPEC, 0
      FROM LOAD_CICLOS_NUSE_STAGE_2 NUSE
      JOIN TMP_NUSE_EXP_ID_NUEVOS EID ON NUSE.ID_EXPEDIENTE = EID.ID_EXPEDIENTE;
-- fin ejecucion del PL/SQL
COMMIT;

-- Cargamos en una TMP los nuevos ids de expediente y sus personas vinculadas
INSERT INTO TMP_MIGRACION_NUSE_2 (EXP_ID, PER_ID, PEX_PASE)
    SELECT nuse.EXP_ID, PER.PER_ID, 0
    FROM TMP_MIGRACION_NUSE_1 nuse
    JOIN cnt_contratos cnt on nuse.CNT_CONTRATO = cnt.CNT_CONTRATO
    JOIN CPE_CONTRATOS_PERSONAS CPE ON cnt.CNT_ID = CPE.CNT_ID 
    JOIN PER_PERSONAS PER ON CPE.PER_ID = PER.PER_ID;			  

COMMIT;

-- Actualizamos el CEX_PASE en la tabla TMP_MIGRACION_NUSE_1 por expediente y 
-- contrato marcando el contrato mayor deuda irregular
-- inicio sustitucion PL/SQL
update TMP_MIGRACION_NUSE_1 set cex_pase = 1 where (exp_id, cnt_contrato) in (
select exp_id, cnt_contrato from (
select row_number() over (partition by nuse.exp_id order by mov.mov_deuda_irregular desc) indice, nuse.*
FROM TMP_MIGRACION_NUSE_1 nuse 
        join cnt_contratos cnt on cnt.CNT_CONTRATO = nuse.cnt_contrato
        join mov_movimientos mov on cnt.cnt_id = mov.cnt_id and cnt.cnt_fecha_extraccion = mov.mov_fecha_extraccion
) where indice = 1);
-- fin sustitucioN PL/SQL


COMMIT;

-- Actualizamos el PEX_PASE en la tabla TMP_MIGRACION_NUSE_2 por expediente y 
-- persona marcando la persona con el per_id más bajo
-- inicio sustitucion PL/SQL
update TMP_MIGRACION_NUSE_2  set pex_pase = 1 where (exp_id, per_id) in ( 
  select exp_id, per_id from (
    select row_number() over (partition by nuse.exp_id order by per_id) indice, nuse.exp_id, cpe.per_id
    FROM TMP_MIGRACION_NUSE_1 nuse 
        join cnt_contratos cnt on cnt.CNT_CONTRATO = nuse.cnt_contrato
        join cpe_contratos_personas cpe on cnt.cnt_id = cpe.cnt_id
  ) where indice = 1
);
-- fin sustitucion PL/SQL


COMMIT;

-- Primer paso: crear los expedientes y los expedientes de recobro
-- inicio sustitución PL/SQL
create index idx_migraci_01 on TMP_MIGRACION_NUSE_1(cex_pase);

create index idx_migraci_02 on TMP_MIGRACION_NUSE_2(pex_pase);

create index idx_migraci_03 on TMP_MIGRACION_NUSE_2(exp_id);

analyze table TMP_MIGRACION_NUSE_1 compute statistics;

analyze table TMP_MIGRACION_NUSE_2 compute statistics;

/
declare
  vARQ_ID NUMBER(16);
begin		
  select ARQ_ID into vARQ_ID from arq_arquetipos where ARQ_NOMBRE = 'GENERICO EXPEDIENTE DE RECOBRO';
INSERT /*+ APPEND PARALLEL(EXP_EXPEDIENTES, 16) PQ_DISTRIBUTE(EXP_EXPEDIENTES, NONE) */ INTO EXP_EXPEDIENTES (EXP_ID, EXP_DESCRIPCION, EXP_FECHA_EST_ID, OFI_ID, 
    ARQ_ID, DD_EEX_ID, EXP_MANUAL, DD_TPX_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)    
    SELECT DISTINCT nuse.exp_id, REPLACE(nuse.exp_id||' - '||TRIM(PER.PER_NOMBRE||' '||PER.PER_APELLIDO1||' '||PER.PER_APELLIDO2),'''','''''')
    ,SYSDATE, CNT.OFI_ID, vARQ_ID, 2, 0, tpx.dd_tpx_id, 0, 'MIG-NUSE', SYSDATE, 0
    FROM TMP_MIGRACION_NUSE_1 nuse 
    JOIN cnt_contratos CNT on CNT.CNT_CONTRATO = nuse.cnt_contrato
    JOIN TMP_MIGRACION_NUSE_2 nuse2  ON nuse.EXP_ID = nuse2.EXP_ID
    JOIN PER_PERSONAS PER ON nuse2.PER_ID = PER.PER_ID 
    JOIN DD_TPX_TIPO_EXPEDIENTE TPX ON TPX.DD_TPX_CODIGO = 'REC'
    WHERE nuse.CEX_PASE = 1 AND nuse2.PEX_PASE = 1; 
end;
/
COMMIT;


    
INSERT /*+ APPEND PARALLEL(EXR_EXPEDIENTE_RECOBRO, 16) PQ_DISTRIBUTE(EXR_EXPEDIENTE_RECOBRO, NONE) */  INTO EXR_EXPEDIENTE_RECOBRO (EXP_ID) 
    SELECT DISTINCT EXP_ID 
    FROM exp_expedientes;    
-- fin sustitución PL/SQL

COMMIT;

-- Segundo paso: crear las relaciones de los expedientes y los contratos
-- inicio sustitución PL/SQL
      
INSERT INTO CEX_CONTRATOS_EXPEDIENTE (CEX_ID, CNT_ID, EXP_ID, DD_AEX_ID, CEX_PASE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
    SELECT S_CEX_CONTRATOS_EXPEDIENTE.nextVal, D.* FROM (
      SELECT DISTINCT cnt.cnt_id, nuse.EXP_ID, AEX.DD_AEX_ID, nuse.cex_pase, 0 V, 'MIG-NUSE' UC, sysdate FC, 0 B 
      FROM TMP_MIGRACION_NUSE_1 nuse
      JOIN EXP_EXPEDIENTES EXP ON NUSE.EXP_ID = EXP.EXP_ID
      join cnt_contratos cnt on nuse.CNT_CONTRATO = cnt.CNT_CONTRATO
      JOIN BANKMASTER.DD_AEX_AMBITOS_EXPEDIENTE AEX ON AEX.DD_AEX_CODIGO = 'AE_AUTO'
    ) D;			  			  	

-- fin sustitución PL/SQL
COMMIT;

-- Tercer paso: crear las relaciones de los expedientes y las personas
-- inicio sustitución PL/SQL

INSERT INTO PEX_PERSONAS_EXPEDIENTE (PEX_ID, EXP_ID, PER_ID, DD_AEX_ID, PEX_PASE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
    SELECT S_PEX_PERSONAS_EXPEDIENTE.nextVal, D.* FROM (
      SELECT DISTINCT nuse.EXP_ID, PER.PER_ID, AEX.DD_AEX_ID, nuse.PEX_PASE, 0 V, 'MIG-NUSE' UC, sysdate VC, 0 B  
      FROM TMP_MIGRACION_NUSE_2 nuse
      JOIN EXP_EXPEDIENTES EXP ON NUSE.EXP_ID = EXP.EXP_ID
      JOIN CPE_CONTRATOS_PERSONAS CPE ON nuse.PER_ID = CPE.PER_ID
      JOIN PER_PERSONAS PER ON CPE.PER_ID = PER.PER_ID
      JOIN BANKMASTER.DD_AEX_AMBITOS_EXPEDIENTE AEX ON AEX.DD_AEX_CODIGO = 'AE_AUTO'
    ) D;			  			  	
    
-- fin sustitución PL/SQL

COMMIT;

-- Creamos una tabla TEMPORAL que contendrá los nuevos ciclos de recobro de expedientes
CREATE TABLE TMP_MIGRACION_NUSE_3 (
    EXP_ID      NUMBER(16), 
    RCF_ESQ_ID  NUMBER(16), 
    RCF_ESC_ID  NUMBER(16), 
    RCF_SCA_ID  NUMBER(16), 
    RCF_SUA_ID  NUMBER(16), 
    RCF_AGE_ID  NUMBER(16)
);

-- Cargamos la tabla temporal que contendrá los nuevos ciclos de recobro

-- Creamos los índices necesarios
--create index idx_migraci_04 on CNT_CONTRATOS(cnt_contrato);

analyze table CNT_CONTRATOS compute statistics;

create index idx_migraci_05 on LOAD_CICLOS_NUSE_STAGE_2(cnt_contrato);

create index idx_migraci_06 on LOAD_CICLOS_NUSE_STAGE_2(descripcion_tipo_gestion);

analyze table LOAD_CICLOS_NUSE_STAGE_2 compute statistics;

create index idx_migraci_07 on TMP_MIGRACION_NUSE_1(cnt_contrato);

analyze table TMP_MIGRACION_NUSE_1 compute statistics;

-- Primero cargamos los ciclos de la cartera de Telecobro 
/
declare
  vDD_ESQ_ID NUMBER(16);
  vFecha_Ext DATE;  
begin		
  select rcf_esq_id into vDD_ESQ_ID from rcf_esq_esquema where RCF_ESQ_NOMBRE = 'ESQUEMA INICIAL';
  INSERT INTO TMP_MIGRACION_NUSE_3
  SELECT nuse.EXP_ID, 
    vDD_ESQ_ID,
    (SELECT ESC.RCF_ESC_ID FROM RCF_ESC_ESQUEMA_CARTERAS ESC JOIN RCF_CAR_CARTERA CAR ON ESC.RCF_CAR_ID = CAR.RCF_CAR_ID
        WHERE ESC.RCF_ESQ_ID = vDD_ESQ_ID AND CAR.RCF_CAR_NOMBRE = 'TELECOBRO'),
    (SELECT RCF_SCA_ID FROM RCF_SCA_SUBCARTERA WHERE RCF_ESC_ID = (SELECT ESC.RCF_ESC_ID FROM 
        RCF_ESC_ESQUEMA_CARTERAS ESC JOIN RCF_CAR_CARTERA CAR ON ESC.RCF_CAR_ID = CAR.RCF_CAR_ID
        WHERE ESC.RCF_ESQ_ID = vDD_ESQ_ID AND CAR.RCF_CAR_NOMBRE = 'TELECOBRO')),    
   (SELECT RCF_SUA_ID FROM RCF_SUA_SUBCARTERA_AGENCIAS WHERE 
        RCF_AGE_ID = (SELECT DISTINCT RCF_AGE_ID FROM RCF_AGE_AGENCIAS WHERE RCF_AGE_CODIGO = load.CODIGO_AGENCIA) AND
        RCF_SCA_ID = (SELECT RCF_SCA_ID FROM RCF_SCA_SUBCARTERA WHERE RCF_ESC_ID = (SELECT ESC.RCF_ESC_ID FROM 
        RCF_ESC_ESQUEMA_CARTERAS ESC JOIN RCF_CAR_CARTERA CAR ON ESC.RCF_CAR_ID = CAR.RCF_CAR_ID
        WHERE ESC.RCF_ESQ_ID = vDD_ESQ_ID AND CAR.RCF_CAR_NOMBRE = 'TELECOBRO'))),    
    (SELECT DISTINCT RCF_AGE_ID FROM RCF_AGE_AGENCIAS WHERE RCF_AGE_CODIGO = load.CODIGO_AGENCIA)
  FROM TMP_MIGRACION_NUSE_1 nuse
    JOIN LOAD_CICLOS_NUSE_STAGE_2 load on nuse.CNT_CONTRATO = load.CNT_CONTRATO
    JOIN cnt_contratos cnt on nuse.CNT_CONTRATO = cnt.CNT_CONTRATO
    JOIN CEX_CONTRATOS_EXPEDIENTE cex on cnt.cnt_id = cex.cnt_id
  WHERE load.DESCRIPCION_TIPO_GESTION like '%Telecobro%' and cex.cex_pase = 1; 
end;
/
COMMIT;

-- Segundo cargamos los ciclos de las carteras que NO SON Telecobro según el número de días del campo FECHA_POS_VIVA_VENCIDA
-- Primero cargamos la cartera RECOBRO < 210 donde FECHA_POS_VIVA_VENCIDA <= 210
/
declare
  vDD_ESQ_ID NUMBER(16);
  vFecha_Ext DATE;  
begin		
  SELECT max(mov_fecha_extraccion) into vFecha_Ext from mov_movimientos;
  select rcf_esq_id into vDD_ESQ_ID from rcf_esq_esquema where RCF_ESQ_NOMBRE = 'ESQUEMA INICIAL';
  INSERT INTO TMP_MIGRACION_NUSE_3
  SELECT nuse.EXP_ID, 
    vDD_ESQ_ID,
    (CASE WHEN (MOV.MOV_FECHA_POS_VENCIDA + 210) <= sysdate THEN (SELECT ESC.RCF_ESC_ID FROM RCF_ESC_ESQUEMA_CARTERAS ESC 
      JOIN RCF_CAR_CARTERA CAR ON ESC.RCF_CAR_ID = CAR.RCF_CAR_ID
      WHERE ESC.RCF_ESQ_ID = vDD_ESQ_ID AND CAR.RCF_CAR_NOMBRE = 'RECOBRO < 210') 
    ELSE (SELECT ESC.RCF_ESC_ID FROM RCF_ESC_ESQUEMA_CARTERAS ESC JOIN RCF_CAR_CARTERA CAR ON ESC.RCF_CAR_ID = CAR.RCF_CAR_ID 
      WHERE ESC.RCF_ESQ_ID = vDD_ESQ_ID AND CAR.RCF_CAR_NOMBRE = 'RECOBRO > 210') END),
    (CASE WHEN (MOV.MOV_FECHA_POS_VENCIDA + 210) <= sysdate THEN (SELECT RCF_SCA_ID FROM RCF_SCA_SUBCARTERA 
      WHERE RCF_ESC_ID = (SELECT ESC.RCF_ESC_ID FROM RCF_ESC_ESQUEMA_CARTERAS ESC JOIN RCF_CAR_CARTERA CAR ON ESC.RCF_CAR_ID = CAR.RCF_CAR_ID
      WHERE ESC.RCF_ESQ_ID = vDD_ESQ_ID AND CAR.RCF_CAR_NOMBRE = 'RECOBRO < 210'))
    ELSE (SELECT RCF_SCA_ID FROM RCF_SCA_SUBCARTERA WHERE RCF_ESC_ID = (SELECT ESC.RCF_ESC_ID 
      FROM RCF_ESC_ESQUEMA_CARTERAS ESC JOIN RCF_CAR_CARTERA CAR ON ESC.RCF_CAR_ID = CAR.RCF_CAR_ID
      WHERE ESC.RCF_ESQ_ID = vDD_ESQ_ID AND CAR.RCF_CAR_NOMBRE = 'RECOBRO > 210')) END),  
    (CASE WHEN (MOV.MOV_FECHA_POS_VENCIDA + 210) <= sysdate THEN (SELECT RCF_SUA_ID FROM RCF_SUA_SUBCARTERA_AGENCIAS 
      WHERE RCF_AGE_ID = (SELECT DISTINCT RCF_AGE_ID FROM RCF_AGE_AGENCIAS WHERE RCF_AGE_CODIGO = load.CODIGO_AGENCIA) 
      AND RCF_SCA_ID = (SELECT RCF_SCA_ID FROM RCF_SCA_SUBCARTERA WHERE RCF_ESC_ID = (SELECT ESC.RCF_ESC_ID 
      FROM RCF_ESC_ESQUEMA_CARTERAS ESC JOIN RCF_CAR_CARTERA CAR ON ESC.RCF_CAR_ID = CAR.RCF_CAR_ID
      WHERE ESC.RCF_ESQ_ID = vDD_ESQ_ID AND CAR.RCF_CAR_NOMBRE = 'RECOBRO < 210'))) 
    ELSE (SELECT RCF_SUA_ID FROM RCF_SUA_SUBCARTERA_AGENCIAS WHERE RCF_AGE_ID = (SELECT DISTINCT RCF_AGE_ID FROM RCF_AGE_AGENCIAS 
      WHERE RCF_AGE_CODIGO = load.CODIGO_AGENCIA) AND RCF_SCA_ID = (SELECT RCF_SCA_ID FROM RCF_SCA_SUBCARTERA 
      WHERE RCF_ESC_ID = (SELECT ESC.RCF_ESC_ID FROM RCF_ESC_ESQUEMA_CARTERAS ESC JOIN RCF_CAR_CARTERA CAR ON ESC.RCF_CAR_ID = CAR.RCF_CAR_ID
      WHERE ESC.RCF_ESQ_ID = vDD_ESQ_ID AND CAR.RCF_CAR_NOMBRE = 'RECOBRO > 210'))) END),
    (SELECT DISTINCT RCF_AGE_ID FROM RCF_AGE_AGENCIAS WHERE RCF_AGE_CODIGO = load.CODIGO_AGENCIA)
  FROM TMP_MIGRACION_NUSE_1 nuse
    JOIN LOAD_CICLOS_NUSE_STAGE_2 load on nuse.CNT_CONTRATO = load.CNT_CONTRATO
    JOIN cnt_contratos cnt on nuse.CNT_CONTRATO = cnt.CNT_CONTRATO
    JOIN mov_movimientos MOV on cnt.cnt_id = MOV.cnt_id
    JOIN CEX_CONTRATOS_EXPEDIENTE cex on cnt.cnt_id = cex.cnt_id
  WHERE MOV.MOV_FECHA_EXTRACCION = vFecha_Ext AND load.DESCRIPCION_TIPO_GESTION not like '%Telecobro%' and cex.cex_pase = 1; 
end;
/
COMMIT;

-- Creamos una tabla TEMPORAL que contendrá los nuevos ciclos de recobro de expedientes con sus importes
CREATE TABLE TMP_MIGRACION_NUSE_4 (
    EXP_ID      NUMBER(16), 
    RCF_ESQ_ID  NUMBER(16), 
    RCF_ESC_ID  NUMBER(16), 
    RCF_SCA_ID  NUMBER(16), 
    RCF_SUA_ID  NUMBER(16), 
    RCF_AGE_ID  NUMBER(16), 
    CRE_POS_VIVA_NO_VENCIDA NUMBER(16,2), 
    CRE_POS_VIVA_VENCIDA    NUMBER(16,2), 
    CRE_INT_ORDIN_DEVEN     NUMBER(16,2), 
    CRE_INT_MORAT_DEVEN     NUMBER(16,2), 
    CRE_COMISIONES          NUMBER(16,2), 
    CRE_GASTOS              NUMBER(16,2), 
    CRE_IMPUESTOS           NUMBER(16,2)
);

-- Cargamos la tabla temporal que contendrá los nuevos ciclos de recobro
/
declare
  vFecha_Ext DATE;  
begin		
  SELECT max(mov_fecha_extraccion) into vFecha_Ext from mov_movimientos;
  INSERT INTO TMP_MIGRACION_NUSE_4
  SELECT nuse.EXP_ID, 
    nuse.RCF_ESQ_ID,
    nuse.RCF_ESC_ID, 
    nuse.RCF_SCA_ID,
    nuse.RCF_SUA_ID,
    nuse.RCF_AGE_ID,
    SUM(NVL(MOV.MOV_POS_VIVA_NO_VENCIDA,0)),
    SUM(NVL(MOV.MOV_POS_VIVA_VENCIDA,0)),
    SUM(NVL(MOV.MOV_INT_REMUNERATORIOS,0)),
    SUM(NVL(MOV.MOV_INT_MORATORIOS,0)),
    SUM(NVL(MOV.MOV_COMISIONES,0)),
    SUM(NVL(MOV.MOV_GASTOS,0)),
    SUM(NVL(MOV.MOV_IMPUESTOS,0))
  FROM TMP_MIGRACION_NUSE_3 nuse
    JOIN TMP_MIGRACION_NUSE_1 nuse2 on nuse.EXP_ID = nuse2.EXP_ID
    JOIN LOAD_CICLOS_NUSE_STAGE_2 load on nuse2.CNT_CONTRATO = load.CNT_CONTRATO
    JOIN cnt_contratos cnt on load.CNT_CONTRATO = cnt.CNT_CONTRATO
    JOIN mov_movimientos MOV on cnt.cnt_id = MOV.cnt_id
  WHERE MOV.MOV_FECHA_EXTRACCION = vFecha_Ext
  GROUP BY nuse.EXP_ID, nuse.RCF_ESQ_ID, nuse.RCF_ESC_ID, nuse.RCF_SCA_ID, nuse.RCF_SUA_ID, nuse.RCF_AGE_ID;  
end;
/
COMMIT;

-- Cuarto paso: crear los ciclos de expedientes de recobro de expedientes
/
declare
begin		
  INSERT INTO CRE_CICLO_RECOBRO_EXP (CRE_ID, EXP_ID, CRE_FECHA_ALTA, RCF_ESQ_ID, RCF_ESC_ID, RCF_SCA_ID, RCF_SUA_ID, RCF_AGE_ID, 
    CRE_POS_VIVA_NO_VENCIDA, CRE_POS_VIVA_VENCIDA, CRE_INT_ORDIN_DEVEN, CRE_INT_MORAT_DEVEN, CRE_COMISIONES, CRE_GASTOS, 
    CRE_IMPUESTOS, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
  SELECT S_CRE_CICLO_RECOBRO_EXP.NEXTVAL, 
    TMP.EXP_ID,
    TRUNC(SYSDATE), 
    TMP.RCF_ESQ_ID, 
    TMP.RCF_ESC_ID, 
    TMP.RCF_SCA_ID, 
    TMP.RCF_SUA_ID, 
    TMP.RCF_AGE_ID, 
    TMP.CRE_POS_VIVA_NO_VENCIDA, 
    TMP.CRE_POS_VIVA_VENCIDA, 
    TMP.CRE_INT_ORDIN_DEVEN, 
    TMP.CRE_INT_MORAT_DEVEN, 
    TMP.CRE_COMISIONES, 
    TMP.CRE_GASTOS, 
    TMP.CRE_IMPUESTOS, 0, 'MIG-NUSE', sysdate, 0 
  FROM TMP_MIGRACION_NUSE_4 TMP;
end;
/
COMMIT;

-- Creamos una tabla TEMPORAL que contendrá los nuevos ciclos de recobro de contratos
CREATE TABLE TMP_MIGRACION_NUSE_5 (
  CNT_ID  NUMBER(16),
  CRE_ID  NUMBER(16),
  CRC_ID_ENVIO NUMBER(16),
  CRC_FECHA_ALTA  TIMESTAMP,
  CRC_POS_VIVA_NO_VENCIDA NUMBER(16,2), 
  CRC_POS_VIVA_VENCIDA  NUMBER(16,2),
  CRC_INT_ORDIN_DEVEN NUMBER(16,2),
  CRC_INT_MORAT_DEVEN NUMBER(16,2),
  CRC_COMISIONES  NUMBER(16,2),
  CRC_GASTOS  NUMBER(16,2), 
  CRC_IMPUESTOS NUMBER(16,2)
);

-- Cargamos la tabla temporal que contendrá los nuevos ciclos de recobro de contrato
/
declare
  vFecha_Ext DATE;  
begin		
  SELECT max(mov_fecha_extraccion) into vFecha_Ext from mov_movimientos;
  INSERT INTO TMP_MIGRACION_NUSE_5
  SELECT cnt.cnt_id, 
    cre.cre_id,
    to_number(to_char(TRUNC(sysdate), 'yyyyMMdd') || cnt.CNT_ID),
    sysdate,
    NVL(MOV.MOV_POS_VIVA_NO_VENCIDA,0),
    NVL(MOV.MOV_POS_VIVA_VENCIDA,0), 
    NVL(MOV.MOV_INT_REMUNERATORIOS,0),
    NVL(MOV.MOV_INT_MORATORIOS,0), 
    NVL(MOV.MOV_COMISIONES,0), 
    NVL(MOV.MOV_GASTOS,0), 
    NVL(MOV.MOV_IMPUESTOS,0)
  FROM TMP_MIGRACION_NUSE_1 nuse
    JOIN CRE_CICLO_RECOBRO_EXP cre on nuse.exp_id = cre.exp_id
    JOIN cnt_contratos cnt on nuse.CNT_CONTRATO = cnt.CNT_CONTRATO
    JOIN mov_movimientos MOV on cnt.cnt_id = MOV.cnt_id
    WHERE MOV.MOV_FECHA_EXTRACCION = vFecha_Ext;  
end;
/
COMMIT;

-- Quinto paso: crear los ciclos de contratos de recobro
/
declare
begin		
  INSERT INTO CRC_CICLO_RECOBRO_CNT (CRC_ID, CNT_ID, CRE_ID, CRC_ID_ENVIO, CRC_FECHA_ALTA, CRC_POS_VIVA_NO_VENCIDA, CRC_POS_VIVA_VENCIDA, 
    CRC_INT_ORDIN_DEVEN, CRC_INT_MORAT_DEVEN, CRC_COMISIONES, CRC_GASTOS, CRC_IMPUESTOS, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
  SELECT S_CRC_CICLO_RECOBRO_CNT.NEXTVAL,
    CNT_ID, 
    CRE_ID, 
    CRC_ID_ENVIO, 
    TRUNC(SYSDATE), 
    CRC_POS_VIVA_NO_VENCIDA, 
    CRC_POS_VIVA_VENCIDA, 
    CRC_INT_ORDIN_DEVEN, 
    CRC_INT_MORAT_DEVEN, 
    CRC_COMISIONES, 
    CRC_GASTOS, 
    CRC_IMPUESTOS, 0, 'MIG-NUSE', sysdate, 0 
  FROM TMP_MIGRACION_NUSE_5;
end;
/
COMMIT;

-- Creamos una tabla TEMPORAL que contendrá los nuevos ciclos de recobro de personas
CREATE TABLE TMP_MIGRACION_NUSE_6 (
  PER_ID    NUMBER(16),
  CRE_ID  NUMBER(16),
  CRP_FECHA_ALTA  TIMESTAMP,
  CRP_RIESGO_DIRECTO  NUMBER(16,2),
  CRP_RIESGO_INDIRECTO  NUMBER(16,2)
);

-- Cargamos la tabla temporal que contendrá los nuevos ciclos de recobro de personas
/
declare
begin		
  INSERT /*+ APPEND PARALLEL(TMP_MIGRACION_NUSE_6, 16) PQ_DISTRIBUTE(TMP_MIGRACION_NUSE_6, NONE) */ INTO TMP_MIGRACION_NUSE_6
  SELECT PER.PER_ID,
    cre.cre_id,
    sysdate,
    NVL(PER.PER_RIESGO, 0),
    NVL(PER.PER_RIESGO_IND, 0)
  FROM TMP_MIGRACION_NUSE_2 nuse
    JOIN CRE_CICLO_RECOBRO_EXP cre on nuse.exp_id = cre.exp_id  
    JOIN PER_PERSONAS PER ON nuse.per_id = PER.per_id;
end;
/
COMMIT;

-- Sexto paso: crear los ciclos de personas de recobro
/
declare
  vDD_AEX_ID NUMBER(16);
begin		
  INSERT /*+ APPEND PARALLEL(CRP_CICLO_RECOBRO_PER, 16) PQ_DISTRIBUTE(CRP_CICLO_RECOBRO_PER, NONE) */ INTO CRP_CICLO_RECOBRO_PER (CRP_ID, PER_ID, CRE_ID, CRP_FECHA_ALTA, CRP_RIESGO_DIRECTO, CRP_RIESGO_INDIRECTO,
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
  SELECT S_CRP_CICLO_RECOBRO_PER.NEXTVAL,
    PER_ID,
    CRE_ID,
    CRP_FECHA_ALTA,
    CRP_RIESGO_DIRECTO,
    CRP_RIESGO_INDIRECTO,
    0, 'MIG-NUSE', sysdate, 0 
  FROM TMP_MIGRACION_NUSE_6;
end;
/
COMMIT;