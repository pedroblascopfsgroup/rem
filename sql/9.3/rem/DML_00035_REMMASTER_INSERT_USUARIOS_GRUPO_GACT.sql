--/*
--###########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5874
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de relaciones Grupos-Usuarios REM
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
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-5874'; -- USUARIO CREAR/MODIFICAR
    V_TABLA VARCHAR2(50 CHAR) := 'GRU_GRUPOS_USUARIOS';
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;

    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(

	T_FUNCION( 'grupgact' , 'soporteGAC'),
	T_FUNCION( 'grupgact' , 'agonzaleza'),
	T_FUNCION( 'grupgact' , 'mtl'),
	T_FUNCION( 'grupgact' , 'jtamarit'),
	T_FUNCION( 'grupgact' , 'amanzano'),
	T_FUNCION( 'grupgact' , 'eluqu'),
	T_FUNCION( 'grupgact' , 'aalonsos'),
	T_FUNCION( 'grupgact' , 'iramal'),
	T_FUNCION( 'grupgact' , 'langel'),
	T_FUNCION( 'grupgact' , 'lpena'),
	T_FUNCION( 'grupgact' , 'mgimenez'),
	T_FUNCION( 'grupgact' , 'mlopezo'),
	T_FUNCION( 'grupgact' , 'texposito'),
	T_FUNCION( 'grupgact' , 'vmaldonado'),
	T_FUNCION( 'grupgact' , 'jberenguerx'),
	T_FUNCION( 'grupgact' , 'mcanton'),
	T_FUNCION( 'grupgact' , 'ndelaossa'),
	T_FUNCION( 'grupgact' , 'rdl'),
	T_FUNCION( 'grupgact' , 'rdura'),
	T_FUNCION( 'grupgact' , 'mgarciade'),
	T_FUNCION( 'grupgact' , 'mgodoy'),
	T_FUNCION( 'grupgact' , 'rguirado'),
	T_FUNCION( 'grupgact' , 'ckuhnel'),
	T_FUNCION( 'grupgact' , 'cmorales'),
	T_FUNCION( 'grupgact' , 'morandeira'),
	T_FUNCION( 'grupgact' , 'gmoreno'),
	T_FUNCION( 'grupgact' , 'jlpelaz'),
	T_FUNCION( 'grupgact' , 'mperez'),
	T_FUNCION( 'grupgact' , 'aruiz'),
	T_FUNCION( 'grupgact' , 'cserrano'),
	T_FUNCION( 'grupgact' , 'mriquelme'),
	T_FUNCION( 'grupgact' , 'mcarmona'),
	T_FUNCION( 'grupgact' , 'mhernandez'),
	T_FUNCION( 'grupgact' , 'iperezm'),
	T_FUNCION( 'grupgact' , 'ibenedito'),
	T_FUNCION( 'grupgact' , 'sflores'),
	T_FUNCION( 'grupgact' , 'jbadia'),
	T_FUNCION( 'grupgact' , 'mgomezp'),
	T_FUNCION( 'grupgact' , 'pagudo'),
	T_FUNCION( 'grupgact' , 'adelaroja'),
	T_FUNCION( 'grupgact' , 'inieto'),
	T_FUNCION( 'grupgact' , 'jtorresr'),
	T_FUNCION( 'grupgact' , 'colivares'),
	T_FUNCION( 'grupgact' , 'acasado'),
	T_FUNCION( 'grupgact' , 'bgonzalezn'),
	T_FUNCION( 'grupgact' , 'bcarrascos'),
	T_FUNCION( 'grupgact' , 'csalazar'),
	T_FUNCION( 'grupgact' , 'csalvador'),
	T_FUNCION( 'grupgact' , 'amp'),
	T_FUNCION( 'grupgact' , 'enavarro'),
	T_FUNCION( 'grupgact' , 'fllorente'),
	T_FUNCION( 'grupgact' , 'iba'),
	T_FUNCION( 'grupgact' , 'jcook'),
	T_FUNCION( 'grupgact' , 'jalmaida'),
	T_FUNCION( 'grupgact' , 'jpalazon'),
	T_FUNCION( 'grupgact' , 'mizquierdo'),
	T_FUNCION( 'grupgact' , 'esanchism'),
	T_FUNCION( 'grupgact' , 'ogv'),
	T_FUNCION( 'grupgact' , 'mtm'),
	T_FUNCION( 'grupgact' , 'msanchezd'),
	T_FUNCION( 'grupgact' , 'A164854'),
	T_FUNCION( 'grupgact' , 'ogf.gherrero'),
	T_FUNCION( 'grupgact' , 'naparicio'),
	T_FUNCION( 'grupgact' , 'purquiza'),
	T_FUNCION( 'grupgact' , 'pbrisa'),
	T_FUNCION( 'grupgact' , 'smoreno'),
	T_FUNCION( 'grupgact' , 'A149608'),
	T_FUNCION( 'grupgact' , 'A167191'),
	T_FUNCION( 'grupgact' , 'A174151'),
	T_FUNCION( 'grupgact' , 'A167150'),
	T_FUNCION( 'grupgact' , 'A168192'),
	T_FUNCION( 'grupgact' , 'A173059'),
	T_FUNCION( 'grupgact' , 'A174309'),
	T_FUNCION( 'grupgact' , 'rpavon'),
	T_FUNCION( 'grupgact' , 'rsastre'),
	T_FUNCION( 'grupgact' , 'amonge'),
	T_FUNCION( 'grupgact' , 'ifernandez'),
	T_FUNCION( 'grupgact' , 'lgonzalezm'),
	T_FUNCION( 'grupgact' , 'sbejarano'),
	T_FUNCION( 'grupgact' , 'mblascop'),
	T_FUNCION( 'grupgact' , 'mmorandeira'),
	T_FUNCION( 'grupgact' , 'mmorenod'),
	T_FUNCION( 'grupgact' , 'A148400'),
	T_FUNCION( 'grupgact' , 'A167832'),
	T_FUNCION( 'grupgact' , 'A169425'),
	T_FUNCION( 'grupgact' , 'A169803'),
	T_FUNCION( 'grupgact' , 'A170683'),
	T_FUNCION( 'grupgact' , 'A175931'),
	T_FUNCION( 'grupgact' , 'arodriguezh'),
	T_FUNCION( 'grupgact' , 'cmunozf'),
	T_FUNCION( 'grupgact' , 'lnestar'),
	T_FUNCION( 'grupgact' , 'mmorales'),
	T_FUNCION( 'grupgact' , 'mpaniagua'),
	T_FUNCION( 'grupgact' , 'mvillamor'),
	T_FUNCION( 'grupgact' , 'pfernandezm'),
	T_FUNCION( 'grupgact' , 'rcervantesi'),
	T_FUNCION( 'grupgact' , 'usugruhpm'),
	T_FUNCION( 'grupgact' , 'mdevivero'),
	T_FUNCION( 'grupgact' , 'rcanales'),
	T_FUNCION( 'grupgact' , 'rlozano'),
	T_FUNCION( 'grupgact' , 'usugengac'),
	T_FUNCION( 'grupgact' , 'A169696'),
	T_FUNCION( 'grupgact' , 'A174226'),
	T_FUNCION( 'grupgact' , 'A170678'),
	T_FUNCION( 'grupgact' , 'A171051'),
	T_FUNCION( 'grupgact' , 'A173061'),
	T_FUNCION( 'grupgact' , 'A174027'),
	T_FUNCION( 'grupgact' , 'afernandezdu'),
	T_FUNCION( 'grupgact' , 'prodriguezdelema'),
	T_FUNCION( 'grupgact' , 'A162883'),
	T_FUNCION( 'grupgact' , 'A167195'),
	T_FUNCION( 'grupgact' , 'A168756'),
	T_FUNCION( 'grupgact' , 'A174310'),
	T_FUNCION( 'grupgact' , 'A175830'),
	T_FUNCION( 'grupgact' , 'A176407'),
	T_FUNCION( 'grupgact' , 'A117897'),
	T_FUNCION( 'grupgact' , 'A162833'),
	T_FUNCION( 'grupgact' , 'A167125'),
	T_FUNCION( 'grupgact' , 'A169165'),
	T_FUNCION( 'grupgact' , 'A170799'),
	T_FUNCION( 'grupgact' , 'A173060'),
	T_FUNCION( 'grupgact' , 'A175556'),
	T_FUNCION( 'grupgact' , 'dgarciaa'),
	T_FUNCION( 'grupgact' , 'mortegaa'),
	T_FUNCION( 'grupgact' , 'rtalavera'),
	T_FUNCION( 'grupgact' , 'phuerta'),
	T_FUNCION( 'grupgact' , 'malonso'),
	T_FUNCION( 'grupgact' , 'SOP_HAYAGESACT'),
	T_FUNCION( 'grupgact' , 'bcarrascosa'),
	T_FUNCION( 'grupgact' , 'idomingo'),
	T_FUNCION( 'grupgact' , 'bcarrasco'),
	T_FUNCION( 'grupgact' , 'mescribano'),
	T_FUNCION( 'grupgact' , 'dmercado'),
	T_FUNCION( 'grupgact' , 'aalvear'),
	T_FUNCION( 'grupgact' , 'asantos'),
	T_FUNCION( 'grupgact' , 'iplaza'),
	T_FUNCION( 'grupgact' , 'acabello'),
	T_FUNCION( 'grupgact' , 'maparicio'),
	T_FUNCION( 'grupgact' , 'maranda'),
	T_FUNCION( 'grupgact' , 'A164780'),
	T_FUNCION( 'grupgact' , 'omartinezs'),
	T_FUNCION( 'grupgact' , 'tdiez'),
	T_FUNCION( 'grupgact' , 'fsanchez'),
	T_FUNCION( 'grupgact' , 'sreal'),
	T_FUNCION( 'grupgact' , 'rbarroso'),
	T_FUNCION( 'grupgact' , 'tgualix'),
	T_FUNCION( 'grupgact' , 'ssalazar'),
	T_FUNCION( 'grupgact' , 'jsanmartint'),
	T_FUNCION( 'grupgact' , 'egomez'),
	T_FUNCION( 'grupgact' , 'tmorena'),
	T_FUNCION( 'grupgact' , 'jramirezf'),
	T_FUNCION( 'grupgact' , 'agasion'),
	T_FUNCION( 'grupgact' , 'iobregon'),
	T_FUNCION( 'grupgact' , 'csanchezbu'),
	T_FUNCION( 'grupgact' , 'amarcosb'),
	T_FUNCION( 'grupgact' , 'ecasis'),
	T_FUNCION( 'grupgact' , 'aballesteros'),
	T_FUNCION( 'grupgact' , 'mpassardi'),
	T_FUNCION( 'grupgact' , 'scalzado'),
	T_FUNCION( 'grupgact' , 'selena'),
	T_FUNCION( 'grupgact' , 'mgonzaleze'),
	T_FUNCION( 'grupgact' , 'cmartinc'),
	T_FUNCION( 'grupgact' , 'pbadial'),
	T_FUNCION( 'grupgact' , 'irodriguez'),
	T_FUNCION( 'grupgact' , 'imartinr'),
	T_FUNCION( 'grupgact' , 'arueda'),
	T_FUNCION( 'grupgact' , 'mblat'),
	T_FUNCION( 'grupgact' , 'vcastillo'),
	T_FUNCION( 'grupgact' , 'lrubio'),
	T_FUNCION( 'grupgact' , 'gmorenog'),
	T_FUNCION( 'grupgact' , 'bgonzalezm'),
	T_FUNCION( 'grupgact' , 'lramos'),
	T_FUNCION( 'grupgact' , 'gmurcia'),
	T_FUNCION( 'grupgact' , 'cdiazplaza'),
	T_FUNCION( 'grupgact' , 'valfonso'),
	T_FUNCION( 'grupgact' , 'rejarque'),
	T_FUNCION( 'grupgact' , 'imorillo'),
	T_FUNCION( 'grupgact' , 'sdelgado'),
	T_FUNCION( 'grupgact' , 'log.cluna'),
	T_FUNCION( 'grupgact' , 'log.pcostas'),
	T_FUNCION( 'grupgact' , 'asanchezm'),
	T_FUNCION( 'grupgact' , 'dortiz'),
	T_FUNCION( 'grupgact' , 'ele.rgutierrez'),
	T_FUNCION( 'grupgact' , 'esanzm '),
	T_FUNCION( 'grupgact' , 'malvarezp'),
	T_FUNCION( 'grupgact' , 'rrojas'),
	T_FUNCION( 'grupgact' , 'dcontra'),
	T_FUNCION( 'grupgact' , 'jjordan'),
	T_FUNCION( 'grupgact' , 'mzevallos'),
	T_FUNCION( 'grupgact' , 'dnieto'),
	T_FUNCION( 'grupgact' , 'log.griascos'),
	T_FUNCION( 'grupgact' , 'log.egarcia'),
	T_FUNCION( 'grupgact' , 'log.yaraujo'),
	T_FUNCION( 'grupgact' , 'buk.mrubio'),
	T_FUNCION( 'grupgact' , 'buk.pmorcillo'),
	T_FUNCION( 'grupgact' , 'buk.aheredero'),
	T_FUNCION( 'grupgact' , 'buk.ariveiro'),
	T_FUNCION( 'grupgact' , 'buk.agonzalez'),
	T_FUNCION( 'grupgact' , 'jsantosp'),
	T_FUNCION( 'grupgact' , 'jjimenezg'),
	T_FUNCION( 'grupgact' , 'ademier'),
	T_FUNCION( 'grupgact' , 'jtellov'),
	T_FUNCION( 'grupgact' , 'all.msanchez'),
	T_FUNCION( 'grupgact' , 'sprada'),
	T_FUNCION( 'grupgact' , 'gestalq'),
	T_FUNCION( 'grupgact' , 'gestedi'),
	T_FUNCION( 'grupgact' , 'gestsue'),
	T_FUNCION( 'grupgact' , 'elorente'),
	T_FUNCION( 'grupgact' , 'jdiazp'),
	T_FUNCION( 'grupgact' , 'ealonso'),
	T_FUNCION( 'grupgact' , 'barana'),
	T_FUNCION( 'grupgact' , 'ele.ndiaz'),
	T_FUNCION( 'grupgact' , 'ogf.sdiaz'),
	T_FUNCION( 'grupgact' , 'ogf.mamich'),
	T_FUNCION( 'grupgact' , 'ele.jgarcia'),
	T_FUNCION( 'grupgact' , 'gsanchezs'),
	T_FUNCION( 'grupgact' , 'smutis'),
	T_FUNCION( 'grupgact' , 'ext.aalcantara'),
	T_FUNCION( 'grupgact' , 'rlamas'),
	T_FUNCION( 'grupgact' , 'ext.orubio'),
	T_FUNCION( 'grupgact' , 'ext.jromero'),
	T_FUNCION( 'grupgact' , 'ext.mbaquero'),
	T_FUNCION( 'grupgact' , 'ext.jgimeno'),
	T_FUNCION( 'grupgact' , 'ycardo'),
	T_FUNCION( 'grupgact' , 'ext.avazquez'),
	T_FUNCION( 'grupgact' , 'ext.cmontero'),
	T_FUNCION( 'grupgact' , 'ext.dballester'),
	T_FUNCION( 'grupgact' , 'ext.cbarea'),
	T_FUNCION( 'grupgact' , 'ext.pgarciam'),
	T_FUNCION( 'grupgact' , 'aguirre.jcastejon'),
	T_FUNCION( 'grupgact' , 'jsanesteban'),
	T_FUNCION( 'grupgact' , 'pdominguezs'),
	T_FUNCION( 'grupgact' , 'ext.acaro'),
	T_FUNCION( 'grupgact' , 'ext.jmunoz'),
	T_FUNCION( 'grupgact' , 'ext.morzaez'),
	T_FUNCION( 'grupgact' , 'mrial'),
	T_FUNCION( 'grupgact' , 'slabarga'),
	T_FUNCION( 'grupgact' , 'ext.rborondo'),
	T_FUNCION( 'grupgact' , 'hbarbado'),
	T_FUNCION( 'grupgact' , 'rruiz'),
	T_FUNCION( 'grupgact' , 'ext.ravila'),
	T_FUNCION( 'grupgact' , 'ext.clopezb'),
	T_FUNCION( 'grupgact' , 'alombardi'),
	T_FUNCION( 'grupgact' , 'ext.amuntanola'),
	T_FUNCION( 'grupgact' , 'ext.storreblanca'),
	T_FUNCION( 'grupgact' , 'ext.yescribano'),
	T_FUNCION( 'grupgact' , 'ext.vbenalcazar'),
	T_FUNCION( 'grupgact' , 'ele.cguillen'),
	T_FUNCION( 'grupgact' , 'ele.jrepulles'),
	T_FUNCION( 'grupgact' , 'odelatorre'),
	T_FUNCION( 'grupgact' , 'amartinl'),
	T_FUNCION( 'grupgact' , 'lsalmeron'),
	T_FUNCION( 'grupgact' , 'ext.lmena'),
	T_FUNCION( 'grupgact' , 'ext.aaznar'),
	T_FUNCION( 'grupgact' , 'igarcial'),
	T_FUNCION( 'grupgact' , 'jvilar'),
	T_FUNCION( 'grupgact' , 'pdemartin'),
	T_FUNCION( 'grupgact' , 'ext.mgarcia'),
	T_FUNCION( 'grupgact' , 'log.pcambronero'),
	T_FUNCION( 'grupgact' , 'log.cramos'),
	T_FUNCION( 'grupgact' , 'jgarridon'),
	T_FUNCION( 'grupgact' , 'sfuentes'),
	T_FUNCION( 'grupgact' , 'mgomezm'),
	T_FUNCION( 'grupgact' , 'ext.jgarciace'),
	T_FUNCION( 'grupgact' , 'ext.lteruel'),
	T_FUNCION( 'grupgact' , 'ext.tperiago'),
	T_FUNCION( 'grupgact' , 'ext.bbarchin'),
	T_FUNCION( 'grupgact' , 'isanchezal'),
	T_FUNCION( 'grupgact' , 'ext.ahernandez'),
	T_FUNCION( 'grupgact' , 'gsanchez'),
	T_FUNCION( 'grupgact' , 'jdelgado'),
	T_FUNCION( 'grupgact' , 'malonsom'),
	T_FUNCION( 'grupgact' , 'jmartinm'),
	T_FUNCION( 'grupgact' , 'ahernando'),
	T_FUNCION( 'grupgact' , 'surrutia'),
	T_FUNCION( 'grupgact' , 'dperianes'),
	T_FUNCION( 'grupgact' , 'ext.aparamio'),
	T_FUNCION( 'grupgact' , 'ext.dsanchez'),
	T_FUNCION( 'grupgact' , 'ext.fescribano'),
	T_FUNCION( 'grupgact' , 'ext.jreyez'),
	T_FUNCION( 'grupgact' , 'ext.jmartin'),
	T_FUNCION( 'grupgact' , 'ext.jmartinezs'),
	T_FUNCION( 'grupgact' , 'ext.jgonzalezr'),
	T_FUNCION( 'grupgact' , 'ext.jsanchez'),
	T_FUNCION( 'grupgact' , 'ext.jgonzalez'),
	T_FUNCION( 'grupgact' , 'ext.mbarbon'),
	T_FUNCION( 'grupgact' , 'ext.mpedraza'),
	T_FUNCION( 'grupgact' , 'ext.rrodelgo'),
	T_FUNCION( 'grupgact' , 'dpaez'),
	T_FUNCION( 'grupgact' , 'anano'),
	T_FUNCION( 'grupgact' , 'tsuarez'),
	T_FUNCION( 'grupgact' , 'msancho'),
	T_FUNCION( 'grupgact' , 'rberceruelo'),
	T_FUNCION( 'grupgact' , 'ext.jruiz'),
	T_FUNCION( 'grupgact' , 'ext.csanchezc'),
	T_FUNCION( 'grupgact' , 'ext.agrau'),
	T_FUNCION( 'grupgact' , 'ext.icalvo'),
	T_FUNCION( 'grupgact' , 'ext.cmoreno'),
	T_FUNCION( 'grupgact' , 'ext.sfalces'),
	T_FUNCION( 'grupgact' , 'ext.dmasip'),
	T_FUNCION( 'grupgact' , 'ext.amurcia'),
	T_FUNCION( 'grupgact' , 'ext.osantos'),
	T_FUNCION( 'grupgact' , 'ext.csoledad'),
	T_FUNCION( 'grupgact' , 'ext.lrodriguezn'),
	T_FUNCION( 'grupgact' , 'ext.eesquefa'),
	T_FUNCION( 'grupgact' , 'ext.eadolf'),
	T_FUNCION( 'grupgact' , 'ext.ncastillo'),
	T_FUNCION( 'grupgact' , 'ext.aquerol'),
	T_FUNCION( 'grupgact' , 'ext.jcastro'),
	T_FUNCION( 'grupgact' , 'ext.acale'),
	T_FUNCION( 'grupgact' , 'ext.apradillo'),
	T_FUNCION( 'grupgact' , 'ext.abarrera'),
	T_FUNCION( 'grupgact' , 'ele.jgarciav'),
	T_FUNCION( 'grupgact' , 'ele.jgil'),
	T_FUNCION( 'grupgact' , 'ext.eleon'),
	T_FUNCION( 'grupgact' , 'ext.prequejo'),
	T_FUNCION( 'grupgact' , 'jmoralesv'),
	T_FUNCION( 'grupgact' , 'jparrar'),
	T_FUNCION( 'grupgact' , 'ext.mmegias'),
	T_FUNCION( 'grupgact' , 'jizquierdo'),
	T_FUNCION( 'grupgact' , 'ext.agarrote'),
	T_FUNCION( 'grupgact' , 'ext.cpedreira'),
	T_FUNCION( 'grupgact' , 'ext.esanchez'),
	T_FUNCION( 'grupgact' , 'ext.ovillar'),
	T_FUNCION( 'grupgact' , 'ext.igomez'),
	T_FUNCION( 'grupgact' , 'ext.afransitorra'),
	T_FUNCION( 'grupgact' , 'ext.cdominguez'),
	T_FUNCION( 'grupgact' , 'spizarro'),
	T_FUNCION( 'grupgact' , 'ext.iramos'),
	T_FUNCION( 'grupgact' , 'ext.mbastus'),
	T_FUNCION( 'grupgact' , 'ext.asanz'),
	T_FUNCION( 'grupgact' , 'ext.rperis'),
	T_FUNCION( 'grupgact' , 'jredondo'),
	T_FUNCION( 'grupgact' , 'ext.mjperez'),
	T_FUNCION( 'grupgact' , 'ext.ljimenez'),
	T_FUNCION( 'grupgact' , 'ext.jstrachan'),
	T_FUNCION( 'grupgact' , 'ext.vgonzalez'),
	T_FUNCION( 'grupgact' , 'ext.lmartinez'),
	T_FUNCION( 'grupgact' , 'jcastro'),
	T_FUNCION( 'grupgact' , 'belencale'),
	T_FUNCION( 'grupgact' , 'arcaballero'),
	T_FUNCION( 'grupgact' , 'ext.erodriguezo'),
	T_FUNCION( 'grupgact' , 'ele.mmarti'),
	T_FUNCION( 'grupgact' , 'ico.mcanado'),
	T_FUNCION( 'grupgact' , 'ext.agonzalezr'),
	T_FUNCION( 'grupgact' , 'ext.mllontop'),
	T_FUNCION( 'grupgact' , 'ext.igutierrez'),
	T_FUNCION( 'grupgact' , 'ext.mgarciag')

    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ZON_PEF_USU -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);

		V_SQL := 'SELECT count(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||''' ';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS > 0 THEN
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' 
						WHERE USU_ID_GRUPO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||''') 
							AND USU_ID_USUARIO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||''')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS_2;
			
			-- Si existe la FILA
			IF V_NUM_TABLAS_2 > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA_M||'.'||V_TABLA||' ...no se modifica nada.');
				
			ELSE
				V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TABLA||'' ||
							' (GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
							' SELECT '||V_ESQUEMA_M||'.S_'||V_TABLA||'.NEXTVAL' ||
							',(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||''')' ||
							',(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||''')' ||
							',0, '''||V_USUARIO||''', SYSDATE, 0 FROM DUAL';
		    	
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA_M||'.'||V_TABLA||' insertados correctamente.');
				
		    END IF;

		ELSE
			DBMS_OUTPUT.PUT_LINE('[ INFO ]: El usuario no existe.');
		END IF;	

      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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
EXIT;
