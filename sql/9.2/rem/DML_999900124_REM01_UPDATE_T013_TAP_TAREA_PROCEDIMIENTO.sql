--/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20170802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2600
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar trámite de comercialización.
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_USU VARCHAR2(30 CHAR) := 'HREOS-2600'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    /* Reordenar TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    --		   TAP_CODIGO                    TFI_NOMBRE             TFI_ORDEN
        T_TFI('T013_PosicionamientoYFirma',  'comboCondiciones'     ,  '4'),
        T_TFI('T013_PosicionamientoYFirma',  'condiciones'          ,  '5'),
        T_TFI('T013_PosicionamientoYFirma',  'motivoNoFirma'        ,  '6'),
        T_TFI('T013_PosicionamientoYFirma',  'observaciones'        ,  '7'),
        T_TFI('T013_PosicionamientoYFirma',  'tieneReserva'         ,  '8')
    );
    V_TMP_T_TFI T_TFI;

BEGIN

        DBMS_OUTPUT.PUT_LINE('[INFO] Eliminando TFI_TAREAS_FORM_ITEMS');

        V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = ''fechaIngreso'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_PosicionamientoYFirma'')';
        DBMS_OUTPUT.PUT_LINE('[INFO] eliminado TFI_TAREAS_FORM_ITEMS fechaIngreso .......');
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] REORDENANDO TFI_TAREAS_FORM_ITEMS');

        FOR I IN V_TFI.FIRST .. V_TFI.LAST
        LOOP

            V_TMP_T_TFI := V_TFI(I);

            --Comprobar el dato a insertar.
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_T_TFI(1))||''' AND BORRADO = 0';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            DBMS_OUTPUT.PUT_LINE('[INFO] ORDENANDO ''' || TRIM(V_TMP_T_TFI(1)));

            IF V_NUM_TABLAS > 0 THEN				
                -- Si existe se modifica.
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '||
                ' SET TFI_ORDEN = '||V_TMP_T_TFI(3)||' '||
                ' ,USUARIOMODIFICAR = ''' || V_USU || ''' ,FECHAMODIFICAR = SYSDATE '||
                ' WHERE TFI_NOMBRE = '''||V_TMP_T_TFI(2)||''' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||''') ';
                
                DBMS_OUTPUT.PUT_LINE('[INFO] ORDENANDO SQL: ''' || V_MSQL);
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO] El campo TAP_SCRIPT_VALIDACION_JBPM de la tarea '||V_TMP_T_TFI(1)||' se ha actualizado.');
                
            END IF;
        END LOOP;

		DBMS_OUTPUT.PUT_LINE('[INFO] Actualizar datos de '||V_TEXT_TABLA);

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T013_ResolucionTanteo'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS > 0 THEN

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T013_ResolucionTanteo''''][''''comboEjerce''''] == DDSiNo.SI ? (checkEjercidoTanteo() ? existeAdjuntoUGValidacion("13,E;05,E") : ''''No existe ningún activo del expediente con tanteo Ejercido'''') : (checkRenunciaTanteo() ? existeAdjuntoUGValidacion("13,E;05,E") : ''''Existe algún activo del expediente sin tanteo Renuncia'''')'''  || 
            ' ,USUARIOMODIFICAR = '''||V_USU||''' '||
            ' ,FECHAMODIFICAR = SYSDATE '||
		    ' WHERE TAP_CODIGO = ''T013_ResolucionTanteo'' ';
			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando tarea T013_ResolucionTanteo.......');
		    DBMS_OUTPUT.PUT_LINE(V_MSQL);
		    EXECUTE IMMEDIATE V_MSQL;

		END IF;

        DBMS_OUTPUT.PUT_LINE('[INFO] Actualizar datos de ' || V_TEXT_TABLA);

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T013_DocumentosPostVenta'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS > 0 THEN

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||
        			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''existeAdjuntoUGValidacion("19,E;17,E")'' '||
                      ' ,USUARIOMODIFICAR = '''||V_USU||''' '||
                      ' ,FECHAMODIFICAR = SYSDATE '||
        			  ' WHERE TAP_CODIGO = ''T013_DocumentosPostVenta'' ';
        	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;

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
