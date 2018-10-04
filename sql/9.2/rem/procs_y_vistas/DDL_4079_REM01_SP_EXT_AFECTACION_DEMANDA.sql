--/*
--#########################################
--## AUTOR=Maria Presencia
--## FECHA_CREACION=20180926
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=HREOS-4529
--## PRODUCTO=NO
--## 
--## Finalidad:  Creación del SP SP_EXT_AFECTACION_DEMANDA
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1-Maria Presencia-Versión inicial (20180924) (HREOS-4529)
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE SP_EXT_AFECTACION_DEMANDA (
	--Parametros de entrada
	ID_ACTIVO_HAYA IN #ESQUEMA#.ACT_ACTIVO.ACT_NUM_ACTIVO%TYPE,
	FLAG_ACTIVO_HAYA IN #ESQUEMA#.ACT_ACTIVO.ACT_ACTIVO_DEMANDA_AFECT_COM%TYPE,
	--Variable de salida
	COD_RETORNO OUT NUMBER  -- 0 OK / 1 KO
)
AS

	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; 	-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; 	-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	err_num NUMBER; 								-- Numero de errores
	err_msg VARCHAR2(2048);
	V_NUM NUMBER(16);
	V_COUNT NUMBER(16) := 0;	
	V_MSQL VARCHAR2(4000 CHAR);
	
	V_SEC VARCHAR2(30 CHAR) := '';
	V_TABLA_HLP VARCHAR2(30 CHAR) := 'HLP_HISTORICO_LANZA_PERIODICO';
	V_TABLA_HLD VARCHAR2(30 CHAR) := 'HLD_HISTORICO_LANZA_PER_DETA';
	V_TABLA_ACTIVO VARCHAR2(30 CHAR) := 'ACT_ACTIVO';	
	HLP_REGISTRO_EJEC VARCHAR2(1024 CHAR) := '';


BEGIN

	 DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');
	 
	 COD_RETORNO := 0;
	 
	 IF COD_RETORNO = 0 AND ID_ACTIVO_HAYA IS NULL THEN
		HLP_REGISTRO_EJEC := '[ERROR] El ID_ACTIVO_HAYA indicado como parámetro de entrada no se ha ingresado. Por favor ingrese un valor para este campo.';
		DBMS_OUTPUT.PUT_LINE(' '||HLP_REGISTRO_EJEC||' ');
		COD_RETORNO := 1;
	END IF;
	 

	IF COD_RETORNO = 0 THEN
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||' AND ACT.BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		IF V_COUNT < 1 THEN
				HLP_REGISTRO_EJEC := '[ERROR] El ID_ACTIVO_HAYA indicado no existe en la tabla ACT_ACTIVO o es un activo borrado.';
				DBMS_OUTPUT.PUT_LINE(' '||HLP_REGISTRO_EJEC||' ');
				COD_RETORNO := 1;
		END IF;
	END IF;
	
	IF COD_RETORNO = 0 THEN
	
		IF FLAG_ACTIVO_HAYA IS NULL THEN
	
			DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio de la insercion tabla : '||V_TABLA_HLD||' .');
		
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
			SELECT ''SP_EXT_AFECTACION_DEMANDA'',
			SYSDATE,
			'||ID_ACTIVO_HAYA||',
			'''||V_TABLA_ACTIVO||''',
			''ACT_ID'',
			ACT.ACT_ID,
			''ACT_ACTIVO_DEMANDA_AFECT_COM'',
			ACT.ACT_ACTIVO_DEMANDA_AFECT_COM
			FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||' AND ACT.BORRADO = 0
			';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio de la actualización tabla : '||V_TABLA_ACTIVO||' .');
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT SET ACT.ACT_ACTIVO_DEMANDA_AFECT_COM = NULL , USUARIOMODIFICAR = ''HREOS-4529'', FECHAMODIFICAR = SYSDATE WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||' AND ACT.BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL;
			
			V_COUNT := SQL%ROWCOUNT;
				
			
			DBMS_OUTPUT.PUT_LINE('[FIN] Finalizada la insercion tabla : '||V_TABLA_HLD||' .');
	 
		ELSE
		
		
			DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio de la insercion tabla : '||V_TABLA_HLD||' .');
		
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
			SELECT ''SP_EXT_AFECTACION_DEMANDA'',
			SYSDATE,
			'||ID_ACTIVO_HAYA||',
			'''||V_TABLA_ACTIVO||''',
			''ACT_ID'',
			ACT.ACT_ID,
			''ACT_ACTIVO_DEMANDA_AFECT_COM'',
			ACT.ACT_ACTIVO_DEMANDA_AFECT_COM,
			'||FLAG_ACTIVO_HAYA||'
			FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||' AND ACT.BORRADO = 0
			';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio de la actualización tabla : '||V_TABLA_ACTIVO||' .');
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT SET ACT.ACT_ACTIVO_DEMANDA_AFECT_COM = '||FLAG_ACTIVO_HAYA||' , USUARIOMODIFICAR = ''HREOS-4529'', FECHAMODIFICAR = SYSDATE WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||' AND ACT.BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL;
			
			V_COUNT := SQL%ROWCOUNT;
				
			
			DBMS_OUTPUT.PUT_LINE('[FIN] Finalizada la insercion tabla : '||V_TABLA_HLD||' .');
		
		END IF;
	 
	 DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio de la insercion tabla : '||V_TABLA_HLP||' .');
	 
	 V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLP||' (
		HLP_SP_CARGA,
		HLP_FECHA_EJEC,
		HLP_RESULTADO_EJEC,
		HLP_CODIGO_REG,
		HLP_REGISTRO_EJEC
	 )VALUES(
		''SP_EXT_AFECTACION_DEMANDA'',
		SYSDATE,
		0,
		'''||ID_ACTIVO_HAYA||' | '||FLAG_ACTIVO_HAYA||''',
		'||to_char(V_COUNT)||'
	 )';
	
	EXECUTE IMMEDIATE V_MSQL;
	 
	 END IF;

	COD_RETORNO := 0;
	
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
		''SP_EXT_AFECTACION_DEMANDA'',
		 SYSDATE,
		 1,
		 '''||ID_ACTIVO_HAYA||' | '||FLAG_ACTIVO_HAYA||''',
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
