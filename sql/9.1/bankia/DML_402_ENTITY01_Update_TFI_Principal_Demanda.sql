/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=20160121
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-1477
--## PRODUCTO=NO
--##
--## Finalidad: DML para agregar Valor Inicial a los items Principal Demanda de la primera Tarea de algunos procedimientos
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_REGS NUMBER(16); -- Vble. para validar la existencia de un dato
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN
	DBMS_OUTPUT.PUT_LINE('P. hipotecario	P01_DemandaCertificacionCargas');
	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = ''dameTotalLiquidacionPCO()'' WHERE TAP_ID  = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO= ''P01_DemandaCertificacionCargas'' AND BORRADO = 0) AND TFI_TIPO = ''number'' AND TFI_NOMBRE = ''principalDemanda'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('... registros afectados: ' || sql%rowcount);

	DBMS_OUTPUT.PUT_LINE('P. Ej. de Título Judicial	P16_InterposicionDemanda');
	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = ''dameTotalLiquidacionPCO()'' WHERE TAP_ID  = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO= ''P16_InterposicionDemanda'' AND BORRADO = 0) AND TFI_TIPO = ''number'' AND TFI_NOMBRE = ''principalDemanda'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('... registros afectados: ' || sql%rowcount);

	DBMS_OUTPUT.PUT_LINE('P. Ej. de título no judicial	P15_InterposicionDemandaMasBienes');
	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = ''dameTotalLiquidacionPCO()'' WHERE TAP_ID  = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO= ''P15_InterposicionDemandaMasBienes'' AND BORRADO = 0) AND TFI_TIPO = ''number'' AND TFI_NOMBRE = ''principalDemanda'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('... registros afectados: ' || sql%rowcount);

	DBMS_OUTPUT.PUT_LINE('P. ordinario	P03_InterposicionDemanda');
	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = ''dameTotalLiquidacionPCO()'' WHERE TAP_ID  = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO= ''P03_InterposicionDemanda'' AND BORRADO = 0) AND TFI_TIPO = ''number'' AND TFI_NOMBRE = ''principalDemanda'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('... registros afectados: ' || sql%rowcount);

	DBMS_OUTPUT.PUT_LINE('P. Monitorio	P02_InterposicionDemanda');
	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = ''dameTotalLiquidacionPCO()'' WHERE TAP_ID  = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO= ''P02_InterposicionDemanda'' AND BORRADO = 0) AND TFI_TIPO = ''number'' AND TFI_NOMBRE = ''principalDemanda'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('... registros afectados: ' || sql%rowcount);

	DBMS_OUTPUT.PUT_LINE('P. Cambiario	P17_InterposicionDemandaMasBienes');
	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = ''dameTotalLiquidacionPCO()'' WHERE TAP_ID  = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO= ''P17_InterposicionDemandaMasBienes'' AND BORRADO = 0) AND TFI_TIPO = ''number'' AND TFI_NOMBRE = ''principalDemanda'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('... registros afectados: ' || sql%rowcount);

	DBMS_OUTPUT.PUT_LINE('P. verbal	P04_InterposicionDemanda');
	V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = ''dameTotalLiquidacionPCO()'' WHERE TAP_ID  = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO= ''P04_InterposicionDemanda'' AND BORRADO = 0) AND TFI_TIPO = ''number'' AND TFI_NOMBRE = ''principalDemanda'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('... registros afectados: ' || sql%rowcount);

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

