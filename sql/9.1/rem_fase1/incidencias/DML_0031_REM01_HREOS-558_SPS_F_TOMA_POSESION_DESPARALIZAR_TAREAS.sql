--/* 
--#########################################
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20160608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-558
--## PRODUCTO=NO
--## 
--## Finalidad: Paralizar tareas desparalizadas por error. Vaciar campo SPS_FECHA_TOMA_POSESION de los activos afectados.
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBANDO ACTIVOS AFECTADOS...');
   
	V_MSQL := '
	select COUNT(sps.act_id)
	from '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA sps
	inner join '||V_ESQUEMA||'.ACT_ACTIVO act
		on act.act_id = sps.act_id
	inner join '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION bie
		on bie.bie_id = act.bie_id
	left join '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL adn 
	  on adn.act_id = sps.act_id
	where SPS_FECHA_TOMA_POSESION is not null
	and adn.act_id is null
	and sps.usuariocrear != ''MIG''
	AND SPS.BORRADO = 0
	and bie.bie_adj_f_rea_posesion is null
	and act.act_num_activo != 122951
	'
	;
	
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] EXISTEN '||V_NUM||' ACTIVOS AFECTADOS'||CHR(10));

	DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBANDO TAREAS A PARALIZAR...');
   
	V_MSQL := '
	select count(1)
	from '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS tac 
	inner join '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar
	  on tar.tar_id = tac.tar_id
	inner join '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex
	  on tex.tar_id = tar.tar_id
	where act_id in (
		select sps.act_id
		from '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA sps
		inner join '||V_ESQUEMA||'.ACT_ACTIVO act
			on act.act_id = sps.act_id
		inner join '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION bie
			on bie.bie_id = act.bie_id
		left join '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL adn 
		  on adn.act_id = sps.act_id
		where SPS_FECHA_TOMA_POSESION is not null
		and adn.act_id is null
		and sps.usuariocrear != ''MIG''
		AND SPS.BORRADO = 0
		and bie.bie_adj_f_rea_posesion is null
		and act.act_num_activo != 122951
	)
	and tar.tar_descripcion != ''Checking de información''
	AND TAR.TAR_FECHA_FIN IS NULL
	AND TAR.TAR_TAREA_FINALIZADA = 0
	AND TEX.TEX_DETENIDA = 0
	and tar.borrado = 0
	'
	;
	
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] SE VAN A PARALIZAR '||V_NUM||' TAREAS...'||CHR(10));
	
	DBMS_OUTPUT.PUT_LINE('[INFO] PARALIZANDO TAREAS...');
	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICANDO TAR_TAREAS_NOTIFICACIONES...BORRADO = 1...');
	
	V_MSQL := '
	UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR 
	  SET 
	  TAR.BORRADO = 1,
		TAR.USUARIOMODIFICAR = ''HREOS-558'',
		TAR.FECHAMODIFICAR = SYSDATE
	  WHERE EXISTS (
	  WITH PARALIZA AS (
		select TAC.act_id, tar.tar_id
			from '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS tac 
			inner join '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar
			  on tar.tar_id = tac.tar_id
			inner join '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex
			  on tex.tar_id = tar.tar_id
			where act_id in (
				select sps.act_id
				from '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA sps
				inner join '||V_ESQUEMA||'.ACT_ACTIVO act
					on act.act_id = sps.act_id
				inner join '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION bie
					on bie.bie_id = act.bie_id
				left join '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL adn 
				  on adn.act_id = sps.act_id
				where SPS.SPS_FECHA_TOMA_POSESION is not null
				and adn.act_id is null
				and sps.usuariocrear != ''MIG''
				AND SPS.BORRADO = 0
				and bie.bie_adj_f_rea_posesion is null
				and act.act_num_activo != 122951
			)
			and tar.tar_descripcion != ''Checking de información''
			AND TAR.TAR_FECHA_FIN IS NULL
			AND TAR.TAR_TAREA_FINALIZADA = 0
			AND TEX.TEX_DETENIDA = 0
			and tar.borrado = 0
	  )
	  SELECT 1 FROM PARALIZA WHERE PARALIZA.TAR_ID = TAR.TAR_ID
	  )
	'
	;
	
	EXECUTE IMMEDIATE V_MSQL;
	
	V_NUM := SQL%ROWCOUNT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM||' REGISTROS MODIFICADOS.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICANDO TEX_TAREA_EXTERNA...TEX_DETENIDA = 1...');
	
	V_MSQL := '
	UPDATE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX
	  SET 
	  TEX.TEX_DETENIDA = 1,
		TEX.USUARIOMODIFICAR = ''HREOS-558'',
		TEX.FECHAMODIFICAR = SYSDATE
	  WHERE EXISTS (
	  WITH PARALIZA AS (
		select TAC.act_id, TEX.TEX_ID
			from '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS tac 
			inner join '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar
			  on tar.tar_id = tac.tar_id
			inner join '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex
			  on tex.tar_id = tar.tar_id
			where act_id in (
				select sps.act_id
				from '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA sps
				inner join '||V_ESQUEMA||'.ACT_ACTIVO act
					on act.act_id = sps.act_id
				inner join '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION bie
					on bie.bie_id = act.bie_id
				left join '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL adn 
				  on adn.act_id = sps.act_id
				where SPS.SPS_FECHA_TOMA_POSESION is not null
				and adn.act_id is null
				and sps.usuariocrear != ''MIG''
				AND SPS.BORRADO = 0
				and bie.bie_adj_f_rea_posesion is null
				and act.act_num_activo != 122951
			)
			and tar.tar_descripcion != ''Checking de información''
			AND TAR.TAR_FECHA_FIN IS NULL
			AND TAR.TAR_TAREA_FINALIZADA = 0
			AND TEX.TEX_DETENIDA = 0
			and tar.borrado = 1
	  )
	  SELECT 1 FROM PARALIZA WHERE PARALIZA.TEX_ID = TEX.TEX_ID
	  )
	'
	;
	
	EXECUTE IMMEDIATE V_MSQL;
	
	V_NUM := SQL%ROWCOUNT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM||' REGISTROS MODIFICADOS.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] TAR_TAREAS_NOTIFICACIONES Y TEX_TAREA_EXTERNA MODIFICADAS...'||CHR(10));
	
	DBMS_OUTPUT.PUT_LINE('[INFO] VACIANDO CAMPO FECHA DE TOMA DE POSESIÓN SOBRE LOS ACTIVOS AFECTADOS...SPS_FECHA_TOMA_POSESION = NULL...');
	
	V_MSQL := '
	UPDATE '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS
	  SET 
	  sps.sps_fecha_toma_posesion = null,
		usuariomodificar = ''HREOS-558'',
		fechamodificar = SYSDATE
	  WHERE EXISTS (
	  WITH PARALIZA AS (
		
				select sps.act_id
				from '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA sps
				inner join '||V_ESQUEMA||'.ACT_ACTIVO act
					on act.act_id = sps.act_id
				inner join '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION bie
					on bie.bie_id = act.bie_id
				left join '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL adn 
				  on adn.act_id = sps.act_id
				where SPS.SPS_FECHA_TOMA_POSESION is not null
				and adn.act_id is null
				and sps.usuariocrear != ''MIG''
				AND SPS.BORRADO = 0
				and bie.bie_adj_f_rea_posesion is null
				and act.act_num_activo != 122951
		
	  )
	  SELECT 1 FROM PARALIZA WHERE PARALIZA.ACT_ID = SPS.ACT_ID
	  )
	'
	;
	
	EXECUTE IMMEDIATE V_MSQL;
	
	V_NUM := SQL%ROWCOUNT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM||' REGISTROS MODIFICADOS.');
	
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]  PROCESO FINALIZADO.');

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
