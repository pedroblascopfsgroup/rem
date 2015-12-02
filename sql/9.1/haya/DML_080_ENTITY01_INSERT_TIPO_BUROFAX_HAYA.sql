--/*
--##########################################
--## AUTOR=Vicente Lozano
--## FECHA_CREACION=20151014
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HR-1280
--## PRODUCTO=NO
--## Finalidad: DML para crear un nuevo tipo de burofax REQ-PAGO-SAREB
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

    -- contiene el principio del insert hasta values
    V_INSERT VARCHAR2(2400 CHAR):= 'INSERT INTO ' || V_ESQUEMA || '.' || V_DDNAME || ' (DD_PCO_BFT_ID, DD_PCO_BFT_CODIGO, DD_PCO_BFT_DESCRIPCION, DD_PCO_BFT_DESCRIPCION_LARGA,DD_PCO_BFT_PLANTILLA ,VERSION, USUARIOCREAR, FECHACREAR) VALUES ';

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] Borramos los tipos de burofax anteriores');

V_SQL := 'UPDATE ' || V_ESQUEMA || '.' || V_DDNAME || ' SET BORRADO = 1 WHERE DD_PCO_BFT_CODIGO NOT LIKE ''REQ-PAGO-SAREB''';
EXECUTE IMMEDIATE V_SQL;

DBMS_OUTPUT.PUT_LINE('[INICIO] Poblar diccionario: ' || V_DDNAME || '...');

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFT_CODIGO = ''REQ-PAGO-SAREB''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar tipo burofax REQ-PAGO-SAREB');
    EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFT_TIPO.nextval, ''REQ-PAGO-SAREB'', ''Requerimiento de pago Sareb'', ''Plantilla de requerimiento de pago Sareb'',''POR IMPAGO DEL ${origenContrato} NÚMERO ${numeroContrato} DESDE ${fechaPosicionVencida}, DEL QUE USTED ES ${tipoIntervencion}, EL CONTRATO QUEDA RESUELTO.<br /><br />LA LIQUIDACIÓN PRACTICADA A FECHA ${fechaLiquidacion} ASCIENDE A ${totalLiq} EUROS.<br /><br />SI EN EL PLAZO MAXIMO DE 10 DÍAS LA DEUDA NO HA SIDO LIQUIDADA PROCEDEREMOS A INICIAR LAS ACCIONES JUDICIALES CORRESPONDIENTES.<br /><br />ESTA OPERACIÓN INICIALMENTE FUE CONCEDIDA POR ${entidadOrigen}, HOY BANKIA Y POSTERIORMENTE TRASMITIDA A SOCIEDAD DE GESTIÓN DE ACTIVOS PROCEDENTES DE LA REESTRUCTURACIÓN BANCARIA SOCIEDAD ANONIMA (SAREB), EN CUMPLIMIENTO DEL DEBER LEGAL DE TRANSMISIÓN IMPUESTO POR LA LEY 9/2012 DE 14 DE NOVIEMBRE Y EL REAL DECRETO 1559/2012 DE 15 DE NOVIEMBRE.'', 0, ''INICIAL'', sysdate) ';
ELSE
	DBMS_OUTPUT.PUT_LINE('[INFO] Tipo burofax REQ-PAGO-SAREB YA existe');
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

