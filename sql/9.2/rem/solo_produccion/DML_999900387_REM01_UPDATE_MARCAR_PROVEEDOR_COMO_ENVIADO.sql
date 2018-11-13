--/*
--###########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20181105
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2305
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATEAR IMPORTE TRABAJO 
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
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-2305';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1500);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    ------ 	 		NIF , PVE_ID
    T_TIPO_DATA('02523192T','88770'),
	T_TIPO_DATA('052533968J','47834'),
	T_TIPO_DATA('08788963L','78771'),
	T_TIPO_DATA('12235419V','21548'),
	T_TIPO_DATA('12720044D','20739'),
	T_TIPO_DATA('18917291K','22736'),
	T_TIPO_DATA('19991286P','21451'),
	T_TIPO_DATA('20000013','71808'),
	T_TIPO_DATA('20010389','60614'),
	T_TIPO_DATA('20010976','60004'),
	T_TIPO_DATA('20010976','61893'),
	T_TIPO_DATA('20021412','60368'),
	T_TIPO_DATA('20031944','49876'),
	T_TIPO_DATA('20032688','47904'),
	T_TIPO_DATA('20032688','47978'),
	T_TIPO_DATA('20032692','47868'),
	T_TIPO_DATA('20032822','59798'),
	T_TIPO_DATA('20032932','47923'),
	T_TIPO_DATA('20033099','59893'),
	T_TIPO_DATA('20033099','59979'),
	T_TIPO_DATA('20033099','63452'),
	T_TIPO_DATA('20033099','63775'),
	T_TIPO_DATA('20033117','63447'),
	T_TIPO_DATA('20033117','65065'),
	T_TIPO_DATA('20033117','65110'),
	T_TIPO_DATA('20033142','58158'),
	T_TIPO_DATA('20033142','58324'),
	T_TIPO_DATA('20033142','58453'),
	T_TIPO_DATA('20033142','58490'),
	T_TIPO_DATA('20033142','60734'),
	T_TIPO_DATA('20033142','61657'),
	T_TIPO_DATA('20033142','61699'),
	T_TIPO_DATA('20033142','61708'),
	T_TIPO_DATA('20033142','61866'),
	T_TIPO_DATA('20033142','61996'),
	T_TIPO_DATA('20033142','62044'),
	T_TIPO_DATA('20033142','62082'),
	T_TIPO_DATA('20033142','63424'),
	T_TIPO_DATA('20033142','63695'),
	T_TIPO_DATA('20033142','65332'),
	T_TIPO_DATA('20033142','68731'),
	T_TIPO_DATA('20033142','68922'),
	T_TIPO_DATA('20033142','70845'),
	T_TIPO_DATA('20033142','70866'),
	T_TIPO_DATA('20033142','70891'),
	T_TIPO_DATA('20033144','55198'),
	T_TIPO_DATA('20033144','55199'),
	T_TIPO_DATA('20033144','55200'),
	T_TIPO_DATA('20033144','55201'),
	T_TIPO_DATA('20033144','55261'),
	T_TIPO_DATA('20033144','55273'),
	T_TIPO_DATA('20033144','55274'),
	T_TIPO_DATA('20033144','55290'),
	T_TIPO_DATA('20033155','56585'),
	T_TIPO_DATA('20033155','56587'),
	T_TIPO_DATA('20033155','56588'),
	T_TIPO_DATA('20033155','56591'),
	T_TIPO_DATA('20033155','56592'),
	T_TIPO_DATA('20033155','56593'),
	T_TIPO_DATA('20033155','56594'),
	T_TIPO_DATA('20033159','56965'),
	T_TIPO_DATA('20033159','56966'),
	T_TIPO_DATA('20033159','56967'),
	T_TIPO_DATA('20033159','56969'),
	T_TIPO_DATA('20033159','56970'),
	T_TIPO_DATA('20033159','56972'),
	T_TIPO_DATA('20033159','56973'),
	T_TIPO_DATA('20033176','57604'),
	T_TIPO_DATA('20033176','57605'),
	T_TIPO_DATA('20033176','57606'),
	T_TIPO_DATA('20033176','57633'),
	T_TIPO_DATA('20033176','57670'),
	T_TIPO_DATA('20033176','57671'),
	T_TIPO_DATA('20033176','57700'),
	T_TIPO_DATA('20033179','57857'),
	T_TIPO_DATA('20033190','61646'),
	T_TIPO_DATA('20033209','58227'),
	T_TIPO_DATA('20033255','68654'),
	T_TIPO_DATA('20033313','58822'),
	T_TIPO_DATA('20033313','64236'),
	T_TIPO_DATA('20033358','61635'),
	T_TIPO_DATA('20033411','67066'),
	T_TIPO_DATA('20033472','63304'),
	T_TIPO_DATA('20033472','65452'),
	T_TIPO_DATA('20033472','66992'),
	T_TIPO_DATA('20033472','67107'),
	T_TIPO_DATA('20033472','67269'),
	T_TIPO_DATA('20033472','68942'),
	T_TIPO_DATA('20033472','69153'),
	T_TIPO_DATA('20033482','60130'),
	T_TIPO_DATA('20033541','62577'),
	T_TIPO_DATA('20033541','63684'),
	T_TIPO_DATA('20033605','73024'),
	T_TIPO_DATA('20033605','73028'),
	T_TIPO_DATA('20033608','58247'),
	T_TIPO_DATA('20033608','60345'),
	T_TIPO_DATA('20033631','59998'),
	T_TIPO_DATA('20033644','60188'),
	T_TIPO_DATA('20033651','78213'),
	T_TIPO_DATA('20033651','78214'),
	T_TIPO_DATA('20033651','78215'),
	T_TIPO_DATA('20033651','78216'),
	T_TIPO_DATA('20033651','78217'),
	T_TIPO_DATA('20033651','78218'),
	T_TIPO_DATA('20033651','78219'),
	T_TIPO_DATA('20033651','78220'),
	T_TIPO_DATA('20033651','78221'),
	T_TIPO_DATA('20033651','78222'),
	T_TIPO_DATA('20033651','78223'),
	T_TIPO_DATA('20033651','78224'),
	T_TIPO_DATA('20033651','78225'),
	T_TIPO_DATA('20033651','78226'),
	T_TIPO_DATA('20033651','78227'),
	T_TIPO_DATA('20033651','78228'),
	T_TIPO_DATA('20033651','78229'),
	T_TIPO_DATA('20033651','78230'),
	T_TIPO_DATA('20033651','78231'),
	T_TIPO_DATA('20033651','78232'),
	T_TIPO_DATA('20033651','78233'),
	T_TIPO_DATA('20033651','78234'),
	T_TIPO_DATA('20033651','78235'),
	T_TIPO_DATA('20033651','78236'),
	T_TIPO_DATA('20033651','78237'),
	T_TIPO_DATA('20033651','78240'),
	T_TIPO_DATA('20033651','78241'),
	T_TIPO_DATA('20033651','78242'),
	T_TIPO_DATA('20033651','78243'),
	T_TIPO_DATA('20033651','78244'),
	T_TIPO_DATA('20033651','78245'),
	T_TIPO_DATA('20033651','78246'),
	T_TIPO_DATA('20033653','78627'),
	T_TIPO_DATA('20033653','78628'),
	T_TIPO_DATA('20033653','78629'),
	T_TIPO_DATA('20033653','78630'),
	T_TIPO_DATA('20033653','78631'),
	T_TIPO_DATA('20033653','78634'),
	T_TIPO_DATA('20033653','78635'),
	T_TIPO_DATA('20033653','78636'),
	T_TIPO_DATA('20033653','78637'),
	T_TIPO_DATA('20033653','78638'),
	T_TIPO_DATA('20033653','78641'),
	T_TIPO_DATA('20033653','78642'),
	T_TIPO_DATA('20033653','78643'),
	T_TIPO_DATA('20033653','78644'),
	T_TIPO_DATA('20033653','78647'),
	T_TIPO_DATA('20033653','78648'),
	T_TIPO_DATA('20033653','78649'),
	T_TIPO_DATA('20033653','78650'),
	T_TIPO_DATA('20033653','78651'),
	T_TIPO_DATA('20033653','78655'),
	T_TIPO_DATA('20033653','78656'),
	T_TIPO_DATA('20033653','78657'),
	T_TIPO_DATA('20033653','78660'),
	T_TIPO_DATA('20033653','78661'),
	T_TIPO_DATA('20033653','78662'),
	T_TIPO_DATA('20033653','78663'),
	T_TIPO_DATA('20033653','78664'),
	T_TIPO_DATA('20033653','78665'),
	T_TIPO_DATA('20033653','78667'),
	T_TIPO_DATA('20033653','78668'),
	T_TIPO_DATA('20033656','78827'),
	T_TIPO_DATA('20033656','78828'),
	T_TIPO_DATA('20033656','78829'),
	T_TIPO_DATA('20033656','78830'),
	T_TIPO_DATA('20033656','78831'),
	T_TIPO_DATA('20033656','78832'),
	T_TIPO_DATA('20033656','78833'),
	T_TIPO_DATA('20033656','78834'),
	T_TIPO_DATA('20033656','78835'),
	T_TIPO_DATA('20033656','78836'),
	T_TIPO_DATA('20033656','78837'),
	T_TIPO_DATA('20033656','78838'),
	T_TIPO_DATA('20033656','78839'),
	T_TIPO_DATA('20033656','78840'),
	T_TIPO_DATA('20033656','78841'),
	T_TIPO_DATA('20033656','78842'),
	T_TIPO_DATA('20033656','78843'),
	T_TIPO_DATA('20033656','78844'),
	T_TIPO_DATA('20033656','78845'),
	T_TIPO_DATA('20033656','78846'),
	T_TIPO_DATA('20033656','78847'),
	T_TIPO_DATA('20033656','78848'),
	T_TIPO_DATA('20033656','78849'),
	T_TIPO_DATA('20033656','78850'),
	T_TIPO_DATA('20033656','78851'),
	T_TIPO_DATA('20033656','78852'),
	T_TIPO_DATA('20033656','78853'),
	T_TIPO_DATA('20033656','78854'),
	T_TIPO_DATA('20033656','78855'),
	T_TIPO_DATA('20033656','78856'),
	T_TIPO_DATA('20033685','58260'),
	T_TIPO_DATA('20033692','68851'),
	T_TIPO_DATA('20033703','58221'),
	T_TIPO_DATA('20033839','61905'),
	T_TIPO_DATA('20033870','61930'),
	T_TIPO_DATA('20033913','61987'),
	T_TIPO_DATA('20033927','58712'),
	T_TIPO_DATA('20033959','63732'),
	T_TIPO_DATA('20033959','63798'),
	T_TIPO_DATA('20034062','63792'),
	T_TIPO_DATA('20034137','65448'),
	T_TIPO_DATA('20034210','58509'),
	T_TIPO_DATA('20034302','63812'),
	T_TIPO_DATA('20034490','58563'),
	T_TIPO_DATA('20034507','62062'),
	T_TIPO_DATA('20034548','60379'),
	T_TIPO_DATA('20034621','58884'),
	T_TIPO_DATA('20034624','62140'),
	T_TIPO_DATA('20034626','60457'),
	T_TIPO_DATA('20034626','61313'),
	T_TIPO_DATA('20034626','63082'),
	T_TIPO_DATA('20034626','63094'),
	T_TIPO_DATA('20034626','63934'),
	T_TIPO_DATA('20034626','70186'),
	T_TIPO_DATA('20034626','70248'),
	T_TIPO_DATA('20034666','58690'),
	T_TIPO_DATA('20034691','60413'),
	T_TIPO_DATA('20034728','60444'),
	T_TIPO_DATA('20034779','58702'),
	T_TIPO_DATA('20034953','58585'),
	T_TIPO_DATA('20035799','68144'),
	T_TIPO_DATA('20035996','63172'),
	T_TIPO_DATA('20035996','70191'),
	T_TIPO_DATA('20036414','64814'),
	T_TIPO_DATA('20037029','63270'),
	T_TIPO_DATA('20037522','59819'),
	T_TIPO_DATA('21489741J','1089'),
	T_TIPO_DATA('21940710K','20197'),
	T_TIPO_DATA('22549331Q','21492'),
	T_TIPO_DATA('22663883M','19152'),
	T_TIPO_DATA('24182722Q','21268'),
	T_TIPO_DATA('2705418C','18861'),
	T_TIPO_DATA('31204038F','19673'),
	T_TIPO_DATA('40874387Y','20767'),
	T_TIPO_DATA('43014322K','20158'),
	T_TIPO_DATA('44504278Z','52822'),
	T_TIPO_DATA('44870007C','24327'),
	T_TIPO_DATA('48055553C','52831'),
	T_TIPO_DATA('50867811E','89029'),
	T_TIPO_DATA('52122650G','27548'),
	T_TIPO_DATA('52246780A','21462'),
	T_TIPO_DATA('52605703B','22372'),
	T_TIPO_DATA('5668632Y','3960'),
	T_TIPO_DATA('71417421Y','20091'),
	T_TIPO_DATA('74343318G','20645'),
	T_TIPO_DATA('8816137F','2856'),
	T_TIPO_DATA('9797945Z','21921'),
	T_TIPO_DATA('A03895836','20079'),
	T_TIPO_DATA('A28161396','3411'),
	T_TIPO_DATA('A28161396','5879'),
	T_TIPO_DATA('A33002106','88952'),
	T_TIPO_DATA('A63222533','3421'),
	T_TIPO_DATA('A63222533','22421'),
	T_TIPO_DATA('A82838350','93'),
	T_TIPO_DATA('A95113361','35246'),
	T_TIPO_DATA('A95113361','82113'),
	T_TIPO_DATA('A95113361','82655'),
	T_TIPO_DATA('B82373804','5006'),
	T_TIPO_DATA('B82373804','20310'),
	T_TIPO_DATA('B82802075','2824'),
	T_TIPO_DATA('B82802075','20732'),
	T_TIPO_DATA('B82846817','23643'),
	T_TIPO_DATA('B84783596','80828'),
	T_TIPO_DATA('B97061584','27270'),
	T_TIPO_DATA('E08553513','29829'),
	T_TIPO_DATA('E25039769','36428'),
	T_TIPO_DATA('E40016735','47856'),
	T_TIPO_DATA('E46950176','5487'),
	T_TIPO_DATA('E78229622','72416'),
	T_TIPO_DATA('E78345758','72445'),
	T_TIPO_DATA('E78433224','72432'),
	T_TIPO_DATA('E78655255','72435'),
	T_TIPO_DATA('E78929072','72421'),
	T_TIPO_DATA('E78982808','72436'),
	T_TIPO_DATA('E92919448','21925'),
	T_TIPO_DATA('G53978938','42880'),
	T_TIPO_DATA('G73228389','26865'),
	T_TIPO_DATA('h05221577','72804'),
	T_TIPO_DATA('H06561641','68206'),
	T_TIPO_DATA('H12257580','58320'),
	T_TIPO_DATA('H12277570','66195'),
	T_TIPO_DATA('H12277570','67467'),
	T_TIPO_DATA('H12277570','69181'),
	T_TIPO_DATA('H12277570','69419'),
	T_TIPO_DATA('H12399770','62129'),
	T_TIPO_DATA('H12492294','61995'),
	T_TIPO_DATA('H12535621','63548'),
	T_TIPO_DATA('H12578159','58489'),
	T_TIPO_DATA('H12589610','59895'),
	T_TIPO_DATA('H12589610','65276'),
	T_TIPO_DATA('H12625034','60797'),
	T_TIPO_DATA('H12638672','62572'),
	T_TIPO_DATA('H12697462','62915'),
	T_TIPO_DATA('H12717815','60821'),
	T_TIPO_DATA('H12770632','67204'),
	T_TIPO_DATA('H12773289','68779'),
	T_TIPO_DATA('H12785846','66650'),
	T_TIPO_DATA('H12798914','49983'),
	T_TIPO_DATA('H12819660','60817'),
	T_TIPO_DATA('H12848370','61206'),
	T_TIPO_DATA('H12848370','68262'),
	T_TIPO_DATA('H12883427','56692'),
	T_TIPO_DATA('H13417738','63043'),
	T_TIPO_DATA('h16118325','73217'),
	T_TIPO_DATA('H16193336','52664'),
	T_TIPO_DATA('H17276122','32521'),
	T_TIPO_DATA('H17964685','12050'),
	T_TIPO_DATA('H24069643','46943'),
	T_TIPO_DATA('H26103861','62725'),
	T_TIPO_DATA('H26158154','69047'),
	T_TIPO_DATA('H26458521','60220'),
	T_TIPO_DATA('H26467456','62016'),
	T_TIPO_DATA('H30282925','30232'),
	T_TIPO_DATA('H33598335','58377'),
	T_TIPO_DATA('H36394245','58420'),
	T_TIPO_DATA('H36538619','66944'),
	T_TIPO_DATA('H37341708','51454'),
	T_TIPO_DATA('H39539861','65095'),
	T_TIPO_DATA('H39539861','66925'),
	T_TIPO_DATA('H39596986','62243'),
	T_TIPO_DATA('H39714589','59449'),
	T_TIPO_DATA('H43255819','36576'),
	T_TIPO_DATA('H43265628','29146'),
	T_TIPO_DATA('H43278357','31033'),
	T_TIPO_DATA('H43281690','30744'),
	T_TIPO_DATA('H43299924','28335'),
	T_TIPO_DATA('H43590710','31833'),
	T_TIPO_DATA('H43656396','35721'),
	T_TIPO_DATA('H43679992','36058'),
	T_TIPO_DATA('H43693902','36538'),
	T_TIPO_DATA('H43886381','35719'),
	T_TIPO_DATA('H43916790','35698'),
	T_TIPO_DATA('H43922707','28989'),
	T_TIPO_DATA('H44171403','61797'),
	T_TIPO_DATA('H44225092','60243'),
	T_TIPO_DATA('H45342250','58070'),
	T_TIPO_DATA('H45495231','47957'),
	T_TIPO_DATA('H45641669','62607'),
	T_TIPO_DATA('H45650348','64346'),
	T_TIPO_DATA('H45695285','50361'),
	T_TIPO_DATA('H53608352','87840'),
	T_TIPO_DATA('H55123871','10608'),
	T_TIPO_DATA('H55191779','28913'),
	T_TIPO_DATA('H58034554','28070'),
	T_TIPO_DATA('H58858200','30709'),
	T_TIPO_DATA('H58878596','28021'),
	T_TIPO_DATA('H58923210','28082'),
	T_TIPO_DATA('H59009415','30690'),
	T_TIPO_DATA('H59988220','33835'),
	T_TIPO_DATA('H61169280','28095'),
	T_TIPO_DATA('H61325049','33242'),
	T_TIPO_DATA('H61484499','28707'),
	T_TIPO_DATA('H61968574','27770'),
	T_TIPO_DATA('H62792130','30361'),
	T_TIPO_DATA('H64225782','29452'),
	T_TIPO_DATA('H73621831','76382'),
	T_TIPO_DATA('H73722860','30249'),
	T_TIPO_DATA('H86420627','34714'),
	T_TIPO_DATA('H86420627','56938'),
	T_TIPO_DATA('H97366744','42240'),
	T_TIPO_DATA('h97521330','73013'),
	T_TIPO_DATA('H99170151','59615'),
	T_TIPO_DATA('H99170151','59616'),
	T_TIPO_DATA('H99170151','59617'),
	T_TIPO_DATA('H99170151','61343'),
	T_TIPO_DATA('H99170151','64842'),
	T_TIPO_DATA('H99170151','66633'),
	T_TIPO_DATA('H99170151','70218'),
	T_TIPO_DATA('H99170151','70219'),
	T_TIPO_DATA('J86981560','24536'),
	T_TIPO_DATA('P0600900E','47258'),
	T_TIPO_DATA('P0609400G','47288'),
	T_TIPO_DATA('P1210900e','26659'),
	T_TIPO_DATA('P1400028E','49834'),
	T_TIPO_DATA('P1400028E','80502'),
	T_TIPO_DATA('P1500600J','47096'),
	T_TIPO_DATA('P1507100D','47291'),
	T_TIPO_DATA('P1700053J','21206'),
	T_TIPO_DATA('P2203100I','47254'),
	T_TIPO_DATA('P2217800H','35384'),
	T_TIPO_DATA('P2602300B','47250'),
	T_TIPO_DATA('P3901200J','47303'),
	T_TIPO_DATA('P3903900C','47244'),
	T_TIPO_DATA('P3909100D','47263'),
	T_TIPO_DATA('P4100000A','19447'),
	T_TIPO_DATA('P4100000A','80921'),
	T_TIPO_DATA('P4507200F','47139'),
	T_TIPO_DATA('P4513700G','47005'),
	T_TIPO_DATA('P4513700G','47037'),
	T_TIPO_DATA('P4513700G','47084'),
	T_TIPO_DATA('P4616100F','23596'),
	T_TIPO_DATA('P4616100F','80690'),
	T_TIPO_DATA('P5000600F','47284'),
	T_TIPO_DATA('P5590001C','20781'),
	T_TIPO_DATA('P6700002F','20378'),
	T_TIPO_DATA('P6700002F','26965'),
	T_TIPO_DATA('P7900001D','19541'),
	T_TIPO_DATA('P7900001D','81659'),
	T_TIPO_DATA('Q5856419F','20787'),
	T_TIPO_DATA('U12663605','1193'),
	T_TIPO_DATA('U12663605','24595'),
	T_TIPO_DATA('V26391607','62192')   

	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para actualizar los valores en ECO_CONDICIONANTES_EXPEDIENTE -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: MARCAR PROVEEDOR COMO ENVIADO');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_ID = '||TRIM(V_TMP_TIPO_DATA(2))||'';
		
       -- DBMS_OUTPUT.PUT_LINE(V_SQL);		
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       -- DBMS_OUTPUT.PUT_LINE(V_NUM_TABLAS);
			--Si existe realizamos otra comprobacion
			IF V_NUM_TABLAS > 0 THEN	
			
					V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR
									SET
										PVE_ENVIADO = SYSDATE,
										USUARIOMODIFICAR = '''||V_USUARIO||''',
										FECHAMODIFICAR = SYSDATE
								WHERE
									PVE_ID = '||TRIM(V_TMP_TIPO_DATA(2))||'';
					
					EXECUTE IMMEDIATE V_MSQL;	
				
			--El activo no existe
			ELSE
				  DBMS_OUTPUT.PUT_LINE('[ERROR]:  NO EXISTE EL PROVEEDOR CON ID '||TRIM(V_TMP_TIPO_DATA(2))||' ');
			END IF;
		
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]:  LOS PROVEEDORES HAN SIDO MARCADOS CORRECTAMENTE ');

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
