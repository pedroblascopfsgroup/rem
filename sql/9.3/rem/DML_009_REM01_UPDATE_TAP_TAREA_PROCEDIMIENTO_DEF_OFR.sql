--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20190306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3449
--## PRODUCTO=NO
--##
--## Finalidad: update TAP_TAREA_PROCEDIMIENTO 'T013_DefinicionOferta' script validación JBPM
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

    --DBMS_OUTPUT.PUT_LINE('COMENZANDO EL PROCESO DE ACTUALIZACIÓN');
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''existeAdjuntoUGCarteraValidacion("36", "E", "01") == null ? valores[''''T013_DefinicionOferta''''][''''comboConflicto''''] == DDSiNo.SI || valores[''''T013_DefinicionOferta''''][''''comboRiesgo''''] == DDSiNo.SI  ?  ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' : comprobarComiteLiberbankPlantillaPropuesta() ? existeAdjuntoUGCarteraValidacion("36", "E", "08") : definicionOfertaT013(valores[''''T013_DefinicionOferta''''][''''comite''''])  : existeAdjuntoUGCarteraValidacion("36", "E", "01")'', USUARIOMODIFICAR = ''REMVIP-3449'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T013_DefinicionOferta''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_TIPO = ''comboboxreadonly'', TFI_BUSINESS_OPERATION = ''DDComiteSancion'', USUARIOMODIFICAR = ''REMVIP-3449'', FECHAMODIFICAR = SYSDATE WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_DefinicionOferta'') AND TFI_NOMBRE = ''comite''';
    
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
