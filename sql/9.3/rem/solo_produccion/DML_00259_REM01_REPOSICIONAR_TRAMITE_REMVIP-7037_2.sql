--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200417
--## ARTEFACTO=migracion
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7036
--## PRODUCTO=NO
--## 
--## Finalidad:
--##                    
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    PL_OUTPUT VARCHAR2(32000 char);
    
    V_USUARIO VARCHAR(50 CHAR):= 'REMVIP-7036';
    OFR_NUM_OFERTA NUMBER(16);
    TAP_CODIGO VARCHAR2(50 CHAR);
    ECO_NUM_EXPEDIENTE NUMBER(16);
    TRA_ID NUMBER(16);

BEGIN
    
    DBMS_OUTPUT.put_line('[INICIO]');

    
    #ESQUEMA#.REPOSICIONAMIENTO_TRABAJO (''||V_USUARIO||'',
       '902384000001,
	902457100001,
	902792700001,
	903064400001,
	903489000001,
	903535000001,
	903543800001,
	907422800001,
	907424800001,
	907426600001,
	907847600001,
	907936400001,
	909271300001,
	909312700001,
	910702700001,
	910903100001,
	910903100002,
	911453400001,
	911609700001,
	911995800001,
	912255800001,
	912255800002,
	912255800003,
	912381400001,
	912513000001,
	912523100001,
	912554000001,
	912603100001,
	912696800001,
	912697000001,
	912697200001,
	912698100001,
	912734400001,
	912887800001,
	912921100001,
	912921100002,
	912948300001,
	912959900001,
	912973900001,
	912973900002,
	912973900003,
	913011400001,
	913034800001,
	913040800001,
	913084100001,
	913096400001,
	913138100001,
	913145600001,
	913219400001,
	913220900001,
	913240200001,
	913249600001,
	913287600001,
	913293500001,
	913339100001,
	913363200001,
	913470800001,
	913508200001,
	913512300001,
	913553100001,
	913553100002,
	913572900001,
	913573200001,
	913582000001,
	913632000001,
	913695200001,
	913695200002,
	913723000001,
	913851400001,
	913862400001,
	913865400001,
	913887400001,
	913911600001,
	913941700001,
	913957100001,
	913957200001,
	913957300001,
	913997100001,
	913999800001,
	914033500001,
	914056900001,
	916949700001,
	914087500001,
	914094200001,
	916949500001,
	916949400001,
	916949400002,
	916949200001,
	916949100001,
	916948700001,
	916948600001,
	916948300001,
	916948100001,
	916948100002,
	916948000001,
	914125400001,
	916947800001,
	916947700001,
	916947700002,
	916947700003,
	916947400001,
	916946500001,
	916946500002,
	916946300001,
	916946200001,
	914129500001,
	914139200001,
	914236700001,
	916946100001,
	914256400001,
	916946000001,
	916945900001,
	916945200001,
	916945000001,
	916944900001,
	916944800001,
	916944700001,
	916944700002,
	916944600001,
	916944300001,
	916944300002,
	916944100001,
	916943600001,
	916943600002,
	916943400001,
	916943200001,
	916942900001,
	916942800001,
	916942600001,
	916942500001,
	914256500001,
	916942300001,
	916942100001,
	916941900001,
	916941800001,
	916941700001,
	914257600001,
	916941600001,
	916941500001,
	916941500002,
	916941400001,
	916941300001,
	916941200001,
	914263500001,
	916941000001,
	916940800001,
	916940700001,
	916940700002,
	916940500001,
	916940400001,
	914263600001,
	916940200001,
	914263700001,
	914298500001,
	916939900001,
	916939800001,
	914301600001,
	916939700001,
	916939600001,
	916939500001,
	916939400001,
	916939300001,
	916938800001,
	916938800002,
	916938600001,
	916938000001,
	916937900001,
	916937800001,
	916937600001,
	916937500001,
	916937400001,
	916937300001,
	916937300002,
	916937200001,
	916937000001,
	916936900001,
	916936800001,
	916936700001,
	916936500001,
	916936400001,
	916936200001,
	916935900001,
	916935900002,
	916935900003,
	916935800001,
	916935800002,
	916935600001,
	916935400001,
	916935300001,
	916935100001,
	916935000001,
	916934800001,
	916934700001,
	916934400001,
	916933500001,
	916933300001,
	916933000001,
	916933000002,
	916932900001,
	916932300001,
	916932200001,
	916931900001,
	916931800001,
	916931700001,
	916931600001,
	916931600002,
	916931500001,
	916931500002,
	916931400001,
	916931400002,
	916931300001,
	916931300002,
	916931200001,
	916931200002,
	916931100001,
	916931100002,
	916931000001,
	916930900001,
	916930800001,
	916930600001,
	916930500001,
	916930300001,
	916930200001,
	916930200002,
	916930100001,
	916929900001,
	916929600001,
	916929500001,
	916929400001,
	916929400002,
	916929300001,
	916929200001,
	916929200002,
	916929000001,
	916928700001,
	916928700002,
	916928700003,
	916928600001,
	916928600002,
	916928600003,
	916928300001,
	916928200001,
	916928100001,
	916928100002,
	916927200001,
	916925900001,
	916925900002,
	916925800001,
	916925700001,
	914306600001,
	914316700001,
	916925600001,
	914321700001,
	916925500001,
	916925400001,
	916925300001,
	916925100001,
	916925000001,
	916924800001,
	916924800002,
	916924800003,
	916924700001,
	916924700002,
	916924600001,
	916924600002,
	916924400001,
	916924300001,
	916924300002,
	916924200001,
	916924200002,
	914348700001,
	914354500001,
	914381600001,
	914432300001,
	914433600001,
	914434800001,
	914434800002,
	914435000001,
	914435000002,
	914435300001,
	914435300002,
	914435600001,
	914435800001,
	914439100001,
	916924100001,
	916924100002,
	916923800001,
	914439200001,
	916923500001,
	916923200001,
	914439300001,
	914439400001,
	916922800001,
	914439500001,
	914439600001,
	914455300001,
	914460600001,
	914465900001,
	914479100001,
	914492700001,
	914492800001,
	914492900001,
	914493000001,
	914496600001,
	916922600001,
	916922500001,
	916922400001,
	914520400001,
	914528000001,
	916921100001,
	916921000001,
	914535300001,
	916915800001,
	916915700001,
	916915400001,
	916915400002,
	914539900001,
	916915100001,
	916915000001,
	916914800001,
	916914500001,
	916914400001,
	916914300001,
	916914300002,
	916914100001,
	916914000001,
	916913800001,
	916913800002,
	916913700001,
	916913600001,
	916913500001,
	916913400001,
	916913100001,
	916913000001,
	916912900001,
	916912700001,
	916912000001,
	916911800001,
	916911700001,
	916911600001,
	916910900001,
	916910800001,
	916910600001,
	916910500001,
	916910400001,
	916910000001,
	916909400001,
	916909300001,
	916909300002,
	916909000001,
	916908900001,
	916908400001,
	916908300001,
	914555500001,
	916906500001,
	916905300001,
	916905100001,
	914562700001,
	916904700001,
	916904600001,
	916904500001,
	916903900001,
	916903700001,
	916903300001,
	914563500001,
	914581400001,
	916903200001,
	916903100001,
	916902900001,
	916902500001,
	916902400001,
	916901500001,
	916901200001,
	916900800001,
	914612200001,
	916900400001,
	916900400002,
	916900300001,
	916900200001,
	916900100001,
	914623600001,
	914623600002,
	916900000001,
	916899800001,
	914633600001,
	916898800001,
	914656000001,
	914685300001,
	914692000001,
	916898100001,
	916897900001,
	916897800001,
	916897700001,
	916897600001,
	916897500001,
	914708900001,
	914712900001,
	914718300001,
	916897300001,
	916897200001,
	916897100001,
	916897000001,
	916897000002,
	914726000001,
	916896900001,
	916896700001,
	914726300001,
	914727900001,
	916896600001,
	914735100001,
	916896400001,
	914766700001,
	916895600001,
	916894900001,
	914771500001,
	914775000001,
	914776200001,
	914784800001,
	914793800001,
	914811000001,
	914812600001,
	914826300001,
	916894800001,
	914835000001,
	914841800001,
	914848900001,
	914849100001,
	914852300001,
	914854800001,
	914854800002,
	914861100001,
	916894400001,
	916894300001,
	916894000001,
	916893300001,
	916893100001,
	916892900001,
	914862500001,
	914865300001,
	916892400001,
	916892300001,
	916892200001,
	916892100001,
	916892000001,
	916891900001,
	914868900001,
	916891700001,
	916891600001,
	916891500001,
	916891400001,
	914879900001,
	914896400001,
	914912600001,
	914919400001,
	914924900001,
	914930700001,
	914938000001,
	914948900001,
	914952200001,
	914952800001,
	914956500001,
	914957800001,
	914960000001,
	914962300001,
	914971300001,
	916891200001,
	916891100001,
	916891000001,
	916890900001,
	916890700001,
	914994100001,
	914998900001,
	915001200001,
	915001300001,
	915003400001,
	915014600001,
	915022300001,
	915022500001,
	915022600001,
	915022800001,
	916890400001,
	915025600001,
	915027400001,
	915034300001,
	916890300001,
	916890200001,
	915035100001,
	915044000001,
	916890100001,
	915044100001,
	916890000001,
	916889800001,
	916889700001,
	915044300001,
	915044600001,
	915048400001,
	915048500001,
	915048600001,
	915048700001,
	915048800001,
	915048900001,
	915049000001,
	915049200001,
	915049300001,
	915049400001,
	915056000001,
	916889500001,
	916889400001,
	915063800001,
	916889300001,
	916889200001,
	916889000001,
	915066300001,
	916888400001,
	916888200001,
	916887900001,
	916887800001,
	916887300001,
	915069500001,
	916887000001,
	915076200001,
	916886600001,
	916886600002,
	916886200001,
	915085000001,
	915087700001,
	915092900001,
	916886000001,
	916885900001,
	915107900001,
	915109900001,
	915110100001,
	915110200001,
	915119800001,
	915120400001,
	915134500001,
	915134900001,
	915139400001,
	915142200001,
	915146400001,
	915149400001,
	915149500001,
	915149800001,
	915150000001,
	915153300001,
	915155300001,
	915161300001,
	915163300001,
	915165900001,
	915166100001,
	915166500001,
	915178500001,
	915186000001,
	915186400001,
	915186600001,
	915191300001,
	915193600001,
	916885000001,
	916884400001,
	916884200001,
	916884100001,
	916884000001,
	916883900001,
	916883800001,
	916883700001,
	916883600001,
	916883500001,
	916883400001,
	916883300001,
	916883200001,
	916883100001,
	916883000001,
	916882900001,
	916882600001,
	916882300001,
	916882000001,
	916881900001,
	915203400001,
	915203500001,
	916881200001,
	916881100001,
	916880900001,
	915203700001,
	915209000001,
	915209500001,
	915210500001,
	915218100001,
	915221800001,
	915226500001,
	915228600001,
	916880800001,
	916880800002,
	916880800003,
	916880600001,
	916880400001,
	916880300001,
	915229000001,
	916879900001,
	916879700001,
	916879600001,
	916879500001,
	916879300001,
	916879200001,
	916879100001,
	916878700001,
	915229800001,
	916878500001,
	916878500002,
	916877800001,
	915233600001,
	916877500001,
	916877300001,
	916876600001,
	915236900001,
	915237100001,
	915237300001,
	915237400001,
	915239000001,
	915239200001,
	915239300001,
	915239800001,
	916875300001,
	916875200001,
	916875200002,
	915240200001,
	916873700001,
	915249900001,
	915249900002,
	915250900001,
	915257500001,
	915258500001,
	915262400001,
	915266400001,
	915267700001,
	916872700001,
	915270400001,
	915278600001,
	915278700001,
	915283400001,
	916872500001,
	915285100001,
	915288800001,
	916872200001,
	916872000001,
	916871800001,
	916871400001,
	916871300001,
	915306800001,
	915327100001,
	915333200001,
	916870600001,
	916870500001,
	915341300001,
	916870200001,
	916870100001,
	916870000001,
	915341900001,
	915341900002,
	916869900001,
	916869600001,
	916869500001,
	916869400001,
	915350600001,
	915353500001,
	916869300001,
	916869200001,
	916869200002,
	916869100001,
	915354200001,
	915359100001,
	916868900001,
	915360300001,
	915366300001,
	915377000001,
	916868800001,
	915379500001,
	915382900001,
	916868700001,
	916868300001,
	915383200001,
	916868200001,
	916868100001,
	916868000001,
	915387700001,
	915388400001,
	915393300001,
	915393700001,
	915393900001,
	915396300001,
	915397300001,
	915411700001,
	915426700001,
	915430700001,
	915434800001,
	916866700001,
	916866200001,
	916866200002,
	916866100001,
	916866100002,
	916866000001,
	916865800001,
	915444700001,
	916865700001,
	916865700002,
	916865700003,
	916865700004,
	915445800001,
	916865400001,
	916865300001,
	916865200001,
	915450500001,
	916865000001,
	915451600001,
	915452400001,
	915453700001,
	915454700001,
	915457600001,
	915463900001,
	916864900001,
	916864800001,
	916864700001,
	916864700002,
	916864600001,
	916864500001,
	916864200001,
	916864100001,
	916863900001,
	916863600001,
	916863400001,
	916863300001,
	916863300002,
	916863300003,
	916863200001,
	916863000001,
	916862300001,
	916862100001,
	916861600001,
	916861500001,
	916861400001,
	916861200001,
	916861100001,
	916861000001,
	915464000001,
	915464600001,
	915467100001,
	915481300001,
	915487900001,
	915489100001,
	915490600001,
	915491600001,
	915496900001,
	915503700001,
	916860700001,
	916860600001,
	916860500001,
	915507900001,
	916860400001,
	915508700001,
	915508800001,
	916860200001,
	916860100001,
	915511100001,
	915522900001,
	915527600001,
	915536400001,
	915539400001,
	915554900001,
	915556700001,
	916860000001,
	915558500001,
	915564300001,
	915567900001,
	915568100001,
	915569600001,
	915570700001,
	915573400001,
	915578400001,
	915580700001,
	915581700001,
	915586200001,
	915589900001,
	915610200001,
	915615400001,
	915620000001,
	915622700001,
	915627000001,
	915627400001,
	915632700001,
	915646400001,
	915652900001,
	915659600001,
	915674700001,
	915675700001,
	915678000001,
	915680300001,
	916859800001,
	915680600001,
	915690000001,
	915692900001,
	915693000001,
	916859400001,
	915697500001,
	915700300001,
	916859000001,
	916858900001,
	915701500001,
	915703900001,
	915708600001,
	915709000001,
	915710600001,
	915710700001,
	916854700001,
	916853500001,
	916853500002,
	916853500003,
	916853400001,
	916853300001,
	916852800001,
	916852400001,
	916852200001,
	916852100001,
	916851800001,
	916851800002,
	916851600001,
	916851400001,
	916851400002,
	916851200001,
	916850700001,
	916850400001,
	916850300001,
	916850200001,
	916850100001,
	916850000001,
	916849800001,
	916849600001,
	916849500001,
	916849400001,
	916849300001,
	916849200001,
	916849000001,
	916848800001,
	916848800002,
	916848400001,
	916848100001,
	916847900001,
	916847800001,
	916846900001,
	916846700001,
	916846600001,
	916846500001,
	915711300001,
	915712100001,
	915714500001,
	915714600001,
	915715900001,
	915716800001,
	915720200001,
	915723300001,
	915726700001,
	915731700001,
	915734900001,
	915738500001,
	915739900001,
	915742600001,
	915743000001,
	915750000001,
	915754000001,
	915755100001,
	915759900001,
	915760600001,
	915764600001,
	915766200001,
	915767700001,
	915768600001,
	915768800001,
	915771000001,
	915771100001,
	915771200001,
	915771300001,
	915775200001,
	915779900001,
	915781200001,
	915783300001,
	915784400001,
	915785700001,
	915794700001,
	915795200001,
	915796100001,
	915804400001,
	915808300001,
	915809100001,
	915810200001,
	915810300001,
	915812100001,
	915812800001,
	915816300001,
	916846400001,
	915822700001,
	915823300001,
	915827400001,
	916846300001,
	916846300002,
	916846200001,
	915829200001,
	916846000001,
	915833400001,
	915834600001,
	916845900001,
	916845800001,
	916845600001,
	916845400001,
	915835800001,
	915837400001,
	916845300001,
	916845300002,
	916845200001,
	916845100001,
	916845000001,
	916844900001,
	915837500001,
	916844800001,
	916844700001,
	915837800001,
	916844400001,
	916844300001,
	916844300002,
	916844300003,
	915839400001,
	916844200001,
	916844100001,
	916844000001,
	916843900001,
	915843900001,
	915845500001,
	916843500001,
	916843500002,
	916843400001,
	915846000001,
	916843300001,
	916842400001,
	916842300001,
	916842200001,
	916842000001,
	916842000002,
	916841600001,
	916841400001,
	916841300001,
	916841200001,
	916841000001,
	916840800001,
	916840700001,
	916840600001,
	916840500001,
	916840200001,
	916840100001,
	916840000001,
	916839900001,
	915847500001,
	916839700001,
	915848900001,
	915852600001,
	915853100001,
	916839600001,
	916839500001,
	915853300001,
	916839100001,
	916839000001,
	916838900001,
	916838800001,
	916838600001,
	915853500001,
	916838400001,
	916838300001,
	915854100001,
	916838000001,
	915855100001,
	915857200001,
	915857200002,
	915857200003,
	915857300001,
	916837600001,
	915862700001,
	915877500001,
	915877700001,
	915883400001,
	915887400001,
	915887700001,
	915887900001,
	915893100001,
	915893200001,
	915903100001,
	915905200001,
	916837200001,
	916837100001,
	915906500001'
        , 'T004_ResultadoTarificada');

    
	COMMIT;
 DBMS_OUTPUT.put_line('[OK]');
 DBMS_OUTPUT.put_line('[FIN]');
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
EXIT;