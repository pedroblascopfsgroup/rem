--/*
--#########################################
--## AUTOR=Joaquin Bahamonde
--## FECHA_CREACION=20200204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9179
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_TBJ_TRABAJO';
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'HREOS-9179';

BEGIN

--BUSCA Y ACTUALIZA  RESPONSABLE TRABAJOS 

		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de actualizacion DE TRABAJOS');
		
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
			USING (
                SELECT DISTINCT TBJ_NUM_TRABAJO 
			FROM REM01.ACT_TBJ_TRABAJO TBJ
            JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID AND TRA.BORRADO = 0 AND TRA.TRA_FECHA_FIN IS NULL
            JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID AND TAC.BORRADO = 0
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = TBJ.ACT_ID AND ACT.BORRADO = 0
            JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID  AND TAR_TAREA_FINALIZADA = 0 AND TAR.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''02''
            WHERE TAC.USU_ID IS NOT NULL
            AND TBJ.BORRADO = 0
        ) T2 
        ON (T1.TBJ_NUM_TRABAJO = T2.TBJ_NUM_TRABAJO)
        WHEN MATCHED THEN 
        UPDATE SET 
        T1.TBJ_RESPONSABLE_TRABAJO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''grupgact''), 
        T1.FECHAMODIFICAR = SYSDATE, 
        T1.USUARIOMODIFICAR = '''||V_INCIDENCIA||'''';
						
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla de trabajos.');

		COMMIT;

		DBMS_OUTPUT.PUT_LINE('[FIN] Finaliza el proceso de actualizacion.');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
