--/*
--##########################################
--## AUTOR=GONZALO ESTELLES
--## FECHA_CREACION=20151007
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.5-hcj
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TAREA VARCHAR(50 CHAR);
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-883');
	V_TAREA:='H052_RegistrarPresentacionEscritoSub';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''valoresBPMPadre[''''H005_RegistrarInscripcionDelTitulo''''] != null ? damePlazo(dameFechaFinTareaProcedimientoPadre(''''H005_RegistrarInscripcionDelTitulo'''')) + 5*24*60*60*1000L : 10*24*60*60*1000L'' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TAREA||''')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-883');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-891');
	V_TAREA:='H008_RegInsCancelacionCargasReg';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''!comprobarEstadoCargasCancelacion() ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Todas las cargas registrales deben ser informadas en estado cancelada o rechazada</div>'''' : comprobarExisteDocumentoSCBCCR() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Documento acreditativo de la cancelaci&oacute;n de cargas registrales.</div>'''''' WHERE TAP_CODIGO = '''||V_TAREA||'''';

	V_TAREA:='H008_RegInsCancelacionCargasRegEco';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''!comprobarEstadoCargasCancelacion() ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Todas las cargas registrales deben ser informadas en estado cancelada o rechazada</div>'''' : comprobarExisteDocumentoSCBCCR() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el Documento acreditativo de la cancelaci&oacute;n de cargas registrales.</div>'''''' WHERE TAP_CODIGO = '''||V_TAREA||'''';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-891');
	
	
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