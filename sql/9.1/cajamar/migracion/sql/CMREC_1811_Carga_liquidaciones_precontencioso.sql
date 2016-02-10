--/*
--##########################################
--## AUTOR=GUSTAVO MORA 
--## FECHA_CREACION=20160208
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-1811
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de liquidaciones de expedientes precontenciosos
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        1.0 version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
  
      
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
   V_ESQUEMA          VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquema
   V_ESQUEMA_MASTER   VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquema Master

   err_num            NUMBER; -- Numero de errores
   err_msg            VARCHAR2(2048); -- Mensaje de error    
   V_MSQL             VARCHAR2(5000);
   

BEGIN

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES (PCO_LIQ_ID, PCO_PRC_ID, DD_PCO_LIQ_ID, CNT_ID, usuariocrear, fechacrear, SYS_GUID)
                      SELECT s_PCO_LIQ_LIQUIDACIONES.nextval, pco_prc_id, 1, cnt_id, ''SAG'', sysdate, SYS_GUID() AS SYS_GUID
                   FROM (
                         select distinct prc.prc_id, pco.pco_prc_id, cex.cnt_id
                           from '||V_ESQUEMA||'.prc_procedimientos prc inner join 
                                '||V_ESQUEMA||'.pco_prc_procedimientos pco on pco.prc_id = prc.prc_id inner join
                                '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP hep on hep.pco_prc_id = pco.pco_prc_id inner join
                                '||V_ESQUEMA||'.prc_cex pcex on pcex.prc_id = prc.prc_id inner join
                                '||V_ESQUEMA||'.cex_contratos_expediente cex on cex.cex_id = pcex.cex_id
                    where hep.DD_PCO_PEP_ID = (select DD_PCO_PEP_ID from '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION where DD_PCO_PEP_CODIGO = ''PR'') 
                      and not exists (select 1 from '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES liq where liq.pco_prc_id = pco.pco_prc_id)
                   )';
      
   
   EXECUTE IMMEDIATE V_MSQL;
   

   COMMIT;   
                
                   


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

EXIT;

