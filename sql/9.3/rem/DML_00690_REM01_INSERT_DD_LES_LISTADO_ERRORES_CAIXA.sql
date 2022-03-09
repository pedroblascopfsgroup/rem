--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220302
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17266
--## PRODUCTO=NO
--##
--## Finalidad: Insert en tabla DD_LES_LISTADO_ERRORES_CAIXA.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-16085] - Alejandra García
--##        0.2 Añadir resgistros y campo SITUACION - [HREOS-17266] - Alejandra García
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
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_LES_LISTADO_ERRORES_CAIXA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-17266';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --DD_RETORNO_CAIXA DD_TEXT_MENSAJE_CAIXA  SITUACION  DD_EGA_CODIGO  DD_EAH_CODIGO  DD_EAP_CODIGO
	T_TIPO_DATA('PAGADA'   ,'Pagada'                     ,'PAGADA'                    ,'05','03','07'),
	T_TIPO_DATA('ENTREGADA','Aceptada.  Pdte pago'       ,'ACEPTADA PAGO'             ,'04','03','07'),
	T_TIPO_DATA('ENTREGADA','Incidenica pdte corrección.','ALERTA PAGO'               ,'04','03','07'),
	T_TIPO_DATA('ENTREGADA','No contabilizada'           ,'INC.REGISTRO'              ,'03','03','01'),
	T_TIPO_DATA('ENTREGADA','Pdte aceptacion'            ,'PENDIENTE'                 ,'04','03','07'),
	T_TIPO_DATA('ENTREGADA','Aprobación directa'         ,'APROBACION DIRECTA'        ,'04','03','07'),
	T_TIPO_DATA('ENTREGADA','Denegada por duplicada'     ,'DENEGADA POR DUPLICADA'    ,'08','01','04')


    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a insertar.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_RETORNO_CAIXA = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND SITUACION = '''||TRIM(V_TMP_TIPO_DATA(3))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN				
          -- Si existe se modifica.
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    'SET DD_TEXT_MENSAJE_CAIXA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
					', DD_EGA_ID = (SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''') '||
					', DD_EAH_ID = (SELECT DD_EAH_ID FROM '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||''') '||
					', DD_EAP_ID = (SELECT DD_EAP_ID FROM '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(6))||''') '||
					', USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_RETORNO_CAIXA = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND SITUACION = '''||TRIM(V_TMP_TIPO_DATA(3))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
  
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                        DD_LES_ID
                      , DD_LES_CODIGO
                      , DD_RETORNO_CAIXA
                      , SITUACION
                      , DD_TEXT_MENSAJE_CAIXA
                      , DD_EGA_ID, DD_EAH_ID
                      , DD_EAP_ID 
                      , USUARIOCREAR
                      , FECHACREAR) VALUES
                    (    S_'||V_TEXT_TABLA||'.NEXTVAL
                      ,  SYS_GUID()
                      ,  '''||TRIM(V_TMP_TIPO_DATA(1))||'''
                      ,  '''||TRIM(V_TMP_TIPO_DATA(3))||'''
                      ,  '''||TRIM(V_TMP_TIPO_DATA(2))||'''
                      ,  (SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''')
                      ,  (SELECT DD_EAH_ID FROM '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||''')
                      ,  (SELECT DD_EAP_ID FROM '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(6))||''')
                      ,  '''||V_USUARIO||'''
                      ,  SYSDATE)';
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
