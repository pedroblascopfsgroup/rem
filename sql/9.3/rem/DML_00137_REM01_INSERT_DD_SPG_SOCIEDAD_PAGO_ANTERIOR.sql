--/*
--##########################################
--## AUTOR=Pablo Garcia Pallas
--## FECHA_CREACION=20200324
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9844
--## PRODUCTO=NO
--##
--## Finalidad: Script que completa el diccionario DD_SPG_SOCIEDAD_PAGO_ANTERIOR
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SPG_SOCIEDAD_PAGO_ANTERIOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ID NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-9844';
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        -- DD_SPG_CODIGO, (CODIGO DEL EXCEL), DD_SPG_DESCRIPCION, DD_SPG_DESCRIPCION_LARGA  
        T_TIPO_DATA('105', '8021', 'SATICEM IMMOBLES EN ARRENDAMENT S.L.', 'SATICEM IMMOBLES EN ARRENDAMENT S.L.'),	
		T_TIPO_DATA('106', '8018', 'CAIXA MANRESA IMMOBILIARIA SOCIAL S.L.', 'CAIXA MANRESA IMMOBILIARIA SOCIAL S.L.'),
		T_TIPO_DATA('107', '8014', 'IRIDION SOLUCIONS IMMOBILIÀRIES, S.L.', 'IRIDION SOLUCIONS IMMOBILIÀRIES, S.L.'),
		T_TIPO_DATA('108', '8006', 'GESCAT LLEVANT, S.L.', 'GESCAT LLEVANT, S.L.'),
		T_TIPO_DATA('109', '8020', 'CAIXA MANRESA ONCASA INMOBILIARIA S.L.', 'CAIXA MANRESA ONCASA INMOBILIARIA S.L.'),
		T_TIPO_DATA('110', '8013', 'GESCAT LLOGUERS, S.L.', 'GESCAT LLOGUERS, S.L.'),
		T_TIPO_DATA('111', '8015', 'NOIDIRI, S.L.', 'NOIDIRI, S.L.'),
		T_TIPO_DATA('112', '8022', 'SATICEM GESTIO S.L.U.', 'SATICEM GESTIO S.L.U.'),
		T_TIPO_DATA('113', '8019', 'SATICEM HOLDING S.L.', 'SATICEM HOLDING S.L.'),
		T_TIPO_DATA('114', '8007', 'PUERTO CIUDAD LAS PALMAS, S.A.', 'PUERTO CIUDAD LAS PALMAS, S.A.'),
		T_TIPO_DATA('115', '9736', 'ARRELS CT LLOGUER SA', 'ARRELS CT LLOGUER SA'),
		T_TIPO_DATA('116', '8011', 'GESCAT GESTIÓ DE SÒL, S.L.', 'GESCAT GESTIÓ DE SÒL, S.L.'),
		T_TIPO_DATA('117', '8010', 'ACTIVOS MACORP, S.L.', 'ACTIVOS MACORP, S.L.'),
		T_TIPO_DATA('118', '9732', 'PROMOU CT 3 AG DELTA SLU', 'PROMOU CT 3 AG DELTA SLU'),
		T_TIPO_DATA('119', '8012', 'GESCAT VIVENDES EN COMERCIALITZACIÓ, S.L', 'GESCAT VIVENDES EN COMERCIALITZACIÓ, S.L'),
		T_TIPO_DATA('120', '9711', 'ARRAHONA RENT SLU', 'ARRAHONA RENT SLU'),
		T_TIPO_DATA('121', '224', 'EL MILANILLO, S.A.', 'EL MILANILLO, S.A.'),
		T_TIPO_DATA('122', 'BVR5', 'BBVA RMBS 5 Fondo de Titulizacion de Activos', 'BBVA RMBS 5 Fondo de Titulizacion de Activos'),
		T_TIPO_DATA('123', '9716', 'L EIX IMMOBLES S.L.', 'L EIX IMMOBLES S.L.'),
		T_TIPO_DATA('124', '8002', 'CATALUNYACAIXA IMMOBILIARIA SAU', 'CATALUNYACAIXA IMMOBILIARIA SAU'),
		T_TIPO_DATA('125', '8016', 'CETACTIUS, S.L.', 'CETACTIUS, S.L.')
		); 	
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_SCR_SUBCARTERA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT EN '||TRIM(V_TEXT_TABLA)||'');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TRIM(V_TEXT_TABLA)||' WHERE DD_SPG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        DBMS_OUTPUT.PUT_LINE('[INFO]: NUMERO DE REGISTROS '''|| TRIM(V_SQL) ||''' CON VALOR: '''|| TRIM(V_NUM_TABLAS)||'''');
        --Si existe lo modificamos
        IF V_NUM_TABLAS <= 0 THEN		

          DBMS_OUTPUT.PUT_LINE('[INFO]: CREAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_SPG_SOCIEDAD_PAGO_ANTERIOR (DD_SPG_CODIGO, DD_SPG_DESCRIPCION, 
		  DD_SPG_DESCRIPCION_LARGA, USUARIOCREAR) VALUES('''||TRIM(V_TMP_TIPO_DATA(1))||''', '''||TRIM(V_TMP_TIPO_DATA(3))||'''
		  , '''||TRIM(V_TMP_TIPO_DATA(4))||''', '''||TRIM(V_ITEM)||''')';
          DBMS_OUTPUT.PUT_LINE('[INFO]: SENTENCIA '|| TRIM(V_MSQL)||''' A PUNTO DE EJECUTARSE');
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO CREADO CORRECTAMENTE');
       END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' CREADOS CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
