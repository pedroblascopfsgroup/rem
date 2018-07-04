--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180704
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=HREOS-4268
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

create or replace PROCEDURE #ESQUEMA#.SP_EXT_ACTUALIZA_TASACION ( 
          COD_EXPEDIENTE 	   IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_EXPEDIENTE_EXTERNO%TYPE
       ,  IMPORTE_TAS_TOTAL    IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_IMPORTE_TAS_FIN%TYPE
       ,  VALOR_MERCADO 	   IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_VALOR_MERCADO%TYPE
       ,  VALOR_SUELO 		   IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_IMPORTE_VAL_SOLAR%TYPE
       ,  VALOR_SEGURO 		   IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_VALOR_SEGURO%TYPE
       ,  VALOR_LIQUIDATIVO    IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_VALOR_LIQUIDATIVO%TYPE
       ,  VALOR_OBRA_TERMINADA IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_IMPORTE_VALOR_TER%TYPE
       ,  PORCENTAJE_OBRA_EJEC IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_PORCENTAJE_OBRA%TYPE
       ,  PORCENTAJE_AJUSTE	   IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_PORCENTAJE_AJUSTE%TYPE
       ,  TASACION_MODIFICADA  IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_TASACION_MODIFICADA%TYPE
       ,  CIF_TASADORA 		   IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_CIF_TASADOR%TYPE
       ,  NOMBRE_TASADORA 	   IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_NOMBRE_TASADOR%TYPE
       ,  FECHA_TASACION 	   IN  VARCHAR2
       ,  TECNICO_TASADOR 	   IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_TECNICO_TASADOR%TYPE
       ,  TIPO_TASACION  	   IN  #ESQUEMA#.DD_TTS_TIPO_TASACION.DD_TTS_CODIGO%TYPE
       ,  FECHA_CADUCIDAD      IN  VARCHAR2
       ,  TASACION_ACTIVA      IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_TASACION_ACTIVA%TYPE
       ,  FECHA_VIGENCIA_INI   IN  VARCHAR2
       ,  FECHA_VIGENCIA_FIN   IN  VARCHAR2
       ,  CONDICIONANTE        IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_CONDICIONANTE%TYPE
       ,  CONDICIONANTE_OBS    IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_CONDICIONANTE_OBS%TYPE
       ,  ORDEN_ECO            IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_ORDEN_ECO%TYPE
       ,  ORDEN_ECO_OBS        IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_ORDEN_ECO_OBS%TYPE
       ,  ADVERTENCIAS 		   IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_ADVERTENCIAS%TYPE
       ,  ADVERTENCIAS_OBS 	   IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_ADVERTENCIAS_OBS%TYPE
       ,  PORCENTAJE_PARTICIPA IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_PORCENTAJE_PARTICIPACION%TYPE
       ,  COD_RETORNO    	   OUT NUMBER
) AS


V_MSQL VARCHAR2(32000 CHAR); 											-- Sentencia a ejecutar.      
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 								-- Configuracion Esquema.
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 					-- Configuracion Esquema Master.
ERR_NUM NUMBER(25); 													-- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); 											-- Vble. auxiliar para registrar errores en el script.
V_TABLA VARCHAR2 (50 CHAR);
V_COUNT NUMBER(1);
V_RESULTADO VARCHAR2(50 CHAR);
V_NOMBRESP VARCHAR2(50 CHAR) := 'SP_EXT_ACTUALIZA_TASACION';			-- Nombre del SP.
HLP_REGISTRO_EJEC VARCHAR2(1024 CHAR) := ''; 	
V_NOTABLES NUMBER(1) := 0;												-- Comprueba si existen las tablas HLD y HLP		
V_NUMREGISTROS NUMBER(25) := 0;											-- Vble. auxiliar que guarda el número de registros actualizados	
V_NUMREGISTROS2 NUMBER(25) := 0;
V_VALID NUMBER(16,0);
TAS_ID NUMBER(16,0);													-- TAS_ID DE LA TASACION
FECHA_HOY TIMESTAMP := SYSTIMESTAMP;


TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

	--Valor-parámetro  |   Campo ACT_TAS_TASACION
	T_TIPO_DATA(''''||IMPORTE_TAS_TOTAL||'''','TAS_IMPORTE_TAS_FIN'),
	T_TIPO_DATA(''''||VALOR_MERCADO||'''','TAS_VALOR_MERCADO'),
	T_TIPO_DATA(''''||VALOR_SUELO||'''','TAS_IMPORTE_VAL_SOLAR'),
	T_TIPO_DATA(''''||VALOR_SEGURO||'''','TAS_VALOR_SEGURO'),
	T_TIPO_DATA(''''||VALOR_LIQUIDATIVO||'''','TAS_VALOR_LIQUIDATIVO'),
	T_TIPO_DATA(''''||VALOR_OBRA_TERMINADA||'''','TAS_IMPORTE_VALOR_TER'),
	T_TIPO_DATA(''''||PORCENTAJE_OBRA_EJEC||'''','TAS_PORCENTAJE_OBRA'),
	T_TIPO_DATA(''''||PORCENTAJE_AJUSTE||'''','TAS_PORCENTAJE_AJUSTE'),
	T_TIPO_DATA(''''||TASACION_MODIFICADA||'''','TAS_TASACION_MODIFICADA'),
	T_TIPO_DATA(''''||CIF_TASADORA||'''','TAS_CIF_TASADOR'),
	T_TIPO_DATA(''''||NOMBRE_TASADORA||'''','TAS_NOMBRE_TASADOR'),
	T_TIPO_DATA(''''||FECHA_TASACION||'''','TAS_FECHA_INI_TASACION'),
	T_TIPO_DATA(''''||TECNICO_TASADOR||'''','TAS_TECNICO_TASADOR'),
	T_TIPO_DATA(''''||TIPO_TASACION||'''','DD_TTS_ID'),
	T_TIPO_DATA(''''||FECHA_CADUCIDAD||'''','TAS_FECHA_CADUCIDAD'),
	T_TIPO_DATA(''''||TASACION_ACTIVA||'''','TAS_TASACION_ACTIVA'),
	T_TIPO_DATA(''''||FECHA_VIGENCIA_INI||'''','TAS_FECHA_VIGENCIA_INI'),
	T_TIPO_DATA(''''||FECHA_VIGENCIA_FIN||'''','TAS_FECHA_VIGENCIA_FIN'),
	T_TIPO_DATA(''''||CONDICIONANTE||'''','TAS_CONDICIONANTE'),
	T_TIPO_DATA(''''||CONDICIONANTE_OBS||'''','TAS_CONDICIONANTE_OBS'),
	T_TIPO_DATA(''''||ORDEN_ECO||'''','TAS_ORDEN_ECO'),
	T_TIPO_DATA(''''||ORDEN_ECO_OBS||'''','TAS_ORDEN_ECO_OBS'),
	T_TIPO_DATA(''''||ADVERTENCIAS||'''','TAS_ADVERTENCIAS'),
	T_TIPO_DATA(''''||ADVERTENCIAS_OBS||'''','TAS_ADVERTENCIAS_OBS'),
	T_TIPO_DATA(''''||PORCENTAJE_PARTICIPA||'''','TAS_PORCENTAJE_PARTICIPACION')

);
V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

   COD_RETORNO := 0;

   /***********************************************************************************  
   1.- Miramos que el parámetro obligatorio (COD_EXPEDIENTE) del SP vengan informado.
   ************************************************************************************/
   IF COD_RETORNO = 0 AND TRIM(COD_EXPEDIENTE) IS NULL THEN 
		HLP_REGISTRO_EJEC := '[ERROR] El COD_EXPEDIENTE indicado como parámetro de entrada no se ha ingresado. Por favor ingrese un valor para este campo.';
		COD_RETORNO := 1;
   END IF;   

   /*****************************************************************   
   2.- Miramos que la tasación exista en la BD por COD_EXPEDIENTE.
   ******************************************************************/  
   IF COD_RETORNO = 0 THEN 
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TAS_TASACION TAS WHERE TRIM(TAS.TAS_EXPEDIENTE_EXTERNO) = TRIM('''||COD_EXPEDIENTE||''')';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		IF V_COUNT < 1 THEN
				HLP_REGISTRO_EJEC := '[ERROR] La tasación ['||TRIM(COD_EXPEDIENTE)||'] no existe en la tabla ACT_TAS_TASACION.';
				COD_RETORNO := 1;
		ELSE
			    V_MSQL := 'SELECT TAS.TAS_ID FROM '||V_ESQUEMA||'.ACT_TAS_TASACION TAS WHERE TRIM(TAS.TAS_EXPEDIENTE_EXTERNO) = TRIM('''||COD_EXPEDIENTE||''')';
				EXECUTE IMMEDIATE V_MSQL INTO TAS_ID;
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
   4.- Actualizamos los valores pasados por parámetro a la tasación indicada en COD_EXPEDIENTE.
   ******************************************************************/  
   IF COD_RETORNO = 0 AND V_NOTABLES = 0 THEN
		
		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP

			V_TMP_TIPO_DATA := V_TIPO_DATA(I);		

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
						SELECT '''||V_NOMBRESP||''', 
							   '''||FECHA_HOY||''', 
							   '||TAS_ID||', 
							   ''ACT_TAS_TASACION'', 
							   ''TAS_ID'',  
							   '||TAS_ID||',
							   '''||V_TMP_TIPO_DATA(2)||''', 
							   (SELECT TAS.'||V_TMP_TIPO_DATA(2)||' FROM '||V_ESQUEMA||'.ACT_TAS_TASACION TAS WHERE TAS.TAS_ID = '||TAS_ID||'), 
							   CASE WHEN '''||V_TMP_TIPO_DATA(2)||''' = ''DD_TTS_ID'' THEN ''''||(SELECT TTS.DD_TTS_ID FROM '||V_ESQUEMA||'.DD_TTS_TIPO_TASACION TTS WHERE TTS.DD_TTS_CODIGO = '||V_TMP_TIPO_DATA(1)||')                
							        WHEN '''||V_TMP_TIPO_DATA(2)||''' LIKE ''%FECHA%'' THEN ''''||TO_DATE('||V_TMP_TIPO_DATA(1)||',''yyyymmdd'')
                                    ELSE '||V_TMP_TIPO_DATA(1)||' END
							   FROM DUAL
						';
			EXECUTE IMMEDIATE V_MSQL;
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
			V_NUMREGISTROS2 := V_NUMREGISTROS2 + SQL%ROWCOUNT;

			V_MSQL := ' UPDATE '||V_ESQUEMA||'.ACT_TAS_TASACION TAS
						SET                            
                            TAS.'||V_TMP_TIPO_DATA(2)||' = CASE WHEN '''||V_TMP_TIPO_DATA(2)||''' LIKE ''%FECHA%'' THEN ''''||TO_DATE('||V_TMP_TIPO_DATA(1)||',''yyyymmdd'')
                                                              ELSE '||V_TMP_TIPO_DATA(1)||' END, 
							TAS.USUARIOMODIFICAR = '''||V_NOMBRESP||''',
							TAS.FECHAMODIFICAR = '''||FECHA_HOY||'''
						WHERE TRIM(TAS.TAS_EXPEDIENTE_EXTERNO) = TRIM('''||COD_EXPEDIENTE||''')
					  ';
			EXECUTE IMMEDIATE V_MSQL;
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
			V_NUMREGISTROS := SQL%ROWCOUNT;
			
		END LOOP;
		DBMS_OUTPUT.PUT_LINE('[INFO] - Se insertan '||V_NUMREGISTROS2||' registros en la HLD_HISTORICO_LANZA_PER_DETA.');		
		DBMS_OUTPUT.PUT_LINE('[INFO] - Se actualizan '||V_NUMREGISTROS||' registros en la ACT_VAL_VALORACIONES.');

   END IF;

   /*****************************************************************     
   5.- Si ha habido algún error, insertamos 1 registro en la HLP con el error
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
			'''||FECHA_HOY||''',
			1,
			NVL('||TAS_ID||',''-1''),
			'''||HLP_REGISTRO_EJEC||'''
		FROM DUAL
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] - Ha habido errores. Se inserta '||SQL%ROWCOUNT||' registro en la HLP_HISTORICO_LANZA_PERIODICO.');		
   END IF;

   /*****************************************************************   
   6.- Si no ha habido ningun error, insertamos 1 registro en la HLP.
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
			'''||FECHA_HOY||''',
			0,
			'||TAS_ID||',
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
			NVL('||TAS_ID||',''-1''),
			'''||ERR_MSG||'''
		FROM DUAL
	  ';
	  EXECUTE IMMEDIATE V_MSQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] - Ha habido errores. Se inserta '||SQL%ROWCOUNT||' registro en la HLP_HISTORICO_LANZA_PERIODICO.');
	  COMMIT;
      RAISE;
END SP_EXT_ACTUALIZA_TASACION;
/
EXIT;
