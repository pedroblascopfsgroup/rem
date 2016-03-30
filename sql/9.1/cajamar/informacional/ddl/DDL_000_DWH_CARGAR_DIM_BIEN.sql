--/*
--##########################################
--## AUTOR=Pedro S.
--## FECHA_CREACION=20160330
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-2314
--## PRODUCTO=NO
--## 
--## Finalidad: GARANTIA_NUM_OPE_BIE
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
create or replace PROCEDURE CARGAR_DIM_BIEN(O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Jaime Sánchez-Cuenca, PFS Group
-- Fecha creacion: Septiembre 2015
-- Responsable ultima modificacion: Pedro S., PFS Group
-- Fecha ultima modificacion: 28/03/2016
-- Motivos del cambio: GARANTIA_NUM_OPE_BIE
-- Cliente: Recovery BI CAJAMAR
--
-- Descripcion: Procedimiento almancenado que carga las tablas de la dimension Subasta
-- ===============================================================================================
 

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION SUBASTA

    -- D_BIE
    -- D_BIE_TIPO_BIEN
    -- D_BIE_SUBTIPO_BIEN
    -- D_BIE_POBLACION
    -- D_BIE_ADJUDICADO
    -- D_BIE_ADJ_CESION_REM
    -- D_BIE_CODIGO_ACTIVO
    -- D_BIE_ENTIDAD_ADJUDICATARIA
    -- D_BIE_FASE_ACTUAL_DETALLE
    -- D_BIE_DESC_LANZAMIENTOS
    -- D_BIE_PRIMER_TITULAR
    -- D_BIE_NUM_OPERACION
    -- D_BIE_ZONA
    -- D_BIE_OFICINA
    -- D_BIE_ENTIDAD
	-- D_BIE_GARANTIA_NUM_OPE_BIE_AGR
	-- D_BIE_GARANTIA_NUM_OPE_BIE

V_NOMBRE VARCHAR2(50) := 'CARGAR_DIM_BIEN';
V_ROWCOUNT NUMBER;

BEGIN
DECLARE

OBJECTEXISTS EXCEPTION;
INSERT_NULL EXCEPTION;
PARAMETERS_NUMBER EXCEPTION;
PRAGMA EXCEPTION_INIT(OBJECTEXISTS, -955);
PRAGMA EXCEPTION_INIT(INSERT_NULL, -1400);
PRAGMA EXCEPTION_INIT(PARAMETERS_NUMBER, -909);

V_NUM_ROW NUMBER(10);
V_DATASTAGE VARCHAR2(100);

BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
  select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';

 
-- ----------------------------------------------------------------------------------------------
--                                      D_BIE
-- ----------------------------------------------------------------------------------------------

  EXECUTE IMMEDIATE
    'INSERT INTO D_BIE(BIE_ID, BIE_DESC, BIE_DESC_2, BIE_DESC_3)
     SELECT BIE_ID, BIE_DATOS_REGISTRALES, BIE_DESCRIPCION, TO_CHAR(BIE_ID) FROM '||V_DATASTAGE||'.BIE_BIEN';

  V_ROWCOUNT := sql%rowcount;     
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit; 


-- ----------------------------------------------------------------------------------------------
--                                      D_BIE_TIPO_BIEN
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_TIPO_BIEN WHERE TIPO_BIEN_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_TIPO_BIEN (TIPO_BIEN_ID, TIPO_BIEN_DESC, TIPO_BIEN_DESC_2) VALUES (-1 ,'Tipo de Bien Desconocido', 'Tipo de Bien Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_BIE_TIPO_BIEN (TIPO_BIEN_ID, TIPO_BIEN_DESC, TIPO_BIEN_DESC_2)
     SELECT DD_TBI_ID, DD_TBI_DESCRIPCION, DD_TBI_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_TBI_TIPO_BIEN';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_TIPO_BIEN. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;


-- ----------------------------------------------------------------------------------------------
--                                      D_BIE_SUBTIPO_BIEN
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_SUBTIPO_BIEN WHERE SUBTIPO_BIEN_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_SUBTIPO_BIEN(SUBTIPO_BIEN_ID, SUBTIPO_BIEN_DESC, SUBTIPO_BIEN_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_BIE_SUBTIPO_BIEN(SUBTIPO_BIEN_ID, SUBTIPO_BIEN_DESC, SUBTIPO_BIEN_DESC_2)
     SELECT DD_TPN_ID,DD_TPN_DESCRIPCION, DD_TPN_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_TPN_TIPO_INMUEBLE';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_SUBTIPO_BIEN. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;

  
-- ----------------------------------------------------------------------------------------------
--                                      D_BIE_POBLACION
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_POBLACION WHERE POBLACION_BIEN_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_POBLACION (POBLACION_BIEN_ID, POBLACION_BIEN_DESC, POBLACION_BIEN_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_BIE_POBLACION (POBLACION_BIEN_ID, POBLACION_BIEN_DESC, POBLACION_BIEN_DESC_2)
     SELECT DD_LOC_ID, DD_LOC_DESCRIPCION, DD_LOC_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_LOC_LOCALIDAD';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_POBLACION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;  
  
  
-- ----------------------------------------------------------------------------------------------
--                                      D_BIE_ADJUDICADO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_ADJUDICADO WHERE BIEN_ADJUDICADO_ID = 0;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_ADJUDICADO (BIEN_ADJUDICADO_ID, BIEN_ADJUDICADO_DESC, BIEN_ADJUDICADO_DESC_2) VALUES (0 ,'No', 'Bien No Adjudicado');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_ADJUDICADO WHERE BIEN_ADJUDICADO_ID = 1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_ADJUDICADO (BIEN_ADJUDICADO_ID, BIEN_ADJUDICADO_DESC, BIEN_ADJUDICADO_DESC_2) VALUES (1 ,'Si', 'Bien Adjudicado');
  END IF;

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_ADJUDICADO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;  
  

-- ----------------------------------------------------------------------------------------------
--                                      D_BIE_ADJ_CESION_REM
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_ADJ_CESION_REM WHERE ADJ_CESION_REM_BIEN_ID = 0;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_ADJ_CESION_REM (ADJ_CESION_REM_BIEN_ID, ADJ_CESION_REM_BIEN_DESC, ADJ_CESION_REM_BIEN_DESC_2) VALUES (0 ,'Bien Sin Cesión Remate', 'Bien Sin Cesión Remate');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_ADJ_CESION_REM WHERE ADJ_CESION_REM_BIEN_ID = 1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_ADJ_CESION_REM (ADJ_CESION_REM_BIEN_ID, ADJ_CESION_REM_BIEN_DESC, ADJ_CESION_REM_BIEN_DESC_2) VALUES (1 ,'Bien Con Cesión Remate', 'Bien Con Cesión Remate');
  END IF;

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_ADJ_CESION_REM. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;  

-- ----------------------------------------------------------------------------------------------
--                                     D_BIE_CODIGO_ACTIVO
-- ----------------------------------------------------------------------------------------------

  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_CODIGO_ACTIVO WHERE CODIGO_ACTIVO_BIEN_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_CODIGO_ACTIVO (CODIGO_ACTIVO_BIEN_ID, CODIGO_ACTIVO_BIEN_DESC) VALUES (-1 ,'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_BIE_CODIGO_ACTIVO (CODIGO_ACTIVO_BIEN_ID, CODIGO_ACTIVO_BIEN_DESC)
     SELECT DISTINCT BIE_NUMERO_ACTIVO, BIE_NUMERO_ACTIVO FROM '||V_DATASTAGE||'.BIE_BIEN WHERE BIE_NUMERO_ACTIVO IS NOT NULL ORDER BY 1';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_CODIGO_ACTIVO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit;  

-- ----------------------------------------------------------------------------------------------
--                                     D_BIE_ENTIDAD_ADJUDICATARIA
-- ----------------------------------------------------------------------------------------------

--  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_ENTIDAD_ADJUDICATARIA WHERE ENTIDAD_ADJUDICATARIA_ID = -1;
--  IF (V_NUM_ROW = 0) THEN
--    INSERT INTO D_BIE_ENTIDAD_ADJUDICATARIA (ENTIDAD_ADJUDICATARIA_ID, ENTIDAD_ADJUDICATARIA_DESC, ENTIDAD_ADJUDICATARIA_DESC_2) VALUES (-1 ,' ', ' ');
--  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_BIE_ENTIDAD_ADJUDICATARIA (ENTIDAD_ADJUDICATARIA_ID, ENTIDAD_ADJUDICATARIA_DESC, ENTIDAD_ADJUDICATARIA_DESC_2)
     SELECT DD_EAD_ID, DD_EAD_DESCRIPCION, DD_EAD_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_EAD_ENTIDAD_ADJUDICA';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_ENTIDAD_ADJUDICATARIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  commit; 

-- ----------------------------------------------------------------------------------------------
--                           D_BIE_FASE_ACTUAL_DETALLE
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_FASE_ACTUAL_DETALLE WHERE BIE_FASE_ACTUAL_DETALLE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_FASE_ACTUAL_DETALLE (BIE_FASE_ACTUAL_DETALLE_ID, BIE_FASE_ACTUAL_DETALLE_DESC, BIE_FASE_ACTUAL_DETALLE_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_BIE_FASE_ACTUAL_DETALLE(BIE_FASE_ACTUAL_DETALLE_ID, BIE_FASE_ACTUAL_DETALLE_DESC, BIE_FASE_ACTUAL_DETALLE_DESC_2)
     SELECT DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_TPO_TIPO_PROCEDIMIENTO';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_FASE_ACTUAL_DETALLE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;  

-- ----------------------------------------------------------------------------------------------
--                           D_BIE_DESC_LANZAMIENTOS
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_DESC_LANZAMIENTOS WHERE DESC_LANZAMIENTO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_DESC_LANZAMIENTOS (DESC_LANZAMIENTO_ID, DESC_LANZAMIENTO_DESC, DESC_LANZAMIENTO_DESC_2) VALUES (-1 ,'', 'Desconocido');
  END IF;

  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_DESC_LANZAMIENTOS WHERE DESC_LANZAMIENTO_ID = 1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_DESC_LANZAMIENTOS (DESC_LANZAMIENTO_ID, DESC_LANZAMIENTO_DESC, DESC_LANZAMIENTO_DESC_2) VALUES (1 ,'', '01 - Entrega Voluntaria - Dación en pago');
  END IF;

  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_DESC_LANZAMIENTOS WHERE DESC_LANZAMIENTO_ID = 2;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_DESC_LANZAMIENTOS (DESC_LANZAMIENTO_ID, DESC_LANZAMIENTO_DESC, DESC_LANZAMIENTO_DESC_2) VALUES (2 ,'', '02 - Entrega Voluntaria - Otros');
  END IF;

  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_DESC_LANZAMIENTOS WHERE DESC_LANZAMIENTO_ID = 3;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_DESC_LANZAMIENTOS (DESC_LANZAMIENTO_ID, DESC_LANZAMIENTO_DESC, DESC_LANZAMIENTO_DESC_2) VALUES (3 ,'', '03 - Lanzamiento Celebrado - Vivienda no ocupada');
  END IF;

  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_DESC_LANZAMIENTOS WHERE DESC_LANZAMIENTO_ID = 4;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_DESC_LANZAMIENTOS (DESC_LANZAMIENTO_ID, DESC_LANZAMIENTO_DESC, DESC_LANZAMIENTO_DESC_2) VALUES (4 ,'', '04 - Lanzamiento Celebrado - Vivienda ocupada');
  END IF;

  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_DESC_LANZAMIENTOS WHERE DESC_LANZAMIENTO_ID = 5;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_DESC_LANZAMIENTOS (DESC_LANZAMIENTO_ID, DESC_LANZAMIENTO_DESC, DESC_LANZAMIENTO_DESC_2) VALUES (5 ,'', '05 - Lanzamiento Celebrado - Intervención FF.OO.');
  END IF;

  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_DESC_LANZAMIENTOS WHERE DESC_LANZAMIENTO_ID = 6;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_DESC_LANZAMIENTOS (DESC_LANZAMIENTO_ID, DESC_LANZAMIENTO_DESC, DESC_LANZAMIENTO_DESC_2) VALUES (6 ,'', '06 - Lanzamiento Suspendido (por el Juzgado) - Por RD 27/2012-Ley 01/2013');
  END IF;

  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_DESC_LANZAMIENTOS WHERE DESC_LANZAMIENTO_ID = 7;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_DESC_LANZAMIENTOS (DESC_LANZAMIENTO_ID, DESC_LANZAMIENTO_DESC, DESC_LANZAMIENTO_DESC_2) VALUES (7 ,'', '07 - Lanzamiento Suspendido (por el Juzgado) - Por título reconocido');
  END IF;

  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_DESC_LANZAMIENTOS WHERE DESC_LANZAMIENTO_ID = 8;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_DESC_LANZAMIENTOS (DESC_LANZAMIENTO_ID, DESC_LANZAMIENTO_DESC, DESC_LANZAMIENTO_DESC_2) VALUES (8 ,'', '08 - Lanzamiento Suspendido (por la Entidad) - Celebrado alquiler');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_DESC_LANZAMIENTOS WHERE DESC_LANZAMIENTO_ID = 9;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_DESC_LANZAMIENTOS (DESC_LANZAMIENTO_ID, DESC_LANZAMIENTO_DESC, DESC_LANZAMIENTO_DESC_2) VALUES (9 ,'', '09 - Lanzamiento Suspendido (por la Entidad) - Pdte. Aprob. Alquiler');
  END IF;

  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_DESC_LANZAMIENTOS WHERE DESC_LANZAMIENTO_ID = 10;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_DESC_LANZAMIENTOS (DESC_LANZAMIENTO_ID, DESC_LANZAMIENTO_DESC, DESC_LANZAMIENTO_DESC_2) VALUES (10 ,'', '10 - Lanzamiento Suspendido (por la Entidad) - Otros');
  END IF;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_DESC_LANZAMIENTOS WHERE DESC_LANZAMIENTO_ID = 11;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_DESC_LANZAMIENTOS (DESC_LANZAMIENTO_ID, DESC_LANZAMIENTO_DESC, DESC_LANZAMIENTO_DESC_2) VALUES (11 ,'', '11 - Lanzamiento Suspendido (por el Juzgado) – Otros');
  END IF;
  
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_DESC_LANZAMIENTOS. Tabla Cargada', 3;  
  
  
-- ----------------------------------------------------------------------------------------------
--                           D_BIE_PRIMER_TITULAR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_PRIMER_TITULAR WHERE PRIMER_TITULAR_BIE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_PRIMER_TITULAR (PRIMER_TITULAR_BIE_ID, PRIMER_TITULAR_BIE_DOCUMENT_ID, PRIMER_TITULAR_BIE_NOMBRE, PRIMER_TITULAR_BIE_APELLIDO_1, PRIMER_TITULAR_BIE_APELLIDO_2)
    VALUES (-1 ,'Desconocido', 'Desconocido' ,'Desconocido' ,'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
      'INSERT INTO D_BIE_PRIMER_TITULAR (PRIMER_TITULAR_BIE_ID, PRIMER_TITULAR_BIE_DOCUMENT_ID, PRIMER_TITULAR_BIE_NOMBRE, PRIMER_TITULAR_BIE_APELLIDO_1, PRIMER_TITULAR_BIE_APELLIDO_2)
      SELECT MAX(AUX_TITULARES.PER_ID) PER_ID, AUX_TITULARES.PER_DOC_ID, AUX_TITULARES.PER_NOMBRE, AUX_TITULARES.PER_APELLIDO1, AUX_TITULARES.PER_APELLIDO2 FROM(
        SELECT DISTINCT PER.PER_ID, PER.PER_DOC_ID, PER.PER_NOMBRE, PER.PER_APELLIDO1, PER.PER_APELLIDO2, CPE.CPE_ORDEN, rank() over (partition by AUX.ASU_ID order by cpe.cpe_orden) as ranking2 FROM(
                                SELECT DISTINCT ASU.ASU_ID, CNT.CNT_ID, MOV.MOV_POS_VIVA_VENCIDA + MOV_POS_VIVA_NO_VENCIDA, rank() over (partition by ASU.ASU_ID order by (MOV.MOV_POS_VIVA_VENCIDA + MOV_POS_VIVA_NO_VENCIDA) DESC, MOV_ID) as ranking
                                FROM '||V_DATASTAGE||'.CNT_CONTRATOS CNT, '||V_DATASTAGE||'.MOV_MOVIMIENTOS MOV, '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE CEX, '||V_DATASTAGE||'.EXP_EXPEDIENTES EXP,
                                     '||V_DATASTAGE||'.ASU_ASUNTOS ASU
                                WHERE CNT.CNT_ID = MOV.CNT_ID
                                AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION
                                AND CNT.CNT_ID = CEX.CNT_ID
                                AND CEX.EXP_ID = EXP.EXP_ID
                                AND EXP.EXP_ID = ASU.EXP_ID
                    ) AUX,
                    '||V_DATASTAGE||'.CPE_CONTRATOS_PERSONAS CPE, '||V_DATASTAGE||'.DD_TIN_TIPO_INTERVENCION TIN, '||V_DATASTAGE||'.PER_PERSONAS PER
                        WHERE AUX.CNT_ID = CPE.CNT_ID
                        AND CPE.DD_TIN_ID = TIN.DD_TIN_ID AND TIN.DD_TIN_TITULAR = 1
                        AND CPE.PER_ID = PER.PER_ID AND PER.BORRADO = 0
                        AND AUX.RANKING = 1) AUX_TITULARES
                     WHERE AUX_TITULARES.RANKING2 = 1
     GROUP BY AUX_TITULARES.PER_DOC_ID, AUX_TITULARES.PER_NOMBRE, AUX_TITULARES.PER_APELLIDO1, AUX_TITULARES.PER_APELLIDO2
     ORDER BY 1';
     
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_PRIMER_TITULAR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;  


-- ----------------------------------------------------------------------------------------------
--                           D_BIE_NUM_OPERACION
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_NUM_OPERACION WHERE NUM_OPERACION_BIEN_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_NUM_OPERACION (NUM_OPERACION_BIEN_ID, NUM_OPERACION_BIEN_DESC, NUM_OPERACION_BIEN_DESC_2, GARANTIA_NUM_OPE_BIE_ID)
    VALUES (-1 ,'Desconocido', '', -1);
  END IF;

  EXECUTE IMMEDIATE
      'INSERT INTO D_BIE_NUM_OPERACION (NUM_OPERACION_BIEN_ID, NUM_OPERACION_BIEN_DESC, NUM_OPERACION_BIEN_DESC_2, GARANTIA_NUM_OPE_BIE_ID)
       SELECT DISTINCT AUX.CNT_ID, LPAD(AUX.CNT_CONTRATO,16,''0''), AUX.CNT_CCC_DOMICILIACION, NVL(DD_GC1_ID, -1) FROM(
                                SELECT DISTINCT ASU.ASU_ID, CNT.CNT_ID, CNT.CNT_CONTRATO, CNT.CNT_CCC_DOMICILIACION, DD_GC1_ID, MOV.MOV_POS_VIVA_VENCIDA + MOV_POS_VIVA_NO_VENCIDA, rank() over (partition by ASU.ASU_ID order by (MOV.MOV_POS_VIVA_VENCIDA + MOV_POS_VIVA_NO_VENCIDA) DESC, MOV_ID) as ranking
                                FROM '||V_DATASTAGE||'.CNT_CONTRATOS CNT, '||V_DATASTAGE||'.MOV_MOVIMIENTOS MOV, '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE CEX, '||V_DATASTAGE||'.EXP_EXPEDIENTES EXP,
                                     '||V_DATASTAGE||'.ASU_ASUNTOS ASU
                                WHERE CNT.CNT_ID = MOV.CNT_ID
                                AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION
                                AND CNT.CNT_ID = CEX.CNT_ID
                                AND CEX.EXP_ID = EXP.EXP_ID
                                AND EXP.EXP_ID = ASU.EXP_ID
                    ) AUX
                WHERE AUX.RANKING = 1
        ORDER BY 1';
        
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_NUM_OPERACION. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;      
        
-- ----------------------------------------------------------------------------------------------
--                           D_BIE_ZONA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_ZONA WHERE ZONA_BIEN_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_ZONA (ZONA_BIEN_ID, ZONA_BIEN_DESC, ZONA_BIEN_DESC_2)
    VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
      'INSERT INTO D_BIE_ZONA (ZONA_BIEN_ID, ZONA_BIEN_DESC, ZONA_BIEN_DESC_2)
       SELECT DISTINCT ZON.ZON_ID, ZON.ZON_DESCRIPCION, ZON.ZON_DESCRIPCION_LARGA
       FROM '||V_DATASTAGE||'.ZON_ZONIFICACION ZON
       ORDER BY 1';
        
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_ZONA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                           D_BIE_OFICINA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_OFICINA WHERE OFICINA_BIEN_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_OFICINA (OFICINA_BIEN_ID, OFICINA_BIEN_DESC, OFICINA_BIEN_DESC_2)
    VALUES (-1 ,'Desconocido', '');
  END IF;

  EXECUTE IMMEDIATE
      'INSERT INTO D_BIE_OFICINA (OFICINA_BIEN_ID, OFICINA_BIEN_DESC, OFICINA_BIEN_DESC_2)
       SELECT DISTINCT OFI.OFI_ID, OFI.OFI_NOMBRE, NULL
       FROM '||V_DATASTAGE||'.OFI_OFICINAS OFI
       ORDER BY 1';
        
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_OFICINA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                           D_BIE_ENTIDAD
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_BIE_ENTIDAD WHERE ENTIDAD_BIEN_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_BIE_ENTIDAD (ENTIDAD_BIEN_ID, ENTIDAD_BIEN_DESC, ENTIDAD_BIEN_DESC_2)
    VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
      'INSERT INTO D_BIE_ENTIDAD (ENTIDAD_BIEN_ID, ENTIDAD_BIEN_DESC, ENTIDAD_BIEN_DESC_2)
       SELECT DISTINCT ENP.DD_ENP_ID, ENP.DD_ENP_DESCRIPCION, ENP.DD_ENP_DESCRIPCION_LARGA
       FROM '||V_DATASTAGE||'.DD_ENP_ENTIDADES_PROPIETARIAS ENP
       ORDER BY 1';
        
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_ENTIDAD. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

  
-- ----------------------------------------------------------------------------------------------
--                                      D_BIE_GARANTIA_NUM_OPE_BIE_AGR
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_BIE_GARANTIA_NUM_OPE_BIE_AGR where GARANTIA_NUM_OPE_BIE_AGR_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_BIE_GARANTIA_NUM_OPE_BIE_AGR (GARANTIA_NUM_OPE_BIE_AGR_ID, GARANTIA_NUM_OPE_BIE_AGR_DESC) values (-1 ,'Desconocido');
  end if;
  select count(*) into V_NUM_ROW from D_BIE_GARANTIA_NUM_OPE_BIE_AGR where GARANTIA_NUM_OPE_BIE_AGR_ID = 0;
  if (V_NUM_ROW = 0) then
    insert into D_BIE_GARANTIA_NUM_OPE_BIE_AGR (GARANTIA_NUM_OPE_BIE_AGR_ID, GARANTIA_NUM_OPE_BIE_AGR_DESC) values (0 ,'Real Hipotecaria');
  end if;
  select count(*) into V_NUM_ROW from D_BIE_GARANTIA_NUM_OPE_BIE_AGR where GARANTIA_NUM_OPE_BIE_AGR_ID = 1;
  if (V_NUM_ROW = 0) then
    insert into D_BIE_GARANTIA_NUM_OPE_BIE_AGR (GARANTIA_NUM_OPE_BIE_AGR_ID, GARANTIA_NUM_OPE_BIE_AGR_DESC) values (1 ,'Resto');
  end if;
  select count(*) into V_NUM_ROW from D_BIE_GARANTIA_NUM_OPE_BIE_AGR where GARANTIA_NUM_OPE_BIE_AGR_ID = 2;
  if (V_NUM_ROW = 0) then
    insert into D_BIE_GARANTIA_NUM_OPE_BIE_AGR (GARANTIA_NUM_OPE_BIE_AGR_ID, GARANTIA_NUM_OPE_BIE_AGR_DESC) values (2 ,'Real Pignoraticias');
  end if;
  select count(*) into V_NUM_ROW from D_BIE_GARANTIA_NUM_OPE_BIE_AGR where GARANTIA_NUM_OPE_BIE_AGR_ID = 3;
  if (V_NUM_ROW = 0) then
    insert into D_BIE_GARANTIA_NUM_OPE_BIE_AGR (GARANTIA_NUM_OPE_BIE_AGR_ID, GARANTIA_NUM_OPE_BIE_AGR_DESC) values (3 ,'Personal');
  end if;

  commit;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_GARANTIA_NUM_OPE_BIE_AGR. Realizados INSERTS', 3;
  
-- ----------------------------------------------------------------------------------------------
--                                    D_BIE_GARANTIA_NUM_OPE_BIE
-- ----------------------------------------------------------------------------------------------
  select count(*) into V_NUM_ROW from D_BIE_GARANTIA_NUM_OPE_BIE where GARANTIA_NUM_OPE_BIE_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_BIE_GARANTIA_NUM_OPE_BIE (GARANTIA_NUM_OPE_BIE_ID, GARANTIA_NUM_OPE_BIE_DESC, GARANTIA_NUM_OPE_BIE_DESC_2,GARANTIA_NUM_OPE_BIE_AGR_ID)
    values (-1 ,'Desconocido', 'Desconocido', -1);
  end if;

  execute immediate
  'insert into D_BIE_GARANTIA_NUM_OPE_BIE(GARANTIA_NUM_OPE_BIE_ID, GARANTIA_NUM_OPE_BIE_DESC, GARANTIA_NUM_OPE_BIE_DESC_2)
   select DD_GCN_ID, DD_GCN_DESCRIPCION, DD_GCN_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_GCN_GARANTIA_CONTRATO';

  V_ROWCOUNT := sql%rowcount;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_GARANTIA_NUM_OPE_BIE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

  -- Incluimos GARANTIA_NUM_OPE_BIE_AGR_ID
  -- 0 - Real Hipotecaria
  update D_BIE_GARANTIA_NUM_OPE_BIE SET GARANTIA_NUM_OPE_BIE_AGR_ID = 0 where GARANTIA_NUM_OPE_BIE_ID IN (2,3,4,5,1,6,7,8,9,11,10,35);
  -- 1 - Resto
  update D_BIE_GARANTIA_NUM_OPE_BIE SET GARANTIA_NUM_OPE_BIE_AGR_ID = 1 where GARANTIA_NUM_OPE_BIE_ID IN (33,32,31,30,29,27,26,25,28);
  -- 2 - Real Pignoraticias
  update D_BIE_GARANTIA_NUM_OPE_BIE SET GARANTIA_NUM_OPE_BIE_AGR_ID = 2 where GARANTIA_NUM_OPE_BIE_ID IN (13,12,17,21,20,19,18,16,15,23,22,14,24);
  -- 3 - Personal
  update D_BIE_GARANTIA_NUM_OPE_BIE SET GARANTIA_NUM_OPE_BIE_AGR_ID = 3 where GARANTIA_NUM_OPE_BIE_ID IN (34);
  -- 1 - Resto (sin identificar)
  update D_BIE_GARANTIA_NUM_OPE_BIE SET GARANTIA_NUM_OPE_BIE_AGR_ID = 1 where GARANTIA_NUM_OPE_BIE_AGR_ID is null;

  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_BIE_GARANTIA_NUM_OPE_BIE. Finalizado UPDATES', 3;  
  
-------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
  
EXCEPTION
  WHEN OBJECTEXISTS THEN
    O_ERROR_STATUS := 'La tabla ya existe';
    --ROLLBACK;
    DBMS_OUTPUT.PUT_LINE(SQLERRM);

  WHEN INSERT_NULL THEN
    O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
    --ROLLBACK;    
    DBMS_OUTPUT.PUT_LINE(SQLERRM);

  WHEN PARAMETERS_NUMBER THEN
    O_ERROR_STATUS := 'N�mero de par�metros incorrecto';
    --ROLLBACK;    
    DBMS_OUTPUT.PUT_LINE(SQLERRM);

  WHEN OTHERS THEN
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
    
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    --ROLLBACK;
END;
END CARGAR_DIM_BIEN;
/
EXIT


