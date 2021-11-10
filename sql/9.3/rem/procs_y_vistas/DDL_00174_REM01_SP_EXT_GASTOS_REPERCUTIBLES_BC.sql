--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210813
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14549
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

create or replace PROCEDURE       #ESQUEMA#.SP_EXT_GASTOS_REPERCUTIBLES_BC (
	      GPV_NUM_GASTO_HAYA			IN  #ESQUEMA#.GPV_GASTOS_PROVEEDOR.GPV_NUM_GASTO_HAYA%TYPE
       ,  REPERCUTIDO       			IN  VARCHAR2
       ,  FECHA_REPERCUSION	   			IN  VARCHAR2
       ,  MOTIVO_RECHAZO    			IN  VARCHAR2
       ,  RESULTADO    	   				OUT NUMBER
) AS


V_MSQL VARCHAR2(32000 CHAR); 											-- Sentencia a ejecutar.
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 								-- Configuracion Esquema.
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 					-- Configuracion Esquema Master.
ERR_NUM NUMBER(25); 													-- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); 											-- Vble. auxiliar para registrar errores en el script.
V_TABLA VARCHAR2 (50 CHAR);
V_COUNT NUMBER(1);
V_COUNT_LENGTH NUMBER(16,0);
V_RESULTADO VARCHAR2(50 CHAR);
V_NOMBRESP VARCHAR2(50 CHAR) := 'SP_EXT_GASTOS_REPERCUTIBLES_BC';			-- Nombre del SP.
V_NUMREGISTROS NUMBER(25) := 0;											-- Vble. auxiliar que guarda el número de registros actualizados
HLP_REGISTRO_EJEC VARCHAR2(1024 CHAR) := '';
GPV_ID NUMBER(16,0);													-- IDENTIFICADOR DEL GASTO

TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	T_TIPO_DATA(''''||GPV_NUM_GASTO_HAYA||'''','GPV_NUM_GASTO_HAYA'),
	T_TIPO_DATA(''''||REPERCUTIDO||'''','REPERCUTIDO'),
	T_TIPO_DATA(''''||FECHA_REPERCUSION||'''','FECHA_REPERCUSION'),
	T_TIPO_DATA(''''||MOTIVO_RECHAZO||'''','MOTIVO_RECHAZO')	
);
V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	-- Version 0.1
	
   RESULTADO := 0;

   /**************************************************************************************************************************************************************
   1.- Miramos que los parámetros obligatorios (GPV_NUM_GASTO_HAYA) del SP vengan informados.
   ***************************************************************************************************************************************************************/
   IF RESULTADO = 0 AND GPV_NUM_GASTO_HAYA IS NULL THEN
		HLP_REGISTRO_EJEC := '[ERROR] El GPV_NUM_GASTO_HAYA indicado como parámetro de entrada no se ha ingresado. Por favor ingrese un valor para este campo.';
		RESULTADO := 1;
   END IF;

   /**************************************************************************************************************************************************************
   2.- Miramos que el gasto exista en la BD por GPV_NUM_GASTO_HAYA y que pertenezca a cartera Caixa.
   ***************************************************************************************************************************************************************/
   IF RESULTADO = 0 THEN
		V_MSQL := 'SELECT GPV.GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV WHERE GPV.GPV_NUM_GASTO_HAYA = TRIM('||GPV_NUM_GASTO_HAYA||') AND GPV.BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO GPV_ID;
		IF GPV_ID IS NULL THEN
				HLP_REGISTRO_EJEC := '[ERROR] El gasto ['||GPV_NUM_GASTO_HAYA||'] no existe.';
				RESULTADO := 1;
		ELSE
			V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
						JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID AND PRO.BORRADO = 0
						JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID AND CRA.BORRADO = 0 AND CRA.DD_CRA_CODIGO = ''03''
						WHERE GPV.GPV_ID = '||GPV_ID||' AND GPV.BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
			IF V_COUNT < 1 THEN
				HLP_REGISTRO_EJEC := '[ERROR] El gasto ['||GPV_NUM_GASTO_HAYA||'] no es de la cartera Caixa.';
				RESULTADO := 1;
			ELSE 
				V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
				JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID AND EGA.BORRADO = 0 AND EGA.DD_EGA_CODIGO = ''05''
				WHERE GPV.GPV_ID = '||GPV_ID||' AND GPV.BORRADO = 0';
				EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
				IF V_COUNT < 1 THEN
					HLP_REGISTRO_EJEC := '[ERROR] El gasto ['||GPV_NUM_GASTO_HAYA||'] no está pagado.';
					RESULTADO := 1;
				END IF;
			END IF;
		END IF;
   END IF;

   /**************************************************************************************************************************************************************
   3.- Miramos que nos pasan S o N como valor repercutido
   ***************************************************************************************************************************************************************/
   IF RESULTADO = 0 THEN
		V_MSQL := 'SELECT CASE WHEN '''||REPERCUTIDO||''' IN (''S'',''N'') THEN 1 ELSE 0 END FROM DUAL';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		IF V_COUNT < 1 THEN
				HLP_REGISTRO_EJEC := '[ERROR] Repercutible solo puede tener como valores ''S'' y ''N''.';
				RESULTADO := 1;
		END IF;
		V_MSQL := 'SELECT CASE WHEN '''||REPERCUTIDO||''' = ''S'' AND '''||FECHA_REPERCUSION||''' IS NULL THEN 1 ELSE 0 END FROM DUAL';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		IF V_COUNT > 0 THEN
				HLP_REGISTRO_EJEC := '[ERROR] La fecha de repercusión es obligatoria cuando se indica que es repercutible el gasto.';
				RESULTADO := 1;
		END IF;
   END IF;

   /**************************************************************************************************************************************************************
   4.- Miramos que la cadena de texto no sobrepase los 255 caracteres
   ***************************************************************************************************************************************************************/
   IF RESULTADO = 0 THEN
		V_MSQL := 'SELECT LENGTH(TRIM('''||MOTIVO_RECHAZO||''')) FROM DUAL';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT_LENGTH;
		IF V_COUNT_LENGTH > 255 THEN
				HLP_REGISTRO_EJEC := '[ERROR] El motivo rechazo sobrepasa el límite de 255 caracteres.';
				RESULTADO := 1;
		END IF;
   END IF;

   /**************************************************************************************************************************************************************
   5.- Si el campo GPV_ID llega y no existe error, actualizamos el gasto correspondiente
   ***************************************************************************************************************************************************************/
	IF RESULTADO = 0 AND GPV_ID IS NOT NULL THEN
		V_MSQL := ' UPDATE '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE
					SET
						GGE.GGE_REPERCUTIDO = (SELECT SIN.DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO SIN WHERE SIN.DD_SIN_CODIGO = DECODE(TRIM('''||REPERCUTIDO||'''), ''S'', ''01'', ''N'', ''02''))
						, GGE.GGE_FECHA_REPERCUSION = TO_DATE(TRIM('''||FECHA_REPERCUSION||'''),''YYYYMMDD'')
						, GGE.GGE_MOTIVO_RECHAZO = TRIM('''||MOTIVO_RECHAZO||''')
						, GGE.USUARIOMODIFICAR = '''||V_NOMBRESP||'''
						, GGE.FECHAMODIFICAR = SYSDATE
					WHERE GGE.GPV_ID = '||GPV_ID||'';
		EXECUTE IMMEDIATE V_MSQL;
		V_NUMREGISTROS := SQL%ROWCOUNT;

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
	                              HLD_VALOR_ACTUALIZADO
	                            )
	                            SELECT '''||V_NOMBRESP||'''
	                                   , SYSDATE
	                                   , '||GPV_NUM_GASTO_HAYA||'
	                                   , ''GGE_GASTOS_GESTION''
	                                   , ''GPV_ID''
	                                   , '||GPV_ID||'
	                                   , '''||V_TMP_TIPO_DATA(2)||'''
	                                   , '||V_TMP_TIPO_DATA(1)||'
	                                   FROM DUAL';
	                EXECUTE IMMEDIATE V_MSQL;
	            END LOOP;
	END IF;

	/**************************************************************************************************************************************************************
	6.- Si ha habido algún error, insertamos 1 registro en la HLP con el error
	***************************************************************************************************************************************************************/
	IF RESULTADO = 1 THEN
		ROLLBACK;
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
			NVL('''||GPV_NUM_GASTO_HAYA||''',''-1''),
			'''||HLP_REGISTRO_EJEC||'''
		FROM DUAL
		';
		EXECUTE IMMEDIATE V_MSQL;
	END IF;

	/**************************************************************************************************************************************************************
    7.- Si no ha habido ningun error, insertamos 0 registro en la HLP.
    ***************************************************************************************************************************************************************/
	IF RESULTADO = 0 THEN
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
			'||GPV_NUM_GASTO_HAYA||',
			'''||V_NUMREGISTROS||'''
		FROM DUAL
		';
		EXECUTE IMMEDIATE V_MSQL;
	END IF;



	COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      RESULTADO := 1;
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
			NVL('''||GPV_NUM_GASTO_HAYA||''',''-1''),
			'''||ERR_MSG||'''
		FROM DUAL
	  ';
	  EXECUTE IMMEDIATE V_MSQL;
	  COMMIT;
      RAISE;
END SP_EXT_GASTOS_REPERCUTIBLES_BC;
/
EXIT;

