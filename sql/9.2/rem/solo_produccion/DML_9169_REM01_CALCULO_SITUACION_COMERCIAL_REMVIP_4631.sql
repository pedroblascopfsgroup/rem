--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190625
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4631
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
			T_JBV('3625'),
			T_JBV('150126'),
/*
			T_JBV('238383'),
			T_JBV('207496'),
			T_JBV('219688'),
			T_JBV('223702'),
			T_JBV('191243'),
			T_JBV('222212'),
			T_JBV('207955'),
			T_JBV('238770'),
			T_JBV('166351'),
			T_JBV('243183'),
			T_JBV('303095'),
			T_JBV('323116'),
			T_JBV('323143'),
			T_JBV('314361'),
			T_JBV('312812'),
			T_JBV('316796'),
			T_JBV('312404'),
			T_JBV('322411'),
			T_JBV('299377'),
			T_JBV('322613'),
			T_JBV('322410'),
			T_JBV('298518'),
			T_JBV('308284'),
			T_JBV('298299'),
			T_JBV('299982'),
			T_JBV('299376'),
			T_JBV('299378'),
			T_JBV('295905'),
			T_JBV('313044'),
			T_JBV('304522'),
			T_JBV('309378'),
			T_JBV('304375'),
			T_JBV('305358'),
			T_JBV('320028'),
			T_JBV('309092'),
			T_JBV('276403'),
			T_JBV('281598'),
			T_JBV('304359'),
			T_JBV('304065'),
			T_JBV('332542'),
			T_JBV('342703'),
			T_JBV('346228'),
			T_JBV('345247'),
			T_JBV('345859'),
			T_JBV('349573'),*/
			T_JBV('353154')
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
