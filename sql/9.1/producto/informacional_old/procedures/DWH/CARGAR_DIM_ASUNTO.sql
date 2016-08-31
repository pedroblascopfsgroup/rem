create or replace PROCEDURE CARGAR_DIM_ASUNTO(o_error_status OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Gonzalo Martin, PFS Group
-- Fecha creacion: Febrero 2014
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 04/11/2015
-- Motivos del cambio: Usuario propietario
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Procedimiento almancenado que carga las tablas de la dimension Asunto.
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION ASUNTO
    -- D_ASU_ESTADO
    -- D_ASU_DESPACHO
    -- D_ASU_TIPO_DESPACHO
    -- D_ASU_DESPACHO_GESTOR
    -- D_ASU_TIPO_DESPACHO_GESTOR
    -- D_ASU_GESTOR
    -- D_ASU_ENTIDAD_GESTOR
    -- D_ASU_ROL_GESTOR
    -- D_ASU_NVL_DESPACHO
    -- D_ASU_OFI_DESPACHO
    -- D_ASU_PROV_DESPACHO
    -- D_ASU_ZONA_DESPACHO
    -- D_ASU_NVL_DESPACHO_GESTOR
    -- D_ASU_OFI_DESPACHO_GESTOR
    -- D_ASU_PROV_DESPACHO_GESTOR
    -- D_ASU_ZONA_DESPACHO_GESTOR
    -- D_ASU_PROPIETARIO_ASUNTO
    -- D_ASU

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

V_NOMBRE VARCHAR2(50) := 'CARGAR_DIM_ASUNTO';
V_ROWCOUNT NUMBER;
V_SQL VARCHAR2(16000);

BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';

-- ----------------------------------------------------------------------------------------------
--                    D_ASU_DESPACHO / D_ASU_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_ASU_DESPACHO WHERE DESPACHO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_ASU_DESPACHO (DESPACHO_ID, DESPACHO_DESC, TIPO_DESPACHO_ID, ZONA_DESPACHO_ID)
    VALUES (-1 ,'Desconocido', -1, -1);
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU_DESPACHO(DESPACHO_ID, DESPACHO_DESC, TIPO_DESPACHO_ID, ZONA_DESPACHO_ID)
    SELECT DES_ID, DES_DESPACHO, NVL(DD_TDE_ID, -1), NVL(ZON_ID, -1) FROM '||V_DATASTAGE||'.DES_DESPACHO_EXTERNO';

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU_DESPACHO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_ASU_DESPACHO_GESTOR WHERE DESPACHO_GESTOR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_ASU_DESPACHO_GESTOR (DESPACHO_GESTOR_ID, DESPACHO_GESTOR_DESC, TIPO_DESPACHO_GESTOR_ID, ZONA_DESPACHO_GESTOR_ID)
    VALUES (-1 ,'Desconocido', -1, -1);
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU_DESPACHO_GESTOR(DESPACHO_GESTOR_ID, DESPACHO_GESTOR_DESC, TIPO_DESPACHO_GESTOR_ID, ZONA_DESPACHO_GESTOR_ID)
    SELECT DES_ID, DES_DESPACHO, NVL(DD_TDE_ID, -1), NVL(ZON_ID, -1) FROM '||V_DATASTAGE||'.DES_DESPACHO_EXTERNO';
    
  V_ROWCOUNT := sql%rowcount;     
  COMMIT;
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU_DESPACHO_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_ASU_ENTIDAD_GESTOR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_ASU_ENTIDAD_GESTOR WHERE ENTIDAD_GESTOR_ID = -1;
  IF ( V_NUM_ROW = 0) THEN
    INSERT INTO D_ASU_ENTIDAD_GESTOR (ENTIDAD_GESTOR_ID, ENTIDAD_GESTOR_DESC) VALUES (-1, 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU_ENTIDAD_GESTOR(ENTIDAD_GESTOR_ID, ENTIDAD_GESTOR_DESC)
      SELECT ENT_ID, ENT_DESCRIPCION FROM '||V_DATASTAGE||'.ENTIDAD';

  V_ROWCOUNT := sql%rowcount;     
  COMMIT;
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU_ENTIDAD_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_ASU_ESTADO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_ASU_ESTADO WHERE ESTADO_ASUNTO_ID = -1;
  if (V_NUM_ROW = 0) then
    insert into D_ASU_ESTADO (ESTADO_ASUNTO_ID, ESTADO_ASUNTO_DESC, ESTADO_ASUNTO_DESC_2) values (-1 ,'Desconocido','Desconocido');
  end if;

  EXECUTE IMMEDIATE
    'insert into D_ASU_ESTADO(ESTADO_ASUNTO_ID, ESTADO_ASUNTO_DESC, ESTADO_ASUNTO_DESC_2)
    select DD_EAS_ID, DD_EAS_DESCRIPCION, DD_EAS_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_EAS_ESTADO_ASUNTOS';
    
  V_ROWCOUNT := sql%rowcount;     
  COMMIT;
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU_ESTADO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_ASU_GESTOR
-- ----------------------------------------------------------------------------------------------
/*
  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU_GESTOR(GESTOR_ID, GESTOR_NOMBRE, GESTOR_APELLIDO1, GESTOR_APELLIDO2,  ENTIDAD_GESTOR_ID, DESPACHO_GESTOR_ID)
     SELECT USU.USU_ID, NVL(USU.USU_NOMBRE, ''Desconocido'') USU_NOMBRE, NVL(USU.USU_APELLIDO1, ''Desconocido'') USU_APELLIDO1, NVL(USU.USU_APELLIDO2, ''Desconocido'') USU_APELLIDO2, USU.ENTIDAD_ID, USD.DES_ID
     FROM '||V_DATASTAGE||'.USD_USUARIOS_DESPACHOS USD
      JOIN '||V_DATASTAGE||'.USU_USUARIOS USU ON USD.USU_ID = USU.USU_ID
     GROUP BY USU.USU_ID, USU_NOMBRE, USU_APELLIDO1, USU_APELLIDO2, USU.ENTIDAD_ID, USD.DES_ID';

  COMMIT;
*/
-- ----------------------------------------------------------------------------------------------
--               D_ASU_NVL_DESPACHO / D_ASU_NVL_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_ASU_NVL_DESPACHO WHERE NIVEL_DESPACHO_ID = -1;
  IF ( V_NUM_ROW = 0) THEN
    INSERT INTO D_ASU_NVL_DESPACHO (NIVEL_DESPACHO_ID, NIVEL_DESPACHO_DESC, NIVEL_DESPACHO_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU_NVL_DESPACHO(NIVEL_DESPACHO_ID, NIVEL_DESPACHO_DESC, NIVEL_DESPACHO_DESC_2)
    SELECT NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.NIV_NIVEL';

  V_ROWCOUNT := sql%rowcount;     
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU_NVL_DESPACHO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_ASU_NVL_DESPACHO_GESTOR WHERE NIVEL_DESPACHO_GESTOR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_ASU_NVL_DESPACHO_GESTOR (NIVEL_DESPACHO_GESTOR_ID, NIVEL_DESPACHO_GESTOR_DESC, NIVEL_DESPACHO_GESTOR_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU_NVL_DESPACHO_GESTOR(NIVEL_DESPACHO_GESTOR_ID, NIVEL_DESPACHO_GESTOR_DESC, NIVEL_DESPACHO_GESTOR_DESC_2)
    SELECT NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.NIV_NIVEL';

  V_ROWCOUNT := sql%rowcount;     
  COMMIT;
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU_NVL_DESPACHO_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--               D_ASU_OFI_DESPACHO / D_ASU_OFI_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_ASU_OFI_DESPACHO WHERE OFICINA_DESPACHO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_ASU_OFI_DESPACHO (OFICINA_DESPACHO_ID, OFICINA_DESPACHO_DESC, OFICINA_DESPACHO_DESC_2, PROVINCIA_DESPACHO_ID) VALUES (-1 ,'Desconocido', 'Desconocido', -1);
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU_OFI_DESPACHO(OFICINA_DESPACHO_ID, OFICINA_DESPACHO_DESC, PROVINCIA_DESPACHO_ID)
    SELECT OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM '||V_DATASTAGE||'.OFI_OFICINAS';

  V_ROWCOUNT := sql%rowcount;     
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU_OFI_DESPACHO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_ASU_OFI_DESPACHO_GESTOR WHERE OFICINA_DESPACHO_GESTOR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_ASU_OFI_DESPACHO_GESTOR (OFICINA_DESPACHO_GESTOR_ID, OFICINA_DESPACHO_GESTOR_DESC, OFICINA_DESPACHO_GESTOR_DESC_2, PROV_DESPACHO_GESTOR_ID) VALUES (-1 ,'Desconocido', 'Desconocido', -1);
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU_OFI_DESPACHO_GESTOR(OFICINA_DESPACHO_GESTOR_ID, OFICINA_DESPACHO_GESTOR_DESC, PROV_DESPACHO_GESTOR_ID)
    SELECT OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM '||V_DATASTAGE||'.OFI_OFICINAS';

  V_ROWCOUNT := sql%rowcount;     
  COMMIT;
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU_OFI_DESPACHO_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--               D_ASU_PROV_DESPACHO / D_ASU_PROV_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_ASU_PROV_DESPACHO WHERE PROVINCIA_DESPACHO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_ASU_PROV_DESPACHO (PROVINCIA_DESPACHO_ID, PROVINCIA_DESPACHO_DESC, PROVINCIA_DESPACHO_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU_PROV_DESPACHO(PROVINCIA_DESPACHO_ID, PROVINCIA_DESPACHO_DESC, PROVINCIA_DESPACHO_DESC_2)
    SELECT DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_PRV_PROVINCIA';

  V_ROWCOUNT := sql%rowcount;     
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU_PROV_DESPACHO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_ASU_PROV_DESPACHO_GESTOR WHERE PROV_DESPACHO_GESTOR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_ASU_PROV_DESPACHO_GESTOR (PROV_DESPACHO_GESTOR_ID, PROV_DESPACHO_GESTOR_DESC, PROV_DESPACHO_GESTOR_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU_PROV_DESPACHO_GESTOR(PROV_DESPACHO_GESTOR_ID, PROV_DESPACHO_GESTOR_DESC, PROV_DESPACHO_GESTOR_DESC_2)
    SELECT DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_PRV_PROVINCIA';

  V_ROWCOUNT := sql%rowcount;     
  COMMIT;
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU_PROV_DESPACHO_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--              D_ASU_TIPO_DESPACHO / D_ASU_TIPO_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_ASU_TIPO_DESPACHO WHERE TIPO_DESPACHO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_ASU_TIPO_DESPACHO (TIPO_DESPACHO_ID, TIPO_DESPACHO_DESC, TIPO_DESPACHO_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU_TIPO_DESPACHO(TIPO_DESPACHO_ID, TIPO_DESPACHO_DESC, TIPO_DESPACHO_DESC_2)
    SELECT DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_TDE_TIPO_DESPACHO';

  V_ROWCOUNT := sql%rowcount;     
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU_TIPO_DESPACHO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_ASU_TIPO_DESPACHO_GESTOR WHERE TIPO_DESPACHO_GESTOR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_ASU_TIPO_DESPACHO_GESTOR (TIPO_DESPACHO_GESTOR_ID, TIPO_DESPACHO_GESTOR_DESC, TIPO_DESPACHO_GESTOR_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU_TIPO_DESPACHO_GESTOR(TIPO_DESPACHO_GESTOR_ID, TIPO_DESPACHO_GESTOR_DESC, TIPO_DESPACHO_GESTOR_DESC_2)
    SELECT DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_TDE_TIPO_DESPACHO';

  V_ROWCOUNT := sql%rowcount;     
  COMMIT;
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU_TIPO_DESPACHO_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_ASU_ROL_GESTOR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_ASU_ROL_GESTOR WHERE ROL_GESTOR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_ASU_ROL_GESTOR (ROL_GESTOR_ID, ROL_GESTOR_DESC, ROL_GESTOR_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU_ROL_GESTOR(ROL_GESTOR_ID, ROL_GESTOR_DESC, ROL_GESTOR_DESC_2)
    SELECT DD_TGE_ID, DD_TGE_DESCRIPCION, DD_TGE_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_TGE_TIPO_GESTOR';

  V_ROWCOUNT := sql%rowcount;     
  COMMIT;
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU_ROL_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                      D_ASU_ZONA_DESPACHO / D_ASU_ZONA_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_ASU_ZONA_DESPACHO WHERE ZONA_DESPACHO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_ASU_ZONA_DESPACHO (ZONA_DESPACHO_ID, ZONA_DESPACHO_DESC, ZONA_DESPACHO_DESC_2, NIVEL_DESPACHO_ID, OFICINA_DESPACHO_ID) VALUES (-1 ,'Desconocido', 'Desconocido', -1, -1);
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU_ZONA_DESPACHO(ZONA_DESPACHO_ID, ZONA_DESPACHO_DESC, ZONA_DESPACHO_DESC_2, NIVEL_DESPACHO_ID, OFICINA_DESPACHO_ID)
    SELECT ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, COALESCE(OFI_ID, -1) FROM '||V_DATASTAGE||'.ZON_ZONIFICACION';

  V_ROWCOUNT := sql%rowcount;     
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU_ZONA_DESPACHO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_ASU_ZONA_DESPACHO_GESTOR WHERE ZONA_DESPACHO_GESTOR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_ASU_ZONA_DESPACHO_GESTOR (ZONA_DESPACHO_GESTOR_ID, ZONA_DESPACHO_GESTOR_DESC, ZONA_DESPACHO_GESTOR_DESC_2, NIVEL_DESPACHO_GESTOR_ID, OFICINA_DESPACHO_GESTOR_ID) VALUES (-1 ,'Desconocido', 'Desconocido', -1, -1);
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU_ZONA_DESPACHO_GESTOR(ZONA_DESPACHO_GESTOR_ID, ZONA_DESPACHO_GESTOR_DESC, ZONA_DESPACHO_GESTOR_DESC_2, NIVEL_DESPACHO_GESTOR_ID, OFICINA_DESPACHO_GESTOR_ID)
    SELECT ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, COALESCE(OFI_ID, -1) FROM '||V_DATASTAGE||'.ZON_ZONIFICACION';

  V_ROWCOUNT := sql%rowcount;     
  COMMIT;
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU_ZONA_DESPACHO_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_ASU_PROPIETARIO_ASUNTO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_ASU_PROPIETARIO_ASUNTO WHERE PROPIETARIO_ASUNTO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_ASU_PROPIETARIO_ASUNTO (PROPIETARIO_ASUNTO_ID, PROPIETARIO_ASUNTO_DESC, PROPIETARIO_ASUNTO_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU_PROPIETARIO_ASUNTO (PROPIETARIO_ASUNTO_ID, PROPIETARIO_ASUNTO_DESC, PROPIETARIO_ASUNTO_DESC_2)
    SELECT DD_PAS_ID, DD_PAS_DESCRIPCION, DD_PAS_DESCRIPCION_LARGA from '||V_DATASTAGE||'.DD_PAS_PROPIEDAD_ASUNTO';

  V_ROWCOUNT := sql%rowcount;     
  COMMIT;
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU_PROPIETARIO_ASUNTO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;


-- ----------------------------------------------------------------------------------------------
--                                      D_ASU
-- ----------------------------------------------------------------------------------------------
  EXECUTE IMMEDIATE
    'INSERT INTO D_ASU (ASUNTO_ID, NOMBRE_ASUNTO, ESTADO_ASUNTO_ID, EXPEDIENTE_ID, PROPIETARIO_ASUNTO_ID)
    SELECT ASU_ID, NVL(ASU_NOMBRE, ''Desconocido''), DD_EAS_ID, EXP_ID, -1
      FROM '||V_DATASTAGE||'.ASU_ASUNTOS WHERE BORRADO=0';

  V_ROWCOUNT := sql%rowcount;     
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_DESPACHO_ASUNTO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT o_error_status;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_DESPACHO_ASUNTO. Realizado TRUNCATE', 3;
  
  -- Tabla temporal con los despachos de los asuntos (Despacho del usuario "Gestor")
  EXECUTE IMMEDIATE
    'INSERT INTO TMP_DESPACHO_ASUNTO (ASUNTO_ID, DESPACHO_ID)
      SELECT GAA.ASU_ID, USD.DES_ID
      FROM '||V_DATASTAGE||'.USD_USUARIOS_DESPACHOS USD
        JOIN '||V_DATASTAGE||'.GAA_GESTOR_ADICIONAL_ASUNTO GAA ON GAA.USD_ID = USD.USD_ID
        JOIN '||V_DATASTAGE||'.DES_DESPACHO_EXTERNO DEXT ON DEXT.DES_ID = USD.DES_ID
        JOIN '||V_DATASTAGE||'.DD_TGE_TIPO_GESTOR TGES ON GAA.DD_TGE_ID = TGES.DD_TGE_ID
      WHERE TGES.DD_TGE_DESCRIPCION = ''Gestoria''';

  V_ROWCOUNT := sql%rowcount;     
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_DESPACHO_ASUNTO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
  UPDATE D_ASU ASU
    SET DESPACHO_ID = NVL((SELECT DESPACHO_ID FROM TMP_DESPACHO_ASUNTO TMP WHERE ASU.ASUNTO_ID = TMP.ASUNTO_ID), -1);
  COMMIT;

  V_ROWCOUNT := sql%rowcount;     
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU. Registros Updatados: ' || TO_CHAR(V_ROWCOUNT), 3;

  execute immediate '
  update D_ASU A
    set PROPIETARIO_ASUNTO_ID = NVL((select B.DD_PAS_ID from '||V_DATASTAGE||'.ASU_ASUNTOS B where B.ASU_ID = A.ASUNTO_ID), -1)';
  COMMIT;

  V_ROWCOUNT := sql%rowcount;     
  
   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_ASU. Registros Updatados: ' || TO_CHAR(V_ROWCOUNT), 3;



  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
  
EXCEPTION
  WHEN OBJECTEXISTS THEN
    O_ERROR_STATUS := 'La tabla ya existe';
    --ROLLBACK;
  WHEN INSERT_NULL THEN
    O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
    --ROLLBACK;
  WHEN PARAMETERS_NUMBER THEN
    O_ERROR_STATUS := 'Numero de parametros incorrecto';
    --ROLLBACK;
  WHEN OTHERS THEN
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
    --ROLLBACK;
  end;
END CARGAR_DIM_ASUNTO;