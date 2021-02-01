--/*
--######################################### 
--## AUTOR=CARLOS MUÑOZ
--## FECHA_CREACION=20180808
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4402
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##                    
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


CREATE OR REPLACE PROCEDURE #ESQUEMA#.SP_EXT_CARTERIZA_USUARIO (

    --Parametros de entrada
    USU_USERNAME IN #ESQUEMA_MASTER#.USU_USUARIOS.USU_USERNAME%TYPE,
    DD_CRA_DESCRIPCION IN #ESQUEMA#.DD_CRA_CARTERA.DD_CRA_DESCRIPCION%TYPE,
    --Variables de salida
    PL_OUTPUT                   OUT VARCHAR2 -- 0 OK / 1 KO - Información de la ejecución	

) AS

    --Configuracion
    V_ESQUEMA                   VARCHAR2(15 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_MASTER            VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';

	--Sentencia a ejecutar
	V_SQL 						VARCHAR2(32000 CHAR);         
   

	RESULTADO     NUMBER;
	
BEGIN
		
	
     #ESQUEMA#.CARTERIZA_USUARIO(USU_USERNAME, DD_CRA_DESCRIPCION, PL_OUTPUT);
     
     RESULTADO := INSTR(PL_OUTPUT, '[ERROR]');
     
     IF RESULTADO > 0 THEN 
		V_SQL := 'INSERT INTO '|| V_ESQUEMA || '.HLP_HISTORICO_LANZA_PERIODICO (
			HLP_SP_CARGA, 
			HLP_FECHA_EJEC, 
			HLP_RESULTADO_EJEC,
			HLP_CODIGO_REG,
			HLP_REGISTRO_EJEC
		) VALUES (
			''SP_EXT_CARTERIZA_USUARIO'',
			SYSDATE,
			1,
			'''||USU_USERNAME|| ' - ' || DD_CRA_DESCRIPCION || ''',
			'''||PL_OUTPUT||'''
		)' ;
		
		EXECUTE IMMEDIATE V_SQL;
	
	ELSE
		
		V_SQL := 'INSERT INTO '|| V_ESQUEMA || '.HLP_HISTORICO_LANZA_PERIODICO (
			HLP_SP_CARGA, 
			HLP_FECHA_EJEC, 
			HLP_RESULTADO_EJEC,
			HLP_CODIGO_REG,
			HLP_REGISTRO_EJEC
		) VALUES (
			''SP_EXT_CARTERIZA_USUARIO'',
			SYSDATE,
			0,
			'''||USU_USERNAME|| ' - ' || DD_CRA_DESCRIPCION || ''',
			'' ''
		)' ;
		
		EXECUTE IMMEDIATE V_SQL;
		
	END IF;
     
     DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
     COMMIT;

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
        
END SP_EXT_CARTERIZA_USUARIO;

/

EXIT;
