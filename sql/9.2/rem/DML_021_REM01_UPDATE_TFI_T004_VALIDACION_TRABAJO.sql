--/*
--##########################################
--## AUTOR=ALFONSO RODRIGUEZ 
--## FECHA_CREACION=20190917
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7610
--## PRODUCTO=NO
--##
--## Finalidad: INSERTA filas de TFI_TAREAS_FORM_ITEMS - Campos tarea T004_ValidacionTrabajo
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
    V_USR VARCHAR2(30 CHAR) := 'HREOS-7610'; -- USUARIOCREAR/USUARIOMODIFICAR
    
    
    /* TABLA: TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;

    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    			 --TAP_CODIGO 								       --TFI_TIPO 		--TFI_NOMBRE 			        --TFI_BUSINESS_OP				      --TFI_LABEL 								--TFI_ERROR_VALIDACION				--TFI_VALIDACION
		T_TFI(   'T004_ValidacionTrabajo',   			'combobox',			'motivoIncorreccion',	  		'DDMotivoDevolucionTbj',			'Motivo devolución',						'Debe indicar un motivo de devoluci&oacute;n',																		'' )
		);
      V_TMP_T_TFI T_TFI;

    
 -- ## FIN DATOS
 -- ########################################################################################

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Insertando datos de TFI_TAREAS_FORM_ITEMS - remapeo de tarea T004_ValidacionTrabajo');

	-- Bucle INSERT tfi_tareas_form_items
	FOR I IN V_TFI.FIRST .. V_TFI.LAST
	LOOP

		V_TMP_T_TFI := V_TFI(I);

		V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
        ' SET TFI_BUSINESS_OPERATION = '''||V_TMP_T_TFI(4)||''' '||
        ' ,TFI_TIPO = '''||V_TMP_T_TFI(2)||''' '||
        ' ,TFI_LABEL = '''||V_TMP_T_TFI(5)||''' '||
        ' ,TFI_ERROR_VALIDACION = '''||V_TMP_T_TFI(6)||''' '||
        ' ,USUARIOMODIFICAR = '''||V_USR||''', FECHAMODIFICAR = SYSDATE '||
        ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||''') ' ||
        '   AND TFI_NOMBRE = '''||V_TMP_T_TFI(3)||''' ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] En tarea '||V_TMP_T_TFI(1)||' se ha actualizado el campo '||V_TMP_T_TFI(3)||' para dar a la columna TFI_BUSINESS_OPERATION el valor '||V_TMP_T_TFI(4)||'.');

	END LOOP;

	DBMS_OUTPUT.PUT_LINE('[COMMIT] Commit realizado');
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Filas TFI insertadas correctamente.');

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
