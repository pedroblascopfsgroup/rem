--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200710
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7779
--## PRODUCTO=NO
--## 
--## Finalidad: Aprovisionar la tabla 'TMP_GCO_GCH_REMVIP_7779' con ECO_ID
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TMP_GCO_GCH_REMVIP_7779'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'REMVIP-7779';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
      
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_GCO_GCH_REMVIP_7779 (ID, ECO_ID,USERNAME) 
SELECT ROWNUM, ECO_ID, USERNAME FROM (
SELECT distinct eco.eco_id, eco.eco_num_expediente,
case when (cra.dd_Cra_codigo = ''08'' and prv.dd_prv_codigo in (''3'',''4'',''48'',''20'',''1'',''52'',''51'',''50'',''49'',''47'',''46'',''44'',''42'',''41'',''40'',''39'',''37'',''34'',''30'',''29'',''24'',''23'',''5'',''7'',''9'',''11'',''12'',''14'',''18'',''21'',''22''))
or (cra.dd_Cra_codigo = ''03'' and prv.dd_prv_codigo in (''1'',''3'',''4'',''6'',''9'',''10'',''11'',''12'',''14'',''15'',''18'',''20'',''21'',''23'',''24'',''27'',''29'',''30'',''32'',''34'',''36'',''37'',''39'',''40'',''41'',''42'',''46'',''47'',''48'',''49'',''51'',''52''))
or (cra.dd_cra_codigo = ''01'' and (prv.dd_prv_codigo in (''49'',''48'',''2'',''50'',''47'',''46'',''45'',''12'',''39'',''10'',''44'',''43'',''15'',''1'',''3'',''33'',''5'',''6'',''8'',''9'',''51'',''13'',''16'',''17'',''19'',''20'',''22'',''7'',''26'',''35'',''24'',''25'',''27'',''28'',''52'',''31'',''32'',''34'',''36'',''37'',''40'',''42'',''38'') or (prv.dd_prv_codigo = ''30'' and loc.dd_loc_codigo != ''30030'')))
THEN  ''garsa03'' 
when (cra.dd_Cra_codigo = ''03'' and prv.dd_prv_codigo in (''50'',''45'',''44'',''43'',''38'',''28'',''25'',''35'',''26'',''7'',''19'',''17'',''16'',''13'',''8'',''5'',''33'',''22'',''2'',''31'')) 
then ''montalvo03''
when (cra.dd_cra_codigo = ''07'' and scr.dd_scr_codigo = ''138'') or (cra.dd_cra_codigo = ''02'') 
or (cra.dd_cra_codigo = ''01'' and (prv.dd_prv_codigo in (''41'',''29'',''23'',''21'',''14'',''11'',''4'',''18'') or (prv.dd_prv_codigo = ''30'' and loc.dd_loc_codigo = ''30030'')))
then ''ogf03''
when (cra.dd_Cra_codigo = ''08'' and prv.dd_prv_codigo in (''2'',''6'',''8'',''10'',''13'',''15'',''16'',''17'',''19'',''25'',''26'',''27'',''28'',''31'',''32'',''33'',''35'',''36'',''38'',''43'',''45''))
then ''pinos03''
end as username
FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
inner join '||V_ESQUEMA||'.gah_gestor_activo_historico gah on gah.act_id = act.act_id
inner join '||V_ESQUEMA||'.geh_gestor_entidad_hist geh on geh.geh_id = gah.geh_id and geh.borrado = 0 and geh.geh_fecha_hasta is null
inner join '||V_ESQUEMA||'.dd_cra_cartera cra on cra.dd_cra_id = act.dd_cra_id
inner join '||V_ESQUEMA||'.dd_scr_subcartera scr on act.dd_scr_id = scr.dd_scr_id
inner join '||V_ESQUEMA||'.bie_bien bie on bie.bie_id = act.bie_id
inner join '||V_ESQUEMA||'.BIE_LOCALIZACION bieloc on bieloc.bie_id = bie.bie_id
inner join '||V_ESQUEMA_M||'.dd_prv_provincia prv on prv.dd_prv_id = bieloc.dd_prv_id
inner join '||V_ESQUEMA_M||'.dd_loc_localidad loc on bieloc.dd_loc_id = loc.dd_loc_id
inner join '||V_ESQUEMA||'.act_ofr aof on aof.act_id = act.act_id
inner join '||V_ESQUEMA||'.ofr_ofertas ofr on ofr.ofr_id = aof.ofr_id and ofr.borrado = 0
inner join (SELECT distinct eco.* FROM '||V_ESQUEMA||'.eco_expediente_comercial eco
   left join (
   select distinct eco.eco_id from '||V_ESQUEMA||'.eco_expediente_comercial eco    
   inner join '||V_ESQUEMA||'.gch_gestor_eco_historico gch on gch.eco_id = eco.eco_id
   inner join '||V_ESQUEMA||'.geh_gestor_entidad_hist geh1 on geh1.geh_id = gch.geh_id and geh1.borrado = 0 and geh1.geh_fecha_hasta is null
   inner join '||V_ESQUEMA_M||'.dd_tge_tipo_gestor tge1 on tge1.dd_tge_id = geh1.dd_tge_id
   where eco.borrado = 0 and tge1.dd_tge_codigo = ''GIAFORM'') aux on aux.eco_id = eco.eco_id
   inner join '||V_ESQUEMA||'.act_tra_tramite tra on tra.tbj_id = eco.tbj_id and tra.borrado = 0 and tra.dd_epr_id != 5
   where eco.borrado = 0 and aux.eco_id is null) eco on eco.ofr_id = ofr.ofr_id and eco.borrado = 0
inner join '||V_ESQUEMA_M||'.dd_tge_tipo_gestor tge on tge.dd_tge_id = geh.dd_tge_id
where tge.dd_tge_codigo = ''GIAFORM'' and act.borrado = 0 and (cra.dd_cra_codigo in (''01'',''02'',''03'',''08'')or (cra.dd_cra_codigo = ''07'' and scr.dd_Scr_codigo = ''138'')) and eco.fechacrear >= TO_DATE (''26/06/20'', ''dd/mm/yy''))';

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
