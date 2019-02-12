--/*
--##########################################
--## AUTOR=SERGIO SALT
--## FECHA_CREACION=20190109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=none
--## PRODUCTO=NO
--##
--## Finalidad: Inserción del metodo checkConOpcionACompra() para la firma del expediente en la tabla : TAP_TAREA_PROCEDIMIENTO > TAP_SCRIPT_VALIDACION_JBPM
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_EXISTE_REGISTRO NUMBER(16); -- Vble. para verificar que existe el registro
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    
BEGIN

    DBMS_OUTPUT.PUT_LINE('Añadiendo el metodo checkConOpcionACompra()');

	V_SQL := 'SELECT count(1)
                FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
                WHERE TAP_CODIGO LIKE ''T015_Firma'' AND DD_TPO_ID = (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO LIKE ''T015'')';
	--DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_REGISTRO;


	IF (V_EXISTE_REGISTRO = 1) THEN
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
                    SET TAP_SCRIPT_VALIDACION_JBPM = ''checkContratoSubido() ? null : checkConOpcionCompra() ? ''''Es necesario adjuntar sobre el Expediente Comercial, el documento Contrato con opción a compra.'''':''''Es necesario adjuntar sobre el Expediente Comercial, el documento Contrato.''''''
                    WHERE TAP_CODIGO LIKE ''T015_Firma'' AND DD_TPO_ID = (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO LIKE ''T015'')';

		DBMS_OUTPUT.PUT_LINE('Se ha actualizado el campo correctamente'); 
		--DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
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