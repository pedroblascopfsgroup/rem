--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20191129
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5286
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

CREATE OR REPLACE PROCEDURE #ESQUEMA#.SP_GESTOR_SUSTITUTO_WEB
        (     
		  OPERACION IN VARCHAR2
        , V_USU_ID_ORI IN VARCHAR2
        , V_USU_ID_SUS IN VARCHAR2
        , FECHA_INICIO IN VARCHAR2
        , FECHA_FIN IN VARCHAR2
        , USUARIO_LOGADO IN VARCHAR2
        , PL_OUTPUT OUT VARCHAR2
    )

   AS

   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_AUX NUMBER(10); -- Variable auxiliar
   USUARIO VARCHAR2(50 CHAR):= 'SP_GESTOR_SUSTITUTO_WEB';
   USUARIO_CONSULTA_REM VARCHAR2(50 CHAR):= 'REM_QUERY';
   V_FECHA_INICIO VARCHAR2(100 CHAR);
   V_FECHA_FIN VARCHAR2(100 CHAR);

BEGIN

    V_FECHA_INICIO := TO_DATE(TO_DATE(''||FECHA_INICIO||'','DD/MM/RRRR'),'DD/MM/RR');

	V_FECHA_FIN := TO_DATE(TO_DATE(''||FECHA_FIN||'','DD/MM/RRRR'),'DD/MM/RR');
	
	USUARIO := USUARIO_LOGADO;
	
    IF (OPERACION IS NOT NULL )AND (V_USU_ID_ORI IS NOT NULL) AND (V_FECHA_INICIO IS NOT NULL) THEN
	
		EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE TRIM(UPPER(USU_USERNAME)) = TRIM(UPPER('''||V_USU_ID_ORI||'''))' INTO V_AUX;
		
		IF V_AUX = 1 THEN 
		
		   CASE

			WHEN OPERACION = 'ALTA' THEN

				 V_SQL :=  'SELECT COUNT(1) FROM '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO
                                                        WHERE USU_ID_ORI = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE TRIM(UPPER(USU_USERNAME)) = TRIM(UPPER('''||V_USU_ID_ORI||''')))
                                                        AND BORRADO = 0 
                                                        AND 
                                                        (
                                                            (TO_DATE(FECHA_INICIO,''DD/MM/YY'') <= TO_DATE('''||V_FECHA_INICIO||''',''DD/MM/YY'') AND TO_DATE(FECHA_FIN,''DD/MM/YY'') >= TO_DATE('''||V_FECHA_FIN||''',''DD/MM/YY'') )
                                                            OR
                                                            (TO_DATE(FECHA_FIN,''DD/MM/YY'') <= TO_DATE('''||V_FECHA_INICIO||''',''DD/MM/YY'') AND TO_DATE(FECHA_INICIO,''DD/MM/YY'') >= TO_DATE('''||V_FECHA_FIN||''',''DD/MM/YY''))
                                                            OR
                                                            (TO_DATE('''||V_FECHA_INICIO||''',''DD/MM/YY'') <= TO_DATE(FECHA_FIN,''DD/MM/YY'') AND TO_DATE(FECHA_FIN,''DD/MM/YY'') <= TO_DATE('''||V_FECHA_FIN||''',''DD/MM/YY'') )
                                                            OR
                                                            (TO_DATE('''||V_FECHA_INICIO||''',''DD/MM/YY'') <= TO_DATE(FECHA_INICIO,''DD/MM/YY'') AND TO_DATE(FECHA_INICIO,''DD/MM/YY'') < TO_DATE('''||V_FECHA_FIN||''',''DD/MM/YY'') )
                                                            OR
                                                            ((TO_DATE('''||V_FECHA_INICIO||''',''DD/MM/YY'') <= TO_DATE(FECHA_INICIO,''DD/MM/YY'')) AND (FECHA_FIN IS NULL))
                                                            OR
                                                            ((TO_DATE('''||V_FECHA_INICIO||''',''DD/MM/YY'') <= TO_DATE(FECHA_INICIO,''DD/MM/YY'')) AND (FECHA_FIN IS NULL))
                                                        )';
                
                EXECUTE IMMEDIATE V_SQL INTO V_AUX ;
										
				IF V_USU_ID_SUS IS NOT NULL THEN
				
					IF V_AUX = 0 THEN
					
						EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE TRIM(UPPER(USU_USERNAME)) = TRIM(UPPER('''||V_USU_ID_SUS||'''))' INTO V_AUX;
		
						IF V_AUX = 1 THEN 
		
						   V_SQL := 'INSERT INTO '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO
										(     SGS_ID
											, USU_ID_ORI
											, USU_ID_SUS
											, FECHA_INICIO
											, FECHA_FIN
											, USUARIOCREAR
											, FECHACREAR
											, USUARIOMODIFICAR
											, FECHAMODIFICAR
											, USUARIOBORRAR
											, FECHABORRAR
											)
										VALUES ( '||V_ESQUEMA||'.S_SGS_GESTOR_SUSTITUTO.NEXTVAL
												,(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE TRIM(UPPER(USU_USERNAME)) = TRIM(UPPER('''||V_USU_ID_ORI||''')))
												,(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE TRIM(UPPER(USU_USERNAME)) = TRIM(UPPER('''||V_USU_ID_SUS||''')))
												,'''||V_FECHA_INICIO||'''
												,'''||V_FECHA_FIN||'''
												,'''||USUARIO||'''
												,SYSDATE
												,NULL
												,NULL
												,NULL
												,NULL
												)';
		
							EXECUTE IMMEDIATE V_SQL;
						
						ELSE
						
							PL_OUTPUT := PL_OUTPUT || '[ERROR] No existe un usuario sustituto con ese nombre de usuario ' || CHR(10) ;
						
						END IF;
						
					ELSE
		
						PL_OUTPUT := PL_OUTPUT || '[ERROR] Ya existe un registro con ese rango de fechas ' || CHR(10) ;
		
					END IF;
				
				ELSE
				
					 PL_OUTPUT := PL_OUTPUT || '[ERROR] No se ha informado de la variable V_USU_ID_SUS' || CHR(10) ;
					 
				END IF;

			WHEN OPERACION = 'MOD' THEN

				 V_SQL :=  'SELECT COUNT(1) FROM '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO
                                                        WHERE USU_ID_ORI = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE TRIM(UPPER(USU_USERNAME)) = TRIM(UPPER('''||V_USU_ID_ORI||''')))
                                                        AND BORRADO = 0 
                                                        AND 
                                                        (
                                                            (TO_DATE(FECHA_INICIO,''DD/MM/YY'') <= TO_DATE('''||V_FECHA_INICIO||''',''DD/MM/YY'') AND TO_DATE(FECHA_FIN,''DD/MM/YY'') >= TO_DATE('''||V_FECHA_FIN||''',''DD/MM/YY'') )
                                                            OR
                                                            (TO_DATE(FECHA_FIN,''DD/MM/YY'') <= TO_DATE('''||V_FECHA_INICIO||''',''DD/MM/YY'') AND TO_DATE(FECHA_INICIO,''DD/MM/YY'') >= TO_DATE('''||V_FECHA_FIN||''',''DD/MM/YY''))
                                                            OR
                                                            (TO_DATE('''||V_FECHA_INICIO||''',''DD/MM/YY'') <= TO_DATE(FECHA_FIN,''DD/MM/YY'') AND TO_DATE(FECHA_FIN,''DD/MM/YY'') <= TO_DATE('''||V_FECHA_FIN||''',''DD/MM/YY'') )
                                                            OR
                                                            (TO_DATE('''||V_FECHA_INICIO||''',''DD/MM/YY'') <= TO_DATE(FECHA_INICIO,''DD/MM/YY'') AND TO_DATE(FECHA_INICIO,''DD/MM/YY'') < TO_DATE('''||V_FECHA_FIN||''',''DD/MM/YY'') )
                                                            OR
                                                            ((TO_DATE('''||V_FECHA_INICIO||''',''DD/MM/YY'') <= TO_DATE(FECHA_INICIO,''DD/MM/YY'')) AND (FECHA_FIN IS NULL))
                                                            OR
                                                            ((TO_DATE('''||V_FECHA_INICIO||''',''DD/MM/YY'') <= TO_DATE(FECHA_INICIO,''DD/MM/YY'')) AND (FECHA_FIN IS NULL))
                                                        )';
                
                EXECUTE IMMEDIATE V_SQL INTO V_AUX ;

				IF V_AUX > 0 THEN

					EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO
											WHERE USU_ID_ORI = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE TRIM(UPPER(USU_USERNAME)) = TRIM(UPPER('''||V_USU_ID_ORI||''')))
											AND FECHA_INICIO = '''||V_FECHA_INICIO||'''
											AND BORRADO = 0' INTO V_AUX;

					IF V_AUX > 0 THEN

						V_SQL := 'UPDATE '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO SET
									  FECHA_FIN = '''||V_FECHA_FIN||'''
									, USUARIOMODIFICAR = '''||USUARIO||'''
									, FECHAMODIFICAR = SYSDATE
									WHERE USU_ID_ORI = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE TRIM(UPPER(USU_USERNAME)) = TRIM(UPPER('''||V_USU_ID_ORI||''')))
									  AND FECHA_INICIO = '''||V_FECHA_INICIO||'''
									  AND BORRADO = 0';
								
						EXECUTE IMMEDIATE V_SQL;

					ELSE

						PL_OUTPUT := PL_OUTPUT || '[ERROR] No existe un registro con esos datos' || CHR(10) ;

					END IF;

				ELSE

					PL_OUTPUT := PL_OUTPUT || '[ERROR] No existe un registro dentro del rango de fechas '''||V_FECHA_INICIO||''' y '''||V_FECHA_FIN||''' para el Usuario '||V_USU_ID_ORI||' y Sustituto  '||V_USU_ID_SUS||' ' || CHR(10) ;

				END IF;

			WHEN OPERACION = 'BAJA' THEN
				
				IF V_USU_ID_SUS IS NOT NULL THEN
				
					EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE UPPER(USU_USERNAME) = UPPER('''||V_USU_ID_SUS||''')' INTO V_AUX;
		
						IF V_AUX = 1 THEN 

						EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO
											WHERE USU_ID_ORI = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE TRIM(UPPER(USU_USERNAME)) = TRIM(UPPER('''||V_USU_ID_ORI||''')))
											AND USU_ID_SUS = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE TRIM(UPPER(USU_USERNAME)) = TRIM(UPPER('''||V_USU_ID_SUS||''')))
											AND BORRADO = 0' INTO V_AUX;
							IF V_AUX > 0 THEN
		
								IF V_FECHA_FIN IS NOT NULL THEN
		
									V_SQL := 'UPDATE '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO SET
													FECHA_FIN = '''||V_FECHA_FIN||'''
													, USUARIOBORRAR = '''||USUARIO||'''
													, FECHABORRAR = SYSDATE
													, BORRADO = 1
											  WHERE USU_ID_ORI = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE TRIM(UPPER(USU_USERNAME)) = TRIM(UPPER('''||V_USU_ID_ORI||''')))
													AND USU_ID_SUS = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE TRIM(UPPER(USU_USERNAME)) = TRIM(UPPER('''||V_USU_ID_SUS||''')))
													AND FECHA_INICIO = '''||V_FECHA_INICIO||'''
													AND BORRADO = 0 ';
								
									EXECUTE IMMEDIATE V_SQL;
		
								ELSE
		
									V_SQL := 'UPDATE '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO SET
													  USUARIOBORRAR = '''||USUARIO||'''
													, FECHABORRAR = SYSDATE
													, BORRADO = 1
											  WHERE USU_ID_ORI = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE TRIM(UPPER(USU_USERNAME)) = TRIM(UPPER('''||V_USU_ID_ORI||''')))
													AND USU_ID_SUS = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE TRIM(UPPER(USU_USERNAME)) = TRIM(UPPER('''||V_USU_ID_SUS||''')))
													AND FECHA_INICIO = '''||V_FECHA_INICIO||'''
													AND BORRADO = 0 ';
							
									EXECUTE IMMEDIATE V_SQL;									
							
								END IF;
		
							ELSE
				
								PL_OUTPUT := PL_OUTPUT || '[ERROR] No existe un registro con esos datos ' || CHR(10);
				
							END IF;
					
						ELSE
						
							PL_OUTPUT := PL_OUTPUT || '[ERROR] No existe un usuario sustituto con ese nombre de usuario ' || CHR(10) ;

						END IF;
				
					ELSE
					
						PL_OUTPUT := PL_OUTPUT || '[ERROR] No se ha informado de la variable V_USU_ID_SUS ' || CHR(10) ;
					
					END IF;

			ELSE
				PL_OUTPUT := PL_OUTPUT || '[ERROR] No se ha reconocido el código de la operación a ejecutar ' || CHR(10);

			END CASE;
			
		ELSE 
		
			PL_OUTPUT := PL_OUTPUT || '[ERROR] El usuario '||V_USU_ID_ORI||' no existe ' || CHR(10);
		
		END IF;

    ELSE

		CASE
            WHEN OPERACION IS NULL THEN		 PL_OUTPUT := PL_OUTPUT || '[ERROR] El campo OPERACION se encuentra vacio ' || CHR(10) ;
            WHEN V_USU_ID_ORI IS NULL THEN 	 PL_OUTPUT := PL_OUTPUT || '[ERROR] El campo V_USU_ID_ORI se encuentra vacio ' || CHR(10) ;
            WHEN V_FECHA_INICIO IS NULL THEN PL_OUTPUT := PL_OUTPUT || '[ERROR] El campo V_FECHA_INICIO se encuentra vacio ' || CHR(10) ;
		ELSE
            PL_OUTPUT := PL_OUTPUT || '[ERROR] Alguno de los siguientes campos se encuentra vacio : OPERACION ,V_USU_ID_ORI ,V_USU_ID_SUS ,V_FECHA_INICIO ' || CHR(10) ;
		END CASE;

    END IF;

	V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_USERS WHERE USERNAME LIKE '''||USUARIO_CONSULTA_REM||'''';

	EXECUTE IMMEDIATE V_SQL INTO V_AUX;

	IF V_AUX = 1 THEN

		V_SQL := 'GRANT EXECUTE ON '||V_ESQUEMA||'.SP_GESTOR_SUSTITUTO_WEB TO '||USUARIO_CONSULTA_REM||'';

		EXECUTE IMMEDIATE V_SQL;
	END IF;

COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END SP_GESTOR_SUSTITUTO_WEB;
/
EXIT;
