--/*
--##########################################
--## AUTOR=PedroBlasco
--## FECHA_CREACION=20150716
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
    V_DDNAME VARCHAR2(30):= 'DD_PCO_DOC_ESTADO';

    -- contiene el principio del insert hasta values
    V_INSERT VARCHAR2(2400 CHAR):= 'INSERT INTO ' || V_ESQUEMA || '.' || V_DDNAME || ' (DD_PCO_DED_ID, DD_PCO_DED_CODIGO, DD_PCO_DED_DESCRIPCION, DD_PCO_DED_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR) VALUES ';

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] Poblar diccionario: ' || V_DDNAME || '...');

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_DED_CODIGO = ''PS''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar estado Pendiente solicitar');
    EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_DOC_ESTADO.nextval, ''PS'', ''Pendiente solicitar'', ''Pendiente solicitar'', 0, ''INICIAL'', sysdate) ';
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_DED_CODIGO = ''SO''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar estado Solicitado');
    EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_DOC_ESTADO.nextval, ''SO'', ''Solicitado'', ''Solicitado'', 0, ''INICIAL'', sysdate) ';
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_DED_CODIGO = ''EN''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar estado Enviado');
    EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_DOC_ESTADO.nextval, ''EN'', ''Enviado'', ''Enviado'', 0, ''INICIAL'', sysdate) ';
END IF;


V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_DED_CODIGO = ''DI''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar estado Disponible/Recibido');
    EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_DOC_ESTADO.nextval, ''DI'', ''Disponible/Recibido'', ''Disponible/Recibido'', 0, ''INICIAL'', sysdate) ';
END IF;


V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_DED_CODIGO = ''DE''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar estado Descartado');
    EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_DOC_ESTADO.nextval, ''DE'', ''Descartado'', ''Descartado'', 0, ''INICIAL'', sysdate) ';
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

