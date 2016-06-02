--/*
--##########################################
--## AUTOR=ALBERTO CAMPOS
--## FECHA_CREACION=20151217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc34
--## INCIDENCIA_LINK=CMREC-1238
--## PRODUCTO=NO
--##
--## Finalidad: Resolución de incidencias de concursos
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-1238');
	V_TAREA:='H017_RegistrarSentenciaFirme';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET ' ||
	' TAP_SCRIPT_VALIDACION_JBPM=''existenConveniosDefinidos() ? (valores[''''H017_RegistrarSentenciaFirme''''][''''comboAdmision''''] == DDSiNo.SI ? (ExistenConvenioAdmitidoTrasAprovacion() ? null : ''''Debe existir al menos un convenio asociado al asunto con el estado "Admitido tras aprobaci&oacute;n".'''') : (NoExisteConvenioNoAdmitidoTrasAprovacion() ? ''''Debe existir al menos un convenio asociado al asunto con el estado "No admitido tras aprobaci&oacute;n".'''' : null)) : ''''Debe registrar al menos un convenio desde la pesta&nacute;a "Convenios" del asunto.'''''' WHERE TAP_CODIGO='''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-1238');
	
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