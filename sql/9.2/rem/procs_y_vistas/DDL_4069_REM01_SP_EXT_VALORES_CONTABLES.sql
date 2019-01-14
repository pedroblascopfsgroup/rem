--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180620
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.19
--## INCIDENCIA_LINK=HREOS-4197
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Control de errores en HLP_HISTORICO_LANZA_PERIODICO
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE #ESQUEMA#.SP_EXT_VALORES_CONTABLES ( 
         ID_ACTIVO_HAYA IN  #ESQUEMA#.ACT_ACTIVO.ACT_NUM_ACTIVO%TYPE
       , TIPO_PRECIO    IN  #ESQUEMA#.DD_TPC_TIPO_PRECIO.DD_TPC_CODIGO%TYPE
	   , IMPORTE        IN  #ESQUEMA#.ACT_VAL_VALORACIONES.VAL_IMPORTE%TYPE
       , COD_RETORNO    OUT NUMBER
) AS


V_MSQL VARCHAR2(32000 CHAR); 											-- Sentencia a ejecutar.      
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 								-- Configuracion Esquema.
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 					-- Configuracion Esquema Master.
ERR_NUM NUMBER(25); 													-- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); 											-- Vble. auxiliar para registrar errores en el script.
V_TABLA VARCHAR2 (50 CHAR);
V_COUNT NUMBER(1);
V_RESULTADO VARCHAR2(50 CHAR);
V_NOMBRESP VARCHAR2(50 CHAR) := 'SP_EXT_VALORES_CONTABLES';				-- Nombre del SP.
HLP_REGISTRO_EJEC VARCHAR2(1024 CHAR) := ''; 	
V_NOTABLES NUMBER(1) := 0;												-- Comprueba si existen las tablas HLD y HLP		
V_NUMREGISTROS NUMBER(25) := 0;											-- Vble. auxiliar que guarda el número de registros actualizados	
V_NEXTVAL INTEGER;
V_VALID NUMBER(16,0);

BEGIN

   COD_RETORNO := 0;
   
   /*****************************************************************   
   1.- Miramos que los 3 parámetros obligatorios del SP vengan informados
   ******************************************************************/
   IF COD_RETORNO = 0 AND ID_ACTIVO_HAYA IS NULL THEN 
		HLP_REGISTRO_EJEC := '[ERROR] El ID_ACTIVO_HAYA indicado como parámetro de entrada no se ha ingresado. Por favor ingrese un valor para este campo.';
		COD_RETORNO := 1;
   END IF;   
   IF COD_RETORNO = 0 AND TIPO_PRECIO IS NULL THEN 
		HLP_REGISTRO_EJEC := '[ERROR] El TIPO_PRECIO indicado como parámetro de entrada no se ha ingresado. Por favor ingrese un valor para este campo.';
		COD_RETORNO := 1;
   END IF;   
   IF COD_RETORNO = 0 AND IMPORTE IS NULL THEN 
		HLP_REGISTRO_EJEC := '[ERROR] El IMPORTE indicado como parámetro de entrada no se ha ingresado. Por favor ingrese un valor para este campo.';
		COD_RETORNO := 1;
   END IF;
   
   /*****************************************************************   
   2.- Miramos que el activo y el tipo de precio pasados por parámetro existan.
   ******************************************************************/  
   IF COD_RETORNO = 0 THEN 
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA;
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		IF V_COUNT < 1 THEN
				HLP_REGISTRO_EJEC := '[ERROR] El activo ['||ID_ACTIVO_HAYA||'] no existe en la tabla ACT_ACTIVO.';
				COD_RETORNO := 1;
		END IF;
   END IF; 
   IF COD_RETORNO = 0 THEN 
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC WHERE TPC.DD_TPC_CODIGO = '''||TIPO_PRECIO||''' ';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		IF V_COUNT < 1 THEN
				HLP_REGISTRO_EJEC := '[ERROR] El tipo de precio con código ['||TIPO_PRECIO||'] no existe en la tabla DD_TPC_TIPO_PRECIO.';
				COD_RETORNO := 1;
		END IF;
   END IF;
   
   /*****************************************************************   
   3.- Comprobamos que las tablas donde vamos a escribir (HLP y HLD) existan.
   ******************************************************************/   
   IF COD_RETORNO = 0 THEN 
        V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME IN (''HLP_HISTORICO_LANZA_PERIODICO'',''HLD_HISTORICO_LANZA_PER_DETA'') AND OWNER LIKE '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

        IF V_COUNT > 1 AND COD_RETORNO = 0 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO] Existen las tablas HLP_HISTORICO_LANZA_PERIODICO y HLD_HISTORICO_LANZA_PER_DETA. Continuamos la ejecución.');
        ELSE          
            HLP_REGISTRO_EJEC := '[ERROR] NO existe la tabla HLP_HISTORICO_LANZA_PERIODICO ó HLD_HISTORICO_LANZA_PER_DETA. O no existen ambas. Paramos la ejecución.';
            DBMS_OUTPUT.PUT_LINE(HLP_REGISTRO_EJEC);
            COD_RETORNO := 1;
            V_NOTABLES := 1;
        END IF;
   END IF;
   
   
   /*****************************************************************   
   4.- 
     4.1.-  Insertamos en la HVA la valoración que hubiera en la VAL para ese (ACT_ID,DD_TPC_ID).
     4.2.-  Insertamos en la HLD si se han actualizado/insertado datos de la VAL en el punto anterior.
   ******************************************************************/   
   IF COD_RETORNO = 0 AND V_NOTABLES = 0 THEN
	   V_MSQL := '
			SELECT COUNT(1)                                 			
			FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES  VAL
			JOIN '||V_ESQUEMA||'.ACT_ACTIVO            ACT
			  ON VAL.ACT_ID = ACT.ACT_ID
			JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO    TPC
			  ON VAL.DD_TPC_ID = TPC.DD_TPC_ID
			WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'
			  AND TPC.DD_TPC_CODIGO = '''||TIPO_PRECIO||'''
			  AND ACT.BORRADO = 0
			  AND VAL.BORRADO = 0';
	   EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
   END IF;
   
   --Si la Valoracion (ACT_ID, DD_TPC_ID) ya existe en la ACT_VAL_VALORACIONES, la guardamos en el histórico.
   IF COD_RETORNO = 0 AND V_NOTABLES = 0 AND V_COUNT = 1 THEN        
        
        V_MSQL := 'SELECT '||V_ESQUEMA||'.S_ACT_HVA_HIST_VALORACIONES.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_NEXTVAL;
             
        V_MSQL := '
		INSERT INTO '||V_ESQUEMA||'.ACT_HVA_HIST_VALORACIONES HVA
		(
			HVA_ID, 
			ACT_ID, 
			DD_TPC_ID, 
			HVA_IMPORTE, 
			HVA_FECHA_INICIO, 
			HVA_FECHA_FIN, 
			HVA_OBSERVACIONES,
			USU_ID,
			USUARIOCREAR, 
			FECHACREAR
		)
		SELECT '||V_NEXTVAL||'									     AS HVA_ID,
			   VAL.ACT_ID                                			 AS ACT_ID,
			   VAL.DD_TPC_ID                            			 AS DD_TPC_ID,
			   VAL.VAL_IMPORTE                           			 AS HVA_IMPORTE,
			   VAL.VAL_FECHA_INICIO                      			 AS HVA_FECHA_INICIO,
			   SYSDATE                                   			 AS HVA_FECHA_FIN,
			   VAL.VAL_OBSERVACIONES                     			 AS HVA_OBSERVACIONES,
			   VAL.USU_ID										     AS USU_ID,
			   '''||V_NOMBRESP||'''                      			 AS USUARIOCREAR, 
			   SYSDATE                                   			 AS FECHACREAR
		FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES  VAL
		JOIN '||V_ESQUEMA||'.ACT_ACTIVO            ACT
		  ON VAL.ACT_ID = ACT.ACT_ID
		JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO    TPC
		  ON VAL.DD_TPC_ID = TPC.DD_TPC_ID
		WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'
		  AND TPC.DD_TPC_CODIGO = '''||TIPO_PRECIO||'''
		  AND ACT.BORRADO = 0
		  AND VAL.BORRADO = 0
		'; 
        EXECUTE IMMEDIATE V_MSQL;
        V_NUMREGISTROS := SQL%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE('[INFO] - Se inserta '||V_NUMREGISTROS||' registro en la ACT_HVA_HIST_VALORACIONES.');
		
		IF V_NUMREGISTROS > 0 THEN
			V_MSQL := '
			INSERT INTO '||V_ESQUEMA||'.HLD_HISTORICO_LANZA_PER_DETA (
			  HLD_SP_CARGA,
			  HLD_FECHA_EJEC,
			  HLD_CODIGO_REG,
			  HLD_TABLA_MODIFICAR,
			  HLD_TABLA_MODIFICAR_CLAVE,
			  HLD_TABLA_MODIFICAR_CLAVE_ID,
			  HLD_CAMPO_MODIFICAR,
			  HLD_VALOR_ORIGINAL,
			  HLD_VALOR_ACTUALIZADO
			)
			SELECT '''||V_NOMBRESP||''', SYSDATE, TO_NUMBER('''||ID_ACTIVO_HAYA||'''), ''ACT_HVA_HIST_VALORACIONES'', ''HVA_ID'',  TO_NUMBER('''||V_NEXTVAL||'''), ''HVA_ID'', NULL, TO_CHAR('''||V_NEXTVAL||''') FROM DUAL
			UNION ALL
			SELECT '''||V_NOMBRESP||''', SYSDATE, TO_NUMBER('''||ID_ACTIVO_HAYA||'''), ''ACT_HVA_HIST_VALORACIONES'', ''HVA_ID'',  TO_NUMBER('''||V_NEXTVAL||'''), ''ACT_ID'', NULL, TO_CHAR((SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||')) FROM DUAL
			UNION ALL
			SELECT '''||V_NOMBRESP||''', SYSDATE, TO_NUMBER('''||ID_ACTIVO_HAYA||'''), ''ACT_HVA_HIST_VALORACIONES'', ''HVA_ID'',  TO_NUMBER('''||V_NEXTVAL||'''), ''DD_TPC_ID'', NULL, TO_CHAR((SELECT TPC.DD_TPC_ID FROM '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC WHERE TPC.DD_TPC_CODIGO = '''||TIPO_PRECIO||''')) FROM DUAL
			UNION ALL
			SELECT '''||V_NOMBRESP||''', SYSDATE, TO_NUMBER('''||ID_ACTIVO_HAYA||'''), ''ACT_HVA_HIST_VALORACIONES'', ''HVA_ID'',  TO_NUMBER('''||V_NEXTVAL||'''), ''HVA_IMPORTE'', NULL, TO_CHAR(VAL.VAL_IMPORTE)                                 			
		    FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES  VAL JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON VAL.ACT_ID = ACT.ACT_ID JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID
			WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||' AND TPC.DD_TPC_CODIGO = '''||TIPO_PRECIO||''' AND ACT.BORRADO = 0 AND VAL.BORRADO = 0
			UNION ALL
			SELECT '''||V_NOMBRESP||''', SYSDATE, TO_NUMBER('''||ID_ACTIVO_HAYA||'''), ''ACT_HVA_HIST_VALORACIONES'', ''HVA_ID'',  TO_NUMBER('''||V_NEXTVAL||'''), ''HVA_FECHA_INICIO'', NULL, TO_CHAR(VAL.VAL_FECHA_INICIO)                                 			
		    FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES  VAL JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON VAL.ACT_ID = ACT.ACT_ID JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID
			WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||' AND TPC.DD_TPC_CODIGO = '''||TIPO_PRECIO||''' AND ACT.BORRADO = 0 AND VAL.BORRADO = 0
			';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] - Se insertan '||SQL%ROWCOUNT||' registros en la HLD_HISTORICO_LANZA_PER_DETA.');
        END IF;
        
   END IF;   
        
        
   /*****************************************************************   
   5.- 
     5.1.-  Insertamos en la VAL la valoración que hubiera en la VAL para ese (ACT_ID,DD_TPC_ID).
     5.2.-  Insertamos en la HLD si se han actualizado datos de la VAL en el punto anterior.
   ******************************************************************/        
   IF COD_RETORNO = 0 AND V_NOTABLES = 0 THEN             
        
        --Si la Valoracion (ACT_ID, DD_TPC_ID) ya existe en la ACT_VAL_VALORACIONES, la actualizamos.
        IF V_COUNT = 1 THEN        
			 V_MSQL := 'SELECT VAL.VAL_ID 
						FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES  VAL
						JOIN '||V_ESQUEMA||'.ACT_ACTIVO            ACT
						  ON VAL.ACT_ID = ACT.ACT_ID
						JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO    TPC
						  ON VAL.DD_TPC_ID = TPC.DD_TPC_ID
						WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'
						  AND TPC.DD_TPC_CODIGO = '''||TIPO_PRECIO||'''
						  AND ACT.BORRADO = 0
						  AND VAL.BORRADO = 0
					   ';
			 EXECUTE IMMEDIATE V_MSQL INTO V_VALID;
			
			 V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.HLD_HISTORICO_LANZA_PER_DETA (
						  HLD_SP_CARGA,
						  HLD_FECHA_EJEC,
						  HLD_CODIGO_REG,
						  HLD_TABLA_MODIFICAR,
						  HLD_TABLA_MODIFICAR_CLAVE,
						  HLD_TABLA_MODIFICAR_CLAVE_ID,
						  HLD_CAMPO_MODIFICAR,
						  HLD_VALOR_ORIGINAL,
						  HLD_VALOR_ACTUALIZADO
						)
						SELECT '''||V_NOMBRESP||''', SYSDATE, TO_NUMBER('''||ID_ACTIVO_HAYA||'''), ''ACT_VAL_VALORACIONES'', ''VAL_ID'',  TO_NUMBER('''||V_VALID||'''), ''VAL_IMPORTE'', TO_CHAR((SELECT VAL.VAL_IMPORTE FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL WHERE VAL.VAL_ID = '||V_VALID||')), TO_CHAR('''||IMPORTE||''') FROM DUAL
						UNION ALL
						SELECT '''||V_NOMBRESP||''', SYSDATE, TO_NUMBER('''||ID_ACTIVO_HAYA||'''), ''ACT_VAL_VALORACIONES'', ''VAL_ID'',  TO_NUMBER('''||V_VALID||'''), ''VAL_FECHA_INICIO'', TO_CHAR((SELECT VAL.VAL_FECHA_INICIO FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL WHERE VAL.VAL_ID = '||V_VALID||')), TO_CHAR(SYSDATE) FROM DUAL
					   ';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] - Se insertan '||SQL%ROWCOUNT||' registros en la HLD_HISTORICO_LANZA_PER_DETA.');
						
			V_MSQL := ' UPDATE '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL
						SET
							VAL.VAL_IMPORTE = '''||IMPORTE||''',
							VAL.VAL_FECHA_INICIO = SYSDATE,
							VAL.USUARIOMODIFICAR = '''||V_NOMBRESP||''',
							VAL.FECHAMODIFICAR = SYSDATE
						WHERE VAL.VAL_ID = '||V_VALID||'
					  ';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] - Se actualiza '||SQL%ROWCOUNT||' registro en la ACT_VAL_VALORACIONES.');
			V_NUMREGISTROS := V_NUMREGISTROS + SQL%ROWCOUNT;
              
        --Si la Valoracion (ACT_ID, DD_TPC_ID) no existe en la ACT_VAL_VALORACIONES, la creamos nueva.
        --V_COUNT = 0 THEN 
        ELSE
			
			V_MSQL := 'SELECT '||V_ESQUEMA||'.S_ACT_VAL_VALORACIONES.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL INTO V_NEXTVAL;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_VAL_VALORACIONES (
							VAL_ID, ACT_ID, DD_TPC_ID, VAL_IMPORTE, VAL_FECHA_INICIO, USU_ID,
							USUARIOCREAR, FECHACREAR
					   )
					   VALUES
					   (
							'||V_NEXTVAL||',
							(SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'), 
							(SELECT TPC.DD_TPC_ID FROM '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC WHERE TPC.DD_TPC_CODIGO = '''||TIPO_PRECIO||'''), 
							'''||IMPORTE||''', 
							SYSDATE,
							-1,
							'''||V_NOMBRESP||''',
							SYSDATE
					   )';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] - Se inserta '||SQL%ROWCOUNT||' registro en la ACT_VAL_VALORACIONES.');
			V_NUMREGISTROS := V_NUMREGISTROS + SQL%ROWCOUNT;
						
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.HLD_HISTORICO_LANZA_PER_DETA (
						  HLD_SP_CARGA,
						  HLD_FECHA_EJEC,
						  HLD_CODIGO_REG,
						  HLD_TABLA_MODIFICAR,
						  HLD_TABLA_MODIFICAR_CLAVE,
						  HLD_TABLA_MODIFICAR_CLAVE_ID,
						  HLD_CAMPO_MODIFICAR,
						  HLD_VALOR_ORIGINAL,
						  HLD_VALOR_ACTUALIZADO
						)
						SELECT '''||V_NOMBRESP||''', SYSDATE, TO_NUMBER('''||ID_ACTIVO_HAYA||'''), ''ACT_VAL_VALORACIONES'', ''VAL_ID'',  TO_NUMBER('''||V_NEXTVAL||'''), ''VAL_ID'', NULL, TO_CHAR('''||V_NEXTVAL||''') FROM DUAL
						UNION ALL
						SELECT '''||V_NOMBRESP||''', SYSDATE, TO_NUMBER('''||ID_ACTIVO_HAYA||'''), ''ACT_VAL_VALORACIONES'', ''VAL_ID'',  TO_NUMBER('''||V_NEXTVAL||'''), ''ACT_ID'', NULL, TO_CHAR((SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||')) FROM DUAL
						UNION ALL
						SELECT '''||V_NOMBRESP||''', SYSDATE, TO_NUMBER('''||ID_ACTIVO_HAYA||'''), ''ACT_VAL_VALORACIONES'', ''VAL_ID'',  TO_NUMBER('''||V_NEXTVAL||'''), ''DD_TPC_ID'', NULL, TO_CHAR((SELECT TPC.DD_TPC_ID FROM '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC WHERE TPC.DD_TPC_CODIGO = '''||TIPO_PRECIO||''')) FROM DUAL
						UNION ALL
						SELECT '''||V_NOMBRESP||''', SYSDATE, TO_NUMBER('''||ID_ACTIVO_HAYA||'''), ''ACT_VAL_VALORACIONES'', ''VAL_ID'',  TO_NUMBER('''||V_NEXTVAL||'''), ''VAL_IMPORTE'', NULL, TO_CHAR('''||IMPORTE||''') FROM DUAL                                			
						UNION ALL
						SELECT '''||V_NOMBRESP||''', SYSDATE, TO_NUMBER('''||ID_ACTIVO_HAYA||'''), ''ACT_VAL_VALORACIONES'', ''VAL_ID'',  TO_NUMBER('''||V_NEXTVAL||'''), ''VAL_FECHA_INICIO'', NULL, TO_CHAR(SYSDATE) FROM DUAL
					';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] - Se insertan '||SQL%ROWCOUNT||' registros en la HLD_HISTORICO_LANZA_PER_DETA.');
        
        END IF;

   END IF;
   
   
   /*****************************************************************     
   6.- Si ha habido algún error, insertamos 1 registro en la HLP con el error
   ******************************************************************/
   IF COD_RETORNO = 1 AND V_NOTABLES = 0 THEN  
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE('[ERROR] Procedemos a informar la tabla HLP_HISTORICO_LANZA_PERIODICO.');
		V_MSQL := '
		INSERT INTO '||V_ESQUEMA||'.HLP_HISTORICO_LANZA_PERIODICO (
			HLP_SP_CARGA,
			HLP_FECHA_EJEC,
			HLP_RESULTADO_EJEC,
			HLP_CODIGO_REG,
			HLP_REGISTRO_EJEC
		)
		SELECT
			'''||V_NOMBRESP||''',
			SYSDATE,
			1,
			NVL('''||ID_ACTIVO_HAYA||''',''-1'') ||''|''|| NVL('''||TIPO_PRECIO||''',''-1''),
			'''||HLP_REGISTRO_EJEC||'''
		FROM DUAL
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] - Ha habido errores. Se inserta '||SQL%ROWCOUNT||' registro en la HLP_HISTORICO_LANZA_PERIODICO.');		
   END IF;
   
   /*****************************************************************   
   7.- Si no ha habido fallos, insertamos 1 registro en la HLP.
   ******************************************************************/   
   IF COD_RETORNO = 0 AND V_NOTABLES = 0 THEN
		V_MSQL := '
		INSERT INTO '||V_ESQUEMA||'.HLP_HISTORICO_LANZA_PERIODICO (
			HLP_SP_CARGA,
			HLP_FECHA_EJEC,
			HLP_RESULTADO_EJEC,
			HLP_CODIGO_REG,
			HLP_REGISTRO_EJEC
		)
		SELECT
			'''||V_NOMBRESP||''',
			SYSDATE,
			0,
			'''||ID_ACTIVO_HAYA||''' ||''|''|| '''||TIPO_PRECIO||''',
			'''||V_NUMREGISTROS||'''
		FROM DUAL
	  ';
	  EXECUTE IMMEDIATE V_MSQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] - No ha habido errores. Se inserta '||SQL%ROWCOUNT||' registro en la HLP_HISTORICO_LANZA_PERIODICO.');		
   END IF;
   COMMIT;
    
    
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      COD_RETORNO := 1;
      DBMS_OUTPUT.PUT_LINE('[ERROR] Procedemos a informar la tabla HLP_HISTORICO_LANZA_PERIODICO.');
	  V_MSQL := '
		INSERT INTO '||V_ESQUEMA||'.HLP_HISTORICO_LANZA_PERIODICO (
			HLP_SP_CARGA,
			HLP_FECHA_EJEC,
			HLP_RESULTADO_EJEC,
			HLP_CODIGO_REG,
			HLP_REGISTRO_EJEC
		)
		SELECT
			'''||V_NOMBRESP||''',
			SYSDATE,
			1,
			NVL('''||ID_ACTIVO_HAYA||''',''-1'') ||''|''|| NVL('''||TIPO_PRECIO||''',''-1''),
			'''||ERR_MSG||'''
		FROM DUAL
	  ';
	  EXECUTE IMMEDIATE V_MSQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] - Ha habido errores. Se inserta '||SQL%ROWCOUNT||' registro en la HLP_HISTORICO_LANZA_PERIODICO.');
	  COMMIT;
      RAISE;
END SP_EXT_VALORES_CONTABLES;
/
EXIT;
