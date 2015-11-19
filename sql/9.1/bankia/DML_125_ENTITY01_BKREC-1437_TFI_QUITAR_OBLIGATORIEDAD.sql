--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20151118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.18-bk
--## INCIDENCIA_LINK=BKREC-1437
--## PRODUCTO=NO
--## Finalidad: DML
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

     DBMS_OUTPUT.PUT_LINE('[INICIO]');

     --/** 
    -- * Modificación de TFI_TAREAS_FORM_ITEMS pondremos 'null' en TFI_ERROR_VALIDACION y TFI_ERROR_VALIDACION para el trámite de Posesión
    -- * en la tarea -> P416_RegistrarPosesionYLanzamiento
    -- */
    
    V_SQL := 'select count(*) from '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS tfi join '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap on tap.tap_id=tfi.tap_id and tap.borrado=0 and tap.tap_codigo=''P416_RegistrarPosesionYLanzamiento'' and (tfi.TFI_NOMBRE=''fecha'' or tfi.TFI_NOMBRE=''comboEntregaVoluntaria'' or tfi.TFI_NOMBRE=''comboFuerzaPublica'' or tfi.TFI_NOMBRE=''comboLanzamiento'' or tfi.TFI_NOMBRE=''fechaSolLanza'') ';
    
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    --/**
	--* Valor antiguo que es reemplazado con este update en 
	--* TFI_ERROR_VALIDACION: tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio
	--* y/o TFI_VALIDACION: valor != null && valor != '' ? true : false
	--* en los valores TFI_NOMBRE=(fecha,comboEntregaVoluntaria,comboFuerzaPublica,comboLanzamiento,fechaSolLanza) 
	--* de la tarea P416_RegistrarPosesionYLanzamiento
	-- */
    IF V_NUM_TABLAS = 5 THEN      	
        execute immediate 'update '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS set TFI_ERROR_VALIDACION=null, TFI_VALIDACION=null, USUARIOMODIFICAR=''BKREC-1437'', FECHAMODIFICAR=SYSDATE WHERE BORRADO=0 and TFI_NOMBRE=''fecha'' and TAP_ID=(select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''P416_RegistrarPosesionYLanzamiento'')';
        execute immediate 'update '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS set TFI_ERROR_VALIDACION=null, TFI_VALIDACION=null, USUARIOMODIFICAR=''BKREC-1437'', FECHAMODIFICAR=SYSDATE WHERE BORRADO=0 and TFI_NOMBRE=''comboEntregaVoluntaria'' and TAP_ID=(select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''P416_RegistrarPosesionYLanzamiento'')';
        execute immediate 'update '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS set TFI_ERROR_VALIDACION=null, TFI_VALIDACION=null, USUARIOMODIFICAR=''BKREC-1437'', FECHAMODIFICAR=SYSDATE WHERE BORRADO=0 and TFI_NOMBRE=''comboFuerzaPublica'' and TAP_ID=(select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''P416_RegistrarPosesionYLanzamiento'')';
        execute immediate 'update '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS set TFI_ERROR_VALIDACION=null, TFI_VALIDACION=null, USUARIOMODIFICAR=''BKREC-1437'', FECHAMODIFICAR=SYSDATE WHERE BORRADO=0 and TFI_NOMBRE=''comboLanzamiento'' and TAP_ID=(select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''P416_RegistrarPosesionYLanzamiento'')';
        execute immediate 'update '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS set TFI_ERROR_VALIDACION=null, TFI_VALIDACION=null, USUARIOMODIFICAR=''BKREC-1437'', FECHAMODIFICAR=SYSDATE WHERE BORRADO=0 and TFI_NOMBRE=''fechaSolLanza'' and TAP_ID=(select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''P416_RegistrarPosesionYLanzamiento'')';
    
        DBMS_OUTPUT.PUT_LINE('ACTUALIZACION CORRECTA....');
        DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe ese codigo en la base de datos');
         DBMS_OUTPUT.PUT_LINE('[INFO] No se ha podido modificar el registro...');
    
    END IF;
    
    COMMIT;
    
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          
END;
/
EXIT;