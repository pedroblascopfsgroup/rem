--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210224
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9050
--## PRODUCTO=NO
--##
--## Finalidad: Script realiza una carga masiva de fases
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
    V_NUM NUMBER(16); -- Vble. auxiliar para almacenar el número de registros
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_HFP_HIST_FASES_PUB'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9050'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_ACT_ID NUMBER(16);
	V_USU_ID NUMBER(16);
	V_COUNT NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1024);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --	ACTIVO | FASE | SUBFASE | COMENTARIO
		T_TIPO_DATA('6857254','09','14','WIP'),
		T_TIPO_DATA('6857256','09','14','WIP'),
		T_TIPO_DATA('6857297','09','14','WIP'),
		T_TIPO_DATA('7072984','09','14','WIP'),
		T_TIPO_DATA('7072993','09','14','WIP'),
		T_TIPO_DATA('7072999','09','14','WIP'),
		T_TIPO_DATA('7073006','09','14','WIP'),
		T_TIPO_DATA('7073007','09','14','WIP'),
		T_TIPO_DATA('7073008','09','14','WIP'),
		T_TIPO_DATA('7073010','09','14','WIP'),
		T_TIPO_DATA('7073011','09','14','WIP'),
		T_TIPO_DATA('7073013','09','14','WIP'),
		T_TIPO_DATA('7073014','09','14','WIP'),
		T_TIPO_DATA('7073015','09','14','WIP'),
		T_TIPO_DATA('7073018','09','14','WIP'),
		T_TIPO_DATA('7073019','09','14','WIP'),
		T_TIPO_DATA('7073020','09','14','WIP'),
		T_TIPO_DATA('7073022','09','14','WIP'),
		T_TIPO_DATA('7073024','09','14','WIP'),
		T_TIPO_DATA('7073025','09','14','WIP'),
		T_TIPO_DATA('7073026','09','14','WIP'),
		T_TIPO_DATA('7073029','09','14','WIP'),
		T_TIPO_DATA('7073030','09','14','WIP'),
		T_TIPO_DATA('7073031','09','14','WIP'),
		T_TIPO_DATA('7073032','09','14','WIP'),
		T_TIPO_DATA('7073034','09','14','WIP'),
		T_TIPO_DATA('7073036','09','14','WIP'),
		T_TIPO_DATA('7073038','09','14','WIP'),
		T_TIPO_DATA('7073039','09','14','WIP'),
		T_TIPO_DATA('7073042','09','14','WIP'),
		T_TIPO_DATA('7073043','09','14','WIP'),
		T_TIPO_DATA('7073045','09','14','WIP'),
		T_TIPO_DATA('7073046','09','14','WIP'),
		T_TIPO_DATA('7073048','09','14','WIP'),
		T_TIPO_DATA('7073049','09','14','WIP'),
		T_TIPO_DATA('7073052','09','14','WIP'),
		T_TIPO_DATA('7073056','09','14','WIP'),
		T_TIPO_DATA('7073057','09','14','WIP'),
		T_TIPO_DATA('7073059','09','14','WIP'),
		T_TIPO_DATA('7073061','09','14','WIP'),
		T_TIPO_DATA('7073062','09','14','WIP'),
		T_TIPO_DATA('7073063','09','14','WIP'),
		T_TIPO_DATA('7073067','09','14','WIP'),
		T_TIPO_DATA('7073068','09','14','WIP'),
		T_TIPO_DATA('7073069','09','14','WIP'),
		T_TIPO_DATA('7073071','09','14','WIP'),
		T_TIPO_DATA('7073074','09','14','WIP'),
		T_TIPO_DATA('7073075','09','14','WIP'),
		T_TIPO_DATA('7073079','09','14','WIP'),
		T_TIPO_DATA('7073080','09','14','WIP'),
		T_TIPO_DATA('7073082','09','14','WIP'),
		T_TIPO_DATA('7073084','09','14','WIP'),
		T_TIPO_DATA('7073086','09','14','WIP'),
		T_TIPO_DATA('7073087','09','14','WIP'),
		T_TIPO_DATA('7073089','09','14','WIP'),
		T_TIPO_DATA('7073090','09','14','WIP'),
		T_TIPO_DATA('7073092','09','14','WIP'),
		T_TIPO_DATA('7073093','09','14','WIP'),
		T_TIPO_DATA('7073095','09','14','WIP'),
		T_TIPO_DATA('7073096','09','14','WIP'),
		T_TIPO_DATA('7073097','09','14','WIP'),
		T_TIPO_DATA('7073099','09','14','WIP'),
		T_TIPO_DATA('7073100','09','14','WIP'),
		T_TIPO_DATA('7073101','09','14','WIP'),
		T_TIPO_DATA('7073102','09','14','WIP'),
		T_TIPO_DATA('7073103','09','14','WIP'),
		T_TIPO_DATA('7073104','09','14','WIP'),
		T_TIPO_DATA('7073105','09','14','WIP'),
		T_TIPO_DATA('7073106','09','14','WIP'),
		T_TIPO_DATA('7073108','09','14','WIP'),
		T_TIPO_DATA('7073109','09','14','WIP'),
		T_TIPO_DATA('7073110','09','14','WIP'),
		T_TIPO_DATA('7073111','09','14','WIP'),
		T_TIPO_DATA('7073112','09','14','WIP'),
		T_TIPO_DATA('7073114','09','14','WIP'),
		T_TIPO_DATA('7073115','09','14','WIP'),
		T_TIPO_DATA('7073116','09','14','WIP'),
		T_TIPO_DATA('7073117','09','14','WIP'),
		T_TIPO_DATA('7073119','09','14','WIP'),
		T_TIPO_DATA('7073120','09','14','WIP'),
		T_TIPO_DATA('7073121','09','14','WIP'),
		T_TIPO_DATA('7073122','09','14','WIP'),
		T_TIPO_DATA('7073123','09','14','WIP'),
		T_TIPO_DATA('7073124','09','14','WIP'),
		T_TIPO_DATA('7073125','09','14','WIP'),
		T_TIPO_DATA('7073126','09','14','WIP'),
		T_TIPO_DATA('7073127','09','14','WIP'),
		T_TIPO_DATA('7073130','09','14','WIP'),
		T_TIPO_DATA('7073132','09','14','WIP'),
		T_TIPO_DATA('7073136','09','14','WIP'),
		T_TIPO_DATA('7073137','09','14','WIP'),
		T_TIPO_DATA('7073138','09','14','WIP'),
		T_TIPO_DATA('7073140','09','14','WIP'),
		T_TIPO_DATA('7073141','09','14','WIP'),
		T_TIPO_DATA('7073142','09','14','WIP'),
		T_TIPO_DATA('7073144','09','14','WIP'),
		T_TIPO_DATA('7073145','09','14','WIP'),
		T_TIPO_DATA('7073148','09','14','WIP'),
		T_TIPO_DATA('7073150','09','14','WIP'),
		T_TIPO_DATA('7073154','09','14','WIP'),
		T_TIPO_DATA('7073155','09','14','WIP'),
		T_TIPO_DATA('7073156','09','14','WIP'),
		T_TIPO_DATA('7073157','09','14','WIP'),
		T_TIPO_DATA('7073158','09','14','WIP'),
		T_TIPO_DATA('7073162','09','14','WIP'),
		T_TIPO_DATA('6854380','09','14','Tapiado'),
		T_TIPO_DATA('6854988','09','14','Tapiado'),
		T_TIPO_DATA('6855073','09','14','Tapiado'),
		T_TIPO_DATA('6855464','09','14','Tapiado'),
		T_TIPO_DATA('6855787','09','14','Tapiado'),
		T_TIPO_DATA('6855884','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6855885','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6855886','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6855969','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6856542','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6856750','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6856801','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6856802','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6857067','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6857068','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6857275','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6858721','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6858722','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861065','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861066','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861067','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861068','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861069','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861070','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861071','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861072','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861719','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861720','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861721','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861722','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861723','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861724','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861725','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861726','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861727','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861992','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861993','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861994','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861995','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861996','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861997','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861998','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6861999','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862000','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862001','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862002','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862046','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862047','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862048','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862049','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862050','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862051','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862052','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862053','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862093','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862094','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862095','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862096','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862097','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862098','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862099','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862100','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862101','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862134','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862135','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862136','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862137','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862138','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862139','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862140','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862141','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862142','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862143','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862199','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862200','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862201','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862202','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862203','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862204','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862205','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862206','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862207','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862208','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862209','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862393','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862394','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862395','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862441','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862442','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862443','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862444','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862445','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862446','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862447','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862448','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862449','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862450','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862451','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862452','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862453','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862454','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862956','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862957','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862958','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6862959','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863103','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863104','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863105','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863106','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863107','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863108','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863109','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863110','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863284','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863285','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863286','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863287','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863288','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863289','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863290','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863291','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863292','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863293','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863294','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863295','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863296','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863297','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863298','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6863299','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6869434','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6869778','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6875885','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6876543','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6876830','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6876887','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6877938','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6877939','09','14','En construcción obra nueva'),
		T_TIPO_DATA('6859809','09','14','WIP'),
		T_TIPO_DATA('6859811','09','14','WIP'),
		T_TIPO_DATA('6859863','09','14','WIP'),
		T_TIPO_DATA('6860003','09','14','WIP'),
		T_TIPO_DATA('6860005','09','14','WIP'),
		T_TIPO_DATA('6860007','09','14','WIP'),
		T_TIPO_DATA('6860198','09','14','WIP'),
		T_TIPO_DATA('6860201','09','14','WIP'),
		T_TIPO_DATA('6860202','09','14','WIP'),
		T_TIPO_DATA('6860204','09','14','WIP'),
		T_TIPO_DATA('6860207','09','14','WIP'),
		T_TIPO_DATA('6860208','09','14','WIP'),
		T_TIPO_DATA('6860210','09','14','WIP'),
		T_TIPO_DATA('6860508','09','14','WIP'),
		T_TIPO_DATA('6860511','09','14','WIP'),
		T_TIPO_DATA('6860627','09','14','WIP'),
		T_TIPO_DATA('6860631','09','14','WIP'),
		T_TIPO_DATA('6860632','09','14','WIP'),
		T_TIPO_DATA('6860686','09','14','WIP'),
		T_TIPO_DATA('6860687','09','14','WIP'),
		T_TIPO_DATA('6860725','09','14','WIP'),
		T_TIPO_DATA('6860738','09','14','WIP'),
		T_TIPO_DATA('6860892','09','14','WIP'),
		T_TIPO_DATA('6860893','09','14','WIP'),
		T_TIPO_DATA('6860896','09','14','WIP'),
		T_TIPO_DATA('6861104','09','14','WIP'),
		T_TIPO_DATA('6861106','09','14','WIP'),
		T_TIPO_DATA('6861214','09','14','WIP'),
		T_TIPO_DATA('6861215','09','14','WIP'),
		T_TIPO_DATA('6861274','09','14','WIP'),
		T_TIPO_DATA('6861276','09','14','WIP'),
		T_TIPO_DATA('6861277','09','14','WIP'),
		T_TIPO_DATA('6861324','09','14','WIP'),
		T_TIPO_DATA('6861325','09','14','WIP'),
		T_TIPO_DATA('6861359','09','14','WIP'),
		T_TIPO_DATA('6861360','09','14','WIP'),
		T_TIPO_DATA('6861361','09','14','WIP'),
		T_TIPO_DATA('6862166','09','14','WIP'),
		T_TIPO_DATA('6862295','09','14','WIP'),
		T_TIPO_DATA('6862513','09','14','WIP'),
		T_TIPO_DATA('6862516','09','14','WIP'),
		T_TIPO_DATA('6862945','09','14','WIP'),
		T_TIPO_DATA('6862946','09','14','WIP'),
		T_TIPO_DATA('6862949','09','14','WIP'),
		T_TIPO_DATA('6862952','09','14','WIP'),
		T_TIPO_DATA('6862953','09','14','WIP'),
		T_TIPO_DATA('6862954','09','14','WIP'),
		T_TIPO_DATA('6863033','09','14','WIP'),
		T_TIPO_DATA('6863035','09','14','WIP'),
		T_TIPO_DATA('6863037','09','14','WIP'),
		T_TIPO_DATA('6863038','09','14','WIP'),
		T_TIPO_DATA('6863040','09','14','WIP'),
		T_TIPO_DATA('6863225','09','14','WIP'),
		T_TIPO_DATA('6863226','09','14','WIP'),
		T_TIPO_DATA('6863229','09','14','WIP'),
		T_TIPO_DATA('6863231','09','14','WIP'),
		T_TIPO_DATA('6863344','09','14','WIP'),
		T_TIPO_DATA('6863345','09','14','WIP'),
		T_TIPO_DATA('6863446','09','14','WIP'),
		T_TIPO_DATA('6863995','09','14','WIP'),
		T_TIPO_DATA('6863996','09','14','WIP'),
		T_TIPO_DATA('6863997','09','14','WIP'),
		T_TIPO_DATA('6864159','09','14','WIP'),
		T_TIPO_DATA('6864160','09','14','WIP'),
		T_TIPO_DATA('7062767','08','31','Solicitado Advisory'),
		T_TIPO_DATA('7062768','08','31','Solicitado Advisory'),
		T_TIPO_DATA('7062769','08','31','Solicitado Advisory'),
		T_TIPO_DATA('7062772','08','31','Solicitado Advisory'),
		T_TIPO_DATA('7062773','08','31','Solicitado Advisory'),
		T_TIPO_DATA('7062775','08','31','Solicitado Advisory'),
		T_TIPO_DATA('7062776','08','31','Solicitado Advisory'),
		T_TIPO_DATA('7062777','08','31','Solicitado Advisory'),
		T_TIPO_DATA('7062778','08','31','Solicitado Advisory'),
		T_TIPO_DATA('7062779','08','31','Solicitado Advisory'),
		T_TIPO_DATA('7062780','08','31','Solicitado Advisory'),
		T_TIPO_DATA('7062781','08','31','Solicitado Advisory'),
		T_TIPO_DATA('7062783','08','31','Solicitado Advisory'),
		T_TIPO_DATA('7062784','08','31','Solicitado Advisory'),
		T_TIPO_DATA('7062785','08','31','Solicitado Advisory'),
		T_TIPO_DATA('7062786','08','31','Solicitado Advisory'),
		T_TIPO_DATA('7055436','05','09','Pendiente de informe comercial'),
		T_TIPO_DATA('7055437','05','09','Pendiente de informe comercial'),
		T_TIPO_DATA('7055438','05','09','Pendiente de informe comercial'),
		T_TIPO_DATA('7055439','05','09','Pendiente de informe comercial'),
		T_TIPO_DATA('7056492','10','19','Calidad comprobada'),
		T_TIPO_DATA('7056493','10','19','Calidad comprobada'),
		T_TIPO_DATA('7056494','10','19','Calidad comprobada'),
		T_TIPO_DATA('7056495','10','19','Calidad comprobada'),
		T_TIPO_DATA('7056496','10','19','Calidad comprobada'),
		T_TIPO_DATA('7056497','10','19','Calidad comprobada'),
		T_TIPO_DATA('7056498','10','19','Calidad comprobada')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	DBMS_OUTPUT.PUT_LINE('[INFO]: FINALIZAR FASE EN '||V_TEXT_TABLA);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL:='SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT > 0 THEN

			V_MSQL:='SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
			EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;

			V_MSQL:='SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''SUPER''';
			EXECUTE IMMEDIATE V_MSQL INTO V_USU_ID;

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET
			HFP_FECHA_FIN = SYSDATE,
			USUARIOMODIFICAR = '''||V_USU||''',
			FECHAMODIFICAR = SYSDATE
			WHERE
			ACT_ID = '||V_ACT_ID||'
			AND HFP_FECHA_FIN IS NULL';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: FASE FINALIZADA PARA EL ACTIVO: '||V_TMP_TIPO_DATA(1)||'');
				
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (HFP_ID, ACT_ID, DD_FSP_ID, DD_SFP_ID, USU_ID, HFP_FECHA_INI, HFP_COMENTARIO, USUARIOCREAR, FECHACREAR)
			VALUES (
			'||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
			'||V_ACT_ID||',
			(SELECT DD_FSP_ID FROM '||V_ESQUEMA||'.DD_FSP_FASE_PUBLICACION WHERE DD_FSP_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
			(SELECT DD_SFP_ID FROM '||V_ESQUEMA||'.DD_SFP_SUBFASE_PUBLICACION WHERE DD_SFP_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''),
			'||V_USU_ID||',
			SYSDATE,
			'''||V_TMP_TIPO_DATA(4)||''',
			'''||V_USU||''',
			SYSDATE)';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: FASE INSERTADA PARA EL ACTIVO: '||V_TMP_TIPO_DATA(1)||'');
		
		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: EL ACTIVO: '||V_TMP_TIPO_DATA(1)||' NO EXISTE');

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