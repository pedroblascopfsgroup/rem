--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180621
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.19
--## INCIDENCIA_LINK=HREOS-4226
--## PRODUCTO=NO
--## 
--## Finalidad:  Creación del SP_EXT_ACTUALIZA_PROVEEDOR
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1-Marco Munoz-Versión inicial (20180620)
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE SP_EXT_ACTUALIZA_PROVEEDOR 
(
	PVE_ID IN #ESQUEMA#.ACT_PVE_PROVEEDOR.PVE_ID%TYPE,
	PVE_COD_PRINEX IN #ESQUEMA#.ACT_PVE_PROVEEDOR.PVE_COD_PRINEX%TYPE,
	COD_RETORNO OUT NUMBER
)
AS

	V_ESQUEMA VARCHAR2(25 CHAR):=  '#ESQUEMA#'; 		-- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	err_num NUMBER; 									-- Numero de errores
	err_msg VARCHAR2(2048);
	V_NUM NUMBER(16);
	V_COUNT NUMBER(16) := 0;	
	V_COUNT2 NUMBER(16) := 0;
	V_MSQL VARCHAR2(4000 CHAR);
	V_NOTABLES NUMBER(1) := 0;	
	HLP_REGISTRO_EJEC VARCHAR2(1024 CHAR) := ''; 
	
	V_SEC VARCHAR2(30 CHAR) := '';
	V_TABLA_HLP VARCHAR2(30 CHAR) := 'HLP_HISTORICO_LANZA_PERIODICO';
	V_TABLA_HLD VARCHAR2(30 CHAR) := 'HLD_HISTORICO_LANZA_PER_DETA';
	V_TABLA_PROVEEDOR VARCHAR2(30 CHAR) := 'ACT_PVE_PROVEEDOR';	
	
BEGIN
	
	--v0.1
	 DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de actualización de campos de proveedor.');
	 
	 COD_RETORNO := 0;
	 
	 /*****************************************************************   
     1.- Miramos que el parámetro obligatorio del SP (PVE_ID) venga informado
     ******************************************************************/
	 IF COD_RETORNO = 0 AND PVE_ID IS NULL THEN 
		HLP_REGISTRO_EJEC := '[ERROR] El PVE_ID indicado como parámetro de entrada es obligatorio y no se ha ingresado. Por favor ingrese un valor válido para este campo.';
		COD_RETORNO := 1;
	 END IF; 
	 
	 /*****************************************************************   
     2.- Miramos que el proveedor exista en la ACT_PVE_PROVEEDOR.
     ******************************************************************/  
	 IF COD_RETORNO = 0 THEN 
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_PROVEEDOR||' PVE WHERE PVE.PVE_ID = '''||PVE_ID||''' ';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT2;
		IF V_COUNT2 < 1 THEN
				HLP_REGISTRO_EJEC := '[ERROR] El proveedor con PVE_ID ['||PVE_ID||'] no existe en la tabla ACT_PVE_PROVEEDOR.';
				COD_RETORNO := 1;
		END IF;
     END IF;
	 	
	 /*****************************************************************   
     3.- Comprobamos que las tablas donde vamos a escribir (HLP y HLD) existan.
     ******************************************************************/   
     IF COD_RETORNO = 0 THEN 
          V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME IN (''HLP_HISTORICO_LANZA_PERIODICO'',''HLD_HISTORICO_LANZA_PER_DETA'') AND OWNER LIKE '''||V_ESQUEMA||'''';
          EXECUTE IMMEDIATE V_MSQL INTO V_COUNT2;

          IF V_COUNT2 > 1 AND COD_RETORNO = 0 THEN
              DBMS_OUTPUT.PUT_LINE('[INFO] Existen las tablas HLP_HISTORICO_LANZA_PERIODICO y HLD_HISTORICO_LANZA_PER_DETA. Continuamos la ejecución.');
          ELSE          
              HLP_REGISTRO_EJEC := '[ERROR] No existe la tabla HLP_HISTORICO_LANZA_PERIODICO ó la HLD_HISTORICO_LANZA_PER_DETA. O no existen ambas. Paramos la ejecución.';
              DBMS_OUTPUT.PUT_LINE(HLP_REGISTRO_EJEC);
              COD_RETORNO := 1;
              V_NOTABLES := 1;
          END IF;
     END IF;
   	 
	 
	 /*****************************************************************   
     4.- Insertamos en la ACT_PVE_PROVEEDOR.
     ******************************************************************/ 
	 --Si no ha habido errores y existen las tablas HLP y HLD
	 IF COD_RETORNO = 0 AND V_NOTABLES = 0 THEN									
	 	  	 
	 	  	 --Si el PVE_COD_PRINEX pasado por parámetro es nulo insertamos un nulo para ese PVE_ID. Más 1 registro en la HLD.
			 IF PVE_COD_PRINEX IS NULL THEN
			 
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
				 SELECT 
					 ''SP_EXT_ACTUALIZA_PROVEEDOR'',
					 SYSDATE,
					 '||PVE_ID||',
					 '''||V_TABLA_PROVEEDOR||''',
					 ''PVE_ID'',
					 PVE.PVE_ID,
					 ''PVE_COD_PRINEX'',
					 PVE.PVE_COD_PRINEX
				 FROM '||V_ESQUEMA||'.'||V_TABLA_PROVEEDOR||' PVE WHERE PVE.PVE_ID = '||PVE_ID||' AND PVE.BORRADO = 0
				 ';
				 EXECUTE IMMEDIATE V_MSQL;
				 
				 V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_PROVEEDOR||' PVE 
							SET PVE.PVE_COD_PRINEX = NULL, USUARIOMODIFICAR = ''HREOS-4226'', FECHAMODIFICAR = SYSDATE 
							WHERE PVE.PVE_ID = '||PVE_ID||' AND PVE.BORRADO = 0';
				 EXECUTE IMMEDIATE V_MSQL;
				 
				 V_COUNT := SQL%ROWCOUNT;
				 
			 --Si el PVE_COD_PRINEX pasado por parámetro no es nulo, lo insertamos para ese PVE_ID.	Más 1 registro en la HLD.
			 ELSE
			 
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
				 SELECT 
					 ''SP_EXT_ACTUALIZA_PROVEEDOR'',
					 SYSDATE,
					 '||PVE_ID||',
					 '''||V_TABLA_PROVEEDOR||''',
					 ''PVE_ID'',
					 PVE.PVE_ID,
					 ''PVE_COD_PRINEX'',
					 PVE.PVE_COD_PRINEX,
					 '''||PVE_COD_PRINEX||'''
				 FROM '||V_ESQUEMA||'.'||V_TABLA_PROVEEDOR||' PVE WHERE PVE.PVE_ID = '||PVE_ID||' AND PVE.BORRADO = 0
				 ';
				 EXECUTE IMMEDIATE V_MSQL;
				 
				 V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_PROVEEDOR||' PVE 
							SET PVE.PVE_COD_PRINEX = '||PVE_COD_PRINEX||', USUARIOMODIFICAR = ''HREOS-4226'', FECHAMODIFICAR = SYSDATE 
							WHERE PVE.PVE_ID = '||PVE_ID||' AND PVE.BORRADO = 0';
				 EXECUTE IMMEDIATE V_MSQL;
				 
				 V_COUNT := SQL%ROWCOUNT;
			
			END IF;
			
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLP||' (
				HLP_SP_CARGA,
				HLP_FECHA_EJEC,
				HLP_RESULTADO_EJEC,
				HLP_CODIGO_REG,
				HLP_REGISTRO_EJEC
			)VALUES(
				''SP_EXT_ACTUALIZA_PROVEEDOR'',
				 SYSDATE,
				 0,
				 '||PVE_ID||',
				 '||TO_CHAR(V_COUNT)||'
			 )';
			EXECUTE IMMEDIATE V_MSQL;
			  
			COD_RETORNO := 0;
	 
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
			''SP_EXT_ACTUALIZA_PROVEEDOR'',
			SYSDATE,
			1,
			NVL('''||PVE_ID||''',''-1''),
			'''||HLP_REGISTRO_EJEC||'''
		FROM DUAL
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] - Ha habido errores. Se inserta '||SQL%ROWCOUNT||' registro en la HLP_HISTORICO_LANZA_PERIODICO.');		
    END IF;
	
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
		 '||PVE_ID||',
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
