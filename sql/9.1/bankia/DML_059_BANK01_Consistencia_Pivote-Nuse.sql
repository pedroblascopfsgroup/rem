--/*
--##########################################
--## AUTOR=JOSEVI
--## FECHA_CREACION=20150807
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.12
--## INCIDENCIA_LINK=FASE-1470
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');

DBMS_OUTPUT.PUT_LINE('[INFO] Borrado de registros para consistencia de datos PIVOTE-NUSE');


DBMS_OUTPUT.PUT('[INFO] INTEGRIDAD FK: PIVOTE CON PRC_PROCEDIMIENTOS (PRC_ID)...');
execute immediate
'DELETE '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD CDD  
 WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC WHERE PRC.PRC_ID = CDD.PRC_ID )' ;
DBMS_OUTPUT.PUT_LINE('OK'); 

DBMS_OUTPUT.PUT('[INFO] INTEGRIDAD FK: PIVOTE CON ASU_ASUNTO (ASU_ID)...');
execute immediate 
'DELETE '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD CDD   
 WHERE NOT EXISTS  (SELECT 1 FROM '||V_ESQUEMA||'.ASU_ASUNTOS ASU WHERE ASU.ASU_ID = CDD.ASU_ID )' ;
DBMS_OUTPUT.PUT_LINE('OK'); 

DBMS_OUTPUT.PUT('[INFO] INTEGRIDAD FK: PIVOTE CON BIE_BIEN (BIE_ID)...');
execute immediate 
'DELETE '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD CDD     
 WHERE  CDD.BIE_ID  IS NOT NULL AND  NOT EXISTS  (SELECT 1 FROM '||V_ESQUEMA||'.BIE_BIEN BIE WHERE BIE.BIE_ID = CDD.BIE_ID )' ;
DBMS_OUTPUT.PUT_LINE('OK'); 

DBMS_OUTPUT.PUT('[INFO] INTEGRIDAD FK: PIVOTE CON NUSE (ID_ACUERDO_CIERRE)...');
execute immediate 
'DELETE '||V_ESQUEMA||'.CDD_CRN_RESULTADO_NUSE CRN     
 WHERE  CRN.ID_ACUERDO_CIERRE  IS NOT NULL AND  NOT EXISTS  (SELECT 1 FROM '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD CDD WHERE CDD.ID_ACUERDO_CIERRE = CRN.ID_ACUERDO_CIERRE )';
DBMS_OUTPUT.PUT_LINE('OK'); 

DBMS_OUTPUT.PUT('[INFO] INTEGRIDAD FK: TODAS - Borrado de IDs a NULL...');
execute immediate 
'DELETE '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD CDD
 WHERE CDD.ASU_ID IS NULL
 OR CDD.PRC_ID IS NULL';
 --OR CDD.BIE_ID IS NULL
 
 execute immediate 
'DELETE '||V_ESQUEMA||'.CDD_CRN_RESULTADO_NUSE CRN 
  WHERE CRN.ID_ACUERDO_CIERRE IS NULL';
DBMS_OUTPUT.PUT_LINE('OK'); 


COMMIT;

DBMS_OUTPUT.PUT_LINE('OK consistencia establecida.');

DBMS_OUTPUT.PUT_LINE('[FIN]');



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO - error');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

