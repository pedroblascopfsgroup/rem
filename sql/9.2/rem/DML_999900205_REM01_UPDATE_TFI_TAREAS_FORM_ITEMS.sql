--/*
--##########################################
--## AUTOR=DANIEL ALGABA
--## FECHA_CREACION=20180509
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4074
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el trámite T011_RevisionInformeComercial para ocultar el campo comboDatosIguales y ponerle por defecto el valor No.
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
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(30 CHAR) := 'TFI_TAREAS_FORM_ITEMS';  -- Tabla a modificar
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := 'HREOS-4074'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('T011_RevisionInformeComercial','comboini','comboDatosIguales','02')
    );

    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN

    DBMS_OUTPUT.PUT_LINE('COMENZANDO EL PROCESO DE ACTUALIZACIÓN TABLA '||V_TABLA||'');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

	    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND
				 TAP_ID = (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND TAP.BORRADO = 0) AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	     
	    IF V_NUM_TABLAS = 1 THEN
	        
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
					   SET TFI_TIPO = '''||TRIM(V_TMP_TIPO_DATA(2))||''',TFI_VALOR_INICIAL = '''||TRIM(V_TMP_TIPO_DATA(4))||''',
					   USUARIOMODIFICAR = '''||V_USU_MODIFICAR||''',
					   FECHAMODIFICAR = SYSDATE
					   WHERE TAP_ID = (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''') 
					   AND TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(3))||''''; 
		    EXECUTE IMMEDIATE V_MSQL;
	    END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TABLA||' ACTUALIZADA CORRECTAMENTE ');


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