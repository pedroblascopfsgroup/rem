--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20190530
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4021
--## PRODUCTO=NO
--##
--## Finalidad: DELETE DD_TPD_TIPO_DOCUMENTO DUPLICADO
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	V_ID NUMBER(16);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN

    --DBMS_OUTPUT.PUT_LINE('COMENZANDO EL PROCESO DE ACTUALIZACIÓN');
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ACT_ADT_ADJUNTO_TRABAJO 
						SET DD_TPD_ID = (SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = ''104''), USUARIOMODIFICAR = ''REMVIP-4021'', FECHAMODIFICAR = SYSDATE
						WHERE DD_TPD_ID = (SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = ''115'')';
						
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO 
						SET DD_TPD_ID = (SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = ''104''), USUARIOMODIFICAR = ''REMVIP-4021'', FECHAMODIFICAR = SYSDATE
						WHERE DD_TPD_ID = (SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = ''115'')';	
	COMMIT;
	
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.TPD_TTR WHERE DD_TPD_ID = (SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = ''115'')';

	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = ''115''';
	COMMIT; 
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T006_ValidacionInforme''''][''''comboCorreccion''''] == DDSiNo.SI ? (esFechaMenor(valores[''''T006_ValidacionInforme''''][''''fechaValidacion''''], fechaAprobacionTrabajo()) ? ''''Fecha validaci&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : existeAdjuntoUGValidacion("104","T")) : null'', USUARIOMODIFICAR = ''REMVIP-4021'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T006_ValidacionInforme''';
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
