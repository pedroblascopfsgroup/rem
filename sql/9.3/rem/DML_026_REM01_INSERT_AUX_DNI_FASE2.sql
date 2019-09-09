--/*
--##########################################
--## AUTOR=Carlos López
--## FECHA_CREACION=20190610
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-6668
--## PRODUCTO=NO
--##
--## Finalidad: insertr en la tabla AUX_DNI_FASE2.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_NUM_TABLAS NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(27 CHAR) := 'AUX_DNI_FASE2'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Cambios de usuario DNI'; -- Vble. para los comentarios de las tablas	
    
 BEGIN 
	
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    V_SQL := '  UPDATE '||V_ESQUEMA||'.AUX_USUARIOS_NUEVO_ANTIGUO SET USU_ID = NULL ';
    EXECUTE IMMEDIATE V_SQL ;
    
   DBMS_OUTPUT.PUT_LINE('[INFO] Actualizaciones en AUX_USUARIOS_NUEVO_ANTIGUO '||SQL%ROWCOUNT);  
   
    
    V_SQL := '      
    MERGE INTO '||V_ESQUEMA||'.AUX_USUARIOS_NUEVO_ANTIGUO T1
		USING (
			WITH USUARIOS_UNICOS AS (
				SELECT USERNAME_ACTUAL, USERNAME_DEFINITIVO
				FROM (
				SELECT AUX.USU_ID USU_ID_AUXILIAR, AUX.USERNAME_ACTUAL, AUX.USERNAME_DEFINITIVO, USU.USU_ID USU_ID_USUARIOS, USU.USU_USERNAME
				FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
				JOIN '||V_ESQUEMA||'.AUX_USUARIOS_NUEVO_ANTIGUO AUX ON AUX.USERNAME_ACTUAL = USU.USU_USERNAME OR AUX.USERNAME_DEFINITIVO = USU.USU_USERNAME
				WHERE AUX.USU_ID IS NULL)
				GROUP BY USERNAME_ACTUAL, USERNAME_DEFINITIVO
				HAVING COUNT(1) = 1)
			SELECT USU.USU_ID, AUX.USERNAME_ACTUAL, AUX.USERNAME_DEFINITIVO
			FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
			JOIN USUARIOS_UNICOS AUX ON AUX.USERNAME_ACTUAL = USU.USU_USERNAME OR AUX.USERNAME_DEFINITIVO = USU.USU_USERNAME
			) T2
		ON (T1.USERNAME_ACTUAL = T2.USERNAME_ACTUAL AND T1.USERNAME_DEFINITIVO = T2.USERNAME_DEFINITIVO)
		WHEN MATCHED THEN UPDATE SET
			T1.USU_ID = T2.USU_ID ';
    
    EXECUTE IMMEDIATE V_SQL ;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizaciones en AUX_USUARIOS_NUEVO_ANTIGUO '||SQL%ROWCOUNT);  
    
    V_SQL := ' 
    INSERT INTO '||V_ESQUEMA||'.AUX_DNI_FASE2 (OWNER, TABLE_NAME, COLUMN_NAME, NUM_ROWS,TABLE_PLAN,PROCESADO, ACTUALIZADO)
	SELECT DISTINCT TAB.OWNER, TAB.TABLE_NAME, COL.COLUMN_NAME, TAB.NUM_ROWS
		, CASE 
			WHEN TAB.NUM_ROWS > 1000000 THEN 1
			ELSE 0
			END TABLE_PLAN
		, 0 PROCESADO
		, 0 ACTUALIZADO
	FROM ALL_TABLES TAB
	JOIN ALL_TAB_COLUMNS COL ON COL.TABLE_NAME = TAB.TABLE_NAME
	WHERE COL.COLUMN_NAME LIKE ''USUARIO%AR'' AND TAB.TABLE_NAME NOT LIKE ''%BACKUP%''
		AND TAB.TABLE_NAME NOT LIKE ''MIG%'' AND TAB.TABLE_NAME NOT LIKE ''DD_%''
		AND TAB.TABLE_NAME NOT LIKE ''AUX%'' AND TAB.TABLE_NAME NOT LIKE ''TMP%''
		AND TAB.TABLE_NAME NOT LIKE ''APR%'' AND TAB.TABLE_NAME NOT LIKE ''INFORME%''
		AND NVL(TAB.NUM_ROWS,0) > 0 AND TAB.OWNER IN (''REM01'', ''REMMASTER'') ' ;


    EXECUTE IMMEDIATE V_SQL ;
    
   DBMS_OUTPUT.PUT_LINE('[INFO] Insercciones en AUX_DNI_FASE2 '||SQL%ROWCOUNT); 
	
COMMIT;
DBMS_OUTPUT.PUT_LINE('[INFO] Proceso terminado.');
 
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
