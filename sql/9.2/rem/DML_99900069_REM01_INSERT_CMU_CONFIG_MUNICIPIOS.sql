--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20170206
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1421
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en CMU_CONFIG_MUNICIPIOS los datos añadidos en T_ARRAY_DATA
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
    V_NUM_ID NUMBER(16); -- Vble. para obtener el id de un registro.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                  -- MUNICIP_DESC   
        T_TIPO_DATA('Anglesola'),
		T_TIPO_DATA('Balaguer'),
		T_TIPO_DATA('Banyoles'),
		T_TIPO_DATA('Barberà del Vallès'),
		T_TIPO_DATA('Barcelona'),
		T_TIPO_DATA('Begues'),
		T_TIPO_DATA('Bellpuig'),
		T_TIPO_DATA('Bellver de Cerdanya'),
		T_TIPO_DATA('Berga'),
		T_TIPO_DATA('Besalú'),
		T_TIPO_DATA('Bisbal d''''Empordà'),
		T_TIPO_DATA('Blanes'),
		T_TIPO_DATA('Borges Blanques'),
		T_TIPO_DATA('Cabrera de Mar'),
		T_TIPO_DATA('Cabrils'),
		T_TIPO_DATA('Calaf'),
		T_TIPO_DATA('Calafell'),
		T_TIPO_DATA('Caldes de Montbui'),
		T_TIPO_DATA('Caldes d''''Estrac'),
		T_TIPO_DATA('Calella'),
		T_TIPO_DATA('Calldetenes'),
		T_TIPO_DATA('Calonge'),
		T_TIPO_DATA('Cambrils'),
		T_TIPO_DATA('Canet de Mar'),
		T_TIPO_DATA('Canonja'),
		T_TIPO_DATA('Canovelles'),
		T_TIPO_DATA('Cardedeu'),
		T_TIPO_DATA('Cardona'),
		T_TIPO_DATA('Castellar del Vallès'),
		T_TIPO_DATA('Castellbisbal'),
		T_TIPO_DATA('Castelldefels'),
		T_TIPO_DATA('Castelló d''''Empúries'),
		T_TIPO_DATA('Castell-Platja d''''Aro'),
		T_TIPO_DATA('Castellvell del Camp'),
		T_TIPO_DATA('Centelles'),
		T_TIPO_DATA('Cerdanyola del Vallès'),
		T_TIPO_DATA('Cervelló'),
		T_TIPO_DATA('Cervera'),
		T_TIPO_DATA('Constantí'),
		T_TIPO_DATA('Corbera de Llobregat'),
		T_TIPO_DATA('Cornellà de Llobregat'),
		T_TIPO_DATA('Cornellà del Terri'),
		T_TIPO_DATA('Cubelles'),
		T_TIPO_DATA('Cunit'),
		T_TIPO_DATA('Escala'),
		T_TIPO_DATA('Esparreguera'),
		T_TIPO_DATA('Esplugues de Llobregat'),
		T_TIPO_DATA('Falset'),
		T_TIPO_DATA('Figueres'),
		T_TIPO_DATA('Flix'),
		T_TIPO_DATA('Fondarella'),
		T_TIPO_DATA('Fornells de la Selva'),
		T_TIPO_DATA('Franqueses del Vallès'),
		T_TIPO_DATA('Gandesa'),
		T_TIPO_DATA('Garriga'),
		T_TIPO_DATA('Gavà'),
		T_TIPO_DATA('Gelida'),
		T_TIPO_DATA('Girona'),
		T_TIPO_DATA('Gironella'),
		T_TIPO_DATA('Golmés'),
		T_TIPO_DATA('Granollers'),
		T_TIPO_DATA('Guissona'),
		T_TIPO_DATA('Gurb'),
		T_TIPO_DATA('Hospitalet de Llobregat'),
		T_TIPO_DATA('Igualada'),
		T_TIPO_DATA('Llagosta'),
		T_TIPO_DATA('Llagostera'),
		T_TIPO_DATA('Llançà'),
		T_TIPO_DATA('Lleida'),
		T_TIPO_DATA('Lliçà d''''Amunt'),
		T_TIPO_DATA('Lliçà de Vall'),
		T_TIPO_DATA('Llinars del Vallès'),
		T_TIPO_DATA('Lloret de Mar'),
		T_TIPO_DATA('Malgrat de Mar'),
		T_TIPO_DATA('Manlleu'),
		T_TIPO_DATA('Manresa'),
		T_TIPO_DATA('Martorell'),
		T_TIPO_DATA('Martorelles'),
		T_TIPO_DATA('Masies de Voltregà'),
		T_TIPO_DATA('Masnou'),
		T_TIPO_DATA('Matadepera'),
		T_TIPO_DATA('Mataró'),
		T_TIPO_DATA('Miralcamp'),
		T_TIPO_DATA('Molins de Rei'),
		T_TIPO_DATA('Mollerussa'),
		T_TIPO_DATA('Mollet del Vallès'),
		T_TIPO_DATA('Montblanc'),
		T_TIPO_DATA('Montcada i Reixac'),
		T_TIPO_DATA('Montgat'),
		T_TIPO_DATA('Montmeló'),
		T_TIPO_DATA('Montornès del Vallès'),
		T_TIPO_DATA('Mont-ras'),
		T_TIPO_DATA('Mont-roig del Camp'),
		T_TIPO_DATA('Móra d''''Ebre'),
		T_TIPO_DATA('Móra la Nova'),
		T_TIPO_DATA('Navàs'),
		T_TIPO_DATA('Òdena'),
		T_TIPO_DATA('Olesa de Montserrat'),
		T_TIPO_DATA('Olot'),
		T_TIPO_DATA('Palafolls'),
		T_TIPO_DATA('Palafrugell'),
		T_TIPO_DATA('Palamós'),
		T_TIPO_DATA('Palau d''''Anglesola'),
		T_TIPO_DATA('Palau-solità i Plegamans'),
		T_TIPO_DATA('Pallaresos'),
		T_TIPO_DATA('Pallejà'),
		T_TIPO_DATA('Palma de Cervelló'),
		T_TIPO_DATA('Papiol'),
		T_TIPO_DATA('Parets del Vallès'),
		T_TIPO_DATA('Perelló'),
		T_TIPO_DATA('Piera'),
		T_TIPO_DATA('Pineda de Mar'),
		T_TIPO_DATA('Pobla de Segur'),
		T_TIPO_DATA('Polinyà'),
		T_TIPO_DATA('Pont de Suert'),
		T_TIPO_DATA('Ponts'),
		T_TIPO_DATA('Porqueres'),
		T_TIPO_DATA('Prat de Llobregat'),
		T_TIPO_DATA('Premià de Dalt'),
		T_TIPO_DATA('Premià de Mar'),
		T_TIPO_DATA('Puigcerdà'),
		T_TIPO_DATA('Reus'),
		T_TIPO_DATA('Ripoll'),
		T_TIPO_DATA('Ripollet'),
		T_TIPO_DATA('Roca del Vallès'),
		T_TIPO_DATA('Roda de Barà'),
		T_TIPO_DATA('Roquetes'),
		T_TIPO_DATA('Roses'),
		T_TIPO_DATA('Rubí'),
		T_TIPO_DATA('Sabadell'),
		T_TIPO_DATA('Sallent'),
		T_TIPO_DATA('Salou'),
		T_TIPO_DATA('Salt'),
		T_TIPO_DATA('Sant Adrià de Besòs'),
		T_TIPO_DATA('Sant Andreu de la Barca'),
		T_TIPO_DATA('Sant Andreu de Llavaneres'),
		T_TIPO_DATA('Sant Boi de Llobregat'),
		T_TIPO_DATA('Sant Carles de la Ràpita'),
		T_TIPO_DATA('Sant Celoni'),
		T_TIPO_DATA('Sant Climent de Llobregat'),
		T_TIPO_DATA('Sant Cugat del Vallès'),
		T_TIPO_DATA('Sant Esteve Sesrovires'),
		T_TIPO_DATA('Sant Feliu de Guíxols'),
		T_TIPO_DATA('Sant Feliu de Llobregat'),
		T_TIPO_DATA('Sant Fost de Campsentelles'),
		T_TIPO_DATA('Sant Fruitós de Bages'),
		T_TIPO_DATA('Sant Gregori'),
		T_TIPO_DATA('Sant Joan de les Abadesses'),
		T_TIPO_DATA('Sant Joan de Vilatorrada'),
		T_TIPO_DATA('Sant Joan Despí'),
		T_TIPO_DATA('Sant Joan les Fonts'),
		T_TIPO_DATA('Sant Julià de Ramis'),
		T_TIPO_DATA('Sant Just Desvern'),
		T_TIPO_DATA('Sant Pere de Ribes'),
		T_TIPO_DATA('Sant Pol de Mar'),
		T_TIPO_DATA('Sant Quirze del Vallès'),
		T_TIPO_DATA('Sant Sadurní d''''Anoia'),
		T_TIPO_DATA('Sant Vicenç de Castellet'),
		T_TIPO_DATA('Sant Vicenç de Montalt'),
		T_TIPO_DATA('Sant Vicenç dels Horts'),
		T_TIPO_DATA('Santa Bàrbara'),
		T_TIPO_DATA('Santa Coloma de Cervelló'),
		T_TIPO_DATA('Santa Coloma de Farners'),
		T_TIPO_DATA('Santa Coloma de Gramenet'),
		T_TIPO_DATA('Santa Coloma de Queralt'),
		T_TIPO_DATA('Santa Cristina d''''Aro'),
		T_TIPO_DATA('Santa Eugènia de Berga'),
		T_TIPO_DATA('Santa Llogaia d''''Àlguema'),
		T_TIPO_DATA('Santa Margarida de Montbui'),
		T_TIPO_DATA('Santa Margarida i els Monjos'),
		T_TIPO_DATA('Santa Perpètua de Mogoda'),
		T_TIPO_DATA('Santa Susanna'),
		T_TIPO_DATA('Sarrià de Ter'),
		T_TIPO_DATA('Selva del Camp'),
		T_TIPO_DATA('Sénia'),
		T_TIPO_DATA('Sentmenat'),
		T_TIPO_DATA('Seu d''''Urgell'),
		T_TIPO_DATA('Sitges'),
		T_TIPO_DATA('Solsona'),
		T_TIPO_DATA('Sort'),
		T_TIPO_DATA('Súria'),
		T_TIPO_DATA('Tarragona'),
		T_TIPO_DATA('Tàrrega'),
		T_TIPO_DATA('Teià'),
		T_TIPO_DATA('Terrassa'),
		T_TIPO_DATA('Tiana'),
		T_TIPO_DATA('Tona'),
		T_TIPO_DATA('Tordera'),
		T_TIPO_DATA('Torelló'),
		T_TIPO_DATA('Torredembarra'),
		T_TIPO_DATA('Torrelles de Llobregat'),
		T_TIPO_DATA('Torroella de Montgrí'),
		T_TIPO_DATA('Tortosa'),
		T_TIPO_DATA('Tossa de Mar'),
		T_TIPO_DATA('Tremp'),
		T_TIPO_DATA('Ulldecona'),
		T_TIPO_DATA('Vallirana'),
		T_TIPO_DATA('Valls'),
		T_TIPO_DATA('Vendrell'),
		T_TIPO_DATA('Vic'),
		T_TIPO_DATA('Vielha e Mijaran'),
		T_TIPO_DATA('Vilablareix'),
		T_TIPO_DATA('Viladecans'),
		T_TIPO_DATA('Viladecavalls'),
		T_TIPO_DATA('Vilafant'),
		T_TIPO_DATA('Vilafranca del Penedès'),
		T_TIPO_DATA('Vilagrassa'),
		T_TIPO_DATA('Vilamalla'),
		T_TIPO_DATA('Vilanova del Camí'),
		T_TIPO_DATA('Vilanova i la Geltrú'),
		T_TIPO_DATA('Vila-seca'),
		T_TIPO_DATA('Vilassar de Dalt'),
		T_TIPO_DATA('Vilassar de Mar'),
		T_TIPO_DATA('Abrera'),
		T_TIPO_DATA('Agramunt'),
		T_TIPO_DATA('Alcanar'),
		T_TIPO_DATA('Alcarràs'),
		T_TIPO_DATA('Alcoletge'),
		T_TIPO_DATA('Aldea'),
		T_TIPO_DATA('Alella'),
		T_TIPO_DATA('Alguaire'),
		T_TIPO_DATA('Almacelles'),
		T_TIPO_DATA('Almenar'),
		T_TIPO_DATA('Almoster'),
		T_TIPO_DATA('Altafulla'),
		T_TIPO_DATA('Amposta'),
		T_TIPO_DATA('Arboç'),
		T_TIPO_DATA('Arenys de Mar'),
		T_TIPO_DATA('Arenys de Munt'),
		T_TIPO_DATA('Argentona'),
		T_TIPO_DATA('Artesa de Segre'),
		T_TIPO_DATA('Avià'),
		T_TIPO_DATA('Badalona'),
		T_TIPO_DATA('Badia del Vallès')


    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en CMU_CONFIG_MUNICIPIOS -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CMU_CONFIG_MUNICIPIOS ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(LOC.DD_LOC_ID) FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON LOC.DD_PRV_ID=PRV.DD_PRV_ID '|| 
        			' WHERE UPPER(LOC.DD_LOC_DESCRIPCION) LIKE UPPER('''||V_TMP_TIPO_DATA(1)||'%'') AND PRV.DD_PRV_CODIGO IN (''8'', ''43'',''25'',''17'') ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 1 THEN
        	V_SQL := 'SELECT LOC.DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON LOC.DD_PRV_ID=PRV.DD_PRV_ID '|| 
        			' WHERE UPPER(LOC.DD_LOC_DESCRIPCION) LIKE UPPER('''||V_TMP_TIPO_DATA(1)||''') AND PRV.DD_PRV_CODIGO IN (''8'', ''43'',''25'',''17'') ';
      		EXECUTE IMMEDIATE V_SQL INTO V_NUM_ID;
        ELSIF V_NUM_TABLAS = 1 THEN
	        V_SQL := 'SELECT LOC.DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON LOC.DD_PRV_ID=PRV.DD_PRV_ID '|| 
	        			' WHERE UPPER(LOC.DD_LOC_DESCRIPCION) LIKE UPPER('''||V_TMP_TIPO_DATA(1)||'%'') AND PRV.DD_PRV_CODIGO IN (''8'', ''43'',''25'',''17'') ';
	        EXECUTE IMMEDIATE V_SQL INTO V_NUM_ID;
	    END IF;
        
        --Si existe lo insertamos en la tabla CMU
        IF V_NUM_TABLAS > 0 THEN
        
        	 V_SQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.CMU_CONFIG_MUNICIPIOS WHERE DD_LOC_ID = '||V_NUM_ID ||'';
        	 EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        	 
        	 IF V_NUM_TABLAS = 0 THEN
          
		          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL MUNICIPIO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
		       	  V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_CMU_CONFIG_MUNICIPIOS.NEXTVAL FROM DUAL';
		          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
		          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CMU_CONFIG_MUNICIPIOS (' ||
		                      'CMU_ID, DD_LOC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
		                      'SELECT '|| V_ID ||' '||
		                      ', '||V_NUM_ID ||' '||
		                      ', 0, ''DML_F2'',SYSDATE,0 FROM DUAL';
		          EXECUTE IMMEDIATE V_MSQL;
		          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
		     ELSE
		     	DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE LA PROVINCIA CON ID: '||V_NUM_ID);
		     END IF;
          
       --Si no existe, no lo insertamos, y lo mostramos en el log
       ELSE
       
          DBMS_OUTPUT.PUT_LINE(' -------[INFO]: NO HAY CORRESPONDENCIA CON: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ----------');   
         
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA CMU_CONFIG_MUNICIPIOS ACTUALIZADO CORRECTAMENTE ');
   

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



   
