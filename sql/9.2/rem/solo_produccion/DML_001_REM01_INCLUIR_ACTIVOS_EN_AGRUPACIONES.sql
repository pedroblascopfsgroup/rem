--/*
--###########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1767
--## PRODUCTO=NO
--## 
--## Finalidad: INCLUIR ACTIVOS EN AGRUPACIONES
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
  V_COUNT_ACT NUMBER(16):= 0;
  V_COUNT_AGR NUMBER(16):= 0;
  V_COUNT_AGA NUMBER(16):= 0;
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-1767';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    -- 	 		Agrupacion  , Activo 
    T_TIPO_DATA('1000006657','6988680'),
	T_TIPO_DATA('1000006657','6988681'),
	T_TIPO_DATA('1000006657','6988682'),
	T_TIPO_DATA('1000006657','6988683'),
	T_TIPO_DATA('1000007417','6988281'),
	T_TIPO_DATA('1000007417','6988284'),
	T_TIPO_DATA('1000007700','6983740'),
	T_TIPO_DATA('1000007700','6983741'),
	T_TIPO_DATA('1000007700','6983745'),
	T_TIPO_DATA('1000007700','6984021'),
	T_TIPO_DATA('1000007700','6984022'),
	T_TIPO_DATA('1000007700','6984023'),
	T_TIPO_DATA('1000007700','6984024'),
	T_TIPO_DATA('1000007700','6984025'),
	T_TIPO_DATA('1000007700','6984026'),
	T_TIPO_DATA('1000007700','6984027'),
	T_TIPO_DATA('1000007700','6984028'),
	T_TIPO_DATA('1000007700','6984053'),
	T_TIPO_DATA('1000007700','6984054'),
	T_TIPO_DATA('1000007700','6984055'),
	T_TIPO_DATA('1000007700','6984057'),
	T_TIPO_DATA('1000007819','6979518'),
	T_TIPO_DATA('1000008567','6980896'),
	T_TIPO_DATA('1000008567','6980897'),
	T_TIPO_DATA('1000008690','6995832'),
	T_TIPO_DATA('1000008690','6995833'),
	T_TIPO_DATA('1000008690','6995834'),
	T_TIPO_DATA('1000008690','6995835'),
	T_TIPO_DATA('1000008690','6995836'),
	T_TIPO_DATA('1000008690','6995837'),
	T_TIPO_DATA('1000008690','6995838'),
	T_TIPO_DATA('1000008690','6995839'),
	T_TIPO_DATA('1000008690','6996120'),
	T_TIPO_DATA('1000008690','6996121'),
	T_TIPO_DATA('1000008690','6996122'),
	T_TIPO_DATA('1000008690','6996123'),
	T_TIPO_DATA('1000008690','6996124'),
	T_TIPO_DATA('1000008690','6996125'),
	T_TIPO_DATA('1000008690','6996126'),
	T_TIPO_DATA('1000008690','6996310'),
	T_TIPO_DATA('1000008690','6996311'),
	T_TIPO_DATA('1000008690','6996336'),
	T_TIPO_DATA('1000008690','6996337'),
	T_TIPO_DATA('1000008690','6996339'),
	T_TIPO_DATA('1000008690','6996340'),
	T_TIPO_DATA('1000008690','6996341'),
	T_TIPO_DATA('1000008690','6996342'),
	T_TIPO_DATA('1000008690','6996343'),
	T_TIPO_DATA('1000008694','6988464'),
	T_TIPO_DATA('1000008694','6988466'),
	T_TIPO_DATA('1000008697','6986281'),
	T_TIPO_DATA('1000008700','6986695'),
	T_TIPO_DATA('1000008702','6986372'),
	T_TIPO_DATA('1000008703','6985570'),
	T_TIPO_DATA('1000008704','6994482'),
	T_TIPO_DATA('1000008704','6994483'),
	T_TIPO_DATA('1000008704','6994484'),
	T_TIPO_DATA('1000008704','6994485'),
	T_TIPO_DATA('1000008704','6994486'),
	T_TIPO_DATA('1000008704','6994487'),
	T_TIPO_DATA('1000008704','6994488'),
	T_TIPO_DATA('1000008704','6994489'),
	T_TIPO_DATA('1000008704','6994490'),
	T_TIPO_DATA('1000008704','6994491'),
	T_TIPO_DATA('1000008704','6994492'),
	T_TIPO_DATA('1000008704','6994493'),
	T_TIPO_DATA('1000008704','6994494'),
	T_TIPO_DATA('1000008704','6994495'),
	T_TIPO_DATA('1000008704','6994496'),
	T_TIPO_DATA('1000008704','6994497'),
	T_TIPO_DATA('1000008704','6994498'),
	T_TIPO_DATA('1000008704','6994499'),
	T_TIPO_DATA('1000008704','6994500'),
	T_TIPO_DATA('1000008704','6994501'),
	T_TIPO_DATA('1000008704','6994502'),
	T_TIPO_DATA('1000008704','6994503'),
	T_TIPO_DATA('1000008704','6994504'),
	T_TIPO_DATA('1000008704','6994505'),
	T_TIPO_DATA('1000008704','6994506'),
	T_TIPO_DATA('1000008704','6994507'),
	T_TIPO_DATA('1000008704','6994508'),
	T_TIPO_DATA('1000008704','6994509'),
	T_TIPO_DATA('1000008704','6994510'),
	T_TIPO_DATA('1000008704','6994511'),
	T_TIPO_DATA('1000008704','6994512'),
	T_TIPO_DATA('1000008704','6994513'),
	T_TIPO_DATA('1000008704','6994514'),
	T_TIPO_DATA('1000008704','6994515'),
	T_TIPO_DATA('1000008704','6994516'),
	T_TIPO_DATA('1000008704','6994517'),
	T_TIPO_DATA('1000008704','6994518'),
	T_TIPO_DATA('1000008704','6994519'),
	T_TIPO_DATA('1000008704','6994520'),
	T_TIPO_DATA('1000008704','6994521'),
	T_TIPO_DATA('1000008704','6994522'),
	T_TIPO_DATA('1000008704','6994523'),
	T_TIPO_DATA('1000008704','6994524'),
	T_TIPO_DATA('1000008704','6994525'),
	T_TIPO_DATA('1000008704','6994526'),
	T_TIPO_DATA('1000008704','6994527'),
	T_TIPO_DATA('1000008704','6994528'),
	T_TIPO_DATA('1000008704','6994529'),
	T_TIPO_DATA('1000008704','6994530'),
	T_TIPO_DATA('1000008704','6994531'),
	T_TIPO_DATA('1000008704','6994532'),
	T_TIPO_DATA('1000008704','6994533'),
	T_TIPO_DATA('1000008704','6994534'),
	T_TIPO_DATA('1000008704','6994535'),
	T_TIPO_DATA('1000008704','6994536'),
	T_TIPO_DATA('1000008704','6994537'),
	T_TIPO_DATA('1000008704','6994538'),
	T_TIPO_DATA('1000008704','6994540'),
	T_TIPO_DATA('1000008704','6994541'),
	T_TIPO_DATA('1000008704','6994542'),
	T_TIPO_DATA('1000008704','6994543'),
	T_TIPO_DATA('1000008704','6994544'),
	T_TIPO_DATA('1000008704','6994545'),
	T_TIPO_DATA('1000008704','6994546'),
	T_TIPO_DATA('1000008704','6994547'),
	T_TIPO_DATA('1000008704','6994548'),
	T_TIPO_DATA('1000008704','6994549'),
	T_TIPO_DATA('1000008704','6994550'),
	T_TIPO_DATA('1000008704','6994551'),
	T_TIPO_DATA('1000008704','6994560'),
	T_TIPO_DATA('1000008704','6994561'),
	T_TIPO_DATA('1000008704','6994562'),
	T_TIPO_DATA('1000008704','6994563'),
	T_TIPO_DATA('1000008704','6994564'),
	T_TIPO_DATA('1000008704','6994565'),
	T_TIPO_DATA('1000008704','6994566'),
	T_TIPO_DATA('1000008704','6994567'),
	T_TIPO_DATA('1000008704','6994584'),
	T_TIPO_DATA('1000008704','6994585'),
	T_TIPO_DATA('1000008704','6994586'),
	T_TIPO_DATA('1000008704','6994587'),
	T_TIPO_DATA('1000008704','6994588'),
	T_TIPO_DATA('1000008713','6988790'),
	T_TIPO_DATA('1000008713','6989071'),
	T_TIPO_DATA('1000008713','6989075'),
	T_TIPO_DATA('1000008713','6989077'),
	T_TIPO_DATA('1000008724','6988794'),
	T_TIPO_DATA('1000008724','6988795'),
	T_TIPO_DATA('1000008724','6988796'),
	T_TIPO_DATA('1000008724','6988797'),
	T_TIPO_DATA('1000008724','6988798'),
	T_TIPO_DATA('1000008728','6990824'),
	T_TIPO_DATA('1000008728','6990825'),
	T_TIPO_DATA('1000008728','6990826'),
	T_TIPO_DATA('1000008728','6991166'),
	T_TIPO_DATA('1000008728','6991191'),
	T_TIPO_DATA('1000008728','6991193'),
	T_TIPO_DATA('1000008728','6991195'),
	T_TIPO_DATA('1000008728','6991196'),
	T_TIPO_DATA('1000008728','6991197'),
	T_TIPO_DATA('1000008728','6991198'),
	T_TIPO_DATA('1000008728','6991223'),
	T_TIPO_DATA('1000008728','6991224'),
	T_TIPO_DATA('1000008728','6991225'),
	T_TIPO_DATA('1000008728','6991226'),
	T_TIPO_DATA('1000008728','6991227'),
	T_TIPO_DATA('1000008728','6991228'),
	T_TIPO_DATA('1000008728','6991229'),
	T_TIPO_DATA('1000008728','6991230'),
	T_TIPO_DATA('1000008728','6991255'),
	T_TIPO_DATA('1000008728','6991256'),
	T_TIPO_DATA('1000008728','6991257'),
	T_TIPO_DATA('1000008736','6988347'),
	T_TIPO_DATA('1000008736','7001103'),
	T_TIPO_DATA('1000008736','7002122'),
	T_TIPO_DATA('1000008736','7002382'),
	T_TIPO_DATA('1000008741','6988791'),
	T_TIPO_DATA('1000008741','6988792'),
	T_TIPO_DATA('1000008741','6989079'),
	T_TIPO_DATA('1000008741','6989269'),
	T_TIPO_DATA('1000008741','6989270'),
	T_TIPO_DATA('1000008745','6999332'),
	T_TIPO_DATA('1000008746','6981010'),
	T_TIPO_DATA('1000008746','6981011'),
	T_TIPO_DATA('1000008746','6981012'),
	T_TIPO_DATA('1000008747','6996864'),
	T_TIPO_DATA('1000008747','6996870'),
	T_TIPO_DATA('1000008747','6996874'),
	T_TIPO_DATA('1000008747','6996877'),
	T_TIPO_DATA('1000008747','6996888'),
	T_TIPO_DATA('1000008747','6996897'),
	T_TIPO_DATA('1000008747','6996904'),
	T_TIPO_DATA('1000008747','6996909'),
	T_TIPO_DATA('1000008747','6996926'),
	T_TIPO_DATA('1000008752','6990166'),
	T_TIPO_DATA('1000008752','6990196'),
	T_TIPO_DATA('1000008792','6991154'),
	T_TIPO_DATA('1000008792','6991277'),
	T_TIPO_DATA('1000008793','6994336'),
	T_TIPO_DATA('1000008793','6994337'),
	T_TIPO_DATA('1000008793','6994338'),
	T_TIPO_DATA('1000008793','6994339'),
	T_TIPO_DATA('1000008793','6994781'),
	T_TIPO_DATA('1000008793','6994782'),
	T_TIPO_DATA('1000008793','6994783'),
	T_TIPO_DATA('1000008793','6994808'),
	T_TIPO_DATA('1000008793','6994809'),
	T_TIPO_DATA('1000008793','6994810'),
	T_TIPO_DATA('1000008793','6994811'),
	T_TIPO_DATA('1000008793','6994812'),
	T_TIPO_DATA('1000008793','6994813'),
	T_TIPO_DATA('1000008793','6994814'),
	T_TIPO_DATA('1000008793','6994815'),
	T_TIPO_DATA('1000008799','6998546'),
	T_TIPO_DATA('1000008799','6998549'),
	T_TIPO_DATA('1000008799','6998550'),
	T_TIPO_DATA('1000008813','6983094'),
	T_TIPO_DATA('1000008813','6983097'),
	T_TIPO_DATA('1000008821','6989171'),
	T_TIPO_DATA('1000008821','6989174'),
	T_TIPO_DATA('1000008821','6989199'),
	T_TIPO_DATA('1000008821','6989200'),
	T_TIPO_DATA('1000008821','6989202'),
	T_TIPO_DATA('1000008821','6989205'),
	T_TIPO_DATA('1000008821','6989206'),
	T_TIPO_DATA('1000008821','6989231'),
	T_TIPO_DATA('1000008821','6989233'),
	T_TIPO_DATA('1000008821','6989234'),
	T_TIPO_DATA('1000008821','6989236'),
	T_TIPO_DATA('1000008821','6989238'),
	T_TIPO_DATA('1000008821','6989267'),
	T_TIPO_DATA('1000008822','6979376'),
	T_TIPO_DATA('1000008828','7001778'),
	T_TIPO_DATA('1000008833','6993345'),
	T_TIPO_DATA('1000008833','6993346'),
	T_TIPO_DATA('1000008833','6993790'),
	T_TIPO_DATA('1000008836','6986739'),
	T_TIPO_DATA('1000008836','6987217'),
	T_TIPO_DATA('1000008836','6987218'),
	T_TIPO_DATA('1000008838','6986742'),
	T_TIPO_DATA('1000008857','6983409'),
	T_TIPO_DATA('1000008858','6997360'),
	T_TIPO_DATA('1000008858','6997650'),
	T_TIPO_DATA('1000008871','6982948'),
	T_TIPO_DATA('1000008871','6982965'),
	T_TIPO_DATA('1000008871','6982966'),
	T_TIPO_DATA('1000008873','6984193'),
	T_TIPO_DATA('1000008878','6991858'),
	T_TIPO_DATA('1000008879','6988849'),
	T_TIPO_DATA('1000008879','6988851'),
	T_TIPO_DATA('1000008879','6988852'),
	T_TIPO_DATA('1000008879','6988855'),
	T_TIPO_DATA('1000008883','6986957'),
	T_TIPO_DATA('1000008884','6989753'),
	T_TIPO_DATA('1000008888','6993654'),
	T_TIPO_DATA('1000008888','6993655'),
	T_TIPO_DATA('1000008888','6993680'),
	T_TIPO_DATA('1000008894','6991945'),
	T_TIPO_DATA('1000008905','6992860'),
	T_TIPO_DATA('1000008905','6992861'),
	T_TIPO_DATA('1000008905','6992862'),
	T_TIPO_DATA('1000008906','6991719'),
	T_TIPO_DATA('1000008906','6991723'),
	T_TIPO_DATA('1000008906','6991751'),
	T_TIPO_DATA('1000008907','6992857'),
	T_TIPO_DATA('1000008907','6992858'),
	T_TIPO_DATA('1000008907','6992859'),
	T_TIPO_DATA('1000008908','6991799'),
	T_TIPO_DATA('1000008908','6992309'),
	T_TIPO_DATA('1000008909','6991693'),
	T_TIPO_DATA('1000008909','6991694'),
	T_TIPO_DATA('1000008909','6991720'),
	T_TIPO_DATA('1000008909','6991721'),
	T_TIPO_DATA('1000008909','6991722'),
	T_TIPO_DATA('1000008909','6991724'),
	T_TIPO_DATA('1000008909','6991725'),
	T_TIPO_DATA('1000008909','6991726'),
	T_TIPO_DATA('1000008909','6991752'),
	T_TIPO_DATA('1000008909','6991753'),
	T_TIPO_DATA('1000008909','6991754'),
	T_TIPO_DATA('1000008909','6991755'),
	T_TIPO_DATA('1000008914','6994157'),
	T_TIPO_DATA('1000008914','6994218'),
	T_TIPO_DATA('1000008914','6994254'),
	T_TIPO_DATA('1000008915','6988360'),
	T_TIPO_DATA('1000008915','6999556'),
	T_TIPO_DATA('1000008915','6999560'),
	T_TIPO_DATA('1000008915','7000445'),
	T_TIPO_DATA('1000008915','7000796'),
	T_TIPO_DATA('1000008915','7001134'),
	T_TIPO_DATA('1000008915','7002080'),
	T_TIPO_DATA('1000008915','7002208'),
	T_TIPO_DATA('1000008915','7002209'),
	T_TIPO_DATA('1000008915','7002210'),
	T_TIPO_DATA('1000008920','6988357'),
	T_TIPO_DATA('1000008920','7000441'),
	T_TIPO_DATA('1000008932','7000920'),
	T_TIPO_DATA('1000008933','6993901'),
	T_TIPO_DATA('1000008939','6988368'),
	T_TIPO_DATA('1000008941','6988372'),
	T_TIPO_DATA('1000008943','6988345'),
	T_TIPO_DATA('1000008944','6984895'),
	T_TIPO_DATA('1000008950','6984331'),
	T_TIPO_DATA('1000008951','6990884'),
	T_TIPO_DATA('1000008951','6990885'),
	T_TIPO_DATA('1000008951','6990886'),
	T_TIPO_DATA('1000008951','6990887'),
	T_TIPO_DATA('1000008962','6992684'),
	T_TIPO_DATA('1000008962','6992686'),
	T_TIPO_DATA('1000008962','6992711'),
	T_TIPO_DATA('1000008970','6982070'),
	T_TIPO_DATA('1000008975','6994108'),
	T_TIPO_DATA('1000008975','6994109'),
	T_TIPO_DATA('1000008975','6994110'),
	T_TIPO_DATA('1000008976','6988384'),
	T_TIPO_DATA('1000008976','6988385'),
	T_TIPO_DATA('1000008976','6988387'),
	T_TIPO_DATA('1000008976','6988388'),
	T_TIPO_DATA('1000008976','6988389'),
	T_TIPO_DATA('1000008976','6988390'),
	T_TIPO_DATA('1000008976','6988391'),
	T_TIPO_DATA('1000008977','7000563'),
	T_TIPO_DATA('1000008979','6999717'),
	T_TIPO_DATA('1000008979','6999718'),
	T_TIPO_DATA('1000008979','6999743'),
	T_TIPO_DATA('1000008979','6999744'),
	T_TIPO_DATA('1000008979','6999745'),
	T_TIPO_DATA('1000008979','6999746'),
	T_TIPO_DATA('1000008979','6999747'),
	T_TIPO_DATA('1000008979','6999748'),
	T_TIPO_DATA('1000008979','6999749'),
	T_TIPO_DATA('1000008979','6999750'),
	T_TIPO_DATA('1000008979','6999871'),
	T_TIPO_DATA('1000008979','6999872'),
	T_TIPO_DATA('1000008979','6999873'),
	T_TIPO_DATA('1000008979','6999874'),
	T_TIPO_DATA('1000008979','7000284'),
	T_TIPO_DATA('1000008979','7000285'),
	T_TIPO_DATA('1000008979','7000286'),
	T_TIPO_DATA('1000008979','7000311'),
	T_TIPO_DATA('1000008979','7000312'),
	T_TIPO_DATA('1000008979','7000313'),
	T_TIPO_DATA('1000008979','7000314'),
	T_TIPO_DATA('1000008979','7000315'),
	T_TIPO_DATA('1000008979','7000316'),
	T_TIPO_DATA('1000008979','7000317'),
	T_TIPO_DATA('1000008979','7000318'),
	T_TIPO_DATA('1000008979','7000343'),
	T_TIPO_DATA('1000008979','7000344'),
	T_TIPO_DATA('1000008979','7000345'),
	T_TIPO_DATA('1000008979','7000346'),
	T_TIPO_DATA('1000008979','7000347'),
	T_TIPO_DATA('1000008979','7000348'),
	T_TIPO_DATA('1000008979','7000349'),
	T_TIPO_DATA('1000008979','7000350'),
	T_TIPO_DATA('1000008980','6982989'),
	T_TIPO_DATA('1000008980','6983026'),
	T_TIPO_DATA('1000008980','6983054'),
	T_TIPO_DATA('1000008980','6983055'),
	T_TIPO_DATA('1000008980','6983056'),
	T_TIPO_DATA('1000008980','6983117'),
	T_TIPO_DATA('1000008980','6983118'),
	T_TIPO_DATA('1000008980','6983119'),
	T_TIPO_DATA('1000008980','6983120'),
	T_TIPO_DATA('1000008980','6983122'),
	T_TIPO_DATA('1000008980','6983123'),
	T_TIPO_DATA('1000008980','6983124'),
	T_TIPO_DATA('1000008980','6983152'),
	T_TIPO_DATA('1000008983','7001601'),
	T_TIPO_DATA('1000008983','7001605'),
	T_TIPO_DATA('1000008985','7001213'),
	T_TIPO_DATA('1000008985','7001214'),
	T_TIPO_DATA('1000008985','7001239'),
	T_TIPO_DATA('1000008985','7001241'),
	T_TIPO_DATA('1000008985','7001242'),
	T_TIPO_DATA('1000008985','7001272'),
	T_TIPO_DATA('1000008985','7001275'),
	T_TIPO_DATA('1000008985','7001276'),
	T_TIPO_DATA('1000008985','7001277'),
	T_TIPO_DATA('1000008985','7001278'),
	T_TIPO_DATA('1000008985','7001304'),
	T_TIPO_DATA('1000008986','6999779'),
	T_TIPO_DATA('1000008986','6999780'),
	T_TIPO_DATA('1000008986','6999781'),
	T_TIPO_DATA('1000008986','6999782'),
	T_TIPO_DATA('1000008986','6999808'),
	T_TIPO_DATA('1000008986','6999809'),
	T_TIPO_DATA('1000008986','6999811'),
	T_TIPO_DATA('1000008986','6999812'),
	T_TIPO_DATA('1000008989','6979273'),
	T_TIPO_DATA('1000008989','6979274'),
	T_TIPO_DATA('1000008989','6979275'),
	T_TIPO_DATA('1000008989','6979276'),
	T_TIPO_DATA('1000008989','6979277'),
	T_TIPO_DATA('1000008989','6979278'),
	T_TIPO_DATA('1000008989','6979279'),
	T_TIPO_DATA('1000008989','6979280'),
	T_TIPO_DATA('1000008989','6979281'),
	T_TIPO_DATA('1000008989','6979282'),
	T_TIPO_DATA('1000008989','6979283'),
	T_TIPO_DATA('1000008989','6979284'),
	T_TIPO_DATA('1000008989','6979285'),
	T_TIPO_DATA('1000008989','6979286'),
	T_TIPO_DATA('1000008989','6979287'),
	T_TIPO_DATA('1000008989','6979288'),
	T_TIPO_DATA('1000008989','6979289'),
	T_TIPO_DATA('1000008989','6979290'),
	T_TIPO_DATA('1000008989','6979291'),
	T_TIPO_DATA('1000008989','6979292'),
	T_TIPO_DATA('1000008989','6979293'),
	T_TIPO_DATA('1000008989','6979294'),
	T_TIPO_DATA('1000008989','6979295'),
	T_TIPO_DATA('1000008989','6979296'),
	T_TIPO_DATA('1000008989','6979297'),
	T_TIPO_DATA('1000008989','6979298'),
	T_TIPO_DATA('1000008989','6987860'),
	T_TIPO_DATA('1000008989','6987861'),
	T_TIPO_DATA('1000008989','6987862'),
	T_TIPO_DATA('1000008989','6987863'),
	T_TIPO_DATA('1000008989','6987864'),
	T_TIPO_DATA('1000008989','6987865'),
	T_TIPO_DATA('1000008989','6987866'),
	T_TIPO_DATA('1000008989','6987867'),
	T_TIPO_DATA('1000008989','6987868'),
	T_TIPO_DATA('1000008989','6987869'),
	T_TIPO_DATA('1000008989','6987870'),
	T_TIPO_DATA('1000008989','6987871'),
	T_TIPO_DATA('1000008989','6987872'),
	T_TIPO_DATA('1000008989','6987873'),
	T_TIPO_DATA('1000008989','6987874'),
	T_TIPO_DATA('1000008989','6987875'),
	T_TIPO_DATA('1000008989','6987876'),
	T_TIPO_DATA('1000008989','6987877'),
	T_TIPO_DATA('1000008989','6987878'),
	T_TIPO_DATA('1000008989','6987879'),
	T_TIPO_DATA('1000008989','6987880'),
	T_TIPO_DATA('1000008989','6987881'),
	T_TIPO_DATA('1000008989','6987882'),
	T_TIPO_DATA('1000008989','6987883'),
	T_TIPO_DATA('1000008989','6987884'),
	T_TIPO_DATA('1000008989','6987885'),
	T_TIPO_DATA('1000008989','6987886'),
	T_TIPO_DATA('1000008989','6987887'),
	T_TIPO_DATA('1000008989','6987888'),
	T_TIPO_DATA('1000008989','6987889'),
	T_TIPO_DATA('1000008989','6987890'),
	T_TIPO_DATA('1000008989','6987891'),
	T_TIPO_DATA('1000008989','6987892'),
	T_TIPO_DATA('1000008989','6987893'),
	T_TIPO_DATA('1000008989','6987894'),
	T_TIPO_DATA('1000008989','6987895'),
	T_TIPO_DATA('1000008989','6987896'),
	T_TIPO_DATA('1000008989','6987897'),
	T_TIPO_DATA('1000008989','6987898'),
	T_TIPO_DATA('1000008989','6987899'),
	T_TIPO_DATA('1000008989','6987900'),
	T_TIPO_DATA('1000008989','6987901'),
	T_TIPO_DATA('1000008989','6987902'),
	T_TIPO_DATA('1000008989','6987903'),
	T_TIPO_DATA('1000008989','6987904'),
	T_TIPO_DATA('1000008989','6987905'),
	T_TIPO_DATA('1000008989','6987906'),
	T_TIPO_DATA('1000008989','6987907'),
	T_TIPO_DATA('1000008989','6987908'),
	T_TIPO_DATA('1000008989','6987909'),
	T_TIPO_DATA('1000008989','6987910'),
	T_TIPO_DATA('1000008989','6987911'),
	T_TIPO_DATA('1000008989','6987912'),
	T_TIPO_DATA('1000008989','6987913'),
	T_TIPO_DATA('1000008989','6987914'),
	T_TIPO_DATA('1000008989','6987915'),
	T_TIPO_DATA('1000008989','6987916'),
	T_TIPO_DATA('1000008989','6987917'),
	T_TIPO_DATA('1000008989','6987918'),
	T_TIPO_DATA('1000008989','6987919'),
	T_TIPO_DATA('1000008989','6987920'),
	T_TIPO_DATA('1000008989','6987921'),
	T_TIPO_DATA('1000008989','6987922'),
	T_TIPO_DATA('1000008989','6987923'),
	T_TIPO_DATA('1000008989','6987924'),
	T_TIPO_DATA('1000008989','6987925'),
	T_TIPO_DATA('1000008989','6987926'),
	T_TIPO_DATA('1000008989','6987927'),
	T_TIPO_DATA('1000008989','6987928'),
	T_TIPO_DATA('1000008989','6987929'),
	T_TIPO_DATA('1000008989','6987930'),
	T_TIPO_DATA('1000008989','6987931'),
	T_TIPO_DATA('1000008989','6987932'),
	T_TIPO_DATA('1000008989','6987933'),
	T_TIPO_DATA('1000008989','6987934'),
	T_TIPO_DATA('1000008989','6987935'),
	T_TIPO_DATA('1000008989','6987936'),
	T_TIPO_DATA('1000008989','6987937'),
	T_TIPO_DATA('1000009005','6981155'),
	T_TIPO_DATA('1000009006','6994360'),
	T_TIPO_DATA('1000009006','6994365'),
	T_TIPO_DATA('1000009006','6994367'),
	T_TIPO_DATA('1000009006','6994369'),
	T_TIPO_DATA('1000009006','6994370'),
	T_TIPO_DATA('1000009006','6994371'),
	T_TIPO_DATA('1000009015','6984920'),
	T_TIPO_DATA('1000009015','6984921'),
	T_TIPO_DATA('1000009016','6989109'),
	T_TIPO_DATA('1000009016','6989110'),
	T_TIPO_DATA('1000009017','7001845'),
	T_TIPO_DATA('1000009017','7001846'),
	T_TIPO_DATA('1000009017','7001871'),
	T_TIPO_DATA('1000009017','7001874'),
	T_TIPO_DATA('1000009017','7001876'),
	T_TIPO_DATA('1000009017','7001877'),
	T_TIPO_DATA('1000009019','6979942'),
	T_TIPO_DATA('1000009021','6986602'),
	T_TIPO_DATA('1000009023','6986294'),
	T_TIPO_DATA('1000009023','6986296'),
	T_TIPO_DATA('1000009023','6986298'),
	T_TIPO_DATA('1000009023','6986299'),
	T_TIPO_DATA('1000009049','6984502'),
	T_TIPO_DATA('1000009049','6984504'),
	T_TIPO_DATA('1000009049','6984505'),
	T_TIPO_DATA('1000009049','6984506'),
	T_TIPO_DATA('1000009049','6984507'),
	T_TIPO_DATA('1000009049','6984535'),
	T_TIPO_DATA('1000009049','6984536'),
	T_TIPO_DATA('1000009051','6995763'),
	T_TIPO_DATA('1000009051','6995764'),
	T_TIPO_DATA('1000009051','6995765'),
	T_TIPO_DATA('1000009052','6993968'),
	T_TIPO_DATA('1000009052','6993969'),
	T_TIPO_DATA('1000009052','6993971'),
	T_TIPO_DATA('1000009053','6989211'),
	T_TIPO_DATA('1000009053','6989213'),
	T_TIPO_DATA('1000009053','6989214'),
	T_TIPO_DATA('1000009053','6989240'),
	T_TIPO_DATA('1000009056','6999863'),
	T_TIPO_DATA('1000009056','6999864'),
	T_TIPO_DATA('1000009056','6999865'),
	T_TIPO_DATA('1000009056','6999866'),
	T_TIPO_DATA('1000009056','6999867'),
	T_TIPO_DATA('1000009056','6999868'),
	T_TIPO_DATA('1000009056','6999869'),
	T_TIPO_DATA('1000009056','6999870'),
	T_TIPO_DATA('1000009056','7000143'),
	T_TIPO_DATA('1000009056','7000144'),
	T_TIPO_DATA('1000009056','7000145'),
	T_TIPO_DATA('1000009056','7000146'),
	T_TIPO_DATA('1000009056','7000147'),
	T_TIPO_DATA('1000009056','7000148'),
	T_TIPO_DATA('1000009056','7000149'),
	T_TIPO_DATA('1000009056','7000151'),
	T_TIPO_DATA('1000009056','7000152'),
	T_TIPO_DATA('1000009056','7000153'),
	T_TIPO_DATA('1000009056','7000154'),
	T_TIPO_DATA('1000009056','7000155'),
	T_TIPO_DATA('1000009056','7000156'),
	T_TIPO_DATA('1000009056','7000157'),
	T_TIPO_DATA('1000009056','7000158'),
	T_TIPO_DATA('1000009056','7000175'),
	T_TIPO_DATA('1000009056','7000176'),
	T_TIPO_DATA('1000009056','7000177'),
	T_TIPO_DATA('1000009056','7000178'),
	T_TIPO_DATA('1000009056','7000179'),
	T_TIPO_DATA('1000009056','7000180'),
	T_TIPO_DATA('1000009056','7000181'),
	T_TIPO_DATA('1000009056','7000182'),
	T_TIPO_DATA('1000009056','7000183'),
	T_TIPO_DATA('1000009056','7000184'),
	T_TIPO_DATA('1000009056','7000185'),
	T_TIPO_DATA('1000009056','7000186'),
	T_TIPO_DATA('1000009056','7000187'),
	T_TIPO_DATA('1000009056','7000188'),
	T_TIPO_DATA('1000009056','7000189'),
	T_TIPO_DATA('1000009056','7000190'),
	T_TIPO_DATA('1000009056','7000207'),
	T_TIPO_DATA('1000009056','7000208'),
	T_TIPO_DATA('1000009056','7000209'),
	T_TIPO_DATA('1000009056','7000210'),
	T_TIPO_DATA('1000009056','7000211'),
	T_TIPO_DATA('1000009056','7000212'),
	T_TIPO_DATA('1000009056','7000213'),
	T_TIPO_DATA('1000009056','7000214'),
	T_TIPO_DATA('1000009056','7000215'),
	T_TIPO_DATA('1000009056','7000216'),
	T_TIPO_DATA('1000009056','7000217'),
	T_TIPO_DATA('1000009056','7000218'),
	T_TIPO_DATA('1000009056','7000219'),
	T_TIPO_DATA('1000009056','7000220'),
	T_TIPO_DATA('1000009056','7000239'),
	T_TIPO_DATA('1000009056','7000240'),
	T_TIPO_DATA('1000009056','7000241'),
	T_TIPO_DATA('1000009056','7000242'),
	T_TIPO_DATA('1000009056','7000243'),
	T_TIPO_DATA('1000009056','7000244'),
	T_TIPO_DATA('1000009056','7000245'),
	T_TIPO_DATA('1000009056','7000246'),
	T_TIPO_DATA('1000009056','7000271'),
	T_TIPO_DATA('1000009056','7000272'),
	T_TIPO_DATA('1000009056','7000273'),
	T_TIPO_DATA('1000009056','7000274'),
	T_TIPO_DATA('1000009056','7000275'),
	T_TIPO_DATA('1000009056','7000276'),
	T_TIPO_DATA('1000009056','7000277'),
	T_TIPO_DATA('1000009056','7000278'),
	T_TIPO_DATA('1000009056','7000303'),
	T_TIPO_DATA('1000009056','7000304'),
	T_TIPO_DATA('1000009056','7000305'),
	T_TIPO_DATA('1000009056','7000306'),
	T_TIPO_DATA('1000009056','7000307'),
	T_TIPO_DATA('1000009056','7000308'),
	T_TIPO_DATA('1000009056','7000309'),
	T_TIPO_DATA('1000009056','7000310'),
	T_TIPO_DATA('1000009056','7000335'),
	T_TIPO_DATA('1000009056','7000336'),
	T_TIPO_DATA('1000009056','7000337'),
	T_TIPO_DATA('1000009056','7000338'),
	T_TIPO_DATA('1000009056','7000339'),
	T_TIPO_DATA('1000009056','7000340'),
	T_TIPO_DATA('1000009056','7000341'),
	T_TIPO_DATA('1000009056','7000342'),
	T_TIPO_DATA('1000009056','7000367'),
	T_TIPO_DATA('1000009056','7000368'),
	T_TIPO_DATA('1000009056','7000369'),
	T_TIPO_DATA('1000009056','7000370'),
	T_TIPO_DATA('1000009056','7000371'),
	T_TIPO_DATA('1000009056','7000372'),
	T_TIPO_DATA('1000009056','7000373'),
	T_TIPO_DATA('1000009056','7000374'),
	T_TIPO_DATA('1000009060','7001287'),
	T_TIPO_DATA('1000009060','7001288'),
	T_TIPO_DATA('1000009060','7001289'),
	T_TIPO_DATA('1000009071','6996679'),
	T_TIPO_DATA('1000009071','6996704'),
	T_TIPO_DATA('1000009071','6996705'),
	T_TIPO_DATA('1000009071','6996707'),
	T_TIPO_DATA('1000009071','6996711'),
	T_TIPO_DATA('1000009073','6993542'),
	T_TIPO_DATA('1000009075','6990950'),
	T_TIPO_DATA('1000009075','6992034'),
	T_TIPO_DATA('1000009080','7001920'),
	T_TIPO_DATA('1000009080','7001925'),
	T_TIPO_DATA('1000009082','6980093'),
	T_TIPO_DATA('1000009082','6980096'),
	T_TIPO_DATA('1000009082','6980098'),
	T_TIPO_DATA('1000009082','6980099'),
	T_TIPO_DATA('1000009082','6980142'),
	T_TIPO_DATA('1000009082','6980143'),
	T_TIPO_DATA('1000009082','6980146'),
	T_TIPO_DATA('1000003964','6982844'),
	T_TIPO_DATA('1000006295','6983234'),
	T_TIPO_DATA('1000006635','7001850')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para actualizar los valores en ACT_TBJ_TRABAJO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE SITUACION COMERCIAL ACTIVO');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		
		-- COmprobamos si la agrupacion existe
		V_SQL := 'SELECT
						COUNT(1)
					FROM
						'||V_ESQUEMA||'.ACT_AGR_AGRUPACION
					WHERE
						AGR_NUM_AGRUP_REM = '||TRIM(V_TMP_TIPO_DATA(1))||'';
				
        EXECUTE IMMEDIATE V_SQL INTO V_COUNT_AGR;
        
        --Comprobamos si el activo existe
        V_SQL := 'SELECT
						COUNT(1)
					FROM
						'||V_ESQUEMA||'.ACT_ACTIVO 
					WHERE
						ACT_NUM_ACTIVO =  '||TRIM(V_TMP_TIPO_DATA(2))||'';
				
        EXECUTE IMMEDIATE V_SQL INTO V_COUNT_ACT;
        
        
        
        IF V_COUNT_AGR = 1 THEN		
			
			IF V_COUNT_ACT = 1 THEN
			
			
				V_SQL := 'SELECT
								COUNT(1)
							FROM
								'||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO
							WHERE
									ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(2))||' )
								AND
									AGR_ID = (SELECT AGR_ID FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE AGR_NUM_AGRUP_REM = '||TRIM(V_TMP_TIPO_DATA(1))||' )';
									
				EXECUTE IMMEDIATE V_SQL INTO V_COUNT_AGA;
				
				IF V_COUNT_AGA = 0 THEN
								
									V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO (
													AGA_ID,
													AGR_ID,
													ACT_ID,
													AGA_FECHA_INCLUSION,
													AGA_PRINCIPAL,
													VERSION,
													USUARIOCREAR,
													FECHACREAR,
													BORRADO
												) VALUES (
													'||V_ESQUEMA||'.S_ACT_AGA_AGRUPACION_ACTIVO.NEXTVAL,
													(SELECT AGR_ID FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE AGR_NUM_AGRUP_REM = '||TRIM(V_TMP_TIPO_DATA(1))||' ),
													(SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(2))||' ),
													TO_DATE(''18/01/2019'',''DD/MM/YYYY''),
													0,
													0,
													'''||V_USUARIO||''',
													SYSDATE,
													0
												)';
												

									EXECUTE IMMEDIATE V_MSQL;

									DBMS_OUTPUT.PUT_LINE('[INFO]: SE HA INSERTADO EN LA AGRUPACIÓN '''||TRIM(V_TMP_TIPO_DATA(1))||'''EL ACTIVO '''||TRIM(V_TMP_TIPO_DATA(2))||'''');
								
				ELSE
					DBMS_OUTPUT.PUT_LINE('[ERROR]:  AGRUPACION '''||TRIM(V_TMP_TIPO_DATA(1))||''' YA TIENE EL ACTIVO '''||TRIM(V_TMP_TIPO_DATA(2))||'''');
				END IF;
				
			ELSE 
				DBMS_OUTPUT.PUT_LINE('[ERROR]:  EL ACTIVO '''||TRIM(V_TMP_TIPO_DATA(2))||' NO EXISTE');
			END IF;
		
		ELSE
			  DBMS_OUTPUT.PUT_LINE('[ERROR]:  LA AGRUPACION '''||TRIM(V_TMP_TIPO_DATA(1))||' NO EXISTE');
		END IF;
		
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]:  LOS ACTIVOS SE HAN AÑADIDO EN LAS AGRUPACIONES');

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
