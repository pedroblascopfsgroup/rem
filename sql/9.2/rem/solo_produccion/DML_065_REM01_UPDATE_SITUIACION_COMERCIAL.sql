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
			T_JBV('244734'),
			T_JBV('239398'),
			T_JBV('279550'),
			T_JBV('288269'),
			T_JBV('242974'),
			T_JBV('247233'),
			T_JBV('247234'),
			T_JBV('215696'),
			T_JBV('225217'),
			T_JBV('218055'),
			T_JBV('223502'),
			T_JBV('237151'),
			T_JBV('158582'),
			T_JBV('160512'),
			T_JBV('165651'),
			T_JBV('235228'),
			T_JBV('253220'),
			T_JBV('288469'),
			T_JBV('168854'),
			T_JBV('149104'),
			T_JBV('235886'),
			T_JBV('293245'),
			T_JBV('281399'),
			T_JBV('168727'),
			T_JBV('209130'),
			T_JBV('247225'),
			T_JBV('158674'),
			T_JBV('248210'),
			T_JBV('212998'),
			T_JBV('287354'),
			T_JBV('247165'),
			T_JBV('290804'),
			T_JBV('162398'),
			T_JBV('225132'),
			T_JBV('158821'),
			T_JBV('222663'),
			T_JBV('132509'),
			T_JBV('159502'),
			T_JBV('159394'),
			T_JBV('265573'),
			T_JBV('265574'),
			T_JBV('265576'),
			T_JBV('265577'),
			T_JBV('265566'),
			T_JBV('265572'),
			T_JBV('265559'),
			T_JBV('265556'),
			T_JBV('265575'),
			T_JBV('125333'),
			T_JBV('145112'),
			T_JBV('212996'),
			T_JBV('213024'),
			T_JBV('212972'),
			T_JBV('238593'),
			T_JBV('209663'),
			T_JBV('166428'),
			T_JBV('232342'),
			T_JBV('239526'),
			T_JBV('213579'),
			T_JBV('153507'),
			T_JBV('171910'),
			T_JBV('137171'),
			T_JBV('242282'),
			T_JBV('262779'),
			T_JBV('207549'),
			T_JBV('277329'),
			T_JBV('161092')
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
