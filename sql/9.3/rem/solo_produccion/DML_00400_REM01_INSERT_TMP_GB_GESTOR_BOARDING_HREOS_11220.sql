--/*
--#########################################
--## AUTOR=Carlos Augusto
--## FECHA_CREACION=20201008
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11220
--## PRODUCTO=NO
--## 
--## Finalidad: Aprovisionar la tabla 'TMP_GB_GESTOR_BOARDING' con ECO_ID
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TMP_GB_GESTOR_BOARDING'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'HREOS-11220';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
      
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_GB_GESTOR_BOARDING (ID, ECO_ID,USERNAME)
                 SELECT  ROWNUM,eco.ECO_ID, (''gruboarding'') as USERNAME
      FROM  '||V_ESQUEMA||'.eco_expediente_comercial eco
      inner join '||V_ESQUEMA||'.act_tra_tramite atr on eco.tbj_id = atr.tbj_id
      inner join '||V_ESQUEMA||'.tac_tareas_activos tac on atr.tra_id = tac.tra_id
      inner join '||V_ESQUEMA||'.tar_tareas_notificaciones tar on tar.tar_id = tac.tar_id
      inner join '||V_ESQUEMA||'.tex_tarea_externa txt on txt.tar_id = tar.tar_id
      inner join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on txt.tap_id = tap.tap_id
      inner join '||V_ESQUEMA_M||'.usu_usuarios usu on usu.usu_id = tac.usu_id
      where eco.borrado = 0
      and tar.tar_tarea_finalizada in (0)
      and tar.borrado = 0
      and eco.dd_eec_id not in(2,8,15)
      and tap.tap_codigo in (''T013_PBCReserva'', ''T017_PBCReserva'', ''T013_InstruccionesReserva'',''T013_ObtencionContratoReserva'',''T017_InstruccionesReserva'',''T017_ObtencionContratoReserva'')
     and eco.eco_num_expediente not in (87143,86139,17261,17236)';

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
