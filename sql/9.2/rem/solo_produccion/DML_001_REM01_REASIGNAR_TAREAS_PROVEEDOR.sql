--/*
--##########################################
--## AUTOR=Guillermo Llidó
--## FECHA_CREACION=20190110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2963
--## PRODUCTO=SI
--##
--## Finalidad: Reasuignar tareas a proveedor.
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIOMODIFICAR VARCHAR2(50 CHAR):= 'REMVIP-2963';
    PL_OUTPUT VARCHAR2(32000 CHAR);
        
BEGIN
		V_MSQL:= 'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS
						SET
							USU_ID = 81859,
							SUP_ID = 81859,
							USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''',
							FECHAMODIFICAR = SYSDATE
					WHERE
						TAR_ID IN (
							SELECT DISTINCT
								TAC.TAR_ID
							FROM
								'||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
								INNER JOIN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC ON
									PVC.PVC_ID = TBJ.PVC_ID
								AND
									PVC.PVC_NOMBRE = ''CASER ASISTENCIA''
								AND
									PVC.PVC_APELLID01 = ''Liberbank''
								AND
									PVC.BORRADO = 0
								INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON
									TRA.TBJ_ID = TBJ.TBJ_ID
								AND
									TRA.BORRADO = 0
								INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON
									TRA.TRA_ID = TAC.TRA_ID
								AND
									TAC.BORRADO = 0
								INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON
									TAR.TAR_ID = TAC.TAR_ID
								AND
									TAR.BORRADO = 0
							WHERE
									TAR.TAR_TAREA LIKE ''Resultado actuación técnica%''
								AND
									TAR.TAR_FECHA_FIN IS NULL
								AND
									TAR.BORRADO = 0
						)';
						
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
