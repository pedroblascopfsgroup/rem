/***************************************/
-- CREACION DE DOCUMENTOS Y BUROFAXES DE PRECONTENCIOSO PARA ESTADOS DISTINTOS A ENVIADO
-- Creador: SERGIO HERNANDEZ GASO PFS Group
-- Modificador: 
-- Fecha: 31/03/2016
-- Modificacion: 
/***************************************/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
set timing ON
set linesize 2000
SET VERIFY OFF
set timing on
set feedback on

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA02'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    USUARIO varchar2(20 CHAR) := 'MIGRAHAYA02PCO';
BEGIN

/*****************************
*   PCO_DOCUMENTOS           *
******************************/

        V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS (PCO_DOC_PDD_ID, PCO_PRC_ID, DD_PCO_DED_ID, DD_PCO_DTD_ID, DD_TFA_ID, PCO_DOC_PDD_UG_ID, PCO_DOC_PDD_UG_DESC, USUARIOCREAR, FECHACREAR, SYS_GUID)
                                SELECT '||V_ESQUEMA||'.S_PCO_DOC_DOCUMENTOS.NEXTVAL,
                                           PCO.PCO_PRC_ID,
                                           DED.DD_PCO_DED_ID,
                                           DTD.DD_PCO_DTD_ID, 
                                           CONF.DD_TFA_ID,
                                           CNT.CNT_ID,
                                           CNT.CNT_CONTRATO, 
                                           '''||USUARIO||''',
                                           SYSDATE,
                                           SYS_GUID() AS SYS_GUID
                                  FROM '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
                                        INNER JOIN '||V_ESQUEMA||'.DD_PCO_DOC_ESTADO DED ON DED.DD_PCO_DED_CODIGO = ''PS''
                                        INNER JOIN '||V_ESQUEMA||'.DD_PCO_DOC_UNIDADGESTION DTD ON DTD.DD_PCO_DTD_CODIGO = ''CO''
                                        INNER JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID=PCO.PRC_ID
                                        INNER JOIN '||V_ESQUEMA||'.PCO_CDE_CONF_TFA_TIPOENTIDAD CONF ON CONF.DD_PCO_DTD_ID=DTD.DD_PCO_DTD_ID AND CONF.DD_TPO_ID=PCO.PCO_PRC_TIPO_PRC_PROP
                                        INNER JOIN '||V_ESQUEMA||'.PRC_CEX PCEX ON PCEX.PRC_ID = PCO.PRC_ID
                                        INNER JOIN '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.CEX_ID = PCEX.CEX_ID
                                        INNER JOIN '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_ID=CEX.CNT_ID
                                        INNER JOIN '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP HIS ON HIS.PCO_PRC_ID = PCO.PCO_PRC_ID AND DD_PCO_PEP_ID NOT IN  (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO IN (''PT'', ''EN''))'; -- PROPUESTO, ENVIADO
    
        EXECUTE IMMEDIATE V_SQL;
        
        DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
    COMMIT;

        V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS (PCO_DOC_PDD_ID, PCO_PRC_ID, DD_PCO_DED_ID, DD_PCO_DTD_ID, DD_TFA_ID, PCO_DOC_PDD_UG_ID, PCO_DOC_PDD_UG_DESC, USUARIOCREAR, FECHACREAR, SYS_GUID)
                                SELECT '||V_ESQUEMA||'.S_PCO_DOC_DOCUMENTOS.NEXTVAL,
                                           PCO.PCO_PRC_ID,
                                           DED.DD_PCO_DED_ID,
                                           DTD.DD_PCO_DTD_ID, 
                                           CONF.DD_TFA_ID,
                                           PER.PER_ID,
                                           PER.PER_NOM50,
                                           '''||USUARIO||''',
                                           SYSDATE,
                                           SYS_GUID() AS SYS_GUID
                                  FROM '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
                                        INNER JOIN '||V_ESQUEMA||'.DD_PCO_DOC_ESTADO DED ON DED.DD_PCO_DED_CODIGO = ''PS''
                                        INNER JOIN '||V_ESQUEMA||'.DD_PCO_DOC_UNIDADGESTION DTD ON DTD.DD_PCO_DTD_CODIGO = ''PE''
                                        INNER JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID=PCO.PRC_ID
                                        INNER JOIN '||V_ESQUEMA||'.PCO_CDE_CONF_TFA_TIPOENTIDAD CONF ON CONF.DD_PCO_DTD_ID=DTD.DD_PCO_DTD_ID AND CONF.DD_TPO_ID=PCO.PCO_PRC_TIPO_PRC_PROP
                                        INNER JOIN '||V_ESQUEMA||'.PRC_CEX PCEX ON PCEX.PRC_ID = PCO.PRC_ID
                                        INNER JOIN '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.CEX_ID = PCEX.CEX_ID
                                        INNER JOIN '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_ID=CEX.CNT_ID
                                        INNER JOIN '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS CPE ON CPE.CNT_ID = CNT.CNT_ID
                                        INNER JOIN '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE PEX ON PEX.PER_ID = CPE.PER_ID AND PEX.PEX_PASE = 1 AND PEX.EXP_ID = CEX.EXP_ID
                                        INNER JOIN '||V_ESQUEMA||'.PER_PERSONAS PER ON PER.PER_ID = PEX.PER_ID
                                        INNER JOIN '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP HIS ON HIS.PCO_PRC_ID = PCO.PCO_PRC_ID AND DD_PCO_PEP_ID NOT IN  (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO IN (''PT'', ''EN''))'; -- PROPUESTO, ENVIADO
    
        EXECUTE IMMEDIATE V_SQL;
        
        DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
    COMMIT;

/*****************************
*   PCO_BUROFAX              *
******************************/

        V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_BUR_BUROFAX (PCO_BUR_BUROFAX_ID, PCO_PRC_ID, PER_ID, DD_PCO_BFE_ID, CNT_ID, DD_TIN_ID, USUARIOCREAR, FECHACREAR, SYS_GUID)
                                SELECT '||V_ESQUEMA||'.S_PCO_BUR_BUROFAX_ID.NEXTVAL,
                                           PCO.PCO_PRC_ID,
                                           CPE.PER_ID,
                                           BFE.DD_PCO_BFE_ID, 
                                           CPE.CNT_ID,
                                           CPE.DD_TIN_ID,
                                           '''||USUARIO||''',
                                           SYSDATE,
                                           SYS_GUID() AS SYS_GUID
                                FROM '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
                                        INNER JOIN '||V_ESQUEMA||'.DD_PCO_BFE_ESTADO BFE ON BFE.DD_PCO_BFE_CODIGO=''KO''
                                        INNER JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID=PCO.PRC_ID
                                        INNER JOIN '||V_ESQUEMA||'.PRC_CEX PCEX ON PCEX.PRC_ID = PCO.PRC_ID
                                        INNER JOIN '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.CEX_ID = PCEX.CEX_ID
                                        INNER JOIN '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_ID=CEX.CNT_ID
                                        INNER JOIN '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS CPE ON CPE.CNT_ID = CNT.CNT_ID
                                        INNER JOIN '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE PEX ON PEX.PER_ID = CPE.PER_ID AND PEX.PEX_PASE = 1 AND PEX.EXP_ID = CEX.EXP_ID
                                        INNER JOIN '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP HIS ON HIS.PCO_PRC_ID = PCO.PCO_PRC_ID AND DD_PCO_PEP_ID NOT IN  (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO IN (''PT'', ''EN''))'; -- PROPUESTO, ENVIADO
    
        EXECUTE IMMEDIATE V_SQL;
        
        DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/

EXIT;
