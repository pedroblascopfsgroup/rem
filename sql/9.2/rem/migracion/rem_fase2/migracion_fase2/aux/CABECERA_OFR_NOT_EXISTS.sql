--COMPROBACIONES PREVIAS - OFERTAS
  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO OFERTAS...');
  
  V_SENTENCIA := '
  SELECT COUNT(OFA_COD_OFERTA) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR WHERE OFR.OFR_NUM_OFERTA = MIG.OFA_COD_OFERTA
  )
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_2;
  
  IF TABLE_COUNT_2 = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] TODAS LAS OFERTAS EXISTEN EN OFR_OFERTAS');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_2||' OFERTAS INEXISTENTES EN OFR_OFERTAS. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_OFR_NOT_EXISTS.');
    
    --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
    
    EXECUTE IMMEDIATE '
    DELETE FROM '||V_ESQUEMA||'.MIG2_OFR_NOT_EXISTS
    WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
    '
    ;
    
    COMMIT;
  
    EXECUTE IMMEDIATE '
    INSERT INTO '||V_ESQUEMA||'.MIG2_OFR_NOT_EXISTS (
    OFR_NUM_OFERTA,
    TABLA_MIG,
    FECHA_COMPROBACION
    )
    WITH OFR_NUM_OFERTA AS (
		SELECT
		MIG.OFA_COD_OFERTA 
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
		WHERE NOT EXISTS (
		  SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE MIG.OFA_COD_OFERTA = OFR_NUM_OFERTA
		)
    )
    SELECT DISTINCT
    MIG.OFA_COD_OFERTA                              						OFA_COD_OFERTA,
    '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
    SYSDATE                                                                 FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN OFR_NUM_OFERTA
    ON OFR_NUM_OFERTA.OFA_COD_OFERTA = MIG.OFA_COD_OFERTA
    '
    ;
    
    COMMIT;

  END IF;
