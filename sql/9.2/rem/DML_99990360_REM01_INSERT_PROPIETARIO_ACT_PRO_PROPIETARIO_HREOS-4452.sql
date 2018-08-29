--/*
--##########################################
--## AUTOR=Rasul Abdulaev
--## FECHA_CREACION=20180829
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4452
--## PRODUCTO=SI
--##
--## Finalidad: DML Aniadir un nuevo propietario a la tabla ACT_PRO_PROPIETARIO.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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
    V_NUM_REGISTROS NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_DDNAME VARCHAR2(30):= 'ACT_PRO_PROPIETARIO'; -- Vble. del nombre de la tabla
    V_ID NUMBER(16); -- Vble.auxiliar para sacar un ID.
    V_ID2 NUMBER(16); -- Vble.auxiliar para sacar un ID.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** ACT_PRO_PROPIETARIO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_DDNAME||' ... Comprobaciones previas ACT_PRO_PROPIETARIO');

    V_SQL := ' SELECT count(1) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE PRO_NOMBRE LIKE ''ZEUS REAL STATE INVESTMENT 1 SL'' ';	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTROS;

    IF V_NUM_REGISTROS = 0 THEN

        V_MSQL:= 'SELECT '||V_ESQUEMA||'.S_'||V_DDNAME||'.nextval FROM dual';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;

        V_MSQL:= 'SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_DESCRIPCION LIKE ''Egeo''';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID2;

        V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.'||V_DDNAME||' (PRO_ID, PRO_NOMBRE, PRO_DOCIDENTIF, USUARIOCREAR, FECHACREAR, DD_CRA_ID) VALUES ('||V_ID||', ''ZEUS REAL STATE INVESTMENT 1 SL'', ''R9602817J'', ''HREOS-4452'', sysdate, '||V_ID2||')';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA '||V_DDNAME||'' );

    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] No se han podido actualizar los registros de la tabla '||V_ESQUEMA||'.'||V_DDNAME||'');
    END IF;

    COMMIT;
   
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
EXIT