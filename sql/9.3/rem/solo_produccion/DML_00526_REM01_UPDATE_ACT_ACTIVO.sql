--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201111
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8349
--## PRODUCTO=NO
--## 
--## Finalidad: Revivir activo
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
    V_TABLA_PERIMETRO VARCHAR2(50 CHAR) := 'ACT_PAC_PERIMETRO_ACTIVO';
    -- ID
    V_NUM_ACTIVO NUMBER(16) := 65639; -- Vble. para el num del activo
    V_ID_ACTIVO NUMBER(16);
    -- Contador
	V_COUNT NUMBER(16); -- Vble. para comprobar

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: REVIVIR ACTIVO');

    -- Obtener ID del activo
    V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO = '||V_NUM_ACTIVO;
	EXECUTE IMMEDIATE V_MSQL INTO V_ID_ACTIVO;

	-- Comprobamos la existencia del activo
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_ID = '||V_ID_ACTIVO;
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

	IF V_COUNT = 1 THEN

        -- Actualizamos la tabla ACT_ACTIVO
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' SET 
            USUARIOMODIFICAR = '''||V_USU||''',
            FECHAMODIFICAR = SYSDATE,
            USUARIOBORRAR = NULL,
            FECHABORRAR = NULL,
            BORRADO = 0
            WHERE ACT_ID = '''||V_ID_ACTIVO||'''';
        
        EXECUTE IMMEDIATE V_MSQL;
    
        -- Actualizamos la tabla ACT_PAC_PERIMETRO_ACTIVO
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_PERIMETRO||' SET
            PAC_INCLUIDO = 1,
            PAC_CHECK_GESTIONAR = 1,
            PAC_FECHA_GESTIONAR = TO_DATE(SYSDATE, ''DD/MM/YY''),
            PAC_CHECK_COMERCIALIZAR = 1,
            PAC_FECHA_COMERCIALIZAR = TO_DATE(SYSDATE, ''DD/MM/YY''),
            PAC_CHECK_FORMALIZAR = 1,
            PAC_FECHA_FORMALIZAR = TO_DATE(SYSDATE, ''DD/MM/YY''),
            PAC_CHECK_PUBLICAR = 1,
            PAC_FECHA_PUBLICAR = TO_DATE(SYSDATE, ''DD/MM/YY''),
            VERSION = 5,
            USUARIOMODIFICAR = '''||V_USU||''', 
            FECHAMODIFICAR = SYSDATE 
            WHERE ACT_ID = '''||V_ID_ACTIVO||'''';
        
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] ACTIVO '''||V_NUM_ACTIVO||''' REVIVIDO CON ÉXITO');

	ELSE 

		DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO '''||V_NUM_ACTIVO||'''');

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