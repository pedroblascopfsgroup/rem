--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20160202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-hy-rc01
--## INCIDENCIA_LINK=HR-1866
--## PRODUCTO=NO
--## Finalidad: Actualización de las validaciones de la tarea.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizando TAP_SCRIPT_VALIDACION_JBPM');

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''H003_CelebracionSubasta''''][''''comboCelebrada''''] == DDSiNo.NO ? (valores[''''H003_CelebracionSubasta''''][''''comboDecisionSuspension''''] == null ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El campo Decisi&oacute;n suspensi&oacute;n es obligatorio</div>'''' : null) : (comprobarExisteDocumentoACS() ? (comprobarNumeroActivo() ? (validarBienesDocCelebracionSubasta() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe rellenar en cada bien los datos de adjudicaci&oacute;n o de cesi&oacute;n remate</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Todos los bienes de la subasta deben tener informado el n&uacute;mero de activo.</div>'''') : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento Acta de subasta</div>'''')'' ' ||
	          ' WHERE TAP_CODIGO = ''H003_CelebracionSubasta''';
    EXECUTE IMMEDIATE V_MSQL;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]');

EXCEPTION     
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(SQLERRM);
    ROLLBACK;
    RAISE; 
END;
/

EXIT;