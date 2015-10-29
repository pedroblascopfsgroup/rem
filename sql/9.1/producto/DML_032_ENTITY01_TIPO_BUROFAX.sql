--/*
--##########################################
--## AUTOR=Vicente Lozano
--## FECHA_CREACION=20150804
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-76
--## PRODUCTO=SI
--## Finalidad: DML , Inserción de los tipos de burofax
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
    V_INSERT VARCHAR2(2400 CHAR):= 'INSERT INTO ' || V_ESQUEMA || '.' || V_DDNAME || ' (DD_PCO_BFT_ID,DD_PCO_BFT_CODIGO,DD_PCO_BFT_DESCRIPCION,DD_PCO_BFT_DESCRIPCION_LARGA,DD_PCO_BFT_PLANTILLA,USUARIOCREAR,FECHACREAR) VALUES ';

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] Poblar diccionario: ' || V_DDNAME || '...');

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFT_CODIGO = ''AVAL-EJE-TOT''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar Sí');
    EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFT_TIPO.nextval, ''AVAL-EJE-TOT'', ''AVAL-EJE-TOT Descripcion'', ''AVAL-EJE-TOT Descripcion'',''POR IMPAGO DE LA POLIZA DE COBERTURA DE FIANZA Nº $wvnumcuenta DE LA QUE USTED ES TITULAR, EL CONTRATO QUEDA RESUELTO. EL SALDO DEUDOR A EFECTOS DEL ARTÍCULO 572 DE LA LEY DE ENJUICIAMIENTO CIVIL ASCIENDEA FECHA  $wvfechaliq A LA CANTIDAD DE $wnTOTALLIQ EUROS. SI EN EL PLAZO MÁXIMO DE 10 DÍAS LA DEUDA NO HA SIDO LIQUIDADA, PROCEDEREMOS A INICIAR LAS ACCIONES JUDICIALES CORRESPONDIENTES, SIN PERJUICIO DE PODER INFORMAR SUS DATOS A FICHEROS DE SOLVENCIA PATRIMONIAL.'',''INICIAL'',sysdate) ';
END IF;

V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_BFT_CODIGO = ''AVAL-RES-TOT''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar Si');
    EXECUTE IMMEDIATE V_INSERT || ' ('||V_ESQUEMA||'.S_DD_PCO_BFE_ESTADO.nextval, ''AVAL-RES-TOT'', ''AVAL-RES-TOT Descripcion'', ''AVAL-RES-TOT Descripcion'',''Plantilla'',''INICIAL'' ,sysdate) ';
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




