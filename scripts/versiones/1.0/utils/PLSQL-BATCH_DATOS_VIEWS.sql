set verify off;

define MASTER_SCHEMA = &Introduce_el_master_schema;

declare 
  a_tables dbms_sql.varchar2_table;
  a_ddls dbms_sql.clob_table;
  nCount NUMBER;
  v_sql LONG;
  contador NUMBER;
  currentTable VARCHAR2(100 CHAR);
  type t_requerida is record 
  (
    name varchar2(50 char)
    ,message varchar2(100 char)
  );
  type t_dependencias is table of t_requerida index by binary_integer;
  t_dep t_dependencias;
  ERROR_TABLE_NOT_FOUND EXCEPTION;
begin
  DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('ENTRADA DE DATOS BATCH AGENCIAS (Producción)');
  DBMS_OUTPUT.PUT_LINE('   Este script sustituye las tablas existentes por vistas que recojan');
  DBMS_OUTPUT.PUT_LINE('los datos de las tablas de Recovery.');
  DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------');
  
  /*
   * Tablas que deben existir   
   */
  t_dep(1).name := 'EXC_EXCEPTUACION';
  t_dep(1).message := 'No se ha podido acceder al modelo de datos para la excepción de personas y contratos.';
  
  
  t_dep(t_dep.LAST +1).name := 'EPE_EXCEPTUACION_PERSONA';
  t_dep(t_dep.LAST).message := 'No se ha podido acceder al modelo de datos para la excepción de personas y contratos.';
  
  t_dep(t_dep.LAST + 1).name := 'ECO_EXCEPTUACION_CONTRATO';
  t_dep(t_dep.LAST).message := 'No se ha podido acceder al modelo de datos para la excepción de personas y contratos.';
  
  t_dep(t_dep.LAST + 1).name := 'DD_MOE_MOTIVO_EXCEPTUACION';
  t_dep(t_dep.LAST).message := 'No se ha podido acceder al modelo de datos para la excepción de personas y contratos.';
  
  t_dep(t_dep.LAST + 1).name := 'EXP_EXPEDIENTES_REC';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de expedientes de recobro.';
  
  t_dep(t_dep.LAST + 1).name := 'CRE_CICLO_RECOBRO_EXP';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de expedientes de recobro.';
  
  t_dep(t_dep.LAST + 1).name := 'RCF_ESC_ESQUEMA_CARTERAS';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de configuración de esquemas.';
  
  t_dep(t_dep.LAST + 1).name := 'RCF_DD_MTR_MODELO_TRANSICION';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de configuración de esquemas.';
  
  t_dep(t_dep.LAST + 1).name := 'RCF_DD_EES_ESTADO_ESQUEMA';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de configuración de esquemas.';
  
  t_dep(t_dep.LAST + 1).name := 'RCF_DD_TGC_TIPO_GESTION_CART';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de configuración de esquemas.';
  
  t_dep(t_dep.LAST + 1).name := 'RCF_DD_TCE_TIPO_CARTERA_ESQ';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de configuración de esquemas.';
  
  t_dep(t_dep.LAST + 1).name := 'RCF_DD_AER_AMBITO_EXP_REC';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de configuración de esquemas.';
  
  t_dep(t_dep.LAST + 1).name := 'RCF_CAR_CARTERA';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de configuración de esquemas.';
  
  t_dep(t_dep.LAST + 1).name := 'RCF_SCA_SUBCARTERA';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de configuración de esquemas.';
  
  t_dep(t_dep.LAST + 1).name := 'RCF_DD_TPR_TIPO_REPARTO_SUBC';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de configuración de esquemas.';
  
  t_dep(t_dep.LAST + 1).name := 'RCF_ITV_ITI_METAS_VOLANTES';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de configuración de esquemas.';
  
  t_dep(t_dep.LAST + 1).name := 'RCF_MFA_MODELOS_FACTURACION';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de configuración de esquemas.';
  
  t_dep(t_dep.LAST + 1).name := 'RCF_SUA_SUBCARTERA_AGENCIAS';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de configuración de esquemas.';
  
  t_dep(t_dep.LAST + 1).name := 'RCF_AGE_AGENCIAS';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de configuración de esquemas.';
  
  t_dep(t_dep.LAST + 1).name := 'RCF_SUR_SUBCARTERA_RANKING';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de configuración de esquemas.';
  
  t_dep(t_dep.LAST + 1).name := 'RCF_POA_POLITICA_ACUERDOS';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de configuración de esquemas.';
  
  t_dep(t_dep.LAST + 1).name := 'RCF_MOR_MODELO_RANKING';
  t_dep(t_dep.LAST).message := 'No se ha encontrado el modelo de configuración de esquemas.';
  
  
  /*
   * Relación de tablas que vamos a sustituir
   */ 
  a_tables(1) := 'BATCH_DATOS_EXP';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_EXP_MANUAL';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_CNT';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_PER';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_GCL';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_PER_EXP';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_CNT_EXP';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_CNT_PER';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_CLI';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_EXCEPTUADOS';
  a_tables(a_tables.LAST + 1) := 'BATCH_RCF_ENTRADA';
  
  /*
   * Relación de DDL's que vamos a ejecutar para crear las tablas
   */
  a_ddls(1) := '
    CREATE OR REPLACE VIEW BATCH_DATOS_EXP AS
      SELECT EXP.EXP_ID
        , ESC.RCF_CAR_ID AS ARQ_ID
        , 0 AS EXP_BORRADO
        , ''RECOBRO'' AS DD_TPE_CODIGO
        , EEX.DD_EEX_CODIGO
        , CRE.RCF_ESQ_ID AS RCF_ESQ_ID
        , CRE.RCF_AGE_ID AS RCF_AGE_ID
        , CRE.RCF_SCA_ID AS RCF_SCA_ID
        , NVL(CRE.CRE_MARCADO_BPM, 0) AS EXP_MARCADO_BPM
        , EXP.EXP_MANUAL
      FROM EXP_EXPEDIENTES EXP
        JOIN EXP_EXPEDIENTES_REC REC ON EXP.EXP_ID = REC.EXP_ID
        JOIN &MASTER_SCHEMA..DD_EEX_ESTADO_EXPEDIENTE EEX ON EXP.DD_EEX_ID = EEX.DD_EEX_ID
        JOIN CRE_CICLO_RECOBRO_EXP CRE ON EXP.EXP_ID = CRE.EXP_ID
        JOIN RCF_ESC_ESQUEMA_CARTERAS ESC ON CRE.RCF_ESC_ID = ESC.RCF_ESC_ID
      WHERE EXP.BORRADO = 0 AND EEX.DD_EEX_CODIGO = ''1'' AND EXP.EXP_MANUAL = 0
  ';
  
  a_ddls(a_ddls.LAST + 1) := '
    CREATE OR REPLACE VIEW BATCH_DATOS_EXP_MANUAL AS
      SELECT EXP.EXP_ID
        , ESC.RCF_CAR_ID AS ARQ_ID
        , 0 AS EXP_BORRADO
        , ''RECOBRO'' AS DD_TPE_CODIGO
        , EEX.DD_EEX_CODIGO
        , CRE.RCF_ESQ_ID AS RCF_ESQ_ID
        , CRE.RCF_AGE_ID AS RCF_AGE_ID
        , CRE.RCF_SCA_ID AS RCF_SCA_ID
        , NVL(CRE.CRE_MARCADO_BPM, 0) AS EXP_MARCADO_BPM
        , EXP.EXP_MANUAL
      FROM EXP_EXPEDIENTES EXP
        JOIN EXP_EXPEDIENTES_REC REC ON EXP.EXP_ID = REC.EXP_ID
        JOIN &MASTER_SCHEMA..DD_EEX_ESTADO_EXPEDIENTE EEX ON EXP.DD_EEX_ID = EEX.DD_EEX_ID
        JOIN CRE_CICLO_RECOBRO_EXP CRE ON EXP.EXP_ID = CRE.EXP_ID
        JOIN RCF_ESC_ESQUEMA_CARTERAS ESC ON CRE.RCF_ESC_ID = ESC.RCF_ESC_ID
      WHERE EXP.BORRADO = 0 AND EEX.DD_EEX_CODIGO = ''1'' AND EXP.EXP_MANUAL = 1
  ';
  
  a_ddls(a_ddls.LAST + 1) := '
    CREATE OR REPLACE VIEW BATCH_DATOS_CNT AS
      SELECT CNT.CNT_ID
        , CNT.OFI_ID
        , (NVL(MOV.MOV_DEUDA_IRREGULAR,0) - NVL(MOV.MOV_LIMITE_DESC,0)) AS CNT_RIESGO
      FROM CNT_CONTRATOS CNT
        JOIN &MASTER_SCHEMA..DD_ESC_ESTADO_CNT ESC ON CNT.DD_ESC_ID = ESC.DD_ESC_ID
        JOIN MOV_MOVIMIENTOS MOV ON CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION
      WHERE CNT.BORRADO = 0 AND ESC.DD_ESC_CODIGO = ''0''
  ';
  a_ddls(a_ddls.LAST + 1) := '
    CREATE OR REPLACE VIEW BATCH_DATOS_PER AS
      SELECT PER_ID
        , NVL(PER_NOMBRE,'''') AS PER_NOMBRE
        , NVL(PER_APELLIDO1,'''') AS PER_APELLIDO1
        , NVL(PER_APELLIDO2,'''') AS PER_APELLIDO2
        , NVL(PER_DEUDA_IRREGULAR, 0) AS PER_DEUDA_IRREGULAR
        , NVL(PER_RIESGO, 0) AS PER_RIESGO_DIRECTO
        , NVL(PER_RIESGO_IND, 0) AS PER_RIESGO_INDIRECTO
      FROM PER_PERSONAS
      WHERE BORRADO = 0
  ';
  
  a_ddls(a_ddls.LAST + 1) := '
    CREATE OR REPLACE VIEW BATCH_DATOS_GCL AS
      SELECT DISTINCT PGCL.GCL_ID
        , PGCL.PER_ID
      FROM PER_GCL PGCL 
        JOIN GCL_GRUPOS_CLIENTES GCL ON PGCL.GCL_ID = GCL.GCL_ID AND GCL.BORRADO = 0
        JOIN BATCH_DATOS_PER PER ON PGCL.PER_ID = PER.PER_ID
      WHERE PGCL.BORRADO = 0
  ';
  
  a_ddls(a_ddls.LAST + 1) := '
    CREATE OR REPLACE VIEW BATCH_DATOS_PER_EXP AS
     SELECT PEX.EXP_ID, PEX.PER_ID
      FROM  PEX_PERSONAS_EXPEDIENTE PEX
      WHERE PEX.BORRADO = 0
  ';
  a_ddls(a_ddls.LAST + 1) := '
    CREATE OR REPLACE VIEW BATCH_DATOS_CNT_EXP AS
     SELECT CEX.EXP_ID, CEX.CNT_ID
      FROM  CEX_CONTRATOS_EXPEDIENTE CEX
      WHERE CEX.BORRADO = 0
  ';
  a_ddls(a_ddls.LAST + 1) := '
    CREATE OR REPLACE VIEW BATCH_DATOS_CNT_PER AS
     SELECT CPE.CNT_ID
        , CPE.PER_ID
        , TIN.DD_TIN_CODIGO AS CNT_PER_TIN
        , CPE.CPE_ORDEN AS CNT_PER_OIN
      FROM  CPE_CONTRATOS_PERSONAS CPE
        JOIN DD_TIN_TIPO_INTERVENCION TIN ON CPE.DD_TIN_ID = TIN.DD_TIN_ID
      WHERE CPE.BORRADO = 0
  ';
  a_ddls(a_ddls.LAST + 1) := '
    CREATE OR REPLACE VIEW BATCH_DATOS_CLI AS
     SELECT CLI.CLI_ID, CLI.PER_ID
      FROM CLI_CLIENTES CLI
        JOIN &MASTER_SCHEMA..DD_ECL_ESTADO_CLIENTE ECL ON CLI.DD_ECL_ID = ECL.DD_ECL_ID
      WHERE CLI.BORRADO = 0 AND ECL.DD_ECL_CODIGO <> ''2''
  ';
  a_ddls(a_ddls.LAST + 1) := '
    CREATE OR REPLACE VIEW BATCH_DATOS_EXCEPTUADOS AS
        SELECT NULL AS PER_ID
          , CNT.CNT_ID
          , EXC.DD_MOE_ID AS DD_MOB_ID 
          , MOE.DD_MOE_CODIGO AS DD_MOB_CODIGO
          , MOE.BORRADO AS DD_MOB_BORRADO
          , EXC.EXC_ID
        FROM EXC_EXCEPTUACION EXC
          JOIN DD_MOE_MOTIVO_EXCEPTUACION MOE ON EXC.DD_MOE_ID = MOE.DD_MOE_ID
          JOIN ECO_EXCEPTUACION_CONTRATO CNT ON EXC.EXC_ID = CNT.EXC_ID
        WHERE EXC.BORRADO = 0 AND TRUNC(EXC.EXC_FECHA_HASTA) > TRUNC(SYSDATE) 
        UNION
        SELECT PER.PER_ID
          , NULL AS CNT_ID
          , EXC.DD_MOE_ID AS DD_MOB_ID 
          , MOE.DD_MOE_CODIGO AS DD_MOB_CODIGO
          , MOE.BORRADO AS DD_MOB_BORRADO
          , EXC.EXC_ID
        FROM EXC_EXCEPTUACION EXC
          JOIN DD_MOE_MOTIVO_EXCEPTUACION MOE ON EXC.DD_MOE_ID = MOE.DD_MOE_ID
          JOIN EPE_EXCEPTUACION_PERSONA PER ON EXC.EXC_ID = PER.EXC_ID
        WHERE EXC.BORRADO = 0 AND TRUNC(EXC_FECHA_HASTA) > TRUNC(SYSDATE)
  ';
  
  a_ddls(a_ddls.LAST + 1) :='
  CREATE OR REPLACE VIEW BATCH_RCF_ENTRADA AS
SELECT 
    ESQ.RCF_ESQ_ID AS RCF_ESQ_ID,
    ESQ.RCF_ESQ_PLAZO AS RCF_ESQ_PLAZO,
    ESQ.RCF_ESQ_FECHA_LIB AS RCF_ESQ_FECHA_LIB,
    ESQ.BORRADO AS RCF_ESQ_BORRADO,
    EES.RCF_DD_EES_ID AS RCF_DD_EES_ID,
    EES.RCF_DD_EES_CODIGO AS RCF_DD_EES_CODIGO,
    EES.BORRADO AS RCF_DD_EES_BORRADO,
    MTR.RCF_DD_MTR_ID AS RCF_DD_MTR_ID,
    MTR.RCF_DD_MTR_CODIGO AS RCF_DD_MTR_CODIGO,
    MTR.BORRADO AS RCF_DD_MTR_BORRADO,
    CAR.RCF_CAR_ID AS RCF_CAR_ID,
    CAR.RCF_CAR_NOMBRE AS RCF_CAR_NOMBRE,
    CAR.BORRADO AS RCF_CAR_BORRADO,
    null AS RCF_DD_ECA_ID, --ECA.RCF_DD_ECA_ID ,
    null AS RCF_DD_ECA_CODIGO, --ECA.RCF_DD_ECA_CODIGO ,
    null AS RCF_DD_ECA_BORRADO, --ECA.BORRADO ,
    RUL.RD_ID AS RD_ID,
    RUL.RD_NAME AS RD_NAME,
    RUL.RD_DEFINITION AS RD_DEFINITION,
    RUL.BORRADO AS RD_BORRADO,
    AGE.RCF_AGE_ID AS RCF_AGE_ID,
    AGE.RCF_AGE_NOMBRE AS RCF_AGE_NOMBRE,
    AGE.RCF_AGE_CODIGO AS RCF_AGE_CODIGO,
    AGE.BORRADO AS RCF_AGE_BORRADO,
    ESC.RCF_ESC_ID AS RCF_ESC_ID,
    ESC.RCF_ESC_PRIORIDAD AS RCF_ESC_PRIORIDAD,
    ESC.BORRADO AS RCF_ESC_BORRADO,
    TCE.DD_TCE_ID AS RCF_DD_TCE_ID,        
    TCE.DD_TCE_CODIGO AS RCF_DD_TCE_CODIGO,
    TCE.BORRADO AS RCF_DD_TCE_BORRADO,
    TGC.DD_TGC_ID AS RCF_DD_TGC_ID,        
    TGC.DD_TGC_CODIGO AS RCF_DD_TGC_CODIGO,
    TGC.BORRADO AS RCF_DD_TGC_BORRADO,
    AER.DD_AER_ID AS RCF_DD_AER_ID,        
    AER.DD_AER_CODIGO AS RCF_DD_AER_CODIGO,
    AER.BORRADO AS RCF_DD_AER_BORRADO,
    SCA.RCF_SCA_ID AS RCF_SCA_ID,
    SCA.RCF_SCA_NOMBRE AS RCF_SCA_NOMBRE,
    SCA.RCF_SCA_PARTICION AS RCF_SCA_PARTICION,
    SCA.BORRADO AS RCF_SCA_BORRADO,
    TPR.RCF_DD_TPR_ID AS RCF_DD_TPR_ID,        
    TPR.RCF_DD_TPR_CODIGO AS RCF_DD_TPR_CODIGO,
    TPR.BORRADO AS RCF_DD_TPR_BORRADO,
    ITV.RCF_ITV_ID AS RCF_ITV_ID,        
    ITV.RCF_ITV_NOMBRE AS RCF_ITV_NOMBRE,
    ITV.RCF_ITV_FECHA_ALTA AS RCF_ITV_FECHA_ALTA,
    ITV.RCF_ITV_PLAZO_MAX AS RCF_ITV_PLAZO_MAX,
    ITV.RCF_ITV_NO_GEST AS RCF_ITV_NO_GEST,
    ITV.BORRADO AS RCF_ITV_BORRADO,
    MFA.RCF_MFA_ID AS RCF_MFA_ID,        
    MFA.RCF_MFA_NOMBRE AS RCF_MFA_NOMBRE,
    MFA.BORRADO AS RCF_MFA_BORRADO,
    POA.RCF_POA_ID AS RCF_POA_ID,        
    POA.RCF_POA_CODIGO AS RCF_POA_CODIGO,
    POA.BORRADO AS RCF_POA_BORRADO,
    MOR.RCF_MOR_ID AS RCF_MOR_ID,
    MOR.RCF_MOR_NOMBRE AS RCF_MOR_NOMBRE,
    MOR.BORRADO AS RCF_MOR_BORRADO,
    SUA.RCF_SUA_ID AS RCF_SUA_ID,
    SUA.RCF_SUA_COEFICIENTE AS RCF_SUA_COEFICIENTE,
    SUA.BORRADO AS RCF_SUA_BORRADO,
    SUR.RCF_SUR_ID AS RCF_SUR_ID,
    SUR.RCF_SUR_POSICION AS RCF_SUR_POSICION,
    SUR.RCF_SUR_PORCENTAJE AS RCF_SUR_PORCENTAJE,
    SUR.BORRADO AS RCF_SUR_BORRADO
  FROM RCF_ESQ_ESQUEMA ESQ  
    JOIN RCF_DD_MTR_MODELO_TRANSICION MTR ON ESQ.RCF_DD_MTR_ID = MTR.RCF_DD_MTR_ID
    JOIN RCF_DD_EES_ESTADO_ESQUEMA EES ON ESQ.RCF_DD_EES_ID = EES.RCF_DD_EES_ID    
    JOIN RCF_ESC_ESQUEMA_CARTERAS ESC ON ESQ.RCF_ESQ_ID = ESC.RCF_ESQ_ID
    JOIN RCF_DD_TGC_TIPO_GESTION_CART TGC ON ESC.DD_TGC_ID = TGC.DD_TGC_ID
    JOIN RCF_DD_TCE_TIPO_CARTERA_ESQ TCE ON ESC.DD_TCE_ID = TCE.DD_TCE_ID
    JOIN RCF_DD_AER_AMBITO_EXP_REC AER ON ESC.DD_AER_ID = AER.DD_AER_ID
    JOIN RCF_CAR_CARTERA CAR ON ESC.RCF_CAR_ID = CAR.RCF_CAR_ID
    --JOIN RCF_DD_ECA_ESTADO_CARTERA ECA ON CAR.RCF_DD_ECA_ID = ECA.RCF_DD_ECA_ID
    JOIN RULE_DEFINITION RUL ON CAR.RD_ID = RUL.RD_ID
    JOIN RCF_SCA_SUBCARTERA SCA ON ESC.RCF_ESC_ID = SCA.RCF_ESC_ID  
    JOIN RCF_DD_TPR_TIPO_REPARTO_SUBC TPR ON SCA.RCF_DD_TPR_ID = TPR.RCF_DD_TPR_ID
    JOIN RCF_ITV_ITI_METAS_VOLANTES ITV ON SCA.RCF_ITV_ID = ITV.RCF_ITV_ID
    JOIN RCF_MFA_MODELOS_FACTURACION MFA ON SCA.RCF_MFA_ID = MFA.RCF_MFA_ID
    JOIN RCF_SUA_SUBCARTERA_AGENCIAS SUA ON SCA.RCF_SCA_ID = SUA.RCF_SCA_ID
    JOIN RCF_AGE_AGENCIAS AGE ON SUA.RCF_AGE_ID  = AGE.RCF_AGE_ID 
    LEFT JOIN RCF_SUR_SUBCARTERA_RANKING SUR ON SCA.RCF_SCA_ID = SUR.RCF_SUR_ID AND SUR.BORRADO = 0    
    LEFT JOIN RCF_POA_POLITICA_ACUERDOS POA ON SCA.RCF_POA_ID = POA.RCF_POA_ID AND POA.BORRADO = 0
    JOIN RCF_MOR_MODELO_RANKING MOR ON SCA.RCF_MOR_ID = MOR.RCF_MOR_ID
  WHERE ESQ.BORRADO = 0 AND MTR.BORRADO = 0 AND EES.BORRADO = 0
    AND ESC.BORRADO = 0 AND TGC.BORRADO = 0 AND TCE.BORRADO = 0
    AND AER.BORRADO = 0 AND CAR.BORRADO = 0 --AND ECA.BORRADO = 0
    AND RUL.BORRADO = 0 AND SCA.BORRADO = 0 AND TPR.BORRADO = 0
    AND ITV.BORRADO = 0 AND MFA.BORRADO = 0 AND SUA.BORRADO = 0
    AND AGE.BORRADO = 0 
    AND MOR.BORRADO = 0 AND EES.RCF_DD_EES_CODIGO IN (''EXG'', ''LBR'')
  ';
  
  /*
   * Comprobamos que existan las tablas de las que se depende
   */
   FOR i IN t_dep.FIRST..t_dep.LAST LOOP
     SELECT COUNT(*) INTO NCOUNT FROM ALL_TABLES WHERE TABLE_NAME = t_dep(i).name;
     IF ncount <= 0 THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: TABLE ['||t_dep(i).name||'] NOT FOUND - '||t_dep(i).message);
      currentTable := t_dep(i).name;
      RAISE ERROR_TABLE_NOT_FOUND;
     END IF;
   END LOOP;
  
  /*
   * Borramos las tablas si existen
   */
  FOR contador IN 1..a_tables.LAST LOOP
    SELECT COUNT(*) INTO NCOUNT FROM ALL_TABLES WHERE TABLE_NAME = a_tables(contador);
    
    IF ncount > 0 THEN
       DBMS_OUTPUT.PUT_LINE(a_tables(contador)||': tabla encontrada, se sustituirá por una vista.');
       v_sql:='ALTER TABLE '||a_tables(contador)||' RENAME TO '||a_tables(contador)||'_RNMD';
       execute immediate v_sql;
       DBMS_OUTPUT.PUT_LINE(a_tables(contador)||': tabla renombrada.');
    END IF;
  END LOOP;
  
  /*
   * Creamos las vistas
   */
  FOR contador IN 1..a_tables.LAST LOOP
    DBMS_OUTPUT.PUT_LINE('Ejecutando DDL: '||SUBSTR(a_ddls(contador),1,INSTR(a_ddls(contador),'AS')-2));
    execute immediate a_ddls(contador);
  END LOOP; 
  
  EXCEPTION 
    WHEN ERROR_TABLE_NOT_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('El programa ha abortado');
      RAISE_APPLICATION_ERROR(-20000, 'PROCESO ABORTADO FALTA UNA TABLA REQUERIDA: '||currentTable) ;
end;