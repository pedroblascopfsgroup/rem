--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20150911
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-75
--## PRODUCTO=SI
--## Finalidad: DML
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_DDNAME VARCHAR2(30):= 'DD_TPD_PCO_TIPO_PRM_DOC';

    -- contiene el principio del insert hasta values
    V_INSERT VARCHAR2(2400 CHAR):= 'INSERT INTO ' || V_ESQUEMA || '.' || V_DDNAME || ' (DD_TPD_PCO_ID, DD_TPD_PCO_CODIGO, DD_TPD_PCO_DESCRIPCION, DD_TPD_PCO_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR) VALUES ';

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] Poblar diccionario: ' || V_DDNAME || '...');

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_TPD_PCO_CODIGO = ''DOC''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar Documentación');
    EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_TPD_PCO_TIPO_PRM_DOC.nextval, ''DOC'', ''Documentación'', ''Documentación'', 0, ''INICIAL'', sysdate) ';
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_TPD_PCO_CODIGO = ''REQ''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar Requerimiento');
    EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_TPD_PCO_TIPO_PRM_DOC.nextval, ''REQ'', ''Requerimiento'', ''Requerimiento'', 0, ''INICIAL'', sysdate) ';
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_TPD_PCO_CODIGO = ''LIQ''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar Liquidaciones');
    EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_TPD_PCO_TIPO_PRM_DOC.nextval, ''LIQ'', ''Liquidaciones'', ''Liquidaciones'', 0, ''INICIAL'', sysdate) ';
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_TPD_PCO_CODIGO = ''CPR''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar Cambio de procedimiento');
    EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_TPD_PCO_TIPO_PRM_DOC.nextval, ''CPR'', ''Cambio de procedimiento'', ''Cambio de procedimiento'', 0, ''INICIAL'', sysdate) ';
END IF;

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

