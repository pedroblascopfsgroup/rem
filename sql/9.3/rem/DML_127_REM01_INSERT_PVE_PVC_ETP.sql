--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200227
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9607
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en proveedores los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
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
    V_ID_COD_REM NUMBER(16);
    V_ID_PVC NUMBER(16);
    V_ID_ETP NUMBER(16);
    V_BOOLEAN NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-9607';
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('JESUS GARCIA-VALCARCEL MUÑOZ-REPISO','00817841F','jgv_arquitectos@coam.es',1,'41',0,0,0,0,1),
      T_TIPO_DATA('SANTIAGO GARCIA SALVATIERRA','01112263Y','santiago.garcia@sgsalvatierra.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('JOSE FRANCISCO ALVAREZ CORREA','11960644T','jcorrea@ciccp.es',1,'41',0,0,0,0,1),
      T_TIPO_DATA('ANA MARIA AMIANO SAN EMETERIO','13786488N','amiano@coaatcan.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('JUAN JOSE BUJ TORRO','22527396T','buj@buj.es',1,'41',0,0,0,0,1),
      T_TIPO_DATA('FRANCISCO JAVIER JIMENEZ VILARET','31670778P','fvilaret@gmail.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('GRV Arquitectura','33399807N','grv.arquitectura@gmail.com',1,'41',1,1,0,0,0),
      T_TIPO_DATA('BARTOLOME VILA ABAD','33411008N','bva@caatvalencia.es',1,'41',0,0,0,0,1),
      T_TIPO_DATA('FRANCISCO MONFORTE GONZALEZ','38549353L','fmg@coac.net',1,'41',0,0,0,0,1),
      T_TIPO_DATA('MARIA DEL CARMEN SANCHEZ LOPEZ','39169617L','csl.carmensanchez@gmail.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('Drago32','42793075B','drago32.Arquitectos@drago32.com',1,'41',1,1,0,0,0),
      T_TIPO_DATA('ANDREU XAVIER CORTES FORTEZA','43103849D','andreucortesforteza@hotmail.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('ANGELS LOPEZ GARCIA','43444793R','angels.lopez@alde1gn.cat',1,'41',0,0,0,0,1),
      T_TIPO_DATA('CLEMENTE VERA PEREZ','45448954B','clementeproyectos@gmail.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('SUSANA PAVON GARCIA','46656452D','susana.pavon@upc.edu',1,'41',0,0,0,0,1),
      T_TIPO_DATA('MARIO CARBAJO LARGO','51671784F','carbajo@carbajoarquitectotecnico.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('MIKEL ELIZONDO ALDASORO','72464475P','elizondoaldasoro@gmail.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('MIRIAM VALDIVIESO FRAILE','72983409Q','m.valdivieso.fraile@gmail.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('ALEJANDRO VASCO PINEDA','78715931H','alevaspin@gmail.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('EUROCONTROL SA','A28318012','jfernandez@eurocontrol.es',1,'41',0,0,0,0,1),
      T_TIPO_DATA('TA1BERICA SA','A28842045','jgonzalez@ge1berica.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('GRATEC SA','A35206846','gerencia@gratecsa.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('ARC ARQUITECTURA URBANISMO SOLUCIONES INMOBILIARIA SL','B10412500','a.ibarra@arc-arquitectura.es',1,'41',0,0,0,0,1),
      T_TIPO_DATA('INGENIERIA Y ARQUITECTURA SEGORBE SL','B12486767','inarse@inarse.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('GESTION PROCESO EDIFICATORIO SL','B14656573','maserranogalan@gmail.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('OSOVI PROYECTOS SL','B20809364','felix.vidaurreta@osoviproyectos.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('REURCO CONSULTORIA TECNICA SL','B25613282','avicente@reurco.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('POINTERINVEST SL','B27814664','fernando@pointerinvest.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('CETEC SL','B30034870','mjodar@cetec.es',1,'41',0,0,0,0,1),
      T_TIPO_DATA('JORGE RODRIGUEZ CRUZ SL','B38477451','jorge@estudiojrc.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('EMA ARQUITECTURA SL','B38659306','estudio@emarquitectura.es',1,'41',0,0,0,0,1),
      T_TIPO_DATA('A1STENCIA TECNICA INTEGRAL AL DESARROLLO INM. SL','B47704838','aresarquitecto@hotmail.es',1,'41',0,0,0,0,1),
      T_TIPO_DATA('REGALADO SALA Y VALDES SL (RESULTA)','B54478755','david.martinez@resultasoluciones.com',1,'41',1,1,0,0,1),
      T_TIPO_DATA('DOPEC SL','B60452430','ntorres@dopec.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('GORINA I FARRES ARQUITECTES SL','B61601712','rfarres@coac.cat',1,'41',0,0,0,0,1),
      T_TIPO_DATA('BAMMP ARQUITECTES I ASSOCIATS SL','B62572979','pep.malgosa@bammp.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('ARQUITECTURA I MANAGEMENT EN CONSTRUCCIO SL','B63227508','agrieraar@gmail.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('CIUDAD HERNANSANZ SL','B63918445','eciudad@ciudad.es',1,'41',0,0,0,0,1),
      T_TIPO_DATA('SBS 1MON I BLANCO SL','B64168933','l1mon@sbs-enginyers.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('GIPROC ARQUITECTURA TECNICA SL','B65019549','giproc@giproc.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('APROTECNIC GROUP SL','B65472789','e.fernandez@aprotecnic.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('INGENIERIA GESTION Y CONSULTORIA BARCELONA SL','B65987729','josemanuel@igcbcn.onmicrosoft.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('Securama','B73496200','es@securama.es',1,'41',1,0,0,0,0),
      T_TIPO_DATA('CONSTRUCCIONES JOFEMAR SL','B78650322','cjofemar@cjofemar.e.telefonica.net',1,'41',0,0,0,0,1),
      T_TIPO_DATA('GESTION INTEGRAL DEL SUELO SL','B81480352','ranton@gis-ingenieria.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('PRACTICA PROYECTOS SL','B81689093','juan.vara@practicaproyectos.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('ASESORES DE OBRA CIVIL SL','B83697763','juanlucampos@asocivil.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('OBRAS, DISEÑO Y VALORACION SL','B84824044','odv@odvarquitectostecnicos.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('EBUS ESTUDIO DE ARQUITECTURA SL','B84899996','lipygp@gmail.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('GAS ESTUDIO SL','B85166841','galfaro@alfaro-manrique.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('JNC CONSULTORES SL','B85644888','jlfernandez@jncconsultores.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('ATEC GESTION DE INMUEBLES SL','B87350690','hescudero@atecinmuebles.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('GESTION Y SERVICIOS DE ACTIVOS Y BIENES INMUEBLES SL','B90116179','m.herrera@gesebi.es',1,'41',0,0,0,0,1),
      T_TIPO_DATA('VEGA 15, ARQUITECTURA Y URBANISMO SL','B90205618','jbt@vega15.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('ARQUERMO ARQUITECTOS SL','B91404921','jcobreros@clavesdegestion.es',1,'41',0,0,0,0,1),
      T_TIPO_DATA('STRICTE SL','B91406264','jperez@stricte.es',1,'41',0,0,0,0,1),
      T_TIPO_DATA('FACTOR(IA), ARQUITECTURA Y URBANISMO SL','B91544395','factor-ia@factor-ia.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('TINATEC SL','B92886803','gar.tinatec@gmail.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('JAAM SOCIEDAD DE ARQUITECTURA SL','B95366183','juncal@jaam.es',1,'41',0,0,0,0,1),
      T_TIPO_DATA('ALGESCON LEVANTE SL','B96565981','gonzalo@algescon.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('Llorens Fornes y Navarro','B96836739','laura@llfnarquitectos.com',1,'41',1,1,0,0,0),
      T_TIPO_DATA('AS1STA CASA 2005 SL','B97600001','c.sanz@grupoas1sta.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('TERRRITORIO CIUDAD Y HABITAT SL','B98316730','tcarrasco@tcharquitectura.com',1,'41',0,0,0,0,1),
      T_TIPO_DATA('ACTUA','B98562036','jorgemarco@actua-ga.es',1,'41',1,1,0,0,0),
      T_TIPO_DATA('DESARROLLOS URBANISTICOS DE ZARAGOZA SL','B99101156','isainz@deurza.es',1,'41',0,0,0,0,1),
      T_TIPO_DATA('Akra','E54696950','amador.suarez@grupoakra.es',1,'41',1,0,0,0,0),
      T_TIPO_DATA('ESTUDIO Q. ARQUITECTURA Y URBANISMO SC','J70038708','estudio@qarq.es',1,'41',0,0,0,0,1),
      T_TIPO_DATA('JOSE IGNACIO PUERTAS MEDINA','19848053L','joseignaciopuertas@gmail.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('JOSE OCTAVIO ORDINYANA POVEDA','20447058N','jose@ijarquitectos.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('JUSTINO ANDRES ALONSO HERMOSA','22562062M','justino@adagronomos.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('ARISTEA CORTES BALLESTER','29010659T','acortesbal@gmail.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('GRV Arquitectura','33399807N','grv.arquitectura@gmail.com',1,'40',1,1,0,0,0),
      T_TIPO_DATA('Drago32','42793075B','drago32.Arquitectos@drago32.com',1,'40',1,1,0,0,0),
      T_TIPO_DATA('Alfonso Ortega Garcia','50074661G','10530ortega@coam.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('JUAN JOSE CAPOTE JURADO','80147162M','juanjo.capote@coacordoba.net',1,'40',0,0,1,0,0),
      T_TIPO_DATA('INVESTIGACIÓN Y CONTROL DE CALIDAD S.A.U','A24036691','clientes@incosa.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('OMICRON AMEPRO SA','A28520278','isuarez@omicronamepro.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('VALTECNIC SA','A28903920','bcabeza@organismodecontrol.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('OCT CONTROLIA, S.A.','A82838350','1lviagarcia@controliaga.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('José Ángel Ferrer Arquitectos, S.L.P.','B04336301','info@ferrerarquitectos.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('ARKU3 URBAN SLP','B25752395','marcribes@arku3.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('ECA S.L. GRUPO BUREAU VERITAS ','B28205904','buraudio@buraudio.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('Unicontrol','B45740818','chinjos@unicontrol.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('Resulta Soluciones inmobiliarias','B54478755','david.martinez@resultasoluciones.com',1,'40',1,1,0,0,0),
      T_TIPO_DATA('Akra','B54780697','amador.suarez@grupoakra.es',1,'40',1,1,0,0,0),
      T_TIPO_DATA('APROTECNIC GROUP SL','B65472789','e.fernandez@aprotecnic.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('Securama','B73496200','es@securama.es',1,'40',1,1,0,0,0),
      T_TIPO_DATA('UVE','B86140878','mlq@v-valoraciones.es',1,'40',1,1,0,1,0),
      T_TIPO_DATA('Almar Consulting','B86408374','info@almarconsulting.com',1,'40',1,1,0,0,0),
      T_TIPO_DATA('Tinsa Certify','B86689494','marta.garciahernandez@tinsa.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('GESVALT PROPERTY SERVICES SL','B87212122','jpgil@gesvaltservices.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('ALL GLOBAL','B87300349','maberengue@allgpm.es',1,'40',1,1,1,1,0),
      T_TIPO_DATA('FM Ingenieros','B87764841','gizquierdo@fmingenieros.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('Premea','B96595897','premea@premea.com',1,'40',1,1,1,0,0),
      T_TIPO_DATA('Premea','B96595897 ','premea@premea.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('Llorens Fornes y Navarro','B96836739','laura@llfnarquitectos.com',1,'40',1,1,1,0,0),
      T_TIPO_DATA('ACTUA','B98562036','jorgemarco@actua-ga.es',1,'40',1,1,0,0,0),
      T_TIPO_DATA('JESUS GARCIA-VALCARCEL MUÑOZ-REPISO','00817841F','jgv_arquitectos@coam.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('Estudio Mónica Alcántara','0385439P','arquitectura@monicaalcantara.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('JOSE OCTAVIO ORDINYANA POVEDA','20447058N','jose@ijarquitectos.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('JUAN JOSE BUJ TORRO','22527396T','buj@buj.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('Juan Montiel Fernandez','24871325E','mofe1192@gmail.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('Caser','28013050','jaimepena@caser.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('Aránzazu Carvajal','33529494W','acarvajalcoro@gmail.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('Reyes Gómez Martín','3845509R','arquitectoreyesg@gmail.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('Alfonso Ortega Garcia','50074661G','10530ortega@coam.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('Patricio Herguido Palomar','50279700K','phparquitectura@hotmail.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('Jose Antonio Martín Rodríguez','50301648-B','rodrimar8888@gmail.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('Fermín Alfaro','50709220Q','f.alfaroarregui@gmail.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('Juan Carlos García Herrero','51372454E','jcgarcia@ese-dos.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('Mariano Álvarez Pulido','52474186P','malvarezpulido@gmail.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('Alejandro Tejedor','52657376A','alejandro.tejedorcalvo@gmail.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('GUILLERMO GOMEZ SOLBAS','75723391P','guillermogomezsolbas@gmail.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('REFORMAS SG','78472108H','reformas.sg@hotmail.com',1,'40',1,1,0,0,0),
      T_TIPO_DATA('JUAN JOSE CAPOTE JURADO','80147162M','juanjo.capote@coacordoba.net',1,'40',0,0,1,0,0),
      T_TIPO_DATA('INSMOEL, S.A.','A04028205','ingenieria@insmoel.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('GRUPO CONTROL EMPRESA DE SEGURIDAD, S.A.','A04038014','lbermejo@grupocontrol.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('ALBAIDA INFRAESTRUCTURAS, S.A.','A04337309','albaida@grupoalbaida.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('ANTONIO GOMILA SA','A07405681','jaen@antoniogomila.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('AQUALIA GESTIÓN INTEGRAL DEL AGUA,SA','A26019992','www.aqualia.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('CASER','A28013050','MGALEANO@aciertaa1stencia.es/',1,'40',1,0,0,0,0),
      T_TIPO_DATA('EL CORTE INGLES S.A','A28017895','empresas_granada@elcorteingles.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('INTEMAC','A28184661','ediaz@intemac.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('EUROCONTROL','A28318012','valencia@eurocontrol.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('S.G.S. TECNOS SA','A28345577','es.sgs.anida@sgs.com',1,'40',0,0,0,1,1),
      T_TIPO_DATA('Acierta','A28346054','vlabella@aciertaa1stencia.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('Ferroser','A28672038','ferroser@ferroser.com',1,'40',1,1,0,0,0),
      T_TIPO_DATA('ERVEGA SA','A29353893','jm@ervega.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('Sedes','A33002106','pomar@sedes.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('Peralte','A33649138','obras@peralte.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('GRUPO BERTOLIN S.A.','A46092128','bertolin@grupobertolin.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('ELECNOR','A48027056','notificacioneshaya@elecnor.es',1,'40',0,1,0,0,0),
      T_TIPO_DATA('JARQUIL CONSTRUCCION, SA','A54496005','contratacion@grupojarquil.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('Rege Ibérica','A78208410','avilla@regeiberica.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('MEDICINA DE DIAGNOSTICO Y CONTROL, INTERMEDIACION SA','A78339769','mdiaz@medycsa.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('SACYR CONSTRUCCION SAU','A78366382','zlopez@sacyr.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('Seranco','A79189940','estudios@seranco.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('SECURITAS DIRECT ESPAÑA, SAU','A79252219','maria.cuesta@securitas.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('GESTVAL','A80884372','direccioncomercial@gesvalt.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('ESCREYES, S.A.','A93192946','david@escreyes.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('GRUPO G. PROTECCION Y SEGURIDAD, S.A.','A96244421','seguridad@grupog.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('INTERACTIVA IBERGEST SLU','B02118115','clientes@ibergest.net',1,'40',0,0,1,0,0),
      T_TIPO_DATA('GESTIMED LEVANTE S.L.','B03830510','cimenta2@grupogestimed.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('ICC Control de Calidad S.L','B04122883','alopez@icc-laboratorio.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('ODYSMA, S.L.','B04219424','info@odysma.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('MONTAJES DE ELECTRICIDAD MOYA, SL','B04229548','central@electricidadmoya.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('INSTALACIONES ELECTRICAS SEGURA, S.L.','B04254793','lkm@instalacionessegura.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('EXCAVACIONES MAYFRA, S.L.','B04264982','fms@excavacionesmayfra.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('DIMOBA SERVICIOS, S.L.','B04307120','smembrilla@dimoba.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('José Ángel Ferrer Arquitectos, S.L.P.','B04336301','info@ferrerarquitectos.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('CONSTRUCCIONES Y PROMOCIONES JONECO, SL','B04405403','joneco@hotmail.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('CONSTRUCCIONES ANGEL BLANQUE SANCHEZ, S.L.','B04485686','admon@construccionesblanque.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('ARTISTERRA S.L','B04604195','atc@artisterra.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('CONSTRUCTORA DE OBRAS PUBLICAS ANDALUZAS (COPSA)','B04764809','estudios@grupocopsa.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('J2 DE 1MON Y CUERVA ARQUITECTOS SLP','B04816906','estudio@j2arquitectos.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('EVINTES CALIDAD S.L.L','B04824280','jretamero@evintes.com; ',1,'40',0,0,0,1,0),
      T_TIPO_DATA('ACTEIN SERVICIOS SL','B06559470','proyectos@acteinservicios.com',1,'40',0,0,0,1,1),
      T_TIPO_DATA('ORICONST DE EDIFICACIONES Y CONSTRUCCIONES SL','B11766268','const.orihuela@hotmail.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('URVISA CUATRO SL','B12082368','nestorgarcia@ingse.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('CONSTRUCCIONES TOMAS Y LUIS SL','B12398038','belen@gruporoldan.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('ESTUDIOS Y MÉTODOS DE LA RESTAURACIÓN','B12530770','emr@emr.es',1,'40',1,1,0,0,0),
      T_TIPO_DATA('KAABA','B-13384235','kaabaarquitectura@gmail.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('EDIFEST SL','B17787334','edificacio@edifestsl.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('COANFI SL','B22292163','rchueca@coanfi.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('AVANZA SERVICIOS INTEGRALES SLU','B23657521','recuperaciones@avanza1.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('GESLEON, SL','B24263907','selene@gesleon.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('CONSTRUCCIONES LOPEZ ALVAREZ SL','B24356800','lopezalvarezsl@gmail.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('VALDENUCIELLO, SL','B24503245','tecnico@vdl.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('B-BIOSCA SL','B25250598','darmengol@b-biosca.cat',1,'40',0,0,0,0,1),
      T_TIPO_DATA('CONSPIME CERDAÑA SL','B25483884','oficina2@conspime.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('BUREAU VERITAS','B28205904','rut.ramos@es.bureauveritas.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('FLORESUR SL','B29353026','contratacion@floresur.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('GENERAL DE VIALES, S.L.','B29770922','administracion@generaldeviales.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('ADAM, SL','B30090674','adamsl@adamsl.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('INVERSIONES Y CONTRATAS SODELOR','B30473599','sodelor@sodelor.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('4 Real Arquitectura e Ingeniería','B32324527','lamet@4real.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('BZ99','B35680149','info@bz99.es',1,'40',1,0,0,0,0),
      T_TIPO_DATA('SERVICIOS INTEGRALES','B35828995','central@servicio1ntegralesdecanarias.com',1,'40',1,1,0,0,0),
      T_TIPO_DATA('MONTAJES E INSTALACIONES CANARIAS 2008 SL','B35992304','jpadron@mic2008.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('CONSTRUCCIONES DALTRE SL','B38281945','cbengtson@grupodaltre.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('CONSTRUCCIONES Y REFORMAS M. BERNABE SL','B38393112','cbernabe68@gmail.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('PINTURAS Y DECORACIONES GRANA SL','B38467874','pinturasgrana@hotmail.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('1VERIO LOPEZ COACH CONSTRUCCION SL','B38966362','info@coachconstruccion.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('GRUA DE PIEDRA SL','B39710504','tecnico2@gruadepiedra.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('INV','B40165920','fcuenca@invseguridad.com',1,'40',1,0,0,0,0),
      T_TIPO_DATA('Muñoz y Doblado','B45346590','munozydoblado@hotmail.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('APLISER CONSTRUCCIONES Y REFORMAS, S.L.U.','B45684677','apliser.1@gmail.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('PROYME GRUPO GESTION SL','B46635991','proyme@proyme.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('PROVISER','B47667415','gvalleinclan@proviser.es',1,'40',1,1,0,0,0),
      T_TIPO_DATA('Corolla Arquitectura','B52538691','jorgeparaja@gmail.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('Urbana exteriores','B53546040','psaez@urbanadeexteriores.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('AGLOMERADOS OBRAS Y CANTERAS DELTA SL','B53952370','aglodelta@aglodelta.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('TRISOLIA INVESTMENT SLU','B54448097','jose@trisolia.es;jruiz@trisolia.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('AKRA INFRAESTRUCTURAS SL','B54780697','amador.suarez@grupoakra.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('Cimex','B58292392','jmdana@cimexsu.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('Dorseran','B60546611','lis@dorseran.net',1,'40',1,1,0,1,1),
      T_TIPO_DATA('HERA HOLDING HABITAT, ECOLOGIA Y RESTAURACION AMBIENTAL, SL','B61540969','fernando.herreros@heraholding.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('ARQUITECTURA I MANAGEMENT EN CONSTRUCCIO SL','B63227508','agrieraar@gmail.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('INSTAL LACIONS I REPARACIONS COBO SL','B64052392','quim.boada@icobo.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('SBS 1MON I BLANCO SL','B64168933','l1mon@sbs-enginyers.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('PROMOLLONCH','B64381387','jordi@promollonch.com',1,'40',1,1,0,0,0),
      T_TIPO_DATA('ALTATAMARINDO, SL','B65428583','ALTATAMARINDO@GMAIL.COM',1,'40',0,0,1,0,0),
      T_TIPO_DATA('APROTECNIC','B65472789','e.fernandez@aprotecnic.com',1,'40',1,1,0,1,1),
      T_TIPO_DATA('Active','B66258831','x.milanes@activeobras.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('OBRAS Y REFORMAS DAVARA SL','B70173281','david_varela@davarasl.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('ACODAR 2010 SL','B70258819','ecores@acodar.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('PROGUARD 1STEMAS, SL','B73281081','proguard@proguard1stemas.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('AREA NAOS CONSTRUCCION SLU','B76536242','lgerardo@areaconstruccion.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('ARTEK REFORMAS CANARIAS SL','B76676709','artekreformas@gmail.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('AUIA Arquitectos e Ingenieros','B78018017','f.soriano@auia.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('ARQUIPROYECT, S.L.','B80379308','proyectos@aqparquitectos.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('INGENIERIA Y PREVENCION DE RIESGOS SL','B81470841','pedro.garcia@imasp.net',1,'40',0,0,0,0,1),
      T_TIPO_DATA('GILSA CONSERVACION Y MANTENIMIENTO SL','B82409681','administracion@gilsagilper.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('ENDESA DISTRIBUCION ELÉCTRICA, SL','B82846817','diego.berenguel@endesa.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('Arkitools','B83337568','luisgarciagil@arkitools.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('TERRALIA CONSTRUCCIONES','B83567693','administracion@terraliaconstrucciones.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('INVERTOL PROMOCION E INVERSION INMOBILIARIA S.L.','B84105899','control@invertol.com',1,'40',0,0,1,0,1),
      T_TIPO_DATA('FUTURE ARQUITECTURAS SL','B84709492','martin@arqfuture.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('VALUATION & REAL ESTATE GROUP SL','B85030641','icruz@mreg.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('Brick/Avintia','B85343721','hayaincidencias@avintiaservicios.com',1,'40',1,0,0,1,0),
      T_TIPO_DATA('ABLE, CONSTRUCCION Y MONTAJES DE EFIMEROS SL','B85402501','departamentoobras@able-cme.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('PROGRESA XCI SL','B85757300','joseluisdiaz@progresaxci.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('4Real','B86036290','lamet@4real.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('ORGANISMO DE CONTROL DE OBRAS SL','B86189651','bcabeza@organismodecontrol.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('MatFo- cgi','B86910825','ricardo.font@matfo-cgi.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('GESVALT PROPERTY SERVICES SL','B87212122','jpgil@gesvaltservices.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('OBRAS PIÑA MARTIN SL (OPIMA)','B91903278','opimasl@hotmail.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('CEMALSA Expertos en Calidad S.L.','B92084060','laboratorio@cemalsa.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('PROSECO INGENIERIA S.L.P.','B92203413','prosecoingenieria@yahoo.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('CHIRIVO CONSTRUCCIONES S.L.','B92418524','industrial@chirivo.com',1,'40',1,1,1,0,1),
      T_TIPO_DATA('EJECUCION DEL PLANEAMIENTO 2 SLP','B92710698','fernando.garcia.pulido@edp-sl.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('DECOPROYECTOS PENINSULAR SL','B93069300','decoproyectos.angel@gmail.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('UCI','B93456275','fhervas@ucisl.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('B&S Castro Arquitectura S.L.P.','B94084233','benitocastroestevez@hotmail.com ',1,'40',0,0,0,1,0),
      T_TIPO_DATA('VARESER 96 S.L.','B96534805','ofertas@vareser.net',1,'40',0,0,1,0,0),
      T_TIPO_DATA('CTRES 97 SL','B96683149','sergio@ctres.net',1,'40',0,0,0,0,1),
      T_TIPO_DATA('GRUPO INNOVA TORMO SL','B96683420','jjdepedro@enlucidostormo.com',1,'40',0,0,0,0,1),
      T_TIPO_DATA('ESTUDIO DE ARQUITECTURA Y URBANISMO, LLORENS, FORNES Y NAVARRO S.L.P.','B96836739','estudio@llfnarquitectos.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('PROCYR EDIFICACIÓN Y URBANISMO S.L.','B97279012','ernesto.torregrosa@procyr.es',1,'40',0,0,1,0,0),
      T_TIPO_DATA('ARTEASVAL, S.L.','B97513691','arteasval@runbox.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('ARQUITECTURA Y URBANISMO 1NGULARQ SLP','B97570063','estudio@qarq.es',1,'40',0,0,0,0,1),
      T_TIPO_DATA('AS1STA','B97600001','jm.asen1@grupoas1sta.com',1,'40',1,0,0,0,0),
      T_TIPO_DATA('PROYME GRUPO GESTION SL','B97788582','proyme@proyme.es',1,'40',1,1,0,0,0),
      T_TIPO_DATA('Vainsa Infraestructuras','B98296486','jvanacloig@vainsa.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('AVANZA URBANA 1GLO XXI SL','B98327943','mmpuchades@avanzaurbana.com',1,'40',0,0,1,0,0),
      T_TIPO_DATA('VARENYAM','B98350077','varenyamslu@gmail.com',1,'40',1,1,0,0,1),
      T_TIPO_DATA('Integraval','B98493190','luis@integraval.es',1,'40',1,1,0,1,1),
      T_TIPO_DATA('Reuna','B98631633','rafavillalba@reuna.es',1,'40',0,0,0,1,0),
      T_TIPO_DATA('Obras y estructuras Hidalgo','B98685654','obrashidalgo@hotmail.com',1,'40',0,0,0,1,0),
      T_TIPO_DATA('ELECTROCER','B98692676','celectrocervic@hotmail.com',1,'40',1,1,0,0,0),
      T_TIPO_DATA('DEGESER','B98792823','degeser@degeser.com',1,'40',1,1,0,0,0),
      T_TIPO_DATA('J2 PROJECTS','E04711990','estudio@j2arquitectos.com',1,'40',1,1,0,0,0),
      T_TIPO_DATA('GRUPO ALMICRAR S.C.','J04678785','mmmadrid18@gmail.com',1,'40',1,1,1,0,0),
      T_TIPO_DATA('Alonso y Barrientos','J39419338','ALONSOYBARRIENTOS@telefonica.net',1,'40',0,0,0,1,0)
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_SCR_SUBCARTERA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_PVE_PROVEEDOR ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE WHERE PVE.PVE_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
        AND PVE.DD_TPR_ID = (SELECT TPR.DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR TPR WHERE TPR.DD_TPR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||''') AND PVE.PVE_FECHA_BAJA IS NULL';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --1 existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE EL PROVEEDOR CON NIF: '''||TRIM(V_TMP_TIPO_DATA(2))||'''');  

          V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE WHERE PVE.PVE_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
          AND PVE.DD_TPR_ID = (SELECT TPR.DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR TPR WHERE TPR.DD_TPR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||''') AND PVE.PVE_FECHA_BAJA IS NULL
          AND PVE.DD_EPR_ID IS NULL';
          EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
          IF V_NUM_TABLAS > 0 THEN
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
            SET PVE.DD_EPR_ID = (SELECT EPR.DD_EPR_ID FROM '|| V_ESQUEMA ||'.DD_EPR_ESTADO_PROVEEDOR EPR WHERE EPR.DD_EPR_CODIGO = ''04'')
            WHERE PVE.PVE_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
            AND PVE.DD_TPR_ID = (SELECT TPR.DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR TPR WHERE TPR.DD_TPR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||''') AND PVE.PVE_FECHA_BAJA IS NULL
            AND PVE.DD_EPR_ID IS NULL';
            EXECUTE IMMEDIATE V_MSQL;
          END IF;

        ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_ACT_PVE_PROVEEDOR.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	

          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_PVE_COD_REM.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID_COD_REM;	

          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_ACT_PVC_PROVEEDOR_CONTACTO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID_PVC;	

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR (
                      PVE_ID
                      , DD_TPR_ID
                      , PVE_NOMBRE
                      , PVE_NOMBRE_COMERCIAL
                      , DD_TDI_ID
                      , PVE_DOCIDENTIF
                      , PVE_EMAIL
                      , PVE_HOMOLOGADO
                      , VERSION
                      , USUARIOCREAR
                      , FECHACREAR
                      , BORRADO
                      , PVE_COD_REM
                      , PVE_FECHA_ALTA
                      , DD_EPR_ID)
                      SELECT '|| V_ID ||'
                      , (SELECT TPR.DD_TPR_ID FROM '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR TPR WHERE TPR.DD_TPR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||''')
                      , '''||TRIM(V_TMP_TIPO_DATA(1))||'''
                      , '''||TRIM(V_TMP_TIPO_DATA(1))||'''
                      , (SELECT TDI.DD_TDI_ID FROM '|| V_ESQUEMA ||'.DD_TDI_TIPO_DOCUMENTO_ID TDI WHERE TDI.DD_TDI_CODIGO = ''15'')
                      , '''||TRIM(V_TMP_TIPO_DATA(2))||''' 
                      , '''||TRIM(V_TMP_TIPO_DATA(3))||''' 
                      , '||TRIM(V_TMP_TIPO_DATA(4))||' 
                      , 0
                      , '''||TRIM(V_ITEM)||'''
                      , SYSDATE
                      , 0
                      , '|| V_ID_COD_REM ||'
                      , SYSDATE
                      , (SELECT EPR.DD_EPR_ID FROM '|| V_ESQUEMA ||'.DD_EPR_ESTADO_PROVEEDOR EPR WHERE EPR.DD_EPR_CODIGO = ''04'')
                      FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE EN PVE');

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_PVC_PROVEEDOR_CONTACTO (
                      PVC_ID
                      , PVE_ID
                      , DD_TDI_ID
                      , PVC_DOCIDENTIF
                      , PVC_NOMBRE
                      , PVC_EMAIL
                      , VERSION
                      , USUARIOCREAR
                      , FECHACREAR
                      , BORRADO
                      , PVC_FECHA_ALTA)
                      SELECT 
                      '|| V_ID_PVC ||'
                      , '|| V_ID ||'
                      , (SELECT TDI.DD_TDI_ID FROM '|| V_ESQUEMA ||'.DD_TDI_TIPO_DOCUMENTO_ID TDI WHERE TDI.DD_TDI_CODIGO = ''15'')
                      , '''||TRIM(V_TMP_TIPO_DATA(2))||'''
                      , '''||TRIM(V_TMP_TIPO_DATA(1))||'''
                      , '''||TRIM(V_TMP_TIPO_DATA(3))||''' 
                      , 0
                      , '''||TRIM(V_ITEM)||'''
                      , SYSDATE
                      , 0
                      , SYSDATE
                      FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE EN PVC');
 
          IF V_TMP_TIPO_DATA(6) = 1 THEN

            V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_ACT_ETP_ENTIDAD_PROVEEDOR.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID_ETP;	
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_ETP_ENTIDAD_PROVEEDOR (
                      ETP_ID
                      , DD_CRA_ID
                      , PVE_ID
                      , VERSION
                      , USUARIOCREAR
                      , FECHACREAR
                      , BORRADO
                      , ETP_FECHA_INICIO)
                      SELECT 
                      '|| V_ID_ETP ||'
                      , (SELECT CRA.DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''03'')
                      , '|| V_ID ||'
                      , 0
                      , '''||TRIM(V_ITEM)||'''
                      , SYSDATE
                      , 0
                      , SYSDATE
                      FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: CARTERA BANKIA');
          END IF;

          IF V_TMP_TIPO_DATA(7) = 1 THEN

            V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_ACT_ETP_ENTIDAD_PROVEEDOR.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID_ETP;	
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_ETP_ENTIDAD_PROVEEDOR (
                      ETP_ID
                      , DD_CRA_ID
                      , PVE_ID
                      , VERSION
                      , USUARIOCREAR
                      , FECHACREAR
                      , BORRADO
                      , ETP_FECHA_INICIO)
                      SELECT 
                      '|| V_ID_ETP ||'
                      , (SELECT CRA.DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''02'')
                      , '|| V_ID ||'
                      , 0
                      , '''||TRIM(V_ITEM)||'''
                      , SYSDATE
                      , 0
                      , SYSDATE
                      FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: CARTERA SAREB');
          END IF;

          IF V_TMP_TIPO_DATA(8) = 1 THEN

            V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_ACT_ETP_ENTIDAD_PROVEEDOR.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID_ETP;	
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_ETP_ENTIDAD_PROVEEDOR (
                      ETP_ID
                      , DD_CRA_ID
                      , PVE_ID
                      , VERSION
                      , USUARIOCREAR
                      , FECHACREAR
                      , BORRADO
                      , ETP_FECHA_INICIO)
                      SELECT 
                      '|| V_ID_ETP ||'
                      , (SELECT CRA.DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''01'')
                      , '|| V_ID ||'
                      , 0
                      , '''||TRIM(V_ITEM)||'''
                      , SYSDATE
                      , 0
                      , SYSDATE
                      FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: CARTERA CAJAMAR');
          END IF;

          IF V_TMP_TIPO_DATA(9) = 1 THEN

            V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_ACT_ETP_ENTIDAD_PROVEEDOR.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID_ETP;	
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_ETP_ENTIDAD_PROVEEDOR (
                      ETP_ID
                      , DD_CRA_ID
                      , PVE_ID
                      , VERSION
                      , USUARIOCREAR
                      , FECHACREAR
                      , BORRADO
                      , ETP_FECHA_INICIO)
                      SELECT 
                      '|| V_ID_ETP ||'
                      , (SELECT CRA.DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''08'')
                      , '|| V_ID ||'
                      , 0
                      , '''||TRIM(V_ITEM)||'''
                      , SYSDATE
                      , 0
                      , SYSDATE
                      FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: CARTERA LIBERBANK');
          END IF;

          IF V_TMP_TIPO_DATA(10) = 1 THEN

            V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_ACT_ETP_ENTIDAD_PROVEEDOR.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID_ETP;	
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_ETP_ENTIDAD_PROVEEDOR (
                      ETP_ID
                      , DD_CRA_ID
                      , PVE_ID
                      , VERSION
                      , USUARIOCREAR
                      , FECHACREAR
                      , BORRADO
                      , ETP_FECHA_INICIO)
                      SELECT 
                      '|| V_ID_ETP ||'
                      , (SELECT CRA.DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''07'')
                      , '|| V_ID ||'
                      , 0
                      , '''||TRIM(V_ITEM)||'''
                      , SYSDATE
                      , 0
                      , SYSDATE
                      FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: CARTERA CERBERUS');
          END IF;
        
       END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO ACT_PVE_PROVEEDOR MODIFICADO CORRECTAMENTE ');
   

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
