--/*
--##########################################
--## AUTOR=Sergio Nieto
--## FECHA_CREACION=201811112
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4719
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el trámite T015 Trámite comercial alquiler.
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_USU VARCHAR2(30 CHAR) := 'HREOS-4719'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    /* Reordenar TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    --		   TAP_CODIGO                    TFI_NOMBRE             	TFI_ORDEN
        T_TFI('T015_VerificarSeguroRentas',  'nMesesFianza'        		,  '3'),
        T_TFI('T015_VerificarSeguroRentas',  'importeFianza'     		,  '4'),
        T_TFI('T015_VerificarSeguroRentas',  'deposito'          		,  '5'),
        T_TFI('T015_VerificarSeguroRentas',  'nMeses'        			,  '6'),
        T_TFI('T015_VerificarSeguroRentas',  'importeDeposito'        	,  '7'),
        T_TFI('T015_VerificarSeguroRentas',  'fiadorSolidario'        	,  '8'),
        T_TFI('T015_VerificarSeguroRentas',  'nombreFS'        			,  '9'),
        T_TFI('T015_VerificarSeguroRentas',  'documento'        		,  '10'),
        T_TFI('T015_VerificarSeguroRentas',  'tipoImpuesto'        		,  '11'),
        T_TFI('T015_VerificarSeguroRentas',  'porcentajeImpuesto'       ,  '12'),
        T_TFI('T015_VerificarSeguroRentas',  'aseguradora'         		,  '13'),
        T_TFI('T015_VerificarSeguroRentas',  'envioEmail'        		,  '14'),
        T_TFI('T015_VerificarSeguroRentas',  'observaciones'       		,  '15'),
        T_TFI('T015_AceptacionCliente',  	 'hueco'       				,  '3')

    );
    V_TMP_T_TFI T_TFI;

BEGIN

        DBMS_OUTPUT.PUT_LINE('[INFO] Eliminando TFI_TAREAS_FORM_ITEMS');

        V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = ''motivoRechazo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T015_VerificarSeguroRentas'')';
        DBMS_OUTPUT.PUT_LINE('[INFO] eliminado TFI_TAREAS_FORM_ITEMS motivoRechazo .......');
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;
        
        V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = ''motivoAC'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T015_AceptacionCliente'')';
        DBMS_OUTPUT.PUT_LINE('[INFO] eliminado TFI_TAREAS_FORM_ITEMS motivoAC .......');
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
