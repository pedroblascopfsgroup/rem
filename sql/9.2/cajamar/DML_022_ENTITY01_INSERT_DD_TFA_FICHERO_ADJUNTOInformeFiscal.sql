--/*
--##########################################
--## AUTOR=Alberto B.
--## FECHA_CREACION=20160330
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.1-cj
--## INCIDENCIA_LINK= CMREC-2886
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO = ''INFFISC''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 0 THEN
    	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID,DD_TFA_CODIGO,DD_TFA_DESCRIPCION,DD_TFA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TAC_ID) VALUES ('||V_ESQUEMA||'.S_DD_TFA_FICHERO_ADJUNTO.NEXTVAL,''INFFISC'',''Informe Fiscal (Tributación de Bienes)'',''Informe Fiscal (Tributación de Bienes)'',''0'',''CMREC-2886'', SYSDATE ,null,null,null,null,''0'',''8'')';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('OK INSERTADO');
    ELSE
    
    	DBMS_OUTPUT.PUT_LINE('Ya existe el documento');
    
    END IF;
    
    -- Actualizamos la tarea para que coja este codigo del documento
	
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO  = ''H054_EmisionInformeFiscal''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS > 0 THEN
    	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumento(''''INFFISC'''') ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el Informe Fiscal</div>'''''' WHERE TAP_CODIGO = ''H054_EmisionInformeFiscal''';
    	DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('OK INSERTADO');
    ELSE
    
    	DBMS_OUTPUT.PUT_LINE('no existe la tarea');
    
    END IF;
	
	
	COMMIT;
	    
    
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');


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
  	