--/*
--##########################################
--## AUTOR=María V.
--## FECHA_CREACION=20160323
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=GC-1058
--## PRODUCTO=NO
--## 
--## Finalidad: Se añade campo PROCURADOR_PRC_ID en tablas de procedimientos
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
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
   
/
EXIT