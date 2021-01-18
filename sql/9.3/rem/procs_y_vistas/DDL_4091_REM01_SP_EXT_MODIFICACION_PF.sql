--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190913
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3906
--## PRODUCTO=NO
--## 
--## Finalidad:  Creación del SP SP_EXT_MODIFICACION_PF
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1-Oscar Diestre-Versión inicial (20190416)
--##        0.2-Oscar Diestre-Inserta registros en tablas auditoría HLD y HLP (20190912)
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE       SP_EXT_MODIFICACION_PF (
         PRG_NUM_PROVISION IN  REM01.RSR_REGISTRO_SQLS.RSR_SALIDA_LOG%TYPE,
         V_USUARIO       VARCHAR2 DEFAULT 'SP_EXT_MODIFICACION_PF',
         DD_EPR_CODIGO VARCHAR2 DEFAULT NULL,
         COD_RETORNO    OUT NUMBER
) AS

--

-- GPV_NUM_GASTO_HAYA se utiliza en una expresión de tipo 'IN' con lo que puede
-- ponerse 1 o múltiples identificadores separados por ',', con limite de 400
V_SQL VARCHAR2(32000 CHAR); 											-- Sentencia a ejecutar.
V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; 								-- Configuracion Esquema.
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
V_NOMBRE_SP VARCHAR( 256 CHAR ) := 'SP_EXT_MODIFICACION_PF';
V_TABLA_HLP VARCHAR( 256 CHAR ) := 'HLP_HISTORICO_LANZA_PERIODICO';
V_TABLA_HLD VARCHAR( 256 CHAR ) := 'HLD_HISTORICO_LANZA_PER_DETA' ;
V_PRG_NUM_PROVISION VARCHAR( 256 CHAR );
V_PRG_ID NUMBER;
V_DD_EPR_ID NUMBER;
V_DD_EPR_ID_ORI NUMBER;
V_COUNT NUMBER := 0;

TYPE ProCurTyp IS REF CURSOR;
v_pro_cursor    ProCurTyp;
V_PRO_SQL VARCHAR( 1000 CHAR );


 PROCEDURE PLP$CREAR_REGISTRO_ERROR( AERROR VARCHAR2 ) IS

  BEGIN

    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA_HLP||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
    
    IF V_COUNT > 0 THEN
		
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLP||' (
			HLP_SP_CARGA,
			HLP_FECHA_EJEC,
			HLP_RESULTADO_EJEC,
			HLP_CODIGO_REG,
			HLP_REGISTRO_EJEC
		)VALUES(
		''' || V_NOMBRE_SP || ''',
		 SYSDATE,
		 1,
		 '''||PRG_NUM_PROVISION||''',
		 '''||AERROR||'''
		 )';
		  EXECUTE IMMEDIATE V_SQL;
		  
		COMMIT;
	END IF;
    COD_RETORNO := 1;

  END;

 PROCEDURE PLP$CREAR_REGISTRO_OK( AMSG VARCHAR2 ) IS

  BEGIN

    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA_HLP||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
    
    IF V_COUNT > 0 THEN
		
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLP||' (
			HLP_SP_CARGA,
			HLP_FECHA_EJEC,
			HLP_RESULTADO_EJEC,
			HLP_CODIGO_REG,
			HLP_REGISTRO_EJEC
		)VALUES(
		''' || V_NOMBRE_SP || ''',
		 SYSDATE,
		 0,
		 '''||PRG_NUM_PROVISION||''',
		 '''||AMSG||'''
		 )';
		  EXECUTE IMMEDIATE V_SQL;
		  
	END IF;
    COD_RETORNO := 1;

  END;

 PROCEDURE PLP$CREAR_REGISTRO_HLD( ACODIGO_REG NUMBER,
				   ATABLA_MODIFICAR VARCHAR2,
				   ATABLA_MODIFICAR_CLAVE VARCHAR2,
				   ATABLA_MODIFICAR_CLAVE_ID NUMBER,
				   ACAMPO_MODIFICAR VARCHAR,
				   AVALOR_ORIGINAL VARCHAR,
				   AVALOR_ACTUALIZADO VARCHAR					
				 ) IS

  BEGIN


    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA_HLD||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
    
    IF V_COUNT > 0 THEN

	 V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLD||' (
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
		    VALUES
		   (	
			''' || V_NOMBRE_SP || ''',
			 SYSDATE,
			 '  || ACODIGO_REG ||',
			 '''||ATABLA_MODIFICAR||''',
			 '''||ATABLA_MODIFICAR_CLAVE||''',
			 '  ||ATABLA_MODIFICAR_CLAVE_ID||',
			 '''||ACAMPO_MODIFICAR||''',
			 '''||AVALOR_ORIGINAL||''',
			 '''||AVALOR_ACTUALIZADO||'''

		   ) ';

		  EXECUTE IMMEDIATE V_SQL;

	END IF;

  END;
 
 PROCEDURE PLP$ACTUALIZAR_HLD IS

  BEGIN

      -- Busca el valor que debe actualizar:
    IF ( DD_EPR_CODIGO IS NOT NULL ) THEN

    	V_SQL := ' SELECT DD_EPR_ID FROM  ' || V_ESQUEMA || '.DD_EPR_ESTADOS_PROVISION_GASTO WHERE DD_EPR_CODIGO = ''' || DD_EPR_CODIGO || ''' ';
    	EXECUTE IMMEDIATE V_SQL INTO V_DD_EPR_ID;

     -- Busca las provisiones que actualizará y crea registro en HLD:
    V_PRO_SQL :=
    ' SELECT PRG_ID, PRG_NUM_PROVISION, DD_EPR_ID FROM REM01.PRG_PROVISION_GASTOS PRG
      WHERE PRG.PRG_NUM_PROVISION IN ( ' || PRG_NUM_PROVISION || '  ) ' ;

      OPEN v_pro_cursor FOR V_PRO_SQL;

      LOOP
            FETCH v_pro_cursor INTO V_PRG_ID, V_PRG_NUM_PROVISION, V_DD_EPR_ID_ORI ;
            EXIT WHEN v_pro_cursor%NOTFOUND;

      		PLP$CREAR_REGISTRO_HLD(
			     	 	V_PRG_NUM_PROVISION,
			      		'PRG_PROVISION_GASTOS',
			      		'PRG_ID',
			      		V_PRG_ID,
			      		'DD_EPR_ID',
			      		V_DD_EPR_ID_ORI,
			      		V_DD_EPR_ID
			    	    );

      END LOOP;

      CLOSE v_pro_cursor;

   END IF;

  END;


BEGIN

    COD_RETORNO := 0;

    PLP$ACTUALIZAR_HLD;

    --Actualiza PRG_PROVISION_GASTOS :
	V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.PRG_PROVISION_GASTOS T1 USING
    (
        SELECT PRG.PRG_ID
        FROM ' || V_ESQUEMA || '.PRG_PROVISION_GASTOS PRG
        WHERE PRG.PRG_NUM_PROVISION IN (  ' || PRG_NUM_PROVISION || '  )

    )T2 ON (T1.PRG_ID = T2.PRG_ID)
    WHEN MATCHED THEN
    UPDATE
    SET ' || CASE WHEN ( DD_EPR_CODIGO IS NOT NULL ) THEN ' T1.DD_EPR_ID = (SELECT DD_EPR_ID FROM  ' || V_ESQUEMA || '.DD_EPR_ESTADOS_PROVISION_GASTO WHERE DD_EPR_CODIGO = ''' || DD_EPR_CODIGO || '''), ' END
          || ' T1.USUARIOMODIFICAR = ''' || V_USUARIO || ''', '
          || ' T1.FECHAMODIFICAR = SYSDATE ' ;

        EXECUTE IMMEDIATE V_SQL;
       DBMS_OUTPUT.PUT_LINE('[INFO] - Modificados '||SQL%ROWCOUNT||' registro/s en PRG_PROVISION_GASTOS.');
       DBMS_OUTPUT.PUT_LINE('[INFO] - Modificado/s ' ||SQL%ROWCOUNT||' provision/es de gasto.');
	
      PLP$CREAR_REGISTRO_OK( ' Cambiado estado en provisión de fondos ' );	

   COMMIT;

       COD_RETORNO := 1;


EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ERR_NUM := SQLCODE;
      PLP$CREAR_REGISTRO_ERROR( 'ERROR ' || ERR_NUM );	
      RAISE;
END SP_EXT_MODIFICACION_PF;
/
EXIT
