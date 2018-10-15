--/*
--#########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20180809
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=REMVIP-1506
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE #ESQUEMA#.SP_EXT_GESTOR_SUSTITUTO
        (
        --Parametros de entrada
		 SGS_ID 		IN 	NUMBER	--Obligatorio
        ,USU_ID_SUS 	IN 	NUMBER
        ,FECHA_INICIO 	IN 	VARCHAR2
        ,FECHA_FIN 		IN 	VARCHAR2
        
        --Variables de salida
        ,PL_OUTPUT		OUT VARCHAR2
		,COD_RETORNO    OUT VARCHAR2 -- 0 OK / 1 KO
    )

   AS

   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_AUX NUMBER(10); -- Variable auxiliar
   USUARIO VARCHAR2(50 CHAR):= 'SP_EXT_GESTOR_SUSTITUTO';
   USUARIO_CONSULTA_REM VARCHAR2(50 CHAR):= 'REM_EXT';
   V_USU_ID_SUS NUMBER(10);    
   V_FECHA_INICIO VARCHAR2(100 CHAR);
   V_FECHA_FIN VARCHAR2(100 CHAR);
   V_LOGAR_HDL VARCHAR2(1400 CHAR) := 'HLD_HIST_LANZA_PER_DETA(''SP_EXT_GESTOR_SUSTITUTO'',:1,:2,:3,:4,:5,:6,:7)'; 
   USU_ID_SUS_ANT VARCHAR(50 CHAR);
   FECHA_INICIO_ANT VARCHAR2(50 CHAR);
   FECHA_FIN_ANT VARCHAR2(50 CHAR);
   PARAM1 VARCHAR2(50 CHAR);
   PARAM2 VARCHAR2(50 CHAR);
   PARAM3 VARCHAR2(50 CHAR);


    --Excepciones
    ERR_NEGOCIO EXCEPTION;

    --Procedure que inserta en HLD_HISTORICO_LANZA_PER_DETA, sin comitear.
    PROCEDURE HLD_HIST_LANZA_PER_DETA (
      HLD_CODIGO_REG                  IN VARCHAR2,
      HLD_TABLA_MODIFICAR             IN VARCHAR2,
      HLD_TABLA_MODIFICAR_CLAVE       IN VARCHAR2,
      HLD_TABLA_MODIFICAR_CLAVE_ID    IN NUMBER,
      HLD_CAMPO_MODIFICAR             IN VARCHAR2,
      HLD_VALOR_ORIGINAL              IN VARCHAR2,
      HLD_VALOR_ACTUALIZADO           IN VARCHAR2
    ) IS

BEGIN

    V_SQL := '
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
      SELECT
        ''SP_EXT_GESTOR_SUSTITUTO'',
        SYSDATE,
        TO_NUMBER('''||HLD_CODIGO_REG||'''),
        '''||HLD_TABLA_MODIFICAR||''',
        '''||HLD_TABLA_MODIFICAR_CLAVE||''',
        '||HLD_TABLA_MODIFICAR_CLAVE_ID||',
        '''||HLD_CAMPO_MODIFICAR||''',
        '''||HLD_VALOR_ORIGINAL||''',
        '''||HLD_VALOR_ACTUALIZADO||'''
      FROM DUAL
      ';
      EXECUTE IMMEDIATE V_SQL;

      IF SQL%ROWCOUNT = 1 THEN
         DBMS_OUTPUT.PUT_LINE('[INFO] HLD_HISTORICO_LANZA_PER_DETA | Registro insertado correctamente, no comiteado.');
      ELSE
         DBMS_OUTPUT.PUT_LINE('[ERROR] HLD_HISTORICO_LANZA_PER_DETA | No se ha podido insertar el registro correctamente.');
      END IF;

    END;

BEGIN

	IF SGS_ID IS NOT NULL THEN

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO WHERE SGS_ID = '||SGS_ID||'';

        EXECUTE IMMEDIATE V_SQL INTO V_AUX;

        IF V_AUX > 0 THEN

			V_SQL := 'SELECT TO_CHAR(FECHA_INICIO,''DD/MM/RR'') FROM '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO WHERE SGS_ID = '||SGS_ID||'';

			EXECUTE IMMEDIATE V_SQL INTO FECHA_INICIO_ANT;

			V_SQL := 'SELECT TO_CHAR(FECHA_FIN,''DD/MM/RR'') FROM '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO WHERE SGS_ID = '||SGS_ID||'';

			EXECUTE IMMEDIATE V_SQL INTO FECHA_FIN_ANT;

			V_SQL := 'SELECT TO_CHAR(USU_ID_SUS) FROM '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO WHERE SGS_ID = '||SGS_ID||'';

			EXECUTE IMMEDIATE V_SQL INTO USU_ID_SUS_ANT;
			
            IF USU_ID_SUS IS NOT NULL THEN 

                V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_ID = '||USU_ID_SUS||'';

                EXECUTE IMMEDIATE V_SQL INTO V_AUX;

                IF V_AUX > 0 THEN

                    V_USU_ID_SUS := USU_ID_SUS;

                END IF;

            ELSE 

                V_SQL := 'SELECT USU_ID_SUS FROM SGS_GESTOR_SUSTITUTO WHERE SGS_ID = '||SGS_ID||'';

                EXECUTE IMMEDIATE V_SQL INTO V_USU_ID_SUS;

                V_AUX := 1;

            END IF;           

                IF V_AUX > 0 THEN

                    IF FECHA_INICIO IS NOT NULL THEN

                        V_FECHA_INICIO := TO_DATE(TO_DATE(''||FECHA_INICIO||'','DD/MM/RRRR'),'DD/MM/RR');

                    ELSE 

                        V_SQL := 'SELECT FECHA_INICIO FROM '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO WHERE SGS_ID = '||SGS_ID||'';

                        EXECUTE IMMEDIATE V_SQL INTO V_FECHA_INICIO;

                    END IF ;

                    IF FECHA_FIN IS NOT NULL THEN

                        V_FECHA_FIN := TO_DATE(TO_DATE(''||FECHA_FIN||'','DD/MM/RRRR'),'DD/MM/RR');

                    ELSE 

                        V_SQL := 'SELECT FECHA_FIN FROM '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO WHERE SGS_ID = '||SGS_ID||'';

                        EXECUTE IMMEDIATE V_SQL INTO V_FECHA_FIN;

                    END IF ;

                    V_SQL := 'UPDATE '||V_ESQUEMA||'.SGS_GESTOR_SUSTITUTO 
                                SET USU_ID_SUS = '||V_USU_ID_SUS||'
                                    ,FECHA_INICIO = '''||V_FECHA_INICIO||'''
                                    ,FECHA_FIN = '''||V_FECHA_FIN||'''
                                    ,USUARIOMODIFICAR = '''||USUARIO||'''
                                    ,FECHAMODIFICAR = SYSDATE
                                WHERE SGS_ID = '||SGS_ID||'';

                    EXECUTE IMMEDIATE V_SQL;
                                        
                     --Comprobamos si se ha actualizado o no
					IF SQL%ROWCOUNT > 0 THEN
						DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado correctamente el registro con ID '||SGS_ID||' .');
						--Logado en HLD_HIST_LANZA_PER_DETA
						PARAM1 := 'SGS_GESTOR_SUSTITUTO';
						PARAM2 := 'SGS_ID';
						PARAM3 := 'USU_ID_SUS';
						HLD_HIST_LANZA_PER_DETA (TO_CHAR(SGS_ID), PARAM1, PARAM2, SGS_ID, PARAM3, USU_ID_SUS_ANT, V_USU_ID_SUS);
						PARAM1 := 'SGS_GESTOR_SUSTITUTO';
						PARAM2 := 'SGS_ID';
						PARAM3 := 'FECHA_INICIO';
						HLD_HIST_LANZA_PER_DETA (TO_CHAR(SGS_ID), PARAM1, PARAM2, SGS_ID, PARAM3, FECHA_INICIO_ANT, V_FECHA_INICIO);
						PARAM1 := 'SGS_GESTOR_SUSTITUTO';
						PARAM2 := 'SGS_ID';
						PARAM3 := 'FECHA_FIN';
						HLD_HIST_LANZA_PER_DETA (TO_CHAR(SGS_ID), PARAM1, PARAM2, SGS_ID, PARAM3, FECHA_FIN_ANT, V_FECHA_FIN);
						
						V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''HLP_HISTORICO_LANZA_PERIODICO''';
						EXECUTE IMMEDIATE V_SQL INTO V_AUX;

						IF V_AUX > 0 THEN

							V_SQL := 'INSERT INTO '||V_ESQUEMA||'.HLP_HISTORICO_LANZA_PERIODICO (
								HLP_SP_CARGA,
								HLP_FECHA_EJEC,
								HLP_RESULTADO_EJEC,
								HLP_CODIGO_REG,
								HLP_REGISTRO_EJEC
							)VALUES(
							''SP_EXT_GESTOR_SUSTITUTO'',
							 SYSDATE,
							 0,
							 '''||SGS_ID||''',
							 1
							 )';
							  EXECUTE IMMEDIATE V_SQL;

							COMMIT;
						END IF;
					ELSE
						COD_RETORNO := 1;
						ERR_MSG := '[ERROR] Ha fallado la actualizacion del registro';
					END IF;

                ELSE

                    ERR_MSG :=  '[ERROR]No existe ningún usuario con el siguiente id ' ||USU_ID_SUS||'.' ;

                END IF;

        ELSE

            ERR_MSG := '[ERROR]No existe ningún registro en la tabla con el SGS_ID ' ||SGS_ID||' indicado ';

        END IF;

    ELSE

        ERR_MSG :=  '[ERROR]La variable SGS_ID no viene informada ' ;

    END IF;

DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

COMMIT;

EXCEPTION
	WHEN OTHERS THEN
	ERR_NUM := SQLCODE;
	ERR_MSG := SQLERRM;
	PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
	PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    '||ERR_MSG;
	ROLLBACK;
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''HLP_HISTORICO_LANZA_PERIODICO''';
    EXECUTE IMMEDIATE V_SQL INTO V_AUX;

    IF V_AUX > 0 THEN

		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.HLP_HISTORICO_LANZA_PERIODICO (
			HLP_SP_CARGA,
			HLP_FECHA_EJEC,
			HLP_RESULTADO_EJEC,
			HLP_CODIGO_REG,
			HLP_REGISTRO_EJEC
		)VALUES(
		''SP_EXT_GESTOR_SUSTITUTO'',
		 SYSDATE,
		 1,
		 '''||ERR_NUM||''',
		 '''||SQLERRM||'''
		 )';
		  EXECUTE IMMEDIATE V_SQL;

		COMMIT;
	END IF;
    COD_RETORNO := 1;
    RAISE;
END SP_EXT_GESTOR_SUSTITUTO;
/

EXIT
