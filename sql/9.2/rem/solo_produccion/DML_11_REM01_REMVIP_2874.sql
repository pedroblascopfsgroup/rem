--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20181210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2874
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-2874'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    NUMERO_OFERTA NUMBER(16);
    USUARIO VARCHAR2(30 CHAR);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
			T_JBV(90091567,'jdrodriguez'),
			T_JBV(90091561,'jdrodriguez'),
			T_JBV(90091817,'jdrodriguez'),
			T_JBV(90091611,'ebretones'),
			T_JBV(90091657,'mcozar'),
			T_JBV(90068423,'cbenavides'),
			T_JBV(90068344,'jmartinezsa'),
			T_JBV(90069261,'cbenavides'),
			T_JBV(90068945,'mlopez'),
			T_JBV(90091312,'nmuñoz'),
			T_JBV(90091157,'mcozar'),
			T_JBV(90091122,'ebretones'),
			T_JBV(90091129,'mlopez'),
			T_JBV(90090882,'nmuñoz'),
			T_JBV(90090974,'mlopez'),
			T_JBV(90091341,'jmartinezsa'),
			T_JBV(90069737,'cbenavides'),
			T_JBV(90089810,'nmuñoz'),
			T_JBV(90089843,'mlopez'),
			T_JBV(90089738,'nmuñoz'),
			T_JBV(90090305,'mcozar'),
			T_JBV(90089957,'mlopez'),
			T_JBV(90090446,'jmartinezsa'),
			T_JBV(90090391,'ebretones'),
			T_JBV(90090689,'mcozar'),
			T_JBV(90090735,'cbenavides'),
			T_JBV(90090465,'ebretones'),
			T_JBV(90090472,'ebretones'),
			T_JBV(90090676,'mlopez'),
			T_JBV(90066708,'cbenavides'),
			T_JBV(90067397,'cbenavides'),
			T_JBV(90089279,'cbenavides'),
			T_JBV(90089090,'nmuñoz'),
			T_JBV(90089526,'jmartinezsa'),
			T_JBV(90089593,'nmuñoz'),
			T_JBV(90088581,'mcozar'),
			T_JBV(90088018,'ebretones'),
			T_JBV(90087969,'cbenavides'),
			T_JBV(90088510,'mcozar'),
			T_JBV(90088216,'jmartinezsa'),
			T_JBV(90088147,'mcozar'),
			T_JBV(90088092,'ebretones'),
			T_JBV(90088102,'jmartinezsa'),
			T_JBV(90086173,'ebretones'),
			T_JBV(90086275,'nmuñoz'),
			T_JBV(90064875,'cbenavides'),
			T_JBV(90073569,'cbenavides'),
			T_JBV(90073546,'mlopez'),
			T_JBV(90073722,'cbenavides'),
			T_JBV(90094159,'cbenavides'),
			T_JBV(90094028,'mcozar'),
			T_JBV(90094103,'cbenavides'),
			T_JBV(90094139,'cbenavides'),
			T_JBV(90075873,'cbenavides'),
			T_JBV(90075904,'nmuñoz'),
			T_JBV(90076679,'jmartinezsa'),
			T_JBV(90092433,'cbenavides'),
			T_JBV(90077054,'cbenavides'),
			T_JBV(90092768,'cbenavides'),
			T_JBV(90092859,'ebretones'),
			T_JBV(90092878,'mlopez'),
			T_JBV(90093264,'jmartinezsa'),
			T_JBV(90093223,'mlopez'),
			T_JBV(90093535,'mlopez'),
			T_JBV(90093281,'jmartinezsa'),
			T_JBV(90093006,'mlopez'),
			T_JBV(90093148,'mcozar'),
			T_JBV(90093215,'cbenavides'),
			T_JBV(90092889,'mlopez'),
			T_JBV(90092992,'jmartinezsa'),
			T_JBV(90093554,'mcozar'),
			T_JBV(90093556,'cbenavides'),
			T_JBV(90093757,'cbenavides'),
			T_JBV(90070724,'cbenavides'),
			T_JBV(90070860,'cbenavides'),
			T_JBV(90075118,'cbenavides'),
			T_JBV(90073908,'jmartinezsa'),
			T_JBV(90092306,'mlopez'),
			T_JBV(90092363,'mlopez'),
			T_JBV(90092335,'cbenavides'),
			T_JBV(90092327,'mlopez'),
			T_JBV(90092325,'ebretones'),
			T_JBV(90092367,'ebretones'),
			T_JBV(90087579,'jmartinezsa'),
			T_JBV(90087105,'nmuñoz'),
			T_JBV(90087071,'nmuñoz'),
			T_JBV(90087677,'nmuñoz'),
			T_JBV(90087782,'nmuñoz'),
			T_JBV(90087668,'cbenavides'),
			T_JBV(90087803,'ebretones'),
			T_JBV(90087805,'mlopez'),
			T_JBV(90086810,'mcozar'),
			T_JBV(90086935,'mlopez'),
			T_JBV(90104168,'mcozar'),
			T_JBV(90103955,'texposito'),
			T_JBV(90103280,'nmuñoz'),
			T_JBV(90103474,'jmartinezsa'),
			T_JBV(90103226,'cbenavides'),
			T_JBV(90103239,'ebretones'),
			T_JBV(90104653,'mcozar'),
			T_JBV(90104262,'cbenavides'),
			T_JBV(90035873,'mlopez'),
			T_JBV(90038854,'cbenavides'),
			T_JBV(90035621,'mlopez'),
			T_JBV(90048725,'cbenavides'),
			T_JBV(90101355,'mcozar'),
			T_JBV(90101286,'mcozar'),
			T_JBV(90101117,'cbenavides'),
			T_JBV(90101240,'mlopez'),
			T_JBV(90100831,'cbenavides'),
			T_JBV(90100703,'cbenavides'),
			T_JBV(90100596,'cbenavides'),
			T_JBV(90100885,'jmartinezsa'),
			T_JBV(90100566,'mlopez'),
			T_JBV(90100512,'mcozar'),
			T_JBV(90100464,'cbenavides'),
			T_JBV(90100408,'jdrodriguez'),
			T_JBV(90100372,'jdrodriguez'),
			T_JBV(90100100,'jmartinezsa'),
			T_JBV(90100068,'ebretones'),
			T_JBV(90099872,'mlopez'),
			T_JBV(90100216,'mcozar'),
			T_JBV(90100269,'jdrodriguez'),
			T_JBV(90100322,'mcozar'),
			T_JBV(90100334,'ebretones'),
			T_JBV(90100351,'mcozar'),
			T_JBV(90100352,'mlopez'),
			T_JBV(90100366,'jdrodriguez'),
			T_JBV(90083299,'jdrodriguez'),
			T_JBV(90083843,'nmuñoz'),
			T_JBV(90084184,'mcozar'),
			T_JBV(90099659,'jdrodriguez'),
			T_JBV(90099696,'jdrodriguez'),
			T_JBV(90078961,'cbenavides'),
			T_JBV(90079348,'mlopez'),
			T_JBV(90079820,'nmuñoz'),
			T_JBV(90096221,'jdrodriguez'),
			T_JBV(90096313,'nmuñoz'),
			T_JBV(90096298,'ebretones'),
			T_JBV(90096268,'mlopez'),
			T_JBV(90096399,'ebretones'),
			T_JBV(90096591,'mlopez'),
			T_JBV(90097303,'mlopez'),
			T_JBV(90097364,'jdrodriguez'),
			T_JBV(90096642,'mcozar'),
			T_JBV(90096972,'jmartinezsa'),
			T_JBV(90096690,'jmartinezsa'),
			T_JBV(90096829,'mlopez'),
			T_JBV(90095999,'mlopez'),
			T_JBV(90099563,'jmartinezsa'),
			T_JBV(90099223,'jdrodriguez'),
			T_JBV(90099447,'mlopez'),
			T_JBV(90098960,'jmartinezsa'),
			T_JBV(90098881,'mlopez'),
			T_JBV(90098872,'jdrodriguez'),
			T_JBV(90098986,'ebretones'),
			T_JBV(90099088,'jdrodriguez'),
			T_JBV(90099162,'mlopez'),
			T_JBV(90098224,'mcozar'),
			T_JBV(90098094,'jdrodriguez'),
			T_JBV(90098102,'nmuñoz'),
			T_JBV(90098075,'mlopez'),
			T_JBV(90097797,'ebretones'),
			T_JBV(90097821,'texposito'),
			T_JBV(90098770,'nmuñoz'),
			T_JBV(90098356,'jdrodriguez'),
			T_JBV(90098579,'mlopez'),
			T_JBV(90098381,'jdrodriguez'),
			T_JBV(90077755,'jmartinezsa'),
			T_JBV(90097728,'mlopez'),
			T_JBV(90097771,'ebretones'),
			T_JBV(90097614,'jdrodriguez'),
			T_JBV(90097547,'jdrodriguez'),
			T_JBV(90097518,'jdrodriguez'),
			T_JBV(90078430,'jdrodriguez'),
			T_JBV(90078698,'mcozar'),
			T_JBV(90078779,'mcozar'),
			T_JBV(90078562,'mlopez'),
			T_JBV(90095438,'mlopez'),
			T_JBV(90095545,'jdrodriguez'),
			T_JBV(90095633,'mlopez'),
			T_JBV(90095626,'jdrodriguez'),
			T_JBV(90095632,'mcozar'),
			T_JBV(90095564,'cbenavides'),
			T_JBV(90094241,'jdrodriguez'),
			T_JBV(90094893,'mlopez'),
			T_JBV(90094578,'nmuñoz'),
			T_JBV(90094214,'jdrodriguez'),
			T_JBV(90095743,'ebretones'),
			T_JBV(90095667,'cbenavides'),
			T_JBV(90095694,'mcozar'),
			T_JBV(90095920,'ebretones'),
			T_JBV(90101654,'mcozar'),
			T_JBV(90101607,'mlopez'),
			T_JBV(90101554,'mlopez'),
			T_JBV(90101978,'mlopez'),
			T_JBV(90101972,'jmartinezsa'),
			T_JBV(90102063,'jdrodriguez'),
			T_JBV(90102326,'mlopez'),
			T_JBV(90085631,'jdrodriguez'),
			T_JBV(90101421,'jmartinezsa'),
			T_JBV(90101508,'jdrodriguez'),
			T_JBV(90101467,'jdrodriguez'),
			T_JBV(90102364,'mlopez'),
			T_JBV(90102398,'jmartinezsa'),
			T_JBV(90102566,'ebretones'),
			T_JBV(90102546,'mlopez'),
			T_JBV(90102679,'nmuñoz'),
			T_JBV(90102613,'ebretones'),
			T_JBV(90102589,'jdrodriguez'),
			T_JBV(90102772,'mlopez'),
			T_JBV(90102730,'jmartinezsa'),
			T_JBV(90102958,'jdrodriguez'),
			T_JBV(90103028,'ebretones'),
			T_JBV(90103036,'texposito'),
			T_JBV(90103152,'jmartinezsa'),
			T_JBV(90082582,'jmartinezsa'),
			T_JBV(90085254,'jdrodriguez'),
			T_JBV(90085076,'mcozar'),
			T_JBV(90085134,'nmuñoz'),
			T_JBV(90085083,'mlopez'),
			T_JBV(90085467,'nmuñoz'),
			T_JBV(90085447,'nmuñoz'),
			T_JBV(90084617,'ebretones'),
			T_JBV(90084625,'jmartinezsa'),
			T_JBV(90084963,'jdrodriguez'),
			T_JBV(90084709,'nmuñoz'),
			T_JBV(90084409,'jmartinezsa'),
			T_JBV(90084267,'mcozar'),
			T_JBV(90043431,'cbenavides')); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION DESTINATARIO DE LAS TAREAS');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
  	NUMERO_OFERTA := V_TMP_JBV(1);
  	USUARIO := V_TMP_JBV(2);
	
	EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1 
						USING (SELECT TAC.*
								FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
								JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
								JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TRA ON ECO.TBJ_ID = TRA.TBJ_ID AND TRA.BORRADO = 0
								JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE ATR ON ATR.TBJ_ID = TRA.TBJ_ID AND ATR.BORRADO = 0
								JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON ATR.TRA_ID = TAC.TRA_ID AND TAC.BORRADO = 0
								JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID AND TAR.BORRADO = 0
								JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TXT ON TXT.TAR_ID = TAR.TAR_ID AND TXT.BORRADO = 0
								JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TXT.TAP_ID = TAP.TAP_ID AND TAP.BORRADO = 0
								WHERE TAR.TAR_TAREA_FINALIZADA = 0 
								AND OFR.BORRADO = 0
								AND OFR.OFR_NUM_OFERTA = '||NUMERO_OFERTA||') T2
						ON (T1.TAR_ID = T2.TAR_ID AND T1.TRA_ID = T2.TRA_ID)
						WHEN MATCHED THEN UPDATE
						SET T1.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||USUARIO||'''), 
						T1.USUARIOMODIFICAR = ''REMVIP-2874'', 
						T1.FECHAMODIFICAR = SYSDATE';
	
	END LOOP;
	
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] REGISTROS ACTUALIZADOS');
 
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
