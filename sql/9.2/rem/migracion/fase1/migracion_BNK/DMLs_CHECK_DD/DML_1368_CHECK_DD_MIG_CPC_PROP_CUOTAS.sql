--/*
--######################################### 
--## AUTOR=CLV
--## FECHA_CREACION=201600803
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-719
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
V_TABLA VARCHAR(30 CHAR) := 'MIG_CPC_PROP_CUOTAS_BNK';
FICHERO VARCHAR2(30 CHAR) := 'COM_PROPIETARIOS_CUOTA.dat';
SENTENCIA VARCHAR2(300 CHAR);
V_NUM NUMBER(10);
CAMPO VARCHAR2(30 CHAR);
DICCIONARIO VARCHAR2(30 CHAR);
COD_DICC VARCHAR2(30 CHAR);
CLAVE VARCHAR2(30 CHAR) := 'CPR_COD_COM_PROP_UVEM';

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
    
  --DD_TPC_TIPO_CUOTA--
  
  CAMPO := 'TIPO_CUOTA';
  DICCIONARIO := 'DD_TPC_TIPO_CUOTA';
  COD_DICC := 'DD_TPC_CODIGO';
  
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
