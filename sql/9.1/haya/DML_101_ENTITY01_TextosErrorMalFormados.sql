--/*
--##########################################
--## AUTOR=GONZALO ESTELLES
--## FECHA_CREACION=20150802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hcj
--## INCIDENCIA_LINK=VARIAS
--## PRODUCTO=NO
--##
--## Finalidad: Resolución de varias incidencias de Litigios
--## INSTRUCCIONES: Relanzable
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
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-680,CMREC-669');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''((valores[''''H024_ConfirmarNotDemanda''''][''''comboResultado''''] == DDPositivoNegativo.POSITIVO) && (valores[''''H024_ConfirmarNotDemanda''''][''''fecha''''] == null))?''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Para poder continuar debe indicar la fecha.</div>'''':null'' WHERE TAP_CODIGO = ''H024_ConfirmarNotDemanda''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''((valores[''''H024_RegistrarAudienciaPrevia''''][''''comboResultado''''] == DDSiNo.NO) && (valores[''''H024_RegistrarAudienciaPrevia''''][''''fechaJuicio''''] == null))?''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Para poder continuar debe indicar la fecha del juicio.</div>'''':null'' WHERE TAP_CODIGO = ''H024_RegistrarAudienciaPrevia''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''((valores[''''H038_ConfirmarRequerimientoResultado''''][''''comboRequerido''''] == DDSiNo.SI) && ((valores[''''H038_ConfirmarRequerimientoResultado''''][''''comboResultado''''] == '''''''')||(valores[''''H038_ConfirmarRequerimientoResultado''''][''''comboResultado''''] == null)||(valores[''''H038_ConfirmarRequerimientoResultado''''][''''importeNom''''] == '''''''')||(valores[''''H038_ConfirmarRequerimientoResultado''''][''''importeRet''''] == '''''''')) )?''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Para poder continuar debe indicar el importe base retenci&oacute;n y la retenci&oacute;n.</div>'''':null''  WHERE TAP_CODIGO = ''H038_ConfirmarRequerimientoResultado''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-680,CMREC-669');

	
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