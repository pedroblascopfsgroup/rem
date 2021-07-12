--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210514
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9171
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##	    0.2 Juan Bautista Alfonso - REMVIP-8566 - Añadido campo TAS_ILOCALIZABLE
--##	    0.3 Juan Bautista Alfonso - REMVIP-9171 - Modificado actualizacion para que actualice por TAS_ID en vez de por ID_EXTERNO
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE       #ESQUEMA#.SP_EXT_ACTUALIZA_TASACION_BBVA (
	      ID 							IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_ID%TYPE
       ,  ID_ACTIVO_HAYA       			IN  #ESQUEMA#.ACT_ACTIVO.ACT_NUM_ACTIVO%TYPE
       ,  COD_EXPEDIENTE 	   			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_EXPEDIENTE_EXTERNO%TYPE
       ,  IMPORTE_TAS_TOTAL    			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_IMPORTE_TAS_FIN%TYPE
       ,  VALOR_MERCADO 	   			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_VALOR_MERCADO%TYPE
       ,  VALOR_SUELO 		   			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_IMPORTE_VAL_SOLAR%TYPE
       ,  VALOR_SEGURO 		   			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_VALOR_SEGURO%TYPE
       ,  VALOR_LIQUIDATIVO    			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_VALOR_LIQUIDATIVO%TYPE
       ,  VALOR_OBRA_TERMINADA 			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_IMPORTE_VALOR_TER%TYPE
       ,  PORCENTAJE_OBRA_EJEC 			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_PORCENTAJE_OBRA%TYPE
       ,  PORCENTAJE_AJUSTE	   			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_PORCENTAJE_AJUSTE%TYPE
       ,  TASACION_MODIFICADA  			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_TASACION_MODIFICADA%TYPE
       ,  CIF_TASADORA 		   			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_CIF_TASADOR%TYPE
       ,  NOMBRE_TASADORA 	   			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_NOMBRE_TASADOR%TYPE
       ,  FECHA_TASACION 	   			IN  VARCHAR2
       ,  TECNICO_TASADOR 	   			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_TECNICO_TASADOR%TYPE
       ,  TIPO_TASACION  	   			IN  #ESQUEMA#.DD_TTS_TIPO_TASACION.DD_TTS_CODIGO%TYPE
       ,  FECHA_CADUCIDAD      			IN  VARCHAR2
       ,  TASACION_ACTIVA      			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_TASACION_ACTIVA%TYPE
       ,  FECHA_VIGENCIA_INI   			IN  VARCHAR2
       ,  FECHA_VIGENCIA_FIN   			IN  VARCHAR2
       ,  CONDICIONANTE        			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_CONDICIONANTE%TYPE
       ,  CONDICIONANTE_OBS    			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_CONDICIONANTE_OBS%TYPE
       ,  ORDEN_ECO            			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_ORDEN_ECO%TYPE
       ,  ORDEN_ECO_OBS        			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_ORDEN_ECO_OBS%TYPE
       ,  ADVERTENCIAS 		   			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_ADVERTENCIAS%TYPE
       ,  ADVERTENCIAS_OBS 	   			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_ADVERTENCIAS_OBS%TYPE
       ,  PORCENTAJE_PARTICIPA 			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_PORCENTAJE_PARTICIPACION%TYPE
       ,  OBSERVACIONES 	   			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_OBSERVACIONES%TYPE
       ,  IMPORTE_VAL_LEGAL_FINCA 		IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_IMPORTE_VAL_LEGAL_FINCA%TYPE
       ,  ID_TEXTO_ASOCIADO 			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_ID_TEXTO_ASOCIADO%TYPE
       ,  COSTE_REPOSICION 				IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_COSTE_REPOSICION%TYPE
       ,  COSTE_UNI_REPO_NETO 			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_COSTE_UNI_REPO_NETO%TYPE
       ,  COSTE_CONST_DEPRE 			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_COSTE_CONST_DEPRE%TYPE
       ,  INDICE_TOTAL_DEPRE 			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_INDICE_TOTAL_DEPRE%TYPE
       ,  INDICE_DEPRE_FUNCIONAL 		IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_INDICE_DEPRE_FUNCIONAL%TYPE
       ,  INDICE_DEPRE_FISICA 			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_INDICE_DEPRE_FISICA%TYPE
       ,  COSTE_CONST_CONST 			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_COSTE_CONST_CONST%TYPE
       ,  VALOR_REPER_SUELO_CONST 		IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_VALOR_REPER_SUELO_CONST%TYPE
       ,  COEF_POND_VALOR_ANYADIDO 		IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_COEF_POND_VALOR_ANYADIDO%TYPE
       ,  COEF_MERCADO_ESTADO 			IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_COEF_MERCADO_ESTADO%TYPE
       ,  COSTE_REPO_NETO_FINALIZADO 	IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_COSTE_REPO_NETO_FINALIZADO%TYPE
       ,  COSTE_REPO_NETO_ACTUAL 		IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_COSTE_REPO_NETO_ACTUAL%TYPE
       ,  CODIGO_FIRMA 					IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_CODIGO_FIRMA_BBVA%TYPE
       ,  FECHA_RECEPCION_TASACION 		IN  VARCHAR2
       ,  ID_EXTERNO 					IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_ID_EXTERNO_BBVA%TYPE
       ,  ILOCALIZABLE					IN  #ESQUEMA#.ACT_TAS_TASACION.TAS_ILOCALIZABLE%TYPE
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
V_NOMBRESP VARCHAR2(50 CHAR) := 'SP_EXT_ACTUALIZA_TASACION_BBVA';			-- Nombre del SP.
HLP_REGISTRO_EJEC VARCHAR2(1024 CHAR) := '';
V_NOTABLES NUMBER(1) := 0;												-- Comprueba si existen las tablas HLD y HLP
V_NUMREGISTROS NUMBER(25) := 0;											-- Vble. auxiliar que guarda el número de registros actualizados
V_NUMREGISTROS2 NUMBER(25) := 0;
V_VALID NUMBER(16,0);
ACT_ID NUMBER(16,0);													-- ACT_ID DEL ACTIVO
TAS_ID NUMBER(16,0);													-- TAS_ID DE LA TASACION
BIE_VAL_ID NUMBER(16,0);
FECHA_HOY TIMESTAMP := SYSTIMESTAMP;
VALOR VARCHAR2 (256 CHAR);


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
	T_TIPO_DATA(''''||PORCENTAJE_PARTICIPA||'''','TAS_PORCENTAJE_PARTICIPACION'),
	T_TIPO_DATA(''''||OBSERVACIONES||'''','TAS_OBSERVACIONES'),
	T_TIPO_DATA(''''||IMPORTE_VAL_LEGAL_FINCA||'''','TAS_IMPORTE_VAL_LEGAL_FINCA'),
	T_TIPO_DATA(''''||ID_TEXTO_ASOCIADO||'''','TAS_ID_TEXTO_ASOCIADO'),
	T_TIPO_DATA(''''||COSTE_REPOSICION||'''','TAS_COSTE_REPOSICION'),
	T_TIPO_DATA(''''||COSTE_UNI_REPO_NETO||'''','TAS_COSTE_UNI_REPO_NETO'),
	T_TIPO_DATA(''''||COSTE_CONST_DEPRE||'''','TAS_COSTE_CONST_DEPRE'),
	T_TIPO_DATA(''''||INDICE_TOTAL_DEPRE||'''','TAS_INDICE_TOTAL_DEPRE'),
	T_TIPO_DATA(''''||INDICE_DEPRE_FUNCIONAL||'''','TAS_INDICE_DEPRE_FUNCIONAL'),
	T_TIPO_DATA(''''||INDICE_DEPRE_FISICA||'''','TAS_INDICE_DEPRE_FISICA'),
	T_TIPO_DATA(''''||COSTE_CONST_CONST||'''','TAS_COSTE_CONST_CONST'),
	T_TIPO_DATA(''''||VALOR_REPER_SUELO_CONST||'''','TAS_VALOR_REPER_SUELO_CONST'),
	T_TIPO_DATA(''''||COEF_POND_VALOR_ANYADIDO||'''','TAS_COEF_POND_VALOR_ANYADIDO'),
	T_TIPO_DATA(''''||COEF_MERCADO_ESTADO||'''','TAS_COEF_MERCADO_ESTADO'),
	T_TIPO_DATA(''''||COSTE_REPO_NETO_FINALIZADO||'''','TAS_COSTE_REPO_NETO_FINALIZADO'),
	T_TIPO_DATA(''''||COSTE_REPO_NETO_ACTUAL||'''','TAS_COSTE_REPO_NETO_ACTUAL'),
	T_TIPO_DATA(''''||CODIGO_FIRMA||'''','TAS_CODIGO_FIRMA_BBVA'),
	T_TIPO_DATA(''''||FECHA_RECEPCION_TASACION||'''','TAS_FECHA_RECEPCION_TASACION'),
	T_TIPO_DATA(''''||ILOCALIZABLE||'''','TAS_ILOCALIZABLE')
	

);
V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	-- Version 1.02
	
   COD_RETORNO := 0;

   /**************************************************************************************************************************************************************
   1.- Miramos que los parámetros obligatorios (ID_ACTIVO_HAYA Y ID_EXTERNO) del SP vengan informados.
   ***************************************************************************************************************************************************************/
   IF COD_RETORNO = 0 AND ID_ACTIVO_HAYA IS NULL THEN
		HLP_REGISTRO_EJEC := '[ERROR] El ID_ACTIVO_HAYA indicado como parámetro de entrada no se ha ingresado. Por favor ingrese un valor para este campo.';
		COD_RETORNO := 1;
   END IF;
   IF COD_RETORNO = 0 AND ID_EXTERNO IS NULL THEN
		HLP_REGISTRO_EJEC := '[ERROR] El ID_EXTERNO indicado como parámetro de entrada no se ha ingresado. Por favor ingrese un valor para este campo.';
		COD_RETORNO := 1;
   END IF;

   /**************************************************************************************************************************************************************
   2.- Miramos que el activo exista en la BD por ID_ACTIVO_HAYA.
   ***************************************************************************************************************************************************************/
   IF COD_RETORNO = 0 THEN
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||' AND ACT.BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		IF V_COUNT < 1 THEN
				HLP_REGISTRO_EJEC := '[ERROR] El activo ['||ID_ACTIVO_HAYA||'] no existe en la tabla ACT_ACTIVO o es un activo borrado.';
				COD_RETORNO := 1;
		ELSE
			    V_MSQL := 'SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||' ';
				EXECUTE IMMEDIATE V_MSQL INTO ACT_ID;
                DBMS_OUTPUT.PUT_LINE('[INFO] - El activo '||ID_ACTIVO_HAYA||' existe en la ACT_ACTIVO. Continuamos la ejecución.');
                
                /*V_MSQL := 'SELECT TAS.TAS_ID FROM '||V_ESQUEMA||'.ACT_TAS_TASACION TAS WHERE TRIM(TAS.TAS_EXPEDIENTE_EXTERNO) = TRIM('''||COD_EXPEDIENTE||''')';
				EXECUTE IMMEDIATE V_MSQL INTO TAS_ID;*/
		END IF;
   END IF;

   /**************************************************************************************************************************************************************
   3.- Comprobamos que las tablas donde vamos a escribir (HLP y HLD) existan.
   ***************************************************************************************************************************************************************/
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

   /**************************************************************************************************************************************************************
   4.- Insertamos/Actualizamos la tasación.
   ***************************************************************************************************************************************************************/
   IF COD_RETORNO = 0 AND V_NOTABLES = 0 THEN
        
   
   		/**************************************************************************************************************************************************************
	  	4.1.- Si el campo ID (TAS_ID)
			 llega, actualizamos el ID_EXTERNO 			 
	  	***************************************************************************************************************************************************************/     
   
   		IF COD_RETORNO = 0 AND ID IS NOT NULL THEN
   		
			V_MSQL := ' UPDATE '||V_ESQUEMA||'.ACT_TAS_TASACION TAS
                        SET
                            TAS.TAS_ID_EXTERNO_BBVA = TRIM('''||ID_EXTERNO||'''),
                            TAS.USUARIOMODIFICAR = '''||V_NOMBRESP||''',
                            TAS.FECHAMODIFICAR = '''||FECHA_HOY||'''
                        WHERE TRIM(TAS.TAS_ID) = TRIM('''||ID||''')
                      ';
            EXECUTE IMMEDIATE V_MSQL;
        
            
   		/**************************************************************************************************************************************************************
	  	4.2.- Si el campo ID (TAS_ID)
			 no llega, comprobamos la dupla (ID_ACTIVO_HAYA + ID_EXTERNO)	 
	  	***************************************************************************************************************************************************************/
   
        ELSIF COD_RETORNO = 0 AND ID IS NULL THEN
        
	        V_MSQL :=  'SELECT COUNT(*) 
	                    FROM '||V_ESQUEMA||'.ACT_TAS_TASACION TAS
	                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO       ACT
	                      ON TAS.ACT_ID = ACT.ACT_ID
	                     AND ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'
	                     AND TAS.TAS_ID_EXTERNO_BBVA = TRIM('''||ID_EXTERNO||''') ';
	        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
	
	      
	       /**************************************************************************************************************************************************************
	       4.2.1.- Si la dupla (ID_ACTIVO_HAYA + ID_EXTERNO) 
	             existe, actualizamos la tasación.
	       ***************************************************************************************************************************************************************/
	       IF V_COUNT = 1 THEN
	       
	            V_MSQL :=  'SELECT TAS.TAS_ID
	                        FROM '||V_ESQUEMA||'.ACT_TAS_TASACION TAS
	                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO       ACT
	                        ON TAS.ACT_ID = ACT.ACT_ID
	                        AND ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'
	                        AND TAS.TAS_ID_EXTERNO_BBVA = TRIM('''||ID_EXTERNO||''') ';
	            EXECUTE IMMEDIATE V_MSQL INTO TAS_ID;
	            
	            FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	            LOOP
	    
	                V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	    
	                V_MSQL := 'SELECT TAS.'||V_TMP_TIPO_DATA(2)||' FROM '||V_ESQUEMA||'.ACT_TAS_TASACION TAS WHERE TAS.TAS_ID = '||TAS_ID||' ';
	                EXECUTE IMMEDIATE V_MSQL INTO VALOR;
	                
	                V_MSQL := ' UPDATE '||V_ESQUEMA||'.ACT_TAS_TASACION TAS
	                            SET
	                                TAS.'||V_TMP_TIPO_DATA(2)||' = CASE WHEN '''||V_TMP_TIPO_DATA(2)||''' LIKE ''%FECHA%'' THEN ''''||TO_DATE('||V_TMP_TIPO_DATA(1)||',''yyyymmdd'')
	                                                                    ELSE '||V_TMP_TIPO_DATA(1)||' END,
	                                TAS.USUARIOMODIFICAR = '''||V_NOMBRESP||''',
	                                TAS.FECHAMODIFICAR = '''||FECHA_HOY||'''
	                            WHERE TAS.TAS_ID = '||TAS_ID||'
	                          ';
	                EXECUTE IMMEDIATE V_MSQL;
	                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
	                V_NUMREGISTROS := SQL%ROWCOUNT;
	                
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
	                                   SUBSTR('''||VALOR||''', 1, 30),
	                                   CASE WHEN '''||V_TMP_TIPO_DATA(2)||''' = ''DD_TTS_ID'' THEN ''''||(SELECT TTS.DD_TTS_ID FROM '||V_ESQUEMA||'.DD_TTS_TIPO_TASACION TTS WHERE TTS.DD_TTS_CODIGO = '||V_TMP_TIPO_DATA(1)||')
	                                        WHEN '''||V_TMP_TIPO_DATA(2)||''' LIKE ''%FECHA%'' THEN ''''||TO_DATE('||V_TMP_TIPO_DATA(1)||',''yyyymmdd'')
	                                        ELSE SUBSTR('||V_TMP_TIPO_DATA(1)||',1 ,30) END
	                                   FROM DUAL
	                            ';
	                EXECUTE IMMEDIATE V_MSQL;
	                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
	                V_NUMREGISTROS2 := V_NUMREGISTROS2 + SQL%ROWCOUNT;
	                   
	            END LOOP;
	            DBMS_OUTPUT.PUT_LINE('[INFO] - Se insertan '||V_NUMREGISTROS2||' registros en la HLD_HISTORICO_LANZA_PER_DETA.');
	            DBMS_OUTPUT.PUT_LINE('[INFO] - Se actualizan '||V_NUMREGISTROS||' registros en la ACT_TAS_TASACION.');
	       
	       
	       /**************************************************************************************************************************************************************
	       4.2.2.- Si la dupla (ID_ACTIVO_HAYA + ID_EXTERNO) 
	             No existe, insertamos la tasación (Siempre y cuando la tasación no exista ya en BD.)
	       ***************************************************************************************************************************************************************/
	       ELSIF V_COUNT = 0 THEN
	        
	            V_MSQL := 'SELECT COUNT(*)
	                        FROM '||V_ESQUEMA||'.ACT_TAS_TASACION TAS
	                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO       ACT
	                        ON TAS.ACT_ID = ACT.ACT_ID
	                        WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'
	                        AND TRIM(TAS.TAS_ID_EXTERNO_BBVA) = TRIM('''||ID_EXTERNO||''')';
	                        
	           EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
	           
	           IF V_COUNT > 1 THEN
	                
	                HLP_REGISTRO_EJEC := '[ERROR] La tasación ['||ID_EXTERNO||'] existe para otro activo que no es el indicado por parámetro.';
	                COD_RETORNO := 1;
	           
	           ELSE
	           
	                /*****************************************************************
	                Insertamos 1 registro en la BIE_VALORACIONES
	                *****************************************************************/
	               
	                V_MSQL :=  'SELECT '||V_ESQUEMA||'.S_BIE_VALORACIONES.NEXTVAL FROM DUAL';
	                EXECUTE IMMEDIATE V_MSQL INTO BIE_VAL_ID;
	                
	                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.BIE_VALORACIONES BIE (
	                                  BIE_ID,
	                                  BIE_VAL_ID,
					  BIE_FECHA_VALOR_TASACION,
	                                  USUARIOCREAR,
	                                  FECHACREAR
	                                )
	                                SELECT 
	                                       (SELECT ACT.BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_ID = '||ACT_ID||'),
	                                       '||BIE_VAL_ID||',
					       TO_DATE('''||FECHA_TASACION||''',''yyyymmdd'') ,
	                                       '''||V_NOMBRESP||''',
	                                       '''||FECHA_HOY||'''
	                                       FROM DUAL
	                            ';
	                EXECUTE IMMEDIATE V_MSQL;
	                V_NUMREGISTROS := SQL%ROWCOUNT;
	                DBMS_OUTPUT.PUT_LINE('[INFO] - Se inserta '||SQL%ROWCOUNT||' registro en la BIE_VALORACIONES.');
	                
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
	                                       '||BIE_VAL_ID||',
	                                       ''BIE_VALORACIONES'',
	                                       ''BIE_VAL_ID'',
	                                       '||BIE_VAL_ID||',
	                                       ''BIE_VAL_ID'',
	                                       NULL,
	                                       '||BIE_VAL_ID||'
	                                FROM DUAL
	                                ';
	                EXECUTE IMMEDIATE V_MSQL;
	                DBMS_OUTPUT.PUT_LINE('[INFO] - Se inserta '||SQL%ROWCOUNT||' registro en la HLD_HISTORICO_LANZA_PER_DETA.');
	                
	                /*****************************************************************
	                Insertamos 1 registro en la ACT_TAS_TASACION
	                *****************************************************************/
	                
	                V_MSQL :=  'SELECT '||V_ESQUEMA||'.S_ACT_TAS_TASACION.NEXTVAL FROM DUAL';
	                EXECUTE IMMEDIATE V_MSQL INTO TAS_ID;
	                
	                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_TAS_TASACION TAS (                              
	                                 ACT_ID
	                              ,  TAS_ID
	                              ,  BIE_VAL_ID
	                              ,  USUARIOCREAR
	                              ,  FECHACREAR      
	                              ,  TAS_IMPORTE_TAS_FIN
	                              ,  TAS_VALOR_MERCADO
	                              ,  TAS_IMPORTE_VAL_SOLAR
	                              ,  TAS_VALOR_SEGURO
	                              ,  TAS_VALOR_LIQUIDATIVO
	                              ,  TAS_IMPORTE_VALOR_TER
	                              ,  TAS_PORCENTAJE_OBRA
	                              ,  TAS_PORCENTAJE_AJUSTE
	                              ,  TAS_TASACION_MODIFICADA
	                              ,  TAS_CIF_TASADOR
	                              ,  TAS_EXPEDIENTE_EXTERNO
	                              ,  TAS_NOMBRE_TASADOR
	                              ,  TAS_FECHA_INI_TASACION
	                              ,  TAS_TECNICO_TASADOR
	                              ,  DD_TTS_ID
	                              ,  TAS_FECHA_CADUCIDAD
	                              ,  TAS_TASACION_ACTIVA
	                              ,  TAS_FECHA_VIGENCIA_INI
	                              ,  TAS_FECHA_VIGENCIA_FIN
	                              ,  TAS_CONDICIONANTE
	                              ,  TAS_CONDICIONANTE_OBS
	                              ,  TAS_ORDEN_ECO
	                              ,  TAS_ORDEN_ECO_OBS
	                              ,  TAS_ADVERTENCIAS
	                              ,  TAS_ADVERTENCIAS_OBS
	                              ,  TAS_PORCENTAJE_PARTICIPACION
	                              ,  TAS_OBSERVACIONES
	                              ,  TAS_IMPORTE_VAL_LEGAL_FINCA
	                              ,  TAS_ID_TEXTO_ASOCIADO
	                              ,  TAS_COSTE_REPOSICION
	                              ,  TAS_COSTE_UNI_REPO_NETO
	                              ,  TAS_COSTE_CONST_DEPRE
	                              ,  TAS_INDICE_TOTAL_DEPRE
	                              ,  TAS_INDICE_DEPRE_FUNCIONAL
	                              ,  TAS_INDICE_DEPRE_FISICA
	                              ,  TAS_COSTE_CONST_CONST
	                              ,  TAS_VALOR_REPER_SUELO_CONST
	                              ,  TAS_COEF_POND_VALOR_ANYADIDO
	                              ,  TAS_COEF_MERCADO_ESTADO
	                              ,  TAS_COSTE_REPO_NETO_FINALIZADO
	                              ,  TAS_COSTE_REPO_NETO_ACTUAL
	                              ,  TAS_CODIGO_FIRMA_BBVA
	                              ,  TAS_FECHA_RECEPCION_TASACION
				       ,  TAS_ID_EXTERNO_BBVA
				       ,  TAS_ILOCALIZABLE
	                            )
	                            SELECT '||ACT_ID||',
	                                   '||TAS_ID||',
	                                   '||BIE_VAL_ID||',
	                                   '''||V_NOMBRESP||''',
	                                   '''||FECHA_HOY||''',
	                                   '''||IMPORTE_TAS_TOTAL||''',
	                                   '''||VALOR_MERCADO||''',
	                                   '''||VALOR_SUELO||''',
	                                   '''||VALOR_SEGURO||''',
	                                   '''||VALOR_LIQUIDATIVO||''',
	                                   '''||VALOR_OBRA_TERMINADA||''',
	                                   '''||PORCENTAJE_OBRA_EJEC||''',
	                                   '''||PORCENTAJE_AJUSTE||''',
	                                   '''||TASACION_MODIFICADA||''',
	                                   '''||CIF_TASADORA||''',
	                                   '''||COD_EXPEDIENTE||''',
	                                   '''||NOMBRE_TASADORA||''',
	                                   TO_DATE('''||FECHA_TASACION||''',''yyyymmdd'') ,
	                                   '''||TECNICO_TASADOR||''',
	                                   (SELECT TTS.DD_TTS_ID FROM '||V_ESQUEMA||'.DD_TTS_TIPO_TASACION TTS WHERE TTS.DD_TTS_CODIGO = '''||TIPO_TASACION||'''),
	                                   TO_DATE('''||FECHA_CADUCIDAD||''',''yyyymmdd'') ,
	                                   '''||TASACION_ACTIVA||''',
	                                   TO_DATE('''||FECHA_VIGENCIA_INI||''',''yyyymmdd''),
	                                   TO_DATE('''||FECHA_VIGENCIA_FIN||''',''yyyymmdd''),
	                                   '''||CONDICIONANTE||''',
	                                   '''||CONDICIONANTE_OBS||''',
	                                   '''||ORDEN_ECO||''',
	                                   '''||ORDEN_ECO_OBS||''',
	                                   '''||ADVERTENCIAS||''',
	                                   '''||ADVERTENCIAS_OBS||''',
	                                   '''||PORCENTAJE_PARTICIPA||''',                                   
	                                   '''||OBSERVACIONES||''',          
	                                   '''||IMPORTE_VAL_LEGAL_FINCA||''',    
	                                   '''||ID_TEXTO_ASOCIADO||''',          
	                                   '''||COSTE_REPOSICION||''',          
	                                   '''||COSTE_UNI_REPO_NETO||''',        
	                                   '''||COSTE_CONST_DEPRE||''',          
	                                   '''||INDICE_TOTAL_DEPRE||''',         
	                                   '''||INDICE_DEPRE_FUNCIONAL||''',     
	                                   '''||INDICE_DEPRE_FISICA||''',        
	                                   '''||COSTE_CONST_CONST||''',          
	                                   '''||VALOR_REPER_SUELO_CONST||''',    
	                                   '''||COEF_POND_VALOR_ANYADIDO||''',   
	                                   '''||COEF_MERCADO_ESTADO||''',        
	                                   '''||COSTE_REPO_NETO_FINALIZADO||''', 
	                                   '''||COSTE_REPO_NETO_ACTUAL||''',     
	                                   '''||CODIGO_FIRMA||''',          
	                                   TO_DATE('''||FECHA_RECEPCION_TASACION||''' ,''yyyymmdd''),
					    '''||ID_EXTERNO||''',
					    '''||ILOCALIZABLE||'''  
	                            FROM DUAL
	                ';
	                EXECUTE IMMEDIATE V_MSQL;
	                V_NUMREGISTROS := V_NUMREGISTROS + SQL%ROWCOUNT;
	                DBMS_OUTPUT.PUT_LINE('[INFO] - Se inserta '||SQL%ROWCOUNT||' registro en la ACT_TAS_TASACION.');
	
	
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
	                                       SUBSTR('''||V_TMP_TIPO_DATA(2)||''', 1, 30),
	                                       NULL,
	                                       CASE WHEN '''||V_TMP_TIPO_DATA(2)||''' = ''DD_TTS_ID'' THEN ''''||(SELECT TTS.DD_TTS_ID FROM '||V_ESQUEMA||'.DD_TTS_TIPO_TASACION TTS WHERE TTS.DD_TTS_CODIGO = '||V_TMP_TIPO_DATA(1)||')
	                                            WHEN '''||V_TMP_TIPO_DATA(2)||''' LIKE ''%FECHA%'' THEN ''''||TO_DATE('||V_TMP_TIPO_DATA(1)||',''yyyymmdd'')
	                                            ELSE SUBSTR('||V_TMP_TIPO_DATA(1)||', 1, 30) END
	                                       FROM DUAL
	                                ';
	                    EXECUTE IMMEDIATE V_MSQL;
	                    V_NUMREGISTROS2 := V_NUMREGISTROS2 + SQL%ROWCOUNT;
	        
	                END LOOP;
	                DBMS_OUTPUT.PUT_LINE('[INFO] - Se insertan '||V_NUMREGISTROS2||' registros en la HLD_HISTORICO_LANZA_PER_DETA.');
	                
	
	           END IF;
	       
	       /**************************************************************************************************************************************************************
	       4.2.3.- Si la dupla (ID_ACTIVO_HAYA + ID_EXTERNO) 
	             existe más de una vez, informamos el error.
	       ***************************************************************************************************************************************************************/
	       ELSIF V_COUNT > 1 THEN
	
	            HLP_REGISTRO_EJEC := '[ERROR] Existe más de una tasación para el par activo/tasación ['||ID_ACTIVO_HAYA||','||ID_EXTERNO||'].';
	            COD_RETORNO := 1;
	
	       END IF;
	       
   		END IF;

   END IF;

   /**************************************************************************************************************************************************************
   5.- Si ha habido algún error, insertamos 1 registro en la HLP con el error
   ***************************************************************************************************************************************************************/
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
			NVL('''||ID_ACTIVO_HAYA||''',''-1''),
			'''||HLP_REGISTRO_EJEC||'''
		FROM DUAL
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] - Ha habido errores. Se inserta '||SQL%ROWCOUNT||' registro en la HLP_HISTORICO_LANZA_PERIODICO.');
   END IF;

   /**************************************************************************************************************************************************************
   6.- Si no ha habido ningun error, insertamos 0 registro en la HLP.
   ***************************************************************************************************************************************************************/
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
			'||ID_ACTIVO_HAYA||',
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
			NVL('''||ID_ACTIVO_HAYA||''',''-1''),
			'''||ERR_MSG||'''
		FROM DUAL
	  ';
	  EXECUTE IMMEDIATE V_MSQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] - Ha habido errores. Se inserta '||SQL%ROWCOUNT||' registro en la HLP_HISTORICO_LANZA_PERIODICO.');
	  COMMIT;
      RAISE;
END SP_EXT_ACTUALIZA_TASACION_BBVA;
/
EXIT;

