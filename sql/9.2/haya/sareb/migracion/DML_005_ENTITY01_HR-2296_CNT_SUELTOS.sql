--/*
--##########################################
--## AUTOR=DANIEL ALBERT PEREZ
--## FECHA_CREACION=20160516
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2296
--## PRODUCTO=NO
--## 
--## Finalidad: Borrado referentes a contratos 6268341, 6247359 y 6248994 de la Migración PCO
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_MSQL VARCHAR(32000);   
    V_MSQL_RESULT VARCHAR(32000);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- Configuracion Esquema
    
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
BEGIN

  DBMS_OUTPUT.ENABLE(1000000);

  DBMS_OUTPUT.PUT_LINE('*********************************************');
  DBMS_OUTPUT.PUT_LINE('******* BORRADO PCOs CONTRATOS SUELTOS ******');
  DBMS_OUTPUT.PUT_LINE('*********************************************');

  DBMS_OUTPUT.PUT_LINE('');

  V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.CNT_CONTRATOS WHERE USUARIOBORRAR = ''HR-2296'' AND CNT_ID = '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS.PCO_DOC_PDD_UG_ID) AND BORRADO <> 1 AND USUARIOCREAR = ''MIGRAPCO''';
  EXECUTE IMMEDIATE V_MSQL INTO V_MSQL_RESULT;
  DBMS_OUTPUT.PUT_LINE('Se borrarán '||V_MSQL_RESULT||' documentos.');
  EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS SET USUARIOBORRAR = ''HR-2296'', BORRADO = 1, FECHABORRAR = SYSDATE WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.CNT_CONTRATOS WHERE USUARIOBORRAR = ''HR-2296'' AND CNT_ID = '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS.PCO_DOC_PDD_UG_ID) AND BORRADO <> 1 AND USUARIOCREAR = ''MIGRAPCO''';
  EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.PCO_DOC_SOLICITUDES SET USUARIOBORRAR = ''HR-2296'', BORRADO = 1, FECHABORRAR = SYSDATE WHERE PCO_DOC_PDD_ID IN (SELECT PCO_DOC_PDD_ID FROM '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS WHERE BORRADO = 1) AND BORRADO <> 1 AND USUARIOCREAR = ''MIGRAPCO''';
  
  V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.CNT_CONTRATOS CNT WHERE USUARIOBORRAR = ''HR-2296'' AND CNT.CNT_ID = '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES.CNT_ID) AND BORRADO <> 1 AND USUARIOCREAR = ''MIGRAPCO''';
  EXECUTE IMMEDIATE V_MSQL INTO V_MSQL_RESULT;
  DBMS_OUTPUT.PUT_LINE('Se borrarán '||V_MSQL_RESULT||' liquidaciones.');
  EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES SET USUARIOBORRAR = ''HR-2296'', BORRADO = 1, FECHABORRAR = SYSDATE WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.CNT_CONTRATOS CNT WHERE USUARIOBORRAR = ''HR-2296'' AND CNT.CNT_ID = '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES.CNT_ID) AND BORRADO <> 1 AND USUARIOCREAR = ''MIGRAPCO''';
  
  V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PCO_BUR_BUROFAX WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.CNT_CONTRATOS CNT WHERE USUARIOBORRAR = ''HR-2296'' AND CNT.CNT_ID = '||V_ESQUEMA||'.PCO_BUR_BUROFAX.CNT_ID) AND BORRADO <> 1 AND USUARIOCREAR = ''MIGRAPCO''';
  EXECUTE IMMEDIATE V_MSQL INTO V_MSQL_RESULT;
  DBMS_OUTPUT.PUT_LINE('Se borrarán '||V_MSQL_RESULT||' burofaxes.');
  EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.PCO_BUR_BUROFAX SET USUARIOBORRAR = ''HR-2296'', BORRADO = 1, FECHABORRAR = SYSDATE WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.CNT_CONTRATOS CNT WHERE USUARIOBORRAR = ''HR-2296'' AND CNT.CNT_ID = '||V_ESQUEMA||'.PCO_BUR_BUROFAX.CNT_ID) AND BORRADO <> 1 AND USUARIOCREAR = ''MIGRAPCO''';
  EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.PCO_BUR_ENVIO SET USUARIOBORRAR = ''HR-2296'', BORRADO = 1, FECHABORRAR = SYSDATE WHERE PCO_BUR_BUROFAX_ID IN (SELECT PCO_BUR_BUROFAX_ID FROM '||V_ESQUEMA||'.PCO_BUR_BUROFAX WHERE BORRADO = 1) AND BORRADO <> 1 AND USUARIOCREAR = ''MIGRAPCO''';
  EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.PCO_BUR_ENVIO_INTEGRACION SET USUARIOBORRAR = ''HR-2296'', BORRADO = 1, FECHABORRAR = SYSDATE WHERE PCO_BUR_ENVIO_ID IN (SELECT PCO_BUR_ENVIO_ID FROM '||V_ESQUEMA||'.PCO_BUR_ENVIO WHERE BORRADO = 1) AND BORRADO <> 1 AND USUARIOCREAR = ''MIGRAPCO''';
  
  V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PCO_OBS_OBSERVACIONES WHERE SUBSTR(PCO_OBS_TEXTO_ANOTACION,1,17) IN (SELECT SUBSTR(CNT_CONTRATO,11,17) FROM '||V_ESQUEMA||'.CNT_CONTRATOS WHERE USUARIOBORRAR = ''HR-2296'') AND BORRADO <> 1 AND USUARIOCREAR = ''MIGRACIÓN''';
  EXECUTE IMMEDIATE V_MSQL INTO V_MSQL_RESULT;
  DBMS_OUTPUT.PUT_LINE('Se borrarán '||V_MSQL_RESULT||' observaciones.');
  EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.PCO_OBS_OBSERVACIONES SET USUARIOBORRAR = ''HR-2296'', BORRADO = 1, FECHABORRAR = SYSDATE WHERE SUBSTR(PCO_OBS_TEXTO_ANOTACION,1,17) IN (SELECT SUBSTR(CNT_CONTRATO,11,17) FROM '||V_ESQUEMA||'.CNT_CONTRATOS WHERE USUARIOBORRAR = ''HR-2296'') AND BORRADO <> 1 AND USUARIOCREAR = ''MIGRACIÓN''';
  
  DBMS_OUTPUT.PUT_LINE('');
  
  DBMS_OUTPUT.PUT_LINE('**************************************');
  DBMS_OUTPUT.PUT_LINE('***** Finalizado correctamente. ******');
  DBMS_OUTPUT.PUT_LINE('**************************************');
  
EXCEPTION
WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
  
END;
/
EXIT
