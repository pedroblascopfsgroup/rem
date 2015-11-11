--/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO
--## FECHA_CREACION=20151006
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=PRODUCTO-290
--## PRODUCTO=SI
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Inserts de la tabla motivos rechazo
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
    V_DDNAME VARCHAR2(30):= 'DD_MTR_MOTIVO_RECHAZO_ACUERDO';

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');


DBMS_OUTPUT.PUT_LINE('[INFO] Bloque scripts para la inclusión de los motivos de rechazo del acuerdo');
DBMS_OUTPUT.PUT('[INFO] Nuevo valor en el diccionario entidad información '||V_DDNAME||'...');

--/**
-- * Nuevo valor en el diccionario DD_MTR_MOTIVO_RECHAZO_ACUERDO
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE DD_MTR_CODIGO= ''01''';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Denegado" en el diccionario '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(DD_MTR_ID,DD_MTR_CODIGO,DD_MTR_DESCRIPCION,DD_MTR_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_DD_MTR_MOTIVO_RECHAZO_ACU.nextval,''01'',''Denegado'',''Denegado'',''0'',''ACUERDOS'',sysdate,''0'') ';

  DBMS_OUTPUT.PUT_LINE('OK modificado');

END IF;

COMMIT;


--/**
-- * Nuevo valor en el diccionario DD_MTR_MOTIVO_RECHAZO_ACUERDO
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE DD_MTR_CODIGO= ''02''';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro "Incompleto / Falta documentación" en el diccionario '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(DD_MTR_ID,DD_MTR_CODIGO,DD_MTR_DESCRIPCION,DD_MTR_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values '||
  '('||V_ESQUEMA||'.S_DD_MTR_MOTIVO_RECHAZO_ACU.nextval,''02'',''Incompleto / Falta documentación'',''Incompleto / Falta documentación'',''0'',''ACUERDOS'',sysdate,''0'') ';

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

