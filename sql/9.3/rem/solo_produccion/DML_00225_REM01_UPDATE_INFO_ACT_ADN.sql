--/*
--##########################################
--## AUTOR=Alberto Flores
--## FECHA_CREACION=20200331
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6708
--## PRODUCTO=SI
--##
--## Finalidad: Script que actualiza de forma masiva el tipo de entrada, subtipo de entrada y fecha título de los activos. 
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
	V_USR VARCHAR2(30 CHAR) := 'REMVIP-6708'; -- USUARIOCREAR/USUARIOMODIFICAR.
	
	TYPE T_ACT IS TABLE OF VARCHAR2(50);
	TYPE T_ARRAY_ACT IS TABLE OF T_ACT; 
	V_ACT T_ARRAY_ACT := T_ARRAY_ACT(   
		T_ACT('6895075', '20200117'), 	T_ACT('6895076', '20200117'), 	T_ACT('6895077', '20200117'), 	T_ACT('6895078', '20200117'),
		T_ACT('6895079', '20200117'), 	T_ACT('6895080', '20200117'), 	T_ACT('6895081', '20200117'), 	T_ACT('6895082', '20200117'),
		T_ACT('6895083', '20200117'), 	T_ACT('6895084', '20200117'), 	T_ACT('6895085', '20200117'), 	T_ACT('6895087', '20200117'),
		T_ACT('6895088', '20200117'), 	T_ACT('6895089', '20200117'), 	T_ACT('6895090', '20200117'), 	T_ACT('6895091', '20200117'),
		T_ACT('6895092', '20200117'), 	T_ACT('6895093', '20200117'), 	T_ACT('6895094', '20200117'), 	T_ACT('6895095', '20200117'),
		T_ACT('6895096', '20200117'), 	T_ACT('6895097', '20200117'), 	T_ACT('6895098', '20200117'), 	T_ACT('6895099', '20200117'),
		T_ACT('6895100', '20200117'), 	T_ACT('6895101', '20200117'), 	T_ACT('6895102', '20200117'), 	T_ACT('6895103', '20200117'),
		T_ACT('6895104', '20200117'), 	T_ACT('6895105', '20200117'), 	T_ACT('6895106', '20200117'), 	T_ACT('6895107', '20200117'),
		T_ACT('6895108', '20200117'), 	T_ACT('6895109', '20200117'), 	T_ACT('6895110', '20200117'), 	T_ACT('6895111', '20200117'),
		T_ACT('6895112', '20200117'), 	T_ACT('6895113', '20200117'), 	T_ACT('6895114', '20200117'), 	T_ACT('6895115', '20200117'),
		T_ACT('6895116', '20200117'), 	T_ACT('6895117', '20200117'), 	T_ACT('6895118', '20200117'), 	T_ACT('6895119', '20200117'),
		T_ACT('6895120', '20200117'), 	T_ACT('6895121', '20200117'), 	T_ACT('6895122', '20200117'), 	T_ACT('6895123', '20200117'),
		T_ACT('6895124', '20200117'), 	T_ACT('6895125', '20200117'), 	T_ACT('6895126', '20200117'), 	T_ACT('6895127', '20200117'),
		T_ACT('6895128', '20200117'), 	T_ACT('6895129', '20200117'), 	T_ACT('6895130', '20200117'), 	T_ACT('6895131', '20200117'),
		T_ACT('6895132', '20200117'), 	T_ACT('6895133', '20200117'), 	T_ACT('6895134', '20200117'), 	T_ACT('6895135', '20200117'),
		T_ACT('6895136', '20200117'), 	T_ACT('6895137', '20200117'), 	T_ACT('6895138', '20200117'), 	T_ACT('6895139', '20200117'),
		T_ACT('6895140', '20200117'), 	T_ACT('6895141', '20200117'), 	T_ACT('6895142', '20200117'), 	T_ACT('6895143', '20200117'),
		T_ACT('6895144', '20200117'), 	T_ACT('6895146', '20200117'), 	T_ACT('6895147', '20200117'), 	T_ACT('6895148', '20200117'),
		T_ACT('6895149', '20200117'), 	T_ACT('6895150', '20200117'), 	T_ACT('6895152', '20200117'), 	T_ACT('6895153', '20200117'),
		T_ACT('6895154', '20200117'), 	T_ACT('6895155', '20200117'), 	T_ACT('6895156', '20200117'), 	T_ACT('6895157', '20200117'),
		T_ACT('6895158', '20200117'), 	T_ACT('6895159', '20200117'), 	T_ACT('6895160', '20200117'), 	T_ACT('6895161', '20200117'),
		T_ACT('6895162', '20200117'), 	T_ACT('6895163', '20200117'), 	T_ACT('6895164', '20200117'), 	T_ACT('6895165', '20200117'),
		T_ACT('6895166', '20200117'), 	T_ACT('6895167', '20200117'), 	T_ACT('6895168', '20200117'), 	T_ACT('6895169', '20200117'),
		T_ACT('6895170', '20200117'), 	T_ACT('6895171', '20200117'), 	T_ACT('6895172', '20200117'), 	T_ACT('6895173', '20200117'),
		T_ACT('6895174', '20200117'), 	T_ACT('6895175', '20200117'), 	T_ACT('6895176', '20200117'), 	T_ACT('6895177', '20200117'),
		T_ACT('6895178', '20200117'), 	T_ACT('6895179', '20200117'), 	T_ACT('6895180', '20200117'), 	T_ACT('6895181', '20200117'),
		T_ACT('6895182', '20200117'), 	T_ACT('6895183', '20200117'), 	T_ACT('6895184', '20200117'), 	T_ACT('6895185', '20200117'),
		T_ACT('6895186', '20200117'), 	T_ACT('6895190', '20200117'), 	T_ACT('6895193', '20200117'), 	T_ACT('6895194', '20200117'),
		T_ACT('6895195', '20200117'), 	T_ACT('6895196', '20200117'), 	T_ACT('6895200', '20200117'), 	T_ACT('6895202', '20200117'),
		T_ACT('6895204', '20200117'), 	T_ACT('6895205', '20200117'), 	T_ACT('6895226', '20200117'), 	T_ACT('6895228', '20200117'),
		T_ACT('6895232', '20200117'), 	T_ACT('6895235', '20200117'), 	T_ACT('6895243', '20200117'), 	T_ACT('6895244', '20200117'),
		T_ACT('6895250', '20200117'), 	T_ACT('6895251', '20200117'), 	T_ACT('6895253', '20200117'), 	T_ACT('6895289', '20200117'),
		T_ACT('6895291', '20200117'), 	T_ACT('6895295', '20200117'), 	T_ACT('6895297', '20200117'), 	T_ACT('6895308', '20200117'),
		T_ACT('6895309', '20200117'),
		
		T_ACT('6893293', '20200207'), 	T_ACT('6893294', '20200207'), 	T_ACT('6893295', '20200207'), 	T_ACT('6893296', '20200207'),
		T_ACT('6893297', '20200207'), 	T_ACT('6893298', '20200207'), 	T_ACT('6893299', '20200207'), 	T_ACT('6893300', '20200207'),
		T_ACT('6893301', '20200207'), 	T_ACT('6893302', '20200207'), 	T_ACT('6893303', '20200207'), 	T_ACT('6893304', '20200207'),
		T_ACT('6893305', '20200207'), 	T_ACT('6893306', '20200207'), 	T_ACT('6893307', '20200207'), 	T_ACT('6893308', '20200207'),
		T_ACT('6893309', '20200207'), 	T_ACT('6893310', '20200207'), 	T_ACT('6893316', '20200207'), 	T_ACT('6893317', '20200207'),
		T_ACT('6893318', '20200207'), 	T_ACT('6893319', '20200207'), 	T_ACT('6893320', '20200207'), 	T_ACT('6893321', '20200207'),
		T_ACT('6893322', '20200207'), 	T_ACT('6893323', '20200207'), 	T_ACT('6893324', '20200207'), 	T_ACT('6893325', '20200207'),
		T_ACT('6893330', '20200207'), 	T_ACT('6893333', '20200207'), 	T_ACT('6893334', '20200207'), 	T_ACT('6893335', '20200207'),
		T_ACT('6893336', '20200207'), 	T_ACT('6893337', '20200207'), 	T_ACT('6893338', '20200207'), 	T_ACT('6893339', '20200207'),
		T_ACT('6893340', '20200207'), 	T_ACT('6893341', '20200207'), 	T_ACT('7299599', '20200207'), 	T_ACT('7299600', '20200207'),
		T_ACT('7299601', '20200207'), 	T_ACT('7299602', '20200207'), 	T_ACT('7299603', '20200207'), 	T_ACT('7299604', '20200207'),
		T_ACT('7299605', '20200207'), 	T_ACT('7299606', '20200207'), 	T_ACT('7299607', '20200207'), 	T_ACT('7299608', '20200207')
	); 
	V_TMP_ACT T_ACT;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualización masiva de campos:');

	FOR I IN V_ACT.FIRST .. V_ACT.LAST LOOP
		V_TMP_ACT := V_ACT(I);
		
		V_MSQL := 'SELECT COUNT(*) FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_ACT(1)||'';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
		
		IF V_NUM > 0 THEN
			DBMS_OUTPUT.PUT_LINE('	[INFO] Actualizando los campos del activo '||V_TMP_ACT(1));
			
			EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT 
			USING(
				SELECT T1.ACT_ID FROM ACT_ACTIVO T1
				WHERE T1.ACT_NUM_ACTIVO = '||V_TMP_ACT(1)||'
			) T2
			ON (
				ACT.ACT_ID = T2.ACT_ID
			)
			WHEN MATCHED THEN UPDATE SET
				ACT.DD_TTA_ID = 2, 
				ACT.DD_STA_ID = 3, 
				ACT.USUARIOMODIFICAR = '''||V_USR||''',
				ACT.FECHAMODIFICAR = SYSDATE
			';
			
			EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL ADN 
			USING(
				SELECT T1.ACT_ID FROM ACT_ACTIVO T1
				JOIN ACT_ADN_ADJNOJUDICIAL ADN ON ADN.ACT_ID = T1.ACT_ID
				WHERE T1.ACT_NUM_ACTIVO = '||V_TMP_ACT(1)||'
			) T2
			ON (
				ADN.ACT_ID = T2.ACT_ID
			)
			WHEN MATCHED THEN UPDATE SET
				ADN.ADN_FECHA_TITULO = TO_DATE('||V_TMP_ACT(2)||',''YYYYMMDD''),
				ADN.USUARIOMODIFICAR = '''||V_USR||''',
				ADN.FECHAMODIFICAR = SYSDATE
			';
	
			DBMS_OUTPUT.PUT_LINE('	[OK] Campos actualizados.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('	[WRN] No existe el activo '||V_TMP_ACT(1)||'.');
		END IF;
	END LOOP;
	
	--ROLLBACK;
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
