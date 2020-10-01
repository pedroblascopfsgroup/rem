--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20200922
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8085
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar telefono de usuarios que son gestores
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Modificacion filtro por numero de telefonos nulos
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8085'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='USU_USUARIOS'; --Vble. auxiliar para almacenar la tabla a insertar
    
	
    V_ID NUMBER(16); --Vble. Para almacenar el id del usuario a modificar
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    	-- USU.USU_USERNAME	   USU.USU_TELEFONO
        T_TIPO_DATA('jmaynau','663280555'),
        T_TIPO_DATA('imartin','608152482'),
        T_TIPO_DATA('asanfrutos','689749292'),
        T_TIPO_DATA('jlostao','629853863'),
        T_TIPO_DATA('ecamano','690669823'),
        T_TIPO_DATA('fmartinez','629694146'),
        T_TIPO_DATA('lsanmiguel','620205015'),
        T_TIPO_DATA('pfernandezg','616393241'),
        T_TIPO_DATA('asantos','699412822'),
        T_TIPO_DATA('dgonzalez','626087445'),
        T_TIPO_DATA('fvaldes','676243575'),
        T_TIPO_DATA('mcomyn','682575003'),
        T_TIPO_DATA('dejeda','628729129'),
        T_TIPO_DATA('lgarciat','648754979'),
        T_TIPO_DATA('gsanchez','639922080'),
        T_TIPO_DATA('jtorresr','618718455'),
        T_TIPO_DATA('jdelgado','648588261'),
        T_TIPO_DATA('jmartinm','659119355'),
        T_TIPO_DATA('mcarmona','630967173'),
        T_TIPO_DATA('malonsom','626148082'),
        T_TIPO_DATA('jfernandez','646174308'),
        T_TIPO_DATA('rherrero','667878355'),
        T_TIPO_DATA('csalvador','696461549'),
        T_TIPO_DATA('dfarre','659260716'),
        T_TIPO_DATA('jmoreno','639967890'),
        T_TIPO_DATA('rcanales','679849147'),
        T_TIPO_DATA('jcordoba','638129412'),
        T_TIPO_DATA('mhernandez','696980744'),
        T_TIPO_DATA('msanchezd','628254842'),
        T_TIPO_DATA('pagudo','620637675'),
        T_TIPO_DATA('sflores','628510393'),
        T_TIPO_DATA('jcobas','639939052'),
        T_TIPO_DATA('jherranz','618740908'),
        T_TIPO_DATA('ilopezm','649470291'),
        T_TIPO_DATA('slopez','638067411'),
        T_TIPO_DATA('mmartinma','649370934'),
        T_TIPO_DATA('gmarting','689444006'),
        T_TIPO_DATA('tvaloria','689048721'),
        T_TIPO_DATA('mjbondia','626339024'),
        T_TIPO_DATA('ejust','620727648'),
        T_TIPO_DATA('afraile','679951494'),
        T_TIPO_DATA('lalonsor','669529528'),
        T_TIPO_DATA('mvgonzalez','618394051'),
        T_TIPO_DATA('sbertomeu','660761210'),
        T_TIPO_DATA('psm','659463700'),
        T_TIPO_DATA('nvalle','650704534'),
        T_TIPO_DATA('mgarcia','618081793'),
        T_TIPO_DATA('dmartin','609718923'),
        T_TIPO_DATA('ivazquez','660760302'),
        T_TIPO_DATA('jdominguezr','608518938'),
        T_TIPO_DATA('ecabrera','618730464'),
        T_TIPO_DATA('ajimeneze','679129970'),
        T_TIPO_DATA('ygarciam','689937090'),
        T_TIPO_DATA('emaurizot','638145830'),
        T_TIPO_DATA('ksteiert','626609509'),
        T_TIPO_DATA('shernandez','679354948'),
        T_TIPO_DATA('jherrera','682818975'),
        T_TIPO_DATA('nbenedicto','669163796'),
        T_TIPO_DATA('bizquierdo','619668344'),
        T_TIPO_DATA('ataboadaa','669239357'),
        T_TIPO_DATA('borjadavila','615496033'),
        T_TIPO_DATA('acaridad','661684057'),
        T_TIPO_DATA('ogv','609630122'),
        T_TIPO_DATA('malonso','667464922'),
        T_TIPO_DATA('mtm','696087644'),
        T_TIPO_DATA('mmartinpenato','639478280'),
        T_TIPO_DATA('mmarquis','699734547'),
        T_TIPO_DATA('nserrano','676533175'),
        T_TIPO_DATA('cotero','683472412'),
        T_TIPO_DATA('orojo','689986871'),
        T_TIPO_DATA('mmonzon','696724668'),
        T_TIPO_DATA('jalarcon','676005255'),
        T_TIPO_DATA('jsanchis','689422625'),
        T_TIPO_DATA('gblanco','660315338'),
        T_TIPO_DATA('suriel','619500461'),
        T_TIPO_DATA('rduenas','690105124'),
        T_TIPO_DATA('jcortinaa','650326677'),
        T_TIPO_DATA('jsanchezs','683297989'),
        T_TIPO_DATA('agomez','646119394'),
        T_TIPO_DATA('lgomezc','686863652'),
        T_TIPO_DATA('alobo','682796596'),
        T_TIPO_DATA('dgutierrez','660180167'),
        T_TIPO_DATA('jpoyatos','616420664'),
        T_TIPO_DATA('ngeneroso','672431633'),
        T_TIPO_DATA('mselleri','681084141'),
        T_TIPO_DATA('jmg','676960612'),
        T_TIPO_DATA('asaenz','606610162'),
        T_TIPO_DATA('dgarciag','680392507'),
        T_TIPO_DATA('bgs','659602129'),
        T_TIPO_DATA('chm','680190272'),
        T_TIPO_DATA('odominguez','689426605'),
        T_TIPO_DATA('jmonterrubio','616355369'),
        T_TIPO_DATA('jencinar','682204667'),
        T_TIPO_DATA('epozuelo','625091222'),
        T_TIPO_DATA('malvaro','630979241'),
        T_TIPO_DATA('cmartin','686983031'),
        T_TIPO_DATA('fdeusa','682861374'),
        T_TIPO_DATA('mredon','682865508'),
        T_TIPO_DATA('csolaz','636196280'),
        T_TIPO_DATA('abenavides','646181254'),
        T_TIPO_DATA('ccarles','636196528'),
        T_TIPO_DATA('aperis','686296859'),
        T_TIPO_DATA('amp','680332989'),
        T_TIPO_DATA('slozano','647666017'),
        T_TIPO_DATA('marenas','682548936'),
        T_TIPO_DATA('llp','669353530'),
        T_TIPO_DATA('lsanchez','629694452'),
        T_TIPO_DATA('nlopez-cuadra','639594926'),
        T_TIPO_DATA('rgarciaa','669828960'),
        T_TIPO_DATA('cmartinezc','689803858'),
        T_TIPO_DATA('jpulgar','673569013'),
        T_TIPO_DATA('sllopis','682138832'),
        T_TIPO_DATA('privas','630084970'),
        T_TIPO_DATA('mjc','638095765'),
        T_TIPO_DATA('nmartinezb','648588670'),
        T_TIPO_DATA('mdomarco','696132698'),
        T_TIPO_DATA('odelatorre','627612323'),
        T_TIPO_DATA('mrial','608362891'),
        T_TIPO_DATA('cmorales','690155548'),
        T_TIPO_DATA('mmorandeira','609391647'),
        T_TIPO_DATA('mgonzalezf','681342179'),
        T_TIPO_DATA('lfabe','630205704'),
        T_TIPO_DATA('purquiza','620090780'),
        T_TIPO_DATA('aruiz','629820307'),
        T_TIPO_DATA('nhorcajo','606101406'),
        T_TIPO_DATA('rcervantesi','699034286'),
        T_TIPO_DATA('adelaroja','630338475'),
        T_TIPO_DATA('dortiz','680327554'),
        T_TIPO_DATA('lestebanez','627611466'),
        T_TIPO_DATA('osuarez','646252488'),
        T_TIPO_DATA('bnorena','628682465'),
        T_TIPO_DATA('mlopezy','620869466'),
        T_TIPO_DATA('jgarciago','638446672'),
        T_TIPO_DATA('nfernandez','682833059'),
        T_TIPO_DATA('vmateos','680295531'),
        T_TIPO_DATA('vgl','680623472'),
        T_TIPO_DATA('bmorales','686294328'),
        T_TIPO_DATA('fcortes','636553598'),
        T_TIPO_DATA('rchicharro','669013403'),
        T_TIPO_DATA('bruiz','629867067'),
        T_TIPO_DATA('csanchezd','689102432'),
        T_TIPO_DATA('lsanchiz','648913573'),
        T_TIPO_DATA('smontes','683319446'),
        T_TIPO_DATA('igonzalezlo','636553214'),
        T_TIPO_DATA('olopez','636554904'),
        T_TIPO_DATA('msanchezbeato','680383546'),
        T_TIPO_DATA('mtl','618940535'),
        T_TIPO_DATA('jtamarit','689735961'),
        T_TIPO_DATA('lnestar','669948297'),
        T_TIPO_DATA('rtalavera','682639993'),
        T_TIPO_DATA('dpalomares','682836536'),
        T_TIPO_DATA('cgalaron','682838147'),
        T_TIPO_DATA('ebertrandelis','689042749'),
        T_TIPO_DATA('mgarciaarr','649279236'),
        T_TIPO_DATA('llmaroto','673694060'),
        T_TIPO_DATA('anavas','657549425'),
        T_TIPO_DATA('gblancos','682044907'),
        T_TIPO_DATA('rpecharroman','627614467'),
        T_TIPO_DATA('lbarcelo','639727161'),
        T_TIPO_DATA('mhernandezb','669122722'),
        T_TIPO_DATA('mgarciaj','619941423'),
        T_TIPO_DATA('orubio','680299901'),
        T_TIPO_DATA('asanchezgui','681017022'),
        T_TIPO_DATA('magui','680402262'),
        T_TIPO_DATA('falves','626824511'),
        T_TIPO_DATA('achillon','682846177'),
        T_TIPO_DATA('scapellan','648190741'),
        T_TIPO_DATA('ocg','682841040'),
        T_TIPO_DATA('iss','690622210'),
        T_TIPO_DATA('mfabra','680373272'),
        T_TIPO_DATA('iperezf','682066310'),
        T_TIPO_DATA('sulldemolins','626282805'),
        T_TIPO_DATA('dvalero','618562346'),
        T_TIPO_DATA('ebenitezt','696354134'),
        T_TIPO_DATA('avilarino','639480630'),
        T_TIPO_DATA('saragon','606677948'),
        T_TIPO_DATA('ndelaossa','636798786'),
        T_TIPO_DATA('jalmendros','689959167'),
        T_TIPO_DATA('aruedag','690685391'),
        T_TIPO_DATA('cvinets','639381013'),
        T_TIPO_DATA('cmunoz','639764476'),
        T_TIPO_DATA('ltorices','680578119'),
        T_TIPO_DATA('lmunoz','659652257'),
        T_TIPO_DATA('sbroto','650741995'),
        T_TIPO_DATA('pmoliner','680620249'),
        T_TIPO_DATA('rescuredo','696802821'),
        T_TIPO_DATA('lmorillom','679336000'),
        T_TIPO_DATA('sch','630993136'),
        T_TIPO_DATA('vpeino','683171808'),
        T_TIPO_DATA('bgil','686084180'),
        T_TIPO_DATA('bcoello','690338692'),
        T_TIPO_DATA('bzubiria','607377248'),
        T_TIPO_DATA('jmena','646308310'),
        T_TIPO_DATA('jgonzalezg','636561773'),
        T_TIPO_DATA('tpereira','629415554'),
        T_TIPO_DATA('tgonzalez','682101464'),
        T_TIPO_DATA('amenendeza','676009454'),
        T_TIPO_DATA('igonzaleza','682082629'),
        T_TIPO_DATA('mmadariaga','682931627'),
        T_TIPO_DATA('plopez','619083363'),
        T_TIPO_DATA('adelgado','676439403'),
        T_TIPO_DATA('oramirez','683461664'),
        T_TIPO_DATA('vcastillo','682325005'),
        T_TIPO_DATA('eluque','650886713'),
        T_TIPO_DATA('amanzanob','690201409'),
        T_TIPO_DATA('rmh','676724678'),
        T_TIPO_DATA('jmatencias','650559607'),
        T_TIPO_DATA('msanzm','682667865'),
        T_TIPO_DATA('jbacciadone','690760964'),
        T_TIPO_DATA('adelaiglesia','689358613'),
        T_TIPO_DATA('gpradena','679418421'),
        T_TIPO_DATA('rgarvia','683130312'),
        T_TIPO_DATA('shormaeche','672796670'),
        T_TIPO_DATA('jsanesteban','608806369'),
        T_TIPO_DATA('jizquierdo','638511796'),
        T_TIPO_DATA('lmorales','682344114'),
        T_TIPO_DATA('avalerog','682650979'),
        T_TIPO_DATA('jespejo','682924200'),
        T_TIPO_DATA('mramirezh','686282051'),
        T_TIPO_DATA('bhuerta','690213029'),
        T_TIPO_DATA('acm','686396600'),
        T_TIPO_DATA('npenalba','660195478'),
        T_TIPO_DATA('mbalderrama','682735057'),
        T_TIPO_DATA('csanchezc','690877976'),
        T_TIPO_DATA('igarcial','699542258'),
        T_TIPO_DATA('irodriguez','659791855'),
        T_TIPO_DATA('cbarros','630056931'),
        T_TIPO_DATA('fyago','629227217'),
        T_TIPO_DATA('alopezdehierro','630080968'),
        T_TIPO_DATA('aojeda','649791721'),
        T_TIPO_DATA('operegrina','609100680'),
        T_TIPO_DATA('gesteban','659567759')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN USU_USUARIOS ');
        
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

         V_SQL := 'SELECT DISTINCT COUNT(1)
        FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC 
		JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID
		JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON (GEE.DD_TGE_ID = TGE.DD_TGE_ID AND DD_TGE_CODIGO = ''GCOM'' AND  GEE.BORRADO = 0)
		JOIN '||V_ESQUEMA_M||'.'||V_TABLA||' USU ON USU.USU_ID = GEE.USU_ID WHERE USU.USU_USERNAME='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''  AND (USU.USU_TELEFONO IS NULL OR USU.USU_TELEFONO!='''|| TRIM(V_TMP_TIPO_DATA(2)) ||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN

            V_COUNT:=V_COUNT+1;

            V_SQL := 'SELECT DISTINCT USU.USU_ID
                    FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC 
                    JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID
                    JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON (GEE.DD_TGE_ID = TGE.DD_TGE_ID AND DD_TGE_CODIGO = ''GCOM'' AND  GEE.BORRADO = 0)
                    JOIN '||V_ESQUEMA_M||'.'||V_TABLA||' USU ON USU.USU_ID = GEE.USU_ID WHERE USU.USU_USERNAME='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''  AND (USU.USU_TELEFONO IS NULL OR USU.USU_TELEFONO!='''|| TRIM(V_TMP_TIPO_DATA(2)) ||''') ';
            
            EXECUTE IMMEDIATE V_SQL INTO V_ID;
            
            V_SQL := 'UPDATE '||V_ESQUEMA_M||'.'||V_TABLA||' SET
                        USU_TELEFONO = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''',
                        USUARIOMODIFICAR = '''||V_USUARIO||''', 
                        FECHAMODIFICAR = SYSDATE
                        WHERE USU_ID='||V_ID||'';

            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]:                                    ');
            DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE:= '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
            DBMS_OUTPUT.PUT_LINE('[INFO]:                                    ');

        ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO]: EL USUARIO CON USERNAME: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' TIENE EL MISMO TELEFONO QUE EL ADJUNTADO: ('''|| TRIM(V_TMP_TIPO_DATA(2)) ||''') ');
       
        END IF;
    
        
      END LOOP;
    
        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS CORRECTAMENTE: '''||V_COUNT||''' REGISTROS ');
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    
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