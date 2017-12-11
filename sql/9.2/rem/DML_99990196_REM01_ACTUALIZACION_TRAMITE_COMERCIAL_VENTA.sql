--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20171211
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3328
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el trámite T013 Trámite comercial venta.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --				TAP_CODIGO						TAP_SCRIPT_VALIDACION_JBPM
		T_TIPO_DATA('T013_DocumentosPostVenta',		'valores[''''T013_DocumentosPostVenta''''][''''fechaIngreso''''] == null ? (valores[''''T013_DocumentosPostVenta''''][''''checkboxVentaDirecta''''] == ''''false'''' ?''''No es posible avanzar la tarea por ausencia de fecha ingreso cheque'''' : existeAdjuntoUGValidacion("19,E;17,E")) : existeAdjuntoUGValidacion("19,E;17,E")')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizar campo TAP_SCRIPT_VALIDACION_JBPM para las tareas del tramite T013 Trámite comercial venta');

	 FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        DBMS_OUTPUT.PUT('[INFO] Tarea '|| V_TMP_TIPO_DATA(1) ||'');

	    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
				  ' SET TAP_SCRIPT_VALIDACION_JBPM = '''|| V_TMP_TIPO_DATA(2) ||''' '||
				  ', USUARIOMODIFICAR = ''HREOS-3328'' , FECHAMODIFICAR = SYSDATE '||
				  ' WHERE TAP_CODIGO = '''|| V_TMP_TIPO_DATA(1) ||''' ';
	    EXECUTE IMMEDIATE V_MSQL;

	    DBMS_OUTPUT.PUT_LINE(' - OK');

	END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Actualizado T013 Trámite comercial venta');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE(' - KO');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);

          ROLLBACK;
          RAISE;   
END;
/
EXIT;