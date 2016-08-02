--/*
--##########################################
--## AUTOR=María V.
--## FECHA_CREACION=20160415
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-3085
--## PRODUCTO=NO
--## 
--## Finalidad: Se añade campo VIVIENDA_HABITUAL_ID en tablas de bienes
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema ESQUEMA_DWH
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN 


   EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.H_BIE ADD ( VIVIENDA_HABITUAL_ID NUMBER(16,0) )';




   EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.H_BIE_SEMANA ADD ( VIVIENDA_HABITUAL_ID NUMBER(16,0) )';




   EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.H_BIE_MES ADD ( VIVIENDA_HABITUAL_ID NUMBER(16,0) )';



 
   EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.H_BIE_TRIMESTRE ADD ( VIVIENDA_HABITUAL_ID NUMBER(16,0) )';




   EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.H_BIE_ANIO ADD ( VIVIENDA_HABITUAL_ID NUMBER(16,0) )';




   EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.TMP_H_BIE ADD ( VIVIENDA_HABITUAL_ID NUMBER(16,0) )';



EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;
