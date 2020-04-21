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

    
    
#ESQUEMA#.REPOSICIONAMIENTO_TRABAJO(''||V_USUARIO||'', 
	TRIM('915906500002,
	915906500003,
	915906500004,
	916836900001,
	916836800001,
	916836700001,
	916836600001,
	916836500001,
	916836400001,
	916836300001,
	916836200001,
	916836100001,
	916836000001,
	916835900001,
	916835800001,
	916835700001,
	916835600001,
	916835500001,
	916835400001,
	916835300001,
	916835200001,
	916835100001,
	916835000001,
	916834900001,
	916834800001,
	916834700001,
	916834600001,
	916834500001,
	916834400001,
	916834300001,
	916834200001,
	916834100001,
	916834000001,
	916833000001,
	916832000001,
	916831900001,
	916831800001,
	916831700001,
	916831600001,
	916831500001,
	916831400001,
	916831200001,
	916831100001,
	916831000001,
	916830900001,
	916830800001,
	916830700001,
	916830600001,
	916830500001,
	916830400001,
	916830300001,
	916830200001,
	916830100001,
	916830000001,
	916829900001,
	916829800001,
	916829700001,
	916829600001,
	916829500001,
	916829400001,
	916829300001,
	916829200001,
	916829100001,
	916829000001,
	916828900001,
	916828800001,
	916828700001,
	916828600001,
	916828500001,
	916828400001,
	916828300001,
	916828200001,
	916828100001,
	916828000001,
	916827900001,
	916827800001,
	916827700001,
	916827600001,
	916827500001,
	916827400001,
	916827300001,
	916827200001,
	916827100001,
	916827000001,
	916826900001,
	916826800001,
	916826700001,
	916826600001,
	916826500001,
	916826300001,
	916826100001,
	916826000001,
	915906600001,
	916825500001,
	916825400001,
	916825200001,
	915909900001,
	915912200001,
	916825000001,
	916824900001,
	916824900002,
	916824900003,
	916824800001,
	915914600001,
	916824600001,
	916824600002,
	916824400001,
	916824300001,
	916824300002,
	916824200001,
	916824100001,
	915916400001,
	915918800001,
	915919800001,
	915920700001,
	915922000001,
	915922100001,
	915925300001,
	915925300002,
	915929000001,
	915929600001,
	915931400001,
	915934800001,
	915944200001,
	915947500001,
	915947500002,
	915947500003,
	915948500001,
	915948600001,
	915949500001,
	915950700001,
	915951000001,
	915951800001,
	915955100001,
	915955100002,
	915955100003,
	915955200001,
	915955500001,
	915955500002,
	915955500003,
	915955600001,
	915955600002,
	915955600003,
	915955800001,
	915955800002,
	915955800003,
	915955900001,
	915955900002,
	915955900003,
	915957700001,
	915957700002,
	915961600001,
	915963000001,
	915963200001,
	915967400001,
	915968100001,
	915968700001,
	915969300001,
	915976600001,
	915978300001,
	915980700001,
	915980800001,
	915985900001,
	915987200001,
	915993600001,
	915995000001,
	915998000001,
	916001100001,
	916001800001,
	916002100001,
	916013700001,
	916823800001,
	916823400001,
	916823300001,
	916822400001,
	916822300001,
	916822200001,
	916822100001,
	916821400001,
	916821200001,
	916820900001,
	916820800001,
	916820800002,
	916820600001,
	916820000001,
	916820000002,
	916819900001,
	916819900002,
	916819800001,
	916819700001,
	916819600001,
	916819600002,
	916017200001,
	916021500001,
	916021600001,
	916024300001,
	916025900001,
	916819000001,
	916818900001,
	916818800001,
	916818200001,
	916817600001,
	916817600002,
	916817300001,
	916816600001,
	916816600002,
	916816100001,
	916815800001,
	916815600001,
	916815600002,
	916815500001,
	916815500002,
	916815300001,
	916815300002,
	916814800001,
	916814700001,
	916814700002,
	916814600001,
	916814400001,
	916814300001,
	916814300002,
	916814100001,
	916814000001,
	916813800001,
	916813400001,
	916813200001,
	916812500001,
	916811500001,
	916811400001,
	916810900001,
	916026300001,
	916026500001,
	916027600001,
	916810000001,
	916809400001,
	916809100001,
	916809000001,
	916808800001,
	916808200001,
	916807900001,
	916031900001,
	916032900001,
	916034200001,
	916034400001,
	916034700001,
	916038000001,
	916807500001,
	916807400001,
	916807300001,
	916038100001,
	916806600001,
	916040100001,
	916806100001,
	916805900001,
	916041700001,
	916805800001,
	916805600001,
	916805500001,
	916043100001,
	916805200001,
	916805200002,
	916804800001,
	916804800002,
	916804700001,
	916804700002,
	916804600001,
	916804400001,
	916804400002,
	916804400003,
	916803300001,
	916803200001,
	916803200002,
	916803100001,
	916803100002,
	916803000001,
	916803000002,
	916802900001,
	916802900002,
	916045400001,
	916802700001,
	916802700002,
	916802600001,
	916802600002,
	916802500001,
	916802500002,
	916802300001,
	916802300002,
	916045700001,
	916802200001,
	916802200002,
	916802100001,
	916802100002,
	916802000001,
	916802000002,
	916801900001,
	916801900002,
	916801800001,
	916801800002,
	916801700001,
	916801700002,
	916801600001,
	916801600002,
	916801500001,
	916801500002,
	916801400001,
	916801400002,
	916801300001,
	916801300002,
	916801200001,
	916801200002,
	916801100001,
	916801100002,
	916801000001,
	916801000002,
	916800900001,
	916800900002,
	916800800001,
	916800800002,
	916800700001,
	916800700002,
	916800600001,
	916800600002,
	916800500001,
	916800500002,
	916800400001,
	916800400002,
	916800300001,
	916800300002,
	916800200001,
	916800200002,
	916800100001,
	916800100002,
	916800000001,
	916800000002,
	916799900001,
	916799900002,
	916799800001,
	916799800002,
	916799700001,
	916799700002,
	916799600001,
	916799600002,
	916799500001,
	916799500002,
	916799400001,
	916799400002,
	916799300001,
	916799300002,
	916799200001,
	916799200002,
	916799100001,
	916799000001,
	916799000002,
	916046100001,
	916046400001,
	916047400001,
	916048200001,
	916049100001,
	916049200001,
	916049700001,
	916050700001,
	916051000001,
	916055500001,
	916055600001,
	916055800001,
	916798900001,
	916798700001,
	916798600001,
	916798500001,
	916798400001,
	916798200001,
	916056600001,
	916797700001,
	916797600001,
	916797500001,
	916797300001,
	916057400001,
	916796000001,
	916795400001,
	916795100001,
	916794600001,
	916794500001,
	916057800001,
	916793900001,
	916792500001,
	916792200001,
	916059600001,
	916062300001,
	916066500001,
	916072500001,
	916792000001,
	916791900001,
	916791700001,
	916791200001,
	916791100001,
	916073500001,
	916790500001,
	916790200001,
	916790100001,
	916790000001,
	916789900001,
	916789700001,
	916074200001,
	916074600001,
	916789600001,
	916788800001,
	916788600001,
	916788500001,
	916788400001,
	916788300001,
	916788200001,
	916788200002,
	916788000001,
	916787500001,
	916787500002,
	916787400001,
	916787400002,
	916787100001,
	916787100002,
	916787000001,
	916786800001,
	916786700001,
	916074700001,
	916075500001,
	916786000001,
	916785900001,
	916785800001,
	916076000001,
	916076800001,
	916785400001,
	916078600001,
	916784700001,
	916078900001,
	916783300001,
	916783100001,
	916783000001,
	916782900001,
	916782900002,
	916782900003,
	916782700001,
	916782600001,
	916782500001,
	916782300001,
	916782100001,
	916782000001,
	916781800001,
	916781800002,
	916781600001,
	916781200001,
	916780700001,
	916780600001,
	916780500001,
	916780300001,
	916780200001,
	916780100001,
	916779900001,
	916779800001,
	916779700001,
	916779600001,
	916779500001,
	916779200001,
	916779100001,
	916778900001,
	916778800001,
	916778700001,
	916778600001,
	916778100001,
	916777900001,
	916777800001,
	916777700001,
	916777600001,
	916777600002,
	916777500001,
	916777400001,
	916777300001,
	916777200001,
	916777100001,
	916777000001,
	916776900001,
	916776800001,
	916776700001,
	916776500001,
	916776400001,
	916776100001,
	916776000001,
	916775800001,
	916775600001,
	916775000001,
	916774700001,
	916774500001,
	916774200001,
	916774000001,
	916773300001,
	916772800001,
	916772700001,
	916772600001,
	916771300001,
	916770600001,
	916770300001,
	916770300002,
	916770200001,
	916769400001,
	916769100001,
	916768900001,
	916768800001,
	916768400001,
	916768000001,
	916767800001,
	916767600001,
	916767400001,
	916767200001,
	916766400001,
	916766200001,
	916765700001,
	916764800001,
	916764200001,
	916764100001,
	916763800001,
	916763300001,
	916761500001,
	916760800001,
	916760500001,
	916760300001,
	916760200001,
	916759900001,
	916759800001,
	916759500001,
	916759300001,
	916759200001,
	916759100001,
	916759000001,
	916758800001,
	916758800002,
	916758700001,
	916758600001,
	916758400001,
	916758000001,
	916757900001,
	916757700001,
	916757400001,
	916757200001,
	916756500001,
	916756400001,
	916756200001,
	916756100001,
	916756000001,
	916755900001,
	916755700001,
	916755600001,
	916755400001,
	916755200001,
	916755000001,
	916754800001,
	916754700001,
	916754600001,
	916754500001,
	916754400001,
	916754300001,
	916754300002,
	916754300003,
	916754200001,
	916754100001,
	916753800001,
	916753700001,
	916753600001,
	916753500001,
	916753300001,
	916080700001,
	916753200001,
	916753000001,
	916081500001,
	916752900001,
	916082800001,
	916752700001,
	916752600001,
	916752500001,
	916752300001,
	916752200001,
	916084700001,
	916084700002,
	916752000001,
	916751900001,
	916749900001,
	916085500001,
	916749700001,
	916087100001,
	916087100002,
	916749600001,
	916749400001,
	916749300001,
	916749200001,
	916748900001,
	916748800001,
	916748600001,
	916748500001,
	916748300001,
	916748100001,
	916090700001,
	916091500001,
	916091800001,
	916094800001,
	916095200001,
	916095700001,
	916096800001,
	916747900001,
	916097400001,
	916098300001,
	916099900001,
	916101300001,
	916101700001,
	916103300001,
	916103700001,
	916104700001,
	916118800001,
	916120800001,
	916122900001,
	916123100001,
	916124300001,
	916124400001,
	916125100001,
	916128200001,
	916129600001,
	916747700001,
	916747500001,
	916747100001,
	916746400001,
	916745800001,
	916745700001,
	916745600001,
	916745500001,
	916738900001,
	916738400001,
	916738400002,
	916738000001,
	916737400001,
	916737000001,
	916736500001,
	916736100001,
	916736000001,
	916735600001,
	916735500001,
	916734900001,
	916734300001,
	916734200001,
	916733800001,
	916733300001,
	916733100001,
	916732900001,
	916732100001,
	916731200001,
	916730300001,
	916730200001,
	916730000001,
	916729800001,
	916729700001,
	916729500001,
	916729300001,
	916729200001,
	916728900001,
	916728700001,
	916727200001,
	916727100001,
	916727000001,
	916726600001,
	916726300001,
	916726200001,
	916726000001,
	916725900001,
	916725700001,
	916725500001,
	916137300001,
	916725400001,
	916725300001,
	916140700001,
	916724800001,
	916724700001,
	916724500001,
	916724400001,
	916724300001,
	916724100001,
	916723900001,
	916723300001,
	916722900001,
	916722600001,
	916722300001,
	916722100001,
	916721800001,
	916721700001,
	916143100001,
	916721600001,
	916143600001,
	916146400001,
	916147700001,
	916721400001,
	916721100001,
	916721000001,
	916720900001,
	916720800001,
	916720500001,
	916720400001,
	916720300001,
	916720100001,
	916720000001,
	916719600001,
	916719500001,
	916148000001,
	916719200001,
	916719100001,
	916719000001,
	916718900001,
	916718700001,
	916718500001,
	916718500002,
	916718400001,
	916718300001,
	916718200001,
	916718000001,
	916717800001,
	916717500001,
	916717200001,
	916717100001,
	916716800001,
	916716700001,
	916149100001,
	916149100002,
	916149200001,
	916716000001,
	916152100001,
	916152200001,
	916715800001,
	916715700001,
	916153000001,
	916715600001,
	916715500001,
	916155200001,
	916155500001,
	916155500002,
	916715400001,
	916715200001,
	916715100001,
	916715000001,
	916714900001,
	916714900002,
	916714800001,
	916714700001,
	916714600001,
	916714600002,
	916714600003,
	916157500001,
	916157800001,
	916158200001,
	916713300001,
	916158700001,
	916713200001,
	916711900001,
	916158900001,
	916159500001,
	916711400001,
	916711400002,
	916711400003,
	916711400004,
	916711400005,
	916161100001,
	916711100001,
	916161400001,
	916168400001,
	916711000001,
	916169500001,
	916710600001,
	916169800001,
	916170500001,
	916710100001,
	916710000001,
	916709900001,
	916171700001,
	916172700001,
	916173500001,
	916709500001,
	916709500002,
	916709300001,
	916708900001,
	916708500001,
	916708300001,
	916708100001,
	916708000001,
	916190300001,
	916190400001,
	916190400002,
	916706300001,
	916705800001,
	916190600001,
	916190700001,
	916190900001,
	916191000001,
	916191100001,
	916191200001,
	916704800001,
	916704700001,
	916704600001,
	916704600002,
	916704500001,
	916704300001,
	916704000001,
	916703700001,
	916703500001,
	916191300001,
	916702300001,
	916702200001,
	916702100001,
	916191400001,
	916701600001,
	916701600002,
	916701500001,
	916701200001,
	916191500001,
	916701000001,
	916191600001,
	916700400001,
	916191700001,
	916700000001,
	916699800001,
	916698700001,
	916698600001,
	916698400001,
	916191800001,
	916191900001,
	916698300001,
	916698200001,
	916698000001,
	916697900001,
	916697400001,
	916192000001,
	916697100001,
	916696900001,
	916192100001,
	916192200001,
	916192400001,
	916192500001,
	916192600001,
	916192700001,
	916696600001,
	916696500001,
	916696400001,
	916696300001,
	916696200001,
	916696100001,
	916696000001,
	916695900001,
	916695800001,
	916695500001,
	916695400001,
	916695400002,
	916694900001,
	916694600001,
	916694400001,
	916192900001,
	916193100001,
	916694200001,
	916193200001,
	916694100001,
	916693900001,
	916193300001,
	916693500001,
	916693400001,
	916693200001,
	916193400001,
	916692400001,
	916193500001,
	916193600001,
	916690700001,
	916193700001,
	916193800001,
	916193900001,
	916194000001,
	916690400001,
	916194100001,
	916690300001,
	916194200001,
	916690200001,
	916690000001,
	916689900001,
	916689600001,
	916689500001,
	916689400001,
	916689000001,
	916688700001,
	916194300001,
	916688600001,
	916688500001,
	916688300001,
	916688100001,
	916687900001,
	916194600001,
	916687600001,
	916687400001,
	916687000001,
	916194700001,
	916686600001,
	916686400001,
	916686300001,
	916686300002,
	916686200001,
	916686200002,
	916194800001,
	916685400001,
	916685300001,
	916685100001,
	916683900001,
	916683600001,
	916683200001,
	916682300001,
	916194900001,
	916681900001,
	916681500001,
	916681300001,
	916681100001,
	916680600001,
	916680500001,
	916680200001,
	916679900001,
	916679700001,
	916679600001,
	916678800001,
	916678300001,
	916678200001,
	916677900001,
	916677800001,
	916677700001,
	916195000001,
	916677500001,
	916195100001,
	916676400001,
	916676100001,
	916195300001,
	916196100001,
	916675800001,
	916197400001,
	916675500001,
	916675400001,
	916675400002,
	916198800001,
	916675300001,
	916675200001,
	916675100001,
	916198900001,
	916675000001,
	916674600001,
	916201500001,
	916202400001,
	916673300001,
	916673200001,
	916202700001,
	916672500001,
	916672000001,
	916671700001,
	916671600001,
	916671500001,
	916205900001,
	916671300001,
	916671100001,
	916671100002,
	916670800001,
	916670200001,
	916669900001,
	916669600001,
	916669400001,
	916669100001,
	916669000001,
	916668400001,
	916667900001,
	916206000001,
	916667600001,
	916207300001,
	916667200001,
	916665900001,
	916665500001,
	916665500002,
	916665200001,
	916208100001,
	916664200001,
	916664100001,
	916664000001,
	916663700001,
	916663400001,
	916208700001,
	916663200001,
	916209000001,
	916210000001,
	916210100001,
	916661400001,
	916661300001,
	916210500001,
	916661000001,
	916660500001')
        , 'T004_ResultadoTarificada');
        
   #ESQUEMA#.ALTA_BPM_INSTANCES(''||V_USUARIO||'', PL_OUTPUT);
    
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