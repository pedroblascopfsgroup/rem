--/*
--##########################################
--## AUTOR=Jorge Martin
--## FECHA_CREACION=20151013
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HR-1256
--## PRODUCTO=NO
--## 
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión PCO
--##########################################
--*/

-- DEPENDE DE:
-- DDL_006_ENTITY01_CREATE_TABLE_DD_PCO_DOC_SOLICIT_TIPOACTOR.sql
-- DML_027_ENTITY01_DD_PCO_DOC_SOLICIT_TIPOACTOR

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
    V_DDNAME VARCHAR2(30):= 'DD_PCO_DOC_SOLICIT_TIPOACTOR';

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] Poblar diccionario: ' || V_DDNAME || '...');


-- tipo actor Registro de la propiedad

DBMS_OUTPUT.PUT_LINE('[INFO] comprobar existencia tipo actor Registro de la propiedad');
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_DSA_CODIGO = ''REGPROP_PCO''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar tipo actor Registro de la propiedad');
    EXECUTE IMMEDIATE 'INSERT INTO ' || V_ESQUEMA || '.' || V_DDNAME || ' (DD_PCO_DSA_ID, DD_PCO_DSA_CODIGO, DD_PCO_DSA_DESCRIPCION, DD_PCO_DSA_DESCRIPCION_LARGA, DD_PCO_DSA_ACCESO_RECOVERY, VERSION, USUARIOCREAR, FECHACREAR) VALUES '
     || ' ('||V_ESQUEMA||'.S_DD_PCO_DOC_SOLICIT_ACTOR.nextval, ''REGPROP_PCO'', ''Registro de la propiedad'', ''Registro de la propiedad'', 0, 0, ''PCO'', sysdate) ';
END IF;


-- tipo actor ARCHIVO_PCO

DBMS_OUTPUT.PUT_LINE('[INFO] comprobar existencia tipo actor ARCHIVO_PCO');
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_DSA_CODIGO = ''ARCHIVO_PCO''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar tipo actor ARCHIVO_PCO');
    EXECUTE IMMEDIATE 'INSERT INTO ' || V_ESQUEMA || '.' || V_DDNAME || ' (DD_PCO_DSA_ID, DD_PCO_DSA_CODIGO, DD_PCO_DSA_DESCRIPCION, DD_PCO_DSA_DESCRIPCION_LARGA, DD_PCO_DSA_ACCESO_RECOVERY, VERSION, USUARIOCREAR, FECHACREAR) VALUES '
     || ' ('||V_ESQUEMA||'.S_DD_PCO_DOC_SOLICIT_ACTOR.nextval, ''ARCHIVO_PCO'', ''Archivo'', ''Archivo'', 0, 0, ''PCO'', sysdate) ';
END IF;


-- tipo actor NOTARI

DBMS_OUTPUT.PUT_LINE('[INFO] comprobar existencia tipo actor Notaria');
V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_DSA_CODIGO = ''NOTARI''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar tipo actor NOTARIA');
    EXECUTE IMMEDIATE 'INSERT INTO ' || V_ESQUEMA || '.' || V_DDNAME || ' (DD_PCO_DSA_ID, DD_PCO_DSA_CODIGO, DD_PCO_DSA_DESCRIPCION, DD_PCO_DSA_DESCRIPCION_LARGA, DD_PCO_DSA_ACCESO_RECOVERY, VERSION, USUARIOCREAR, FECHACREAR) VALUES '
     || ' ('||V_ESQUEMA||'.S_DD_PCO_DOC_SOLICIT_ACTOR.nextval, ''NOTARI'', ''Notaria'', ''Notaria'', 0, 0, ''PCO'', sysdate) ';
ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] comprobar existencia tipo actor Notaria está bien configurado');
    V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_DSA_CODIGO = ''NOTARI'' AND DD_PCO_DSA_ACCESO_RECOVERY = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] se actualiza el actor notaria como que no tiene acceso a recovery');
        V_SQL := 'UPDATE ' || V_ESQUEMA || '.' || V_DDNAME || ' SET DD_PCO_DSA_ACCESO_RECOVERY=0 WHERE DD_PCO_DSA_CODIGO = ''NOTARI''';
        EXECUTE IMMEDIATE V_SQL;
    END IF;

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
