--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200929
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11197
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TS_TIPO_SEGMENTO los datos añadidos en T_ARRAY_DATA
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
    V_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_TS_TIPO_SEGMENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'TS'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'HREOS-11197';
    V_ID_TIPO_SEGMENTO NUMBER(16); --Vble para extraer el ID del registro a modificar, si procede.

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('00200','Nuevas entradas desde 01/10/2018'),
      T_TIPO_DATA('00201','Nuevas entradas desde 01/10/2018 (Pachowiak)'),
      T_TIPO_DATA('00202','Recompras de Titulizados'),
      T_TIPO_DATA('00203','SLA - Anexo Titulizados (EdT) (Inmuebles gestionados por EdT)'),
      T_TIPO_DATA('00204','SLA - Anexo Titulizados (EdT) (Inmuebles gestionados por EdT) (Pachowiak)'),
      T_TIPO_DATA('00205','SLA - Initial REOs Schedule 4.1.1 (i) (Inmuebles NO 118 con fecha de alta < 26/06/17) (Pachowiak)'),
      T_TIPO_DATA('00206','SLA - Initial REOs Schedule 4.1.1 (i)(b) (Inmuebles NO 118 con fecha de alta > 26/06/17 Y < 11/10/18) (Pachowiak)'),
      T_TIPO_DATA('00207','SLA - Initial REOs Schedule 4.1.1 (i) (Inmuebles NO 118 con fecha de alta < 26/06/17)'),
      T_TIPO_DATA('00208','SLA - Initial REOs Schedule 4.1.1 (i) (Inmuebles NO 118 con fecha de alta < 26/06/17) - nuevos'),
      T_TIPO_DATA('00209','SLA - Initial REOs Schedule 4.1.1 (i)(b) (Inmuebles NO 118 con fecha de alta > 26/06/17 Y < 11/10/18)'),
      T_TIPO_DATA('00210','SLA - Initial REOs Schedule 4.1.1 (i)(b) (Inmuebles NO 118 con fecha de alta > 26/06/17 Y < 11/10/18) – nuevos'),
      T_TIPO_DATA('00211','SLA (118) - Initial REOs Schedule 4.1.1 (i) (Inmuebles 118 No EPA o autorizados EPA sin arras)'),
      T_TIPO_DATA('00212','SLA (118) - Initial REOs Schedule 4.1.1 (i) (Inmuebles 118 No EPA o autorizados EPA sin arras) - nuevos'),
      T_TIPO_DATA('00213','SLA (118) - Restricted Assets Schedule 3.1.3 (sin Arras) (Inmuebles 118 EPA sin arras)'),
      T_TIPO_DATA('00214','SLA - ex118 (inmuebles que anteriormente fueron 118)'),
      T_TIPO_DATA('00215','Nuevas entradas desde 01/10/2018 (Ánfora)'),
      T_TIPO_DATA('00216','Nuevas entradas desde 01/10/2018 (Ánfora) con condición suspensiva_inscribir, cancelar cargas y obtener renuncia tanteo / autorización VPO'),
      T_TIPO_DATA('00217','Nuevas entradas desde 01/10/2018 (Ánfora) transmitidos_inscribir y cancelar cargas'),
      T_TIPO_DATA('00218','Nuevas entradas desde 01/10/2018 (Ánfora) subsiguientes _ sólo inscribir si hay trámite en curso'),
      T_TIPO_DATA('00219','Nuevas entradas desde 01/10/2018 (Hércules)'),
      T_TIPO_DATA('00220','SLA - Initial REOs Schedule 4.1.1 (i) (Inmuebles NO 118 con fecha de alta < 26/06/17) - nuevos (Hércules)'),
      T_TIPO_DATA('00221','Nuevas entradas desde 01/10/2018 (Sintra)'),
      T_TIPO_DATA('00222','SLA - Initial REOs Schedule 4.1.1 (i)(b) (Inmuebles NO 118 con fecha de alta > 26/06/17 Y < 11/10/18) (Sintra)'),
      T_TIPO_DATA('00223','SLA - ex118 (inmuebles que anteriormente fueron 118) (Sintra)'),
      T_TIPO_DATA('00224','SLA - Initial REOs Schedule 4.1.1 (i)(b) (Inmuebles NO 118 con fecha de alta > 26/06/17 Y < 11/10/18) (Jaipur)'),
      T_TIPO_DATA('00225','SLA - Initial REOs Schedule 4.1.1 (i) (Inmuebles NO 118 con fecha de alta < 26/06/17) (Jaipur)'),
      T_TIPO_DATA('00226','SLA - ex118 (inmuebles que anteriormente fueron 118) (Jaipur)'),
      T_TIPO_DATA('00227','SLA - Initial REOs Schedule 4.1.1 (i) (Inmuebles NO 118 con fecha de alta < 26/06/17) (SAREB)'),
      T_TIPO_DATA('00228','SLA - Other REOs Schedule 4.3 (ii) (Inmuebles NO 118 con compromiso comercial previo) (Hércules)'),
      T_TIPO_DATA('00229','SLA - Other REOs Schedule 4.3 (ii) (Inmuebles NO 118 con compromiso comercial previo) (Sintra)'),
      T_TIPO_DATA('00230','SLA - Other REOs Schedule 4.3 (ii) (Inmuebles NO 118 con compromiso comercial previo) (Sareb)'),
      T_TIPO_DATA('00231','SLA - Other REOs Schedule 4.3 (ii) (Inmuebles NO 118 con compromiso comercial previo)'),
      T_TIPO_DATA('00232','SLA (118) - IniREO_Schedule 4.1.1 (i)(a) (Inmuebles 118 No EPA o autorizados EPA con arras)'),
      T_TIPO_DATA('00233','SLA (118) - Restricted Assets Schedule 3.1.3 (con Arras) (Inmuebles 118 EPA con arras)'),
      T_TIPO_DATA('00234','SLA - Participadas Adscritas'),
      T_TIPO_DATA('00235','Baja contable no registrada aún'),
      T_TIPO_DATA('00236','No SLA: incorporar al contrato????'),
      T_TIPO_DATA('00237','Baja Contable posterior a 1/10/2018')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_TS_TIPO_SEGMENTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TS_TIPO_SEGMENTO ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        -- Comprobamos si existe la tabla   
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN 
        
          --Comprobamos el dato a insertar
          V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

          --Si existe modificamos los valores
          IF V_NUM_TABLAS > 0 THEN
          
            V_MSQL := 'SELECT DD_TS_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID_TIPO_SEGMENTO;

            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
            'SET DD_TS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''''||
            ', DD_'||V_TEXT_CHARS||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
            ', DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
            ', USUARIOMODIFICAR = '''||V_INCIDENCIA||''' , FECHAMODIFICAR = SYSDATE '||
            'WHERE DD_'||V_TEXT_CHARS||'_ID = '''||V_ID_TIPO_SEGMENTO||'''';
            EXECUTE IMMEDIATE V_MSQL;
            --Si no existe insertamos los registros
          ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');             
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (DD_TS_CODIGO, DD_TS_DESCRIPCION, DD_TS_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
            VALUES ('''||TRIM(V_TMP_TIPO_DATA(1))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''', 0, '''||V_INCIDENCIA||''', SYSDATE, 0)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADO CORRECTAMENTE');
          
          END IF;
        ELSE
          DBMS_OUTPUT.PUT_LINE('LA TABLA DD_TS_TIPO_SEGMENTO NO EXISTE');
        END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TS_TIPO_SEGMENTO MODIFICADO CORRECTAMENTE ');
   

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
