--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20210813
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-14300
--## PRODUCTO=NO
--##
--## Finalidad: Insert en tabla DD_LES_LISTADO_ERRORES_SAP.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
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
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_LES_LISTADO_ERRORES_SAP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-13884';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	T_TIPO_DATA('01','700','Gasto OK, pendiente de aprobación.','09','03','05'),
	T_TIPO_DATA('02','999','Gasto KO, pero se subsana en SAPBC (periodo contable cerrado, etc) y no requiere gestión por parte de Haya.', '08','01','04'),
	T_TIPO_DATA('03','000','Gasto contabilizado.','04','03','07'),
	T_TIPO_DATA('04','701','Gasto rechazado, requiere gestión por parte de Haya (vendrá acompañado de algún texto que clarifique el problema).','08','01','04'),
	T_TIPO_DATA('05','600','Gasto Ok, pero error en otro gasto de provisión.','03','03','01'),
	T_TIPO_DATA('06','800','Gasto pagado','05','03','07'),
	T_TIPO_DATA('07','801','Gasto retrocedido y vuelto a pagar.','05','03','07'),
	T_TIPO_DATA('08','802','Anulación pago.','04','03','07')


    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a insertar.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_LES_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN				
          -- Si existe se modifica.
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    'SET DD_RETORNO_SAPBC = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_TEXT_MENSAJE_SAP = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_LES_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
  
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                      DD_LES_ID, DD_LES_CODIGO, DD_RETORNO_SAPBC, DD_TEXT_MENSAJE_SAP, DD_EGA_ID, DD_EAH_ID, DD_EAP_ID ,USUARIOCREAR, FECHACREAR) VALUES
                      (S_'||V_TEXT_TABLA||'.NEXTVAL,  '''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', (SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_ID = '''||TRIM(V_TMP_TIPO_DATA(4))||'''),(SELECT DD_EAH_ID FROM '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_ID = '''||TRIM(V_TMP_TIPO_DATA(5))||'''),(SELECT DD_EAP_ID FROM '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_ID = '''||TRIM(V_TMP_TIPO_DATA(6))||'''),'''||V_USUARIO||''',SYSDATE)';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

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
