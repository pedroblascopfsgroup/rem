--/*
--##########################################
--## AUTOR=Jesus Jativa
--## FECHA_CREACION=20210114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-12352
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
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
	SET 
  TAP_SCRIPT_VALIDACION = ''esActivoContabilizado() ? null : ''''No se puede validar la ejecuci&oacute;n del trabajo para un activo no contabilizado.'''''' ,
	USUARIOMODIFICAR = ''HREOS-12352'', 
	FECHAMODIFICAR = SYSDATE 
	WHERE TAP_CODIGO = ''T002_CierreEconomico''';

  DBMS_OUTPUT.PUT_LINE(V_MSQL );
  
	EXECUTE IMMEDIATE V_MSQL;
	      
  
  	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');

    	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
	SET 
  TAP_SCRIPT_VALIDACION = ''esActivoContabilizado() ? null : ''''No se puede validar la ejecuci&oacute;n del trabajo para un activo no contabilizado.'''''' ,
	USUARIOMODIFICAR = ''HREOS-12352'', 
	FECHAMODIFICAR = SYSDATE 
	WHERE TAP_CODIGO = ''T003_CierreEconomico''';

  DBMS_OUTPUT.PUT_LINE(V_MSQL );
  
	EXECUTE IMMEDIATE V_MSQL;
	      
  
  	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');

    	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
	SET 
  TAP_SCRIPT_VALIDACION = ''esActivoContabilizado() ? null : ''''No se puede validar la ejecuci&oacute;n del trabajo para un activo no contabilizado.'''''' ,
	USUARIOMODIFICAR = ''HREOS-12352'', 
	FECHAMODIFICAR = SYSDATE 
	WHERE TAP_CODIGO = ''T004_CierreEconomico''';

  DBMS_OUTPUT.PUT_LINE(V_MSQL );
  
	EXECUTE IMMEDIATE V_MSQL;
	      
  
  	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');

    	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
	SET 
  TAP_SCRIPT_VALIDACION = ''esActivoContabilizado() ? null : ''''No se puede validar la ejecuci&oacute;n del trabajo para un activo no contabilizado.'''''' ,
	USUARIOMODIFICAR = ''HREOS-12352'', 
	FECHAMODIFICAR = SYSDATE 
	WHERE TAP_CODIGO = ''T005_CierreEconomico''';

  DBMS_OUTPUT.PUT_LINE(V_MSQL );
  
	EXECUTE IMMEDIATE V_MSQL;
	      
  
  	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');

    	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
	SET 
  TAP_SCRIPT_VALIDACION = ''esActivoContabilizado() ? null : ''''No se puede validar la ejecuci&oacute;n del trabajo para un activo no contabilizado.'''''' ,
	USUARIOMODIFICAR = ''HREOS-12352'', 
	FECHAMODIFICAR = SYSDATE 
	WHERE TAP_CODIGO = ''T006_CierreEconomico''';

  DBMS_OUTPUT.PUT_LINE(V_MSQL );
  
	EXECUTE IMMEDIATE V_MSQL;
	      
  
  	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');

    	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
	SET 
  TAP_SCRIPT_VALIDACION = ''esActivoContabilizado() ? null : ''''No se puede validar la ejecuci&oacute;n del trabajo para un activo no contabilizado.'''''' ,
	USUARIOMODIFICAR = ''HREOS-12352'', 
	FECHAMODIFICAR = SYSDATE 
	WHERE TAP_CODIGO = ''T008_CierreEconomico''';

  DBMS_OUTPUT.PUT_LINE(V_MSQL );
  
	EXECUTE IMMEDIATE V_MSQL;
	      
  
  	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');
    
    
    
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAP_TAREA_PROCEDIMIENTO ACTUALIZADA CORRECTAMENTE ');
   			

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuci&oacute;n:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
