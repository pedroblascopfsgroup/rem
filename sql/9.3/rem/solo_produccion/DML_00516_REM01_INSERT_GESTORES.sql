--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6536
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir al usuario scapellan como Gestor de Formalización de todos los activos de la subcartera OMEGA
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    -- Esquemas 
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    -- Errores
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    -- Usuario
    V_USU VARCHAR2(50 CHAR) := 'REMVIP_6536';
    -- IDs
    V_GEE_ID NUMBER(16); -- Vble. para el id gestor identidad
	V_ACT_ID NUMBER(16); -- Vble. para el id de activo
	V_GEH_ID NUMBER(16); -- Vble. para el id gestor identidad hist
	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		T_TIPO_DATA('7226181'),
            T_TIPO_DATA('7226183'),
            T_TIPO_DATA('7226184'),
            T_TIPO_DATA('7226185'),
            T_TIPO_DATA('7226186'),
            T_TIPO_DATA('7226187'),
            T_TIPO_DATA('7226188'),
            T_TIPO_DATA('7226189'),
            T_TIPO_DATA('7226190'),
            T_TIPO_DATA('7226191'),
            T_TIPO_DATA('7226192'),
            T_TIPO_DATA('7226193'),
            T_TIPO_DATA('7226194'),
            T_TIPO_DATA('7226197'),
            T_TIPO_DATA('7226198'),
            T_TIPO_DATA('7226200'),
            T_TIPO_DATA('7226201'),
            T_TIPO_DATA('7226203'),
            T_TIPO_DATA('7226206'),
            T_TIPO_DATA('7226207'),
            T_TIPO_DATA('7226208'),
            T_TIPO_DATA('7226209'),
            T_TIPO_DATA('7226210'),
            T_TIPO_DATA('7226211'),
            T_TIPO_DATA('7226213'),
            T_TIPO_DATA('7226214'),
            T_TIPO_DATA('7226215'),
            T_TIPO_DATA('7226216'),
            T_TIPO_DATA('7226217'),
            T_TIPO_DATA('7226220'),
            T_TIPO_DATA('7226221'),
            T_TIPO_DATA('7226222'),
            T_TIPO_DATA('7226223'),
            T_TIPO_DATA('7226224'),
            T_TIPO_DATA('7226225'),
            T_TIPO_DATA('7226226'),
            T_TIPO_DATA('7226227'),
            T_TIPO_DATA('7226229'),
            T_TIPO_DATA('7226230'),
            T_TIPO_DATA('7226231'),
            T_TIPO_DATA('7226232'),
            T_TIPO_DATA('7226233'),
            T_TIPO_DATA('7226234'),
            T_TIPO_DATA('7226235'),
            T_TIPO_DATA('7226236'),
            T_TIPO_DATA('7226237'),
            T_TIPO_DATA('7226238'),
            T_TIPO_DATA('7226239'),
            T_TIPO_DATA('7226240'),
            T_TIPO_DATA('7226241'),
            T_TIPO_DATA('7226243'),
            T_TIPO_DATA('7226245'),
            T_TIPO_DATA('7226246'),
            T_TIPO_DATA('7226247'),
            T_TIPO_DATA('7226251'),
            T_TIPO_DATA('7226252'),
            T_TIPO_DATA('7226253'),
            T_TIPO_DATA('7226254'),
            T_TIPO_DATA('7226255'),
            T_TIPO_DATA('7226256'),
            T_TIPO_DATA('7226257'),
            T_TIPO_DATA('7226258'),
            T_TIPO_DATA('7226259'),
            T_TIPO_DATA('7226260'),
            T_TIPO_DATA('7226262'),
            T_TIPO_DATA('7226266'),
            T_TIPO_DATA('7226267'),
            T_TIPO_DATA('7226269'),
            T_TIPO_DATA('7226270'),
            T_TIPO_DATA('7226271'),
            T_TIPO_DATA('7226272'),
            T_TIPO_DATA('7226273'),
            T_TIPO_DATA('7226274'),
            T_TIPO_DATA('7226275'),
            T_TIPO_DATA('7226277'),
            T_TIPO_DATA('7226278'),
            T_TIPO_DATA('7226279'),
            T_TIPO_DATA('7226280'),
            T_TIPO_DATA('7226281'),
            T_TIPO_DATA('7226283'),
            T_TIPO_DATA('7226284'),
            T_TIPO_DATA('7226285'),
            T_TIPO_DATA('7226289'),
            T_TIPO_DATA('7226290'),
            T_TIPO_DATA('7226291'),
            T_TIPO_DATA('7226292'),
            T_TIPO_DATA('7226293'),
            T_TIPO_DATA('7226294'),
            T_TIPO_DATA('7226296'),
            T_TIPO_DATA('7226299'),
            T_TIPO_DATA('7226300'),
            T_TIPO_DATA('7226302'),
            T_TIPO_DATA('7226304'),
            T_TIPO_DATA('7226306'),
            T_TIPO_DATA('7226307'),
            T_TIPO_DATA('7226308'),
            T_TIPO_DATA('7226309'),
            T_TIPO_DATA('7226310'),
            T_TIPO_DATA('7226311'),
            T_TIPO_DATA('7226312'),
            T_TIPO_DATA('7226313'),
            T_TIPO_DATA('7226314'),
            T_TIPO_DATA('7226315'),
            T_TIPO_DATA('7226316'),
            T_TIPO_DATA('7226317'),
            T_TIPO_DATA('7226318'),
            T_TIPO_DATA('7226319'),
            T_TIPO_DATA('7226320'),
            T_TIPO_DATA('7226321'),
            T_TIPO_DATA('7226322'),
            T_TIPO_DATA('7226323'),
            T_TIPO_DATA('7226324'),
            T_TIPO_DATA('7226325'),
            T_TIPO_DATA('7226326'),
            T_TIPO_DATA('7226327'),
            T_TIPO_DATA('7226328'),
            T_TIPO_DATA('7226329'),
            T_TIPO_DATA('7226330'),
            T_TIPO_DATA('7226331'),
            T_TIPO_DATA('7226332'),
            T_TIPO_DATA('7226333'),
            T_TIPO_DATA('7226334'),
            T_TIPO_DATA('7226335'),
            T_TIPO_DATA('7226337'),
            T_TIPO_DATA('7226338'),
            T_TIPO_DATA('7226339'),
            T_TIPO_DATA('7226340'),
            T_TIPO_DATA('7226341'),
            T_TIPO_DATA('7226342'),
            T_TIPO_DATA('7226343'),
            T_TIPO_DATA('7226344'),
            T_TIPO_DATA('7226345'),
            T_TIPO_DATA('7226346'),
            T_TIPO_DATA('7226347'),
            T_TIPO_DATA('7226348'),
            T_TIPO_DATA('7226349'),
            T_TIPO_DATA('7226350'),
            T_TIPO_DATA('7226351'),
            T_TIPO_DATA('7226352'),
            T_TIPO_DATA('7226354'),
            T_TIPO_DATA('7226355'),
            T_TIPO_DATA('7226356'),
            T_TIPO_DATA('7226357'),
            T_TIPO_DATA('7226358'),
            T_TIPO_DATA('7226360'),
            T_TIPO_DATA('7226361'),
            T_TIPO_DATA('7226362'),
            T_TIPO_DATA('7226363'),
            T_TIPO_DATA('7226364'),
            T_TIPO_DATA('7226365'),
            T_TIPO_DATA('7226366'),
            T_TIPO_DATA('7226367'),
            T_TIPO_DATA('7226368'),
            T_TIPO_DATA('7226369'),
            T_TIPO_DATA('7226370'),
            T_TIPO_DATA('7226371'),
            T_TIPO_DATA('7226372'),
            T_TIPO_DATA('7226373'),
            T_TIPO_DATA('7226374'),
            T_TIPO_DATA('7226375'),
            T_TIPO_DATA('7226376'),
            T_TIPO_DATA('7226377'),
            T_TIPO_DATA('7226378'),
            T_TIPO_DATA('7226380'),
            T_TIPO_DATA('7226381'),
            T_TIPO_DATA('7226382'),
            T_TIPO_DATA('7226383'),
            T_TIPO_DATA('7226384'),
            T_TIPO_DATA('7226385'),
            T_TIPO_DATA('7226386'),
            T_TIPO_DATA('7226387'),
            T_TIPO_DATA('7226388'),
            T_TIPO_DATA('7226389'),
            T_TIPO_DATA('7226390'),
            T_TIPO_DATA('7226391'),
            T_TIPO_DATA('7226392'),
            T_TIPO_DATA('7226393'),
            T_TIPO_DATA('7226394'),
            T_TIPO_DATA('7226395'),
            T_TIPO_DATA('7226396'),
            T_TIPO_DATA('7226397'),
            T_TIPO_DATA('7226398'),
            T_TIPO_DATA('7226399'),
            T_TIPO_DATA('7226400'),
            T_TIPO_DATA('7226401'),
            T_TIPO_DATA('7226402'),
            T_TIPO_DATA('7226403'),
            T_TIPO_DATA('7226404'),
            T_TIPO_DATA('7226405'),
            T_TIPO_DATA('7226406'),
            T_TIPO_DATA('7226407'),
            T_TIPO_DATA('7226408'),
            T_TIPO_DATA('7226409'),
            T_TIPO_DATA('7226410'),
            T_TIPO_DATA('7226412'),
            T_TIPO_DATA('7226413'),
            T_TIPO_DATA('7226414'),
            T_TIPO_DATA('7226415'),
            T_TIPO_DATA('7226416'),
            T_TIPO_DATA('7226417'),
            T_TIPO_DATA('7226418'),
            T_TIPO_DATA('7226419'),
            T_TIPO_DATA('7226420'),
            T_TIPO_DATA('7226421'),
            T_TIPO_DATA('7226422'),
            T_TIPO_DATA('7226423'),
            T_TIPO_DATA('7226424'),
            T_TIPO_DATA('7226425'),
            T_TIPO_DATA('7226426'),
            T_TIPO_DATA('7226427'),
            T_TIPO_DATA('7226428'),
            T_TIPO_DATA('7226429'),
            T_TIPO_DATA('7226430'),
            T_TIPO_DATA('7226431'),
            T_TIPO_DATA('7226432'),
            T_TIPO_DATA('7226433'),
            T_TIPO_DATA('7226434'),
            T_TIPO_DATA('7226435'),
            T_TIPO_DATA('7226436'),
            T_TIPO_DATA('7226437'),
            T_TIPO_DATA('7226438'),
            T_TIPO_DATA('7226439'),
            T_TIPO_DATA('7226440'),
            T_TIPO_DATA('7226441'),
            T_TIPO_DATA('7226442'),
            T_TIPO_DATA('7226443'),
            T_TIPO_DATA('7226444'),
            T_TIPO_DATA('7226445'),
            T_TIPO_DATA('7226446'),
            T_TIPO_DATA('7226447'),
            T_TIPO_DATA('7226448'),
            T_TIPO_DATA('7226449'),
            T_TIPO_DATA('7226450'),
            T_TIPO_DATA('7226451'),
            T_TIPO_DATA('7226452'),
            T_TIPO_DATA('7226453'),
            T_TIPO_DATA('7226454'),
            T_TIPO_DATA('7226455'),
            T_TIPO_DATA('7226456'),
            T_TIPO_DATA('7226851'),
            T_TIPO_DATA('7226297'),
            T_TIPO_DATA('7226180'),
            T_TIPO_DATA('7226182'),
            T_TIPO_DATA('7226195'),
            T_TIPO_DATA('7226196'),
            T_TIPO_DATA('7226199'),
            T_TIPO_DATA('7226202'),
            T_TIPO_DATA('7226204'),
            T_TIPO_DATA('7226205'),
            T_TIPO_DATA('7226212'),
            T_TIPO_DATA('7226218'),
            T_TIPO_DATA('7226219'),
            T_TIPO_DATA('7226228'),
            T_TIPO_DATA('7226244'),
            T_TIPO_DATA('7226249'),
            T_TIPO_DATA('7226250'),
            T_TIPO_DATA('7226261'),
            T_TIPO_DATA('7226263'),
            T_TIPO_DATA('7226264'),
            T_TIPO_DATA('7226265'),
            T_TIPO_DATA('7226268'),
            T_TIPO_DATA('7226282'),
            T_TIPO_DATA('7226286'),
            T_TIPO_DATA('7226287'),
            T_TIPO_DATA('7226288'),
            T_TIPO_DATA('7226295'),
            T_TIPO_DATA('7226298'),
            T_TIPO_DATA('7226303'),
            T_TIPO_DATA('7226305'),
            T_TIPO_DATA('7226379'),
            T_TIPO_DATA('7226411'),
            T_TIPO_DATA('7226276'),
            T_TIPO_DATA('7226301'),
            T_TIPO_DATA('7226336'),
            T_TIPO_DATA('7226353'),
            T_TIPO_DATA('7226359'),
            T_TIPO_DATA('7226248'),
            T_TIPO_DATA('7228150'),
            T_TIPO_DATA('7294138'),
            T_TIPO_DATA('7293960'),
            T_TIPO_DATA('7294185'),
            T_TIPO_DATA('7294186'),
            T_TIPO_DATA('7294456'),
            T_TIPO_DATA('7294565'),
            T_TIPO_DATA('7294809'),
            T_TIPO_DATA('7294807'),
            T_TIPO_DATA('7294566'),
            T_TIPO_DATA('7294567'),
            T_TIPO_DATA('7294808'),
            T_TIPO_DATA('7294811'),
            T_TIPO_DATA('7294806'),
            T_TIPO_DATA('7295482'),
            T_TIPO_DATA('7295092'),
            T_TIPO_DATA('7295492'),
            T_TIPO_DATA('7295493'),
            T_TIPO_DATA('7301109'),
            T_TIPO_DATA('7301112'),
            T_TIPO_DATA('7301106'),
            T_TIPO_DATA('7301110'),
            T_TIPO_DATA('7301111'),
            T_TIPO_DATA('7295091'),
            T_TIPO_DATA('7301114'),
            T_TIPO_DATA('7301100'),
            T_TIPO_DATA('7301102'),
            T_TIPO_DATA('7301105'),
            T_TIPO_DATA('7301099'),
            T_TIPO_DATA('7301104'),
            T_TIPO_DATA('7301098'),
            T_TIPO_DATA('7301115'),
            T_TIPO_DATA('7295484'),
            T_TIPO_DATA('7301101'),
            T_TIPO_DATA('7301113'),
            T_TIPO_DATA('7301107'),
            T_TIPO_DATA('7294810'),
            T_TIPO_DATA('7295483'),
            T_TIPO_DATA('7301103'),
            T_TIPO_DATA('7301994'),
            T_TIPO_DATA('7302186'),
            T_TIPO_DATA('7302187'),
            T_TIPO_DATA('7297771'),
            T_TIPO_DATA('7297772'),
            T_TIPO_DATA('7295485'),
            T_TIPO_DATA('7297773'),
            T_TIPO_DATA('7295494'),
            T_TIPO_DATA('7301108'),
            T_TIPO_DATA('7302694'),
            T_TIPO_DATA('7295495'),
            T_TIPO_DATA('7385566'),
            T_TIPO_DATA('7302695'),
            T_TIPO_DATA('7302692')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR SUPERVISOR DE FORMALIZACIÓN DE ACTIVOS DE OMEGA A SCAPELLAN');

	--Comprobamos la existencia del usuario scapellan
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''scapellan''';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

	IF V_COUNT = 1 THEN

		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	      	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

            --Comprobamos la existencia del activo
			V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;			

			IF V_COUNT = 1 THEN

                --Obtenemos act_id, gee_id y geh_id
                V_MSQL := 'SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                    INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
                    INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SFORM'') AND GEE.BORRADO = 0
                    INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
                    INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GAH.GEH_ID AND GEH.DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SFORM'') AND GEH.GEH_FECHA_HASTA IS NULL AND GEH.BORRADO = 0
                    INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON GEE.USU_ID = USU.USU_ID
                    WHERE ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;
                V_MSQL := 'SELECT GEE.GEE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                    INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
                    INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SFORM'') AND GEE.BORRADO = 0
                    INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
                    INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GAH.GEH_ID AND GEH.DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SFORM'') AND GEH.GEH_FECHA_HASTA IS NULL AND GEH.BORRADO = 0
                    INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON GEE.USU_ID = USU.USU_ID
                    WHERE ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_GEE_ID;
                V_MSQL := 'SELECT GEH.GEH_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                    INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
                    INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SFORM'') AND GEE.BORRADO = 0
                    INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
                    INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GAH.GEH_ID AND GEH.DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SFORM'') AND GEH.GEH_FECHA_HASTA IS NULL AND GEH.BORRADO = 0
                    INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON GEE.USU_ID = USU.USU_ID
                    WHERE ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_GEH_ID;
					
				--ACTUALIZAMOS REGISTROS EN LA GEE
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD SET 
					USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''scapellan''),
					USUARIOMODIFICAR = '''||V_USU||''',
					FECHAMODIFICAR = SYSDATE
					WHERE GEE_ID = '''||V_GEE_ID||'''';
				
				EXECUTE IMMEDIATE V_MSQL;
			
				--Actualizamos la fecha fin del gestor antiguo en GEH
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST SET
					GEH_FECHA_HASTA = TO_DATE(SYSDATE, ''DD/MM/YY''),
					USUARIOMODIFICAR = '''||V_USU||''', 
					FECHAMODIFICAR = SYSDATE 
					WHERE GEH_ID = '''||V_GEH_ID||'''';
				
				EXECUTE IMMEDIATE V_MSQL;
				
				--Obtenemos el id de gestor entidad hist > GEH_ID
				V_MSQL := 'SELECT '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.nextval FROM dual';
				EXECUTE IMMEDIATE V_MSQL INTO V_GEH_ID;	
					
				--INSERTAMOS EN LA GEH
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST
					(GEH_ID,USU_ID,DD_TGE_ID,GEH_FECHA_DESDE,USUARIOCREAR,FECHACREAR) VALUES (
					'||V_GEH_ID||', (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''scapellan''),
					(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SFORM''), SYSDATE,
					'''||V_USU||''', SYSDATE)';
				
				EXECUTE IMMEDIATE V_MSQL;
					
				--INSERTAMOS EN LA GAH
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO
					(GEH_ID, ACT_ID) VALUES ('||V_GEH_ID||', '||V_ACT_ID||')';
				
				EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO] ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO CON ÉXITO');
					
			ELSE 

				DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO '''||V_TMP_TIPO_DATA(1)||'''');

			END IF;

		END LOOP;

	ELSE 

		DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL USUARIO ''scapellan''');

	END IF;

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
EXIT;