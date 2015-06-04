--/*
--##########################################
--## AUTOR=Nacho A
--## FECHA_CREACION=20150604
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.1-hy-rc01
--## INCIDENCIA_LINK=HR-940
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
   	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO' ||
	          ' SET FLAG_UNICO_BIEN = 1 ' ||
	          ' WHERE DD_TPO_CODIGO = ''H036''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando flag de único bien del trámite de ejecución notarial.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Flag de único bien del trámite actualizado.');
    
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
	          ' SET TAP_SCRIPT_VALIDACION = ''!comprobarBienAsociadoPrc() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom:10px;">' ||
	          '<p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea, deber&aacute; registrar un &uacute;nico bien, para ello debe acceder a la pesta&ntilde;' ||
	          'a Bienes.</p></div>'''': (comprobarExisteDocumentoADS() ? (comprobarExisteDocumentoBOP() ? null ' ||
	          ': ''''Es necesario adjuntar el documento Bolet&iacute;n Oficial Propiedad'''' ) : ''''Es necesario adjuntar el documento Auto declarando subasta'''' ) ''' ||
	          ' WHERE TAP_CODIGO = ''H036_registrarAnuncioSubasta'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando label de los campos.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Label de los campos actualizada.');
    
    
    COMMIT;

EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;
  	