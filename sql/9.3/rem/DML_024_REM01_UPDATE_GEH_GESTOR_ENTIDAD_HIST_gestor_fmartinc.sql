--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20190516
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4166
--## PRODUCTO=NO
--##
--## Finalidad: update GEH_GESTOR_ENTIDAD_HIST para el usuario fmartin que no se actualizó a fmartinc
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	V_ID NUMBER(16);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN

    --DBMS_OUTPUT.PUT_LINE('COMENZANDO EL PROCESO DE ACTUALIZACIÓN');
    EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.geh_gestor_entidad_hist set usu_id = (select usu_id from '||V_ESQUEMA_M||'.usu_usuarios where usu_username = ''fmartinc''),
						usuariomodificar = ''REMVIP-4166'', fechamodificar = sysdate
						where usu_id = (select usu_id from '||V_ESQUEMA_M||'.usu_usuarios where usu_username = ''fmartin'')
						and geh_id not in (select geh.geh_id from '||V_ESQUEMA||'.geh_gestor_entidad_hist geh
						                        inner join '||V_ESQUEMA||'.gah_gestor_activo_historico gah on geh.geh_id = gah.geh_id
						                        inner join '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO gac on gac.act_id = gah.act_id
						                        inner join '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD gee on gee.gee_id = gac.gee_id
						                        inner join '||V_ESQUEMA||'.act_activo act on act.act_id = gah.act_id
						                        inner join '||V_ESQUEMA_M||'.dd_tge_tipo_gestor tge on geh.dd_tge_id = tge.dd_tge_id
						                        inner join '||V_ESQUEMA_M||'.usu_usuarios usu on usu.usu_id = geh.usu_id
						                        inner join '||V_ESQUEMA_M||'.dd_tge_tipo_gestor tge2 on gee.dd_tge_id = tge2.dd_tge_id
						                        inner join '||V_ESQUEMA_M||'.usu_usuarios usu2 on usu2.usu_id = gee.usu_id
						                        where tge.dd_tge_codigo = ''GESTCOMALQ'' and usu.usu_username = ''fmartin'' and tge2.dd_tge_codigo = ''GESTCOMALQ'' and usu2.usu_username = ''fmartin'')';
						    
    COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
