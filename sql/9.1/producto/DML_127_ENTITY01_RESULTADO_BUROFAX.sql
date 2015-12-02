--/*
--##########################################
--## AUTOR=MANUEL_MEJIAS
--## FECHA_CREACION=20151029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-366
--## PRODUCTO=SI
--## Finalidad: DML , Inserción de los resultados del burofax
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
    V_DDNAME VARCHAR2(30):= 'DD_PCO_BFR_RESULTADO';

    -- contiene el principio del insert hasta values
    V_INSERT VARCHAR2(2400 CHAR):= 'INSERT INTO ' || V_ESQUEMA || '.' || V_DDNAME || ' (DD_PCO_BFR_ID, DD_PCO_BFR_CODIGO, DD_PCO_BFR_DESCRIPCION, DD_PCO_BFR_DESCRIPCION_LARGA, DD_PCO_BFR_NOTIFICADO, USUARIOCREAR, FECHACREAR) VALUES ';

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] Poblar diccionario: ' || V_DDNAME || '...');
    
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''ENVIADO''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar Sí');
	V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''13''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS > 0 THEN  
    DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  	DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Incompleto / Falta documentación" en el diccionario '||V_DDNAME||'.');
	ELSE
    	EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.nextval, ''13'', ''Enviado'', ''Enviado'', ''0'',''INICIAL'', sysdate) ';
    END IF;
ELSE
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_PCO_BFR_RESULTADO SET DD_PCO_BFR_CODIGO = ''13'', DD_PCO_BFR_NOTIFICADO=''0'' WHERE DD_PCO_BFR_CODIGO = ''ENVIADO'' ';
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''PREPARADO''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar Sí');
     DBMS_OUTPUT.PUT_LINE('[INFO] Insertar Sí');
	V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''11''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS > 0 THEN  
    DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  	DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Incompleto / Falta documentación" en el diccionario '||V_DDNAME||'.');
	ELSE
	EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.nextval, ''11'', ''Preparado'', ''Preparado'', ''0'',''INICIAL'', sysdate) ';
	END IF;
ELSE
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_PCO_BFR_RESULTADO SET DD_PCO_BFR_CODIGO = ''11'', DD_PCO_BFR_NOTIFICADO=''0'' WHERE DD_PCO_BFR_CODIGO = ''PREPARADO'' ';
END IF;


V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''00''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN  
    DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  	DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Incompleto / Falta documentación" en el diccionario '||V_DDNAME||'.');
ELSE
	EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.nextval, ''00'', ''Entregado'', ''Entregado'', ''1'',''INICIAL'', sysdate) ';
	DBMS_OUTPUT.PUT_LINE('Insert Entregado');
END IF;


V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''01''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN  
    DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
ELSE
	EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.nextval, ''01'', ''Dirección incorrecta'', ''Dirección incorrecta'', ''0'',''INICIAL'', sysdate) ';
	DBMS_OUTPUT.PUT_LINE('Insert Entregado');
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''02''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN  
    DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
ELSE
	EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.nextval, ''02'', ''Ausente'', ''Ausente'', ''0'',''INICIAL'', sysdate) ';
	DBMS_OUTPUT.PUT_LINE('Insert Entregado');
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''03''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN  
    DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
ELSE
	EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.nextval, ''03'', ''Desconocido/a'', ''Desconocido/a'', ''0'',''INICIAL'', sysdate) ';
	DBMS_OUTPUT.PUT_LINE('Insert Entregado');
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''04''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN  
    DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
ELSE
	EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.nextval, ''04'', ''Fallecido'', ''Fallecido'', ''0'',''INICIAL'', sysdate) ';
	DBMS_OUTPUT.PUT_LINE('Insert Entregado');
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''05''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN  
    DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
ELSE
	EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.nextval, ''05'', ''Rehusado'', ''Rehusado'', ''0'',''INICIAL'', sysdate) ';
	DBMS_OUTPUT.PUT_LINE('Insert Entregado');
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''06''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN  
    DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
ELSE
	EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.nextval, ''06'', ''No se hace cargo'', ''No se hace cargo'', ''0'',''INICIAL'', sysdate) ';
	DBMS_OUTPUT.PUT_LINE('Insert Entregado');
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''07''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN  
    DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
ELSE
	EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.nextval, ''07'', ''Entregado en oficina'', ''Entregado en oficina'', ''1'',''INICIAL'', sysdate) ';
	DBMS_OUTPUT.PUT_LINE('Insert Entregado');
END IF;


V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''08''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN  
    DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
ELSE
	EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.nextval, ''08'', ''No retirado oficina'', ''No retirado oficina'', ''0'',''INICIAL'', sysdate) ';
	DBMS_OUTPUT.PUT_LINE('Insert Entregado');
END IF;


V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''09''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN  
    DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
ELSE
	EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.nextval, ''09'', ''Devuelto (3 intentos)'', ''Devuelto (3 intentos)'', ''0'',''INICIAL'', sysdate) ';
	DBMS_OUTPUT.PUT_LINE('Insert Entregado');
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''10''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN  
    DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
ELSE
	EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.nextval, ''10'', ''Sobrante'', ''Sobrante'', ''0'',''INICIAL'', sysdate) ';
	DBMS_OUTPUT.PUT_LINE('Insert Entregado');
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''12''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN  
    DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
ELSE
	EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.nextval, ''12'', ''Solicitado'', ''Solicitado'', ''0'',''INICIAL'', sysdate) ';
	DBMS_OUTPUT.PUT_LINE('Insert Entregado');
END IF;


V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''14''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN  
    DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
ELSE
EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.nextval, ''14'', ''Procesado'', ''Procesado'', ''0'',''INICIAL'', sysdate) ';
	DBMS_OUTPUT.PUT_LINE('Insert Entregado');
END IF;


V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFR_CODIGO = ''15''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN  
    DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
ELSE
EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.nextval, ''15'', ''Incidentado'', ''Incidentado'', ''0'',''INICIAL'', sysdate) ';
	DBMS_OUTPUT.PUT_LINE('Insert Entregado');
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
