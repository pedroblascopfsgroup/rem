--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20200228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6525
--## PRODUCTO=NO
--## 
--## Finalidad: Script que añade en ACT_PLS_PLUSVALIA los datos añadidos en la tabla temporal TMP_ACT_PLS_PLUSVALIA_REMVIP_6525
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
	V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_TABLA_PLS VARCHAR2(25 CHAR):= 'ACT_PLS_PLUSVALIA';
	V_COUNT NUMBER(16); -- Vble. para contar.
	V_KOUNT NUMBER(16); -- Vble. para kontar.
	V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	DATO_ACT_ID NUMBER(16);
	DATO_GPV_ID NUMBER(16);
	DATO_SEGUIMIENTO NUMBER(16);
	DATO_MINUSVALIA NUMBER(16);
	DATO_EXENTO NUMBER(16);
	DATO_AUTOLIQUIDACION NUMBER(16);
	DATO_PLUSVALIA_ID NUMBER(16);
	
	NUM_SECUENCIA_VAL NUMBER(16);
	CON_ERRORES VARCHAR2(25 CHAR);
	
	
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6525';    
    
   ----------------------------------
	CURSOR CPOS IS 
		SELECT DISTINCT ACT_NUM_ACTIVO,
						FECHA_RECEPCION_PLUSVALIA, 
						FECHA_PRESENTACION_PLUSVALIA, 
						FECHA_PRESENTACION_RECURSO, 
						FECHA_RESPUESTA_RECURSO, 
						APERTURA_SEGUIMIENTO_EXPEDIENTE, 
						IMPORTE_PAGADO_PLUSVALIA, 
						GASTO_ASOCIADO,
						MINUSVALIA, 
						EXENTO, 
						AUTOLIQUIDACION
	FROM #ESQUEMA#.TMP_ACT_PLS_PLUSVALIA_REMVIP_6525;
   ----------------------------------
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
		
    FOR NCP IN CPOS LOOP
    
		--############################################
		--## VALIDACIONES PREVIAS A LA CARGA MASIVA ##
		--############################################
    
    	CON_ERRORES := 'N';
    	DATO_GPV_ID := -1;
    	
    	--------------------COMPROBACIÓN SI EXISTE ACTIVO------------------------------------------------------------------------------------------------
    	DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBANDO QUE EXISTE EL ACTIVO ' || NCP.ACT_NUM_ACTIVO);
    	
    	EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE BORRADO = 0 AND ACT_NUM_ACTIVO = '||NCP.ACT_NUM_ACTIVO INTO V_COUNT;
    	
    	IF V_COUNT = 1 THEN
    		EXECUTE IMMEDIATE 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||NCP.ACT_NUM_ACTIVO INTO DATO_ACT_ID;  
    	ELSE
    		CON_ERRORES := 'S';
    		DBMS_OUTPUT.PUT_LINE('[ERROR] NO SE HA ENCONTRADO EL ACTIVO ' || NCP.ACT_NUM_ACTIVO);
    	END IF;
    	-------------------------------------------------------------------------------------------------------------------------------------------------
    	
    	--------------------COMPROBACIÓN SI EL ACTIVO PERTENECE A UNA UA---------------------------------------------------------------------------------
    	DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBANDO SI EL ACTIVO ' || NCP.ACT_NUM_ACTIVO || ' PERTENECE A UNA UA');
    	EXECUTE IMMEDIATE 'SELECT COUNT(*)
							FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
							LEFT JOIN '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO TTA ON TTA.DD_TTA_ID = ACT.DD_TTA_ID
							WHERE TTA.DD_TTA_CODIGO = ''05''
							AND ACT.ACT_NUM_ACTIVO = '||NCP.ACT_NUM_ACTIVO INTO V_COUNT;
							 
    	
    	IF V_COUNT <> 0 THEN
    		CON_ERRORES := 'S';
    		DBMS_OUTPUT.PUT_LINE('[ERROR] EL ACTIVO ' || NCP.ACT_NUM_ACTIVO || ' PERTENECE A UNA UA');
    	END IF;
    	-------------------------------------------------------------------------------------------------------------------------------------------------
    	
    	--------------------COMPROBACIÓN SI EXISTE EL GASTO ASOCIADO-------------------------------------------------------------------------------------
    	DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBANDO SI EXISTE EL GASTO ASOCIADO ' || NCP.GASTO_ASOCIADO);
    	IF NCP.GASTO_ASOCIADO IS NOT NULL THEN
    		V_COUNT := 0;
	    	EXECUTE IMMEDIATE 'SELECT COUNT(*)
								FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR 
								WHERE GPV_NUM_GASTO_HAYA = '|| NCP.GASTO_ASOCIADO ||' 
								AND BORRADO = 0' INTO V_COUNT;
    	END IF;
						
    	IF V_COUNT = 1 THEN
    		EXECUTE IMMEDIATE 'SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '||NCP.GASTO_ASOCIADO||' AND BORRADO = 0' INTO DATO_GPV_ID; 
    	ELSIF NCP.GASTO_ASOCIADO IS NOT NULL THEN
    		CON_ERRORES := 'S';
    		DBMS_OUTPUT.PUT_LINE('[ERROR] NO SE HA ENCONTRADO EL GASTO ASOCIADO ' || NCP.GASTO_ASOCIADO);
    	END IF;
    	-------------------------------------------------------------------------------------------------------------------------------------------------
    	
    	--------------------COMPROBACIÓN APERTURA EXPEDIENTE---------------------------------------------------------------------------------------------
    	DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBANDO FORMATO DEL CAMPO APERTURA_SEGUIMIENTO_EXPEDIENTE');
    	IF NCP.APERTURA_SEGUIMIENTO_EXPEDIENTE = 'S' OR NCP.APERTURA_SEGUIMIENTO_EXPEDIENTE = 'N' THEN
    		EXECUTE IMMEDIATE 'SELECT DD_SIN_ID
								FROM '||V_ESQUEMA_M||'.DD_SIN_SINO 
								WHERE DD_SIN_CODIGO = DECODE('''|| NCP.APERTURA_SEGUIMIENTO_EXPEDIENTE ||''', ''S'', ''01'',
																									  		  ''N'', ''02'')
								AND BORRADO = 0' INTO DATO_SEGUIMIENTO;		
    	ELSE
    		CON_ERRORES := 'S';
    		DBMS_OUTPUT.PUT_LINE('[ERROR] FORMATO INCORRECTO DEL CAMPO APERTURA_SEGUIMIENTO_EXPEDIENTE');
    	END IF;
    	-------------------------------------------------------------------------------------------------------------------------------------------------
    	
    		
    	--------------------COMPROBACIÓN MINUSVALIA------------------------------------------------------------------------------------------------------
    	DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBANDO FORMATO DEL CAMPO MINUSVALIA');
    	IF NCP.MINUSVALIA = 'S' OR NCP.MINUSVALIA = 'N' THEN
    		EXECUTE IMMEDIATE 'SELECT DD_SIN_ID
								FROM '||V_ESQUEMA_M||'.DD_SIN_SINO 
								WHERE DD_SIN_CODIGO = DECODE('''|| NCP.MINUSVALIA ||''', ''S'', ''01'',
																			  			 ''N'', ''02'')
								AND BORRADO = 0' INTO DATO_MINUSVALIA;		
    	ELSE
    		CON_ERRORES := 'S';
    		DBMS_OUTPUT.PUT_LINE('[ERROR] FORMATO INCORRECTO DEL CAMPO MINUSVALIA');
    	END IF;
    	-------------------------------------------------------------------------------------------------------------------------------------------------
    	
    	--------------------COMPROBACIÓN EXENTO----------------------------------------------------------------------------------------------------------
	    	DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBANDO FORMATO DEL CAMPO EXENTO');
			IF NCP.EXENTO = 'S' OR NCP.EXENTO = 'N' THEN
    		EXECUTE IMMEDIATE 'SELECT DD_SIN_ID
								FROM '||V_ESQUEMA_M||'.DD_SIN_SINO 
								WHERE DD_SIN_CODIGO = DECODE('''|| NCP.EXENTO ||''', ''S'', ''01'',
																			  	 	 ''N'', ''02'')
								AND BORRADO = 0' INTO DATO_EXENTO;		
    	ELSE
    		CON_ERRORES := 'S';
    		DBMS_OUTPUT.PUT_LINE('[ERROR] FORMATO INCORRECTO DEL CAMPO EXENTO');
    	END IF;
    	-------------------------------------------------------------------------------------------------------------------------------------------------
    	
    	--------------------COMPROBACIÓN AUTOLIQUIDACION-------------------------------------------------------------------------------------------------
    	DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBANDO FORMATO DEL CAMPO AUTOLIQUIDACION');
    	IF NCP.AUTOLIQUIDACION = 'S' OR NCP.AUTOLIQUIDACION = 'N' THEN
    		EXECUTE IMMEDIATE 'SELECT DD_SIN_ID
								FROM '||V_ESQUEMA_M||'.DD_SIN_SINO 
								WHERE DD_SIN_CODIGO = DECODE('''|| NCP.AUTOLIQUIDACION ||''', ''S'', ''01'',
																						  	  ''N'', ''02'')
								AND BORRADO = 0' INTO DATO_AUTOLIQUIDACION;		
    	ELSE
    		CON_ERRORES := 'S';
    		DBMS_OUTPUT.PUT_LINE('[ERROR] FORMATO INCORRECTO DEL CAMPO AUTOLIQUIDACION');
    	END IF;
    	-------------------------------------------------------------------------------------------------------------------------------------------------
    	
    	   	  	
    	
    	--########################
		--## PROCESADO DE DATOS ##
		--########################
    	
    	--------------------COMPROBACIÓN SI EXISTE LA PLUSVALIA------------------------------------------------------------------------------------------
    	EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TABLA_PLS||' WHERE BORRADO = 0 AND ACT_ID = '||DATO_ACT_ID INTO V_COUNT;
    	    	
    	--------------------SI EXISTE LA PLUSVALIA Y NO HAY ERRORES DE VALIDACION, UPDATEAMOS------------------------------------------------------------
    	IF V_COUNT = 1 AND CON_ERRORES = 'N' THEN
    		DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO DATOS DE PLUSVALIA DEL ACTIVO ' ||NCP.ACT_NUM_ACTIVO);
	    	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_PLS||'
						SET
							ACT_PLS_FECHA_RECEPCION_PLUSVALIA 		= 	TO_DATE('''||NCP.FECHA_RECEPCION_PLUSVALIA||''', ''DD/MM/YYYY''), 
							ACT_PLS_FECHA_PRESENTACION_PLUSVALIA 	= 	TO_DATE('''||NCP.FECHA_PRESENTACION_PLUSVALIA||''', ''DD/MM/YYYY''),
							ACT_PLS_FECHA_PRESENTACION_RECURSO 		= 	TO_DATE('''||NCP.FECHA_PRESENTACION_RECURSO||''', ''DD/MM/YYYY''),
							ACT_PLS_FECHA_RESPUESTA_RECURSO 		= 	TO_DATE('''||NCP.FECHA_RESPUESTA_RECURSO||''', ''DD/MM/YYYY''),
							ACT_PLS_EXENTO 							= 	'|| DATO_EXENTO ||',
							ACT_PLS_AUTOLIQUIDACION 				= 	'|| DATO_AUTOLIQUIDACION ||',
							ACT_PLS_APERTURA_Y_SEGUIMIENTO_EXP 		= 	'|| DATO_SEGUIMIENTO ||',
							ACT_PLS_MINUSVALIA 						= 	'|| DATO_MINUSVALIA ||',
							ACT_PLS_IMPORTE_PAGADO 					= 	TO_NUMBER(REPLACE('''|| NCP.IMPORTE_PAGADO_PLUSVALIA ||''', '','', ''.'' ), ''99999999.99''),
							GPV_ID 									=	DECODE('|| DATO_GPV_ID ||', -1, NULL, '|| DATO_GPV_ID ||'),
							FECHAMODIFICAR							= 	SYSDATE,
							USUARIOMODIFICAR						= 	'''|| V_USUARIO ||'''
						WHERE ACT_ID = '|| DATO_ACT_ID ||'
						AND BORRADO = 0';
			EXECUTE IMMEDIATE V_SQL;
    	
    	--------------------SI NO EXISTE LA PLUSVALIA Y NO HAY ERRORES DE VALIDACION, INSERTAMOS---------------------------------------------------------
    	ELSIF V_COUNT = 0 AND CON_ERRORES = 'N' THEN
    		DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO DATOS NUEVOS DE PLUSVALIA DEL ACTIVO ' ||NCP.ACT_NUM_ACTIVO);
    		EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_'||V_TABLA_PLS||'.NEXTVAL FROM DUAL' INTO DATO_PLUSVALIA_ID;
    		
	    	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_PLS||'
						(
							ACT_PLS_ID,
							ACT_ID, 
							ACT_PLS_FECHA_RECEPCION_PLUSVALIA, 
							ACT_PLS_FECHA_PRESENTACION_PLUSVALIA, 
							ACT_PLS_FECHA_PRESENTACION_RECURSO, 
							ACT_PLS_FECHA_RESPUESTA_RECURSO,
							ACT_PLS_EXENTO,
							ACT_PLS_AUTOLIQUIDACION,
							ACT_PLS_APERTURA_Y_SEGUIMIENTO_EXP,
							ACT_PLS_MINUSVALIA,
							ACT_PLS_IMPORTE_PAGADO,
							GPV_ID,
							FECHACREAR, 
							USUARIOCREAR, 
							VERSION, 
							BORRADO
						)
					  	SELECT '|| DATO_PLUSVALIA_ID ||',
								'|| DATO_ACT_ID ||',
								TO_DATE('''||NCP.FECHA_RECEPCION_PLUSVALIA||''', ''DD/MM/YYYY''),
								TO_DATE('''||NCP.FECHA_PRESENTACION_PLUSVALIA||''', ''DD/MM/YYYY''),
								TO_DATE('''||NCP.FECHA_PRESENTACION_RECURSO||''', ''DD/MM/YYYY''),
								TO_DATE('''||NCP.FECHA_RESPUESTA_RECURSO||''', ''DD/MM/YYYY''),
								'|| DATO_EXENTO ||',
								'|| DATO_AUTOLIQUIDACION ||',
								'|| DATO_SEGUIMIENTO ||',
								'|| DATO_MINUSVALIA ||',
								TO_NUMBER(REPLACE('''|| NCP.IMPORTE_PAGADO_PLUSVALIA ||''', '','', ''.'' ), ''99999999.99''),
								DECODE('|| DATO_GPV_ID ||', -1, NULL, '|| DATO_GPV_ID ||'),
								SYSDATE,
								'''|| V_USUARIO ||''',
								0,
								0
					  	FROM DUAL';
			EXECUTE IMMEDIATE V_SQL;
    	
    	--------------------EN CASO CONTRARIO, NO HACEMOS NADA-------------------------------------------------------------------------------------------
    	ELSE
    		DBMS_OUTPUT.PUT_LINE('[INFO] NO SE PROCESARÁ EL ACTIVO ' || NCP.ACT_NUM_ACTIVO || ' DEBIDO A ERRORES');
    	END IF;
    	-------------------------------------------------------------------------------------------------------------------------------------------------
    	
    END LOOP;
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[OK] DATOS PROCESADOS CORRECTAMENTE');
    
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
