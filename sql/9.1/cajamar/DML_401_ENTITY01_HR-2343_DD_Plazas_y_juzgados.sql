--/*
--##########################################
--## AUTOR=Pepe Tamarit
--## FECHA_CREACION=20160504
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HR-2343
--## PRODUCTO=NO
--## Finalidad: DML
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_COLUMN   NUMBER(16); -- Vble. para validar la existencia de una columna.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_VIEW     NUMBER(16); -- Vble. para validar la existencia de una vista.
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

   dbms_output.enable(1000000);

   -- 30800 - LORCA 
   -- 04620 - VERA 
   -- 30850 - TOTANA
   -- 30170 - MULA
   -- 29000 - MALAGA
   -- 38686 - ALCALA
   -- 03800 - ALCOY
   -- 46600 - ALZIRA
   -- 21200 - ARACENA
   -- 18800 - BAZA
   -- 49600 - BENAVENTE
   -- 08600 - BERGA
   -- 09000 - BURGOS
   -- 14940 - CABRA
   -- 25200 - CERVERA
   -- 10414 - COLLADO
   -- 16000 - CUENCA
   -- 41400 - ECIJA
   -- 03200 - ELX/ELCHE 
   -- 41560 - ESTEPA 
   -- 43730 - FALSET
   -- 28940 - FUENLABRADA
   -- 18000 - GRANADA
   -- 22000 - HUESCA
   -- 03440 - IBI
   -- 22714 - JACA
   -- 23000 - JAEN
   -- 28912 - LEGANES
   -- 24000 - LEON
   -- 14900 - LUCENA
   -- 08760 - MARTORELL
   -- 30000 - MURCIA
   -- 45300 - OCAÑA
   -- 34000 - PALENCIA
   -- 28980 - PARLA
   -- 46980 - PATERNA
   -- 43200 - REUS
   -- 17500 - RIPOLL
   -- 08191 - RUBI
   -- 16600 - SAN CLEMENTE
   -- 18320 - SANTA FE
   -- 41000 - SEVILLA
   -- 44000 - TERUEL
   -- 45000 - TOLEDO
   -- 28340 - VALDEMORO
   -- 46000 - VALENCIA
   -- 43800 - VALLS
   -- 50000 - ZARAGOZA
   
   -- Reactivar las plazas Vera y Lorca
   V_MSQL := 'update '||V_ESQUEMA||'.dd_pla_plazas 
                 set borrado = 0, 
                     usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate, 
                     usuarioborrar = null, 
                     fechaborrar = null
               where dd_pla_codigo in (''04620'', ''30800'', ''30850'', ''30170'', ''29000'', 
			                           ''38686'', ''03800'', ''46600'', ''21200'', ''18800'', ''49600'', 
									   ''08600'', ''09000'', ''14940'', ''25200'', ''28400'', ''16000'',
                                       ''41400'', ''03200'', ''41560'', ''43730'', ''28940'', ''18000'', 
									   ''22000'', ''03440'', ''22714'', ''23000'', ''28912'', ''24000'',
                                       ''14900'', ''08760'', ''30000'', ''45300'', ''34000'', ''28980'', 
									   ''46980'', ''43200'', ''17500'', ''08191'', ''16600'', ''18320'',
                                       ''41000'', ''44000'', ''45000'', ''28340'', ''46000'', ''43800'', 
									   ''50000'')';
   EXECUTE IMMEDIATE V_MSQL;

   -- Asociar juzgados a 30800 - LORCA 
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''30800''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''30143'', ''30144'', ''30145'', ''31604'', ''34563'', ''32921'', ''37565'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 04620 - VERA 
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''04620''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''30074'', ''30075'',''34604'')';
   EXECUTE IMMEDIATE V_MSQL;

   -- Asociar juzgados a 30850 - TOTANA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id
				 FROM dd_pla_plazas WHERE dd_pla_codigo = ''30850''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''30134'', ''30135'', ''31605'', ''32682'', ''32683'')';
   EXECUTE IMMEDIATE V_MSQL;

   -- Asociar juzgados a 30170 - MULA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''30170''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''33358'', ''33898'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 29000 - MALAGA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''29000''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''33569'', ''39445'', ''33578'', ''33579'', ''38249'', ''33581'', ''38250'', ''33583'', ''35203'', ''38251'', ''35543'', ''35544'', ''33570'', ''37832'', ''38246'', ''37785'', ''33573'', ''33574'', ''38247'', ''38248'', ''33577'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 38686 - ALCALA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''38686''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''33846'', ''33847'', ''33848'', ''33849'', ''33850'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 03800 - ALCOY
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''03800''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''32042'',''38989'',''38990'',''38991'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 46600 - ALZIRA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''46600''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''36393'',''36394'',''36395'',''36396'',''36397'',''36398'',''37805'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 21200 - ARACENA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''21200''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''40225'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 18800 - BAZA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''18800''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''32821'',''33748'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 49600 - BENAVENTE
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''49600''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''39205'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 08600 - BERGA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''08600''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''37465'',''37466'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 09000 - BURGOS
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''09000''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''37827'',''38105'',''39005'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 14940 - CABRA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''14940''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''39945'',''39946'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 25200 - CERVERA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''25200''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''39705'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 10414 - COLLADO
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''10414''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''33870'',''33871'',''33872'',''33873'',''33874'',''33875'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 16000 - CUENCA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''16000''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''40285'',''38905'',''40185'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 41400 - ECIJA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''41400''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''40285'',''38905'',''40185'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 03200 - ELX/ELCHE 
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''03200''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''32104'',''33942'',''33944'',''33945'',''33946'',''33947'',''39014'',''39015'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 41560 - ESTEPA 
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''41560''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''38273'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 43730 - FALSET
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''43730''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''34470'',''34471'',''34472'',''34473'',''34474'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 28940 - FUENLABRADA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''28940''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''33793'',''33794'',''33795'',''33796'',''39026'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 18000 - GRANADA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''18000''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''36285'',''36400'',''33085'',''33982'',''33983'',''33984'',''33986'',''33987'',''33988'',''33990'',''33991'',''33992'',''33993'',''33994'',''33995'',''33996'',''34102'',''39833'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 22000 - HUESCA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''22000''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''39149'',''39845'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 03440 - IBI
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''03440''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''37106'',''38965'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 22714 - JACA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''22714''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''37245'',''37246'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 23000 - JAEN
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''23000''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''32463'',''35764'',''38525'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 28912 - LEGANES
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''28912''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''33855'',''33856'',''33857'',''33858'',''33859'',''33860'',''33861'',''39030'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 24000 - LEON
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''24000''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''38086'',''38065'',''36112'',''39225'',''37828'',''37928'',''38087'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 14900 - LUCENA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''14900''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''35523'',''35524'',''35525'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 08760 - MARTORELL
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''08760''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''31702'',''32022'',''34523'',''36585'',''31229'',''31230'',''31263'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 30000 - MURCIA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''30000''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''30438'',''30442'',''30444'',''30426'',''31424'',''31425'',''36405'',''36726'',''36727'',''36728'',''30430'',''30434'',''30420'',''30422'',''33901'',''33902'',''34022'',''37425'',''37445'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 45300 - OCAÑA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''45300''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''36325'',''39805'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 34000 - PALENCIA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''34000''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''37925'',''36109'',''38046'',''38047'',''38305'',''37834'',''38705'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 28980 - PARLA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''28980''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''33841'',''33842'',''33843'',''33844'',''33845'',''38271'',''38272'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 46980 - PATERNA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''46980''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''34606'',''36265'',''32801'',''36825'',''36947'',''37845'',''38025'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 43200 - REUS
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''43200''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''34465'',''34466'',''34467'',''34468'',''34469'',''36745'',''39110'',''39111'',''39112'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 17500 - RIPOLL
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''17500''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''38565'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 08191 - RUBI
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''08191''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''31662'',''31232'',''31233'',''31259'',''31260'',''32881'',''36748'',''37985'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 16600 - SAN CLEMENTE
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''16600''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''38926'',''38925'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 18320 - SANTA FE
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''18320''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''34924'',''37025'',''36025'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 41000 - SEVILLA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''41000''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''39827'',''39828'',''35103'',''35104'',''35105'',''35223'',''36425'',''36426'',''36427'',''36428'',''36429'',''37088'',''35503'',''35624'',''35885'',''38262'',''39966'',''39116'',''39115'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 44000 - TERUEL
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''44000''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''39505'',''39129'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 45000 - TOLEDO
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''45000''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''38268'',''38269'',''38267'',''38270'',''39926'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 28340 - VALDEMORO
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''28340''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''40105'',''33797'',''33798'',''33799'',''33800'',''35817'',''40145'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 46000 - VALENCIA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''46000''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''35243'',''36525'',''33665'',''32394'',''32395'',''32396'',''32397'',''32398'',''32399'',''32400'',''32401'',''32402'',''32403'',''32404'',''32406'',''32407'',''32408'',''32563'',''32702'',''33021'',''33022'',''36905'',''34144'',''34282'',''39829'',''39830'',''39491'',''39136'',''39137'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 43800 - VALLS
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''43800''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''37085'',''37086'',''39138'')';
   EXECUTE IMMEDIATE V_MSQL;
   
      -- Asociar juzgados a 43800 - VALLS
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''43800''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''37085'',''37086'',''39138'')';
   EXECUTE IMMEDIATE V_MSQL;

   -- Asociar juzgados a 28400 - VILLALBA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''28400''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''33876'',''33877'',''33878'',''33879'',''33880'',''33881'')';
   EXECUTE IMMEDIATE V_MSQL;
   
   -- Asociar juzgados a 50000 - ZARAGOZA
   V_MSQL := 'update '||V_ESQUEMA||'.dd_juz_juzgados_plaza 
                 set dd_pla_id = (SELECT dd_pla_id FROM dd_pla_plazas WHERE dd_pla_codigo = ''50000''),
	                 usuariomodificar = ''HR-2343'', 
                     fechamodificar = sysdate
               where dd_juz_codigo in (''40085'',''39645'',''34804'',''35123'',''35168'',''36807'',''35625'',''35664'',''35723'',''38253'',''39141'',''39927'',''40205'')';
   EXECUTE IMMEDIATE V_MSQL;
     
   commit;   
   
   dbms_output.put_line( 'FIN DEL PROCESO' );

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;
END;
/
EXIT;
