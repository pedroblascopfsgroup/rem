-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Cargar_Dim_Persona`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_PER: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensión Persona.
-- ===============================================================================================
 
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN PERSONA
    -- DIM_PERSONA_AMBITO_EXPEDIENTE
    -- DIM_PERSONA_ARQUETIPO
    -- DIM_PERSONA_ESTADO_FINANCIERO 
    -- DIM_PERSONA_GRUPO_GESTOR
    -- DIM_PERSONA_ITINERARIO  
    -- DIM_PERSONA_NACIONALIDAD
    -- DIM_PERSONA_NIVEL 
    -- DIM_PERSONA_OFICINA 
    -- DIM_PERSONA_PAIS_NACIMIENTO
    -- DIM_PERSONA_PERFIL
    -- DIM_PERSONA_POLITICA
    -- DIM_PERSONA_PROVINCIA 
    -- DIM_PERSONA_RATING_AUXILIAR
    -- DIM_PERSONA_RATING_EXTERNO
    -- DIM_PERSONA_SEGMENTO
    -- DIM_PERSONA_SEGMENTO_DETALLE
    -- DIM_PERSONA_SEXO 
    -- DIM_PERSONA_TENDENCIA
    -- DIM_PERSONA_TIPO_DOCUMENTO
    -- DIM_PERSONA_TIPO_ITINERARIO
    -- DIM_PERSONA_TIPO_PERSONA
    -- DIM_PERSONA_TIPO_POLITICA
    -- DIM_PERSONA_ZONA   
    -- DIM_PERSONA 


-- --------------------------------------------------------------------------------
-- DEFINICIÓN DE LOS HANDLER DE ERROR
-- --------------------------------------------------------------------------------
DECLARE EXIT handler for 1062 set o_error_status := 'Error 1062: La tabla ya existe';
DECLARE EXIT handler for 1048 set o_error_status := 'Error 1048: Has intentado insertar un valor nulo'; 
DECLARE EXIT handler for 1318 set o_error_status := 'Error 1318: Número de parámetros incorrecto'; 

-- --------------------------------------------------------------------------------
-- DEFINICIÓN DEL HANDLER GENÉRICO DE ERROR
-- --------------------------------------------------------------------------------
DECLARE EXIT handler for sqlexception set o_error_status:= 'Se ha producido un error en el proceso';

	
-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_AMBITO_EXPEDIENTE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_AMBITO_EXPEDIENTE where AMBITO_EXPEDIENTE_PERSONA_ID = -1) = 0) then
	insert into DIM_PERSONA_AMBITO_EXPEDIENTE (AMBITO_EXPEDIENTE_PERSONA_ID, AMBITO_EXPEDIENTE_PERSONA_DESC, AMBITO_EXPEDIENTE_PERSONA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PERSONA_AMBITO_EXPEDIENTE(AMBITO_EXPEDIENTE_PERSONA_ID, AMBITO_EXPEDIENTE_PERSONA_DESC, AMBITO_EXPEDIENTE_PERSONA_DESC_ALT)
    select DD_AEX_ID, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_AEX_AMBITOS_EXPEDIENTE;   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_ARQUETIPO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_ARQUETIPO where ARQUETIPO_PERSONA_ID = -1) = 0) then
	insert into DIM_PERSONA_ARQUETIPO (ARQUETIPO_PERSONA_ID, ARQUETIPO_PERSONA_DESC, ITINERARIO_PERSONA_ID) values (-1 ,'Desconocido', -1);
end if;

 insert into DIM_PERSONA_ARQUETIPO(ARQUETIPO_PERSONA_ID, ARQUETIPO_PERSONA_DESC, ITINERARIO_PERSONA_ID)
    select ARQ_ID, ARQ_NOMBRE, ITI_ID FROM recovery_lindorff_datastage.ARQ_ARQUETIPOS;   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_ESTADO_FINANCIERO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_ESTADO_FINANCIERO where ESTADO_FINANCIERO_PERSONA_ID = -1) = 0) then
	insert into DIM_PERSONA_ESTADO_FINANCIERO (ESTADO_FINANCIERO_PERSONA_ID, ESTADO_FINANCIERO_PERSONA_DESC, ESTADO_FINANCIERO_PERSONA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PERSONA_ESTADO_FINANCIERO(ESTADO_FINANCIERO_PERSONA_ID, ESTADO_FINANCIERO_PERSONA_DESC, ESTADO_FINANCIERO_PERSONA_DESC_ALT)
    select DD_EFC_ID, DD_EFC_DESCRIPCION, DD_EFC_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_EFC_ESTADO_FINAN_CNT;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_GRUPO_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_GRUPO_GESTOR where GRUPO_GESTOR_ID = -1) = 0) then
	insert into DIM_PERSONA_GRUPO_GESTOR (GRUPO_GESTOR_ID, GRUPO_GESTOR_DESC, GRUPO_GESTOR_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PERSONA_GRUPO_GESTOR(GRUPO_GESTOR_ID, GRUPO_GESTOR_DESC, GRUPO_GESTOR_DESC_ALT)
    select DD_GGE_ID, DD_GGE_DESCRIPCION, DD_GGE_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_GGE_GRUPO_GESTOR;
    
        
-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_ITINERARIO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_ITINERARIO where ITINERARIO_PERSONA_ID = -1) = 0) then
	insert into DIM_PERSONA_ITINERARIO (ITINERARIO_PERSONA_ID, ITINERARIO_PERSONA_DESC, TIPO_ITINERARIO_PERSONA_ID, AMBITO_EXPEDIENTE_PERSONA_ID) values (-1 ,'Desconocido', -1, -1);
end if;

 insert into DIM_PERSONA_ITINERARIO(ITINERARIO_PERSONA_ID, ITINERARIO_PERSONA_DESC, TIPO_ITINERARIO_PERSONA_ID, AMBITO_EXPEDIENTE_PERSONA_ID)
    select ITI_ID, ITI_NOMBRE, DD_TIT_ID, DD_AEX_ID FROM recovery_lindorff_datastage.ITI_ITINERARIOS;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_NACIONALIDAD
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_NACIONALIDAD where NACIONALIDAD_ID = -1) = 0) then
	insert into DIM_PERSONA_NACIONALIDAD (NACIONALIDAD_ID, NACIONALIDAD_DESC, NACIONALIDAD_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PERSONA_NACIONALIDAD(NACIONALIDAD_ID, NACIONALIDAD_DESC, NACIONALIDAD_DESC_ALT)
    select DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_CIC_CODIGO_ISO_CIRBE;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_NIVEL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_NIVEL where NIVEL_PERSONA_ID = -1) = 0) then
	insert into DIM_PERSONA_NIVEL (NIVEL_PERSONA_ID, NIVEL_PERSONA_DESC, NIVEL_PERSONA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PERSONA_NIVEL(NIVEL_PERSONA_ID, NIVEL_PERSONA_DESC, NIVEL_PERSONA_DESC_ALT)
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.NIV_NIVEL;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_OFICINA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_OFICINA where OFICINA_PERSONA_ID = -1) = 0) then
	insert into DIM_PERSONA_OFICINA (OFICINA_PERSONA_ID, OFICINA_PERSONA_DESC, OFICINA_PERSONA_DESC_ALT, PROVINCIA_PERSONA_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_PERSONA_OFICINA(OFICINA_PERSONA_ID, OFICINA_PERSONA_DESC, PROVINCIA_PERSONA_ID)
    select OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM recovery_lindorff_datastage.OFI_OFICINAS;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_PAIS_NACIMIENTO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_PAIS_NACIMIENTO where PAIS_NACIMIENTO_ID = -1) = 0) then
	insert into DIM_PERSONA_PAIS_NACIMIENTO (PAIS_NACIMIENTO_ID, PAIS_NACIMIENTO_DESC, PAIS_NACIMIENTO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PERSONA_PAIS_NACIMIENTO(PAIS_NACIMIENTO_ID, PAIS_NACIMIENTO_DESC, PAIS_NACIMIENTO_DESC_ALT)
    select DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_CIC_CODIGO_ISO_CIRBE;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_PERFIL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_PERFIL where PERFIL_ID = -1) = 0) then
	insert into DIM_PERSONA_PERFIL (PERFIL_ID, PERFIL_DESC, PERFIL_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PERSONA_PERFIL(PERFIL_ID, PERFIL_DESC, PERFIL_DESC_ALT)
    select PEF_ID, PEF_DESCRIPCION, PEF_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.PEF_PERFILES;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_POLITICA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_POLITICA where POLITICA_PERSONA_ID = -1) = 0) then
	insert into DIM_PERSONA_POLITICA (POLITICA_PERSONA_ID, POLITICA_PERSONA_DESC, POLITICA_PERSONA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PERSONA_POLITICA(POLITICA_PERSONA_ID, POLITICA_PERSONA_DESC, POLITICA_PERSONA_DESC_ALT)
    select DD_POL_ID,DD_POL_DESCRIPCION, DD_POL_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_POL_POLITICAS;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_PROVINCIA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_PROVINCIA where PROVINCIA_PERSONA_ID = -1) = 0) then
	insert into DIM_PERSONA_PROVINCIA (PROVINCIA_PERSONA_ID, PROVINCIA_PERSONA_DESC, PROVINCIA_PERSONA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PERSONA_PROVINCIA(PROVINCIA_PERSONA_ID, PROVINCIA_PERSONA_DESC, PROVINCIA_PERSONA_DESC_ALT)
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_PRV_PROVINCIA;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_RATING_AUXILIAR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_RATING_AUXILIAR where RATING_AUXILIAR_ID = -1) = 0) then
	insert into DIM_PERSONA_RATING_AUXILIAR (RATING_AUXILIAR_ID, RATING_AUXILIAR_DESC, RATING_AUXILIAR_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PERSONA_RATING_AUXILIAR(RATING_AUXILIAR_ID, RATING_AUXILIAR_DESC, RATING_AUXILIAR_DESC_ALT)
    select DD_RAX_ID, DD_RAX_DESCRIPCION, DD_RAX_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_RAX_RATING_AUXILIAR;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_RATING_EXTERNO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_RATING_EXTERNO where RATING_EXTERNO_ID = -1) = 0) then
	insert into DIM_PERSONA_RATING_EXTERNO (RATING_EXTERNO_ID, RATING_EXTERNO_DESC, RATING_EXTERNO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PERSONA_RATING_EXTERNO(RATING_EXTERNO_ID, RATING_EXTERNO_DESC, RATING_EXTERNO_DESC_ALT)
    select DD_REX_ID, DD_REX_DESCRIPCION, DD_REX_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_REX_RATING_EXTERNO;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_SEGMENTO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_SEGMENTO where SEGMENTO_ID = -1) = 0) then
	insert into DIM_PERSONA_SEGMENTO (SEGMENTO_ID, SEGMENTO_DESC, SEGMENTO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PERSONA_SEGMENTO(SEGMENTO_ID, SEGMENTO_DESC, SEGMENTO_DESC_ALT)
    select DD_SCL_ID, DD_SCL_DESCRIPCION, DD_SCL_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_SCL_SEGTO_CLI;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_SEGMENTO_DETALLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_SEGMENTO_DETALLE where SEGMENTO_DETALLE_ID = -1) = 0) then
	insert into DIM_PERSONA_SEGMENTO_DETALLE (SEGMENTO_DETALLE_ID, SEGMENTO_DETALLE_DESC, SEGMENTO_DETALLE_DESC_ALT, SEGMENTO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_PERSONA_SEGMENTO_DETALLE(SEGMENTO_DETALLE_ID, SEGMENTO_DETALLE_DESC, SEGMENTO_DETALLE_DESC_ALT, SEGMENTO_ID)
    select DD_SCE_ID, DD_SCE_DESCRIPCION, DD_SCE_DESCRIPCION_LARGA, DD_SCL_ID FROM recovery_lindorff_datastage.DD_SCE_SEGTO_CLI_ENTIDAD;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_SEXO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_SEXO where SEXO_ID = -1) = 0) then
	insert into DIM_PERSONA_SEXO (SEXO_ID, SEXO_DESC) values (-1 ,'Desconocido');
end if;

 insert into DIM_PERSONA_SEXO(SEXO_ID, SEXO_DESC)
    select DD_SEX_ID, DD_SEX_DESCRIPCION FROM recovery_lindorff_datastage.DD_SEX_SEXOS;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_TENDENCIA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_TENDENCIA where TENDENCIA_PERSONA_ID = -1) = 0) then
	insert into DIM_PERSONA_TENDENCIA (TENDENCIA_PERSONA_ID, TENDENCIA_PERSONA_DESC, TENDENCIA_PERSONA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PERSONA_TENDENCIA(TENDENCIA_PERSONA_ID, TENDENCIA_PERSONA_DESC, TENDENCIA_PERSONA_DESC_ALT)
    select TEN_ID, TEN_DESCRIPCION, TEN_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.TEN_TENDENCIA;



-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_TIPO_DOCUMENTO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_TIPO_DOCUMENTO where TIPO_DOCUMENTO_ID = -1) = 0) then
	insert into DIM_PERSONA_TIPO_DOCUMENTO (TIPO_DOCUMENTO_ID, TIPO_DOCUMENTO_DESC, TIPO_DOCUMENTO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PERSONA_TIPO_DOCUMENTO(TIPO_DOCUMENTO_ID, TIPO_DOCUMENTO_DESC, TIPO_DOCUMENTO_DESC_ALT)
    select DD_TDI_ID, DD_TDI_DESCRIPCION, DD_TDI_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TDI_TIPO_DOCUMENTO_ID;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_TIPO_ITINERARIO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_TIPO_ITINERARIO where TIPO_ITINERARIO_PERSONA_ID = -1) = 0) then
	insert into DIM_PERSONA_TIPO_ITINERARIO (TIPO_ITINERARIO_PERSONA_ID, TIPO_ITINERARIO_PERSONA_DESC, TIPO_ITINERARIO_PERSONA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PERSONA_TIPO_ITINERARIO(TIPO_ITINERARIO_PERSONA_ID, TIPO_ITINERARIO_PERSONA_DESC, TIPO_ITINERARIO_PERSONA_DESC_ALT)
    select DD_TIT_ID, DD_TIT_DESCRIPCION, DD_TIT_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TIT_TIPO_ITINERARIOS;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_TIPO_PERSONA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_TIPO_PERSONA where TIPO_PERSONA_ID = -1) = 0) then
	insert into DIM_PERSONA_TIPO_PERSONA (TIPO_PERSONA_ID, TIPO_PERSONA_DESC, TIPO_PERSONA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PERSONA_TIPO_PERSONA(TIPO_PERSONA_ID, TIPO_PERSONA_DESC, TIPO_PERSONA_DESC_ALT)
    select DD_TPE_ID, DD_TPE_DESCRIPCION, DD_TPE_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TPE_TIPO_PERSONA;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_TIPO_POLITICA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_TIPO_POLITICA where TIPO_POLITICA_PERSONA_ID = -1) = 0) then
	insert into DIM_PERSONA_TIPO_POLITICA(TIPO_POLITICA_PERSONA_ID, TIPO_POLITICA_PERSONA_DESC, TIPO_POLITICA_PERSONA_DESC_ALT, POLITICA_PERSONA_ID, TENDENCIA_PERSONA_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into DIM_PERSONA_TIPO_POLITICA(TIPO_POLITICA_PERSONA_ID, TIPO_POLITICA_PERSONA_DESC, TIPO_POLITICA_PERSONA_DESC_ALT, POLITICA_PERSONA_ID, TENDENCIA_PERSONA_ID)
    select TPL_ID, TPL_DESCRIPCION, TPL_DESCRIPCION_LARGA, DD_POL_ID, TEN_ID FROM recovery_lindorff_datastage.TPL_TIPO_POLITICA;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA_ZONA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PERSONA_ZONA where ZONA_PERSONA_ID = -1) = 0) then
	insert into DIM_PERSONA_ZONA (ZONA_PERSONA_ID, ZONA_PERSONA_DESC, ZONA_PERSONA_DESC_ALT, NIVEL_PERSONA_ID, OFICINA_PERSONA_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into DIM_PERSONA_ZONA(ZONA_PERSONA_ID, ZONA_PERSONA_DESC, ZONA_PERSONA_DESC_ALT, NIVEL_PERSONA_ID, OFICINA_PERSONA_ID)
    select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, OFI_ID FROM recovery_lindorff_datastage.ZON_ZONIFICACION;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PERSONA
-- ----------------------------------------------------------------------------------------------
  insert into DIM_PERSONA
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
    ESTADO_FINANCIERO_PERSONA_ID,
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
        coalesce(PER_TELEFONO_1, 'Desconocido'),
        coalesce(PER_TELEFONO_2, 'Desconocido'),
        coalesce(PER_MOVIL_1, 'Desconocido'),
        coalesce(PER_MOVIL_2, 'Desconocido'),
        coalesce(PER_EMAIL, 'Desconocido'),
        coalesce(ARQ_ID, -1),
        coalesce(DD_EFC_ID, -1),
        coalesce(DD_GGE_ID, -1),
        coalesce(PER_NACIONALIDAD, -1),
        coalesce(OFI_ID, -1),
        coalesce(PER_PAIS_NACIMIENTO, -1),
        coalesce(PEF_ID,  -1),
        coalesce(DD_POL_ID, -1),
        coalesce(DD_RAX_ID, -1),
        coalesce(DD_REX_ID, -1),
        coalesce(DD_SCL_ID, -1),
        coalesce(DD_SCE_ID, -1),
        coalesce(PER_SEXO, -1),
        coalesce(DD_TDI_ID, -1),
        coalesce(DD_TPE_ID, -1),
        coalesce(TPL_ID, -1),
        coalesce(ZON_ID, -1)
  from recovery_lindorff_datastage.PER_PERSONAS where BORRADO = 0;
  
  
END MY_BLOCK_DIM_PER