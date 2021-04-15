--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9076
--## PRODUCTO=SI
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--## 		0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(4000 CHAR);
	V_SQL VARCHAR2(4000 CHAR);
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_NUM NUMBER(16); -- Vble. para validar la existencia de un registro.
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error
	V_USR VARCHAR2(30 CHAR) := 'REMVIP-9076'; -- USUARIOCREAR/USUARIOMODIFICAR.
	V_ACTIVO NUMBER(16);
	
	TYPE T_VAR IS TABLE OF VARCHAR2(100);
	TYPE T_ARRAY_VAR IS TABLE OF T_VAR; 
	V_VAR T_ARRAY_VAR := T_ARRAY_VAR(
		-- 	ACT 									
		T_VAR('6892241'),
		T_VAR('6892240'),
		T_VAR('6892239'),
		T_VAR('6893382'),
		T_VAR('6893381'),
		T_VAR('6893380'),
		T_VAR('7226096'),
		T_VAR('7226098'),
		T_VAR('7226101'),
		T_VAR('7226103'),
		T_VAR('7226105'),
		T_VAR('7226106'),
		T_VAR('7226107'),
		T_VAR('7226109'),
		T_VAR('7226110'),
		T_VAR('7226111'),
		T_VAR('7226117'),
		T_VAR('7226122'),
		T_VAR('7226123'),
		T_VAR('7226124'),
		T_VAR('7226125'),
		T_VAR('7226126'),
		T_VAR('7226127'),
		T_VAR('7226128'),
		T_VAR('7226129'),
		T_VAR('7226130'),
		T_VAR('7226133'),
		T_VAR('7226134'),
		T_VAR('7226135'),
		T_VAR('6897721'),
		T_VAR('6897740'),
		T_VAR('6897720'),
		T_VAR('6897722'),
		T_VAR('7034604'),
		T_VAR('7034955'),
		T_VAR('7035737'),
		T_VAR('7035758'),
		T_VAR('7035961'),
		T_VAR('7036138'),
		T_VAR('7036323'),
		T_VAR('7036529'),
		T_VAR('7036608'),
		T_VAR('7036646'),
		T_VAR('7037733'),
		T_VAR('7038244'),
		T_VAR('7038364'),
		T_VAR('7038734'),
		T_VAR('7039116'),
		T_VAR('7039209'),
		T_VAR('7039564'),
		T_VAR('7039627'),
		T_VAR('7039942'),
		T_VAR('7041119'),
		T_VAR('7041122'),
		T_VAR('7041123'),
		T_VAR('7041469'),
		T_VAR('7042027'),
		T_VAR('7042217'),
		T_VAR('7043089'),
		T_VAR('7043345'),
		T_VAR('7043433'),
		T_VAR('7043481'),
		T_VAR('7043576'),
		T_VAR('7043599'),
		T_VAR('7043734'),
		T_VAR('7043865'),
		T_VAR('7044153'),
		T_VAR('7044206'),
		T_VAR('7044266'),
		T_VAR('7044340'),
		T_VAR('7044740'),
		T_VAR('7044757'),
		T_VAR('7044989'),
		T_VAR('7045088'),
		T_VAR('7045199'),
		T_VAR('7045231'),
		T_VAR('7045304'),
		T_VAR('7045354'),
		T_VAR('7045412'),
		T_VAR('7045425'),
		T_VAR('7045492'),
		T_VAR('7045511'),
		T_VAR('7045523'),
		T_VAR('7045594'),
		T_VAR('7045610'),
		T_VAR('7045677'),
		T_VAR('7045888'),
		T_VAR('7046384'),
		T_VAR('7046479'),
		T_VAR('7046480'),
		T_VAR('7046505'),
		T_VAR('7046584'),
		T_VAR('7046609'),
		T_VAR('7046801'),
		T_VAR('7047083'),
		T_VAR('7047194'),
		T_VAR('7047339'),
		T_VAR('7047522'),
		T_VAR('7047585'),
		T_VAR('7047586'),
		T_VAR('7047770'),
		T_VAR('7047870'),
		T_VAR('7047904'),
		T_VAR('7048051'),
		T_VAR('7048090'),
		T_VAR('7048145'),
		T_VAR('7048553'),
		T_VAR('7049422'),
		T_VAR('7049870'),
		T_VAR('7050131'),
		T_VAR('7050710'),
		T_VAR('7050845'),
		T_VAR('7051019'),
		T_VAR('7051415'),
		T_VAR('7051995'),
		T_VAR('7055092'),
		T_VAR('7055096'),
		T_VAR('7063467'),
		T_VAR('7063497'),
		T_VAR('7063498'),
		T_VAR('7063499'),
		T_VAR('7063510'),
		T_VAR('7063511'),
		T_VAR('7063512'),
		T_VAR('7063516'),
		T_VAR('7063525'),
		T_VAR('7063527'),
		T_VAR('7063528'),
		T_VAR('7063531'),
		T_VAR('7063541'),
		T_VAR('7063542'),
		T_VAR('7063547'),
		T_VAR('7264093'),
		T_VAR('7268575'),
		T_VAR('7231066'),
		T_VAR('7231230'),
		T_VAR('7231337'),
		T_VAR('7231497'),
		T_VAR('7232084'),
		T_VAR('7232249'),
		T_VAR('7232537'),
		T_VAR('7232539'),
		T_VAR('7232697'),
		T_VAR('7232853'),
		T_VAR('7233201'),
		T_VAR('7233991'),
		T_VAR('7233992'),
		T_VAR('7234861'),
		T_VAR('7235122'),
		T_VAR('7236156'),
		T_VAR('7236779'),
		T_VAR('7236821'),
		T_VAR('7236858'),
		T_VAR('7237375'),
		T_VAR('7237742'),
		T_VAR('7237830'),
		T_VAR('7237884'),
		T_VAR('7237886'),
		T_VAR('7238246'),
		T_VAR('7283859'),
		T_VAR('7238691'),
		T_VAR('7238692'),
		T_VAR('7238781'),
		T_VAR('7238837'),
		T_VAR('7239732'),
		T_VAR('7240507'),
		T_VAR('7241095'),
		T_VAR('7241109'),
		T_VAR('7241417'),
		T_VAR('7241523'),
		T_VAR('7241723'),
		T_VAR('7241724'),
		T_VAR('7241725'),
		T_VAR('7241726'),
		T_VAR('7241728'),
		T_VAR('7241729'),
		T_VAR('7242501'),
		T_VAR('7243261'),
		T_VAR('7243289'),
		T_VAR('7243290'),
		T_VAR('7243629'),
		T_VAR('7243630'),
		T_VAR('7243647'),
		T_VAR('7243664'),
		T_VAR('7243665'),
		T_VAR('7243666'),
		T_VAR('7243667'),
		T_VAR('7243668'),
		T_VAR('7243998'),
		T_VAR('7244002'),
		T_VAR('7244004'),
		T_VAR('7244216'),
		T_VAR('7245361'),
		T_VAR('7246310'),
		T_VAR('7246351'),
		T_VAR('7246960'),
		T_VAR('7246961'),
		T_VAR('7246962'),
		T_VAR('7246963'),
		T_VAR('7246964'),
		T_VAR('7246965'),
		T_VAR('7246966'),
		T_VAR('7246967'),
		T_VAR('7246968'),
		T_VAR('7246969'),
		T_VAR('7246970'),
		T_VAR('7246971'),
		T_VAR('7246972'),
		T_VAR('7246973'),
		T_VAR('7246974'),
		T_VAR('7246975'),
		T_VAR('7246976'),
		T_VAR('7246977'),
		T_VAR('7246978'),
		T_VAR('7247236'),
		T_VAR('7247825'),
		T_VAR('7248019'),
		T_VAR('7248187'),
		T_VAR('7248622'),
		T_VAR('7248928'),
		T_VAR('7249428'),
		T_VAR('7249490'),
		T_VAR('7252787'),
		T_VAR('7262004'),
		T_VAR('7262006'),
		T_VAR('7262008'),
		T_VAR('7262011'),
		T_VAR('7262019'),
		T_VAR('7262021'),
		T_VAR('7262022'),
		T_VAR('7262024'),
		T_VAR('7262027'),
		T_VAR('7262028'),
		T_VAR('7262029'),
		T_VAR('7262453'),
		T_VAR('7262827'),
		T_VAR('7271052'),
		T_VAR('7271668'),
		T_VAR('7271955'),
		T_VAR('7271968'),
		T_VAR('7272658'),
		T_VAR('7272673'),
		T_VAR('7272674'),
		T_VAR('7272675'),
		T_VAR('7272676'),
		T_VAR('7272677'),
		T_VAR('7272678'),
		T_VAR('7272679'),
		T_VAR('7272680'),
		T_VAR('7272681'),
		T_VAR('7272682'),
		T_VAR('7273015'),
		T_VAR('7273016'),
		T_VAR('7273017'),
		T_VAR('7273018'),
		T_VAR('7273513'),
		T_VAR('7273514'),
		T_VAR('7273515'),
		T_VAR('7273516'),
		T_VAR('7273840'),
		T_VAR('7273841'),
		T_VAR('7273842'),
		T_VAR('7273843'),
		T_VAR('7273844'),
		T_VAR('7273845'),
		T_VAR('7273846'),
		T_VAR('7273847'),
		T_VAR('7273922'),
		T_VAR('7273929'),
		T_VAR('7273930'),
		T_VAR('7273931'),
		T_VAR('7273934'),
		T_VAR('7276910')


	); 
	V_TMP_VAR T_VAR;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	DBMS_OUTPUT.PUT_LINE('---------------------------------------');

	FOR I IN V_VAR.FIRST .. V_VAR.LAST LOOP
		V_TMP_VAR := V_VAR(I);
		
		V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_VAR(1)||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
		
		IF V_NUM = 1 THEN

			V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_VAR(1)||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_ACTIVO;
			
			EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL SET
					ICO_MEDIADOR_ID = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = 1116),
					USUARIOMODIFICAR = '''||V_USR||''',
					FECHAMODIFICAR = SYSDATE
					WHERE ACT_ID = '||V_ACTIVO||'';
			
			DBMS_OUTPUT.PUT_LINE('	[INFO] Proveedor cambiado para '||V_TMP_VAR(1)||' ');
		ELSE

			DBMS_OUTPUT.PUT_LINE('	[INFO] No existe el activo '||V_TMP_VAR(1)||'');

		END IF;

	END LOOP;		

	DBMS_OUTPUT.PUT_LINE('[FIN].');

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
