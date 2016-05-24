--/*
--##########################################
--## AUTOR=Alberto Soler
--## FECHA_CREACION=20160225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-839
--## PRODUCTO=NO
--## Finalidad: DML , Eliminar tipo de liquidación EXTRACTO CREDITO
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

    V_DDNAME VARCHAR2(30):= 'DD_PCO_LIQ_TIPO';

BEGIN


V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_LIQ_CODIGO = ''EXTRACTO''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] eliminar Sí');
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'|| V_DDNAME || ' WHERE DD_PCO_LIQ_CODIGO = ''EXTRACTO''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_LIQ_CODIGO = ''HIPOTECARIO''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Cambiar nombre plantilla Sí');
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'|| V_DDNAME || ' SET DD_PCO_LIQ_RUTA_PLANTILLA = ''PTAMO_HIPOTECARIO.docx'' WHERE DD_PCO_LIQ_CODIGO = ''HIPOTECARIO''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_LIQ_CODIGO = ''PERSONAL''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Cambiar nombre plantilla Sí');
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'|| V_DDNAME || ' SET DD_PCO_LIQ_RUTA_PLANTILLA = ''PTAMO_PERSONAL.docx'' WHERE DD_PCO_LIQ_CODIGO = ''PERSONAL''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
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
