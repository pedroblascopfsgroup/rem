--/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO
--## FECHA_CREACION=20150729
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=PRODUCTO-159
--## PRODUCTO=SI
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Inserts de la tabla subtipos
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
    V_DDNAME VARCHAR2(30):= 'DD_SBT_SUBTIPO_ACUERDO';

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');


DBMS_OUTPUT.PUT_LINE('[INFO] Bloque scripts para la inclusión de los subtipos de terminos del acuerdo');
DBMS_OUTPUT.PUT('[INFO] Nuevo valor en el diccionario entidad información '||V_DDNAME||'...');

--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE DD_SBT_CODIGO= ''01''';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Estándar" en el diccionario '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(DD_SBT_ID,DD_SBT_CODIGO,DD_SBT_DESCRIPCION,DD_SBT_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_DD_SBT_SUBTIPO_ACUERDO.nextval,''01'',''Estándar'',''Estándar'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE DD_SBT_CODIGO= ''02''';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Especial" en el diccionario '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(DD_SBT_ID,DD_SBT_CODIGO,DD_SBT_DESCRIPCION,DD_SBT_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_DD_SBT_SUBTIPO_ACUERDO.nextval,''02'',''Especial'',''Especial'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

--/**
-- * Nuevo valor en el diccionario DD_EIN_ENTIDAD_INFORMACION
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE DD_SBT_CODIGO= ''03''';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Especial" en el diccionario '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(DD_SBT_ID,DD_SBT_CODIGO,DD_SBT_DESCRIPCION,DD_SBT_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_DD_SBT_SUBTIPO_ACUERDO.nextval,''03'',''Otros'',''Otros'',''0'',''PRODUCTO'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

