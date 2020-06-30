--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200630
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7588
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
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'REMVIP-7588';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
      
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_GCO_GCH (ID, ECO_ID) 
    SELECT ROWNUM, ECO_ID FROM (
	SELECT DISTINCT eco.eco_id
    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
	inner join '||V_ESQUEMA||'.gah_gestor_activo_historico gah on gah.act_id = act.act_id
	inner join '||V_ESQUEMA||'.geh_gestor_entidad_hist geh on geh.geh_id = gah.geh_id and geh.borrado = 0 and geh.geh_fecha_hasta is null
	inner join '||V_ESQUEMA||'.act_ofr aof on aof.act_id = act.act_id
	inner join '||V_ESQUEMA||'.ofr_ofertas ofr on ofr.ofr_id = aof.ofr_id and ofr.borrado = 0
	inner join (SELECT distinct eco.* FROM '||V_ESQUEMA||'.eco_expediente_comercial eco
	    left join (
	    select distinct eco.eco_id from '||V_ESQUEMA||'.eco_expediente_comercial eco     
	    inner join '||V_ESQUEMA||'.gch_gestor_eco_historico gch on gch.eco_id = eco.eco_id 
	    inner join '||V_ESQUEMA||'.geh_gestor_entidad_hist geh1 on geh1.geh_id = gch.geh_id and geh1.borrado = 0 and geh1.geh_fecha_hasta is null
	    inner join '||V_ESQUEMA_M||'.dd_tge_tipo_gestor tge1 on tge1.dd_tge_id = geh1.dd_tge_id
	    where eco.borrado = 0 and tge1.dd_tge_codigo = ''GCONT'') aux on aux.eco_id = eco.eco_id
	    inner join '||V_ESQUEMA||'.act_tra_tramite tra on tra.tbj_id = eco.tbj_id and tra.borrado = 0 and tra.dd_epr_id != 5
	    where eco.borrado = 0 and aux.eco_id is null) eco on eco.ofr_id = ofr.ofr_id and eco.borrado = 0
	inner join '||V_ESQUEMA_M||'.dd_tge_tipo_gestor tge on tge.dd_tge_id = geh.dd_tge_id
	where tge.dd_tge_codigo = ''GCONT'' and act.borrado = 0)';

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
