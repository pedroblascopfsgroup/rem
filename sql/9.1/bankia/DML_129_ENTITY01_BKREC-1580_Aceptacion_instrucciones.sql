--/*
--##########################################
--## AUTOR=OSCAR
--## FECHA_CREACION=20151215
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.19-bk
--## INCIDENCIA_LINK=BKREC-1580
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

    
    V_SQL := 'select count(*) from '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS tfi join '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap on tap.tap_id=tfi.tap_id and tap.borrado=0 and tap.tap_codigo=''P408_lecturaAceptacionInstrucciones'' and tfi.TFI_NOMBRE=''propuestaInstrucciones'' ';
    
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
   
    --/** 
    -- * Modificación de TFI_TAREAS_FORM_ITEMS, 
    -- * ANTES: campo TFI_VALOR_INICIAL: valores['P408_registrarResultado'] == null ? '' : (valores['P408_registrarResultado']['propuestaInstrucciones'])
    -- * NUEVO: campo TFI_VALOR_INICIAL: valores['P408_registrarResultadoComite'] == null ? '' : (valores['P408_registrarResultadoComite']['propuestaInstrucciones'])
    -- * en la tarea -> P408_lecturaAceptacionInstrucciones
    -- */
    
    IF V_NUM_TABLAS > 0 THEN      	
        execute immediate 'update '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS set TFI_VALOR_INICIAL=''valores[''''P408_registrarResultadoComite''''] == null ? '''''''' : (valores[''''P408_registrarResultadoComite''''][''''propuestaInstrucciones''''])'', USUARIOMODIFICAR=''BKREC-1580'', FECHAMODIFICAR=SYSDATE WHERE BORRADO=0 and TFI_NOMBRE=''propuestaInstrucciones'' And TAP_ID=(select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''P408_lecturaAceptacionInstrucciones'')';
        
        DBMS_OUTPUT.PUT_LINE('ACTUALIZACION CORRECTA....');
        DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe ese codigo en la base de datos');
         DBMS_OUTPUT.PUT_LINE('[INFO] No se ha podido modificar el registro...');
    
    END IF;
    
  --/** 
    -- * Modificación de TAP_TAREA_PROCEDIMIENTO, 
    -- * ANTES: campo TAP_VIEW: plugin/procedimientos/tramiteFaseConvenio/lecturaYaceptacionV4
    -- * NUEVO: campo TAP_VIEW: null
    -- * en la tarea -> P408_lecturaAceptacionInstrucciones
    -- */
    
    V_SQL := 'select count(*) from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap WHERE tap.borrado=0 and tap.tap_codigo=''P408_lecturaAceptacionInstrucciones'' ';
    
    IF V_NUM_TABLAS > 0 THEN      	
        execute immediate 'update '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO set TAP_VIEW = NULL, USUARIOMODIFICAR=''BKREC-1580'', FECHAMODIFICAR=SYSDATE WHERE BORRADO=0 AND TAP_CODIGO=''P408_lecturaAceptacionInstrucciones''';
        
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