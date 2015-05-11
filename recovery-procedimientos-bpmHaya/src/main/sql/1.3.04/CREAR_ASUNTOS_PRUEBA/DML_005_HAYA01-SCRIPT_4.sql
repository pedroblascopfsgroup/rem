
/*  PEX_PASE   */ 

 
  DECLARE                    
                     
 CURSOR EXPEDIENTES IS
SELECT DISTINCT EXP_ID FROM PEX_PERSONAS_EXPEDIENTE WHERE USUARIOCREAR = 'CONVIVE_F2';
                      
TYPE t_expedientes_exp IS TABLE OF EXPEDIENTES%ROWTYPE INDEX BY BINARY_INTEGER;
	l_expedientes_exp t_expedientes_exp;
  
	  C_DESCRIPCION VARCHAR2(30 CHAR);
    C_USUARIOCREAR VARCHAR2(10 CHAR);
    C_FECHA_HASTA DATE;

  BEGIN
  INSERT INTO TMP_EXP_CONV SELECT  PER_ID, EXP_ID FROM PEX_PERSONAS_EXPEDIENTE WHERE USUARIOCREAR = 'CONVIVE_F2';
  OPEN EXPEDIENTES;
  FETCH EXPEDIENTES BULK COLLECT INTO l_expedientes_exp;
  CLOSE EXPEDIENTES;
  
  IF l_expedientes_exp.COUNT>0 THEN

                  
            
      FORALL indx IN 1..l_expedientes_exp.COUNT 
               
            MERGE INTO PEX_PERSONAS_EXPEDIENTE PEX1
            USING(
            SELECT * FROM (
SELECT TMP_EXP_CONV.EXP_ID, PER.PER_ID,
        ROW_NUMBER () OVER (PARTITION BY  TMP_EXP_CONV.EXP_ID ORDER BY TMP_EXP_CONV.EXP_ID DESC) RN
            FROM CNV_TMP_PER_ID PER
            INNER JOIN TMP_EXP_CONV ON PER.PER_ID = TMP_EXP_CONV.PER_ID
            INNER JOIN CPE_CONTRATOS_PERSONAS CPE ON PER.PER_ID = CPE.PER_ID
            INNER JOIN DD_TIN_TIPO_INTERVENCION TIN ON TIN.DD_TIN_ID = CPE.DD_TIN_ID
            INNER JOIN PER_PERSONAS PERSONAS ON PERSONAS.PER_ID = CPE.PER_ID
            WHERE CPE.CNT_ID IN (SELECT CEX.CNT_ID FROM CEX_CONTRATOS_EXPEDIENTE CEX INNER JOIN TMP_EXP_CONV ON TMP_EXP_CONV.EXP_ID = CEX.EXP_ID)
            AND TIN.DD_TIN_TITULAR = 1
            AND PER_DEUDA_IRREGULAR_DIR = (SELECT MIN(PER_DEUDA_IRREGULAR_DIR) 
                                            FROM PER_PERSONAS 
                                            WHERE PER_ID IN (SELECT PER_ID 
                                                              FROM CPE_CONTRATOS_PERSONAS
                                                              WHERE CNT_ID IN (SELECT CNT_ID FROM CEX_CONTRATOS_EXPEDIENTE 
                                                                              WHERE EXP_ID = l_expedientes_exp(indx).EXP_ID)))
            AND CPE.CPE_ORDEN = (SELECT MIN(cpe2.CPE_ORDEN) 
                                FROM CPE_CONTRATOS_PERSONAS cpe2
                                WHERE CNT_ID IN (SELECT CNT_ID FROM CEX_CONTRATOS_EXPEDIENTE 
                                                                              WHERE EXP_ID = l_expedientes_exp(indx).EXP_ID))
               GROUP BY CPE.CPE_ORDEN,TMP_EXP_CONV.EXP_ID,PER.PER_ID, CPE.CNT_ID,  PERSONAS.PER_DEUDA_IRREGULAR_DIR ) TMP
WHERE TMP.RN = 1
            ) ORIGEN
                  ON (PEX1.PER_ID=ORIGEN.PER_ID AND PEX1.EXP_ID=ORIGEN.EXP_ID)
                  WHEN MATCHED THEN UPDATE
                  SET  PEX1.PEX_PASE = 1,
                 PEX1.FECHAMODIFICAR = TRUNC(SYSDATE);

  END IF;
  
  
  
  
  END;
  
  

  
  
 