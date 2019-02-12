--/*
--#########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20180102
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=REMVIP-2889
--## PRODUCTO=NO
--## 
--## Finalidad:  Creación del SP SP_EXT_ACTUALIZA_PROMOCION
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1-Sergio Ortuño-Versión inicial (20180608) (HREOS-4190)
--##		0.2-Vicente Martinez Cifre - Modificacion para LBB (REMVIP-1378) (20180608) 
--##		0.3-Marco Muñoz de Morales - Modificacion para incluir la fecha de toma de posesión. (REMVIP-2328)
--##		0.4-Ivan Castelló Cabrelles - Modificación al incluir fecha toma posesión, cuando es no judicial no tenesmo en cuenta la BIE_ADJ_ADJUDICACION. (REMVIP-2889)
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE SP_EXT_ACTUALIZA_PROMOCION (
	ID_ACTIVO_HAYA IN #ESQUEMA#.ACT_ACTIVO.ACT_NUM_ACTIVO%TYPE,
	CODIGO_PROMOCION IN #ESQUEMA#.ACT_ACTIVO.ACT_COD_PROMOCION_PRINEX%TYPE,
	COD_CATEGORIA_CONTABLE IN #ESQUEMA#.DD_CCO_CATEGORIA_CONTABLE.DD_CCO_CODIGO%TYPE DEFAULT NULL,
    CODIGO_PROMOCION_LBB IN #ESQUEMA#.ACT_ILB_NFO_LIBERBANK.ILB_COD_PROMOCION%TYPE DEFAULT NULL,
    FECHA_TOMA_POSESION IN VARCHAR2,
	COD_RETORNO OUT NUMBER
)
AS

	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; 			-- '#ESQUEMA#'; 		-- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; 	-- '#ESQUEMA_MASTER#'; 	-- Configuracion Esquema Master
	err_num NUMBER; 								-- Numero de errores
	err_msg VARCHAR2(2048);
	V_NUM NUMBER(16);
	V_COUNT NUMBER(16) := 0;	
	V_COUNT2 NUMBER(16) := 0;
	V_COUNT3 NUMBER(16) := 0;	
	V_MSQL VARCHAR2(4000 CHAR);
	
	V_SEC VARCHAR2(30 CHAR) := '';
	V_TABLA_HLP VARCHAR2(30 CHAR) := 'HLP_HISTORICO_LANZA_PERIODICO';
	V_TABLA_HLD VARCHAR2(30 CHAR) := 'HLD_HISTORICO_LANZA_PER_DETA';
	V_TABLA_SPS VARCHAR2(30 CHAR) := 'ACT_SPS_SIT_POSESORIA';
	V_TABLA_ADJ VARCHAR2(30 CHAR) := 'BIE_ADJ_ADJUDICACION';
	V_TABLA_ADN VARCHAR2(30 CHAR) := 'ACT_ADN_ADJNOJUDICIAL';
	V_TABLA_ILB VARCHAR2(30 CHAR) := 'ACT_ILB_NFO_LIBERBANK';
	V_TABLA_ACTIVO VARCHAR2(30 CHAR) := 'ACT_ACTIVO';	
	CODIGO_ANTERIOR #ESQUEMA#.ACT_ACTIVO.ACT_COD_PROMOCION_PRINEX%TYPE;
	FECHA_TOMA_POSESION_DATE DATE;
	
BEGIN
	  --v0.3
	   DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');
	 	 
	   IF FECHA_TOMA_POSESION IS NOT NULL THEN
			FECHA_TOMA_POSESION_DATE := to_date(FECHA_TOMA_POSESION,'dd/mm/yyyy');
       END IF;
	 
	   --Código de la version V0.1
	   IF CODIGO_PROMOCION IS NULL THEN
	 
			DBMS_OUTPUT.PUT_LINE('[INFO] CODIGO_PROMOCION no informado. Se procede a actualizar a nulo.');			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLD||' (
				HLD_SP_CARGA,
				HLD_FECHA_EJEC,	
				HLD_CODIGO_REG,
				HLD_TABLA_MODIFICAR,	
				HLD_TABLA_MODIFICAR_CLAVE,	
				HLD_TABLA_MODIFICAR_CLAVE_ID,	
				HLD_CAMPO_MODIFICAR,	
				HLD_VALOR_ORIGINAL
			 )
			 SELECT ''SP_EXT_ACTUALIZA_PROMOCION'',
			 SYSDATE,
			 '||ID_ACTIVO_HAYA||',
			 '''||V_TABLA_ACTIVO||''',
			 ''ACT_ID'',
			 ACT.ACT_ID,
			 ''ACT_COD_PROMOCION_PRINEX'',
			 NVL(ACT.ACT_COD_PROMOCION_PRINEX,0)
			 FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||' AND ACT.BORRADO = 0
			 ';
			 EXECUTE IMMEDIATE V_MSQL;
			 
			 V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT SET ACT.ACT_COD_PROMOCION_PRINEX = NULL, USUARIOMODIFICAR = ''HREOS-4190'', FECHAMODIFICAR = SYSDATE WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||' AND ACT.BORRADO = 0';
			 EXECUTE IMMEDIATE V_MSQL;
			 
			 V_COUNT := SQL%ROWCOUNT;
	 
	   ELSE
	 
			 DBMS_OUTPUT.PUT_LINE('[INFO] CODIGO_PROMOCION informado. Se procede a actualizar.');
			 V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLD||' (
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
			 SELECT ''SP_EXT_ACTUALIZA_PROMOCION'',
			 SYSDATE,
			 '||ID_ACTIVO_HAYA||',
			 '''||V_TABLA_ACTIVO||''',
			 ''ACT_ID'',
			 ACT.ACT_ID,
			 ''ACT_COD_PROMOCION_PRINEX'',
			 NVL(ACT.ACT_COD_PROMOCION_PRINEX,0),
			 '''||CODIGO_PROMOCION||'''
			 FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||' AND ACT.BORRADO = 0
			 ';
			 EXECUTE IMMEDIATE V_MSQL;
			 
			 V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT SET ACT.ACT_COD_PROMOCION_PRINEX = '||CODIGO_PROMOCION||', USUARIOMODIFICAR = ''HREOS-4190'', FECHAMODIFICAR = SYSDATE WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||' AND ACT.BORRADO = 0';
			 EXECUTE IMMEDIATE V_MSQL;
			 
			 V_COUNT := SQL%ROWCOUNT;
	
	  END IF;
	  DBMS_OUTPUT.PUT_LINE('[INFO] CODIGO_PROMOCION actualizado correctamente.');
 
 
 
	  --Código de la version V0.2
      IF COD_CATEGORIA_CONTABLE IS NOT NULL AND CODIGO_PROMOCION_LBB IS NOT NULL THEN

        V_MSQL :=  'SELECT COUNT(1) 
					FROM '||V_ESQUEMA||'.'||V_TABLA_ILB||' ILB
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ILB.ACT_ID = ACT.ACT_ID AND ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'
					AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT2;

        IF V_COUNT2 > 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] COD_CATEGORIA_CONTABLE y CODIGO_PROMOCION_LBB informados. Se procede a actualizar registro en la ACT_ILB_NFO_LIBERBANK.');
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_ILB||' 
                SET
                DD_CCO_ID = (SELECT DD_CCO_ID FROM '||V_ESQUEMA||'.DD_CCO_CATEGORIA_CONTABLE WHERE DD_CCO_CODIGO = '''||COD_CATEGORIA_CONTABLE||'''),
                ILB_COD_PROMOCION = '''||CODIGO_PROMOCION_LBB||'''
                WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||')';      
            EXECUTE IMMEDIATE V_MSQL;
            V_COUNT := V_COUNT + SQL%ROWCOUNT;

        ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO] COD_CATEGORIA_CONTABLE y CODIGO_PROMOCION_LBB informados. Se procede a insertar un nuevo registro en la ACT_ILB_NFO_LIBERBANK.');
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ILB||' (ACT_ID, DD_CCO_ID, ILB_COD_PROMOCION)
                VALUES ((SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'), 
                (SELECT DD_CCO_ID FROM '||V_ESQUEMA||'.DD_CCO_CATEGORIA_CONTABLE WHERE DD_CCO_CODIGO = '''||COD_CATEGORIA_CONTABLE||'''), '''||CODIGO_PROMOCION_LBB||''')';
            EXECUTE IMMEDIATE V_MSQL;
            V_COUNT := V_COUNT + SQL%ROWCOUNT;

        END IF;

      END IF;
	  
	  
	  
	  --Código de la versión V0.3
	  IF FECHA_TOMA_POSESION_DATE IS NOT NULL THEN
	  
			V_MSQL :=  'SELECT COUNT(1) 
						FROM '||V_ESQUEMA||'.ACT_ACTIVO 	   		ACT 
						JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA 	SPS ON SPS.ACT_ID = ACT.ACT_ID
 						WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'
 						  AND ACT.BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_COUNT2;
			
			/*
			V_MSQL :=  'SELECT COUNT(1) 
						FROM '||V_ESQUEMA||'.ACT_ACTIVO 		  ACT
						JOIN '||V_ESQUEMA||'.BIE_BIEN   		  BIE
						ON ACT.BIE_ID = BIE.BIE_ID
						JOIN '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION ADJ
						ON ADJ.BIE_ID = BIE.BIE_ID
 						WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'
 						  AND ACT.BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_COUNT3;
			*/

			DBMS_OUTPUT.PUT_LINE('[INFO] FECHA_TOMA_POSESION informado. Se procede a actualizar la fecha de toma de posesión.');
	  
			IF V_COUNT2 > 0 /*AND V_COUNT3 > 0*/ THEN
					
				 V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLD||' (
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
				 SELECT ''SP_EXT_ACTUALIZA_PROMOCION'',
						 SYSDATE,
						 '||ID_ACTIVO_HAYA||',
						 '''||V_TABLA_SPS||''',
						 ''SPS_ID'',
						 SPS.SPS_ID,
						 ''SPS_FECHA_TOMA_POSESION'',
						 SPS.SPS_FECHA_TOMA_POSESION,
						 '''||FECHA_TOMA_POSESION_DATE||'''
				 FROM '||V_ESQUEMA||'.'||V_TABLA_SPS||' SPS WHERE SPS.ACT_ID IN (
																					SELECT ACT.ACT_ID  
																					FROM '||V_ESQUEMA||'.ACT_ACTIVO 	   		ACT 
																					JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA 	SPS ON SPS.ACT_ID = ACT.ACT_ID
																					WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'
																					  AND ACT.BORRADO = 0
																			    )
				 ';
				 EXECUTE IMMEDIATE V_MSQL;
				 
				 V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_SPS||' SPS 
							SET SPS.SPS_FECHA_TOMA_POSESION = '''||FECHA_TOMA_POSESION_DATE||''', 
							    USUARIOMODIFICAR = ''SP_EXT_ACTUALIZA_PROMOCION'', 
							    FECHAMODIFICAR = SYSDATE 
							WHERE SPS.ACT_ID IN (
													SELECT ACT.ACT_ID  
													FROM '||V_ESQUEMA||'.ACT_ACTIVO 	   		ACT 
													JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA 	SPS ON SPS.ACT_ID = ACT.ACT_ID
													WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'
													  AND ACT.BORRADO = 0
												) 
							';
				 EXECUTE IMMEDIATE V_MSQL; 
				 V_COUNT := V_COUNT + SQL%ROWCOUNT;
				 
				 
				 V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLD||' (
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
				 SELECT ''SP_EXT_ACTUALIZA_PROMOCION'',
						 SYSDATE,
						 '||ID_ACTIVO_HAYA||',
						 '''||V_TABLA_ADJ||''',
						 ''BIE_ADJ_ID'',
						 ADJ.BIE_ADJ_ID,
						 ''BIE_ADJ_F_REA_POSESION'',
						 ADJ.BIE_ADJ_F_REA_POSESION,
						 '''||FECHA_TOMA_POSESION_DATE||'''
				 FROM '||V_ESQUEMA||'.'||V_TABLA_ADJ||' ADJ WHERE ADJ.BIE_ADJ_ID IN (
																					SELECT ADJ.BIE_ADJ_ID 
																					FROM '||V_ESQUEMA||'.ACT_ACTIVO 		  		ACT
																					JOIN '||V_ESQUEMA||'.BIE_BIEN   		  		BIE
																					ON ACT.BIE_ID = BIE.BIE_ID
																					JOIN '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION 		ADJ
																					ON ADJ.BIE_ID = BIE.BIE_ID
																					JOIN '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO  TTA 
                                                                                    ON TTA.DD_TTA_ID = ACT.DD_TTA_ID 
																					WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'
																					  AND ACT.BORRADO = 0 
																					  AND TTA.DD_TTA_CODIGO = ''01''
																			    )
				 ';
				 EXECUTE IMMEDIATE V_MSQL;
				 
				 V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_ADJ||' ADJ 
							SET ADJ.BIE_ADJ_F_REA_POSESION = '''||FECHA_TOMA_POSESION_DATE||''', 
							    ADJ.USUARIOMODIFICAR = ''SP_EXT_ACTUALIZA_PROMOCION'', 
							    ADJ.FECHAMODIFICAR = SYSDATE 
							WHERE ADJ.BIE_ADJ_ID IN (
														SELECT ADJ.BIE_ADJ_ID 
														FROM '||V_ESQUEMA||'.ACT_ACTIVO 		  ACT
														JOIN '||V_ESQUEMA||'.BIE_BIEN   		  BIE
														ON ACT.BIE_ID = BIE.BIE_ID
														JOIN '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION ADJ
														ON ADJ.BIE_ID = BIE.BIE_ID
														JOIN '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO  TTA 
                                                        ON TTA.DD_TTA_ID = ACT.DD_TTA_ID 
														WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'
														  AND ACT.BORRADO = 0
														  AND TTA.DD_TTA_CODIGO = ''01''
													)
							';
				 EXECUTE IMMEDIATE V_MSQL; 
				 V_COUNT := V_COUNT + SQL%ROWCOUNT;
				 
				 
				 V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLD||' (
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
				 SELECT ''SP_EXT_ACTUALIZA_PROMOCION'',
						 SYSDATE,
						 '||ID_ACTIVO_HAYA||',
						 '''||V_TABLA_ADN||''',
						 ''ADN_ID'',
						 ADN.ADN_ID,
						 ''ADN_FECHA_TITULO'',
						 ADN.ADN_FECHA_TITULO,
						 '''||FECHA_TOMA_POSESION_DATE||'''
				 FROM '||V_ESQUEMA||'.'||V_TABLA_ADN||' ADN WHERE ADN.ADN_ID IN (
																					SELECT ADN.ADN_ID 
																					FROM '||V_ESQUEMA||'.ACT_ACTIVO 		  		ACT
																					JOIN '||V_ESQUEMA||'.BIE_BIEN   		  		BIE
																					ON ACT.BIE_ID = BIE.BIE_ID
																					JOIN '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO  TTA 
                                                                                    ON TTA.DD_TTA_ID = ACT.DD_TTA_ID
                                                                                    JOIN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL 	    ADN
                                                                                    ON ADN.ACT_ID = ACT.ACT_ID
																					WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'
																					  AND ACT.BORRADO = 0 
																					  AND TTA.DD_TTA_CODIGO = ''02''
																			    )
				 ';
				 EXECUTE IMMEDIATE V_MSQL;
				 
				 V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_ADN||' ADN 
							SET ADN.ADN_FECHA_TITULO = '''||FECHA_TOMA_POSESION_DATE||''', 
							    ADN.USUARIOMODIFICAR = ''SP_EXT_ACTUALIZA_PROMOCION'', 
							    ADN.FECHAMODIFICAR = SYSDATE 
							WHERE ADN.ADN_ID IN (
														SELECT ADN.ADN_ID 
														FROM '||V_ESQUEMA||'.ACT_ACTIVO 		  		ACT
														JOIN '||V_ESQUEMA||'.BIE_BIEN   		  		BIE
														ON ACT.BIE_ID = BIE.BIE_ID
														JOIN '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO  TTA 
														ON TTA.DD_TTA_ID = ACT.DD_TTA_ID
														JOIN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL 	    ADN
														ON ADN.ACT_ID = ACT.ACT_ID
														WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'
														  AND ACT.BORRADO = 0 
														  AND TTA.DD_TTA_CODIGO = ''02''
													)
							';
				 EXECUTE IMMEDIATE V_MSQL; 
				 V_COUNT := V_COUNT + SQL%ROWCOUNT;
				 DBMS_OUTPUT.PUT_LINE('[INFO] Fecha de toma de posesion actualizada correctamente.');
				 
			ELSE
			
				 DBMS_OUTPUT.PUT_LINE('[INFO] No se encuentra el registro de la tabla ACT_SPS_SIT_POSESORIA o de la BIE_ADJ_ADJUDICACION relacionado con el activo proporcionado.');
			
			END IF; 
	  
	  END IF;
	  
	  
	  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLP||' (
			HLP_SP_CARGA,
			HLP_FECHA_EJEC,
			HLP_RESULTADO_EJEC,
			HLP_CODIGO_REG,
			HLP_REGISTRO_EJEC
		)VALUES(
		''SP_EXT_ACTUALIZA_PROMOCION'',
		 SYSDATE,
		 0,
		 '''||ID_ACTIVO_HAYA||' | '||CODIGO_PROMOCION||''',
		 '||to_char(V_COUNT)||'
		 )';
	  EXECUTE IMMEDIATE V_MSQL;
	  
	  COD_RETORNO := 0;
	  DBMS_OUTPUT.PUT_LINE('[FIN] Fin del proceso');
	  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(SQLERRM);
    ROLLBACK;
    
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA_HLP||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
    
    IF V_COUNT > 0 THEN
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLP||' (
			HLP_SP_CARGA,
			HLP_FECHA_EJEC,
			HLP_RESULTADO_EJEC,
			HLP_CODIGO_REG,
			HLP_REGISTRO_EJEC
		)VALUES(
		''SP_EXT_ACTUALIZA_PROMOCION'',
		 SYSDATE,
		 1,
		 '''||ID_ACTIVO_HAYA||' | '||CODIGO_PROMOCION||''',
		 '''||SQLERRM||'''
		 )';
		  EXECUTE IMMEDIATE V_MSQL;
		  
		COMMIT;
	END IF;
    COD_RETORNO := 1;
    RAISE;

END;
/
EXIT
