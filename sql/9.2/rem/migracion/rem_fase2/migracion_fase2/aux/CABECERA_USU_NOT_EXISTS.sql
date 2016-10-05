      --COMPROBACIONES PREVIAS - USUARIOS
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO USUARIOS...');
      
      V_SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
        SELECT 1 FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = MIG2.CLC_COD_USUARIO_LDAP_ACCION
      )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
      
      IF TABLE_COUNT = 0 THEN
      
          DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS USUARIOS EXISTEN EN REMMASTER.USU_USUARIOS');
      
      ELSE
      
          DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' USUARIOS INEXISTENTES EN USU_USUARIO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_USU_NOT_EXISTS.');
          
          --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
          
          EXECUTE IMMEDIATE '
          DELETE FROM '||V_ESQUEMA||'.MIG2_USU_NOT_EXISTS
          WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
          '
          ;
          
          COMMIT;
          
          EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.MIG2_USU_NOT_EXISTS (
            TABLA_MIG,
            USU_USERNAME,            
            FECHA_COMPROBACION
          )
          WITH USERNAME_NOT_EXISTS AS (
            SELECT DISTINCT MIG2.CLC_COD_USUARIO_LDAP_ACCION 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
              SELECT 1 
              FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU
              WHERE MIG2.CLC_COD_USUARIO_LDAP_ACCION = USU.USU_USERNAME
            )
          )
          SELECT DISTINCT
          '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
          MIG2.CLC_COD_USUARIO_LDAP_ACCION    						      OFA_COD_OFERTA,          
          SYSDATE                                                                 FECHA_COMPROBACION
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2  
          INNER JOIN USERNAME_NOT_EXISTS ON USERNAME_NOT_EXISTS.CLC_COD_USUARIO_LDAP_ACCION = MIG2.CLC_COD_USUARIO_LDAP_ACCION
          '
          ;
          
          COMMIT;      
      
      END IF;
