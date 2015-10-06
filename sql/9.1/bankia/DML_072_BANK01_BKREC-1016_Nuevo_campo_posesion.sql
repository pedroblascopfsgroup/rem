--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=201501006
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.16-bk
--## INCIDENCIA_LINK=BKREC-1016
--## PRODUCTO=NO
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
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    V_ENTIDAD_ID NUMBER(16);
   

BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS... Empezando a insertar datos en tfi');
   
	V_SQL := 'select count(*) from '||V_ESQUEMA||'.tfi_Tareas_form_items where tfi_nombre = ''comboEntregaVoluntaria'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P416_RegistrarPosesionYLanzamiento'')';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS ...no se modificará nada.');
	ELSE
		EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
			   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR,  BORRADO)
			 Values
			   ('||V_ESQUEMA||'.s_tfi_Tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P416_RegistrarPosesionYLanzamiento''), 3, ''combo'', ''comboEntregaVoluntaria'', ''Entrega voluntaria posesión'', ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', ''valor != null && valor != '''''''' ? true : false'',  ''DDSiNo'', 0, ''BKREC-1016'', SYSDATE, 0)';
	
		EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.tfi_Tareas_form_items set tfi_orden = 4 where tfi_nombre = ''comboFuerzaPublica'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P416_RegistrarPosesionYLanzamiento'')';
		EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.tfi_Tareas_form_items set tfi_orden = 5 where tfi_nombre = ''comboLanzamiento'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P416_RegistrarPosesionYLanzamiento'')';
		EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.tfi_Tareas_form_items set tfi_orden = 6 where tfi_nombre = ''fechaSolLanza'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P416_RegistrarPosesionYLanzamiento'')';
		EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.tfi_Tareas_form_items set tfi_orden = 7 where tfi_nombre = ''observaciones'' and tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''P416_RegistrarPosesionYLanzamiento'')';
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Datos insertados correctamente en la tabla '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS .');
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
  	