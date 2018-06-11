--/*
--#########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=HREOS-4190
--## PRODUCTO=NO
--## 
--## Finalidad:  Creación del SP SP_EXT_ACTUALIZA_PROMOCION
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1-Sergio Ortuño-Versión inicial (20180608)
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE SP_EXT_ACTUALIZA_PROMOCION (
	ID_ACTIVO_HAYA IN #ESQUEMA#.ACT_ACTIVO.ACT_NUM_ACTIVO%TYPE,
	CODIGO_PROMOCION IN #ESQUEMA#.ACT_ACTIVO.ACT_COD_PROMOCION_PRINEX%TYPE,
	COD_RETORNO OUT NUMBER
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
	CODIGO_ANTERIOR #ESQUEMA#.ACT_ACTIVO.ACT_COD_PROMOCION_PRINEX%TYPE;
BEGIN
	--v0.1
	 DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');
	 	 
	 
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
	 1,
	 ''ACT_COD_PROMOCION_PRINEX'',
	 NVL(ACT.ACT_COD_PROMOCION_PRINEX,0),
	 '''||CODIGO_PROMOCION||'''
	 FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA||'
	 ';
	 EXECUTE IMMEDIATE V_MSQL;
	 
	 V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT SET ACT.ACT_COD_PROMOCION_PRINEX = '||CODIGO_PROMOCION||', USUARIOMODIFICAR = ''HREOS-4190'', FECHAMODIFICAR = SYSDATE WHERE ACT.ACT_NUM_ACTIVO = '||ID_ACTIVO_HAYA;--
	 EXECUTE IMMEDIATE V_MSQL;
	 
	 V_COUNT := SQL%ROWCOUNT;
	 
	 
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
	 '||ID_ACTIVO_HAYA||',
	 '||to_char(V_COUNT)||'
	 )';
	  EXECUTE IMMEDIATE V_MSQL;
	  
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
		''SP_EXT_ACTUALIZA_PROMOCION'',
		 SYSDATE,
		 1,
		 '||ID_ACTIVO_HAYA||',
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
