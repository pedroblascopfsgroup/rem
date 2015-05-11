--/*
--##########################################
--## Author: #AUTOR#
--## Finalidad: DML para crear los tipos de documento de fase III
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET DEFINE OFF;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
        
   	V_TEXT VARCHAR2(1024 CHAR);
   	
BEGIN   
  
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comenzando con la modificación de BPM');  
	
	-- CANCELADO POR BANKIA EN FUNCIONAL FASE III
	--V_TEXT := 'comprobarInformacionCompletaInstrucciones() ? (comprobarExisteDocumentoPRI() && comprobarExisteDocumentoINCS() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar los documentos Propuesta de Instrucciones y el Informe de cargas</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">La informaci&oacute;n de las instrucciones de los lotes no est&aacute; completa.</div>''''';
	V_TEXT := 'comprobarInformacionCompletaInstrucciones() ? (comprobarExisteDocumentoPRI() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento Propuesta de Instrucciones.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">La informaci&oacute;n de las instrucciones de los lotes no est&aacute; completa.</div>''''';
	execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''' || V_TEXT || ''' where tap_codigo = ''P401_PrepararPropuestaSubasta''';

	--V_TEXT := 'comprobarInformacionCompletaInstrucciones() ? (comprobarExisteDocumentoPSSB() && comprobarExisteDocumentoFSSF() && comprobarExisteDocumentoFSSB() && comprobarExisteDocumentoINCS() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar los documentos Ficha suelo SAREB, Plantilla subasta SAREB, Front-sheet SAREB y el Informe de cargas.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">La informaci&oacute;n de las instrucciones de los lotes no est&aacute; completa.</div>''''';
	V_TEXT := 'comprobarInformacionCompletaInstrucciones() ? (comprobarExisteDocumentoPSSB() && comprobarExisteDocumentoFSSF() && comprobarExisteDocumentoFSSB() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar los documentos Ficha suelo SAREB, Plantilla subasta SAREB y Front-sheet SAREB.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">La informaci&oacute;n de las instrucciones de los lotes no est&aacute; completa.</div>''''';
	execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion = ''' || V_TEXT || ''' where tap_codigo = ''P409_PrepararPropuestaSubasta''';
	
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN] Modificación de modificación datos de BPM');

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
