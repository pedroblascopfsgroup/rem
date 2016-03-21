--/*
--##########################################
--## AUTOR=CARLOS PEREZ
--## FECHA_CREACION=20160121
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.1-cj
--## INCIDENCIA_LINK=CMREC-1794
--## PRODUCTO=SI
--## Finalidad: DDL
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


--Script perteneciente a NO_PROTOCOLO adaptado para el resto de entornos BANKIA
DBMS_OUTPUT.PUT_LINE('[INICIO] ');

      V_MSQL := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA ||'.V_PER_PERSONAS_FORMULAS (PER_ID, EST_CICLO_VIDA, DIAS_VENC_RIESGO_DIRECTO, DIAS_VENC_RIESGO_INDIRECTO
        , RIESGO_TOTAL, RIESGO_TOTAL_DIRECTO, RIESGO_TOTAL_INDIRECTO, SITUACION_CLIENTE, DIAS_VENCIDO
        , NUM_EXP_ACTIVOS, NUM_ASU_ACTIVOS, NUM_ASU_ACTIVOS_POR_PRC, SITUACION, RELACION_EXP, SERV_NOMINIA_PENSION
        , ULTIMA_ACTUACION, DISPUESTO_NO_VENCIDO, DISPUESTO_VENCIDO, DESC_CNAE,DESC_FECHA_SIT_CONCURSAL,DESC_CLIENTE_REESTRUC) AS
WITH NUM_EXP_ACTIVOS AS (select PEX.PER_ID ID, count(distinct exp.exp_id) NUM_EXP_ACTIVOS
from '||V_ESQUEMA ||'.EXP_EXPEDIENTES exp 
   JOIN '||V_ESQUEMA ||'.PEX_PERSONAS_EXPEDIENTE pex ON pex.exp_id = exp.exp_id 
  JOIN '||V_ESQUEMA_M ||'.DD_EEX_ESTADO_EXPEDIENTE dd_eex ON exp.dd_eex_id = dd_eex.dd_eex_id 
WHERE pex.borrado = 0 and exp.borrado = 0 and dd_eex.dd_eex_codigo in (''1'',''4'',''2'')
GROUP  BY PEX.PER_ID),
NUM_ASU_ACTIVOS_POR_PRC AS (SELECT PRCPER.PER_ID ID, COUNT (DISTINCT asu.asu_id) NUM_ASU_ACTIVOS_POR_PRC FROM '||V_ESQUEMA ||'.ASU_ASUNTOS asu JOIN '||V_ESQUEMA ||'.PRC_PROCEDIMIENTOS prc ON prc.asu_id = asu.asu_id
            JOIN '||V_ESQUEMA ||'.PRC_PER PRCPER ON PRC.PRC_ID = PRCPER.PRC_ID
            WHERE asu.borrado = 0 and prc.borrado = 0
GROUP BY PRCPER.PER_ID),
NUM_ASU_ACTIVOS AS (
SELECT cpe.per_id ID, COUNT (DISTINCT asu.asu_id) NUM_ASU_ACTIVOS FROM '||V_ESQUEMA ||'.ASU_ASUNTOS asu JOIN '||V_ESQUEMA ||'.PRC_PROCEDIMIENTOS prc ON prc.asu_id = asu.asu_id
            JOIN '||V_ESQUEMA ||'.PRC_CEX pc ON pc.prc_id = prc.prc_id JOIN CEX_CONTRATOS_EXPEDIENTE cex ON pc.cex_id = cex.cex_id
            JOIN '||V_ESQUEMA ||'.CNT_CONTRATOS cnt ON cex.cnt_id = cnt.cnt_id JOIN CPE_CONTRATOS_PERSONAS cpe ON cpe.cnt_id = cnt.cnt_id
            JOIN '||V_ESQUEMA_M ||'.dd_eas_estado_asuntos dd_eas ON asu.dd_eas_id = dd_eas.dd_eas_id
            WHERE asu.borrado = 0 and prc.borrado = 0 and dd_eas.dd_eas_codigo in (''03'',''01'',''02'')
            GROUP BY cpe.per_id
)
select 
PPF.PER_ID, PPF.EST_CICLO_VIDA, PPF.DIAS_VENC_RIESGO_DIRECTO, PPF.DIAS_VENC_RIESGO_INDIRECTO
        , PPF.RIESGO_TOTAL, PPF.RIESGO_TOTAL_DIRECTO, PPF.RIESGO_TOTAL_INDIRECTO, PPF.SITUACION_CLIENTE, PPF.DIAS_VENCIDO
        , NUM_EXP_ACTIVOS.NUM_EXP_ACTIVOS, NUM_ASU_ACTIVOS.NUM_ASU_ACTIVOS, NUM_ASU_ACTIVOS_POR_PRC.NUM_ASU_ACTIVOS_POR_PRC, 
		   --PPF.SITUACION
        CASE WHEN NUM_EXP_ACTIVOS.NUM_EXP_ACTIVOS IS NOT NULL AND NUM_ASU_ACTIVOS.NUM_ASU_ACTIVOS IS NULL AND NUM_ASU_ACTIVOS_POR_PRC.NUM_ASU_ACTIVOS_POR_PRC IS NULL THEN ''En Expediente''
             WHEN NUM_EXP_ACTIVOS.NUM_EXP_ACTIVOS IS NULL AND (NUM_ASU_ACTIVOS.NUM_ASU_ACTIVOS IS NOT NULL OR NUM_ASU_ACTIVOS_POR_PRC.NUM_ASU_ACTIVOS_POR_PRC IS NOT NULL) THEN ''En Asunto''
             WHEN NUM_EXP_ACTIVOS.NUM_EXP_ACTIVOS IS NULL AND NUM_ASU_ACTIVOS.NUM_ASU_ACTIVOS IS NULL AND NUM_ASU_ACTIVOS_POR_PRC.NUM_ASU_ACTIVOS_POR_PRC IS NULL THEN ''Normal''
              WHEN NUM_EXP_ACTIVOS.NUM_EXP_ACTIVOS IS NOT NULL AND (NUM_ASU_ACTIVOS.NUM_ASU_ACTIVOS IS NOT NULL OR NUM_ASU_ACTIVOS_POR_PRC.NUM_ASU_ACTIVOS_POR_PRC IS NOT NULL) THEN''En Expediente/ En Asunto'' 
        END AS SITUACION,    		
	    PPF.RELACION_EXP, PPF.SERV_NOMINIA_PENSION
        , PPF.ULTIMA_ACTUACION, PPF.DISPUESTO_NO_VENCIDO, PPF.DISPUESTO_VENCIDO, PPF.DESC_CNAE,DESC_FECHA_SIT_CONCURSAL,DESC_CLIENTE_REESTRUC
from '||V_ESQUEMA ||'.per_personas_formulas PPF 
LEFT JOIN NUM_EXP_ACTIVOS ON NUM_EXP_ACTIVOS.ID = PPF.PER_ID
LEFT JOIN NUM_ASU_ACTIVOS ON NUM_ASU_ACTIVOS.ID = PPF.PER_ID
LEFT JOIN NUM_ASU_ACTIVOS_POR_PRC ON NUM_ASU_ACTIVOS_POR_PRC.ID = PPF.PER_ID';

	   EXECUTE IMMEDIATE V_MSQL;
	
	   --V_MSQL := 'GRANT ALL PRIVILEGES ON '||V_ESQUEMA||'.TMP_REC_PER_DATA_RULE_ENGINE TO PFSRECOVERY';
		--EXECUTE IMMEDIATE V_MSQL;
		
    
    DBMS_OUTPUT.PUT_LINE('[INFO] FIN');

commit;

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT



