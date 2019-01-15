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
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''HREOS-4719'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    
    TYPE T_TIPO_CODIGO IS TABLE OF VARCHAR2(50 CHAR);
    TYPE T_ARRAY_CODIGO IS TABLE OF T_TIPO_CODIGO;
    V_TIPO_CODIGO T_ARRAY_CODIGO := T_ARRAY_CODIGO(
    	T_TIPO_CODIGO('T015_ElevarASancion')
    );
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('DDMotivoAnulacionOferta')
    );

    V_TMP_TIPO_CODIGO T_TIPO_CODIGO;
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN

    DBMS_OUTPUT.PUT_LINE('COMENZANDO EL PROCESO DE ACTUALIZACIÓN TABLA ''TFI_TAREAS_FORM_ITEMS''');
    FOR I IN V_TIPO_CODIGO.FIRST .. V_TIPO_CODIGO.LAST
      LOOP
      	V_TMP_TIPO_CODIGO := V_TIPO_CODIGO(I);
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
		   SET TFI_BUSINESS_OPERATION = '''||TRIM(V_TMP_TIPO_DATA(1))||''',
		   USUARIOMODIFICAR = '||V_USU_MODIFICAR||',
		   FECHAMODIFICAR = SYSDATE
		   WHERE TAP_ID = (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = '''||TRIM(V_TMP_TIPO_CODIGO(1))||''') 
			AND TFI_NOMBRE = ''motivoAnulacion'''; 
    EXECUTE IMMEDIATE V_MSQL;

      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ''TFI_TAREAS_FORM_ITEMS'' ACTUALIZADA CORRECTAMENTE ');


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