    --COMPROBACIONES PREVIAS - TIPO PRECIO
    DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO TIPO PRECIO...');
    
    V_SENTENCIA := '
        SELECT COUNT(1) 
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
        WHERE NOT EXISTS (
          SELECT 1 
          FROM '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO DD 
          WHERE DD.DD_TPC_CODIGO = MIG2.HVA_COD_TIPO_PRECIO
    )
    '
    ;
    EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_2;
    
    IF TABLE_COUNT_2 = 0 THEN    
        DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS TIPOS DE PRECIO EXISTEN EN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO');    
    ELSE
    
        DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_2||' TIPOS DE PRECIO INEXISTENTES EN DD_TPC_TIPO_PRECIO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS.');
        
        --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
        
        EXECUTE IMMEDIATE '
        DELETE FROM '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS
        WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
        '
        ;
        
        COMMIT;
        
        EXECUTE IMMEDIATE '
        INSERT INTO '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS (
              CLAVE           ,  
              TABLA_MIG  , 
              CAMPO_ORIGEN    ,
              DICCIONARIO     ,
              VALOR           ,
              FECHA_COMPROBACION

        )
              SELECT
                      HVA_ACT_NUMERO_ACTIVO,
                      '''||V_TABLA_MIG||''',
                      ''HVA_COD_TIPO_PRECIO'',
                      ''DD_TPC_TIPO_PRECIO'',
                      HVA_COD_TIPO_PRECIO,
                      SYSDATE
              FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
                    WHERE NOT EXISTS (
                      SELECT 1 
                      FROM '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO DD 
                      WHERE DD.DD_TPC_CODIGO = MIG2.HVA_COD_TIPO_PRECIO
              )'
        ;
        
        V_COD := SQL%ROWCOUNT;
        
        COMMIT;      
    
    END IF;
