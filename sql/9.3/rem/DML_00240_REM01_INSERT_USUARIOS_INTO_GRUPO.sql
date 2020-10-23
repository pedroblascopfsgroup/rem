--/*
--##########################################
--## AUTOR=CARLES MOLINS
--## FECHA_CREACION=20201018
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8110
--## PRODUCTO=NO
--##
--## Finalidad: Insertar usuarios a grupo
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
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_TABLA VARCHAR2(50 CHAR) := 'GRU_GRUPOS_USUARIOS';
	
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8110'; -- USUARIO CREAR/MODIFICAR

	TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
	V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
		T_FUNCION( 'grpformgencat' , 'mhernandez'),
		T_FUNCION( 'grpformgencat' , 'tbuendia'),
		T_FUNCION( 'grpformgencat' , 'vgardel'),
		T_FUNCION( 'grpformgencat' , 'A110247'),
		T_FUNCION( 'grpformgencat' , 'A150929'),
		T_FUNCION( 'grpformgencat' , 'A119075'),
		T_FUNCION( 'grpformgencat' , 'colivares'),
		T_FUNCION( 'grpformgencat' , 'egalan'),
		T_FUNCION( 'grpformgencat' , 'emoreno'),
		T_FUNCION( 'grpformgencat' , 'A137858'),
		T_FUNCION( 'grpformgencat' , 'agonzalez'),
		T_FUNCION( 'grpformgencat' , 'agimenez'),
		T_FUNCION( 'grpformgencat' , 'arojasb'),
		T_FUNCION( 'grpformgencat' , 'A110907'),
		T_FUNCION( 'grpformgencat' , 'aabadv'),
		T_FUNCION( 'grpformgencat' , 'A110337'),
		T_FUNCION( 'grpformgencat' , 'azanon'),
		T_FUNCION( 'grpformgencat' , 'alirola'),
		T_FUNCION( 'grpformgencat' , 'amanas'),
		T_FUNCION( 'grpformgencat' , 'agalanp'),
		T_FUNCION( 'grpformgencat' , 'bcanadas'),
		T_FUNCION( 'grpformgencat' , 'A148323'),
		T_FUNCION( 'grpformgencat' , 'cmartinez'),
		T_FUNCION( 'grpformgencat' , 'tch'),
		T_FUNCION( 'grpformgencat' , 'cgalaron'),
		T_FUNCION( 'grpformgencat' , 'cmonterolo'),
		T_FUNCION( 'grpformgencat' , 'dmartin'),
		T_FUNCION( 'grpformgencat' , 'dvalero'),
		T_FUNCION( 'grpformgencat' , 'A110009'),
		T_FUNCION( 'grpformgencat' , 'A164764'),
		T_FUNCION( 'grpformgencat' , 'ebenitezt'),
		T_FUNCION( 'grpformgencat' , 'A010116'),
		T_FUNCION( 'grpformgencat' , 'fclares'),
		T_FUNCION( 'grpformgencat' , 'fllop'),
		T_FUNCION( 'grpformgencat' , 'fcarrasco'),
		T_FUNCION( 'grpformgencat' , 'A113035'),
		T_FUNCION( 'grpformgencat' , 'fyago'),
		T_FUNCION( 'grpformgencat' , 'A106427'),
		T_FUNCION( 'grpformgencat' , 'A105887'),
		T_FUNCION( 'grpformgencat' , 'gcarles'),
		T_FUNCION( 'grpformgencat' , 'iperezf'),
		T_FUNCION( 'grpformgencat' , 'A108228'),
		T_FUNCION( 'grpformgencat' , 'A149182'),
		T_FUNCION( 'grpformgencat' , 'igomezr'),
		T_FUNCION( 'grpformgencat' , 'A120328'),
		T_FUNCION( 'grpformgencat' , 'jgonzalezs'),
		T_FUNCION( 'grpformgencat' , 'jalmaida'),
		T_FUNCION( 'grpformgencat' , 'jrodriguez'),
		T_FUNCION( 'grpformgencat' , 'A138691'),
		T_FUNCION( 'grpformgencat' , 'A164801'),
		T_FUNCION( 'grpformgencat' , 'jaldea'),
		T_FUNCION( 'grpformgencat' , 'joreja_old'),
		T_FUNCION( 'grpformgencat' , 'jespinosam'),
		T_FUNCION( 'grpformgencat' , 'jdella'),
		T_FUNCION( 'grpformgencat' , 'jmatencias'),
		T_FUNCION( 'grpformgencat' , 'A109187'),
		T_FUNCION( 'grpformgencat' , 'A111460'),
		T_FUNCION( 'grpformgencat' , 'jhernandez'),
		T_FUNCION( 'grpformgencat' , 'jsanchezmu_old'),
		T_FUNCION( 'grpformgencat' , 'A134812'),
		T_FUNCION( 'grpformgencat' , 'lmillan'),
		T_FUNCION( 'grpformgencat' , 'lgonzaleze'),
		T_FUNCION( 'grpformgencat' , 'A164829'),
		T_FUNCION( 'grpformgencat' , 'lmontesinos'),
		T_FUNCION( 'grpformgencat' , 'A164704'),
		T_FUNCION( 'grpformgencat' , 'A164862'),
		T_FUNCION( 'grpformgencat' , 'mlopez'),
		T_FUNCION( 'grpformgencat' , 'mpenam'),
		T_FUNCION( 'grpformgencat' , 'mguitart'),
		T_FUNCION( 'grpformgencat' , 'A111404'),
		T_FUNCION( 'grpformgencat' , 'A111909'),
		T_FUNCION( 'grpformgencat' , 'mcumbreras'),
		T_FUNCION( 'grpformgencat' , 'pmorera'),
		T_FUNCION( 'grpformgencat' , 'garsa.rmoya'),
		T_FUNCION( 'grpformgencat' , 'garsa.emartinez'),
		T_FUNCION( 'grpformgencat' , 'gl.alabrador'),
		T_FUNCION( 'grpformgencat' , '0892090J'),
		T_FUNCION( 'grpformgencat' , 'A164814'),
		T_FUNCION( 'grpformgencat' , 'malonsobar'),
		T_FUNCION( 'grpformgencat' , 'A112836'),
		T_FUNCION( 'grpformgencat' , 'iss'),
		T_FUNCION( 'grpformgencat' , 'marcas'),
		T_FUNCION( 'grpformgencat' , 'mpastorg'),
		T_FUNCION( 'grpformgencat' , 'A144169'),
		T_FUNCION( 'grpformgencat' , 'mfabra'),
		T_FUNCION( 'grpformgencat' , 'mganan'),
		T_FUNCION( 'grpformgencat' , 'msanchezf'),
		T_FUNCION( 'grpformgencat' , 'A152847'),
		T_FUNCION( 'grpformgencat' , 'ext.gmolina'),
		T_FUNCION( 'grpformgencat' , 'gl.jmaldonado'),
		T_FUNCION( 'grpformgencat' , 'gl.rgarcia'),
		T_FUNCION( 'grpformgencat' , 'nbertran'),
		T_FUNCION( 'grpformgencat' , 'ocg'),
		T_FUNCION( 'grpformgencat' , 'pmanez'),
		T_FUNCION( 'grpformgencat' , 'A151790'),
		T_FUNCION( 'grpformgencat' , 'ptranche'),
		T_FUNCION( 'grpformgencat' , 'rricot'),
		T_FUNCION( 'grpformgencat' , 'A112648'),
		T_FUNCION( 'grpformgencat' , 'rcf'),
		T_FUNCION( 'grpformgencat' , 'A122788'),
		T_FUNCION( 'grpformgencat' , 'rvazquez'),
		T_FUNCION( 'grpformgencat' , 'rmarin'),
		T_FUNCION( 'grpformgencat' , 'rdelaplaza'),
		T_FUNCION( 'grpformgencat' , 'rmh'),
		T_FUNCION( 'grpformgencat' , 'A164710'),
		T_FUNCION( 'grpformgencat' , 'sbroto'),
		T_FUNCION( 'grpformgencat' , 'ssg'),
		T_FUNCION( 'grpformgencat' , 'sch'),
		T_FUNCION( 'grpformgencat' , 'sulldemolins'),
		T_FUNCION( 'grpformgencat' , 'A125895'),
		T_FUNCION( 'grpformgencat' , 'A148327'),
		T_FUNCION( 'grpformgencat' , 'A148742'),
		T_FUNCION( 'grpformgencat' , 'A166040'),
		T_FUNCION( 'grpformgencat' , 'pfernandezg'),
		T_FUNCION( 'grpformgencat' , 'A144791'),
		T_FUNCION( 'grpformgencat' , 'A152297'),
		T_FUNCION( 'grpformgencat' , 'A111842'),
		T_FUNCION( 'grpformgencat' , 'rdelolmo'),
		T_FUNCION( 'grpformgencat' , 'SOP_HAYAGESTFORM'),
		T_FUNCION( 'grpformgencat' , 'usugegf'),
		T_FUNCION( 'grpformgencat' , 'mmarrero'),
		T_FUNCION( 'grpformgencat' , 'bdiestro'),
		T_FUNCION( 'grpformgencat' , 'ap.scastro'),
		T_FUNCION( 'grpformgencat' , 'ap.mmartinez'),
		T_FUNCION( 'grpformgencat' , 'jcarbonellm'),
		T_FUNCION( 'grpformgencat' , 'achillon'),
		T_FUNCION( 'grpformgencat' , 'prodriguezg'),
		T_FUNCION( 'grpformgencat' , 'gl.alabradorp'),
		T_FUNCION( 'grpformgencat' , 'lmarcos'),
		T_FUNCION( 'grpformgencat' , 'gl.jdelasheras'),
		T_FUNCION( 'grpformgencat' , 'tmorena'),
		T_FUNCION( 'grpformgencat' , 'jramirezf'),
		T_FUNCION( 'grpformgencat' , 'alopezf'),
		T_FUNCION( 'grpformgencat' , 'ap.dgarcia'),
		T_FUNCION( 'grpformgencat' , 'pmoliner'),
		T_FUNCION( 'grpformgencat' , 'vlouzan'),
		T_FUNCION( 'grpformgencat' , 'nrivilla'),
		T_FUNCION( 'grpformgencat' , 'gsantos'),
		T_FUNCION( 'grpformgencat' , 'bdo.cmunoz'),
		T_FUNCION( 'grpformgencat' , 'jdrodriguez'),
		T_FUNCION( 'grpformgencat' , 'ajimenezj'),
		T_FUNCION( 'grpformgencat' , 'ges_mig_LBK'),
		T_FUNCION( 'grpformgencat' , 'rgarvia'),
		T_FUNCION( 'grpformgencat' , 'amateos'),
		T_FUNCION( 'grpformgencat' , 'irodriguez'),
		T_FUNCION( 'grpformgencat' , 'ap.smihailisins'),
		T_FUNCION( 'grpformgencat' , 'bdo.jgomez'),
		T_FUNCION( 'grpformgencat' , 'kmpg.jmedina'),
		T_FUNCION( 'grpformgencat' , 'ap.ljimenez'),
		T_FUNCION( 'grpformgencat' , 'ap.asanz'),
		T_FUNCION( 'grpformgencat' , 'ap.nhurtado'),
		T_FUNCION( 'grpformgencat' , 'bperez'),
		T_FUNCION( 'grpformgencat' , 'bgarcia'),
		T_FUNCION( 'grpformgencat' , 'jmartinezsa'),
		T_FUNCION( 'grpformgencat' , 'buk.alopez'),
		T_FUNCION( 'grpformgencat' , 'buk.svazquezb'),
		T_FUNCION( 'grpformgencat' , 'buk.jtorres'),
		T_FUNCION( 'grpformgencat' , 'buk.mayuso'),
		T_FUNCION( 'grpformgencat' , 'buk.calcala'),
		T_FUNCION( 'grpformgencat' , 'avalerog'),
		T_FUNCION( 'grpformgencat' , 'log.cluna'),
		T_FUNCION( 'grpformgencat' , 'log.pcostas'),
		T_FUNCION( 'grpformgencat' , 'asanchezm'),
		T_FUNCION( 'grpformgencat' , 'bdo.cregatero'),
		T_FUNCION( 'grpformgencat' , 'buk.vpeinado'),
		T_FUNCION( 'grpformgencat' , 'buk.druiz'),
		T_FUNCION( 'grpformgencat' , 'rescuredo'),
		T_FUNCION( 'grpformgencat' , 'mcobo'),
		T_FUNCION( 'grpformgencat' , 'buk.rlopez'),
		T_FUNCION( 'grpformgencat' , 'ap.fdelrio'),
		T_FUNCION( 'grpformgencat' , 'ap.ocarrascal'),
		T_FUNCION( 'grpformgencat' , 'osanz'),
		T_FUNCION( 'grpformgencat' , 'log.griascos'),
		T_FUNCION( 'grpformgencat' , 'log.egarcia'),
		T_FUNCION( 'grpformgencat' , 'log.yaraujo'),
		T_FUNCION( 'grpformgencat' , 'bdo.mpajuelo'),
		T_FUNCION( 'grpformgencat' , 'buk.itrujillo'),
		T_FUNCION( 'grpformgencat' , 'buk.faguera'),
		T_FUNCION( 'grpformgencat' , 'buk.mgomezp'),
		T_FUNCION( 'grpformgencat' , 'buk.agutierrez'),
		T_FUNCION( 'grpformgencat' , 'buk.mcampos'),
		T_FUNCION( 'grpformgencat' , 'buk.mfilereto'),
		T_FUNCION( 'grpformgencat' , 'buk.aloring'),
		T_FUNCION( 'grpformgencat' , 'buk.dvargas'),
		T_FUNCION( 'grpformgencat' , 'jhernandezma'),
		T_FUNCION( 'grpformgencat' , 'mperezg'),
		T_FUNCION( 'grpformgencat' , 'ap.aandrada'),
		T_FUNCION( 'grpformgencat' , 'agonzalezr'),
		T_FUNCION( 'grpformgencat' , 'buk.mvarela'),
		T_FUNCION( 'grpformgencat' , 'nfq.cpastor'),
		T_FUNCION( 'grpformgencat' , 'bdo.pmingorance'),
		T_FUNCION( 'grpformgencat' , 'ran.gsanchis'),
		T_FUNCION( 'grpformgencat' , 'cgarciah'),
		T_FUNCION( 'grpformgencat' , 'ediez'),
		T_FUNCION( 'grpformgencat' , 'lmorillom'),
		T_FUNCION( 'grpformgencat' , 'mgutierrezmo'),
		T_FUNCION( 'grpformgencat' , 'ggandoy'),
		T_FUNCION( 'grpformgencat' , 'arodrigueza'),
		T_FUNCION( 'grpformgencat' , 'ext.mmerlos'),
		T_FUNCION( 'grpformgencat' , 'ext.ajordan'),
		T_FUNCION( 'grpformgencat' , 'acastrol'),
		T_FUNCION( 'grpformgencat' , 'atellor'),
		T_FUNCION( 'grpformgencat' , 'cdiazd'),
		T_FUNCION( 'grpformgencat' , 'cvinets'),
		T_FUNCION( 'grpformgencat' , 'jnavarrom'),
		T_FUNCION( 'grpformgencat' , 'lmunoz'),
		T_FUNCION( 'grpformgencat' , 'mgonzalezv'),
		T_FUNCION( 'grpformgencat' , 'mpena'),
		T_FUNCION( 'grpformgencat' , 'ext.jroldan'),
		T_FUNCION( 'grpformgencat' , 'ext.mgaldeano'),
		T_FUNCION( 'grpformgencat' , 'ext.aromero'),
		T_FUNCION( 'grpformgencat' , 'ext.isaftic'),
		T_FUNCION( 'grpformgencat' , 'ext.mvalverde'),
		T_FUNCION( 'grpformgencat' , 'ext.arodriguezg'),
		T_FUNCION( 'grpformgencat' , 'jsanesteban'),
		T_FUNCION( 'grpformgencat' , 'rpeces'),
		T_FUNCION( 'grpformgencat' , 'scapellan'),
		T_FUNCION( 'grpformgencat' , 'ext.apriego'),
		T_FUNCION( 'grpformgencat' , 'ext.lbarranco'),
		T_FUNCION( 'grpformgencat' , 'ext.amagureanu'),
		T_FUNCION( 'grpformgencat' , 'isanchezmu'),
		T_FUNCION( 'grpformgencat' , 'ext.alopezr'),
		T_FUNCION( 'grpformgencat' , 'ext.dmolina'),
		T_FUNCION( 'grpformgencat' , 'ext.jcrespillo'),
		T_FUNCION( 'grpformgencat' , 'ext.rmonterosi'),
		T_FUNCION( 'grpformgencat' , 'ext.sperezg'),
		T_FUNCION( 'grpformgencat' , 'bdo.jfernandez'),
		T_FUNCION( 'grpformgencat' , 'mguillen'),
		T_FUNCION( 'grpformgencat' , 'nalcibar'),
		T_FUNCION( 'grpformgencat' , 'eperezc'),
		T_FUNCION( 'grpformgencat' , 'ext.asuarez'),
		T_FUNCION( 'grpformgencat' , 'jordonez'),
		T_FUNCION( 'grpformgencat' , 'jroca'),
		T_FUNCION( 'grpformgencat' , 'jsevilla'),
		T_FUNCION( 'grpformgencat' , 'igarcial'),
		T_FUNCION( 'grpformgencat' , 'ext.asaettone'),
		T_FUNCION( 'grpformgencat' , 'ext.cazcona'),
		T_FUNCION( 'grpformgencat' , 'dpereto'),
		T_FUNCION( 'grpformgencat' , 'gplana'),
		T_FUNCION( 'grpformgencat' , 'log.pcambronero'),
		T_FUNCION( 'grpformgencat' , 'log.cramos'),
		T_FUNCION( 'grpformgencat' , 'ext.imartindelosrios'),
		T_FUNCION( 'grpformgencat' , 'emerino'),
		T_FUNCION( 'grpformgencat' , 'ext.cromero'),
		T_FUNCION( 'grpformgencat' , 'pmiguell'),
		T_FUNCION( 'grpformgencat' , 'ext.mpalmero'),
		T_FUNCION( 'grpformgencat' , 'ext.mgarciamo'),
		T_FUNCION( 'grpformgencat' , 'emartinm'),
		T_FUNCION( 'grpformgencat' , 'ext.bheras'),
		T_FUNCION( 'grpformgencat' , 'ext.mlucas'),
		T_FUNCION( 'grpformgencat' , 'ext.erodrigue'),
		T_FUNCION( 'grpformgencat' , 'ext.rberenguer'),
		T_FUNCION( 'grpformgencat' , 'ext.ccastellanos'),
		T_FUNCION( 'grpformgencat' , 'garsa.elopez'),
		T_FUNCION( 'grpformgencat' , 'ext.mmoralesc'),
		T_FUNCION( 'grpformgencat' , 'ext.amartin'),
		T_FUNCION( 'grpformgencat' , 'ext.amorenog'),
		T_FUNCION( 'grpformgencat' , 'nesteban'),
		T_FUNCION( 'grpformgencat' , 'ext.jvilchez'),
		T_FUNCION( 'grpformgencat' , 'ext.amarquezg'),
		T_FUNCION( 'grpformgencat' , 'ext.pferrer'),
		T_FUNCION( 'grpformgencat' , 'ext.gsancheza'),
		T_FUNCION( 'grpformgencat' , 'ext.rmonteros'),
		T_FUNCION( 'grpformgencat' , 'ejarquem'),
		T_FUNCION( 'grpformgencat' , 'bgalan'),
		T_FUNCION( 'grpformgencat' , 'ext.jlahuerta'),
		T_FUNCION( 'grpformgencat' , 'ext.ipinedo'),
		T_FUNCION( 'grpformgencat' , 'ext.dchirveches'),
		T_FUNCION( 'grpformgencat' , 'ext.aluque'),
		T_FUNCION( 'grpformgencat' , 'ext.emolina'),
		T_FUNCION( 'grpformgencat' , 'ext.igomezl'),
		T_FUNCION( 'grpformgencat' , 'ext.mesteban'),
		T_FUNCION( 'grpformgencat' , 'ext.sdiaz'),
		T_FUNCION( 'grpformgencat' , 'nmartini'),
		T_FUNCION( 'grpformgencat' , 'jfuentes'),
		T_FUNCION( 'grpformgencat' , 'mmoron'),
		T_FUNCION( 'grpformgencat' , 'alopezr'),
		T_FUNCION( 'grpformgencat' , 'mbenitez'),
		T_FUNCION( 'grpformgencat' , 'nlopez'),
		T_FUNCION( 'grpformgencat' , 'ext.jgutierrezs'),
		T_FUNCION( 'grpformgencat' , 'jfernandezb'),
		T_FUNCION( 'grpformgencat' , 'jizquierdo'),
		T_FUNCION( 'grpformgencat' , 'ext.mhayon'),
		T_FUNCION( 'grpformgencat' , 'ext.jconde'),
		T_FUNCION( 'grpformgencat' , 'ext.rmartinezm'),
		T_FUNCION( 'grpformgencat' , 'dnunez'),
		T_FUNCION( 'grpformgencat' , 'ivalverde'),
		T_FUNCION( 'grpformgencat' , 'ext.msanchezto'),
		T_FUNCION( 'grpformgencat' , 'ext.dlopezj'),
		T_FUNCION( 'grpformgencat' , 'ext.bhiguera'),
		T_FUNCION( 'grpformgencat' , 'ext.cpanadero'),
		T_FUNCION( 'grpformgencat' , 'ext.mmarting'),
		T_FUNCION( 'grpformgencat' , 'ext.ldiez'),
		T_FUNCION( 'grpformgencat' , 'ext.squilon'),
		T_FUNCION( 'grpformgencat' , 'aprados'),
		T_FUNCION( 'grpformgencat' , 'ext.bbelmar'),
		T_FUNCION( 'grpformgencat' , 'ext.mcortecero'),
		T_FUNCION( 'grpformgencat' , 'eblasco'),
		T_FUNCION( 'grpformgencat' , 'ext.spujadas'),
		T_FUNCION( 'grpformgencat' , 'ext.jleandro'),
		T_FUNCION( 'grpformgencat' , 'ext.malcantara')
	); 
	V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INFO] INICIO'); 

	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||' ');
	FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
	LOOP
		V_TMP_FUNCION := V_FUNCION(I);

		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||''' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS > 0 THEN
		
			DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobando si existe el usuario '''||V_TMP_FUNCION(2)||''' asociado al grupo '''||V_TMP_FUNCION(1)||'');

			V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' WHERE USU_ID_GRUPO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||''') 
						AND USU_ID_USUARIO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||''')';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

			IF V_NUM_TABLAS > 0 THEN	  

				DBMS_OUTPUT.PUT_LINE('[INFO]: Ya existe el usuario en ese grupo.');		

			ELSE
			
				DBMS_OUTPUT.PUT_LINE('[INFO]: Insertando relación '''||V_TMP_FUNCION(1)||''' - '''||V_TMP_FUNCION(2)||'''.');

				V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TABLA||' (GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO, USUARIOCREAR, FECHACREAR)
							SELECT '||V_ESQUEMA_M||'.S_'||V_TABLA||'.NEXTVAL,(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||'''),
							(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||'''),'''||V_USUARIO||''', SYSDATE FROM DUAL';
				EXECUTE IMMEDIATE V_MSQL;

				DBMS_OUTPUT.PUT_LINE('[INFO] Relación insertada correctamente.');
					
			END IF;	

		ELSE 

			DBMS_OUTPUT.PUT_LINE('[INFO]: No existe el usuario '||V_TMP_FUNCION(2)||'');		

		END IF;

	END LOOP;
	
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TABLA||' ACTUALIZADA CORRECTAMENTE ');
   
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
