--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180926
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1993
--## PRODUCTO=SI
--## Finalidad: Actualización del campo ACT_ACTIVO_COOPER a 1 en ACT_ACTIVO para los activos de la migración Cooper con el flag a 2.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

	VN_COUNT NUMBER;
	V_TABLENAME VARCHAR2(35 CHAR):= 'ACT_ACTIVO'; 
	V_CAMPO VARCHAR2(35 CHAR):= 'ACT_ACTIVO_COOPER';
	V_INCIDENCIALINK VARCHAR(35 CHAR):='REMVIP-1993';
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.

	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Comienza el script que updatea a 1 el flag ACT_ACTIVO_COOPER de los activos que tengan el flag igual a 2.');	
		
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLENAME||' ACTIVOS
                   SET 
                        USUARIOMODIFICAR = '''||V_INCIDENCIALINK||''', 
                        FECHAMODIFICAR = SYSDATE, 
                        '||V_CAMPO||' = 1
                   WHERE EXISTS (                        
                        SELECT 1 
                        FROM  '||V_ESQUEMA||'.'||V_TABLENAME||'               ACT
                        WHERE ACTIVOS.ACT_ID = ACT.ACT_ID
                          AND ACT.'||V_CAMPO||' = 2
                   )
		';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'   ACT_ACTIVO '||SQL%ROWCOUNT||' activos actualizados.');

        COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');
    
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
