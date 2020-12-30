--/*
--##########################################
--## AUTOR=KEVIN HONORATO
--## FECHA_CREACION=20201214
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12376
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_SCS_SEGMENTO_CRA_SCR los datos añadidos en T_ARRAY_DATA
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SCS_SEGMENTO_CRA_SCR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(25 CHAR) := 'HREOS-11197'; 
    V_ID_CRA NUMBER(16); --Vble para extraer el ID del registro de la cartera.
    V_ID_SCR_ARROW NUMBER(16); --Vble para extraer el ID del registro de la subcartera.
    V_ID_SCR_REMAINING NUMBER(16); --Vble para extraer el ID del registro de la subcartera.
    V_ID_TS NUMBER(16); --Vble para extraer el ID del registro del diccionario tipo segmento.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
  	T_TIPO_DATA('00200'),
    T_TIPO_DATA('00201'),
    T_TIPO_DATA('00202'),
    T_TIPO_DATA('00203'),
    T_TIPO_DATA('00204'),
    T_TIPO_DATA('00205'),
    T_TIPO_DATA('00206'),
    T_TIPO_DATA('00207'),
    T_TIPO_DATA('00208'),
    T_TIPO_DATA('00209'),
    T_TIPO_DATA('00210'),
    T_TIPO_DATA('00211'),
    T_TIPO_DATA('00212'),
    T_TIPO_DATA('00213'),
    T_TIPO_DATA('00214'),
    T_TIPO_DATA('00215'),
    T_TIPO_DATA('00216'),
    T_TIPO_DATA('00217'),
    T_TIPO_DATA('00218'),
    T_TIPO_DATA('00219'),
    T_TIPO_DATA('00220'),
    T_TIPO_DATA('00221'),
    T_TIPO_DATA('00222'),
    T_TIPO_DATA('00223'),
    T_TIPO_DATA('00224'),
    T_TIPO_DATA('00225'),
    T_TIPO_DATA('00226'),
    T_TIPO_DATA('00227'),
    T_TIPO_DATA('00228'),
    T_TIPO_DATA('00229'),
    T_TIPO_DATA('00230'),
    T_TIPO_DATA('00231'),
    T_TIPO_DATA('00232'),
    T_TIPO_DATA('00233'),
    T_TIPO_DATA('00234'),
    T_TIPO_DATA('00235'),
    T_TIPO_DATA('00236'),
    T_TIPO_DATA('00237'),
    T_TIPO_DATA('00238'),
    T_TIPO_DATA('00239'),
    T_TIPO_DATA('00240')

		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en DD_SCS_SEGMENTO_CRA_SCR 
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_SCS_SEGMENTO_CRA_SCR] ');
        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
          LOOP
          
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);

             -- Comprobamos si existe la tabla   
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
              EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

             IF V_NUM_TABLAS = 1 THEN 
        
            --Comprobamos el dato a insertar
               V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SCS_SEGMENTO_CRA_SCR AUX
                JOIN DD_TS_TIPO_SEGMENTO TS ON TS.DD_TS_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
                WHERE TS.DD_TS_ID = AUX.DD_TS_ID';
               EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
      
          --EXISTE
              IF V_NUM_TABLAS > 0 THEN			   
              
              DBMS_OUTPUT.PUT_LINE('[INFO]: EL SEGMENTO YA EXISTE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
              
          --NO EXISTE 
              ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
                V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'
                                      (
                                        DD_TS_ID
                                        , DD_CRA_ID
                                        , DD_SCR_ID
                                        , USUARIOCREAR
                                      )
                                      SELECT
                                          TS.DD_TS_ID
                                        , CRA.DD_CRA_ID
                                        , SCR.DD_SCR_ID
                                        ,  '''||V_USUARIO||''' USUARIOCREAR
                                      FROM '|| V_ESQUEMA ||'.DD_TS_TIPO_SEGMENTO TS
                                      LEFT JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON 1 = 1 AND CRA.BORRADO = 0
                                      LEFT JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = CRA.DD_CRA_ID AND SCR.BORRADO = 0
                                      WHERE CRA.DD_CRA_CODIGO = ''16''
                                      AND TS.BORRADO = 0 AND TS.DD_TS_CODIGO IN ('''||TRIM(V_TMP_TIPO_DATA(1))||''')';

                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
               END IF;
            END IF;
          END LOOP;
    COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_SCS_SEGMENTO_CRA_SCR MODIFICADO CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE(V_MSQL);

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
