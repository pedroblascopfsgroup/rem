ALTER TABLE 
   recovery_cm_dwh.h_prc 
ADD 
   (
      PROCURADOR_PRC_ID             NUMBER(16,0)
   );
  
  
ALTER TABLE 
   recovery_cm_dwh.h_prc_semana 
ADD 
   (
      PROCURADOR_PRC_ID             NUMBER(16,0)
   );
   
   
ALTER TABLE 
   recovery_cm_dwh.h_prc_mes 
ADD 
   (
      PROCURADOR_PRC_ID             NUMBER(16,0)
   );
   

ALTER TABLE 
   recovery_cm_dwh.h_prc_trimestre 
ADD 
   (
      PROCURADOR_PRC_ID             NUMBER(16,0)
   );
   
      
ALTER TABLE 
   recovery_cm_dwh.h_prc_anio 
ADD 
   (
      PROCURADOR_PRC_ID             NUMBER(16,0)
   );

ALTER TABLE 
   recovery_cm_dwh.tmp_h_prc 
ADD 
   (
      PROCURADOR_PRC_ID2             NUMBER(16,0)
   );