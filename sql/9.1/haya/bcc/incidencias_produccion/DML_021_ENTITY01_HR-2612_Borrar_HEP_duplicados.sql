--##########################################
--## AUTOR=JTD
--## FECHA_CREACION=20160531
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HR-2612
--## PRODUCTO=NO
--## 
--## Finalidad: Borra HEP duplicados del usuario SINCRO_CM_HAYA
--## INSTRUCCIONES:  
--## VERSIONES:
--##            0.1 Versión inicial
--##########################################
--*/
/***************************************/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
set timing ON
set linesize 2000
SET VERIFY OFF
set feedback on

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN

  DBMS_OUTPUT.PUT_LINE('[INICIO] HR-2612');
       
  V_SQL := 'DELETE FROM '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP 
             WHERE pco_prc_hep_id IN (
                   SELECT ID FROM (
                        SELECT pco_prc_hep_id ID, pco_prc_id, RANKING
                          FROM (
                              SELECT h.pco_prc_hep_id, h.pco_prc_id,
                                     rank() over (partition by H.pco_prc_id order by pco_prc_hep_id ASC) RANKING
                                FROM ( 
                                   select pco_prc_id, DD_PCO_PEP_ID, count(1) 
                                     from '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP
                                    WHERE usuariocrear = ''SINCRO_CM_HAYA''
                                    group by pco_prc_id, DD_PCO_PEP_ID
                                   having count (1) > 1) 
                               sqli, '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP h
                          WHERE sqli.pco_prc_id = h.pco_prc_id  
                            AND sqli.DD_PCO_PEP_ID = h.DD_PCO_PEP_ID
                          ) WHERE RANKING <> 1
                       )
                 )';
       
  EXECUTE IMMEDIATE V_SQL;
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN] HR-2612');        
   
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
