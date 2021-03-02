--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210302
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9106
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
   
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error;
    V_USUARIO VARCHAR2(25 CHAR) := 'REMVIP-9106';
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ACT_ID NUMBER(16);
    V_COUNT NUMBER(16);
    V_BBVA_NUM NUMBER(16);

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZAR NÚMERO BBVA DEL ACTIVO 7434899');
	
    V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 7434899';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT > 0 THEN

        V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 7434899';
        EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;

        V_MSQL := 'SELECT '||V_ESQUEMA||'.S_BBVA_NUM_ACTIVO.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_BBVA_NUM;

        V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.ACT_BBVA_ACTIVOS SET 
                        BBVA_NUM_ACTIVO = TO_CHAR('||V_BBVA_NUM||'),
                        BBVA_NUM_ACTIVO_NUM = '||V_BBVA_NUM||',
                        USUARIOMODIFICAR = '''||V_USUARIO||''',
                        FECHAMODIFICAR = SYSDATE
                        WHERE ACT_ID = '||V_ACT_ID||' ';
                                        
        EXECUTE IMMEDIATE V_MSQL;

    ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO] EL ACTIVO 7434899 NO EXISTE');
    
    END IF;

    COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');
	
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