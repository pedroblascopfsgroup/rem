--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190305
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3525
--## PRODUCTO=NO
--##
--## Finalidad:  
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-3525'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    ACT_ID NUMBER(16);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
			T_JBV('201489'),
			T_JBV('152847'),
			T_JBV('141145'),
			T_JBV('201490'),
			T_JBV('150394'),
			T_JBV('202299'),
			T_JBV('130518'),
			T_JBV('174458'),
			T_JBV('203292'),
			T_JBV('199943'),
			T_JBV('173802'),
			T_JBV('137835'),
			T_JBV('160400'),
			T_JBV('206697'),
			T_JBV('202297'),
			T_JBV('209278'),
			T_JBV('149434'),
			T_JBV('174599'),
			T_JBV('224384'),
			T_JBV('227203'),
			T_JBV('194126'),
			T_JBV('165728'),
			T_JBV('202759'),
			T_JBV('140117'),
			T_JBV('247370'),
			T_JBV('206700'),
			T_JBV('223364'),
			T_JBV('145920'),
			T_JBV('134842'),
			T_JBV('158634'),
			T_JBV('182783'),
			T_JBV('191372'),
			T_JBV('214066'),
			T_JBV('205640'),
			T_JBV('187927'),
			T_JBV('237379'),
			T_JBV('164607'),
			T_JBV('177801'),
			T_JBV('234652'),
			T_JBV('189089'),
			T_JBV('222897'),
			T_JBV('216846'),
			T_JBV('205412'),
			T_JBV('206701'),
			T_JBV('219951'),
			T_JBV('181083'),
			T_JBV('240230'),
			T_JBV('204476'),
			T_JBV('143126'),
			T_JBV('206695'),
			T_JBV('197269'),
			T_JBV('188069'),
			T_JBV('230497'),
			T_JBV('188180'),
			T_JBV('186624'),
			T_JBV('186625'),
			T_JBV('224319'),
			T_JBV('247462'),
			T_JBV('248697'),
			T_JBV('248539'),
			T_JBV('229721'),
			T_JBV('250479'),
			T_JBV('249477'),
			T_JBV('236165'),
			T_JBV('251984'),
			T_JBV('242979'),
			T_JBV('312671'),
			T_JBV('218278'),
			T_JBV('218272'),
			T_JBV('218243'),
			T_JBV('218274'),
			T_JBV('218265'),
			T_JBV('218246'),
			T_JBV('218280'),
			T_JBV('218260'),
			T_JBV('218275'),
			T_JBV('218269'),
			T_JBV('218258'),
			T_JBV('218239'),
			T_JBV('218249'),
			T_JBV('218254'),
			T_JBV('218253'),
			T_JBV('218279'),
			T_JBV('218244'),
			T_JBV('218267'),
			T_JBV('218257'),
			T_JBV('218273'),
			T_JBV('218277'),
			T_JBV('218276'),
			T_JBV('218264'),
			T_JBV('218263'),
			T_JBV('218281'),
			T_JBV('218262'),
			T_JBV('218261'),
			T_JBV('218252'),
			T_JBV('218255'),
			T_JBV('218266'),
			T_JBV('218238'),
			T_JBV('218251'),
			T_JBV('218241'),
			T_JBV('218240'),
			T_JBV('218259'),
			T_JBV('218247'),
			T_JBV('218202'),
			T_JBV('218303'),
			T_JBV('218250'),
			T_JBV('218285'),
			T_JBV('218256'),
			T_JBV('218289'),
			T_JBV('218290'),
			T_JBV('218293'),
			T_JBV('218304'),
			T_JBV('218283'),
			T_JBV('218307'),
			T_JBV('218294'),
			T_JBV('218305'),
			T_JBV('218295'),
			T_JBV('218306'),
			T_JBV('218297'),
			T_JBV('218302'),
			T_JBV('218286'),
			T_JBV('218308'),
			T_JBV('218284'),
			T_JBV('218298'),
			T_JBV('218287'),
			T_JBV('218300'),
			T_JBV('218299'),
			T_JBV('218282'),
			T_JBV('218288'),
			T_JBV('302261'),
			T_JBV('313166'),
			T_JBV('312047'),
			T_JBV('295926'),
			T_JBV('316799'),
			T_JBV('312591'),
			T_JBV('283631'),
			T_JBV('286270'),
			T_JBV('286853'),
			T_JBV('280922'),
			T_JBV('282167'),
			T_JBV('288580'),
			T_JBV('276598'),
			T_JBV('281898'),
			T_JBV('289339'),
			T_JBV('297879'),
			T_JBV('296380')
			); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION ');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	ACT_ID := TRIM(V_TMP_JBV(1));
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_ID = '||ACT_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 1 THEN

	  	V_SQL := 'BEGIN '||V_ESQUEMA||'.SP_ASC_ACTUALIZA_SIT_COMERCIAL('||ACT_ID||',1); END;';
	   
	  	EXECUTE IMMEDIATE V_SQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON ACT_ID: '||ACT_ID||' ACTUALIZADO');
		
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
