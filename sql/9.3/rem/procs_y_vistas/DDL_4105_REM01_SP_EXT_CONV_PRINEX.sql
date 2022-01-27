--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20220125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10039
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##	    0.2 HREOS-16975 Nuevos campos de comprador y fecha de venta
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE #ESQUEMA#.SP_EXT_CONV_PRINEX ( 
         ID_ACTIVO_HAYA IN  #ESQUEMA#.ACT_ACTIVO.ACT_NUM_ACTIVO%TYPE
       , DISP_TECNICO    IN  #ESQUEMA#.DD_DIT_DISP_TECNICO.DD_DIT_CODIGO%TYPE
	   , DISP_ADMINISTRATIVO   IN  #ESQUEMA#.DD_DIA_DISP_ADMINISTRATIVO.DD_DIA_CODIGO%TYPE
       , MOTIVO_TECNICO     IN #ESQUEMA#.DD_MTC_MOTIVO_TECNICO.DD_MTC_CODIGO%TYPE
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
V_NOMBRESP VARCHAR2(50 CHAR) := 'SP_EXT_CONV_PRINEX';				-- Nombre del SP.
HLP_REGISTRO_EJEC VARCHAR2(1024 CHAR) := ''; 	
V_NOTABLES NUMBER(1) := 0;												-- Comprueba si existen las tablas HLD y HLP		
V_NUMREGISTROS NUMBER(25) := 0;											-- Vble. auxiliar que guarda el número de registros actualizados	
V_NEXTVAL INTEGER;
V_VALID NUMBER(16,0);

BEGIN

   COD_RETORNO := 0;
   
   /*****************************************************************   
   1.- Miramos que ACT_NUM_ACTIVO venga informado
   ******************************************************************/
   IF COD_RETORNO = 0 AND ID_ACTIVO_HAYA IS NULL THEN 
		HLP_REGISTRO_EJEC := '[ERROR] El ID_ACTIVO_HAYA indicado como parámetro de entrada no se ha ingresado. Por favor ingrese un valor para este campo.';
		COD_RETORNO := 1;
   END IF;   
   
   /*****************************************************************   
   2.- Miramos que el activo pasado por parámetro exista.
   ******************************************************************/  
   IF COD_RETORNO = 0 THEN 
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA;
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		IF V_COUNT < 1 THEN
				HLP_REGISTRO_EJEC := '[ERROR] El activo ['||ID_ACTIVO_HAYA||'] no existe en la tabla ACT_ACTIVO.';
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
     4.1.COMPROBAR ACT_ID EN ACT_PRINEX
   ******************************************************************/   
   IF COD_RETORNO = 0 AND V_NOTABLES = 0 THEN
	   V_MSQL := '
			SELECT COUNT(1)                                 			
			FROM '||V_ESQUEMA||'.ACT_PRINEX_ACTIVOS  PRI
			JOIN '||V_ESQUEMA||'.ACT_ACTIVO            ACT
			  ON PRI.ACT_ID = ACT.ACT_ID			
			WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'		  
			  AND ACT.BORRADO = 0
			  AND PRI.BORRADO = 0';
	   EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		IF V_COUNT = 0 AND COD_RETORNO = 0 THEN
			
			DBMS_OUTPUT.PUT_LINE('[INFO] Procedemos a insertar en ACT_PRINEX_ACTIVOS.');
		V_MSQL := '
		INSERT INTO '||V_ESQUEMA||'.ACT_PRINEX_ACTIVOS (
			PRINEX_ID,
			ACT_ID,
			DD_DIA_ID,
			DD_DIT_ID,
			DD_MTC_ID,
			USUARIOCREAR,
			FECHACREAR
		)
		SELECT
			'||V_ESQUEMA||'.S_ACT_PRINEX_ACTIVOS.NEXTVAL,
			(SELECT act.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO act WHERE act.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'),
			(SELECT DD_DIA_ID FROM '||V_ESQUEMA||'.DD_DIA_DISP_ADMINISTRATIVO WHERE DD_DIA_CODIGO = '''||DISP_ADMINISTRATIVO||'''),
			(SELECT DD_DIT_ID FROM '||V_ESQUEMA||'.DD_DIT_DISP_TECNICO WHERE DD_DIT_CODIGO = '''||DISP_TECNICO||'''),
			(SELECT DD_MTC_ID FROM '||V_ESQUEMA||'.DD_MTC_MOTIVO_TECNICO WHERE DD_MTC_CODIGO = '''||MOTIVO_TECNICO||'''),
			'''||V_NOMBRESP||''',
			SYSDATE
			
		FROM DUAL
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] - Se han insertado '||SQL%ROWCOUNT||' registros en la ACT_PRINEX_ACTIVOS.');
		
			
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PRINEX_ACTIVOS PRI USING (
		  	SELECT DISTINCT ACT.ACT_ID, ECO.ECO_FECHA_VENTA, COM.ID_PERSONA_HAYA FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
		  	JOIN '||V_ESQUEMA||'.ACT_OFR ACO ON ACO.ACT_ID = ACT.ACT_ID
		  	JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ACO.OFR_ID
		  	JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
		  	JOIN '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE CEX ON CEX.ECO_ID = ECO.ECO_ID
		  	JOIN '||V_ESQUEMA||'.COM_COMPRADOR COM ON COM.COM_ID = CEX.COM_ID
            		JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID AND EEC.DD_EEC_CODIGO = ''08''
		  	WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||' AND CEX.CEX_TITULAR_CONTRATACION = 1) AUX ON (AUX.ACT_ID = PRI.ACT_ID)
		  	WHEN MATCHED THEN UPDATE SET
			PRI.FECHA_VENTA = AUX.ECO_FECHA_VENTA,
			PRI.COMPRADOR = AUX.ID_PERSONA_HAYA';
			
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] - Se han actualizado '||SQL%ROWCOUNT||' registros en la ACT_PRINEX_ACTIVOS.');
			



		END IF;

   END IF;
   
   --Si existe ACT_ID, INSERT EN HLD_HISTORICO_LANZA_PER_DETA
   IF COD_RETORNO = 0 AND V_NOTABLES = 0 AND V_COUNT = 1 THEN        
        
       
        V_NUMREGISTROS := SQL%ROWCOUNT;
        

  

		V_MSQL := 'SELECT PRINEX_ID FROM '||V_ESQUEMA||'.ACT_PRINEX_ACTIVOS WHERE ACT_ID = (SELECT act.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO act WHERE act.ACT_NUM_ACTIVO = '''||ID_ACTIVO_HAYA||''') ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NEXTVAL;     
			 
						
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
						
						SELECT '''||V_NOMBRESP||''', SYSDATE, TO_NUMBER('''||ID_ACTIVO_HAYA||'''), ''ACT_PRINEX_ACTIVOS'', ''PRIMEX_ID'',  TO_NUMBER('''||V_NEXTVAL||'''), ''DD_DIA_ID'', TO_CHAR((SELECT pri.DD_DIA_ID FROM '||V_ESQUEMA||'.ACT_PRINEX_ACTIVOS pri WHERE pri.ACT_ID = (SELECT act.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO act WHERE act.ACT_NUM_ACTIVO = '''||ID_ACTIVO_HAYA||''') )), TO_CHAR((SELECT DD_DIA_ID FROM '||V_ESQUEMA||'.DD_DIA_DISP_ADMINISTRATIVO WHERE DD_DIA_CODIGO = '''||DISP_ADMINISTRATIVO||''')) FROM DUAL
						UNION ALL
						SELECT '''||V_NOMBRESP||''', SYSDATE, TO_NUMBER('''||ID_ACTIVO_HAYA||'''), ''ACT_PRINEX_ACTIVOS'', ''PRIMEX_ID'',  TO_NUMBER('''||V_NEXTVAL||'''), ''DD_DIT_ID'', TO_CHAR((SELECT pri.DD_DIT_ID FROM '||V_ESQUEMA||'.ACT_PRINEX_ACTIVOS pri WHERE pri.ACT_ID = (SELECT act.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO act WHERE act.ACT_NUM_ACTIVO = '''||ID_ACTIVO_HAYA||''') )), TO_CHAR((SELECT DD_DIT_ID FROM '||V_ESQUEMA||'.DD_DIT_DISP_TECNICO WHERE DD_DIT_CODIGO = '''||DISP_TECNICO||''')) FROM DUAL
						UNION ALL
						SELECT '''||V_NOMBRESP||''', SYSDATE, TO_NUMBER('''||ID_ACTIVO_HAYA||'''), ''ACT_PRINEX_ACTIVOS'', ''PRIMEX_ID'',  TO_NUMBER('''||V_NEXTVAL||'''), ''DD_MTC_ID'', TO_CHAR((SELECT pri.DD_MTC_ID FROM '||V_ESQUEMA||'.ACT_PRINEX_ACTIVOS pri WHERE pri.ACT_ID = (SELECT act.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO act WHERE act.ACT_NUM_ACTIVO = '''||ID_ACTIVO_HAYA||''') )), TO_CHAR((SELECT DD_MTC_ID FROM '||V_ESQUEMA||'.DD_MTC_MOTIVO_TECNICO WHERE DD_MTC_CODIGO = '''||MOTIVO_TECNICO||''')) FROM DUAL
						
						
					';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] - Se insertan '||SQL%ROWCOUNT||' registros en la HLD_HISTORICO_LANZA_PER_DETA.');
        
   

		--Si existe ACT_ID, UPDATE A LA ACT_PRINEX_ACTIVOS
		IF V_NUMREGISTROS > 0 THEN
			V_MSQL := '
                UPDATE '||V_ESQUEMA||'.ACT_PRINEX_ACTIVOS PRI
						SET
							PRI.DD_DIA_ID = (SELECT DD_DIA_ID FROM '||V_ESQUEMA||'.DD_DIA_DISP_ADMINISTRATIVO WHERE DD_DIA_CODIGO = '''||DISP_ADMINISTRATIVO||'''),
                            PRI.DD_DIT_ID = (SELECT DD_DIT_ID FROM '||V_ESQUEMA||'.DD_DIT_DISP_TECNICO WHERE DD_DIT_CODIGO = '''||DISP_TECNICO||'''),
                            PRI.DD_MTC_ID = (SELECT DD_MTC_ID FROM '||V_ESQUEMA||'.DD_MTC_MOTIVO_TECNICO WHERE DD_MTC_CODIGO = '''||MOTIVO_TECNICO||'''),
                           
							PRI.USUARIOMODIFICAR = '''||V_NOMBRESP||''',
							PRI.FECHAMODIFICAR = SYSDATE
						WHERE PRI.ACT_ID = (SELECT act.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO act WHERE act.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||')  

			';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] - Se han actualizado '||SQL%ROWCOUNT||' registros en la ACT_PRINEX_ACTIVOS.');

			
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
			NVL('''||ID_ACTIVO_HAYA||''',''-1'') ||''|''|| NVL('''||DISP_ADMINISTRATIVO||''',''-1'') ||''|''|| NVL('''||DISP_TECNICO||''',''-1'') ||''|''|| NVL('''||MOTIVO_TECNICO||''',''-1''),
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
			'''||ID_ACTIVO_HAYA||''' ||''|''|| '''||DISP_TECNICO||''' ||''|''|| '''||DISP_ADMINISTRATIVO||''' ||''|''|| '''||MOTIVO_TECNICO||''',
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
			NVL('''||ID_ACTIVO_HAYA||''',''-1'') ||''|''|| NVL('''||DISP_TECNICO||''',''-1'') ||''|''|| NVL('''||DISP_ADMINISTRATIVO||''',''-1'') ||''|''|| NVL('''||MOTIVO_TECNICO||''',''-1''),
			'''||ERR_MSG||'''
		FROM DUAL
	  ';
	  EXECUTE IMMEDIATE V_MSQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] - Ha habido errores. Se inserta '||SQL%ROWCOUNT||' registro en la HLP_HISTORICO_LANZA_PERIODICO.');
	  COMMIT;
      RAISE;
END SP_EXT_CONV_PRINEX;
/
EXIT;
