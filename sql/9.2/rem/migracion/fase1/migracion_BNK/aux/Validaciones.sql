############################################
### VALIDACIÓNES DE DATOS PARA MIGRACIÓN ###
############################################

DECLARE

VAR1 NUMBER(10);
VAR2 NUMBER(10);
VAR3 NUMBER(10);
TABLA_MIG VARCHAR2(30 CHAR);
TABLA_REM VARCHAR2(30 CHAR);
SENTENCIA VARCHAR2(500 CHAR);

BEGIN

-------- DUPLICADOS MIG_ACT_ACTIVOS ---------

  DBMS_OUTPUT.PUT_LINE('[INFO] [DUPLICADOS MIG_ACT_ACTIVOS]');

  TABLA_MIG := 'MIG_ACA_CABECERA';
  
  SENTENCIA := '
  SELECT COUNT(1) FROM '||TABLA_MIG||'
  '
  ;
  EXECUTE IMMEDIATE SENTENCIA INTO VAR1;
  
  SENTENCIA := '
  SELECT COUNT(DISTINCT(ACT_NUMERO_ACTIVO)) FROM '||TABLA_MIG||'
  '
  ;
  EXECUTE IMMEDIATE SENTENCIA INTO VAR2;
  
  VAR3 := VAR1-VAR2;
  
  IF VAR3 <= 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] No hay registros duplicados.');
    DBMS_OUTPUT.PUT_LINE('');
  
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('[INFO] Hay '||VAR3||' registros duplicados de un total de '||VAR1||' registros.');
    DBMS_OUTPUT.PUT_LINE('');
  
  END IF;

-------- INTEGRIDAD MIG_ACT_ACTIVOS <> ACT_ACTIVO ---------

  DBMS_OUTPUT.PUT_LINE('[INFO] [INTEGRIDAD MIG_ACT_ACTIVOS <> ACT_ACTIVO]');

  TABLA_REM := 'ACT_ACTIVO';
  TABLA_MIG := 'MIG_ACA_CABECERA';
  
  SENTENCIA := '
  SELECT COUNT(1) FROM '||TABLA_REM||'
  '
  ;
  EXECUTE IMMEDIATE SENTENCIA INTO VAR1;
  
  SENTENCIA := '
  SELECT COUNT(1) FROM '||TABLA_MIG||'
  '
  ;
  EXECUTE IMMEDIATE SENTENCIA INTO VAR2;
  
  VAR3 := VAR1-VAR2;
  
  IF VAR3 = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] El número de registros en ambas tablas es coincidente.');
  
  ELSE 
  IF VAR3 < 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] Hay '||VAR3||' registros más en '||TABLA_MIG||' que en '||TABLA_REM||'.');
    
  ELSE
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Hay '||VAR3||' registros más en '||TABLA_REM||' que en '||TABLA_MIG||'.');
    
  END IF;
  END IF;
  
  SENTENCIA := '
  SELECT COUNT(1)
  FROM '||TABLA_MIG||' MIG
  INNER JOIN '||TABLA_REM||' REM
  ON MIG.ACT_NUMERO_ACTIVO = REM.ACT_NUM_ACTIVO
  '
  ;
  EXECUTE IMMEDIATE SENTENCIA INTO VAR3;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||VAR3||'/'||VAR2||' Registros coincidentes entre '||TABLA_REM||' Y '||TABLA_MIG||'. (INNER JOIN). Registros '||TABLA_REM||' -> '||VAR1||', Registros '||TABLA_MIG||' -> '||VAR2||'.');
    DBMS_OUTPUT.PUT_LINE('');
    	
    
END;
/
