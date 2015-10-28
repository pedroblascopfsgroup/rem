delete from minirec.rcv_gest_persona_litigio;
commit;

INSERT INTO minirec.RCV_GEST_PERSONA_LITIGIO
SELECT DISTINCT GUI.ID_PERSONA_RCV AS ID_PERSONA_RCV
     , GUI.NUMERO_PERSONA AS NUMERO_PERSONA
     , DECODE(TDI.DD_TDI_CODIGO
             ,'1','D'
             ,'2','C'
             ,'3','T'
             ,'4','P'
             ,'5','E'
             ,'7','F'
             ,'8','I'
             ,'9','M'
             ,'J','J'
             ,'F','N'
             ,'P','S'
             ,'N') AS TIPO_DOC
     , PER.PER_DOC_ID AS DOCUMENTO
     , NVL(PER.PER_NOM50,'Nombre Tit. Exp.') AS NOMBRE 
FROM MINIREC.RCV_GEST_PERSONA_PDM GUI
   , BANK01.DD_TDI_TIPO_DOCUMENTO_ID TDI
   , BANK01.PER_PERSONAS PER
WHERE GUI.ID_PERSONA_RCV = PER.PER_ID
  AND PER.DD_TDI_ID = TDI.DD_TDI_ID;
  
COMMIT;
