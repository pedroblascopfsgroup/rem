--/*
--######################################### 
--## AUTOR=David González
--## FECHA_CREACION=20160225
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-67B
--## PRODUCTO=NO
--## 
--## Finalidad: COMPROBACION DE DICCIONARIOS: Comprobamos que los codigos de diccionario que nos 
--##    										llegan en migracion existen en nuestros diccionarios
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(20 CHAR) := 'REMMASTER';
DESCRIPCION VARCHAR2(50 CHAR);
V_TABLA VARCHAR(30 CHAR) := 'MIG_AIA_INFOCOMERCIAL_ACTIVO';
FICHERO VARCHAR2(30 CHAR) := 'INFOCOMERCIAL_ACTIVO.dat';
SENTENCIA VARCHAR2(300 CHAR);
V_NUM NUMBER(10);
CAMPO VARCHAR2(30 CHAR);
DICCIONARIO VARCHAR2(30 CHAR);
COD_DICC VARCHAR2(30 CHAR);
CLAVE VARCHAR2(30 CHAR) := 'ACT_NUMERO_ACTIVO';

BEGIN

  SENTENCIA := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_COD_NOT_EXISTS'' AND OWNER = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE SENTENCIA INTO V_NUM;
  
  IF V_NUM = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[ERROR] NO EXISTE LA TABLA '||V_ESQUEMA||'.DD_COD_NOT_EXISTS. EJECUTAR DDL.');
  
  ELSE
  
  EXECUTE IMMEDIATE '
  DELETE FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS
  WHERE FICHERO_ORIGEN = '''||FICHERO||'''
  '
  ;
  
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] SE VA A PROCEDER A VALIDAR LOS CODIGOS DE DICCIONARIO.');
    
  --DD_UAC_UBICACION_ACTIVO--
  
  CAMPO := 'UBICACION_ACTIVO';
  DICCIONARIO := 'DD_UAC_UBICACION_ACTIVO';
  COD_DICC := 'DD_UAC_CODIGO';
  
  EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.DD_COD_NOT_EXISTS (
  SELECT 
  MIG.'||CLAVE||',
  '''||FICHERO||''',
  '''||CAMPO||''',
  '''||DICCIONARIO||''',
  MIG.'||CAMPO||',
  SYSDATE
  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG
  WHERE MIG.'||CAMPO||' NOT IN (
    SELECT '||COD_DICC||'
    FROM '||V_ESQUEMA||'.'||DICCIONARIO||'
  )
  AND MIG.'||CAMPO||' != ''UNDEFINED''
  )
  '
  ;
  
  COMMIT;
    
  --DD_ECT_ESTADO_CONSTRUCCION--
  
  CAMPO := 'ESTADO_CONSTRUCCION';
  DICCIONARIO := 'DD_ECT_ESTADO_CONSTRUCCION';
  COD_DICC := 'DD_ECT_CODIGO';
  
  EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.DD_COD_NOT_EXISTS (
  SELECT 
  MIG.'||CLAVE||',
  '''||FICHERO||''',
  '''||CAMPO||''',
  '''||DICCIONARIO||''',
  MIG.'||CAMPO||',
  SYSDATE
  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG
  WHERE MIG.'||CAMPO||' NOT IN (
    SELECT '||COD_DICC||'
    FROM '||V_ESQUEMA||'.'||DICCIONARIO||'
  )
  AND MIG.'||CAMPO||' != ''UNDEFINED''
  )
  '
  ;
  
  COMMIT;
    
  --DD_ECV_ESTADO_CONSERVACION--
  
  CAMPO := 'ESTADO_CONSERVACION';
  DICCIONARIO := 'DD_ECV_ESTADO_CONSERVACION';
  COD_DICC := 'DD_ECV_CODIGO';
  
  EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.DD_COD_NOT_EXISTS (
  SELECT 
  MIG.'||CLAVE||',
  '''||FICHERO||''',
  '''||CAMPO||''',
  '''||DICCIONARIO||''',
  MIG.'||CAMPO||',
  SYSDATE
  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG
  WHERE MIG.'||CAMPO||' NOT IN (
    SELECT '||COD_DICC||'
    FROM '||V_ESQUEMA||'.'||DICCIONARIO||'
  )
  AND MIG.'||CAMPO||' != ''UNDEFINED''
  )
  '
  ;
  
  COMMIT;
  
  --DD_TIC_TIPO_INFO_COMERCIAL--
  
  CAMPO := 'TIPO_INFO_COMERCIAL';
  DICCIONARIO := 'DD_TIC_TIPO_INFO_COMERCIAL';
  COD_DICC := 'DD_TIC_CODIGO';
  
  EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.DD_COD_NOT_EXISTS (
  SELECT 
  MIG.'||CLAVE||',
  '''||FICHERO||''',
  '''||CAMPO||''',
  '''||DICCIONARIO||''',
  MIG.'||CAMPO||',
  SYSDATE
  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG
  WHERE MIG.'||CAMPO||' NOT IN (
    SELECT '||COD_DICC||'
    FROM '||V_ESQUEMA||'.'||DICCIONARIO||'
  )
  AND MIG.'||CAMPO||' != ''UNDEFINED''
  )
  '
  ;
  
  --DD_ECV_ESTADO_CONSERVACION--
  
  CAMPO := 'ESTADO_CONSERVACION_EDIFICIO';
  DICCIONARIO := 'DD_ECV_ESTADO_CONSERVACION';
  COD_DICC := 'DD_ECV_CODIGO';
  
  EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.DD_COD_NOT_EXISTS (
  SELECT 
  MIG.'||CLAVE||',
  '''||FICHERO||''',
  '''||CAMPO||''',
  '''||DICCIONARIO||''',
  MIG.'||CAMPO||',
  SYSDATE
  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG
  WHERE MIG.'||CAMPO||' NOT IN (
    SELECT '||COD_DICC||'
    FROM '||V_ESQUEMA||'.'||DICCIONARIO||'
  )
  AND MIG.'||CAMPO||' != ''UNDEFINED''
  )
  '
  ;
  
  COMMIT;
  
  --DD_TPF_TIPO_FACHADA--
  
  CAMPO := 'TIPO_FACHADA_EDIFICIO';
  DICCIONARIO := 'DD_TPF_TIPO_FACHADA';
  COD_DICC := 'DD_TPF_CODIGO';
  
  EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.DD_COD_NOT_EXISTS (
  SELECT 
  MIG.'||CLAVE||',
  '''||FICHERO||''',
  '''||CAMPO||''',
  '''||DICCIONARIO||''',
  MIG.'||CAMPO||',
  SYSDATE
  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG
  WHERE MIG.'||CAMPO||' NOT IN (
    SELECT '||COD_DICC||'
    FROM '||V_ESQUEMA||'.'||DICCIONARIO||'
  )
  AND MIG.'||CAMPO||' != ''UNDEFINED''
  )
  '
  ;
  
  COMMIT;
  
  --DD_TPV_TIPO_VIVIENDA--
  
  CAMPO := 'TIPO_VIVIENDA';
  DICCIONARIO := 'DD_TPV_TIPO_VIVIENDA';
  COD_DICC := 'DD_TPV_CODIGO';
  
  EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.DD_COD_NOT_EXISTS (
  SELECT 
  MIG.'||CLAVE||',
  '''||FICHERO||''',
  '''||CAMPO||''',
  '''||DICCIONARIO||''',
  MIG.'||CAMPO||',
  SYSDATE
  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG
  WHERE MIG.'||CAMPO||' NOT IN (
    SELECT '||COD_DICC||'
    FROM '||V_ESQUEMA||'.'||DICCIONARIO||'
  )
  AND MIG.'||CAMPO||' != ''UNDEFINED''
  )
  '
  ;
  
  COMMIT;
  
  --DD_TPO_TIPO_ORIENTACION--
  
  CAMPO := 'TIPO_ORIENTACION';
  DICCIONARIO := 'DD_TPO_TIPO_ORIENTACION';
  COD_DICC := 'DD_TPO_CODIGO';
  
  EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.DD_COD_NOT_EXISTS (
  SELECT 
  MIG.'||CLAVE||',
  '''||FICHERO||''',
  '''||CAMPO||''',
  '''||DICCIONARIO||''',
  MIG.'||CAMPO||',
  SYSDATE
  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG
  WHERE MIG.'||CAMPO||' NOT IN (
    SELECT '||COD_DICC||'
    FROM '||V_ESQUEMA||'.'||DICCIONARIO||'
  )
  AND MIG.'||CAMPO||' != ''UNDEFINED''
  )
  '
  ;
  
  COMMIT;
  
  --DD_TPR_TIPO_RENTA--
  
  CAMPO := 'TIPO_RENTA';
  DICCIONARIO := 'DD_TPR_TIPO_RENTA';
  COD_DICC := 'DD_TPR_CODIGO';
  
  EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.DD_COD_NOT_EXISTS (
  SELECT 
  MIG.'||CLAVE||',
  '''||FICHERO||''',
  '''||CAMPO||''',
  '''||DICCIONARIO||''',
  MIG.'||CAMPO||',
  SYSDATE
  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG
  WHERE MIG.'||CAMPO||' NOT IN (
    SELECT '||COD_DICC||'
    FROM '||V_ESQUEMA||'.'||DICCIONARIO||'
  )
  AND MIG.'||CAMPO||' != ''UNDEFINED''
  )
  '
  ;
  
  COMMIT;
  
  --DD_TUA_TIPO_UBICA_APARCA--
  
  CAMPO := 'TIPO_UBICACION_APARCA';
  DICCIONARIO := 'DD_TUA_TIPO_UBICA_APARCA';
  COD_DICC := 'DD_TUA_CODIGO';
  
  EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.DD_COD_NOT_EXISTS (
  SELECT 
  MIG.'||CLAVE||',
  '''||FICHERO||''',
  '''||CAMPO||''',
  '''||DICCIONARIO||''',
  MIG.'||CAMPO||',
  SYSDATE
  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG
  WHERE MIG.'||CAMPO||' NOT IN (
    SELECT '||COD_DICC||'
    FROM '||V_ESQUEMA||'.'||DICCIONARIO||'
  )
  AND MIG.'||CAMPO||' != ''UNDEFINED''
  )
  '
  ;
  
  COMMIT;
  
  --DD_TCA_TIPO_CALIDAD--
  
  CAMPO := 'TIPO_CALIDAD';
  DICCIONARIO := 'DD_TCA_TIPO_CALIDAD';
  COD_DICC := 'DD_TCA_CODIGO';
  
  EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.DD_COD_NOT_EXISTS (
  SELECT 
  MIG.'||CLAVE||',
  '''||FICHERO||''',
  '''||CAMPO||''',
  '''||DICCIONARIO||''',
  MIG.'||CAMPO||',
  SYSDATE
  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG
  WHERE MIG.'||CAMPO||' NOT IN (
    SELECT '||COD_DICC||'
    FROM '||V_ESQUEMA||'.'||DICCIONARIO||'
  )
  AND MIG.'||CAMPO||' != ''UNDEFINED''
  )
  '
  ;
  
  COMMIT;
  
  DBMS_OUTPUT.put_line('[INFO] CHECKEO FINALIZADO.');
  
  EXECUTE IMMEDIATE '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS WHERE FICHERO_ORIGEN = '''||FICHERO||''''
  INTO V_NUM;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||V_NUM||' CÓDIGOS DE DICCIONARIO INEXISTENTES');
  
  END IF;
  
  -------
  
  EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
