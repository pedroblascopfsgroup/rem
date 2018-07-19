--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20180710
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.12
--## INCIDENCIA_LINK=REMVIP-1218
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(50 CHAR) := 'ACT_GES_DIST_GESTORES';
    V_AUX NUMBER(16);
    PL_OUTPUT VARCHAR2(32000 CHAR);
    V_SQL_INSERT VARCHAR2(32000 CHAR); 
    V_USUARIO VARCHAR(50 CHAR):= 'REMVIP-1066'; -- Vble. Nombre del usuario de las variables de auditoria.
   
   
   
   
    TYPE T_TIPO_DATA_2 IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_DATA_2 IS TABLE OF T_TIPO_DATA_2;
    V_TIPO_DATA_2 T_ARRAY_DATA_2 := T_ARRAY_DATA_2(
        -- 
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04001','Abla','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04002','Abrucena','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04003','Adra','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04007','Alcolea','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04009','Alcudia de Monteagud','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04010','Alhabia','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04011','Alhama de Almería','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04013','Almería','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04015','Alsodux','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04024','Benahadux','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04026','Benitagla','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04027','Binizalón','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04029','Berja','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04030','Canjayar','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04032','Carboneras','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04038','Dalias','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04041','Enix','','jhernandez','Juan Hernandez Cabrera','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04043','Felix','','jhernandez','Juan Hernandez Cabrera','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04046','Fondón','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04047','Gador','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04049','Garrucha','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04050','Gergal','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04051','Huecija','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04052','Hercal de Almería','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04054','Illar','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04055','Institución','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04057','Laujar de Andarax','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04059','Lubrín','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04060','Lucainena de las Torres','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04064','Mojacar','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04065','Nacimiento','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04066','Nijar','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04067','Ohanes','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04074','Pechina','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04077','Ragol','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04078','Rioja','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04079','Roquetas de Mar','','jhernandez','Juan Hernandez Cabrera','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04081','Santa Fe de Mondujar','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04086','Sorbas','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04088','Tabernas','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04091','Terque','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04093','Turre','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04095','Uleila del Campo','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04101','Viator','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04102','Vicar','','jhernandez','Juan Hernandez Cabrera','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04113','Atochares','','mcumbreras','Margarita Cumbreras Manga','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04901','Las Tres Villas','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04902','El Ejido','','bcanadas','Basilio Cañadas Rodriguez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','04903','La Mojonera','','jhernandez','Juan Hernandez Cabrera','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','4','ALMERIA','','','','spalma','Seila Palma Mendoza','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','11','CADIZ','11004','Algeciras','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','11','CADIZ','11022','La Línea de la Concepción','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','11','CADIZ','11035','Tarifa','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','11','CADIZ','11038','Ubrique','','eespinosa','Estela Espinosa Morales','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','11','CADIZ','','','','egalan','Elena Galán Díaz','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','14','CORDOBA','','','','egalan','Elena Galán Díaz','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','18','GRANADA','','','','alirola','Antonio Lirola Tesón','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','21','HUELVA','','','','egalan','Elena Galán Díaz','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','23','JAEN','','','','alirola','Antonio Lirola Tesón','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29001','Alameda','','egalan','Elena Galán Díaz','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29010','Almargen','','egalan','Elena Galán Díaz','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29023','Benahavis','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29025','Benalmadena','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29032','Campillos','','egalan','Elena Galán Díaz','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29041','Casares','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29051','Estepona','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29054','Fuengirola','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29055','Fuente de Piedra','','egalan','Elena Galán Díaz','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29059','Humilladero','','egalan','Elena Galán Díaz','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29067','Málaga','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29068','Manilva','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29069','Marbella','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29070','Mijas','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29072','Mollina','','egalan','Elena Galán Díaz','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29076','Ojen','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29082','Rincon de la Victoría','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29088','Sierra de Yeguas','','egalan','Elena Galán Díaz','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29089','Teba','','egalan','Elena Galán Díaz','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','29901','Torremolinos','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','29','MALAGA','','','','eespinosa','Estela Espinosa Morales','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('1','ANDALUCIA','41','SEVILLA','','','','egalan','Elena Galán Díaz','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('2','ARAGON','22','HUESCA','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('2','ARAGON','44','TERUEL','','','','msanchezf','Mercedes Sanchez Fernandez','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('2','ARAGON','50','ZARAGOZA','','','','msanchezf','Mercedes Sanchez Fernandez','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('3','ISLAS BALEARES','7','BALEARES','','','','tbuendia','Tomás Buendía Feixas','emaurizot','Elisabeth Maurizot Pont'),
		T_TIPO_DATA_2('4','CANARIAS','35','LAS PALMAS','','','','ecabrera','Emilio Cabrera Cabrera','ecabrera','Emilio Cabrera Cabrera'),
		T_TIPO_DATA_2('4','CANARIAS','38','SANTA C TENERIFE','','','','ecabrera','Emilio Cabrera Cabrera','ecabrera','Emilio Cabrera Cabrera'),
		T_TIPO_DATA_2('5','CANTABRIA','39','CANTABRIA','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('6','CASTILLA LA MANCHA','2','ALBACETE','','','','msanchezf','Mercedes Sanchez Fernandez','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('6','CASTILLA LA MANCHA','13','CIUDAD REAL','','','','msanchezf','Mercedes Sanchez Fernandez','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('6','CASTILLA LA MANCHA','16','CUENCA','','','','msanchezf','Mercedes Sanchez Fernandez','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('6','CASTILLA LA MANCHA','19','GUADALAJARA','','','','msanchezf','Mercedes Sanchez Fernandez','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('6','CASTILLA LA MANCHA','45','TOLEDO','','','','msanchezf','Mercedes Sanchez Fernandez','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('7','CASTILLA Y LEON','5','AVILA','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('7','CASTILLA Y LEON','9','BURGOS','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('7','CASTILLA Y LEON','24','LEON','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('7','CASTILLA Y LEON','34','PALENCIA','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('7','CASTILLA Y LEON','37','SALAMANCA','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('7','CASTILLA Y LEON','40','SEGOVIA','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('7','CASTILLA Y LEON','42','SORIA','','','','msanchezf','Mercedes Sanchez Fernandez','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('7','CASTILLA Y LEON','47','VALLADOLID','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('7','CASTILLA Y LEON','49','ZAMORA','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('8','CATALUÑA','8','BARCELONA','','','','tbuendia','Tomás Buendía Feixas','emaurizot','Elisabeth Maurizot Pont'),
		T_TIPO_DATA_2('8','CATALUÑA','17','GIRONA','','','','tbuendia','Tomás Buendía Feixas','emaurizot','Elisabeth Maurizot Pont'),
		T_TIPO_DATA_2('8','CATALUÑA','25','LLEIDA','','','','tbuendia','Tomás Buendía Feixas','emaurizot','Elisabeth Maurizot Pont'),
		T_TIPO_DATA_2('8','CATALUÑA','43','TARRAGONA','','','','tbuendia','Tomás Buendía Feixas','emaurizot','Elisabeth Maurizot Pont'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03005','Albatera','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03012','Algorfa','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03013','Algueña','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03015','Almoradi','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03019','Aspe','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03023','Beneixama','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03024','Benejuzar','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03025','Benferri','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03034','Benijofar','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03043','Biar','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03044','Bigastro','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03049','Callosa de Seguro','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03053','Castalla','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03055','Catral','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03058','Cos','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03059','Crevillent','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03061','Daya Nueva','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03062','Daya Vieja','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03064','Dolores','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03065','Elche','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03066','Elda','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03070','Formentera del Segura','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03076','Guardamar del Segura','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03077','Hondón de las nieves','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03078','Hondón de los Frailes','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03088','Monforte del Cid','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03089','Monóver','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03093','Novelda','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03096','Onil','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03099','Orihuela','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03104','Petrer','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03105','Pinoso','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03109','Rafal','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03111','Redovan','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03113','Rojales','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03114','La Romana','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03116','Salinas','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03118','San Fulgencio','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03120','San Miguel de Salinas','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03121','Santa Pola','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03123','Sax','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03129','Tibi','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03133','Torrevieja','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03140','Villena','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03902','Pilar de la Horadada','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03903','Los Montesinos','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','03904','San Isidro','','pmorera','Purificación Morera Garnateo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','3','ALICANTE','','','','fcarrasco','Francisco José Carrasco Acedo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','12','CASTELLON','','','','ncolom','Nuria Colom Jaime','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46002','Ador','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46004','Agullent','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46005','Alaquás','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46006','Albaida','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46007','Albal','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46008','Albalat de la Ribera','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46009','Albalat dels Sorells','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46010','Albalat dels Taronchers','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46013','Alboraya','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46014','Albuixsch','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46015','Alcàsser','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46019','L´alcudia','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46020','L´alcudia de Cespins','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46021','Aldaia','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46022','Alfafar','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46024','Alfara de Algimia','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46025','Alfara de Patriarca','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46026','Alfarp','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46028','Algar de Palancia','','pmanez','Paloma Mañez Alarcón','',''),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46029','Algemesi','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46030','Algimia de Alrará','','pmanez','Paloma Mañez Alarcón','',''),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46031','Alginet','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46032','Almássera','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46034','Almoines','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46035','Almussafes','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46039','Anna','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46042','Aielo de Malferit','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46046','Barx','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46047','Bèlgida','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46048','Bellreguard','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46054','Benetusser','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46055','Beniarjo','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46057','Benicolet','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46058','Benifairo de les Valls','','pmanez','Paloma Mañez Alarcón','',''),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46059','Benifairo de la Valldigna','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46060','Benifaio','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46061','Benifla','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46062','Beniganim','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46063','Benimodo','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46065','Beniparrell','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46066','Benirredrá','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46068','Benisoda','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46069','Benisuera','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46072','Bocairent','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46073','Bolbaite','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46074','Bonrepós I Mirambell','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46075','Bufali','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46081','Canals','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46082','Canet D´en Berenduer','','pmanez','Paloma Mañez Alarcón','',''),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46085','Carlet','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46090','Castello de Rugat','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46093','Catadau','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46094','Catarroja','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46096','Cerdà','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46098','Corbera','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46101','Quart de les Valls','','pmanez','Paloma Mañez Alarcón','',''),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46102','Quart de Poblet','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46103','Quartell','','pmanez','Paloma Mañez Alarcón','',''),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46104','Quatretonda','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46105','Cullera','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46107','Chella','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46109','Cheste','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46110','Sirivella','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46113','Daimus','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46118','Enguera','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46120','Estivella','','pmanez','Paloma Mañez Alarcón','',''),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46121','Estubeny','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46122','Raura','','pmanez','Paloma Mañez Alarcón','',''),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46123','Favara','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46124','Fontanars de Alforins','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46125','Fortaleny','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46126','Foios','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46127','La Font dén Carrós','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46131','Gandía','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46132','Genoves','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46134','Gilet','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46137','L´granja de la Cespins','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46138','Guadasequies','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46139','Guadassuar','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46140','Guardamar de la Safor','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46143','Xeraco','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46145','Xàtiva','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46146','Xeresa','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46150','Llutxent','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46151','Llocnou de Fenollet','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46153','Llocnou de Sant Jeroni','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46154','Llanera de Ranes','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46155','Llaurí','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46156','Llombai','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46159','Manises','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46163','Massalfassar','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46164','Massamagrell','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46165','Massanassa','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46166','Meliana','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46169','Mislata','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46170','Moixent','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46171','Moncada','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46172','Montserrat','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46173','Montaverner','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46174','Montesa','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46175','Montixelvo','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46176','Montroy','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46177','Museros','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46179','Navarres','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46180','Novetlè','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46181','Oliva','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46183','L´olleria','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46184','Ontinyent','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46185','Otos','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46186','Paiporta','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46187','Palma de Gandía','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46188','Palmera','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46189','L´palomar','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46192','Petres','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46193','Picanya','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46194','Picassent','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46195','Piles','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46196','Pinet','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46197','Polinyá de Xuquer','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46198','Potries','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46199','LA Pobla de Farnals','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46200','L´pobla del Cespins','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46204','Puig','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46205','Puçol','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46207','Rafelbuñol','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46208','Rafelcofer','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46210','Rafol de Salem','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46211','Real de Gandía','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46212','Real','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46215','Riola','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46217','Rotglà de Corberà','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46218','Rotova','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46220','Sagunto','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46221','Salem','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46223','Sedavi','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46225','Sellent','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46230','Silla','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46231','Simat de la Valldigna','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46233','Sollana','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46235','Sueca','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46237','Tavernes Blanques','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46238','Tavernes de la Valldigna','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46240','Terrateig','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46243','Torrella','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46244','Torrent','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46245','Torres Torres','','pmanez','Paloma Mañez Alarcón','',''),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46248','Turis','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46250','Valencia','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46251','Vallada','','vgardel','Vanesa Gardel Domingo','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46255','Villalonga','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46260','Vinalesa','','dmartin','Daniel Martín Gutierrez','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','46904','Benicull de Xuquer','','mfabra','María Rosario Fabra Heredia','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('9','COMUNIDAD VALENCIANA','46','VALENCIA','','','','azanon','Angel Zanón García','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('10','EXTREMADURA','6','BADAJOZ','','','','egalan','Elena Galán Díaz','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('10','EXTREMADURA','10','CACERES','','','','egalan','Elena Galán Díaz','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('11','GALICIA','15','A CORUÑA','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('11','GALICIA','27','LUGO','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('11','GALICIA','32','OURENSE','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('11','GALICIA','36','PONTEVEDRA','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('12','COMUNIDAD DE MADRID','28','MADRID','','','','msanchezf','Mercedes Sanchez Fernandez','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30001','Abanilla','','aromera','Antonio Germán Romera Linares','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30002','Abarna','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30003','Aguilas','','aromera','Antonio Germán Romera Linares','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30004','Albudeite','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30006','Aledo','','aromera','Antonio Germán Romera Linares','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30007','Alguazas','','aromera','Antonio Germán Romera Linares','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30009','Archena','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30010','Beniel','','aromera','Antonio Germán Romera Linares','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30011','Blanca','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30012','Bullas','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30013','Calasparra','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30014','Campos del Rio','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30015','Caravaca de la Cruz','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30017','Cehegin','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30018','Ceutí','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30019','Cieza','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30020','Fortuna','','aromera','Antonio Germán Romera Linares','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30022','Jumilla','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30024','Lorca','','aromera','Antonio Germán Romera Linares','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30025','Lorquí','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30026','Mazarrón','','aromera','Antonio Germán Romera Linares','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30027','Molina de Segufa','','aromera','Antonio Germán Romera Linares','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30028','Moratalla','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30029','Mula','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30031','Ojos','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30032','Pliego','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30033','Puerto Lumbreras','','aromera','Antonio Germán Romera Linares','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30034','Ricote','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30038','Las Torres de Cotillas','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30039','Totana','','aromera','Antonio Germán Romera Linares','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30042','Villanueva del Rio Segura','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30043','Yecla','','emoreno','Estefanía Moreno Martinez','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','30901','Santomera','','aromera','Antonio Germán Romera Linares','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('13','REGION DE MURCIA','30','MURCIA','','','','mguitart','María Cristina Guitart Ramos','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('14','COMUNIDAD FORAL DE NAVARRA','31','NAVARRA','','','','msanchezf','Mercedes Sanchez Fernandez','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('15','PAIS VASCO','1','ALAVA','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('15','PAIS VASCO','20','GUIPUZCOA','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('15','PAIS VASCO','48','VIZCAYA','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('16','PRINCIPADO DE ASTURIAS','33','ASTURIAS','','','','ofernandez','Oscar Fernandez Fraile','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('17','LA RIOJA','26','LA RIOJA','','','','msanchezf','Mercedes Sanchez Fernandez','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('18','CEUTA','51','CEUTA','','','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('19','MELILLA','52','MELILLA','','','','rdelaplaza','Ricardo de la Plaza Ramirez','fmalvarez','Francisco Manuel Malvarez Mañas')
	); 
    V_TMP_TIPO_DATA_2 T_TIPO_DATA_2;


BEGIN 
	
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';	
    
	EXECUTE IMMEDIATE V_MSQL INTO V_AUX;

	IF V_AUX = 1 THEN 
	
		DBMS_OUTPUT.PUT_LINE('[INICIO]');
			
		 -- LOOP-----------------------------------------------------------------
			DBMS_OUTPUT.PUT_LINE('[INFO] Empieza la inserción en la tabla auxiliar '||V_TABLA||'');
    
    		FOR I IN V_TIPO_DATA_2.FIRST .. V_TIPO_DATA_2.LAST
            
			  LOOP
			              
				V_TMP_TIPO_DATA_2 := V_TIPO_DATA_2(I);
		               
                V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA_2(8))||'''';
                                
                EXECUTE IMMEDIATE V_MSQL INTO V_AUX;
                  
                IF V_AUX = 1 THEN
              
                      V_SQL_INSERT := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                                        ID                          
                                        ,TIPO_GESTOR                     
                                        ,COD_CARTERA                             
                                        ,COD_PROVINCIA                          
                                        ,COD_MUNICIPIO                                                  
                                        ,USERNAME                  
                                        ,NOMBRE_USUARIO   
                                        ,VERSION                 
                                        ,USUARIOCREAR             
                                        ,FECHACREAR 
                                        ) VALUES (
                                          S_'||V_TABLA||'.NEXTVAL
                                        , ''GCOMRET''
                                        , ''01''
                                        , '''||TRIM(V_TMP_TIPO_DATA_2(3))||'''
                                        , '''||TRIM(V_TMP_TIPO_DATA_2(5))||'''
                                        , '''||TRIM(V_TMP_TIPO_DATA_2(8))||'''
                                        , '''||V_TMP_TIPO_DATA_2(9)||'''
                                        ,1
                                        , '''||V_USUARIO||'''
                                        , SYSDATE
                                        )';
                                                                                    
                    EXECUTE IMMEDIATE V_SQL_INSERT;
                                
                    DBMS_OUTPUT.PUT_LINE('[INFO] Registro '||I||' insertado.');
                    
                ELSE 
                
                    DBMS_OUTPUT.PUT_LINE('El usuario '||V_TMP_TIPO_DATA_2(8)||' no existe en la fila '||I||' ');
                    
                END IF;

			END LOOP;

	ELSE 
    
        DBMS_OUTPUT.PUT_LINE('[INFO] No se ha iniciado la inserción');		
	
    END IF;
	
    COMMIT;
   
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



   
