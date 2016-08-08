--############################################
--### VALIDACIÓNES DE DATOS PRE-MIGRACIÓN ###
--############################################

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

TYPE T_TAB IS TABLE OF VARCHAR2(3000);
TYPE T_ARRAY_TABLAS IS TABLE OF T_TAB;

VAR1 NUMBER(6);
VAR2 NUMBER(6);
VAR3 NUMBER(6);
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
TABLA_MIG VARCHAR2(30 CHAR);
TABLA_REM VARCHAR2(30 CHAR);
SENTENCIA VARCHAR2(1000 CHAR);
V_TMP_TAB T_TAB;

V_TABLAS T_ARRAY_TABLAS := T_ARRAY_TABLAS(
    T_TAB('MIG_ACA_CABECERA'),
    T_TAB('MIG_ATI_TITULO'),
    T_TAB('MIG_ADA_DATOS_ADI'),
    T_TAB('MIG_ADJ_JUDICIAL'),
    T_TAB('MIG_ADJ_NO_JUDICIAL'),
    T_TAB('MIG_ACA_CALIDADES_ACTIVO'),
    T_TAB('MIG_AIA_INFOCOMERCIAL_ACTIVO'),
    T_TAB('MIG_ALA_LLAVES_ACTIVO'),
    T_TAB('MIG_APA_PROP_ACTIVO')
  )
  ;
  
V_TABLAS_2 T_ARRAY_TABLAS := T_ARRAY_TABLAS(
    T_TAB('MIG_AAA_AGRUPACIONES_ACTIVO'),
    T_TAB('MIG_ACA_CALIDADES_ACTIVO'),
    T_TAB('MIG_ACA_CARGAS_ACTIVO'),
    T_TAB('MIG_ACA_CATASTRO_ACTIVO'),
    T_TAB('MIG_ADA_DATOS_ADI'),
    T_TAB('MIG_ADA_DOCUMENTOS_ACTIVO'),
    T_TAB('MIG_ADD_ADMISION_DOCUMENTOS'),
    T_TAB('MIG_AIA_IMAGENES_ACTIVO'),
    T_TAB('MIG_AIA_INFOCOMERCIAL_ACTIVO'),
    T_TAB('MIG_AID_INFOCOMERCIAL_DISTR'),
    T_TAB('MIG_ALA_LLAVES_ACTIVO'),
    T_TAB('MIG_AOA_OBSERVACIONES_ACTIVOS'),
    T_TAB('MIG_AOA_OCUPANTES_ACTIVO'),
    T_TAB('MIG_APA_PROP_ACTIVO'),
    T_TAB('MIG_APC_PRECIO'),
    T_TAB('MIG_APL_PLANDINVENTAS'),
    T_TAB('MIG_ATA_TASACIONES_ACTIVO'),
    T_TAB('MIG_ATI_TITULO'),
    T_TAB('MIG_ATR_TRABAJO'),
    T_TAB('MIG_PRESUPUESTO_ACTIVO'),
    T_TAB('MIG_ADJ_JUDICIAL'),
    T_TAB('MIG_ADJ_NO_JUDICIAL')
  )
  ;

V_TABLAS_3 T_ARRAY_TABLAS := T_ARRAY_TABLAS(
    T_TAB('MIG_AAA_AGRUPACIONES_ACTIVO'),
    T_TAB('MIG_AOA_OBSERVACIONES_AGRUP'),
    T_TAB('MIG_ASA_SUBDIVISIONES_AGRUP')
  )
  ;
  
V_TABLAS_4 T_ARRAY_TABLAS := T_ARRAY_TABLAS(
    T_TAB('MIG_CPC_PROP_CABECERA'),
    T_TAB('MIG_CPC_PROP_CUOTAS'),
    T_TAB('MIG_ADA_DATOS_ADI')
  )
  ;

BEGIN


-------- BUSCAMOS ACT_NUMERO_ACTIVO DUPLICADOS ENTRE LAS SIGUIENTES TABLAS : ---------------------------------------------------------
-------- MIG_ACA_CABECERA, MIG_ATI_TITULO, MIG_ADA_DATOS_ADI, MIG_APL_PLANDINVENTAS, MIG_ADJ_JUDICIAL, MIG_ADJ_NO_JUDICIAL -----------
-------- MIG_ACA_CALIDADES_ACTIVO, MIG_AIA_INFOCOMERCIAL_ACTIVO, MIG_ALA_LLAVES_ACTIVO, MIG_APA_PROP_ACTIVO --------------------------


  DBMS_OUTPUT.PUT_LINE('[INFO] [ACT_NUMERO_ACTIVO DUPLICADOS]');
  DBMS_OUTPUT.PUT_LINE('');
  
  FOR I IN V_TABLAS.FIRST .. V_TABLAS.LAST
  LOOP
  
    V_TMP_TAB := V_TABLAS(I);

    TABLA_MIG := V_TMP_TAB(1);
    
    --LLAVES_ACTIVO ES ESPECIAL PORQUE NO SE PUEDE REPETIR ACT_NUMERO_ACTIVO-LLV_CODIGO_UVEM
    
    IF TABLA_MIG = 'MIG_ALA_LLAVES_ACTIVO' THEN
    
    SENTENCIA := '
      SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
      WHERE MIG.ACT_NUMERO_ACTIVO IS NOT NULL
      '
      ;
      EXECUTE IMMEDIATE SENTENCIA INTO VAR1;
    
      SENTENCIA := '
      SELECT COUNT(DISTINCT(ACT_NUMERO_ACTIVO||LLV_CODIGO_UVEM)) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
      WHERE MIG.ACT_NUMERO_ACTIVO IS NOT NULL
      '
      ;
      EXECUTE IMMEDIATE SENTENCIA INTO VAR2;
      
      VAR3 := VAR1-VAR2;
      
      IF VAR3 <= 0 THEN
      
        DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
        DBMS_OUTPUT.PUT_LINE('- No hay registros duplicados.');
        DBMS_OUTPUT.PUT_LINE('');
      
      ELSE
      
        DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
        DBMS_OUTPUT.PUT_LINE('- Hay '||VAR3||' registros duplicados de un total de '||VAR1||' registros.');
        DBMS_OUTPUT.PUT_LINE('- Puede ver estos registros con la siguiente consulta: ');
        DBMS_OUTPUT.PUT_LINE('SELECT ACT_NUMERO_ACTIVO||LLV_CODIGO_UVEM, COUNT(*) VECES_REPETIDO FROM '||TABLA_MIG||' GROUP BY ACT_NUMERO_ACTIVO||LLV_CODIGO_UVEM HAVING COUNT(*) > 1;');
        DBMS_OUTPUT.PUT_LINE('');
      
      END IF;    
    
    ELSE 
  
      SENTENCIA := '
      SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
      WHERE MIG.ACT_NUMERO_ACTIVO IS NOT NULL
      '
      ;
      EXECUTE IMMEDIATE SENTENCIA INTO VAR1;
    
      SENTENCIA := '
      SELECT COUNT(DISTINCT(ACT_NUMERO_ACTIVO)) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
      WHERE MIG.ACT_NUMERO_ACTIVO IS NOT NULL
      '
      ;
      EXECUTE IMMEDIATE SENTENCIA INTO VAR2;
      
      VAR3 := VAR1-VAR2;
      
      IF VAR3 <= 0 THEN
      
        DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
        DBMS_OUTPUT.PUT_LINE('- No hay registros duplicados.');
        DBMS_OUTPUT.PUT_LINE('');
      
      ELSE
      
        DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
        DBMS_OUTPUT.PUT_LINE('- Hay '||VAR3||' registros duplicados de un total de '||VAR1||' registros.');
        DBMS_OUTPUT.PUT_LINE('- Puede ver estos registros con la siguiente consulta: ');
        DBMS_OUTPUT.PUT_LINE('SELECT ACT_NUMERO_ACTIVO, COUNT(*) VECES_REPETIDO FROM '||TABLA_MIG||' GROUP BY ACT_NUMERO_ACTIVO HAVING COUNT(*) > 1;');
        DBMS_OUTPUT.PUT_LINE('');
      
      END IF;
      
    END IF;
    
  END LOOP;
  
  
-------- CONFIRMAR EXISTENCIA DE ACTIVOS ENTRE MIG_ACA_CABECERA Y LAS SIGUIENTES TABLAS : ---------------------------
-------- MIG_ATI_TITULO, MIG_ADA_DATOS_ADI, MIG_APL_PLANDINVENTAS, MIG_ADJ_JUDICIAL + MIG_ADJ_NO_JUDICIAL -----------
-------- MIG_ACA_CALIDADES_ACTIVO, MIG_AIA_INFOCOMERCIAL_ACTIVO, MIG_ALA_LLAVES_ACTIVO, MIG_APA_PROP_ACTIVO ---------


  DBMS_OUTPUT.PUT_LINE('[INFO] [EXISTENCIA DE ACTIVOS REFERENCIADOS EN TABLAS]');
  DBMS_OUTPUT.PUT_LINE('');
  
  FOR I IN V_TABLAS_2.FIRST .. V_TABLAS_2.LAST
  LOOP
  
    V_TMP_TAB := V_TABLAS_2(I);

    TABLA_MIG := V_TMP_TAB(1);
  
    SENTENCIA := '
    SELECT COUNT(1) 
    FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
    WHERE NOT EXISTS (
      SELECT 1 FROM '||V_ESQUEMA||'.MIG_ACA_CABECERA ACT WHERE ACT.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    )
    AND MIG.ACT_NUMERO_ACTIVO IS NOT NULL
    '
    ;
    EXECUTE IMMEDIATE SENTENCIA INTO VAR1;
    
    EXECUTE IMMEDIATE '
    SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
    WHERE MIG.ACT_NUMERO_ACTIVO IS NOT NULL
    '
    INTO VAR2
    ;
  
    IF VAR1 <= 0 THEN
    
      DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
      DBMS_OUTPUT.PUT_LINE('- Todos los activos informados existen en MIG_ACA_CABECERA.');
      DBMS_OUTPUT.PUT_LINE('');
    
    ELSE
    
      DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
      DBMS_OUTPUT.PUT_LINE('- Hay '||VAR1||' de '||VAR2||' activos que no existen en MIG_ACA_CABECERA.');
      DBMS_OUTPUT.PUT_LINE('- Puede ver estos registros con la siguiente consulta: ');
      DBMS_OUTPUT.PUT_LINE('SELECT * FROM '||TABLA_MIG||' WHERE ACT_NUMERO_ACTIVO NOT IN ( SELECT ACT_NUMERO_ACTIVO FROM MIG_ACA_CABECERA );');
      VAR2 := VAR2 - VAR1;
      DBMS_OUTPUT.PUT_LINE('  '||VAR2||' si existen en MIG_ACA_CABECERA.');
      DBMS_OUTPUT.PUT_LINE('');
    
    END IF;
    
  END LOOP;
 
  EXECUTE IMMEDIATE '
  WITH UNO AS (
  SELECT COUNT(ACT_NUMERO_ACTIVO) COUNTER
  FROM '||V_ESQUEMA||'.MIG_ADJ_JUDICIAL MIG
  WHERE MIG.ACT_NUMERO_ACTIVO IS NOT NULL
  ),
  DOS AS (
  SELECT COUNT(ACT_NUMERO_ACTIVO) COUNTER
  FROM '||V_ESQUEMA||'.MIG_ADJ_NO_JUDICIAL MIG
  WHERE MIG.ACT_NUMERO_ACTIVO IS NOT NULL
  )
  SELECT UNO.COUNTER+DOS.COUNTER FROM UNO JOIN DOS ON 1=1
  '
  INTO VAR1
  ;
  
  EXECUTE IMMEDIATE '
  SELECT COUNT(ACT_NUMERO_ACTIVO) FROM '||V_ESQUEMA||'.MIG_ACA_CABECERA
  '
  INTO VAR2
  ;
  
  VAR3 := VAR2 - VAR1;
  
  IF VAR3 <= 0 THEN

    IF VAR3 < 0 THEN
    
        VAR3 := VAR3 * (-1);
        DBMS_OUTPUT.PUT_LINE('[ADJUDICACIONES JUDICIALES].');
        DBMS_OUTPUT.PUT_LINE('- Hay '||VAR3||' activos más en MIG_ADJ_JUDICIAL + MIG_ADJ_NO_JUDICIAL que en MIG_ACA_CABECERA.');
        DBMS_OUTPUT.PUT_LINE('');
    
    ELSE
    
        DBMS_OUTPUT.PUT_LINE('[ADJUDICACIONES JUDICIALES].');
        DBMS_OUTPUT.PUT_LINE('- Todos los activos informados existen en MIG_ACA_CABECERA.');
        DBMS_OUTPUT.PUT_LINE('');
        
    END IF;
      
  ELSE 
  
      DBMS_OUTPUT.PUT_LINE('[ADJUDICACIONES JUDICIALES].');
      DBMS_OUTPUT.PUT_LINE('- Se han informado '||VAR3||' activos menos en MIG_ADJ_JUDICIAL + MIG_ADJ_NO_JUDICIAL que en MIG_ACA_CABECERA.');
      DBMS_OUTPUT.PUT_LINE('');    
    
  END IF;
  
  
-------- BUSCAMOS CPR_COD_COM_PROP_UVEM DUPLICADOS ENTRE LAS SIGUIENTES TABLAS : -----
-------- MIG_CPC_PROP_CABECERA, MIG_CPC_PROP_CUOTAS, MIG_ADA_DATOS_ADI -----------


  DBMS_OUTPUT.PUT_LINE('[INFO] [CPR_COD_COM_PROP_UVEM DUPLICADOS]');
  DBMS_OUTPUT.PUT_LINE('');
  
  FOR I IN V_TABLAS_4.FIRST .. V_TABLAS_4.LAST
  LOOP
  
    V_TMP_TAB := V_TABLAS_4(I);

    TABLA_MIG := V_TMP_TAB(1);
    
    --EN MIG_ADA_DATOS_ADI NO SE PUEDE REPETIR LA PAREJA ACT_NUMERO_ACTIVO-CPR_COD_COM_PROP_UVEM
    
    IF TABLA_MIG = 'MIG_ADA_DATOS_ADI' THEN
    
      SENTENCIA := '
      SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
      WHERE MIG.CPR_COD_COM_PROP_UVEM IS NOT NULL
      '
      ;
      EXECUTE IMMEDIATE SENTENCIA INTO VAR1;
    
      SENTENCIA := '
      SELECT COUNT(DISTINCT(ACT_NUMERO_ACTIVO||CPR_COD_COM_PROP_UVEM)) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
      WHERE MIG.CPR_COD_COM_PROP_UVEM IS NOT NULL
      AND MIG.ACT_NUMERO_ACTIVO IS NOT NULL
      '
      ;
      EXECUTE IMMEDIATE SENTENCIA INTO VAR2;
      
      VAR3 := VAR1-VAR2;
      
      IF VAR3 <= 0 THEN
      
        DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
        DBMS_OUTPUT.PUT_LINE('- No hay registros duplicados.');
        DBMS_OUTPUT.PUT_LINE('');
      
      ELSE
      
        DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
        DBMS_OUTPUT.PUT_LINE('- Hay '||VAR3||' registros duplicados de un total de '||VAR1||' registros.');
        DBMS_OUTPUT.PUT_LINE('- Puede ver estos registros con la siguiente consulta: ');
        DBMS_OUTPUT.PUT_LINE('SELECT ACT_NUMERO_ACTIVO||CPR_COD_COM_PROP_UVEM, COUNT(*) VECES_REPETIDO FROM '||TABLA_MIG||' GROUP BY ACT_NUMERO_ACTIVO||CPR_COD_COM_PROP_UVEM HAVING COUNT(*) > 1;');
        DBMS_OUTPUT.PUT_LINE('');
      
      END IF;
      
    ELSE
  
      SENTENCIA := '
      SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
      WHERE MIG.CPR_COD_COM_PROP_UVEM IS NOT NULL
      '
      ;
      EXECUTE IMMEDIATE SENTENCIA INTO VAR1;
    
      SENTENCIA := '
      SELECT COUNT(DISTINCT(CPR_COD_COM_PROP_UVEM)) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
      WHERE MIG.CPR_COD_COM_PROP_UVEM IS NOT NULL
      '
      ;
      EXECUTE IMMEDIATE SENTENCIA INTO VAR2;
      
      VAR3 := VAR1-VAR2;
      
      IF VAR3 <= 0 THEN
      
        DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
        DBMS_OUTPUT.PUT_LINE('- No hay registros duplicados.');
        DBMS_OUTPUT.PUT_LINE('');
      
      ELSE
      
        DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
        DBMS_OUTPUT.PUT_LINE('- Hay '||VAR3||' registros duplicados de un total de '||VAR1||' registros.');
        DBMS_OUTPUT.PUT_LINE('- Puede ver estos registros con la siguiente consulta: ');
        DBMS_OUTPUT.PUT_LINE('SELECT CPR_COD_COM_PROP_UVEM, COUNT(*) VECES_REPETIDO FROM '||TABLA_MIG||' GROUP BY CPR_COD_COM_PROP_UVEM HAVING COUNT(*) > 1;');
        DBMS_OUTPUT.PUT_LINE('');
      
      END IF;
      
    END IF;
    
  END LOOP;
  
  
-------- CONFIRMAR EXISTENCIA DE COMUNIDADES DE PROPIETARIOS ENTRE MIG_CPC_PROP_CABECERA Y LAS SIGUIENTES TABLAS : ---------------------------
-------- MIG_CPC_PROP_CUOTAS, MIG_ADA_DATOS_ADI ----------------------------------------------------------------------------------------------



  DBMS_OUTPUT.PUT_LINE('[INFO] [EXISTENCIA DE ACTIVOS REFERENCIADOS EN TABLAS]');
  DBMS_OUTPUT.PUT_LINE('');
  
  FOR I IN V_TABLAS_4.FIRST .. V_TABLAS_4.LAST
  LOOP
  
    V_TMP_TAB := V_TABLAS_4(I);

    TABLA_MIG := V_TMP_TAB(1);
  
    SENTENCIA := '
    SELECT COUNT(1) 
    FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
    WHERE NOT EXISTS (
      SELECT 1 FROM '||V_ESQUEMA||'.MIG_CPC_PROP_CABECERA CPC WHERE CPC.CPR_COD_COM_PROP_UVEM = MIG.CPR_COD_COM_PROP_UVEM
    )
    AND MIG.CPR_COD_COM_PROP_UVEM IS NOT NULL
    '
    ;
    EXECUTE IMMEDIATE SENTENCIA INTO VAR1;
    
    EXECUTE IMMEDIATE '
    SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
    WHERE MIG.CPR_COD_COM_PROP_UVEM IS NOT NULL
    '
    INTO VAR2
    ;
  
    IF VAR1 <= 0 THEN
    
      DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
      DBMS_OUTPUT.PUT_LINE('- Todas las comunidades de propietarios existen en MIG_CPC_PROP_CABECERA.');
      DBMS_OUTPUT.PUT_LINE('');
    
    ELSE
    
      DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
      DBMS_OUTPUT.PUT_LINE('- Hay '||VAR1||' de '||VAR2||' comunidades de propietarios que no existen en MIG_CPC_PROP_CABECERA.');
      DBMS_OUTPUT.PUT_LINE('- Puede ver estos registros con la siguiente consulta: ');
      DBMS_OUTPUT.PUT_LINE('SELECT * FROM '||TABLA_MIG||' WHERE CPR_COD_COM_PROP_UVEM NOT IN ( SELECT CPR_COD_COM_PROP_UVEM FROM MIG_CPC_PROP_CABECERA );');
      VAR2 := VAR2 - VAR1;
      DBMS_OUTPUT.PUT_LINE('  '||VAR2||' si existen en MIG_CPC_PROP_CABECERA.');
      DBMS_OUTPUT.PUT_LINE('');
    
    END IF;
    
  END LOOP;

  
-------- BUSCAMOS AGR_UVEM DUPLICADOS ENTRE LAS SIGUIENTES TABLAS : ---------
-------- MIG_AAG_AGRUPACIONES -----------------------------------------------


  DBMS_OUTPUT.PUT_LINE('[INFO] [AGR_UVEM DUPLICADOS]');
  DBMS_OUTPUT.PUT_LINE('');
  
    TABLA_MIG := 'MIG_AAG_AGRUPACIONES';
  
    SENTENCIA := '
    SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
    WHERE MIG.AGR_UVEM IS NOT NULL
    '
    ;
    EXECUTE IMMEDIATE SENTENCIA INTO VAR1;
  
    SENTENCIA := '
    SELECT COUNT(DISTINCT(AGR_UVEM)) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
    WHERE MIG.AGR_UVEM IS NOT NULL
    '
    ;
    EXECUTE IMMEDIATE SENTENCIA INTO VAR2;
    
    VAR3 := VAR1-VAR2;
    
    IF VAR3 <= 0 THEN
    
      DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
      DBMS_OUTPUT.PUT_LINE('- No hay registros duplicados.');
      DBMS_OUTPUT.PUT_LINE('');
    
    ELSE
    
      DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
      DBMS_OUTPUT.PUT_LINE('- Hay '||VAR3||' registros duplicados de un total de '||VAR1||' registros.');
      DBMS_OUTPUT.PUT_LINE('- Puede ver estos registros con la siguiente consulta: ');
      DBMS_OUTPUT.PUT_LINE('SELECT AGR_UVEM, COUNT(*) VECES_REPETIDO FROM '||TABLA_MIG||' GROUP BY AGR_UVEM HAVING COUNT(*) > 1;');
      DBMS_OUTPUT.PUT_LINE('');
    
    END IF;
  
  
-------- CONFIRMAR EXISTENCIA DE AGRUPACIONES ENTRE MIG_AAG_AGRUPACIONES Y LAS SIGUIENTES TABLAS : -----------
-------- MIG_AAA_AGRUPACIONES_ACTIVO, MIG_AOA_OBSERVACIONES_AGRUP, MIG_ASA_SUBDIVISIONES_AGRUP ---------------


  DBMS_OUTPUT.PUT_LINE('[INFO] [EXISTENCIA DE AGRUPACIONES REFERENCIADOS EN TABLAS]');
  DBMS_OUTPUT.PUT_LINE('');
  
  FOR I IN V_TABLAS_3.FIRST .. V_TABLAS_3.LAST
  LOOP
  
    V_TMP_TAB := V_TABLAS_3(I);

    TABLA_MIG := V_TMP_TAB(1);
    
    EXECUTE IMMEDIATE '
    SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
    WHERE MIG.AGR_UVEM IS NOT NULL
    '
    INTO VAR2
    ;

    IF VAR2 != 0 THEN
  
      SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
      WHERE NOT EXISTS (
        SELECT 1 FROM '||V_ESQUEMA||'.MIG_AAG_AGRUPACIONES AGR WHERE AGR.AGR_UVEM = MIG.AGR_UVEM
      )
      AND MIG.AGR_UVEM IS NOT NULL
      '
      ;
      EXECUTE IMMEDIATE SENTENCIA INTO VAR1;
      
      
    
      IF VAR1 <= 0 THEN
      
        DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
        DBMS_OUTPUT.PUT_LINE('- Todos las agrupaciones informadas existen en MIG_AAG_AGRUPACIONES.');
        DBMS_OUTPUT.PUT_LINE('');
      
      ELSE
      
        DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
        DBMS_OUTPUT.PUT_LINE('- Hay '||VAR1||' de '||VAR2||' agrupaciones que no existen en MIG_AAG_AGRUPACIONES.');
        DBMS_OUTPUT.PUT_LINE('- Puede ver estos registros con la siguiente consulta: ');
        DBMS_OUTPUT.PUT_LINE('SELECT * FROM '||TABLA_MIG||' WHERE AGR_UVEM NOT IN ( SELECT AGR_UVEM FROM MIG_AAG_AGRUPACIONES );');
        VAR2 := VAR2 - VAR1;
        DBMS_OUTPUT.PUT_LINE('  '||VAR2||' si existen en MIG_AAG_AGRUPACIONES.');
        DBMS_OUTPUT.PUT_LINE('');
      
      END IF;
      
    END IF;
    
  END LOOP;
   
  
-------- BUSCAMOS PRO_CODIGO_UVEM DUPLICADOS ENTRE LAS SIGUIENTES TABLAS : ---------
-------- MIG_APC_PROP_CABECERA -----------------------------------------------


  DBMS_OUTPUT.PUT_LINE('[INFO] [PRO_CODIGO_UVEM DUPLICADOS]');
  DBMS_OUTPUT.PUT_LINE('');
  
    TABLA_MIG := 'MIG_APC_PROP_CABECERA';
  
    SENTENCIA := '
    SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
    WHERE MIG.PRO_CODIGO_UVEM IS NOT NULL
    '
    ;
    EXECUTE IMMEDIATE SENTENCIA INTO VAR1;
  
    SENTENCIA := '
    SELECT COUNT(DISTINCT(PRO_CODIGO_UVEM)) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
    WHERE MIG.PRO_CODIGO_UVEM IS NOT NULL
    '
    ;
    EXECUTE IMMEDIATE SENTENCIA INTO VAR2;
    
    VAR3 := VAR1-VAR2;
    
    IF VAR3 = 0 THEN
    
      DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
      DBMS_OUTPUT.PUT_LINE('- No hay registros duplicados.');
      DBMS_OUTPUT.PUT_LINE('');
    
    ELSE
    
      DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
      DBMS_OUTPUT.PUT_LINE('- Hay '||VAR3||' registros duplicados de un total de '||VAR1||' registros.');
      DBMS_OUTPUT.PUT_LINE('- Puede ver estos registros con la siguiente consulta: ');
      DBMS_OUTPUT.PUT_LINE('SELECT PRO_CODIGO_UVEM, COUNT(*) VECES_REPETIDO FROM '||TABLA_MIG||' GROUP BY PRO_CODIGO_UVEM HAVING COUNT(*) > 1;');
      DBMS_OUTPUT.PUT_LINE('');
    
    END IF;
    
    
-------- CONFIRMAR EXISTENCIA DE PROPIETARIOS ENTRE MIG_APC_PROP_CABECERA Y LAS SIGUIENTES TABLAS : -----------
-------- MIG_APA_PROP_ACTIVO ---------------


  DBMS_OUTPUT.PUT_LINE('[INFO] [EXISTENCIA DE AGRUPACIONES REFERENCIADOS EN TABLAS]');
  DBMS_OUTPUT.PUT_LINE('');
  
    TABLA_MIG := 'MIG_APA_PROP_ACTIVO';
    
    EXECUTE IMMEDIATE '
    SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
    WHERE MIG.PRO_CODIGO_UVEM IS NOT NULL
    '
    INTO VAR2
    ;

    IF VAR2 != 0 THEN
  
      SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
      WHERE NOT EXISTS (
        SELECT 1 FROM '||V_ESQUEMA||'.MIG_APC_PROP_CABECERA PRO WHERE PRO.PRO_CODIGO_UVEM = MIG.PRO_CODIGO_UVEM
      )
      AND MIG.PRO_CODIGO_UVEM IS NOT NULL
      '
      ;
      EXECUTE IMMEDIATE SENTENCIA INTO VAR1;
      
      
    
      IF VAR1 <= 0 THEN
      
        DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
        DBMS_OUTPUT.PUT_LINE('- Todos las propietarios informados existen en MIG_APC_PROP_CABECERA.');
        DBMS_OUTPUT.PUT_LINE('');
      
      ELSE
      
        DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
        DBMS_OUTPUT.PUT_LINE('- Hay '||VAR1||' de '||VAR2||' propietarios que no existen en MIG_APC_PROP_CABECERA.');
        DBMS_OUTPUT.PUT_LINE('- Puede ver estos registros con la siguiente consulta: ');
        DBMS_OUTPUT.PUT_LINE('SELECT * FROM '||TABLA_MIG||' WHERE PRO_CODIGO_UVEM NOT IN ( SELECT PRO_CODIGO_UVEM FROM MIG_APC_PROP_CABECERA );');
        VAR2 := VAR2 - VAR1;
        DBMS_OUTPUT.PUT_LINE('  '||VAR2||' si existen en MIG_APC_PROP_CABECERA.');
        DBMS_OUTPUT.PUT_LINE('');
      
      END IF;
      
    END IF;
    
    
-------- BUSCAMOS PVE_COD_UVEM DUPLICADOS ENTRE LAS SIGUIENTES TABLAS : ---------
-------- MIG_APR_PROVEEDORES -----------------------------------------------


  DBMS_OUTPUT.PUT_LINE('[INFO] [PVE_COD_UVEM DUPLICADOS]');
  DBMS_OUTPUT.PUT_LINE('');
  
    TABLA_MIG := 'MIG_APR_PROVEEDORES';
  
    SENTENCIA := '
    SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
    WHERE MIG.PVE_COD_UVEM IS NOT NULL
    '
    ;
    EXECUTE IMMEDIATE SENTENCIA INTO VAR1;
  
    SENTENCIA := '
    SELECT COUNT(DISTINCT(PVE_COD_UVEM)) FROM '||V_ESQUEMA||'.'||TABLA_MIG||' MIG
    WHERE MIG.PVE_COD_UVEM IS NOT NULL
    '
    ;
    EXECUTE IMMEDIATE SENTENCIA INTO VAR2;
    
    VAR3 := VAR1-VAR2;
    
    IF VAR3 = 0 THEN
    
      DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
      DBMS_OUTPUT.PUT_LINE('- No hay registros duplicados.');
      DBMS_OUTPUT.PUT_LINE('');
    
    ELSE
    
      DBMS_OUTPUT.PUT_LINE('['||TABLA_MIG||'].');
      DBMS_OUTPUT.PUT_LINE('- Hay '||VAR3||' registros duplicados de un total de '||VAR1||' registros.');
      DBMS_OUTPUT.PUT_LINE('- Puede ver estos registros con la siguiente consulta: ');
      DBMS_OUTPUT.PUT_LINE('SELECT PVE_COD_UVEM, COUNT(*) VECES_REPETIDO FROM '||TABLA_MIG||' GROUP BY PVE_COD_UVEM HAVING COUNT(*) > 1;');
      DBMS_OUTPUT.PUT_LINE('');
    
    END IF;
    
    
  DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBACIONES VARIAS.');
	DBMS_OUTPUT.PUT_LINE('');
  

--01---- COMPROBACION PUNTUAL EN MIG_AEP_ENTIDAD_PROVEEDOR, MIG_ASA_SUBDIVISIONES_AGRUP -------------------------------------
-------- COMPROBAMOS QUE NO EXISTEN CAMPOS NULL EN LAS SIGUIENTES TABLAS, YA QUE ES REQUERIDO EN EL DESTINO REM : -----------


  DBMS_OUTPUT.PUT_LINE('  [01] [EXISTENCIA DE CAMPOS NULLS EN CAMPOS REQUERIDOS EN REM]');
  DBMS_OUTPUT.PUT_LINE('');

  EXECUTE IMMEDIATE '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.MIG_AEP_ENTIDAD_PROVEEDOR WHERE ENTIDAD_PROPIETARIA IS NULL
  '
  INTO VAR1
  ;
  
  IF VAR1 != 0 THEN
  
    EXECUTE IMMEDIATE '
    SELECT COUNT(1) FROM '||V_ESQUEMA||'.MIG_ASA_SUBDIVISIONES_AGRUP
    '
    INTO VAR2
    ;
  
    DBMS_OUTPUT.PUT_LINE('  [01.1][KO] [MIG_AEP_ENTIDAD_PROVEEDOR] - Existen '||VAR1||' de '||VAR2||' valores nulos, estos registros no se migrarán. ENTIDAD_PROPIETARIA.');
    DBMS_OUTPUT.PUT_LINE('');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('  [01.1][OK] [MIG_AEP_ENTIDAD_PROVEEDOR] - No existen valores nulos. ENTIDAD_PROPIETARIA.');
    DBMS_OUTPUT.PUT_LINE('');
    
  END IF;
  
  EXECUTE IMMEDIATE '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.MIG_ASA_SUBDIVISIONES_AGRUP WHERE TIPO_SUBDIVISION IS NULL
  '
  INTO VAR1
  ;
  
  IF VAR1 != 0 THEN
  
    EXECUTE IMMEDIATE '
    SELECT COUNT(1) FROM '||V_ESQUEMA||'.MIG_ASA_SUBDIVISIONES_AGRUP
    '
    INTO VAR2
    ;
  
    DBMS_OUTPUT.PUT_LINE('  [01.2][KO] [MIG_ASA_SUBDIVISIONES_AGRUP] - Existen '||VAR1||' de '||VAR2||' valores nulos, estos registros no se migrarán. TIPO_SUBDIVISION.');
    DBMS_OUTPUT.PUT_LINE('');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('  [01.2][OK] [MIG_ASA_SUBDIVISIONES_AGRUP] - No existen valores nulos. TIPO_SUBDIVISION.');
    DBMS_OUTPUT.PUT_LINE('');
    
  END IF;
  

--02---- COMPROBACION PUNTUAL EN MIG_ACA_CABECERA -----------------------------------------------------------
-------- SI ENTIDAD_PROPIETARIA ES 02 (UVEM) TIENE QUE VENIR INFORMADO EL CAMPO ACT_NUMERO_UVEM -------------


  EXECUTE IMMEDIATE '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.MIG_ACA_CABECERA WHERE ENTIDAD_PROPIETARIA = 02 AND ACT_NUMERO_UVEM IS NULL
  '
  INTO VAR1
  ;
  
  IF VAR1 != 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[02][KO] Existen '||VAR1||' registros en MIG_ACA_CABECERA con ENTIDAD_PROPIETARIA = 02 y el campo ACT_NUMERO_UVEM no informado.');
    DBMS_OUTPUT.PUT_LINE('');
        
  ELSE 
  
    DBMS_OUTPUT.PUT_LINE('[02][OK] Todos los registros en MIG_ACA_CABECERA con ENTIDAD_PROPIETARIA = 02 y el campo ACT_NUMERO_UVEM informados.');
    DBMS_OUTPUT.PUT_LINE('');
    
  END IF;
  
  
--03---- COMPROBACION PUNTUAL EN MIG_ATR_TRABAJO -----------------------------------------------------------
-------- SI VIENE INFORMADO AGR_UVEM, NO DEBE VENIR INFORMADO ACT_NUMERO_ACTIVO ----------------------------


  EXECUTE IMMEDIATE '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.MIG_ATR_TRABAJO WHERE ACT_NUMERO_ACTIVO != 0 AND AGR_UVEM != 0
  '
  INTO VAR1
  ;
  
  IF VAR1 != 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[03][KO] Existen '||VAR1||' registros en MIG_ATR_TRABAJO con ACT_NUMERO_ACTIVO y AGR_UVEM informados a la vez.');
    DBMS_OUTPUT.PUT_LINE('');
        
  ELSE 
  
    DBMS_OUTPUT.PUT_LINE('[03][OK] Todos los registros en MIG_ATR_TRABAJO con ACT_NUMERO_ACTIVO y AGR_UVEM informados por separado.');
    DBMS_OUTPUT.PUT_LINE('');
    
  END IF;
  
  
--04---- COMPROBACION PUNTUAL EN MIG_AAG_AGRUPACIONES ------------------------------------------------------
-------- COMPROBAMOS QUE EXISTEN LOS MEDIADORES, EN PROVEEDORES, TIPO PROVEEDOR 04 -------------------------

  
  DBMS_OUTPUT.PUT_LINE('  [04] [EXISTENCIA DE MEDIADORES INFORMADOS DESDE MIG_AAG_AGRUPACIONES EN MIG_APR_PROVEEDORES Y ACT_PVE_PROVEEDOR');
  DBMS_OUTPUT.PUT_LINE('');
  
  EXECUTE IMMEDIATE '
  WITH AUX AS (
  SELECT DD_TPR_CODIGO 
  FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR DD
  INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
    ON PVE.DD_TPR_ID = DD.DD_TPR_ID
  )
  SELECT COUNT(DISTINCT AAG.AGR_MEDIADOR)
  FROM '||V_ESQUEMA||'.MIG_AAG_AGRUPACIONES AAG
  LEFT JOIN AUX
   ON AUX.DD_TPR_CODIGO = AAG.AGR_MEDIADOR
  LEFT JOIN '||V_ESQUEMA||'.MIG_APR_PROVEEDORES APR
    ON APR.TIPO_PROVEEDOR = AAG.AGR_MEDIADOR
  WHERE AAG.AGR_MEDIADOR IS NOT NULL
  AND AUX.DD_TPR_CODIGO IS NULL
  AND APR.TIPO_PROVEEDOR IS NULL
  '
  INTO VAR1
  ;
  
  EXECUTE IMMEDIATE '
  SELECT count(DISTINCT AGR_MEDIADOR) FROM '||V_ESQUEMA||'.MIG_AAG_AGRUPACIONES WHERE AGR_MEDIADOR IS NOT NULL
  '
  INTO VAR2
  ;

  IF VAR1 != 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('  [04.1][KO] Existen '||VAR1||' de '||VAR2||' mediadores informados en MIG_AAG_AGRUPACIONES que no existen en ACT_PVE_PROVEEDOR ni vienen informados en MIG_APR_PROVEEDORES. Sin contar nulos.');
    DBMS_OUTPUT.PUT_LINE('');
    
  ELSE 
  
    DBMS_OUTPUT.PUT_LINE('  [04.1][OK] Todos los mediadores ('||VAR2||') informados en MIG_AAG_AGRUPACIONES son aprovisionados en ACT_PVE_PROVEEDOR o en MIG_APR_PROVEEDORES. Sin contar nulos.');
    DBMS_OUTPUT.PUT_LINE('');
    
  END IF;
  
  
--05---- COMPROBACION DUPLICADOS EN MIG_ATR_TRABAJO ------------------------------------------------------
-------- COMPROBAMOS QUE NO EXISTA MAS DE UNA FILA CON EL MISMO ACT_NUMERO_ACTIVO-TBJ_NUM_TRABAJO --------


  EXECUTE IMMEDIATE '
  SELECT COUNT(1) FROM (
  SELECT DISTINCT TBJ_NUM_TRABAJO, ACT_NUMERO_ACTIVO FROM MIG_ATR_TRABAJO GROUP BY(TBJ_NUM_TRABAJO, ACT_NUMERO_ACTIVO) HAVING COUNT(*) >1
  )
  '
  INTO VAR1
  ;
  
  IF VAR1 != 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[05][KO] Hay '||VAR1||' claves unicas ACT_NUMERO_ACTIVO-TBJ_NUM_TRABAJO duplicadas en MIG_ATR_TRABAJO.');
    DBMS_OUTPUT.PUT_LINE('- Puede ver estos registros con la siguiente consulta: ');
    DBMS_OUTPUT.PUT_LINE('SELECT DISTINCT TBJ_NUM_TRABAJO, ACT_NUMERO_ACTIVO FROM MIG_ATR_TRABAJO GROUP BY(TBJ_NUM_TRABAJO, ACT_NUMERO_ACTIVO) HAVING COUNT(*) >1;');
    DBMS_OUTPUT.PUT_LINE('');
    
  ELSE 
  
    DBMS_OUTPUT.PUT_LINE('[05][OK] Todas las parejas ACT_NUMERO_ACTIVO-TBJ_NUM_TRABAJO (clave única) existentes en MIG_ATR_TRABAJO son únicas.');
    DBMS_OUTPUT.PUT_LINE('');
    
  END IF;
  
  
--06---- COMPROBACION DUPLICADOS EN MIG_APL_PLANDINVENTAS ------------------------------------------------------
-------- COMPROBAMOS QUE NO EXISTA MAS DE UNA FILA CON EL MISMO ACT_NUMERO_ACTIVO-PDV_ACREEDOR_NUM_EXP ---------


  EXECUTE IMMEDIATE '
  SELECT COUNT(1) FROM (
  SELECT DISTINCT ACT_NUMERO_ACTIVO, PDV_ACREEDOR_NUM_EXP FROM MIG_APL_PLANDINVENTAS GROUP BY(ACT_NUMERO_ACTIVO, PDV_ACREEDOR_NUM_EXP) HAVING COUNT(*) >1
  )
  '
  INTO VAR1
  ;
  
  IF VAR1 != 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[06][KO] Hay '||VAR1||' claves unicas ACT_NUMERO_ACTIVO-PDV_ACREEDOR_NUM_EXP duplicadas en MIG_APL_PLANDINVENTAS.');
    DBMS_OUTPUT.PUT_LINE('- Puede ver estos registros con la siguiente consulta: ');
    DBMS_OUTPUT.PUT_LINE('SELECT DISTINCT ACT_NUMERO_ACTIVO, PDV_ACREEDOR_NUM_EXP FROM MIG_APL_PLANDINVENTAS GROUP BY(ACT_NUMERO_ACTIVO, PDV_ACREEDOR_NUM_EXP) HAVING COUNT(*) >1;');
    DBMS_OUTPUT.PUT_LINE('');
    
  ELSE 
  
    DBMS_OUTPUT.PUT_LINE('[06][OK] Todas las parejas ACT_NUMERO_ACTIVO-PDV_ACREEDOR_NUM_EXP (clave única) existentes en MIG_APL_PLANDINVENTAS son únicas.');
    DBMS_OUTPUT.PUT_LINE('');
    
  END IF;
  
  EXCEPTION
	
	WHEN OTHERS THEN
     
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(SQLERRM);

    ROLLBACK;
    RAISE;          
   
END;
/
