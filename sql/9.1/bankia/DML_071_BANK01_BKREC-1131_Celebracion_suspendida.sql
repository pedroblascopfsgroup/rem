--/*
--##########################################
--## AUTOR=JOSEVI
--## FECHA_CREACION=20150930
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.16-bk
--## INCIDENCIA_LINK=
--## PRODUCTO=NO
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

--/**
-- * Modificacion de tap_tarea_procedimiento.tap_script_validacion para la tarea P409_CelebraciónSubasta para añadir validación entidad adjudicataria e importe
-- * Antes: comprobarGestoriaAsignadaPrc() ? comprobarAdjuntoDecretoFirmeAdjudicacion() ? validacionesConfirmarTestimonioPRE() : '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe adjuntar el Decreto Firme de Adjudicaci&oacute;n.</div>' : '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe asignar la Gestor&iacute;a encargada de tramitar la adjudicaci&oacute;n.</div>'  
-- */
execute immediate 'update tap_tarea_procedimiento set tap_script_validacion_jbpm = ''valores[''''P401_CelebracionSubasta''''][''''comboCelebrada''''] == ''''02'''' ? null : (comprobarImporteEntidadAdjudicacionBienes() ? (comprobarNumeroActivo() ? null : ''''Antes de dar la subasta por celebrada, deber&aacute; acceder a la ficha del bien y solicitar el n&uacute;mero de activo mediante el bot&oacute;n habilitado para tal efecto.'''') : ''''Debe rellenar en cada bien el importe adjudicaci&oacute;n y la entidad.'''')'' where tap_codigo = ''P401_CelebracionSubasta''';

execute immediate 'update tap_tarea_procedimiento set tap_script_validacion_jbpm = ''valores[''''P409_CelebracionSubasta''''][''''comboCelebrada''''] == ''''02'''' ? null : (comprobarImporteEntidadAdjudicacionBienes() ? (comprobarNumeroActivo() ? null : ''''Antes de dar la subasta por celebrada, deber&aacute; acceder a la ficha del bien y solicitar el n&uacute;mero de activo mediante el bot&oacute;n habilitado para tal efecto.'''') : ''''Debe rellenar en cada bien el importe adjudicaci&oacute;n y la entidad.'''')'' where tap_codigo = ''P409_CelebracionSubasta''';

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

