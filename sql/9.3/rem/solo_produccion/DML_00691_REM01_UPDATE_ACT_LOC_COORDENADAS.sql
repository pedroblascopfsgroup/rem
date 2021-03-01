--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20210224
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8972
--## PRODUCTO=NO
--##
--## Finalidad: script para añadir las coordenadas correctas
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-8972'; -- USUARIOCREAR/USUARIOMODIFICAR.
    REC_ID NUMBER(16);
    LOC_CODIGO VARCHAR2(20 CHAR);
    PRV_CODIGO VARCHAR2(20 CHAR);
    LOC_ID NUMBER(16);
    PRV_ID NUMBER(16);
    ACT_ID NUMBER(16);
    BIE_ID NUMBER(16);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--act_recovery_id, dd_loc_codigo, dd_prv_codigo

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
	
		T_JBV(7314861,'43.5071375657','-8.1859886138'),
		T_JBV(7321003,'42.1836727637','-1.748476794'),
		T_JBV(7324373,'42.0333228152','-4.5896179709'),
		T_JBV(7323312,'41.7088108909','1.8502799762'),
		T_JBV(7323311,'41.7088108909','1.8502799762'),
		T_JBV(7323310,'41.7088108909','1.8502799762'),
		T_JBV(7323309,'41.7088108909','1.8502799762'),
		T_JBV(7323308,'41.7088108909','1.8502799762'),
		T_JBV(7323307,'41.7088108909','1.8502799762'),
		T_JBV(7323306,'41.7088108909','1.8502799762'),
		T_JBV(7323305,'41.7088108909','1.8502799762'),
		T_JBV(7323304,'41.7088108909','1.8502799762'),
		T_JBV(7323303,'41.7088108909','1.8502799762'),
		T_JBV(7323302,'41.7088108909','1.8502799762'),
		T_JBV(7323301,'41.7088108909','1.8502799762'),
		T_JBV(7323300,'41.7088108909','1.8502799762'),
		T_JBV(7323299,'41.7088108909','1.8502799762'),
		T_JBV(7323298,'41.7088108909','1.8502799762'),
		T_JBV(7323297,'41.7088108909','1.8502799762'),
		T_JBV(7323296,'41.7088108909','1.8502799762'),
		T_JBV(7323295,'41.7088108909','1.8502799762'),
		T_JBV(7323294,'41.7088108909','1.8502799762'),
		T_JBV(7323293,'41.7088108909','1.8502799762'),
		T_JBV(7323292,'41.7088108909','1.8502799762'),
		T_JBV(7323291,'41.7088108909','1.8502799762'),
		T_JBV(7323290,'41.7088108909','1.8502799762'),
		T_JBV(7323289,'41.7088108909','1.8502799762'),
		T_JBV(7322344,'41.6255910568','0.6256569104'),
		T_JBV(7309097,'41.6218411646','0.6209149786'),
		T_JBV(7311309,'41.6117364749','0.6631323037'),
		T_JBV(7305453,'41.6101858968','0.6154678047'),
		T_JBV(7309171,'41.5772171698','2.0318896992'),
		T_JBV(7308264,'41.5742627941','2.0302840407'),
		T_JBV(7304418,'41.5680903975','2.0295104036'),
		T_JBV(7309207,'41.5669902219','2.0309582991'),
		T_JBV(7310690,'41.5648588837','2.023202633'),
		T_JBV(7310678,'41.5605957493','2.0246210158'),
		T_JBV(7305722,'41.5560075482','2.0057004876'),
		T_JBV(7307313,'41.5556100723','2.0110805414'),
		T_JBV(7307312,'41.5556100723','2.0110805414'),
		T_JBV(7307311,'41.5556100723','2.0110805414'),
		T_JBV(7307310,'41.5556100723','2.0110805414'),
		T_JBV(7307309,'41.5556100723','2.0110805414'),
		T_JBV(7308665,'41.5553204416','2.0242107271'),
		T_JBV(7318061,'41.54433817','2.4491921023'),
		T_JBV(7312486,'41.5405199632','2.0441573647'),
		T_JBV(7309896,'41.5352795001','2.040193596'),
		T_JBV(7314615,'41.487737737','2.0384804499'),
		T_JBV(7322389,'41.487212506','2.025975858'),
		T_JBV(7305639,'41.4469694591','2.184402484'),
		T_JBV(7306838,'41.4419516493','2.1791283673'),
		T_JBV(7318833,'41.430689357','2.1661248015'),
		T_JBV(7308883,'41.4072157042','2.1257855221'),
		T_JBV(7308882,'41.4072157042','2.1257855221'),
		T_JBV(7308881,'41.4072157042','2.1257855221'),
		T_JBV(7308880,'41.4072157042','2.1257855221'),
		T_JBV(7322499,'41.394204444','2.177504012'),
		T_JBV(7310590,'41.3365667015','1.7004241872'),
		T_JBV(7310580,'41.3365667015','1.7004241872'),
		T_JBV(7311129,'40.7922000223','-3.4703052479'),
		T_JBV(7311658,'40.6172706705','-5.9544751968'),
		T_JBV(7311446,'40.256256967','-3.8222658424'),
		T_JBV(7321801,'39.994119128','-0.0629119298'),
		T_JBV(7304561,'39.9651513934','-0.2594099198'),
		T_JBV(7318640,'39.9446353892','-0.0090740768'),
		T_JBV(7304945,'39.9388601748','-0.1068152364'),
		T_JBV(7304383,'39.8567578604','-0.1581054246'),
		T_JBV(7318317,'39.5972525393','-0.5812022151'),
		T_JBV(7318316,'39.5972525393','-0.5812022151'),
		T_JBV(7318323,'39.5955236164','-0.576396282'),
		T_JBV(7318314,'39.5949871968','-0.5774872248'),
		T_JBV(7318321,'39.5949259128','-0.5779655097'),
		T_JBV(7318315,'39.5948614058','-0.576475616'),
		T_JBV(7318318,'39.5947476072','-0.5747314968'),
		T_JBV(7318320,'39.5944493731','-0.5794663298'),
		T_JBV(7318322,'39.5941214109','-0.5764107066'),
		T_JBV(7318324,'39.593622906','-0.5761971794'),
		T_JBV(7318319,'39.5877579649','-0.5745852851'),
		T_JBV(7318087,'39.5789356749','2.6727394983'),
		T_JBV(7304965,'39.4740460479','-0.4653753339'),
		T_JBV(7305244,'39.4371151688','-0.4689516919'),
		T_JBV(7304450,'39.4089519109','-0.4054441447'),
		T_JBV(7309851,'39.4064728619','-0.4139650414'),
		T_JBV(7305322,'38.9730956277','-0.1792038283'),
		T_JBV(7319191,'38.9241601452','-0.1234093188'),
		T_JBV(7316923,'38.9137559137','-6.3450120053'),
		T_JBV(7314506,'38.7600585906','-0.4574485492'),
		T_JBV(7314507,'38.7597050541','-0.4592045494'),
		T_JBV(7314504,'38.7575632429','-0.4624622861'),
		T_JBV(7320789,'38.6964530904','-0.4681367563'),
		T_JBV(7315898,'38.6780184013','-6.4072414356'),
		T_JBV(7315897,'38.6780184013','-6.4072414356'),
		T_JBV(7315896,'38.6780184013','-6.4072414356'),
		T_JBV(7315388,'38.6153733184','-0.6921910129'),
		T_JBV(7319487,'38.5091301125','-0.2314948058'),
		T_JBV(7310820,'38.1060606885','-3.7663696585'),
		T_JBV(7310819,'38.1046540943','-3.7680407487'),
		T_JBV(7305100,'37.9783065518','-1.0660776028'),
		T_JBV(7306728,'37.6975893079','-5.2810307786'),
		T_JBV(7308966,'37.4144855982','-4.4836982807'),
		T_JBV(7308195,'37.3844689978','-6.5463038578'),
		T_JBV(7308194,'37.3844689978','-6.5463038578'),
		T_JBV(7308193,'37.3844689978','-6.5463038578'),
		T_JBV(7308192,'37.3844689978','-6.5463038578'),
		T_JBV(7308191,'37.3844689978','-6.5463038578'),
		T_JBV(7308190,'37.3844689978','-6.5463038578'),
		T_JBV(7308189,'37.3844689978','-6.5463038578'),
		T_JBV(7308188,'37.3844689978','-6.5463038578'),
		T_JBV(7308187,'37.3844689978','-6.5463038578'),
		T_JBV(7308186,'37.3844689978','-6.5463038578'),
		T_JBV(7308185,'37.3844689978','-6.5463038578'),
		T_JBV(7308184,'37.3844689978','-6.5463038578'),
		T_JBV(7308183,'37.3844689978','-6.5463038578'),
		T_JBV(7308182,'37.3844689978','-6.5463038578'),
		T_JBV(7308181,'37.3844689978','-6.5463038578'),
		T_JBV(7308180,'37.3844689978','-6.5463038578'),
		T_JBV(7308179,'37.3844689978','-6.5463038578'),
		T_JBV(7308178,'37.3844689978','-6.5463038578'),
		T_JBV(7308177,'37.3844689978','-6.5463038578'),
		T_JBV(7308176,'37.3844689978','-6.5463038578'),
		T_JBV(7308175,'37.3844689978','-6.5463038578'),
		T_JBV(7308174,'37.3844689978','-6.5463038578'),
		T_JBV(7308173,'37.3844689978','-6.5463038578'),
		T_JBV(7308172,'37.3844689978','-6.5463038578'),
		T_JBV(7308170,'37.3844689978','-6.5463038578'),
		T_JBV(7308169,'37.3844689978','-6.5463038578'),
		T_JBV(7308168,'37.3844689978','-6.5463038578'),
		T_JBV(7308167,'37.3844689978','-6.5463038578'),
		T_JBV(7308166,'37.3844689978','-6.5463038578'),
		T_JBV(7308165,'37.3844689978','-6.5463038578'),
		T_JBV(7308164,'37.3844689978','-6.5463038578'),
		T_JBV(7308163,'37.3844689978','-6.5463038578'),
		T_JBV(7308162,'37.3844689978','-6.5463038578'),
		T_JBV(7308161,'37.3844689978','-6.5463038578'),
		T_JBV(7308160,'37.3844689978','-6.5463038578'),
		T_JBV(7308159,'37.3844689978','-6.5463038578'),
		T_JBV(7319070,'37.3726911341','-6.0467660671'),
		T_JBV(7319069,'37.3726911341','-6.0467660671'),
		T_JBV(7319068,'37.3726911341','-6.0467660671'),
		T_JBV(7319067,'37.3726911341','-6.0467660671'),
		T_JBV(7319066,'37.3726911341','-6.0467660671'),
		T_JBV(7319065,'37.3726911341','-6.0467660671'),
		T_JBV(7319064,'37.3726911341','-6.0467660671'),
		T_JBV(7319063,'37.3726911341','-6.0467660671'),
		T_JBV(7319062,'37.3726911341','-6.0467660671'),
		T_JBV(7319061,'37.3726911341','-6.0467660671'),
		T_JBV(7319060,'37.3726911341','-6.0467660671'),
		T_JBV(7319059,'37.3726911341','-6.0467660671'),
		T_JBV(7319058,'37.3726911341','-6.0467660671'),
		T_JBV(7319057,'37.3726911341','-6.0467660671'),
		T_JBV(7319056,'37.3726911341','-6.0467660671'),
		T_JBV(7319055,'37.3726911341','-6.0467660671'),
		T_JBV(7323369,'37.3369344658','-5.4271306369'),
		T_JBV(7311222,'37.3332893814','-5.4228157834'),
		T_JBV(7323506,'37.3081102498','-5.929546599'),
		T_JBV(7322481,'37.1662763446','-5.9370607826'),
		T_JBV(7317626,'36.9995956366','-5.6928254174'),
		T_JBV(7317628,'36.9854224889','-5.7016736038'),
		T_JBV(7317627,'36.9808084896','-5.7274743681'),
		T_JBV(7313401,'36.7518175701','-5.8090333582'),
		T_JBV(7318357,'36.6826711545','-6.1340870675'),
		T_JBV(7322643,'36.6509013102','-4.7492640647'),
		T_JBV(7319207,'36.6283139417','-6.360570661'),
		T_JBV(7308556,'36.6057638167','-6.2321215219'),
		T_JBV(7305976,'36.4798947843','-6.1968480648'),
		T_JBV(7310000,'36.469623518','-6.1974625844'),
		T_JBV(7315199,'36.4554723389','-6.2016269082'),
		T_JBV(7319033,'36.4290683568','-6.1400370687'),
		T_JBV(7323183,'36.2544635719','-5.9690482177'),
		T_JBV(7318363,'36.141904321','-5.4590418135'),
		T_JBV(7311662,'35.8882064692','-5.3301019006'),
		T_JBV(7308475,'28.5090604414','-13.8602610769'),
		T_JBV(7308474,'28.5090604414','-13.8602610769'),
		T_JBV(7308473,'28.5090604414','-13.8602610769'),
		T_JBV(7308472,'28.5090604414','-13.8602610769'),
		T_JBV(7308471,'28.5090604414','-13.8602610769'),
		T_JBV(7308470,'28.5090604414','-13.8602610769'),
		T_JBV(7308469,'28.5090604414','-13.8602610769'),
		T_JBV(7308468,'28.5090604414','-13.8602610769'),
		T_JBV(7308467,'28.5090604414','-13.8602610769'),
		T_JBV(7308466,'28.5090604414','-13.8602610769'),
		T_JBV(7308465,'28.5090604414','-13.8602610769'),
		T_JBV(7308464,'28.5090604414','-13.8602610769'),
		T_JBV(7308463,'28.5090604414','-13.8602610769'),
		T_JBV(7308462,'28.5090604414','-13.8602610769'),
		T_JBV(7308461,'28.5090604414','-13.8602610769'),
		T_JBV(7308460,'28.5090604414','-13.8602610769'),
		T_JBV(7308459,'28.5090604414','-13.8602610769'),
		T_JBV(7305450,'28.2361469335','-16.7995851171'),
		T_JBV(7306289,'42.48276888927','-2.6372948330933')

		); 
	V_TMP_JBV T_JBV;

BEGIN	
    -- LOOP Insertando 
    DBMS_OUTPUT.PUT_LINE('[INICIO] Empezando a insertar datos en la tabla');

    FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	

		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION LOC USING (
					SELECT ACT.ACT_ID
					FROM '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION AUX
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AUX.ACT_ID
					WHERE ACT.ACT_NUM_ACTIVO = '||V_TMP_JBV(1)||'
					) AUX ON (AUX.ACT_ID = LOC.ACT_ID)
					WHEN MATCHED THEN UPDATE SET
					LOC.LOC_LONGITUD = '||V_TMP_JBV(3)||',
					LOC.LOC_LATITUD = '||V_TMP_JBV(2)||',
					LOC.USUARIOMODIFICAR = ''REMVIP-8972'',
					LOC.FECHAMODIFICAR = SYSDATE';

		EXECUTE IMMEDIATE V_MSQL;
				
		DBMS_OUTPUT.PUT_LINE('[INFO] Activo actualizado correctamente. ');
		
	
    	END LOOP; 

	DBMS_OUTPUT.PUT_LINE('[FIN] Registros actualizado correctamente.');	
	
	COMMIT;

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
