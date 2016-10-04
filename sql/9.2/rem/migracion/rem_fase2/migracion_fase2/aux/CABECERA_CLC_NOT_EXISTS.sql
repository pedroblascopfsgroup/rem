--CABECERA CLC_WEBCOM_ID

	  --COMPROBACIONES PREVIAS - CLIENTE_COMERCIAL (CLC_WEBCOM_ID)
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO CLIENTE_COMERCIAL...');
      
      V_SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
        SELECT 1 
        FROM '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC 
        WHERE CLC.CLC_WEBCOM_ID = MIG2.VIS_COD_CLIENTE_WEBCOM
      )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
      
      IF TABLE_COUNT = 0 THEN
      
          DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS CLIENTE_COMERCIAL EXISTEN EN '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL');
      
      ELSE
      
          DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' CLIENTE_COMERCIAL INEXISTENTES EN CLC_CLIENTE_COMERCIAL. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_CLC_NOT_EXISTS.');
          
          --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
          
          EXECUTE IMMEDIATE '
          DELETE FROM '||V_ESQUEMA||'.MIG2_CLC_NOT_EXISTS
          WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
          '
          ;
          
          COMMIT;
          
          EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.MIG2_CLC_NOT_EXISTS (
            TABLA_MIG,
            CODIGO_RECHAZADO,
            CAMPO_RECHAZO,            
            FECHA_COMPROBACION
          )
          WITH NOT_EXISTS AS (
            SELECT DISTINCT MIG2.VIS_COD_CLIENTE_WEBCOM 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
              SELECT 1 
              FROM '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC
              WHERE MIG2.VIS_COD_CLIENTE_WEBCOM = CLC.CLC_WEBCOM_ID
            )
          )
          SELECT DISTINCT
          '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
          MIG2.VIS_COD_CLIENTE_WEBCOM                                             CODIGO_RECHAZADO,
          ''CLC_WEBCOM_ID''         		                                      CAMPO_RECHAZO,
          SYSDATE                                                                 FECHA_COMPROBACION
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2  
          INNER JOIN NOT_EXISTS ON NOT_EXISTS.VIS_COD_CLIENTE_WEBCOM = MIG2.VIS_COD_CLIENTE_WEBCOM
          '
          ;
          
          COMMIT;      
      
      END IF;
