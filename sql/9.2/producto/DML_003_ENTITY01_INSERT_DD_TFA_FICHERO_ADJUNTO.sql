--/*
--##########################################
--## AUTOR=CARLOS MARTOS NAVARRO
--## FECHA_CREACION=20160301
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-692
--## PRODUCTO=SI
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Inserts de la tabla fichero adjunto
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
    V_DDNAME VARCHAR2(30):= 'DD_TFA_FICHERO_ADJUNTO';

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');


DBMS_OUTPUT.PUT_LINE('[INFO] Bloque scripts para la inclusión tipos de adjunto');
DBMS_OUTPUT.PUT('[INFO] Nuevo valor en el diccionario fichero adjunto '||V_DDNAME||'...');

--/**
-- * Nuevo valor en el diccionario DD_TFA_FICHERO_ADJUNTO
-- */
V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE DD_TFA_CODIGO= ''PBOE''';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN    
  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el tipo "Publicacion en el BOE" en el diccionario '||V_DDNAME||'.');

ELSE

  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
  '(DD_TFA_ID,DD_TFA_CODIGO,DD_TFA_DESCRIPCION,DD_TFA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_TAC_ID) values '||
  '('||V_ESQUEMA||'.S_DD_TFA_FICHERO_ADJUNTO.nextval,''PBOE'',''Publicación en el BOE'',''Publicación en el BOE'',''0'',''PRODUCTO'',sysdate,''0'',''3'')';

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
