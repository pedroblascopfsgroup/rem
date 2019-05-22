--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190415
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6143
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    V_TABLA VARCHAR2(2400 CHAR):= 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(1024 CHAR):= 'HREOS-6143';
    
    
BEGIN
		--VENTA
		DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TABLA);
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TAP_CODIGO = ''T004_AnalisisPeticion'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
					   SET 
						    TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T004_AnalisisPeticion''''][''''comboTramitar''''] == DDSiNo.NO ? null : (checkHayPresupuestoEjercicioActual() ? (checkSareb() ' || chr(38) || chr(38) || ' valores[''''T004_AnalisisPeticion''''][''''comboTarifaPlana''''] == DDSiNo.SI ? (checkTarifaPlana() ? null : ''''Debe asignar al menos un proveedor'''') : null) : ''''El activo debe tener asignado un presupuesto para el ejercicio actual, aunque sea con saldo cero'''')''
						  , TAP_SCRIPT_DECISION = ''valores[''''T004_AnalisisPeticion''''][''''comboTramitar''''] == DDSiNo.NO ? ''''KO'''' : (valores[''''T004_AnalisisPeticion''''][''''comboTarifa''''] == DDSiNo.SI ? (checkTarifaPlana() ? (checkSareb() ? (valores[''''T004_AnalisisPeticion''''][''''comboTarifaPlana''''] == DDSiNo.SI ? ''''ConSaldo'''' : ''''OKTarificada'''') : ''''ConSaldo'''' ) : ''''OKTarificada'''') : ''''OKNoTarificada'''')''
						  , USUARIOMODIFICAR = '''||V_USU_MODIFICAR||'''
						  , FECHAMODIFICAR = SYSDATE 
					   WHERE TAP_CODIGO = ''T004_AnalisisPeticion''
					     AND BORRADO = 0';
			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando tarea T004_AnalisisPeticion.......');
		    DBMS_OUTPUT.PUT_LINE(V_MSQL);
		    EXECUTE IMMEDIATE V_MSQL;
		  
		END IF;
    
		
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
