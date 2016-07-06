--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20160629
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1635
--## PRODUCTO=NO
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
    V_TMP NUMBER(16); -- Vble. para validar la existencia de una tabla.      
    V_TMP_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_DDNAME VARCHAR2(30);
    V_ID_MAX NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_DD_TDE_ID_OFI NUMBER(16); -- Vble. para almacenar el DD_TDE_ID del tipo despacho oficina.

BEGIN


DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nuevo despacho Notaria de escrituras, Notaria para Acta de liquidación, Notaria para nota simple');
V_NUM_TABLAS := 0;
V_SQL := 'SELECT DD_TDE_ID FROM ' || V_ESQUEMA_M || '.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = ''NOTARI''';
EXECUTE IMMEDIATE V_SQL INTO V_DD_TDE_ID_OFI;
DBMS_OUTPUT.PUT_LINE('[INFO] hay id de DD_TDE_TIPO_DESPACHO: ' || V_DD_TDE_ID_OFI );

DBMS_OUTPUT.PUT_LINE('[INFO] Se consulta tipo despacho Notarias');

V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DD_TDE_ID = ' || V_DD_TDE_ID_OFI;
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN
  V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO= ''Notaría''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  IF V_NUM_TABLAS > 0 THEN
  	V_MSQL := 'UPDATE ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO SET USUARIOBORRAR = ''PRODUCTO-1635'', FECHABORRAR = SYSDATE, BORRADO = 0 WHERE DES_DESPACHO= ''Notaría'''; 
  	EXECUTE IMMEDIATE V_MSQL;
  END IF;

  V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO= ''Notaria de escrituras''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  IF V_NUM_TABLAS > 0 THEN
  	V_MSQL := 'UPDATE ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO SET USUARIOBORRAR = ''PRODUCTO-1635'', FECHABORRAR = SYSDATE, BORRADO = 1 WHERE DES_DESPACHO= ''Notaria de escrituras'''; 
  	EXECUTE IMMEDIATE V_MSQL;
  END IF;
  
  V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO= ''Notaria para Acta de liquidación''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  IF V_NUM_TABLAS > 0 THEN
  	V_MSQL := 'UPDATE ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO SET USUARIOBORRAR = ''PRODUCTO-1635'', FECHABORRAR = SYSDATE, BORRADO = 1 WHERE DES_DESPACHO= ''Notaria para Acta de liquidación'''; 
  	EXECUTE IMMEDIATE V_MSQL;
  END IF;

  V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO= ''Notaria para nota simple''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  IF V_NUM_TABLAS > 0 THEN
  	V_MSQL := 'UPDATE ' || V_ESQUEMA || '.DES_DESPACHO_EXTERNO SET USUARIOBORRAR = ''PRODUCTO-1635'', FECHABORRAR = SYSDATE, BORRADO = 1 WHERE DES_DESPACHO= ''Notaria para nota simple'''; 
  	EXECUTE IMMEDIATE V_MSQL;
  END IF;

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

