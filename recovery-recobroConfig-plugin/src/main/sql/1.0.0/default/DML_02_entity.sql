
-- INSERTAR DATOS EN EL DICCIONARIO DE VARIABLES DE RANKING

insert into RCF_DD_VAR_VARIABLES_RANKING (RCF_DD_VAR_ID, RCF_DD_VAR_CODIGO, RCF_DD_VAR_DESCRIPCION, RCF_DD_VAR_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_RCF_DD_AER_AMBITO_EXP_REC.nextval, 'EFS', 'Eficacia sobre stock', 'Eficacia sobre stock',
0, 'DD', sysdate, 0);

insert into RCF_DD_VAR_VARIABLES_RANKING (RCF_DD_VAR_ID, RCF_DD_VAR_CODIGO, RCF_DD_VAR_DESCRIPCION, RCF_DD_VAR_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_RCF_DD_AER_AMBITO_EXP_REC.nextval, 'ESE', 'Eficacia sobre entradas', 'Eficacia sobre entradas',
0, 'DD', sysdate, 0);

insert into RCF_DD_VAR_VARIABLES_RANKING (RCF_DD_VAR_ID, RCF_DD_VAR_CODIGO, RCF_DD_VAR_DESCRIPCION, RCF_DD_VAR_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_RCF_DD_AER_AMBITO_EXP_REC.nextval, 'COT', 'Contactabilidad', 'Contactabilidad',
0, 'DD', sysdate, 0);

insert into RCF_DD_VAR_VARIABLES_RANKING (RCF_DD_VAR_ID, RCF_DD_VAR_CODIGO, RCF_DD_VAR_DESCRIPCION, RCF_DD_VAR_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_RCF_DD_AER_AMBITO_EXP_REC.nextval, 'CAG', 'Calidad de la gestión (AP/CU)', 'Calidad de la gestión (AP/CU)',
0, 'DD', sysdate, 0);

insert into RCF_DD_VAR_VARIABLES_RANKING (RCF_DD_VAR_ID, RCF_DD_VAR_CODIGO, RCF_DD_VAR_DESCRIPCION, RCF_DD_VAR_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_RCF_DD_AER_AMBITO_EXP_REC.nextval, 'CAA', 'Calidad de los acuerdos (AP cumplidos / AP)', 'Calidad de los acuerdos (AP cumplidos / AP)',
0, 'DD', sysdate, 0);

insert into RCF_DD_VAR_VARIABLES_RANKING (RCF_DD_VAR_ID, RCF_DD_VAR_CODIGO, RCF_DD_VAR_DESCRIPCION, RCF_DD_VAR_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_RCF_DD_AER_AMBITO_EXP_REC.nextval, 'COB', 'Cobertura (Personas con intento contacto / Número personas totales)', 
'Cobertura (Personas con intento contacto / Número personas totales)', 0, 'DD', sysdate, 0);

-- INSERTAR DATOS EN EL DICCIONARIO DE AMBITO DE EXPEDIENTE

insert into RCF_DD_AER_AMBITO_EXP_REC (DD_AER_ID, DD_AER_CODIGO, DD_AER_DESCRIPCION, DD_AER_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_RCF_DD_AER_AMBITO_EXP_REC.nextval, 'CP', 'Solo contrato de pase', 'Solo el contrato de pase',
0, 'DD', sysdate, 0);

insert into RCF_DD_AER_AMBITO_EXP_REC (DD_AER_ID, DD_AER_CODIGO, DD_AER_DESCRIPCION, DD_AER_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_RCF_DD_AER_AMBITO_EXP_REC.nextval, 'CG', 'Solo el contrato de pase y contratos del grupo de clientes', 'Solo el contrato de pase y contratos del grupo de clientes',
0, 'DD', sysdate, 0);

insert into RCF_DD_AER_AMBITO_EXP_REC (DD_AER_ID, DD_AER_CODIGO, DD_AER_DESCRIPCION, DD_AER_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_RCF_DD_AER_AMBITO_EXP_REC.nextval, 'CPGRA', 'Contrato de pase, contratos del grupo de clientes y contratos de primera generación', 'Contrato de pase, contratos del grupo de clientes y contratos de primera generación',
0, 'DD', sysdate, 0);

insert into RCF_DD_AER_AMBITO_EXP_REC (DD_AER_ID, DD_AER_CODIGO, DD_AER_DESCRIPCION, DD_AER_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_RCF_DD_AER_AMBITO_EXP_REC.nextval, 'CSGRA', 'Contrato de pase, contratos del grupo de clientes y contratos de primera y segunda generación', 'Contrato de pase, contratos del grupo de clientes y contratos de primera y segunda generación',
0, 'DD', sysdate, 0);

-- INSERTAR DATOS EN EL DICCIONARIO DE TIPOS DE CARTERA EN EL ESQUEMA

insert into RCF_DD_TCE_TIPO_CARTERA_ESQ (DD_TCE_ID, DD_TCE_CODIGO, DD_TCE_DESCRIPCION, DD_TCE_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_RCF_DD_TCE_TIPO_CARTERA_ESQ.nextval, 'GES', 'Gestión', 'La cartera clasifica personas para enviar a recobro',
0, 'DD', sysdate, 0);

insert into RCF_DD_TCE_TIPO_CARTERA_ESQ (DD_TCE_ID, DD_TCE_CODIGO, DD_TCE_DESCRIPCION, DD_TCE_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_RCF_DD_TCE_TIPO_CARTERA_ESQ.nextval, 'FIL', 'Filtro', 'El filtro clasifica personas para no enviar a recobro',
0, 'DD', sysdate, 0);

-- INSERTAR DATOS EN EL DICCIONARIO DE TIPOS DE GESTION DE LA CARTERA EN EL ESQUEMA

insert into RCF_DD_TGC_TIPO_GESTION_CART (DD_TGC_ID, DD_TGC_CODIGO, DD_TGC_DESCRIPCION, DD_TGC_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_RCF_DD_TGC_TIPO_GESTION_CART.nextval, 'GI', 'Gestión irregular', 'Solo se envía a las agencias los contratos irregulares',
0, 'DD', sysdate, 0);

insert into RCF_DD_TGC_TIPO_GESTION_CART (DD_TGC_ID, DD_TGC_CODIGO, DD_TGC_DESCRIPCION, DD_TGC_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_RCF_DD_TGC_TIPO_GESTION_CART.nextval, 'GC', 'Gestión completa', 'A las agencias se envía tanto los contratos irregulares como no irregulares',
0, 'DD', sysdate, 0);

-- INSERTAR EN EL DICCIONARIO DE MODELOS DE TRANSICIÓN

insert into RCF_DD_MTR_MODELO_TRANSICION (RCF_DD_MTR_ID, RCF_DD_MTR_CODIGO, RCF_DD_MTR_DESCRIPCION, RCF_DD_MTR_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_RCF_DD_MTR_MODELO_TRANSICION.nextval, 'RU', 'Con ruptura', 'llegado el plazo de vencimiento los expedientes se rompen',
0, 'DD', sysdate, 0);

insert into RCF_DD_MTR_MODELO_TRANSICION (RCF_DD_MTR_ID, RCF_DD_MTR_CODIGO, RCF_DD_MTR_DESCRIPCION, RCF_DD_MTR_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (S_RCF_DD_MTR_MODELO_TRANSICION.nextval, 'RA', 'Rearquetipado', 'llegado el plazo de vencimiento los expedientes se rearquetipan',
0, 'DD', sysdate, 0);

-- INSERTAR DATOS EN EL DICCIONARIO DE ESTADOS DE ESQUEMA

insert into RCF_DD_EES_ESTADO_ESQUEMA (RCF_DD_EES_ID, RCF_DD_EES_CODIGO, RCF_DD_EES_DESCRIPCION,
	RCF_DD_EES_DESCRIPCION_LARGA ,USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_DD_EES_ESTADO_ESQUEMA.nextval, 'DEF', 'Definición', 'Definición', 'DIANA', SYSDATE, 0 );

insert into RCF_DD_EES_ESTADO_ESQUEMA (RCF_DD_EES_ID, RCF_DD_EES_CODIGO, RCF_DD_EES_DESCRIPCION,
	RCF_DD_EES_DESCRIPCION_LARGA ,USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_DD_EES_ESTADO_ESQUEMA.nextval, 'PTS', 'Pte. Simular', 'Pte. Simular', 'DIANA', SYSDATE, 0 );

insert into RCF_DD_EES_ESTADO_ESQUEMA (RCF_DD_EES_ID, RCF_DD_EES_CODIGO, RCF_DD_EES_DESCRIPCION,
	RCF_DD_EES_DESCRIPCION_LARGA ,USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_DD_EES_ESTADO_ESQUEMA.nextval, 'SML', 'Simulado', 'Simulado', 'DIANA', SYSDATE, 0 );

insert into RCF_DD_EES_ESTADO_ESQUEMA (RCF_DD_EES_ID, RCF_DD_EES_CODIGO, RCF_DD_EES_DESCRIPCION,
	RCF_DD_EES_DESCRIPCION_LARGA ,USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_DD_EES_ESTADO_ESQUEMA.nextval, 'LBR', 'Liberado', 'Liberado', 'DIANA', SYSDATE, 0 );

insert into RCF_DD_EES_ESTADO_ESQUEMA (RCF_DD_EES_ID, RCF_DD_EES_CODIGO, RCF_DD_EES_DESCRIPCION,
	RCF_DD_EES_DESCRIPCION_LARGA ,USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_DD_EES_ESTADO_ESQUEMA.nextval, 'EXG', 'En extinción', 'En extinción', 'DIANA', SYSDATE, 0 );

insert into RCF_DD_EES_ESTADO_ESQUEMA (RCF_DD_EES_ID, RCF_DD_EES_CODIGO, RCF_DD_EES_DESCRIPCION,
	RCF_DD_EES_DESCRIPCION_LARGA ,USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_DD_EES_ESTADO_ESQUEMA.nextval, 'DSA', 'Desactivado', 'Desactivado', 'DIANA', SYSDATE, 0 );

insert into RCF_DD_EES_ESTADO_ESQUEMA (RCF_DD_EES_ID, RCF_DD_EES_CODIGO, RCF_DD_EES_DESCRIPCION,
	RCF_DD_EES_DESCRIPCION_LARGA ,USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_DD_EES_ESTADO_ESQUEMA.nextval, 'PLB', 'Pte. Liberar', 'Pte. Liberar', 'DIANA', SYSDATE, 0 );

-- INSERTAR TIPO DE PALANCA Y SUBTIPO

insert into RCF_TPP_TIPO_PALANCA (RCF_TPP_ID, RCF_TPP_CODIGO, RCF_TPP_DESCRIPCION, RCF_TPP_DESCRIPCION_LARGA,
	VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_TPP_TIPO_PALANCA.nextval, 'TP1', 'Tipo palanca 1', 'Tipo palanca 1', 1, 'SAG', SYSDATE, 0 );

insert into RCF_STP_SUBTIPO_PALANCA (RCF_STP_ID, RCF_TPP_ID, RCF_STP_CODIGO, RCF_STP_DESCRIPCION, RCF_STP_DESCRIPCION_LARGA,
	VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_STP_SUBTIPO_PALANCA.nextval, (select max(RCF_TPP_ID) from RCF_TPP_TIPO_PALANCA), 'STP1', 'Sub tipo palanca 1', 'Sub tipo palanca 1', 1, 'SAG', SYSDATE, 0 );

insert into RCF_TPP_TIPO_PALANCA (RCF_TPP_ID, RCF_TPP_CODIGO, RCF_TPP_DESCRIPCION, RCF_TPP_DESCRIPCION_LARGA,
	VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_TPP_TIPO_PALANCA.nextval, 'TP2', 'Tipo palanca 2', 'Tipo palanca 2', 1, 'SAG', SYSDATE, 0 );

insert into RCF_STP_SUBTIPO_PALANCA (RCF_STP_ID, RCF_TPP_ID, RCF_STP_CODIGO, RCF_STP_DESCRIPCION, RCF_STP_DESCRIPCION_LARGA,
	VERSION, USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_STP_SUBTIPO_PALANCA.nextval, (select max(RCF_TPP_ID) from RCF_TPP_TIPO_PALANCA), 'STP2', 'Sub tipo palanca 2', 'Sub tipo palanca 2', 1, 'SAG', SYSDATE, 0 );


-- INSERTAR DATOS EN EL DICCIONARIO DE METAS VOLANTES

insert into RCF_DD_MET_META_VOLANTE (RCF_DD_MET_ID, RCF_DD_MET_ORDEN, RCF_DD_MET_CODIGO, RCF_DD_MET_DESCRIPCION,
	RCF_DD_MET_DES_LARGA,USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_DD_MET_META_VOLANTE.nextval, 1, 'SC', 'Sin contacto', 'Sin contacto', 'DIANA', SYSDATE, 0 );

insert into RCF_DD_MET_META_VOLANTE (RCF_DD_MET_ID, RCF_DD_MET_ORDEN, RCF_DD_MET_CODIGO, RCF_DD_MET_DESCRIPCION,
	RCF_DD_MET_DES_LARGA,USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_DD_MET_META_VOLANTE.nextval, 2, 'CNU', 'Contacto no útil', 'Contacto no útil', 'DIANA', SYSDATE, 0 );

insert into RCF_DD_MET_META_VOLANTE (RCF_DD_MET_ID, RCF_DD_MET_ORDEN, RCF_DD_MET_CODIGO, RCF_DD_MET_DESCRIPCION,
	RCF_DD_MET_DES_LARGA,USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_DD_MET_META_VOLANTE.nextval, 3, 'CU', 'Contacto útil positivo', 'Contacto útil positivo', 'DIANA', SYSDATE, 0 );

insert into RCF_DD_MET_META_VOLANTE (RCF_DD_MET_ID, RCF_DD_MET_ORDEN, RCF_DD_MET_CODIGO, RCF_DD_MET_DESCRIPCION,
	RCF_DD_MET_DES_LARGA,USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_DD_MET_META_VOLANTE.nextval, 4, 'PPP', 'Promesa pago parcial', 'Promesa pago parcial', 'DIANA', SYSDATE, 0 );

insert into RCF_DD_MET_META_VOLANTE (RCF_DD_MET_ID, RCF_DD_MET_ORDEN, RCF_DD_MET_CODIGO, RCF_DD_MET_DESCRIPCION,
	RCF_DD_MET_DES_LARGA,USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_DD_MET_META_VOLANTE.nextval, 5, 'PPT', 'Promesa pago total', 'Promesa pago total', 'DIANA', SYSDATE, 0 );

insert into RCF_DD_MET_META_VOLANTE (RCF_DD_MET_ID, RCF_DD_MET_ORDEN, RCF_DD_MET_CODIGO, RCF_DD_MET_DESCRIPCION,
	RCF_DD_MET_DES_LARGA,USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_DD_MET_META_VOLANTE.nextval, 6, 'PGE', 'Palanca gestionada', 'Palanca gestionada', 'DIANA', SYSDATE, 0 );

insert into RCF_DD_MET_META_VOLANTE (RCF_DD_MET_ID, RCF_DD_MET_ORDEN, RCF_DD_MET_CODIGO, RCF_DD_MET_DESCRIPCION,
	RCF_DD_MET_DES_LARGA,USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_DD_MET_META_VOLANTE.nextval, 7, 'CBP', 'Cobro parcial', 'Cobro parcial', 'DIANA', SYSDATE, 0 );

insert into RCF_DD_MET_META_VOLANTE (RCF_DD_MET_ID, RCF_DD_MET_ORDEN, RCF_DD_MET_CODIGO, RCF_DD_MET_DESCRIPCION,
	RCF_DD_MET_DES_LARGA,USUARIOCREAR, FECHACREAR,BORRADO)
values (S_RCF_DD_MET_META_VOLANTE.nextval, 8, 'CBT', 'Cobro total', 'Cobro total', 'DIANA', SYSDATE, 0 );

-- tipos de reparto de subcarteras

Insert into RCF_DD_TPR_TIPO_REPARTO_SUBC
   (RCF_DD_TPR_ID, RCF_DD_TPR_CODIGO, RCF_DD_TPR_DESCRIPCION, RCF_DD_TPR_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_RCF_DD_TPR_TIPO_REPARTO_SUBC.nextval, 'DIN', 'Reparto dinamico', 'Reparto dinámico', 0, 
    'DIANA', sysdate, 0);
    
Insert into RCF_DD_TPR_TIPO_REPARTO_SUBC
   (RCF_DD_TPR_ID, RCF_DD_TPR_CODIGO, RCF_DD_TPR_DESCRIPCION, RCF_DD_TPR_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_RCF_DD_TPR_TIPO_REPARTO_SUBC.nextval, 'EST', 'Reparto estático', 'Reparto estático', 0, 
    'DIANA', sysdate, 0);

commit;

-- datos de diccionarios de modelo de facturación

-- tipos de correctores

Insert into RCF_DD_TCO_TIPO_CORRECTOR
   (RCF_DD_TCO_ID, RCF_DD_TCO_CODIGO, RCF_DD_TCO_DESCRIPCION, RCF_DD_TCO_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_TCO_TIPO_CORRECTOR.nextval, 'MEO', 'Mejora objetivo', 'Mejora objetivo', 0, 
    'SAG', sysdate, 1);
    
Insert into RCF_DD_TCO_TIPO_CORRECTOR
   (RCF_DD_TCO_ID, RCF_DD_TCO_CODIGO, RCF_DD_TCO_DESCRIPCION, RCF_DD_TCO_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_TCO_TIPO_CORRECTOR.nextval, 'RAN', 'Ranking', 'Ranking', 0, 
    'SAG', sysdate, 0);


-- Tipo de cobro

--Insert into RCF_DD_TCB_TIPO_COBRO
--   (RCF_DD_TCB_ID, RCF_DD_TCB_CODIGO, RCF_DD_TCB_DESCRIPCION, RCF_DD_TCB_DESCRIPCION_LARGA, RCF_DD_TCB_FACTURABLE, VERSION, 
--    USUARIOCREAR, FECHACREAR, BORRADO)
-- Values
--   (S_RCF_DD_TCB_TIPO_COBRO.nextval, 'TC1', 'Tipo de cobro 1', 'Tipo de cobro 1', 1, 0, 
--    'SAG', sysdate, 0);
    
-- Diccionario de conceptos de cobro

Insert into RCF_DD_COC_CONCEPTO_COBRO
   (RCF_DD_COC_ID, RCF_DD_COC_CODIGO, RCF_DD_COC_DESCRIPCION, RCF_DD_COC_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_COC_CONCEPTO_COBRO.nextval, 'ICO', '% sobre importe irregular cobrado', '% sobre importe irregular cobrado', 0, 
    'SAG', sysdate, 0);

Insert into RCF_DD_COC_CONCEPTO_COBRO
   (RCF_DD_COC_ID, RCF_DD_COC_CODIGO, RCF_DD_COC_DESCRIPCION, RCF_DD_COC_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_COC_CONCEPTO_COBRO.nextval, 'NVC', '% sobre importe no vencido cobrado', '% sobre importe no vencido cobrado', 0, 
    'SAG', sysdate, 0);
    
    Insert into RCF_DD_COC_CONCEPTO_COBRO
   (RCF_DD_COC_ID, RCF_DD_COC_CODIGO, RCF_DD_COC_DESCRIPCION, RCF_DD_COC_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_COC_CONCEPTO_COBRO.nextval, 'IOC', '% sobre importe intereses ordinarios cobrados', '% sobre importe intereses ordinarios cobrados', 0, 
    'SAG', sysdate, 0);
    
    Insert into RCF_DD_COC_CONCEPTO_COBRO
   (RCF_DD_COC_ID, RCF_DD_COC_CODIGO, RCF_DD_COC_DESCRIPCION, RCF_DD_COC_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_COC_CONCEPTO_COBRO.nextval, 'IMC', '% sobre importe intereses moratorios cobrados', '% sobre importe intereses moratorios cobrados', 0, 
    'SAG', sysdate, 0);
    
    Insert into RCF_DD_COC_CONCEPTO_COBRO
   (RCF_DD_COC_ID, RCF_DD_COC_CODIGO, RCF_DD_COC_DESCRIPCION, RCF_DD_COC_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_COC_CONCEPTO_COBRO.nextval, 'ICC', '% sobre importe comisiones cobradas', '% sobre importe comisiones cobradas', 0, 
    'SAG', sysdate, 0);
    
    Insert into RCF_DD_COC_CONCEPTO_COBRO
   (RCF_DD_COC_ID, RCF_DD_COC_CODIGO, RCF_DD_COC_DESCRIPCION, RCF_DD_COC_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_COC_CONCEPTO_COBRO.nextval, 'IGC', '% sobre importe gastos cobrados', '% sobre importe gastos cobrados', 0, 
    'SAG', sysdate, 0);
    
    Insert into RCF_DD_COC_CONCEPTO_COBRO
   (RCF_DD_COC_ID, RCF_DD_COC_CODIGO, RCF_DD_COC_DESCRIPCION, RCF_DD_COC_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_COC_CONCEPTO_COBRO.nextval, 'RPR', '% sobre regularizado por refinanciación', '% sobre regularizado por refinanciación', 0, 
    'SAG', sysdate, 0);
        
commit;


-- estados de proceso de facturacion

Insert into RCF_DD_EPF_ESTADO_PROC_FAC
   (RCF_DD_EPF_ID, RCF_DD_EPF_CODIGO, RCF_DD_EPF_DESCRIPCION, RCF_DD_EPF_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_EPF_ESTADO_PROC_FAC.nextval, 'PTE', 'Pendiente', 'Pendiente', 0, 
    'DIA', sysdate, 0);
    
Insert into RCF_DD_EPF_ESTADO_PROC_FAC
   (RCF_DD_EPF_ID, RCF_DD_EPF_CODIGO, RCF_DD_EPF_DESCRIPCION, RCF_DD_EPF_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_EPF_ESTADO_PROC_FAC.nextval, 'PRC', 'Procesado', 'Procesado', 0, 
    'DIA', sysdate, 0);
    
Insert into RCF_DD_EPF_ESTADO_PROC_FAC
   (RCF_DD_EPF_ID, RCF_DD_EPF_CODIGO, RCF_DD_EPF_DESCRIPCION, RCF_DD_EPF_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_EPF_ESTADO_PROC_FAC.nextval, 'LBR', 'Liberado', 'Liberado', 0, 
    'DIA', sysdate, 0);
    
Insert into RCF_DD_EPF_ESTADO_PROC_FAC
   (RCF_DD_EPF_ID, RCF_DD_EPF_CODIGO, RCF_DD_EPF_DESCRIPCION, RCF_DD_EPF_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_EPF_ESTADO_PROC_FAC.nextval, 'CNL', 'Cancelado', 'Cancelado', 0, 
    'DIA', sysdate, 0);

Insert into RCF_DD_EPF_ESTADO_PROC_FAC
   (RCF_DD_EPF_ID, RCF_DD_EPF_CODIGO, RCF_DD_EPF_DESCRIPCION, RCF_DD_EPF_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_EPF_ESTADO_PROC_FAC.nextval, 'PER', 'Procesado con errores', 'Procesado con errores', 0, 
    'DIA', sysdate, 0);

commit;

-- estados de componentes de un esquema

Insert into RCF_DD_ECM_ESTADO_COMPONENT
   (RCF_DD_ECM_ID, RCF_DD_ECM_CODIGO, RCF_DD_ECM_DESCRIPCION, RCF_DD_ECM_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_ECM_ESTADO_COMPONENT.nextval, 'DEF', 'Definición', 'Definición', 0, 
    'DIA', sysdate, 0);
    
Insert into RCF_DD_ECM_ESTADO_COMPONENT
   (RCF_DD_ECM_ID, RCF_DD_ECM_CODIGO, RCF_DD_ECM_DESCRIPCION, RCF_DD_ECM_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_ECM_ESTADO_COMPONENT.nextval, 'BLQ', 'Bloqueado', 'Bloqueado', 0, 
    'DIA', sysdate, 0); 
    
Insert into RCF_DD_ECM_ESTADO_COMPONENT
   (RCF_DD_ECM_ID, RCF_DD_ECM_CODIGO, RCF_DD_ECM_DESCRIPCION, RCF_DD_ECM_DESCRIPCION_LARGA, VERSION, 
    USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_RCF_DD_ECM_ESTADO_COMPONENT.nextval, 'DSP', 'Disponible', 'Disponible', 0, 
    'DIA', sysdate, 0);     

    
-- estados resultado de la simulacion
    
INSERT INTO RCF_DD_ESI_ESTADO_SIMULACION 
	(RCF_DD_ESI_ID, RCF_DD_ESI_CODIGO, RCF_DD_ESI_DESCRIPCION, RCF_DD_ESI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
VALUES (S_RCF_DD_ESI_ESTADO_SIMULACION.nextval, 'PRO', 'Procesado', 'Procesado', '0', 'CPEREZ', sysdate, '0');

INSERT INTO RCF_DD_ESI_ESTADO_SIMULACION 
	(RCF_DD_ESI_ID, RCF_DD_ESI_CODIGO, RCF_DD_ESI_DESCRIPCION, RCF_DD_ESI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
VALUES (S_RCF_DD_ESI_ESTADO_SIMULACION.nextval, 'ERR', 'Procesado con errores', 'Procesado con Errores', '0', 'CPEREZ', sysdate, '0');
    
INSERT INTO RCF_DD_ESI_ESTADO_SIMULACION 
	(RCF_DD_ESI_ID, RCF_DD_ESI_CODIGO, RCF_DD_ESI_DESCRIPCION, RCF_DD_ESI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
VALUES (S_RCF_DD_ESI_ESTADO_SIMULACION.nextval, 'PEN', 'Pendiente simular', 'Pendiente simular', '0', 'CPEREZ', sysdate, '0');
    
commit;    
