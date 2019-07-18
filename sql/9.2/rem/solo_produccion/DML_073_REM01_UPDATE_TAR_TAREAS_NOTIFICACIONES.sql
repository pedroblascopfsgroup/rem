--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20190718
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4653
--## PRODUCTO=SI
--##
--## Finalidad: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

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
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR 
	SET TAR_FECHA_FIN = SYSDATE,
	TAR_TAREA_FINALIZADA = ''1'',
	USUARIOBORRAR = ''REMVIP-4653'', 
	FECHABORRAR = SYSDATE,
	BORRADO = 1
	WHERE TAR_ID in (SELECT TAR.TAR_ID FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR 
	JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAR.TAR_ID = TAC.TAR_ID 
	JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TAC.TRA_ID = TRA.TRA_ID 
	JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON TRA.TBJ_ID = ECO.TBJ_ID 
	JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON ECO.DD_EEC_ID = EEC.DD_EEC_ID 
	WHERE TAR.TAR_TAREA = ''Resolución tanteo'' 
	AND TAR.TAR_FECHA_FIN IS NULL 
	AND TAR.BORRADO = 0 
	AND EEC.DD_EEC_CODIGO IN (''02'', ''05'', ''11''))';

	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA SET 
							USUARIOMODIFICAR = ''REMVIP-4653''
						  , FECHAMODIFICAR = SYSDATE
						  , USUARIOBORRAR = ''REMVIP-4653''
						  , FECHABORRAR = SYSDATE
						  , BORRADO = 1
							WHERE TAR_ID = 4233660';
			 	
			EXECUTE IMMEDIATE V_MSQL;
	      
  	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAR_TAREAS_NOTIFICACIONES ACTUALIZADA CORRECTAMENTE ');
   	

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
