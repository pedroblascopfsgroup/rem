--/*
--##########################################
--## AUTOR=Guillermo Llidó
--## FECHA_CREACION=20180621
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1038
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

CREATE OR REPLACE PROCEDURE #ESQUEMA#.SP_GESTOR_SUSTITUTO
    (     
		  OPERACION VARCHAR2
        , V_USU_ID_ORI IN NUMBER
        , V_USU_ID_SUS IN NUMBER
        , V_FECHA_INICIO IN VARCHAR2
        , V_FECHA_FIN IN VARCHAR2
        , PL_OUTPUT OUT VARCHAR2
    )

   AS

   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_AUX NUMBER(1); -- Variable auxiliar
   USUARIO VARCHAR2(50 CHAR):= 'SP_GESTOR_SUSTITUTO';

BEGIN
    IF (OPERACION IS NOT NULL )AND (V_USU_ID_ORI IS NOT NULL) AND (V_USU_ID_SUS IS NOT NULL) AND (V_FECHA_INICIO IS NOT NULL) THEN 

       CASE 

        WHEN OPERACION = 'ALTA' THEN

			EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO 
									WHERE USU_ID_ORI = '||V_USU_ID_ORI||' 
									AND (FECHA_FIN > '''||V_FECHA_FIN||''' OR FECHA_FIN IS NULL) 
									AND FECHA_INICIO < '''||V_FECHA_INICIO||'''
									AND BORRADO = 0' INTO V_AUX;
			IF V_AUX = 0 THEN	

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
									,'||V_USU_ID_ORI||'
									,'||V_USU_ID_SUS||'
									,TO_DATE('''||V_FECHA_INICIO||''',''DD/MM/YYYY'')
									,TO_DATE('''||V_FECHA_FIN||''',''DD/MM/YYYY'')
									,'''||USUARIO||'''
									,SYSDATE 
									,NULL
									,NULL
									,NULL
									,NULL
									)';

				EXECUTE IMMEDIATE V_SQL;

				PL_OUTPUT := '[INFO] El nuevo registro se ha dado de alta correctamente ';

			  ELSE

				PL_OUTPUT := '[ERROR] Ya existe un registro con ese rango de fechas';

			  END IF;

        WHEN OPERACION = 'MOD' THEN

            EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO 
									WHERE USU_ID_ORI = '||V_USU_ID_ORI||' 
									AND USU_ID_SUS = '||V_USU_ID_SUS||'
									AND FECHA_FIN >= '''||V_FECHA_FIN||'''
									AND FECHA_INICIO <= '''||V_FECHA_INICIO||'''
									AND BORRADO = 0' INTO V_AUX;

			IF V_AUX = 0 THEN

				EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO 
										WHERE USU_ID_ORI = '||V_USU_ID_ORI||' 					
										AND USU_ID_SUS = '||V_USU_ID_SUS||'
										AND FECHA_INICIO = '''||V_FECHA_INICIO||'''
										AND BORRADO = 0' INTO V_AUX;

				IF V_AUX > 0 THEN	

					V_SQL := 'UPDATE '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO SET 
								  FECHA_FIN = TO_DATE('''||V_FECHA_FIN||''',''DD/MM/YYYY'')
								, USUARIOMODIFICAR = '''||USUARIO||'''
								, FECHAMODIFICAR = SYSDATE
                                WHERE USU_ID_ORI = '||V_USU_ID_ORI||'
								  AND USU_ID_SUS = '||V_USU_ID_SUS||'
								  AND FECHA_INICIO = '''||V_FECHA_INICIO||'''
								  AND BORRADO = 0';

					EXECUTE IMMEDIATE V_SQL;

					PL_OUTPUT := '[INFO] El nuevo registro se ha modificado correctamente ';

				ELSE

					PL_OUTPUT := '[ERROR] No existe un registro con esos datos';

				END IF;

			ELSE

				PL_OUTPUT := '[ERROR] Ya existe un registro dentro del rango de fechas TO_DATE('''||V_FECHA_INICIO||''',''DD/MM/YYYY'') y TO_DATE('''||V_FECHA_FIN||''',''DD/MM/YYYY'') para el Usuario '||V_USU_ID_ORI||' y Sustituto  '||V_USU_ID_SUS||' ';			

			END IF;	

        WHEN OPERACION = 'BAJA' THEN

            EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO 
									WHERE USU_ID_ORI = '||V_USU_ID_ORI||' 					
									AND USU_ID_SUS = '||V_USU_ID_SUS||'
									AND FECHA_INICIO = '''||V_FECHA_INICIO||'''
									AND BORRADO = 0' INTO V_AUX;
            IF V_AUX > 0 THEN 

				IF V_FECHA_FIN IS NOT NULL THEN

					V_SQL := 'UPDATE '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO SET 
									FECHA_FIN = TO_DATE('''||V_FECHA_FIN||''',''DD/MM/YYYY'') 
									, USUARIOBORRAR = '''||USUARIO||'''
									, FECHABORRAR = SYSDATE
									, BORRADO = 1 
							  WHERE USU_ID_ORI = '||V_USU_ID_ORI||'
									AND USU_ID_SUS = '||V_USU_ID_SUS||'
									AND FECHA_INICIO = '''||V_FECHA_INICIO||'''
									AND BORRADO = 0 ';

					EXECUTE IMMEDIATE V_SQL;

					PL_OUTPUT := '[INFO] El registro se ha borrado correctamente ';

				ELSE 

					V_SQL := 'UPDATE '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO SET 
									  USUARIOBORRAR = '''||USUARIO||'''
									, FECHABORRAR = SYSDATE
									, BORRADO = 1 
							  WHERE USU_ID_ORI = '||V_USU_ID_ORI||'
									AND USU_ID_SUS = '||V_USU_ID_SUS||'
									AND FECHA_INICIO = '''||V_FECHA_INICIO||'''
									AND BORRADO = 0 ';

					EXECUTE IMMEDIATE V_SQL;

					PL_OUTPUT := '[INFO] El registro se ha borrado correctamente ';					
				END IF;

            ELSE 

               	PL_OUTPUT := '[ERROR] No existe un registro con esos datos ';

            END IF;

        ELSE
            PL_OUTPUT := '[ERROR] No se ha reconocido el código de la operación a ejecutar '; 

        END CASE;

    ELSE 

		CASE
            WHEN OPERACION IS NULL THEN		 PL_OUTPUT := '[ERROR] El campo OPERACION se encuentra vacio '; 
            WHEN V_USU_ID_ORI IS NULL THEN 	 PL_OUTPUT := '[ERROR] El campo V_USU_ID_ORI se encuentra vacio '; 	
            WHEN V_USU_ID_SUS IS NULL THEN 	 PL_OUTPUT := '[ERROR] El campo V_USU_ID_SUS se encuentra vacio '; 
            WHEN V_FECHA_INICIO IS NULL THEN PL_OUTPUT := '[ERROR] El campo V_FECHA_INICIO se encuentra vacio '; 
		ELSE 
            PL_OUTPUT := '[ERROR] Alguno de los siguientes campos se encuentra vacio : OPERACION ,V_USU_ID_ORI ,V_USU_ID_SUS ,V_FECHA_INICIO '; 
		END CASE;

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
END #ESQUEMA#.SP_GESTOR_SUSTITUTO;
/
EXIT;
