--/*
--##########################################
--## AUTOR=Lara Pablo Flores
--## FECHA_CREACION=20190601
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6587
--## PRODUCTO=SI
--##
--## Finalidad: 
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
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
--INSERT TAP_TAREA_PROCEDIMIENTO T013_ValidacionClientes ----------------------------

  EXECUTE IMMEDIATE 'SELECT count(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_ValidacionClientes'' AND TAP_SCRIPT_VALIDACION IS NULL AND TAP_SCRIPT_VALIDACION_JBPM LIKE ''checkDiscrepanciasUrsus()%''' INTO V_COUNT;

    IF V_COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE(' Editando [TAP_TAREA_PROCEDIMIENTO] ');
	V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO '||
                   
					'SET TAP_SCRIPT_VALIDACION_JBPM = null  '|| 
					', TAP_SCRIPT_VALIDACION = ''checkDiscrepanciasUrsus() ? ''''Hay discrepancias'''' : null '' '||
					', USUARIOMODIFICAR = ''HREOS-6587'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE TAP_CODIGO = ''T013_ValidacionClientes'' ';
					
					
	EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('DATOS CAMBIADOS CORRECTAMENTE');
    ELSE
        DBMS_OUTPUT.PUT_LINE(' LA FILA NO EXISTE, O YA ESTÁ EN ESE ESTADO');
    END IF;

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
