-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Cargar_Dim_Contrato`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_CNT: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff 
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensión Contrato.
-- ===============================================================================================
 
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN CONTRATO
    -- DIM_CONTRATO_CATALOGO_DETALLE_1 
    -- DIM_CONTRATO_CATALOGO_DETALLE_2 
    -- DIM_CONTRATO_CATALOGO_DETALLE_3 
    -- DIM_CONTRATO_CATALOGO_DETALLE_4 
    -- DIM_CONTRATO_CATALOGO_DETALLE_5 
    -- DIM_CONTRATO_CATALOGO_DETALLE_6 
    -- DIM_CONTRATO_ESTADO_CONTRATO 
    -- DIM_CONTRATO_ESTADO_FINANCIERO
    -- DIM_CONTRATO_ESTADO_FINANCIERO_AGRUPADO
    -- DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR
    -- DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR_AGRUPADO
    -- DIM_CONTRATO_FINALIDAD_CONTRATO 
    -- DIM_CONTRATO_FINALIDAD_OFICIAL 
    -- DIM_CONTRATO_GARANTIA_CONTABLE 
    -- DIM_CONTRATO_GARANTIA_CONTRATO 
    -- DIM_CONTRATO_JUDICIALIZADO
    -- DIM_CONTRATO_ESTADO_JUDICIALIZADO
    -- DIM_CONTRATO_MONEDA 
    -- DIM_CONTRATO_NIVEL 
    -- DIM_CONTRATO_OFICINA 
    -- DIM_CONTRATO_PRODUCTO 
    -- DIM_CONTRATO_PROVINCIA 
    -- DIM_CONTRATO_TIPO_PRODUCTO 
    -- DIM_CONTRATO_ZONA 
    -- DIM_CONTRATO_NACIONALIDAD_TITULAR 
    -- DIM_CONTRATO_POLITICA_TITULAR 
    -- DIM_CONTRATO_SEGMENTO_TITULAR 
    -- DIM_CONTRATO_SEXO_TITULAR 
    -- DIM_CONTRATO_SITUACION
    -- DIM_CONTRATO_SITUACION_DETALLE
    -- DIM_CONTRATO_SITUACION_ANTERIOR
    -- DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE
    -- DIM_CONTRATO_SITUACION_RESPECTO_PERIODO_ANT
    -- DIM_CONTRATO_TIPO_PERSONA_TITULAR
    -- DIM_CONTRATO_ESTADO_INSINUACION_CONTRATO
    -- DIM_CONTRATO_CARTERA
    -- DIM_CONTRATO_TIPO_CARTERA
    -- DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS
    -- DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES
    -- DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO
    -- DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT
    -- DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT
    -- DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT
    -- DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO
    -- DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO
    -- DIM_CONTRATO_GARANTIA_CONTRATO_AGRUPADO 
    -- DIM_CONTRATO_SEGMENTO_TITULAR_AGRUPADO
    -- DIM_CONTRATO_EN_GESTION_RECOBRO 
    -- DIM_CONTRATO_RESULTADO_ACTUACION
    -- DIM_CONTRATO_EN_IRREGULAR
    -- DIM_CONTRATO
    

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
--                                      DIM_CONTRATO_CATALOGO_DETALLE_1
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_CATALOGO_DETALLE_1 where CATALOGO_DETALLE_1_ID = -1) = 0) then
	insert into DIM_CONTRATO_CATALOGO_DETALLE_1 (CATALOGO_DETALLE_1_ID, CATALOGO_DETALLE_1_DESC, CATALOGO_DETALLE_1_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_CONTRATO_CATALOGO_DETALLE_1(CATALOGO_DETALLE_1_ID, CATALOGO_DETALLE_1_DESC, CATALOGO_DETALLE_1_DESC_ALT)
    select DD_CT1_ID, DD_CT1_DESCRIPCION, DD_CT1_DESCRIPCION_LARGA from recovery_lindorff_datastage.DD_CT1_CATALOGO_1;   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_CATALOGO_DETALLE_2
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_CATALOGO_DETALLE_2 where CATALOGO_DETALLE_2_ID = -1) = 0) then
	insert into DIM_CONTRATO_CATALOGO_DETALLE_2 (CATALOGO_DETALLE_2_ID, CATALOGO_DETALLE_2_DESC, CATALOGO_DETALLE_2_DESC_ALT, CATALOGO_DETALLE_1_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_CONTRATO_CATALOGO_DETALLE_2(CATALOGO_DETALLE_2_ID, CATALOGO_DETALLE_2_DESC, CATALOGO_DETALLE_2_DESC_ALT, CATALOGO_DETALLE_1_ID)
    select DD_CT2_ID, DD_CT2_DESCRIPCION, DD_CT2_DESCRIPCION_LARGA, DD_CT1_ID FROM recovery_lindorff_datastage.DD_CT2_CATALOGO_2;   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_CATALOGO_DETALLE_3
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_CATALOGO_DETALLE_3 where CATALOGO_DETALLE_3_ID = -1) = 0) then
	insert into DIM_CONTRATO_CATALOGO_DETALLE_3 (CATALOGO_DETALLE_3_ID, CATALOGO_DETALLE_3_DESC, CATALOGO_DETALLE_3_DESC_ALT, CATALOGO_DETALLE_2_ID) values (-1 ,'Desconocido', 'Desconocido',-1);
end if;

 insert into DIM_CONTRATO_CATALOGO_DETALLE_3(CATALOGO_DETALLE_3_ID, CATALOGO_DETALLE_3_DESC, CATALOGO_DETALLE_3_DESC_ALT, CATALOGO_DETALLE_2_ID)
    select DD_CT3_ID, DD_CT3_DESCRIPCION, DD_CT3_DESCRIPCION_LARGA, DD_CT2_ID FROM recovery_lindorff_datastage.DD_CT3_CATALOGO_3;   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_CATALOGO_DETALLE_4
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_CATALOGO_DETALLE_4 where CATALOGO_DETALLE_4_ID = -1) = 0) then
	insert into DIM_CONTRATO_CATALOGO_DETALLE_4 (CATALOGO_DETALLE_4_ID, CATALOGO_DETALLE_4_DESC, CATALOGO_DETALLE_4_DESC_ALT, CATALOGO_DETALLE_3_ID) values (-1 ,'Desconocido', 'Desconocido',-1);
end if;

 insert into DIM_CONTRATO_CATALOGO_DETALLE_4(CATALOGO_DETALLE_4_ID, CATALOGO_DETALLE_4_DESC, CATALOGO_DETALLE_4_DESC_ALT, CATALOGO_DETALLE_3_ID)
    select DD_CT4_ID, DD_CT4_DESCRIPCION, DD_CT4_DESCRIPCION_LARGA, DD_CT3_ID FROM recovery_lindorff_datastage.DD_CT4_CATALOGO_4;   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_CATALOGO_DETALLE_5
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_CATALOGO_DETALLE_5 where CATALOGO_DETALLE_5_ID = -1) = 0) then
	insert into DIM_CONTRATO_CATALOGO_DETALLE_5 (CATALOGO_DETALLE_5_ID, CATALOGO_DETALLE_5_DESC, CATALOGO_DETALLE_5_DESC_ALT, CATALOGO_DETALLE_4_ID) values (-1 ,'Desconocido', 'Desconocido',-1);
end if;

 insert into DIM_CONTRATO_CATALOGO_DETALLE_5(CATALOGO_DETALLE_5_ID, CATALOGO_DETALLE_5_DESC, CATALOGO_DETALLE_5_DESC_ALT, CATALOGO_DETALLE_4_ID)
    select DD_CT5_ID, DD_CT5_DESCRIPCION, DD_CT5_DESCRIPCION_LARGA, DD_CT4_ID FROM recovery_lindorff_datastage.DD_CT5_CATALOGO_5;    
    
    
-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_CATALOGO_DETALLE_6
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_CATALOGO_DETALLE_6 where CATALOGO_DETALLE_6_ID = -1) = 0) then
	insert into DIM_CONTRATO_CATALOGO_DETALLE_6 (CATALOGO_DETALLE_6_ID, CATALOGO_DETALLE_6_DESC, CATALOGO_DETALLE_6_DESC_ALT, CATALOGO_DETALLE_5_ID) values (-1 ,'Desconocido', 'Desconocido',-1);
end if;

 insert into DIM_CONTRATO_CATALOGO_DETALLE_6(CATALOGO_DETALLE_6_ID, CATALOGO_DETALLE_6_DESC, CATALOGO_DETALLE_6_DESC_ALT, CATALOGO_DETALLE_5_ID)
    select DD_CT6_ID, DD_CT6_DESCRIPCION, DD_CT6_DESCRIPCION_LARGA, DD_CT5_ID FROM recovery_lindorff_datastage.DD_CT6_CATALOGO_6;    
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_ESTADO_CONTRATO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_ESTADO_CONTRATO where ESTADO_CONTRATO_ID = -1) = 0) then
	insert into DIM_CONTRATO_ESTADO_CONTRATO (ESTADO_CONTRATO_ID, ESTADO_CONTRATO_DESC, ESTADO_CONTRATO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_CONTRATO_ESTADO_CONTRATO(ESTADO_CONTRATO_ID, ESTADO_CONTRATO_DESC, ESTADO_CONTRATO_DESC_ALT)
    select DD_ESC_ID, DD_ESC_DESCRIPCION, DD_ESC_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_ESC_ESTADO_CNT;
    
        
-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_ESTADO_FINANCIERO
--                                      DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR
-- ----------------------------------------------------------------------------------------------

-- DIM_CONTRATO_ESTADO_FINANCIERO
if ((select count(*) from DIM_CONTRATO_ESTADO_FINANCIERO where ESTADO_FINANCIERO_CONTRATO_ID = -1) = 0) then
	insert into DIM_CONTRATO_ESTADO_FINANCIERO (ESTADO_FINANCIERO_CONTRATO_ID, ESTADO_FINANCIERO_CONTRATO_DESC, ESTADO_FINANCIERO_CONTRATO_DESC_ALT, ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_CONTRATO_ESTADO_FINANCIERO(ESTADO_FINANCIERO_CONTRATO_ID, ESTADO_FINANCIERO_CONTRATO_DESC, ESTADO_FINANCIERO_CONTRATO_DESC_ALT)
    select DD_EFC_ID, DD_EFC_DESCRIPCION, DD_EFC_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_EFC_ESTADO_FINAN_CNT;

-- DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR (Misma tabla fuente)
if ((select count(*) from DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR where ESTADO_FINANCIERO_ANTERIOR_ID = -1) = 0) then
	insert into DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR (ESTADO_FINANCIERO_ANTERIOR_ID, ESTADO_FINANCIERO_ANTERIOR_DESC, ESTADO_FINANCIERO_ANTERIOR_DESC_ALT, ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR(ESTADO_FINANCIERO_ANTERIOR_ID, ESTADO_FINANCIERO_ANTERIOR_DESC, ESTADO_FINANCIERO_ANTERIOR_DESC_ALT)
    select DD_EFC_ID, DD_EFC_DESCRIPCION, DD_EFC_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_EFC_ESTADO_FINAN_CNT;
   
-- Incluimos ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID y ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID
-- 0 - NORMAL
update DIM_CONTRATO_ESTADO_FINANCIERO set ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID = 0 where ESTADO_FINANCIERO_CONTRATO_ID in (101);
update DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR set ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID = 0 where ESTADO_FINANCIERO_ANTERIOR_ID in (101);
-- 1 - LITIGIO
update DIM_CONTRATO_ESTADO_FINANCIERO set ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID = 1 where ESTADO_FINANCIERO_CONTRATO_ID in (102, 105);
update DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR set ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID = 1 where ESTADO_FINANCIERO_ANTERIOR_ID in (102, 105);
-- 2 - IMPAGADO
update DIM_CONTRATO_ESTADO_FINANCIERO set ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID = 2 where ESTADO_FINANCIERO_CONTRATO_ID in (103);
update DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR set ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID = 2 where ESTADO_FINANCIERO_ANTERIOR_ID in (103);
-- 3 - DUDOSO
update DIM_CONTRATO_ESTADO_FINANCIERO set ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID = 3 where ESTADO_FINANCIERO_CONTRATO_ID in (104);
update DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR set ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID = 3 where ESTADO_FINANCIERO_ANTERIOR_ID in (104);
-- 4 - FALLIDO
update DIM_CONTRATO_ESTADO_FINANCIERO set ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID = 4 where ESTADO_FINANCIERO_CONTRATO_ID in (106);
update DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR set ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID = 4 where ESTADO_FINANCIERO_ANTERIOR_ID in (106);
-- -1 - Desconocido
update DIM_CONTRATO_ESTADO_FINANCIERO set ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID = -1 where ESTADO_FINANCIERO_CONTRATO_ID is null;
update DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR set ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID = -1 where ESTADO_FINANCIERO_ANTERIOR_ID is null;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO_ESTADO_FINANCIERO_AGRUPADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_ESTADO_FINANCIERO_AGRUPADO where ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID = -1) = 0) then
	insert into DIM_CONTRATO_ESTADO_FINANCIERO_AGRUPADO (ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID, ESTADO_FINANCIERO_CONTRATO_AGRUPADO_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from DIM_CONTRATO_ESTADO_FINANCIERO_AGRUPADO where ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID = 0) = 0) then
	insert into DIM_CONTRATO_ESTADO_FINANCIERO_AGRUPADO (ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID, ESTADO_FINANCIERO_CONTRATO_AGRUPADO_DESC) values (0 ,'NORMAL');
end if;
if ((select count(*) from DIM_CONTRATO_ESTADO_FINANCIERO_AGRUPADO where ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID = 1) = 0) then
	insert into DIM_CONTRATO_ESTADO_FINANCIERO_AGRUPADO (ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID, ESTADO_FINANCIERO_CONTRATO_AGRUPADO_DESC) values (1 ,'LITIGIO');
end if;
if ((select count(*) from DIM_CONTRATO_ESTADO_FINANCIERO_AGRUPADO where ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID = 2) = 0) then
	insert into DIM_CONTRATO_ESTADO_FINANCIERO_AGRUPADO (ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID, ESTADO_FINANCIERO_CONTRATO_AGRUPADO_DESC) values (2 ,'IMPAGADO');
end if;
if ((select count(*) from DIM_CONTRATO_ESTADO_FINANCIERO_AGRUPADO where ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID = 3) = 0) then
	insert into DIM_CONTRATO_ESTADO_FINANCIERO_AGRUPADO (ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID, ESTADO_FINANCIERO_CONTRATO_AGRUPADO_DESC) values (3 ,'DUDOSO');
end if;
if ((select count(*) from DIM_CONTRATO_ESTADO_FINANCIERO_AGRUPADO where ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID = 4) = 0) then
	insert into DIM_CONTRATO_ESTADO_FINANCIERO_AGRUPADO (ESTADO_FINANCIERO_CONTRATO_AGRUPADO_ID, ESTADO_FINANCIERO_CONTRATO_AGRUPADO_DESC) values (4 ,'FALLIDO');
end if;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR_AGRUPADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR_AGRUPADO where ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID = -1) = 0) then
	insert into DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR_AGRUPADO (ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID, ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR_AGRUPADO where ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID = 0) = 0) then
	insert into DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR_AGRUPADO (ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID, ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_DESC) values (0 ,'NORMAL');
end if;
if ((select count(*) from DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR_AGRUPADO where ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID = 1) = 0) then
	insert into DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR_AGRUPADO (ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID, ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_DESC) values (1 ,'LITIGIO');
end if;
if ((select count(*) from DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR_AGRUPADO where ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID = 2) = 0) then
	insert into DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR_AGRUPADO (ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID, ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_DESC) values (2 ,'IMPAGADO');
end if;
if ((select count(*) from DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR_AGRUPADO where ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID = 3) = 0) then
	insert into DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR_AGRUPADO (ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID, ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_DESC) values (3 ,'DUDOSO');
end if;
if ((select count(*) from DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR_AGRUPADO where ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID = 4) = 0) then
	insert into DIM_CONTRATO_ESTADO_FINANCIERO_ANTERIOR_AGRUPADO (ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_ID, ESTADO_FINANCIERO_ANTERIOR_AGRUPADO_DESC) values (4 ,'FALLIDO');
end if;

 
-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO_FINALIDAD_CONTRATO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_FINALIDAD_CONTRATO where FINALIDAD_CONTRATO_ID = -1) = 0) then
	insert into DIM_CONTRATO_FINALIDAD_CONTRATO (FINALIDAD_CONTRATO_ID, FINALIDAD_CONTRATO_DESC, FINALIDAD_CONTRATO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_CONTRATO_FINALIDAD_CONTRATO(FINALIDAD_CONTRATO_ID, FINALIDAD_CONTRATO_DESC, FINALIDAD_CONTRATO_DESC_ALT)
    select DD_FCN_ID, DD_FCN_DESCRIPCION, DD_FCN_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_FCN_FINALIDAD_CONTRATO;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO_FINALIDAD_OFICIAL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_FINALIDAD_OFICIAL where FINALIDAD_OFICIAL_ID = -1) = 0) then
	insert into DIM_CONTRATO_FINALIDAD_OFICIAL (FINALIDAD_OFICIAL_ID, FINALIDAD_OFICIAL_DESC, FINALIDAD_OFICIAL_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_CONTRATO_FINALIDAD_OFICIAL(FINALIDAD_OFICIAL_ID, FINALIDAD_OFICIAL_DESC, FINALIDAD_OFICIAL_DESC_ALT)
    select DD_FNO_ID, DD_FNO_DESCRIPCION, DD_FNO_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_FNO_FINALIDAD_OFICIAL;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO_GARANTIA_CONTABLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_GARANTIA_CONTABLE where GARANTIA_CONTABLE_ID = -1) = 0) then
	insert into DIM_CONTRATO_GARANTIA_CONTABLE (GARANTIA_CONTABLE_ID, GARANTIA_CONTABLE_DESC, GARANTIA_CONTABLE_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_CONTRATO_GARANTIA_CONTABLE(GARANTIA_CONTABLE_ID, GARANTIA_CONTABLE_DESC, GARANTIA_CONTABLE_DESC_ALT)
    select DD_GCO_ID, DD_GCO_DESCRIPCION, DD_GCO_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_GCO_GARANTIA_CONTABLE;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO_GARANTIA_CONTRATO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_GARANTIA_CONTRATO where GARANTIA_CONTRATO_ID = -1) = 0) then
	insert into DIM_CONTRATO_GARANTIA_CONTRATO (GARANTIA_CONTRATO_ID, GARANTIA_CONTRATO_DESC, GARANTIA_CONTRATO_DESC_ALT,GARANTIA_CONTRATO_AGRUPADO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_CONTRATO_GARANTIA_CONTRATO(GARANTIA_CONTRATO_ID, GARANTIA_CONTRATO_DESC, GARANTIA_CONTRATO_DESC_ALT)
    select DD_GCN_ID, DD_GCN_DESCRIPCION, DD_GCN_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_GCN_GARANTIA_CONTRATO;

-- Incluimos GARANTIA_CONTRATO_AGRUPADO_ID
-- 0 - Hipotecario
update DIM_CONTRATO_GARANTIA_CONTRATO set GARANTIA_CONTRATO_AGRUPADO_ID = 0 where GARANTIA_CONTRATO_ID in (1,2,3,4,5,6,7);
-- 1 - Resto Garantía Real
update DIM_CONTRATO_GARANTIA_CONTRATO set GARANTIA_CONTRATO_AGRUPADO_ID = 1 where GARANTIA_CONTRATO_ID in (8,9,11,12,13);
-- 2 - Formal
update DIM_CONTRATO_GARANTIA_CONTRATO set GARANTIA_CONTRATO_AGRUPADO_ID = 2 where GARANTIA_CONTRATO_ID in (10,15,16,17,18,19,20,21);
-- 3 - Personal
update DIM_CONTRATO_GARANTIA_CONTRATO set GARANTIA_CONTRATO_AGRUPADO_ID = 3 where GARANTIA_CONTRATO_ID in (14,22,23,24);
-- 4 - Resto
update DIM_CONTRATO_GARANTIA_CONTRATO set GARANTIA_CONTRATO_AGRUPADO_ID = 4 where GARANTIA_CONTRATO_AGRUPADO_ID is null;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO_JUDICIALIZADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_JUDICIALIZADO where CONTRATO_JUDICIALIZADO_ID = -1) = 0) then
	insert into DIM_CONTRATO_JUDICIALIZADO (CONTRATO_JUDICIALIZADO_ID, CONTRATO_JUDICIALIZADO_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from DIM_CONTRATO_JUDICIALIZADO where CONTRATO_JUDICIALIZADO_ID = 0) = 0) then
	insert into DIM_CONTRATO_JUDICIALIZADO (CONTRATO_JUDICIALIZADO_ID, CONTRATO_JUDICIALIZADO_DESC) values (0 ,'No Judicializado');
end if;

if ((select count(*) from DIM_CONTRATO_JUDICIALIZADO where CONTRATO_JUDICIALIZADO_ID = 1) = 0) then
	insert into DIM_CONTRATO_JUDICIALIZADO (CONTRATO_JUDICIALIZADO_ID, CONTRATO_JUDICIALIZADO_DESC) values (1 ,'Judicializado');
end if;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO_ESTADO_JUDICIALIZADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_ESTADO_JUDICIALIZADO where CONTRATO_ESTADO_JUDICIALIZADO_ID = -2) = 0) then
	insert into DIM_CONTRATO_ESTADO_JUDICIALIZADO (CONTRATO_ESTADO_JUDICIALIZADO_ID, CONTRATO_ESTADO_JUDICIALIZADO_DESC) values (-2 ,'No Judicializado');
end if;

if ((select count(*) from DIM_CONTRATO_ESTADO_JUDICIALIZADO where CONTRATO_ESTADO_JUDICIALIZADO_ID = -1) = 0) then
	insert into DIM_CONTRATO_ESTADO_JUDICIALIZADO (CONTRATO_ESTADO_JUDICIALIZADO_ID, CONTRATO_ESTADO_JUDICIALIZADO_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from DIM_CONTRATO_ESTADO_JUDICIALIZADO where CONTRATO_ESTADO_JUDICIALIZADO_ID = 0) = 0) then
	insert into DIM_CONTRATO_ESTADO_JUDICIALIZADO (CONTRATO_ESTADO_JUDICIALIZADO_ID, CONTRATO_ESTADO_JUDICIALIZADO_DESC) values (0 ,'Inactivo');
end if;

if ((select count(*) from DIM_CONTRATO_ESTADO_JUDICIALIZADO where CONTRATO_ESTADO_JUDICIALIZADO_ID = 1) = 0) then
	insert into DIM_CONTRATO_ESTADO_JUDICIALIZADO (CONTRATO_ESTADO_JUDICIALIZADO_ID, CONTRATO_ESTADO_JUDICIALIZADO_DESC) values (1 ,'Activo');
end if;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO_MONEDA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_MONEDA where MONEDA_ID = -1) = 0) then
	insert into DIM_CONTRATO_MONEDA (MONEDA_ID, MONEDA_DESC, MONEDA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_CONTRATO_MONEDA(MONEDA_ID, MONEDA_DESC, MONEDA_DESC_ALT)
    select DD_MON_ID, DD_MON_DESCRIPCION, DD_MON_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_MON_MONEDAS;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO_NIVEL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_NIVEL where NIVEL_CONTRATO_ID = -1) = 0) then
	insert into DIM_CONTRATO_NIVEL (NIVEL_CONTRATO_ID, NIVEL_CONTRATO_DESC, NIVEL_CONTRATO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_CONTRATO_NIVEL(NIVEL_CONTRATO_ID, NIVEL_CONTRATO_DESC, NIVEL_CONTRATO_DESC_ALT)
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.NIV_NIVEL;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO_OFICINA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_OFICINA where OFICINA_CONTRATO_ID = -1) = 0) then
	insert into DIM_CONTRATO_OFICINA (OFICINA_CONTRATO_ID, OFICINA_CONTRATO_DESC, OFICINA_CONTRATO_DESC_ALT, PROVINCIA_CONTRATO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_CONTRATO_OFICINA(OFICINA_CONTRATO_ID, OFICINA_CONTRATO_DESC, PROVINCIA_CONTRATO_ID)
    select OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM recovery_lindorff_datastage.OFI_OFICINAS;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO_PRODUCTO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_PRODUCTO where PRODUCTO_ID = -1) = 0) then
	insert into DIM_CONTRATO_PRODUCTO (PRODUCTO_ID, PRODUCTO_DESC, PRODUCTO_DESC_ALT, TIPO_PRODUCTO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_CONTRATO_PRODUCTO(PRODUCTO_ID, PRODUCTO_DESC, PRODUCTO_DESC_ALT, TIPO_PRODUCTO_ID)
    select DD_TPE_ID, DD_TPE_DESCRIPCION, DD_TPE_DESCRIPCION_LARGA, DD_TPR_ID FROM recovery_lindorff_datastage.DD_TPE_TIPO_PROD_ENTIDAD;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO_PROVINCIA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_PROVINCIA where PROVINCIA_CONTRATO_ID = -1) = 0) then
	insert into DIM_CONTRATO_PROVINCIA (PROVINCIA_CONTRATO_ID, PROVINCIA_CONTRATO_DESC, PROVINCIA_CONTRATO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_CONTRATO_PROVINCIA(PROVINCIA_CONTRATO_ID, PROVINCIA_CONTRATO_DESC, PROVINCIA_CONTRATO_DESC_ALT)
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_PRV_PROVINCIA;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO_TIPO_PRODUCTO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_TIPO_PRODUCTO where TIPO_PRODUCTO_ID = -1) = 0) then
	insert into DIM_CONTRATO_TIPO_PRODUCTO (TIPO_PRODUCTO_ID, TIPO_PRODUCTO_DESC, TIPO_PRODUCTO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_CONTRATO_TIPO_PRODUCTO(TIPO_PRODUCTO_ID, TIPO_PRODUCTO_DESC, TIPO_PRODUCTO_DESC_ALT)
    select DD_TPR_ID, DD_TPR_DESCRIPCION, DD_TPR_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TPR_TIPO_PROD;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO_ZONA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_ZONA where ZONA_CONTRATO_ID = -1) = 0) then
	insert into DIM_CONTRATO_ZONA (ZONA_CONTRATO_ID, ZONA_CONTRATO_DESC, ZONA_CONTRATO_DESC_ALT, NIVEL_CONTRATO_ID, OFICINA_CONTRATO_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into DIM_CONTRATO_ZONA(ZONA_CONTRATO_ID, ZONA_CONTRATO_DESC, ZONA_CONTRATO_DESC_ALT, NIVEL_CONTRATO_ID, OFICINA_CONTRATO_ID)
    select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, OFI_ID FROM recovery_lindorff_datastage.ZON_ZONIFICACION;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_NACIONALIDAD_TITULAR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_NACIONALIDAD_TITULAR where NACIONALIDAD_TITULAR_ID = -1) = 0) then
	insert into DIM_CONTRATO_NACIONALIDAD_TITULAR (NACIONALIDAD_TITULAR_ID, NACIONALIDAD_TITULAR_DESC, NACIONALIDAD_TITULAR_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_CONTRATO_NACIONALIDAD_TITULAR(NACIONALIDAD_TITULAR_ID, NACIONALIDAD_TITULAR_DESC, NACIONALIDAD_TITULAR_DESC_ALT)
    select DD_CIC_ID, DD_CIC_DESCRIPCION, DD_CIC_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_CIC_CODIGO_ISO_CIRBE;

	
-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_POLITICA_TITULAR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_POLITICA_TITULAR where POLITICA_TITULAR_ID = -1) = 0) then
	insert into DIM_CONTRATO_POLITICA_TITULAR (POLITICA_TITULAR_ID, POLITICA_TITULAR_DESC, POLITICA_TITULAR_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_CONTRATO_POLITICA_TITULAR(POLITICA_TITULAR_ID, POLITICA_TITULAR_DESC, POLITICA_TITULAR_DESC_ALT)
    select DD_POL_ID,DD_POL_DESCRIPCION, DD_POL_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_POL_POLITICAS;
	

	-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_SEGMENTO_TITULAR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_SEGMENTO_TITULAR where SEGMENTO_TITULAR_ID = -1) = 0) then
	insert into DIM_CONTRATO_SEGMENTO_TITULAR (SEGMENTO_TITULAR_ID, SEGMENTO_TITULAR_DESC, SEGMENTO_TITULAR_DESC_ALT, SEGMENTO_TITULAR_AGRUPADO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_CONTRATO_SEGMENTO_TITULAR(SEGMENTO_TITULAR_ID, SEGMENTO_TITULAR_DESC, SEGMENTO_TITULAR_DESC_ALT)
    select DD_SCE_ID, DD_SCE_DESCRIPCION, DD_SCE_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_SCE_SEGTO_CLI_ENTIDAD;

-- Incluimos SEGMENTO_TITULAR_AGRUPADO_ID
-- 0-Micropymes
update DIM_CONTRATO_SEGMENTO_TITULAR set SEGMENTO_TITULAR_AGRUPADO_ID = 0 where SEGMENTO_TITULAR_ID in (14,15);
-- 1-Particulares
update DIM_CONTRATO_SEGMENTO_TITULAR set SEGMENTO_TITULAR_AGRUPADO_ID = 1 where SEGMENTO_TITULAR_ID in (1,2,3,4,5,6,7);
-- 2-Resto
update DIM_CONTRATO_SEGMENTO_TITULAR set SEGMENTO_TITULAR_AGRUPADO_ID = 2 where SEGMENTO_TITULAR_AGRUPADO_ID is null;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_SEXO_TITULAR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_SEXO_TITULAR where SEXO_TITULAR_ID = -1) = 0) then
	insert into DIM_CONTRATO_SEXO_TITULAR (SEXO_TITULAR_ID, SEXO_TITULAR_DESC) values (-1 ,'Desconocido');
end if;

 insert into DIM_CONTRATO_SEXO_TITULAR(SEXO_TITULAR_ID, SEXO_TITULAR_DESC)
    select DD_SEX_ID, DD_SEX_DESCRIPCION FROM recovery_lindorff_datastage.DD_SEX_SEXOS;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_SITUACION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_SITUACION where SITUACION_CONTRATO_ID = -2) = 0) then
	insert into DIM_CONTRATO_SITUACION (SITUACION_CONTRATO_ID, SITUACION_CONTRATO_DESC) values (-2 ,'Normalizado (Baja)'); -- Contrato Baja (Tiene estado anterior, pero no actual)
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION where SITUACION_CONTRATO_ID = -1) = 0) then
	insert into DIM_CONTRATO_SITUACION (SITUACION_CONTRATO_ID, SITUACION_CONTRATO_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION where SITUACION_CONTRATO_ID = 0) = 0) then
	insert into DIM_CONTRATO_SITUACION (SITUACION_CONTRATO_ID, SITUACION_CONTRATO_DESC) values (0 ,'Normal');
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION where SITUACION_CONTRATO_ID = 1) = 0) then
	insert into DIM_CONTRATO_SITUACION (SITUACION_CONTRATO_ID, SITUACION_CONTRATO_DESC) values (1 ,'Vencido No Dudoso');
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION where SITUACION_CONTRATO_ID = 2) = 0) then
	insert into DIM_CONTRATO_SITUACION (SITUACION_CONTRATO_ID, SITUACION_CONTRATO_DESC) values (2 ,'Dudoso');
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION where SITUACION_CONTRATO_ID = 3) = 0) then
	insert into DIM_CONTRATO_SITUACION (SITUACION_CONTRATO_ID, SITUACION_CONTRATO_DESC) values (3 ,'Fallido');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_SITUACION_DETALLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_SITUACION_DETALLE where SITUACION_CONTRATO_DETALLE_ID = -2) = 0) then
	insert into DIM_CONTRATO_SITUACION_DETALLE (SITUACION_CONTRATO_DETALLE_ID, SITUACION_CONTRATO_DETALLE_DESC , SITUACION_CONTRATO_ID) values (-2 ,'Normalizado (Baja)', -2); -- Contrato Baja (Tiene estado anterior, pero no actual)
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_DETALLE where SITUACION_CONTRATO_DETALLE_ID = -1) = 0) then
	insert into DIM_CONTRATO_SITUACION_DETALLE (SITUACION_CONTRATO_DETALLE_ID, SITUACION_CONTRATO_DETALLE_DESC , SITUACION_CONTRATO_ID) values (-1 ,'Desconocido', -1);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_DETALLE where SITUACION_CONTRATO_DETALLE_ID = 0) = 0) then
	insert into DIM_CONTRATO_SITUACION_DETALLE (SITUACION_CONTRATO_DETALLE_ID, SITUACION_CONTRATO_DETALLE_DESC , SITUACION_CONTRATO_ID) values (0 ,'Normal', 0);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_DETALLE where SITUACION_CONTRATO_DETALLE_ID = 1) = 0) then
	insert into DIM_CONTRATO_SITUACION_DETALLE (SITUACION_CONTRATO_DETALLE_ID, SITUACION_CONTRATO_DETALLE_DESC , SITUACION_CONTRATO_ID) values (1 ,'Vencido <= 30 Días No Litigio', 1);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_DETALLE where SITUACION_CONTRATO_DETALLE_ID = 2) = 0) then
	insert into DIM_CONTRATO_SITUACION_DETALLE (SITUACION_CONTRATO_DETALLE_ID, SITUACION_CONTRATO_DETALLE_DESC , SITUACION_CONTRATO_ID) values (2 ,'Vencido 31-60 Días No Litigio', 1);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_DETALLE where SITUACION_CONTRATO_DETALLE_ID = 3) = 0) then
	insert into DIM_CONTRATO_SITUACION_DETALLE (SITUACION_CONTRATO_DETALLE_ID, SITUACION_CONTRATO_DETALLE_DESC , SITUACION_CONTRATO_ID) values (3 ,'Vencido > 60 Días No Litigio',1);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_DETALLE where SITUACION_CONTRATO_DETALLE_ID = 4) = 0) then
	insert into DIM_CONTRATO_SITUACION_DETALLE (SITUACION_CONTRATO_DETALLE_ID, SITUACION_CONTRATO_DETALLE_DESC , SITUACION_CONTRATO_ID) values (4 ,'Vencido <= 30 Días Litigio', 1);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_DETALLE where SITUACION_CONTRATO_DETALLE_ID = 5) = 0) then
	insert into DIM_CONTRATO_SITUACION_DETALLE (SITUACION_CONTRATO_DETALLE_ID, SITUACION_CONTRATO_DETALLE_DESC , SITUACION_CONTRATO_ID) values (5 ,'Vencido 31-60 Días Litigio', 1);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_DETALLE where SITUACION_CONTRATO_DETALLE_ID = 6) = 0) then
	insert into DIM_CONTRATO_SITUACION_DETALLE (SITUACION_CONTRATO_DETALLE_ID, SITUACION_CONTRATO_DETALLE_DESC , SITUACION_CONTRATO_ID) values (6 ,'Vencido > 60 Días Litigio',1);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_DETALLE where SITUACION_CONTRATO_DETALLE_ID = 7) = 0) then
	insert into DIM_CONTRATO_SITUACION_DETALLE (SITUACION_CONTRATO_DETALLE_ID, SITUACION_CONTRATO_DETALLE_DESC , SITUACION_CONTRATO_ID) values (7 ,'Dudoso No Litigio', 2);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_DETALLE where SITUACION_CONTRATO_DETALLE_ID = 8) = 0) then
	insert into DIM_CONTRATO_SITUACION_DETALLE (SITUACION_CONTRATO_DETALLE_ID, SITUACION_CONTRATO_DETALLE_DESC , SITUACION_CONTRATO_ID) values (8 ,'Dudoso Litigio', 2);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_DETALLE where SITUACION_CONTRATO_DETALLE_ID = 9) = 0) then
	insert into DIM_CONTRATO_SITUACION_DETALLE (SITUACION_CONTRATO_DETALLE_ID, SITUACION_CONTRATO_DETALLE_DESC , SITUACION_CONTRATO_ID) values (9 ,'Fallido Litigio', 3);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_DETALLE where SITUACION_CONTRATO_DETALLE_ID = 10) = 0) then
	insert into DIM_CONTRATO_SITUACION_DETALLE (SITUACION_CONTRATO_DETALLE_ID, SITUACION_CONTRATO_DETALLE_DESC , SITUACION_CONTRATO_ID) values (10 ,'Resto Fallido', 3);
end if;


  -- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_SITUACION_ANTERIOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR where SITUACION_ANTERIOR_CONTRATO_ID = -2) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR (SITUACION_ANTERIOR_CONTRATO_ID, SITUACION_ANTERIOR_CONTRATO_DESC) values (-2 ,'No Existe (Alta)'); -- Contrato Alta (Tiene estado actual, pero no anterior)
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR where SITUACION_ANTERIOR_CONTRATO_ID = -1) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR (SITUACION_ANTERIOR_CONTRATO_ID, SITUACION_ANTERIOR_CONTRATO_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR where SITUACION_ANTERIOR_CONTRATO_ID = 0) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR (SITUACION_ANTERIOR_CONTRATO_ID, SITUACION_ANTERIOR_CONTRATO_DESC) values (0 ,'Normal');
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR where SITUACION_ANTERIOR_CONTRATO_ID = 1) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR (SITUACION_ANTERIOR_CONTRATO_ID, SITUACION_ANTERIOR_CONTRATO_DESC) values (1 ,'Vencido No Dudoso');
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR where SITUACION_ANTERIOR_CONTRATO_ID = 2) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR (SITUACION_ANTERIOR_CONTRATO_ID, SITUACION_ANTERIOR_CONTRATO_DESC) values (2 ,'Dudoso');
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR where SITUACION_ANTERIOR_CONTRATO_ID = 3) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR (SITUACION_ANTERIOR_CONTRATO_ID, SITUACION_ANTERIOR_CONTRATO_DESC) values (3 ,'Fallido');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE where SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = -2) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE (SITUACION_ANTERIOR_CONTRATO_DETALLE_ID, SITUACION_ANTERIOR_CONTRATO_DETALLE_DESC , SITUACION_ANTERIOR_CONTRATO_ID) values (-2 ,'Normalizado (Baja)', -2); -- Contrato Baja (Tiene estado anterior, pero no actual)
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE where SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = -1) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE (SITUACION_ANTERIOR_CONTRATO_DETALLE_ID, SITUACION_ANTERIOR_CONTRATO_DETALLE_DESC , SITUACION_ANTERIOR_CONTRATO_ID) values (-1 ,'Desconocido', -1);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE where SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = 0) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE (SITUACION_ANTERIOR_CONTRATO_DETALLE_ID, SITUACION_ANTERIOR_CONTRATO_DETALLE_DESC , SITUACION_ANTERIOR_CONTRATO_ID) values (0 ,'Normal', 0);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE where SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = 1) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE (SITUACION_ANTERIOR_CONTRATO_DETALLE_ID, SITUACION_ANTERIOR_CONTRATO_DETALLE_DESC , SITUACION_ANTERIOR_CONTRATO_ID) values (1 ,'Vencido <= 30 Días No Litigio', 1);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE where SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = 2) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE (SITUACION_ANTERIOR_CONTRATO_DETALLE_ID, SITUACION_ANTERIOR_CONTRATO_DETALLE_DESC , SITUACION_ANTERIOR_CONTRATO_ID) values (2 ,'Vencido 31-60 Días No Litigio', 1);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE where SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = 3) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE (SITUACION_ANTERIOR_CONTRATO_DETALLE_ID, SITUACION_ANTERIOR_CONTRATO_DETALLE_DESC , SITUACION_ANTERIOR_CONTRATO_ID) values (3 ,'Vencido > 60 Días No Litigio',1);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE where SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = 4) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE (SITUACION_ANTERIOR_CONTRATO_DETALLE_ID, SITUACION_ANTERIOR_CONTRATO_DETALLE_DESC , SITUACION_ANTERIOR_CONTRATO_ID) values (4 ,'Vencido <= 30 Días Litigio', 1);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE where SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = 5) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE (SITUACION_ANTERIOR_CONTRATO_DETALLE_ID, SITUACION_ANTERIOR_CONTRATO_DETALLE_DESC , SITUACION_ANTERIOR_CONTRATO_ID) values (5 ,'Vencido 31-60 Días Litigio', 1);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE where SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = 6) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE (SITUACION_ANTERIOR_CONTRATO_DETALLE_ID, SITUACION_ANTERIOR_CONTRATO_DETALLE_DESC , SITUACION_ANTERIOR_CONTRATO_ID) values (6 ,'Vencido > 60 Días Litigio',1);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE where SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = 7) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE (SITUACION_ANTERIOR_CONTRATO_DETALLE_ID, SITUACION_ANTERIOR_CONTRATO_DETALLE_DESC , SITUACION_ANTERIOR_CONTRATO_ID) values (7 ,'Dudoso No Litigio', 2);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE where SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = 8) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE (SITUACION_ANTERIOR_CONTRATO_DETALLE_ID, SITUACION_ANTERIOR_CONTRATO_DETALLE_DESC , SITUACION_ANTERIOR_CONTRATO_ID) values (8 ,'Dudoso Litigio', 2);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE where SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = 9) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE (SITUACION_ANTERIOR_CONTRATO_DETALLE_ID, SITUACION_ANTERIOR_CONTRATO_DETALLE_DESC , SITUACION_ANTERIOR_CONTRATO_ID) values (9 ,'Fallido Litigio', 3);
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE where SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = 10) = 0) then
	insert into DIM_CONTRATO_SITUACION_ANTERIOR_DETALLE (SITUACION_ANTERIOR_CONTRATO_DETALLE_ID, SITUACION_ANTERIOR_CONTRATO_DETALLE_DESC , SITUACION_ANTERIOR_CONTRATO_ID) values (10 ,'Resto Fallido', 3);
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_SITUACION_RESPECTO_PERIODO_ANT
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_SITUACION_RESPECTO_PERIODO_ANT where SITUACION_RESPECTO_PERIODO_ANT_ID = -1) = 0) then
	insert into DIM_CONTRATO_SITUACION_RESPECTO_PERIODO_ANT (SITUACION_RESPECTO_PERIODO_ANT_ID, SITUACION_RESPECTO_PERIODO_ANT_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_RESPECTO_PERIODO_ANT where SITUACION_RESPECTO_PERIODO_ANT_ID = 0) = 0) then
	insert into DIM_CONTRATO_SITUACION_RESPECTO_PERIODO_ANT (SITUACION_RESPECTO_PERIODO_ANT_ID, SITUACION_RESPECTO_PERIODO_ANT_DESC) values (0 ,'Mantiene');
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_RESPECTO_PERIODO_ANT where SITUACION_RESPECTO_PERIODO_ANT_ID = 1) = 0) then
	insert into DIM_CONTRATO_SITUACION_RESPECTO_PERIODO_ANT (SITUACION_RESPECTO_PERIODO_ANT_ID, SITUACION_RESPECTO_PERIODO_ANT_DESC) values (1 ,'Alta');
end if;
if ((select count(*) from DIM_CONTRATO_SITUACION_RESPECTO_PERIODO_ANT where SITUACION_RESPECTO_PERIODO_ANT_ID = 2) = 0) then
	insert into DIM_CONTRATO_SITUACION_RESPECTO_PERIODO_ANT (SITUACION_RESPECTO_PERIODO_ANT_ID, SITUACION_RESPECTO_PERIODO_ANT_DESC) values (2 ,'Baja');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_TIPO_PERSONA_TITULAR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_TIPO_PERSONA_TITULAR where TIPO_PERSONA_TITULAR_ID = -1) = 0) then
	insert into DIM_CONTRATO_TIPO_PERSONA_TITULAR (TIPO_PERSONA_TITULAR_ID, TIPO_PERSONA_TITULAR_DESC, TIPO_PERSONA_TITULAR_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_CONTRATO_TIPO_PERSONA_TITULAR(TIPO_PERSONA_TITULAR_ID, TIPO_PERSONA_TITULAR_DESC, TIPO_PERSONA_TITULAR_DESC_ALT)
    select DD_TPE_ID, DD_TPE_DESCRIPCION, DD_TPE_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TPE_TIPO_PERSONA;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_ESTADO_INSINUACION_CONTRATO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_ESTADO_INSINUACION_CONTRATO where ESTADO_INSINUACION_CONTRATO_ID = -2) = 0) then
	insert into DIM_CONTRATO_ESTADO_INSINUACION_CONTRATO (ESTADO_INSINUACION_CONTRATO_ID, ESTADO_INSINUACION_CONTRATO_DESC, ESTADO_INSINUACION_CONTRATO_DESC_ALT) values (-2 ,'Sin Cédito Insinuado Asociado', 'Sin Cédito Insinuado Asociado');
end if;

if ((select count(*) from DIM_CONTRATO_ESTADO_INSINUACION_CONTRATO where ESTADO_INSINUACION_CONTRATO_ID = -1) = 0) then
	insert into DIM_CONTRATO_ESTADO_INSINUACION_CONTRATO (ESTADO_INSINUACION_CONTRATO_ID, ESTADO_INSINUACION_CONTRATO_DESC, ESTADO_INSINUACION_CONTRATO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_CONTRATO_ESTADO_INSINUACION_CONTRATO(ESTADO_INSINUACION_CONTRATO_ID, ESTADO_INSINUACION_CONTRATO_DESC, ESTADO_INSINUACION_CONTRATO_DESC_ALT)
    select STD_CRE_ID, STD_CRE_DESCRIP, STD_CRE_DESCRIP_LARGA FROM recovery_lindorff_datastage.DD_STD_CREDITO;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_CEDENTE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_CEDENTE where CEDENTE_CONTRATO_ID = -1) = 0) then
	insert into DIM_CONTRATO_CEDENTE (CEDENTE_CONTRATO_ID, CEDENTE_CONTRATO_DESC) values (-1 ,'Desconocido');
end if;

insert into DIM_CONTRATO_CEDENTE (CEDENTE_CONTRATO_ID, CEDENTE_CONTRATO_DESC)
    select DD_ENC_ID, DD_ENC_DESCRIPCION FROM recovery_lindorff_datastage.DD_ENC_ENTIDADES_CEDENTES;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_PROPIETARIO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_PROPIETARIO where PROPIETARIO_CONTRATO_ID = -1) = 0) then
	insert into DIM_CONTRATO_PROPIETARIO (PROPIETARIO_CONTRATO_ID, PROPIETARIO_CONTRATO_DESC) values (-1 ,'Desconocido');
end if;

insert into DIM_CONTRATO_PROPIETARIO (PROPIETARIO_CONTRATO_ID, PROPIETARIO_CONTRATO_DESC)
    select DD_ENP_ID, DD_ENP_DESCRIPCION FROM recovery_lindorff_datastage.DD_ENP_ENTIDADES_PROPIETARIAS;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_TIPO_CARTERA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_TIPO_CARTERA where TIPO_CARTERA_CONTRATO_ID = -1) = 0) then
	insert into DIM_CONTRATO_TIPO_CARTERA (TIPO_CARTERA_CONTRATO_ID, TIPO_CARTERA_CONTRATO_DESC) values (-1 ,'Desconocido');
end if;

insert into DIM_CONTRATO_TIPO_CARTERA (TIPO_CARTERA_CONTRATO_ID, TIPO_CARTERA_CONTRATO_DESC)
    select TIPO_CARTERA_ID, TIPO_CARTERA_DESCRIPCION from recovery_lindorff_datastage.DD_TCA_TIPO_CARTERA;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_CARTERA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_CARTERA where CARTERA_CONTRATO_ID = -1) = 0) then
	insert into DIM_CONTRATO_CARTERA (CARTERA_CONTRATO_ID, CARTERA_CONTRATO_DESC, TIPO_CARTERA_CONTRATO_ID) values (-1 ,'Desconocido', -1);
end if;

insert into DIM_CONTRATO_CARTERA (CARTERA_CONTRATO_ID, CARTERA_CONTRATO_DESC, TIPO_CARTERA_CONTRATO_ID)
    select CAR_ID, CAR_DESCRIPCION, TIPO_CARTERA_ID FROM recovery_lindorff_datastage.CAR_CARTERA;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS where TRAMO_IRREGULARIDAD_DIAS_ID = -1) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS (TRAMO_IRREGULARIDAD_DIAS_ID, TRAMO_IRREGULARIDAD_DIAS_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS where TRAMO_IRREGULARIDAD_DIAS_ID = 0) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS (TRAMO_IRREGULARIDAD_DIAS_ID, TRAMO_IRREGULARIDAD_DIAS_DESC) values (0 ,'Sin Irregularidad');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS where TRAMO_IRREGULARIDAD_DIAS_ID = 1) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS (TRAMO_IRREGULARIDAD_DIAS_ID, TRAMO_IRREGULARIDAD_DIAS_DESC) values (1 ,'<= 30 Días');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS where TRAMO_IRREGULARIDAD_DIAS_ID = 2) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS (TRAMO_IRREGULARIDAD_DIAS_ID, TRAMO_IRREGULARIDAD_DIAS_DESC) values (2 ,'31-60 Días');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS where TRAMO_IRREGULARIDAD_DIAS_ID = 3) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS (TRAMO_IRREGULARIDAD_DIAS_ID, TRAMO_IRREGULARIDAD_DIAS_DESC) values (3 ,'61-90 Días');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS where TRAMO_IRREGULARIDAD_DIAS_ID = 4) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS (TRAMO_IRREGULARIDAD_DIAS_ID, TRAMO_IRREGULARIDAD_DIAS_DESC) values (4 ,'91-120 Días');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS where TRAMO_IRREGULARIDAD_DIAS_ID = 5) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS (TRAMO_IRREGULARIDAD_DIAS_ID, TRAMO_IRREGULARIDAD_DIAS_DESC) values (5 ,'121 Días-1 Año');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS where TRAMO_IRREGULARIDAD_DIAS_ID = 6) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS (TRAMO_IRREGULARIDAD_DIAS_ID, TRAMO_IRREGULARIDAD_DIAS_DESC) values (6 ,'1-3 Años');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS where TRAMO_IRREGULARIDAD_DIAS_ID = 7) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS (TRAMO_IRREGULARIDAD_DIAS_ID, TRAMO_IRREGULARIDAD_DIAS_DESC) values (7 ,'> 3 Años');
end if;
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES where TRAMO_IRREGULARIDAD_FASES_ID = -1) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES (TRAMO_IRREGULARIDAD_FASES_ID, TRAMO_IRREGULARIDAD_FASES_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID) values (-1 ,'Fase No Informada', -1);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES where TRAMO_IRREGULARIDAD_FASES_ID = 0) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES (TRAMO_IRREGULARIDAD_FASES_ID, TRAMO_IRREGULARIDAD_FASES_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID) values (0 ,'Al Día',0);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES where TRAMO_IRREGULARIDAD_FASES_ID = 1) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES (TRAMO_IRREGULARIDAD_FASES_ID, TRAMO_IRREGULARIDAD_FASES_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID) values (1 ,'A', 1);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES where TRAMO_IRREGULARIDAD_FASES_ID = 2) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES (TRAMO_IRREGULARIDAD_FASES_ID, TRAMO_IRREGULARIDAD_FASES_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID) values (2 ,'B', 2);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES where TRAMO_IRREGULARIDAD_FASES_ID = 3) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES (TRAMO_IRREGULARIDAD_FASES_ID, TRAMO_IRREGULARIDAD_FASES_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID) values (3 ,'C', 3);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES where TRAMO_IRREGULARIDAD_FASES_ID = 4) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES (TRAMO_IRREGULARIDAD_FASES_ID, TRAMO_IRREGULARIDAD_FASES_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID) values (4 ,'D', 4);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES where TRAMO_IRREGULARIDAD_FASES_ID = 5) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES (TRAMO_IRREGULARIDAD_FASES_ID, TRAMO_IRREGULARIDAD_FASES_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID) values (5 ,'E', 5);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES where TRAMO_IRREGULARIDAD_FASES_ID = 6) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES (TRAMO_IRREGULARIDAD_FASES_ID, TRAMO_IRREGULARIDAD_FASES_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID) values (6 ,'F', 5);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES where TRAMO_IRREGULARIDAD_FASES_ID = 7) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES (TRAMO_IRREGULARIDAD_FASES_ID, TRAMO_IRREGULARIDAD_FASES_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID) values (7 ,'G', 5);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES where TRAMO_IRREGULARIDAD_FASES_ID = 8) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES (TRAMO_IRREGULARIDAD_FASES_ID, TRAMO_IRREGULARIDAD_FASES_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID) values (8 ,'H', 5);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES where TRAMO_IRREGULARIDAD_FASES_ID = 9) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES (TRAMO_IRREGULARIDAD_FASES_ID, TRAMO_IRREGULARIDAD_FASES_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID) values (9 ,'X', 5);
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO where TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID = -1) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO (TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_DESC) values (-1 ,'Fase No Informada');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO where TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID = 0) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO (TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_DESC) values (0 ,'Al Día');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO where TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID = 1) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO (TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_DESC) values (1 ,'A');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO where TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID = 2) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO (TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_DESC) values (2 ,'B');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO where TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID = 3) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO (TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_DESC) values (3 ,'C');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO where TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID = 4) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO (TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_DESC) values (4 ,'D');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO where TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID = 5) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO (TRAMO_IRREGULARIDAD_FASES_AGRUPADO_ID, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_DESC) values (5 ,'>= E');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT where TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID = -2) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT (TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_DESC) values (-2 ,'No Existe En Periodo Anterior'); 
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT where TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID = -1) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT (TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT where TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID = 0) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT (TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_DESC) values (0 ,'Sin Irregularidad');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT where TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID = 1) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT (TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_DESC) values (1 ,'<= 30 Días');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT where TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID = 2) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT (TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_DESC) values (2 ,'31-60 Días');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT where TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID = 3) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT (TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_DESC) values (3 ,'61-90 Días');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT where TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID = 4) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT (TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_DESC) values (4 ,'91-120 Días');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT where TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID = 5) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT (TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_DESC) values (5 ,'121 Días-1 Año');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT where TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID = 6) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT (TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_DESC) values (6 ,'1-3 Años');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT where TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID = 7) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT (TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_DESC) values (7 ,'> 3 Años');
end if;
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = -2) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID) values (-2 ,'No Existe En Periodo Anterior', -2); 
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = -1) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID) values (-1 ,'Fase No Informada', -1);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = 0) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID) values (0 ,'Al Día',0);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = 1) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID) values (1 ,'A', 1);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = 2) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID) values (2 ,'B', 2);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = 3) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID) values (3 ,'C', 3);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = 4) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID) values (4 ,'D', 4);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = 5) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID) values (5 ,'E', 5);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = 6) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID) values (6 ,'F', 5);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = 7) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID) values (7 ,'G', 5);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = 8) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID) values (8 ,'H', 5);
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = 9) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_DESC, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID) values (9 ,'X', 5);
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID = -2) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_DESC) values (-2 ,'No Existe En Periodo Anterior'); 
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID = -1) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_DESC) values (-1 ,'Fase No Informada');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID = 0) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_DESC) values (0 ,'Al Día');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID = 1) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_DESC) values (1 ,'A');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID = 2) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_DESC) values (2 ,'B');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID = 3) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_DESC) values (3 ,'C');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID = 4) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_DESC) values (4 ,'D');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT where TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID = 5) = 0) then
	insert into DIM_CONTRATO_TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT (TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_ID, TRAMO_IRREGULARIDAD_FASES_AGRUPADO_PERIODO_ANT_DESC) values (5 ,'>= E');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO where TRAMO_DIAS_EN_GESTION_A_COBRO_ID = -3) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO (TRAMO_DIAS_EN_GESTION_A_COBRO_ID, TRAMO_DIAS_EN_GESTION_A_COBRO_DESC) values (-3, 'Sin Cobro');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO where TRAMO_DIAS_EN_GESTION_A_COBRO_ID = -2) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO (TRAMO_DIAS_EN_GESTION_A_COBRO_ID, TRAMO_DIAS_EN_GESTION_A_COBRO_DESC) values (-2, 'Sin Gestión Recobro');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO where TRAMO_DIAS_EN_GESTION_A_COBRO_ID = -1) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO (TRAMO_DIAS_EN_GESTION_A_COBRO_ID, TRAMO_DIAS_EN_GESTION_A_COBRO_DESC) values (-1, 'Desconocido');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO where TRAMO_DIAS_EN_GESTION_A_COBRO_ID = 0) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO (TRAMO_DIAS_EN_GESTION_A_COBRO_ID, TRAMO_DIAS_EN_GESTION_A_COBRO_DESC) values (0, '<= 5 Días');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO where TRAMO_DIAS_EN_GESTION_A_COBRO_ID = 1) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO (TRAMO_DIAS_EN_GESTION_A_COBRO_ID, TRAMO_DIAS_EN_GESTION_A_COBRO_DESC) values (1, '6-10 Días');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO where TRAMO_DIAS_EN_GESTION_A_COBRO_ID = 2) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO (TRAMO_DIAS_EN_GESTION_A_COBRO_ID, TRAMO_DIAS_EN_GESTION_A_COBRO_DESC) values (2, '11-15 Días');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO where TRAMO_DIAS_EN_GESTION_A_COBRO_ID = 3) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO (TRAMO_DIAS_EN_GESTION_A_COBRO_ID, TRAMO_DIAS_EN_GESTION_A_COBRO_DESC) values (3, '16-20 Días');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO where TRAMO_DIAS_EN_GESTION_A_COBRO_ID = 4) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO (TRAMO_DIAS_EN_GESTION_A_COBRO_ID, TRAMO_DIAS_EN_GESTION_A_COBRO_DESC) values (4, '21-25 Días');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO where TRAMO_DIAS_EN_GESTION_A_COBRO_ID = 5) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_EN_GESTION_A_COBRO (TRAMO_DIAS_EN_GESTION_A_COBRO_ID, TRAMO_DIAS_EN_GESTION_A_COBRO_DESC) values (5, '> 25 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO where TRAMO_DIAS_IRREGULAR_A_COBRO_ID = -3) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO (TRAMO_DIAS_IRREGULAR_A_COBRO_ID, TRAMO_DIAS_IRREGULAR_A_COBRO_DESC) values (-3, 'Sin Cobro');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO where TRAMO_DIAS_IRREGULAR_A_COBRO_ID = -2) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO (TRAMO_DIAS_IRREGULAR_A_COBRO_ID, TRAMO_DIAS_IRREGULAR_A_COBRO_DESC) values (-2, 'Sin Gestión Recobro');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO where TRAMO_DIAS_IRREGULAR_A_COBRO_ID = -1) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO (TRAMO_DIAS_IRREGULAR_A_COBRO_ID, TRAMO_DIAS_IRREGULAR_A_COBRO_DESC) values (-1, 'Contrato Sin Impago');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO where TRAMO_DIAS_IRREGULAR_A_COBRO_ID = 0) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO (TRAMO_DIAS_IRREGULAR_A_COBRO_ID, TRAMO_DIAS_IRREGULAR_A_COBRO_DESC) values (0, '<= 30 Días');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO where TRAMO_DIAS_IRREGULAR_A_COBRO_ID = 1) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO (TRAMO_DIAS_IRREGULAR_A_COBRO_ID, TRAMO_DIAS_IRREGULAR_A_COBRO_DESC) values (1, '31-60 Días');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO where TRAMO_DIAS_IRREGULAR_A_COBRO_ID = 2) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO (TRAMO_DIAS_IRREGULAR_A_COBRO_ID, TRAMO_DIAS_IRREGULAR_A_COBRO_DESC) values (2, '61-90 Días');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO where TRAMO_DIAS_IRREGULAR_A_COBRO_ID = 3) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO (TRAMO_DIAS_IRREGULAR_A_COBRO_ID, TRAMO_DIAS_IRREGULAR_A_COBRO_DESC) values (3, '91 Días-1 Año');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO where TRAMO_DIAS_IRREGULAR_A_COBRO_ID = 4) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO (TRAMO_DIAS_IRREGULAR_A_COBRO_ID, TRAMO_DIAS_IRREGULAR_A_COBRO_DESC) values (4, '1-3 Años');
end if;
if ((select count(*) from DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO where TRAMO_DIAS_IRREGULAR_A_COBRO_ID = 5) = 0) then
	insert into DIM_CONTRATO_TRAMO_DIAS_IRREGULAR_A_COBRO (TRAMO_DIAS_IRREGULAR_A_COBRO_ID, TRAMO_DIAS_IRREGULAR_A_COBRO_DESC) values (5, '> 3 Años');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_GARANTIA_CONTRATO_AGRUPADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_GARANTIA_CONTRATO_AGRUPADO where GARANTIA_CONTRATO_AGRUPADO_ID = -1) = 0) then
	insert into DIM_CONTRATO_GARANTIA_CONTRATO_AGRUPADO (GARANTIA_CONTRATO_AGRUPADO_ID, GARANTIA_CONTRATO_AGRUPADO_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from DIM_CONTRATO_GARANTIA_CONTRATO_AGRUPADO where GARANTIA_CONTRATO_AGRUPADO_ID = 0) = 0) then
	insert into DIM_CONTRATO_GARANTIA_CONTRATO_AGRUPADO (GARANTIA_CONTRATO_AGRUPADO_ID, GARANTIA_CONTRATO_AGRUPADO_DESC) values (0 ,'Hipotecaria');
end if;
if ((select count(*) from DIM_CONTRATO_GARANTIA_CONTRATO_AGRUPADO where GARANTIA_CONTRATO_AGRUPADO_ID = 1) = 0) then
	insert into DIM_CONTRATO_GARANTIA_CONTRATO_AGRUPADO (GARANTIA_CONTRATO_AGRUPADO_ID, GARANTIA_CONTRATO_AGRUPADO_DESC) values (1 ,'Resto Garantía Real');
end if;
if ((select count(*) from DIM_CONTRATO_GARANTIA_CONTRATO_AGRUPADO where GARANTIA_CONTRATO_AGRUPADO_ID = 2) = 0) then
	insert into DIM_CONTRATO_GARANTIA_CONTRATO_AGRUPADO (GARANTIA_CONTRATO_AGRUPADO_ID, GARANTIA_CONTRATO_AGRUPADO_DESC) values (2 ,'Formal');
end if;
if ((select count(*) from DIM_CONTRATO_GARANTIA_CONTRATO_AGRUPADO where GARANTIA_CONTRATO_AGRUPADO_ID = 3) = 0) then
	insert into DIM_CONTRATO_GARANTIA_CONTRATO_AGRUPADO (GARANTIA_CONTRATO_AGRUPADO_ID, GARANTIA_CONTRATO_AGRUPADO_DESC) values (3 ,'Personal');
end if;
if ((select count(*) from DIM_CONTRATO_GARANTIA_CONTRATO_AGRUPADO where GARANTIA_CONTRATO_AGRUPADO_ID = 4) = 0) then
	insert into DIM_CONTRATO_GARANTIA_CONTRATO_AGRUPADO (GARANTIA_CONTRATO_AGRUPADO_ID, GARANTIA_CONTRATO_AGRUPADO_DESC) values (4 ,'Resto');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_SEGMENTO_TITULAR_AGRUPADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_SEGMENTO_TITULAR_AGRUPADO where SEGMENTO_TITULAR_AGRUPADO_ID = -1) = 0) then
	insert into DIM_CONTRATO_SEGMENTO_TITULAR_AGRUPADO (SEGMENTO_TITULAR_AGRUPADO_ID, SEGMENTO_TITULAR_AGRUPADO_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from DIM_CONTRATO_SEGMENTO_TITULAR_AGRUPADO where SEGMENTO_TITULAR_AGRUPADO_ID = 0) = 0) then
	insert into DIM_CONTRATO_SEGMENTO_TITULAR_AGRUPADO (SEGMENTO_TITULAR_AGRUPADO_ID, SEGMENTO_TITULAR_AGRUPADO_DESC) values (0 ,'Micropymes');
end if;
if ((select count(*) from DIM_CONTRATO_SEGMENTO_TITULAR_AGRUPADO where SEGMENTO_TITULAR_AGRUPADO_ID = 1) = 0) then
	insert into DIM_CONTRATO_SEGMENTO_TITULAR_AGRUPADO (SEGMENTO_TITULAR_AGRUPADO_ID, SEGMENTO_TITULAR_AGRUPADO_DESC) values (1 ,'Particulares');
end if;
if ((select count(*) from DIM_CONTRATO_SEGMENTO_TITULAR_AGRUPADO where SEGMENTO_TITULAR_AGRUPADO_ID = 2) = 0) then
	insert into DIM_CONTRATO_SEGMENTO_TITULAR_AGRUPADO (SEGMENTO_TITULAR_AGRUPADO_ID, SEGMENTO_TITULAR_AGRUPADO_DESC) values (2 ,'Resto');
end if;
    
 
-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_RESULTADO_ACTUACION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_RESULTADO_ACTUACION where RESULTADO_ACTUACION_CONTRATO_ID = -2) = 0) then
	insert into DIM_CONTRATO_RESULTADO_ACTUACION (RESULTADO_ACTUACION_CONTRATO_ID, RESULTADO_ACTUACION_CONTRATO_DESC) values (-2, 'No En Gestión');
end if;

if ((select count(*) from DIM_CONTRATO_RESULTADO_ACTUACION where RESULTADO_ACTUACION_CONTRATO_ID = -1) = 0) then
	insert into DIM_CONTRATO_RESULTADO_ACTUACION (RESULTADO_ACTUACION_CONTRATO_ID, RESULTADO_ACTUACION_CONTRATO_DESC) values (-1, 'Desconocido');
end if;

if ((select count(*) from DIM_CONTRATO_RESULTADO_ACTUACION where RESULTADO_ACTUACION_CONTRATO_ID = 0) = 0) then
	insert into DIM_CONTRATO_RESULTADO_ACTUACION (RESULTADO_ACTUACION_CONTRATO_ID, RESULTADO_ACTUACION_CONTRATO_DESC) values (0, 'Sin Actuación');
end if;

 insert into DIM_CONTRATO_RESULTADO_ACTUACION(RESULTADO_ACTUACION_CONTRATO_ID, RESULTADO_ACTUACION_CONTRATO_DESC)
    select DD_RGT_ID, DD_RGT_DESCRIPCION FROM recovery_lindorff_datastage.DD_RGT_RESULT_GESTION_TEL; 


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_EN_GESTION_RECOBRO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_EN_GESTION_RECOBRO where EN_GESTION_RECOBRO_ID = -1) = 0) then
	insert into DIM_CONTRATO_EN_GESTION_RECOBRO (EN_GESTION_RECOBRO_ID, EN_GESTION_RECOBRO_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from DIM_CONTRATO_EN_GESTION_RECOBRO where EN_GESTION_RECOBRO_ID = 0) = 0) then
	insert into DIM_CONTRATO_EN_GESTION_RECOBRO (EN_GESTION_RECOBRO_ID, EN_GESTION_RECOBRO_DESC) values (0 ,'Sin Gestión Recobro');
end if;
if ((select count(*) from DIM_CONTRATO_EN_GESTION_RECOBRO where EN_GESTION_RECOBRO_ID = 1) = 0) then
	insert into DIM_CONTRATO_EN_GESTION_RECOBRO (EN_GESTION_RECOBRO_ID, EN_GESTION_RECOBRO_DESC) values (1 ,'En Gestión Recobro');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_CONTRATO_EN_IRREGULAR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_CONTRATO_EN_IRREGULAR where CONTRATO_EN_IRREGULAR_ID = -1) = 0) then
	insert into DIM_CONTRATO_EN_IRREGULAR (CONTRATO_EN_IRREGULAR_ID, CONTRATO_EN_IRREGULAR_DESC) values (-1, 'Desconocido');
end if;
if ((select count(*) from DIM_CONTRATO_EN_IRREGULAR where CONTRATO_EN_IRREGULAR_ID = 0) = 0) then
	insert into DIM_CONTRATO_EN_IRREGULAR (CONTRATO_EN_IRREGULAR_ID, CONTRATO_EN_IRREGULAR_DESC) values (0, 'Sin Impago');
end if;
if ((select count(*) from DIM_CONTRATO_EN_IRREGULAR where CONTRATO_EN_IRREGULAR_ID = 1) = 0) then
	insert into DIM_CONTRATO_EN_IRREGULAR (CONTRATO_EN_IRREGULAR_ID, CONTRATO_EN_IRREGULAR_DESC) values (1, 'En Irregular');
end if;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO
-- ----------------------------------------------------------------------------------------------                                                                                          
insert into DIM_CONTRATO
   (CONTRATO_ID,
    CONTRATO_COD_ENTIDAD,
    CONTRATO_COD_OFICINA,
    CONTRATO_COD_CENTRO,
    CONTRATO_COD_CONTRATO,
    TIPO_PRODUCTO_ID,
    PRODUCTO_ID,
    FINALIDAD_CONTRATO_ID,
    FINALIDAD_OFICIAL_ID,
    GARANTIA_CONTABLE_ID,
    GARANTIA_CONTRATO_ID,
    MONEDA_ID,
    ZONA_CONTRATO_ID,
    OFICINA_CONTRATO_ID,
    CATALOGO_DETALLE_6_ID,
    CARTERA_CONTRATO_ID,
	  PROPIETARIO_CONTRATO_ID,
  	CEDENTE_CONTRATO_ID
    )
  select cnt.CNT_ID, 
      coalesce(CNT_COD_ENTIDAD, 'Desconocido'),  
      coalesce(CNT_COD_OFICINA, 'Desconocido'), 
      coalesce(CNT_COD_CENTRO, 'Desconocido'), 
      coalesce(CNT_CONTRATO, 'Desconocido'), 
      coalesce(DD_TPR_ID, -1),
      coalesce(DD_TPE_ID, -1),
      coalesce(DD_FCN_ID, -1),
      coalesce(DD_FNO_ID, -1),
      coalesce(DD_GC2_ID, -1), 
      coalesce(DD_GC1_ID, -1), 
      coalesce(DD_MON_ID, -1), 
      coalesce(ZON_ID, -1),
      coalesce(OFI_ID, -1), 
      coalesce(DD_CT6_ID -1),  
      -1, -- CARTERA_CONTRATO_ID                                         
      -1, -- PROPIETARIO_CONTRATO_ID
      -1 -- CEDENTE_CONTRATO_ID
    from recovery_lindorff_datastage.CNT_CONTRATOS cnt 
	  -- join recovery_lindorff_datastage.EXT_IAC_INFO_ADD_CONTRATO iac on cnt.CNT_ID = iac.CNT_ID
	  where cnt.BORRADO = 0;
      -- and iac.DD_IFC_ID = 43;
      
-- HABILITAR  
update DIM_CONTRATO set SEGMENTO_TITULAR_ID = coalesce((select DD_SCE_ID from recovery_lindorff_datastage.PER_PERSONAS where PER_ID = 
(select MIN(PER_ID) from recovery_lindorff_datastage.CPE_CONTRATOS_PERSONAS where CNT_ID = CONTRATO_ID and DD_TIN_ID = 1)), -1);

update DIM_CONTRATO set NACIONALIDAD_TITULAR_ID = coalesce((select PER_NACIONALIDAD from recovery_lindorff_datastage.PER_PERSONAS where PER_ID = 
(select MIN(PER_ID) from recovery_lindorff_datastage.CPE_CONTRATOS_PERSONAS where CNT_ID = CONTRATO_ID and DD_TIN_ID = 1)), -1);

update DIM_CONTRATO set SEXO_TITULAR_ID = coalesce((select PER_SEXO from recovery_lindorff_datastage.PER_PERSONAS where PER_ID = 
(select MIN(PER_ID) from recovery_lindorff_datastage.CPE_CONTRATOS_PERSONAS where CNT_ID = CONTRATO_ID and DD_TIN_ID = 1)), -1);

update DIM_CONTRATO set TIPO_PERSONA_TITULAR_ID = coalesce((select DD_TPE_ID from recovery_lindorff_datastage.PER_PERSONAS where PER_ID = 
(select MIN(PER_ID) from recovery_lindorff_datastage.CPE_CONTRATOS_PERSONAS where CNT_ID = CONTRATO_ID and DD_TIN_ID = 1)), -1);

-- Update CCC_LITIGIO / NUC_LITIGIO / IBAN_RIESGO
update DIM_CONTRATO dc, recovery_lindorff_datastage.EXT_IAC_INFO_ADD_CONTRATO ext set dc.CCC_LITIGIO = ext.IAC_VALUE where dc.CONTRATO_ID = ext.CNT_ID and ext.dd_ifc_id = 32;
update DIM_CONTRATO set CCC_LITIGIO = 'Desconocido' where CCC_LITIGIO is null;


-- Update CARTERA (por oficina)
update DIM_CONTRATO set CARTERA_CONTRATO_ID = coalesce((select car.CAR_ID	from recovery_lindorff_datastage.CNT_CONTRATOS cnt	
                                                                              inner join recovery_lindorff_datastage.CAR_CARTERA car on car.OFICINA = cnt.OFI_ID
                                                                              where cnt.CNT_ID = CONTRATO_ID), -1);
                                                                              
-- Update CEDENTE 
update DIM_CONTRATO set CEDENTE_CONTRATO_ID = coalesce((select iac.IAC_VALUE from recovery_lindorff_datastage.EXT_IAC_INFO_ADD_CONTRATO iac
                                                                              where iac.DD_IFC_ID = 34 and iac.CNT_ID = CONTRATO_ID), -1);
                                                                              
-- Update PROPIETARIO
update DIM_CONTRATO set PROPIETARIO_CONTRATO_ID = coalesce((select iac.IAC_VALUE	from recovery_lindorff_datastage.EXT_IAC_INFO_ADD_CONTRATO iac
                                                                                  where iac.DD_IFC_ID = 33 and iac.CNT_ID = CONTRATO_ID), -1);

END MY_BLOCK_DIM_CNT
