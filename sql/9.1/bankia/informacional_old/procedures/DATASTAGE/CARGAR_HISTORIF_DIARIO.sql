create or replace PROCEDURE CARGAR_HISTORIF_DIARIO (O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Pedro Sebastián, PFS Group
-- Fecha creación: Junio 2015
-- Responsable ultima modificacion: Diego Pérez, PFS
-- Fecha ultima modificacion: 21/08/2015
-- Motivos del cambio: Usuario/Propietario
-- Cliente: Recovery BI Bankia
--
-- Descripción: Procedimiento almancenado que carga las tablas ext_iab_info_add_bi_h y ext_iab_info_add_bi.
-- ===============================================================================================

-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================

  V_ESQUEMA VARCHAR2(100);
  V_NOMBRE VARCHAR2(50) := 'CARGAR_HISTORIF_DIARIO';
  nCount NUMBER;
  V_SQL VARCHAR2(16000);
  V_MAX_DIA_H DATE;

BEGIN

  --Log_Cargar_Tabla
  execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 0, 0, 'Empieza ' || V_NOMBRE, 3;

  select valor into V_ESQUEMA from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';
  
  -- Borrado índices ext_iab_info_add_bi_h
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''EXT_IAB_INFO_ADD_BI_H_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  

   /* COPIADO DEL DIA ANTERIOR EN LA TABLA DE HISTORICO */

   execute immediate 'INSERT INTO '||V_ESQUEMA||'.ext_iab_info_add_bi_h
               (iab_id, dd_ein_id, iab_id_unidad_gestion, dd_ifb_id, iab_valor, iab_fecha_valor, VERSION, usuariocrear, fechacrear, usuariomodificar, fechamodificar, usuarioborrar, borrado, fecha_cancelacion)
      SELECT iab_id, dd_ein_id, iab_id_unidad_gestion, dd_ifb_id, iab_valor, iab_fecha_valor, VERSION, usuariocrear, fechacrear, usuariomodificar, fechamodificar, usuarioborrar, borrado, fecha_cancelacion
        FROM '||V_ESQUEMA||'.ext_iab_info_add_bi
       WHERE TRUNC (iab_fecha_valor) <= TRUNC (SYSDATE - 1)';

   COMMIT;

  -- Crear indices ext_iab_info_add_bi_h
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''EXT_IAB_INFO_ADD_BI_H_IX'', ''EXT_IAB_INFO_ADD_BI_H (IAB_FECHA_VALOR, IAB_ID_UNIDAD_GESTION)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  

   /* BORRADO DEL DIA ACTUAL DE LA TABLA DIARIA */

   execute immediate 'DELETE FROM '||V_ESQUEMA||'.ext_iab_info_add_bi
         WHERE TRUNC (iab_fecha_valor) = TRUNC (SYSDATE)';

   COMMIT;

  -- Borrado índices ext_iab_info_add_bi
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''EXT_IAB_INFO_ADD_BI_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  

   /* INSERCION DE LOS VALORES DE LAS DIFERENTES VARIABLES EN LAS TABLAS DIARIAS */

   /* ESTADO DEl ASUNTO: DD_EAS_ID */

   execute immediate 'INSERT INTO '||V_ESQUEMA||'.ext_iab_info_add_bi (iab_id, dd_ein_id, iab_id_unidad_gestion, dd_ifb_id,
                iab_valor, iab_fecha_valor, usuariocrear, fechacrear, borrado, VERSION)
   SELECT '||V_ESQUEMA||'.s_ext_iab_info_add_bi.NEXTVAL iab_id, 3 dd_ein_id, asu_id iab_id_unidad_gestion, 1 dd_ifb_id, dd_eas_id iab_valor,
             SYSDATE AS iab_fecha_valor, ''MANTENIMIE'' usuariocrear, SYSDATE fechacrear, 0 borrado, 0 VERSION
   FROM (SELECT DISTINCT ASU.asu_id, ASU.dd_eas_id FROM '||V_ESQUEMA||'.ASU_ASUNTOS ASU)';

   COMMIT;

   /* ESTADO DEl PROCEDIMIENTO: DD_EPR_ID */

   execute immediate 'INSERT INTO '||V_ESQUEMA||'.ext_iab_info_add_bi (iab_id, dd_ein_id, iab_id_unidad_gestion, dd_ifb_id,
                iab_valor, iab_fecha_valor, usuariocrear, fechacrear, borrado, VERSION)
   SELECT '||V_ESQUEMA||'.s_ext_iab_info_add_bi.NEXTVAL iab_id, 5 dd_ein_id, prc_id iab_id_unidad_gestion, 2 dd_ifb_id, dd_epr_id iab_valor,
             SYSDATE AS iab_fecha_valor, ''MANTENIMIE'' usuariocrear, SYSDATE fechacrear, 0 borrado, 0 VERSION
   FROM (SELECT PRC.prc_id, PRC.dd_epr_id FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC)';

   COMMIT;


   /* NUMERO DE AUTO: PRC_COD_PROC_EN_JUZGADO */

   execute immediate 'INSERT INTO ext_iab_info_add_bi (iab_id, dd_ein_id, iab_id_unidad_gestion, dd_ifb_id,
                iab_valor, iab_fecha_valor, usuariocrear, fechacrear, borrado, VERSION)
   SELECT s_ext_iab_info_add_bi.NEXTVAL iab_id, 5 dd_ein_id, prc_id iab_id_unidad_gestion, 3 dd_ifb_id, PRC_COD_PROC_EN_JUZGADO iab_valor,
             SYSDATE AS iab_fecha_valor, ''MANTENIMIE'' usuariocrear, SYSDATE fechacrear, 0 borrado, 0 VERSION
   FROM (SELECT PRC.prc_id, PRC.PRC_COD_PROC_EN_JUZGADO FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC)';

   COMMIT;


      /* SALDO RECUPERACION: PRC_SALDO_RECUPERACION */

   execute immediate 'INSERT INTO ext_iab_info_add_bi (iab_id, dd_ein_id, iab_id_unidad_gestion, dd_ifb_id,
                iab_valor, iab_fecha_valor, usuariocrear, fechacrear, borrado, VERSION)
   SELECT s_ext_iab_info_add_bi.NEXTVAL iab_id, 5 dd_ein_id, prc_id iab_id_unidad_gestion, 4 dd_ifb_id, PRC_SALDO_RECUPERACION iab_valor,
             SYSDATE AS iab_fecha_valor, ''MANTENIMIE'' usuariocrear, SYSDATE fechacrear, 0 borrado, 0 VERSION
   FROM (SELECT PRC.prc_id, PRC.PRC_SALDO_RECUPERACION FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC)';

   COMMIT;


   /* RESTANTE TOTAL: EXT_DD_IFC_INFO_CONTRATO con dd_ifc_id =6 (LIN - Restante Total) */

   execute immediate 'INSERT INTO ext_iab_info_add_bi (iab_id, dd_ein_id, iab_id_unidad_gestion, dd_ifb_id,
                iab_valor, iab_fecha_valor, usuariocrear, fechacrear, borrado, VERSION)
   SELECT s_ext_iab_info_add_bi.NEXTVAL iab_id, 6 dd_ein_id, CNT_ID iab_id_unidad_gestion, 5 dd_ifb_id, IAC_VALUE iab_valor,
             SYSDATE AS iab_fecha_valor, ''MANTENIMIE'' usuariocrear, SYSDATE fechacrear, 0 borrado, 0 VERSION
   FROM (SELECT IAC.CNT_ID, IAC.IAC_VALUE FROM '||V_ESQUEMA||'.EXT_IAC_INFO_ADD_CONTRATO IAC WHERE IAC.DD_IFC_ID = 6)';

   COMMIT;

   /* FECHA_CANCELACION_ESTADO DEL ASUNTO */

   --si ya está informada la propagamos
   execute immediate 'merge into '||V_ESQUEMA||'.ext_iab_info_add_bi t1 using (select distinct IAB_ID_UNIDAD_GESTION, FECHA_CANCELACION from '||V_ESQUEMA||'.EXT_IAB_INFO_ADD_BI where DD_IFB_ID = 1 and TRUNC(IAB_FECHA_VALOR) <= TRUNC(SYSDATE - 1) and FECHA_CANCELACION is not null) t2 on (t1.IAB_ID_UNIDAD_GESTION = t2.IAB_ID_UNIDAD_GESTION) when matched then update set t1.FECHA_CANCELACION = t2.FECHA_CANCELACION where t1.FECHA_CANCELACION is null AND t1.DD_IFB_ID = 1';
   COMMIT;
   
   --si ya está informada la propagamos, control de varias ejecuciones en el día, se consulta sobre la tabla histórica
   execute immediate 'select COUNT(1) from '||V_ESQUEMA||'.EXT_IAB_INFO_ADD_BI where DD_IFB_ID = 1 and TRUNC(IAB_FECHA_VALOR) <= TRUNC(SYSDATE - 1)' INTO nCount;
   if nCount = 0 then
    execute immediate 'select max(TRUNC(IAB_FECHA_VALOR)) from '||V_ESQUEMA||'.EXT_IAB_INFO_ADD_BI_H' INTO V_MAX_DIA_H;
    execute immediate 'merge into '||V_ESQUEMA||'.ext_iab_info_add_bi t1 using (select distinct IAB_ID_UNIDAD_GESTION, FECHA_CANCELACION from '||V_ESQUEMA||'.EXT_IAB_INFO_ADD_BI_H where DD_IFB_ID = 1 and TRUNC(IAB_FECHA_VALOR) = ''' ||V_MAX_DIA_H|| ''' and FECHA_CANCELACION is not null) t2 on (t1.IAB_ID_UNIDAD_GESTION = t2.IAB_ID_UNIDAD_GESTION) when matched then update set t1.FECHA_CANCELACION = t2.FECHA_CANCELACION where t1.FECHA_CANCELACION is null AND t1.DD_IFB_ID = 1';
    COMMIT;
   end if;

   --cancelaciones nuevas
   execute immediate 'merge into '||V_ESQUEMA||'.ext_iab_info_add_bi t1 using (select IAB_ID_UNIDAD_GESTION from '||V_ESQUEMA||'.EXT_IAB_INFO_ADD_BI where DD_IFB_ID = 1 and TRUNC(IAB_FECHA_VALOR) <= TRUNC(SYSDATE - 1) and trim(iab_valor) not in (''5'',''6'')) t2 on (t1.IAB_ID_UNIDAD_GESTION = t2.IAB_ID_UNIDAD_GESTION) when matched then update set t1.FECHA_CANCELACION = TRUNC(SYSDATE) where t1.FECHA_CANCELACION is null and trim(t1.IAB_VALOR) IN (''5'',''6'') AND t1.DD_IFB_ID = 1';

   COMMIT;

   /* BORRADO DEL DIA ANTERIOR DE LA TABLA DIARIA */

   execute immediate 'DELETE FROM '||V_ESQUEMA||'.ext_iab_info_add_bi
         WHERE TRUNC (iab_fecha_valor) <= TRUNC (SYSDATE - 1)';
   COMMIT;

  -- Crear indices ext_iab_info_add_bi
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''EXT_IAB_INFO_ADD_BI_IX'', ''EXT_IAB_INFO_ADD_BI (IAB_FECHA_VALOR, IAB_ID_UNIDAD_GESTION)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  

  --Log_Cargar_Tabla
  execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 0, 0, 'Termina ' || V_NOMBRE, 3;

/*EXCEPTION
  when OBJECTEXISTS then
    O_ERROR_STATUS := 'La tabla ya existe';
    --ROLLBACK;
  when INSERT_NULL then
    O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
    --ROLLBACK;
  when PARAMETERS_NUMBER then
    O_ERROR_STATUS := 'Número de parámetros incorrecto';
    --ROLLBACK;
  when OTHERS then
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;*/
    --ROLLBACK;
end;