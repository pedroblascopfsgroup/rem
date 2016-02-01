--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20151117
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.2
--## INCIDENCIA_LINK=BKREC-1285
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

create or replace PROCEDURE PROCESA_PROCESO_FACT AUTHID CURRENT_USER AS

  CURSOR CUR_COBROS_PAGOS_FECHA (P_ID_PROCESO NUMBER) IS

  WITH PFS AS (
    SELECT PFS_ID, PRF_ID, RCF_SCA_ID
      , CASE WHEN RCF_MFA_ID_ACTUAL IS NOT NULL THEN RCF_MFA_ID_ACTUAL ELSE RCF_MFA_ID_ORIGINAL END RCF_MFA_ID
    FROM BANK01.PFS_PROC_FAC_SUBCARTERA
    WHERE BORRADO = 0
  )
  , DATOS AS (
    SELECT /*+ PARALLEL */ PFS.PFS_ID, CPR.CPA_ID, CPR.CPR_ID, CPA.CNT_ID, CPR.EXP_ID, CPR.RCF_SCA_ID, CPR.RCF_AGE_ID, CPR.CPA_FECHA, COC.RCF_DD_COC_CPA_CONCEP_IMPORT
      , CASE COC.RCF_DD_COC_CPA_CONCEP_IMPORT
          WHEN 'CPA_INTERESES_ORDINAR' THEN CPA.CPA_INTERESES_ORDINAR
          WHEN 'CPA_INTERESES_MORATOR' THEN CPA.CPA_INTERESES_MORATOR
          WHEN 'CPA_COMISIONES' THEN CPA.CPA_COMISIONES
          WHEN 'CPA_CAPITAL' THEN CPA.CPA_CAPITAL
          WHEN 'CPA_CAPITAL_NO_VENCIDO' THEN CPA.CPA_CAPITAL_NO_VENCIDO
          WHEN 'CPA_GASTOS' THEN CPA.CPA_GASTOS
          WHEN 'CPA_IMPUESTOS' THEN CPA.CPA_IMPUESTOS
          ELSE NULL
        END IMPORTE_SEGUN_CONCEPTO
      , CASE WHEN CPR.FECHA_INI_IRREGU IS NOT NULL THEN CPR.CPA_FECHA - CPR.FECHA_INI_IRREGU ELSE CPR.CPA_FECHA - CPR.FECHA_POS_VENCIDA END DIAS_EN_AGENCIA
      , TCC.RCF_TCC_ID
      , TCT.RCF_TRF_ID
      , TCT.RCF_TCT_PORCENTAJE
      , TCC.RCF_TCC_PORCENTAJE_DEFECTO
      , TCC.RCF_TCC_MIN
      , TCC.RCF_TCC_MAX
      FROM BANK01.CPR_COBROS_PAGOS_RECOBRO CPR
        JOIN BANK01.CPA_COBROS_PAGOS CPA ON CPR.CPA_ID = CPA.CPA_ID
        JOIN PFS ON CPR.RCF_SCA_ID = PFS.RCF_SCA_ID
        JOIN BANK01.PRF_PROCESO_FACTURACION PRF ON PFS.PRF_ID = PRF.PRF_ID AND PRF.BORRADO = 0
        JOIN BANK01.RCF_MFA_MODELOS_FACTURACION MFA ON PFS.RCF_MFA_ID = MFA.RCF_MFA_ID AND MFA.BORRADO = 0
        JOIN BANK01.RCF_TCF_TIPO_COBRO_FACTURA TCF ON MFA.RCF_MFA_ID = TCF.RCF_MFA_ID AND CPA.DD_SCP_ID = TCF.DD_SCP_ID AND TCF.BORRADO = 0
        JOIN BANK01.RCF_TCC_TARIFAS_CONCEP_COBRO TCC ON TCF.RCF_TCF_ID = TCC.RCF_TCF_ID AND TCC.BORRADO = 0
        JOIN BANK01.RCF_DD_COC_CONCEPTO_COBRO COC ON TCC.RCF_DD_COC_ID = COC.RCF_DD_COC_ID
        JOIN BANK01.RCF_TCT_TARIF_COBRO_TRAMO TCT ON TCC.RCF_TCC_ID = TCT.RCF_TCC_ID AND TCC.BORRADO = 0
    WHERE PRF.PRF_ID = P_ID_PROCESO AND CPR.CPA_FECHA BETWEEN PRF.PRF_FECHA_DESDE AND PRF.PRF_FECHA_HASTA
  )
  , DATOS_TRAMOS AS (
    SELECT D.PFS_ID, D.CPA_ID, D.CPR_ID, D.CNT_ID, D.EXP_ID, D.RCF_SCA_ID, D.RCF_AGE_ID, D.CPA_FECHA, D.RCF_DD_COC_CPA_CONCEP_IMPORT, D.IMPORTE_SEGUN_CONCEPTO, D.DIAS_EN_AGENCIA, D.RCF_TCC_ID, D.RCF_TCC_PORCENTAJE_DEFECTO, D.RCF_TCC_MAX, D.RCF_TCC_MIN, D.RCF_TCT_PORCENTAJE, TRF.RCF_TRF_DIAS
    FROM DATOS D
      LEFT JOIN BANK01.RCF_TRF_TRAMO_FACTURACION TRF ON D.RCF_TRF_ID = TRF.RCF_TRF_ID AND TRF.BORRADO = 0
        AND D.DIAS_EN_AGENCIA <= TRF.RCF_TRF_DIAS
  )
  , DATOS_PORCENTAJE_TRAMO AS (
    SELECT PFS_ID, CPA_ID, CPR_ID, CNT_ID, EXP_ID, RCF_SCA_ID, RCF_AGE_ID, CPA_FECHA, RCF_DD_COC_CPA_CONCEP_IMPORT, IMPORTE_SEGUN_CONCEPTO, DIAS_EN_AGENCIA, RCF_TCC_ID, RCF_TRF_DIAS
      , CASE WHEN (DIAS_EN_AGENCIA <= RCF_TRF_DIAS) THEN NVL(RCF_TCT_PORCENTAJE, RCF_TCC_PORCENTAJE_DEFECTO) ELSE RCF_TCC_PORCENTAJE_DEFECTO END PORCENTAJE_TRAMO
      , ROW_NUMBER() OVER (PARTITION BY CPA_ID, CPA_FECHA, RCF_DD_COC_CPA_CONCEP_IMPORT, IMPORTE_SEGUN_CONCEPTO, DIAS_EN_AGENCIA ORDER BY  RCF_TRF_DIAS) N
      , RCF_TCC_MIN
      , RCF_TCC_MAX
    FROM  DATOS_TRAMOS
    WHERE (DIAS_EN_AGENCIA <= RCF_TRF_DIAS OR RCF_TCC_PORCENTAJE_DEFECTO IS NOT NULL) AND IMPORTE_SEGUN_CONCEPTO <> 0
  )
  ,DATOS_CORREGIDOS AS (
    SELECT D.PFS_ID, D.CPA_ID, D.CPR_ID, D.CNT_ID, D.EXP_ID, D.RCF_SCA_ID, D.RCF_AGE_ID, D.CPA_FECHA, D.RCF_DD_COC_CPA_CONCEP_IMPORT, D.IMPORTE_SEGUN_CONCEPTO, D.DIAS_EN_AGENCIA, D.RCF_TCC_ID, D.PORCENTAJE_TRAMO
      , CASE
          WHEN (RCF_TCC_MAX IS NOT NULL AND IMPORTE_SEGUN_CONCEPTO > RCF_TCC_MAX) THEN RCF_TCC_MAX
          WHEN (RCF_TCC_MIN IS NOT NULL AND IMPORTE_SEGUN_CONCEPTO < RCF_TCC_MIN) THEN 0.0
          ELSE IMPORTE_SEGUN_CONCEPTO
        END IMPORTE_CORREGIDO
    FROM DATOS_PORCENTAJE_TRAMO D
    WHERE D.N = 1 AND PORCENTAJE_TRAMO IS NOT NULL
  )
  , RESULTADO AS (
  SELECT D.PFS_ID, D.CPA_ID, D.CPR_ID, D.CNT_ID, D.EXP_ID, D.RCF_SCA_ID, D.RCF_AGE_ID, D.CPA_FECHA, D.RCF_DD_COC_CPA_CONCEP_IMPORT, D.IMPORTE_SEGUN_CONCEPTO, D.DIAS_EN_AGENCIA, D.RCF_TCC_ID, D.PORCENTAJE_TRAMO, D.IMPORTE_CORREGIDO
    , ((IMPORTE_CORREGIDO * PORCENTAJE_TRAMO) / 100) COMISION
  FROM DATOS_CORREGIDOS D
  )
  SELECT *
  FROM RESULTADO WHERE COMISION IS NOT NULL AND COMISION <> 0
  ORDER BY CPA_ID, RCF_DD_COC_CPA_CONCEP_IMPORT;

  TYPE T_COBROS IS TABLE OF CUR_COBROS_PAGOS_FECHA%ROWTYPE INDEX BY BINARY_INTEGER;
  L_COBROS T_COBROS;
BEGIN
  -- Borramos la tabla
    BANK01.OPERACION_DDL.DDL_TABLE('TRUNCATE','TMP_RECOBRO_DETALLE_FACTURA');

  -- Inicio bucle procesos pendientes
  FOR P IN (SELECT PRF_ID
            FROM BANK01.PRF_PROCESO_FACTURACION PRF
              JOIN BANK01.RCF_DD_EPF_ESTADO_PROC_FAC EFP ON PRF.RCF_DD_EPF_ID = EFP.RCF_DD_EPF_ID
            WHERE EFP.RCF_DD_EPF_CODIGO = 'PTE' AND PRF.BORRADO = 0)
  LOOP
    -- Inicio bucle de cobros
    OPEN CUR_COBROS_PAGOS_FECHA(P.PRF_ID);
    LOOP
      FETCH CUR_COBROS_PAGOS_FECHA BULK COLLECT INTO L_COBROS LIMIT 1000;

      FORALL I IN 1..L_COBROS.COUNT
      INSERT INTO BANK01.TMP_RECOBRO_DETALLE_FACTURA(PFS_ID, CPA_ID, CNT_ID, EXP_ID, RCF_SCA_ID, RCF_AGE_ID, RDF_FECHA_COBRO, RDF_PORCENTAJE, RDF_IMPORTE_A_PAGAR, RCF_TCC_ID, RDF_IMP_CONCEP_FACTU, RDF_IMP_REAL_FACTU, CPR_ID)
      VALUES(
      L_COBROS(I).PFS_ID
      , L_COBROS(I).CPA_ID
      , L_COBROS(I).CNT_ID
      , L_COBROS(I).EXP_ID
      , L_COBROS(I).RCF_SCA_ID
      , L_COBROS(I).RCF_AGE_ID
      , L_COBROS(I).CPA_FECHA
      , L_COBROS(I).PORCENTAJE_TRAMO
      , L_COBROS(I).COMISION
      , L_COBROS(I).RCF_TCC_ID
      , L_COBROS(I).IMPORTE_SEGUN_CONCEPTO
      , L_COBROS(I).IMPORTE_CORREGIDO
      , L_COBROS(I).CPR_ID
      );

      EXIT WHEN CUR_COBROS_PAGOS_FECHA%NOTFOUND;
    END LOOP;
    CLOSE CUR_COBROS_PAGOS_FECHA;
    -- Fin bucle de cobros
    COMMIT;
  END LOOP;
  -- Fin bucle procesos pendientes
  
  
  --** CALCULO DE FACTURACION CON CORRECTORES
-------------------------------------
BANK01.OPERACION_DDL.DDL_TABLE('TRUNCATE','TMP_RECOBRO_DETALLE_FACTURA_CO');


INSERT INTO BANK01.TMP_RECOBRO_DETALLE_FACTURA_CO(PFS_ID,CPA_ID,CNT_ID,EXP_ID,RCF_SCA_ID,RCF_AGE_ID,RDF_FECHA_COBRO,RDF_PORCENTAJE,RDF_IMPORTE_A_PAGAR,RCF_TCC_ID,RDF_IMP_CONCEP_FACTU,RDF_IMP_REAL_FACTU,CPR_ID) 
with MODELO_FACT_CORRECTOR_FACT
  as (select mfa.rcf_mfa_id
           , cof.rcf_cof_ranking_posicion
           , cof.RCF_COF_COEFICIENTE
        from bank01.RCF_MFA_MODELOS_FACTURACION  mfa
           , bank01.RCF_COF_CORRECTOR_FACTURA    cof
           , bank01.RCF_DD_TCO_TIPO_CORRECTOR    tco
       where mfa.rcf_mfa_id = cof.rcf_mfa_id(+)
         and mfa.borrado = 0 and cof.borrado(+) = 0
         and mfa.rcf_dd_tco_id = tco.rcf_dd_tco_id
         and tco.rcf_dd_tco_codigo = 'RAN'
         and tco.borrado = 0)
, TMP_RECOBRO_DETALLE_FACT_MFA 
  as (select tmp.*
           , mfa.rcf_mfa_id
           , ras.ras_posicion
        from bank01.TMP_RECOBRO_DETALLE_FACTURA   tmp
           , bank01.RCF_SCA_SUBCARTERA            sca
           , bank01.RCF_MFA_MODELOS_FACTURACION   mfa
           , bank01.H_RAS_RANKING_SUBCARTERA      ras
       where tmp.rcf_sca_id = sca.rcf_sca_id
         and sca.rcf_mfa_id = mfa.rcf_mfa_id
         and mfa.borrado = 0
         and tmp.rcf_sca_id = ras.rcf_sca_id(+)
         and tmp.rcf_age_id = ras.rcf_age_id(+)
         and last_day(tmp.rdf_fecha_cobro) = ras.fecha_hist(+))
     select 
       tmp.PFS_ID
     , tmp.CPA_ID
     , tmp.CNT_ID
     , tmp.EXP_ID
     , tmp.RCF_SCA_ID
     , tmp.RCF_AGE_ID
     , tmp.RDF_FECHA_COBRO    
     , tmp.RDF_PORCENTAJE + nvl(cof.RCF_COF_COEFICIENTE,0) as RDF_PORCENTAJE
     , tmp.RDF_IMP_REAL_FACTU * ( tmp.RDF_PORCENTAJE + nvl(cof.RCF_COF_COEFICIENTE,0)) / 100 as RDF_IMPORTE_A_PAGAR
     , tmp.RCF_TCC_ID
     , tmp.RDF_IMP_CONCEP_FACTU
     , tmp.RDF_IMP_REAL_FACTU
     , tmp.CPR_ID
  from TMP_RECOBRO_DETALLE_FACT_MFA  tmp
     , MODELO_FACT_CORRECTOR_FACT    cof
 where tmp.ras_posicion = cof.rcf_cof_ranking_posicion(+)
   and tmp.rcf_mfa_id = cof.rcf_mfa_id(+);
commit;
  
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: '||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.PUT_LINE(SQLERRM);

    ROLLBACK;
    RAISE;
END PROCESA_PROCESO_FACT;
/ 

EXIT;
