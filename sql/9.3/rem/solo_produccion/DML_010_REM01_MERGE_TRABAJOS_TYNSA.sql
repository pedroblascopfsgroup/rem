--/*
--##########################################
--## AUTOR=Ramon Llinares
--## FECHA_CREACION=20190528
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4279
--## PRODUCTO=SI
--##
--## Finalidad: Script que borra las valoraciones caducadas
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error

BEGIN
	
	  DBMS_OUTPUT.PUT_LINE('[INICIO] ASIGNAMOS TYNSA');
  
    	V_MSQL := '
	MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ 
	    USING (Select TBJ_ID from '||V_ESQUEMA||'.ACT_TBJ_TRABAJO tbj 
			  inner join '||V_ESQUEMA||'.ACT_ACTIVO act on tbj.ACT_ID = act.ACT_ID
			  where tbj.DD_STR_ID = 13 and pvc_id is null and act.DD_CRA_ID in (21,2,121) and tbj.FECHACREAR >= TO_DATE (''19/05/2019'', ''DD/MM/YYYY'')
			  ) TRABAJOS_CHUNGOS
	    ON (TBJ.TBJ_ID = TRABAJOS_CHUNGOS.TBJ_ID)
	  WHEN MATCHED THEN
	    UPDATE 
	       SET USUARIOMODIFICAR = ''REMVIP-4336'',
		       FECHAMODIFICAR = SYSDATE,
			   PVC_ID = 21703	 		
         ';
		
	EXECUTE IMMEDIATE V_MSQL;  
	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] REASIGNANDO TAREAS');
  
    	V_MSQL := '
	MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC 
	    USING ( select tac.TAR_ID from REM01.ACT_TRA_TRAMITE tra 
				INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS tac on tra.TRA_ID = tac.tra_id
				INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = tac.TAR_ID
				where TAR.TAR_TAREA LIKE ''Emisión certificado'' AND TAR.BORRADO = 0 AND tra.TBJ_ID IN
					(
					select tbj.TBJ_ID from '||V_ESQUEMA||'.ACT_TBJ_TRABAJO tbj 
					inner join '||V_ESQUEMA||'.ACT_ACTIVO act on tbj.ACT_ID = act.ACT_ID
					where tbj.USUARIOMODIFICAR = ''REMVIP-4336''
					)
			  ) TAREAS_CHUNGAS
	    ON (TAC.TAR_ID = TAREAS_CHUNGAS.TAR_ID)
	  WHEN MATCHED THEN
	    UPDATE 
	       SET USUARIOMODIFICAR = ''REMVIP-4336'',
		       FECHAMODIFICAR = SYSDATE,
			   USU_ID = 29613	 		
         ';
		
	EXECUTE IMMEDIATE V_MSQL;  
   
	
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