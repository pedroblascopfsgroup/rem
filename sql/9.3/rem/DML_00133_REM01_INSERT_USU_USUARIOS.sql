--/*
--###########################################
--## AUTOR=Mª José Ponce
--## FECHA_CREACION=20200309
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9728
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de Usuarios genéricos REM para asociar a proveedores
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
	V_TABLA VARCHAR2(50 CHAR) := 'USU_USUARIOS';
	
	V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
	V_ENTIDAD_ID NUMBER(16);
	V_COUNT NUMBER(16);
	
	V_USUARIOCREAR VARCHAR2(50 CHAR) := 'HREOS-9728';

	
	-- Arrays de usuarios:
	TYPE T_ARRAY IS TABLE OF VARCHAR2(150 CHAR);
	TYPE T_USUARIOS IS TABLE OF T_ARRAY;
	
	V_USER T_USUARIOS := T_USUARIOS(
		T_ARRAY('pm.usugen1','JESUS GARCIA-VALCARCEL MUÑOZ-REPISO','jgv_arquitectos@coam.es','00817841F','Project Manager'),
		T_ARRAY('pm.usugen2','SANTIAGO GARCIA SALVATIERRA','santiago.garcia@sgsalvatierra.com','01112263Y','Project Manager'),
		T_ARRAY('pm.usugen3','JOSE FRANCISCO ALVAREZ CORREA','jcorrea@ciccp.es','11960644T','Project Manager'),
		T_ARRAY('pm.usugen4','ANA MARIA AMIANO SAN EMETERIO','amiano@coaatcan.com','13786488N','Project Manager'),
		T_ARRAY('pm.usugen5','JUAN JOSE BUJ TORRO','buj@buj.es','22527396T','Project Manager'),
		T_ARRAY('pm.usugen6','FRANCISCO JAVIER JIMENEZ VILARET','fvilaret@gmail.com','31670778P','Project Manager'),
		T_ARRAY('pm.usugen7','GRV Arquitectura','grv.arquitectura@gmail.com','33399807N','Project Manager'),
		T_ARRAY('pm.usugen8','BARTOLOME VILA ABAD','bva@caatvalencia.es','33411008N','Project Manager'),
		T_ARRAY('pm.usugen9','FRANCISCO MONFORTE GONZALEZ','fmg@coac.net','38549353L','Project Manager'),
		T_ARRAY('pm.usugen10','MARIA DEL CARMEN SANCHEZ LOPEZ','csl.carmensanchez@gmail.com','39169617L','Project Manager'),
		T_ARRAY('pm.usugen11','Drago32','drago32.Arquitectos@drago32.com','42793075B','Project Manager'),
		T_ARRAY('pm.usugen12','ANDREU XAVIER CORTES FORTEZA','andreucortesforteza@hotmail.com','43103849D','Project Manager'),
		T_ARRAY('pm.usugen13','ANGELS LOPEZ GARCIA','angels.lopez@aldesign.cat','43444793R','Project Manager'),
		T_ARRAY('pm.usugen14','CLEMENTE VERA PEREZ','clementeproyectos@gmail.com','45448954B','Project Manager'),
		T_ARRAY('pm.usugen15','SUSANA PAVON GARCIA','susana.pavon@upc.edu','46656452D','Project Manager'),
		T_ARRAY('pm.usugen16','MARIO CARBAJO LARGO','carbajo@carbajoarquitectotecnico.com','51671784F','Project Manager'),
		T_ARRAY('pm.usugen17','MIKEL ELIZONDO ALDASORO','elizondoaldasoro@gmail.com','72464475P','Project Manager'),
		T_ARRAY('pm.usugen18','MIRIAM VALDIVIESO FRAILE','m.valdivieso.fraile@gmail.com','72983409Q','Project Manager'),
		T_ARRAY('pm.usugen19','ALEJANDRO VASCO PINEDA','alevaspin@gmail.com','78715931H','Project Manager'),
		T_ARRAY('pm.usugen20','EUROCONTROL SA','jfernandez@eurocontrol.es','A28318012','Project Manager'),
		T_ARRAY('pm.usugen21','TASIBERICA SA','jgonzalez@gesiberica.com','A28842045','Project Manager'),
		T_ARRAY('pm.usugen22','GRATEC SA','gerencia@gratecsa.com','A35206846','Project Manager'),
		T_ARRAY('pm.usugen23','ARC ARQUITECTURA URBANISMO SOLUCIONES INMOB.SL','a.ibarra@arc-arquitectura.es','B10412500','Project Manager'),
		T_ARRAY('pm.usugen24','INGENIERIA Y ARQUITECTURA SEGORBE SL','inarse@inarse.com','B12486767','Project Manager'),
		T_ARRAY('pm.usugen25','GESTION PROCESO EDIFICATORIO SL','maserranogalan@gmail.com','B14656573','Project Manager'),
		T_ARRAY('pm.usugen26','OSOVI PROYECTOS SL','felix.vidaurreta@osoviproyectos.com','B20809364','Project Manager'),
		T_ARRAY('pm.usugen27','REURCO CONSULTORIA TECNICA SL','avicente@reurco.com','B25613282','Project Manager'),
		T_ARRAY('pm.usugen28','POINTERINVEST SL','fernando@pointerinvest.com','B27814664','Project Manager'),
		T_ARRAY('pm.usugen29','CETEC SL','mjodar@cetec.es','B30034870','Project Manager'),
		T_ARRAY('pm.usugen30','JORGE RODRIGUEZ CRUZ SL','jorge@estudiojrc.com','B38477451','Project Manager'),
		T_ARRAY('pm.usugen31','EMA ARQUITECTURA SL','estudio@emarquitectura.es','B38659306','Project Manager'),
		T_ARRAY('pm.usugen32','ASISTENCIA TECNICA INTEGRAL AL DESARROLLO INM.SL','aresarquitecto@hotmail.es','B47704838','Project Manager'),
		T_ARRAY('pm.usugen33','REGALADO SALA Y VALDES SL (RESULTA)','david.martinez@resultasoluciones.com','B54478755','Project Manager'),
		T_ARRAY('pm.usugen34','DOPEC SL','ntorres@dopec.com','B60452430','Project Manager'),
		T_ARRAY('pm.usugen35','GORINA I FARRES ARQUITECTES SL','rfarres@coac.cat','B61601712','Project Manager'),
		T_ARRAY('pm.usugen36','BAMMP ARQUITECTES I ASSOCIATS SL','pep.malgosa@bammp.com','B62572979','Project Manager'),
		T_ARRAY('pm.usugen37','ARQUITECTURA I MANAGEMENT EN CONSTRUCCIO SL','agrieraar@gmail.com','B63227508','Project Manager'),
		T_ARRAY('pm.usugen38','CIUDAD HERNANSANZ SL','eciudad@ciudad.es','B63918445','Project Manager'),
		T_ARRAY('pm.usugen39','SBS SIMON I BLANCO SL','lsimon@sbs-enginyers.com','B64168933','Project Manager'),
		T_ARRAY('pm.usugen40','GIPROC ARQUITECTURA TECNICA SL','giproc@giproc.com','B65019549','Project Manager'),
		T_ARRAY('pm.usugen41','APROTECNIC GROUP SL','e.fernandez@aprotecnic.com','B65472789','Project Manager'),
		T_ARRAY('pm.usugen42','INGENIERIA GESTION Y CONSULTORIA BARCELONA SL','josemanuel@igcbcn.onmicrosoft.com','B65987729','Project Manager'),
		T_ARRAY('pm.usugen43','Securama','es@securama.es','B73496200','Project Manager'),
		T_ARRAY('pm.usugen44','CONSTRUCCIONES JOFEMAR SL','cjofemar@cjofemar.e.telefonica.net','B78650322','Project Manager'),
		T_ARRAY('pm.usugen45','GESTION INTEGRAL DEL SUELO SL','ranton@gis-ingenieria.com','B81480352','Project Manager'),
		T_ARRAY('pm.usugen46','PRACTICA PROYECTOS SL','juan.vara@practicaproyectos.com','B81689093','Project Manager'),
		T_ARRAY('pm.usugen47','ASESORES DE OBRA CIVIL SL','juanlucampos@asocivil.com','B83697763','Project Manager'),
		T_ARRAY('pm.usugen48','OBRAS, DISEÑO Y VALORACION SL','odv@odvarquitectostecnicos.com','B84824044','Project Manager'),
		T_ARRAY('pm.usugen49','EBUS ESTUDIO DE ARQUITECTURA SL','lipygp@gmail.com','B84899996','Project Manager'),
		T_ARRAY('pm.usugen50','GAS ESTUDIO SL','galfaro@alfaro-manrique.com','B85166841','Project Manager'),
		T_ARRAY('pm.usugen51','JNC CONSULTORES SL','jlfernandez@jncconsultores.com','B85644888','Project Manager'),
		T_ARRAY('pm.usugen52','ATEC GESTION DE INMUEBLES SL','hescudero@atecinmuebles.com','B87350690','Project Manager'),
		T_ARRAY('pm.usugen53','GESTION Y SERVICIOS ACTIVOS Y BIENES INM.SL','m.herrera@gesebi.es','B90116179','Project Manager'),
		T_ARRAY('pm.usugen54','VEGA 15, ARQUITECTURA Y URBANISMO SL','jbt@vega15.com','B90205618','Project Manager'),
		T_ARRAY('pm.usugen55','ARQUERMO ARQUITECTOS SL','jcobreros@clavesdegestion.es','B91404921','Project Manager'),
		T_ARRAY('pm.usugen56','STRICTE SL','jperez@stricte.es','B91406264','Project Manager'),
		T_ARRAY('pm.usugen57','FACTOR(IA), ARQUITECTURA Y URBANISMO SL','factor-ia@factor-ia.com','B91544395','Project Manager'),
		T_ARRAY('pm.usugen58','TINATEC SL','gar.tinatec@gmail.com','B92886803','Project Manager'),
		T_ARRAY('pm.usugen59','JAAM SOCIEDAD DE ARQUITECTURA SL','juncal@jaam.es','B95366183','Project Manager'),
		T_ARRAY('pm.usugen60','ALGESCON LEVANTE SL','gonzalo@algescon.com','B96565981','Project Manager'),
		T_ARRAY('pm.usugen61','Llorens Fornes y Navarro','laura@llfnarquitectos.com','B96836739','Project Manager'),
		T_ARRAY('pm.usugen62','ASSISTA CASA 2005 SL','c.sanz@grupoassista.com','B97600001','Project Manager'),
		T_ARRAY('pm.usugen63','TERRRITORIO CIUDAD Y HABITAT SL','tcarrasco@tcharquitectura.com','B98316730','Project Manager'),
		T_ARRAY('pm.usugen64','ACTUA','jorgemarco@actua-ga.es','B98562036','Project Manager'),
		T_ARRAY('pm.usugen65','DESARROLLOS URBANISTICOS DE ZARAGOZA SL','isainz@deurza.es','B99101156','Project Manager'),
		T_ARRAY('pm.usugen66','Akra','amador.suarez@grupoakra.es','E54696950','Project Manager'),
		T_ARRAY('pm.usugen67','ESTUDIO Q. ARQUITECTURA Y URBANISMO SC','estudio@qarq.es','J70038708','Project Manager'),
		T_ARRAY('dd.usugen68','JOSE IGNACIO PUERTAS MEDINA','joseignaciopuertas@gmail.com','19848053L','Proveedor DD'),
		T_ARRAY('dd.usugen69','JOSE OCTAVIO ORDINYANA POVEDA','jose@ijarquitectos.com','20447058N','Proveedor DD'),
		T_ARRAY('dd.usugen70','JUSTINO ANDRES ALONSO HERMOSA','justino@adagronomos.es','22562062M','Proveedor DD'),
		T_ARRAY('dd.usugen71','ARISTEA CORTES BALLESTER','acortesbal@gmail.com','29010659T','Proveedor DD'),
		T_ARRAY('dd.usugen72','GRV Arquitectura','grv.arquitectura@gmail.com','33399807N','Proveedor DD'),
		T_ARRAY('dd.usugen73','Drago32','drago32.Arquitectos@drago32.com','42793075B','Proveedor DD'),
		T_ARRAY('dd.usugen74','Alfonso Ortega Garcia','10530ortega@coam.es','50074661G','Proveedor DD'),
		T_ARRAY('dd.usugen75','JUAN JOSE CAPOTE JURADO','juanjo.capote@coacordoba.net','80147162M','Proveedor DD'),
		T_ARRAY('dd.usugen76','INVESTIGACIÓN Y CONTROL DE CALIDAD S.A.U','clientes@incosa.es','A24036691','Proveedor DD'),
		T_ARRAY('dd.usugen77','OMICRON AMEPRO SA','isuarez@omicronamepro.es','A28520278','Proveedor DD'),
		T_ARRAY('dd.usugen78','VALTECNIC SA','bcabeza@organismodecontrol.com','A28903920','Proveedor DD'),
		T_ARRAY('dd.usugen79','OCT CONTROLIA, S.A.','silviagarcia@controliaga.com','A82838350','Proveedor DD'),
		T_ARRAY('dd.usugen80','José Ángel Ferrer Arquitectos, S.L.P.','info@ferrerarquitectos.com','B04336301','Proveedor DD'),
		T_ARRAY('dd.usugen81','ARKU3 URBAN SLP','marcribes@arku3.com','B25752395','Proveedor DD'),
		T_ARRAY('dd.usugen82','ECA S.L. GRUPO BUREAU VERITAS ','buraudio@buraudio.com','B28205904','Proveedor DD'),
		T_ARRAY('dd.usugen83','Unicontrol','chinjos@unicontrol.es','B45740818','Proveedor DD'),
		T_ARRAY('dd.usugen84','Resulta Soluciones inmobiliarias','david.martinez@resultasoluciones.com','B54478755','Proveedor DD'),
		T_ARRAY('dd.usugen85','Akra','amador.suarez@grupoakra.es','B54780697','Proveedor DD'),
		T_ARRAY('dd.usugen86','APROTECNIC GROUP SL','e.fernandez@aprotecnic.com','B65472789','Proveedor DD'),
		T_ARRAY('dd.usugen87','Securama','es@securama.es','B73496200','Proveedor DD'),
		T_ARRAY('dd.usugen88','UVE','mlq@v-valoraciones.es','B86140878','Proveedor DD'),
		T_ARRAY('dd.usugen89','Almar Consulting','info@almarconsulting.com','B86408374','Proveedor DD'),
		T_ARRAY('dd.usugen90','Tinsa Certify','marta.garciahernandez@tinsa.com','B86689494','Proveedor DD'),
		T_ARRAY('dd.usugen91','GESVALT PROPERTY SERVICES SL','jpgil@gesvaltservices.es','B87212122','Proveedor DD'),
		T_ARRAY('dd.usugen92','ALL GLOBAL','maberengue@allgpm.es','B87300349','Proveedor DD'),
		T_ARRAY('dd.usugen93','FM Ingenieros','gizquierdo@fmingenieros.com','B87764841','Proveedor DD'),
		T_ARRAY('dd.usugen94','Premea','premea@premea.com','B96595897','Proveedor DD'),
		T_ARRAY('dd.usugen96','Llorens Fornes y Navarro','laura@llfnarquitectos.com','B96836739','Proveedor DD'),
		T_ARRAY('dd.usugen97','ACTUA','jorgemarco@actua-ga.es','B98562036','Proveedor DD'),
		T_ARRAY('dnd.usugen98','JESUS GARCIA-VALCARCEL MUÑOZ-REPISO','jgv_arquitectos@coam.es','00817841F','Proveedor DND'),
		T_ARRAY('dnd.usugen99','Estudio Mónica Alcántara','arquitectura@monicaalcantara.es','0385439P','Proveedor DND'),
		T_ARRAY('dnd.usugen100','JOSE OCTAVIO ORDINYANA POVEDA','jose@ijarquitectos.com','20447058N','Proveedor DND'),
		T_ARRAY('dnd.usugen101','JUAN JOSE BUJ TORRO','buj@buj.es','22527396T','Proveedor DND'),
		T_ARRAY('dnd.usugen102','Juan Montiel Fernandez','mofe1192@gmail.com','24871325E','Proveedor DND'),
		T_ARRAY('dnd.usugen103','Caser','jaimepena@caser.es','28013050','Proveedor DND'),
		T_ARRAY('dnd.usugen104','Aránzazu Carvajal','acarvajalcoro@gmail.com','33529494W','Proveedor DND'),
		T_ARRAY('dnd.usugen105','Reyes Gómez Martín','arquitectoreyesg@gmail.com','3845509R','Proveedor DND'),
		T_ARRAY('dnd.usugen106','Alfonso Ortega Garcia','10530ortega@coam.es','50074661G','Proveedor DND'),
		T_ARRAY('dnd.usugen107','Patricio Herguido Palomar','phparquitectura@hotmail.com','50279700K','Proveedor DND'),
		T_ARRAY('dnd.usugen108','Jose Antonio Martín Rodríguez','rodrimar8888@gmail.com','50301648-B','Proveedor DND'),
		T_ARRAY('dnd.usugen109','Fermín Alfaro','f.alfaroarregui@gmail.com','50709220Q','Proveedor DND'),
		T_ARRAY('dnd.usugen110','Juan Carlos García Herrero','jcgarcia@ese-dos.es','51372454E','Proveedor DND'),
		T_ARRAY('dnd.usugen111','Mariano Álvarez Pulido','malvarezpulido@gmail.com','52474186P','Proveedor DND'),
		T_ARRAY('dnd.usugen112','Alejandro Tejedor','alejandro.tejedorcalvo@gmail.com','52657376A','Proveedor DND'),
		T_ARRAY('dnd.usugen113','GUILLERMO GOMEZ SOLBAS','guillermogomezsolbas@gmail.com','75723391P','Proveedor DND'),
		T_ARRAY('dnd.usugen114','REFORMAS SG','reformas.sg@hotmail.com','78472108H','Proveedor DND'),
		T_ARRAY('dnd.usugen115','JUAN JOSE CAPOTE JURADO','juanjo.capote@coacordoba.net','80147162M','Proveedor DND'),
		T_ARRAY('dnd.usugen116','INSMOEL, S.A.','ingenieria@insmoel.es','A04028205','Proveedor DND'),
		T_ARRAY('dnd.usugen117','GRUPO CONTROL EMPRESA DE SEGURIDAD, S.A.','lbermejo@grupocontrol.com','A04038014','Proveedor DND'),
		T_ARRAY('dnd.usugen118','ALBAIDA INFRAESTRUCTURAS, S.A.','albaida@grupoalbaida.es','A04337309','Proveedor DND'),
		T_ARRAY('dnd.usugen119','ANTONIO GOMILA SA','jaen@antoniogomila.com','A07405681','Proveedor DND'),
		T_ARRAY('dnd.usugen120','AQUALIA GESTIÓN INTEGRAL DEL AGUA,SA','www.aqualia.es','A26019992','Proveedor DND'),
		T_ARRAY('dnd.usugen121','CASER','MGALEANO@aciertaasistencia.es/','A28013050','Proveedor DND'),
		T_ARRAY('dnd.usugen122','EL CORTE INGLES S.A','empresas_granada@elcorteingles.es','A28017895','Proveedor DND'),
		T_ARRAY('dnd.usugen123','INTEMAC','ediaz@intemac.es','A28184661','Proveedor DND'),
		T_ARRAY('dnd.usugen124','EUROCONTROL','valencia@eurocontrol.es','A28318012','Proveedor DND'),
		T_ARRAY('dnd.usugen125','S.G.S. TECNOS SA','es.sgs.anida@sgs.com','A28345577','Proveedor DND'),
		T_ARRAY('dnd.usugen126','Acierta','vlabella@aciertaasistencia.es','A28346054','Proveedor DND'),
		T_ARRAY('dnd.usugen127','Ferroser','ferroser@ferroser.com','A28672038','Proveedor DND'),
		T_ARRAY('dnd.usugen128','ERVEGA SA','jm@ervega.es','A29353893','Proveedor DND'),
		T_ARRAY('dnd.usugen129','Sedes','pomar@sedes.es','A33002106','Proveedor DND'),
		T_ARRAY('dnd.usugen130','Peralte','obras@peralte.es','A33649138','Proveedor DND'),
		T_ARRAY('dnd.usugen131','GRUPO BERTOLIN S.A.','bertolin@grupobertolin.es','A46092128','Proveedor DND'),
		T_ARRAY('dnd.usugen132','ELECNOR','notificacioneshaya@elecnor.es','A48027056','Proveedor DND'),
		T_ARRAY('dnd.usugen133','JARQUIL CONSTRUCCION, SA','contratacion@grupojarquil.com','A54496005','Proveedor DND'),
		T_ARRAY('dnd.usugen134','Rege Ibérica','avilla@regeiberica.es','A78208410','Proveedor DND'),
		T_ARRAY('dnd.usugen135','MEDICINA DE DIAGNOSTICO Y CONTROL SA','mdiaz@medycsa.com','A78339769','Proveedor DND'),
		T_ARRAY('dnd.usugen136','SACYR CONSTRUCCION SAU','zlopez@sacyr.com','A78366382','Proveedor DND'),
		T_ARRAY('dnd.usugen137','Seranco','estudios@seranco.es','A79189940','Proveedor DND'),
		T_ARRAY('dnd.usugen138','SECURITAS DIRECT ESPAÑA, SAU','maria.cuesta@securitas.es','A79252219','Proveedor DND'),
		T_ARRAY('dnd.usugen139','GESTVAL','direccioncomercial@gesvalt.es','A80884372','Proveedor DND'),
		T_ARRAY('dnd.usugen140','ESCREYES, S.A.','david@escreyes.com','A93192946','Proveedor DND'),
		T_ARRAY('dnd.usugen141','GRUPO G. PROTECCION Y SEGURIDAD, S.A.','seguridad@grupog.es','A96244421','Proveedor DND'),
		T_ARRAY('dnd.usugen142','INTERACTIVA IBERGEST SLU','clientes@ibergest.net','B02118115','Proveedor DND'),
		T_ARRAY('dnd.usugen143','GESTIMED LEVANTE S.L.','cimenta2@grupogestimed.es','B03830510','Proveedor DND'),
		T_ARRAY('dnd.usugen144','ICC Control de Calidad S.L','alopez@icc-laboratorio.com','B04122883','Proveedor DND'),
		T_ARRAY('dnd.usugen145','ODYSMA, S.L.','info@odysma.com','B04219424','Proveedor DND'),
		T_ARRAY('dnd.usugen146','MONTAJES DE ELECTRICIDAD MOYA, SL','central@electricidadmoya.com','B04229548','Proveedor DND'),
		T_ARRAY('dnd.usugen147','INSTALACIONES ELECTRICAS SEGURA, S.L.','lkm@instalacionessegura.es','B04254793','Proveedor DND'),
		T_ARRAY('dnd.usugen148','EXCAVACIONES MAYFRA, S.L.','fms@excavacionesmayfra.com','B04264982','Proveedor DND'),
		T_ARRAY('dnd.usugen149','DIMOBA SERVICIOS, S.L.','smembrilla@dimoba.com','B04307120','Proveedor DND'),
		T_ARRAY('dnd.usugen150','José Ángel Ferrer Arquitectos, S.L.P.','info@ferrerarquitectos.com','B04336301','Proveedor DND'),
		T_ARRAY('dnd.usugen151','CONSTRUCCIONES Y PROMOCIONES JONECO, SL','joneco@hotmail.es','B04405403','Proveedor DND'),
		T_ARRAY('dnd.usugen152','CONSTRUCCIONES ANGEL BLANQUE SANCHEZ, S.L.','admon@construccionesblanque.com','B04485686','Proveedor DND'),
		T_ARRAY('dnd.usugen153','ARTISTERRA S.L','atc@artisterra.es','B04604195','Proveedor DND'),
		T_ARRAY('dnd.usugen154','CONSTRUCTORA OBRAS PUBLICAS ANDALUZAS (COPSA)','estudios@grupocopsa.es','B04764809','Proveedor DND'),
		T_ARRAY('dnd.usugen155','J2 DE SIMON Y CUERVA ARQUITECTOS SLP','estudio@j2arquitectos.com','B04816906','Proveedor DND'),
		T_ARRAY('dnd.usugen156','EVINTES CALIDAD S.L.L','jretamero@evintes.com; ','B04824280','Proveedor DND'),
		T_ARRAY('dnd.usugen157','ACTEIN SERVICIOS SL','proyectos@acteinservicios.com','B06559470','Proveedor DND'),
		T_ARRAY('dnd.usugen158','ORICONST DE EDIFICACIONES Y CONST. SL','const.orihuela@hotmail.com','B11766268','Proveedor DND'),
		T_ARRAY('dnd.usugen159','URVISA CUATRO SL','nestorgarcia@ingse.es','B12082368','Proveedor DND'),
		T_ARRAY('dnd.usugen160','CONSTRUCCIONES TOMAS Y LUIS SL','belen@gruporoldan.es','B12398038','Proveedor DND'),
		T_ARRAY('dnd.usugen161','ESTUDIOS Y MÉTODOS DE LA RESTAURACIÓN','emr@emr.es','B12530770','Proveedor DND'),
		T_ARRAY('dnd.usugen162','KAABA','kaabaarquitectura@gmail.com','B-13384235','Proveedor DND'),
		T_ARRAY('dnd.usugen163','EDIFEST SL','edificacio@edifestsl.com','B17787334','Proveedor DND'),
		T_ARRAY('dnd.usugen164','COANFI SL','rchueca@coanfi.com','B22292163','Proveedor DND'),
		T_ARRAY('dnd.usugen165','AVANZA SERVICIOS INTEGRALES SLU','recuperaciones@avanzasi.es','B23657521','Proveedor DND'),
		T_ARRAY('dnd.usugen166','GESLEON, SL','selene@gesleon.es','B24263907','Proveedor DND'),
		T_ARRAY('dnd.usugen167','CONSTRUCCIONES LOPEZ ALVAREZ SL','lopezalvarezsl@gmail.com','B24356800','Proveedor DND'),
		T_ARRAY('dnd.usugen168','VALDENUCIELLO, SL','tecnico@vdl.es','B24503245','Proveedor DND'),
		T_ARRAY('dnd.usugen169','B-BIOSCA SL','darmengol@b-biosca.cat','B25250598','Proveedor DND'),
		T_ARRAY('dnd.usugen170','CONSPIME CERDAÑA SL','oficina2@conspime.com','B25483884','Proveedor DND'),
		T_ARRAY('dnd.usugen171','BUREAU VERITAS','rut.ramos@es.bureauveritas.com','B28205904','Proveedor DND'),
		T_ARRAY('dnd.usugen172','FLORESUR SL','contratacion@floresur.com','B29353026','Proveedor DND'),
		T_ARRAY('dnd.usugen173','GENERAL DE VIALES, S.L.','administracion@generaldeviales.com','B29770922','Proveedor DND'),
		T_ARRAY('dnd.usugen174','ADAM, SL','adamsl@adamsl.com','B30090674','Proveedor DND'),
		T_ARRAY('dnd.usugen175','INVERSIONES Y CONTRATAS SODELOR','sodelor@sodelor.com','B30473599','Proveedor DND'),
		T_ARRAY('dnd.usugen176','4 Real Arquitectura e Ingeniería','lamet@4real.es','B32324527','Proveedor DND'),
		T_ARRAY('dnd.usugen177','BZ99','info@bz99.es','B35680149','Proveedor DND'),
		T_ARRAY('dnd.usugen178','SERVICIOS INTEGRALES','central@serviciosintegralesdecanarias.com','B35828995','Proveedor DND'),
		T_ARRAY('dnd.usugen179','MONTAJES E INSTALACIONES CANARIAS 2008 SL','jpadron@mic2008.es','B35992304','Proveedor DND'),
		T_ARRAY('dnd.usugen180','CONSTRUCCIONES DALTRE SL','cbengtson@grupodaltre.com','B38281945','Proveedor DND'),
		T_ARRAY('dnd.usugen181','CONST. Y REFORMAS M. BERNABE SL','cbernabe68@gmail.com','B38393112','Proveedor DND'),
		T_ARRAY('dnd.usugen182','PINTURAS Y DECORACIONES GRANA SL','pinturasgrana@hotmail.com','B38467874','Proveedor DND'),
		T_ARRAY('dnd.usugen183','SIVERIO LOPEZ COACH CONSTRUCCION SL','info@coachconstruccion.com','B38966362','Proveedor DND'),
		T_ARRAY('dnd.usugen184','GRUA DE PIEDRA SL','tecnico2@gruadepiedra.es','B39710504','Proveedor DND'),
		T_ARRAY('dnd.usugen185','INV','fcuenca@invseguridad.com','B40165920','Proveedor DND'),
		T_ARRAY('dnd.usugen186','Muñoz y Doblado','munozydoblado@hotmail.com','B45346590','Proveedor DND'),
		T_ARRAY('dnd.usugen187','APLISER CONSTRUCCIONES Y REFORMAS, S.L.U.','apliser.1@gmail.com','B45684677','Proveedor DND'),
		T_ARRAY('dnd.usugen188','PROYME GRUPO GESTION SL','proyme@proyme.es','B46635991','Proveedor DND'),
		T_ARRAY('dnd.usugen189','PROVISER','gvalleinclan@proviser.es','B47667415','Proveedor DND'),
		T_ARRAY('dnd.usugen190','Corolla Arquitectura','jorgeparaja@gmail.com','B52538691','Proveedor DND'),
		T_ARRAY('dnd.usugen191','Urbana exteriores','psaez@urbanadeexteriores.com','B53546040','Proveedor DND'),
		T_ARRAY('dnd.usugen192','AGLOMERADOS OBRAS Y CANTERAS DELTA SL','aglodelta@aglodelta.es','B53952370','Proveedor DND'),
		T_ARRAY('dnd.usugen193','TRISOLIA INVESTMENT SLU','jose@trisolia.es;jruiz@trisolia.es','B54448097','Proveedor DND'),
		T_ARRAY('dnd.usugen194','AKRA INFRAESTRUCTURAS SL','amador.suarez@grupoakra.es','B54780697','Proveedor DND'),
		T_ARRAY('dnd.usugen195','Cimex','jmdana@cimexsu.com','B58292392','Proveedor DND'),
		T_ARRAY('dnd.usugen196','Dorseran','lis@dorseran.net','B60546611','Proveedor DND'),
		T_ARRAY('dnd.usugen197','HERA HOLDING HABITAT, ECOLOGIA REST.AMBIENTAL SL','fernando.herreros@heraholding.com','B61540969','Proveedor DND'),
		T_ARRAY('dnd.usugen198','ARQUITECTURA I MANAGEMENT EN CONSTRUCCIO SL','agrieraar@gmail.com','B63227508','Proveedor DND'),
		T_ARRAY('dnd.usugen199','INSTAL LACIONS I REPARACIONS COBO SL','quim.boada@icobo.es','B64052392','Proveedor DND'),
		T_ARRAY('dnd.usugen200','SBS SIMON I BLANCO SL','lsimon@sbs-enginyers.com','B64168933','Proveedor DND'),
		T_ARRAY('dnd.usugen201','PROMOLLONCH','jordi@promollonch.com','B64381387','Proveedor DND'),
		T_ARRAY('dnd.usugen202','ALTATAMARINDO, SL','ALTATAMARINDO@GMAIL.COM','B65428583','Proveedor DND'),
		T_ARRAY('dnd.usugen203','APROTECNIC','e.fernandez@aprotecnic.com','B65472789','Proveedor DND'),
		T_ARRAY('dnd.usugen204','Active','x.milanes@activeobras.com','B66258831','Proveedor DND'),
		T_ARRAY('dnd.usugen205','OBRAS Y REFORMAS DAVARA SL','david_varela@davarasl.com','B70173281','Proveedor DND'),
		T_ARRAY('dnd.usugen206','ACODAR 2010 SL','ecores@acodar.com','B70258819','Proveedor DND'),
		T_ARRAY('dnd.usugen207','PROGUARD SISTEMAS, SL','proguard@proguardsistemas.com','B73281081','Proveedor DND'),
		T_ARRAY('dnd.usugen208','AREA NAOS CONSTRUCCION SLU','lgerardo@areaconstruccion.es','B76536242','Proveedor DND'),
		T_ARRAY('dnd.usugen209','ARTEK REFORMAS CANARIAS SL','artekreformas@gmail.com','B76676709','Proveedor DND'),
		T_ARRAY('dnd.usugen210','AUIA Arquitectos e Ingenieros','f.soriano@auia.es','B78018017','Proveedor DND'),
		T_ARRAY('dnd.usugen211','ARQUIPROYECT, S.L.','proyectos@aqparquitectos.com','B80379308','Proveedor DND'),
		T_ARRAY('dnd.usugen212','INGENIERIA Y PREVENCION DE RIESGOS SL','pedro.garcia@imasp.net','B81470841','Proveedor DND'),
		T_ARRAY('dnd.usugen213','GILSA CONSERVACION Y MANTENIMIENTO SL','administracion@gilsagilper.com','B82409681','Proveedor DND'),
		T_ARRAY('dnd.usugen214','ENDESA DISTRIBUCION ELÉCTRICA, SL','diego.berenguel@endesa.es','B82846817','Proveedor DND'),
		T_ARRAY('dnd.usugen215','Arkitools','luisgarciagil@arkitools.com','B83337568','Proveedor DND'),
		T_ARRAY('dnd.usugen216','TERRALIA CONSTRUCCIONES','administracion@terraliaconstrucciones.com','B83567693','Proveedor DND'),
		T_ARRAY('dnd.usugen217','INVERTOL PROMOCION E INVERSION INMOBILIARIA S.L.','control@invertol.com','B84105899','Proveedor DND'),
		T_ARRAY('dnd.usugen218','FUTURE ARQUITECTURAS SL','martin@arqfuture.com','B84709492','Proveedor DND'),
		T_ARRAY('dnd.usugen219','VALUATION & REAL ESTATE GROUP SL','icruz@mreg.es','B85030641','Proveedor DND'),
		T_ARRAY('dnd.usugen220','Brick/Avintia','hayaincidencias@avintiaservicios.com','B85343721','Proveedor DND'),
		T_ARRAY('dnd.usugen221','ABLE, CONSTRUCCION Y MONTAJES DE EFIMEROS SL','departamentoobras@able-cme.com','B85402501','Proveedor DND'),
		T_ARRAY('dnd.usugen222','PROGRESA XCI SL','joseluisdiaz@progresaxci.es','B85757300','Proveedor DND'),
		T_ARRAY('dnd.usugen223','4Real','lamet@4real.es','B86036290','Proveedor DND'),
		T_ARRAY('dnd.usugen224','ORGANISMO DE CONTROL DE OBRAS SL','bcabeza@organismodecontrol.com','B86189651','Proveedor DND'),
		T_ARRAY('dnd.usugen225','MatFo- cgi','ricardo.font@matfo-cgi.com','B86910825','Proveedor DND'),
		T_ARRAY('dnd.usugen226','GESVALT PROPERTY SERVICES SL','jpgil@gesvaltservices.es','B87212122','Proveedor DND'),
		T_ARRAY('dnd.usugen227','OBRAS PIÑA MARTIN SL (OPIMA)','opimasl@hotmail.com','B91903278','Proveedor DND'),
		T_ARRAY('dnd.usugen228','CEMALSA Expertos en Calidad S.L.','laboratorio@cemalsa.com','B92084060','Proveedor DND'),
		T_ARRAY('dnd.usugen229','PROSECO INGENIERIA S.L.P.','prosecoingenieria@yahoo.es','B92203413','Proveedor DND'),
		T_ARRAY('dnd.usugen230','CHIRIVO CONSTRUCCIONES S.L.','industrial@chirivo.com','B92418524','Proveedor DND'),
		T_ARRAY('dnd.usugen231','EJECUCION DEL PLANEAMIENTO 2 SLP','fernando.garcia.pulido@edp-sl.com','B92710698','Proveedor DND'),
		T_ARRAY('dnd.usugen232','DECOPROYECTOS PENINSULAR SL','decoproyectos.angel@gmail.com','B93069300','Proveedor DND'),
		T_ARRAY('dnd.usugen233','UCI','fhervas@ucisl.es','B93456275','Proveedor DND'),
		T_ARRAY('dnd.usugen234','B&S Castro Arquitectura S.L.P.','benitocastroestevez@hotmail.com ','B94084233','Proveedor DND'),
		T_ARRAY('dnd.usugen235','VARESER 96 S.L.','ofertas@vareser.net','B96534805','Proveedor DND'),
		T_ARRAY('dnd.usugen236','CTRES 97 SL','sergio@ctres.net','B96683149','Proveedor DND'),
		T_ARRAY('dnd.usugen237','GRUPO INNOVA TORMO SL','jjdepedro@enlucidostormo.com','B96683420','Proveedor DND'),
		T_ARRAY('dnd.usugen238','EST.ARQ.URBANISMO, LLORENS,FORNES Y NAVARRO SLP.','estudio@llfnarquitectos.com','B96836739','Proveedor DND'),
		T_ARRAY('dnd.usugen239','PROCYR EDIFICACIÓN Y URBANISMO S.L.','ernesto.torregrosa@procyr.es','B97279012','Proveedor DND'),
		T_ARRAY('dnd.usugen240','ARTEASVAL, S.L.','arteasval@runbox.com','B97513691','Proveedor DND'),
		T_ARRAY('dnd.usugen241','ARQUITECTURA Y URBANISMO SINGULARQ SLP','estudio@qarq.es','B97570063','Proveedor DND'),
		T_ARRAY('dnd.usugen242','ASSISTA','jm.asensi@grupoassista.com','B97600001','Proveedor DND'),
		T_ARRAY('dnd.usugen243','PROYME GRUPO GESTION SL','proyme@proyme.es','B97788582','Proveedor DND'),
		T_ARRAY('dnd.usugen244','Vainsa Infraestructuras','jvanacloig@vainsa.es','B98296486','Proveedor DND'),
		T_ARRAY('dnd.usugen245','AVANZA URBANA SIGLO XXI SL','mmpuchades@avanzaurbana.com','B98327943','Proveedor DND'),
		T_ARRAY('dnd.usugen246','VARENYAM','varenyamslu@gmail.com','B98350077','Proveedor DND'),
		T_ARRAY('dnd.usugen247','Integraval','luis@integraval.es','B98493190','Proveedor DND'),
		T_ARRAY('dnd.usugen248','Reuna','rafavillalba@reuna.es','B98631633','Proveedor DND'),
		T_ARRAY('dnd.usugen249','Obras y estructuras Hidalgo','obrashidalgo@hotmail.com','B98685654','Proveedor DND'),
		T_ARRAY('dnd.usugen250','ELECTROCER','celectrocervic@hotmail.com','B98692676','Proveedor DND'),
		T_ARRAY('dnd.usugen251','DEGESER','degeser@degeser.com','B98792823','Proveedor DND'),
		T_ARRAY('dnd.usugen252','J2 PROJECTS','estudio@j2arquitectos.com','E04711990','Proveedor DND'),
		T_ARRAY('dnd.usugen253','GRUPO ALMICRAR S.C.','mmmadrid18@gmail.com','J04678785','Proveedor DND'),
		T_ARRAY('dnd.usugen254','Alonso y Barrientos','ALONSOYBARRIENTOS@telefonica.net','J39419338','Proveedor DND')		
	);
	V_TMP_USU T_ARRAY;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	FOR I IN V_USER.FIRST .. V_USER.LAST
	LOOP
		V_TMP_USU := V_USER(I);
		
		DBMS_OUTPUT.PUT_LINE('');
		DBMS_OUTPUT.PUT_LINE('[INFO]: Inserción del usuario '''||V_TMP_USU(1)||'''');
		DBMS_OUTPUT.PUT_LINE('[INFO]:		Comprobando que el registro no exista...');
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' WHERE USU_USERNAME = '''||V_TMP_USU(1)||'''';
		--DBMS_OUTPUT.PUT_LINE(''||V_SQL||'');
		EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
		IF V_COUNT = 0 THEN			
			
			V_SQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TABLA||' 
			(USU_ID, ENTIDAD_ID, USU_USERNAME,USU_PASSWORD,USU_NOMBRE, USU_MAIL, USUARIOCREAR,FECHACREAR,USU_FECHA_VIGENCIA_PASS,BORRADO)
	
			SELECT '||V_ESQUEMA_M||'.S_USU_USUARIOS.NEXTVAL,
			1,
			'''||V_TMP_USU(1)||''',
			''1234'',
			'''||V_TMP_USU(2)||''',
			'''||V_TMP_USU(3)||''',				
			'''||V_USUARIOCREAR||''',
			SYSDATE,
			(SELECT SYSDATE + INTERVAL ''2'' YEAR FROM DUAL),			
			0
			FROM DUAL			
			';
			
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Usuario '''||V_TMP_USU(1)||''' insertado correctamente');

		ELSE 
			DBMS_OUTPUT.PUT_LINE('[ WRN ]: El usuario '''||V_TMP_USU(1)||''' ya existe.');
		END IF;
	END LOOP;

	COMMIT;	

	DBMS_OUTPUT.PUT_LINE('[FIN]: Los usuarios se han insertado correctamente en la tabla '||V_TABLA||'.');

EXCEPTION
	WHEN OTHERS THEN
		ERR_NUM := SQLCODE;
		ERR_MSG := SQLERRM;
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(ERR_MSG);

		ROLLBACK;
		RAISE;          
	END;
/
EXIT
