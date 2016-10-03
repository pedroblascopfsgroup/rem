      --COMPROBACIONES PREVIAS - EJERCICIO
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO EJERCICIO...');
      
      V_SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
        SELECT 1 
        FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE 
        WHERE EJE.EJE_ANYO = MIG2.GIC_EJERCICIO
      )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
      
      IF TABLE_COUNT = 0 THEN
      
          DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS EJERCICIOS EXISTEN EN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO');
      
      ELSE
      
          DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' EJERCICIOS INEXISTENTES EN ACT_EJE_EJERCICIO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_EJE_NOT_EXISTS.');
          
          --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
          
          EXECUTE IMMEDIATE '
          DELETE FROM '||V_ESQUEMA||'.MIG2_EJE_NOT_EXISTS
          WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
          '
          ;
          
          COMMIT;
          
          EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.MIG2_EJE_NOT_EXISTS (
            TABLA_MIG,
            EJE_ANYO,            
            FECHA_COMPROBACION
          )
          WITH NOT_EXISTS AS (
            SELECT DISTINCT MIG2.GIC_EJERCICIO 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
              SELECT 1 
              FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE
              WHERE MIG2.GIC_EJERCICIO = EJE.EJE_ANYO
            )
          )
          SELECT DISTINCT
          '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
          MIG2.GIC_EJERCICIO                                						      EJE_ANYO,          
          SYSDATE                                                                 FECHA_COMPROBACION
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2  
          INNER JOIN NOT_EXISTS ON NOT_EXISTS.GIC_EJERCICIO = MIG2.GIC_EJERCICIO
          '
          ;
          
          COMMIT;      
      
      END IF;
