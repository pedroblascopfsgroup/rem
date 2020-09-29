--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200922
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11217
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
	  V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_CTAS_CONTABLES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_2 VARCHAR2(2400 CHAR) := 'ACT_CONFIG_PTDAS_PREP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');

        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
            V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CCC
                        USING (SELECT CCC.CCC_CTAS_ID
                        FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CCC
                        LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CCC.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.BORRADO = 0
                        WHERE CCC.BORRADO = 0 AND CRA.DD_CRA_CODIGO = ''08'') AUX
                        ON (CCC.CCC_CTAS_ID = AUX.CCC_CTAS_ID)
                        WHEN MATCHED THEN UPDATE SET 
                          CCC.BORRADO = 1
                          , CCC.USUARIOBORRAR = ''HREOS-11217''
                          , CCC.FECHABORRAR = SYSDATE';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Borradas cuentas: '|| SQL%ROWCOUNT);
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: No existe la tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||'');
        END IF;

         V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA_2||''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
            V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_2||' CPP
                        USING (SELECT CPP.CPP_PTDAS_ID
                        FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_2||' CPP
                        LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CPP.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.BORRADO = 0
                        WHERE CPP.BORRADO = 0 AND CRA.DD_CRA_CODIGO = ''08'') AUX
                        ON (CPP.CPP_PTDAS_ID = AUX.CPP_PTDAS_ID)
                        WHEN MATCHED THEN UPDATE SET 
                          CPP.BORRADO = 1
                          , CPP.USUARIOBORRAR = ''HREOS-11217''
                          , CPP.FECHABORRAR = SYSDATE';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Borradas partidas: '|| SQL%ROWCOUNT);
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: No existe la tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA_2||'');
        END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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
