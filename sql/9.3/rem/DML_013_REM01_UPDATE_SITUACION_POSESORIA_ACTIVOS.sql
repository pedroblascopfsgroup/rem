--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20190318
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3495
--## PRODUCTO=NO
--##
--## Finalidad: update ACT_SPS_SITUACION_POSESORIA
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
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				INNER JOIN '||V_ESQUEMA||'.ECO_COND_CONDICIONES_ACTIVO ECC ON ACT.ACT_ID = ECC.ACT_ID
				INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID
				INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = ECC.ECO_ID
				INNER JOIN '||V_ESQUEMA||'.DD_SIP_SITUACION_POSESORIA SIP ON SIP.DD_SIP_ID = ECC.DD_SIP_ID
				INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON ACT.DD_SCM_ID = SCM.DD_SCM_ID
				INNER JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
				WHERE SCM.DD_SCM_CODIGO = ''05'' AND SPS.SPS_CON_TITULO = 1 AND SPS.SPS_OCUPADO = 1 AND SIP.DD_SIP_CODIGO = ''03'' 
					AND (EEC.DD_EEC_CODIGO = ''03'' OR EEC.DD_EEC_CODIGO = ''08'')';
					
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS > 0 THEN
		V_MSQL := 'UPDATE (
					SELECT SPS.SPS_CON_TITULO FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
					INNER JOIN '||V_ESQUEMA||'.ECO_COND_CONDICIONES_ACTIVO ECC ON ACT.ACT_ID = ECC.ACT_ID
					INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID
					INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = ECC.ECO_ID
					INNER JOIN '||V_ESQUEMA||'.DD_SIP_SITUACION_POSESORIA SIP ON SIP.DD_SIP_ID = ECC.DD_SIP_ID
					INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON ACT.DD_SCM_ID = SCM.DD_SCM_ID
					INNER JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
					WHERE SCM.DD_SCM_CODIGO = ''05'' AND SPS.SPS_CON_TITULO = 1 AND SPS.SPS_OCUPADO = 1 AND SIP.DD_SIP_CODIGO = ''03'' 
						AND (EEC.DD_EEC_CODIGO = ''03'' OR EEC.DD_EEC_CODIGO = ''08'')) T
				SET T.SPS_CON_TITULO = 0';
		EXECUTE IMMEDIATE V_MSQL;
	ELSE
		DBMS_OUTPUT.PUT_LINE('NINGÚN ACTIVO QUE ACTUALIZAR!');
	END IF;
    --DBMS_OUTPUT.PUT_LINE('COMENZANDO EL PROCESO DE ACTUALIZACIÓN');
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''existeAdjuntoUGCarteraValidacion("36", "E", "01") == null ? valores[''''T013_DefinicionOferta''''][''''comboConflicto''''] == DDSiNo.SI || valores[''''T013_DefinicionOferta''''][''''comboRiesgo''''] == DDSiNo.SI  ?  ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' : comprobarComiteLiberbankPlantillaPropuesta() ? existeAdjuntoUGCarteraValidacion("36", "E", "08") : definicionOfertaT013(valores[''''T013_DefinicionOferta''''][''''comite''''])  : existeAdjuntoUGCarteraValidacion("36", "E", "01")'', USUARIOMODIFICAR = ''REMVIP-3449'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T013_DefinicionOferta''';    
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
