--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20160223
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc37
--## INCIDENCIA_LINK=CMREC-2188
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
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
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] CMREC-2188');
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H002_SenyalamientoSubasta''''][''''fechaSenyalamiento''''] < valores[''''H002_SenyalamientoSubasta''''][''''fechaAnuncio''''] ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;"><p>La fecha de celebraci&oacute;n de subasta no puede ser anterior a la fecha de notificaci&oacute;n de la subasta.</p></div>'''' : comprobarCostasLetradoValidas() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;"><p>&iexcl;Atenci&oacute;n! Las costas del letrado no pueden superar el 5% del principal.</p></div>'''''', USUARIOMODIFICAR = ''CMREC-2188'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[FIN] CMREC-2188');
	
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
