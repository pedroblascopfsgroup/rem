      --COMPROBACIONES PREVIAS - ACT_TBJ_TRABAJO
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO ACT_TBJ_TRABAJO...');
      
      V_SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
        SELECT 1 
        FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ 
        WHERE TBJ.TBJ_NUM_TRABAJO = MIG2.GPT_TBJ_NUM_TRABAJO
      )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
      
      IF TABLE_COUNT = 0 THEN
      
          DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS TBJ_NUM_TRABAJO EXISTEN EN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO');
      
      ELSE
      
          DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' TBJ_NUM_TRABAJO INEXISTENTES EN ACT_TBJ_TRABAJO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_TBJ_NOT_EXISTS.');
          
          --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
          
          EXECUTE IMMEDIATE '
          DELETE FROM '||V_ESQUEMA||'.MIG2_TBJ_NOT_EXISTS
          WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
          '
          ;
          
          COMMIT;
          
          EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.MIG2_TBJ_NOT_EXISTS (
            TABLA_MIG,
            TBJ_NUM_TRABAJO,            
            FECHA_COMPROBACION
          )
          WITH NOT_EXISTS AS (
            SELECT DISTINCT MIG2.GPT_TBJ_NUM_TRABAJO 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
              SELECT 1 
              FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
              WHERE MIG2.GPT_TBJ_NUM_TRABAJO = TBJ.TBJ_NUM_TRABAJO
            )
          )
          SELECT DISTINCT
          '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
          MIG2.GPT_TBJ_NUM_TRABAJO    						      TBJ_NUM_TRABAJO,          
          SYSDATE                                                                 FECHA_COMPROBACION
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2  
          INNER JOIN NOT_EXISTS ON NOT_EXISTS.GPT_TBJ_NUM_TRABAJO = MIG2.GPT_TBJ_NUM_TRABAJO
          '
          ;
          
          COMMIT;      
      
      END IF;

