--/*
--##########################################
--## Author: Óscar
--## Finalidad: DML
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO] TRAMITE SUBASTA');


execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_decision = ''existeBienConAdjudicacionE() ''''bienConAdjudicacion'''' : ''''bienSinAdjudicacion'''''' where tap_codigo = ''P401_ConfirmarRecepcionMtoPago''';

execute immediate 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_script_decision = ''existeBienConAdjudicacionE() ''''bienConAdjudicacion'''' : ''''bienSinAdjudicacion'''''' where tap_codigo = ''P409_ConfirmarRecepcionMtoPago''';



 DBMS_OUTPUT.PUT_LINE('[INICIO] campo tipoSubasta');  
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = ''comboTipo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO =''P401_ValidarPropuesta'') ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values   (s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_ValidarPropuesta''), 1, ''combo'', ''comboTipo'', ''Tipo subasta'', ''dameTipoSubasta()'', ''DDTipoSubasta'', 0, ''DML'', sysdate, 0)';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  


 DBMS_OUTPUT.PUT_LINE('[INICIO] campo comboSuspension');  
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = ''comboSuspension'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO =''P401_ValidarPropuesta'') ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, tfi_valor_inicial) Values   (s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_ValidarPropuesta''), 3, ''combo'', ''comboSuspension'', ''Suspender subasta'', ''DDSiNo'', 0, ''DML'', sysdate, 0, ''valores[''''P401_PrepararPropuestaSubasta''''][''''comboSuspension'''']'')';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  


 DBMS_OUTPUT.PUT_LINE('[INICIO] campo motivoSuspension');  
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = ''motivoSuspension'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO =''P401_ValidarPropuesta'') ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, tfi_valor_inicial) Values   (s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_ValidarPropuesta''), 4, ''combo'', ''motivoSuspension'', ''Motivo suspensión'', ''DDMotivoSuspSubasta'', 0, ''DML'', sysdate, 0, ''valores[''''P401_PrepararPropuestaSubasta''''][''''motivoSuspension'''']'')';
      EXECUTE IMMEDIATE V_SQL ;
    END IF ;  



execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_orden = 2 where tfi_nombre = ''comboResultado'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_ValidarPropuesta'')';

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_orden = 5 where tfi_nombre = ''fechaDecision'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_ValidarPropuesta'')';

execute immediate 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_orden = 6 where tfi_nombre = ''observaciones'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P401_ValidarPropuesta'')';

 



COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] INCIDENCIA INC-7');



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



