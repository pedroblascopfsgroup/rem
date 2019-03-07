--/*
--##########################################
--## AUTOR=JINLI HU
--## FECHA_CREACION=20190303
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5457
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
--T004_EleccionPresupuesto ----------------------------
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
	SET TAP_SCRIPT_DECISION = ''esLiberBank() ? (superaLimiteLiberbank() ? ''''LiberbankLimiteSuperado'''' : valores[''''T004_EleccionPresupuesto''''][''''comboPresupuesto''''] == DDSiNo.NO ? ''''PresupuestoInvalido'''' : (checkBankia() ? (checkSuperaPresupuestoActivo() ? ''''ValidoSuperaLimiteBankia'''' : (checkSuperaDelegacion() ? ''''ValidoSuperaLimiteBankia'''' : ''''ConSaldo''''))  : (checkEsMultiactivo() ? ''''ConSaldo'''' : (checkSuperaPresupuestoActivo() ? ''''SinSaldo'''' : ''''ConSaldo'''')))) : valores[''''T004_EleccionPresupuesto''''][''''comboPresupuesto''''] == DDSiNo.NO ? ''''PresupuestoInvalido'''' : ((esCerberus() && (esSubcarteraJaipurInmobiliario() || esSubcarteraAgoraInmobiliario() || esSubcarteraEgeo)) || (esEgeo() && (esSubcarteraZeus() || esSubcarteraPromontoria()))) ? ''''ComprobarAdvisoryNote'''' : (checkBankia() ? (checkSuperaPresupuestoActivo() ? ''''ValidoSuperaLimiteBankia'''' : (checkSuperaDelegacion() ? ''''ValidoSuperaLimiteBankia'''' : ''''ConSaldo''''))  : (checkEsMultiactivo() ? ''''ConSaldo'''' : (checkSuperaPresupuestoActivo() ? ''''SinSaldo'''' : ''''ConSaldo'''')))'',
	USUARIOMODIFICAR = ''HREOS-5457'', 
	FECHAMODIFICAR = SYSDATE 
	WHERE TAP_CODIGO = ''T004_EleccionPresupuesto''';

	EXECUTE IMMEDIATE V_MSQL;

--T004_SolicitudExtraordinaria ----------------------------
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
	SET TAP_SCRIPT_VALIDACION_JBPM = ''esFechaMenor(valores[''''T004_SolicitudExtraordinaria''''][''''fecha''''], fechaAprobacionTrabajo()) ? ''''Fecha solicitud debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : ((esCerberus() && (esSubcarteraJaipurInmobiliario() || esSubcarteraAgoraInmobiliario() || esSubcarteraEgeo)) || (esEgeo() && (esSubcarteraZeus() || esSubcarteraPromontoria()))) ? mismoNumeroAdjuntosComoTareasTipoUGValidacion("119", "T", 10000000004665) : null'',
	TAP_SCRIPT_DECISION = '''',
	USUARIOMODIFICAR = ''HREOS-5457'', 
	FECHAMODIFICAR = SYSDATE 
	WHERE TAP_CODIGO = ''T004_SolicitudExtraordinaria''';

	EXECUTE IMMEDIATE V_MSQL;

--T004_SolicitudPresupuestoComplementario ----------------------------
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
	SET TAP_SCRIPT_DECISION = ''((esCerberus() && (esSubcarteraJaipurInmobiliario() || esSubcarteraAgoraInmobiliario() || esSubcarteraEgeo)) || (esEgeo() && (esSubcarteraZeus() || esSubcarteraPromontoria()))) ? ''''ComprobarAdvisoryNote'''' : ''''TramiteNormal'''''',
	USUARIOMODIFICAR = ''HREOS-5457'', 
	FECHAMODIFICAR = SYSDATE 
	WHERE TAP_CODIGO = ''T004_SolicitudPresupuestoComplementario''';
	
	EXECUTE IMMEDIATE V_MSQL;
	      
  	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAP_TAREA_PROCEDIMIENTO ACTUALIZADA CORRECTAMENTE ');
   			

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
