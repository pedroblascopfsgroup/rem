--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20160322
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_PVE_PROVEEDOR los datos añadidos en T_ARRAY_DATA
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
    V_ID NUMBER(16);
    V_ID_ETP NUMBER(16);
    V_ID_ACT NUMBER(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('Activa Externalización de servicios','B87105821','655885482','','mpromero@activaes.es','','Homologado','SAREB'),
		T_TIPO_DATA('Actúa Gestión de Activos','B98562036','609651135','','jlmelchor@actua-ga.es','','Homologado','SAREB'),
		T_TIPO_DATA('Alberta Norweg','B98306012','963043003','','eduardo.simo@albertanorweg.com','','Homologado','SAREB'),
		T_TIPO_DATA('Algescón Levante','B96565981','963372677','','algescon@algescon.com','','Homologado','SAREB'),
		T_TIPO_DATA('Arboreda, Jardinería y paisajismo','E98442098','610614167','','arboredapaisajes2012@yahoo.es','','Homologado','SAREB'),
		T_TIPO_DATA('Arcoin','U76068279','669770527','928856154','jpol@arcoin.es','','Homologado','SAREB'),
		T_TIPO_DATA('Arquiurbi','B97387088','650435657','','04044@ctav.es','','Homologado','SAREB'),
		T_TIPO_DATA('Avanza Urbana Siglo XXI','B98327943','619154309','','slopez@avanzaurbana.com','','Homologado','SAREB'),
		T_TIPO_DATA('Basilio Rodríguez Barbero','7804975V','','','basilio@basilio.e.telefonica.net','','Homologado','SAREB'),
		T_TIPO_DATA('Brick o´Clock','B85343721','916658902','','pperez@brickoclock.es','','Homologado','SAREB'),
		T_TIPO_DATA('Cartera de Activos Inmobiliarios','B85752905','91 770 49 64','669 48 86 20','jpizarro@cdaisl.com','','Homologado','SAREB'),
		T_TIPO_DATA('CGTécnica: Coordinación y gestión Técnica de Obras y Proyectos','B97518138','963551265','','cgtecnica@cgtecnica.com','','Homologado','SAREB'),
		T_TIPO_DATA('Chirivo Construcciones','B92418524','902170173','','administracion@chirivo.com','','Homologado','SAREB'),
		T_TIPO_DATA('DSC: Desarrollo Sub Construcción','B72265986','622325361','','dsconstruccionsl@gmail.com','','Homologado','SAREB'),
		T_TIPO_DATA('Eptisa Servicios de Ingeniería','B85097962','98125900','619412326','jmoro@eptisa.com','','Homologado','SAREB'),
		T_TIPO_DATA('Ferrovial Servicios','A80241789','91 586 29 72','639 77 54 98','hmartinezcampos.ferroser@ferrovial.com','','Homologado','SAREB'),
		T_TIPO_DATA('García Campá y Llidó','B98020001','639785697','928610585','losdragos32@gmail.com','','Homologado','SAREB'),
		T_TIPO_DATA('Gesalia','B95299947','650945505','','nprado@gesalia.com','','Homologado','SAREB'),
		T_TIPO_DATA('Gestimed Levante','B03830510','902333338','','bankia@gestimedlevante.es','','Homologado','SAREB'),
		T_TIPO_DATA('Gesvalt Sociedad de Tasación','A80884372','963375557','','gesvalt@gesvalt.es','','Homologado','SAREB'),
		T_TIPO_DATA('Grupo Control Empresa de Seguridad','A04038014','950262222','','lbermejo@grupocontrol.com','','Homologado','SAREB'),
		T_TIPO_DATA('Habilitas Facility Management','B90107731','625525455','','joseluisalemanylopez@gmail.com','','Homologado','SAREB'),
		T_TIPO_DATA('Ilunion Outsourcing (V2 Servicios Auxiliares)','B82053463','914538200','','fdiez@ilunion.com','','Homologado','SAREB'),
		T_TIPO_DATA('Integraval Hortus','B98493190','670417103','961274323','luis@integraval.es','','Homologado','SAREB'),
		T_TIPO_DATA('Invertol, Promoción e Inversión Inmobiliaria','B84105899','917990752 ','','control@invertol.com','','Homologado','SAREB'),
		T_TIPO_DATA('Legazpi Servicios Generales','B85884336','916913413','','legazpi@infonegocio.com','','Homologado','SAREB'),
		T_TIPO_DATA('Leyser Proyectos y Construcción','A84259027','916397452','','leyser@leyser.es','','Homologado','SAREB'),
		T_TIPO_DATA('Lissar Técnicos','B91703777','954716348','608131629','rodrigosanchez@lissartecnicos.com','','Homologado','SAREB'),
		T_TIPO_DATA('M&C Services 2012','B19504851','953281897','','activos@mcservices2012.es','','Homologado','SAREB'),
		T_TIPO_DATA('Neourbe','B83580803','920 35 34 96','','alberto.f@neourbe.com ','','Homologado','SAREB'),
		T_TIPO_DATA('OUA Gestió del Territori i Urbanisme, S.L.','B63572267','662153152','932178628','assets@oua-urb.com','','Homologado','SAREB'),
		T_TIPO_DATA('PREMEA: Prevención y Medio Ambiente','B96595897','963924100','','premea@premea.com','','Homologado','SAREB'),
		T_TIPO_DATA('PROCYR Edificación y Urbanismo','B97279012','607434679','','ernesto.torregrosa@procyr.es','','Homologado','SAREB'),
		T_TIPO_DATA('Promo Llonch','B64381387','645565797','','jordi@promollonch.com','','Homologado','SAREB'),
		T_TIPO_DATA('Proyme Ingeniería y Construcción','B46635991','961752596','','juanba@proyme.es','','Homologado','SAREB'),
		T_TIPO_DATA('QIPERT UGH Global','B50919604','902140143(Ext.1168)','','licitaciones@qipert.com','','Homologado','SAREB'),
		T_TIPO_DATA('Santiago Guerra Quintana (Reformas SG)','78472108H','606227160','','reformas.sg@hotmail.com','','Homologado','SAREB'),
		T_TIPO_DATA('Securitas Seguridad España','A79252219','902201500','','alejandra.real@securitas.es','','Homologado','SAREB'),
		T_TIPO_DATA('Segurisa Servicios Integrales de Seguridad','A78798998','638080432','','opbarna@gruposagital.com','','Homologado','SAREB'),
		T_TIPO_DATA('Servicios Integrales de Canarias 2002','B35828995','928677881','','central@serviciosintegralesdecanarias.com','','Homologado','SAREB'),
		T_TIPO_DATA('SOINAN: Soluciones Integrales de Andalucía','B91236398','954864321','','soinansl@soinan.com','','Homologado','SAREB'),
		T_TIPO_DATA('Tinsa Certify','B86689494','913727500','','bankiacee@tinsacertify.es','','Homologado','SAREB'),
		T_TIPO_DATA('Unomil Arquitectos','B12640637','619247765','606568115','antonio@unomil.com','','Homologado','SAREB'),
		T_TIPO_DATA('Uransa Mantenimiento Integral','B98278799','680 99 66 46','','administracion@grupogara.com','','Homologado','SAREB'),
		T_TIPO_DATA('Varenyam','B98350077','670650861','','varenyamslu@gmail.com','','Homologado','SAREB'),
		T_TIPO_DATA('Vareser 96','B96534805','963679166','','central@vareser.net','','Homologado','SAREB'),
		T_TIPO_DATA('Víctor Tormo','B98257116','628 842 634','','avela@victortormo.com','','Homologado','SAREB'),
		T_TIPO_DATA('ALBAIDA INFRAESTRUCTURAS, S.A.','A04337309','950280330','660332160','jamanrique@grupoalbaida.es','ALMERIA','Homologado','CAJAMAR'),
		T_TIPO_DATA('ALTATAMARINDO S.L.U','B65428583','636344711','636344711','ALTATAMARINDO@GMAIL.COM','ALMERIA','Homologado','CAJAMAR'),
		T_TIPO_DATA('ARTIS TERRA CONSTRUCCIONES S.L.','B04604195','950487151','616470774','antonio.yanes@artisterra.es','El Ejido','Homologado','CAJAMAR'),
		T_TIPO_DATA('AVANZASI S.L.U.','B23657521','961059927','607388833','eva@avanzasi.es','Jaén','Homologado','CAJAMAR'),
		T_TIPO_DATA('Avanza Urbana Siglo XXI, SL','B98327943','963921991','619154309','slopez@avanzaurbana.com','Valencia','Homologado','CAJAMAR'),
		T_TIPO_DATA('AVINTIA PROYECTOS Y CONSTRUCCIONES S.L.','B85084135','915122711','607701578','lseptien@avintia.es','VILLAVICIOSA DE ODON','Homologado','CAJAMAR'),
		T_TIPO_DATA('APLISER CONSTRUCCIONES Y REFORMAS SLU','B45684677','615484243','615484243','apliser.1@gmail.com','YUNCOS','Homologado','CAJAMAR'),
		T_TIPO_DATA('BEGASA CONSTRUCCIONES PROYECTOS Y REFORMAS,S.L','B04466256','950256230','619015974','begasa@ya.com','GERGAL','Homologado','CAJAMAR'),
		T_TIPO_DATA('BUREAU VERITAS IBERIA','B28205904','954655261','677995717','emilio.losada@es.bureauveritas.com','Alcobendas','Homologado','CAJAMAR'),
		T_TIPO_DATA('CHIRIVO CONSTRUCCIONES,S.L.','B92418524','952034191','699499217','industrial@chirivo.com','VILLANUEVA DE LA CONCEPCION','Homologado','CAJAMAR'),
		T_TIPO_DATA('COISER-VIC21 SL','B98380629','610 20 17 92','610 20 17 92','coiser.vic@gmail.com','BETERA','Homologado','CAJAMAR'),
		T_TIPO_DATA('Construcciones Angel Blanque Sanchez, sl','B04485686','950349441','600567700','admon@construccionesblanque.com','Roquetas de Mar','Homologado','CAJAMAR'),
		T_TIPO_DATA('CONSTRUCCIONES TEJERA S.A','A04028023','950232777','639315114','aj@grupotejera.com','ALMERIA','Homologado','CAJAMAR'),
		T_TIPO_DATA('Construcciones Y Promociones Joneco S.L.','052B04405403','617 32 62 40','617 326 240','joneco@hotmail.es','San José','Homologado','CAJAMAR'),
		T_TIPO_DATA('CONSTRUCTORA DE OBRAS PUBLICAS ANDALUZAS (COPSA)','A04048088','950281136','687462525','estudios@grupocopsa.es','ALMERIA','Homologado','CAJAMAR'),
		T_TIPO_DATA('COROYFER, SL','B18386375','958183900','629810840','coroyfer@coroyfer.com','GRANADA','Homologado','CAJAMAR'),
		T_TIPO_DATA('CORPROYEC ALMERIA SL','B04524583','637545559','637545559','corproyec@erenovables.com','AGUADULCE','Homologado','CAJAMAR'),
		T_TIPO_DATA('DIAGONALGEST SL','B61425682','954186502','649849848','m.reina@diagonalgest.com','BARCELONA','Homologado','CAJAMAR'),
		T_TIPO_DATA('DIMENSUR S.L','B04490587','950282010','610487167','etortosa@dimensur.com','ALMERIA','Homologado','CAJAMAR'),
		T_TIPO_DATA('DIMOBA SERVICIOS, S.L','B04307120','950252577','678 523 689','lbermejo@grupocontrol.com','ALMERÍA','Homologado','CAJAMAR'),
		T_TIPO_DATA('DIMOBA, S.L.','B04307120','902252577','671092052','bgarcia@dimoba.com','ALMERIA','Homologado','CAJAMAR'),
		T_TIPO_DATA('ECA S.L. GRUPO BUREAU VERITAS','B08658601','958805649','647338209','carmen.morillas@es.bureauveritas.com','Sant Cugat del Valles','Homologado','CAJAMAR'),
		T_TIPO_DATA('ELECNOR, S.A.','A48027056','955 632 283','606 43 83 21','jlcubi@elecnor.es','ALCALA DE GUADAIRA','Homologado','CAJAMAR'),
		T_TIPO_DATA('ELECTRICIDAD MONTAJES ALMERIA SL','B04341699','950320103','615656689','sergio@montajesalmeria.es','ROQUETAS DE MAR','Homologado','CAJAMAR'),
		T_TIPO_DATA('electricidad y comunicaciones Gómez Ferre, sl','B04630075','950222771','658872291','manologs@gomezferre.es','Almería','Homologado','CAJAMAR'),
		T_TIPO_DATA('ELITIA Consultoría, S.A.U','A83263772','913727563','648477539','antonio.garcia@elitia-advisors.com','Las Rozas','Homologado','CAJAMAR'),
		T_TIPO_DATA('ENDESA ENERGIA SAU','A81948077','950268111','656602111','juancarlos.arnedo@endesa.es','MADRID','Homologado','CAJAMAR'),
		T_TIPO_DATA('ESPINA OBRAS HIDRÁULICAS S.A.','A15168156','983403270','606392838','espina.cl@espina.es','SANTIAGO DE COMPOSTELA','Homologado','CAJAMAR'),
		T_TIPO_DATA('ESTUDIO DE ARQUITECTURA Y URBANISMO, LLORENS, FORNES Y NAVARRO S.L.P.','B96836739','963 39 41 30','639149623','afornes@llfnarquitectos.com','VALENCIA','Homologado','CAJAMAR'),
		T_TIPO_DATA('GENERAL DE VIALES S.L.','B29770922','952359262','617464635','fulgencio@generaldeviales.com','MALAGA','Homologado','CAJAMAR'),
		T_TIPO_DATA('GESTIMED LEVANTE S.L.','B03830510','','','','ALICANTE','Homologado','CAJAMAR'),
		T_TIPO_DATA('GESTION DE VALORACIONES Y TASACIONES,S.A. (GESVALT)','A80884372','952 220 737','661144801','mjmunoz@gesvalt.es','MADRID','Homologado','CAJAMAR'),
		T_TIPO_DATA('GRUPO ALMICRAR,S.C','J04678785','685901319','685901319','mmmadrid18@gmail.com','VIATOR','Homologado','CAJAMAR'),
		T_TIPO_DATA('GRUPO BERTOLIN,S.A.U.','A46092128','963841234','607480815','mcferrer@grupobertolin.es','PATERNA','Homologado','CAJAMAR'),
		T_TIPO_DATA('GRUPO CONTROL EMPRESA DE SEGURIDAD SA','A04038014','902262222','678523689','lbermejo@grupocontrol.com','ALMERIA','Homologado','CAJAMAR'),
		T_TIPO_DATA('GRUPO CONTROL EMPRESA DE SEGURIDAD S.A.','A04038014','902262222','678523689','lbermejo@grupocontrol.com','ALMERIA','Homologado','CAJAMAR'),
		T_TIPO_DATA('Iniciativas y Proyectos Contra el Fuego, S.L.','B04482691','950305092','678744610','juanjo@iniciativasfuego.es','Viator','Homologado','CAJAMAR'),
		T_TIPO_DATA('INSMOEL, S.A.','A04028205','950622790','629050355','ingenieria@insmoel.es','Almería','Homologado','CAJAMAR'),
		T_TIPO_DATA('Instalaciones Electricas Segura S.L.','B04254793','950347640','649478260','rafael.segura@instalacionessegura.es','Vicar','Homologado','CAJAMAR'),
		T_TIPO_DATA('INTERACTIVA IBERGEST S.L.U.','B02118115','965113755','616967744','pgarcia@ibergest.net','ALBACETE','Homologado','CAJAMAR'),
		T_TIPO_DATA('INVERSION Y EDIFICACIONES SODELOR SL','B30473599','968406069','609378096','pedrocazorla@sodelor.com','LORCA','Homologado','CAJAMAR'),
		T_TIPO_DATA('INVERTOL S.L','B84105899','917990752','609162777','control@invertol.com','Puzuelo de Alarcon','Homologado','CAJAMAR'),
		T_TIPO_DATA('J2 ARQUITECTOS CB','E04711990','950260071','658122502','estudio@j2arquitectos.com','ALMERÍA','Homologado','CAJAMAR'),
		T_TIPO_DATA('JARQUIL CONSTRUCCIÓN, SA','A54496005','950219900','600957307','contratacion@jarquil.com','MADRID','Homologado','CAJAMAR'),
		T_TIPO_DATA('J. Martinez Arce y Asociados, S.L.','B73156424','968214881','616972428','acs@martinezarce.com','MURCIA','Homologado','CAJAMAR'),
		T_TIPO_DATA('José Ángel Ferrer Arquitectos, S.L.P.','B04336301','950281100','699138642','info@ferrerarquitectos.com','Almería','Homologado','CAJAMAR'),
		T_TIPO_DATA('Jose Octavio Ordinyana Poveda','20447058N','968419000','651533687','jose@ijarquitectos.com','Puerto Lumbreras','Homologado','CAJAMAR'),
		T_TIPO_DATA('Juan Carlos Navarro Navarro','73760763Q','96 3394130','619250072','jcnavarro@llfnarquitectos.com','Valencia','Homologado','CAJAMAR'),
		T_TIPO_DATA('Mantenimientos Reynes SLU','B57657207','--','609 307 392','abadia@mantenimientosreynes.com','Colonia de Sant Jordi','Homologado','CAJAMAR'),
		T_TIPO_DATA('MAYFRA OBRAS Y SERVICIOS, S.L.','B04264982','950250647','610738937','fms@excavacionesmayfra.com','BERJA','Homologado','CAJAMAR'),
		T_TIPO_DATA('Montajes de Electricidad Moya, S.L.','B04229548','--','660 480 511','antomoya@electricidadmoya.com','Huercal de Almería','Homologado','CAJAMAR'),
		T_TIPO_DATA('Montajes Electricos Samblas s.l.u.','B04506614','950580366','678660144','gerente@samblas.net','eL EJIDO','Homologado','CAJAMAR'),
		T_TIPO_DATA('Obras Acocasa, SLU','B04697728','950178071','660452391','javier@acocasa.com','Roquetas de Mar','Homologado','CAJAMAR'),
		T_TIPO_DATA('OCT CONTROLIA, S.A.','A82838350','915158080','639716671','miguelrv@octcontrolia.com','Madrid','Homologado','CAJAMAR'),
		T_TIPO_DATA('OMP','9','--','950 266 765','ompsle@teleline.es','--','Homologado','CAJAMAR'),
		T_TIPO_DATA('Procyr, Edificación y Urbanismo, s.l.','B97279012','963106208','696449513','ernesto.torregrosa@procyr.es','Paterna','Homologado','CAJAMAR'),
		T_TIPO_DATA('Quadratia Consultants S.L.','B53966560','965145310','616 92 33 69','juanramon.rubio@quadratia.es','Alicante','Homologado','CAJAMAR'),
		T_TIPO_DATA('SECURITAS SEGURIDAD ESPAÑA, S.A.','A79252219','968 270 05 84','676458619','angel.castano@securitas.es','MADRID','Homologado','CAJAMAR'),
		T_TIPO_DATA('SECURITAS SEGURIDAD ESPAÑA, S.A.','A79252219','961479476','649913438','maria.cuesta@securitas.es','MADRID','Homologado','CAJAMAR'),
		T_TIPO_DATA('SECURITAS DIRECT ESPAÑA, SAU','A26106013','','','','','Homologado','CAJAMAR'),
		T_TIPO_DATA('VALDENUCIELLO, S.L.','B24503245','987218050','607373625','jmgarciagonz@yahoo.es','LEÓN','Homologado','CAJAMAR'),
		T_TIPO_DATA('Valmesa & GB Projects SL','B54624119','966802977','649425174','reverte.sanchez@valmesa.es','BENIDORM','Homologado','CAJAMAR'),
		T_TIPO_DATA('VALUATION & REAL ESTATE GROUP, S.L. - MREG','B85030641','913751626','670706455','icruz@mreg.es','MADRID','Homologado','CAJAMAR'),
		T_TIPO_DATA('VARESER 96, S.L.','B96534805','963679166','661263473','ofertas@vareser.net','VALENCIA','Homologado','CAJAMAR'),
		T_TIPO_DATA('TINSA CERTIFY, S.L.','B86689494','','','','','Homologado','CAJAMAR'),
		T_TIPO_DATA('TINSA TASACIONES INMOBILIARIAS SA','A78029774','','','','','Homologado','CAJAMAR'),
		T_TIPO_DATA('VALORACIONES MEDITERRÁNEO, S.A.','A03319530','966802977','649425174','reverte.sanchez@valmesa.es','BENIDORM','Homologado','CAJAMAR'),
		T_TIPO_DATA('MALACITANA DE CONTROL, J.C., S.L.','B92687458','952 66 38 25','660086186','ISABEL@MALACITANADECONTROL.COM','FUENGIROLA','Homologado','CAJAMAR')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en ACT_PVE_PROVEEDOR -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_PVE_PROVEEDOR] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
	        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	        
		        --Comprobamos el dato a insertar
		        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
		        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		        
		        --Si existe lo modificamos
		       IF V_NUM_TABLAS > 0 THEN			       
		         DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR...no se modifica nada.');
		       ELSE
       		      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');   
			      V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_ACT_PVE_PROVEEDOR.NEXTVAL FROM DUAL';
			      EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
			      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR (' ||
			                  'PVE_ID, DD_TPR_ID, PVE_NOMBRE, PVE_NOMBRE_COMERCIAL, DD_TDI_ID, PVE_DOCIDENTIF, DD_PRV_ID, DD_LOC_ID, PVE_TELF1, PVE_TELF2, PVE_EMAIL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
			                  'SELECT '|| V_ID || ',(SELECT DD_TPR_ID FROM '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''05''), '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''',(SELECT DD_TDI_ID FROM '|| V_ESQUEMA ||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_DESCRIPCION = ''NIF''), '''||TRIM(V_TMP_TIPO_DATA(2))||''',(select dd_prv_id from '||V_ESQUEMA_M||'.dd_loc_localidad where upper(dd_loc_descripcion) = upper('''||TRIM(V_TMP_TIPO_DATA(6))||''')),(select dd_loc_id from '||V_ESQUEMA_M||'.dd_loc_localidad where upper(dd_loc_descripcion) = upper('''||TRIM(V_TMP_TIPO_DATA(6))||''')),'''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','''||TRIM(V_TMP_TIPO_DATA(5))||''', 0, ''DML'',SYSDATE,0 FROM DUAL';
			      EXECUTE IMMEDIATE V_MSQL;
			      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
	          
			      
			      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' EN ACT_ETP_ENTIDAD_PROVEEDOR ');   
			      V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_ACT_ETP_ENTIDAD_PROVEEDOR.NEXTVAL FROM DUAL';
			      EXECUTE IMMEDIATE V_MSQL INTO V_ID_ETP;	
			      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_ETP_ENTIDAD_PROVEEDOR (ETP_ID, DD_CRA_ID, PVE_ID) ' ||
			                  'SELECT '|| V_ID_ETP || ', (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE UPPER(DD_CRA_DESCRIPCION) = UPPER('''|| TRIM(V_TMP_TIPO_DATA(8)) ||''')), '|| V_ID || ' FROM DUAL';
			      EXECUTE IMMEDIATE V_MSQL;
			      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' EN ACT_ETP_ENTIDAD_PROVEEDOR');
			      
			      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' EN ACT_PVC_PROVEEDOR_CONTACTO ');   
			      V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_ACT_PVC_PROVEEDOR_CONTACTO.NEXTVAL FROM DUAL';
			      EXECUTE IMMEDIATE V_MSQL INTO V_ID_ACT;	
			      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_PVC_PROVEEDOR_CONTACTO (' ||
			      			  'PVC_ID, PVE_ID, DD_PRV_ID, USU_ID, DD_TDI_ID, PVC_DOCIDENTIF, PVC_NOMBRE, PVC_TELF1, PVC_TELF2, PVC_EMAIL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
			                  'SELECT '|| V_ID_ACT ||','|| V_ID ||', (SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE UPPER(DD_LOC_DESCRIPCION) = UPPER('''||TRIM(V_TMP_TIPO_DATA(6))||''')), (select usu_id from '||V_ESQUEMA_M||'.usu_usuarios where USU_USERNAME  = ''USUPROV''), (SELECT DD_TDI_ID FROM '|| V_ESQUEMA ||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_DESCRIPCION = ''NIF''), '''||TRIM(V_TMP_TIPO_DATA(2))||''', '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''||TRIM(V_TMP_TIPO_DATA(3))||''', '''||TRIM(V_TMP_TIPO_DATA(4))||''', '''||TRIM(V_TMP_TIPO_DATA(5))||''', 0, ''DML'',SYSDATE,0 FROM DUAL';
			      EXECUTE IMMEDIATE V_MSQL;
			      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' EN ACT_PVC_PROVEEDOR_CONTACTO');
			      
			END IF;
      	END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ACT_PVE_PROVEEDOR ACTUALIZADO CORRECTAMENTE ');
   

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



   