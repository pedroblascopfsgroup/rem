--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170615
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2248
--## PRODUCTO=NO
--##
--## Finalidad: MODIFICA campos tarea 'Actuación Técnica'
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
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    TYPE T_TIPO_CODIGO IS TABLE OF VARCHAR2(50 CHAR);
    TYPE T_ARRAY_CODIGO IS TABLE OF T_TIPO_CODIGO;
    V_TIPO_CODIGO T_ARRAY_CODIGO := T_ARRAY_CODIGO(
    	T_TIPO_CODIGO('T004_AnalisisPeticion'),
    	T_TIPO_CODIGO('T004_FijacionPlazo'),
    	T_TIPO_CODIGO('T004_ResultadoTarificada'),
    	T_TIPO_CODIGO('T004_ResultadoNoTarificada'),
    	T_TIPO_CODIGO('T004_CierreEconomico')
    );
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('REPLACE(TFI_LABEL, ''el activo dispone'', ''el/los activo/s dispone/n'')'),
    	T_TIPO_DATA('REPLACE(TFI_LABEL, ''(por determinar)'', ''XX'')'),
    	T_TIPO_DATA('TFI_LABEL || ''<p style="margin-bottom: 10px">En caso de que el trabajo haya afectado a varios activos, debe validar el importe de participación de cada uno de ellos en el importe total del trabajo, modificándolo en su caso. En el supuesto de que no haya podido realizar el trabajo respecto de alguno de los activos, deberá anotar un porcentaje de participación igual a 0.</p>'''),
    	T_TIPO_DATA('TFI_LABEL || ''<p style="margin-bottom: 10px">En caso de que el trabajo haya afectado a varios activos, debe validar el importe de participación de cada uno de ellos en el importe total del trabajo, modificándolo en su caso. En el supuesto de que no haya podido realizar el trabajo respecto de alguno de los activos, deberá anotar un porcentaje de participación igual a 0.</p>'''),
    	T_TIPO_DATA('TFI_LABEL || ''<p style="margin-bottom: 10px">Para ello deberá cumplimentar (...). Asimismo, en el caso de que el trabajo afecte a más de un activo, deberá validar en la pestaña de Listado de Activos que es correcto el porcentaje de participación de cada uno de ellos en el coste del trabajo.</p>''')
    );

    TYPE T_TIPO_DECISION IS TABLE OF VARCHAR2(3500 CHAR);
    TYPE T_ARRAY_DECISION IS TABLE OF T_TIPO_DECISION;
    V_TIPO_DECISION T_ARRAY_DECISION := T_ARRAY_DECISION(
    	T_TIPO_DECISION('valores[''T004_EleccionPresupuesto''][''comboPresupuesto''] == DDSiNo.NO ? ''PresupuestoInvalido'' : (checkBankia() ? (checkSuperaPresupuestoActivo() ? ''ValidoSuperaLimiteBankia'' : (checkSuperaDelegacion() ? ''ValidoSuperaLimiteBankia'' : ''ConSaldo''))  : (checkEsMultiactivo() ? ''ConSaldo'' : (checkSuperaPresupuestoActivo() ? ''SinSaldo'' : ''ConSaldo'')))'),
    	T_TIPO_DECISION('checkBankia() ? (checkSuperaPresupuestoActivo() ? ''SuperaLimiteBankia'' : (checkSuperaDelegacion() ? ''SuperaLimiteBankia'' : ''ConSaldo'')) : (checkEsMultiactivo() ? ''ConSaldo'' :	(checkSuperaPresupuestoActivo() ? ''SinSaldo'' : ''ConSaldo'')))')
    );
    
    TYPE T_TIPO_DECISION_CODIGO IS TABLE OF VARCHAR2(3500 CHAR);
    TYPE T_ARRAY_DECISION_CODIGO IS TABLE OF T_TIPO_DECISION_CODIGO;
    V_TIPO_DECISION_CODIGO T_ARRAY_DECISION_CODIGO := T_ARRAY_DECISION_CODIGO(
    	T_TIPO_DECISION_CODIGO('T004_EleccionPresupuesto'),
    	T_TIPO_DECISION_CODIGO('T004_EleccionProveedorYTarifa')
    );
    V_TMP_TIPO_CODIGO T_TIPO_CODIGO;
    V_TMP_TIPO_DATA T_TIPO_DATA;
    V_TMP_TIPO_DECISION_CODIGO T_TIPO_DECISION_CODIGO;
    V_TMP_TIPO_DECISION T_TIPO_DECISION;
    
BEGIN

    DBMS_OUTPUT.PUT_LINE('COMENZANDO EL PROCESO DE ACTUALIZACIÓN TABLA ''TFI_TAREAS_FORM_ITEMS''');
    FOR I IN V_TIPO_CODIGO.FIRST .. V_TIPO_CODIGO.LAST
      LOOP
      	V_TMP_TIPO_CODIGO := V_TIPO_CODIGO(I);
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
		   SET TFI_LABEL = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
		   WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_CODIGO(1))||''') 
			AND TFI_NOMBRE = ''titulo''';
		  
    EXECUTE IMMEDIATE V_MSQL;

      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ''TAP_TAREA_PROCEDIMIENTO'' ACTUALIZADA CORRECTAMENTE ');

	DBMS_OUTPUT.PUT_LINE('COMENZANDO EL PROCESO DE ACTUALIZACIÓN TABLA ''TFI_TAREAS_FORM_ITEMS''');
    FOR I IN V_TIPO_DECISION.FIRST .. V_TIPO_DECISION.LAST
      LOOP
      	V_TMP_TIPO_DECISION_CODIGO := V_TIPO_DECISION_CODIGO(I);
        V_TMP_TIPO_DECISION := V_TIPO_DECISION(I);
        
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
		   SET TAP_SCRIPT_DECISON = '''||TRIM(V_TMP_TIPO_DECISION(1))||'''
		   WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DECISION_CODIGO(1))||'''';
		  
    EXECUTE IMMEDIATE V_MSQL;

      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ''TAP_TAREA_PROCEDIMIENTO'' ACTUALIZADA CORRECTAMENTE ');
    
    --EXECUTE IMMEDIATE ('DELETE FROM TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T004_DisponibilidadSaldo''');
    --EXECUTE IMMEDIATE ('DELETE FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T004_DisponibilidadSaldo''');

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