--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190411
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3987
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-3987'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    ACT_ID NUMBER(16);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
			T_JBV('174049'),
			T_JBV('213500'),
			T_JBV('173752'),
			T_JBV('130518'),
			T_JBV('174458'),
			T_JBV('230356'),
			T_JBV('233648'),
			T_JBV('208106'),
			T_JBV('174599'),
			T_JBV('199095'),
			T_JBV('183584'),
			T_JBV('245195'),
			T_JBV('210967'),
			T_JBV('173999'),
			T_JBV('143843'),
			T_JBV('237608'),
			T_JBV('245595'),
			T_JBV('188251'),
			T_JBV('209263'),
			T_JBV('234652'),
			T_JBV('236893'),
			T_JBV('205412'),
			T_JBV('187884'),
			T_JBV('241811'),
			T_JBV('219951'),
			T_JBV('220295'),
			T_JBV('135108'),
			T_JBV('143126'),
			T_JBV('231631'),
			T_JBV('173998'),
			T_JBV('247704'),
			T_JBV('221104'),
			T_JBV('247462'),
			T_JBV('244206'),
			T_JBV('252915'),
			T_JBV('252720'),
			T_JBV('253376'),
			T_JBV('259064'),
			T_JBV('293096'),
			T_JBV('293449'),
			T_JBV('293397'),
			T_JBV('326394'),
			T_JBV('293315'),
			T_JBV('293043'),
			T_JBV('283631'),
			T_JBV('293154'),
			T_JBV('292874'),
			T_JBV('293242'),
			T_JBV('293321'),
			T_JBV('286270'),
			T_JBV('286853'),
			T_JBV('280922'),
			T_JBV('293194'),
			T_JBV('282167'),
			T_JBV('293599'),
			T_JBV('293296'),
			T_JBV('292954'),
			T_JBV('293086'),
			T_JBV('293310'),
			T_JBV('293214'),
			T_JBV('288580'),
			T_JBV('293402'),
			T_JBV('293153'),
			T_JBV('293399'),
			T_JBV('293174'),
			T_JBV('293029'),
			T_JBV('293686'),
			T_JBV('293151'),
			T_JBV('293653'),
			T_JBV('293610'),
			T_JBV('293696'),
			T_JBV('293445'),
			T_JBV('276598'),
			T_JBV('293666'),
			T_JBV('293511'),
			T_JBV('293193'),
			T_JBV('281898'),
			T_JBV('289339'),
			T_JBV('293304'),
			T_JBV('293130'),
			T_JBV('293444')
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
