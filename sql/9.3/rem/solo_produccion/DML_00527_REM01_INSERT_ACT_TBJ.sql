--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201111
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8349
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir relación activo - trabajo
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

    -- Ejecutar
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    -- Esquemas 
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    -- Errores
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    -- Usuario
    V_USU VARCHAR2(50 CHAR) := 'REMVIP_8349';
    -- TABLAS
    V_TABLA_ACTIVO VARCHAR2(25 CHAR) := 'ACT_ACTIVO';
    V_TABLA_TRABAJO VARCHAR2(25 CHAR) := 'ACT_TBJ_TRABAJO';
    V_TABLA_ACT_TBJ VARCHAR2(25 CHAR) := 'ACT_TBJ';
    -- ID
    V_ACT_ID NUMBER(16); -- Vble. para el id del activo
    V_TBJ_ID NUMBER(16); -- Vble. para el id del trabajo
    V_NUM_ACTIVO NUMBER(16):= 65639;
    V_NUM_TRABAJO NUMBER(16):= 9000173840;
    -- Contador
	V_COUNT NUMBER(16); -- Vble. para comprobar

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIR RELACIÓN ACTIVO - TRABAJO');

    -- Obtener ID del activo
    V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO = '||V_NUM_ACTIVO;
	EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;

    -- Obtener ID del trabajo
    V_MSQL := 'SELECT TBJ_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TRABAJO||' WHERE TBJ_NUM_TRABAJO = '||V_NUM_TRABAJO;
	EXECUTE IMMEDIATE V_MSQL INTO V_TBJ_ID;

	-- Comprobamos la existencia del activo
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACT_TBJ||' WHERE ACT_ID = '||V_ACT_ID||' AND TBJ_ID = '||V_TBJ_ID;
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

	IF V_COUNT = 0 THEN

        -- Actualizamos la tabla ACT_ACTIVO
        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ACT_TBJ||' VALUES (
            '||V_ACT_ID||',
            '||V_TBJ_ID||',
            100,
            0
            )';
        
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] RELACIÓN ENTRE EL ACTIVO: '||V_NUM_ACTIVO||' Y EL TRABAJO: '||V_NUM_TRABAJO||' INSERTADA CON ÉXITO');

	ELSE 

		DBMS_OUTPUT.PUT_LINE('[INFO] YA RELACIÓN YA SE ENCUENTRA EN LA BBDD');

	END IF;

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