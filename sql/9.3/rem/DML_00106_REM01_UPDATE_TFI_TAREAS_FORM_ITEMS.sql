--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20200311
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9768
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar campos TFI_TAREAS_FORM_ITEMS
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
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_TABLA VARCHAR2(30 CHAR) := 'TFI_TAREAS_FORM_ITEMS';  -- Tabla a modificar   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'HREOS-9768'; -- USUARIOCREAR/USUARIOMODIFICAR
    
    
    /* TABLA: TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;

    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    			 --TAP_CODIGO 				   --TFI_LABEL_VIEJO 		--TFI_NOMBRE 	      --TFI_LABEL_NUEVO				
		T_TFI(   'T017_DefinicionOferta',   	'Título',				'titulo',	  	'<p style="margin-bottom: 10px">
  Ha aceptado una oferta y se ha creado un expediente comercial asociado a la misma. 
  A continuación  debería rellenar todos los campos necesarios para definir la oferta, pudiendo darse la siguiente casuística para finalizar la tarea. La siguiente tarea será "Resolución comité". 
  </p> 
  <p style="margin-bottom: 10px">Para sancionar la oferta, deberá preparar la propuesta y remitirla al Portfolio Manager indicando abajo la fecha de envío. 
  En cualquier caso, para poder finalizar la tarea, tiene que reflejar si existe riesgo reputacional y/o conflicto de intereses en la Ficha de expediente.</p>  
  <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'),	
				--TAP_CODIGO 				   --TFI_LABEL_VIEJO 		--TFI_NOMBRE 	      --TFI_LABEL_NUEVO
		T_TFI(   'T017_RespuestaOfertanteCES',  'Título',				'titulo',	  	'<p style="margin-bottom: 10px">La resolución del comité sancionador ha sido porponer nuevo importe 
como contraoferta. Para finalizar esta tarea, debe reflejar la decisión del comprador con respecto a la misma.</p> <p style="margin-bottom: 10px">Si el ofertante ha rechazado
 la propuesta de contraoferta, seleccione la opción "Deniega" en el campo "Respuesta ofertante Comité". Con esto se dará por concluido el trámite y el expediente quedará
 rechazado.</p> <p style="margin-bottom: 10px">Si el ofertante ha aceptado la propuesta de contraoferta, seleccione la opción "Aprueba". Si es así, se lanzará la
 tarea "Informe jurídico" a la gestoría de formalización.</p> <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier 
aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'),	
    			--TAP_CODIGO 				   --TFI_LABEL_VIEJO 		--TFI_NOMBRE 	      --TFI_LABEL_NUEVO
    	T_TFI(   'T017_ResolucionCES',   		'Título',				'titulo',	  	'<p style="margin-bottom: 10px">
		        Ha elevado un expediente comercial al comité sancionador de la cartera.
		        Para completar esta tarea es necesario esperar a la respuesta del comité, subiendo el documento de respuesta por parte del comité en la pestaña "documentos".
		        Además:
		    </p>
		    <p style="margin-bottom: 10px">
		        A) Si el comité ha <b>rechazado</b> la oferta, seleccione en el campo "Resolución Advisory" la opción "Rechaza". Con esto finalizará el trámite, quedando el expediente rechazado.
		    </p>
		    <p style="margin-bottom: 10px">
		        B) Si el comité ha <b>propuesto</b> una contraoferta, suba el documento justificativo en la pestaña "documentos" del expediente.
		        Seleccione la opción "contraoferta" e introduzca el importe propuesto en el campo "importe contraoferta Advisory".
		        La siguiente tarea que se lanzará es "Respuesta ofertante Comité".
		    </p>
		    <p style="margin-bottom: 10px">
		    C) Si el comité ha <b>aprobado</b> la oferta, seleccione la opción "aprobado" en el campo "Resolución Advisory". La siguiente tarea se le lanzará a informe jurídico; creación de AN y PBC de reserva o venta según el caso.
		    </p>
		    <p style="margin-bottom: 10px">
		    En el campo "observaciones Advisory" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>')
		);
      V_TMP_T_TFI T_TFI;

    
 -- ## FIN DATOS

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizando datos de TFI_TAREAS_FORM_ITEMS');
	V_MSQL := 'SELECT COUNT(TAP_CODIGO) FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''T017_DefinicionOferta'',''T017_RespuestaOfertanteCES'',''T017_ResolucionCES'') AND BORRADO = 0';
    
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS = 3 THEN
	
		-- Bucle INSERT tfi_tareas_form_items
		FOR I IN V_TFI.FIRST .. V_TFI.LAST
		LOOP
	
			V_TMP_T_TFI := V_TFI(I);
	
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	        ' SET TFI_LABEL = '''||V_TMP_T_TFI(4)||''' '||
	        ' ,USUARIOMODIFICAR = '''||V_USR||''', FECHAMODIFICAR = SYSDATE '||
	        ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||''') ' ||
	        ' AND TFI_NOMBRE = '''||V_TMP_T_TFI(3)||''' ';
	    EXECUTE IMMEDIATE V_MSQL;
	    DBMS_OUTPUT.PUT_LINE('[INFO] En tarea '||V_TMP_T_TFI(1)||' se ha actualizado el campo '||V_TMP_T_TFI(2)||' para dar a la columna TFI_BUSINESS_OPERATION el valor nuevo.');
	
		END LOOP;
		
	    DBMS_OUTPUT.PUT_LINE('[FIN] Filas TFI insertadas correctamente.');
		COMMIT;    
		
	END IF;

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
