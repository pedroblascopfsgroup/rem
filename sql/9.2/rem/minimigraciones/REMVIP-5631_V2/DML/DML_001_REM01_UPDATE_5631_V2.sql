--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191030
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5631
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva de aprobación del informe comercial
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-5631_V2'; -- USUARIOCREAR/USUARIOMODIFICAR.

    
BEGIN		


        DBMS_OUTPUT.PUT_LINE('[INICIO] Cerrando Tareas ');	

	V_MSQL := ' MERGE INTO REM01.TAR_TAREAS_NOTIFICACIONES TAR
		    USING( 

			 	SELECT DISTINCT TAR.TAR_ID
				FROM REM01.ACT_TRA_TRAMITE TRA, REM01.TAC_TAREAS_ACTIVOS TAC, REM01.TAR_TAREAS_NOTIFICACIONES TAR
				WHERE 1 = 1
				AND TAC.TAR_ID = TAR.TAR_ID
				AND TRA.TRA_ID = TAC.TRA_ID
				AND TAR.BORRADO = 0
				AND TAC.BORRADO = 0
				AND TRA.BORRADO = 0
				AND TRA.TRA_ID IN (SELECT TRA_ID FROM REM01.AUX_REMVIP_5631_V2)
			) AUX
		    ON ( AUX.TAR_ID = TAR.TAR_ID )
		    WHEN MATCHED THEN UPDATE SET
		    TAR_FECHA_FIN = SYSDATE,
		    TAR_TAREA_FINALIZADA = 1,
		    BORRADO = 1,	
		    FECHABORRAR = SYSDATE,
		    USUARIOBORRAR = ''' || V_USR || '''';	

	--DBMS_OUTPUT.PUT_LINE(V_MSQL); 	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros de TAR_TAREAS_NOTIFICACIONES '); 



	DBMS_OUTPUT.PUT_LINE('[INICIO] Cerrando Tramites ');	

	V_MSQL := ' MERGE INTO REM01.ACT_TRA_TRAMITE TRA
		    USING( 

			 	SELECT DISTINCT TRA.TRA_ID
				FROM REM01.ACT_TRA_TRAMITE TRA, REM01.TAC_TAREAS_ACTIVOS TAC, REM01.TAR_TAREAS_NOTIFICACIONES TAR
				WHERE 1 = 1
				AND TAC.TAR_ID = TAR.TAR_ID
				AND TRA.TRA_ID = TAC.TRA_ID
				AND TAC.BORRADO = 0
				AND TRA.BORRADO = 0
				AND TRA.TRA_ID IN (SELECT TRA_ID FROM REM01.AUX_REMVIP_5631_V2)
			) AUX
		    ON ( AUX.TRA_ID = TRA.TRA_ID )
		    WHEN MATCHED THEN UPDATE SET
		    DD_EPR_ID = ( SELECT DD_EPR_ID FROM REMMASTER.DD_EPR_ESTADO_PROCEDIMIENTO EPR WHERE DD_EPR_CODIGO = ''05'' ),
		    TRA_FECHA_FIN = SYSDATE,	
		    FECHAMODIFICAR = SYSDATE,
		    USUARIOMODIFICAR = ''' || V_USR || '''' ;

	--DBMS_OUTPUT.PUT_LINE(V_MSQL); 
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros de ACT_TRA_TRAMITE '); 

	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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
