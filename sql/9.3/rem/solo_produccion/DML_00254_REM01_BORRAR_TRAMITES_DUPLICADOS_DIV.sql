--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200416
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7002
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES: Insertar en la tabla AUX_REMVIP_6969 para modificar la fecha de aprobacion de las valoraciones.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= 'REM_IDX'; -- #TABLESPACE_INDEX# Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); --Vble .aux para almacenar el valor de la sequencia
    V_NUM_MAXID NUMBER(16); --Vble .aux para almacenar el valor maximo de ID
    V_SENTENCIA VARCHAR2(2000 CHAR);
    
BEGIN


		V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA USING(
				SELECT TRA_ID FROM (
				SELECT TRA_ID, TBJ_ID, ROW_NUMBER() OVER(PARTITION BY TBJ_ID ORDER BY VERSION DESC) AS ROW_NUM
				FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE 
				WHERE USUARIOCREAR = ''MIG_DIVARIAN'')
				WHERE ROW_NUM > 1) AUX ON (AUX.TRA_ID = TRA.TRA_ID)
				WHEN MATCHED THEN UPDATE SET
				TRA.BORRADO = 1,
				USUARIOBORRAR = ''REMVIP-7002'',
				FECHABORRAR = SYSDATE';

			EXECUTE IMMEDIATE V_SQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Borradas de la TRA '||SQL%ROWCOUNT||' Filas.');

		V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC USING(
				SELECT TRA_ID FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE 
				WHERE USUARIOBORRAR = ''REMVIP-7002'' AND BORRADO = 1 AND USUARIOCREAR = ''MIG_DIVARIAN''
				) AUX ON (TAC.TRA_ID = AUX.TRA_ID)
				WHEN MATCHED THEN UPDATE SET
				TAC.BORRADO = 1,
				TAC.USUARIOBORRAR = ''REMVIP-7002'',
				TAC.FECHABORRAR = SYSDATE';

			EXECUTE IMMEDIATE V_SQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Borradas de la TAC '||SQL%ROWCOUNT||' Filas.');

		V_SQL := 'MERGE INTO TAR_TAREAS_NOTIFICACIONES TAR USING(
				SELECT TAR_ID FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS 
				WHERE USUARIOBORRAR = ''REMVIP-7002'' AND BORRADO = 1 AND USUARIOCREAR = ''MIG_DIVARIAN''
				) AUX ON (TAR.TAR_ID = AUX.TAR_ID)
				WHEN MATCHED THEN UPDATE SET
				TAR.BORRADO = 1,
				TAR.USUARIOBORRAR = ''REMVIP-7002'',
				TAR.FECHABORRAR = SYSDATE
				';

			EXECUTE IMMEDIATE V_SQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  Borradas de la TAR. '||SQL%ROWCOUNT||' Filas.');

	COMMIT;


EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(V_SQL);    
    DBMS_OUTPUT.put_line(ERR_MSG);    
    ROLLBACK;
    RAISE;        

END;
/
EXIT;
