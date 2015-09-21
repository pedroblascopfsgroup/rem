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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    PAR_TABLENAME_TPROC VARCHAR2(50 CHAR) := 'DD_TPO_TIPO_PROCEDIMIENTO';   -- [PARAMETRO] TABLA para tipo de procedimiento. Por defecto DD_TPO_TIPO_PROCEDIMIENTO
    PAR_TABLENAME_TARPR VARCHAR2(50 CHAR) := 'TAP_TAREA_PROCEDIMIENTO';     -- [PARAMETRO] TABLA para tareas del procedimiento. Por defecto TAP_TAREA_PROCEDIMIENTO
    PAR_TABLENAME_TPLAZ VARCHAR2(50 CHAR) := 'DD_PTP_PLAZOS_TAREAS_PLAZAS'; -- [PARAMETRO] TABLA para plazos de tareas. Por defecto DD_PTP_PLAZOS_TAREAS_PLAZAS
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_CURR_ROWARRAY VARCHAR2(25 CHAR);                -- Variable con fila array actual - para excepciones
    VAR_CURR_TABLE VARCHAR2(50 CHAR);                   -- Variable con tabla actual - para excepciones
    
    V_CODIGO_TAP VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Tap tareas
    V_CODIGO_PLAZAS VARCHAR2(100 CHAR); -- Variable para nombre campo FK con codigo de Plazos

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