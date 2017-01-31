--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20170126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1440
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza las decisiones de trámites
--## INSTRUCCIONES:
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    --REGISTRO TFI ELEGIDO
    V_TAP_TAP_CODIGOS VARCHAR2(4000 CHAR) := '';

    --CAMPO TFI PARA ACTUALIZAR
    V_TAP_CAMPO VARCHAR2(100 CHAR)  := '';
    V_TAP_VALOR VARCHAR2(1000 CHAR) := '';


BEGIN 
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO DECISIONES - TRAMITE ACTUACION TECNICA: DECISIONES');


  --ACTUALIZACION DE VALIDACIONE POST 
  V_TAP_CAMPO := 'TAP_SCRIPT_DECISION';



--valores['T004_EleccionPresupuesto']['comboPresupuesto'] == DDSiNo.NO ? 'PresupuestoInvalido' : (checkBankia() ? (checkSuperaPresupuestoActivo() ?  'ValidoSuperaLimiteBankia' : (checkSuperaDelegacion() ? 'ValidoSuperaLimiteBankia' :'ValidoDentroLimiteBankia'))  : 'PresupuestoValido') 



  -- ACTUACION TECNICA - T004_EleccionPresupuesto --------
  V_TAP_TAP_CODIGOS := ' ''T004_EleccionPresupuesto'' ';
  V_TAP_VALOR := 'valores[''''T004_EleccionPresupuesto''''][''''comboPresupuesto''''] == DDSiNo.NO ? ''''PresupuestoInvalido'''' : (checkBankia() ? (checkSuperaPresupuestoActivo() ?  ''''ValidoSuperaLimiteBankia'''' : (checkSuperaDelegacion() ? ''''ValidoSuperaLimiteBankia'''' :''''ValidoDentroLimiteBankia''''))  : ''''PresupuestoValido'''') ';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;

--checkBankia() ? (checkSuperaPresupuestoActivo() ?  'SuperaLimiteBankia' : (checkSuperaDelegacion() ? 'SuperaLimiteBankia' :'DentroLimiteBankia')) : 'avanzaBPM' 

  -- ACTUACION TECNICA - T004_EleccionProveedorYTarifa --------
  V_TAP_TAP_CODIGOS := ' ''T004_EleccionProveedorYTarifa'' ';
  V_TAP_VALOR := 'checkBankia() ? (checkSuperaPresupuestoActivo() ?  ''''SuperaLimiteBankia'''' : (checkSuperaDelegacion() ? ''''SuperaLimiteBankia'''' :''''DentroLimiteBankia'''')) : ''''avanzaBPM'''' ';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADO CORRECTAMENTE ');


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
