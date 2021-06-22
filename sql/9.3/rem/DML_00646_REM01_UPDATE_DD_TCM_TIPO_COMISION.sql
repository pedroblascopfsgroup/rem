--/*
--##########################################
--## AUTOR=Adrián Molina Garrido
--## FECHA_CREACION=20210617
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9902
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TABLA VARCHAR2(30 CHAR) := 'DD_TCM_TIPO_COMISION';  -- Tabla a modificar
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-9902'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
                    SET DD_TCM_CODIGO = ''A_BBVA'',
                    USUARIOBORRAR = '''|| V_USR ||''',
                    FECHABORRAR = SYSDATE
                    WHERE DD_TCM_CODIGO = ''A''';

        EXECUTE IMMEDIATE V_MSQL;
        
        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
                    SET DD_TCM_CODIGO = ''B_BBVA'',
                    USUARIOBORRAR = '''|| V_USR ||''',
                    FECHABORRAR = SYSDATE
                    WHERE DD_TCM_CODIGO = ''B''';

        EXECUTE IMMEDIATE V_MSQL;
        
        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
                    SET DD_TCM_CODIGO = ''C_BBVA'',
                    USUARIOBORRAR = '''|| V_USR ||''',
                    FECHABORRAR = SYSDATE
                    WHERE DD_TCM_CODIGO = ''C''';

        EXECUTE IMMEDIATE V_MSQL;


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
