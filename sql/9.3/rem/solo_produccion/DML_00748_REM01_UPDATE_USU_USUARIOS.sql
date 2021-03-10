--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210310
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9177
--## PRODUCTO=NO
--##
--## Finalidad: Script para modificar email de usuarios
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'USU_USUARIOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9177'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_USU_ID NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		-- 			USU_USERNAME  USU_MAIL
		T_TIPO_DATA('buk.bvilarrasa','buk.bvilarrasa@externos.haya.es'),
		T_TIPO_DATA('buk.itrujillo','buk.itrujillo@externos.haya.es'),
		T_TIPO_DATA('buk.mgomezp','buk.mgomezp@externos.haya.es'),
		T_TIPO_DATA('buk.aperez','buk.aperez@externos.haya.es'),
		T_TIPO_DATA('buk.clisea','buk.clisea@externos.haya.es'),
		T_TIPO_DATA('buk.agonzalez','buk.agonzalez@externos.haya.es'),
		T_TIPO_DATA('buk.vmartindelgado','buk.vmartindelgado@externos.haya.es'),
		T_TIPO_DATA('buk.mfilereto','buk.mfilereto@externos.haya.es'),
		T_TIPO_DATA('buk.mmartin','buk.mmartin@externos.haya.es'),
		T_TIPO_DATA('ext.jroldan','ext.jroldan@externos.haya.es'),
		T_TIPO_DATA('ext.mgaldeano','ext.mgaldeano@externos.haya.es'),
		T_TIPO_DATA('ext.aromero','ext.aromero@externos.haya.es'),
		T_TIPO_DATA('ext.isaftic','ext.isaftic@externos.haya.es'),
		T_TIPO_DATA('ext.mvalverde','ext.mvalverde@externos.haya.es'),
		T_TIPO_DATA('ext.lmartinc','ext.lmartinc@externos.haya.es'),
		T_TIPO_DATA('ext.ldanes','ext.ldanes@externos.haya.es'),
		T_TIPO_DATA('ext.rmerchan','ext.rmerchan@externos.haya.es'),
		T_TIPO_DATA('ext.rflox','ext.rflox@externos.haya.es'),
		T_TIPO_DATA('ext.sbravo','ext.sbravo@externos.haya.es'),
		T_TIPO_DATA('ext.cfreire','ext.cfreire@externos.haya.es'),
		T_TIPO_DATA('ext.fgavira','ext.fgavira@externos.haya.es'),
		T_TIPO_DATA('ext.sramirezfr','ext.sramirezfr@externos.haya.es'),
		T_TIPO_DATA('ext.cblanco','ext.cblanco@externos.haya.es'),
		T_TIPO_DATA('ext.lvarela','ext.lvarela@externos.haya.es'),
		T_TIPO_DATA('ext.mpalmero','ext.mpalmero@externos.haya.es'),
		T_TIPO_DATA('ext.ireyes','ext.ireyes@externos.haya.es'),
		T_TIPO_DATA('ext.mgarciamo','ext.mgarciamo@externos.haya.es'),
		T_TIPO_DATA('ext.pnievaq','ext.pnievaq@externos.haya.es'),
		T_TIPO_DATA('ext.bllinasp','ext.bllinasp@externos.haya.es'),
		T_TIPO_DATA('ext.tnadales','ext.tnadales@externos.haya.es'),
		T_TIPO_DATA('ext.jdelaf','ext.jdelaf@externos.haya.es'),
		T_TIPO_DATA('ext.ccarmona','ext.ccarmona@externos.haya.es'),
		T_TIPO_DATA('ext.mmurillo','ext.mmurillo@externos.haya.es'),
		T_TIPO_DATA('ext.jvilchez','ext.jvilchez@externos.haya.es'),
		T_TIPO_DATA('ext.arodriguezgi','ext.arodriguezgi@externos.haya.es'),
		T_TIPO_DATA('ext.eorellanov','ext.eorellanov@externos.haya.es'),
		T_TIPO_DATA('ext.sgallego','ext.sgallego@externos.haya.es'),
		T_TIPO_DATA('ext.apuigt','ext.apuigt@externos.haya.es'),
		T_TIPO_DATA('smontes','smontes@haya.es'),
		T_TIPO_DATA('vhernandez','vhernandez@haya.es'),
		T_TIPO_DATA('egalan','egalan@haya.es'),
		T_TIPO_DATA('farbas','farbas@bankia.com'),
		T_TIPO_DATA('jcalatayud','jcalatayud@bancaja.es'),
		T_TIPO_DATA('jmatencias','jmatencias@haya.es'),
		T_TIPO_DATA('lgonzaleze','lgonzaleze@haya.es'),
		T_TIPO_DATA('marenas','marenas@haya.es'),
		T_TIPO_DATA('pcasares','pcasares@haya.es'),
		T_TIPO_DATA('rgomez','rgomez@bancajahabitat.es'),
		T_TIPO_DATA('mponced','mponced@haya.es'),
		T_TIPO_DATA('rcanales','rcanales@haya.es'),
		T_TIPO_DATA('mmartinez','mmartinez@bankiahabitat.es'),
		T_TIPO_DATA('mesteban','mesteban@haya.es'),
		T_TIPO_DATA('evillarejo','evillarejo@haya.es'),
		T_TIPO_DATA('lmartinc','lmartinc@haya.es'),
		T_TIPO_DATA('gjimenezs','gjimenezs@haya.es'),
		T_TIPO_DATA('mescribano','mescribano@haya.es'),
		T_TIPO_DATA('avila','avila@haya.es'),
		T_TIPO_DATA('csanchezd','csanchezd@haya.es'),
		T_TIPO_DATA('ecalcerrada','ecalcerrada@haya.es'),
		T_TIPO_DATA('mripoll','mripoll@haya.es'),
		T_TIPO_DATA('psanchez','psanchez@haya.es'),
		T_TIPO_DATA('jvallejo','jvallejo@haya.es'),
		T_TIPO_DATA('lcarrillo','lcarrillo@haya.es'),
		T_TIPO_DATA('prodriguezg','prodriguezg@haya.es'),
		T_TIPO_DATA('lmarcos','lmarcos@haya.es'),
		T_TIPO_DATA('jromeros','jromeros@haya.es'),
		T_TIPO_DATA('tdiez','tdiez@haya.es'),
		T_TIPO_DATA('ddelcura','ddelcura@haya.es'),
		T_TIPO_DATA('alorenzob','alorenzob@haya.es'),
		T_TIPO_DATA('pdominguez','pdominguez@haya.es'),
		T_TIPO_DATA('ssalazar','ssalazar@haya.es'),
		T_TIPO_DATA('raguirrebengoa','raguirrebengoa@haya.es'),
		T_TIPO_DATA('mdiaz','mdiaz@bancaja.es'),
		T_TIPO_DATA('dpalomares','dpalomares@haya.es'),
		T_TIPO_DATA('ebretones','ebretones@externos.haya.es'),
		T_TIPO_DATA('jcalvo','jcalvo@haya.es'),
		T_TIPO_DATA('amartin','amartin@bankia.com'),
		T_TIPO_DATA('egomez','egomez@haya.es'),
		T_TIPO_DATA('cmartinezc','cmartinezc@haya.es'),
		T_TIPO_DATA('csanchezbu','csanchezbu@haya.es'),
		T_TIPO_DATA('tgarciag','tgarciag@haya.es'),
		T_TIPO_DATA('shormaeche','shormaeche@haya.es'),
		T_TIPO_DATA('pdiez','pdiez@haya.es'),
		T_TIPO_DATA('alopezf','alopezf@haya.es'),
		T_TIPO_DATA('afernandezs','afernandezs@haya.es'),
		T_TIPO_DATA('lscheffer','lscheffer@haya.es'),
		T_TIPO_DATA('lborgonovo','lborgonovo@haya.es'),
		T_TIPO_DATA('mmunozc','mmunozc@haya.es'),
		T_TIPO_DATA('nrivilla','nrivilla@haya.es'),
		T_TIPO_DATA('scalzado','scalzado@haya.es'),
		T_TIPO_DATA('sfernandezg','sfernandezg@haya.es'),
		T_TIPO_DATA('fgomez','fgomez@haya.es'),
		T_TIPO_DATA('ebertrandelis','ebertrandelis@haya.es'),
		T_TIPO_DATA('ogonzalez','ogonzalez@haya.es'),
		T_TIPO_DATA('smerayo','smerayo@haya.es'),
		T_TIPO_DATA('cmartinc','cmartinc@haya.es'),
		T_TIPO_DATA('imartinr','imartinr@haya.es'),
		T_TIPO_DATA('drodriguezs','drodriguezs@haya.es'),
		T_TIPO_DATA('esantorcuato','esantorcuato@haya.es'),
		T_TIPO_DATA('vcastillo','vcastillo@haya.es'),
		T_TIPO_DATA('rpuentes','rpuentes@haya.es'),
		T_TIPO_DATA('jmonterrubio','jmonterrubio@haya.es'),
		T_TIPO_DATA('cdiazplaza','cdiazplaza@haya.es'),
		T_TIPO_DATA('vmartinez','vmartinez@haya.es'),
		T_TIPO_DATA('taquino','taquino@externos.haya.es'),
		T_TIPO_DATA('mpedrera','mpedrera@haya.es'),
		T_TIPO_DATA('jtellov','jtellov@haya.es'),
		T_TIPO_DATA('sprada','sprada@haya.es'),
		T_TIPO_DATA('adelaiglesia','adelaiglesia@haya.es'),
		T_TIPO_DATA('elorente','elorente@haya.es'),
		T_TIPO_DATA('amorenoj','amorenoj@haya.es'),
		T_TIPO_DATA('gbc.afuentesm','afuentesm@grupobc.com'),
		T_TIPO_DATA('gbc.esantiagoi','esantiagoi@grupobc.com'),
		T_TIPO_DATA('gbc.chmartinm','chmartinm@grupobc.com'),
		T_TIPO_DATA('eblanco','eblanco@haya.es'),
		T_TIPO_DATA('ext.mbanon','maria.banon@bpo.es'),
		T_TIPO_DATA('slabarga','slabarga@haya.es'),
		T_TIPO_DATA('fboix','fboix@externos.haya.es'),
		T_TIPO_DATA('ext.imartindelosrios','ext.imartindelosrios@externos.haya.es'),
		T_TIPO_DATA('ext.tbernatene','tomas.bernatene.contractor@divarian.com'),
		T_TIPO_DATA('tgualix','tgualix@haya.es'),
		T_TIPO_DATA('jramirezg','jramirezg@haya.es'),
		T_TIPO_DATA('sdavila','sdavila@haya.es'),
		T_TIPO_DATA('ext.balonso','beatriz.alonso@divarian.com'),
		T_TIPO_DATA('ext.storio','storio@minsait.com'),
		T_TIPO_DATA('ext.tdiarte','ext.tdiarte@externos.haya.es'),
		T_TIPO_DATA('ofernandez','ofernandez@haya.es'),
		T_TIPO_DATA('ext.acampos','ext.acampos@externos.haya.es'),
		T_TIPO_DATA('ext.jhurtado','ext.jhurtado@externos.haya.es')

	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' WHERE USU_USERNAME = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT = 1 THEN

			V_MSQL:= 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' WHERE USU_USERNAME = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_USU_ID;

			V_MSQL:= 'UPDATE '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' SET
						USU_MAIL = '''||V_TMP_TIPO_DATA(2)||''',
						USUARIOMODIFICAR = '''||V_USU||''',
						FECHAMODIFICAR = SYSDATE
						WHERE USU_ID = '||V_USU_ID||' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL EMAIL DEL USUARIO = '||V_TMP_TIPO_DATA(1)||' A '||V_TMP_TIPO_DATA(2)||'');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: USUARIO '||V_TMP_TIPO_DATA(1)||' NO EXISTE O ESTA BORRADO');

		END IF;

	END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');


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