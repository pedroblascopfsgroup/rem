--Truncado de tablas TDX
TRUNCATE TABLE MINIREC.VAL_PROC_JUDICIAL_FOTO;

--Generacion de las tablas TDX
INSERT INTO MINIREC.VAL_PROC_JUDICIAL_FOTO
  (
ASU_ID
,ASU_NOMBRE
,ID_PROCEDIMIENTO
,ID_PROCEDIMIENTO_PADRE
,ENTI
,ENTIDAD
,SERVICER
,TIPO_PROCEDIMIENTO
,FECHA_ALTA
,FECHA_DEMANDA
,FECHA_CIERRE
,MOTIVO_CIERRE
,AUTO
,HITO_CODIGO
,HITO_DESCR
,FECHA_HITO
,IMPORTE_DEMANDA_TOTAL
  )
WITH 
ULT_PROC_PADRE AS (
  SELECT  PRC_ID, ASU_ID
  FROM (
    SELECT PRC.PRC_ID, PRC.ASU_ID
    ,ROW_NUMBER() OVER (PARTITION BY PRC.ASU_ID ORDER BY PRC.PRC_ID DESC) PROC_NUM
    FROM HAYA01.PRC_PROCEDIMIENTOS PRC
    INNER JOIN HAYA01.ASU_ASUNTOS ASU ON ASU.ASU_ID=PRC.ASU_ID
      INNER JOIN HAYA01.DD_TPO_TIPO_PROCEDIMIENTO TPO ON PRC.DD_TPO_ID = TPO.DD_TPO_ID
      INNER JOIN HAYA01.DD_TAC_TIPO_ACTUACION TAC ON  TAC.DD_TAC_ID=PRC.DD_TAC_ID
    WHERE(
           UPPER(TPO.DD_TPO_CODIGO) LIKE 'H001'
           OR UPPER(TPO.DD_TPO_CODIGO) LIKE 'H018'
           OR UPPER(TPO.DD_TPO_CODIGO) LIKE 'H020'
           OR UPPER(TPO.DD_TPO_CODIGO) LIKE 'H022'
           OR UPPER(TPO.DD_TPO_CODIGO) LIKE 'H024'
           OR UPPER(TPO.DD_TPO_CODIGO) LIKE 'H026'
           OR UPPER(TPO.DD_TPO_CODIGO) LIKE 'H028'  
       )
    AND ( TAC.DD_TAC_CODIGO <> 'PCO'
        OR NOT EXISTS(
            SELECT 1 FROM HAYA01.PRC_PROCEDIMIENTOS PRC2
            WHERE PRC2.ASU_ID=PRC.ASU_ID
            AND PRC2.PRC_ID <>PRC.PRC_ID
        )
    )
    AND ASU.BORRADO = 0 
    AND PRC.BORRADO = 0    
    )
  WHERE PROC_NUM = 1
),
ULTIMO_PROC_ASUNTO AS (
	SELECT ASU_ID, PRC_ID
	FROM (
	  SELECT ASU.ASU_ID, PRC.PRC_ID, ROW_NUMBER () OVER (PARTITION BY ASU.ASU_ID ORDER BY PRC.PRC_ID DESC) RN
	  FROM HAYA01.ASU_ASUNTOS ASU
	  INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON PRC.ASU_ID = ASU.ASU_ID
	  WHERE ASU.BORRADO = 0 AND PRC.BORRADO = 0 
    AND PRC.PRC_ID NOT IN(
        SELECT PRC2.PRC_ID FROM HAYA01.PRC_PROCEDIMIENTOS PRC2
        WHERE PRC2.DD_TAC_ID=(SELECT DD_TAC_ID FROM HAYA01.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO LIKE 'PCO')
        AND NOT EXISTS(
          SELECT 1 FROM HAYA01.PRC_PROCEDIMIENTOS PRC3
          WHERE PRC3.ASU_ID=PRC2.ASU_ID
          AND PRC3.PRC_ID <>PRC2.PRC_ID
    ))
  ) TMP_AP
	WHERE RN = 1
),
TAR AS(
SELECT  TMP.ASU_ID, TMP.HITO_DESCR, TMP.HITO_CODIGO, TMP.FECHA_DEMANDA, TMP.FECHA_HITO,TMP.FECHA_CIERRE,TMP.MOTIVO_CIERRE
FROM(
    SELECT 
        ASU.ASU_ID
        ,TAR.TAR_TAREA HITO_DESCR
        ,TAP.TAP_CODIGO HITO_CODIGO
        ,TEX.FECHACREAR FECHA_DEMANDA
        ,TAR.TAR_FECHA_INI FECHA_HITO  
        ,CASE EPR.DD_EPR_CODIGO WHEN  '04' THEN 'CANCELADO'
        WHEN '05' THEN 'CERRADO'
        END AS MOTIVO_CIERRE
        ,CASE EPR.DD_EPR_CODIGO 
        WHEN '04' THEN TAR.TAR_FECHA_FIN
        WHEN  '05' THEN TAR.TAR_FECHA_FIN
        END AS FECHA_CIERRE
        ,ROW_NUMBER() OVER (PARTITION BY PRC.ASU_ID ORDER BY TAR.FECHACREAR,PRC.PRC_ID DESC) TAR_NUM
    FROM HAYA01.ASU_ASUNTOS ASU
      INNER JOIN HAYA01.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.ASU_ID = ASU.ASU_ID      
      INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON TAR.PRC_ID = PRC.PRC_ID
      INNER JOIN HAYAMASTER.DD_EPR_ESTADO_PROCEDIMIENTO EPR ON PRC.DD_EPR_ID = EPR.DD_EPR_ID
      INNER JOIN HAYA01.TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID=TEX.TAR_ID
      INNER JOIN HAYA01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID=TEX.TAP_ID
) TMP WHERE TAR_NUM=1
)
select 
  NVL(ULT_PROC_PADRE.ASU_ID,ULTIMO_PROC_ASUNTO.ASU_ID) ASU_ID
  ,ASU_NOMBRE
  ,NVL(ULT_PROC_PADRE.PRC_ID,ULTIMO_PROC_ASUNTO.PRC_ID) ID_PROCEDIMIENTO
  ,PRC.PRC_PRC_ID
  ,'2038' ENTI
  ,'BANKIA' ENTIDAD
  ,'HAYA' SERVICER
  , CASE UPPER(TAS.DD_TAS_DESCRIPCION) 
          WHEN 'CONCURSAL' THEN 'CONCURSO'
          ELSE 
          CASE UPPER(TPO.DD_TPO_DESCRIPCION)
            WHEN 'P. HIPOTECARIO - HAYA' THEN 'HIPOTECARIO'
            WHEN 'P. EJ. DE TÍTULO JUDICIAL - HAYA' THEN 'EJECUCION NO HIP'
            WHEN 'P. EJ. DE TÍTULO NO JUDICIAL - HAYA' THEN 'EJECUCION NO HIP'
            WHEN 'P. ORDINARIO - HAYA' THEN 'VERBAL/ORDINARIO'
            WHEN 'P. VERBAL - HAYA' THEN 'VERBAL/ORDINARIO'
            WHEN 'P. VERBAL DESDE MONITORIO - HAYA' THEN 'VERBAL/ORDINARIO'
            WHEN 'P. MONITORIO - HAYA' THEN 'MONITORIO'
            ELSE 'OTROS'
          END
        END  AS TIPO_PROCEDIMIENTO
    ,PRC.FECHACREAR FECHA_ALTA
    ,NULL
    ,TAR.FECHA_CIERRE
    ,TAR.MOTIVO_CIERRE
    ,PRC.PRC_COD_PROC_EN_JUZGADO AUTO
    ,TAR.HITO_CODIGO
    ,TAR.HITO_DESCR
    ,TAR.FECHA_HITO
    ,CASE WHEN TAS.DD_TAS_CODIGO LIKE '02' THEN NULL
    ELSE PRC_SALDO_RECUPERACION
    END AS IMPORTE_DEMANDA_TOTAL
FROM HAYA01.ASU_ASUNTOS ASU
LEFT JOIN ULT_PROC_PADRE ON ULT_PROC_PADRE.ASU_ID = ASU.ASU_ID
INNER JOIN ULTIMO_PROC_ASUNTO ON ULTIMO_PROC_ASUNTO.ASU_ID = ASU.ASU_ID
INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON NVL(ULT_PROC_PADRE.PRC_ID,ULTIMO_PROC_ASUNTO.PRC_ID)=PRC.PRC_ID
LEFT JOIN HAYA01.DD_TPO_TIPO_PROCEDIMIENTO TPO ON PRC.DD_TPO_ID=TPO.DD_TPO_ID
LEFT JOIN HAYAMASTER.DD_TAS_TIPOS_ASUNTO TAS ON TAS.DD_TAS_ID=ASU.DD_TAS_ID
LEFT JOIN TAR ON TAR.ASU_ID=ASU.ASU_ID;

commit;

--MERGE 3(SUBASTA)
MERGE INTO MINIREC.VAL_PROC_JUDICIAL_FOTO PJF
USING 
(
 SELECT DISTINCT PRC.PRC_ID,S.SUB_FECHA_SENYALAMIENTO AS FECHA
    FROM HAYA01.SUB_SUBASTA S 
    INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON PRC.ASU_ID=S.ASU_ID
    WHERE SUB_FECHA_SENYALAMIENTO IS NOT NULL 
    AND SUB_FECHA_SENYALAMIENTO = ( SELECT MAX(SUB_FECHA_SENYALAMIENTO) FROM HAYA01.SUB_SUBASTA S2 WHERE S.ASU_ID=S2.ASU_ID)
    AND PRC.PRC_PRC_ID IS NULL
) A
ON (PJF.ID_PROCEDIMIENTO = A.PRC_ID)
WHEN MATCHED THEN
UPDATE SET 
    PJF.FECHA_SUBASTA = A.FECHA
;

commit;

--MERGE 4(JUZGADO)
MERGE INTO MINIREC.VAL_PROC_JUDICIAL_FOTO PJF
USING 
(
  SELECT PRC.PRC_ID,JUZ.DD_JUZ_DESCRIPCION,PLA.DD_PLA_DESCRIPCION FROM HAYA01.PRC_PROCEDIMIENTOS PRC 
  LEFT JOIN HAYA01.DD_JUZ_JUZGADOS_PLAZA JUZ ON JUZ.DD_JUZ_ID=PRC.DD_JUZ_ID
  LEFT JOIN HAYA01.DD_PLA_PLAZAS PLA ON PLA.DD_PLA_ID = JUZ.DD_PLA_ID
  WHERE PRC.PRC_PRC_ID IS NULL
 
) A
ON (PJF.ID_PROCEDIMIENTO = A.PRC_ID)
WHEN MATCHED THEN
UPDATE SET 
    PJF.JUZGADO = A.DD_JUZ_DESCRIPCION,
    PJF.PARTIDO_JUDICIAL = A.DD_PLA_DESCRIPCION
;

commit;

--MERGE 5 (IMPORTES)
MERGE INTO MINIREC.VAL_PROC_JUDICIAL_FOTO PJF
USING 
(
SELECT
      PRC.PRC_ID,
      SUM(CRE2.CRE_PRINCIPAL_EXT) AS COMUNICADO,
      SUM(CRE.CRE_PRINCIPAL_FINAL) AS RECONOCIDO
      FROM HAYA01.ASU_ASUNTOS ASU
      INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON PRC.ASU_ID = ASU.ASU_ID
      INNER JOIN HAYA01.CRE_PRC_CEX CRE ON  CRE.CRE_PRC_CEX_PRCID=PRC.PRC_ID
      INNER JOIN HAYA01.CRE_PRC_CEX CRE2 ON  CRE2.CRE_PRC_CEX_PRCID=PRC.PRC_ID
      INNER JOIN HAYAMASTER.DD_STD_CREDITO STD ON STD.STD_CRE_ID = CRE.STD_CRE_ID
      WHERE STD.STD_CRE_CODIGO IN ('2','7','8','10')
      GROUP BY PRC.PRC_ID
) A
ON (PJF.ID_PROCEDIMIENTO = A.PRC_ID)
WHEN MATCHED THEN
UPDATE SET 
    PJF.IMPORTE_COMUNICADO = A.COMUNICADO,
    PJF.IMPORTE_RECONOCIDO = A.RECONOCIDO
;

commit;

--MERGE 6 (ABOGADO)
MERGE INTO MINIREC.VAL_PROC_JUDICIAL_FOTO PJF
USING 
(
    SELECT   
    PRC.PRC_ID,
    DES.DES_DESPACHO
    FROM HAYA01.PRC_PROCEDIMIENTOS PRC
    INNER JOIN HAYA01.GAA_GESTOR_ADICIONAL_ASUNTO GAA ON GAA.ASU_ID=PRC.ASU_ID AND DD_TGE_ID=261
    INNER JOIN HAYA01.USD_USUARIOS_DESPACHOS USD ON USD.USD_ID=GAA.USD_ID
    INNER JOIN HAYA01.DES_DESPACHO_EXTERNO DES ON USD.DES_ID = DES.DES_ID
) A
ON (PJF.ID_PROCEDIMIENTO = A.PRC_ID)
WHEN MATCHED THEN
UPDATE SET 
    PJF.ABOGADO = A.DES_DESPACHO
;

commit;

--MERGE 7(PROCURADOR)
MERGE INTO MINIREC.VAL_PROC_JUDICIAL_FOTO PJF
USING 
(

    SELECT   
    PRC.PRC_ID,
    DES.DES_DESPACHO
    FROM HAYA01.PRC_PROCEDIMIENTOS PRC
    INNER JOIN HAYA01.GAA_GESTOR_ADICIONAL_ASUNTO GAA ON GAA.ASU_ID=PRC.ASU_ID AND DD_TGE_ID=4
    INNER JOIN HAYA01.USD_USUARIOS_DESPACHOS USD ON USD.USD_ID=GAA.USD_ID
    INNER JOIN HAYA01.DES_DESPACHO_EXTERNO DES ON USD.DES_ID = DES.DES_ID
) A
ON (PJF.ID_PROCEDIMIENTO = A.PRC_ID)
WHEN MATCHED THEN
UPDATE SET 
    PJF.PROCURADOR = A.DES_DESPACHO
;

commit;

--MERGE 8 (PROVINCIA)
MERGE INTO MINIREC.VAL_PROC_JUDICIAL_FOTO PJF
USING 
(
    SELECT DISTINCT 
    PRC.PRC_ID,
    LOC.DD_LOC_ID,
    LOC.DD_LOC_DESCRIPCION,
    PRV.DD_PRV_DESCRIPCION
    FROM HAYA01.PRC_PROCEDIMIENTOS PRC
      INNER JOIN  HAYA01.DD_JUZ_JUZGADOS_PLAZA JUZ  ON JUZ.DD_JUZ_ID=PRC.DD_JUZ_ID
      INNER JOIN HAYA01.DD_PLA_PLAZAS PLA ON PLA.DD_PLA_ID = JUZ.DD_PLA_ID
      INNER JOIN  HAYAMASTER.DD_LOC_LOCALIDAD LOC ON TRANSLATE(UPPER(DD_PLA_DESCRIPCION), 'ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜÂÊÎÔÛ', 'AEIOUAEIOUAEIOUAEIOU')=TRANSLATE(UPPER(LOC.DD_LOC_DESCRIPCION), 'ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜÂÊÎÔÛ', 'AEIOUAEIOUAEIOUAEIOU')		
      INNER JOIN  HAYAMASTER.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID=LOC.DD_PRV_ID
    WHERE PRC.PRC_PRC_ID IS NULL
) PRV
ON (PJF.ID_PROCEDIMIENTO = PRV.PRC_ID)
WHEN MATCHED THEN
 UPDATE SET 
    PJF.PROVINCIA = PRV.DD_PRV_DESCRIPCION
;

commit;


--MERGE 9 (FECHA_DEMANDA_CONCURSO)
MERGE INTO VAL_PROC_JUDICIAL_FOTO VAL
USING (
        SELECT TEV_VALOR, PRC.PRC_ID, ASU.ASU_ID FROM HAYA01.TEV_TAREA_EXTERNA_VALOR TEV
        INNER JOIN HAYA01.TEX_TAREA_EXTERNA TEX ON TEX.TEX_ID = TEV.TEX_ID
        INNER JOIN HAYA01.TAR_TAREAS_NOTIFICACIONES TAR ON TEX.TAR_ID = TAR.TAR_ID
        INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON TAR.ASU_ID = PRC.ASU_ID
        INNER JOIN HAYA01.ASU_ASUNTOS ASU ON PRC.ASU_ID = ASU.ASU_ID
        WHERE TEV.TEV_NOMBRE = 'fechaAuto'
        AND ASU.DD_TAS_ID =2
      )X
ON (VAL.ID_PROCEDIMIENTO = X.PRC_ID)
WHEN MATCHED THEN
  UPDATE SET VAL.FECHA_DEMANDA = TO_DATE(X.TEV_VALOR, 'RRRR-MM-DD')
  WHERE UPPER(VAL.TIPO_PROCEDIMIENTO) = 'CONCURSO';
  
commit;
  
 -- MERGE 10 (FECHA_DEMANDA_LITIGIO)
 MERGE INTO VAL_PROC_JUDICIAL_FOTO VAL
USING (
        SELECT DISTINCT TEV_VALOR, PRC.PRC_ID, ASU.ASU_ID FROM HAYA01.TEV_TAREA_EXTERNA_VALOR TEV
        INNER JOIN HAYA01.TEX_TAREA_EXTERNA TEX ON TEX.TEX_ID = TEV.TEX_ID 
        INNER JOIN HAYA01.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
        INNER JOIN HAYA01.TAR_TAREAS_NOTIFICACIONES TAR ON TEX.TAR_ID = TAR.TAR_ID
        INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON TAR.ASU_ID = PRC.ASU_ID       
        INNER JOIN HAYA01.ASU_ASUNTOS ASU ON PRC.ASU_ID = ASU.ASU_ID
        WHERE TEV.TEV_NOMBRE = 'fechaInterposicion'
        --AND TAP.TAP_ID IN (10000000003208,10000000003144,10000000003219,10000000003244,10000000003250,10000000003384,10000000003444)
      )Y
ON (VAL.ID_PROCEDIMIENTO = Y.PRC_ID)
WHEN MATCHED THEN
  UPDATE SET VAL.FECHA_DEMANDA = TO_DATE(Y.TEV_VALOR, 'RRRR-MM-DD')
  WHERE UPPER(VAL.TIPO_PROCEDIMIENTO) <> 'CONCURSO';

commit;
