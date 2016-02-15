create or replace
PROCEDURE CARGAR_H_BIEN (DATE_START IN DATE, DATE_END IN DATE, O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Jaime Sánchez-Cuenca Bellido, PFS Group
-- Fecha creación: Septiembre 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group

-- Fecha ultima modificacion: 02/01/2016
-- Motivos del cambio: Desarrollo - FECHA_INTERP_DEM_HIP

-- Cliente: Recovery BI Cajamar
--
-- Descripción: Procedimiento almancenado que carga las tablas de hechos de Bien
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================

-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
  V_NUM_ROW NUMBER(10);
  V_DATASTAGE VARCHAR2(100);
  V_NUMBER  NUMBER(16,0);
  V_SQL VARCHAR2(16000);

  max_dia_semana date;
  max_dia_mes date;
  max_dia_trimestre date;
  max_dia_anio date;
  max_dia_carga date;
  
  semana int;
  mes int;
  trimestre int;
  anio int;
  fecha date;
  fecha_rellenar date;

  nCount number;

  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_BIEN';
  V_ROWCOUNT NUMBER;

--  cursor c_fecha_rellenar is select distinct(DIA_ID) DIA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_fecha is select distinct(DIA_ID) DIA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_semana is select distinct SEMANA_H from TMP_FECHA order by 1;
  cursor c_mes is select distinct MES_H from TMP_FECHA order by 1;
  cursor c_trimestre is select distinct TRIMESTRE_H from TMP_FECHA order by 1;
  cursor c_anio is select distinct ANIO_H from TMP_FECHA order by 1;

-- --------------------------------------------------------------------------------
-- DEFINICIÓN DE LOS HANDLER DE ERROR
-- --------------------------------------------------------------------------------
  OBJECTEXISTS EXCEPTION;
  INSERT_NULL EXCEPTION;
  PARAMETERS_NUMBER EXCEPTION;
  PRAGMA EXCEPTION_INIT(OBJECTEXISTS, -955);
  PRAGMA EXCEPTION_INIT(INSERT_NULL, -1400);
  PRAGMA EXCEPTION_INIT(PARAMETERS_NUMBER, -909);

BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
  select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';
  
  open c_fecha;
  loop --READ_LOOP
    fetch c_fecha into fecha;        
    exit when c_fecha%NOTFOUND;

      -- Borrado índices TMP_H_BIE
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_BIE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;

       V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_BIE'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;

      execute immediate
        'insert into TMP_H_BIE(
                    DIA_ID,
                    FECHA_CARGA_DATOS,
                    ASUNTO_ID,
                    LOTE_ID,
                    BIE_ID,
                    TIPO_BIEN_ID,
                    SUBTIPO_BIEN_ID,
                    POBLACION_BIEN_ID,
                    BIEN_ADJUDICADO_ID,
                    ADJ_CESION_REM_BIEN_ID,
                    CODIGO_ACTIVO_BIEN_ID,
                    ENTIDAD_ADJUDICATARIA_ID,
                    IMP_VALOR_BIEN,
                    IMP_ADJUDICADO,
                    IMP_CESION_REMATE,
                    IMP_BIE_TIPO_SUBASTA,
                    PROCEDIMIENTO_ID
                   )
            SELECT  ''' || fecha || ''',
                    ''' || fecha || ''',
                     SUB.ASU_ID,
                     LOB.LOS_ID,
                     BIE.BIE_ID,
                     NVL(BIE.DD_TBI_ID,-1) AS TIPO_BIEN_ID,
                     NVL(ADI.DD_TPN_ID, -1) AS SUBTIPO_BIE,
                     NVL(LOC.DD_LOC_ID,-1) AS POBLACION_BIEN_ID,
                     CASE WHEN ADJ.BIE_ID IS NOT NULL THEN 1 ELSE 0 END AS BIEN_ADJUDICADO_ID,
                     NVL(ADJ.BIE_ADJ_CESION_REMATE,0) AS ADJ_CESION_REM_BIEN_ID,
                     NVL(BIE.BIE_NUMERO_ACTIVO,-1) AS CODIGO_ACTIVO_BIEN_ID,
                     NVL(ADJ.DD_EAD_ID,-1) AS ENTIDAD_ADJUDICATARIA_ID,
                     NVL(BIE.BIE_VALOR_ACTUAL,0) AS IMP_VALOR_BIEN,
                     NVL(ADJ.BIE_ADJ_IMPORTE_ADJUDICACION,0) AS IMP_ADJUDICADO,
                     NVL(ADJ.BIE_ADJ_CESION_REMATE_IMP,0) AS IMP_CESION_REMATE,
                     NVL(BIE.BIE_TIPO_SUBASTA,0) AS IMP_BIE_TIPO_SUBASTA,
                     (SELECT MIN(PRC_ID) FROM '|| V_DATASTAGE ||'.PRC_PROCEDIMIENTOS PRC WHERE PRC.ASU_ID = SUB.ASU_ID AND PRC.PRC_PRC_ID IS NULL GROUP BY PRC.ASU_ID) AS PROCEDIMIENTO_ID
              FROM '|| V_DATASTAGE ||'.BIE_BIEN BIE, '|| V_DATASTAGE ||'.SUB_SUBASTA SUB, '|| V_DATASTAGE ||'.LOS_LOTE_SUBASTA LOS, '|| V_DATASTAGE ||'. LOB_LOTE_BIEN LOB,
                   '|| V_DATASTAGE ||'.BIE_ADICIONAL ADI, '|| V_DATASTAGE ||'.BIE_LOCALIZACION LOC, '|| V_DATASTAGE ||'.BIE_ADJ_ADJUDICACION ADJ
              WHERE BIE.BIE_ID = LOB.BIE_ID
              AND LOB.LOS_ID = LOS.LOS_ID
              AND LOS.SUB_ID = SUB.SUB_ID 
              AND BIE.BIE_ID = ADI.BIE_ID (+)
              AND BIE.BIE_ID = LOC.BIE_ID (+)
              AND BIE.BIE_ID = ADJ.BIE_ID (+)
              AND BIE.BORRADO (+) = 0 and ''' || fecha || ''' >= trunc(BIE.FECHACREAR)
              AND SUB.BORRADO (+) = 0  
              AND LOS.BORRADO (+) = 0
              AND ''' || fecha || ''' >= trunc(SUB.FECHACREAR(+))
              AND ''' || fecha || ''' >= trunc(LOS.FECHACREAR (+))
              ORDER BY 2';

        V_ROWCOUNT := sql%rowcount;
     
        --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_BIE. Registros Insertados (1): ' || TO_CHAR(V_ROWCOUNT) ||' para la Fecha ='||TO_CHAR(fecha, 'DD/MM/YYYY'), 4;
        commit;

        --Log_Proceso
        execute immediate '
            insert into TMP_H_BIE(
                    DIA_ID,
                    FECHA_CARGA_DATOS,
                    ASUNTO_ID,
                    LOTE_ID,
                    BIE_ID,
                    TIPO_BIEN_ID,
                    SUBTIPO_BIEN_ID,
                    POBLACION_BIEN_ID,
                    BIEN_ADJUDICADO_ID,
                    ADJ_CESION_REM_BIEN_ID,
                    CODIGO_ACTIVO_BIEN_ID,
                    ENTIDAD_ADJUDICATARIA_ID,
                    IMP_VALOR_BIEN,
                    IMP_ADJUDICADO,
                    IMP_CESION_REMATE,
                    IMP_BIE_TIPO_SUBASTA,
                    PROCEDIMIENTO_ID
                   )
              SELECT DISTINCT 
                     ''' || fecha || ''',
                     ''' || fecha || ''',
                     PRC.ASU_ID,
                     -1 LOTE_ID,
                     BIE.BIE_ID,
                     NVL(BIE.DD_TBI_ID,-1) AS TIPO_BIEN_ID,
                     NVL(ADI.DD_TPN_ID, -1) AS SUBTIPO_BIE,
                     NVL(LOC.DD_LOC_ID,-1) AS POBLACION_BIEN_ID,
                     CASE WHEN ADJ.BIE_ID IS NOT NULL THEN 1 ELSE 0 END AS BIEN_ADJUDICADO_ID,
                     NVL(ADJ.BIE_ADJ_CESION_REMATE,0) AS ADJ_CESION_REM_BIEN_ID,
                     NVL(BIE.BIE_NUMERO_ACTIVO,-1) AS CODIGO_ACTIVO_BIEN_ID,
                     NVL(ADJ.DD_EAD_ID,-1) AS ENTIDAD_ADJUDICATARIA_ID,
                     NVL(BIE.BIE_VALOR_ACTUAL,0) AS IMP_VALOR_BIEN,
                     NVL(ADJ.BIE_ADJ_IMPORTE_ADJUDICACION,0) AS IMP_ADJUDICADO,
                     NVL(ADJ.BIE_ADJ_CESION_REMATE_IMP,0) AS IMP_CESION_REMATE,
                     NVL(BIE.BIE_TIPO_SUBASTA,0) AS IMP_BIE_TIPO_SUBASTA,
                     (SELECT MIN(PRC_ID) FROM '|| V_DATASTAGE ||'.PRC_PROCEDIMIENTOS PRC2 WHERE PRC2.ASU_ID = PRC.ASU_ID AND PRC2.PRC_PRC_ID IS NULL GROUP BY PRC2.ASU_ID) AS PROCEDIMIENTO_ID
              FROM '|| V_DATASTAGE ||'.BIE_BIEN BIE, '|| V_DATASTAGE ||'.PRB_PRC_BIE PRB, '|| V_DATASTAGE ||'.PRC_PROCEDIMIENTOS PRC,
                   '|| V_DATASTAGE ||'.BIE_ADICIONAL ADI, '|| V_DATASTAGE ||'.BIE_LOCALIZACION LOC, '|| V_DATASTAGE ||'.BIE_ADJ_ADJUDICACION ADJ
              WHERE BIE.BIE_ID = PRB.BIE_ID
              AND NOT EXISTS(SELECT 1
                             FROM TMP_H_BIE TMP
                             WHERE TMP.BIE_ID = BIE.BIE_ID)
              AND PRB.PRC_ID = PRC.PRC_ID
              AND BIE.BIE_ID = ADI.BIE_ID (+)
              AND BIE.BIE_ID = LOC.BIE_ID (+)
              AND BIE.BIE_ID = ADJ.BIE_ID (+)
              AND BIE.BORRADO (+) = 0 and ''' || fecha || ''' >= trunc(BIE.FECHACREAR(+))
              AND PRC.BORRADO (+) = 0  
              AND PRB.BORRADO (+) = 0
              AND ''' || fecha || ''' >= trunc(PRB.FECHACREAR(+))
              AND ''' || fecha || ''' >= trunc(PRC.FECHACREAR(+))';
              
        V_ROWCOUNT := sql%rowcount;
              
        --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_BIE. Registros Insertados (2): ' || TO_CHAR(V_ROWCOUNT), 4;
        commit;
        
        
		execute immediate '
        UPDATE TMP_H_BIE TMP
        SET FASE_ACTUAL_DETALLE_ID = (SELECT DD_TPO_ID FROM '|| V_DATASTAGE ||'.PRC_PROCEDIMIENTOS PRC WHERE PRC.PRC_ID = (SELECT MAX(PRC_ID) 
                                                                                                                            FROM '|| V_DATASTAGE ||'.PRC_PROCEDIMIENTOS PRC2
                                                                                                                            WHERE PRC2.ASU_ID = TMP.ASUNTO_ID
                                                                                                                            AND trunc(PRC2.FECHACREAR) <= ''' || fecha || ''' ))';

		
		execute immediate '																													
		merge into TMP_H_BIE t1 using 
			(SELECT B.DD_TPO_ID, B.PRC_ID, A.ASU_ID, A.BIE_ID
			FROM
				(SELECT MAX(PRC2.PRC_ID) PRC_ID, PRB.BIE_ID BIE_ID, PRC2.ASU_ID ASU_ID 
						FROM TMP_H_BIE TMP,
							 '|| V_DATASTAGE ||'.PRC_PROCEDIMIENTOS PRC2,
							 '|| V_DATASTAGE ||'.PRB_PRC_BIE PRB
					   WHERE PRB.BIE_ID = TMP.BIE_ID
						 AND PRB.PRC_ID = PRC2.PRC_ID
						 AND PRC2.ASU_ID = TMP.ASUNTO_ID
						 AND trunc(PRC2.FECHACREAR) <= ''' || fecha || ''' 
						 GROUP BY PRB.BIE_ID, PRC2.ASU_ID) A,
				(SELECT DD_TPO_ID, PRC_ID, ASU_ID
						FROM '|| V_DATASTAGE ||'.PRC_PROCEDIMIENTOS PRC
					   WHERE trunc(PRC.FECHACREAR) <= ''' || fecha || ''') B
			WHERE A.PRC_ID = B.PRC_ID
			  AND A.ASU_ID = B.ASU_ID) C
		ON (T1.BIE_ID = C.BIE_ID AND T1.ASUNTO_ID = C.ASU_ID)
		when matched then update set T1.BIE_FASE_ACTUAL_DETALLE_ID = C.DD_TPO_ID, T1.BIE_FASE_ACTUAL = C.PRC_ID';
        
        V_ROWCOUNT := sql%rowcount;
              
        --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_BIE. Update (1): ' || TO_CHAR(V_ROWCOUNT), 4;
        commit;

        execute immediate '
        UPDATE TMP_H_BIE TMP
        SET TMP.TIPO_PROCEDIMIENTO_DET_ID = (SELECT DD_TPO_ID FROM '|| V_DATASTAGE ||'.PRC_PROCEDIMIENTOS PRC WHERE PRC.PRC_ID = TMP.PROCEDIMIENTO_ID)';
        
        V_ROWCOUNT := sql%rowcount;
        
        --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_BIE. Update (2): ' || TO_CHAR(V_ROWCOUNT), 4;
        commit;
        
        execute immediate 'merge into TMP_H_BIE t1
                       using (select PRC_ID, PRC_PRC_ID, DD_EPR_ID, DD_TPO_ID from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS) t2
                          on (t1.BIE_FASE_ACTUAL = t2.PRC_ID)
                       when matched then update set t1.BIE_ESTADO_FASE_ACTUAL_ID = t2.DD_EPR_ID
                                          where t1.DIA_ID = '''||fecha||'''';
        commit;
     -- FASE_ACTUAL_AGR_ID
     update TMP_H_BIE  set FASE_ACTUAL_AGR_ID = (case when TIPO_PROCEDIMIENTO_DET_ID IN (2452) then 1
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2377) then 2
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2378) then 3
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2353) then 4
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2382) then 5
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2381) then 6
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2543) then 7
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2544) then 8
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2450) then 9
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2542,2357,2446,2356,2370,2373,2358,2384,2351,2374,2449,2943,2944) then 10
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2375) then 11
                                                     when TIPO_PROCEDIMIENTO_DET_ID IN (2842) then 15
                                                     when TIPO_PROCEDIMIENTO_DET_ID NOT IN (2542,2357,2446,2356,2370,2373,2358,2384,2351,2374,2449,2943,2944,2375) and BIE_ESTADO_FASE_ACTUAL_ID=3 then 13
                                                     when TIPO_PROCEDIMIENTO_DET_ID IS NULL then -1
                                                     else 14 end) where DIA_ID = fecha;
    commit;                                                     
     update TMP_H_BIE set FASE_ACTUAL_AGR_ID = (case when FASE_ACTUAL_DETALLE_ID IN (2452) then 1
                                                     when FASE_ACTUAL_DETALLE_ID IN (2377) then 2
                                                     when FASE_ACTUAL_DETALLE_ID IN (2378) then 3
                                                     when FASE_ACTUAL_DETALLE_ID IN (2353) then 4
                                                     when FASE_ACTUAL_DETALLE_ID IN (2382) then 5
                                                     when FASE_ACTUAL_DETALLE_ID IN (2381) then 6
                                                     when FASE_ACTUAL_DETALLE_ID IN (2543) then 7
                                                     when FASE_ACTUAL_DETALLE_ID IN (2544) then 8
                                                     when FASE_ACTUAL_DETALLE_ID IN (2450) then 9
                                                     when FASE_ACTUAL_DETALLE_ID IN (2542,2357,2446,2356,2370,2373,2358,2384,2351,2374,2449,2943,2944) then 10
                                                     when FASE_ACTUAL_DETALLE_ID IN (2375) then 11
													 when FASE_ACTUAL_DETALLE_ID IN (2842) then 15
                                                     when FASE_ACTUAL_DETALLE_ID NOT IN (2542,2357,2446,2356,2370,2373,2358,2384,2351,2374,2449,2943,2944,2375) and BIE_ESTADO_FASE_ACTUAL_ID=3 then 13
                                                     else FASE_ACTUAL_AGR_ID end) where DIA_ID = fecha;

        V_ROWCOUNT := sql%rowcount;
        
        --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_BIE. Update (3): ' || TO_CHAR(V_ROWCOUNT), 4;
        commit;
                                                     
                                                     
        EXECUTE IMMEDIATE '
        UPDATE TMP_H_BIE TMP
        SET TITULAR_PROCEDIMIENTO_ID = (SELECT MAX(PRCPER.PER_ID)
                                        from '|| V_DATASTAGE ||'.CPE_CONTRATOS_PERSONAS CPE, '|| V_DATASTAGE ||'.PRC_PER PRCPER, '|| V_DATASTAGE ||'.DD_TIN_TIPO_INTERVENCION TIN
                                        WHERE CPE.PER_ID = PRCPER.PER_ID
                                        AND CPE.DD_TIN_ID = TIN.DD_TIN_ID AND TIN.DD_TIN_TITULAR = 1
                                        AND PRCPER.PRC_ID = TMP.PROCEDIMIENTO_ID)';
   
        V_ROWCOUNT := sql%rowcount;
        
        --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_BIE. Update (4): ' || TO_CHAR(V_ROWCOUNT), 4;
        commit;
    
            execute immediate '
            insert into TMP_H_BIE(
                    DIA_ID,
                    FECHA_CARGA_DATOS,
                    ASUNTO_ID,
                    LOTE_ID,
                    BIE_ID,
                    TIPO_BIEN_ID,
                    SUBTIPO_BIEN_ID,
                    POBLACION_BIEN_ID,
                    BIEN_ADJUDICADO_ID,
                    ADJ_CESION_REM_BIEN_ID,
                    CODIGO_ACTIVO_BIEN_ID,
                    ENTIDAD_ADJUDICATARIA_ID,
                    IMP_VALOR_BIEN,
                    IMP_ADJUDICADO,
                    IMP_CESION_REMATE,
                    IMP_BIE_TIPO_SUBASTA,
                    PROCEDIMIENTO_ID,
                    FASE_ACTUAL_DETALLE_ID,
                    TIPO_PROCEDIMIENTO_DET_ID,
                    FASE_ACTUAL_AGR_ID,
                    TITULAR_PROCEDIMIENTO_ID,
					BIE_FASE_ACTUAL_DETALLE_ID
                   )
              SELECT DISTINCT 
                     ''' || fecha || ''',
                     ''' || fecha || ''',
                     -1 AS ASUNTO_ID,
                     -1 LOTE_ID,
                     BIE.BIE_ID,
                     NVL(BIE.DD_TBI_ID,-1) AS TIPO_BIEN_ID,
                     NVL(ADI.DD_TPN_ID, -1) AS SUBTIPO_BIE,
                     NVL(LOC.DD_LOC_ID,-1) AS POBLACION_BIEN_ID,
                     CASE WHEN ADJ.BIE_ID IS NOT NULL THEN 1 ELSE 0 END AS BIEN_ADJUDICADO_ID,
                     NVL(ADJ.BIE_ADJ_CESION_REMATE,0) AS ADJ_CESION_REM_BIEN_ID,
                     NVL(BIE.BIE_NUMERO_ACTIVO,-1) AS CODIGO_ACTIVO_BIEN_ID,
                     NVL(ADJ.DD_EAD_ID,-1) AS ENTIDAD_ADJUDICATARIA_ID,
                     NVL(BIE.BIE_VALOR_ACTUAL,0) AS IMP_VALOR_BIEN,
                     NVL(ADJ.BIE_ADJ_IMPORTE_ADJUDICACION,0) AS IMP_ADJUDICADO,
                     NVL(ADJ.BIE_ADJ_CESION_REMATE_IMP,0) AS IMP_CESION_REMATE,
                     NVL(BIE.BIE_TIPO_SUBASTA,0) AS IMP_BIE_TIPO_SUBASTA,
                    -1 AS PROCEDIMIENTO_ID,
                    -1 AS  FASE_ACTUAL_DETALLE_ID,
                    -1 AS TIPO_PROCEDIMIENTO_DET_ID,
                    -1 AS FASE_ACTUAL_AGR_ID,
                    -1 AS TITULAR_PROCEDIMIENTO_ID,
					-1 AS BIE_FASE_ACTUAL_DETALLE_ID
              FROM '|| V_DATASTAGE ||'.BIE_BIEN BIE, 
                   '|| V_DATASTAGE ||'.BIE_ADICIONAL ADI, '|| V_DATASTAGE ||'.BIE_LOCALIZACION LOC, '|| V_DATASTAGE ||'.BIE_ADJ_ADJUDICACION ADJ
              WHERE NOT EXISTS(SELECT 1
                             FROM TMP_H_BIE TMP
                             WHERE TMP.BIE_ID = BIE.BIE_ID)
              AND BIE.BIE_ID = ADI.BIE_ID (+)
              AND BIE.BIE_ID = LOC.BIE_ID (+)
              AND BIE.BIE_ID = ADJ.BIE_ID (+)
              AND BIE.BORRADO (+) = 0 and ''' || fecha || ''' >= trunc(BIE.FECHACREAR(+))';
              
        V_ROWCOUNT := sql%rowcount;
              
        --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_BIE. Registros Insertados (3): ' || TO_CHAR(V_ROWCOUNT), 4;
        commit;
        
        execute immediate 'MERGE INTO TMP_H_BIE TMP USING
                    (SELECT AUX_TITULARES.BIE_ID, MAX(AUX_TITULARES.PER_ID) PER_ID FROM(
                        SELECT DISTINCT PER.PER_ID, BIE_CNT.BIE_ID, AUX.CNT_ID, CPE.CPE_ORDEN, rank() over (partition by CPE.CNT_ID order by cpe.cpe_orden) as ranking2 FROM(
                          SELECT DISTINCT CNT.CNT_ID, rank() over (partition by CNT.CNT_ID order by (MOV.MOV_POS_VIVA_VENCIDA + MOV_POS_VIVA_NO_VENCIDA) DESC) as ranking
                          FROM '||V_DATASTAGE||'.CNT_CONTRATOS CNT, '||V_DATASTAGE||'.MOV_MOVIMIENTOS MOV
                          WHERE CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION) AUX,
                         '||V_DATASTAGE||'.CPE_CONTRATOS_PERSONAS CPE, '||V_DATASTAGE||'.DD_TIN_TIPO_INTERVENCION TIN, '||V_DATASTAGE||'.PER_PERSONAS PER, '||V_DATASTAGE||'.BIE_CNT --BIE_CNT
                        WHERE CPE.CNT_ID = AUX.CNT_ID
                        AND CPE.CNT_ID = BIE_CNT.CNT_ID
                        AND CPE.DD_TIN_ID = TIN.DD_TIN_ID AND TIN.DD_TIN_TITULAR = 1
                        AND CPE.PER_ID = PER.PER_ID AND PER.BORRADO = 0
                        AND AUX.RANKING = 1) AUX_TITULARES
                     WHERE AUX_TITULARES.RANKING2 = 1
                     GROUP BY AUX_TITULARES.BIE_ID) TITULAR_BIEN
                     ON (TMP.BIE_ID = TITULAR_BIEN.BIE_ID)
                     WHEN MATCHED THEN UPDATE SET TMP.PRIMER_TITULAR_BIE_ID = TITULAR_BIEN.PER_ID';
                  
        V_ROWCOUNT := sql%rowcount;
        
        --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_BIE. Registros Updateados (5): ' || TO_CHAR(V_ROWCOUNT), 4;
        commit;
        
        UPDATE TMP_H_BIE
          SET PRIMER_TITULAR_BIE_ID = -1
        WHERE PRIMER_TITULAR_BIE_ID IS NULL;

        COMMIT;
        
        execute immediate 'MERGE INTO TMP_H_BIE TMP USING(
                               SELECT CNT2.CNT_ID, AUX2.BIE_ID, CNT2.ZON_ID, CNT2.OFI_ID, ENP.DD_ENP_ID FROM(
                                  SELECT MAX(AUX.CNT_ID) CNT_ID, AUX.BIE_ID FROM(
                                      SELECT DISTINCT CNT.CNT_ID, BIE_CNT.BIE_ID, RANK() over (partition by BIE_CNT.BIE_ID order by (MOV.MOV_POS_VIVA_VENCIDA + MOV_POS_VIVA_NO_VENCIDA) DESC) as ranking
                                      FROM '||V_DATASTAGE||'.CNT_CONTRATOS CNT, '||V_DATASTAGE||'.MOV_MOVIMIENTOS MOV, '||V_DATASTAGE||'.BIE_CNT BIE_CNT
                                      WHERE CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION
                                       AND CNT.CNT_ID = BIE_CNT.CNT_ID) AUX 
                                    WHERE AUX.RANKING = 1
                                    GROUP BY AUX.BIE_ID) AUX2, '||V_DATASTAGE||'.CNT_CONTRATOS CNT2, '||V_DATASTAGE||'.DD_ENP_ENTIDADES_PROPIETARIAS ENP
                               WHERE AUX2.CNT_ID = CNT2.CNT_ID
                               AND CNT2.CNT_COD_ENTIDAD = ENP.DD_ENP_CODIGO) CONTRATO_BIEN
                           ON (TMP.BIE_ID = CONTRATO_BIEN.BIE_ID )
                           WHEN MATCHED THEN UPDATE SET NUM_OPERACION_BIEN_ID = CONTRATO_BIEN.CNT_ID,
                                                        ZONA_BIEN_ID = CONTRATO_BIEN.ZON_ID,
                                                        OFICINA_BIEN_ID = CONTRATO_BIEN.OFI_ID,
                                                        ENTIDAD_BIEN_ID = CONTRATO_BIEN.DD_ENP_ID';
                                    
        V_ROWCOUNT := sql%rowcount;
              
        --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_BIE. Registros Updateados (6): ' || TO_CHAR(V_ROWCOUNT), 4;
        commit;          

        UPDATE TMP_H_BIE
          SET NUM_OPERACION_BIEN_ID = -1
        WHERE NUM_OPERACION_BIEN_ID IS NULL;

        COMMIT;

        UPDATE TMP_H_BIE
          SET ZONA_BIEN_ID = -1
        WHERE ZONA_BIEN_ID IS NULL;

        COMMIT;

        UPDATE TMP_H_BIE
          SET OFICINA_BIEN_ID = -1
        WHERE OFICINA_BIEN_ID IS NULL;

        COMMIT;
        
        UPDATE TMP_H_BIE
          SET ENTIDAD_BIEN_ID = -1
        WHERE ENTIDAD_BIEN_ID IS NULL;

        COMMIT;

        -- LANZAMIENTOS:
        -- 01 - Entrega Voluntaria - Dacion en Pago
        EXECUTE IMMEDIATE'
        MERGE INTO TMP_H_BIE TMP USING(
            SELECT DISTINCT BIE_ID, TRUNC(BIE_TEA.FECHACREAR) AS FECHA_LANZAMIENTO_BIEN
            FROM '||V_DATASTAGE||'. BIE_TEA, '||V_DATASTAGE||'.TEA_TERMINOS_ACUERDO TEA
            WHERE BIE_TEA.TEA_ID = TEA.TEA_ID
            AND TEA.DD_TPA_ID = 1 --Dacion en Pago
            AND TRUNC(BIE_TEA.FECHACREAR) <= ''' || fecha || ''') BIENES
        ON (TMP.BIE_ID = BIENES.BIE_ID)
        WHEN MATCHED THEN UPDATE SET TMP.DESC_LANZAMIENTO_ID = 1,
                                     TMP.FECHA_LANZAMIENTO_BIEN = BIENES.FECHA_LANZAMIENTO_BIEN';
                                     
        COMMIT;
                                       
         
        -- 02 - Entrega Voluntaria - Otros
        EXECUTE IMMEDIATE'
        MERGE INTO TMP_H_BIE TMP USING (
            SELECT PRC.BIE_ID, MAX(TRUNC(TAR.TAR_FECHA_FIN)) AS FECHA
            FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR, '||V_DATASTAGE||'.PRB_PRC_BIE PRC
            WHERE TEV.TEX_ID = TEX.TEX_ID
            AND TEX.TAP_ID = 10000000002965 -- Registrar posesión y decisión sobre lanzamiento
            AND TEV.TEV_NOMBRE = ''comboLanzamiento''
            AND TEV.TEV_VALOR = ''02'' -- NO
            AND TEX.TAR_ID = TAR.TAR_ID
            AND TAR.PRC_ID = PRC.PRC_ID
            AND TRUNC(TAR.TAR_FECHA_FIN) <= ''' || fecha || '''
            GROUP BY PRC.BIE_ID) BIENES
        ON (TMP.BIE_ID = BIENES.BIE_ID)
        WHEN MATCHED THEN UPDATE SET TMP.DESC_LANZAMIENTO_ID = 2,
                                     TMP.FECHA_LANZAMIENTO_BIEN = BIENES.FECHA'; 

        COMMIT;
         
        -- 03 - Lanzamiento Celebrado - Vivienda no ocupada
        EXECUTE IMMEDIATE '
        MERGE INTO TMP_H_BIE TMP USING (
              SELECT PRC.BIE_ID, MAX(TO_DATE(TEV.TEV_VALOR,''RRRR-MM-DD'')) AS FECHA
              FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR, '||V_DATASTAGE||'.PRB_PRC_BIE PRC
              WHERE TEV.TEX_ID = TEX.TEX_ID
              AND TEX.TAP_ID = 10000000002967 -- Registrar lanzamiento efectuado
              AND TEV.TEV_NOMBRE = ''fecha''
              AND TEX.TAR_ID = TAR.TAR_ID
              AND TAR.PRC_ID = PRC.PRC_ID
              AND TO_DATE(TEV.TEV_VALOR,''RRRR-MM-DD'') <= ''' || fecha || '''
              AND EXISTS(SELECT 1
                         FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV2, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX2, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR2
                         WHERE TEV2.TEX_ID = TEX2.TEX_ID
                         AND TEX2.TAP_ID = 10000000002965 -- Registrar posesión y decisión sobre lanzamiento
                         AND TEV2.TEV_NOMBRE = ''comboOcupado''
                         AND TEV2.TEV_VALOR = ''02''
                         AND TEX2.TAR_ID = TAR2.TAR_ID
                         AND TAR2.PRC_ID = PRC.PRC_ID)
              GROUP BY PRC.BIE_ID           
                         ) BIENES
        ON (TMP.BIE_ID = BIENES.BIE_ID)
        WHEN MATCHED THEN UPDATE SET TMP.DESC_LANZAMIENTO_ID = 3,
                                     TMP.FECHA_LANZAMIENTO_BIEN = BIENES.FECHA';

        COMMIT;
                                     
        -- 04 -  Lanzamiento Celebrado - Vivienda ocupada
        EXECUTE IMMEDIATE '
        MERGE INTO TMP_H_BIE TMP USING (
              SELECT PRC.BIE_ID, MAX(TO_DATE(TEV.TEV_VALOR,''RRRR-MM-DD'')) AS FECHA
              FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR, '||V_DATASTAGE||'.PRB_PRC_BIE PRC
              WHERE TEV.TEX_ID = TEX.TEX_ID
              AND TEX.TAP_ID = 10000000002967 -- -- Registrar lanzamiento efectuado
              AND TEV.TEV_NOMBRE = ''fecha''
              AND TEX.TAR_ID = TAR.TAR_ID
              AND TAR.PRC_ID = PRC.PRC_ID
              AND TO_DATE(TEV.TEV_VALOR,''RRRR-MM-DD'') <= ''' || fecha || '''
              AND EXISTS(SELECT 1
                         FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV2, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX2, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR2
                         WHERE TEV2.TEX_ID = TEX2.TEX_ID
                         AND TEX2.TAP_ID = 10000000002965 -- Registrar posesión y decisión sobre lanzamiento
                         AND TEV2.TEV_NOMBRE = ''comboOcupado''
                         AND TEV2.TEV_VALOR = ''01''
                         AND TEX2.TAR_ID = TAR2.TAR_ID
                         AND TAR2.PRC_ID = PRC.PRC_ID)
               GROUP BY PRC.BIE_ID          
                         ) BIENES
        ON (TMP.BIE_ID = BIENES.BIE_ID)
        WHEN MATCHED THEN UPDATE SET TMP.DESC_LANZAMIENTO_ID = 4,
                                     TMP.FECHA_LANZAMIENTO_BIEN = BIENES.FECHA';

        COMMIT;

        -- 05 -  Lanzamiento Celebrado - Intervención FF.OO.
        EXECUTE IMMEDIATE '
        MERGE INTO TMP_H_BIE TMP USING (
              SELECT PRC.BIE_ID, MAX(TO_DATE(TEV.TEV_VALOR,''RRRR-MM-DD'')) AS FECHA
              FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR, '||V_DATASTAGE||'.PRB_PRC_BIE PRC
              WHERE TEV.TEX_ID = TEX.TEX_ID
              AND TEX.TAP_ID = 10000000002967 -- Registrar lanzamiento efectuado
              AND TEV.TEV_NOMBRE = ''fecha''
              AND TEX.TAR_ID = TAR.TAR_ID
              AND TAR.PRC_ID = PRC.PRC_ID
              AND TO_DATE(TEV.TEV_VALOR,''RRRR-MM-DD'') <= ''' || fecha || '''
              AND EXISTS(SELECT 1
                         FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV2, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX2, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR2
                         WHERE TEV2.TEX_ID = TEX2.TEX_ID
                         AND TEX2.TAP_ID = 10000000002965 -- Registrar posesión y decisión sobre lanzamiento
                         AND TEV2.TEV_NOMBRE = ''comboFuerzaPublica'' 
                         AND TEV2.TEV_VALOR = ''01''
                         AND TEX2.TAR_ID = TAR2.TAR_ID
                         AND TAR2.PRC_ID = PRC.PRC_ID)
              GROUP BY PRC.BIE_ID           
                         ) BIENES
        ON (TMP.BIE_ID = BIENES.BIE_ID)
        WHEN MATCHED THEN UPDATE SET TMP.DESC_LANZAMIENTO_ID = 5,
                                     TMP.FECHA_LANZAMIENTO_BIEN = BIENES.FECHA';

        COMMIT;

        
        -- 06 - Lanzamiento Suspendido (por el Juzgado) - Por RD 27/2012-Ley 01/2013
        EXECUTE IMMEDIATE'
        MERGE INTO TMP_H_BIE TMP USING(
            SELECT PRB.BIE_ID, NVL(DPR_FECHA_PARA, DPR.FECHACREAR) AS FECHA
            FROM '||V_DATASTAGE||'.DPR_DECISIONES_PROCEDIMIENTOS DPR, '||V_DATASTAGE||'.PRB_PRC_BIE PRB
            WHERE DPR.PRC_ID = PRB.PRC_ID
            AND (DPR_PARALIZA = 1 OR DPR_FINALIZA = 1)
            AND DPR.DD_DPA_ID = (SELECT DD_DPA_ID FROM '||V_DATASTAGE||'.DD_DPA_DECISION_PARALIZAR WHERE DD_DPA_CODIGO = ''OPOSI'') -- Oposición Ley hipotecaria 1/2013
            AND NVL(DPR_FECHA_PARA, DPR.FECHACREAR) <= ''' || fecha || '''
            ) BIENES
        ON (TMP.BIE_ID = BIENES.BIE_ID)
        WHEN MATCHED THEN UPDATE SET TMP.DESC_LANZAMIENTO_ID = 6,
                                     TMP.FECHA_LANZAMIENTO_BIEN = BIENES.FECHA';

        COMMIT;
        
        -- 07 - Lanzamiento Suspendido (por el Juzgado) - Por título reconocido
        EXECUTE IMMEDIATE'
        MERGE INTO TMP_H_BIE TMP USING (
              SELECT PRC.BIE_ID, MAX(TO_DATE(TEV.TEV_VALOR,''RRRR-MM-DD'')) AS FECHA
              FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR, '||V_DATASTAGE||'.PRB_PRC_BIE PRC
              WHERE TEV.TEX_ID = TEX.TEX_ID
              AND TEX.TAP_ID = 10000000002934 -- H011_RegistrarResolucion
              AND TEV.TEV_NOMBRE = ''fechaFinMoratoria''
              AND TEX.TAR_ID = TAR.TAR_ID
              AND TAR.PRC_ID = PRC.PRC_ID
              AND TO_DATE(TEV.TEV_VALOR,''RRRR-MM-DD'') >= ''' || fecha || '''
              AND EXISTS(SELECT 1
                         FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV2, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX2, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR2
                         WHERE TEV2.TEX_ID = TEX2.TEX_ID
                         AND TEX2.TAP_ID = 10000000002934 -- H011_RegistrarResolucion
                         AND TEV2.TEV_NOMBRE = ''comboFavDesf''
                         AND TEV2.TEV_VALOR = ''02'' -- NO
                         AND TEX2.TAR_ID = TAR2.TAR_ID
                         AND TAR2.PRC_ID = PRC.PRC_ID)
              GROUP BY PRC.BIE_ID           
                         ) BIENES
        ON (TMP.BIE_ID = BIENES.BIE_ID)
        WHEN MATCHED THEN UPDATE SET TMP.DESC_LANZAMIENTO_ID = 7,
                                     TMP.FECHA_LANZAMIENTO_BIEN = BIENES.FECHA'; 


        COMMIT;
        
        -- 08 - Lanzamiento Suspendido (por la Entidad) - Celebrado alquiler

        -- O esta situacion:
        EXECUTE IMMEDIATE'
        MERGE INTO TMP_H_BIE TMP USING (
            SELECT PRC.BIE_ID, MAX(TO_DATE(TEV.TEV_VALOR,''RRRR-MM-DD'')) AS FECHA
            FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR, '||V_DATASTAGE||'.PRB_PRC_BIE PRC
            WHERE TEV.TEX_ID = TEX.TEX_ID
            AND TEX.TAP_ID = 10000000004093 -- H015_FormalizacionAlquilerSocial
            AND TEV.TEV_NOMBRE = ''fecha''
            AND TO_DATE(TEV.TEV_VALOR,''RRRR-MM-DD'') <= ''' || fecha || '''
            AND TEX.TAR_ID = TAR.TAR_ID
            AND TAR.PRC_ID = PRC.PRC_ID
            AND EXISTS(SELECT 1
                       FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV3, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX3, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR3
                       WHERE TEV3.TEX_ID = TEX3.TEX_ID
                       AND TEX3.TAP_ID = 10000000004093 -- H015_FormalizacionAlquilerSocial
                       AND TEV3.TEV_NOMBRE = ''alquilerFormalizado''
                       AND TEV3.TEV_VALOR = ''01'' -- SI
                       AND TAR3.PRC_ID = PRC.PRC_ID)
            AND EXISTS(SELECT 1
                       FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV2, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX2, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR2
                       WHERE TEV2.TEX_ID = TEX2.TEX_ID
                       AND TEX2.TAP_ID = 10000000004094 -- H015_SuspensionLanzamiento
                       AND TEX2.TAR_ID = TAR2.TAR_ID
                       AND TAR2.TAR_FECHA_FIN IS NOT NULL
                       AND TAR2.PRC_ID = PRC.PRC_ID)
             GROUP BY PRC.BIE_ID          
                       ) BIENES
        ON (TMP.BIE_ID = BIENES.BIE_ID)
        WHEN MATCHED THEN UPDATE SET TMP.DESC_LANZAMIENTO_ID = 8,
                                     TMP.FECHA_LANZAMIENTO_BIEN = BIENES.FECHA'; 
                                     
        -- O esta otra:
        EXECUTE IMMEDIATE'
        MERGE INTO TMP_H_BIE TMP USING (
            SELECT PRC.BIE_ID, MAX(TO_DATE(TEV.TEV_VALOR,''RRRR-MM-DD'')) AS FECHA
            FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR, '||V_DATASTAGE||'.PRB_PRC_BIE PRC
            WHERE TEV.TEX_ID = TEX.TEX_ID
            AND TEX.TAP_ID = 10000000004520 -- H015_ConfirmarFormalizacion
            AND TEV.TEV_NOMBRE = ''fecha''
            AND TO_DATE(TEV.TEV_VALOR,''RRRR-MM-DD'') <= ''' || fecha || '''
            AND TEX.TAR_ID = TAR.TAR_ID
            AND TAR.PRC_ID = PRC.PRC_ID
            AND EXISTS(SELECT 1
                       FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV3, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX3, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR3
                       WHERE TEV3.TEX_ID = TEX3.TEX_ID
                       AND TEX3.TAP_ID = 10000000004520 -- H015_ConfirmarFormalizacion
                       AND TEV3.TEV_NOMBRE = ''alquilerFormalizado''
                       AND TEV3.TEV_VALOR = ''01'' -- SI
                       AND TAR3.TAR_FECHA_FIN IS NOT NULL
                       AND TAR3.PRC_ID = PRC.PRC_ID)
            AND EXISTS(SELECT 1
                       FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV2, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX2, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR2
                       WHERE TEV2.TEX_ID = TEX2.TEX_ID
                       AND TEX2.TAP_ID = 10000000004094 -- H015_SuspensionLanzamiento
                       AND TEX2.TAR_ID = TAR2.TAR_ID
                       AND TAR2.TAR_FECHA_FIN IS NOT NULL
                       AND TAR2.PRC_ID = PRC.PRC_ID)
            GROUP BY PRC.BIE_ID           
                       ) BIENES
        ON (TMP.BIE_ID = BIENES.BIE_ID)
        WHEN MATCHED THEN UPDATE SET TMP.DESC_LANZAMIENTO_ID = 8,
                                     TMP.FECHA_LANZAMIENTO_BIEN = BIENES.FECHA';
                                     
        COMMIT;
        
        -- 09 - Lanzamiento Suspendido (por la Entidad) - Pdte. Aprob. Alquiler
        EXECUTE IMMEDIATE'
        MERGE INTO TMP_H_BIE TMP USING (
            SELECT PRC.BIE_ID, MAX(TO_DATE(TEV.TEV_VALOR,''RRRR-MM-DD'')) AS FECHA
            FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR, '||V_DATASTAGE||'.PRB_PRC_BIE PRC
            WHERE TEV.TEX_ID = TEX.TEX_ID
            AND TEX.TAP_ID = 10000000004094 -- H015_SuspensionLanzamiento
            AND TEV.TEV_NOMBRE = ''fechaParalizacion''
            AND TO_DATE(TEV.TEV_VALOR,''RRRR-MM-DD'') <= TRUNC(SYSDATE)
            AND TEX.TAR_ID = TAR.TAR_ID
            AND TAR.PRC_ID = PRC.PRC_ID
            AND EXISTS(SELECT 1
                       FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV3, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX3, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR3
                       WHERE TEV3.TEX_ID = TEX3.TEX_ID
                       AND TEX3.TAP_ID = 10000000004093 -- H015_FormalizacionAlquilerSocial
                       AND TEV3.TEV_NOMBRE = ''alquilerFormalizado''
                       AND TEV3.TEV_VALOR = ''02'' -- NO
                       AND TAR3.PRC_ID = PRC.PRC_ID)
            AND EXISTS(SELECT 1
                       FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV2, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX2, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR2
                       WHERE TEV2.TEX_ID = TEX2.TEX_ID
                       AND TEX2.TAP_ID = 10000000004093 -- H015_FormalizacionAlquilerSocial
                       AND TEV2.TEV_NOMBRE = ''posibleFormalizacion''
                       AND TEV2.TEV_VALOR = ''01'' -- SI
                       AND TAR2.PRC_ID = PRC.PRC_ID)
            AND EXISTS(SELECT 1
                       FROM '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR TEV4, '||V_DATASTAGE||'.TEX_TAREA_EXTERNA TEX4, '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES TAR4
                       WHERE TEV4.TEX_ID = TEX4.TEX_ID
                       AND TEX4.TAP_ID = 10000000004520 -- H015_ConfirmarFormalizacion
                       AND TEV4.TEV_NOMBRE = ''alquilerFormalizado''
                       AND TEV4.TEV_VALOR = ''02'' -- NO
                       AND TAR4.PRC_ID = PRC.PRC_ID)
            GROUP BY PRC.BIE_ID           
                       ) BIENES
        ON (TMP.BIE_ID = BIENES.BIE_ID)
        WHEN MATCHED THEN UPDATE SET TMP.DESC_LANZAMIENTO_ID = 9,
                                     TMP.FECHA_LANZAMIENTO_BIEN = BIENES.FECHA';
                                     
        COMMIT;
        
        -- 10 - Lanzamiento Suspendido (por la Entidad) – Otros
        EXECUTE IMMEDIATE'
        MERGE INTO TMP_H_BIE TMP USING(
            SELECT PRB.BIE_ID, NVL(DPR_FECHA_PARA, DPR.FECHACREAR) AS FECHA
            FROM '||V_DATASTAGE||'.DPR_DECISIONES_PROCEDIMIENTOS DPR, '||V_DATASTAGE||'.PRB_PRC_BIE PRB
            WHERE DPR.PRC_ID = PRB.PRC_ID
            AND (DPR_PARALIZA = 1 OR DPR_FINALIZA = 1)
            AND DPR.DD_DPA_ID = (SELECT DD_DPA_ID FROM '||V_DATASTAGE||'.DD_DPA_DECISION_PARALIZAR WHERE DD_DPA_CODIGO = ''INSTR'') -- Instrucciones de la entidad
            AND NVL(DPR_FECHA_PARA, DPR.FECHACREAR) <= ''' || fecha || '''
            ) BIENES
        ON (TMP.BIE_ID = BIENES.BIE_ID)
        WHEN MATCHED THEN UPDATE SET TMP.DESC_LANZAMIENTO_ID = 10,
                                     TMP.FECHA_LANZAMIENTO_BIEN = BIENES.FECHA';

        COMMIT;
        
        -- 11 - Lanzamiento Suspendido (por el Juzgado) – Otros
        EXECUTE IMMEDIATE'
        MERGE INTO TMP_H_BIE TMP USING(
            SELECT PRB.BIE_ID, NVL(DPR_FECHA_PARA, DPR.FECHACREAR) AS FECHA
            FROM '||V_DATASTAGE||'.DPR_DECISIONES_PROCEDIMIENTOS DPR, '||V_DATASTAGE||'.PRB_PRC_BIE PRB
            WHERE DPR.PRC_ID = PRB.PRC_ID
            AND (DPR_PARALIZA = 1 OR DPR_FINALIZA = 1)
            AND DPR.DD_DPA_ID = (SELECT DD_DPA_ID FROM '||V_DATASTAGE||'.DD_DPA_DECISION_PARALIZAR WHERE DD_DPA_CODIGO = ''OTRA'') -- Otras causa
            AND NVL(DPR_FECHA_PARA, DPR.FECHACREAR) <= ''' || fecha || '''
            ) BIENES
        ON (TMP.BIE_ID = BIENES.BIE_ID)
        WHEN MATCHED THEN UPDATE SET TMP.DESC_LANZAMIENTO_ID = 11,
                                     TMP.FECHA_LANZAMIENTO_BIEN = BIENES.FECHA';

        COMMIT;
		
		--12 - Fecha interposicion demanda hipotecario
		
				EXECUTE IMMEDIATE'
		merge into TMP_H_BIE a
    using (select c.PROCEDIMIENTO_ID, max(TRUNC(c.FECHA_FORMULARIO)) as FECHA_FORMULARIO from (select  b.PROCEDIMIENTO_ID, b.BIE_FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, TO_date(TEV_VALOR,''YYYY-MM-DD'')as FECHA_FORMULARIO
    from TMP_H_BIE b
    join '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar on b.BIE_FASE_ACTUAL = tar.PRC_ID and tar.TAR_FECHA_FIN is not null and TRUNC(tar.TAR_FECHA_FIN) <= ''' || fecha || '''
    join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID and tex.tap_id in (10000000004049)
    join '||V_DATASTAGE||'.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID and tev.TEV_NOMBRE in (''fechaPresentacionDemanda'')
    where b.DIA_ID =''' || fecha || ''')c group by c.PROCEDIMIENTO_ID) d
    on (d.PROCEDIMIENTO_ID = a.PROCEDIMIENTO_ID)
    when matched then update set a.FECHA_INTERP_DEM_HIP = d.FECHA_FORMULARIO
		';

        --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_BIE. Merges LANZAMIENTOS realizados (7).', 4;


        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_BIE_IX'', ''TMP_H_BIE (DIA_ID,LOTE_ID,BIE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;

         -- Borrado del día a insertar
         delete from H_BIE where DIA_ID = fecha;
         commit;

         -- Borrado índices H_BIE
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_BIE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
         execute immediate V_SQL USING OUT O_ERROR_STATUS;
         commit;
        
          INSERT INTO H_BIE(
                            DIA_ID,
                            FECHA_CARGA_DATOS,
                            LOTE_ID,
                            BIE_ID,
                            TIPO_BIEN_ID,
                            SUBTIPO_BIEN_ID,
                            POBLACION_BIEN_ID,
                            BIEN_ADJUDICADO_ID,
                            ADJ_CESION_REM_BIEN_ID,
                            CODIGO_ACTIVO_BIEN_ID,
                            ENTIDAD_ADJUDICATARIA_ID,
                            IMP_VALOR_BIEN,
                            IMP_ADJUDICADO,
                            IMP_CESION_REMATE,
                            IMP_BIE_TIPO_SUBASTA,
                            PROCEDIMIENTO_ID,
                            FASE_ACTUAL_DETALLE_ID,
                            TIPO_PROCEDIMIENTO_DET_ID,
                            FASE_ACTUAL_AGR_ID,
                            TITULAR_PROCEDIMIENTO_ID,
                            BIE_FASE_ACTUAL_DETALLE_ID,
                            DESC_LANZAMIENTO_ID,
                            PRIMER_TITULAR_BIE_ID,
                            NUM_OPERACION_BIEN_ID,
                            ZONA_BIEN_ID,
                            OFICINA_BIEN_ID,
                            ENTIDAD_BIEN_ID,
                            FECHA_LANZAMIENTO_BIEN,
							FECHA_INTERP_DEM_HIP
                            )
          SELECT  DIA_ID,
                  FECHA_CARGA_DATOS,
                  LOTE_ID,
                  BIE_ID,
                  TIPO_BIEN_ID,
                  SUBTIPO_BIEN_ID,
                  POBLACION_BIEN_ID,
                  BIEN_ADJUDICADO_ID,
                  ADJ_CESION_REM_BIEN_ID,
                  CODIGO_ACTIVO_BIEN_ID,
                  ENTIDAD_ADJUDICATARIA_ID,
                  IMP_VALOR_BIEN,
                  IMP_ADJUDICADO,
                  IMP_CESION_REMATE,
                  IMP_BIE_TIPO_SUBASTA,
                  PROCEDIMIENTO_ID,
                  FASE_ACTUAL_DETALLE_ID,
                  TIPO_PROCEDIMIENTO_DET_ID,
                  FASE_ACTUAL_AGR_ID,
                  TITULAR_PROCEDIMIENTO_ID,
                  BIE_FASE_ACTUAL_DETALLE_ID,
                  DESC_LANZAMIENTO_ID,
                  PRIMER_TITULAR_BIE_ID,
                  NUM_OPERACION_BIEN_ID,
                  ZONA_BIEN_ID,
                  OFICINA_BIEN_ID,
                  ENTIDAD_BIEN_ID,
                  FECHA_LANZAMIENTO_BIEN,
				  FECHA_INTERP_DEM_HIP
          FROM TMP_H_BIE;

        V_ROWCOUNT := sql%rowcount;
     
        --Log_Proceso
        execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_BIE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
        commit;

    end loop;
  close c_fecha;

          
             V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_BIE_IX'', ''H_BIE (DIA_ID, LOTE_ID, BIEN_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
         
      
-- ----------------------------------------------------------------------------------------------
--                                      H_BIE_SEMANA
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_BIE_SEMANA. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  select max(SEMANA_ID) into V_NUMBER from H_BIE_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) 
    select max(SEMANA_ID) from H_BIE_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  end if;
    
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_SUB;
  update TMP_FECHA tf set tf.SEMANA_H = (select D.SEMANA_ID from D_F_DIA d  where tf.DIA_H = d.DIA_ID);
  delete from TMP_FECHA where SEMANA_H not IN (select distinct SEMANA_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set SEMANA_ANT = (select min(SEMANA_AUX) from TMP_FECHA_AUX where SEMANA_AUX > SEMANA_H);

  -- Bucle que recorre las semanas
  open c_semana;
  loop --C_SEMANAS_LOOP
    fetch c_semana into semana;        
    exit when c_semana%NOTFOUND;
 
    select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = semana;
    
    -- Borrado indices H_PRC_SEMANA 
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_BIE_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
     
    -- Borrado de las semanas a insertar
    delete from H_BIE_SEMANA where SEMANA_ID = semana;
    commit;
    
    insert into H_BIE_SEMANA(
                            SEMANA_ID,
                            FECHA_CARGA_DATOS,
                            LOTE_ID,
                            BIE_ID,
                            TIPO_BIEN_ID,
                            SUBTIPO_BIEN_ID,
                            POBLACION_BIEN_ID,
                            BIEN_ADJUDICADO_ID,
                            ADJ_CESION_REM_BIEN_ID,
                            CODIGO_ACTIVO_BIEN_ID,
                            ENTIDAD_ADJUDICATARIA_ID,
                            IMP_VALOR_BIEN,
                            IMP_ADJUDICADO,
                            IMP_CESION_REMATE,
                            IMP_BIE_TIPO_SUBASTA,
                            PROCEDIMIENTO_ID,
                            FASE_ACTUAL_DETALLE_ID,
                            TIPO_PROCEDIMIENTO_DET_ID,
                            FASE_ACTUAL_AGR_ID,
                            TITULAR_PROCEDIMIENTO_ID,
                            BIE_FASE_ACTUAL_DETALLE_ID,
                            DESC_LANZAMIENTO_ID,
                            PRIMER_TITULAR_BIE_ID,
                            NUM_OPERACION_BIEN_ID,
                            ZONA_BIEN_ID,
                            OFICINA_BIEN_ID,
                            ENTIDAD_BIEN_ID,
                            FECHA_LANZAMIENTO_BIEN,
							FECHA_INTERP_DEM_HIP
                            )
    select semana, 
           max_dia_semana,
          LOTE_ID,
          BIE_ID,
          TIPO_BIEN_ID,
          SUBTIPO_BIEN_ID,
          POBLACION_BIEN_ID,
          BIEN_ADJUDICADO_ID,
          ADJ_CESION_REM_BIEN_ID,
          CODIGO_ACTIVO_BIEN_ID,
          ENTIDAD_ADJUDICATARIA_ID,
          IMP_VALOR_BIEN,
          IMP_ADJUDICADO,
          IMP_CESION_REMATE,
          IMP_BIE_TIPO_SUBASTA,
          PROCEDIMIENTO_ID,
          FASE_ACTUAL_DETALLE_ID,
          TIPO_PROCEDIMIENTO_DET_ID,
          FASE_ACTUAL_AGR_ID,
          TITULAR_PROCEDIMIENTO_ID,
          BIE_FASE_ACTUAL_DETALLE_ID,
          DESC_LANZAMIENTO_ID,
          PRIMER_TITULAR_BIE_ID,
          NUM_OPERACION_BIEN_ID,
          ZONA_BIEN_ID,
          OFICINA_BIEN_ID,
          ENTIDAD_BIEN_ID,
          FECHA_LANZAMIENTO_BIEN,
		  FECHA_INTERP_DEM_HIP
     from H_BIE
     where DIA_ID = max_dia_semana;
     
     V_ROWCOUNT := sql%rowcount;
     
     
     --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_BIE_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
      commit;
      
        
           V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_BIE_SEMANA_IX'', ''H_BIE_SEMANA (SEMANA_ID, LOTE_ID, BIEN_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
       
    
    end loop C_SEMANAS_LOOP;
    close c_semana; 

-- ----------------------------------------------------------------------------------------------
--                                      H_BIE_MES
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_BIE_MES. Empieza Carga', 3;


  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_BIE_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_BIE;
  update TMP_FECHA tf set tf.MES_H = (select D.MES_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where MES_H not IN (select distinct MES_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set MES_ANT = (select min(MES_AUX) from TMP_FECHA_AUX where MES_AUX > MES_H);
  
  -- Bucle que recorre los meses
  open c_mes;
  loop --C_MESES_LOOP
    fetch c_mes into mes;        
    exit when c_mes%NOTFOUND;
  
      select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = mes;

      -- Borrado indices H_PRC_MES
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_BIE_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
       execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      -- Borrado de los meses a insertar
      delete from H_BIE_MES where MES_ID = mes;
      commit;
      
      -- Insertado de meses (�ltimo d�a del mes disponible en H_PRC)
      insert into H_BIE_MES(
                    MES_ID,
                    FECHA_CARGA_DATOS,
                    LOTE_ID,
                    BIE_ID,
                    TIPO_BIEN_ID,
                    SUBTIPO_BIEN_ID,
                    POBLACION_BIEN_ID,
                    BIEN_ADJUDICADO_ID,
                    ADJ_CESION_REM_BIEN_ID,
                    CODIGO_ACTIVO_BIEN_ID,
                    ENTIDAD_ADJUDICATARIA_ID,
                    IMP_VALOR_BIEN,
                    IMP_ADJUDICADO,
                    IMP_CESION_REMATE,
                    IMP_BIE_TIPO_SUBASTA,
                    PROCEDIMIENTO_ID,
                    FASE_ACTUAL_DETALLE_ID,
                    TIPO_PROCEDIMIENTO_DET_ID,
                    FASE_ACTUAL_AGR_ID,
                    TITULAR_PROCEDIMIENTO_ID,
                    BIE_FASE_ACTUAL_DETALLE_ID,
                    DESC_LANZAMIENTO_ID,
                    PRIMER_TITULAR_BIE_ID,
                    NUM_OPERACION_BIEN_ID,
                    ZONA_BIEN_ID,
                    OFICINA_BIEN_ID,
                    ENTIDAD_BIEN_ID,
                    FECHA_LANZAMIENTO_BIEN,
					FECHA_INTERP_DEM_HIP
                  )
      select mes,
             max_dia_mes,
              LOTE_ID,
              BIE_ID,
              TIPO_BIEN_ID,
              SUBTIPO_BIEN_ID,
              POBLACION_BIEN_ID,
              BIEN_ADJUDICADO_ID,
              ADJ_CESION_REM_BIEN_ID,
              CODIGO_ACTIVO_BIEN_ID,
              ENTIDAD_ADJUDICATARIA_ID,
              IMP_VALOR_BIEN,
              IMP_ADJUDICADO,
              IMP_CESION_REMATE,
              IMP_BIE_TIPO_SUBASTA,
              PROCEDIMIENTO_ID,
              FASE_ACTUAL_DETALLE_ID,
              TIPO_PROCEDIMIENTO_DET_ID,
              FASE_ACTUAL_AGR_ID,
              TITULAR_PROCEDIMIENTO_ID,
              BIE_FASE_ACTUAL_DETALLE_ID,
              DESC_LANZAMIENTO_ID,
              PRIMER_TITULAR_BIE_ID,
              NUM_OPERACION_BIEN_ID,
              ZONA_BIEN_ID,
              OFICINA_BIEN_ID,
              ENTIDAD_BIEN_ID,
              FECHA_LANZAMIENTO_BIEN,
			  FECHA_INTERP_DEM_HIP
      from H_BIE where DIA_ID = max_dia_mes;
      
      V_ROWCOUNT := sql%rowcount;     

      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_BIE_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
      commit;     
 
      -- Crear indices H_PRC_MES 
        
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_BIE_MES_IX'', ''H_BIE_MES (MES_ID, LOTE_ID, BIEN_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      commit;  

   end loop C_MESES_LOOP;
  close c_mes;
--                                      H_BIE_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_BIE_TRIMESTRE. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_BIE_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_BIE;
  update TMP_FECHA tf set tf.TRIMESTRE_H = (select D.TRIMESTRE_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where TRIMESTRE_H not IN (select distinct TRIMESTRE_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set TRIMESTRE_ANT = (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX where TRIMESTRE_AUX > TRIMESTRE_H);
  
  -- Bucle que recorre los trimestres
  open c_trimestre;
  loop --C_TRIMESTRE_LOOP
    fetch c_trimestre into trimestre;        
    exit when c_trimestre%NOTFOUND;
  
      select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;
      
      -- Borrar indices H_PRC_TRIMESTRE
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_BIE_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      -- Borrado de los trimestres a insertar
      delete from H_BIE_TRIMESTRE where TRIMESTRE_ID = trimestre;
      commit;
      
      insert into H_BIE_TRIMESTRE(
                  TRIMESTRE_ID,
                  FECHA_CARGA_DATOS,
                  LOTE_ID,
                  BIE_ID,
                  TIPO_BIEN_ID,
                  SUBTIPO_BIEN_ID,
                  POBLACION_BIEN_ID,
                  BIEN_ADJUDICADO_ID,
                  ADJ_CESION_REM_BIEN_ID,
                  CODIGO_ACTIVO_BIEN_ID,
                  ENTIDAD_ADJUDICATARIA_ID,
                  IMP_VALOR_BIEN,
                  IMP_ADJUDICADO,
                  IMP_CESION_REMATE,
                  IMP_BIE_TIPO_SUBASTA,
                  PROCEDIMIENTO_ID,
                  FASE_ACTUAL_DETALLE_ID,
                  TIPO_PROCEDIMIENTO_DET_ID,
                  FASE_ACTUAL_AGR_ID,
                  TITULAR_PROCEDIMIENTO_ID,
                  BIE_FASE_ACTUAL_DETALLE_ID,
                  DESC_LANZAMIENTO_ID,
                  PRIMER_TITULAR_BIE_ID,
                  NUM_OPERACION_BIEN_ID,
                  ZONA_BIEN_ID,
                  OFICINA_BIEN_ID,
                  ENTIDAD_BIEN_ID,
                  FECHA_LANZAMIENTO_BIEN,
				  FECHA_INTERP_DEM_HIP
                  )
      select trimestre,
             max_dia_trimestre,
              LOTE_ID,
              BIE_ID,
              TIPO_BIEN_ID,
              SUBTIPO_BIEN_ID,
              POBLACION_BIEN_ID,
              BIEN_ADJUDICADO_ID,
              ADJ_CESION_REM_BIEN_ID,
              CODIGO_ACTIVO_BIEN_ID,
              ENTIDAD_ADJUDICATARIA_ID,
              IMP_VALOR_BIEN,
              IMP_ADJUDICADO,
              IMP_CESION_REMATE,
              IMP_BIE_TIPO_SUBASTA,
              PROCEDIMIENTO_ID,
              FASE_ACTUAL_DETALLE_ID,
              TIPO_PROCEDIMIENTO_DET_ID,
              FASE_ACTUAL_AGR_ID,
              TITULAR_PROCEDIMIENTO_ID,
              BIE_FASE_ACTUAL_DETALLE_ID,
              DESC_LANZAMIENTO_ID,
              PRIMER_TITULAR_BIE_ID,
              NUM_OPERACION_BIEN_ID,
              ZONA_BIEN_ID,
              OFICINA_BIEN_ID,
              ENTIDAD_BIEN_ID,
              FECHA_LANZAMIENTO_BIEN,
			  FECHA_INTERP_DEM_HIP
      from H_BIE where DIA_ID = max_dia_trimestre;
      
      V_ROWCOUNT := sql%rowcount;     

      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_BIE_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
      commit;     
 
      -- Crear indices H_BIE_TRIMESTRE 
       
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_BIE_TRIMESTRE_IX'', ''H_BIE_TRIMESTRE (MES_ID, LOTE_ID, BIEN_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      commit;  

   end loop C_TRIMESTRE_LOOP;
  close c_trimestre;

-- ----------------------------------------------------------------------------------------------
--                                      H_BIE_ANIO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_BIE_ANIO. Empieza bucle', 3;
  
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_BIE_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_BIE;
  update TMP_FECHA tf set tf.ANIO_H = (select D.ANIO_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where ANIO_H not IN (select distinct ANIO_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set ANIO_ANT = (select min(ANIO_AUX) from TMP_FECHA_AUX where ANIO_AUX > ANIO_H);
  
  -- Bucle que recorre los a�os
  open c_anio;
  loop --C_ANIO_LOOP
    fetch c_anio into anio;        
    exit when c_anio%NOTFOUND;
  
      select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;
      
      -- Crear indices H_PRC_ANIO
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_BIE_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      
      -- Borrado de los a�s a insertar
      delete from H_BIE_ANIO where ANIO_ID = anio;
      commit;

      insert into H_BIE_ANIO(
                  ANIO_ID,
                  FECHA_CARGA_DATOS,
                  LOTE_ID,
                  BIE_ID,
                  TIPO_BIEN_ID,
                  SUBTIPO_BIEN_ID,
                  POBLACION_BIEN_ID,
                  BIEN_ADJUDICADO_ID,
                  ADJ_CESION_REM_BIEN_ID,
                  CODIGO_ACTIVO_BIEN_ID,
                  ENTIDAD_ADJUDICATARIA_ID,
                  IMP_VALOR_BIEN,
                  IMP_ADJUDICADO,
                  IMP_CESION_REMATE,
                  IMP_BIE_TIPO_SUBASTA,
                  PROCEDIMIENTO_ID,
                  FASE_ACTUAL_DETALLE_ID,
                  TIPO_PROCEDIMIENTO_DET_ID,
                  FASE_ACTUAL_AGR_ID,
                  TITULAR_PROCEDIMIENTO_ID,
                  BIE_FASE_ACTUAL_DETALLE_ID,
                  DESC_LANZAMIENTO_ID,
                  PRIMER_TITULAR_BIE_ID,
                  NUM_OPERACION_BIEN_ID,
                  ZONA_BIEN_ID,
                  OFICINA_BIEN_ID,
                  ENTIDAD_BIEN_ID,
                  FECHA_LANZAMIENTO_BIEN,
				  FECHA_INTERP_DEM_HIP
                  )
      select anio,
             max_dia_anio,
              LOTE_ID,
              BIE_ID,
              TIPO_BIEN_ID,
              SUBTIPO_BIEN_ID,
              POBLACION_BIEN_ID,
              BIEN_ADJUDICADO_ID,
              ADJ_CESION_REM_BIEN_ID,
              CODIGO_ACTIVO_BIEN_ID,
              ENTIDAD_ADJUDICATARIA_ID,
              IMP_VALOR_BIEN,
              IMP_ADJUDICADO,
              IMP_CESION_REMATE,
              IMP_BIE_TIPO_SUBASTA,
              PROCEDIMIENTO_ID,
              FASE_ACTUAL_DETALLE_ID,
              TIPO_PROCEDIMIENTO_DET_ID,
              FASE_ACTUAL_AGR_ID,
              TITULAR_PROCEDIMIENTO_ID,
              BIE_FASE_ACTUAL_DETALLE_ID,
              DESC_LANZAMIENTO_ID,
              PRIMER_TITULAR_BIE_ID,
              NUM_OPERACION_BIEN_ID,
              ZONA_BIEN_ID,
              OFICINA_BIEN_ID,
              ENTIDAD_BIEN_ID,
              FECHA_LANZAMIENTO_BIEN,
			  FECHA_INTERP_DEM_HIP
      from H_BIE where DIA_ID = max_dia_anio;
      
      V_ROWCOUNT := sql%rowcount;     

      --Log_Proceso
      execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_BIE_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
      commit;     
 
      -- Crear indices H_PRC_MES 
      
         V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_BIE_ANIO_IX'', ''H_BIE_ANIO (MES_ID, LOTE_ID, BIEN_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
     
      commit; 

   end loop C_ANIO_LOOP;
  close c_anio;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'H_BIE_ANIO. Termina Carga', 3;  

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

EXCEPTION
  WHEN OBJECTEXISTS then
    O_ERROR_STATUS := 'La tabla ya existe';
    --ROLLBACK;
  WHEN INSERT_NULL then
    O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
    --ROLLBACK;
  WHEN PARAMETERS_NUMBER then
    O_ERROR_STATUS := 'Número de parámetros incorrecto';
    --ROLLBACK;
  WHEN OTHERS then
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;

    DBMS_OUTPUT.PUT_LINE(SQLCODE||' -> '||SQLERRM);
    --ROLLBACK;
end;

END CARGAR_H_BIEN;

