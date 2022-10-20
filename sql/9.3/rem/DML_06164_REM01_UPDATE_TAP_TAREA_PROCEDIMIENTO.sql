--/*
--##########################################
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20221020
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18839
--## PRODUCTO=NO
--##
--## Finalidad:
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	V_TAP_ID NUMBER(16);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'TAP'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-18839';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(800);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('T015_EnvioContrato', '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : estanCamposRellenosParaFormalizacion() ? null : ''''Alguno o varios de los siguientes campos no estan rellenos: Clase contrato, Derecho firme, Retencion de impuestos, Tipo impuesto, Grupo impuesto, Tipo aplicable'''''),
    	T_TIPO_DATA('T018_AprobacionOferta', '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : estanCamposRellenosParaFormalizacion() ? null : ''''Alguno o varios de los siguientes campos no estan rellenos: Clase contrato, Derecho firme, Retencion de impuestos, Clase condicion, Grupo CBK, Tipo impuesto, Grupo impuesto, Tipo aplicable''''')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE '||
				' '||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN				
          -- Si existe se modifica.
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    'SET '||V_TEXT_CHARS||'_SCRIPT_VALIDACION = '''||TRIM(V_TMP_TIPO_DATA(2))||''', USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE WHERE '||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ';
          EXECUTE IMMEDIATE V_MSQL;
         
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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
