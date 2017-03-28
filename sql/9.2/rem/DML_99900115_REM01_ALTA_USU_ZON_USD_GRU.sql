--/*
--###########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20170327
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1683
--## PRODUCTO=NO
--## 
--## Finalidad: Creacion de Usuarios REM
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


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

  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		--	ENTIDAD	  USER_NAME	 	PASS   		NOMBRE_USU		APELL1			APELL2			EMAIL      						GRP		PEF_COD			DESPACHO_EXTERNO	USU GRUPO
--Admision
	T_TIPO_DATA('1', 'bruiz', 		'rLD.a%', 	'BEATRIZ', 		'RUIZ', 		'FUENTES', 		'bruiz@haya.es', 				'0', 	'HAYASUPADM', 	'REMSUPADM',		null	),
	T_TIPO_DATA('1', 'iba', 		'fcAKmj', 	'IRENE', 		'BERENGUER',	'ALEIXANDRE', 	'iba@haya.es', 					'0', 	'HAYAGESTADM', 	'REMGGADM',			'GESTADM'	),
	T_TIPO_DATA('1', 'mriquelme', 	'DA@amI	', 	'MARÍA ELENA', 	'RIQUELME',		'LÓPEZ', 		'mriquelme@haya.es',			'0', 	'HAYAGESTADM', 	'REMGGADM',			'GESTADM'	),
-- Gestor activos
	T_TIPO_DATA('1', 'acasado', 	',]mWk%', 	'ANTONIO', 		'CASADO',		'ORTIZ', 		'acasado@haya.es',				'0', 	'HAYAGESACT', 	'REMACT',			null	),
	T_TIPO_DATA('1', 'adelaroja', 	'XOG))G', 	'AGUSTÍN', 		'DE LA ROJA',	'BUENO', 		'adelaroja@haya.es',			'0', 	'HAYAGESACT', 	'REMACT',			null	),
	T_TIPO_DATA('1', 'bcarrascos', 	'k7JxNA', 	'BLANCA', 		'CARRASCOSA',	'LLINARES', 	'bcarrascosa@haya.es',			'0', 	'HAYAGESACT', 	'REMACT',			null	),
	T_TIPO_DATA('1', 'csalvador', 	'NE)ab7', 	'CARMEN', 		'SALVADOR',		'MAS', 			'csalvador@haya.es',			'0', 	'HAYAGESACT', 	'REMACT',			null	),
	T_TIPO_DATA('1', 'inieto',		'HFn0Me', 	'ISABEL',	 	'NIETO',		'PADILLA', 		'inieto@haya.es',				'0', 	'HAYAGESACT', 	'REMACT',			null	),
	T_TIPO_DATA('1', 'jfernandez', 	'A>WO59', 	'JUAN MANUEL', 	'FERNÁNDEZ',	'MICÓ', 		'jfernandez@haya.es',			'0', 	'HAYAGESACT', 	'REMACT',			null	),
	T_TIPO_DATA('1', 'jmateo', 		'.uwJRF', 	'JUAN', 		'MATEO',		'PÉREZ', 		'jmateo@haya.es',				'0', 	'HAYAGESACT', 	'REMACT',			null	),
	T_TIPO_DATA('1', 'jpalazon', 	'My;RH6', 	'JOSE ÁNGEL', 	'PALAZON',		'GARRIDO', 		'jpalazon@haya.es',				'0', 	'HAYAGESACT', 	'REMACT',			null	),
	T_TIPO_DATA('1', 'jtorresr', 	'4a9MVL', 	'JOSE JESÚS', 	'TORRES',		'RODRÍGUEZ', 	'jtorresr@haya.es',				'0', 	'HAYAGESACT', 	'REMACT',			null	),
	T_TIPO_DATA('1', 'mleon', 		'imL=h]', 	'MIGUEL ÁNGEL', 'LEÓN',			'SÁNCHEZ', 		'mleon@haya.es',				'0', 	'HAYAGESACT', 	'REMACT',			null	),
	T_TIPO_DATA('1', 'purquiza', 	'(acagq', 	'PAOLA', 		'URQUIZA',		'MARTÍNEZ', 	'purquiza@haya.es',				'0', 	'HAYAGESACT', 	'REMACT',			null	),
-- gestores comerciales (retail)
	T_TIPO_DATA('1', 'afraile' 		,'n5uZAj' 	,'ANGELICA'  	,'FRAILE'  		,'ALCALDE'  	,'afraile@haya.es'  			,'0'  	,'HAYAGESTCOM'  ,'REMGCOM'			,null),
	T_TIPO_DATA('1', 'agonzalez'	,'_h9PBn' 	,'ALICIA'  		,'GONZÁLEZ'  ,'HERNÁNDEZ'  , 'agonzalez@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'alirola' 		,'7Mp]]M' 	,'ANTONIO'  	,'LIROLA'  ,'TESON'  , 'alirola@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'ataboadaa' 	,'&M@I@P' 	,'ADRIAN'  		,'TABOADA'  ,'ALBA'  , 'ataboadaa@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'avegas' 		,'ABU[)=' 	,'AROA'  			,'VEGAS'  ,'GONZALEZ'  , 'avegas@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'azanon' 		,'D?PBxM' 	,'ANGEL'  			,'ZANON'  ,'GARCIA'  , 'azanon@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'bcanadas' 	,'Lw$ADu' 	,'BASILIO'  		,'CAÑADAS'  ,'RODRIGUEZ'  , 'bcanadas@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'bmorant' 		,'AQ[],m' 	,'BELEN'  			,'MORANT'  ,'RODRÍGUEZ'  , 'bmorant@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'ccapdevila' 	,'9.<<i2' 	,'CRISTINA'  		,'CAPDEVILA'  ,'COLOMER'  , 'ccapdevila@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'colivares' 	,'wMsPwH' 	,'CONCEPCION'  	,'OLIVARES'  ,'GONZALEZ'  , 'colivares@externos.haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'csalazar' 	,'jsmaZv' 	,'CARLOS'  		,'SALAZAR'  ,'GRAVAN'  , 'csalazar@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'csanchezbl' 	,'%6h+*!' 	,'CRISTOPHER'  	,'SÁNCHEZ'  ,'BLANCO'  , 'csanchezbl@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'dgonzalezq' 	,'DA@amI' 	,'DANIEL'  		,'GONZÁLEZ'  ,'QUINTANA'  , 'dgonzalezq@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'dmartin' 		,'SjmQ>(' 	,'DANIEL'  		,'MARTIN'  ,'GUTIERREZ'  , 'dmartin@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'droncero' 	,'!wFxp6' 	,'DAVID'  			,'RONCERO'  ,'GAMITO'  , 'droncero@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'dvicente' 	,'-*l0wv' 	,'DANIEL'  		,'VICENTE'  ,'PONCE'  , 'dvicente@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'ecabrera' 	,'"2rj_I' 	,'EMILIO'  		,'CABRERA'  ,'CABRERA'  , 'ecabrera@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'edilien' 		,'c,!VU=' 	,'ELKE'  			,'DILIEN'  ,''  , 'edilien@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'eespinosa' 	,'uhb4y6' 	,'ESTELA'  		,'ESPINOSA'  ,'MORALES'  , 'eespinosa@externos.haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'egalan' 		,'e<i-Ee' 	,'ELENA'  			,'GALÁN'  ,'DÍAZ'  , 'egalan@externos.haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'egomezm' 		,'7MMjD9' 	,'ESTEFANÍA'  		,'GÓMEZ'  ,'MEDINA'  , 'egomezm@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'emaurizot' 	,'ql]<;V' 	,'ELISABETH'  		,'MAURIZOT'  ,'PONT'  , 'emaurizot@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'emoreno' 		,'Q.hG2i' 	,'ESTEFANIA'  		,'MORENO'  ,'MARTINEZ'  , 'emoreno@externos.haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'etraviesol' 	,'Zn2ivt' 	,'EDUARDO'  		,'TRAVIESO'  ,'LEDESMA'  , 'etraviesol@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'falonsor' 	,'m-[59*' 	,'FRANCISCO'  		,'ALONSO'  ,'RODRIGUEZ'  , 'falonsor@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'fcarrasco' 	,'Bhh*=R' 	,'FRANCISCO JOSÉ'  ,'CARRASCO'  ,'ACEDO'  , 'fcarrasco@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'fmalvarez' 	,'wC713[' 	,'FRANCISCO MANUEL','MALVAREZ'  ,'MAŃAS'  , 'fmalvarez@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'jalmaida' 	,'a]f];2' 	,'JOAQUIN'  		,'ALMAIDA'  ,'BERNAL'  , 'jalmaida@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'jalmansa' 	,'<7gL9.' 	,'JUAN CARLOS'  	,'ALMANSA'  ,'MARTÍN'  , 'jalmansa@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'jbarbero' 	,'I=@ADw' 	,'JON'  			,'BARBERO'  ,'INTXAURBE'  , 'jbarbero@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'jgarciamoz' 	,'v7wOD.' 	,'JOSÉ JOAQUÍN'  	,'GARCÍA'  ,'MOZAS'  , 'jgarciamoz@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'jgonzalezs' 	,'tI]g9V' 	,'JAVIER'  		,'GONZALEZ'  ,'SANCHEZ'  , 'jgonzalezs@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'jgracia' 		,'3?_*"_' 	,'JAVIER'  		,'GRACIA'  ,'DONNAY'  , 'jgracia@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'jhernandez' 	,'%z?-3a' 	,'JUAN'  			,'HERNANDEZ'  ,'CABRERA'  , 'jhernandez@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'jsoler' 		,'P5r?K#' 	,'JOSEP'  			,'SOLER'  ,'RIPOLL'  , 'jsoler@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'jtomasp' 		,'\"A%M;' 	,'JUAN TEOFILO'  	,'TOMAS'  ,'PARDO'  , 'jtomasp@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'jvila' 		,'jsmaZv' 	,'JOSE MANUEL'  	,'VILA'  ,'OLTRA'  , 'jvila@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'kbajo' 		,'Y69gVp' 	,'KATIA'  			,'BAJO'  ,'PRUDENCIANO'  , 'kbajo@externos.haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'ksteiert' 	,'a?,=aB' 	,'KARIN CLAUDINE'  ,'STEIERT'  ,'PLAZA'  , 'ksteiert@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'lmarting' 	,'xM!/jm' 	,'LAURA'  			,'MARTÍN'  ,'GARCÍA'  , 'lmarting@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'lmontesino' 	,'-%k.Ig' 	,'LYDIA'  			,'MONTESINOS'  ,'BUCH'  , 'lmontesinos@externos.haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'lopezgasco' 	,'S<<DKe' 	,'INMACULADA'  	,'LOPEZ'  ,'GASCO'  , 'ilopezgasco@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'mcumbreras' 	,'eq&L=&' 	,'MARGARITA'  		,'CUMBRERAS'  ,'MANGA'  , 'mcumbreras@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'mdiez' 		,'Z3K;BH' 	,'MARCOS'  		,'DÍEZ'  ,'MORELL'  , 'mdiez@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'mfabra' 		,'!xF%6L' 	,'MARIA ROSARIO'  ,'FABRA'  ,'HEREDIA'  , 'mfabra@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'mgarcia' 		,'FPjt=F' 	,'MINERVA'  		,'GARCÍA'  ,'VÁZQUEZ'  , 'mgarcia@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'mgarciap' 	,'Mnu2I<' 	,'MARÍA BLANCA'  	,'GARCÍA'  ,'PACHO'  , 'mgarciap@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'mguitart' 	,'xA3_",' 	,'MARÍA CRISTINA'  ,'GUITART'  ,'RAMOS'  , 'mguitart@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'montanon' 	,'<2\J!4' 	,'MARÍA'  			,'ONTAÑÓN'  ,'NASARRE'  , 'montanon@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'mperezd' 		,'.VMig=' 	,'MONTSERRAT'  	,'PÉREZ'  ,'DÍEZ'  , 'mperezd@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'mpoblet' 		,'D7@a2I' 	,'MARIONA'  		,'POBLET'  ,'TORRES'  , 'mpoblet@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'mruiz' 		,'G(c<<_' 	,'MIGUEL'  		,'RUIZ'  ,'ARANA'  , 'mruiz@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'msanchezf' 	,'ql]<;V' 	,'MERCEDES'  		,'SANCHEZ'  ,'FERNANDEZ'  , 'msanchezf@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'nvalle' 		,'2J-eMW' 	,'NIEVES'  		,'VALLE'  ,'RODRIGO'  , 'nvalle@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'pmanez' 		,'%Pa5aJ' 	,'PALOMA'  		,'MAÑEZ'  ,'ALARCON'  , 'pmanez@externos.haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'pmorera' 		,'%HnPIc' 	,'PURIFICACION'  	,'MORERA'  ,'GARNATEO'  , 'pmorera@externos.haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'polid' 		,']@2\@E' 	,'PATRICIA'  		,'OLID'  ,'RANGEL'  , 'polid@externos.haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'psm' 			,'DKm6Ee' 	,'PATRICIA'  		,'SANZ'  ,'MARÍN'  , 'psm@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'rdelaplaza' 	,'0LJ]#b' 	,'RICARDO'  		,'DE LA PLAZA'  ,'RAMÍREZ'  , 'rdelaplaza@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'sbertomeu' 	,'9+kH@0' 	,'SANDRA'  		,'BERTOMEU'  ,'TIELKER'  , 'sbertomeu@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'slopeza' 		,'P5r?K#' 	,'SERGIO'  		,'LÓPEZ'  ,'AZA'  , 'slopeza@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'spalma' 		,']j/4WX' 	,'SEILA'  			,'PALMA'  ,'MENDOZA'  , 'spalma@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'tbuendia' 	,'Kzh]%e' 	,'TOMAS'  			,'BUENDIA'  ,'FEIXAS'  , 'tbuendia@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'tpg' 			,'wyR/R!' 	,'TOMÁS'  			,'PÉREZ'  ,'GONZÁLEZ'  , 'tpg@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'vgardel' 		,'-WbmW/' 	,'VANESA'  		,'GARDEL'  ,'DOMINGO'  , 'vgardel@externos.haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
-- Gestores comercial (singular
	T_TIPO_DATA('1', 'aalonso' 		,'JyJ]<?' 	,'ALBERTO'  		,'ALONSO'  ,'ORTIZ'  , 'aalonso@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'acabanir' 	,'rlLIIP' 	,'ANTONIO'  		,'CABANILLAS'  ,'REJA'  , 'acabanir@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'aescribano' 	,'L\w2k9' 	,'ALVARO'  		,'ESCRIBANO'  ,'GALLO'  , 'aescribano@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'amartinez' 	,'</zB_.' 	,'ANTONIO JOSÉ'  	,'MARTÍNEZ'  ,'SALES'  , 'amartinez@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'enavarro' 	,'g@]jOa' 	,'ESTER'  		,'NAVARRO'  ,'CANO'  , 'enavarro@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'gromero' 		,'swm)c.' 	,'GONZALO'  		,'ROMERO'  ,'DE LARA'  , 'gromero@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'hgimenez' 	,'r*6gnj' 	,'HECTOR'  		,'GIMÉNEZ'  ,'BEA'  , 'hgimenez@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'ivazquez' 	,'3YJLA/' 	,'ISABEL MARÍA'  	,'VÁZQUEZ'  ,'NUÑEZ'  , 'ivazquez@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'lguillen' 	,'iMSerP' 	,'LEOPOLDO'  		,'GUILLÉN'  ,''  , 'lguillen@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'lmunoz' 		,'aWsaIa' 	,'LUIS'  			,'MUÑOZ'  ,'ORTEGA'  , 'lmunoz@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'mii' 			,'m2Hz%Q' 	,'MARIAM'  		,'IBÁÑEZ'  ,'IBOR'  , 'mii@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'mtugores' 	,'_AWc<U' 	,'MIQUEL'  		,'TUGORES'  ,'GELABERT'  , 'mtugores@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'omora' 		,'PMR;bA' 	,'OSCAR'  		,'MORA'  ,'RODRIGUEZ'  , 'omora@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'pblanco' 		,'<FUe;z' 	,'PAOLA'  		,'BLANCO'  ,'GIMENO'  , 'pblanco@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
	T_TIPO_DATA('1', 'pfernandez' 	,'/va<kU' 	,'PABLO'  		,'FERNANDEZ'  ,'GREGORIO'  , 'pfernandezg@haya.es'  ,'0'  ,'HAYAGESTCOM'  ,'REMGCOM', null),
-- Gestores backoffice cajamar
	T_TIPO_DATA('1', 'asalag' 		,'xPh3#A' 	,'ANA'  ,'SALAG'  ,'RUBIO'  , 'asalag@externos.haya.es'  ,'0'  ,'GESTCOMBACKOFFICE'  ,'GESTCOMBACKOFF', null),
	T_TIPO_DATA('1', 'ateruel' 		,'4M%Hd8' 	,'AMALIA'  ,'TERUEL'  ,'ANAYA'  , 'ateruel@haya.es'  ,'0'  ,'GESTCOMBACKOFFICE'  ,'GESTCOMBACKOFF', null),
	T_TIPO_DATA('1', 'gcarbonell' 	,'+tYFZ9' 	,'GUILLERMO'  ,'CARBONELL'  ,'AMIGO'  , 'gcarbonell@haya.es'  ,'0'  ,'GESTCOMBACKOFFICE'  ,'GESTCOMBACKOFF', null),
	T_TIPO_DATA('1', 'igomezr' 		,'6VtG3>' 	,'ISABEL MARÍA'  ,'GÓMEZ'  ,'RODRÍGUEZ'  , 'igomezr@haya.es'  ,'0'  ,'GESTCOMBACKOFFICE'  ,'GESTCOMBACKOFF', null),
	T_TIPO_DATA('1', 'jcardenal' 	,'u&D3N%' 	,'JESSICA'  ,'CARDENAL'  ,'GARCIA'  , 'jcardenal@haya.es'  ,'0'  ,'GESTCOMBACKOFFICE'  ,'GESTCOMBACKOFF', null),
	T_TIPO_DATA('1', 'mmaldonado' 	,'3HKa@?' 	,'MARÍA JOSÉ'  ,'MALDONADO'  ,'MARÍNEZ'  , 'mmaldonado@haya.es'  ,'0'  ,'GESTCOMBACKOFFICE'  ,'GESTCOMBACKOFF', null),
	T_TIPO_DATA('1', 'rsanchez' 	,'+DA5tV' 	,'RAUL'  ,'SANCHEZ'  ,'SALAS'  , 'rsanchez@haya.es'  ,'0'  ,'GESTCOMBACKOFFICE'  ,'GESTCOMBACKOFF', null),
-- Gestores formalizacion
	T_TIPO_DATA('1', 'abenavides' 	,'8H+34m' 	,'AMPARO'  ,'BENAVIDES'  ,'FERRER'  , 'abenavides@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'agimenez' 	,'%>3p!R' 	,'AMPARO'  ,'GIMÉNEZ'  ,'MOLINA'  , 'agimenez@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'amanas' 		,'Y%5ce>' 	,'ANTONIO'  ,'MAÑAS'  ,'FLORIT'  , 'amanas@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'cmartinez' 	,'vX3D2&' 	,'CAROLINA'  ,'MARTÍNEZ'  ,'ARIÑO'  , 'cmartinez@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'dvalero' 		,'08JTZz' 	,'DANIEL'  ,'VALERO'  ,'CHICO'  , 'dvalero@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'ebenitezt' 	,'UN+Z3X' 	,'EVELIO RAFAEL'  ,'BENITEZ'  ,'TRUJILLO'  , 'ebenitezt@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'imartin' 		,'3GMA+D' 	,'ISAAC'  ,'MARTÍN'  ,'ÚRSULA'  , 'imartin@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'iperez' 		,'ZWf095' 	,'IGNACIO'  ,'PEREZ'  ,'DE LA FUENTE'  , 'iperez@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'jcarbonell' 	,'M24qp%' 	,'JULIO ENRIQUE'  ,'CARBONELL'  ,'MORA'  , 'jcarbonell@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'jdella' 		,'?8XFdD' 	,'JOSE MARÍA'  ,'DELLA'  ,'MANZANO'  , 'jdella@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'jespinosa' 	,'@d7@A5' 	,'JOSE'  ,'ESPINOSA'  ,'MENCHON'  , 'jespinosa@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'lgl' 			,'B6%$CM' 	,'LAURA'  ,'GARRIDO'  ,'LUJÁN'  , 'lgl@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'lmillan' 		,'K@5!KC' 	,'LUIS ALBERTO'  ,'MILLAN'  ,'RUIZ'  , 'lmillan@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'marcas'		,'>U3SZb' 	,'MARÍA JESUS'  ,'ARCAS'  ,'DÍAZ'  , 'marcas@externos.haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'mganan' 		,'9Z$F#e' 	,'MARTA'  ,'GAÑAN'  ,'CLAVIJO'  , 'mganan@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'mlopez' 		,'8MeMd&' 	,'MARÍA'  ,'LÓPEZ'  ,'CONEJERO'  , 'mlopez@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'mramos' 		,'9VGjR%' 	,'MARÍA'  ,'MERCEDES'  ,'RAMOS'  , 'mramos@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'mveintimil' 	,'X+3UFw' 	,'MARTA'  ,'VEINTIMILLA'  ,'PINO'  , 'mveintimilla@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'nbertran' 	,'Snf2J?' 	,'NOEMI'  ,'BERTRAN'  ,'OLIVELLA'  , 'nbertran@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'ptranche' 	,'!wn%T6' 	,'PEDRO'  ,'TRANCHE'  ,'GONZALEZ'  , 'ptranche@haya.es '  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'rcf' 			,'cL7NV+' 	,'RAQUEL'  ,'CAMPOS'  ,'FORÉS'  , 'rcf@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'rmoreno' 		,'e5S@bM' 	,'RAFAEL'  ,'MORENO'  ,'MELGAR'  , 'rmoreno@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'sulldemoli' 	,'GK#N6H' 	,'SANTIAGO'  ,'ULLDEMOLINS'  ,'SALVADOR'  , 'sulldemolins@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
	T_TIPO_DATA('1', 'zmartin' 		,'8$W4Wm' 	,'ZENEHIDA'  ,'MARTIN'  ,'BERNARDOS'  , 'zmartin@haya.es'  ,'0'  ,'HAYAGESTFORM'  ,'REMGFORM', null),
-- Gestores publicación
	T_TIPO_DATA('1', 'jalmendros' 	,'yV@yD9' 	,'JAVIER'  ,'ALMENDROS'  ,'FORJAN'  , 'jalmendros@haya.es'  ,'0'  ,'HAYAGESTPUBL'  ,'REMGPUBL', null),
	T_TIPO_DATA('1', 'jtorres' 		,'D%9pJ9' 	,'JOSÉ ALBERTO'  ,'TORRES'  ,'SÁNCHEZ'  , 'jtorres@haya.es'  ,'0'  ,'HAYAGESTPUBL'  ,'REMGPUBL', null),
	T_TIPO_DATA('1', 'rabad' 		,'R@@h48' 	,'RAQUEL'  ,'ABAD'  ,'LARA'  , 'rabad@haya.es'  ,'0'  ,'HAYAGESTPUBL'  ,'REMGPUBL', null),
	T_TIPO_DATA('1', 'rchicharro' 	,'$3!FRY' 	,'ROCÍO'  ,'CHICHARRO'  ,'TORRES'  , 'rchicharro@haya.es'  ,'0'  ,'HAYAGESTPUBL'  ,'REMGPUBL', null),
-- Gestores precios
	T_TIPO_DATA('1', 'jalmendros' 	,'@Zz2Q7' 	,'JAVIER'  ,'ALMENDROS'  ,'FORJAN'  , 'jalmendros@haya.es'  ,'0'  ,'HAYAGESTPREC'  ,'REMGPREC', null),
	T_TIPO_DATA('1', 'jtorres' 		,'d%9zS!' 	,'JOSÉ ALBERTO'  ,'TORRES'  ,'SÁNCHEZ'  , 'jtorres@haya.es'  ,'0'  ,'HAYAGESTPREC'  ,'REMGPREC', null),
	T_TIPO_DATA('1', 'rabad' 		,'RATE5+' 	,'RAQUEL'  ,'ABAD'  ,'LARA'  , 'rabad@haya.es'  ,'0'  ,'HAYAGESTPREC'  ,'REMGPREC', null),
	T_TIPO_DATA('1', 'rchicharro' 	,'eE7Yk+' 	,'ROCÍO'  ,'CHICHARRO'  ,'TORRES'  , 'rchicharro@haya.es'  ,'0'  ,'HAYAGESTPREC'  ,'REMGPREC', null),
-- Gestores de administracion
	T_TIPO_DATA('1', 'acarabal' 	,'X$xA65' 	,'AIDA'  ,'CARABAL'  ,'REYES'  , 'acarabal@haya.es '  ,'0'  ,'HAYAADM'  ,'HAYAADM', null),
	T_TIPO_DATA('1', 'amanzano' 	,'U28jbP' 	,'ALBERTO MAGNO'  ,'MANZANO'  ,'ARRIBAS'  , 'amanzanob@haya.es '  ,'0'  ,'HAYAADM'  ,'HAYAADM', null),
	T_TIPO_DATA('1', 'mgarciaa' 	,'x?X@3R' 	,'ALMUDENA'  ,'GARCÍA'  ,'ARRIBAS'  , 'mgarciaa@haya.es '  ,'0'  ,'HAYAADM'  ,'HAYAADM', null),
	T_TIPO_DATA('1', 'abotella' 	,'5r26D>' 	,'AMPARO'  ,'BOTELLA'  ,'SÁNCHEZ'  , 'abotella@haya.es'  ,'0'  ,'HAYAADM'  ,'HAYAADM', null),
	T_TIPO_DATA('1', 'aalonsos' 	,'F@M4@N' 	,'ANTONIO LUIS'  ,'ALONSO'  ,'SÁNCHEZ'  , 'aalonsos@haya.es '  ,'0'  ,'HAYAADM'  ,'HAYAADM', null),
	T_TIPO_DATA('1', 'mgimenez' 	,'37M&Wq' 	,'CARMEN'  ,'GIMENEZ'  ,'ASIS'  , 'mgimenez@haya.es '  ,'0'  ,'HAYAADM'  ,'HAYAADM', null),
	T_TIPO_DATA('1', 'cfernandez' 	,'pDu3&8' 	,'CRISTINA'  ,'FERNANDEZ'  ,'RODRIGUEZ'  , 'cfernandezr@haya.es'  ,'0'  ,'HAYAADM'  ,'HAYAADM', null),
	T_TIPO_DATA('1', 'dmontero' 	,'v!WR9D' 	,'DOLORES'  ,'MONTERO'  ,''  , 'dmontero@haya.es '  ,'0'  ,'HAYAADM'  ,'HAYAADM', null),
	T_TIPO_DATA('1', 'eluqu' 		,'YXD&J9' 	,'ELENA'  ,'LUQUE'  ,'GIMÉNEZ'  , 'eluque@haya.es '  ,'0'  ,'HAYAADM'  ,'HAYAADM', null),
	T_TIPO_DATA('1', 'emartinezr' 	,'jdn%5Y' 	,'ELOISA'  ,'MARTINEZ'  ,'ROMERO'  , 'emartinezr@haya.es '  ,'0'  ,'HAYAADM'  ,'HAYAADM', null),
	T_TIPO_DATA('1', 'fibanez' 		,'A5yJA!' 	,'FRANCISCO MANUEL'  ,'IBÁÑEZ'  ,'ROMERO'  , 'fibanez@haya.es'  ,'0'  ,'HAYAADM'  ,'HAYAADM', null),
	T_TIPO_DATA('1', 'langel' 		,'sCeKd9' 	,'LOURDES'  ,'ANGEL'  ,'CRUZ'  , 'langel@haya.es'  ,'0'  ,'HAYAADM'  ,'HAYAADM', null),
	T_TIPO_DATA('1', 'lpena' 		,'F?fLb6' 	,'LUISA'  ,'MARIA'  ,'PEÑA GRANERO'  , 'lpena@haya.es'  ,'0'  ,'HAYAADM'  ,'HAYAADM', null),
	T_TIPO_DATA('1', 'mlopezo' 		,'J3rX3>' 	,'MIGUEL'  ,'LOPEZ'  ,'ORTEGA'  , 'mlopezo@haya.es'  ,'0'  ,'HAYAADM'  ,'HAYAADM', null),
	T_TIPO_DATA('1', 'texposito' 	,'8gw%Me' 	,'TOMÁS MANUEL'  ,'EXPOSITO'  ,'ORTEGA'  , 'texposito@haya.es'  ,'0'  ,'HAYAADM'  ,'HAYAADM', null),
	T_TIPO_DATA('1', 'vmaldonado' 	,'7%4nFr' 	,'VERONICA'  ,'MALDONADO'  ,'VARGAS'  , 'vmaldonado@haya.es'  ,'0'  ,'HAYAADM'  ,'HAYAADM', null),
-- Gestor de llaves 
	T_TIPO_DATA('1', 'cmolina' 		,'!6MSfA' 	,'CRISTINA'  ,'MOLINA'  ,''  , 'cmolina@haya.es'  ,'0'  ,'HAYALLA'  ,'HAYALLA', null),
	T_TIPO_DATA('1', 'cmorales' 	,'s8+ySB' 	,'MARIA'  ,'CARMEN'  ,'MORALES'  , 'cmorales@haya.es'  ,'0'  ,'HAYALLA'  ,'HAYALLA', null),
	T_TIPO_DATA('1', 'mcaselles' 	,'W5K?@R' 	,'MARIA'  ,'DEL ROSARIO'  ,'CASELLES'  , 'mcaselles@haya.es'  ,'0'  ,'HAYALLA'  ,'HAYALLA', null),
	T_TIPO_DATA('1', 'pmoruno' 		,'6@kFKs' 	,'PURIFICACION'  ,'MORUNO'  ,''  , 'pmoruno@haya.es'  ,'0'  ,'HAYALLA'  ,'HAYALLA', null),
-- Gestorías de Fase 1 ADMISION
	T_TIPO_DATA('1', '36510931H' 	,'4KGg+V' 	,'JOSE ANTONIO SALINAS DOMINGUEZ'  ,''  ,''  , 'jasalinas@tecnotramit.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'tecnotra01'),
	T_TIPO_DATA('1', '13928917W' 	,'8@zPD@' 	,'VERONICA'  ,'BEDIA'  ,'GARCIA'  , 'vbedia@tecnotramit.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'tecnotra01'),
	T_TIPO_DATA('1', '14270925T' 	,'>WVk8f' 	,'ESTER'  ,'DIAZ'  ,'ORTIZ'  , 'ediaz@tecnotramit.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'tecnotra01'),
	T_TIPO_DATA('1', 'Y1304280X' 	,'*LS765' 	,'CLAUDIA ANDREA CONDE PEREZ'  ,''  ,''  , 'caconde@tecnotramit.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'tecnotra01'),
	T_TIPO_DATA('1', '50731233H' 	,'m?Ra6v' 	,'GONZALO BERTRAN DE LIS BERMEJO'  ,''  ,''  , 'gbertrandelis@uniges.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'uniges01'),
	T_TIPO_DATA('1', '50299138R' 	,'2YM9Y8' 	,'RAFAEL'  ,'TEBAR'  ,'PEREZ'  , 'rtebar@uniges.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'uniges01'),
	T_TIPO_DATA('1', '00403142K' 	,'YE2@6G' 	,'JOSE VICENTE GARCIA MAYORA'  ,''  ,''  , 'jgmayora@uniges.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'uniges01'),
	T_TIPO_DATA('1', '02891847B' 	,'63u$+H' 	,'JUAN MANUEL SAMANIEGO FERNANDEZ'  ,''  ,''  , 'jmsamaniego@uniges.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'uniges01'),
	T_TIPO_DATA('1', '11834651R' 	,'>2HvN&' 	,'MARIA JOSE CASTIÑEIRAS CENAMOR'  ,''  ,''  , 'mjccenamor@uniges.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'uniges01'),
	T_TIPO_DATA('1', '53018453A' 	,'E%*g37' 	,'BEGOÑA'  ,'UBEDA'  ,'TORRES'  , 'bubeda@uniges.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'uniges01'),
	T_TIPO_DATA('1', '02912517G' 	,'9kH$&W' 	,'MARIA DEL CARMEN CAMACHO PEREZ'  ,''  ,''  , 'mccamacho@uniges.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'uniges01'),
	T_TIPO_DATA('1', '02618123X' 	,'32dK+5' 	,'MARIA ANGELES SANCHEZ LAGUNA'  ,''  ,''  , 'masanchez@uniges.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'uniges01'),
	T_TIPO_DATA('1', '04843135W' 	,'q5VKR%' 	,'PEDRO'  ,'PERUCHA'  ,'SANCHEZ'  , 'pperucha@uniges.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'uniges01'),
	T_TIPO_DATA('1', '11814281D' 	,'?%Td48' 	,'PEDRO JAVIER LANZ RAGGIO'  ,''  ,''  , 'pjlanz@uniges.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'uniges01'),
	T_TIPO_DATA('1', '46870710E' 	,'tA>@5$' 	,'MARINA'  ,'GONZALEZ'  ,'LLORENTE'  , 'mgonzalezl@uniges.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'uniges01'),
	T_TIPO_DATA('1', '53103618E' 	,'fZ8A$F' 	,'JUAN ANTONIO PULIDO CALVO'  ,''  ,''  , 'japulido@uniges.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'uniges01'),
	T_TIPO_DATA('1', '53605916P' 	,'W7Z4>+' 	,'MONICA'  ,'TORRES'  ,'SAHUCO'  , 'm.torres@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '07259025H' 	,'pD#G2N' 	,'NOELIA'  ,'GARCIA'  ,'CARRILERO'  , 'n.garcia@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '22589245W' 	,'2*bK>g' 	,'JUAN ENRIQUE TOMÁS BIENDICHO'  ,''  ,''  , 'j.tomas@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '24353350F' 	,'#YVYz2' 	,'MATILDE'  ,'CONTRERAS'  ,'GARRIDO'  , 'm.contreras@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '24365131B' 	,'vn9cD>' 	,'VANESSA'  ,'LOPEZ'  ,'VILAS'  , 'v.lopez@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '44854590J' 	,'9wk$+T' 	,'YASMINA'  ,'FEMENIA'  ,'ROGLÁ'  , 'y.femenia@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '25407864V' 	,'$8?4KL' 	,'CARMEN'  ,'ARAQUE'  ,'MORATALLA'  , 'm.araque@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '44853989X' 	,'$ENJw4' 	,'ROSARIO'  ,'MOYA'  ,'LERÍN'  , 'r.moya@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '44879986V' 	,'T8U@?d' 	,'VANESA'  ,'DESCO'  ,'GUILLEN'  , 'v.desco@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '29199627T' 	,'9wk$+T' 	,'ESTHER'  ,'MARTINEZ'  ,'TIRADO'  , 'esther.martinez@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '53253096T' 	,'L8by$P' 	,'SARA'  ,'VILLALBA'  ,'RODRIGUEZ'  , 's.villalba@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '53356963E' 	,'SU4bqt' 	,'FATIMA'  ,'CARRATALÁ'  ,'CASABAN'  , 'f.carratala@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '21500448W' 	,'M?95$R' 	,'MILA'  ,'RICO'  ,'GALLEGO'  , 'm.rico@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '52649732H' 	,'W739xL' 	,'DOLORES'  ,'MURILLO'  ,'TRUJILLO'  , 'm.murillo@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '29193980B' 	,'X9K4ND' 	,'Mª ASUNCIÓN GOMEZ FORCADA'  ,''  ,''  , 'a.gomez@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '33459310Z' 	,'?Z3FtE' 	,'Mª AMPARO PEIRO FERNANDEZ'  ,''  ,''  , 'a.peiro@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '51103423E' 	,'PC+9BJ' 	,'ROMAN'  ,'BERNAL'  ,'DIAZ'  , 'r.bernal@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '47459052R' 	,'+QAE4@' 	,'DANIEL'  ,'GAMO'  ,'BEAMUD'  , 'd.gamo@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '49148664X' 	,'#Ut34q' 	,'LUCIA'  ,'LOPEZ'  ,'ZAFRA'  , 'lucia.lopez@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '52874731P' 	,'4VX3?y' 	,'LUIS'  ,'FERNANDEZ'  ,'MORALES'  , 'l.fernandez@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '09041098M' 	,'XD5n&8' 	,'VERONICA'  ,'MORILLO'  ,'NAJARRO'  , 'v.morillo@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '46870082S' 	,'$5FyKU' 	,'IVAN'  ,'PORTERO'  ,'ESQUILICHE'  , 'i.portero@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '11847519N' 	,'SZ&657' 	,'CLARA'  ,'RUIZ'  ,'CONTRERAS'  , 'c.ruiz@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '02900594H' 	,'7S@NJM' 	,'EDUARDO'  ,'LACASTA'  ,'VILLAVERDE'  , 'e.lacasta@garsa.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'garsa01'),
	T_TIPO_DATA('1', '51409365H' 	,'W2c#74' 	,'ALBERTO'  ,'GARCIA'  ,'VILAS'  , 'albertogarcia@gmontalvo.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'montalvo01'),
	T_TIPO_DATA('1', '50729087B' 	,'&Fc>a3' 	,'ALONSO CARLOS CANOVAS RODRIGUEZ'  ,''  ,''  , 'carloscanovas@gmontalvo.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'montalvo01'),
	T_TIPO_DATA('1', '05356929E' 	,'$23aqX' 	,'MARIA LUISA FERNANDEZ VELA'  ,''  ,''  , 'marisafernandez@gmontalvo.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'montalvo01'),
	T_TIPO_DATA('1', '51943412M' 	,'7D#87+' 	,'MARIA ROSA REDONDO GOMEZ'  ,''  ,''  , 'rosaredondo@gmontalvo.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'montalvo01'),
	T_TIPO_DATA('1', '02715571F' 	,'$5FyKU' 	,'MARIA'  ,'BRETONES'  ,'MIGUELEZ'  , 'mariabretones@gmontalvo.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'montalvo01'),
	T_TIPO_DATA('1', '52979268X' 	,'$>L4Pb' 	,'YOLANDA'  ,'GARCIA'  ,'MERINO'  , 'yolandagmerino@gmontalvo.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'montalvo01'),
	T_TIPO_DATA('1', '02663468E' 	,'EUH%3g' 	,'CRISTINA'  ,'JIMENEZ'  ,''  , 'cristinajimenez@gmontalvo.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'montalvo01'),
	T_TIPO_DATA('1', '33521528V' 	,'bpC@A9' 	,'PALOMA'  ,'TORRES'  ,'RODRIGUEZ'  , 'palomatorres@gmontalvo.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'montalvo01'),
	T_TIPO_DATA('1', '31861013X' 	,'6%cH4X' 	,'JUANA MARIA ALCALDE RIAO'  ,''  ,''  , 'juanialcalde@gmontalvo.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'montalvo01'),
	T_TIPO_DATA('1', '50690262X' 	,'3a4Pk>' 	,'ALFONSO'  ,'LABRADOR'  ,'GARCIA'  , 'alfonso@gutierrezlabrador.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'gl01'),
	T_TIPO_DATA('1', '46933372D' 	,'ZA3?%4' 	,'OSCAR'  ,'ZURDO'  ,'GARCIA'  , 'oscar@gutierrezlabrador.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'gl01'),
	T_TIPO_DATA('1', '25120404B' 	,'Udw&%6' 	,'FRANCISCO MANUEL PEREZ SORIANO'  ,''  ,''  , 'paco@gutierrezlabrador.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'gl01'),
	T_TIPO_DATA('1', '0892090J' 	,'%Y29ZH' 	,'JESUS DE LAS HERAS SANCHEZ'  ,''  ,''  , 'jesus@gutierrezlabrador.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'gl01'),
	T_TIPO_DATA('1', '02521353R' 	,'8>SuD7' 	,'JOSE MARIA LABRADOR GARCIA'  ,''  ,''  , 'chema@gutierrezlabrador.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'gl01'),
	T_TIPO_DATA('1', '07957175A' 	,'y%qC9c' 	,'Mª PAZ DOMINGUEZ ISIDORO'  ,''  ,''  , 'mpaz@gl.e.telefonica.net'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'gl01'),
	T_TIPO_DATA('1', '8978199B' 	,'>%7uMY' 	,'MARIA DEL PILAR PEREZ SANCHEZ'  ,''  ,''  , 'pilar@gutierrezlabrador.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'gl01'),
	T_TIPO_DATA('1', '50432579L' 	,'#cW55@' 	,'MARIA OLGA GARCIA HERNANDO'  ,''  ,''  , 'olga@gutierrezlabrador.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'gl01'),
	T_TIPO_DATA('1', '06959680H' 	,'2T&v7D' 	,'PETRA'  ,'LABRADOR'  ,'GARCIA'  , 'glabrador@gl.e.telefonica.net'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'gl01'),
	T_TIPO_DATA('1', '50297504T' 	,'t4&CMc' 	,'MARIA VICTORIA BARBERO GOMEZ'  ,''  ,''  , 'mariab@pinosxxi.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '51980988E' 	,'6Hq!@Q' 	,'GEMA VANESA JIMENEZ BARBERO'  ,''  ,''  , 'gestiones@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '50105114M' 	,'9L#96#' 	,'DAVID'  ,'CASTAÑO'  ,'GONZALEZ'  , 'davidc@pinosxxi.com'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '42978368Q' 	,'P6%R3R' 	,'ALBERTO'  ,'GARRALON'  ,'DIAZ'  , 'a.garralon@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '70934859F' 	,'u?s6My' 	,'ALFONSO'  ,'GARCIA'  ,'CASTRO'  , 'alfonsogc@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '02251334W' 	,'nx5P#6' 	,'ALICIA'  ,'MARTINEZ'  ,'MENDEZ'  , 'aliciam@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '53365743Q' 	,'K?95VC' 	,'DANIEL'  ,'MARTIN'  ,'GIL'  , 'danielmg@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '51397701S' 	,'55jNSr' 	,'MONICA'  ,'GARCIA'  ,'SANCHEZ'  , 'recuperaciones.52@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '53137011L' 	,'&9W!SV' 	,'SALVADOR'  ,'NAPOLES'  ,'RACIONERO'  , 'recuperaciones.53@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '11831266C' 	,'!+D2BQ' 	,'DAVID'  ,'LOPEZ'  ,'GUTIERREZ'  , 'recuperaciones.62@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '52086132X' 	,'p>d8Nd' 	,'ASUNCION'  ,'CENTELLAS'  ,'PINTO'  , 'administracion.92@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '50979301P' 	,'Xf5AC6' 	,'INMACULADA'  ,'LLORENTE'  ,'GUIJARRO'  , 'cedulas@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '51067218L' 	,'3WNDZ$' 	,'RAQUEL'  ,'LOPEZ'  ,'GUTIERREZ'  , 'recuperaciones.63@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '50962298W' 	,'5C+P!g' 	,'EMILIO'  ,'HERVAS'  ,'VAZQUEZ'  , 'recuperaciones.59@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '51935765V' 	,'638tME' 	,'CRISTINA'  ,'HERNANDEZ'  ,'JIMENEZ'  , 'recuperaciones.54@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '02878451R' 	,'&BR3dH' 	,'MARIA DEL CARMEN DEL ESTAL PASCUAL'  ,''  ,''  , 'recuperaciones.56@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '08938379G' 	,'6h6yNF' 	,'SUSANA'  ,'MERAYO'  ,'LEON'  , 'gestiondocumental.24@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '08938380M' 	,'+QAE4@' 	,'YOLANDA'  ,'MERAYO'  ,'LEON'  , 'gestiondocumental.25@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '50101078V' 	,'6A3DWS' 	,'MARIA TERESA TEMPRANO GARCIA'  ,''  ,''  , 'recuperaciones.57@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '33517318Q' 	,'8R&Ac?' 	,'LUIS MIGUEL SANZ MARCOS'  ,''  ,''  , 'gestioncontratos.82@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '51178583H' 	,'R7gD?D' 	,'RONNIE DAN PATIÑO SAAVEDRA'  ,''  ,''  , 'ronniep@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '53443485H' 	,'h2PL%K' 	,'RAUL'  ,'RODRIGUEZ'  ,'OTERO'  , 'recuperaciones.58@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '50868754E' 	,'+M!Hr3' 	,'JAVIER'  ,'QUIROGA'  ,'MONTES'  , 'contabilidad@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
	T_TIPO_DATA('1', '50341446N' 	,'&!X6MD' 	,'HOLGER'  ,'MENA'  ,'MENA'  , 'gestioncontratos.81@pinosxxi.es'  ,'0'  ,'GESTOADM'   ,'GESTOADM',   'pinos01'),
-- Gestorías de Fase 2 ADMINISTRACION
	T_TIPO_DATA('1', '36510931H' 	,'xD6U>3' 	,'JOSE ANTONIO SALINAS DOMINGUEZ'  ,''  ,''  , 'jasalinas@tecnotramit.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'tecnotra02'),
	T_TIPO_DATA('1', '13928917W' 	,'H%Z#3M' 	,'VERONICA'  ,'BEDIA'  ,'GARCIA'  , 'vbedia@tecnotramit.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'tecnotra02'),
	T_TIPO_DATA('1', '44024784R' 	,'M?WU79' 	,'ESTHER'  ,'GOMEZ'  ,'MARTI'  , 'egomez@tecnotramit.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'tecnotra02'),
	T_TIPO_DATA('1', '43116723A' 	,'?&V8LA' 	,'OLMO'  ,'SARD'  ,'LAGUENS'  , 'osard@tecnotramit.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'tecnotra02'),
	T_TIPO_DATA('1', '36113636W' 	,'5XR8nx' 	,'CRISTINA'  ,'FERNANDEZ'  ,'IGLESIAS'  , 'cfernandez@tecnotramit.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'tecnotra02'),
	T_TIPO_DATA('1', '46579216F' 	,'$7G7xJ' 	,'EMMA'  ,'MARIN'  ,'AZNAR'  , 'emarin@tecnotramit.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'tecnotra02'),
	T_TIPO_DATA('1', '43516462W' 	,'>4Y+MV' 	,'EVA'  ,'RUIZ'  ,'RODRIGUEZ'  , 'eruiz@tecnotramit.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'tecnotra02'),
	T_TIPO_DATA('1', '50731233H' 	,'Gx!5Jm' 	,'GONZALO BERTRAN DE LIS BERMEJO'  ,''  ,''  , 'gbertrandelis@uniges.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'uniges02'),
	T_TIPO_DATA('1', '50299138R' 	,'EKq5s!' 	,'RAFAEL'  ,'TEBAR'  ,'PEREZ'  , 'rtebar@uniges.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'uniges02'),
	T_TIPO_DATA('1', '00403142K' 	,'X7p9x8' 	,'JOSE VICENTE GARCIA MAYORA'  ,''  ,''  , 'jgmayora@uniges.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'uniges02'),
	T_TIPO_DATA('1', '02641048G' 	,'Y!swN5' 	,'AMAYA'  ,'MACHO'  ,'HERVAS'  , 'amacho@uniges.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'uniges02'),
	T_TIPO_DATA('1', '05359290Z' 	,'P%L5#>' 	,'JUAN'  ,'MECO'  ,'GOMEZ'  , 'jmeco@uniges.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'uniges02'),
	T_TIPO_DATA('1', '51621412M' 	,'%F5wm#' 	,'MARIBEL'  ,'ZAMORA'  ,'LOPEZ'  , 'mizamora@uniges.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'uniges02'),
	T_TIPO_DATA('1', '07476736B' 	,'M+WKd2' 	,'SILVIA'  ,'PORTERO'  ,'RODRIGUEZ'  , 'sportero@uniges.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'uniges02'),
	T_TIPO_DATA('1', '05293091D' 	,'P7>@wM' 	,'DANIEL'  ,'SANCHEZ'  ,'CANOREA'  , 'dsanchez@uniges.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'uniges02'),
	T_TIPO_DATA('1', '47043581W' 	,'a86kQV' 	,'SONIA PALOMO DEL CASTILLO'  ,''  ,''  , 'spalomo@uniges.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'uniges02'),
	T_TIPO_DATA('1', '51643931F' 	,'9C$BX2' 	,'ANA'  ,'ZAMORA'  ,'LOPEZ'  , 'amzamora@uniges.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'uniges02'),
	T_TIPO_DATA('1', '51637306Y' 	,'%HXpQ5' 	,'LUCIO'  ,'SUAREZ'  ,'LOPEZ'  , 'lsuarez@uniges.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'uniges02'),
	T_TIPO_DATA('1', '01922998Z' 	,'THLz56' 	,'JORGE'  ,'BARDAVIO'  ,'ANDRES'  , 'jbardavio@uniges.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'uniges02'),
	T_TIPO_DATA('1', '47456865E' 	,'+75D8m' 	,'ELENA'  ,'SEVILLA'  ,'GIRON'  , 'esevilla@uniges.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'uniges02'),
	T_TIPO_DATA('1', '02891847B' 	,'4VX3?y' 	,'JUAN MANUEL SAMANIEGO FERNANDEZ'  ,''  ,''  , 'jmsamaniego@uniges.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'uniges02'),
	T_TIPO_DATA('1', '20158921L' 	,'7TDw>T' 	,'AMPARO'  ,'CANO'  ,'SAEZ'  , 'acanos.valencia@grupobc.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'cenahi02'),
	T_TIPO_DATA('1', '44858702P' 	,'t>W95p' 	,'MARISA'  ,'TAMARIZ'  ,'PALOMARES'  , 'mtamarizp.valencia@grupobc.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'cenahi02'),
	T_TIPO_DATA('1', '52659872S' 	,'dy28%E' 	,'BEATRIZ'  ,'MARTI'  ,'GENOVES'  , 'bmartig@grupobc.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'cenahi02'),
	T_TIPO_DATA('1', '52701241F' 	,'9$P97L' 	,'MAYTE'  ,'ZARAGOZA'  ,'MIRASOL'  , 'mzaragozam@grupobc.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'cenahi02'),
	T_TIPO_DATA('1', '53605916P' 	,'BA+5Sc' 	,'MONICA'  ,'TORRES'  ,'SAHUCO'  , 'm.torres@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '07259025H' 	,'kR+fZ6' 	,'NOELIA'  ,'GARCIA'  ,'CARRILERO'  , 'n.garcia@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '22589245W' 	,'9A3DWS' 	,'JUAN ENRIQUE TOMÁS BIENDICHO'  ,''  ,''  , 'j.tomas@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '24353350F' 	,'k>X9fk' 	,'MATILDE'  ,'CONTRERAS'  ,'GARRIDO'  , 'm.contreras@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '24365131B' 	,'8@RwWk' 	,'VANESSA'  ,'LOPEZ'  ,'VILAS'  , 'v.lopez@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '44854590J' 	,'w?YYA8' 	,'YASMINA'  ,'FEMENIA'  ,'ROGLÁ'  , 'y.femenia@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '25407864V' 	,'H5$Tz%' 	,'CARMEN'  ,'ARAQUE'  ,'MORATALLA'  , 'm.araque@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '44853989X' 	,'46+>AM' 	,'ROSARIO'  ,'MOYA'  ,'LERÍN'  , 'r.moya@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '44879986V' 	,'4MsL&A' 	,'VANESA'  ,'DESCO'  ,'GUILLEN'  , 'v.desco@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '29199627T' 	,'9A3DWS' 	,'ESTHER'  ,'MARTINEZ'  ,'TIRADO'  , 'esther.martinez@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '53253096T' 	,'Mv5@d5' 	,'SARA'  ,'VILLALBA'  ,'RODRIGUEZ'  , 's.villalba@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '53356963E' 	,'7D#87+' 	,'FATIMA'  ,'CARRATALÁ'  ,'CASABAN'  , 'f.carratala@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '21500448W' 	,'Gq@g9T' 	,'MILA'  ,'RICO'  ,'GALLEGO'  , 'm.rico@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '52649732H' 	,'Q2T8g&' 	,'DOLORES'  ,'MURILLO'  ,'TRUJILLO'  , 'm.murillo@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '29193980B' 	,'8nR%gC' 	,'Mª ASUNCIÓN GOMEZ FORCADA'  ,''  ,''  , 'a.gomez@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '33459310Z' 	,'BV8NP#' 	,'Mª AMPARO PEIRO FERNANDEZ'  ,''  ,''  , 'a.peiro@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '51103423E' 	,'rH&K4T' 	,'ROMAN'  ,'BERNAL'  ,'DIAZ'  , 'r.bernal@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '47459052R' 	,'5J>>HC' 	,'DANIEL'  ,'GAMO'  ,'BEAMUD'  , 'd.gamo@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '49148664X' 	,'@5Vn%&' 	,'LUCIA'  ,'LOPEZ'  ,'ZAFRA'  , 'lucia.lopez@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '52874731P' 	,'?8&LT>' 	,'LUIS'  ,'FERNANDEZ'  ,'MORALES'  , 'l.fernandez@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '09041098M' 	,'DE45Vc' 	,'VERONICA'  ,'MORILLO'  ,'NAJARRO'  , 'v.morillo@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '46870082S' 	,'THLz46' 	,'IVAN'  ,'PORTERO'  ,'ESQUILICHE'  , 'i.portero@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '11847519N' 	,'&EuR4d' 	,'CLARA'  ,'RUIZ'  ,'CONTRERAS'  , 'c.ruiz@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '02900594H' 	,'3#NNd6' 	,'EDUARDO'  ,'LACASTA'  ,'VILLAVERDE'  , 'e.lacasta@garsa.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'garsa02'),
	T_TIPO_DATA('1', '07225685M' 	,'Z33H>!' 	,'VICTOR'  ,'SANCHEZ'  ,'DOMINGUEZ'  , 'victorsanchez@gmontalvo.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'montalvo02'),
	T_TIPO_DATA('1', '51936756L' 	,'&9W!SV' 	,'RAUL'  ,'RODRIGUEZ'  ,'RANERA'  , 'raulrodriguez@gmontalvo.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'montalvo02'),
	T_TIPO_DATA('1', '49002451P' 	,'wD%P+4' 	,'BEATRIZ'  ,'GONZALEZ'  ,'SOTO'  , 'beatrizgonzalez@gmontalvo.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'montalvo02'),
	T_TIPO_DATA('1', '50225955G' 	,'54f?Z%' 	,'MIGUEL ANGEL URBANO GARCIA'  ,''  ,''  , 'miguelangelurbano@gmontalvo.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'montalvo02'),
	T_TIPO_DATA('1', 'X4436667J' 	,'TC46fq' 	,'MIGUEL'  ,'CASTILLO'  ,'VELANDIA'  , 'miguelcastillo@gmontalvo.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'montalvo02'),
	T_TIPO_DATA('1', '05217085H' 	,'cC2W>Y' 	,'MARIA ANGELES GOMEZ VAZQUEZ'  ,''  ,''  , 'angelesgomez@gmontalvo.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'montalvo02'),
	T_TIPO_DATA('1', '02257034K' 	,'GGG2+#' 	,'YOLANDA'  ,'RODRIGUEZ'  ,'BUENAÑO'  , 'yolandabrodriguez@gmontalvo.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'montalvo02'),
	T_TIPO_DATA('1', '50887128L' 	,'$>L4Pb' 	,'ROSANA'  ,'POPA'  ,'SANCHEZ'  , 'rosanapopa@gmontalvo.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'montalvo02'),
	T_TIPO_DATA('1', '50690262X' 	,'$aq72D' 	,'ALFONSO'  ,'LABRADOR'  ,'GARCIA'  , 'alfonso@gutierrezlabrador.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'gl02'),
	T_TIPO_DATA('1', '50727168R' 	,'?gt5Qt' 	,'MARIA ESTHER BERTRAN DE LIS BERMEJO'  ,''  ,''  , 'esther@gutierrezlabrador.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'gl02'),
	T_TIPO_DATA('1', '50834347T' 	,'BNp4w&' 	,'ANTONIO'  ,'FERNANDEZ'  ,'GARCIA'  , 'antonio@gutierrezlabrador.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'gl02'),
	T_TIPO_DATA('1', '51484093L' 	,'?FpR%2' 	,'FRANCISCO J. OREJANA RUIZ-DANA'  ,''  ,''  , 'francisco@gutierrezlabrador.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'gl02'),
	T_TIPO_DATA('1', '2698508X' 	,'Bd?45M' 	,'JOAQUIN'  ,'MADRID'  ,'SALVADOR-DUARTE'  , 'joaquin@gutierrezlabrador.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'gl02'),
	T_TIPO_DATA('1', '20253621M' 	,'q5VKR%' 	,'MARIA BELEN ROL RODRIGUEZ'  ,''  ,''  , 'belen@gutierrezlabrador.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'gl02'),
	T_TIPO_DATA('1', '70061363M' 	,'S5T!D8' 	,'RAFAEL'  ,'RANCAÑO'  ,'MARTINEZ'  , 'rafa@gutierrezlabrador.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'gl02'),
	T_TIPO_DATA('1', '20267711L' 	,'AF@3M#' 	,'SARA'  ,'ANTEQUERA'  ,'MARTIN'  , 'sara@gutierrezlabrador.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'gl02'),
	T_TIPO_DATA('1', '53048030W' 	,'VX3C5+' 	,'TAMARA'  ,'CUENCA'  ,'PRIETO'  , 'tamara@gutierrezlabrador.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'gl02'),
	T_TIPO_DATA('1', '50297504T' 	,'Z33H>!' 	,'MARIA VICTORIA BARBERO GOMEZ'  ,''  ,''  , 'mariab@pinosxxi.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '51980988E' 	,'CB+3X2' 	,'GEMA VANESA JIMENEZ BARBERO'  ,''  ,''  , 'gestiones@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '50105114M' 	,'6Q&#FD' 	,'DAVID'  ,'CASTAÑO'  ,'GONZALEZ'  , 'davidc@pinosxxi.com'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '42978368Q' 	,'>T@8zM' 	,'ALBERTO'  ,'GARRALON'  ,'DIAZ'  , 'a.garralon@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '70934859F' 	,'qjQ@C5' 	,'ALFONSO'  ,'GARCIA'  ,'CASTRO'  , 'alfonsogc@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '02251334W' 	,'u$3Uh3' 	,'ALICIA'  ,'MARTINEZ'  ,'MENDEZ'  , 'aliciam@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '53365743Q' 	,'H5$Tz%' 	,'DANIEL'  ,'MARTIN'  ,'GIL'  , 'danielmg@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '50962298W' 	,'3WNDZ$' 	,'EMILIO'  ,'HERVAS'  ,'VAZQUEZ'  , 'recuperaciones.59@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '51935765V' 	,'df!5De' 	,'CRISTINA'  ,'HERNANDEZ'  ,'JIMENEZ'  , 'recuperaciones.54@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '02878451R' 	,'u$2Uh3' 	,'MARIA DEL CARMEN DEL ESTAL PASCUAL'  ,''  ,''  , 'recuperaciones.56@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '08938379G' 	,'Z#nrF8' 	,'SUSANA'  ,'MERAYO'  ,'LEON'  , 'gestiondocumental.24@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '08938380M' 	,'j5D+#g' 	,'YOLANDA'  ,'MERAYO'  ,'LEON'  , 'gestiondocumental.25@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '50101078V' 	,'zM7A2D' 	,'MARIA TERESA TEMPRANO GARCIA'  ,''  ,''  , 'recuperaciones.57@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '33517318Q' 	,'5#DMQm' 	,'LUIS MIGUEL SANZ MARCOS'  ,''  ,''  , 'gestioncontratos.82@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '51178583H' 	,'mE5V2T' 	,'RONNIE DAN PATIÑO SAAVEDRA'  ,''  ,''  , 'ronniep@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '53443485H' 	,'%$DR#3' 	,'RAUL'  ,'RODRIGUEZ'  ,'OTERO'  , 'recuperaciones.58@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '51903049F' 	,'7weR&5' 	,'ENRIQUE'  ,'PEREZ'  ,'TRANCHO'  , 'gestioninmuebles.31@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '07472312A' 	,'8MSfus' 	,'MARIA ANGELES ROSETE GARCIA'  ,''  ,''  , 'gestioninmuebles.33@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '02912870N' 	,'B7@jhF' 	,'CARMEN'  ,'CASTRO'  ,'NIETO'  , 'gestioninmuebles.40@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '11825474R' 	,'p>d8Nd' 	,'MARIA CRUZ CASTAÑO GONZALEZ'  ,''  ,''  , 'gestioninmuebles.38@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '51258960X' 	,'!3TyV5' 	,'SUSAN'  ,'BENZA'  ,'MINCHON'  , 'gestioninmuebles.46@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '51368399S' 	,'9@dmNB' 	,'PABLO'  ,'GARCIA'  ,'SANCHEZ'  , 'gestioninmuebles.47@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '52872988J' 	,'H?W8t8' 	,'DIEGO'  ,'FERNANDEZ'  ,'MUÑOZ'  , 'gestioninmuebles.41@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '50868754E' 	,'%5D>S%' 	,'JAVIER'  ,'QUIROGA'  ,'MONTES'  , 'contabilidad@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '50341446N' 	,'$J49$7' 	,'HOLGER'  ,'MENA'  ,'MENA'  , 'gestioncontratos.81@pinosxxi.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'pinos02'),
	T_TIPO_DATA('1', '03867799G' 	,'%56Dm%' 	,'IRENE'  ,'SARDINERO'  ,'LÓPEZ'  , 'isardinero@grupogf.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'ogf02'),
	T_TIPO_DATA('1', '03876878K' 	,'D>5Fa&' 	,'María Noemí Fernández Martín'  ,''  ,''  , 'mnfernandez@grupogf.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'ogf02'),
	T_TIPO_DATA('1', '03887362V' 	,'Yk6Z5$' 	,'Luis María Nogales Sánchez'  ,''  ,''  , 'lnogales@grupogf.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'ogf02'),
	T_TIPO_DATA('1', '03893974M' 	,'G6aFL@' 	,'Pedro Luis Chicharro Ruiz'  ,''  ,''  , 'pchicharro@grupogf.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'ogf02'),
	T_TIPO_DATA('1', '03877533D' 	,'>G4+EV' 	,'JAIME'  ,'CALVO'  ,'BRASAL'  , 'jcalvo@grupogf.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'ogf02'),
	T_TIPO_DATA('1', 'X4092272C' 	,'Juc#t4' 	,'PABLO'  ,'VARNI'  ,''  , 'pvarni@grupogf.es'  ,'0'  ,'HAYAGESTADMT'   ,'REMGIAADMT',   'ogf02'),
-- Gestorías de Fase 3 FORMALIZACION
	T_TIPO_DATA('1', '36510931H' 	,'57XXN&' 	,'JOSE ANTONIO SALINAS DOMINGUEZ'  ,''  ,''  , 'jasalinas@tecnotramit.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'tecnotra03'),
	T_TIPO_DATA('1', '13928917W' 	,'NG7?#9' 	,'VERONICA'  ,'BEDIA'  ,'GARCIA'  , 'vbedia@tecnotramit.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'tecnotra03'),
	T_TIPO_DATA('1', '46686562N' 	,'PX2X?$' 	,'SARA'  ,'ARRANZ'  ,'MARTINEZ'  , 'sarranz@tecnotramit.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'tecnotra03'),
	T_TIPO_DATA('1', '38115797J' 	,'d7vCDu' 	,'SONIA'  ,'CASTILLA'  ,'REY'  , 'scastilla@tectotramit.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'tecnotra03'),
	T_TIPO_DATA('1', '43696178L' 	,'K78qXn' 	,'TERESA'  ,'RABARTE'  ,'MARTINEZ'  , 'trabarte@tecnotramit.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'tecnotra03'),
	T_TIPO_DATA('1', '50731233H' 	,'>6GkLu' 	,'GONZALO BERTRAN DE LIS BERMEJO'  ,''  ,''  , 'gbertrandelis@uniges.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'uniges03'),
	T_TIPO_DATA('1', '50299138R' 	,'6er3N$' 	,'RAFAEL'  ,'TEBAR'  ,'PEREZ'  , 'rtebar@uniges.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'uniges03'),
	T_TIPO_DATA('1', '00403142K' 	,'>SSyN9' 	,'JOSE VICENTE GARCIA MAYORA'  ,''  ,''  , 'jgmayora@uniges.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'uniges03'),
	T_TIPO_DATA('1', '51637306Y' 	,'!ucQ93' 	,'LUCIO'  ,'SUAREZ'  ,'LOPEZ'  , 'lsuarez@uniges.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'uniges03'),
	T_TIPO_DATA('1', '01922998Z' 	,'J2R$hP' 	,'JORGE'  ,'BARDAVIO'  ,'ANDRES'  , 'jbardavio@uniges.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'uniges03'),
	T_TIPO_DATA('1', '08931423V' 	,'iibS?7' 	,'ALMUDENA'  ,'TORIO'  ,'GONZALEZ'  , 'atorio@uniges.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'uniges03'),
	T_TIPO_DATA('1', '52366328C' 	,'J?TA3+' 	,'ANA'  ,'MORALES'  ,'AGUILAR'  , 'ammorales@uniges.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'uniges03'),
	T_TIPO_DATA('1', '53605916P' 	,'J+3RP5' 	,'MONICA'  ,'TORRES'  ,'SAHUCO'  , 'm.torres@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '07259025H' 	,'3W+KDK' 	,'NOELIA'  ,'GARCIA'  ,'CARRILERO'  , 'n.garcia@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '22589245W' 	,'6w3J@%' 	,'JUAN ENRIQUE TOMÁS BIENDICHO'  ,''  ,''  , 'j.tomas@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '24353350F' 	,'Bz+S5@' 	,'MATILDE'  ,'CONTRERAS'  ,'GARRIDO'  , 'm.contreras@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '24365131B' 	,'W?n2#g' 	,'VANESSA'  ,'LOPEZ'  ,'VILAS'  , 'v.lopez@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '44854590J' 	,'$eHL4v' 	,'YASMINA'  ,'FEMENIA'  ,'ROGLÁ'  , 'y.femenia@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '25407864V' 	,'B2t+DM' 	,'CARMEN'  ,'ARAQUE'  ,'MORATALLA'  , 'm.araque@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '44853989X' 	,'iTLW8r' 	,'ROSARIO'  ,'MOYA'  ,'LERÍN'  , 'r.moya@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '44879986V' 	,'>GyD%6' 	,'VANESA'  ,'DESCO'  ,'GUILLEN'  , 'v.desco@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '29199627T' 	,'DhqB@5' 	,'ESTHER'  ,'MARTINEZ'  ,'TIRADO'  , 'esther.martinez@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '53253096T' 	,'H>5nXC' 	,'SARA'  ,'VILLALBA'  ,'RODRIGUEZ'  , 's.villalba@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '53356963E' 	,'3!UBsj' 	,'FATIMA'  ,'CARRATALÁ'  ,'CASABAN'  , 'f.carratala@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '21500448W' 	,'rXwQy8' 	,'MILA'  ,'RICO'  ,'GALLEGO'  , 'm.rico@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '52649732H' 	,'$w7Mve' 	,'DOLORES'  ,'MURILLO'  ,'TRUJILLO'  , 'm.murillo@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '29193980B' 	,'?PW3H#' 	,'Mª ASUNCIÓN GOMEZ FORCADA'  ,''  ,''  , 'a.gomez@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '33459310Z' 	,'2+Uhxc' 	,'Mª AMPARO PEIRO FERNANDEZ'  ,''  ,''  , 'a.peiro@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '51103423E' 	,'yUME4s' 	,'ROMAN'  ,'BERNAL'  ,'DIAZ'  , 'r.bernal@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '47459052R' 	,'a#X3+C' 	,'DANIEL'  ,'GAMO'  ,'BEAMUD'  , 'd.gamo@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '49148664X' 	,'D2y$JY' 	,'LUCIA'  ,'LOPEZ'  ,'ZAFRA'  , 'lucia.lopez@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '52874731P' 	,'&f8RgF' 	,'LUIS'  ,'FERNANDEZ'  ,'MORALES'  , 'l.fernandez@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '09041098M' 	,'H4kW6+' 	,'VERONICA'  ,'MORILLO'  ,'NAJARRO'  , 'v.morillo@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '46870082S' 	,'9JD%YX' 	,'IVAN'  ,'PORTERO'  ,'ESQUILICHE'  , 'i.portero@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '11847519N' 	,'>Sed9G' 	,'CLARA'  ,'RUIZ'  ,'CONTRERAS'  , 'c.ruiz@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '02900594H' 	,'4yGQ+8' 	,'EDUARDO'  ,'LACASTA'  ,'VILLAVERDE'  , 'e.lacasta@garsa.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'garsa03'),
	T_TIPO_DATA('1', '09796301A' 	,'$mNK5M' 	,'MARIA TERESA SERRANO MARTINEZ'  ,''  ,''  , 'tessaserrano@gmontalvo.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'montalvo03'),
	T_TIPO_DATA('1', '836024C' 		,'7GnC#s' 	,'PABLO'  ,'IGLESIAS'  ,'CONTRERAS'  , 'pabloiglesias@gmontalvo.com '  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'montalvo03'),
	T_TIPO_DATA('1', '50690732C' 	,'V4#4tu' 	,'ANTONIO'  ,'BLANCO'  ,'CABRERO'  , 'antonioblanco@gmontalvo.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'montalvo03'),
	T_TIPO_DATA('1', '2235351G' 	,'pP#5y@' 	,'ROSA MARIA GARCIA-NAVAS MONTALBAN'  ,''  ,''  , 'rmg@montalvoasesores.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'montalvo03'),
	T_TIPO_DATA('1', '50690262X' 	,'eYJ5Rq' 	,'ALFONSO'  ,'LABRADOR'  ,'GARCIA'  , 'alfonso@gutierrezlabrador.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'gl03'),
	T_TIPO_DATA('1', '51927281C' 	,'6er3N$' 	,'MARIA EUGENIA BLANCO BARAHONA'  ,''  ,''  , 'geni@gutierrezlabrador.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'gl03'),
	T_TIPO_DATA('1', '47460855X' 	,'2K#rDq' 	,'ALEJANDRO ELVIRA DE LA PAZ'  ,''  ,''  , 'alex@gutierrezlabrador.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'gl03'),
	T_TIPO_DATA('1', '50751583J' 	,'4k3q!C' 	,'GEMA'  ,'MOLINA'  ,'ALONSO'  , 'gema@gutierrezlabrador.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'gl03'),
	T_TIPO_DATA('1', '74717518V' 	,'@9+X3h' 	,'JUAN SERGIO MALDONADO MARTIN'  ,''  ,''  , 'sergio@gutierrezlabrador.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'gl03'),
	T_TIPO_DATA('1', '50731298Z' 	,'D2dQg%' 	,'MARIA DEL CARMEN JOVE DIAZ'  ,''  ,''  , 'carmina@gutierrezlabrador.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'gl03'),
	T_TIPO_DATA('1', '51391272A' 	,'NUr9hY' 	,'PALOMA'  ,'ALFARO'  ,'FERNANDEZ'  , 'paloma@gutierrezlabrador.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'gl03'),
	T_TIPO_DATA('1', '7525763W' 	,'Qn3$P@' 	,'ROBERTO'  ,'GARCIA'  ,'GOMEZ'  , 'rober@gutierrezlabrador.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'gl03'),
	T_TIPO_DATA('1', '50297504T' 	,'P4nw#3' 	,'MARIA VICTORIA BARBERO GOMEZ'  ,''  ,''  , 'mariab@pinosxxi.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '51980988E' 	,'>9E%7>' 	,'GEMA VANESA JIMENEZ BARBERO'  ,''  ,''  , 'gestiones@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '50105114M' 	,'ew%m2P' 	,'DAVID'  ,'CASTAÑO'  ,'GONZALEZ'  , 'davidc@pinosxxi.com'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '42978368Q' 	,'&M3FA3' 	,'ALBERTO'  ,'GARRALON'  ,'DIAZ'  , 'a.garralon@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '70934859F' 	,'Lr7V+t' 	,'ALFONSO'  ,'GARCIA'  ,'CASTRO'  , 'alfonsogc@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '02251334W' 	,'Kmt6&F' 	,'ALICIA'  ,'MARTINEZ'  ,'MENDEZ'  , 'aliciam@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '53365743Q' 	,'rzbB8m' 	,'DANIEL'  ,'MARTIN'  ,'GIL'  , 'danielmg@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '50979301P' 	,'4aVA&P' 	,'INMACULADA'  ,'LLORENTE'  ,'GUIJARRO'  , 'cedulas@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '51067218L' 	,'%%tTE8' 	,'RAQUEL'  ,'LOPEZ'  ,'GUTIERREZ'  , 'recuperaciones.63@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '50962298W' 	,'FUEt6@' 	,'EMILIO'  ,'HERVAS'  ,'VAZQUEZ'  , 'recuperaciones.59@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '08938379G' 	,'5GBt1t' 	,'SUSANA'  ,'MERAYO'  ,'LEON'  , 'gestiondocumental.24@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '08938380M' 	,'e+Yw9a' 	,'YOLANDA'  ,'MERAYO'  ,'LEON'  , 'gestiondocumental.25@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '53443485H' 	,'7d%WGW' 	,'RAUL'  ,'RODRIGUEZ'  ,'OTERO'  , 'recuperaciones.58@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '50868754E' 	,'ME8%U2' 	,'JAVIER'  ,'QUIROGA'  ,'MONTES'  , 'contabilidad@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '50341446N' 	,'%Z2Ng2' 	,'HOLGER'  ,'MENA'  ,'MENA'  , 'gestioncontratos.81@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '1913510W' 	,'T!3SMs' 	,'INMACULADA DE PINTO HERRERA'  ,''  ,''  , 'activosadjudicados.73@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '52869104Q' 	,'RT62?R' 	,'JORGE'  ,'PEREZ'  ,'GONZALEZ'  , 'activosadjudicados.71@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '1179976V' 	,'F>Us&2' 	,'PABLO SANZ DE LUCAS'  ,''  ,''  , 'activosadjudicados.74@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '11827176R' 	,'EN+5R2' 	,'ORQUIDEA'  ,'DELGADO'  ,'BLAS'  , 'activosadjudicados.79@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '52958095C' 	,'B7wC6+' 	,'HUSSEIN MAHMOUD EL HELOU'  ,''  ,''  , 'activosadjudicados.78@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '50300602Q' 	,'+4K9Q6' 	,'JULIO'  ,'ANTON'  ,'ANTON'  , 'activosadjudicados.80@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '38544746N' 	,'9JD%YX' 	,'ANA Mª DEL CARMEN VARGAS MACHUCA MARQUEZ'  ,''  ,''  , 'firmas2@pinosxxi.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'pinos03'),
	T_TIPO_DATA('1', '20253228A' 	,'YN37Pv' 	,'LUZ'  ,'SÁNCHEZ'  ,'MAQUEDA'  , 'lsanchez@grupogf.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'ogf03'),
	T_TIPO_DATA('1', '03461780G' 	,'43P>9$' 	,'GEMA'  ,'HERRERO'  ,'DIEZ'  , 'gherrero@grupogf.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'ogf03'),
	T_TIPO_DATA('1', '50861491G' 	,'5BQY6+' 	,'REBECA'  ,'ASENJO'  ,'HERNANZ'  , 'rasenjo@grupogf.es'  ,'0'  ,'GESTIAFORM'   ,'GESTORIAFORM',   'ogf03'),
-- Gestoría PDV
	T_TIPO_DATA('1', '44904379F' 	,'4@77Gs' 	,'PABLO'  ,'SIERRA'  ,'FUENTES'  , 'psierra@grupogf.es'  ,'0'  ,'GESTOPDV'   ,'GESTOPDV',   'GESTOPDV'),
	T_TIPO_DATA('1', '41558133N' 	,'Det12JA' 	,'ANGEL'  ,'NIETO'  ,'RODRIGUEZ'  , 'anieto@grupogf.es'  ,'0'  ,'GESTOPDV'   ,'GESTOPDV',   'GESTOPDV'),
	T_TIPO_DATA('1', 'Y3741385N' 	,'Y5k!Qd' 	,'MICHAEL'  ,'GUARNACCIA'  ,''  , 'mguarn@grupogf.es'  ,'0'  ,'GESTOPDV'   ,'GESTOPDV',   'GESTOPDV'),
-- CALIDAD
	T_TIPO_DATA('1', 'falves' 		,'DZgL4J' 	,'Fernando Alves Soriano '  ,''  ,''  , 'falves@haya.es'  ,'0'  ,'HAYACAL'  ,'REMCAL',   null),
	T_TIPO_DATA('1', 'mavazquez' 	,'4TY?&g' 	,'Maria Angeles Vazquez Jandula'  ,''  ,''  , 'mavazquez@haya.es'  ,'0'  ,'HAYACAL'  ,'REMCAL',   null),
	T_TIPO_DATA('1', 'schacon' 		,'%4$YgN' 	,'Sonia Chacon Segovia '  ,''  ,''  , 'schacon@externos.haya.es'  ,'0'  ,'HAYACAL'  ,'REMCAL',   null),
	T_TIPO_DATA('1', 'mandujar' 	,'B8&+K6' 	,'Maria Andujar Gonzalez '  ,''  ,''  , 'mandujar@externos.haya.es'  ,'0'  ,'HAYACAL'  ,'REMCAL',   null),
	T_TIPO_DATA('1', 'mmarquis' 	,'HsBv8+' 	,'MARCELA'  ,'MARQUIS'  ,''  , 'mmarquis@haya.es'  ,'0'  ,'HAYACAL'  ,'REMCAL',   null),
-- IT
	T_TIPO_DATA('1', 'hvictor' 		,'23hAT$' 	,'HECTOR'  ,'VICTOR'  ,'RODERO'  , 'hvictor@haya.es'  ,'0'  ,'HAYASUPER'  ,'REMSUPER',   null),
	T_TIPO_DATA('1', 'ilorenzo' 	,'U7PQR>' 	,'ISMAEL LORENZO DE LA ORDEN'  ,''  ,''  , 'ilorenzo@haya.es'  ,'0'  ,'HAYASUPER'  ,'REMSUPER',   null),
	T_TIPO_DATA('1', 'jmg' 			,'QU3$3#' 	,'JUAN MANUEL MONTERDE GIMENO'  ,''  ,''  , 'jmg@haya.es'  ,'0'  ,'HAYASUPER'  ,'REMSUPER',   null),
	T_TIPO_DATA('1', 'jpoyatos' 	,'rC3ME?' 	,'JUAN FRANCISCO POYATOS PÉREZ'  ,''  ,''  , 'jpoyatos@haya.es'  ,'0'  ,'HAYASUPER'  ,'REMSUPER',   null),
	T_TIPO_DATA('1', 'ngeneroso' 	,'L@CA#4' 	,'NICOLAS'  ,'GENEROSO'  ,'BARAJAS'  , 'ngeneroso@haya.es'  ,'0'  ,'HAYASUPER'  ,'REMSUPER',   null),
	T_TIPO_DATA('1', 'pcarpio' 		,'682$Sh' 	,'PILAR'  ,'CARPIO'  ,'LOBO'  , 'pcarpio@haya.es'  ,'0'  ,'HAYASUPER'  ,'REMSUPER',   null),
	T_TIPO_DATA('1', 'sdiaz' 		,'5>$3Ug' 	,'SILVIA MARIA DIAZ FERNANDEZ'  ,''  ,''  , 'sdiaz@haya.es'  ,'0'  ,'HAYASUPER'  ,'REMSUPER',   null),
--BANKIA - SOLO CONSULTA
	T_TIPO_DATA('1', 'A104218' 		,'N7NQ&f' 	,'JUAN'  ,'MARDOMINGO'  ,'HIGUERA'  , 'email@email.es'  ,'0'  ,'HAYACONSU'  ,null,   null),
	T_TIPO_DATA('1', 'A133647' 		,'7$y%Q8' 	,'ÁNGEL MANUEL PÉREZ ROMERO'  ,''  ,''  , 'email@email.es'  ,'0'  ,'HAYACONSU'  ,null,   null),
	T_TIPO_DATA('1', 'A107592' 		,'KgB+5W' 	,'FERNANDO'  ,'MAESO'  ,'DÍAZ'  , 'email@email.es'  ,'0'  ,'HAYACONSU'  ,null,   null),
	T_TIPO_DATA('1', 'A112826' 		,'F7%zCd' 	,'JESÚS'  ,'BRAVO'  ,'FERNÁNDEZ'  , 'email@email.es'  ,'0'  ,'HAYACONSU'  ,null,   null),
	T_TIPO_DATA('1', 'A149429' 		,'9y#4>D' 	,'MERCEDES'  ,'GOMEZ'  ,'APARICIO'  , 'email@email.es'  ,'0'  ,'HAYACONSU'  ,null,   null),
	T_TIPO_DATA('1', 'A139239' 		,'>M3?Dq' 	,'ÁNGEL MOYA RUIZ - GÁLVEZ '  ,''  ,''  , 'email@email.es'  ,'0'  ,'HAYACONSU'  ,null,   null),
	T_TIPO_DATA('1', 'A142651' 		,'X4?B7Z' 	,'FRANCISCO JAVIER CABALLERO RODRÍGUEZ'  ,''  ,''  , 'email@email.es'  ,'0'  ,'HAYACONSU'  ,null,   null),
	T_TIPO_DATA('1', 'A157097' 		,'t+64G8' 	,'CELESTE'  ,'ESPLÁ'  ,'SÁNCHEZ'  , 'email@email.es'  ,'0'  ,'HAYACONSU'  ,null,   null),
	T_TIPO_DATA('1', 'A158559' 		,'&E9sP6' 	,'JORDI'  ,'BANÚS'  ,'MORERA'  , 'email@email.es'  ,'0'  ,'HAYACONSU'  ,null,   null),
	T_TIPO_DATA('1', 'A146605' 		,'bV>Y78' 	,'MANUELA'  ,'JIMENEZ'  ,'BELLÓN'  , 'email@email.es'  ,'0'  ,'HAYACONSU'  ,null,   null),
	T_TIPO_DATA('1', 'A140010' 		,'$G85?8' 	,'FERNANDO'  ,'PÉREZ'  ,'MATAMOROS'  , 'email@email.es'  ,'0'  ,'HAYACONSU'  ,null,   null),
	T_TIPO_DATA('1', 'A154192' 		,'LH3AA4' 	,'MARTA'  ,'PASCUAL'  ,'RUIZ'  , 'email@email.es'  ,'0'  ,'HAYACONSU'  ,null,   null),
	T_TIPO_DATA('1', 'A119078' 		,'5KkM?e' 	,'MIRYAM'  ,'CARMENA'  ,'SÁNCHEZ'  , 'email@email.es'  ,'0'  ,'HAYACONSU'  ,null,   null),
	T_TIPO_DATA('1', 'A154469' 		,'3S@ydg' 	,'NOELIA CEA PASTRANA '  ,''  ,''  , 'email@email.es'  ,'0'  ,'HAYACONSU'  ,null,   null),
	T_TIPO_DATA('1', 'A161213' 		,'6Xsn?6' 	,'OSCAR'  ,'PASTOR'  ,'LÁZARO'  , 'email@email.es'  ,'0'  ,'HAYACONSU'  ,null,   null)

  ); 
  V_TMP_TIPO_DATA T_TIPO_DATA;
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');


 
   -- LOOP para insertar los valores en USU_USUARIOS, ZON_PEF_USU Y USD_USUARIOS_DESPACHOS -----------------------------------------------------------------
   FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
     LOOP
    
       V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
       -------------------------------------------------
       --Comprobamos el dato a insertar en usu_usuario--
       -------------------------------------------------
       
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USU_USUARIOS ');
       
       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       
       --Si existe no se modifica
       IF V_NUM_TABLAS > 0 THEN				         
			
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USU_USUARIOS...no se modifica nada.');
			
       ELSE
     
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' EN USU_USUARIOS');   
        
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_USU_USUARIOS.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.USU_USUARIOS (' ||
                      'USU_ID,
                       ENTIDAD_ID,
                       USU_USERNAME,
                       USU_PASSWORD,
                       USU_NOMBRE,
                       USU_APELLIDO1,
                       USU_APELLIDO2,
                       USU_MAIL,
                       USU_GRUPO,
                       USU_FECHA_VIGENCIA_PASS,
                       USUARIOCREAR,
                       FECHACREAR,
                       BORRADO) ' ||
                      'SELECT '|| V_ID || ',
                      '|| TRIM(V_TMP_TIPO_DATA(1)) ||',
                      '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(4)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(5)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(6)) ||''',
                      '''|| TRIM(V_TMP_TIPO_DATA(7)) ||''',
                      '|| TRIM(V_TMP_TIPO_DATA(8)) ||',
                      SYSDATE+730,
                      ''HREOS-1683'',
                      SYSDATE,
                      0 
                      FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' INSERTADO CORRECTAMENTE EN USU_USUARIOS');
      
       END IF;
       
       -------------------------------------------------
       --Comprobamos el dato a insertar en zon_pef_usu--
       -------------------------------------------------
        
       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ZON_PEF_USU '); 
        
       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_PEF_USU WHERE PEF_ID = 
						(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(9))||''') 
							AND USU_ID = 
								(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''')';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
		-- Si existe no se modifica
		IF V_NUM_TABLAS > 0 THEN	  
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ZON_PEF_USU...no se modifica nada.');
			
		ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' EN ZON_PEF_USU');
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU' ||
					' (ZPU_ID, ZON_ID, PEF_ID, USU_ID, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT '||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL,' ||
					' (SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''REM''),' ||
					' (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(9))||'''),' ||
					' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),' ||
					' ''HREOS-1683'',
					SYSDATE,
					0 
					FROM DUAL';
		   	
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' INSERTADO CORRECTAMENTE EN ZON_PEF_USU');
			
		END IF;
		
	   ------------------------------------------------------------
       --Comprobamos el dato a insertar en usd_usuarios_despachos--
       ------------------------------------------------------------
       IF V_TMP_TIPO_DATA(10) IS NULL THEN
       		DBMS_OUTPUT.PUT_LINE('[INFO]: NO INSERTA EN USUARIOS_DESPACHOS');
       ELSE
       
	       DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USD_USUARIOS_DESPACHOS ');
	       
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS 
				WHERE DES_ID = 
					(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO 
					WHERE DES_DESPACHO = '''||TRIM(V_TMP_TIPO_DATA(10))||''') 
					AND USU_ID = 
						(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS 
						WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
				
			-- Si existe no se modifica
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS...no se modifica nada.');
				
			ELSE
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' EN USD_USUARIOS_DESPACHOS');
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS' ||
						' (USD_ID, DES_ID, USU_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR, BORRADO)' || 
						' SELECT '||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL,' ||
						' (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = '''||TRIM(V_TMP_TIPO_DATA(10))||'''),' ||							
						' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),' ||
						' 1,1,''HREOS-1683'',SYSDATE,0 FROM DUAL';
			  	
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' INSERTADO CORRECTAMENTE EN USD_USUARIOS_DESPACHOS');
				
			END IF;	
		END IF;
		
	   ---------------------------------------------------------
       --Comprobamos el dato a insertar en gru_grupos_usuarios--
       ---------------------------------------------------------
       
		IF V_TMP_TIPO_DATA(11) IS NULL THEN
			DBMS_OUTPUT.PUT_LINE('[INFO]: NO INSERTA EN GRUPOS ');
		ELSE
	       	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN GRU_GRUPOS_USUARIOS ');	
		   
			V_SQL := '
			SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS
			WHERE USU_ID_USUARIO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''')
			AND USU_ID_GRUPO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(11))||''')
			'
			;
			
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe no se modifica
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.GRU_GRUPOS_USUARIOS...no se modifica nada.');
				
			ELSE
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' EN GRU_GRUPOS_USUARIOS');
			
			V_MSQL := '
			INSERT INTO '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS
				(GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO, USUARIOCREAR, FECHACREAR, BORRADO) 
				SELECT '||V_ESQUEMA_M||'.S_GRU_GRUPOS_USUARIOS.NEXTVAL,
				(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(11))||'''),
				(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),
				''HREOS-1683'',
				SYSDATE,
				0 
				FROM DUAL
			'
			;
				
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' INSERTADO CORRECTAMENTE EN GRU_GRUPOS_USUARIOS.. en GRUPO: '|| TRIM(V_TMP_TIPO_DATA(11)));
				
			END IF;
		END IF;
	   
	   -- Solo para perfiles consulta, y como caso específico, solo se aplica para usuarios BANKIA.
	   IF V_TMP_TIPO_DATA(9) = 'HAYACONSU' THEN
	   
	   		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN UCA_USUARIO_CARTERA ');
	       
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.UCA_USUARIO_CARTERA 
				WHERE USU_ID = 
				(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
				
			-- Si existe no se modifica
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.UCA_USUARIO_CARTERA...no se modifica nada.');
				
			ELSE
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' EN UCA_USUARIO_CARTERA');
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.UCA_USUARIO_CARTERA' ||
							' (UCA_ID, USU_ID, DD_CRA_ID)' || 
							' SELECT '||V_ESQUEMA||'.S_UCA_USUARIO_CARTERA.NEXTVAL,' ||
							' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),' ||
							' (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''03'')' ||
							' FROM DUAL';
			  	
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' INSERTADO CORRECTAMENTE EN UCA_USUARIO_CARTERA');
				
			END IF;	
	   
	   END IF;
	   
	   DBMS_OUTPUT.PUT_LINE('');
       
    END LOOP;
    
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO ACTUALIZADO CORRECTAMENTE ');
 

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
