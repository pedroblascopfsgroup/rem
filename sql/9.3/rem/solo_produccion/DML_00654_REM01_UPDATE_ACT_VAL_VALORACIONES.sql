--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210205
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8867
--## PRODUCTO=NO
--## 
--## Finalidad: Poner importe a 0
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8867';
	V_COUNT NUMBER(16); -- Vble. para comprobar

    V_TABLA VARCHAR2(50 CHAR):= 'ACT_VAL_VALORACIONES';

    V_NUM_ACTIVO VARCHAR2(100 CHAR):='7053467';
    V_ID NUMBER(16); -- Vble. para el id del activo

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

        V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_NUM_ACTIVO||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_ID = '''||V_ID||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT > 0 THEN

            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
               VAL_IMPORTE = 0,
               USUARIOMODIFICAR = '''|| V_USUARIO ||''',
               FECHAMODIFICAR = SYSDATE
               WHERE BORRADO = 1 AND ACT_ID = '''||V_ID||'''';

            EXECUTE IMMEDIATE V_MSQL;         
            
             DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICACIÓN REALIZADA CORRECTAMENTE ');
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE VALORACIÓN PARA EL ACTIVO '''||V_NUM_ACTIVO||''' ');

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