--/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20170718
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=p2.0.6-170728
--## INCIDENCIA_LINK=HREOS-2112
--## PRODUCTO=NO
--##
--## Finalidad: Crear tabla nueva
--## INSTRUCCIONES:
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
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(3 CHAR) := 'TAP'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_USU_BORRAR VARCHAR2(30 CHAR) := '''HREOS-2112'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    
    /* TABLA: TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;

    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    			 --TAP_CODIGO 							--TAP_SCRIPT_VALIDACION_JBPM 		
		         T_TFI(   'T008_ObtencionDocumento', 'valores[''''T008_ObtencionDocumento''''][''''comboObtencion''''] == DDSiNo.SI ? (esFechaMenor(valores[''''T008_ObtencionDocumento''''][''''fechaEmision''''], fechaAprobacionTrabajo()) ? ''''Fecha emisi&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : (existeAdjuntoUG("13","T") || existeAdjuntoUG("27","T")) ? null : "Es necesario adjuntar sobre el trabajo el documento Cédula de habitabilidad o bien el Certificado sustitutivo de Cédula de Habitabilidad" ) : (valores[''''T008_ObtencionDocumento''''][''''motivoNoObtencion''''] == DDMotivoNoObtencion.NO_CUMPLE_REQUISITOS ? null : null)')
		);
      V_TMP_T_TFI T_TFI;

    
 -- ## FIN DATOS
 -- ########################################################################################

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);

	-- Bucle INSERT tfi_tareas_form_items
	FOR I IN V_TFI.FIRST .. V_TFI.LAST
	LOOP

		V_TMP_T_TFI := V_TFI(I);
		
		--Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE '||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_T_TFI(1))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN				
			-- Si existe se modifica.
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
	        ' SET TAP_SCRIPT_VALIDACION_JBPM = '''||V_TMP_T_TFI(2)||''' '||
	        ' ,USUARIOMODIFICAR = '||V_USU_BORRAR||' '||
	        ' ,FECHAMODIFICAR = SYSDATE '||
	        ' WHERE '||V_TEXT_CHARS||'_ID = (SELECT '||V_TEXT_CHARS||'_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE '||V_TEXT_CHARS||'_CODIGO = '''||V_TMP_T_TFI(1)||''') ';
		    EXECUTE IMMEDIATE V_MSQL;
	
		    DBMS_OUTPUT.PUT_LINE('[INFO] El campo TAP_SCRIPT_VALIDACION_JBPM de la tarea '||V_TMP_T_TFI(1)||' se ha actualizado.');
		    
		END IF;
	END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Filas TAP actualizadas correctamente.');

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
