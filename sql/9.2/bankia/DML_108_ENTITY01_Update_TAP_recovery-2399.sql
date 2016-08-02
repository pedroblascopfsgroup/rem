--/*
--##########################################
--## AUTOR=Óscar Dorado
--## FECHA_CREACION=20160715
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2.8
--## INCIDENCIA_LINK=RECOVERY-2399
--## PRODUCTO=NO
--## Finalidad: 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    
    V_NUM NUMBER; 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN


    V_SQL :='update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_validacion_jbpm=''valores[''''P418_RegistrarAdmisionYEmplazamiento''''][''''comboAdminEmplaza''''] == DDSiNo.SI ? (valores[''''P418_RegistrarAdmisionYEmplazamiento''''][''''comboVista''''] == null ? ''''Debe indicar la vista'''' : ((valores[''''P418_RegistrarAdmisionYEmplazamiento''''][''''comboVista''''] == DDSiNo.SI &&  valores[''''P418_RegistrarAdmisionYEmplazamiento''''][''''fechaSenyalamiento''''] == null) ? ''''Debe indicar la fecha de señalamiento'''' : null )) : null'', usuariomodificar=''RECOVERY-2399'', FECHAMODIFICAR=SYSDATE where tap_codigo=''P418_RegistrarAdmisionYEmplazamiento'''; 
    DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION tap_tarea_procedimiento');

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
