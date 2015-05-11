create or replace PROCEDURE RERA_PRECAL_ARQUET_1 AS
  ql_stmt VARCHAR2(2000);
BEGIN

  /*TRUNCATE*/
  ql_stmt := 'TRUNCATE TABLE BANK01.PER_PRECALCULO_ARQ';
  EXECUTE IMMEDIATE ql_stmt;

  /*INSERTAMOS TODAS LAS PERSONAS*/
  ql_stmt := 'INSERT INTO BANK01.PER_PRECALCULO_ARQ
  SELECT DISTINCT TMP.TMP_CNT_PER_COD_PERSONA, 0, 0, 0, 0, 0, 0 FROM BANK01.TMP_CNT_PER TMP';
  EXECUTE IMMEDIATE ql_stmt;

  /*ACTUALIZAMOS LOS TITULARES */
  MERGE INTO BANK01.PER_PRECALCULO_ARQ g USING(
  SELECT /*+ MATERIALIZE */ DISTINCT TMP.TMP_CNT_PER_COD_PERSONA
  FROM BANK01.TMP_CNT_PER TMP
  WHERE TMP.TMP_CNT_PER_TIPO_INTERVENCION IN (SELECT DD_TIN_ID
    FROM BANK01.DD_TIN_TIPO_INTERVENCION WHERE DD_TIN_TITULAR = 1)
  ) t
  ON (g.PER_COD_CLIENTE_ENTIDAD = t.TMP_CNT_PER_COD_PERSONA)
  WHEN MATCHED THEN
  UPDATE SET g.TITULAR = 1;

  /* ACTUALIZAMOS LOS PER_DOMIC_EXT */
  MERGE INTO BANK01.PER_PRECALCULO_ARQ g USING(
  SELECT /*+ MATERIALIZE */ DISTINCT TMP.TMP_CNT_PER_COD_PERSONA
  FROM BANK01.TMP_CNT_PER TMP
  JOIN BANK01.TMP_CNT_CONTRATOS CNT ON TMP.TMP_CNT_PER_CODIGO_CNT50 = CNT.TMP_CNT_CODIGO_CNT50
    AND CNT.TMP_CNT_DEUDA_IRREGULAR > 0 AND CNT.TMP_CNT_IND_DOMICI_EXTERNA = '1'
  ) t
  ON (g.PER_COD_CLIENTE_ENTIDAD = t.TMP_CNT_PER_COD_PERSONA)
  WHEN MATCHED THEN
  UPDATE SET g.PER_DOMIC_EXT = 1;

  /* ACTUALIZAMOS LOS PER_DEUDA_DESC*/
	MERGE INTO BANK01.PER_PRECALCULO_ARQ g USING(
	 WITH DD_APO AS (
	  SELECT DD_APO_CODIGO FROM BANK01.DD_APO_APLICATIVO_ORIGEN WHERE DD_APO_ID IN (1, 2)
	)
	, DD_TIN AS (
	  SELECT DD_TIN_CODIGO FROM BANK01.DD_TIN_TIPO_INTERVENCION WHERE DD_TIN_TITULAR = 1
	)
	, RELACIONES AS (
	  SELECT DISTINCT TMP_CNT_PER_COD_PERSONA
		, CASE WHEN DD_APO.DD_APO_CODIGO IS NOT NULL THEN 1 ELSE 0 END IS_DESC
		, CASE WHEN DD_TIN.DD_TIN_CODIGO IS NOT NULL THEN 1 ELSE 0 END IS_TIT
	  FROM BANK01.TMP_CNT_PER TMP
		JOIN BANK01.TMP_CNT_CONTRATOS CNT ON TMP.TMP_CNT_PER_CODIGO_CNT50 = CNT.TMP_CNT_CODIGO_CNT50
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

  /* ACTUALIZAMOS EL SERV_NOMINA_PENSION*/
  MERGE INTO BANK01.PER_PRECALCULO_ARQ g USING(
  SELECT /*+ MATERIALIZE */ DISTINCT TMP.TMP_PER_COD_PERSONA, TMP.TMP_PER_SERV_NOMINA_PENSION
  FROM BANK01.TMP_PER_PERSONAS TMP
  ) t
  ON (g.PER_COD_CLIENTE_ENTIDAD = t.TMP_PER_COD_PERSONA)
  WHEN MATCHED THEN
  UPDATE SET g.SERV_NOMINA_PENSION = (CASE WHEN t.TMP_PER_SERV_NOMINA_PENSION = '1' THEN 1 ELSE 0 END);

  /* ACTUALIZAMOS EL PER_DEUDA_IRREGULAR_HIPO*/
  MERGE INTO BANK01.PER_PRECALCULO_ARQ g USING(
  SELECT /*+ MATERIALIZE */ DISTINCT TMP.TMP_CNT_PER_COD_PERSONA, SUM(CNT.TMP_CNT_DEUDA_IRREGULAR) AS PER_DEUDA_IRREGULAR_HIPO
  FROM BANK01.TMP_CNT_PER TMP
  JOIN BANK01.TMP_CNT_CONTRATOS CNT ON TMP.TMP_CNT_PER_CODIGO_CNT50 = CNT.TMP_CNT_CODIGO_CNT50
  WHERE CNT.TMP_CNT_NUM_EXTRA2 = 106
  GROUP BY TMP.TMP_CNT_PER_COD_PERSONA
  ) t
  ON (g.PER_COD_CLIENTE_ENTIDAD = t.TMP_CNT_PER_COD_PERSONA)
  WHEN MATCHED THEN
  UPDATE SET g.PER_DEUDA_IRREGULAR_HIPO = t.PER_DEUDA_IRREGULAR_HIPO;

  /* ACTUALIZAMOS EL MAX_DIAS_IRREGULAR*/
  MERGE INTO BANK01.PER_PRECALCULO_ARQ g USING(
    SELECT TMP_CNT_PER.TMP_CNT_PER_COD_PERSONA, ROUND(SYSDATE - min(TMP_CNT_CONTRATOS.TMP_CNT_FECHA_INI_EPI_IRREG)) MAX_DIAS_IRREGULAR
  FROM TMP_CNT_PER
    inner join DD_TIN_TIPO_INTERVENCION TIN on TMP_CNT_PER.TMP_CNT_PER_TIPO_INTERVENCION = TIN.DD_TIN_CODIGO
    inner join TMP_CNT_CONTRATOS on TMP_CNT_PER.TMP_CNT_PER_CODIGO_CNT50 = TMP_CNT_CONTRATOS.TMP_CNT_CODIGO_CNT50
  where TIN.DD_TIN_TITULAR = 1
  and TMP_CNT_CONTRATOS.TMP_CNT_FECHA_INI_EPI_IRREG is not null
  group by TMP_CNT_PER.TMP_CNT_PER_COD_PERSONA
  ) t
  ON (g.PER_COD_CLIENTE_ENTIDAD = t.TMP_CNT_PER_COD_PERSONA)
  WHEN MATCHED THEN
  UPDATE SET g.MAX_DIAS_IRREGULAR = t.MAX_DIAS_IRREGULAR;

  /******* Viene del RERA_PRECAL_ARQUET_2 ******************/

  /*TRUNCATE*/
  ql_stmt := 'TRUNCATE TABLE BANK01.CNT_PRECALCULO_ARQ';
  EXECUTE IMMEDIATE ql_stmt;

  /*ACTUALIZAMOS LAS VARIABLES DE CONTRATOS*/
  MERGE INTO BANK01.CNT_PRECALCULO_ARQ g USING(
  SELECT /*+ MATERIALIZE */ DISTINCT TMP.TMP_CNT_CODIGO_CNT50 AS CNT_CONTRATO,
    (SELECT DD_ECE_ID FROM BANK01.DD_ECE_ESTADO_CONTRATO_ENTIDAD
    WHERE DD_ECE_CODIGO = TMP.TMP_ESTADO_CONTRATO) AS DD_ECE_ID,
    (SELECT DD_SEC_ID FROM BANK01.DD_SEC_SEGMENTO_CARTERA
    WHERE DD_SEC_CODIGO = TMP.TMP_CNT_NUM_EXTRA2) AS SEGMENTO_CARTERA,
    SUBSTR(TMP.TMP_CNT_CHAR_EXTRA1, 1, 4) AS IAC_PROPIETARIO
  FROM BANK01.TMP_CNT_CONTRATOS TMP
  ) t
  ON (g.CNT_CONTRATO = t.CNT_CONTRATO)
  WHEN MATCHED THEN
  UPDATE SET g.DD_ECE_ID = t.DD_ECE_ID,
    g.IAC_PROPIETARIO = t.IAC_PROPIETARIO,
    g.SEGMENTO_CARTERA = t.SEGMENTO_CARTERA
  WHEN NOT MATCHED THEN
  INSERT(CNT_CONTRATO, DD_ECE_ID, IAC_PROPIETARIO, SEGMENTO_CARTERA)
  VALUES (t.CNT_CONTRATO, t.DD_ECE_ID, t.IAC_PROPIETARIO, t.SEGMENTO_CARTERA);

  /*ACTUALIZAMOS LA VARIABLE CNT_DIAS_IRREGULAR_HIPO DE CONTRATOS*/
  MERGE INTO BANK01.CNT_PRECALCULO_ARQ g USING(
  SELECT /*+ MATERIALIZE */ DISTINCT TMP.TMP_CNT_CODIGO_CNT50 AS CNT_CONTRATO,
    (CASE WHEN TMP.TMP_CNT_FECHA_POS_VENCIDA IS NOT NULL THEN TRUNC(SYSDATE - TMP.TMP_CNT_FECHA_POS_VENCIDA)
	ELSE NULL END) AS CNT_DIAS_IRREGULAR_HIPO
  FROM BANK01.TMP_CNT_CONTRATOS TMP
  WHERE TMP.TMP_CNT_NUM_EXTRA2 = 106
  ) t
  ON (g.CNT_CONTRATO = t.CNT_CONTRATO)
  WHEN MATCHED THEN
  UPDATE SET g.CNT_DIAS_IRREGULAR_HIPO = t.CNT_DIAS_IRREGULAR_HIPO;


  /******* Viene del RERA_PRECAL_ARQUET_3 ******************/

  /*TRUNCATE*/
  ql_stmt := 'TRUNCATE TABLE BANK01.PER_PRECALCULO_PERSISTENCIA';
  EXECUTE IMMEDIATE ql_stmt;

  /*INSERT PERSISTENCIA PERSONAS*/
  ql_stmt := 'INSERT INTO BANK01.PER_PRECALCULO_PERSISTENCIA
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
  FROM BANK01.TMP_PER_PERSONAS';
  EXECUTE IMMEDIATE ql_stmt;

  /******* Viene del RERA_PRECAL_ARQUET_4 ******************/

  /*TRUNCATE*/
  ql_stmt := 'TRUNCATE TABLE BANK01.CNT_PRECALCULO_PERSISTENCIA';
  EXECUTE IMMEDIATE ql_stmt;

  /*INSERT PERSISTENCIA CONTRATOS*/
  ql_stmt := 'INSERT INTO BANK01.CNT_PRECALCULO_PERSISTENCIA
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
  FROM BANK01.TMP_CNT_CONTRATOS';
  EXECUTE IMMEDIATE ql_stmt;

END RERA_PRECAL_ARQUET_1;
