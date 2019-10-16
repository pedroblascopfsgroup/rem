--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20191017
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5473
--## PRODUCTO=NO
--## 
--## Finalidad:  Creación del SP SP_EXT_MODIFICACION_ESTADOS
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1-Oscar Diestre-Versión inicial (20190412)
--##        0.2-Oscar Diestre-Corrección error. No actualiza DD_EAP_ID y permitir nulos
--##        0.3-Viorel Remus Ovidiu-REMVIP-5473-Corrección error, tamaño de linea en historico
--##        0.3-Oscar Diestre-REMVIP-5473-Corrección error
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE       SP_EXT_MODIFICACION_ESTADOS (
         GPV_NUM_GASTO_HAYA IN  REM01.RSR_REGISTRO_SQLS.RSR_SALIDA_LOG%TYPE,
         V_USUARIO       VARCHAR2 DEFAULT 'SP_EXT_MODIFICACION_ESTADOS',

         DD_EGA_CODIGO VARCHAR2 DEFAULT NULL,
	 UPDATE_DD_EGA INTEGER DEFAULT 0,

         DD_EAH_CODIGO VARCHAR2 DEFAULT NULL,
	 UPDATE_DD_EAH INTEGER DEFAULT 0,

         DD_EAP_CODIGO VARCHAR2 DEFAULT NULL,    
	 UPDATE_DD_EAP INTEGER DEFAULT 0,

         GGE_FECHA_EAH DATE DEFAULT NULL,
	 UPDATE_FECHA_EAH INTEGER DEFAULT 0,

         GGE_FECHA_EAP DATE DEFAULT NULL,
	 UPDATE_FECHA_EAP INTEGER DEFAULT 0,

         PRG_ID INTEGER DEFAULT NULL,
	 UPDATE_PRG_ID INTEGER DEFAULT 0,

         GGE_FECHA_ENVIO_PRPTRIO DATE DEFAULT NULL,
	 UPDATE_FECHA_ENVIO_PRPTRIO INTEGER DEFAULT 0,

	 GGE_MOTIVO_RECHAZO_PROP VARCHAR2 DEFAULT NULL,
	 UPDATE_MOTIVO_RECHAZO_PROP INTEGER DEFAULT 0,

	 GPV_EXISTE_DOCUMENTO INTEGER DEFAULT NULL,
	 UPDATE_EXISTE_DOCUMENTO INTEGER DEFAULT 0,

	 GDE_IMP_IND_TIPO_IMPOSITIVO INTEGER DEFAULT NULL,
	 UPDATE_IMP_IND_TIPO_IMPOSITIVO INTEGER DEFAULT 0,

         COD_RETORNO    OUT NUMBER
) AS

--

-- GPV_NUM_GASTO_HAYA se utiliza en una expresión de tipo 'IN' con lo que puede
-- ponerse 1 o múltiples identificadores separados por ',', con limite de 400
V_SQL VARCHAR2(32000 CHAR); 											-- Sentencia a ejecutar.
V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; 								-- Configuracion Esquema.
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
V_COUNT NUMBER( 25 );

V_NOMBRE_SP VARCHAR( 256 CHAR ) := 'SP_EXT_MODIFICACION_ESTADOS';
V_TABLA_HLP VARCHAR( 256 CHAR ) := 'HLP_HISTORICO_LANZA_PERIODICO';
V_TABLA_HLD VARCHAR( 256 CHAR ) := 'HLD_HISTORICO_LANZA_PER_DETA' ;

----------------------------------
TYPE CurTyp IS REF CURSOR;
v_cursor    CurTyp;
----------------------------------

V_DD_EAH_ID NUMBER(25);
V_DD_EAP_ID NUMBER(25);

V_GGE_ID NUMBER(25);
V_DD_EAH_ID_ORI VARCHAR2( 32 CHAR );
V_DD_EAP_ID_ORI VARCHAR2( 32 CHAR );
V_GGE_FECHA_EAH VARCHAR2( 32 CHAR );
V_GGE_FECHA_EAP VARCHAR2( 32 CHAR );
V_GGE_FECHA_ENVIO_PRPTRIO VARCHAR( 32 CHAR );
V_GGE_MOTIVO_RECHAZO_PROP VARCHAR( 32 CHAR );
V_GPV_NUM_GASTO_HAYA VARCHAR( 32 CHAR );

V_GDE_ID NUMBER(25);
V_GDE_IMP_IND_TIPO_IMPOSITIVO NUMBER;

V_DD_EGA_ID NUMBER( 25 );
V_DD_EGA_ID_ORI VARCHAR2( 25 CHAR );
V_PRG_ID NUMBER( 25 );
V_GPV_EXISTE_DOCUMENTO NUMBER( 1 );
V_GPV_ID NUMBER( 25 );


  FUNCTION ACT_GGE_GESTION_GASTOS RETURN NUMBER  IS
  BEGIN

   IF (
	   ( UPDATE_DD_EAH = 1 )	
 	OR ( UPDATE_FECHA_EAH = 1 )
	OR ( UPDATE_DD_EAP = 1 )
	OR ( UPDATE_FECHA_EAP = 1 )
	OR ( UPDATE_FECHA_ENVIO_PRPTRIO = 1 )
	OR ( UPDATE_MOTIVO_RECHAZO_PROP = 1 )
      ) THEN RETURN 1;
	ELSE RETURN 0;
   END IF;		

  END;

  FUNCTION ACT_GDE_GASTOS_DETALLE_ECONOMICO RETURN NUMBER  IS
  BEGIN

   IF (
	   ( UPDATE_IMP_IND_TIPO_IMPOSITIVO = 1 )
      ) THEN RETURN 1;
	ELSE RETURN 0;
   END IF;		

  END;

  FUNCTION ACT_GPV_GASTOS_PROVEEDOR RETURN NUMBER  IS
  BEGIN

   IF (
	   ( UPDATE_DD_EGA = 1 )
	OR ( UPDATE_PRG_ID = 1 )
	OR ( UPDATE_EXISTE_DOCUMENTO = 1 )
      ) THEN RETURN 1;
	ELSE RETURN 0;
   END IF;		

  END;


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
		 SUBSTR('''||GPV_NUM_GASTO_HAYA||''', 1, 50),
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
		 SUBSTR('''||GPV_NUM_GASTO_HAYA||''', 1, 50),
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
 

 PROCEDURE PLP$ACTUALIZAR_HLD_GGE_GASTOS_GESTION IS

  BEGIN

      -- 	
      -- DD_EAH_CODIGO Busca el valor que debe actualizar:
    IF ( DD_EAH_CODIGO IS NOT NULL ) THEN

    	V_SQL := ' SELECT DD_EAH_ID FROM  ' || V_ESQUEMA || '.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''' || DD_EAH_CODIGO || ''' ';
    	EXECUTE IMMEDIATE V_SQL INTO V_DD_EAH_ID;
    ELSE
	V_DD_EAH_ID := 0;
    END IF;

      -- 	
      -- DD_EAP_CODIGO Busca el valor que debe actualizar:
    IF ( DD_EAP_CODIGO IS NOT NULL ) THEN

    	V_SQL := ' SELECT DD_EAP_ID FROM  ' || V_ESQUEMA || '.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = ''' || DD_EAP_CODIGO || ''' ';
    	EXECUTE IMMEDIATE V_SQL INTO V_DD_EAP_ID;
    ELSE
	V_DD_EAP_ID := 0;
    END IF;

     -- Busca las provisiones que actualizará y crea registro en HLD:
    V_SQL :=
    ' SELECT DISTINCT GGE_ID, DD_EAP_ID, DD_EAH_ID, GGE_FECHA_EAH, GGE_FECHA_EAP, 
	     	      GGE_FECHA_ENVIO_PRPTRIO, GGE_MOTIVO_RECHAZO_PROP, GPV_NUM_GASTO_HAYA
      FROM REM01.GPV_GASTOS_PROVEEDOR GPV
      JOIN ' || V_ESQUEMA || '.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
      WHERE GPV.GPV_NUM_GASTO_HAYA IN (  ' || GPV_NUM_GASTO_HAYA || '  ) ' ;

      OPEN v_cursor FOR V_SQL;
   
      LOOP
            FETCH v_cursor INTO V_GGE_ID, V_DD_EAP_ID_ORI, V_DD_EAH_ID_ORI, V_GGE_FECHA_EAH, V_GGE_FECHA_EAP,
				    V_GGE_FECHA_ENVIO_PRPTRIO, V_GGE_MOTIVO_RECHAZO_PROP, V_GPV_NUM_GASTO_HAYA ;
            EXIT WHEN v_cursor%NOTFOUND;

		-- Actualiza DD_EAP ?
		IF ( UPDATE_DD_EAP = 1 ) THEN

      		 PLP$CREAR_REGISTRO_HLD(
			     	 	 V_GPV_NUM_GASTO_HAYA,
			      		 'GGE_GASTOS_GESTION',
			      		 'GGE_ID',
			      		 V_GGE_ID,
			      		 'DD_EAP_ID',
			      		 V_DD_EAP_ID_ORI,
			      		 V_DD_EAP_ID
			    	      );
		END IF;

		-- Actualiza DD_EAH ?
		IF ( UPDATE_DD_EAH = 1 ) THEN

      		 PLP$CREAR_REGISTRO_HLD(
			     	 	 V_GPV_NUM_GASTO_HAYA,
			      		 'GGE_GASTOS_GESTION',
			      		 'GGE_ID',
			      		 V_GGE_ID,
			      		 'DD_EAH_ID',
			      		 V_DD_EAH_ID_ORI,
			      		 V_DD_EAH_ID
			    	      );
		END IF;

		-- Actualiza FECHA_EAH ?
		IF ( UPDATE_FECHA_EAH = 1 ) THEN

      		 PLP$CREAR_REGISTRO_HLD(
			     	 	 V_GPV_NUM_GASTO_HAYA,
			      		 'GGE_GASTOS_GESTION',
			      		 'GGE_ID',
			      		 V_GGE_ID,
			      		 'GGE_FECHA_EAH',
			      		 V_GGE_FECHA_EAH,
			      		 GGE_FECHA_EAH
			    	      );
		END IF;

		-- Actualiza FECHA_EAP ?
		IF ( UPDATE_FECHA_EAP = 1 ) THEN

      		 PLP$CREAR_REGISTRO_HLD(
			     	 	 V_GPV_NUM_GASTO_HAYA,
			      		 'GGE_GASTOS_GESTION',
			      		 'GGE_ID',
			      		 V_GGE_ID,
			      		 'GGE_FECHA_EAP',
			      		 V_GGE_FECHA_EAP,
			      		 GGE_FECHA_EAP
			    	      );
		END IF;

		-- Actualiza FECHA_ENVIO_PRPTRIO ?
		IF ( UPDATE_FECHA_ENVIO_PRPTRIO = 1 ) THEN

      		 PLP$CREAR_REGISTRO_HLD(
			     	 	 V_GPV_NUM_GASTO_HAYA,
			      		 'GGE_GASTOS_GESTION',
			      		 'GGE_ID',
			      		 V_GGE_ID,
			      		 'GGE_FECHA_ENVIO_PRPTRIO',
			      		 V_GGE_FECHA_ENVIO_PRPTRIO,
			      		 GGE_FECHA_ENVIO_PRPTRIO
			    	      );
		END IF;

		-- Actualiza MOTIVO_RECHAZO_PROP ?
		IF ( UPDATE_MOTIVO_RECHAZO_PROP = 1 ) THEN

      		 PLP$CREAR_REGISTRO_HLD(
			     	 	 V_GPV_NUM_GASTO_HAYA,
			      		 'GGE_GASTOS_GESTION',
			      		 'GGE_ID',
			      		 V_GGE_ID,
			      		 'GGE_MOTIVO_RECHAZO_PROP',
			      		 V_GGE_MOTIVO_RECHAZO_PROP,
			      		 GGE_MOTIVO_RECHAZO_PROP
			    	      );
		END IF;

      END LOOP;

      CLOSE v_cursor;

  END;

 PROCEDURE PLP$ACTUALIZAR_HLD_GDE_GASTOS_DETALLE_ECONOMICO IS

  BEGIN

     -- Busca las provisiones que actualizará y crea registro en HLD:
    V_SQL :=
    ' SELECT DISTINCT GDE_ID, GDE_IMP_IND_TIPO_IMPOSITIVO, GPV_NUM_GASTO_HAYA
      FROM REM01.GPV_GASTOS_PROVEEDOR GPV
      JOIN ' || V_ESQUEMA || '.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
      WHERE GPV.GPV_NUM_GASTO_HAYA IN (  ' || GPV_NUM_GASTO_HAYA || '  ) ' ;

      OPEN v_cursor FOR V_SQL;
   
      LOOP
            FETCH v_cursor INTO V_GDE_ID, V_GDE_IMP_IND_TIPO_IMPOSITIVO, V_GPV_NUM_GASTO_HAYA ;
            EXIT WHEN v_cursor%NOTFOUND;

      		 PLP$CREAR_REGISTRO_HLD(
			     	 	 V_GPV_NUM_GASTO_HAYA,
			      		 'GDE_GASTOS_DETALLE_ECONOMICO',
			      		 'GDE_ID',
			      		 V_GDE_ID,
			      		 'GDE_IMP_IND_TIPO_IMPOSITIVO',
			      		 V_GDE_IMP_IND_TIPO_IMPOSITIVO,
			      		 GDE_IMP_IND_TIPO_IMPOSITIVO
			    	      );

      END LOOP;

      CLOSE v_cursor;

  END;

 PROCEDURE PLP$ACTUALIZAR_HLD_GPV_GASTOS_PROVEEDOR IS

  BEGIN

      -- 	
      -- DD_EGA_CODIGO Busca el valor que debe actualizar:
    IF ( DD_EGA_CODIGO IS NOT NULL ) THEN

    	V_SQL := ' SELECT DD_EGA_ID FROM  ' || V_ESQUEMA || '.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''' || DD_EGA_CODIGO || ''' ';
    	EXECUTE IMMEDIATE V_SQL INTO V_DD_EGA_ID;
    ELSE
	V_DD_EGA_ID := 'NULL';
    END IF;

     -- Busca las provisiones que actualizará y crea registro en HLD:
    V_SQL :=
    ' SELECT DISTINCT GPV_ID, GPV_NUM_GASTO_HAYA, PRG_ID, DD_EGA_ID, GPV_EXISTE_DOCUMENTO
      FROM REM01.GPV_GASTOS_PROVEEDOR GPV
      WHERE GPV.GPV_NUM_GASTO_HAYA IN (  ' || GPV_NUM_GASTO_HAYA || '  ) ' ;

      OPEN v_cursor FOR V_SQL;
   
      LOOP
            FETCH v_cursor INTO V_GPV_ID, V_GPV_NUM_GASTO_HAYA, V_PRG_ID, V_DD_EGA_ID_ORI, V_GPV_EXISTE_DOCUMENTO ;
            EXIT WHEN v_cursor%NOTFOUND;

		-- Actualiza DD_EGA ?
		IF ( UPDATE_DD_EGA = 1 ) THEN

      		 PLP$CREAR_REGISTRO_HLD(
			     	 	 V_GPV_NUM_GASTO_HAYA,
			      		 'GPV_GASTOS_PROVEEDOR',
			      		 'GPV_ID',
			      		 V_GPV_ID,
			      		 'DD_EGA_ID',
			      		 V_DD_EGA_ID_ORI,
			      		 V_DD_EGA_ID
			    	      );
		END IF;

		-- Actualiza PRG_ID ?
		IF ( UPDATE_PRG_ID = 1 ) THEN

      		 PLP$CREAR_REGISTRO_HLD(
			     	 	 V_GPV_NUM_GASTO_HAYA,
			      		 'GPV_GASTOS_PROVEEDOR',
			      		 'GPV_ID',
			      		 V_GPV_ID,
			      		 'DD_EGA_ID',
			      		 V_PRG_ID,
			      		 PRG_ID
			    	      );

		END IF;

		-- Actualiza GPV_EXISTE_DOCUMENTO ?
		IF ( UPDATE_EXISTE_DOCUMENTO = 1 ) THEN

      		 PLP$CREAR_REGISTRO_HLD(
			     	 	 V_GPV_NUM_GASTO_HAYA,
			      		 'GPV_GASTOS_PROVEEDOR',
			      		 'GPV_ID',
			      		 V_GPV_ID,
			      		 'GPV_EXISTE_DOCUMENTO',
			      		 V_GPV_EXISTE_DOCUMENTO,
			      		 GPV_EXISTE_DOCUMENTO
			    	      );
		END IF;

      END LOOP;

      CLOSE v_cursor;

  END;

BEGIN


    COD_RETORNO := 0;

    --Actualiza GGE_GASTOS_GESTION ? :
 IF ( ACT_GGE_GESTION_GASTOS = 1 ) THEN	

        PLP$ACTUALIZAR_HLD_GGE_GASTOS_GESTION;

	V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.GGE_GASTOS_GESTION T1 USING
    (
        SELECT GPV.GPV_ID
        FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV
        JOIN ' || V_ESQUEMA || '.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
        WHERE GPV.GPV_NUM_GASTO_HAYA IN (  ' || GPV_NUM_GASTO_HAYA || '  )

    )T2 ON (T1.GPV_ID = T2.GPV_ID)
    WHEN MATCHED THEN
    UPDATE
    SET ' || CASE WHEN ( ( DD_EAH_CODIGO IS NOT NULL ) AND ( UPDATE_DD_EAH = 1 ) ) THEN ' T1.DD_EAH_ID = (SELECT DD_EAH_ID FROM  ' || V_ESQUEMA || '.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''' || DD_EAH_CODIGO || '''), ' END 
	  || CASE WHEN ( ( DD_EAH_CODIGO IS NULL ) AND ( UPDATE_DD_EAH = 1 ) ) THEN ' T1.DD_EAH_ID = NULL , ' END 

          || CASE WHEN ( ( GGE_FECHA_EAH IS NOT NULL ) AND ( UPDATE_FECHA_EAH = 1 ) ) THEN ' T1.GGE_FECHA_EAH = ''' || GGE_FECHA_EAH || ''', ' END
          || CASE WHEN ( ( GGE_FECHA_EAH IS NULL ) AND ( UPDATE_FECHA_EAH = 1 ) ) THEN ' T1.GGE_FECHA_EAH = NULL, ' END

          || CASE WHEN ( ( DD_EAP_CODIGO IS NOT NULL ) AND ( UPDATE_DD_EAP = 1 ) ) THEN ' T1.DD_EAP_ID = (SELECT DD_EAP_ID FROM  ' || V_ESQUEMA || '.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = ''' || DD_EAP_CODIGO || '''), ' END
          || CASE WHEN ( ( DD_EAP_CODIGO IS NULL ) AND ( UPDATE_DD_EAP = 1 ) ) THEN ' T1.DD_EAP_ID = NULL, ' END

          || CASE WHEN ( ( GGE_FECHA_EAP IS NOT NULL ) AND ( UPDATE_FECHA_EAP = 1 ) ) THEN ' T1.GGE_FECHA_EAP = ''' || GGE_FECHA_EAP || ''',' END
          || CASE WHEN ( ( GGE_FECHA_EAP IS NULL ) AND ( UPDATE_FECHA_EAP = 1 ) ) THEN ' T1.GGE_FECHA_EAP = NULL,' END

          || CASE WHEN ( ( GGE_FECHA_ENVIO_PRPTRIO IS NOT NULL ) AND ( UPDATE_FECHA_ENVIO_PRPTRIO = 1 ) ) THEN ' T1.GGE_FECHA_ENVIO_PRPTRIO = ''' || GGE_FECHA_ENVIO_PRPTRIO || ''', ' END 
          || CASE WHEN ( ( GGE_FECHA_ENVIO_PRPTRIO IS NULL ) AND ( UPDATE_FECHA_ENVIO_PRPTRIO = 1 ) ) THEN ' T1.GGE_FECHA_ENVIO_PRPTRIO = NULL, ' END 

          || CASE WHEN ( ( GGE_MOTIVO_RECHAZO_PROP IS NOT NULL ) AND ( UPDATE_MOTIVO_RECHAZO_PROP = 1 ) ) THEN ' T1.GGE_MOTIVO_RECHAZO_PROP = ''' || SUBSTR( GGE_MOTIVO_RECHAZO_PROP, 1, 512 ) || ''', ' END 
          || CASE WHEN ( ( GGE_MOTIVO_RECHAZO_PROP IS NULL ) AND ( UPDATE_MOTIVO_RECHAZO_PROP = 1 ) ) THEN ' T1.GGE_MOTIVO_RECHAZO_PROP = NULL, ' END 

          || ' T1.USUARIOMODIFICAR = ''' || V_USUARIO || ''', '
          || ' T1.FECHAMODIFICAR = SYSDATE ' ;  

        EXECUTE IMMEDIATE V_SQL;
       DBMS_OUTPUT.PUT_LINE('[INFO] - Modificados '||SQL%ROWCOUNT||' registro/s en la GGE_GASTOS_GESTION.');
END IF;


    --Actualiza GDE_GASTOS_DETALLE_ECONOMICO ? :

 IF ( ACT_GDE_GASTOS_DETALLE_ECONOMICO = 1 ) THEN

        PLP$ACTUALIZAR_HLD_GDE_GASTOS_DETALLE_ECONOMICO;

	V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.GDE_GASTOS_DETALLE_ECONOMICO T1 USING
    (
        SELECT GPV.GPV_ID
        FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV
        JOIN ' || V_ESQUEMA || '.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
        WHERE GPV.GPV_NUM_GASTO_HAYA IN (  ' || GPV_NUM_GASTO_HAYA || '  )

    )T2 ON (T1.GPV_ID = T2.GPV_ID)
    WHEN MATCHED THEN
    UPDATE
    SET ' || CASE WHEN ( ( GDE_IMP_IND_TIPO_IMPOSITIVO IS NOT NULL ) AND ( UPDATE_IMP_IND_TIPO_IMPOSITIVO = 1 ) ) THEN ' T1.GDE_IMP_IND_TIPO_IMPOSITIVO = ' || GDE_IMP_IND_TIPO_IMPOSITIVO || ', ' END 
	  || CASE WHEN ( ( GDE_IMP_IND_TIPO_IMPOSITIVO IS NULL ) AND ( UPDATE_IMP_IND_TIPO_IMPOSITIVO = 1 ) ) THEN ' T1.GDE_IMP_IND_TIPO_IMPOSITIVO = NULL , ' END 

          || ' T1.USUARIOMODIFICAR = ''' || V_USUARIO || ''', '
          || ' T1.FECHAMODIFICAR = SYSDATE ' ;  

        EXECUTE IMMEDIATE V_SQL;
       DBMS_OUTPUT.PUT_LINE('[INFO] - Modificados '||SQL%ROWCOUNT||' registro/s en la GDE_GASTOS_DETALLE_ECONOMICO.');
END IF;

    --Actualiza GPV_GASTOS_PROVEEDOR ?: 	
 IF ( ACT_GPV_GASTOS_PROVEEDOR = 1 ) THEN

        PLP$ACTUALIZAR_HLD_GPV_GASTOS_PROVEEDOR;

	V_SQL := '
	MERGE INTO ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR T1 USING
    (
        SELECT GPV.GPV_ID
        FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV
        JOIN ' || V_ESQUEMA || '.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
        WHERE GPV.GPV_NUM_GASTO_HAYA IN (  ' || GPV_NUM_GASTO_HAYA || '  )

    )T2 ON (T1.GPV_ID = T2.GPV_ID) 
    WHEN MATCHED THEN
        UPDATE
        SET ' || CASE WHEN ( ( DD_EGA_CODIGO IS NOT NULL ) AND ( UPDATE_DD_EGA = 1 ) ) THEN ' T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM  ' || V_ESQUEMA || '.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''' || DD_EGA_CODIGO || '''), ' END
	      || CASE WHEN ( ( DD_EGA_CODIGO IS NULL ) AND ( UPDATE_DD_EGA = 1 ) ) THEN ' T1.DD_EGA_ID = NULL, ' END

              || CASE WHEN ( ( PRG_ID IS NOT NULL ) AND ( UPDATE_PRG_ID = 1 ) ) THEN  'T1.PRG_ID = ' || PRG_ID || ', ' END
              || CASE WHEN ( ( PRG_ID IS NULL ) AND ( UPDATE_PRG_ID = 1 ) ) THEN  'T1.PRG_ID = NULL, ' END

              || CASE WHEN ( ( GPV_EXISTE_DOCUMENTO IS NOT NULL ) AND ( UPDATE_EXISTE_DOCUMENTO = 1 ) ) THEN  'T1.GPV_EXISTE_DOCUMENTO = ' || GPV_EXISTE_DOCUMENTO || ', ' END
              || CASE WHEN ( ( GPV_EXISTE_DOCUMENTO IS NULL ) AND ( UPDATE_EXISTE_DOCUMENTO = 1 ) ) THEN  'T1.GPV_EXISTE_DOCUMENTO = NULL, ' END

    	      || ' T1.USUARIOMODIFICAR = ''' || V_USUARIO || ''', '
              || ' T1.FECHAMODIFICAR = SYSDATE' ; 

        EXECUTE IMMEDIATE V_SQL;


       DBMS_OUTPUT.PUT_LINE('[INFO] - Modificado/s '||SQL%ROWCOUNT||' registro/s en la GPV_GASTOS_PROVEEDOR.');

       DBMS_OUTPUT.PUT_LINE('[INFO] - Modificado/s ' ||SQL%ROWCOUNT||' gasto/s.');

END IF;

   PLP$CREAR_REGISTRO_OK( ' Cambiado estado en gastos ' );	

   COMMIT;

       COD_RETORNO := 1;


EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ERR_NUM := SQLCODE;
      PLP$CREAR_REGISTRO_ERROR( 'ERROR ' || ERR_NUM );	
      RAISE;
END SP_EXT_MODIFICACION_ESTADOS;
/
EXIT
