--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20150521
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=
--## INCIDENCIA_LINK=FASE-1320
--## PRODUCTO=SI
--## Finalidad: DML
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');


-- Modificamos TAP_SCRIPT_VALIDACION_JBPM de P401_SeñalamientoSubasta
-- Valor actual: ((valores['P401_SenyalamientoSubasta']['principal']).toDouble() >= ((valores['P401_SenyalamientoSubasta']['costasLetrado']).toDouble())) ? null :  '<p>&iexcl;Atenci&oacute;n! Las costas del letrado no pueden superar el 5% del principal.</p>'

execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET USUARIOMODIFICAR = ''FASE1320'', FECHAMODIFICAR=SYSDATE, TAP_SCRIPT_VALIDACION_JBPM = ''comprobarCostasLetradoViviendaHabitual() ? null : ''''&iexcl;Atenci&oacute;n! Las costas del letrado no pueden superar el 5% del principal.'''''' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P401_SenyalamientoSubasta'')';

-- Modificamos TAP_SCRIPT_VALIDACION_JBPM de P409_SeñalamientoSubasta
-- Valor actual: ((valores['P409_SenyalamientoSubasta']['principal']).toDouble() > ((valores['P409_SenyalamientoSubasta']['costasLetrado']).toDouble())) ? 'null' : '<p>&iexcl;Atenci&oacute;n! Las costas del letrado no pueden superar el 5% del principal.</p>'
execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET USUARIOMODIFICAR = ''FASE1320'', FECHAMODIFICAR=SYSDATE, TAP_SCRIPT_VALIDACION_JBPM = ''comprobarCostasLetradoViviendaHabitual() ? null : ''''&iexcl;Atenci&oacute;n! Las costas del letrado no pueden superar el 5% del principal.'''''' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P409_SenyalamientoSubasta'')';

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

