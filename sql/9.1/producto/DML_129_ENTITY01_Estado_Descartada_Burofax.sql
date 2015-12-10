--/*
--##########################################
--## AUTOR=Alberto Soler
--## FECHA_CREACION=20151123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-355
--## PRODUCTO=SI
--## Finalidad: DML , Inserción de un nuevo estado de burofax
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
    V_TMP VARCHAR2(32000 CHAR); -- Sentencia a ejecutar temporal 
    V_RESULT VARCHAR2(32000 CHAR); -- Sentencia a ejecutar temporal 
    V_INSERT VARCHAR2(2400 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_DDNAME VARCHAR2(30):= 'DD_PCO_BFE_ESTADO';
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');
    V_TMP := 'SELECT count(*)  FROM '||V_ESQUEMA||'.' || V_DDNAME || ' WHERE DD_PCO_BFE_CODIGO = ''DESC''';
    --DBMS_OUTPUT.PUT_LINE(V_TMP);
    EXECUTE IMMEDIATE V_TMP INTO V_RESULT; 
    --DBMS_OUTPUT.PUT_LINE(V_RESULT);
    -- contiene el principio del insert hasta values
    V_INSERT:= 'INSERT INTO ' || V_ESQUEMA || '.' || V_DDNAME || ' (DD_PCO_BFE_ID, DD_PCO_BFE_CODIGO, DD_PCO_BFE_DESCRIPCION, DD_PCO_BFE_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES ';

IF(V_RESULT = 0) THEN 
DBMS_OUTPUT.PUT_LINE('EL CAMPO DESC ES NULL, POR TANTO LO CREAMOS');
EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFE_ESTADO.nextval, ''DESC'', ''Descartada'', ''Descartada'',''INICIAL'', sysdate) ';
ELSE
DBMS_OUTPUT.PUT_LINE('EL CAMPO DESC YA EXISTE');
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
