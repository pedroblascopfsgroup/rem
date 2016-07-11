--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160518
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.0.4
--## INCIDENCIA_LINK=HREOS-379
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza campos de TFI_TAREAS_FORM_ITEMS - Obligatorios
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
    --                TAP_CODIGO                                                 TFI_NOMBRE                       TFI_TIPO
		   T_TFI(   'T006_EmisionInforme'                             ,        'fechaEmision'      ,             'datemaxtod'           ),
		   T_TFI(   'T006_ValidacionInforme'                          ,        'fechaValidacion'   ,             'datemaxtod'           ),
		   T_TFI(   'T006_SolicitudExtraordinaria'                    ,        'fecha'             ,             'datemaxtod'           ),
		   T_TFI(   'T006_AutorizacionPropietario'                    ,        'fecha'             ,             'datemaxtod'           ),
		   T_TFI(   'T006_CierreEconomico'                            ,        'fechaCierre'       ,             'datemaxtod'           )
		);
    V_TMP_T_TFI T_TFI;
    
    
    
 -- ## FIN DATOS
 -- ########################################################################################
    
/* TIPOS DE CAMPO ANTERIORES
		   T_TFI(   'T006_EmisionInforme'                             ,        'fechaEmision'      ,             'date'                 ),
		   T_TFI(   'T006_ValidacionInforme'                          ,        'fechaValidacion'   ,             'date'                 ),
		   T_TFI(   'T006_SolicitudExtraordinaria'                    ,        'fecha'             ,             'date'                 ),
		   T_TFI(   'T006_AutorizacionPropietario'                    ,        'fecha'             ,             'date'                 ),
		   T_TFI(   'T006_CierreEconomico'                            ,        'fechaCierre'       ,             'date'                 )
*/    


BEGIN

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizando datos de TFI_TAREAS_FORM_ITEMS. T. INFORME: Estableciendo FECHAS MAXIMAS a HOY()');
	-- Bucle UPDATE tfi_tareas_form_items
	FOR I IN V_TFI.FIRST .. V_TFI.LAST
	LOOP
	  V_TMP_T_TFI := V_TFI(I);
	  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS ' ||
	  			  ' SET   TFI_TIPO = '||''''||V_TMP_T_TFI(3)||''''
	  ||' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '||''''||V_TMP_T_TFI(1)||''''||')'
	  ||' AND TFI_NOMBRE = '||''''||V_TMP_T_TFI(2)||'''';
	  DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO - Set FECHA MAXIMA HOY(): '''||V_TMP_T_TFI(2)||''' de '''||V_TMP_T_TFI(1)||''''); 
--	  DBMS_OUTPUT.PUT_LINE(V_MSQL);
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