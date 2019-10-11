--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20191010
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7835
--## PRODUCTO=NO
--## FINALIDAD: Script que añade en DD_SPG_SOCIEDAD_PAGO_ANTERIOR los datos añadidos en T_ARRAY_DATA.
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de un registro.
    V_NUM_REGISTROS NUMBER(16); -- Vble. para validar la existencia de un registro.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SPG_SOCIEDAD_PAGO_ANTERIOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'SPG'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_USUARIO_CREAR VARCHAR2(20 CHAR) := 'HREOS-7835'; -- Vble. auxiliar para almacenar el usuario crear
    V_USUARIO_MODIFICAR VARCHAR2(20 CHAR) := 'HREOS-7835'; -- Vble. auxiliar para almacenar el usuario modificar

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --T_TIPO_DATA('DD_SRA_CODIGO',		'DD_SRA_DESCRIPCION',		'DD_SRA_DESCRIPCION_LARGA')
      T_TIPO_DATA('001','ACTIVOS MACORP, S.L.'),
      T_TIPO_DATA('002','ANIDA GRUPO INMOBILIARIO, S.L.'),
      T_TIPO_DATA('003','ANIDA OPERACIONES SINGULARES, SAU'),
      T_TIPO_DATA('004','ARRAHONA AMBIT SLU'),
      T_TIPO_DATA('005','ARRAHONA IMMO SLU'),
      T_TIPO_DATA('006','ARRAHONA NEXUS SLU'),
      T_TIPO_DATA('007','ARRELS CT FINSOL SAU'),
      T_TIPO_DATA('008','ARRELS CT PATRIMONI I PROJECTES SAU'),
      T_TIPO_DATA('009','AXIACOM CR-1 SL'),
      T_TIPO_DATA('010','AYT HIPOTECARIO MIXTO IV, FTA'),
      T_TIPO_DATA('011','AYT HIPOTECARIO MIXTO V, FTA'),
      T_TIPO_DATA('012','AyT HIPOTECARIO MIXTO, FTA'),
      T_TIPO_DATA('013','BBVA 6 FTPYME FDO.TIT.ACTIVOS'),
      T_TIPO_DATA('014','BBVA ADJUDICADOS'),
      T_TIPO_DATA('015','BBVA AUTOS 2 FDO. TIT. ACTIVOS'),
      T_TIPO_DATA('016','BBVA AUTOS 2 Fondo de Tit. de Activos'),
      T_TIPO_DATA('017','BBVA CONSUMO 1 Fondo de Tit. de Activos'),
      T_TIPO_DATA('018','BBVA CONSUMO 2 Fondo de Tit. de Activos'),
      T_TIPO_DATA('019','BBVA CONSUMO 3 Fondo de Tit. de Activos'),
      T_TIPO_DATA('020','BBVA CONSUMO 4 Fondo de Tit. de Activos'),
      T_TIPO_DATA('021','BBVA EMPRESAS 1 Fondo de Tit. de Activos'),
      T_TIPO_DATA('022','BBVA EMPRESAS 2 Fondo de Tit. de Activos'),
      T_TIPO_DATA('023','BBVA EMPRESAS 3 Fondo de Titulización de Activos'),
      T_TIPO_DATA('024','BBVA EMPRESAS 3 FTA'),
      T_TIPO_DATA('025','BBVA EMPRESAS 4 FTA'),
      T_TIPO_DATA('026','BBVA EMPRESAS 5 Fondo de Tit. de Activos'),
      T_TIPO_DATA('027','BBVA EMPRESAS 6 Fondo de Tit. de Activos'),
      T_TIPO_DATA('028','BBVA HIPOTECARIO 3 Fondo de Tit. de Act.'),
      T_TIPO_DATA('029','BBVA LEASING 1 Fondo de Tit. de Activos'),
      T_TIPO_DATA('030','BBVA RMBS 1 Fondo de Tit. de Activos'),
      T_TIPO_DATA('031','BBVA RMBS 10 Fondo de Tit. de Activos'),
      T_TIPO_DATA('032','BBVA RMBS 11FTA'),
      T_TIPO_DATA('033','BBVA RMBS 12 FONDO DE TITULIZACION DE ACTIVOS'),
      T_TIPO_DATA('034','BBVA RMBS 13 FONDO DE TITULIZACION DE ACTIVOS'),
      T_TIPO_DATA('035','BBVA RMBS 2 Fondo de Tit. de Activos'),
      T_TIPO_DATA('036','BBVA RMBS 3 Fondo de Tit. de Activos'),
      T_TIPO_DATA('037','BBVA RMBS 4 Fondo de Tit. de Activos'),
      T_TIPO_DATA('038','BBVA RMBS 5 Fondo de Tit. de Activos'),
      T_TIPO_DATA('039','BBVA RMBS 7 Fondo de Tit. de Activos'),
      T_TIPO_DATA('040','BBVA RMBS 9 Fondo de Tit. de Activos'),
      T_TIPO_DATA('041','BBVA-3 FTPYME Fondo de Tit. de Act.'),
      T_TIPO_DATA('042','BBVA-4 PYME Fondo de Tit. de Activos'),
      T_TIPO_DATA('043','BBVA-5 FTPYME Fondo de Tit. de Activos'),
      T_TIPO_DATA('044','BBVA-6 FTPYME Fondo de Tit. de Activos'),
      T_TIPO_DATA('045','BBVA-7 FTGENCAT Fondo de Tit. de Activos'),
      T_TIPO_DATA('046','BBVA-8 FTPYME Fondo de Tit. de Activos'),
      T_TIPO_DATA('047','BBVA-9 PYME Fondo de Titulización de Activos'),
      T_TIPO_DATA('048','CAIXA MANRESA ONCASA INMOBILIARIA S.L.'),
      T_TIPO_DATA('049','CAMARATE GOLF, S.A.'),
      T_TIPO_DATA('050','CATALONIA PROMODIS 4 SAU'),
      T_TIPO_DATA('051','CATALUNYACAIXA IMMOBILIARIA SAU'),
      T_TIPO_DATA('052','DIVARIAN DESARROLLOS INMOBILIARIOS, S.L.U.'),
      T_TIPO_DATA('053','DIVARIAN PROPIEDAD, S.A.U'),
      T_TIPO_DATA('054','ECOARENYS S.L.'),
      T_TIPO_DATA('055','ESPAIS SABADELL PROMOC.IMMOBILIARIES SAU'),
      T_TIPO_DATA('056','FUNDACIÓ HABITATGE LLOGUER'),
      T_TIPO_DATA('057','GARRAF MEDITERRANEA'),
      T_TIPO_DATA('058','GAT FTGENCAT 2006 FTA'),
      T_TIPO_DATA('059','GAT FTGENCAT 2007'),
      T_TIPO_DATA('060','GAT FTGENCAT 2008 FTA'),
      T_TIPO_DATA('061','GAT FTGENCAT 2009 FTA'),
      T_TIPO_DATA('062','GAT ICO FTVPO, FTH'),
      T_TIPO_DATA('063','GESCAT GESTIÓ DE SÒL, S.L.'),
      T_TIPO_DATA('064','GESCAT LLOGUERS, S.L.'),
      T_TIPO_DATA('065','GESCAT VIVENDES EN COMERCIALITZACIÓ, S.L'),
      T_TIPO_DATA('066','HABITATGES FINVER SL'),
      T_TIPO_DATA('067','HABITATGES JUVIPRO, S.L.'),
      T_TIPO_DATA('068','HIPOCAT 10 FTA'),
      T_TIPO_DATA('069','HIPOCAT 11 FTA'),
      T_TIPO_DATA('070','HIPOCAT 17 FTA'),
      T_TIPO_DATA('071','HIPOCAT 19 FTA'),
      T_TIPO_DATA('072','HIPOCAT 20 FTA'),
      T_TIPO_DATA('073','HIPOCAT 6 FTA'),
      T_TIPO_DATA('074','HIPOCAT 7 FTA'),
      T_TIPO_DATA('075','HIPOCAT 8 FTA'),
      T_TIPO_DATA('076','HIPOCAT 9 FTA'),
      T_TIPO_DATA('077','INVERPRO DESENVOLUPAMENT SLU'),
      T_TIPO_DATA('078','IRIDION SOLUCIONS IMMOBILIÀRIES, S.L.'),
      T_TIPO_DATA('079','JALE PROCAM SL'),
      T_TIPO_DATA('080','MBSCAT 1 FTA'),
      T_TIPO_DATA('081','MBSCAT 2 FTA'),
      T_TIPO_DATA('082','NOIDIRI, S.L.'),
      T_TIPO_DATA('083','PARCSUD PLANNER SLU'),
      T_TIPO_DATA('084','PORTICO PROCAM SL'),
      T_TIPO_DATA('085','PORTUGAL ANIDA'),
      T_TIPO_DATA('086','PORTUGAL BBVA SA'),
      T_TIPO_DATA('087','PROMOCIONES MIES DEL VALLE, SL'),
      T_TIPO_DATA('088','PROMOCIONS CAN CATA SL'),
      T_TIPO_DATA('089','PROMOTORA DEL VALLES SLU'),
      T_TIPO_DATA('090','PROMOU CT EIX MACIÀ SLU'),
      T_TIPO_DATA('091','PROMOU CT GEBIRA S.L.U.'),
      T_TIPO_DATA('092','PROMOU CT OPEN SEGRE SLU'),
      T_TIPO_DATA('093','PROMOU CT VALLES SLU'),
      T_TIPO_DATA('094','PROMOU GLOBAL SLU'),
      T_TIPO_DATA('095','PROV-INFI-ARRAHONA SLU'),
      T_TIPO_DATA('096','PROVIURE CZF PARC D`HABITATGES,S.L.'),
      T_TIPO_DATA('097','PYMECAT 3 FTPYME FTA'),
      T_TIPO_DATA('098','RE. DEAL II'),
      T_TIPO_DATA('099','SATICEM GESTIO S.L.U.'),
      T_TIPO_DATA('100','SATICEM HOLDING S.L.'),
      T_TIPO_DATA('101','SATICEM IMMOBLES EN ARRENDAMENT S.L.'),
      T_TIPO_DATA('102','TDA 27, FTA'),
      T_TIPO_DATA('103','TDA 28, FTA'),
      T_TIPO_DATA('104','UNNIM SDAD PARA LA GESTION DE ACTIVOS SA')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_'||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTROS;

        IF V_NUM_REGISTROS > 0 THEN		
          -- Si existe se modifica.
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    'SET DD_'||V_TEXT_CHARS||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
          ', DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
          ', USUARIOMODIFICAR = '''|| V_USUARIO_MODIFICAR ||''' , FECHAMODIFICAR = SYSDATE '||
          ' WHERE DD_'||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

        ELSE		
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');          
          
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'DD_'||V_TEXT_CHARS||'_CODIGO, DD_'||V_TEXT_CHARS||'_DESCRIPCION, DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''','''|| TRIM(V_TMP_TIPO_DATA(2)) ||''', 0, '''|| V_USUARIO_CREAR ||''',SYSDATE, 0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');


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
