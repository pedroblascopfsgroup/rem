--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20170223
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1623
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
    V_TFI_TFI_NOMBRE VARCHAR2(100 CHAR) := '';

    --CAMPO TFI PARA ACTUALIZAR
    V_TFI_CAMPO VARCHAR2(100 CHAR)  := '';
    V_TFI_VALOR VARCHAR2(4000 CHAR) := '';
    V_TFI_CAMPO2 VARCHAR2(100 CHAR)  := '';
    V_TFI_VALOR2 VARCHAR2(4000 CHAR) := '';
    
BEGIN
    
    
    V_TFI_TAP_CODIGO := 'T013_DefinicionOferta';
  	V_TFI_CAMPO := 'tfi_tipo';
  	V_TFI_VALOR := 'comboini';
  	V_TFI_CAMPO2 := 'tfi_validacion';
  	V_TFI_VALOR2 := 'false';
  	
  	V_TFI_TFI_NOMBRE := 'comboConflicto';
  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando '||V_TFI_TFI_NOMBRE ||' .......');
  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''', '||V_TFI_CAMPO2||'='''||V_TFI_VALOR2||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';
    DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
  	EXECUTE IMMEDIATE V_MSQL;
             
    V_TFI_TFI_NOMBRE := 'comboRiesgo';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando '||V_TFI_TFI_NOMBRE ||' .......');
  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''', '||V_TFI_CAMPO2||'='''||V_TFI_VALOR2||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';
    DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
  	EXECUTE IMMEDIATE V_MSQL;
  	
  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando TAP_SCRIPT_VALIDACION de la tarea.......');
  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''checkBankia() ? (checkImpuestos() ? null : ''''Debe indicar el tipo de impuesto y tipo aplicable.'''' ) : null '' '||	  
			  ' WHERE TAP_CODIGO = ''T013_DefinicionOferta'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
  	
  	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando TAP_SCRIPT_VALIDACION_JBPM de la tarea.......');
  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
		  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T013_DefinicionOferta''''][''''comboConflicto''''] != DDSiNo.SI && valores[''''T013_DefinicionOferta''''][''''comboRiesgo''''] != DDSiNo.SI ? (checkFormalizacion() ? (checkDeDerechoTanteo() == false ? (checkBankia() ? (altaComite() ? null : ''''Ha fallado el alta del comite'''')   : null) : null) : null) : ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' '' '||
		  ' WHERE TAP_CODIGO = ''T013_DefinicionOferta'' ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    

	
   
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