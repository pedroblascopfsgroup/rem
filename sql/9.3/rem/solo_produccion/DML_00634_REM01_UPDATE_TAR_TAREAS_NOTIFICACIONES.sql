--/*
--###########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210122
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8759
--## PRODUCTO=NO
--## 
--## Finalidad: Finalizar tareas de trabajos
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-8759';
  
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
                USING(
                SELECT DISTINCT C.TAR_ID
                FROM(
                SELECT
                TAR.TAR_ID,
                ROW_NUMBER() OVER(PARTITION BY TRA.TRA_ID ORDER BY TAR.TAR_ID DESC) AS RN
                FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP
                INNER JOIN REM01.TEX_TAREA_EXTERNA TEX ON TAP.TAP_ID = TEX.TAP_ID
                INNER JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR ON TEX.TAR_ID = TAR.TAR_ID AND TAR.TAR_TAREA_FINALIZADA = 0
                INNER JOIN REM01.TAC_TAREAS_ACTIVOS TAC ON TAR.TAR_ID = TAC.TAR_ID
                INNER JOIN REM01.ACT_TRA_TRAMITE TRA ON TAC.TRA_ID = TRA.TRA_ID
                INNER JOIN REM01.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = TRA.TBJ_ID
                INNER JOIN REM01.DD_STR_SUBTIPO_TRABAJO STR ON STR.DD_STR_ID = TBJ.DD_STR_ID
                INNER JOIN REM01.DD_TTR_TIPO_TRABAJO TTR ON TTR.DD_TTR_ID = TBJ.DD_TTR_ID
                INNER JOIN REM01.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TRA.DD_TPO_ID = TPO.DD_TPO_ID
                WHERE TBJ.DD_TTR_ID IN (2,3)
                AND TRA.BORRADO = 0
                ) C
                WHERE RN = 1) T2
                ON (T1.TAR_ID = T2.TAR_ID)
                WHEN MATCHED THEN
                    UPDATE SET
                T1.TAR_FECHA_FIN = SYSDATE,
                T1.TAR_TAREA_FINALIZADA = 1,
                T1.USUARIOBORRAR = '''||V_USUARIO||''',
                T1.FECHABORRAR = SYSDATE,
                T1.BORRADO = 1';
		
	EXECUTE IMMEDIATE V_MSQL;  
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADAS '||SQL%ROWCOUNT||' TAREAS');
		
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('[FIN] ');

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
