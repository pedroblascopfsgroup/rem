--/*
--##########################################
--## AUTOR=David González
--## FECHA_CREACION=20151002
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
create or replace PROCEDURE RERA_PRECAL_ARQUET_1 AS

  ql_stmt   VARCHAR2(2000);
  empty_tb  EXCEPTION;
  v_table   VARCHAR2(30);

BEGIN

  /*TRUNCATE*/
  ql_stmt := 'TRUNCATE TABLE #ESQUEMA#.PER_PRECALCULO_ARQ';
  EXECUTE IMMEDIATE ql_stmt;

  /*INSERTAMOS TODAS LAS PERSONAS*/
  ql_stmt := 'INSERT INTO #ESQUEMA#.PER_PRECALCULO_ARQ
  (PER_COD_CLIENTE_ENTIDAD, PER_DEUDA_DESC, PER_DOMIC_EXT, TITULAR, SERV_NOMINA_PENSION, PER_DEUDA_IRREGULAR_HIPO, MAX_DIAS_IRREGULAR, DD_TCN_ID)
  SELECT DISTINCT TMP.TMP_CNT_PER_COD_PERSONA, 0, 0, 0, 0, 0, 0, 0
    FROM #ESQUEMA#.TMP_CNT_PER TMP';
  EXECUTE IMMEDIATE ql_stmt;

  /*CONTROL DE INFORMACION*/
  IF SQL%ROWCOUNT = 0 THEN
     v_table := 'PER_PRECALCULO_ARQ';
     RAISE empty_tb;
  END IF;


  /*ACTUALIZAMOS LOS TITULARES */
  MERGE INTO #ESQUEMA#.PER_PRECALCULO_ARQ g USING(
  SELECT /*+ MATERIALIZE */ DISTINCT TMP.TMP_CNT_PER_COD_PERSONA
  FROM #ESQUEMA#.TMP_CNT_PER TMP
  WHERE TMP.TMP_CNT_PER_TIPO_INTERVENCION IN (SELECT DD_TIN_ID
    FROM #ESQUEMA#.DD_TIN_TIPO_INTERVENCION WHERE DD_TIN_TITULAR = 1)
  ) t
  ON (g.PER_COD_CLIENTE_ENTIDAD = t.TMP_CNT_PER_COD_PERSONA)
  WHEN MATCHED THEN
  UPDATE SET g.TITULAR = 1;

  /* ACTUALIZAMOS LOS PER_DOMIC_EXT */
  MERGE INTO #ESQUEMA#.PER_PRECALCULO_ARQ g USING(
  SELECT /*+ MATERIALIZE */ DISTINCT TMP.TMP_CNT_PER_COD_PERSONA
  FROM #ESQUEMA#.TMP_CNT_PER TMP
  JOIN #ESQUEMA#.TMP_CNT_CONTRATOS CNT ON TMP.TMP_CNT_PER_CODIGO_CNT50 = CNT.TMP_CNT_CODIGO_CNT50
    AND CNT.TMP_CNT_DEUDA_IRREGULAR > 0 AND CNT.TMP_CNT_IND_DOMICI_EXTERNA = '1'
  ) t
  ON (g.PER_COD_CLIENTE_ENTIDAD = t.TMP_CNT_PER_COD_PERSONA)
  WHEN MATCHED THEN
  UPDATE SET g.PER_DOMIC_EXT = 1;

  /* ACTUALIZAMOS LOS PER_DEUDA_DESC*/
	MERGE INTO #ESQUEMA#.PER_PRECALCULO_ARQ g USING(
	 WITH DD_APO AS (
	  SELECT DD_APO_CODIGO FROM #ESQUEMA#.DD_APO_APLICATIVO_ORIGEN WHERE DD_APO_ID IN (1, 2)
	)
	, DD_TIN AS (
	  SELECT DD_TIN_CODIGO FROM #ESQUEMA#.DD_TIN_TIPO_INTERVENCION WHERE DD_TIN_TITULAR = 1
	)
	, RELACIONES AS (
	  SELECT DISTINCT TMP_CNT_PER_COD_PERSONA
		, CASE WHEN DD_APO.DD_APO_CODIGO IS NOT NULL THEN 1 ELSE 0 END IS_DESC
		, CASE WHEN DD_TIN.DD_TIN_CODIGO IS NOT NULL THEN 1 ELSE 0 END IS_TIT
	  FROM #ESQUEMA#.TMP_CNT_PER TMP
		JOIN #ESQUEMA#.TMP_CNT_CONTRATOS CNT ON TMP.TMP_CNT_PER_CODIGO_CNT50 = CNT.TMP_CNT_CODIGO_CNT50
		LEFT JOIN DD_APO ON CNT.TMP_CNT_APLICATIVO_ORIGEN = DD_APO.DD_APO_CODIGO
		LEFT JOIN DD_TIN ON TMP_CNT_PER_TIPO_INTERVENCION = DD_TIN.DD_TIN_CODIGO
	  WHERE TMP_CNT_DEUDA_IRREGULAR > 0
	)
	SELECT DISTINCT TMP_CNT_PER_COD_PERSONA
	FROM RELACIONES WHERE IS_DESC = 1 AND IS_TIT = 1
	MINUS
	SELECT DISTINCT TMP_CNT_PER_COD_PERSONA
	FROM RELACIONES WHERE IS_DESC = 0 AND IS_TIT = 1
	  ) t
	  ON (g.PER_COD_CLIENTE_ENTIDAD = t.TMP_CNT_PER_COD_PERSONA)
	  WHEN MATCHED THEN
	  UPDATE SET g.PER_DEUDA_DESC = 1;

  /* ACTUALIZAMOS EL SERV_NOMINA_PENSION y DD_TCN_ID (TIPO CNAE) */
  MERGE INTO #ESQUEMA#.PER_PRECALCULO_ARQ g USING(
  SELECT /*+ MATERIALIZE */
        DISTINCT TMP.TMP_PER_COD_PERSONA
       , TMP.TMP_PER_SERV_NOMINA_PENSION
       , TCN.DD_TCN_ID
    FROM #ESQUEMA#.TMP_PER_PERSONAS TMP
       , #ESQUEMA_MASTER#..DD_TCN_TIPO_CNAE TCN
   WHERE TMP.TMP_PER_CHAR_EXTRA1 = TCN.DD_TCN_CODIGO(+)
  ) t
  ON (g.PER_COD_CLIENTE_ENTIDAD = t.TMP_PER_COD_PERSONA)
  WHEN MATCHED THEN
  UPDATE SET g.SERV_NOMINA_PENSION = (CASE WHEN t.TMP_PER_SERV_NOMINA_PENSION = '1' THEN 1 ELSE 0 END)
           , g.DD_TCN_ID = t.DD_TCN_ID;

  /* ACTUALIZAMOS EL PER_DEUDA_IRREGULAR_HIPO*/
  MERGE INTO #ESQUEMA#.PER_PRECALCULO_ARQ g USING(
  SELECT /*+ MATERIALIZE */ DISTINCT TMP.TMP_CNT_PER_COD_PERSONA, SUM(CNT.TMP_CNT_DEUDA_IRREGULAR) AS PER_DEUDA_IRREGULAR_HIPO
  FROM #ESQUEMA#.TMP_CNT_PER TMP
  JOIN #ESQUEMA#.TMP_CNT_CONTRATOS CNT ON TMP.TMP_CNT_PER_CODIGO_CNT50 = CNT.TMP_CNT_CODIGO_CNT50
  WHERE CNT.TMP_CNT_NUM_EXTRA2 = 106
  GROUP BY TMP.TMP_CNT_PER_COD_PERSONA
  ) t
  ON (g.PER_COD_CLIENTE_ENTIDAD = t.TMP_CNT_PER_COD_PERSONA)
  WHEN MATCHED THEN
  UPDATE SET g.PER_DEUDA_IRREGULAR_HIPO = t.PER_DEUDA_IRREGULAR_HIPO;

  /* ACTUALIZAMOS EL MAX_DIAS_IRREGULAR*/
  MERGE INTO #ESQUEMA#.PER_PRECALCULO_ARQ g USING(
    SELECT TMP_CNT_PER.TMP_CNT_PER_COD_PERSONA, ROUND(SYSDATE - min(TMP_CNT_CONTRATOS.TMP_CNT_FECHA_INI_EPI_IRREG)) MAX_DIAS_IRREGULAR
  FROM #ESQUEMA#.TMP_CNT_PER
    inner join #ESQUEMA#.DD_TIN_TIPO_INTERVENCION TIN on TMP_CNT_PER.TMP_CNT_PER_TIPO_INTERVENCION = TIN.DD_TIN_CODIGO
    inner join #ESQUEMA#.TMP_CNT_CONTRATOS on TMP_CNT_PER.TMP_CNT_PER_CODIGO_CNT50 = TMP_CNT_CONTRATOS.TMP_CNT_CODIGO_CNT50
  where TIN.DD_TIN_TITULAR = 1
  and TMP_CNT_CONTRATOS.TMP_CNT_FECHA_INI_EPI_IRREG is not null
  group by TMP_CNT_PER.TMP_CNT_PER_COD_PERSONA
  ) t
  ON (g.PER_COD_CLIENTE_ENTIDAD = t.TMP_CNT_PER_COD_PERSONA)
  WHEN MATCHED THEN
  UPDATE SET g.MAX_DIAS_IRREGULAR = t.MAX_DIAS_IRREGULAR;

  /******* Viene del RERA_PRECAL_ARQUET_2 ******************/

  /*TRUNCATE*/
  ql_stmt := 'TRUNCATE TABLE #ESQUEMA#.CNT_PRECALCULO_ARQ';
  EXECUTE IMMEDIATE ql_stmt;

  /*ACTUALIZAMOS LAS VARIABLES DE CONTRATOS*/
  MERGE INTO #ESQUEMA#.CNT_PRECALCULO_ARQ g USING(
  SELECT /*+ MATERIALIZE */ DISTINCT TMP.TMP_CNT_CODIGO_CNT50 AS CNT_CONTRATO,
    (SELECT DD_ECE_ID FROM #ESQUEMA#.DD_ECE_ESTADO_CONTRATO_ENTIDAD
    WHERE DD_ECE_CODIGO = TMP.TMP_ESTADO_CONTRATO) AS DD_ECE_ID,
    (SELECT DD_SEC_ID FROM #ESQUEMA#.DD_SEC_SEGMENTO_CARTERA
    WHERE DD_SEC_CODIGO = TMP.TMP_CNT_NUM_EXTRA2) AS SEGMENTO_CARTERA,
    SUBSTR(TMP.TMP_CNT_CHAR_EXTRA1, 1, 4) AS IAC_PROPIETARIO
  FROM #ESQUEMA#.TMP_CNT_CONTRATOS TMP
  ) t
  ON (g.CNT_CONTRATO = t.CNT_CONTRATO)
  WHEN MATCHED THEN
  UPDATE SET g.DD_ECE_ID = t.DD_ECE_ID,
    g.IAC_PROPIETARIO = t.IAC_PROPIETARIO,
    g.SEGMENTO_CARTERA = t.SEGMENTO_CARTERA
  WHEN NOT MATCHED THEN
  INSERT(CNT_CONTRATO, DD_ECE_ID, IAC_PROPIETARIO, SEGMENTO_CARTERA)
  VALUES (t.CNT_CONTRATO, t.DD_ECE_ID, t.IAC_PROPIETARIO, t.SEGMENTO_CARTERA);

  /*CONTROL DE INFORMACION*/
  IF SQL%ROWCOUNT = 0 THEN
     v_table := 'CNT_PRECALCULO_ARQ';
     RAISE empty_tb;
  END IF;

  /*ACTUALIZAMOS LA VARIABLES DE CONTRATOS: CNT_DIAS_IRREGULAR_HIPO, DD_IDN_ID (NOMINA o PENSION) y DD_MRF_ID / DD_MOM_ID (MARCA REFINANCIACION Y MOTIVO)*/
  MERGE INTO #ESQUEMA#.CNT_PRECALCULO_ARQ g USING
  (
  SELECT /*+ MATERIALIZE */ DISTINCT TMP.TMP_CNT_CODIGO_CNT50 AS CNT_CONTRATO
       , (CASE WHEN TMP_CNT_NUM_EXTRA2 = 106
                AND TMP.TMP_CNT_FECHA_POS_VENCIDA IS NOT NULL
                 THEN TRUNC(SYSDATE - TMP.TMP_CNT_FECHA_POS_VENCIDA)
	             ELSE NULL
         END) AS CNT_DIAS_IRREGULAR_HIPO
       , IDN.DD_IDN_ID
       , MRF.DD_MRF_ID
       , MOM.DD_MOM_ID
    FROM #ESQUEMA#.TMP_CNT_CONTRATOS TMP
       , #ESQUEMA_MASTER#..DD_IDN_INDICADOR_NOMINA IDN
       , #ESQUEMA_MASTER#..DD_MRF_MARCA_REFINANCIACION MRF
       , #ESQUEMA_MASTER#..DD_MOM_MOTIVO_MARCA_R MOM
   WHERE TO_CHAR(TMP.TMP_CNT_NUM_EXTRA4) = IDN.DD_IDN_CODIGO(+)
     AND TMP.TMP_CNT_CHAR_EXTRA9 = MRF.DD_MRF_CODIGO(+)
     AND TMP.TMP_CNT_CHAR_EXTRA10 = MOM.DD_MOM_CODIGO(+)
  ) t
  ON (g.CNT_CONTRATO = t.CNT_CONTRATO)
  WHEN MATCHED
    THEN UPDATE
         SET g.CNT_DIAS_IRREGULAR_HIPO = t.CNT_DIAS_IRREGULAR_HIPO
           , g.DD_IDN_ID = t.DD_IDN_ID
           , g.DD_MRF_ID = t.DD_MRF_ID
           , g.DD_MOM_ID = t.DD_MOM_ID;


  /******* Viene del RERA_PRECAL_ARQUET_3 ******************/

  /*TRUNCATE*/
  ql_stmt := 'TRUNCATE TABLE #ESQUEMA#.PER_PRECALCULO_PERSISTENCIA';
  EXECUTE IMMEDIATE ql_stmt;

  /*INSERT PERSISTENCIA PERSONAS*/
  ql_stmt := 'INSERT INTO #ESQUEMA#.PER_PRECALCULO_PERSISTENCIA
  SELECT TMP_PER_COD_PERSONA AS PER_COD_CLIENTE_ENTIDAD,
  TMP_PER_SERV_NOMINA_PENSION,
  TMP_PER_ULTIMA_ACTUACION,
  TMP_PER_COD_ENT_OFI_GESTORA,
  TMP_PER_COD_OFICINA_GESTORA,
  TMP_PER_COD_SUBSEC_OFI_GESTORA,
  TMP_NUM_EXTRA1,
  TMP_NUM_EXTRA2,
  TMP_NUM_EXTRA3,
  TMP_NUM_EXTRA4,
  TMP_NUM_EXTRA5,
  TMP_NUM_EXTRA6,
  TMP_NUM_EXTRA7,
  TMP_NUM_EXTRA8,
  TMP_NUM_EXTRA9,
  TMP_NUM_EXTRA10,
  TMP_PER_CHAR_EXTRA1,
  TMP_PER_CHAR_EXTRA2,
  TMP_PER_CHAR_EXTRA3,
  TMP_PER_CHAR_EXTRA4,
  TMP_PER_CHAR_EXTRA5,
  TMP_PER_FLAG_EXTRA1,
  TMP_PER_FLAG_EXTRA2,
  TMP_PER_FLAG_EXTRA3,
  TMP_PER_FLAG_EXTRA4,
  TMP_PER_FLAG_EXTRA5,
  TMP_PER_FLAG_EXTRA6,
  TMP_PER_FLAG_EXTRA7,
  TMP_PER_FLAG_EXTRA8,
  TMP_PER_FLAG_EXTRA9,
  TMP_PER_FLAG_EXTRA10,
  TMP_PER_DATE_EXTRA1,
  TMP_PER_DATE_EXTRA2,
  TMP_PER_DATE_EXTRA3,
  TMP_PER_DATE_EXTRA4,
  TMP_PER_DATE_EXTRA5,
  TMP_PER_DATE_EXTRA6,
  TMP_PER_DATE_EXTRA7,
  TMP_PER_DATE_EXTRA8,
  TMP_PER_DATE_EXTRA9,
  TMP_PER_DATE_EXTRA10
  FROM #ESQUEMA#.TMP_PER_PERSONAS';
  EXECUTE IMMEDIATE ql_stmt;

  /*CONTROL DE INFORMACION*/
  IF SQL%ROWCOUNT = 0 THEN
     v_table := 'PER_PRECALCULO_PERSISTENCIA';
     RAISE empty_tb;
  END IF;

  /******* Viene del RERA_PRECAL_ARQUET_4 ******************/

  /*TRUNCATE*/
  ql_stmt := 'TRUNCATE TABLE #ESQUEMA#.CNT_PRECALCULO_PERSISTENCIA';
  EXECUTE IMMEDIATE ql_stmt;

  /*INSERT PERSISTENCIA CONTRATOS*/
  ql_stmt := 'INSERT INTO #ESQUEMA#.CNT_PRECALCULO_PERSISTENCIA
  SELECT TMP_CNT_CODIGO_CNT50 AS CNT_CONTRATO,
  TMP_CNT_CODIGO_PROPIETARIO,
  TMP_CNT_TIPO_PRODUCTO,
  TMP_CNT_CONTRATO,
  TMP_CNT_NUM_ESPEC,
  TMP_CNT_NUM_EXTRA1,
  TMP_CNT_NUM_EXTRA2,
  TMP_CNT_NUM_EXTRA3,
  TMP_CNT_NUM_EXTRA4,
  TMP_CNT_NUM_EXTRA5,
  TMP_CNT_NUM_EXTRA6,
  TMP_CNT_NUM_EXTRA7,
  TMP_CNT_NUM_EXTRA8,
  TMP_CNT_NUM_EXTRA9,
  TMP_CNT_NUM_EXTRA10,
  TMP_CNT_CHAR_EXTRA1,
  TMP_CNT_CHAR_EXTRA2,
  TMP_CNT_CHAR_EXTRA3,
  TMP_CNT_CHAR_EXTRA4,
  TMP_CNT_CHAR_EXTRA5,
  TMP_CNT_FLAG_EXTRA1,
  TMP_CNT_FLAG_EXTRA2,
  TMP_CNT_FLAG_EXTRA3,
  TMP_CNT_FLAG_EXTRA4,
  TMP_CNT_FLAG_EXTRA5,
  TMP_CNT_FLAG_EXTRA6,
  TMP_CNT_FLAG_EXTRA7,
  TMP_CNT_FLAG_EXTRA8,
  TMP_CNT_FLAG_EXTRA9,
  TMP_CNT_FLAG_EXTRA10,
  TMP_CNT_DATE_EXTRA1,
  TMP_CNT_DATE_EXTRA2,
  TMP_CNT_DATE_EXTRA3,
  TMP_CNT_DATE_EXTRA4,
  TMP_CNT_DATE_EXTRA5,
  TMP_CNT_DATE_EXTRA6,
  TMP_CNT_DATE_EXTRA7,
  TMP_CNT_DATE_EXTRA8,
  TMP_CNT_DATE_EXTRA9,
  TMP_CNT_DATE_EXTRA10
  FROM #ESQUEMA#.TMP_CNT_CONTRATOS';
  EXECUTE IMMEDIATE ql_stmt;

  /*CONTROL DE INFORMACION*/
  IF SQL%ROWCOUNT = 0 THEN
     v_table := 'CNT_PRECALCULO_PERSISTENCIA';
     RAISE empty_tb;
  END IF;

EXCEPTION

  WHEN empty_tb THEN
    rollback;
    dbms_output.put_line('La tabla '''||v_table||''' no contiene datos.');
    raise_application_error(-20001,'La tabla '''||v_table||''' no contiene datos.');

END RERA_PRECAL_ARQUET_1;
