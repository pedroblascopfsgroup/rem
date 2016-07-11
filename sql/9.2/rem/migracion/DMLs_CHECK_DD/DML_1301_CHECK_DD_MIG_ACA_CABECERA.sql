--/*
--######################################### 
--## AUTOR=David González
--## FECHA_CREACION=20160216
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

V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(20 CHAR) := '#ESQUEMA_MASTER#';
DESCRIPCION VARCHAR2(50 CHAR);
V_TABLA VARCHAR2(30 CHAR) := 'MIG_ACA_CABECERA';
FICHERO VARCHAR2(30 CHAR) := 'ACTIVO_CABECERA.dat';
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
  
    DBMS_OUTPUT.PUT_LINE('[ERROR] NO EXISTE LA TABLA HAYA01.DD_COD_NOT_EXISTS. EJECUTAR DDL.');
  
  ELSE
  
  EXECUTE IMMEDIATE '
  DELETE FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS
  WHERE FICHERO_ORIGEN = '''||FICHERO||'''
  '
  ;
  
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] SE VA A PROCEDER A VALIDAR LOS CODIGOS DE DICCIONARIO.');
    
  --DD_RTG_RATING_ACTIVO--
  
  CAMPO := 'ACT_RATING';
  DICCIONARIO := 'DD_RTG_RATING_ACTIVO';
  COD_DICC := 'DD_RTG_CODIGO';
  
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
  
  -------
  
  --DD_TPA_TIPO_ACTIVO--
  
  CAMPO := 'TIPO_ACTIVO';
  DICCIONARIO := 'DD_TPA_TIPO_ACTIVO';
  COD_DICC := 'DD_TPA_CODIGO';
  
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
  
  -------
  
  --DD_SAC_SUBTIPO_ACTIVO--
  
  CAMPO := 'SUBTIPO_ACTIVO';
  DICCIONARIO := 'DD_SAC_SUBTIPO_ACTIVO';
  COD_DICC := 'DD_SAC_CODIGO';
  
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
  
  -------
  
  --DD_EAC_ESTADO_ACTIVO--
  
  CAMPO := 'ESTADO_ACTIVO';
  DICCIONARIO := 'DD_EAC_ESTADO_ACTIVO';
  COD_DICC := 'DD_EAC_CODIGO';
  
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
  
  -------
  
  --DD_TUD_TIPO_USO_DESTINO--
  
  CAMPO := 'USO_ACTIVO';
  DICCIONARIO := 'DD_TUD_TIPO_USO_DESTINO';
  COD_DICC := 'DD_TUD_CODIGO';
  
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
  
  -------
  
  --DD_TTA_TIPO_TITULO_ACTIVO--
  
  CAMPO := 'TIPO_TITULO';
  DICCIONARIO := 'DD_TTA_TIPO_TITULO_ACTIVO';
  COD_DICC := 'DD_TTA_CODIGO';
  
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
  
  -------
  
  --DD_STA_SUBTIPO_TITULO_ACTIVO--
  
  CAMPO := 'SUBTIPO_TITULO';
  DICCIONARIO := 'DD_STA_SUBTIPO_TITULO_ACTIVO';
  COD_DICC := 'DD_STA_CODIGO';
  
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
  
  -------
  
  --DD_CRA_CARTERA--
  
  CAMPO := 'ENTIDAD_PROPIETARIA';
  DICCIONARIO := 'DD_CRA_CARTERA';
  COD_DICC := 'DD_CRA_CODIGO';
  
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
  
  -------
  
  --DD_ENO_ENTIDAD_ORIGEN--
  
  CAMPO := 'ENTIDAD_ORIGEN';
  DICCIONARIO := 'DD_ENO_ENTIDAD_ORIGEN';
  COD_DICC := 'DD_ENO_CODIGO';
  
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
  
  -------
  
  --DD_ENO_ENTIDAD_ORIGEN (ENTIDAD_ORIGEN_ANTERIOR)--
  
  /*CAMPO := 'ENTIDAD_ORIGEN_ANTERIOR';
  DICCIONARIO := 'DD_ENO_ENTIDAD_ORIGEN';
  COD_DICC := 'DD_ENO_CODIGO';
  
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
  
  COMMIT;*/
  
  --DD_SCM_SITUACION_COMERCIAL--
  
  CAMPO := 'SITUACION_COMERCIAL';
  DICCIONARIO := 'DD_SCM_SITUACION_COMERCIAL';
  COD_DICC := 'DD_SCM_CODIGO';
  
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
