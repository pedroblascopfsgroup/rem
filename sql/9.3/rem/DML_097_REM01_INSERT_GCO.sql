--/*
--#########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20190202
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9322
--## PRODUCTO=NO
--## 
--## Finalidad: Aprovisionar la tabla 'TMP_GCO_GCH' con ECO_ID
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
    V_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TMP_GCO_GCH'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'HREOS-9322';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
      
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_GCO_GCH (ID, ECO_ID) 
    SELECT ROWNUM, eco.eco_id
    FROM '||V_ESQUEMA||'.eco_expediente_comercial eco
    join '||V_ESQUEMA||'.ofr_ofertas ofr on eco.ofr_id = ofr.ofr_id and ofr.borrado = 0
    join (
    SELECT distinct act_ofr.ofr_id
    FROM '||V_ESQUEMA||'.act_activo act
    join '||V_ESQUEMA||'.act_ofr on act_ofr.act_id = act.act_id
    left join '||V_ESQUEMA||'.act_aba_activo_bancario aba on act.act_id = aba.act_id and aba.borrado = 0
    left join '||V_ESQUEMA||'.dd_cla_clase_activo cla on aba.dd_cla_id = cla.dd_cla_id and cla.borrado = 0
    left join '||V_ESQUEMA||'.dd_cra_cartera cra on act.dd_cra_id = cra.dd_cra_id and cra.borrado = 0
    left join '||V_ESQUEMA||'.dd_scr_subcartera scr on act.dd_scr_id = scr.dd_scr_id and scr.borrado = 0
    where (cra.dd_cra_codigo in (''01'',''02'',''03'',''11'') or 
    scr.dd_scr_codigo in (''65'',''151'',''152'') or cla.dd_cla_codigo = ''01'') 
    ) cra on cra.ofr_id = ofr.ofr_id
    left join '||V_ESQUEMA||'.dd_eec_est_exp_comercial eec on eco.dd_eec_id = eec.dd_eec_id and eec.borrado = 0
    left join '||V_ESQUEMA||'.dd_tof_tipos_oferta tof on tof.dd_tof_id = ofr.dd_tof_id and tof.borrado = 0
    where eco.borrado = 0 and eec.dd_eec_codigo not in (''02'',''17'',''16'',''08'') and tof.dd_tof_codigo = ''01'' 
    and not exists (
    select 1 from  '||V_ESQUEMA||'.gco_gestor_add_eco gco
    join '||V_ESQUEMA||'.gee_gestor_entidad gee on gee.gee_id = gco.gee_id
    join '||V_ESQUEMA_M||'.usu_usuarios usu on gee.usu_id = usu.usu_id and usu.borrado = 0
    left join '||V_ESQUEMA_M||'.dd_tge_tipo_gestor tge on gee.dd_tge_id = tge.dd_tge_id and tge.borrado = 0
    where tge.dd_tge_codigo in (''GCONT'') and gco.eco_id = eco.eco_id)';

    EXECUTE IMMEDIATE V_MSQL;

    COMMIT;
   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
