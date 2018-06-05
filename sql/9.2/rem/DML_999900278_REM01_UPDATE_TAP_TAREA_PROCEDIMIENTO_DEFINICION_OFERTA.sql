--/*
--##########################################
--## AUTOR=DANIEL ALGABA
--## FECHA_CREACION=20180528
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.19
--## INCIDENCIA_LINK=HREOS-4113
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica la columna TAP_SCRIPT_VALIDACION_JBPM para la tarea T013_DefinicionOferta
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32500 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_TABLA VARCHAR2(27 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''HREOS-4113'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    T_TIPO_DATA('T013_DefinicionOferta', 'existeAdjuntoUGCarteraValidacion("36", "E", "01") == null ? valores[''''T013_DefinicionOferta''''][''''comboConflicto''''] == DDSiNo.SI || valores[''''T013_DefinicionOferta''''][''''comboRiesgo''''] == DDSiNo.SI  ?  ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' : comprobarComiteLiberbankPlantillaPropuesta() ? existeAdjuntoUGCarteraValidacion("36", "E", "08") : definicionOfertaT013(valores[''''T013_DefinicionOferta''''][''''comiteSuperior''''])  : existeAdjuntoUGCarteraValidacion("36", "E", "01")')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
  LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TAP_CODIGO = ''T013_DefinicionOferta'' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

  	IF V_NUM_TABLAS > 0 THEN
    	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET TAP_SCRIPT_VALIDACION_JBPM = '''|| V_TMP_TIPO_DATA(2)||'''
      , USUARIOMODIFICAR = '||V_USU_MODIFICAR||' 
      , FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = '''|| V_TMP_TIPO_DATA(1)||''' AND DD_TPO_ID = (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''T013'')';
    	EXECUTE IMMEDIATE V_MSQL;
    	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');

      DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAP_TAREA_PROCEDIMIENTO ACTUALIZADA CORRECTAMENTE ');
    ELSE      
        DBMS_OUTPUT.PUT_LINE('[INFO] NO SE HACE NADA, NO SE HA ENCONTRADO LA TAREA T013_DefinicionOferta EN LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'');
    END IF;
  END LOOP;
  COMMIT;
   			
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] SE HA PRODUCIDO UN ERROR EN LA EJECUCIÓN:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

