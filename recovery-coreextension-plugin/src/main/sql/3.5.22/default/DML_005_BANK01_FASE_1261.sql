--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20150508
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.0.1
--## INCIDENCIA_LINK=FASE-1261
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

-- Añadimos validación POST del número activo en P401_CelebracionSubasta
-- valor anterior: valores['P401_CelebracionSubasta']['comboCelebrada'] == '02' ? (valores['P401_CelebracionSubasta']['comboSuspension'] == null ? 'El campo suspensi&oacute;n es obligatorio' : (valores['P401_CelebracionSubasta']['comboMotivo'] == null ? 'Campo motivo es obligatorio' : null )) : (valores['P401_CelebracionSubasta']['comboCesion'] == null ? 'Campo cesi&oacute;n es obligatorio' : (valores['P401_CelebracionSubasta']['comboCesion'] == '01' ? (valores['P401_CelebracionSubasta']['comboComite'] == null ? 'Campo comit&eacute; es obligatorio' : validacionesCelebracionSubastaPOST()) : validacionesCelebracionSubastaPOST() ))

execute immediate 'update '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET USUARIOMODIFICAR = ''FASE1261'', FECHAMODIFICAR=SYSDATE, TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''P401_CelebracionSubasta''''][''''comboCelebrada''''] == ''''02'''' ? (valores[''''P401_CelebracionSubasta''''][''''comboSuspension''''] == null ? ''''El campo suspensi&oacute;n es obligatorio'''' : (valores[''''P401_CelebracionSubasta''''][''''comboMotivo''''] == null ? ''''Campo motivo es obligatorio'''' : null )) : (valores[''''P401_CelebracionSubasta''''][''''comboCesion''''] == null ? ''''Campo cesi&oacute;n es obligatorio'''' : (valores[''''P401_CelebracionSubasta''''][''''comboCesion''''] == ''''01'''' ? (valores[''''P401_CelebracionSubasta''''][''''comboComite''''] == null ? ''''Campo comit&eacute; es obligatorio'''' : comprobarNumeroActivo() ?validacionesCelebracionSubastaPOST():''''Antes de dar la subasta por celebrada, deber&aacute; acceder a la ficha del bien y solicitar el n&uacute;mero de activo mediante el bot&oacute;n habilitado para tal efecto'''') : comprobarNumeroActivo() ? validacionesCelebracionSubastaPOST():''''Antes de dar la subasta por celebrada, deber&aacute; acceder a la ficha del bien y solicitar el n&uacute;mero de activo mediante el bot&oacute;n habilitado para tal efecto''''))'' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P401_CelebracionSubasta'')';


-- Añadimos validación POST del número activo en P409_CelebracionSubasta
-- valor anterior: valores['P409_CelebracionSubasta']['comboCelebrada'] == '02' ? (valores['P409_CelebracionSubasta']['comboSuspension'] == null ? 'El campo suspensi&oacute;n es obligatorio' : (valores['P409_CelebracionSubasta']['comboMotivo'] == null ? 'Campo motivo es obligatorio' : null )) : (valores['P409_CelebracionSubasta']['comboCesion'] == null ? 'Campo cesi&oacute;n es obligatorio' : (valores['P409_CelebracionSubasta']['comboCesion'] == '01' ? (valores['P409_CelebracionSubasta']['comboComite'] == null ? 'Campo comit&eacute; es obligatorio' : comprobarImporteEntidadAdjudicacionBienes() ? null : 'Debe rellenar en cada bien el importe adjudicaci&oacute;n y la entidad.') : null))

execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET USUARIOMODIFICAR = ''FASE1261'', FECHAMODIFICAR=SYSDATE, TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''P409_CelebracionSubasta''''][''''comboCelebrada''''] == ''''02'''' ? (valores[''''P409_CelebracionSubasta''''][''''comboSuspension''''] == null ? ''''El campo suspensi&oacute;n es obligatorio'''' : (valores[''''P409_CelebracionSubasta''''][''''comboMotivo''''] == null ? ''''Campo motivo es obligatorio'''' : null )) : (valores[''''P409_CelebracionSubasta''''][''''comboCesion''''] == null ? ''''Campo cesi&oacute;n es obligatorio'''' : (valores[''''P409_CelebracionSubasta''''][''''comboCesion''''] == ''''01'''' ? (valores[''''P409_CelebracionSubasta''''][''''comboComite''''] == null ? ''''Campo comit&eacute; es obligatorio'''' : comprobarImporteEntidadAdjudicacionBienes() ? (comprobarNumeroActivo() ? null : ''''Antes de dar la subasta por celebrada, deber&aacute; acceder a la ficha del bien y solicitar el n&uacute;mero de activo mediante el bot&oacute;n habilitado para tal efecto.'''') : ''''Debe rellenar en cada bien el importe adjudicaci&oacute;n y la entidad.'''') : (comprobarNumeroActivo() ? null : ''''Antes de dar la subasta por celebrada, deber&aacute; acceder a la ficha del bien y solicitar el n&uacute;mero de activo mediante el bot&oacute;n habilitado para tal efecto.''''))'' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P409_CelebracionSubasta'')';

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

