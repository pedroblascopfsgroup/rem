--/*
--##########################################
--## AUTOR=OSCAR_DORADO
--## FECHA_CREACION=20150604
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=BKNIVDOS-2379
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

-- Añadimos validación POST del número activo en P418_RegistrarAdmisionYEmplazamiento
-- valor anterior: null
execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set usuariomodificar = ''BKNVDS2379'', fechamodificar=sysdate, tap_script_validacion_jbpm = ''valores[''''P418_RegistrarAdmisionYEmplazamiento''''][''''comboAdminEmplaza''''] == DDSiNo.SI ? (valores[''''P418_RegistrarAdmisionYEmplazamiento''''][''''comboVista''''] == null || valores[''''P418_RegistrarAdmisionYEmplazamiento''''][''''fechaSenyalamiento''''] == null ? ''''Debe indicar la vista y la fecha de señalamiento'''' : null) : null '' where tap_codigo = ''P418_RegistrarAdmisionYEmplazamiento''';

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set usuariomodificar = ''BKNVDS2379'', fechamodificar=sysdate, tfi_error_validacion = null, tfi_validacion = null where tfi_nombre in  (''comboVista'',''fechaSenyalamiento'') and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P418_RegistrarAdmisionYEmplazamiento'')';


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
