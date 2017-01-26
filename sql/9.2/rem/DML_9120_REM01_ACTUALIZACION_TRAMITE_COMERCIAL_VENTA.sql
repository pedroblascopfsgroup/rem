--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20170125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=0
--## PRODUCTO=SI
--##
--## Finalidad: Realiza las modificaciones necesarias para el trámite de sanción de ofertas.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

    --REGISTRO TFI ELEGIDO
    V_TFI_TAP_CODIGO VARCHAR2(100 CHAR) := '';
    V_TFI_TFI_NOMBRE VARCHAR2(100 CHAR) := 'titulo';

    --CAMPO TFI PARA ACTUALIZAR
    V_TFI_CAMPO VARCHAR2(100 CHAR)  := 'tfi_label';
    V_TFI_VALOR VARCHAR2(4000 CHAR) := '';
    
BEGIN
    
    
    V_TFI_TAP_CODIGO := 'T013_PosicionamientoYFirma';
  	V_TFI_TFI_NOMBRE := 'titulo';
  	V_TFI_CAMPO := 'tfi_label';
	V_TFI_VALOR := '<p style="margin-bottom: 10px">La operación ya está lista para su firma. Contacte con los intervientes del expediente para acordar una fecha para la firma del contrato de compraventa. Asimismo, recopile todos los juegos de llaves del activo y la documentación necesaria para la firma.</p> <p style="margin-bottom: 10px">Para finalizar esta tarea, indique si la firma se ha llevado a término, y en su caso, la fecha efectiva de escritura y el número de protocolo. Para dar por finalizada la tarea deberá subir al expediente los siguientes documentos: Copia simple (obligatorio), Hoja de datos (obligatorio), minuta, recibí llaves firmado por el cliente y el justificante de ingreso del cheque. La siguiente tarea que se lanzará es "Documentos postventa".</p> <p style="margin-bottom: 10px">Si la firma se ha cancelado, anule el expediente indicando el motivo, finalizando así el trámite. Se le enviará una notificación a los gestores comercial y de formalización.</p> <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>';
  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  	DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
  	EXECUTE IMMEDIATE V_MSQL;
  	
  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = '''' '||
			  ' WHERE TAP_CODIGO = ''T013_ResultadoPBC'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
  	/*
  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = '''' '||	  
			  ' WHERE TAP_CODIGO = ''T013_DefinicionOferta'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T013_DefinicionOferta''''][''''comboConflicto''''] == DDSiNo.SI ? (valores[''''T013_DefinicionOferta''''][''''comboRiesgo''''] == DDSiNo.SI ? checkFormalizacion() ? (checkDeDerechoTanteo() == false ? (checkAtribuciones() ? null : (checkBankia() ? (altaComite() ? null : ''''Ha fallado el alta del comite'''') : null)) : null) : null ) : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar'''') : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar'''' '' '||
			  ' WHERE TAP_CODIGO = ''T013_DefinicionOferta'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
	*/
    
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