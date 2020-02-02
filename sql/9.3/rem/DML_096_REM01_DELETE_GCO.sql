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
      
	V_MSQL := 'delete from '||V_ESQUEMA||'.gco_gestor_add_eco gco where EXISTS 
	(select 1 from '||V_ESQUEMA||'.gco_gestor_add_eco aux_gco
	join '||V_ESQUEMA||'.gee_gestor_entidad gee on gee.gee_id = gco.gee_id
	left join '||V_ESQUEMA_M||'.dd_tge_tipo_gestor tge on gee.dd_tge_id = tge.dd_tge_id and tge.borrado = 0
	where tge.dd_tge_codigo in (''GCONT'') and gee.usuariocrear = ''HREOS-9322''
	and aux_gco.eco_id = gco.eco_id and aux_gco.gee_id = gco.gee_id)';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] BORRADOS EN GCO: ' || sql%rowcount);

	V_MSQL := 'delete from '||V_ESQUEMA||'.gee_gestor_entidad gee where EXISTS 
	(select 1 from '||V_ESQUEMA||'.gee_gestor_entidad aux_gee
	left join '||V_ESQUEMA_M||'.dd_tge_tipo_gestor tge on aux_gee.dd_tge_id = tge.dd_tge_id and tge.borrado = 0
	where tge.dd_tge_codigo in (''GCONT'') and aux_gee.usuariocrear = ''HREOS-9322''
	and aux_gee.gee_id = gee.gee_id)';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] BORRADOS EN GEE: ' || sql%rowcount);

	V_MSQL := 'delete from '||V_ESQUEMA||'.gch_gestor_eco_historico gch where EXISTS 
	(select 1 from '||V_ESQUEMA||'.gch_gestor_eco_historico aux_gch
	join '||V_ESQUEMA||'.geh_gestor_entidad_hist geh on geh.geh_id = gch.geh_id
	left join '||V_ESQUEMA_M||'.dd_tge_tipo_gestor tge on geh.dd_tge_id = tge.dd_tge_id and tge.borrado = 0
	where tge.dd_tge_codigo in (''GCONT'') and geh.usuariocrear = ''HREOS-9322''
	and aux_gch.eco_id = gch.eco_id and aux_gch.geh_id = gch.geh_id)';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] BORRADOS EN GCH: ' || sql%rowcount);

	V_MSQL := 'delete from '||V_ESQUEMA||'.geh_gestor_entidad_hist geh where EXISTS 
	(select 1 from '||V_ESQUEMA||'.geh_gestor_entidad_hist aux_geh
	left join '||V_ESQUEMA_M||'.dd_tge_tipo_gestor tge on aux_geh.dd_tge_id = tge.dd_tge_id and tge.borrado = 0
	where tge.dd_tge_codigo in (''GCONT'') and aux_geh.usuariocrear = ''HREOS-9322''
	and aux_geh.geh_id = geh.geh_id)';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] BORRADOS EN GEH: ' || sql%rowcount);

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
