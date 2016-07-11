--/*
--#########################################
--## AUTOR=David González
--## FECHA_CREACION=20160422
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-166
--## PRODUCTO=NO
--## 
--## Finalidad: Creacion de Usuarios REM - PROVEEDORES
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
	T_TIPO_DATA('1','B87105821','ah5m92','Activa Externalización de servicios' , '' , '' , 'mpromero@activaes.es' , '0'),
	T_TIPO_DATA('1','B98562036','bi5n55','Actúa Gestión de Activos' , '' , '' , 'jlmelchor@actua-ga.es' , '0'),
	T_TIPO_DATA('1','B82450727','cj4o17','Adarve Corporación Jurídica' , '' , '' , 'juanjose.garcia@adarve.com' , '0'),
	T_TIPO_DATA('1','B98306012','dk5p54','Alberta Norweg' , '' , '' , 'eduardo.simo@albertanorweg.com' , '0'),
	T_TIPO_DATA('1','21430198V','el2q82','Alfonso García Cortés' , '' , '' , 'alfonso@garciacortes.com' , '0'),
	T_TIPO_DATA('1','22518378K','fm6r58','Alfonso Pascual de Miguel-Notaría' , '' , '' , 'alfonsopascual@notariado.org' , '0'),
	T_TIPO_DATA('1','B96565981','gn9s48','Algescón Levante' , '' , '' , 'algescon@algescon.com' , '0'),
	T_TIPO_DATA('1','B58409269','ho4t81','Aliven Gestión de Activos' , '' , '' , 'arodriguez@aliven.com' , '0'),
	T_TIPO_DATA('1','B66610239','ip2v45','Aliven Legal' , '' , '' , 'arodriguez@aliven.com' , '0'),
	T_TIPO_DATA('1','01073243V','jq6w22','Amador García Carrasco (ILS Abogados)' , '' , '' , 'raqueldepablos@ilsabogados.com' , '0'),
	T_TIPO_DATA('1','E98442098','kr2x14','Arboreda, Jardinería y paisajismo' , '' , '' , 'arboredapaisajes2012@yahoo.es' , '0'),
	T_TIPO_DATA('1','B35921642','ls2y67','Arcoin' , '' , '' , 'jpol@arcoin.es' , '0'),
	T_TIPO_DATA('1','B97387088','mt1z76','Arquiurbi' , '' , '' , '04044@ctav.es' , '0'),
	T_TIPO_DATA('1','B85736023','nv2a18','Asigno Servicios Integrales ' , 'de Recuperación de Créditos' , '' , 'marisecosmea@asigno.es' , '0'),
	T_TIPO_DATA('1','B26459560','px2c71','Barinaga Abogados' , '' , '' , 'psantana@barinagamartin.com' , '0'),
	T_TIPO_DATA('1','7804975V' ,'qy3d34','Basilio Rodríguez Barbero' , '' , '' , 'basilio@basilio.e.telefonica.net' , '0'),
	T_TIPO_DATA('1','B85343721','rz6e66','Brick o´Clock' , '' , '' , 'pperez@brickoclock.es' , '0'),
	T_TIPO_DATA('1','B96818828','sa3f13','Broseta Abogados' , '' , '' , 'jllujan@broseta.com' , '0'),
	T_TIPO_DATA('1','J82522061','tb2g93','Bufete López & Llovet' , '' , '' , 'glopezmoron@lopezllovet.com' , '0'),
	T_TIPO_DATA('1','J64395726','vc2h33','Bufete Vallés-Arbos' , '' , '' , 'jordi@bufetvalles.com' , '0'),
	T_TIPO_DATA('1','B85752905','wd1i44','Cartera de Activos Inmobiliarios ' , '' , '' , 'jpizarro@cdaisl.com' , '0'),
	T_TIPO_DATA('1','A28346054','xe4j25','Caser Asistencia' , '' , '' , 'ggonzalez2@caser.es' , '0'),
	T_TIPO_DATA('1','B97518138','yf8k66','CGTécnica: Coordinación y gestión Técnica ' , 'de Obras y Proyectos' , '' , 'cgtecnica@cgtecnica.com' , '0'),
	T_TIPO_DATA('1','B85345452','zg2l49','Chavarri y Muñoz Abogados' , '' , '' , 'sara.chamorro@chabogados.es' , '0'),
	T_TIPO_DATA('1','B63899660','bi9n35','Dalaia Trade (Hibuk Partners)' , '' , '' , 'Hibukbcn@gmail.com' , '0'),
	T_TIPO_DATA('1','B72265986','cj6o12','DSC: Desarrollo Sub Construcción' , '' , '' , 'dsconstruccionsl@gmail.com' , '0'),
	T_TIPO_DATA('1','B86546900','dk4p37','Eco Avanza' , '' , '' , 'info@eco-avanza.es' , '0'),
	T_TIPO_DATA('1','77614922L','el6q22','Eduardo Turón Miranda' , '' , '' , 'info@dinamicadvocats.com' , '0'),
	T_TIPO_DATA('1','B85097962','fm7r77','Eptisa Servicios de Ingeniería' , '' , '' , 'jmoro@eptisa.com' , '0'),
	T_TIPO_DATA('1','A80241789','gn3s15','Ferrovial Servicios ' , '' , '' , 'hmartinezcampos.ferroser@ferrovial.com' , '0'),
	T_TIPO_DATA('1','42793075B','ho9t58','Francisco Javier Solís Robaina' , '' , '' , 'losdragos32@gmail.com' , '0'),
	T_TIPO_DATA('1','B98020001','ip7v47','García Campá y Llidó' , '' , '' , 'nacho@garciacampayllido.es' , '0'),
	T_TIPO_DATA('1','B95299947','jq3w47','Gesalia' , '' , '' , 'nprado@gesalia.com' , '0'),
	T_TIPO_DATA('1','B03830510','kr7x16','Gestimed Levante' , '' , '' , 'bankia@gestimedlevante.es' , '0'),
	T_TIPO_DATA('1','A80884372','ls4y94','Gesvalt Sociedad de Tasación' , '' , '' , 'gesvalt@gesvalt.es' , '0'),
	T_TIPO_DATA('1','33399807N','nv5a34','GRV Arquitectura-Gonzalo Rio' , '' , '' , 'grv.arquitectura@gmail.com' , '0'),
	T_TIPO_DATA('1','B93115921','qy7d32', 'GVA & Atencia abogados' , '' , '' , 'pablo.atencia@atencia-abogados.es' , '0'),
	T_TIPO_DATA('1','B90107731','rz3e98','Habilitas Facility Management' , '' , '' , ' joseluisalemanylopez@gmail.com' , '0'),
	T_TIPO_DATA('1','B86880127','sa6f35','ICARO Abogados y Economistas, S.L.P' , '' , '' , 'pablo.ruiz@icaro.pro' , '0'),
	T_TIPO_DATA('1','A78601945','tb5g15','Ilunion Outsourcing (V2 Servicios Auxiliares)' , '' , '' , 'fdiez@ilunion.com' , '0'),
	T_TIPO_DATA('1','B98493190','vc4h93','Integraval Hortus' , '' , '' , 'luis@integraval.es' , '0'),
	T_TIPO_DATA('1','B84105899','wd2i29','Invertol, Promoción e Inversión Inmobiliaria' , '' , '' , 'control@invertol.com' , '0'),
	T_TIPO_DATA('1','A79222709','xe3j79','Isolux Corsán' , '' , '' , 'vmartin@isoluxcorsan.com' , '0'),
	T_TIPO_DATA('1','B05201249','yf6k23','Jamitel 2006 (Jamitel-Garbantel)' , '' , '' , 'info@garbantel.com' , '0'),
	T_TIPO_DATA('1','43512163G','zg1l62','Javier Casas Martínez' , '' , '' , 'xcasas@jcmadvocats.es' , '0'),
	T_TIPO_DATA('1','07214799K','ah3m71','Javier Fernández Merino' , '' , '' , 'jfmerino@notariajfmerino.com' , '0'),
	T_TIPO_DATA('1','B80463565','bi4n53','JIDEPAR' , '' , '' , 'vmoralo@jimenezdeparga.es' , '0'),
	T_TIPO_DATA('1','32403209G','cj7o15','Jose Francisco Freire Amador' , '' , '' , 'josemaria@freireabogados.com' , '0'),
	T_TIPO_DATA('1','E83658567','dk4p57','José Luis López de Garayo y Gallardo ' , '(Notaría Montesquinza)' , '' , 'mmonjo@notariosmonteesquinza6.com' , '0'),
	T_TIPO_DATA('1','22685627Z','el2q99','Juan María Llatas Serrano' , '' , '' , 'juanllatas@icav.es' , '0'),
	T_TIPO_DATA('1','B85884336','fm8r95','Legazpi Servicios Generales' , '' , '' , ' hugo_legazpi@legazpiserviciosgenerales.com' , '0'),
	T_TIPO_DATA('1','B85735967','gn8s37','Léner asesores legales y económicos' , '' , '' , 'marisecosmea@asigno.es' , '0'),
	T_TIPO_DATA('1','A84259027','ho3t27','Leyser Proyectos y Construcción' , '' , '' , 'leyser@leyser.es' , '0'),
	T_TIPO_DATA('1','B91703777','ip7v58','Lissar Técnicos' , '' , '' , 'rodrigosanchez@lissartecnicos.com' , '0'),
	T_TIPO_DATA('1','B29830577','jq8w64','LR Informática (Inerttia)' , '' , '' , 'mpanteonj@inerttia.es' , '0'),
	T_TIPO_DATA('1','B45608270','kr8x71','Lucsan Abogados y Consultores' , '' , '' , 'despacho@lucsanabogados.es' , '0'),
	T_TIPO_DATA('1','50801610S','ls1y78','Luis Boada Dotor' , '' , '' , 'luisboada@notariado.org' , '0'),
	T_TIPO_DATA('1','05239632V','mt6z62','Luis Pozo Lozano (Pozo & Irurzun abogados)' , '' , '' , 'lpozol@icam.es' , '0'),
	T_TIPO_DATA('1','B82622713','nv1a58','Lupicinio Rodríguez' , '' , '' , ' lrj@lupicinio.com' , '0'),
	T_TIPO_DATA('1','J82985573','ow3b74','Notaría Cachón-Mellado' , '' , '' , 'mmellado@cmnotarios.net' , '0'),
	T_TIPO_DATA('1','B19504851','px2c19','M&C Services 2012' , '' , '' , 'activos@mcservices2012.es' , '0'),
	T_TIPO_DATA('1','25108836N','qy8d35','M. Paloma Gimeno García (Limpiezas el Arco)' , '' , '' , 'jimenopaloma@hotmail.com' , '0'),
	T_TIPO_DATA('1','22470753Y','rz2e18','Mariano Cartagena Sevilla' , '' , '' , 'cartagena@abogadoscyb.es' , '0'),
	T_TIPO_DATA('1','22624330N','sa2f12','Máximo Catalán Pardo-Notaría' , '' , '' , 'mcatalan@correonotarial.org' , '0'),
	T_TIPO_DATA('1','B84216993','tb7g25','Miguel Pintos Abogados' , '' , '' , 'andrea.canadas@litigios.net' , '0'),
	T_TIPO_DATA('1','B83580803','wd2i79','Neourbe' , '' , '' , 'alberto.f@neourbe.com  ' , '0'),
	T_TIPO_DATA('1','J91899609','xe5j47','Notaría de Nervión ' , '' , '' , 'Info@notariadenervion.com' , '0'),
	T_TIPO_DATA('1','E84026277','yf2k84','Notaría Madridejos-Tena' , '' , '' , ' notaria@madridejostena.com' , '0'),
	T_TIPO_DATA('1','B82802075','zg7l29','OGF: Oficina de Gestión de Firmas' , '' , '' , 'mlopez@ogf.es' , '0'),
	T_TIPO_DATA('1','B98658206','ah5m43','Ónice abogados y consultores' , '' , '' , 'administracion@oniceabogados.com' , '0'),
	T_TIPO_DATA('1','B63572267','bi7n13','OUA Gestió del Territori i Urbanisme, S.L.' , '' , '' , 'assets@oua-urb.com' , '0'),
	T_TIPO_DATA('1','B82270240','cj8o99','PFS Group' , '' , '' , 'isabel.garcia@pfsgroup.es' , '0'),
	T_TIPO_DATA('1','B97999254','dk6p53','Ponz asesores jurídicos' , '' , '' , 'ponzasociados@ponzasociados.com' , '0'),
	T_TIPO_DATA('1','B98438633','el7q81','Porcar & Morata Abogados y Consultores ' , '(Adolfo Porcar) JSM' , '' , 'aporcar@porcarmorata.es' , '0'),
	T_TIPO_DATA('1','B96595897','fm6r25','PREMEA: Prevención y Medio Ambiente' , '' , '' , 'premea@premea.com' , '0'),
	T_TIPO_DATA('1','B64381387','ho7t71','Promo Llonch' , '' , '' , 'jordi@promollonch.com' , '0'),
	T_TIPO_DATA('1','A28430882','ip3v89','Prosegur compañía de seguridad' , '' , '' , 'cristobal.donesteve@prosegur.com' , '0'),
	T_TIPO_DATA('1','B46635991','jq9w53','Proyme Ingeniería y Construcción' , '' , '' , 'juanba@proyme.es' , '0'),
	T_TIPO_DATA('1','B50919604','kr5x26','QIPERT UGH Global' , '' , '' , 'licitaciones@qipert.com' , '0'),
	T_TIPO_DATA('1','A82451410','ls9y95','REPARALIA' , '' , '' , 'vlabellas@reparalia.es' , '0'),
	T_TIPO_DATA('1','B60985421','mt7z14','Roca Junyent' , '' , '' , 'jl.yus@rocajunyent.com' , '0'),
	T_TIPO_DATA('1','B82127358','nv2a29','Rojo Mata' , '' , '' , 'pilar@rojomata.com' , '0'),
	T_TIPO_DATA('1','78472108H','ow7b79','Santiago Guerra Quintana (Reformas SG)' , '' , '' , 'reformas.sg@hotmail.com' , '0'),
	T_TIPO_DATA('1','A50001726','px7c52','Schindler' , '' , '' , 'julia.bernal@es.schindler.com' , '0'),
	T_TIPO_DATA('1','A78798998','rz7e79','Segurisa Servicios Integrales de Seguridad' , '' , '' , 'opbarna@gruposagital.com' , '0'),
	T_TIPO_DATA('1','B35828995','sa3f87','Servicios Integrales de Canarias 2002' , '' , '' , 'central@serviciosintegralesdecanarias.com' , '0'),
	T_TIPO_DATA('1','B91236398','tb2g42','SOINAN: Soluciones Integrales de Andalucía' , '' , '' , 'soinansl@soinan.com' , '0'),
	T_TIPO_DATA('1','B86797065','vc6h81','Solís Martín Mochales (Luis Martín Cubillo) -(JSM)' , '' , '' , 'lmartincubillo@avestabogados.com' , '0'),
	T_TIPO_DATA('1','N0066973I','wd2i59','Squire Sanders and Depsey' , '' , '' , 'fernando.gonzalez@squirepb.com' , '0'),
	T_TIPO_DATA('1','B65737322','xe4j73','Tecnotramit Gestión' , '' , '' , 'cruizgallardon@tecnotramit.com' , '0'),
	T_TIPO_DATA('1','B86689494','yf7k97','Tinsa Certify' , '' , '' , 'bankiacee@tinsacertify.es' , '0'),
	T_TIPO_DATA('1','E07306210','zg7l92','Tous, March, Riutord Pane Abogados C.B.' , '' , '' , 'juanriutord@tous-riutord.com' , '0'),
	T_TIPO_DATA('1','A62690953','ah8m87','Unipost' , '' , '' , 'sfranco@unipost.es' , '0'),
	T_TIPO_DATA('1','B12640637','bi5n78','Unomil Arquitectos' , '' , '' , ' info@unomil.com' , '0'),
	T_TIPO_DATA('1','B98278799','cj5o54','Uransa Mantenimiento Integral' , '' , '' , 'administracion@grupogara.com' , '0'),
	T_TIPO_DATA('1','B98350077','dk2p49','Varenyam' , '' , '' , 'varenyamslu@gmail.com' , '0'),
	T_TIPO_DATA('1','B86561677','fm4r19','Vialegis Abogados' , '' , '' , 'p.coloma@vialegis.com' , '0'),
	T_TIPO_DATA('1','B98257116','gn5s61','Víctor Tormo ' , '' , '' , 'avela@victortormo.com' , '0'),
	T_TIPO_DATA('1','A04337309','ho7t98','ALBAIDA INFRAESTRUCTURAS, S.A.' , '' , '' , 'jamanrique@grupoalbaida.es' , '0'),
	T_TIPO_DATA('1','B65428583','ip7v48','ALTATAMARINDO S.L.U' , '' , '' , 'ALTATAMARINDO@GMAIL.COM' , '0'),
	T_TIPO_DATA('1','B04604195','jq9w23','ARTIS TERRA CONSTRUCCIONES S.L.' , '' , '' , 'antonio.yanes@artisterra.es' , '0'),
	T_TIPO_DATA('1','B23657521','kr1x15','AVANZASI S.L.U.' , '' , '' , 'eva@avanzasi.es' , '0'),
	T_TIPO_DATA('1','B98327943','ls5y25','Avanza Urbana Siglo XXI, SL' , '' , '' , 'slopez@avanzaurbana.com' , '0'),
	T_TIPO_DATA('1','B85084135','mt6z34','AVINTIA PROYECTOS Y CONSTRUCCIONES S.L.' , '' , '' , 'lseptien@avintia.es' , '0'),
	T_TIPO_DATA('1','B45684677','nv2a11','APLISER CONSTRUCCIONES Y REFORMAS SLU' , '' , '' , 'apliser.1@gmail.com' , '0'),
	T_TIPO_DATA('1','B04466256','ow1b41','BEGASA CONSTRUCCIONES PROYECTOS Y REFORMAS,S.L' , '' , '' , 'begasa@ya.com' , '0'),
	T_TIPO_DATA('1','B28205904','px8c54','BUREAU VERITAS IBERIA' , '' , '' , 'emilio.losada@es.bureauveritas.com' , '0'),
	T_TIPO_DATA('1','B92418524','qy6d26','CHIRIVO CONSTRUCCIONES,S.L.' , '' , '' , 'industrial@chirivo.com' , '0'),
	T_TIPO_DATA('1','B98380629','rz8e77','COISER-VIC21 SL' , '' , '' , 'coiser.vic@gmail.com' , '0'),
	T_TIPO_DATA('1','B04485686','sa6f28','Construcciones Angel Blanque Sanchez, sl' , '' , '' , 'admon@construccionesblanque.com' , '0'),
	T_TIPO_DATA('1','A04028023','tb6g34','CONSTRUCCIONES TEJERA S.A' , '' , '' , 'aj@grupotejera.com' , '0'),
	T_TIPO_DATA('1','B04405403','vc4h17','Construcciones Y Promociones Joneco S.L.' , '' , '' , 'joneco@hotmail.es' , '0'),
	T_TIPO_DATA('1','A04048088','wd7i81','CONSTRUCTORA DE OBRAS PUBLICAS ANDALUZAS (COPSA)' , '' , '' , 'estudios@grupocopsa.es' , '0'),
	T_TIPO_DATA('1','B18386375','xe1j61','COROYFER, SL' , '' , '' , 'coroyfer@coroyfer.com' , '0'),
	T_TIPO_DATA('1','B04524583','yf4k71','CORPROYEC ALMERIA SL' , '' , '' , 'corproyec@erenovables.com' , '0'),
	T_TIPO_DATA('1','B61425682','zg5l43','DIAGONALGEST SL' , '' , '' , 'm.reina@diagonalgest.com' , '0'),
	T_TIPO_DATA('1','B04490587','ah9m84','DIMENSUR S.L' , '' , '' , 'etortosa@dimensur.com' , '0'),
	T_TIPO_DATA('1','B04307120','bi3n84','DIMOBA SERVICIOS, S.L' , '' , '' , 'lbermejo@grupocontrol.com' , '0'),
	T_TIPO_DATA('1','B08658601','dk1p89','ECA S.L. GRUPO BUREAU VERITAS' , '' , '' , 'carmen.morillas@es.bureauveritas.com' , '0'),
	T_TIPO_DATA('1','A48027056','el4q92','ELECNOR, S.A.' , '' , '' , 'jlcubi@elecnor.es' , '0'),
	T_TIPO_DATA('1','B04341699','fm2r36','ELECTRICIDAD MONTAJES ALMERIA SL' , '' , '' , 'sergio@montajesalmeria.es' , '0'),
	T_TIPO_DATA('1','B04630075','gn7s87','electricidad y comunicaciones Gómez Ferre, sl' , '' , '' , 'manologs@gomezferre.es' , '0'),
	T_TIPO_DATA('1','A83263772','ho5t66','ELITIA Consultoría, S.A.U' , '' , '' , 'antonio.garcia@elitia-advisors.com' , '0'),
	T_TIPO_DATA('1','A81948077','ip3v37','ENDESA ENERGIA SAU' , '' , '' , 'juancarlos.arnedo@endesa.es' , '0'),
	T_TIPO_DATA('1','A15168156','jq3w42','ESPINA OBRAS HIDRÁULICAS S.A.' , '' , '' , 'espina.cl@espina.es' , '0'),
	T_TIPO_DATA('1','B96836739','kr1x18','ESTUDIO DE ARQUITECTURA Y URBANISMO, ' , 'LLORENS, FORNES Y NAVARRO S.L.P.' , '' , 'afornes@llfnarquitectos.com' , '0'),
	T_TIPO_DATA('1','B29770922','ls3y82','GENERAL DE VIALES S.L.' , '' , '' , 'fulgencio@generaldeviales.com' , '0'),
	T_TIPO_DATA('1','J04678785','ow8b16','GRUPO ALMICRAR,S.C' , '' , '' , 'mmmadrid18@gmail.com' , '0'),
	T_TIPO_DATA('1','A46092128','px7c51','GRUPO BERTOLIN,S.A.U.' , '' , '' , 'mcferrer@grupobertolin.es' , '0'),
	T_TIPO_DATA('1','A04038014','rz8e26','GRUPO CONTROL EMPRESA DE SEGURIDAD S.A.' , '' , '' , 'lbermejo@grupocontrol.com' , '0'),
	T_TIPO_DATA('1','B04482691','sa5f59','Iniciativas y Proyectos Contra el Fuego, S.L.' , '' , '' , 'juanjo@iniciativasfuego.es' , '0'),
	T_TIPO_DATA('1','A04028205','tb3g96','INSMOEL, S.A.' , '' , '' , 'ingenieria@insmoel.es' , '0'),
	T_TIPO_DATA('1','B04254793','vc8h36','Instalaciones Electricas Segura S.L.' , '' , '' , 'rafael.segura@instalacionessegura.es' , '0'),
	T_TIPO_DATA('1','B02118115','wd9i14','INTERACTIVA IBERGEST S.L.U.' , '' , '' , 'pgarcia@ibergest.net' , '0'),
	T_TIPO_DATA('1','B30473599','xe2j69','INVERSION Y EDIFICACIONES SODELOR SL' , '' , '' , 'pedrocazorla@sodelor.com' , '0'),
	T_TIPO_DATA('1','E04711990','zg8l61','J2 ARQUITECTOS CB' , '' , '' , 'estudio@j2arquitectos.com' , '0'),
	T_TIPO_DATA('1','A54496005','ah3m78','JARQUIL CONSTRUCCIÓN, SA' , '' , '' , 'contratacion@jarquil.com' , '0'),
	T_TIPO_DATA('1','B73156424','bi9n55','J. Martinez Arce y Asociados, S.L.' , '' , '' , 'acs@martinezarce.com' , '0'),
	T_TIPO_DATA('1','B04336301','cj4o77','José Ángel Ferrer Arquitectos, S.L.P.' , '' , '' , 'info@ferrerarquitectos.com' , '0'),
	T_TIPO_DATA('1','20447058N','dk5p62','Jose Octavio Ordinyana Poveda' , '' , '' , 'jose@ijarquitectos.com' , '0'),
	T_TIPO_DATA('1','73760763Q','fm9r15','Juan Carlos Navarro Navarro' , '' , '' , 'jcnavarro@llfnarquitectos.com' , '0'),
	T_TIPO_DATA('1','B57657207','gn6s31','Mantenimientos Reynes SLU' , '' , '' , 'abadia@mantenimientosreynes.com' , '0'),
	T_TIPO_DATA('1','B04264982','ho8t59','MAYFRA OBRAS Y SERVICIOS, S.L.' , '' , '' , 'fms@excavacionesmayfra.com' , '0'),
	T_TIPO_DATA('1','B04229548','ip1v29','Montajes de Electricidad Moya, S.L.' , '' , '' , 'antomoya@electricidadmoya.com' , '0'),
	T_TIPO_DATA('1','B04506614','jq3w66','Montajes Electricos Samblas s.l.u.' , '' , '' , 'gerente@samblas.net' , '0'),
	T_TIPO_DATA('1','B04697728','kr6x15','Obras Acocasa, SLU' , '' , '' , 'javier@acocasa.com' , '0'),
	T_TIPO_DATA('1','A82838350','ls9y99','OCT CONTROLIA, S.A.' , '' , '' , 'miguelrv@octcontrolia.com' , '0'),
	T_TIPO_DATA('1','B97279012','mt7z22','Procyr, Edificación y Urbanismo, s.l.' , '' , '' , 'ernesto.torregrosa@procyr.es' , '0'),
	T_TIPO_DATA('1','B53966560','nv8a75','Quadratia Consultants S.L.' , '' , '' , 'juanramon.rubio@quadratia.es' , '0'),
	T_TIPO_DATA('1','A79252219','ow6b93','SECURITAS SEGURIDAD ESPAÑA, S.A.' , '' , '' , 'angel.castano@securitas.es' , '0'),
	T_TIPO_DATA('1','B24503245','rz9e27','VALDENUCIELLO, S.L.' , '' , '' , 'jmgarciagonz@yahoo.es' , '0'),
	T_TIPO_DATA('1','B54624119','sa8f37','Valmesa & GB Projects SL' , '' , '' , 'francisco.diaz@valmesa.es' , '0'),
	T_TIPO_DATA('1','B85030641','tb5g21','VALUATION & REAL ESTATE GROUP, S.L. - MREG' , '' , '' , 'icruz@mreg.es' , '0'),
	T_TIPO_DATA('1','B96534805','vc2h99','VARESER 96, S.L.' , '' , '' , 'ofertas@vareser.net' , '0'),
	T_TIPO_DATA('1','A03319530','yf9k96','VALORACIONES MEDITERRÁNEO, S.A.' , '' , '' , 'reverte.sanchez@valmesa.es' , '0'),
	T_TIPO_DATA('1','B92687458','zp8p74','MALACITANA DE CONTROL, J.C., S.L.' , '' , '' , 'ISABEL@MALACITANADECONTROL.COM' , '0')
  ); 
  V_TMP_TIPO_DATA T_TIPO_DATA;
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');


 
   -- LOOP para insertar los valores en USU_USUARIOS -----------------------------------------------------------------
   DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN USU_USUARIOS ');
   FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
     LOOP
    
       V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
       --Comprobamos el dato a insertar
       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       
       --Si existe lo modificamos
       IF V_NUM_TABLAS > 0 THEN				         
			
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USU_USUARIOS...no se modifica nada.');
			
       ELSE
     
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');   
        
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_USU_USUARIOS.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.USU_USUARIOS (' ||
                      'USU_ID,
                       ENTIDAD_ID,
                       USU_USERNAME,
                       USU_PASSWORD,
                       USU_NOMBRE,
                       USU_APELLIDO1,
                        USU_TELEFONO,
                       USU_MAIL,
                       USU_GRUPO,
                       USU_FECHA_VIGENCIA_PASS,
                       USUARIOCREAR,
                       FECHACREAR,
                       BORRADO) ' ||
                      'SELECT '|| V_ID || ',
                      '''||V_TMP_TIPO_DATA(1)||''',
                      '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                      '''||TRIM(UPPER(V_TMP_TIPO_DATA(4)))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(5))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(6))||''',
                      '''||TRIM(LOWER(V_TMP_TIPO_DATA(7)))||''',
                      '''||TRIM(V_TMP_TIPO_DATA(8))||''',
                      SYSDATE+730,
                      ''DML'',
                      SYSDATE,
                      0 
                      FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
      
       END IF;
       
    END LOOP;
    
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]: USU_USUARIOS ACTUALIZADO CORRECTAMENTE ');
 

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
