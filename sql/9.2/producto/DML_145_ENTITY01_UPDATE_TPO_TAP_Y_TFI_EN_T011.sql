/*
--##########################################
--## AUTOR=Juan Ruiz
--## FECHA_CREACION=20181210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.2.3
--## INCIDENCIA_LINK=HREOS-4913
--## PRODUCTO=SI
--##
--## Finalidad: DML
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
    VAR_TABLENAME VARCHAR2(50 CHAR) := 'DD_TPO_TIPO_PROCEDIMIENTO'; -- Nombre de la tabla a modificar
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    VAR_TIPOACTUACION VARCHAR2(50 CHAR); -- Tipo de actuación a insertar
    VAR_DD_TPO_XML_JBPM VARCHAR2(50 CHAR) := 'activo_tramiteAprobacionInformeComercial'; -- DD_TPO_XML_JBPM
    VAR_DD_TPO_DESCRIPCION VARCHAR2(50 CHAR) := 'Trámite Aprobación Informe Comercial'; -- DD_TPO_DESCRIPCION
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := 'HREOS-4913'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('T011_RevisionInformeComercial','comboini','comboDatosIguales','02')
    );

    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ... Empezando a actualizar DD_TPO_TIPO_PROCEDIMIENTO');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO SET DD_TPO_XML_JBPM = ''' || VAR_DD_TPO_XML_JBPM || ''', ' ||
    								'DD_TPO_DESCRIPCION = ''' || VAR_DD_TPO_DESCRIPCION || ''', ' ||
									'DD_TPO_DESCRIPCION_LARGA = ''' || VAR_DD_TPO_DESCRIPCION || ''', ' ||
									'USUARIOMODIFICAR = ''' || V_USU_MODIFICAR || ''', ' ||
									'FECHAMODIFICAR = SYSDATE ' ||
									'WHERE DD_TPO_CODIGO = ''T011''';
    EXECUTE IMMEDIATE V_MSQL;
   
    DBMS_OUTPUT.PUT_LINE('ACTUALIZADO DD_TPO_TIPO_PROCEDIMIENTO');
    
    DBMS_OUTPUT.PUT_LINE('....');
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] ... Empezando a actualizar TAP_TAREA_PROCEDIMIENTO');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_DESCRIPCION = ''Revisión Informe Comercial'', '||
			  'USUARIOMODIFICAR = ''' || V_USU_MODIFICAR || ''', ' ||
			  'FECHAMODIFICAR = SYSDATE ' ||
	          ' WHERE TAP_CODIGO = ''T011_RevisionInformeComercial''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando descripción tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('ACTUALIZADO TAP_TAREA_PROCEDIMIENTO');
   
     DBMS_OUTPUT.PUT_LINE('COMENZANDO EL PROCESO DE ACTUALIZACIÓN TABLA TFI_TAREAS_FORM_ITEMS');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

	    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND
				 TAP_ID = (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND TAP.BORRADO = 0) AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	     
	    IF V_NUM_TABLAS = 1 THEN
	        
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
					   SET BORRADO = 1,
					   USUARIOBORRAR = '''||V_USU_MODIFICAR||''',
					   FECHABORRAR = SYSDATE
					   WHERE TAP_ID = (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''') 
					   AND TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(3))||''''; 
		    EXECUTE IMMEDIATE V_MSQL;
	    END IF;
      END LOOP;
      
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = ''titulo'' AND
				 TAP_ID = (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND TAP.BORRADO = 0) AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	     
	    IF V_NUM_TABLAS = 1 THEN
	        
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
					   SET TFI_LABEL = ''<p style="margin-bottom: 10px">Si se informa el valor "Sí" en el campo "Aceptar informe comercial", el informe quedará como aceptado.</p><p style="margin-bottom: 10px">Por el contrario, si se informa el valor "No" en el campo "Aceptar informe comercial", se rechazará el informe comercial y, en este caso, deberá indicar el motivo que ha generado este rechazo.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'',
					   USUARIOMODIFICAR = '''||V_USU_MODIFICAR||''',
					   FECHAMODIFICAR = SYSDATE
					   WHERE TAP_ID = (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''') 
					   AND TFI_NOMBRE = ''titulo'''; 
		    EXECUTE IMMEDIATE V_MSQL;
		END IF;

    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TFI_TAREAS_FORM_ITEMS ACTUALIZADA CORRECTAMENTE ');
    
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
