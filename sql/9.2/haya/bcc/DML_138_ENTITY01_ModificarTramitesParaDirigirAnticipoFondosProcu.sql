--/*
--##########################################
--## AUTOR=Alberto Soler
--## FECHA_CREACION=20160509
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1315
--## PRODUCTO=SI
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
    V_NUM_ID NUMBER(16); -- Vble. para guardar el id.
    V_NUM_TMP NUMBER(16); -- Vble. para guardar el id.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_CADENA VARCHAR2(200 CHAR) := 'Se inicia trámite de anticipo de fondos y pago de suplidos';

    BEGIN

    DBMS_OUTPUT.PUT_LINE('[INFO] Comprobaciones previas'); 
    --Comprobamos que existe nuestro xml hcj_provisionFondosProcuModificado
    V_SQL := 'select count(1) from '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO = ''P460''';
    DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    DBMS_OUTPUT.PUT_LINE('VNUMTABLAS ES: '||V_NUM_TABLAS);
    -- Si existe, entonces actualizamos
    IF V_NUM_TABLAS = 1 THEN
      --recuperamos el id que tenemos que actualizar
      V_SQL := 'select DD_TPO_ID from '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO = ''P460''';
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_ID;

      --comprobamos que hay alguna entrada que actualizar
      V_SQL := 'select count(1) from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where DD_TPO_ID_BPM in (select dd_tpo_id from '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO = ''HC107'')';
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TMP;

      IF V_NUM_TMP = 1 THEN
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_DESCRIPCION = '''||V_CADENA||''' WHERE DD_TPO_ID_BPM in (select dd_tpo_id from '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO = ''HC107'')'; 
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET DD_TPO_ID_BPM = '||V_NUM_ID||' WHERE DD_TPO_ID_BPM in (select dd_tpo_id from '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO = ''HC107'')';	
	    DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;
      END IF;

      --VAMOS A CAMBIAR TAMBIÉN EL H005_BPMProvisionFondos
      V_SQL := 'select count(1) from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO = ''H005_BPMProvisionFondos''';
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TMP;

      IF V_NUM_TMP = 1 THEN
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_DESCRIPCION = '''||V_CADENA||''' WHERE TAP_CODIGO = ''H005_BPMProvisionFondos''';
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET DD_TPO_ID_BPM = '||V_NUM_ID||' WHERE TAP_CODIGO = ''H005_BPMProvisionFondos''';
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;    
      END IF;
    END IF;

    COMMIT;
    
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;