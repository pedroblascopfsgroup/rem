--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20151120
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-470
--## PRODUCTO=SI
--## Finalidad: DML , La variable que utilizamos para el código de contrato pone ${CODIGO_DE_CONTRATO_DE_17_DIGITOS}, debería poner ${CODIGO_DE_CONTRATO}
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
    V_DDNAME VARCHAR2(30):= 'DD_PCO_BFT_TIPO';

 
BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar diccionario: ' || V_DDNAME || '...');
    
V_SQL := 'UPDATE '||V_ESQUEMA||'.' || V_DDNAME || ' SET dd_pco_bft_plantilla=REPLACE(dd_pco_bft_plantilla, ''${CODIGO_DE_CONTRATO_DE_17_DIGITOS}'', ''${CODIGO_DE_CONTRATO}'') WHERE INSTR(dd_pco_bft_plantilla,''${CODIGO_DE_CONTRATO_DE_17_DIGITOS}'')>0';
EXECUTE IMMEDIATE V_SQL;
DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '... registros afectados: ' || sql%rowcount);

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] Actualizar diccionario: ' || V_DDNAME || '...');

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

