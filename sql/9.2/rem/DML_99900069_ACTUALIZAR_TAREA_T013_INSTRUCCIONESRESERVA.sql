--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20170206
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0
--## INCIDENCIA_LINK=HREOS-1472
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza campos de TFI_TAREAS_FORM_ITEMS
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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
    /* TABLA: TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    --                TAP_CODIGO                                                 TFI_NOMBRE                       TFI_TIPO				TFI_ORDEN	 	BORRADO	TFI_VALIDACION					TFI_ERROR_VALIDACION		TFI_BUSINESS_OPERATION
		   T_TFI(   'T013_InstruccionesReserva'                       ,        'titulo'      		,             'label'       ,    	'0'		,		0		,''								,''							,''	),
		   T_TFI(   'T013_InstruccionesReserva'                       ,        'comboVPO'    	  	,             'combo'       ,  		'1'		,		1		,''								,''							,''),
		   T_TFI(   'T013_InstruccionesReserva'                   	  ,        'Tipo de arras'      ,             'combo'       ,    	'2'		,		0		,'false' 						,'Debe indicar el tipo de arras'	,'DDTiposArras'),
		   T_TFI(   'T013_InstruccionesReserva'                    	  ,        'fechaEnvio'         ,             'date'        ,  		'3'		,		0		,''								,''							,''),
		   T_TFI(   'T013_InstruccionesReserva'                    	  ,        'observaciones'      ,             'textarea'    ,      	'4'		,		0		,''								,''							,''),
		   T_TFI(   'T013_InstruccionesReserva'                    	  ,        'Tipo de arras'      ,             'combo'       ,    	'5'		,		1		,''								,''							,''),
		   T_TFI(   'T013_InstruccionesReserva'                    	  ,        'fechaEnvio'         ,             'date'        ,  		'6'		,		1		,''								,''							,''),
		   T_TFI(   'T013_InstruccionesReserva'                       ,        'observaciones'      ,             'textarea'    ,      	'7'		,		1		,''								,''							,'')
		);
    V_TMP_T_TFI T_TFI;
    
    
    
 -- ## FIN DATOS
 -- ########################################################################################
      


BEGIN

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizando datos de TFI_TAREAS_FORM_ITEMS.');
	-- Bucle UPDATE tfi_tareas_form_items
	FOR I IN V_TFI.FIRST .. V_TFI.LAST
	LOOP
	  V_TMP_T_TFI := V_TFI(I);
	  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS ' ||
	  			  ' SET TFI_TIPO = '||''''||V_TMP_T_TFI(3)||''''||','||
	  			  ' BORRADO = '||''''||V_TMP_T_TFI(5)||''''||','||
	  			  ' TFI_BUSINESS_OPERATION = '||''''||V_TMP_T_TFI(8)||''''||','||
	  			  ' TFI_VALIDACION = '||''''||V_TMP_T_TFI(6)||''''||','||
	  			  ' TFI_ERROR_VALIDACION = '||''''||V_TMP_T_TFI(7)||''''
	  ||' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '||''''||V_TMP_T_TFI(1)||''''||')'
	  ||' AND TFI_ORDEN = '||''''||V_TMP_T_TFI(4)||''''
	  ||' AND TFI_NOMBRE = '||''''||V_TMP_T_TFI(2)||'''';
	  EXECUTE IMMEDIATE V_MSQL;
	END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Actualizado correctamente.');
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