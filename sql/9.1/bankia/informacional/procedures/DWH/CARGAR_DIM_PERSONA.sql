create or replace PROCEDURE CARGAR_DIM_PERSONA(O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Febrero 2014
-- Responsable última modificación: Diego Pérez, PFS Group
-- Fecha última modificación: 02/02/2015
-- Motivos del cambio: LOG's
-- Cliente: Recovery BI Bankia 
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensión Persona.
-- ===============================================================================================
 
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN PERSONA
    -- D_PER_AMBITO_EXPEDIENTE;
    -- D_PER_ARQUETIPO;
    -- D_PER_ESTADO_FINANCIERO;
    -- D_PER_GRUPO_GESTOR;
    -- D_PER_ITINERARIO;  
    -- D_PER_NACIONALIDAD;
    -- D_PER_NIVEL; 
    -- D_PER_OFICINA; 
    -- D_PER_PAIS_NACIMIENTO;
    -- D_PER_PERFIL;
    -- D_PER_POLITICA;
    -- D_PER_PROVINCIA;
    -- D_PER_RATING_AUXILIAR;
    -- D_PER_RATING_EXTERNO;
    -- D_PER_SEGMENTO;
    -- D_PER_SEGMENTO_DETALLE;
    -- D_PER_SEXO;
    -- D_PER_TENDENCIA;
    -- D_PER_TIPO_DOCUMENTO;
    -- D_PER_TIPO_ITINERARIO;
    -- D_PER_TIPO_PERSONA;
    -- D_PER_TIPO_POLITICA;
    -- D_PER_ZONA;
    -- D_PER;

V_NOMBRE VARCHAR2(50) := 'CARGAR_DIM_PERSONA';
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
--                                      D_PER_AMBITO_EXPEDIENTE
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_AMBITO_EXPEDIENTE WHERE AMBITO_EXPEDIENTE_PER_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_AMBITO_EXPEDIENTE (AMBITO_EXPEDIENTE_PER_ID, AMBITO_EXPEDIENTE_PER_DESC, AMBITO_EXPEDIENTE_PER_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;

  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_AMBITO_EXPEDIENTE(AMBITO_EXPEDIENTE_PER_ID, AMBITO_EXPEDIENTE_PER_DESC, AMBITO_EXPEDIENTE_PER_DESC_2)
     SELECT DD_AEX_ID, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_AEX_AMBITOS_EXPEDIENTE';   
     

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_AMBITO_EXPEDIENTE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
     

-- ----------------------------------------------------------------------------------------------
--                                      D_PER_ARQUETIPO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_ARQUETIPO WHERE ARQUETIPO_PERSONA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_ARQUETIPO (ARQUETIPO_PERSONA_ID, ARQUETIPO_PERSONA_DESC, ITINERARIO_PERSONA_ID) VALUES (-1 ,'Desconocido', -1);
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_ARQUETIPO(ARQUETIPO_PERSONA_ID, ARQUETIPO_PERSONA_DESC, ITINERARIO_PERSONA_ID)
     SELECT ARQ_ID, ARQ_NOMBRE, ITI_ID FROM '||V_DATASTAGE||'.ARQ_ARQUETIPOS';   

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_ARQUETIPO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_ESTADO_FINANCIERO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_ESTADO_FINANCIERO WHERE ESTADO_FINANCIERO_PER_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_ESTADO_FINANCIERO (ESTADO_FINANCIERO_PER_ID, ESTADO_FINANCIERO_PER_DESC, ESTADO_FINANCIERO_PER_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_ESTADO_FINANCIERO(ESTADO_FINANCIERO_PER_ID, ESTADO_FINANCIERO_PER_DESC, ESTADO_FINANCIERO_PER_DESC_2)
     SELECT DD_EFC_ID, DD_EFC_DESCRIPCION, DD_EFC_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_EFC_ESTADO_FINAN_CNT';
  
   V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_ESTADO_FINANCIERO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_GRUPO_GESTOR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_GRUPO_GESTOR WHERE GRUPO_GESTOR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_GRUPO_GESTOR (GRUPO_GESTOR_ID, GRUPO_GESTOR_DESC, GRUPO_GESTOR_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_GRUPO_GESTOR(GRUPO_GESTOR_ID, GRUPO_GESTOR_DESC, GRUPO_GESTOR_DESC_2)
     SELECT DD_GGE_ID, DD_GGE_DESCRIPCION, DD_GGE_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_GGE_GRUPO_GESTOR';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_GRUPO_GESTOR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
 
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_ITINERARIO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_ITINERARIO WHERE ITINERARIO_PERSONA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_ITINERARIO (ITINERARIO_PERSONA_ID, ITINERARIO_PERSONA_DESC, TIPO_ITINERARIO_PERSONA_ID, AMBITO_EXPEDIENTE_PER_ID) VALUES (-1 ,'Desconocido', -1, -1);
  END IF;
  
  EXECUTE IMMEDIATE 
    'INSERT INTO D_PER_ITINERARIO(ITINERARIO_PERSONA_ID, ITINERARIO_PERSONA_DESC, TIPO_ITINERARIO_PERSONA_ID, AMBITO_EXPEDIENTE_PER_ID)
     SELECT ITI_ID, ITI_NOMBRE, DD_TIT_ID, DD_AEX_ID FROM '||V_DATASTAGE||'.ITI_ITINERARIOS';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_ITINERARIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
 
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_NACIONALIDAD
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_NACIONALIDAD WHERE NACIONALIDAD_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_NACIONALIDAD (NACIONALIDAD_ID, NACIONALIDAD_DESC, NACIONALIDAD_DEC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_NACIONALIDAD(NACIONALIDAD_ID, NACIONALIDAD_DESC, NACIONALIDAD_DEC_2)
     SELECT DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_CIC_CODIGO_ISO_CIRBE';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_NACIONALIDAD. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
 
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_NIVEL
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_NIVEL WHERE NIVEL_PERSONA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_NIVEL (NIVEL_PERSONA_ID, NIVEL_PERSONA_DESC, NIVEL_PERSONA_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_NIVEL(NIVEL_PERSONA_ID, NIVEL_PERSONA_DESC, NIVEL_PERSONA_DESC_2)
     SELECT NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.NIV_NIVEL';
  
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_NIVEL. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
 
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_OFICINA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_OFICINA WHERE OFICINA_PERSONA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_OFICINA (OFICINA_PERSONA_ID, OFICINA_PERSONA_DESC, OFICINA_PERSONA_DESC_2, PROVINCIA_PERSONA_ID) VALUES (-1 ,'Desconocido', 'Desconocido', -1);
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_OFICINA(OFICINA_PERSONA_ID, OFICINA_PERSONA_DESC, PROVINCIA_PERSONA_ID)
     SELECT OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM '||V_DATASTAGE||'.OFI_OFICINAS';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_OFICINA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
 
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_PAIS_NACIMIENTO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_PAIS_NACIMIENTO WHERE PAIS_NACIMIENTO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_PAIS_NACIMIENTO (PAIS_NACIMIENTO_ID, PAIS_NACIMIENTO_DESC, PAIS_NACIMIENTO_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_PAIS_NACIMIENTO(PAIS_NACIMIENTO_ID, PAIS_NACIMIENTO_DESC, PAIS_NACIMIENTO_DESC_2)
     SELECT DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_CIC_CODIGO_ISO_CIRBE';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_PAIS_NACIMIENTO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
 
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_PERFIL
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_PERFIL WHERE PERFIL_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_PERFIL (PERFIL_ID, PERFIL_DESC, PERFIL_DEC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_PERFIL(PERFIL_ID, PERFIL_DESC, PERFIL_DEC_2)
     SELECT PEF_ID, PEF_DESCRIPCION, PEF_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.PEF_PERFILES';
  
   V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_PERFIL. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_PER_POLITICA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_POLITICA WHERE POLITICA_PERSONA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_POLITICA (POLITICA_PERSONA_ID, POLITICA_PERSONA_DESC, POLITICA_PERSONA_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_POLITICA(POLITICA_PERSONA_ID, POLITICA_PERSONA_DESC, POLITICA_PERSONA_DESC_2)
     SELECT DD_POL_ID,DD_POL_DESCRIPCION, DD_POL_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_POL_POLITICAS';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_POLITICA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;

-- ----------------------------------------------------------------------------------------------
--                                      D_PER_PROVINCIA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_PROVINCIA WHERE PROVINCIA_PERSONA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_PROVINCIA (PROVINCIA_PERSONA_ID, PROVINCIA_PERSONA_DESC, PROVINCIA_PERSONA_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_PROVINCIA(PROVINCIA_PERSONA_ID, PROVINCIA_PERSONA_DESC, PROVINCIA_PERSONA_DESC_2)
     SELECT DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_PRV_PROVINCIA';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_PROVINCIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_RATING_AUXILIAR
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_RATING_AUXILIAR WHERE RATING_AUXILIAR_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_RATING_AUXILIAR (RATING_AUXILIAR_ID, RATING_AUXILIAR_DESC, RATING_AUXILIAR_DEC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_RATING_AUXILIAR(RATING_AUXILIAR_ID, RATING_AUXILIAR_DESC, RATING_AUXILIAR_DEC_2)
     SELECT DD_RAX_ID, DD_RAX_DESCRIPCION, DD_RAX_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_RAX_RATING_AUXILIAR';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_RATING_AUXILIAR. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_RATING_EXTERNO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_RATING_EXTERNO WHERE RATING_EXTERNO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_RATING_EXTERNO (RATING_EXTERNO_ID, RATING_EXTERNO_DESC, RATING_EXTERNO_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_RATING_EXTERNO(RATING_EXTERNO_ID, RATING_EXTERNO_DESC, RATING_EXTERNO_DESC_2)
     SELECT DD_REX_ID, DD_REX_DESCRIPCION, DD_REX_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_REX_RATING_EXTERNO';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_RATING_EXTERNO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_SEGMENTO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_SEGMENTO WHERE SEGMENTO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_SEGMENTO (SEGMENTO_ID, SEGMENTO_DESC, SEGMENTO_DEC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_SEGMENTO(SEGMENTO_ID, SEGMENTO_DESC, SEGMENTO_DEC_2)
     SELECT DD_SCL_ID, DD_SCL_DESCRIPCION, DD_SCL_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_SCL_SEGTO_CLI';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_SEGMENTO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_SEGMENTO_DETALLE
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_SEGMENTO_DETALLE WHERE SEGMENTO_DETALLE_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_SEGMENTO_DETALLE (SEGMENTO_DETALLE_ID, SEGMENTO_DETALLE_DESC, SEGMENTO_DETALLE_DEC_2, SEGMENTO_ID) VALUES (-1 ,'Desconocido', 'Desconocido', -1);
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_SEGMENTO_DETALLE(SEGMENTO_DETALLE_ID, SEGMENTO_DETALLE_DESC, SEGMENTO_DETALLE_DEC_2, SEGMENTO_ID)
     SELECT DD_SCE_ID, DD_SCE_DESCRIPCION, DD_SCE_DESCRIPCION_LARGA, DD_SCL_ID FROM '||V_DATASTAGE||'.DD_SCE_SEGTO_CLI_ENTIDAD';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_SEGMENTO_DETALLE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
 
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_SEXO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_SEXO WHERE SEXO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_SEXO (SEXO_ID, SEXO_DESC) VALUES (-1 ,'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_SEXO(SEXO_ID, SEXO_DESC)
     SELECT DD_SEX_ID, DD_SEX_DESCRIPCION FROM '||V_DATASTAGE||'.DD_SEX_SEXOS';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_SEXO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_TENDENCIA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_TENDENCIA WHERE TENDENCIA_PERSONA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_TENDENCIA (TENDENCIA_PERSONA_ID, TENDENCIA_PERSONA_DESC, TENDENCIA_PERSONA_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_TENDENCIA(TENDENCIA_PERSONA_ID, TENDENCIA_PERSONA_DESC, TENDENCIA_PERSONA_DESC_2)
     SELECT TEN_ID, TEN_DESCRIPCION, TEN_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.TEN_TENDENCIA';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_TENDENCIA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_TIPO_DOCUMENTO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_TIPO_DOCUMENTO WHERE TIPO_DOCUMENTO_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_TIPO_DOCUMENTO (TIPO_DOCUMENTO_ID, TIPO_DOCUMENTO_DESC, TIPO_DOCUMENTO_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_TIPO_DOCUMENTO(TIPO_DOCUMENTO_ID, TIPO_DOCUMENTO_DESC, TIPO_DOCUMENTO_DESC_2)
     SELECT DD_TDI_ID, DD_TDI_DESCRIPCION, DD_TDI_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_TDI_TIPO_DOCUMENTO_ID';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_TIPO_DOCUMENTO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_TIPO_ITINERARIO
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_TIPO_ITINERARIO WHERE TIPO_ITINERARIO_PERSONA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_TIPO_ITINERARIO (TIPO_ITINERARIO_PERSONA_ID, TIPO_ITINERARIO_PERSONA_DESC, TIPO_ITINERARIO_PERSONA_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_TIPO_ITINERARIO(TIPO_ITINERARIO_PERSONA_ID, TIPO_ITINERARIO_PERSONA_DESC, TIPO_ITINERARIO_PERSONA_DESC_2)
     SELECT DD_TIT_ID, DD_TIT_DESCRIPCION, DD_TIT_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_TIT_TIPO_ITINERARIOS';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_TIPO_ITINERARIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_TIPO_PERSONA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_TIPO_PERSONA WHERE TIPO_PERSONA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_TIPO_PERSONA (TIPO_PERSONA_ID, TIPO_PERSONA_DESC, TIPO_PERSONA_DESC_2) VALUES (-1 ,'Desconocido', 'Desconocido');
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_TIPO_PERSONA(TIPO_PERSONA_ID, TIPO_PERSONA_DESC, TIPO_PERSONA_DESC_2)
     SELECT DD_TPE_ID, DD_TPE_DESCRIPCION, DD_TPE_DESCRIPCION_LARGA FROM '||V_DATASTAGE||'.DD_TPE_TIPO_PERSONA';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_TIPO_PERSONA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_TIPO_POLITICA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_TIPO_POLITICA WHERE TIPO_POLITICA_PERSONA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_TIPO_POLITICA(TIPO_POLITICA_PERSONA_ID, TIPO_POLITICA_PERSONA_DESC, TIPO_POLITICA_PERSONA_DESC_2, POLITICA_PERSONA_ID, TENDENCIA_PERSONA_ID) VALUES (-1 ,'Desconocido', 'Desconocido', -1, -1);
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_TIPO_POLITICA(TIPO_POLITICA_PERSONA_ID, TIPO_POLITICA_PERSONA_DESC, TIPO_POLITICA_PERSONA_DESC_2, POLITICA_PERSONA_ID, TENDENCIA_PERSONA_ID)
     SELECT TPL_ID, TPL_DESCRIPCION, TPL_DESCRIPCION_LARGA, DD_POL_ID, TEN_ID FROM '||V_DATASTAGE||'.TPL_TIPO_POLITICA';
    
  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_TIPO_POLITICA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_PER_ZONA
-- ----------------------------------------------------------------------------------------------
  SELECT COUNT(*) INTO V_NUM_ROW FROM D_PER_ZONA WHERE ZONA_PERSONA_ID = -1;
  IF (V_NUM_ROW = 0) THEN
    INSERT INTO D_PER_ZONA (ZONA_PERSONA_ID, ZONA_PERSONA_DESC, ZONA_PERSONA_DESC_2, NIVEL_PERSONA_ID, OFICINA_PERSONA_ID) VALUES (-1 ,'Desconocido', 'Desconocido', -1, -1);
  END IF;
  
  EXECUTE IMMEDIATE
    'INSERT INTO D_PER_ZONA(ZONA_PERSONA_ID, ZONA_PERSONA_DESC, ZONA_PERSONA_DESC_2, NIVEL_PERSONA_ID, OFICINA_PERSONA_ID)
     SELECT ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, OFI_ID FROM '||V_DATASTAGE||'.ZON_ZONIFICACION';

  V_ROWCOUNT := sql%rowcount;     
  commit;

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER_ZONA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      D_PER
-- ----------------------------------------------------------------------------------------------
  execute immediate 'ALTER TABLE D_PER DISABLE CONSTRAINT D_PER_PK';

  insert /*+ APPEND PARALLEL(D_PER_1, 16) PQ_DISTRIBUTE(D_PER_1, NONE) */ into D_PER
   (PERSONA_ID,
    DOCUMENTO_ID,
    NOMBRE,
    APELLIDO_1,
    APELLIDO_2, 
    TELEFONO_1,
    TELEFONO_2,
    MOVIL_1,
    MOVIL_2,
    EMAIL,
    ARQUETIPO_PERSONA_ID,
    ESTADO_FINANCIERO_PER_ID,
    GRUPO_GESTOR_ID,
    NACIONALIDAD_ID,
    OFICINA_PERSONA_ID,
    PAIS_NACIMIENTO_ID,
    PERFIL_ID,
    POLITICA_PERSONA_ID,  
    RATING_AUXILIAR_ID,
    RATING_EXTERNO_ID,
    SEGMENTO_ID,
    SEGMENTO_DETALLE_ID,
    SEXO_ID,
    TIPO_DOCUMENTO_ID,
    TIPO_PERSONA_ID,
    TIPO_POLITICA_PERSONA_ID,
    ZONA_PERSONA_ID
   )
  select PER_ID, 
        PER_DOC_ID,
        PER_NOMBRE,
        PER_APELLIDO1, 
        PER_APELLIDO2, 
        NVL(PER_TELEFONO_1, 'Desconocido'),
        NVL(PER_TELEFONO_2, 'Desconocido'),
        NVL(PER_MOVIL_1, 'Desconocido'),
        NVL(PER_MOVIL_2, 'Desconocido'),
        NVL(PER_EMAIL, 'Desconocido'),
        NVL(ARQ_ID, -1),
        NVL(DD_EFC_ID, -1),
        NVL(DD_GGE_ID, -1),
        NVL(PER_NACIONALIDAD, -1),
        NVL(OFI_ID, -1),
        NVL(PER_PAIS_NACIMIENTO, -1),
        NVL(PEF_ID,  -1),
        NVL(DD_POL_ID, -1),
        NVL(DD_RAX_ID, -1),
        NVL(DD_REX_ID, -1),
        NVL(DD_SCL_ID, -1),
        NVL(DD_SCE_ID, -1),
        NVL(PER_SEXO, -1),
        NVL(DD_TDI_ID, -1),
        NVL(DD_TPE_ID, -1),
        NVL(TPL_ID, -1),
        NVL(ZON_ID, -1)
  FROM RECOVERY_BANKIA_DATASTAGE.PER_PERSONAS WHERE BORRADO = 0;

  V_ROWCOUNT := sql%rowcount;     

   --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'D_PER. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 3;
  
    
  execute immediate 'ALTER TABLE D_PER ENABLE CONSTRAINT D_PER_PK';
  execute immediate 'ANALYZE TABLE D_PER COMPUTE STATISTICS';

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
    O_ERROR_STATUS := 'Número de parámetros incorrecto';
    --ROLLBACK;    
  WHEN OTHERS THEN
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
    --ROLLBACK;
END;
END CARGAR_DIM_PERSONA;