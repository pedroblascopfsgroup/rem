--/*
--##########################################
--## AUTOR=Joaquin Bahamonde
--## FECHA_CREACION=20191210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.17.0
--## INCIDENCIA_LINK=HREOS-7051
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el TAP_SCRIPT_VALIDACION_JBPM ResolucionExpediente.
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
    V_TABLA VARCHAR2(2400 CHAR):= 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref
    V_USU_MODIFICAR VARCHAR2(1024 CHAR):= 'HREOS-7051';

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --				TAP_CODIGO					TAP_SCRIPT_VALIDACION_JBPM      
        T_TIPO_DATA('T013_ResolucionExpediente', 'esCajamar() ? valores[''''T013_ResolucionExpediente''''][''''comboProcede''''] == DDDevolucionReserva.CODIGO_SI_DUPLICADOS || valores[''''T013_ResolucionExpediente''''][''''comboProcede''''] == DDDevolucionReserva.CODIGO_SI_SIMPLES ? checkContabilizacionReserva() ?  null : ''''No se puede devolver la reserva. Reserva pendiente de contabilizar'''' : null : null')   
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizar campo TAP_SCRIPT_VALIDACION para las tareas del tramite T013 Trámite comercial venta');

	 FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        DBMS_OUTPUT.PUT('[INFO] Tarea '|| V_TMP_TIPO_DATA(1) ||'');

	    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'' ||
				  ' SET TAP_SCRIPT_VALIDACION_JBPM = '''|| V_TMP_TIPO_DATA(2) ||''' '||
				  ', USUARIOMODIFICAR = '''||V_USU_MODIFICAR||''', FECHAMODIFICAR = SYSDATE '||
				  ' WHERE TAP_CODIGO = '''|| V_TMP_TIPO_DATA(1) ||''' ';
	    EXECUTE IMMEDIATE V_MSQL;

	    DBMS_OUTPUT.PUT_LINE(' - OK');

	END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Actualizado T013 TAP_SCRIPT_VALIDACION_JBPM ResolucionExpediente');

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