--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211230
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10988
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en BLK_CONFIG_IMPORTE los datos añadidos en T_ARRAY_DATA
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
    V_NUM_TABLAS_CONFIG VARCHAR2(2400 CHAR);
    V_NUM_TABLAS_RELACION VARCHAR2(2400 CHAR);
    V_NUM_ID VARCHAR2(2400 CHAR);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'BLK_CONFIG_IMPORTE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_RELACION VARCHAR2(2400 CHAR) := 'DD_TBK_TIPO_BULK_AN'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'TBK'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'REMVIP-10988';
    V_ID_RELACION NUMBER(16); --Vble para extraer el ID del registro a modificar, si procede.
    V_ALL_TABLES VARCHAR2(2400 CHAR) := 'ALL_TABLES';


    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('JRD', 750000),
        T_TIPO_DATA('JRC', 750000)
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en BLK_CONFIG_IMPORTE -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN BLK_CONFIG_IMPORTE ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        -- COMPROBAMOS QUE EXISTE LA TABLA BLK_CONFIG_IMPORTE
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ALL_TABLES||' WHERE TABLE_NAME = '''||V_TEXT_TABLA||'''';
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS_CONFIG;

        IF V_NUM_TABLAS_CONFIG > 0 THEN
         DBMS_OUTPUT.PUT_LINE('[INFO]: EXISTE LA TABLA CONFIG');
          
            -- COMPROBAMOS QUE EXISTE LA TABLA DD_TBK
          V_MSQL := 'SELECT COUNT(1) FROM '||V_ALL_TABLES||' WHERE TABLE_NAME = '''||V_TEXT_TABLA_RELACION||'''';
          EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS_RELACION;
  
            IF V_NUM_TABLAS_RELACION > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO]: EXISTE LA TABLA DD_TBK');
                --Comprobamos que existe el dato a insertar
                V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_RELACION||' WHERE DD_TBK_CODIGO ='''||TRIM(V_TMP_TIPO_DATA(1))||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

                --Si existe en blk_config modificamos los valores
                IF V_NUM_TABLAS > 0 THEN

                    V_MSQL := 'SELECT DD_TBK_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_RELACION||' WHERE DD_TBK_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
                    EXECUTE IMMEDIATE V_MSQL INTO V_ID_RELACION;

                    V_MSQL := 'SELECT COUNT(BLK.DD_TBK_ID) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' BLK WHERE BLK.DD_TBK_ID = '''||V_ID_RELACION||'''' ;
                    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_ID;

                    --Si existe en blk_config modificamos los registros
                    IF V_NUM_ID > 0 THEN                       
                        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                        'SET BLK_IMPORTE_MAXIMO = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
                        ', USUARIOMODIFICAR = '''||V_INCIDENCIA||''' , FECHAMODIFICAR = SYSDATE '||
                        'WHERE DD_'||V_TEXT_CHARS||'_ID = '''||V_ID_RELACION||'''';
                        EXECUTE IMMEDIATE V_MSQL;                    
                    
                    --Si no existe en blk_config insertamos los registros
                    ELSE
                        DBMS_OUTPUT.PUT_LINE('[INFO]: EL DATO A INSERTAR NO EXISTE');
                        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');           
                        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                            BLK_IMPORTE_MAXIMO, DD_TBK_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
                            VALUES ('||TRIM(V_TMP_TIPO_DATA(2))||','''||V_ID_RELACION||''',
                            0, '''||V_INCIDENCIA||''', SYSDATE, 0)';
                        EXECUTE IMMEDIATE V_MSQL;
                        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADO CORRECTAMENTE');
                    END IF;

                ELSE
                        DBMS_OUTPUT.PUT_LINE('[INFO]: EL DATO EN EL DD NO EXISTE');            
                END IF;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO]: LA TABLA DD NO EXISTE');
            END IF;
        ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO]: LA TABLA BLK_CONF NO EXISTE');
        END IF;

    COMMIT;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA BLK_CONFIG_IMPORTE MODIFICADO CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
