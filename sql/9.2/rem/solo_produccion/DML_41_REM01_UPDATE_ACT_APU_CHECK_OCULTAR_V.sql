--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20190204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3265
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-3265'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    ACT_NUM_ACTIVO NUMBER(16);
    TIPO VARCHAR2(30 CHAR);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV(67473,'Venta'),
		T_JBV(138892,'Venta'),
		T_JBV(139979,'Venta'),
		T_JBV(162124,'Venta'),
		T_JBV(174206,'Venta'),
		T_JBV(188003,'Venta'),
		T_JBV(195298,'Venta'),
		T_JBV(195591,'Venta'),
		T_JBV(204333,'Venta'),
		T_JBV(935235,'Venta'),
		T_JBV(937004,'Venta'),
		T_JBV(940211,'Venta'),
		T_JBV(942075,'Venta'),
		T_JBV(5924996,'Venta'),
		T_JBV(5925131,'Venta'),
		T_JBV(5925473,'Venta'),
		T_JBV(5925487,'Venta'),
		T_JBV(5925559,'Venta'),
		T_JBV(5925808,'Venta'),
		T_JBV(5926111,'Venta'),
		T_JBV(5926218,'Alquiler y venta'),
		T_JBV(5926273,'Venta'),
		T_JBV(5926496,'Venta'),
		T_JBV(5926563,'Venta'),
		T_JBV(5926815,'Venta'),
		T_JBV(5927179,'Venta'),
		T_JBV(5927458,'Venta'),
		T_JBV(5927608,'Venta'),
		T_JBV(5928797,'Venta'),
		T_JBV(5929106,'Venta'),
		T_JBV(5929118,'Venta'),
		T_JBV(5929509,'Venta'),
		T_JBV(5929639,'Venta'),
		T_JBV(5929720,'Venta'),
		T_JBV(5929721,'Venta'),
		T_JBV(5929770,'Venta'),
		T_JBV(5930051,'Venta'),
		T_JBV(5930150,'Venta'),
		T_JBV(5930191,'Venta'),
		T_JBV(5930222,'Venta'),
		T_JBV(5930226,'Venta'),
		T_JBV(5930371,'Venta'),
		T_JBV(5930418,'Venta'),
		T_JBV(5930528,'Venta'),
		T_JBV(5930534,'Venta'),
		T_JBV(5930656,'Venta'),
		T_JBV(5930808,'Venta'),
		T_JBV(5930868,'Venta'),
		T_JBV(5931071,'Venta'),
		T_JBV(5931105,'Venta'),
		T_JBV(5931145,'Venta'),
		T_JBV(5931347,'Venta'),
		T_JBV(5931348,'Venta'),
		T_JBV(5931568,'Venta'),
		T_JBV(5931573,'Venta'),
		T_JBV(5931750,'Venta'),
		T_JBV(5931816,'Venta'),
		T_JBV(5931817,'Venta'),
		T_JBV(5932043,'Venta'),
		T_JBV(5932044,'Venta'),
		T_JBV(5932179,'Venta'),
		T_JBV(5932255,'Venta'),
		T_JBV(5932424,'Venta'),
		T_JBV(5932523,'Venta'),
		T_JBV(5932535,'Venta'),
		T_JBV(5932886,'Venta'),
		T_JBV(5933087,'Venta'),
		T_JBV(5933196,'Venta'),
		T_JBV(5933337,'Venta'),
		T_JBV(5933562,'Venta'),
		T_JBV(5933631,'Venta'),
		T_JBV(5933979,'Venta'),
		T_JBV(5934298,'Venta'),
		T_JBV(5934394,'Venta'),
		T_JBV(5934489,'Venta'),
		T_JBV(5934762,'Venta'),
		T_JBV(5934865,'Venta'),
		T_JBV(5935101,'Venta'),
		T_JBV(5935356,'Venta'),
		T_JBV(5935504,'Venta'),
		T_JBV(5935513,'Venta'),
		T_JBV(5935537,'Venta'),
		T_JBV(5935675,'Venta'),
		T_JBV(5935746,'Venta'),
		T_JBV(5935747,'Venta'),
		T_JBV(5935988,'Venta'),
		T_JBV(5936115,'Venta'),
		T_JBV(5936750,'Venta'),
		T_JBV(5937224,'Venta'),
		T_JBV(5938064,'Venta'),
		T_JBV(5938175,'Venta'),
		T_JBV(5938745,'Venta'),
		T_JBV(5938906,'Venta'),
		T_JBV(5938925,'Venta'),
		T_JBV(5939128,'Venta'),
		T_JBV(5939439,'Venta'),
		T_JBV(5939643,'Venta'),
		T_JBV(5939953,'Venta'),
		T_JBV(5939972,'Venta'),
		T_JBV(5940015,'Venta'),
		T_JBV(5940123,'Venta'),
		T_JBV(5940260,'Venta'),
		T_JBV(5940574,'Venta'),
		T_JBV(5940991,'Venta'),
		T_JBV(5941205,'Venta'),
		T_JBV(5941474,'Venta'),
		T_JBV(5941660,'Venta'),
		T_JBV(5942189,'Venta'),
		T_JBV(5942281,'Venta'),
		T_JBV(5942516,'Venta'),
		T_JBV(5942543,'Venta'),
		T_JBV(5942592,'Venta'),
		T_JBV(5942894,'Venta'),
		T_JBV(5942916,'Venta'),
		T_JBV(5943461,'Venta'),
		T_JBV(5943718,'Venta'),
		T_JBV(5943782,'Venta'),
		T_JBV(5943919,'Venta'),
		T_JBV(5944397,'Venta'),
		T_JBV(5944762,'Venta'),
		T_JBV(5945137,'Venta'),
		T_JBV(5945468,'Venta'),
		T_JBV(5945743,'Venta'),
		T_JBV(5945802,'Venta'),
		T_JBV(5945803,'Venta'),
		T_JBV(5946009,'Venta'),
		T_JBV(5946174,'Venta'),
		T_JBV(5946235,'Venta'),
		T_JBV(5946431,'Venta'),
		T_JBV(5946446,'Venta'),
		T_JBV(5947505,'Venta'),
		T_JBV(5947572,'Venta'),
		T_JBV(5947833,'Venta'),
		T_JBV(5947878,'Venta'),
		T_JBV(5947961,'Venta'),
		T_JBV(5948201,'Venta'),
		T_JBV(5948578,'Venta'),
		T_JBV(5948667,'Venta'),
		T_JBV(5948691,'Venta'),
		T_JBV(5948812,'Venta'),
		T_JBV(5948849,'Venta'),
		T_JBV(5948995,'Venta'),
		T_JBV(5949196,'Venta'),
		T_JBV(5949327,'Venta'),
		T_JBV(5950851,'Venta'),
		T_JBV(5951304,'Venta'),
		T_JBV(5951720,'Venta'),
		T_JBV(5951815,'Venta'),
		T_JBV(5952051,'Venta'),
		T_JBV(5952145,'Venta'),
		T_JBV(5952450,'Venta'),
		T_JBV(5952530,'Venta'),
		T_JBV(5952685,'Venta'),
		T_JBV(5952745,'Venta'),
		T_JBV(5952983,'Venta'),
		T_JBV(5953533,'Venta'),
		T_JBV(5953845,'Venta'),
		T_JBV(5953909,'Alquiler y venta'),
		T_JBV(5954043,'Venta'),
		T_JBV(5954147,'Venta'),
		T_JBV(5954150,'Venta'),
		T_JBV(5954377,'Venta'),
		T_JBV(5954558,'Venta'),
		T_JBV(5954613,'Venta'),
		T_JBV(5954648,'Venta'),
		T_JBV(5955065,'Venta'),
		T_JBV(5955085,'Venta'),
		T_JBV(5955173,'Venta'),
		T_JBV(5955807,'Venta'),
		T_JBV(5955829,'Venta'),
		T_JBV(5955946,'Venta'),
		T_JBV(5956007,'Venta'),
		T_JBV(5956025,'Venta'),
		T_JBV(5956034,'Venta'),
		T_JBV(5956078,'Venta'),
		T_JBV(5956479,'Venta'),
		T_JBV(5956489,'Venta'),
		T_JBV(5956580,'Venta'),
		T_JBV(5956593,'Venta'),
		T_JBV(5956683,'Venta'),
		T_JBV(5956900,'Venta'),
		T_JBV(5957134,'Venta'),
		T_JBV(5957781,'Venta'),
		T_JBV(5958014,'Venta'),
		T_JBV(5958179,'Venta'),
		T_JBV(5958391,'Venta'),
		T_JBV(5958512,'Venta'),
		T_JBV(5958534,'Venta'),
		T_JBV(5958539,'Venta'),
		T_JBV(5958554,'Venta'),
		T_JBV(5958755,'Venta'),
		T_JBV(5958778,'Venta'),
		T_JBV(5959050,'Venta'),
		T_JBV(5959102,'Venta'),
		T_JBV(5959258,'Venta'),
		T_JBV(5959521,'Venta'),
		T_JBV(5959766,'Venta'),
		T_JBV(5959860,'Venta'),
		T_JBV(5960020,'Venta'),
		T_JBV(5960179,'Venta'),
		T_JBV(5960436,'Venta'),
		T_JBV(5960443,'Venta'),
		T_JBV(5960492,'Venta'),
		T_JBV(5960549,'Venta'),
		T_JBV(5961071,'Venta'),
		T_JBV(5961123,'Venta'),
		T_JBV(5961307,'Venta'),
		T_JBV(5961425,'Venta'),
		T_JBV(5961437,'Venta'),
		T_JBV(5961473,'Venta'),
		T_JBV(5961767,'Venta'),
		T_JBV(5962218,'Venta'),
		T_JBV(5962432,'Venta'),
		T_JBV(5963010,'Venta'),
		T_JBV(5963312,'Venta'),
		T_JBV(5963420,'Venta'),
		T_JBV(5963844,'Venta'),
		T_JBV(5964004,'Venta'),
		T_JBV(5964080,'Venta'),
		T_JBV(5964245,'Venta'),
		T_JBV(5964252,'Venta'),
		T_JBV(5964938,'Alquiler y venta'),
		T_JBV(5965048,'Venta'),
		T_JBV(5965258,'Venta'),
		T_JBV(5965443,'Venta'),
		T_JBV(5965877,'Venta'),
		T_JBV(5965991,'Venta'),
		T_JBV(5966048,'Venta'),
		T_JBV(5966419,'Venta'),
		T_JBV(5966744,'Venta'),
		T_JBV(5966987,'Venta'),
		T_JBV(5967483,'Venta'),
		T_JBV(5967569,'Venta'),
		T_JBV(5968697,'Venta'),
		T_JBV(5968726,'Venta'),
		T_JBV(5969018,'Venta'),
		T_JBV(5969309,'Venta'),
		T_JBV(5969542,'Venta'),
		T_JBV(5969726,'Venta'),
		T_JBV(5970038,'Venta'),
		T_JBV(5970246,'Venta'),
		T_JBV(5970352,'Venta'),
		T_JBV(5971519,'Venta'),
		T_JBV(5971574,'Venta'),
		T_JBV(5971632,'Venta'),
		T_JBV(5971743,'Venta'),
		T_JBV(6044829,'Venta'),
		T_JBV(6044912,'Venta'),
		T_JBV(6044927,'Venta'),
		T_JBV(6044928,'Venta'),
		T_JBV(6044935,'Venta'),
		T_JBV(6044990,'Venta'),
		T_JBV(6044999,'Venta'),
		T_JBV(6046010,'Venta'),
		T_JBV(6046352,'Venta'),
		T_JBV(6048319,'Venta'),
		T_JBV(6054372,'Venta'),
		T_JBV(6054686,'Venta'),
		T_JBV(6054933,'Venta'),
		T_JBV(6056967,'Venta'),
		T_JBV(6058278,'Venta'),
		T_JBV(6058480,'Venta'),
		T_JBV(6059265,'Venta'),
		T_JBV(6063756,'Venta'),
		T_JBV(6064146,'Venta'),
		T_JBV(6128629,'Venta'),
		T_JBV(6132924,'Venta'),
		T_JBV(6132950,'Venta'),
		T_JBV(6345886,'Venta'),
		T_JBV(6351607,'Venta'),
		T_JBV(6355322,'Venta'),
		T_JBV(6355334,'Venta'),
		T_JBV(6523310,'Venta'),
		T_JBV(6525373,'Venta'),
		T_JBV(6525380,'Venta'),
		T_JBV(6525381,'Venta'),
		T_JBV(6525382,'Venta'),
		T_JBV(6705280,'Venta'),
		T_JBV(6705281,'Venta'),
		T_JBV(6705440,'Venta'),
		T_JBV(6709298,'Venta'),
		T_JBV(6756931,'Venta'),
		T_JBV(6772870,'Venta'),
		T_JBV(6772878,'Venta'),
		T_JBV(6775815,'Venta'),
		T_JBV(6781665,'Venta'),
		T_JBV(6787687,'Alquiler y venta'),
		T_JBV(6787810,'Venta'),
		T_JBV(6796797,'Venta'),
		T_JBV(6798896,'Venta'),
		T_JBV(6809953,'Venta'),
		T_JBV(6810467,'Venta'),
		T_JBV(6812083,'Venta'),
		T_JBV(6812089,'Venta'),
		T_JBV(6814444,'Venta'),
		T_JBV(6814649,'Venta'),
		T_JBV(6824716,'Venta'),
		T_JBV(6844033,'Venta'),
		T_JBV(6848941,'Venta'),
		T_JBV(6849053,'Venta'),
		T_JBV(6849763,'Venta'),
		T_JBV(6853658,'Venta'),
		T_JBV(6871757,'Venta'),
		T_JBV(6875222,'Venta'),
		T_JBV(6876109,'Venta'),
		T_JBV(6876110,'Venta'),
		T_JBV(6878602,'Alquiler y venta'),
		T_JBV(6879611,'Venta'),
		T_JBV(6891841,'Venta'),
		T_JBV(6935867,'Venta'),
		T_JBV(6938934,'Venta'),
		T_JBV(6943716,'Venta'),
		T_JBV(6946137,'Venta'),
		T_JBV(6946919,'Venta'),
		T_JBV(6959916,'Venta'),
		T_JBV(6961826,'Venta'),
		T_JBV(6965197,'Venta'),
		T_JBV(6965743,'Venta'),
		T_JBV(6966963,'Venta'),
		T_JBV(6970000,'Venta'),
		T_JBV(6970006,'Venta'),
		T_JBV(6970990,'Venta'),
		T_JBV(6971238,'Venta'),
		T_JBV(6973118,'Venta'),
		T_JBV(6982409,'Venta'),
		T_JBV(6985423,'Venta'),
		T_JBV(6986285,'Venta'),
		T_JBV(6988682,'Alquiler y venta'),
		T_JBV(6989325,'Venta'),
		T_JBV(6989692,'Venta'),
		T_JBV(6989712,'Venta'),
		T_JBV(6990748,'Venta'),
		T_JBV(6992938,'Venta'),
		T_JBV(6994367,'Venta'),
		T_JBV(6994371,'Venta'),
		T_JBV(6994704,'Venta'),
		T_JBV(6995412,'Venta'),
		T_JBV(6995599,'Venta'),
		T_JBV(6995954,'Venta'),
		T_JBV(6997478,'Venta'),
		T_JBV(6999575,'Venta'),
		T_JBV(6999948,'Venta'),
		T_JBV(6999951,'Venta'),
		T_JBV(6999989,'Venta'),
		T_JBV(7000002,'Venta'),
		T_JBV(7000009,'Venta'),
		T_JBV(7000034,'Venta'),
		T_JBV(7000043,'Venta'),
		T_JBV(7000074,'Venta'),
		T_JBV(7000084,'Venta'),
		T_JBV(7000094,'Venta'),
		T_JBV(7000095,'Venta'),
		T_JBV(7000480,'Venta'),
		T_JBV(7000988,'Venta'),
		T_JBV(7001313,'Venta'),
		T_JBV(7001445,'Venta'),
		T_JBV(7007120,'Venta')

		); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION COLUMNA APU_CHECK_OCULTAR_V');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	ACT_NUM_ACTIVO := TRIM(V_TMP_JBV(1));
  	TIPO := TRIM(V_TMP_JBV(2));
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION
					   SET APU_CHECK_OCULTAR_V = 1,
					   USUARIOMODIFICAR = '''||V_USR||''',
					   FECHAMODIFICAR = SYSDATE 
					   WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||')
					   AND DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_DESCRIPCION IN (''Venta''))';
	
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON ACT_NUM_ACTIVO: '||ACT_NUM_ACTIVO||' y VENTA ACTUALIZADO');
			
		V_COUNT_UPDATE := V_COUNT_UPDATE + 1;

		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION
					   SET APU_CHECK_OCULTAR_V = 1,
					   APU_CHECK_OCULTAR_A = 1,
					   USUARIOMODIFICAR = '''||V_USR||''',
					   FECHAMODIFICAR = SYSDATE 
					   WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||')
					   AND DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_DESCRIPCION IN (''Alquiler y venta''))';
	
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON ACT_NUM_ACTIVO: '||ACT_NUM_ACTIVO||' y ALQUILER ACTUALIZADO');
			
		V_COUNT_UPDATE := V_COUNT_UPDATE + 1;

	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;
	
	END LOOP;
		
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE||' registros');
 
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
