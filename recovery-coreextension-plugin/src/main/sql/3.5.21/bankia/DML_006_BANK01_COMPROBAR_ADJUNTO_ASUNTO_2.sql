--/*
--##########################################
--## AUTOR=JOSEVI
--## FECHA_CREACION=20150512
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.0.1-rc05-bk
--## INCIDENCIA_LINK=FASE-1151
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''P413_ConfirmarTestimonio'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF (V_NUM_TABLAS < 1) THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] No existe el registro o la tabla: P413_ConfirmarTestimonio en TAP_TAREA_PROCEDIMIENTO en el esquema '||V_ESQUEMA);
    ELSE
      V_MSQL := 'update '||V_ESQUEMA||'.tap_tarea_procedimiento '||
              ' set tap_script_validacion = ''comprobarGestoriaAsignadaPrc() ? comprobarAdjuntoDecretoFirmeAdjudicacionAsunto() ? validacionesConfirmarTestimonioPRE() : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe adjuntar el Decreto Firme de Adjudicaci&oacute;n.</div>'''' : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe asignar la Gestor&iacute;a encargada de tramitar la adjudicaci&oacute;n.</div>'''' ''' ||
              ' where tap_codigo = ''P413_ConfirmarTestimonio'' ';
        
        EXECUTE IMMEDIATE V_MSQL;
        --DBMS_OUTPUT.PUT_LINE(V_MSQL);
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO(P413_ConfirmarTestimonio)... tap_script_validacion cambiado correctamente.');
        
    END IF; 

    COMMIT;


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