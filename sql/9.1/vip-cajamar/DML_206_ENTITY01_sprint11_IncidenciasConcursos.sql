--/*
--##########################################
--## AUTOR=GONZALO ESTELLES
--## FECHA_CREACION=20150918
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

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-769');
	V_TAREA:='H009_RectificarInsinuacionCreditos';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = NULL WHERE TAP_CODIGO='''||V_TAREA||'''';

	V_TAREA:='H009_RevisarInsinuacionCreditos';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores['''''||V_TAREA||'''''][''''comboRectificacion''''] == DDSiNo.SI ? ''''si'''' : ''''no'''''' WHERE TAP_CODIGO='''||V_TAREA||'''';

	V_TAREA:='H009_AnyadirTextosDefinitivos';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''existenCreditosContingentesReconocidos() ? valores['''''||V_TAREA||'''''][''''comboLiquidacion''''] == DDSiNo.SI ? ''''siYCreditos'''' : ''''noYCreditos'''' : valores['''''||V_TAREA||'''''][''''comboLiquidacion''''] == DDSiNo.SI ? ''''si'''' : ''''no'''''' WHERE TAP_CODIGO = '''||V_TAREA||'''';
	
	V_TAREA:='H009_RevisarResultadoInfAdmon';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores['''''||V_TAREA||'''''][''''comboAdenda''''] == DDSiNo.SI ? ''''adenda'''' : valores['''''||V_TAREA||'''''][''''comboDemanda''''] == DDSiNo.SI ? ''''demanda'''' : ''''favorable'''''' WHERE TAP_CODIGO = '''||V_TAREA||'''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-769');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-763');
	V_TAREA:='H043_RevisarInsinuacionCreditos';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores['''''||V_TAREA||'''''][''''comboRectificacion''''] == DDSiNo.SI ? ''''si'''' : ''''no'''''' WHERE TAP_CODIGO = '''||V_TAREA||'''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-763');	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-765');
	V_TAREA:='CJ006_RevisarInsinuacionCreditos';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''CJ006_RevisarInsinuacionCreditos''''][''''comboRectificacion''''] == DDSiNo.SI ? ''''si'''' : ''''no'''''' WHERE TAP_CODIGO=''CJ006_RevisarInsinuacionCreditos''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-765');	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-760');
	V_TAREA:='CJ001_RegistrarRespuestaComite';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''CJ001_RegistrarRespuestaComite''''][''''comboResultado''''] == ''''REC'''' ? ''''rechazado'''' : valores[''''CJ001_RegistrarRespuestaComite''''][''''comboResultado''''] == ''''CON_OFE'''' ? ''''contraoferta'''' : ''''aceptado'''''' WHERE TAP_CODIGO = ''CJ001_RegistrarRespuestaComite''';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-760');	
	
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