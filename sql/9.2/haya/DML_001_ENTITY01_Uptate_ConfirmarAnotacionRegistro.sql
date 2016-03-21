--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20160218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=piloto1802
--## INCIDENCIA_LINK=CMREC-2178
--## PRODUCTO=SI
--## Finalidad: Actualizar validación de la tarea.
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.



BEGIN

	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM ='||
	' ''comprobarBienesAsociadoPrc() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">No se puede avanzar la tarea, la actuaci&oacute;n no tiene bienes asociados.</div>''''''' ||
	' WHERE TAP_CODIGO = ''H062_confirmarAnotacionRegistro''';
	
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');

COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
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
