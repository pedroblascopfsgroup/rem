--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10099
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar situación posesoria
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10099';

    V_ID NUMBER(16); -- Vble. para el id del activo
	V_COUNT NUMBER(16); -- Vble. para comprobar

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR SITUACIÓN POSESORIA DE ACTIVOS');

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 6984257';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

    IF V_COUNT = 1 THEN

        V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 6984257';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;

        V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SET
        DD_SIJ_ID = (SELECT DD_SIJ_ID FROM '||V_ESQUEMA||'.DD_SIJ_SITUACION_JURIDICA WHERE DD_SIJ_CODIGO = ''12''),
        USUARIOMODIFICAR = '''|| V_USUARIO ||''',
        FECHAMODIFICAR = SYSDATE
        WHERE ACT_ID = '||V_ID||'';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] SITUACIÓN POSESORIA DEL ACTIVO 6984257 ACTUALIZADA');

    ELSE 

        DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO 6984257');

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