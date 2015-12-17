--/*
--##########################################
--## AUTOR=G Estellés
--## FECHA_CREACION=20151127
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj
--## INCIDENCIA_LINK=CMREC-1479
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite prov. fondos
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

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-1479');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
          ' SET TAP_SCRIPT_VALIDACION_JBPM = ''!validarHC103SolicitudFondos() ? ''''Los campos N&uacute;mero de auto, Importe de la adjudicaci&oacute;n, Tipo de impuesto a liquidar, Tipo del impuesto de Transmisiones patromoniales, Importe del impuesto de transmisiones Patrimoniales y Fecha fin de plazo de liquidaci&oacute;n del impuesto son obligatorios.'''' : null'' ' ||
          ' WHERE TAP_CODIGO = ''HC103_SolicitarProvision'' ';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_ERROR_VALIDACION=NULL' ||
	  ' ,TFI_VALIDACION=NULL' ||
	  ' WHERE TFI_NOMBRE IN (''numAuto'',''importeAdj'',''tipoImpLiquidar'',''tipoImpTrPatr'',''impTrPatr'',''fechaFinLiqImp'') AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO=''HC103_SolicitarProvision'')';
	EXECUTE IMMEDIATE 'update '||V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET ' ||
	  ' TFI_LABEL=''Importe del impuesto de Trans. Patr.''' ||
	  ' ,TFI_VALIDACION=NULL' ||
	  ' WHERE TFI_NOMBRE=''impTrPatr'' AND TAP_ID IN (select tap_id from '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO=''HC103_SolicitarProvision'')';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-1479');

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