--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201214
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8532
--## PRODUCTO=NO
--##
--## Finalidad: Poner tareas activa
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8532'; -- USUARIOCREAR/USUARIOMODIFICAR
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     

    V_OFERTA NUMBER(25):= 90282010;
    V_OFERTA_2 NUMBER(25):= 90282012;
    V_TAR_ID NUMBER(25) := 5682670;
    V_TAR_ID_2 NUMBER(25) := 5682678;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    -- Comprobar si la oferta existe
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = 90282010';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;         
    
    IF V_NUM_TABLAS > 0 THEN

        DBMS_OUTPUT.PUT_LINE('[MODIFICAMOS TAREA DE LA OFERTA 90282010 PARA ACTIVARLA]');

        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET 
                        BORRADO = 0,
                        USUARIOMODIFICAR = '''||V_USUARIO||''', 
                        FECHAMODIFICAR = SYSDATE
                        WHERE TAR_ID = '||V_TAR_ID||'';
        EXECUTE IMMEDIATE V_MSQL;

        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS SET 
                        BORRADO = 0,
                        USUARIOMODIFICAR = '''||V_USUARIO||''', 
                        FECHAMODIFICAR = SYSDATE
                        WHERE TAR_ID = '||V_TAR_ID||'';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] LISTO');
    
    ELSE                
        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE LA OFERTA: 90282010');

    END IF;

    -- Comprobar si la oferta existe
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = 90282012';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;         
    
    IF V_NUM_TABLAS > 0 THEN

        DBMS_OUTPUT.PUT_LINE('[MODIFICAMOS TAREA DE LA OFERTA 90282012 PARA ACTIVARLA]');

        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET 
                        BORRADO = 0,
                        USUARIOMODIFICAR = '''||V_USUARIO||''', 
                        FECHAMODIFICAR = SYSDATE
                        WHERE TAR_ID = '||V_TAR_ID_2||'';
        EXECUTE IMMEDIATE V_MSQL;

        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS SET 
                        BORRADO = 0,
                        USUARIOMODIFICAR = '''||V_USUARIO||''', 
                        FECHAMODIFICAR = SYSDATE
                        WHERE TAR_ID = '||V_TAR_ID_2||'';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] LISTO');

    ELSE                
    DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE LA OFERTA: 90282010');

    END IF;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;

END;

/

EXIT
