--/*
--###########################################
--## AUTOR=Jessica Sampere
--## FECHA_CREACION=20180209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.12
--## INCIDENCIA_LINK=REMNIVDOS-3315
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
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16);
  V_ID_PRO NUMBER(16);
  V_ID_USU NUMBER(16);
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


  V_TICKET VARCHAR2(25 CHAR):= 'REMNIVDOS-3315';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
				--USER_NAME,	NOMBRE_USU,	APELL1,	APELL2,	EMAIL,	PVE_DOCIDENTIF
		T_TIPO_DATA('53605916P','MONICA','TORRES','SAHUCO','m.torres@garsa.com','A79965331'),
		T_TIPO_DATA('07259025H','NOELIA','GARCIA','CARRILERO','n.garcia@garsa.com','A79965331'),
		T_TIPO_DATA('22589245W','JUAN ENRIQUE TOMÁS BIENDICHO','','','j.tomas@garsa.com','A79965331'),
		T_TIPO_DATA('24353350F','MATILDE','CONTRERAS','GARRIDO','m.contreras@garsa.com','A79965331'),
		T_TIPO_DATA('24365131B','VANESSA','LOPEZ','VILAS','v.lopez@garsa.com','A79965331'),
		T_TIPO_DATA('44854590J','YASMINA','FEMENIA','ROGLÁ','y.femenia@garsa.com','A79965331'),
		T_TIPO_DATA('25407864V','CARMEN','ARAQUE','MORATALLA','m.araque@garsa.com','A79965331'),
		T_TIPO_DATA('44853989X','ROSARIO','MOYA','LERÍN','r.moya@garsa.com','A79965331'),
		T_TIPO_DATA('44879986V','VANESA','DESCO','GUILLEN','v.desco@garsa.com','A79965331'),
		T_TIPO_DATA('29199627T','ESTHER','MARTINEZ','TIRADO','esther.martinez@garsa.com','A79965331'),
		T_TIPO_DATA('53253096T','SARA','VILLALBA','RODRIGUEZ','s.villalba@garsa.com','A79965331'),
		T_TIPO_DATA('53356963E','FATIMA','CARRATALÁ','CASABAN','f.carratala@garsa.com','A79965331'),
		T_TIPO_DATA('21500448W','MILA','RICO','GALLEGO','m.rico@garsa.com','A79965331'),
		T_TIPO_DATA('52649732H','DOLORES','MURILLO','TRUJILLO','m.murillo@garsa.com','A79965331'),
		T_TIPO_DATA('29193980B','Mª ASUNCIÓN GOMEZ FORCADA','','','a.gomez@garsa.com','A79965331'),
		T_TIPO_DATA('33459310Z','Mª AMPARO PEIRO FERNANDEZ','','','a.peiro@garsa.com','A79965331'),
		T_TIPO_DATA('51103423E','ROMAN','BERNAL','DIAZ','r.bernal@garsa.com','A79965331'),
		T_TIPO_DATA('47459052R','DANIEL','GAMO','BEAMUD','d.gamo@garsa.com','A79965331'),
		T_TIPO_DATA('49148664X','LUCIA','LOPEZ','ZAFRA','lucia.lopez@garsa.com','A79965331'),
		T_TIPO_DATA('52874731P','LUIS','FERNANDEZ','MORALES','l.fernandez@garsa.com','A79965331'),
		T_TIPO_DATA('09041098M','VERONICA','MORILLO','NAJARRO','v.morillo@garsa.com','A79965331'),
		T_TIPO_DATA('46870082S','IVAN','PORTERO','ESQUILICHE','i.portero@garsa.com','A79965331'),
		T_TIPO_DATA('11847519N','CLARA','RUIZ','CONTRERAS','c.ruiz@garsa.com','A79965331'),
		T_TIPO_DATA('02900594H','EDUARDO','LACASTA','VILLAVERDE','e.lacasta@garsa.com','A79965331'),
		T_TIPO_DATA('01930131V','MARIA DOLORES','RODRIGUEZ','ORTIZ','md.rodriguez@garsa.com','A79965331'),
		T_TIPO_DATA('05426871K','RAMON','MARTINEZ','VILLA','r.martinez@garsa.com','A79965331'),
		T_TIPO_DATA('18426124l','JOSE JAVIER','BRUNA','RODRIGUEZ','j.bruna@garsa.com','A79965331'),
		T_TIPO_DATA('44504779D','Mª ASUNCIÓN','RUIZ','BOLUDA','asuncion.ruiz@garsa.com','A79965331'),
		T_TIPO_DATA('47462005X','CELIA','BERNARDO','MOLINERO','c.bernardo@garsa.com','A79965331'),
		T_TIPO_DATA('73391233G','ENRIQUE','VENTURA','GIL','e.ventura@garsa.com','A79965331'),
		T_TIPO_DATA('08945178H','JOSE LUIS','RUIZ','MONTOYA','jl.ruiz@garsa.com','A79965331'),
		T_TIPO_DATA('50067852A','CARMEN','GUERREIRO','ANTOLIN','c.guerreiro@garsa.com','A79965331'),
		T_TIPO_DATA('52185411K','CONCEPCIÓN','CARPIO','DUEÑAS','c.carpio@garsa.com','A79965331'),
		T_TIPO_DATA('03115140C','FRANCISCO JAVIER','ALONSO','MANZANERO','f.alonso@garsa.com','A79965331'),
		T_TIPO_DATA('09184389Y','SUSANA','LABRADOR','FERNANDEZ','s.labrador@garsa.com','A79965331'),
		T_TIPO_DATA('29052129R','INES','VILLEN','JIMENEZ','i.villen@garsa.com','A79965331'),
		T_TIPO_DATA('46834516F','MARIA CARMEN','FERNANDEZ','TORREMOCHA','mc.fernandez@garsa.com','A79965331'),
		T_TIPO_DATA('47282555Y','RAQUEL','CALDERON','ALBA','r.calderon@garsa.com','A79965331'),
		T_TIPO_DATA('08932108N','PATRICIA','RIBEIRO','RODRIGUEZ','p.ribeiro@garsa.com','A79965331'),
		T_TIPO_DATA('44602609C','JUDITH TERESA','LLOPIS','ANAYA','j.llopis@garsa.com','A79965331'),
		T_TIPO_DATA('08039865P','ESTRELLA','BASCON','PEDRERO','e.bascon@garsa.com','A79965331'),
		T_TIPO_DATA('20816186J','PILAR','MORENO','EVANGELISTA','p.moreno@garsa.com','A79965331'),
		T_TIPO_DATA('29180786L','MATILDE','CRESPO','VICENTE','m.crespo@garsa.com','A79965331'),
		T_TIPO_DATA('48384311Q','MIREIA','LOPEZ','ESTELLES','mireia.lopez@garsa.com','A79965331'),
		T_TIPO_DATA('75862982N','MANUELA','GARCIA','GOMEZ','manuela.garcia@garsa.com','A79965331'),
		T_TIPO_DATA('28649420E','MARIO ROCIO','CEBALLOS','LARA','r.ceballos@garsa.com','A79965331'),
		T_TIPO_DATA('53362965K','MªPILAR','VEGUER','LLACER','m.veguer@garsa.com','A79965331'),
		T_TIPO_DATA('78547165A','JUAN DAVID','JIMENEZ','GARCIA','d.jimenez@garsa.com','A79965331'),
		T_TIPO_DATA('08867669L','VIOLETA MARIA','RODRIGUEZ','ROQUE','violeta.rodriguez@garsa.com','A79965331'),
		T_TIPO_DATA('44654061K','MARTA','MACIAS','PORRAS','m.macias@garsa.com','A79965331'),
		T_TIPO_DATA('50731233H','GONZALO BERTRAN DE LIS BERMEJO','','','gbertrandelis@uniges.com','B81304412'),
		T_TIPO_DATA('50299138R','RAFAEL','TEBAR','PEREZ','rtebar@uniges.com','B81304412'),
		T_TIPO_DATA('00403142K','JOSE VICENTE GARCIA MAYORA','','','jgmayora@uniges.com','B81304412'),
		T_TIPO_DATA('02891847B','JUAN MANUEL SAMANIEGO FERNANDEZ','','','jmsamaniego@uniges.com','B81304412'),
		T_TIPO_DATA('11834651R','MARIA JOSE CASTIÑEIRAS CENAMOR','','','mjccenamor@uniges.com','B81304412'),
		T_TIPO_DATA('53018453A','BEGOÑA','UBEDA','TORRES','bubeda@uniges.com','B81304412'),
		T_TIPO_DATA('02912517G','MARIA DEL CARMEN CAMACHO PEREZ','','','mccamacho@uniges.com','B81304412'),
		T_TIPO_DATA('02618123X','MARIA ANGELES SANCHEZ LAGUNA','','','masanchez@uniges.com','B81304412'),
		T_TIPO_DATA('04843135W','PEDRO','PERUCHA','SANCHEZ','pperucha@uniges.com','B81304412'),
		T_TIPO_DATA('11814281D','PEDRO JAVIER LANZ RAGGIO','','','pjlanz@uniges.com','B81304412'),
		T_TIPO_DATA('46870710E','MARINA','GONZALEZ','LLORENTE','mgonzalezl@uniges.com','B81304412'),
		T_TIPO_DATA('53103618E','JUAN ANTONIO PULIDO CALVO','','','japulido@uniges.com','B81304412'),
		T_TIPO_DATA('02641048G','AMAYA','MACHO','HERVAS','amacho@uniges.com','B81304412'),
		T_TIPO_DATA('05359290Z','JUAN','MECO','GOMEZ','jmeco@uniges.com','B81304412'),
		T_TIPO_DATA('51621412M','MARIBEL','ZAMORA','LOPEZ','mizamora@uniges.com','B81304412'),
		T_TIPO_DATA('07476736B','SILVIA','PORTERO','RODRIGUEZ','sportero@uniges.com','B81304412'),
		T_TIPO_DATA('05293091D','DANIEL','SANCHEZ','CANOREA','dsanchez@uniges.com','B81304412'),
		T_TIPO_DATA('47043581W','SONIA PALOMO DEL CASTILLO','','','spalomo@uniges.com','B81304412'),
		T_TIPO_DATA('51643931F','ANA','ZAMORA','LOPEZ','amzamora@uniges.com','B81304412'),
		T_TIPO_DATA('51637306Y','LUCIO','SUAREZ','LOPEZ','lsuarez@uniges.com','B81304412'),
		T_TIPO_DATA('01922998Z','JORGE','BARDAVIO','ANDRES','jbardavio@uniges.com','B81304412'),
		T_TIPO_DATA('47456865E','ELENA','SEVILLA','GIRON','esevilla@uniges.com','B81304412'),
		T_TIPO_DATA('08931423V','ALMUDENA','TORIO','GONZALEZ','atorio@uniges.com','B81304412'),
		T_TIPO_DATA('52366328C','ANA','MORALES','AGUILAR','ammorales@uniges.com','B81304412'),
		T_TIPO_DATA('05333677T','AINHOA','MAIZ','ALVAREZ','amaiz@uniges.com','B81304412'),
		T_TIPO_DATA('05960870Y','ANDREA','CASTRO','SANZ','acastro@uniges.com','B81304412'),
		T_TIPO_DATA('50360263S','JENNIFER SULAY','MIRANDA','ALCIVAR','jsmiranda@uniges.com','B81304412'),
		T_TIPO_DATA('12449131J','SHAWNE MICHAEL','BISARRA','SADURAL','smbisarra@uniges.com','B81304412'),
		T_TIPO_DATA('48149397R','JUAN LUIS','GOMEZ','ALMECH','jlgomez@uniges.com','B81304412'),
		T_TIPO_DATA('02790931L','FERNANDA','ROGEL','HURTADO','frogel@uniges.com','B81304412'),
		T_TIPO_DATA('05426070W','HORTENSIA','PILAR DE CASTRO','HERNANDEZ','hpilardecastro@uniges.com','B81304412'),
		T_TIPO_DATA('4843135W','PEDRO','PERUCHA','SANCHEZ','pperucha@uniges.com','B81304412'),
		T_TIPO_DATA('51374894R','JUANA','MONTERO','CASTELLANO','jmontero@uniges.com','B81304412'),
		T_TIPO_DATA('02616729L','JOSE MANUEL','LAHERA','CHAMORRO','jmlahera@uniges.com','B81304412'),
		T_TIPO_DATA('47294808T','AARON','SEDEÑO','MARTINEZ','asmartinez@uniges.com','B81304412'),
		T_TIPO_DATA('70590549F','MARIA','SANCHEZ','SANZ','msanchez@uniges.com','B81304412'),
		T_TIPO_DATA('50297504T','MARIA VICTORIA BARBERO GOMEZ','','','mariab@pinosxxi.com','B82064478'),
		T_TIPO_DATA('51980988E','GEMA VANESA JIMENEZ BARBERO','','','gestiones@pinosxxi.es','B82064478'),
		T_TIPO_DATA('50105114M','DAVID','CASTAÑO','GONZALEZ','davidc@pinosxxi.com','B82064478'),
		T_TIPO_DATA('42978368Q','ALBERTO','GARRALON','DIAZ','a.garralon@pinosxxi.es','B82064478'),
		T_TIPO_DATA('70934859F','ALFONSO','GARCIA','CASTRO','alfonsogc@pinosxxi.es','B82064478'),
		T_TIPO_DATA('02251334W','ALICIA','MARTINEZ','MENDEZ','aliciam@pinosxxi.es','B82064478'),
		T_TIPO_DATA('53365743Q','DANIEL','MARTIN','GIL','danielmg@pinosxxi.es','B82064478'),
		T_TIPO_DATA('51397701S','MONICA','GARCIA','SANCHEZ','recuperaciones.52@pinosxxi.es','B82064478'),
		T_TIPO_DATA('53137011L','SALVADOR','NAPOLES','RACIONERO','recuperaciones.53@pinosxxi.es','B82064478'),
		T_TIPO_DATA('11831266C','DAVID','LOPEZ','GUTIERREZ','recuperaciones.62@pinosxxi.es','B82064478'),
		T_TIPO_DATA('52086132X','ASUNCION','CENTELLAS','PINTO','administracion.92@pinosxxi.es','B82064478'),
		T_TIPO_DATA('50979301P','INMACULADA','LLORENTE','GUIJARRO','cedulas@pinosxxi.es','B82064478'),
		T_TIPO_DATA('51067218L','RAQUEL','LOPEZ','GUTIERREZ','recuperaciones.63@pinosxxi.es','B82064478'),
		T_TIPO_DATA('50962298W','EMILIO','HERVAS','VAZQUEZ','recuperaciones.59@pinosxxi.es','B82064478'),
		T_TIPO_DATA('51935765V','CRISTINA','HERNANDEZ','JIMENEZ','recuperaciones.54@pinosxxi.es','B82064478'),
		T_TIPO_DATA('02878451R','MARIA DEL CARMEN DEL ESTAL PASCUAL','','','recuperaciones.56@pinosxxi.es','B82064478'),
		T_TIPO_DATA('08938379G','SUSANA','MERAYO','LEON','gestiondocumental.24@pinosxxi.es','B82064478'),
		T_TIPO_DATA('08938380M','YOLANDA','MERAYO','LEON','gestiondocumental.25@pinosxxi.es','B82064478'),
		T_TIPO_DATA('50101078V','MARIA TERESA TEMPRANO GARCIA','','','recuperaciones.57@pinosxxi.es','B82064478'),
		T_TIPO_DATA('33517318Q','LUIS MIGUEL SANZ MARCOS','','','gestioncontratos.82@pinosxxi.es','B82064478'),
		T_TIPO_DATA('51178583H','RONNIE DAN PATIÑO SAAVEDRA','','','ronniep@pinosxxi.es','B82064478'),
		T_TIPO_DATA('53443485H','RAUL','RODRIGUEZ','OTERO','recuperaciones.58@pinosxxi.es','B82064478'),
		T_TIPO_DATA('50868754E','JAVIER','QUIROGA','MONTES','contabilidad@pinosxxi.es','B82064478'),
		T_TIPO_DATA('50341446N','HOLGER','MENA','MENA','gestioncontratos.81@pinosxxi.es','B82064478'),
		T_TIPO_DATA('51903049F','ENRIQUE','PEREZ','TRANCHO','gestioninmuebles.31@pinosxxi.es','B82064478'),
		T_TIPO_DATA('07472312A','MARIA ANGELES ROSETE GARCIA','','','gestioninmuebles.33@pinosxxi.es','B82064478'),
		T_TIPO_DATA('02912870N','CARMEN','CASTRO','NIETO','gestioninmuebles.40@pinosxxi.es','B82064478'),
		T_TIPO_DATA('11825474R','MARIA CRUZ CASTAÑO GONZALEZ','','','gestioninmuebles.38@pinosxxi.es','B82064478'),
		T_TIPO_DATA('51258960X','SUSAN','BENZA','MINCHON','gestioninmuebles.46@pinosxxi.es','B82064478'),
		T_TIPO_DATA('51368399S','PABLO','GARCIA','SANCHEZ','gestioninmuebles.47@pinosxxi.es','B82064478'),
		T_TIPO_DATA('52872988J','DIEGO','FERNANDEZ','MUÑOZ','gestioninmuebles.41@pinosxxi.es','B82064478'),
		T_TIPO_DATA('1913510W','INMACULADA DE PINTO HERRERA','','','activosadjudicados.73@pinosxxi.es','B82064478'),
		T_TIPO_DATA('52869104Q','JORGE','PEREZ','GONZALEZ','activosadjudicados.71@pinosxxi.es','B82064478'),
		T_TIPO_DATA('11799776V','PABLO SANZ DE LUCAS','','','activosadjudicados.74@pinosxxi.es','B82064478'),
		T_TIPO_DATA('11827176R','ORQUIDEA','DELGADO','BLAS','activosadjudicados.79@pinosxxi.es','B82064478'),
		T_TIPO_DATA('52958095C','HUSSEIN MAHMOUD EL HELOU','','','activosadjudicados.78@pinosxxi.es','B82064478'),
		T_TIPO_DATA('50300602Q','JULIO','ANTON','ANTON','activosadjudicados.80@pinosxxi.es','B82064478'),
		T_TIPO_DATA('38544746N','ANA Mª DEL CARMEN VARGAS MACHUCA MARQUEZ','','','firmas2@pinosxxi.es','B82064478'),
		T_TIPO_DATA('02640721E','STEFANIA','CAPRIOLI','CARZOLIO','recuperaciones.55@pinosxxi.es','B82064478'),
		T_TIPO_DATA('78685981Z','Jose Carlos','Araque','Delgado','controlcalidad.91@pinosxxi.es','B82064478'),
		T_TIPO_DATA('51935429A','SONIA','FRIAS','CUEVAS','activosadjudicados.81@pinosxxi.es','B82064478'),
		T_TIPO_DATA('51409365H','ALBERTO','GARCIA','VILAS','albertogarcia@gmontalvo.com','B79419131'),
		T_TIPO_DATA('50729087B','ALONSO CARLOS CANOVAS RODRIGUEZ','','','carloscanovas@gmontalvo.com','B79419131'),
		T_TIPO_DATA('05356929E','MARIA LUISA FERNANDEZ VELA','','','marisafernandez@gmontalvo.com','B79419131'),
		T_TIPO_DATA('51943412M','MARIA ROSA REDONDO GOMEZ','','','rosaredondo@gmontalvo.com','B79419131'),
		T_TIPO_DATA('02715571F','MARIA','BRETONES','MIGUELEZ','mariabretones@gmontalvo.com','B79419131'),
		T_TIPO_DATA('52979268X','YOLANDA','GARCIA','MERINO','yolandagmerino@gmontalvo.com','B79419131'),
		T_TIPO_DATA('02663468E','CRISTINA','JIMENEZ','','cristinajimenez@gmontalvo.com','B79419131'),
		T_TIPO_DATA('33521528V','PALOMA','TORRES','RODRIGUEZ','palomatorres@gmontalvo.com','B79419131'),
		T_TIPO_DATA('31861013X','JUANA MARIA ALCALDE RIAO','','','juanialcalde@gmontalvo.com','B79419131'),
		T_TIPO_DATA('07225685M','VICTOR','SANCHEZ','DOMINGUEZ','victorsanchez@gmontalvo.com','B79419131'),
		T_TIPO_DATA('51936756L','RAUL','RODRIGUEZ','RANERA','raulrodriguez@gmontalvo.com','B79419131'),
		T_TIPO_DATA('49002451P','BEATRIZ','GONZALEZ','SOTO','beatrizgonzalez@gmontalvo.com','B79419131'),
		T_TIPO_DATA('50225955G','MIGUEL ANGEL URBANO GARCIA','','','miguelangelurbano@gmontalvo.com','B79419131'),
		T_TIPO_DATA('X4436667J','MIGUEL','CASTILLO','VELANDIA','miguelcastillo@gmontalvo.com','B79419131'),
		T_TIPO_DATA('05217085H','MARIA ANGELES GOMEZ VAZQUEZ','','','angelesgomez@gmontalvo.com','B79419131'),
		T_TIPO_DATA('02257034K','YOLANDA','RODRIGUEZ','BUENAÑO','yolandabrodriguez@gmontalvo.com','B79419131'),
		T_TIPO_DATA('50887128L','ROSANA','POPA','SANCHEZ','rosanapopa@gmontalvo.com','B79419131'),
		T_TIPO_DATA('09796301A','MARIA TERESA SERRANO MARTINEZ','','','tessaserrano@gmontalvo.com','B79419131'),
		T_TIPO_DATA('836024C','PABLO','IGLESIAS','CONTRERAS','pabloiglesias@gmontalvo.com','B79419131'),
		T_TIPO_DATA('50690732C','ANTONIO','BLANCO','CABRERO','antonioblanco@gmontalvo.com','B79419131'),
		T_TIPO_DATA('2235351G','ROSA MARIA GARCIA-NAVAS MONTALBAN','','','rmg@montalvoasesores.es','B79419131'),
		T_TIPO_DATA('2715571F','MARIA','BRETONES','MIGUELEZ','mariabretones@gmontalvo.com','B79419131'),
		T_TIPO_DATA('montserrano','Mª Teresa','Serrano','Martinez','mon.tserrano@haya.es','B79419131'),
		T_TIPO_DATA('50690262X','ALFONSO','LABRADOR','GARCIA','alfonso@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('46933372D','OSCAR','ZURDO','GARCIA','oscar@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('25120404B','FRANCISCO MANUEL PEREZ SORIANO','','','paco@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('0892090J','JESUS DE LAS HERAS SANCHEZ','','','jesus@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('02521353R','JOSE MARIA LABRADOR GARCIA','','','chema@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('07957175A','Mª PAZ DOMINGUEZ ISIDORO','','','mpaz@gl.e.telefonica.net','B79012860'),
		T_TIPO_DATA('8978199B','MARIA DEL PILAR PEREZ SANCHEZ','','','pilar@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('50432579L','MARIA OLGA GARCIA HERNANDO','','','olga@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('06959680H','PETRA','LABRADOR','GARCIA','glabrador@gl.e.telefonica.net','B79012860'),
		T_TIPO_DATA('50727168R','MARIA ESTHER BERTRAN DE LIS BERMEJO','','','esther@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('50834347T','ANTONIO','FERNANDEZ','GARCIA','antonio@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('51484093L','FRANCISCO J. OREJANA RUIZ-DANA','','','francisco@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('2698508X','JOAQUIN','MADRID','SALVADOR-DUARTE','joaquin@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('20253621M','MARIA BELEN ROL RODRIGUEZ','','','belen@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('70061363M','RAFAEL','RANCAÑO','MARTINEZ','rafa@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('20267711L','SARA','ANTEQUERA','MARTIN','sara@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('53048030W','TAMARA','CUENCA','PRIETO','tamara@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('51927281C','MARIA EUGENIA BLANCO BARAHONA','','','geni@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('47460855X','ALEJANDRO ELVIRA DE LA PAZ','','','alex@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('50751583J','GEMA','MOLINA','ALONSO','gema@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('74717518V','JUAN SERGIO MALDONADO MARTIN','','','sergio@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('50731298Z','MARIA DEL CARMEN JOVE DIAZ','','','carmina@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('51391272A','PALOMA','ALFARO','FERNANDEZ','paloma@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('7525763W','ROBERTO','GARCIA','GOMEZ','rober@gutierrezlabrador.es','B79012860'),
		T_TIPO_DATA('malcalde','Maria Isabel','Alcalde','Yuste','malcalde@haya.es','B79012860'),
		T_TIPO_DATA('50892090J','Jesús','de las Heras','Sánchez','jesus@gutierrezlabrador.es','B79012860')

  ); 
  V_TMP_TIPO_DATA T_TIPO_DATA;
  
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');



	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP

			V_TMP_TIPO_DATA := V_TIPO_DATA(I);

			-------------------------------------------------
			--Comprobar usuario--
			-------------------------------------------------
			DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBAMOS QUE EXISTE EL USUARIO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       
			--Si no existe, a casa
			IF V_NUM_TABLAS = 0 THEN				         
				DBMS_OUTPUT.PUT_LINE('[KO] NO EXITE EL USUARIO '||TRIM(V_TMP_TIPO_DATA(1))||'.');
				
			ELSE
			-------------------------------------------------
			--Comprobar proveedor--
			-------------------------------------------------
				DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBAMOS QUE EXISTE EL PROVEEDOR '''|| TRIM(V_TMP_TIPO_DATA(6)) ||''' ');
				
				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(6))||''' AND PVE_FECHA_BAJA IS NULL AND DD_TPR_ID = 1 ';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
				
				--Si no existe, a casa
				IF V_NUM_TABLAS = 0 THEN				         
					DBMS_OUTPUT.PUT_LINE('[KO] NO EXITE EL PROVEEDOR '||TRIM(V_TMP_TIPO_DATA(6))||'.');
				ELSE
					-------------------------------------------------
					--INSERTAR USUARIO EN PERSONA CONTACTO PROVEEDOR--
					-------------------------------------------------
					V_SQL := 'SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(6))||''' AND PVE_FECHA_BAJA IS NULL AND DD_TPR_ID = 1 ';
					EXECUTE IMMEDIATE V_SQL INTO V_ID_PRO;
					
					V_SQL := 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
					EXECUTE IMMEDIATE V_SQL INTO V_ID_USU;
                    
                    DBMS_OUTPUT.PUT_LINE('[INSERT]: DEL USUARIO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN EL PROVEEDOR '''|| TRIM(V_TMP_TIPO_DATA(6)) ||''' ');
                    
					V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO (PVC_ID,PVE_ID,USU_ID,PVC_NOMBRE,PVC_APELLID01,PVC_APELLID02,PVC_EMAIL,USUARIOCREAR,FECHACREAR,BORRADO) VALUES
					('|| V_ESQUEMA ||'.S_ACT_PVC_PROVEEDOR_CONTACTO.NEXTVAL,
					'||V_ID_PRO||',
					'||V_ID_USU||',
					'''||TRIM(V_TMP_TIPO_DATA(2))||''',
					'''||TRIM(V_TMP_TIPO_DATA(3))||''',
					'''||TRIM(V_TMP_TIPO_DATA(4))||''',
					'''||TRIM(V_TMP_TIPO_DATA(5))||''',
					'''||V_TICKET||''',
					SYSDATE,
					0
					)';
					EXECUTE IMMEDIATE V_SQL;
       				DBMS_OUTPUT.PUT_LINE('[OK]: PERSONA DE CONTACTO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' AÑADIDA A PROVEEDOR '''|| TRIM(V_TMP_TIPO_DATA(6)) ||''' ');

				END IF;
				
			END IF;

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