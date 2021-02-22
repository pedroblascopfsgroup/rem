--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8859
--## PRODUCTO=NO
--## 
--## Finalidad: Revivir tarea
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8859';
	V_COUNT NUMBER(16); -- Vble. para comprobar

    V_TABLA VARCHAR2(50 CHAR):= 'TAC_TAREAS_ACTIVOS';

    V_ACT_NUM VARCHAR2(100 CHAR):='7055988';

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' TAC
                    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON TAC.ACT_ID = ACT.ACT_ID
                    WHERE ACT.ACT_NUM_ACTIVO = '''||V_ACT_NUM||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT > 0 THEN

            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
            USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE,
            BORRADO = 0
            WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_ACT_NUM||''')
            AND USUARIOBORRAR IS NULL AND BORRADO = 1';
            EXECUTE IMMEDIATE V_MSQL;         
            
            DBMS_OUTPUT.PUT_LINE('[INFO] TAREA DEL ACTIVO: '''||V_ACT_NUM||''' REVIVIDA CORRECTAMENTE ');
            
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA TAREA DEL ACTIVO: '''||V_ACT_NUM||''' ');

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